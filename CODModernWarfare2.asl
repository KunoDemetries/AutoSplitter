state("iw4sp")
{	
	//string131 MapID : 0x5DA560;
	bool Loader : 0x171338C; // Originally a 4byte
	int KnifeThrown : 0x3E3ED0;
    string100 SpecOpsCampMapID : 0x89C598;
}

init
{
	vars.doneMaps = new List<string>(); // Adding cause of SpecOps
}

startup 
{
    settings.Add("acta", true, "All Acts");
    settings.Add("act1", true, "Act 1", "acta");
    settings.Add("act2", true, "Act 2", "acta");
    settings.Add("act3", true, "Act 3", "acta");
    settings.Add("end", true, "End Split", "acta");
    settings.SetToolTip("end", "This will split when you throw the knife at the end of the run, disabling this will cause timing issues");
    settings.Add("SO", true, "All Special Ops Tiers");
    settings.Add("Alpha", true, "Alpha", "SO");
    settings.Add("Bravo", true, "Bravo", "SO");
    settings.Add("Charlie", true, "Charlie", "SO");
    settings.Add("Delta", true, "Delta", "SO");
    settings.Add("Echo", true, "Echo", "SO");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    	var sB = new List<Tuple<string, string, string>> 
    	{
			//tB("act1","trainier", "S.S.D.D."), 
			tB("act1","roadkill", "Team Player"),
			tB("act1","cliffhanger", "Cliffhanger"),
			tB("act1","airport", "No Russian"),
			tB("act1","favela", "Takedown"),
			tB("act2","invasion", "Wolverines"),
			tB("act2","favela_escape", "The Hornets Nest"),
			tB("act2","arcadia", "Exodus"),
			tB("act2","oilrig", "The Only Easy Day Was Yesterday"),
			tB("act2","gulag", "The Gulag"),
			tB("act2","dcburning", "Of Their Own Accord"),
			tB("act3","contingency", "Contingency"),
			tB("act3","dcemp", "Second Sun"), 
			tB("act3","dc_whitehouse", "Whiskey Hotel"),
			tB("act3","estate", "Loose Ends"),
			tB("act3","boneyard", "The Enemy of My Enemy"),
			tB("act3","af_caves", "Just Like Old Times"),
			tB("act3","af_chase", "Endgame"),
			tB("act3","ending", "End"),
            tB("Alpha","so_killspree_trainer", "The Pit"),
            tB("Alpha","so_rooftop_contingency", "Sniper Fi"),
            tB("Alpha","so_killspree_favela", "O Cirsto Redentor"),
            tB("Alpha","so_forest_contingency", "Evasion"),
            tB("Alpha","so_crossing_so_bridge", "Suspension"),
            tB("Bravo","so_ac130_co_hunted", "Overwatch"),
            tB("Bravo","so_killspree_invasion", "Body Count"),
            tB("Bravo","so_defuse_favela_escape", "Bomb Squad"),
            tB("Bravo","so_snowrace1_cliffhanger", "Race"),
            tB("Bravo","so_chopper_invasion", "Big Brother"),
            tB("Charlie","so_hidden_so_ghillies", "Hidden"),
            tB("Charlie","so_showers_gulag", "Breach & Clear"),
            tB("Charlie","so_snowrace2_cliffhanger", "Time Trial"),
            tB("Charlie","so_defense_invasion", "Homeland Security"),
            tB("Charlie","so_intel_boneyard", "Snatch & Grab"),
            tB("Delta","so_download_arcadia", "Wardriving"),
            tB("Delta","so_demo_so_bridge", "Wreckage"),
            tB("Delta","so_sabotage_cliffhanger", "Acceptable Losses"),
            tB("Delta","so_escape_airport", "Terminal"),
            tB("Delta","so_takeover_estate", "Estate Takedown"),
            tB("Echo","so_assault_oilrig", "Wetwork"),
            tB("Echo","so_juggernauts_favela", "High Explosive"),
            tB("Echo","so_takeover_oilrig", "Armor Piercing"),
        };
    	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
            vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
            vars.doneMaps.Add(current.SpecOpsCampMapID); // Adding for the starting map because it's also bad
        });
        // subsequently fixed issues with certain splits as well, so double bonus points
    timer.OnStart += vars.onStart; 

       vars.onReset = (LiveSplit.Model.Input.EventHandlerT<LiveSplit.Model.TimerPhase>)((s, e) => 
        {
            vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
        });
    timer.OnReset += vars.onReset; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Call of Duty: Modern Warfare 2",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }	
}

split
{	if ((current.SpecOpsCampMapID != old.SpecOpsCampMapID) && (settings[current.SpecOpsCampMapID]) && (!vars.doneMaps.Contains(current.SpecOpsCampMapID)))
    {
		vars.doneMaps.Add(current.SpecOpsCampMapID); 
        return true;
    }

    if ((settings["end"]) && (current.KnifeThrown == 600) && (current.SpecOpsCampMapID == "ending"))
    {
        return true;
    } 
}   

start
{
	if ((current.SpecOpsCampMapID == "trainer") && (current.Loader) || ((current.SpecOpsCampMapID == "so_killspree_trainer") && (current.Loader)))
	{
		vars.doneMaps.Add(current.SpecOpsCampMapID); 
        return true;
	}
}
 
reset
{
    return ((current.SpecOpsCampMapID == "ui") && (old.SpecOpsCampMapID != "ui"));
}

isLoading
{
	return (!current.Loader);
}

shutdown
{
    timer.OnStart -= vars.TimerStart;
}
