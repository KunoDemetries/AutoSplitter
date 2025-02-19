state("SniperResistance_dx12", "Steam 1.05")
{
string25 CurMap : 0x308D5FE;
int start : 0x1290100;
byte fades: 0x25DDDCD; // Fades after load needs testing.
}

state("SniperResistance_dx12", "Steam 1.04")
{
string25 CurMap : 0x30873CE;
int start : 0x128A060;
}

state("SniperResistance_dx12", "Steam 1.02")
{
	//string110 CurCutscene : 0x02728850, 0x38, 0x248, 0x0, 0x0;
	string25 CurMap : 0x30F6D2E;
	int start : 0x128A060;	// main menu 5, in game 14, loading 3, second cutscene is 5, first 8. 128E3DC, 27CE72C, 27CE73C
	//byte fades : 0x;	//F17DEC.. F17DF4,27B19D2, 28168FC
}

init
{
	switch(modules.First().ModuleMemorySize)
    {
	case 255025152 :
			version = "Steam 1.05";
			break;
	case 251449344:
        	version = "Steam 1.04";
        	break;
	case 257024000:
        	version = "Steam 1.02";
        	break;
    }
	vars.doneMaps = new List<string>(); // You get kicked to the main menu, so adding this just in case
	timer.Run.Offset = TimeSpan.FromMilliseconds(-480);
}

startup
{
	var result = MessageBox.Show(timer.Form, // EAC Warning made by xZeKo :O
        "Please make sure Denuvo is disabled.\n"
        + "If you run the autosplit with Denuvo on, there is a possibility you could be banned.\n"
        + "\n \n Click Yes if Denuvo is disabled."
        + "\n \n Click No to find out how to disable Denuvo.",
        "Sniper Elite Resistance",
        MessageBoxButtons.YesNo,
        MessageBoxIcon.Information);
    if (result == DialogResult.No)
    {
        Process.Start("https://github.com/xZeko-SRC/SE5disableEAC/blob/main/README.md");
    }

		
	settings.Add("ils", true, "Individual Levels");
	settings.SetToolTip("ils", "Enable splits for ILs. Please uncheck Missions.");
	settings.Add("survival", false, "Survival");
	settings.SetToolTip("ils", "Enable splits for Survival. Please uncheck Missions and ILs.");
	settings.Add("missions", false, "Missions");
	settings.SetToolTip("missions", "Enable splits for Full Game. Please uncheck Individual Levels. \n Uncheck The Atlantic Wall or it will double split for Occupied Residence");

	vars.missions = new Dictionary<string,string> 
		{ 
		//Coast.asr level 1
			{"Prologue_Alps.asr", "Behind Enemy Lines"},
    	    {"Castle.asr", "Dead Drop"},
    	    {"Terminus.asr", "Sonderzüge Sabotage"},
    	    {"Alps.asr", "Collision Course"},
    		{"Quarry.asr", "Devil's Cauldron"},
    	    {"Fortress.asr", "Assault on Fort Rogue"},
    	    {"Vineyard.asr", "Lock, Stock and Barrels"},
			{"Liberte.asr", "End of the Line"},
			{"Epilogue.asr", "All or Nothing"},
			{"DLC_KillHitlerFilmSet.asr", "Lights, Camera, Achtung!: DLC"},
		};
		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "missions");
    	};

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    	var timingMessage = MessageBox.Show
		(
        	"This game uses Time without Loads (Game Time) as the main timing method.\n"+
        	"LiveSplit is currently set to show Real Time (RTA).\n"+
        	"Would you like to set the timing method to Game Time? This will make verification easier",
        	"LiveSplit | Sniper Elite 5",
        	MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}


start
{
	return ((current.start == 14) && (settings["missions"]) || (settings["ils"] && (current.start == 14)) || (settings["survival"] && (current.start == 14)));
}

onStart
{
	vars.doneMaps.Add(current.CurMap);
}

split
{
	if ((current.CurMap != old.CurMap) && (settings[current.CurMap]) && (!vars.doneMaps.Contains(current.CurMap)) || (old.start == 14) && (current.start == 8) && (settings["ils"]) || (old.start == 14) && (current.start == 8) && (current.CurMap == "DLC_KillHitlerFilmSet.asr") ||  (settings["survival"]) && (old.start == 14) && (current.start == 8) || (current.CurMap == "Epilogue.asr") && (old.start == 14) && (current.start == 9) || (current.CurMap == "Liberte.asr") && (old.start == 14) && (current.start == 9))
	{
		vars.doneMaps.Add(current.CurMap);
		return true;		
	}
}

reset
{
	return (settings["ils"] && (current.start == 3));
}

onReset
{		
	vars.doneMaps.Clear();
}

isLoading
{
	return (settings["missions"] && current.start == 3) || (settings["missions"] && current.fades == 1);
}

