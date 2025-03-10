FROM ubuntu:25.04

RUN apt update \
    && apt install -y bash sudo ca-certificates curl nano wget net-tools iputils-ping \
    iptables supervisor git openssh-server \
    && rm -rf /var/lib/apt/list/*

ENV DOCKER_CHANNEL=stable \
	DOCKER_VERSION=28.0.1 \
	DOCKER_COMPOSE_VERSION=v2.33.1 \
	BUILDX_VERSION=v0.21.2 \
	DEBUG=false

ENV ROOT_PWD=''
ENV ROOT_SSH_PUBLIC_KEY=''
ENV CUSTOM_SOFTWARES=''
ENV SOFTWARES=''



# Docker and buildx installation
RUN set -eux; \
	\
	arch="$(uname -m)"; \
	case "$arch" in \
        # amd64
		x86_64) dockerArch='x86_64' ; buildx_arch='linux-amd64' ;; \
        # arm32v6
		armhf) dockerArch='armel' ; buildx_arch='linux-arm-v6' ;; \
        # arm32v7
		armv7) dockerArch='armhf' ; buildx_arch='linux-arm-v7' ;; \
        # arm64v8
		aarch64) dockerArch='aarch64' ; buildx_arch='linux-arm64' ;; \
		*) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;;\
	esac; \
	\
	if ! wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
		echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
		exit 1; \
	fi; \
	\
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	if ! wget -O docker-buildx "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.${buildx_arch}"; then \
		echo >&2 "error: failed to download 'buildx-${BUILDX_VERSION}.${buildx_arch}'"; \
		exit 1; \
	fi; \
	mkdir -p /usr/local/lib/docker/cli-plugins; \
	chmod +x docker-buildx; \
	mv docker-buildx /usr/local/lib/docker/cli-plugins/docker-buildx; \
	\
	dockerd --version; \
	docker --version; \
	docker buildx version


COPY utils/modprobe utils/start-docker.sh entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/modprobe /usr/local/bin/start-docker.sh /usr/local/bin/entrypoint.sh

COPY utils/supervisor/ /etc/supervisor/conf.d/

COPY utils/logger.sh /opt/bash-utils/logger.sh
RUN chmod +x /opt/bash-utils/logger.sh

COPY cloudinit/init.sh /cloudinit/init.sh
RUN chmod +x /cloudinit/init.sh

COPY cloudinit/apps/ /cloudinit/apps/
RUN chmod +x /cloudinit/apps/*.sh

VOLUME /var/lib/docker


# Docker compose installation
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose && docker-compose version
# RUN ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/bin/bash"]