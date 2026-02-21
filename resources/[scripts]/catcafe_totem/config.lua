Config = {}

Config.Locations = {
    {
        type = "CatCafe",
        coords = vector3(-585.33,-1063.6,22.34),
        groupCheck = "Catcafe",
        label = "Acessar Cardápio",
        items = {
            { item = "uwucoffee3", name = "Combo catcafe", price = 800, img = "uwucoffee3.png" },
            { item = "uwucoffee1", name = "Copo de Cafe", price = 250, img = "uwucoffee1.png" },
            { item = "cupcake", name = "cupcake", price = 250, img = "cupcake.png" },
            { item = "uwucoffee2", name = "Bolinho", price = 250, img = "uwucoffee2.png" }
        }
    },
    {
        type = "Mechanic",
        coords = vector3(-2038.41,-495.71,12.11), -- PREENCHER COORDENADA
        groupCheck = "Mechanic",
        label = "Acessar Loja",
        items = {
            { item = "tyres", name = "Pneus", price = 225, img = "tyres.png" },
            { item = "toolbox", name = "Caixa de Ferramentas", price = 600, img = "toolbox.png" },
            { item = "advtoolbox", name = "Caixa Avançada", price = 8000, img = "toolbox2.png" },
            { item = "WEAPON_WRENCH", name = "Chave Inglesa", price = 1000, img = "wrench.png" }
        }
    }
}
