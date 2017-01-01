# Teamspeak3 (Alpine Linux) Docker Image <br>[![Docker Automated Build](https://img.shields.io/docker/automated/rodaine/teamspeak3-alpine.svg)](https://hub.docker.com/r/rodaine/teamspeak3-alpine/)

_A Teamspeak 3 Server built on Alpine Linux (using glibc)_

* Teamspeak3 v3.0.13.6 (8 Nov 2016)
* Lightweight image (<25MB)
* SQLite only
* Easy, optional voluming of logs, db, and query_ip_*list.txt files
* Pass any TS3 startup flags with `docker run`

### Quickstart

Boot up the server exposing just the main voice port (9987/udp). ServerQuery and 
other features are only accessible via `docker exec`. DB, logs, and other files
are not preserved with this container, but this method is a quick way to spin up
a server quickly.

```sh
docker run -d \
	-p 9987:9987/udp \
	rodaine/teamspeak3-alpine
```

The other ports (10011 for ServerQuery and 30033 for FileManager) can be exposed
individually as well in this manner, or all ports can be exposed with `-P`, 
however the host ports will be random.

### Data Volume

Providing a volume at `/data` in the container will automatically link and use 
these files and directories. A container can then be booted again later and use
this existing data (read: making updates very easy!). The currently supported 
files are:

* `logs/` (directory)
* query_ip_blacklist.txt
* query_ip_whitelist.txt
* ts3server.sqlitedb

```sh
docker run -d \
	-p 9987:9987/udp \
	-v $PWD/my_data:/data \
	rodaine/teamspeak3-alpine
```

### TS3 Startup Flags

TS3 permits a bunch of flags at startup to customize the behavior of the server.
These can be provided directly in the `docker run` statement, after the image 
name:

```sh
docker run -d \
	-p 9987:9987/udp \
	-v $PWD/my_data:/data \
	rodaine/teamspeak3-alpine \
	inifile=/data/ts3server.ini
```

Refer to the documentation included in your TS3 Server release for all the 
available flags.