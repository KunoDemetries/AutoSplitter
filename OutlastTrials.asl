/*
    Created by KunoDemetries
    With help debugging and testing from Symstery, Meta, and N3rd_Squared
    This ASL is a big mess that may have a few minor that'll be patched out through testing. I shouldn't have to update the ASL in the future as it finds direct pointers to each address.
    If any issues arise please contact myself or join the outlast community speedrun server here: https://discord.com/invite/ekHJZth8Cn

    If you would like to donate, as this ASL took around 30 hours to code and debugm my links are here: https://linktr.ee/KunoDemetries 
*/

state("TOTClient-Win64-Shipping")
{

}

init
{
	vars.doneMaps = new List<string>();
    vars.MapTimeResetter = new List<string>();
    vars.FinalSplitPerLevel = new List<string>();
    vars.totalGameTime = 0;
    current.FinalTime = "/";
    vars.watchertouseforIGT = "/";
    vars.Spacer = 0;
    vars.LeveltimeUpdater = 0; // We need to only run the add. once per level (level name curLevel)
    current.Minutes = 0;
    current.Seconds = 0;
    current.Time = 0;
    
    //TY Ero for helping me fix this code here, it basically is setting up the offset and pattern scanner for UE4 games. Same concept from Micro
   Func<int, string, IntPtr> scan = (offset, pattern) => {
    var scn = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
    var pttern = new SigScanTarget(offset, pattern);
    var ptr = scn.Scan(pttern);
    return ptr + 0x4 + game.ReadValue<int>(ptr);
    };

    vars.CurMap = scan(0x3, "48 89 0D ???????? 48 89 0D ???????? 48 89 0D ???????? F3 ?? ?? 05") + 0xF0;
    vars.LevelName = scan(0x3, "48 8B 1D ???????? 48 89 7C 24 38 8B 3D ???????? 85 FF 74 55") + 0x1DD8;
    vars.FinalTime = scan(0x3, "48 8D 15 ???????? 48 8B CB FF 90 ???????? 48 8B 8B");
    vars.GWorld = scan(0x3, "48 8B 1D ???????? 48 85 DB 74 35 33 D2");
    vars.IGT = scan(0x3, "48 8D 0D ???????? E8 ???????? 48 8B 0D ???????? 48 89 3C F1");
    print(vars.IGT.ToString("X"));

    vars.watchers = new MemoryWatcherList
    {
        new StringWatcher(new DeepPointer(vars.LevelName,0xC0, 0x18, 0x278, 0x288, 0x0, 0x108, 0x1A), 100) { Name = "CurLevelName"},
        new StringWatcher(new DeepPointer(vars.CurMap, 0xE30, 0x0, 0x50, 0x290, 0xD0, 0x30), 100) { Name = "CurMap"},
        new MemoryWatcher<byte>(new DeepPointer(vars.GWorld, 0x188, 0x230, 0x1D0, 0x2A8)) { Name = "Loading"},
        new MemoryWatcher<float>(new DeepPointer(vars.IGT, 0x18, 0x8, 0x4BC)) { Name = "IGT"},
    };

    vars.IGTWatchers = new MemoryWatcherList
    {
        new StringWatcher(new DeepPointer(vars.FinalTime, 0x118, 0x20, 0x878, 0x128, 0x28, 0x0), 10) { Name = "PoliceStationLoad"},
        new StringWatcher(new DeepPointer(vars.FinalTime, 0x78, 0x20, 0x878, 0x128, 0x28, 0x0), 10) { Name = "PoliceStationBasementLoad"},
        new StringWatcher(new DeepPointer(vars.FinalTime, 0xE8, 0x20, 0x878, 0x128, 0x28, 0x0), 10) { Name = "FunParkLoad"},
        new StringWatcher(new DeepPointer(vars.FinalTime, 0xB0, 0x20, 0x878, 0x128, 0x28, 0x0), 10) { Name = "FunParkBarnLoad"},
        new StringWatcher(new DeepPointer(vars.FinalTime, 0x128, 0x20, 0x878, 0x128, 0x28, 0x0), 10) { Name = "OrphanageLoad"},
        new StringWatcher(new DeepPointer(vars.FinalTime, 0xA8, 0x20, 0x878, 0x128, 0x28, 0x0), 10) { Name = "OrphanageServicesLoad"},
    };
}

startup
{
    settings.Add("FSPL", false, "Split at the end of each trial? (dont have below settings enabled or you'll have it split twice between trials)");
    settings.Add("OT", true, "Outlast Trials");
        settings.Add("P1", true, "Program 1 - Police Station", "OT");
        settings.Add("P2", true, "Program 2 - Fun Park", "OT");
        settings.Add("P3", true, "Program 3 - Orphanage", "OT");
        settings.Add("PX", true, "Program X - Police Station", "OT");


    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    	var sB = new List<Tuple<string, string, string>>
        {
            tB("P1","KILL THE SNITCH","KILL THE SNITCH"),
            tB("P1","CANCEL THE AUTOPSY","CANCEL THE AUTOPSY"),
            tB("P1","SABOTAGE THE LOCKDOWN","SABOTAGE THE LOCKDOWN"),
            tB("P1","EXAM: KILL THE SNITCH","EXAM: KILL THE SNITCH"),
            tB("P2","GRIND THE BAD APPLES","GRIND THE BAD APPLES"),
            tB("P2","PUNISH THE MISCREANTS","PUNISH THE MISCREANTS"),
            tB("P2","OPEN THE GATES","OPEN THE GATES"),
            tB("P2","EXAM: GRIND THE BAD APPLES","EXAM: GRIND THE BAD APPLES"),
            tB("P3","CLEANSE THE ORPHANS","CLEANSE THE ORPHANS"),
            tB("P3","FEED THE CHILDREN","FEED THE CHILDREN"),
            tB("P3","FOSTER THE ORPHANS","FOSTER THE ORPHANS"),
            tB("P3","EXAM: CLEANSE THE ORPHANS","EXAM: CLEANSE THE ORPHANS"),
        };
    	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?\n\n"+
            "Outlast Trials does not contain an anti-cheat, this ASL will not get you banned in any regard. If one is enabled the ASL will not intialize.",
            "LiveSplit | Outlast Trials",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

update
{
    vars.watchers.UpdateAll(game);
    current.CurMap = vars.watchers["CurMap"].Current;
    current.CurLevelName = vars.watchers["CurLevelName"].Current;
    current.IGT = vars.watchers["IGT"].Current;
    current.Loading = vars.watchers["Loading"].Current;
    
    switch((string)vars.watchers["CurLevelName"].Current)
    {
        case "KILL THE SNITCH" : vars.watchertouseforIGT = "PoliceStationLoad";
            break;
        case "CANCEL THE AUTOPSY" : vars.watchertouseforIGT = "PoliceStationBasementLoad";
            break;
        case "SABOTAGE THE LOCKDOWN" : vars.watchertouseforIGT = "PoliceStationBasementLoad";
            break;
        case "EXAM: KILL THE SNITCH" : vars.watchertouseforIGT = "PoliceStationLoad";
            break;
        case "GRIND THE BAD APPLES" : vars.watchertouseforIGT = "FunParkLoad";
            break;
        case "PUNISH THE MISCREANTS" : vars.watchertouseforIGT = "FunParkBarnLoad";
            break;
        case "OPEN THE GATES" : vars.watchertouseforIGT = "FunParkBarnLoad";
            break;
        case "EXAM: GRIND THE BAD APPLES" : vars.watchertouseforIGT = "FunParkLoad";
            break;
        case "CLEANSE THE ORPHANS" : vars.watchertouseforIGT = "OrphanageLoad";
            break;
        case "FEED THE CHILDREN" : vars.watchertouseforIGT = "OrphanageServicesLoad";
            break;
        case "FOSTER THE ORPHANS" : vars.watchertouseforIGT = "OrphanageServicesLoad";
            break;
        case "EXAM: CLEANSE THE ORPHANS" : vars.watchertouseforIGT = "OrphanageLoad";
            break;
                default:        vars.watchertouseforIGT = "PoliceStationLoad"; 
            break;
    }
    current.FinalTime = vars.IGTWatchers[vars.watchertouseforIGT.ToString()].Current;
    
    if (current.FinalTime == null)
    {
        current.FinalTime = "1";
    }

    if (current.CurMap == null)
    {
        current.CurMap = "1";
    }

    if (current.CurMap.Contains("Lobby") || current.CurMap.Contains("MainMenu"))
    {
        current.CurLevelName = "";
    }

    if (vars.watchers["CurLevelName"].Changed)
    {
        vars.IGTWatchers[vars.watchertouseforIGT.ToString()].Current = "0";
    }

    if (current.FinalTime.Contains(":") && (vars.LeveltimeUpdater == 0) && (!vars.MapTimeResetter.Contains(current.CurLevelName)) && (current.CurLevelName != "Content/Text/Ingame_General.uasset") && (current.CurLevelName != " ") && (current.CurLevelName != null) && (current.CurLevelName.Length > 4))
    {
        vars.MapTimeResetter.Add(current.CurLevelName);
        current.Minutes = int.Parse(current.FinalTime.Split(':')[0]);
        current.Seconds = int.Parse(current.FinalTime.Split(':')[1]);
        vars.IGTWatchers[vars.watchertouseforIGT.ToString()].Current = "0";
        vars.LeveltimeUpdater = 1;
        current.Time = 0;
    }
    
    if ((!current.CurMap.Contains("Lobby") && !current.CurMap.Contains("MainMenu") && (current.CurLevelName != "Content/Text/Ingame_General.uasset") && current.Loading == 0) && (!current.FinalTime.Contains(":")) && (!vars.MapTimeResetter.Contains(current.CurLevelName)))
    {
        current.Time = (vars.watchers["IGT"].Current - vars.watchers["IGT"].Old);
        vars.IGTWatchers.UpdateAll(game);
    }
    else
    {
        current.Time = 0;
    }
}

start
{
    return (settings[current.CurLevelName] && !vars.doneMaps.Contains(current.CurLevelName));
}

onStart
{
    vars.doneMaps.Add(current.CurLevelName);
}

split
{
    if ((settings[current.CurLevelName]) && (!vars.doneMaps.Contains(current.CurLevelName)) && (current.CurLevelName != "Content/Text/Ingame_General.uasset"))
    {
        vars.doneMaps.Add(current.CurLevelName);
        return true;
    }

    //The trial doesn't end until the end screen appears, so the LRT will remove the time from when the FinalTime appears till the next level select screen
    if ((settings["FSPL"]) && (current.FinalTime.Contains(":")) && (!vars.FinalSplitPerLevel.Contains(current.CurLevelName)) && (current.Loading != 0))
    {
        vars.FinalSplitPerLevel.Add(current.CurLevelName);
        return true;
    }
}

isLoading
{
    return (current.CurMap.Contains("Lobby") || (current.CurLevelName == "Content/Text/Ingame_General.uasset") || current.CurMap.Contains("MainMenu") || current.Loading != 0) || (current.FinalTime.Contains(":"));
}

gameTime
{
    if ((vars.LeveltimeUpdater == 1))
    {
        vars.MapTimeResetter.Add(current.CurLevelName);
        vars.totalGameTime = vars.totalGameTime + (current.Minutes * 60) + (current.Seconds);
        vars.LeveltimeUpdater = 0;
        vars.Spacer = 0;
        current.Time = 0;
        current.Seconds = 0;
        current.Minutes = 0;
        vars.IGTWatchers[vars.watchertouseforIGT.ToString()].Current = "0";
        return TimeSpan.FromSeconds(vars.totalGameTime);
    }
    else
    {
        current.Seconds = 0;
        current.Minutes = 0;
        vars.Spacer = vars.Spacer + (current.Time);
        return TimeSpan.FromSeconds(vars.totalGameTime + vars.Spacer);
    }
}

onReset
{
    vars.Spacer = 0;
    vars.doneMaps.Clear();
    vars.FinalSplitPerLevel.Clear();
    vars.totalGameTime = 0;
    vars.MapTimeResetter.Clear();
    current.Seconds = 0;
    current.Minutes = 0;
    vars.watchers.ResetAll();
    current.FinalTime = 0;
    vars.IGTWatchers[vars.watchertouseforIGT.ToString()].Current = "1";
}
