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
        id    = "anim_1",
        label = "Animação 1",
        image = "1.png",
        dict  = "pazeee@radioa",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_2",
        label = "Animação 2",
        image = "2.png",
        dict  = "pazeee@radiob",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_3",
        label = "Animação 3",
        image = "3.png",
        dict  = "pazeee@radioc",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_4",
        label = "Animação 4",
        image = "4.png",
        dict  = "pazeee@radiod",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_5",
        label = "Animação 5",
        image = "5.png",
        dict  = "pazeee@radioe",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_6",
        label = "Animação 6",
        image = "6.png",
        dict  = "pazeee@radiof",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_7",
        label = "Animação 7",
        image = "7.png",
        dict  = "pazeee@radiog",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_8",
        label = "Animação 8",
        image = "8.png",
        dict  = "pazeee@radioh",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_9",
        label = "Animação 9",
        image = "9.png",
        dict  = "pazeee@radioi",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_10",
        label = "Animação 10",
        image = "10.png",
        dict  = "pazeee@radioj",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_11",
        label = "Animação 11",
        image = "11.png",
        dict  = "pazeee@radiok",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_12",
        label = "Animação 12",
        image = "12.png",
        dict  = "pazeee@radiol",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_13",
        label = "Animação 13",
        image = "13.png",
        dict  = "pazeee@radiom",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_14",
        label = "Animação 14",
        image = "14.png",
        dict  = "pazeee@radion",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_15",
        label = "Animação 15",
        image = "15.png",
        dict  = "pazeee@radioo",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "anim_16",
        label = "Animação 16",
        image = "16.png",
        dict  = "pazeee@radiop",
        anim  = "base",
        animParams = { blendIn = 8.0, blendOut = -8.0, duration = -1, flag = 49, playbackRate = 0 },
        prop  = nil,
    },
    {
        id    = "radio_clip",
        label = "Animação 17",
        image = "17.png",
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
        id    = "holding_radio",
        label = "Animação 18",
        image = "18.png",
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
