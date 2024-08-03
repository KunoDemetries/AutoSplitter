state("iw4sp")
{	
	//string131 MapID : 0x5DA560;
	bool Loader : 0x171338C; // Originally a 4byte
	int KnifeThrown : 0x3E3ED0;
    string100 SpecOpsCampMapID : 0x89C598;
    float ArmorPiercingEnemies : 0x36006C;   
}

init
{
	vars.doneMaps = new List<string>(); // Adding cause of SpecOps
    // Resetting happens slightly different for spec-ops runs so we need to be able to check what type of run we're doing
    vars.campaignRun = false;
}

startup
{
    settings.Add("acta", true, "All Acts");
    settings.Add("act1", true, "Act 1", "acta");
    settings.Add("act2", true, "Act 2", "acta");
    settings.Add("act3", true, "Act 3", "acta");
    settings.Add("campaign_end", true, "Campaign End Split", "acta");
    settings.SetToolTip("campaign_end", "This will split when you throw the knife at the end of the run, disabling this will cause timing issues");
    settings.Add("SO", true, "All Special Ops Tiers");
    settings.Add("Alpha", true, "Alpha", "SO");
    settings.Add("Bravo", true, "Bravo", "SO");
    settings.Add("Charlie", true, "Charlie", "SO");
    settings.Add("Delta", true, "Delta", "SO");
    settings.Add("Echo", true, "Echo", "SO");
    settings.Add("spec_ops_end", true, "Spec Ops End Split", "SO");
    settings.SetToolTip("spec_ops_end", "This will split when you kill the last juggernaut on Armour Piercing, disabling this will cause timing issues");

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
{	return (
        // Campaign knife throw
        (settings["campaign_end"] && current.KnifeThrown == 600 && current.SpecOpsCampMapID == "ending") ||
        // Spec ops kill last enemy on Armour Piercing
        (settings["spec_ops_end"] && current.SpecOpsCampMapID == "so_takeover_oilrig" && current.Loader && current.ArmorPiercingEnemies == 0 && old.ArmorPiercingEnemies > 0) ||
        // Level change
        (!vars.doneMaps.Contains(current.SpecOpsCampMapID) && current.SpecOpsCampMapID != "ui" && settings[current.SpecOpsCampMapID] && current.SpecOpsCampMapID != old.SpecOpsCampMapID)
    );
}

onSplit
{
    vars.doneMaps.Add(current.SpecOpsCampMapID);
}

start
{
    return (
        current.Loader &&
        // Campaign first level
        (current.SpecOpsCampMapID == "trainer" ||
        // Spec ops first level
        current.SpecOpsCampMapID == "so_killspree_trainer")
    );
}

onStart
{
	vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
    vars.doneMaps.Add(current.SpecOpsCampMapID); // Adding for the starting map because it's also bad
    vars.campaignRun = current.SpecOpsCampMapID == "trainer";
}

reset
{
    return (
        // Going back to the menu in campaign
        (vars.campaignRun && current.SpecOpsCampMapID == "ui") ||
        // Starting The Pit in spec ops
        (!vars.campaignRun && old.SpecOpsCampMapID == "ui" && current.SpecOpsCampMapID == "so_killspree_trainer")
    );
}

onReset
{
    vars.doneMaps.Clear(); // Needed because checkpoints bad in game
    vars.campaignRun = false;
}

isLoading
{
	return (!current.Loader) || (current.SpecOpsCampMapID == "airport");
}