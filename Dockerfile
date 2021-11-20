FROM python:slim-buster
ENV LANG=C.UTF-8 \
      DPATH=/usr/local/bin \
      TZ=Asia/Shanghai \
      DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
      && apt-get install -y  wget unzip curl ssh npm screen vim tzdata sudo \
      && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
      && echo ${TZ} > /etc/timezone \
      && dpkg-reconfigure --frontend noninteractive tzdata \
      && curl -o /root https://raw.githubusercontent.com/lovezzzxxx/liverecord/master/install.sh | bash \
      && rm -rf /var/lib/apt/lists/* \
      #&& ssh-keygen -A \
      && npm install -g wstunnel \
      && npm cache clean -f \
      && sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config \
      && mkdir -p /root/.config/rclone /root/temp /run/sshd \
      && echo root:uncleluo|chpasswd \
      && echo 'wstunnel -s 0.0.0.0:443 &' >>/start.sh \
      && echo '/usr/sbin/sshd -D' >>/start.sh \
      && chmod a+x /start.sh
EXPOSE 443
WORKDIR /root
CMD  /start.sh
