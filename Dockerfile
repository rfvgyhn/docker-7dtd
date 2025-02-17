FROM cm2network/steamcmd:steam AS build
ARG VERSION
ARG INSTALL_ARGS
RUN set -x \
	&& "${STEAMCMDDIR}/steamcmd.sh" \
		+force_install_dir /home/steam/7dtd \
		+login anonymous \
		+app_update 294420$INSTALL_ARGS validate \
		+quit
WORKDIR /home/steam/7dtd
RUN rm -r steamapps

FROM debian:stable-slim

RUN set -x \
    && useradd -m steam \
    && mkdir -p /home/steam/.local/share/7DaysToDie

WORKDIR /home/steam/7dtd
COPY --from=build --chown=steam /home/steam/7dtd .
ADD 7dtd-* /usr/local/bin/
RUN chmod +x /usr/local/bin/7dtd-*

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
      ca-certificates netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

USER steam
VOLUME /home/steam/7dtd/Mods
VOLUME /home/steam/.local/share/7DaysToDie

EXPOSE 26900/tcp
EXPOSE 8081/tcp
EXPOSE 26900-26903/udp

ENV CONFIG_FILE=/home/steam/.local/share/7DaysToDie/serverconfig.xml
ENV LD_LIBRARY_PATH="/home/steam/7dtd"
HEALTHCHECK CMD [ "7dtd-status" ]

ENTRYPOINT ["7dtd-server"]

