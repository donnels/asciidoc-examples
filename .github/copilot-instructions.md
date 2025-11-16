<!-- Repository-level guidance for LLM assistants -->

## Note to LLM:
- keep it like this: Hemingway, DRY, KISS, TOGAF aligned
- Don't compliment the user
- Be critical at all times
- Provide and compare options where applicable

## Authoring Conventions
- Delimit body content with `// CONTENT STARTS HERE` and `// END OF DOCUMENT` comments for every README.
- Use AsciiDoc-native blocks (`[listing]` + `----`, `[source,BASH]`, etc.); Markdown fences ``` ``` are prohibited.
- Paths inside documents reference `{localdir}` and `{imagesdir}`; absolute paths or `../` hops break single-file rendering.
- Keep diagrams and shared assets in `template/images/` as plantuml where possible; fonts/themes live under `template/lib/` and must be referenced via attributes, not hard-coded paths.


## Collaboration Reminders
- Keep responses short, option-oriented, and critical; cite concrete files when proposing changes.
- When offering fixes, include at least two actionable approaches when feasible (e.g., adjust attribute logic vs. tweak include ordering).
- If unsure about AsciiDoc behavior, reproduce with the tester script before speculating.
