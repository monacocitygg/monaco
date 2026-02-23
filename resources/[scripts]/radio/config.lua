-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÃO DE ANIMAÇÕES DO RÁDIO
-----------------------------------------------------------------------------------------------------------------------------------------
-- Para adicionar uma nova animação, basta adicionar uma nova entrada na tabela abaixo.
--
-- Campos:
--   id       = Identificador único (usado internamente)
--   label    = Nome exibido na interface para o jogador
--   icon     = Ícone MDI (https://materialdesignicons.com)
--   dict     = Dicionário da animação (AnimDict)
--   anim     = Nome da animação (AnimName)
--   animParams = (Opcional) Parâmetros do TaskPlayAnim {blendIn, blendOut, duration, flag, playbackRate}
--   prop     = (Opcional) Tabela com modelo do prop e bone de anexo
--     .model = Nome do modelo do prop
--     .bone  = ID do bone onde o prop será anexado (28422 = mão direita)
--     .offset = {x, y, z} offset de posição
--     .rotation = {x, y, z} offset de rotação
-----------------------------------------------------------------------------------------------------------------------------------------

Config = {}

Config.Animations = {
    {
        id    = "radio_clip",
        label = "Rádio Padrão",
        icon  = "mdi-radio-handheld",
        dict  = "radioanimation",
        anim  = "radio_clip",
        animParams = { blendIn = 8.0, blendOut = 8.0, duration = -1, flag = 49, playbackRate = 1.0 },
        prop  = {
            model    = "prop_cs_hand_radio",
            bone     = 60309,
            offset   = { x = 0.08, y = 0.05, z = 0.003 },
            rotation = { x = -50.0, y = 160.0, z = 0.0 },
        },
    },
    {
        id    = "radio_enter",
        label = "Rádio Enter",
        icon  = "mdi-radio",
        dict  = "random@arrests",
        anim  = "generic_radio_enter",
        prop  = nil,
    },
    {
        id    = "holding_radio",
        label = "Segurar Rádio",
        icon  = "mdi-cellphone",
        dict  = "anim@male@holding_radio",
        anim  = "holding_radio_clip",
        animParams = { blendIn = 8.0, blendOut = 2.0, duration = -1, flag = 50, playbackRate = 2.0 },
        prop  = {
            model    = "prop_cs_hand_radio",
            bone     = 28422,
            offset   = { x = 0.0750, y = 0.0230, z = -0.0230 },
            rotation = { x = -90.0, y = 0.0, z = -59.9999 },
        },
    },
}
