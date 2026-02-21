_G.Index = {}; -- nao mexa

Index.Main = {
    --[[
        opcoes disponives de minutos: 

        60 - 1 minuto;
        120 - 2 minutos;
        180 - 3 minutos;
        240 - 4 minutos;
        300 - 5 minutos;
    ]]
    ['minutos'] = { -- minutos para liberar a caixa de suprimentos (passar os segundos)
        30
    },

    ['cds'] = { -- coordenadas dos airdrops
        [1] = {['x'] = 743.73, ['y'] = 2527.09, ['z'] = 73.16, ['nome'] = 'Rebel'},
        [2] = {['x'] = 1360.92, ['y'] = 3124.36, ['z'] = 41.0, ['nome'] = 'areo trevor'},
        [3] = {['x'] = -732.11, ['y'] = 5366.72, ['z'] = 59.9, ['nome'] = 'madereira'},
        [4] = {['x'] = 2630.79, ['y'] = 915.35, ['z'] = 72.93, ['nome'] = 'industrias'},
    },
    ['time'] = { -- tempo em milisegundos, q o drop vai cair do ceu, quanto maior esse numero mais devagar ele vai cair, quanto menor o numero, mais rapido vai cair (recomendado 15 ou 20)
        15
    },

    ['_reward'] = { -- recompensas do airdrop
        itens = {
            {'WEAPON_PISTOL_MK2', math.random(2, 4)},
            {'WEAPON_PISTOL_AMMO', math.random(250, 750)},
            {'dollarsroll', math.random(250000, 300000)},
            {'backpack', math.random(1, 4)},
            {'energetic', math.random(8,15)},
            {'radio', math.random(1, 4)},
            {'presente', math.random(1, 3)},
        }
    },

    ['webhook'] = { -- webhook de ganhadores
        'https://discord.com/api/webhooks/1196364407014437016/g5Gz83GYsmWJtt1cfxTykJDP_6YO2Uz9-g-RjqOOcWjOzuhto1rbcUsqY_A7MtYOxc2P'
    },

    ['permission'] = { -- permissao para soltar o airdrop
        'Admin'
    },

    ['delay'] = { -- delay pra soltar airdrop
        10
    },

    ['delayToRobbery'] = { -- tempo de roubo do air drop em milisegundos
        625
    }
};

return Index; -- nao mexa