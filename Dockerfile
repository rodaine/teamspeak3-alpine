FROM frolvlad/alpine-glibc:alpine-3.4
MAINTAINER Chris Roche <docker@rodaine.com>

EXPOSE 9987/udp 10011 30033

ENV \
	TS_DIR="/opt/teamspeak" \
	TS_RELEASE="http://dl.4players.de/ts/releases/3.3.1/teamspeak3-server_linux_amd64-3.3.1.tar.bz2" \
	TS_SHA="b3891341a9ff4c4b6b0173ac57f1d64d4752550c95eeb26d2518ac2f5ca9fbc1" \
	TS_ARTIFACT="teamspeak.tar.bz2" \
	TS_DATA="/data"

RUN apk --update add tar ca-certificates \
	&& mkdir -p "${TS_DIR}" \
	&& wget "${TS_RELEASE}" -O "${TS_ARTIFACT}" \
	&& if [ $(sha256sum "${TS_ARTIFACT}" | cut -d" " -f 0) != $TS_SHA ]; then echo "CHECKSUM FAILED"; exit 1; fi \
	&& tar -xjf "${TS_ARTIFACT}" -C "${TS_DIR}" --strip-components=1 \
	&& rm "${TS_ARTIFACT}" "${TS_DIR}/CHANGELOG" "${TS_DIR}/libts3db_mariadb.so" \
	&& rm -r "${TS_DIR}/doc" "${TS_DIR}/redist" "${TS_DIR}/serverquerydocs" "${TS_DIR}/tsdns"

COPY data/ ${TS_DATA}
VOLUME ${TS_DATA}
RUN for file in $(find ${TS_DATA} -mindepth 1 -maxdepth 1); do \
	ln -s "${file}" $(echo $file | sed 's@^'"${TS_DATA}"'@'"${TS_DIR}"'@g') \
	; done

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
