state("hedge")
{
    int levels : 0x3338B4;
    byte loading1 : 0x358CD4;
    byte endsplit : 0x2E5BA4; //11
}

startup
{

    settings.Add("l1", true, "Missions");

    vars.missions5 = new Dictionary<string,string> 
    { 
        {"4","Inside Gladys' House"},
        {"5","Escape!"},
        {"6","Caught in the Hedge!"},
        {"7","Night Streets"},
        {"8","Projector Heist"},
        {"9","Martin Heist, Pt. 1"},
        {"10","Martin Heist, Pt. 2"},
        {"11","Martin House"},
        {"12","Martin House Escape"},
        {"13","Steam Train"},
        {"14","Shooting Gallery"},
        {"15","Maintenance Room"},
        {"16","Smith Birthday Party"},
        {"17","Smith Heist, Pt. 2"},
        {"18","Smith House"},
        {"19","Smith House Escape"},
        {"20","Cave Interiors"},
        {"21","Below Vincent's Den"},
        {"22","Mountain Paths"},
        {"23","Vincent's Den"},
        {"24","Conner Heist, Pt. 1"},
        {"25","Conner Heist, Pt. 2"},
        {"26","Conner Heist, Pt. 3"},
        {"27","Conner House"},
        {"28","Conner House Escape"},
        {"29","Mini-Golf Course"},
        {"30","Roller Coaster Tracks"},
        {"31","Roller Coaster Escape"},
        {"32","Gladys Heist, Pt. 1"},
        {"33","Gladys Heist, Pt. 2"},
        {"34","Gladys Heist Escape"},
        {"35","Protect The Woods!"},
        {"36","Vermtech Heist"},
        {"37","Rescue Heather!"},
    };
 	foreach (var Tag in vars.missions5)
	{
		settings.Add(Tag.Key, true, Tag.Value, "l1");
    };

    
  	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
        vars.doneMaps.Clear();
        });

    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Over The Hedge",
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
    vars.doneMaps = new List<string>(); // Can accidently enter a previous level, doneMaps needed
}

start
{
    if ((current.levels == 3) && (current.loading1 == 1)) 
    {
        vars.doneMaps.Clear();
        return true;
    }
}

split
{
     string currentMap = current.levels.ToString();

	if ((current.levels != old.levels) && (settings[currentMap]) && ((!vars.doneMaps.Contains(currentMap))))
	{
		vars.doneMaps.Add(currentMap);
		return true;	
	}
    
    if ((current.levels == 37) && (current.endsplit == 11))
    {
        return true;
    }
}

reset
{
    return (current.levels == 2);
}

isLoading
{
	return (current.loading1 == 0);
}

exit 
{
    timer.OnStart -= vars.onStart;
}
