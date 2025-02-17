FROM cm2network/steamcmd:steam as build
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
LABEL org.opencontainers.image.title="7 Days to Die Dedicated Server"
LABEL org.opencontainers.image.url="https://7daystodie.com/"

WORKDIR /home/steam/7dtd
COPY --from=build --chown=steam /home/steam/7dtd .
ADD 7dtd-* /usr/local/bin/
RUN chmod +x /usr/local/bin/7dtd-*

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
      netcat-traditional \
    && rm -rf /var/lib/apt/lists/*
RUN set -x \
    && useradd -m steam \
    && chown -R steam:steam /home/steam \
    && mkdir -p /home/steam/.local/share/7DaysToDie

USER steam
VOLUME /home/steam/7dtd/Mods
VOLUME /home/steam/.local/share/7DaysToDie

EXPOSE 26900/tcp
EXPOSE 8081/tcp
EXPOSE 26900-26903/udp

ENV CONFIG_FILE=/home/steam/.local/share/7DaysToDie/serverconfig.xml
HEALTHCHECK CMD [ "7dtd-status" ]

ENTRYPOINT ["7dtd-server"]

