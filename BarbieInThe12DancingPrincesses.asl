state("Barbie(TM) In The 12 Dancing Princesses", "PC")
{
    string50 CurGame : 0x1242D0;
    string50 CurShow : 0x138730;
    float Loader : 0x118674;
    int End : 0x135A84; 
}

state("pcsx2", "PS2")
{
    string50 CurGame : 0x0123E7E8, 0x250;
    string50 CurShow : 0x0123E83C, 0x558;
    int End : 0x0123E7B4, 0x2BC; 
    int Loader : 0x2C5F93C;
}

init
{
    switch (modules.First().ModuleMemorySize) 
    {
        case  47538176: version = "PS2";
            break;
        case    1335296 : version = "PC"; 
            break;
    }

    vars.doneMaps = new List<string>(); 
    vars.DoSplit = 0;
    vars.OldMinigame = "null";
    vars.LoadingValue = null;
}

startup
{
    settings.Add("SEP", true, "Split on every princess?");
    settings.Add("ST", false, "Split on entering princess dancing section?");
    settings.SetToolTip("ST", "Keeping this false will have livesplit split on leaving the princess dancing setting!");
    settings.Add("missions", true, "Barbie In The 12 Dancing Princesses");

    vars.missions = new Dictionary<string,string> 
	{   {@"games\eg_gemstone_juggle\", "gemstone minigame"},
        {@"games\eg_charm_the_magpie\", "charm the magpie minigame"},
        {@"games\eg_boathouse_puzzle\", "boathouse minigame"},
    };
    foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };

    
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Barbie In The 12 Dancing Princesses",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

update
{
    switch (version)
    {
        case "PC" : vars.LoadingValue = 0;
            break;
        case "PS2" : vars.LoadingValue = 5;
            break;
    }

    //string Spacer = "1";
    if (settings["SEP"])
    {
        if (settings["ST"])
        {
            if ((old.CurShow != "dance star") && (current.CurShow == "dance star") && (current.Loader != vars.LoadingValue))
            {
                vars.DoSplit = 1;
            }
        }
        else
        {
            if ((current.CurShow == "Central Pavilion") && (old.CurShow == "dance star"))
            {
                vars.DoSplit = 1;
            }
        }
    }

    if (settings[current.CurGame])
    {
        vars.OldMinigame = current.CurGame;
    }

    if ((settings[vars.OldMinigame]) && (!vars.doneMaps.Contains(vars.OldMinigame)) && (vars.OldMinigame != current.CurGame))
    {
        vars.doneMaps.Add(vars.OldMinigame);
        vars.DoSplit = 1;
    }

    if ((current.CurShow == "my show live") && (current.End == 0))
    {
        vars.DoSplit = 1;
    }
}

start
{
    return ((current.CurGame == @"worlds\enchanted glen\") && (current.Loader != vars.LoadingValue) && (current.End != 0));
}

onStart
{
    vars.OldMinigame = current.CurGame;
}

split
{
    if (vars.DoSplit == 1)
    {
        vars.DoSplit = 0;
        return true;
    }
}

onReset
{
    vars.doneMaps.Clear();
    vars.OldMinigame = "null";
}

isLoading
{
    return (current.Loader == vars.LoadingValue);
}