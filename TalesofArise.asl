
state("Tales of Arise")
{
    //byte LoadingScreen : 0x42C82EE;
    //string150 CurCutscene : 0x0481FBA0, 0x68, 0x20, 0x1F8;
}

init
{
    //Code original written by Micrologist
    var scn = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
    var LoadTrg = new SigScanTarget(2, "83 3d ?? ?? ?? ?? ?? 75 ?? 80 ba") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var Load = scn.Scan(LoadTrg);
    var CutsceneTrg = new SigScanTarget(3, "48 83 3d ?? ?? ?? ?? ?? 75 ?? 48 8b 44 24 ?? 48 89 05 ?? ?? ?? ?? 48 8b 44 24 ?? 48 89 05 ?? ?? ?? ?? eb ?? 48 8b 44 24 ?? 48 c7 40 ?? ?? ?? ?? ?? 48 8b 44 24") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var Cutscene = scn.Scan(CutsceneTrg);
    print(Load.ToString("X"));
        vars.Watchers = new MemoryWatcherList
    {
        //Code original written by Micrologist (changed from ulong to long to work with diggity's FnameReader)
        new MemoryWatcher<byte>(new DeepPointer(Load - 0x1)) { Name = "Loading" },
        new StringWatcher(new DeepPointer(Cutscene + 0x1, 0x68, 0x20, 0x1F8), 100) { Name = "Cutscene"},
    };

    //Generic line of text updating the watchers list and creating current.camtarget and world (to not have it print null errors later on) 
    vars.Watchers.UpdateAll(game);
}

update
{
    //Generic line of text updating the watchers list
    vars.Watchers.UpdateAll(game);
    current.CurCutscene = vars.Watchers["Cutscene"].Current;
    current.LoadingScreen = vars.Watchers["Loading"].Current;
    print(current.LoadingScreen.ToString());
}

start
{
    return ((current.CurCutscene != old.CurCutscene) && (old.CurCutscene == @"\Arise\Content\Binaries\Movie\Composite\MV_MEP_010_00000.usm") && (current.CurCutscene == null) && (current.LoadingScreen == 160));
}

isLoading
{
    return (current.LoadingScreen == 32);
}
