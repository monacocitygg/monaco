Config = Config or {}

Config.Antitank = {
    Enabled = true,
    Debug = true,

    -- tempo em ms pra checar se o player morreu depois do hs
    CheckDelay = 500,

    -- bones da cabeca pro check de headshot
    HeadBones = {
        [31086] = true, -- SKEL_Head
        [65068] = true, -- IK_Head
    },
}
