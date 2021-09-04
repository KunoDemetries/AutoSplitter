state("TEW2", "Current Patch")
{
    float ComputerLoad : 0x2ABFC1D; // 2 while loading
    int Pause : 0x3734978; // just for rn to see what the mod wants
    int Loading : 0x246624E; // loading 0 
    int Chapter : 0x03712248, 0x5C;
    float x : 0x39CA190;
    float y : 0x39CA194; 
    float z : 0x39CA198;
}

state("TEW2", "1.02")
{
    int ComputerLoad : 0x3D6E634; // 0 while loading
    int Pause : 0x3637B00; // 1 paused, 0 unpaused
    int Loading : 0x23692D7; // 2369317 0 loading, 2816 while not
    int Chapter : 0x3615208, 0x5C;
    float x : 0x38CD190;
    float y : 0x38CD194;
    float z : 0x38CD198;
}

startup
{
    settings.Add("chap", true, "All Chapters");
    settings.Add("end", true, "End Split");
    settings.SetToolTip("end", "The end split for when you finish chapter 17. The opposite of start!");
    vars.Chapters = new Dictionary<string,string> 
	    {
            {"starter","Chapter 1 - Into the Flame"},
            {"2","Chapter 2 - Something Not Quite Right"},
            {"3","Chapter 3 - Resonances"},
            {"4","Chapter 4 - Behind the Curtain"},
            {"5","Chapter 5 - Lying in Wait"},
            {"6","Chapter 6 - On the Hunt"},
            {"7","Chapter 7 - Lust For Art"},
            {"8","Chapter 8 - Premiere"},
            {"9","Chapter 9 - Another Evil"},
            {"10","Chapter 10 - Hidden From the Start"},
            {"11","Chapter 11 - Reconnecting"},
            {"12","Chapter 12 - Bottomless Pit"},
            {"13","Chapter 13 - Stronghold"},
            {"14","Chapter 14 - Burning the Altar"},
            {"15","Chapter 15 - The End of This World"},
            {"16","Chapter 16 - In Limbo"},
            {"17","Chapter 17 - A Way Out"},
        };
    foreach (var Tag in vars.Chapters)
		{
			settings.Add(Tag.Key, true, Tag.Value, "chap");
    	}; 

        vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
            vars.doneMaps.Clear();
            vars.doneMaps.Add(current.Chapter.ToString());
        });

    settings.SetToolTip("starter", "This is used as the starter setting, disabling this also disables the original start command!");

    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | The Evil Within 2",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }	
}

init 
{
    switch (modules.First().ModuleMemorySize) 
    {
        case  74637312 : version = "Current Patch"; 
            break;
        case 73007104 : version = "1.02"; 
            break;
        default:        version = ""; 
            break;
    }

    vars.doneMaps = new List<string>();
    vars.endsplit = 0;
    vars.Loader = 0;
}

update
{
    if(settings["end"])
    {
        if (version == "1.02" && current.x > 42099.80858 && current.x < 42099.80860 && current.y > -28778.58009 && current.y < -28778.58007 && current.Chapter == 17)
        {
            vars.endsplit = 1;
        }
    }

    if ((current.Loading == 0) || (current.Pause == 1) || (current.ComputerLoad == 0 && current.Loading != 0))
    {
        vars.Loader = 1;
    }
    else
    {
        vars.Loader = 0;
    }

}

start
{
    return ((current.Chapter == 1) && (settings["starter"]) && (old.Chapter != current.Chapter) && (!vars.doneMaps.Contains(current.Chapter.ToString())));
}

split
{
   if (settings[current.Chapter.ToString()] && (!vars.doneMaps.Contains(current.Chapter.ToString())))
    {
        vars.doneMaps.Add(current.Chapter.ToString());
        return true;
    }  
    
    if (vars.endsplit == 1)
    {
        vars.endsplit = 0;
        return true;
    }
}

isLoading
{
    return (vars.Loader == 1);
}

reset
{
    return (current.Chapter == 0);
}

exit 
{
    timer.OnStart -= vars.onStart;
}