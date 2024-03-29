state("BlazblueEntropyEffect", "Default")
{
    //Gameplay.GameInputManager private LockFlag m_uiActionFlag
    int ActionFlag : "GameAssembly.dll", 0x046D98B0, 0xB8, 0x0, 0x58;
    
    int BossTotalHealth : "GameAssembly.dll", 0x0458A7C8, 0xB8, 0x0, 0x48, 0xA0, 0x28, 0x300;
}

state("BlazblueEntropyEffect", "Update 2/29/24")
{
    //Gameplay.GameInputManager private LockFlag m_uiActionFlag
    int ActionFlag : "GameAssembly.dll", 0x046C5E80, 0xB8, 0x0, 0x58; //13A30
    
    int BossTotalHealth : "GameAssembly.dll", 0x04584060, 0xB8, 0x0, 0xA0, 0x28, 0x300;
}

state("BlazblueEntropyEffect", "Update 3/10/24")
{
    //Gameplay.GameInputManager private LockFlag m_uiActionFlag
    int ActionFlag : "GameAssembly.dll", 0x046EAB90, 0xB8, 0x0, 0x58; //13A30
    
    int BossTotalHealth : "GameAssembly.dll", 0x0459A720, 0xB8, 0x0, 0xA0, 0x28, 0x300;
}

state("BlazblueEntropyEffect", "Update 3/12/24")
{
    //Gameplay.GameInputManager private LockFlag m_uiActionFlag
    int ActionFlag : "GameAssembly.dll", 0x046EC6C8, 0xB8, 0x0, 0x58; //13A30
    
    int BossTotalHealth : "GameAssembly.dll", 0x0459BAB0, 0xB8, 0x0, 0xA0, 0x28, 0x300;
}

init
{
    vars.HighestBossHealth = 0;
    switch (modules.First().ModuleMemorySize) 
    {
                case 688128 :
            version = "Default";
        break;
                default:        
            version = "Default";
        break;
    }
}

startup
{
    settings.Add("BK", true, "Split on Boss Kills");
}

update
{
    if (current.BossTotalHealth > vars.HighestBossHealth)
    {
        vars.HighestBossHealth = current.BossTotalHealth;
    }
}

onStart
{
    vars.HighestBossHealth = 0;
}

split
{
    if ((settings["BK"]) && (current.BossTotalHealth == 0) && (old.BossTotalHealth > 0) && (vars.HighestBossHealth >= 17000) && (((old.BossTotalHealth - current.BossTotalHealth) < 8000)))
    {
        vars.HighestBossHealth = 0;
        return true;
    }
}

isLoading
{
    return (current.ActionFlag & 1) != 0;
}
