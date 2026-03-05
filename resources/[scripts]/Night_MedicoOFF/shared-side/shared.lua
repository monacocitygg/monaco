Config = {}

Config.Command = "ajuda"                                        -- COMANDO PARA PEDIR AJUDA
Config.UsePermission = false                                     -- USAR PERMISSÃO PARA USAR O COMANDO
Config.CommandPermission = "Admin"                             -- PERMISSÃO PARA USAR O COMANDO
Config.MedicsOn = 1                                             -- QUANTIDADE DE PARAMÉDICOS MÍNIMO PARA BLOQUEAR O COMANDO (0 = ignora)
Config.Price = 2000                                             -- VALOR COBRADO PELA AJUDA (0 = gratuito)

Config.Permission = "Paramedic"                                 -- PERMISSÃO DE PARAMÉDICO DA SUA BASE

Config.NPCModel = "s_m_m_doctor_01"                             -- MODELO DO NPC
Config.VehicleModel = "ambulance"                               -- MODELO DO VEÍCULO

Config.Hospital = vector3(-2749.78,0.76,15.45)                  -- LOCALIZAÇÃO DO HOSPITAL, AONDE O NPC VAI TE DEIXAR
Config.HospitalBeds = {                                         -- LOCALIZAÇÃO DA MACA DO HOSPITAL, AONDE O JOGADOR VAI APARECER
    vector4(-2757.9,-80.82,18.94,2.84)
}

Config.DistanceSpawn = 10                                      -- DISTÂNCIA EM METROS QUE A AMBULÂNCIA VAI SPAWNAR DO JOGADOR QUE SOLICITOU AJUDA