FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Desktop leve (XFCE) + VNC + noVNC (web) + extras
RUN apt-get update && apt-get install -y --no-install-recommends \
        xfce4 xfce4-terminal xfce4-whiskermenu-plugin xfce4-taskmanager \
        tigervnc-standalone-server novnc websockify \
        firefox-esr xterm \
        git curl wget ca-certificates sudo procps net-tools unzip bzip2 \
        fonts-dejavu fonts-liberation \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Usuario nao-root para a sessao do desktop
RUN groupadd -g 1000 user \
    && useradd -m -u 1000 -g 1000 -s /bin/bash user \
    && echo 'user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/user

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Railway injeta PORT; no desktop local usa-se 8080
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
