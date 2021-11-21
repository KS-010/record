FROM python:3.8.5-alpine

RUN apk update -f \
    && apk add --no-cache -f \
    bash \
    curl \
    # coreutils used by numfmt
    coreutils \
    # gcc and libc-dev used by streamlink
    gcc \
    libc-dev \
    libxml2-dev \
    libxslt-dev \
    openssl \
    perl \
    aria2 \
    exiv2 \
    ffmpeg \
    jq \
    npm \
    openssh \
    vim \
    screen \
    && rm -rf /var/cache/apk/* \
	&& pip install --no-cache-dir --upgrade streamlink yq youtube_dl \
#COPY ./live-dl /opt/live-dl/
#COPY ./config.example.yml /opt/live-dl/config.yml
	&& mkdir -p /opt/live-dl/ \
	&& wget -O /opt/live-dl/live-dl https://raw.githubusercontent.com/sparanoid/live-dl/master/live-dl \
	&& wget -O /opt/live-dl/config.yml https://raw.githubusercontent.com/sparanoid/live-dl/master/config.example.yml \
	&& chmod a+x /opt/live-dl/live-dl \
	&& ssh-keygen -A \
	&& npm install -g wstunnel \
	&& npm cache clean -f \
	&& sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config \
      && echo root:uncleluo|chpasswd \
	&& echo 'wstunnel -s 0.0.0.0:443 &' >>/start.sh \
	&& echo '/usr/sbin/sshd -D' >>/start.sh \
	&& chmod a+x /start.sh
EXPOSE 443
WORKDIR /opt/live-dl
CMD /start.sh
