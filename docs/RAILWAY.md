# Hospedar no Railway (passo a passo)

O repositório já contém um desktop Linux navegável completo:
**XFCE + Firefox + noVNC servido por websockify** (`Dockerfile` na raiz).
O Railway detecta o Dockerfile automaticamente.

## 1. Deploy

1. Acesse https://railway.app → **New Project** → **Deploy from GitHub repo**.
2. Selecione `Legitms9/Me`.
3. Em **Settings → Source**, escolha a branch a implantar:
   - `arena/607934d8-me` (branch de trabalho), **ou**
   - `main` depois de mesclar o PR desta branch.
4. O Railway detecta o `Dockerfile` e inicia o build (primeira vez ~5–10 min;
   a imagem é grande — Debian + XFCE + Firefox).

## 2. Variáveis (Settings → Variables)

| Variável        | Obrigatória | Exemplo/Observação                          |
|-----------------|-------------|---------------------------------------------|
| `VNC_PASSWORD`  | recomendada | Senha de login no desktop (mín. 8 chars; VNC usa só os 8 primeiros) |
| `GEOMETRY`      | não         | `1280x720` (padrão) ou `1920x1080`          |

> Se `VNC_PASSWORD` não for definida, uma senha **aleatória** é gerada a cada
> deploy e impressa nos **Deploy Logs** (procure por "VNC_PASSWORD NAO definida").
> Sem ela, qualquer pessoa com a URL entra no seu desktop. **Defina sempre.**

## 3. URL pública (Settings → Networking)

1. Clique **Generate Domain** → você recebe `https://algo-xxxx.up.railway.app`.
2. Abra **`https://SEU-DOMINIO/vnc.html`** (a raiz `/` já redireciona para o
   cliente noVNC; se não, use `/vnc.html`).
3. No noVNC: cadastre/escreva a senha do VNC e clique **Connect**.

## 4. No Chromebook da escola

- Basta abrir a mesma URL no Chrome. Nenhuma instalação necessária.
- Chromebooks gerenciados (da escola) conseguem acessar URLs HTTPS comuns.
- ⚠️ A escola pode bloquear domínios/proxy — se a página não abrir, é bloqueio
  de rede do Chromebook, não do Railway.

## 5. Onde ficam / não ficam meus arquivos

- O container é **efêmero**: tudo o que você salvar no desktop se perde a cada
  redeploy (mas sobrevive a reinícios simples).
- Seus projetos: **coloque no repositório** (git) — é o jeito permanente.
- Para restaurar o export do Arena (`workspace-01a1bff3-…zip`, 149 MB): com o
  desktop aberto, abra o Firefox **dentro** do desktop, baixe o zip do seu
  Google Drive pelo navegador e extraia (`unzip`). Arquivos pesados ficam só
  na sessão/container; se quiser permanentes, anexe um **Volume** do Railway
  (Settings → Volumes, montado em `/home/user`) ou use o repo via git.

## 6. Custos e limites

- Railway é pago por uso (há crédito inicial de teste). Desktop 24/7 consome
  o crédito — monitore em **Usage**. Para reduzir custo: derrube o serviço
  (Settings → **Snooze**/"Remove deployment") quando não estiver usando.
- RAM: XFCE + Firefox cabem em ~1 GB; configure RAM no serviço se necessário.
- Alternativas: Render (512 MB free, dorme), Oracle Cloud Free Tier (VPS, mais
  robusto), Fly.io. Este mesmo repo serve em qualquer um deles.

## 7. Próximo passo

Mesclar o PR `arena/607934d8-me → main` (ou apontar o Railway para a branch),
gerando o domínio na etapa 3. Depois, trazer o **project folder** extraído do
zip do Drive para o repo (via upload no Drive + leitura pelo conector, ou git
push direto da sua máquina).
