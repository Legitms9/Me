# Opção C — GitHub Codespaces (grátis, uso ocasional)

Alternativa ao Railway com **muito mais RAM (8 GB)** e custo zero dentro da cota,
mas **não é 24/7**: o Codespace desliga sozinho por inatividade (padrão 30 min)
e a cota grátis é de ~120 core-horas/mês (≈60 h num codespace de 2 núcleos).

## Passo a passo

1. No repositório `Legitms9/Me`, clique em **Code** → aba **Codespaces** →
   **Create codespace on arena/607934d8-me** (ou `main` depois de mesclar o PR #1).
2. Aguarde o build do devcontainer (usa o mesmo `Dockerfile` — XFCE + noVNC).
3. Quando abrir o VS Code na web, vá na aba **Ports** (ou **Terminal**): o
   processo do desktop sobe sozinho via `postStartCommand`. O log fica em
   `/tmp/desktop.log` (`cat /tmp/desktop.log` para ver a senha gerada, se não
   definiu `VNC_PASSWORD`).
4. Na porta **8080**, clique com o botão direito → **Port Visibility → Public**
   (necessário para o Chromebook abrir sem login do GitHub).
5. Abra a URL pública no formato
   `https://<nome-do-codespace>-8080.app.github.dev/vnc.html`
   → digite a senha do VNC → **Connect**.

## Avisos

- Para fixar a senha do desktop, crie um **Codespaces secret** chamado
  `VNC_PASSWORD` em https://github.com/settings/codespaces (ou defina no
  `devcontainer.json` → `"remoteEnv": { "VNC_PASSWORD": "..." }` — não faça isso
  se o repo for público).
- O Codespace é **efêmero**: feche/apague quando terminar (`Stop codespace`)
  para não consumir a cota.
- Nada disso substitui uma hospedagem permanente: Railway (pago/Trial),
  Render (512 MB free) ou Oracle Cloud Free (VPS grátis) continuam sendo as
  opções para 24/7.
