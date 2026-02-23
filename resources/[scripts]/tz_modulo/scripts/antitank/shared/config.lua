Config = Config or {}

Config.Antitank = {
    Enabled = true,
    Debug = false,

    -- bones letais (cabeca + pescoco) -> tiro aqui = morte instantanea
    LethalBones = {
        [31086] = true, -- SKEL_Head
        [65068] = true, -- IK_Head
    },

    -- mensagem ao kickar player com godmode
    DropMessage = '[ANTI-TANK] Removido por uso de god mode.',
}
