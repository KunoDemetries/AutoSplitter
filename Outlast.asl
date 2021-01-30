/*
    -------------------------------------------Outlast/ Outlast Whistleblower ASL -------------------------------------------
                        Major credits to Gelly, AlexisDR and the main mods for stress testing
                        Original codes (isloading, xcord, ycord, zcord, incontrol) all found by MattMatt
                        Splitter and logical changes made by Kuno Demetries
                        Literally the longest and easily the hardest ASL I've made thus far lol
                        Some of the new code was yoinked from Zeko so props to him for linking me some stuff, I didn't bother with 
                        trying to change his start method cause IDC to really learn it as the OL mods said really to just implement a split function
                        so that's what I did
                        Any problems contact Kuno Demetries#6969
*/
state("OLGame")
{
    int isLoading : 0x01FFBCC8, 0x118;  // Generic Loading string
    float xcoord  : 0x02020F38, 0x278, 0x40, 0x454, 0x80;
    float ycooord : 0x2020F38, 0x278, 0x40, 0x454, 0x84;
    float zcoord  : 0x2020F38, 0x278, 0x40, 0x454, 0x88;
    string100 map : 0x02006F00, 0x6F4, 0x40, 0xAB4, 0x80, 0x0;  // Thanks to cheat mods for the game you can find current checkpoint
    int inControl : 0x02020F38, 0x248, 0x60, 0x30, 0x278, 0x54; // In control == 1
}

init
{
    vars.doneMaps = new List<string>(); // Test to see if we split for a setting already
    vars.starter = 0; // Used for the starting check just so everything can just stay in Update
    vars.endsplit = 0; // Used to do the final split
    vars.OnceFinalSplit = 0; // After the game finishes the end split returns true (mattmatt's fault) so I added this to make it split once
    vars.mapcomparison = current.map; // For whatever reason map returns Null and livesplit likes to linger on it so this is the easiest fix without changing addresses for something minor
    vars.Checker = 0;

    // Checking the games memory size to see if it's the steam version 
    switch (modules.First().ModuleMemorySize) 
	{
		case 35831808:
			version = "Patch2";
			break;
	}
}

startup     
{
    settings.Add("OL", true, "Outlast"); // Grouping all the Outlast splits together
		settings.Add("adminblock", true, "Admin Block", "OL"); // Each Chapter is related to one of these
		settings.Add("prisionblock", true, "Prison Block", "OL");
		settings.Add("sewers", true, "Sewers", "OL");
		settings.Add("maleward", true, "Male Ward", "OL");
		settings.Add("courtyard", true, "Courtyard", "OL");
		settings.Add("femaleward", true, "Female Ward", "OL");
		settings.Add("return", true, "Return to the Admin Block" , "OL");
		settings.Add("lab", true, "Underground Lab", "OL");

    settings.Add("WB", true, "Whistleblower");
    	settings.Add("hospital", true, "Hospital", "WB");
    	settings.Add("rec", true, "Recreation Area", "WB");
    	settings.Add("prision", true, "Prison", "WB");
    	settings.Add("drying", true, "Drying Ground", "WB");
    	settings.Add("vocation", true, "Vocational Block", "WB");
    	settings.Add("exit", true, "Exit", "WB");
    //zeko's Code, basically works like how my dictionaries work for other ASLs just only one big dictionary and a definer at the bottom sorting it in a order that livesplit will read because of 
    // C# 7.0 or whatever, really the order doesn't seem to matter lol as long as you sort it at the bottom
 	var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    	var sB = new List<Tuple<string, string, string>> 
    	{
            tB("adminblock", "Admin_MainHall","After first cutscene"),
            tB("adminblock","Admin_SecurityRoom","Power shuts off"),
            tB("prisionblock","Prison_Start","Interact wtih keyboard"),
            tB("prisionblock","Prison_IsolationCells02_Soldier","After Fire"),
            tB("sewers","Sewer_start","Entering Sewers"),
            tB("sewers","Sewer_WaterFlushed","Turning 2nd valve"),
            tB("sewers","Sewer_Citern2","Before waterhops"),
            tB("maleward","Male_Start","Entering Male Ward"),
            tB("maleward","Male_Torture","Trager cutscene"),
            tB("maleward","Male_ElevatorDone","Trager Death"),
            tB("maleward","Male_SprinklerOn","Sprinklers turned on"), 
            tB("courtyard","Courtyard_Start","Entering Courtyard"),
            tB("courtyard","Courtyard_Chapel","Upper Courtyard"),
            tB("femaleward","Female_Start","Entering Female Ward"),
            tB("femaleward","Female_2ndFloor","Before fuses"),
            tB("femaleward","Female_ChuteActivated","After fuses"),
            tB("femaleward","Female_LostCam","Lost camera"),
            tB("femaleward","Female_FoundCam","Pick up Camera"),
            tB("return","Revisit_Soldier1","Entering Return to Admin"),
            tB("return","Revisit_RH","Entering theater"),
            tB("return","Revisit_3rdFloor","Reaching 3rd floor"),
            tB("return","Revisit_PriestDead","After Father Martin death"),
            tB("lab","Lab_Start","Entering lab"),
            tB("lab","Lab_SwarmIntro","Bush skip checkpoint"),
            tB("lab","Lab_SwarmIntro2","Turnaround"),
            tB("lab","Lab_Soldierdead","After Chris dies"),
            tB("lab","Lab_SpeechDone","After Wernicke cutscene"),
            tB("lab","Lab_SwarmCafeteria","Before decontamination"),
            tB("lab","Lab_EBlock","After decontamination"),
            tB("lab","Lab_ToBilly","Big room"),
            tB("lab","Lab_BigRoom","Valve room"),
            tB("lab","Lab_BigRoomDone","After valve turn"),
            tB("lab","Lab_BigTower","Enter tall room"),
            tB("lab","Lab_BigTowerMid","After wires"),
            tB("lab","Lab_BigTowerDone","After Wallrider cutscene"),
            tB("hospital","Hospital_1stFloor_Lobby","Before Frank"),
            tB("hospital","Hospital_1stFloor_Crema","Unlocking handcuffs"),
            tB("hospital","Hospital_2ndFloor_GazOff","Turning Valve"),
            tB("rec","Courtyard1_Start","Start of Rec Area"),
            tB("rec","Courtyard1_SecurityTower","Top of 2nd ladder"),
            tB("prision","PrisonRevisit_Start","Start of Prison"),
            tB("prision","PrisonRevisit_Chase","Chris chase"),
            tB("drying","Courtyard2_Start","Start of Drying Ground"),
            tB("drying","Courtyard2_ElectricityOff_2"," 2nd interact with lever"),
            tB("vocation","Building2_Start","Start of Voc Block"),
            tB("vocation","Building2_Floor3_2","Meeting Eddie"),
            tB("vocation","Building2_Torture","Before Eddie torture cutscene"),
            tB("vocation","Building2_Garden","Escaping Eddie"),
            tB("vocation","Building2_Floor1_5b","Before Eddie death cutscene"),
            tB("exit","MaleRevisit_Start","Start of Exit"),
            tB("exit","AdminBlock_Start","Long hallway"),
        };
    	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
			vars.Checker = 0;			
            vars.starter = 0; // Generic starting split
            vars.endsplit = 0; // generic end split
            vars.OnceFinalSplit = 0; // So it doesn't split more than once for the end split
            vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
            vars.doneMaps.Add(current.map.ToString()); // Adding for the starting map because it's also bad
        });
        // subsequently fixed issues with certain splits as well, so double bonus points
    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Outlast / WB",
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
	// for outlast to be able to not have it endlessly start if you're resetting from the start of the game (thanks mattmatt)
	if ((vars.starter == 0) && (current.zcoord.ToString() == "-551.8501") && (current.xcoord.ToString() == "-16422.93"))
	{
		vars.Checker = 1;
	}
	
	if ((vars.starter == 0) && (current.zcoord.ToString() == "559.15") && (current.xcoord.ToString() == "9543.678"))
	{
		vars.Checker = 1;
	}

	print(current.zcoord.ToString());

	// For outlast to end split
    if ((current.xcoord == -20600) && (current.ycoord == -1578) && (current.zcord == -4098) && (vars.OnceFinalSplit != 1))
    {
        vars.endsplit = 1;
    }
	// For whistleblower to end split
    if ((Math.Abs(-4098.51 - current.zcoord) < 0.01 && current.inControl == 0) && (vars.OnceFinalSplit != 1))
    {
        vars.endsplit = 1;
    }

    vars.mapcomparison = current.map; // Just reinforcing it here as in init
	// For Outlast	

    if  ((vars.Checker == 1) && (current.zcoord > -551.86) && (current.zcoord < -551.84) && (current.xcoord > -16422.93) && (current.xcoord < -16416.11 && current.inControl == 1))
    {
        vars.starter = 1;
    }
	// For whistleblower
    if (vars.Checker == 1 && current.zcoord > 559.14 && current.zcoord < 559.16 && current.xcoord > 9543.68 && current.xcoord < 9550.54 && current.inControl == 1)
    {
        vars.starter = 1; 
    }
}

start
{
    if (vars.starter == 1)
    {
        vars.starter = 0;
        vars.endsplit = 0;
        vars.OnceFinalSplit = 0;
		vars.Checker = 0;
        vars.doneMaps.Clear();
        vars.doneMaps.Add(current.map.ToString());
        return true;
    }
}

split
{
    vars.mapcomparison = current.map;

    if ((settings[(vars.mapcomparison)]) && (!vars.doneMaps.Contains(vars.mapcomparison)))
    {
        vars.doneMaps.Add(vars.mapcomparison);
        return true;
    }

    if ((vars.endsplit == 1) && (vars.OnceFinalSplit == 0))
    {
        vars.OnceFinalSplit = 1;
        return true;
    }
}

isLoading
{
    return current.isLoading == 1;
}

exit 
{
    timer.OnStart -= vars.onStart;
}
