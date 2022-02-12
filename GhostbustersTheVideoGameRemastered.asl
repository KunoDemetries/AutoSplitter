state("ghost", "Epic")
{
    string50 CurrentMapArea : 0x1FB5DF8;
    bool Loader : 0xD2FA30; //originally an int
}

state("ghost", "Steam")
{
    string50 CurrentMapArea : 0x205E058;
    bool Loader : 0xDD3A40; //originally an int
}

init
{
    vars.doneMaps = new List<string>(); //Used for not splitting twice just in cause the game crashes
    vars.DoWeSplit = false;

    switch (modules.First().ModuleMemorySize) 
    {
        case    51519488: version = "Epic";
            break;
        case    52211712: version = "Steam";
            break;
        default:        version = ""; 
            break;
    }
}

startup
{
    settings.Add("FH", false, "Split every time you return to firehouse?");
    //settings.tooltip("FH", "Splits every time you return to the firehouse at the end of missions");
    settings.Add("GB", true, "All Splits");
    settings.Add("HS", true, "Hotel Sedgewick", "GB");
    settings.Add("TS", true, "Times Square", "GB");
    settings.Add("PL", true, "Public Library", "GB");
    settings.Add("MNH", true, "Museum of Natrual History", "GB");
    settings.Add("RTHS", true, "Return to Hotel Sedgewick", "GB");
    settings.Add("LI", true, "Lost Island", "GB");
    settings.Add("CPC", true, "Central Park Cemetery", "GB");
//firehouse
    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>> 
	{
        tB("HS","hotel1a","Slimer"),
        tB("HS","hotel1b","Pappy Sargassi"),
        tB("TS","timesSquare1","Walking with car to Stay Puft"),
        tB("TS","timesSquare1b","Stay Puft fight on street"),
        tB("TS","timesSquare2","Stay Puft fight in building"),
        tB("TS","boss_sp_side","Stay Puft boss fight"),
        tB("PL","Library1a","First section of library"),
        tB("PL","Library1b","Eleanor Twitty underground section"),
        tB("PL","Library2","Eleanor Twitty Boss Fight / Azetlor Boss Fight"),
        tB("MNH","museum1","History Showcase"),
        tB("MNH","museum2","Finding Illisa"),
        tB("MNH","museum3","Chairman Fight"),
        tB("RTHS","hotel2","Entering Hotel Sedgewick"),
        tB("RTHS", "13th_floor_boss","Spider Witch Boss Fight"),
        tB("LI","lost_island","Start of Lost Island"),
        tB("LI","lost_island2","Sewers"),
        tB("CPC","cemetary1","Start of Central Park Cemetery"),
        tB("CPC","cemetary2","Crypt Alley"),
        tB("CPC","abyss","Shandor Boss Fight"),
    };
        foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | Ghostbusters The Video Game",
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
    // I still have issues putting a double if into splits, others say they don't, but from my experience livesplit doesn't handle it properly and the second if is forgotten about.
    if (!vars.doneMaps.Contains(current.CurrentMapArea) && settings[current.CurrentMapArea] && (current.Loader))
    {
        vars.doneMaps.Add(current.CurrentMapArea);
        vars.DoWeSplit = true;
    }

    if (settings["FH"] && (!current.Loader) && (current.CurrentMapArea == "firehouse"))
    {
        vars.DoWeSplit = true;
    }
}

start
{
    return ((current.CurrentMapArea == "firehouse") && (!current.Loader));
}

onStart
{
    vars.doneMaps.Clear();
	vars.doneMaps.Add(current.CurrentMapArea);
}

split
{
    if (vars.DoWeSplit)
    {
        vars.DoWeSplit = false;
        return true;
    }
}

isLoading
{
    return (current.Loader);
}

reset
{
    return (current.CurrentMapArea == null);
}

onReset
{
    vars.doneMaps.Clear();
}