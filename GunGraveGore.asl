// Massive massive thanks to Micrologist for teaching me to find the sigscans for UE4!
state("GunGraveGore-WinGDK-Shipping", "Xbox Game Pass 1.0")
{

}

state("GunGraveGore-Win64-Shipping", "Steam 1.0")
{

}

init
{
    vars.doneMaps = new List<string>(); 

    switch (modules.First().ModuleMemorySize) 
    {
        case  89198592:
            version = "Xbox Game Pass 1.0";
        break;
        case 89116672 : 
            version = "steam 1.0";
        break;
        default:        
            version = "";
        break;
    }


    vars.GetStaticPointerFromSig = (Func<string, int, IntPtr>) ( (signature, instructionOffset) => {
        var scanner = new SignatureScanner(game, modules.First().BaseAddress, (int)modules.First().ModuleMemorySize);
        var pattern = new SigScanTarget(signature);
        var location = scanner.Scan(pattern);
        if (location == IntPtr.Zero) return IntPtr.Zero;
        int offset = game.ReadValue<int>((IntPtr)location + instructionOffset);
        return (IntPtr)location + offset + instructionOffset + 0x4;
    });

    vars.Loading = vars.GetStaticPointerFromSig("48 89 3d ?? ?? ?? ?? 48 89 3d ?? ?? ?? ?? 89 3d ?? ?? ?? ?? c7 05 ?? ?? ?? ?? ?? ?? ?? ?? c7 05 ?? ?? ?? ?? ?? ?? ?? ?? 89 3d ?? ?? ?? ?? 48 89 3d ?? ?? ?? ?? 89 3d ?? ?? ?? ?? 40", 0x3);
    vars.GameEngine = vars.GetStaticPointerFromSig("48 89 05 ?? ?? ?? ?? 48 85 c9 74 ?? e8 ?? ?? ?? ?? 48 8d 4d", 0x3);
    
    if(vars.FNamePool == IntPtr.Zero || vars.UWorld == IntPtr.Zero || vars.GameEngine == IntPtr.Zero)
    {
        throw new Exception("Loading/GameEngine not initialized - trying again");
    }

    vars.watchers = new MemoryWatcherList
    {
        new StringWatcher(new DeepPointer(vars.GameEngine, 0x8B0, 0x0), 100) { Name = "CurMap"},
        new MemoryWatcher<byte>(new DeepPointer(vars.Loading - 0x3)) { Name = "Loader"},

    };
}

update
{
    vars.watchers.UpdateAll(game);
    current.CurMap = vars.watchers["CurMap"].Current;
    current.loading = vars.watchers["Loader"].Current;

}

start
{
    return ((!current.CurMap.Contains("TitleLevel")) && (current.loading == 0) && (old.loading != 0));
}

split
{
    if ((current.CurMap != old.CurMap) && (!vars.doneMaps.Contains(current.CurMap)) && (!current.CurMap.Contains("TitleLevel")))
    {
        vars.doneMaps.Add(current.CurMap);
        return true;
    }
}

isLoading
{
   return (current.loading != 0);
}

onReset
{
    vars.doneMaps.Clear();
}
