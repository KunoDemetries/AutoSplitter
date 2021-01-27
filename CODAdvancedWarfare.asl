// Asl written by KunoDemetries#6969
// Addresses found by Klooger#1867
state("s1_sp64_ship")
{
	int loading1: 0xF6109DC;
	string50 map: 0x30740B6;
}

startup 
{
	settings.Add("missions", true, "Missions");

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
	return ((current.map == "seoul") && (current.loading1 == 0));
}

split
{
	return ((current.map != old.map) && (settings[(current.map)]));
}
 
reset
{
	return (current.map == "ui");
}

isLoading
{
	return (current.loading1 == 1);
}
