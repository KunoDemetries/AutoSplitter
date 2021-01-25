state("FEARXP")
{
    int loading1 : 0x2173B8;
    string60 map1 : 0x21007F;
    int cutscene : 0x214DA4;
}

startup
{
	settings.Add("missions", true, "Missions");

    vars.missions = new Dictionary<string,string> 
	{ 
	    {"Church_02.World00p","Contamination - Metastasis"},
    	{"Warehouse_01.World00p","Flight - Ambush"},
	    {"Warehouse_02.World00p","Flight- Holiday"},
	    {"Warehouse_03.World00p","flight- Desolation"},
	    {"Subway_01.World00p","Descent - Terminus"},
	    {"Subway_02.World00p","Descent - Orange Line"},
	    {"Subway_03.World00p","Descent - The L"},
	    {"Office_01.World00p","Malice - Leviathan"},
	    {"Hospital_01.World00p","Extraction Point - Malignancy"},
	    {"Hospital_02.World00p","Extraction Point - Dark Heart"},
	    {"Hospital_03.World00p","Epilogue"},
    };
   foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };

      	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
            vars.starter = 0;
            vars.endsplit = 0;
            vars.FuckFinalSplit = 0;
            vars.doneMaps.Clear();
            vars.doneMaps.Add(current.map.ToString());
        });

    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Fear Extraction Point",
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
	vars.doneMaps = new List<string>(); 
}

start
{
    if ((current.map1 == "Church_01.World00p") && (current.loading1 != 0) && (current.cutscene == 0))
	{
		vars.doneMaps.Clear();
		return true;
	}
}

isLoading
{
    return (current.loading1 == 0) || (current.cutscene != 0);
}

reset
{
    return (current.map1 == "XP_Intro.World00p");
}

split
{
	if (current.map1 != old.map1) 
	{
		if (settings[current.map1]) 
		{
			vars.doneMaps.Add(old.map1);
			return true;	
		}	
	}
}

exit 
{
    timer.OnStart -= vars.onStart;
}
