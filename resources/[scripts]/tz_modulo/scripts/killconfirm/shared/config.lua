Config = Config or {}

Config.KillConfirm = {
    Enabled = true,
    Debug = false,

    -- tempo em ms que o X fica visivel na tela apos matar alguem
    DisplayTime = 1200,

    -- tamanho do X na tela (escala relativa a resolucao)
    CrossSize = 0.008,

    -- espessura das linhas do X
    LineWidth = 1.0,

    -- cor do X (RGBA 0-255)
    Color = { r = 255, g = 60, b = 60, a = 220 },

    -- efeito de fade out no final da animacao
    FadeOut = true,
}
