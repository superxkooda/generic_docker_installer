FROM debian:buster-slim as builder

# Install deps
RUN apt-get update && \
    apt-get install -y curl unzip

# Downloading zork
RUN mkdir /zork && cd /zork && \
    curl http://infocom-if.org/downloads/zork1.zip --output zork.zip && \
    unzip zork.zip && rm zork.zip

FROM debian:buster-slim

# Install frotz
RUN apt-get update && \
    apt-get install -y frotz && \
    apt-get -y clean && apt-get -y  autoremove

# Creating a nonroot user
RUN useradd -s /bin/bash -m frotz

COPY --from=builder --chown=frotz:frotz /zork /home/frotz/zork

USER frotz

WORKDIR /home/frotz/zork

ENTRYPOINT ["/usr/games/frotz", "DATA/ZORK1.DAT"] 
