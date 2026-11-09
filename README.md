# Me — Workspace "Linux Desktop no Navegador"

Backup organizado do workspace (exportado do Arena) com o objetivo de **hospedar
um desktop Linux acessível pelo navegador**, para ser usado num **Chromebook da
escola** e em outros dispositivos.

## Contexto

- Origem: export de workspace do Arena → `workspace-01a1bff3-886b-7cef-bb99-2f8e50b460f0.zip`
  (149 MB, guardado no Google Drive do usuário como backup bruto).
- Problema original: o Arena servia o desktop, mas tem limite de uso e fechou o
  acesso → necessidade de hospedagem própria (plano: **Render**).
- O arquivo bruto (149 MB) **não vai para o git** (acima do limite do GitHub).
  O repositório guarda o **projeto**: Dockerfile, código, configs e documentação.

## Status atual (2026-11-09)

- [x] Repositório identificado e preparado (.gitignore).
- [x] Backup bruto localizado no Google Drive (não cabe no git/GitHub; fica no Drive).
- [ ] Extrair o projeto do zip e re-enviar **somente a pasta do projeto** (sem caches)
      para o Drive → o agente lê os textos pelo conector e monta o repo.
- [ ] Definir Dockerfile/compose definitivo + `render.yaml`.
- [x] Desktop web pronto e hospedável (Dockerfile: XFCE + Epiphany + noVNC, enxuto para 1 GB RAM) — veja `docs/RAILWAY.md` e opte por Railway (conectado) ou Render.
- [ ] Deploy no Railway/Render (o usuário conecta a conta GitHub↔provedor).
- [ ] Tornar o repositório **PRIVADO** no GitHub (Settings → Danger Zone → Change visibility).
      O token do agente não tem permissão de admin para fazer isso.

## Hospedagem planejada (Render)

Railway/Render rodam containers Docker como *web services*. Para um desktop Linux no
navegador, as rotas comuns:

1. Imagem estilo `linuxserver/webtop` (Ubuntu + XFCE/KDE + noVNC na porta 3001)
   — portável para Render com alguns ajustes.
2. Dockerfile próprio com Xvfb + noVNC/websockify + um desktop leve (XFCE),
   escutando na porta informada por `$PORT` (Render injeta a porta; padrão 10000).

Limitações reais do plano **Free** do Render:

- 512 MB de RAM (um desktop completo fica apertado — XFCE é o mínimo viável;
  KDE/GNOME não).
- Serviço dorme após ~15 min sem tráfego; primeiro acesso depois disso tem
  **cold start** lento (dezenas de segundos).
- Sem disco persistente no free → dados em `$HOME` se perdem a cada redeploy
  (a menos que se use um serviço pago com disk ou storage externo).

Acesso: qualquer navegador (Chromebook da escola) via URL HTTPS do Render.
**Proteja com senha forte** na imagem (o webtop expõe tela de login) ou com
auxílio de um proxy de autenticação.

## Segurança / O que NÃO vai para o git

- `.env`, tokens, chaves, senhas (use variáveis de ambiente no Render).
- ROMs, APKs/XAPKs, ISOs, zips, caches de navegador, `node_modules/`.
- O backup bruto do workspace fica **só no Drive**.
- ⚠️ O Drive do usuário contém arquivos piratas (ROMs/APKs). Eles **não fazem
  parte** deste projeto e não devem ser copiados para cá.
- ⚠️ `.github/workflows/main.yml` ("RDP em Windows via GitHub Actions + Tailscale")
  mantém um runner do GitHub como máquina de uso pessoal por tempo indefinido, o
  que viola os Termos do GitHub. Recomendado remover/desativar e usar o caminho
  Render descrito aqui. Ainda não foi alterado (decisão do dono do repositório).

## Próximos passos

1. Dono extrai o zip no próprio PC e remove: `node_modules/`, `.cache/`,
   perfis de navegador, ROMs/APKs, arquivos > 100 MB.
2. Re-envia a pasta **do projeto** para o Drive (ou empurra direto via git).
3. Agente monta a estrutura no repo (Dockerfile + render.yaml + docs).
4. Deploy no Render via painel (conectando este repositório) e teste no Chromebook.
