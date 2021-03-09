state("iw7_ship")
{
	string100 map1 : 0x21E5F3C;
	byte loading1 : 0x5D65B77;
}

startup
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
	{ 
		{"europa", "Rising Threat"},
		{"phparade", "Black Sky: Parade"},
		{"phstreets", "Black Sky: Under Attack"},
		{"phspace", "Black Sky: Take to the Sky"},
		{"shipcrib_moon", "Retribution: Aftermath"},
		{"moon_port", "Operation Port Armor: Civilian Terminal"},
		{"moonjackal", "Operation Port Armor: Shipping Storage"},
		{"sa_moon", "Operation Port Armor: Boarding Party"},
		{"shipcrib_europa", "Retribution: Back in the Fight"},
		{"sa_assassination", "Operation Deep Execute"},
		{"shipcrib_titan", "Retribution: Doing What Needs to be Done"},
		{"titan", "Operation Burn Water: Refinery"},
		{"titanjackal", "Operation Burn Water: Fight or Flight"},
		{"shipcrib_rogue", "Retribution: Rescued"},
		{"rogue", "Operation Dark Quarry"},	
		{"shipcrib_prisoner", "Retribution: Cost of Victory"}, 
		{"prisoner", "Operation Black Flag: Prisoner Escort"},
		{"heist", "Operation Black Flag: Trap is Sprung"},
		{"heistspace", "Operation Blood Storm: Trojan House"},
		{"marscrash", "Operation Blood Storm: Crash Landing"},
		{"marscrib", "Operation Blood Storm: Regroup"},
		{"marsbase", "Operation Blood Storm: All or Nothing"},
		{"yard", "Operation Blood Storm: Assault the Shipyard"},
	}; 
	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };

    vars.onStart = (EventHandler)((s, e) => // Because of a lack of a start function clearing doneMaps like this
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
                "LiveSplit | Call of Duty: Inifinite Warfare",
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
	vars.doneMaps = new List<string>(); // Like most newer cods you can enter old levels while still playing the game, so gotta have doneMaps 
}

split
{
  if ((current.map1 != old.map1) && (settings[current.map1]) && (!vars.doneMaps.Contains(old.map1)))
    {
	    vars.doneMaps.Add(old.map1);
		  return true;
	  }
}

isLoading
{
	return (current.loading1 == 0);
}

exit 
{
    timer.OnStart -= vars.onStart;
}
