// Asl written by KunoDemetries#6969
// Addresses found by Klooger#1867
state("s1_sp64_ship")
{
	bool Loader : 0xF6109DC;  //Originally an int
	string50 CurrentLevelName : 0x30740B6;
}

init
{
	vars.doneMaps = new List<string>(); //Used for not splitting twice just in cause the game crashes
}

startup 
{
	settings.Add("missions", true, "All Missions");

	vars.missions = new Dictionary<string,string> 
	{ 
		{"recovery","Atlas"},
		{"lagos","Traffic"},
		{"fusion","Fission"},
		{"detroit","Aftermath"},
		{"greece","Manhunt"},
		{"betrayal","Utopia"},
		{"irons_estate","Sentinel"},
		{"crash","Crash"},
		{"lab","Bio Lab"},
		{"sanfran","Collapse"},
		{"sanfran_b","Armada"},
		{"df_fly","Throttle"},
		{"captured","Captured"},
		{"finale","Terminus"},
	}; 
	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Call of Duty: Advanced Warfare",
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
	return ((current.CurrentLevelName == "seoul") && (!current.Loader));
}

onStart
{
	vars.doneMaps.Clear();
}

split
{
	if ((current.CurrentLevelName != old.CurrentLevelName) && (settings[(current.CurrentLevelName)]) && (!vars.doneMaps.Contains(current.CurrentLevelName)))
	{
		vars.doneMaps.Add(current.CurrentLevelName);
		return true;
	}
}
 
reset
{
	return (current.CurrentLevelName == "ui");
}

isLoading
{
	return (current.Loader);
}
