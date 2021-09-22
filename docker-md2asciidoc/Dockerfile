# use a minimum debian as a base
FROM debian:stable-slim
LABEL MAINTAINER Sean Donnellan <docker@donnellan.de>
    # container to convert markdow to asciidoc
        WORKDIR /opt/app
        RUN apt-get update \
            && apt-get install -y --no-install-recommends \
                aptitude \
            && rm -rf /var/lib/apt/lists/* \
            && mkdir -p /root/.local/share /.local/share
        COPY . .
