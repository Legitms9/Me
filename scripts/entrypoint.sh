#!/bin/bash
set -e

PORT="${PORT:-8080}"
GEOMETRY="${GEOMETRY:-1280x720}"
VNC_PASSWORD="${VNC_PASSWORD:-}"

echo "==> Iniciando desktop Linux no navegador (porta ${PORT})"

# --- Senha do VNC (obrigatoria no uso publico) ---
if [ -z "$VNC_PASSWORD" ]; then
  VNC_PASSWORD=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 12)
  echo "============================================================"
  echo " AVISO: VNC_PASSWORD NAO definida no ambiente."
  echo " Senha gerada SOMENTE para esta execucao: ${VNC_PASSWORD}"
  echo " Defina a variavel VNC_PASSWORD no Railway (Variables)."
  echo "============================================================"
fi

# --- Prepara usuario e VNC ---
su -s /bin/bash user -c "mkdir -p ~/.vnc"
printf '%s' "$VNC_PASSWORD" | su -s /bin/bash user -c "vncpasswd -f > ~/.vnc/passwd"
su -s /bin/bash user -c "chmod 600 ~/.vnc/passwd"

cat > /home/user/.vnc/xstartup <<'XSTARTUP'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
XSTARTUP
chmod 755 /home/user/.vnc/xstartup
chown user:user /home/user/.vnc/xstartup

# --- (Re)inicia o servidor VNC na porta 5901 ---
su -s /bin/bash user -c "vncserver -kill :1 >/dev/null 2>&1 || true"
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 || true
su -s /bin/bash user -c "vncserver :1 -geometry ${GEOMETRY} -depth 24 -rfbport 5901 -SecurityTypes VncAuth"

echo "==> VNC ativo em :1 (5901) — expondo noVNC em 0.0.0.0:${PORT}"
exec websockify --web=/usr/share/novnc --heartbeat=60 0.0.0.0:"${PORT}" localhost:5901
