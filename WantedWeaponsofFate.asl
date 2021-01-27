// With help from Voxgizer
state("Wanted")
{
    string25 map : 0x00733140, 0x78, 0x4, 0x64, 0x30, 0x40, 0x4, 0x2EC;
	int loading1 : 0x73EF70;
}

startup
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
    {  
		{"/02_RES_A_1_stage1","Act 2: When the Water Broke"},
		{"/03_DCF_A_stage1","Act 3: Russian's Last Dance"},
		{"/04_AIR_A_stage1","Act 4: Fear of Flying Fuck"},
		{"/05_OFF_A_stage1","Act 5: Shut The Fuck Up"},
		{"/06_CF_A_stage1","Act 6: Shoot That MotherFucker!"},
		{"/07_MOU_A_stage1","Act 7: Spiders Don't Have Wings"},
		{"/08_MVA_B_stage1","Act 8: Dust to Dust"},
		{"/09_CHU_A_1_stage1","Act 9; How's Your Father?"},
	};

 	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
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
            "LiveSplit | Wanted: Weapons of Fate",
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
	if ((current.map == "/01_APT_A_stage1") && (current.loading1 == 0) && (old.loading1 != current.loading1))
	{
		vars.doneMaps.Clear();
		return true;		
	}
}

split
{ 
	if ((current.map != old.map) && (settings[(current.map)]) && (!vars.doneMaps.Contains(current.map))) // done maps needed because of shit checkpoints
	{
		vars.doneMaps.Add(current.map);				
		return true;	
	}	
}


isLoading
{
	return (current.loading1 == 1);
}

exit 
{
    timer.OnStart -= vars.onStart;
}
