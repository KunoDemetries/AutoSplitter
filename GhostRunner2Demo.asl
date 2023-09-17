state("Ghostrunner2-Win64-Shipping")
{

}

init
{
    vars.TotalTime = 0f;
    vars.CurrentLevelTime = 0f;
    vars.timerRunning = 0;

    // Code stipet written by just_ero, derived from Micrologist's original codework on UE4 sigscanning
    Func<int, string, IntPtr> scan = (offset, pattern) => {
    var scn = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
    var pttern = new SigScanTarget(offset, pattern);
    var ptr = scn.Scan(pttern);
    return ptr + 0x4 + game.ReadValue<int>(ptr);
    };

    vars.GameEngine = scan(0x3, "48 89 05 ?? ?? ?? ?? 48 85 c9 74 ?? e8 ?? ?? ?? ?? 48 8d 4d");
    //7FF668598330 
    //7FF66859BCB0
    vars.PlayerEngine = scan (0x3, "48 8b 05 ?? ?? ?? ?? c3 cc cc cc cc cc cc cc cc 48 39 51");
    vars.UWorld = scan(0x3, "48 8b 1d ?? ?? ?? ?? 48 85 db 75 ?? e8 ?? ?? ?? ?? 48 8b d8 48 85 c0 74 ?? e8 ?? ?? ?? ?? 48 8b 53 ?? 4c 8d 40 ?? 48 63 40 ?? 3b 42 ?? 7f ?? 48 8b c8 48 8b 42 ?? 4c 39 04 c8 74 ?? 49 8b df");
    print(vars.PlayerEngine.ToString("X"));


    vars.watchers = new MemoryWatcherList
    {
        //Current map in engine
        new StringWatcher(new DeepPointer(vars.GameEngine, 0x8B0, 0x0), 100) { Name = "CurMap"},
        
        // Player individualized checks
        new MemoryWatcher<bool>(new DeepPointer(vars.PlayerEngine, 0x90, 0x6CF)) { Name = "isPlayerDead"},
        new MemoryWatcher<bool>(new DeepPointer(vars.PlayerEngine, 0x90, 0x12B4)) { Name = "isPlayerInCutscene"},

        //World/Menuing Checks
        new MemoryWatcher<bool>(new DeepPointer(vars.UWorld, 0x238)) { Name = "isPaused"},
        new MemoryWatcher<float>(new DeepPointer(vars.UWorld, 0x1D0, 0x118, 0x3AC)) { Name = "CurrentIGT"},
        new MemoryWatcher<float>(new DeepPointer(vars.UWorld, 0x1D0, 0x118, 0x3A8)) { Name = "PreviousTime"},
    };
}

update
{
    vars.watchers.UpdateAll(game);
    current.CurMap = vars.watchers["CurMap"].Current;
    current.IGT = vars.watchers["CurrentIGT"].Current;
    old.IGT = vars.watchers["CurrentIGT"].Old;
    current.PreviousTime = vars.watchers["PreviousTime"].Current;

    current.isPaused = vars.watchers["isPaused"].Current;
    current.isPlayerInCutscene = vars.watchers["isPlayerInCutscene"].Current;
    old.isPlayerInCutscene = vars.watchers["isPlayerInCutscene"].Old;
    current.isPlayerDead = vars.watchers["isPlayerDead"].Current;
    //print(current.IGT.ToString());

    if ((vars.timerRunning == 1))
    {
        vars.TotalTime = current.PreviousTime + current.IGT;
        vars.CurrentLevelTime = 0f;
    }

   print(vars.CurrentLevelTime.ToString());
}

isLoading
{
    return true;
}

start
{
    return ((!current.isPlayerDead) && (!current.isPlayerInCutscene) && (old.isPlayerInCutscene) && (!current.CurMap.Contains("MainMenu")));
}

onStart
{
    vars.TotalTime = 0f;
    vars.timerRunning = 1;
}

gameTime
{
    if (!current.CurMap.Contains("MainMenu") && (!current.isPlayerInCutscene) && (!current.isPaused))
    {
        return TimeSpan.FromSeconds(vars.TotalTime);
    }
}

reset
{
    return (current.CurMap.Contains("MainMenu"));
}

onReset
{
    vars.TotalTime = 0f;
    vars.timerRunning = 0;
}