#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

CONTAINER_IMAGE="${README_TESTER_IMAGE:-asciidoctor/docker-asciidoctor}"
REQUESTED_RUNTIME="${README_TESTER_RUNTIME:-}"
RUNTIME_CMD_OVERRIDE="${README_TESTER_RUNTIME_CMD:-}"

usage() {
  cat <<'EOF'
Usage: ./README-tester.sh [options]

Options:
  -r, --runtime <podman|docker>   Explicitly choose the container runtime
  -h, --help                      Show this help message

Environment overrides:
  README_TESTER_RUNTIME           Same as --runtime
  README_TESTER_RUNTIME_CMD       Full runtime command (e.g. "flatpak-spawn --host podman")
  README_TESTER_IMAGE             Alternate Asciidoctor container image
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--runtime)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        usage
        exit 1
      fi
      REQUESTED_RUNTIME="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

CONTAINER_RUNTIME_CMD=()

resolve_runtime() {
  if [[ -n "$RUNTIME_CMD_OVERRIDE" ]]; then
    # Allow multi-word commands (e.g., flatpak-spawn --host podman)
    read -r -a CONTAINER_RUNTIME_CMD <<< "$RUNTIME_CMD_OVERRIDE"
  elif [[ -n "$REQUESTED_RUNTIME" ]]; then
    CONTAINER_RUNTIME_CMD=("$REQUESTED_RUNTIME")
  else
    local candidates=(podman docker)
    for candidate in "${candidates[@]}"; do
      if command -v "$candidate" >/dev/null 2>&1; then
        CONTAINER_RUNTIME_CMD=("$candidate")
        break
      fi
    done
  fi

  if [[ ${#CONTAINER_RUNTIME_CMD[@]} -eq 0 ]]; then
    echo "No container runtime available. Install podman or docker, or set README_TESTER_RUNTIME_CMD." >&2
    exit 1
  fi

  if ! command -v "${CONTAINER_RUNTIME_CMD[0]}" >/dev/null 2>&1; then
    echo "Container runtime command not found: ${CONTAINER_RUNTIME_CMD[0]}" >&2
    exit 1
  fi
}

resolve_runtime

echo "Testing HTML and PDF generation..."
echo "Using container runtime: ${CONTAINER_RUNTIME_CMD[*]}"
echo "Using container image: ${CONTAINER_IMAGE}"

ROOT_DIR="${SCRIPT_DIR}"
DOCS_DIR="${ROOT_DIR}/docs"
CONTAINER_DOCS_DIR="/documents/docs"
mkdir -p "${DOCS_DIR}"

run_render() {
  local doc_path="$1"
  local engine="$2"
  local label="$3"

  local doc_dir="$(dirname "$doc_path")"
  local doc_dir_rel="${doc_dir#./}"
  local doc_file="$(basename "$doc_path")"
  local container_dir="/documents"

  if [[ -n "$doc_dir_rel" && "$doc_dir_rel" != "." ]]; then
    container_dir="${container_dir}/${doc_dir_rel}"
  fi

  local host_output_dir="${DOCS_DIR}"
  local container_output_dir="${CONTAINER_DOCS_DIR}"
  if [[ -n "$doc_dir_rel" && "$doc_dir_rel" != "." ]]; then
    host_output_dir="${DOCS_DIR}/${doc_dir_rel}"
    container_output_dir="${CONTAINER_DOCS_DIR}/${doc_dir_rel}"
  fi

  mkdir -p "${host_output_dir}"

  echo "Testing ${label} (${engine})..."
  local render_cmd="set -e; mkdir -p ${container_output_dir} && cd ${container_dir} && ${engine} -D ${container_output_dir} ${doc_file}"
  if ! output=$("${CONTAINER_RUNTIME_CMD[@]}" run -v "${ROOT_DIR}":/documents "${CONTAINER_IMAGE}" sh -c "${render_cmd}" 2>&1); then
    echo "$output"
    echo "${label} (${engine}) failed"
    exit 1
  fi
  echo "$output"
  if echo "$output" | grep -q WARNING; then
    echo "${label} (${engine}) emitted warnings"
    exit 1
  fi
}

discover_readmes() {
  local root_readme=""
  if [[ -f README.asciidoc ]]; then
    root_readme="README.asciidoc"
    printf '%s\n' "$root_readme"
  elif [[ -f README.adoc ]]; then
    root_readme="README.adoc"
    printf '%s\n' "$root_readme"
  fi

  local find_args=(. -type f \( -name 'README.adoc' -o -name 'README.asciidoc' \))
  if [[ -n "$root_readme" ]]; then
    find_args+=( ! -path "./${root_readme}" )
  fi

  find "${find_args[@]}" | sort
}

while IFS= read -r doc; do
  run_render "$doc" asciidoctor "$doc HTML"
  run_render "$doc" asciidoctor-pdf "$doc PDF"
done < <(discover_readmes)

echo "All tests passed!"