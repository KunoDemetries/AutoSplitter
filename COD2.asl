state("CoD2SP_s")
{
	string98 CurrentLevel : 0xCFEBD0;
	bool Loader : 0x415010; // Originally an int
}

init
{
	vars.doneMaps = new List<string>(); //Used for not splitting twice just in cause the game crashes
    vars.DoWeSplit = false;
}

startup 
{
	settings.Add("missions", true, " All Missions");

	vars.missions = new Dictionary<string,string> 
	{ 
		{"demolition", "Demolition"},
		{"tunkhunt", "Repairing the Wire"},
		{"trainyard", "The Pipeline"},
		{"downtown_assault", "Downtown Assault"},
		{"cityhall", "City Hall"},
		{"downtown_sniper", "Comrade Sniper"},
		{"decoytrenches", "The Diversionary Raid"},
		{"decoytown", "Holding The Line"},
		{"elalamein", "Operation Supercharge"},
		{"eldaba", "The End of the Beginning"}, 
		{"libya", "Crusader Charge"},
		{"88ridge", "88 Ridge"},
		{"toujane_ride", "Outnumbered and Outgunned"},
		{"toujane", "Retaking Lost Ground"},
		{"matmata", "Assault on Matmata"},
		{"duhoc_assault", "The Battle of Pointe du Hoc"},
		{"duhoc_defend", "Defending the Pointe"},
		{"silotown_assault", "The Silo"},
		{"beltot", " Prisoners of War"},
		{"crossroads", "The Crossroads"},
		{"newvillers", "The Tiger"},
		{"breakout", "The Brigade Box"},
		{"bergstein", "Approaching Hill 400"},
		{"hill400_assault", "Rangers Lead the Way"}, 
		{"hill400_defend", " The Battle for Hill 400"},
		{"rhine", " Crossing the Rhine"},
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
            "LiveSplit | Call of Duty 2",
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
	if (((current.CurrentLevel != old.CurrentLevel) && (settings[current.CurrentLevel])) || (current.CurrentLevel == "credits"))
	{
		vars.DoWeSplit = true;
	}
}

start
{
	return ((current.CurrentLevel == "moscow") && (old.CurrentLevel == "movie_eastern"));
}

onStart
{
	vars.doneMaps.Clear();
}

split
{
	if (vars.DoWeSplit)
	{
		vars.DoWeSplit = false;
		return true;
	}
}
 
reset
{
	return (current.CurrentLevel == "movie_eastern");
}

onReset
{
	vars.doneMaps.Clear();
}

isLoading
{
	return (!current.Loader);
}
