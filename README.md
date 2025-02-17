# 7 Days to Die Docker

[7 Days to Die][0] dedicated server

Branch | Size             | Version          
-------|------------------|---------------
latest | [![Size][3]][1]  | [![Version][4]][1]

## Usage

### Volumes

* `/home/steam/.local/share/7DaysToDie` mount for save game data and config
* `/home/steam/7dtd/Mods` mount for mods

```
docker run -d \
  --name 7dtd \
  --ulimit nofile=10240 \
  -v /opt/7dtd/data:/home/steam/.local/share/7DaysToDie \
  -p 8081:8081/tcp \
  -p 26900-26903:26900-26903/udp \
  -p 26900:26900/tcp \
   ghcr.io/rfvgyhn/7dtd
```

Note that the container runs as non-root user 1000:1000. Make sure your mounted volume(s) have the correct permissions. (When running Docker in rootless mode, the user is remapped to a different id, usually 100999:100999)


## Docker Images

The `latest` tag will follow the latest 7 Days to Die server release.

You can specify a specific version using the available [tags][2]


[0]: https://www.7daystodie.com/
[1]: https://github.com/rfvgyhn/docker-7dtd/pkgs/container/7dtd
[2]: https://github.com/rfvgyhn/docker-7dtd/pkgs/container/7dtd/versions?filters%5Bversion_type%5D=tagged
[3]: https://ghcr-badge.egpl.dev/rfvgyhn/7dtd/size?color=%231082c2&tag=latest
[4]: https://img.shields.io/badge/v-1.3--b9-blue
