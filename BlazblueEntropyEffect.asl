state("BlazblueEntropyEffect")
{
    //Gameplay.GameInputManager private LockFlag m_uiActionFlag
    int ActionFlag : "GameAssembly.dll", 0x046D98B0, 0xB8, 0x0, 0x58;
    
    int BossTotalHealth : "GameAssembly.dll", 0x0458A7C8, 0xB8, 0x0, 0x48, 0xA0, 0x28, 0x300;
}

init
{
    vars.HighestBossHealth = 0;
/*	var	gameAssembly = game.ModulesWow64Safe().FirstOrDefault(m => m.ModuleName == "GameAssembly.dll");
    var scn = new SignatureScanner(game, gameAssembly.BaseAddress, gameAssembly.ModuleMemorySize);
    var BossTotalHealthtrg = new SigScanTarget(4, "40 7a ?? b2") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) - 0x2C6};
    var BossTotalHealthPtr = scn.Scan(BossTotalHealthtrg); 

    var ActionFlagtrg = new SigScanTarget(4, "a0 ?? ?? ?? ?? ?? ?? ?? ?? cb ?? ?? ?? ?? ?? ?? 00 00 13 00") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr)};
    var ActionFlagPtr = scn.Scan(ActionFlagtrg); 

    print(BossTotalHealthPtr.ToString("X"));
        vars.Watchers = new MemoryWatcherList
    {
        //Code original written by Micrologist (changed from ulong to long to work with diggity's FnameReader)
        new MemoryWatcher<int>(new DeepPointer(BossTotalHealthPtr, 0xB8, 0x0, 0x58)) { Name = "BossTotalHealth" },
        new MemoryWatcher<int>(new DeepPointer(ActionFlagPtr, 0xB8, 0x0, 0x48, 0xA0, 0x28, 0x300)) { Name = "ActionFlag" },
    };

    //Generic line of text updating the watchers list and creating current.camtarget and world (to not have it print null errors later on) 
    vars.Watchers.UpdateAll(game);
    */
}
startup
{
    settings.Add("BK", true, "Split on Boss Kills");
}

update
{
  /*  vars.Watchers.UpdateAll(game);
    current.BossTotalHealth = vars.Watchers["BossTotalHealth"].Current;
    old.BossTotalHealth = vars.Watchers["BossTotalHealth"].Old;
    current.ActionFlag = vars.Watchers["ActionFlag"].Current;
*/
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
    if ((settings["BK"]) && (current.BossTotalHealth == 0) && (old.BossTotalHealth > 0) && (vars.HighestBossHealth >= 17000))
    {
        vars.HighestBossHealth = 0;
        return true;
    }
}

isLoading
{
    return (current.ActionFlag & 1) != 0;
}
