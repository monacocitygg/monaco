# Hidden Anticheat

Sistema Avançado de Anti-Cheat para FiveM, projetado para detectar anomalias comportamentais e manipulação de memória.

## Funcionalidades

### Detecção de Movimento
- **Detecção de Speedhack**: Monitora a velocidade do jogador a pé e em veículos.
- **Detecção de Noclip / Voo**: Detecta mudanças anormais no eixo Z e voo sem veículos.
- **Verificação Server-Side**: Valida a posição do jogador no servidor para prevenir bypass do lado do cliente.

### Análise de Combate
- **Detecção de Silent Aim**: Calcula a diferença de ângulo entre a visão da câmera e a direção do tiro.
- **Magic Bullet / Wallbang**: Bloqueia tiros que atravessam paredes sólidas usando Raycasting (Lançamento de Raios).
  - Utiliza `StartShapeTestRay` para verificar a linha de visão entre atirador e vítima.
  - Ignora o registro de dano (`CancelEvent`) se uma obstrução for detectada.
- **Análise Estatística (ML-Lite)**:
  - **Proporção de Headshots**: Detecta porcentagens de headshot anormalmente altas ao longo do tempo.
  - **Monitoramento de Precisão**: Sinaliza jogadores com precisão desumana.
  - **Kills Por Minuto (KPM)**: Detecta sequências de matança em massa.
- **Análise de Micro-Movimentos**: Analisa a variação de entrada do mouse para detectar mira suave "perfeita" (aimbots) ou falta de recuo (no-recoil).

### Integridade e Exploits
- **Lista Negra de Armas**: Remove automaticamente armas proibidas (RPG, Minigun, etc.).
- **Proteção de Recurso**: Detecta se o cliente tenta parar o recurso do anticheat.

## Instalação

1. Copie a pasta `hidden-anticheat` para o diretório `resources` do seu servidor.
2. Adicione `ensure hidden-anticheat` ao seu `server.cfg`.
3. Configure as opções em `config.lua`.

## Configuração

Edite o `config.lua` para ajustar os limites e ativar/desativar funcionalidades.

```lua
Config.Debug = true -- Ativar para testes
Config.BanSystem = true -- Ativar banimentos automáticos
Config.LogWebhook = "URL_DO_SEU_WEBHOOK_DISCORD"
```

## Aviso Legal

Este sistema utiliza análise estatística e heurística. Embora ajustado para alta precisão, falsos positivos são possíveis em casos extremos (ex: lag massivo). Sempre revise os logs antes de banimentos permanentes.
