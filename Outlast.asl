/*
    -------------------------------------------Outlast/ Outlast Whistleblower ASL -------------------------------------------
                        Major credits to Gelly, AlexisDR and the main mods for stress testing
                        Original codes (isloading, xcord, ycord, zcord, incontrol) all found by MattMatt
                        Splitter and logical changes made by Kuno Demetries
                        IL timing, auto reset, start/end timing adjustments and 32bit implementation by Anti
                        Additional checkpoint settings by Anti and Alexis
                        aiden#2345 on discord
*/
state("OLGame", "Patch2, 64bit") {
  int isLoading: 0x01FFBCC8, 0x118; // Generic Loading string
  float xcoord: 0x02020F38, 0x278, 0x40, 0x454, 0x80;
  float zcoord: 0x2020F38, 0x278, 0x40, 0x454, 0x84;
  float ycoord: 0x2020F38, 0x278, 0x40, 0x454, 0x88;
  string100 map: 0x02006F00, 0x6F4, 0x40, 0xAB4, 0x80, 0x0; // Current Checkpoint
  int inControl: 0x02020F38, 0x248, 0x60, 0x30, 0x278, 0x54; // In control == 1
}

state("OLGame", "Patch2, 32bit") {
  int isLoading: "OLGame.exe", 0x017E5B30, 0xD8;
  float xcoord: "OLGame.exe", 0x017E7764, 0x1D4, 0x38C, 0x78, 0x4, 0x50;
  float zcoord: "OLGame.exe", 0x017E7764, 0x1D4, 0x38C, 0x78, 0x4, 0x54;
  float ycoord: "OLGame.exe", 0x017E7764, 0x1D4, 0x38C, 0x78, 0x4, 0x58;
  string100 map: "OLGame.exe", 0x0178C598, 0x7D4, 0x58, 0x0;
  int inControl: "OLGame.exe", 0x017E7764, 0x1D4, 0x38C, 0x1F4, 0x68, 0x60;
}

init {
  vars.doneMaps = new List < string > (); // Test to see if we split for a setting already
  vars.starter = 0; // Used for the starting check just so everything can just stay in Update
  vars.endsplit = 0; // Used to do the final split
  vars.OnceFinalSplit = 0; // After the game finishes the end split returns true so Kuno added this to make it split once
  vars.mapcomparison = current.map; // For whatever reason map returns Null and livesplit likes to linger on it so this is the easiest fix without changing addresses for something minor
  vars.Checker1 = 0;
  vars.Checker2 = 0;
  vars.Checker3 = 0;
  vars.Checker4 = 0;
  vars.Checker5 = 0;
  vars.Checker6 = 0;
  vars.Checker7 = 0;
  vars.Checker8 = 0;
  vars.Checker9 = 0;
  vars.Checker10 = 0;
  vars.Checker11 = 0;
  vars.Checker12 = 0;
  vars.Checker13 = 0;
  vars.Checker14 = 0;
  vars.Running = 0;
  vars.cz = 0;
  vars.cx = 0;
  // Checking the games memory size to determine version
  switch (modules.First().ModuleMemorySize) {
    case 35831808:
      version = "Patch2, 64bit";
      break;
    case 27406336:
      version = "Patch2, 32bit";
      break;
  }
}

startup {
  vars.Stopwatch = new Stopwatch();
  vars.DelayTime = 0.005;
  settings.Add("OL", true, "Outlast"); // Grouping all the Outlast splits together
  settings.Add("adminblock", true, "Admin Block", "OL"); // Each Chapter is related to one of these
  settings.Add("prisonblock", true, "Prison Block", "OL");
  settings.Add("sewers", true, "Sewers", "OL");
  settings.Add("maleward", true, "Male Ward", "OL");
  settings.Add("courtyard", true, "Courtyard", "OL");
  settings.Add("femaleward", true, "Female Ward", "OL");
  settings.Add("return", true, "Return to the Admin Block", "OL");
  settings.Add("lab", true, "Underground Lab", "OL");

  settings.Add("WB", true, "Whistleblower");
  settings.Add("hospital", true, "Hospital", "WB");
  settings.Add("rec", true, "Recreation Area", "WB");
  settings.Add("prision", true, "Prison", "WB");
  settings.Add("drying", true, "Drying Ground", "WB");
  settings.Add("vocation", true, "Vocational Block", "WB");
  settings.Add("exit", true, "Exit", "WB");
  settings.Add("il", false, "Start timing for ILs (Do not turn on for full game runs!)");
  //zeko's Code, booleans added by anti
  var tB = (Func<string, string, string, bool, Tuple<string, string, string, bool>>) ((elmt1, elmt2, elmt3, elmt4) => { return Tuple.Create(elmt1, elmt2, elmt3, elmt4); });
     var sB = new List<Tuple<string, string, string, bool>>
     {
      tB("adminblock", "Admin_Garden", "Entering garden", false),
      tB("adminblock", "Admin_Explosion", "Entering asylum window", false),
      tB("adminblock", "Admin_Mezzanine", "Drop down from vent", false),
      tB("adminblock", "Admin_MainHall", "After first cutscene", true),
      tB("adminblock", "Admin_WheelChair", "Picked up keycard", false),
      tB("adminblock", "Admin_SecurityRoom", "Power shuts off", true),
      tB("adminblock", "Admin_Basement", "Entering basement", false),
      tB("adminblock", "Admin_Electricity", "Power back on", false),
      tB("adminblock", "Admin_PostBasement", "Leaving basement", false),
      tB("prisonblock", "Prison_Start", "Prison start", true),
      tB("prisonblock", "Prison_IsolationCells01_Mid", "Leaving cell", false),
      tB("prisonblock", "Prison_ToPrisonFloor", "After first decontamination", false),
      tB("prisonblock", "Prison_PrisonFloor_3rdFloor", "Down the drain", false),
      tB("prisonblock", "Prison_PrisonFloor_SecurityRoom1", "Pressed first button", false),
      tB("prisonblock", "Prison_PrisonFloor02_IsolationCells01", "After variant chase", false),
      tB("prisonblock", "Prison_Showers_2ndFloor", "Entering showers 2nd floor", false),
      tB("prisonblock", "Prison_PrisonFloor02_PostShowers", "Leaving showers 2nd floor", false),
      tB("prisonblock", "Prison_PrisonFloor02_SecurityRoom2", "Pressed second button", false),
      tB("prisonblock", "Prison_IsolationCells02_Soldier", "After Fire", true),
      tB("prisonblock", "Prison_IsolationCells02_PostSoldier", "Escaped Chris", false),
      tB("prisonblock", "Prison_OldCells_PreStruggle", "Before variant jumps onto you", false),
      tB("prisonblock", "Prison_OldCells_PreStruggle2", "Before variant grabs you through bars", false),
      tB("prisonblock", "Prison_Showers_Exit", "Before leaving through showers", false),
      tB("sewers", "Sewer_start", "Entering Sewers", true),
      tB("sewers", "Sewer_FlushWater", "Before Flushing Water", true),
      tB("sewers", "Sewer_WaterFlushed", "Turning 2nd valve", true),
      tB("sewers", "Sewer_Ladder", "After climbing 2nd ladder", false),
      tB("sewers", "Sewer_ToCitern", "After climbing down 3rd ladder", false),
      tB("sewers", "Sewer_Citern1", "After crawling through pipe", false),
      tB("sewers", "Sewer_Citern2", "Before waterhops", true),
      tB("sewers", "Sewer_PostCitern", "After escaping Chris", false),
      tB("sewers", "Sewer_ToMaleWard", "After variant attack", false),
      tB("maleward", "Male_Start", "Entering Male Ward", true),
      tB("maleward", "Male_Chase", "Chase start", false),
      tB("maleward", "Male_ChasePause", "Jumping the gap", false),
      tB("maleward", "Male_Torture", "Trager torture cutscene start", true),
      tB("maleward", "Male_TortureDone", "Trager torture cutscene end (lol)", false),
      tB("maleward", "Male_surgeon", "Drop down from first vent after cutscene", false),
      tB("maleward", "Male_GetTheKey", "Drop down from second vent after cutscene", false),
      tB("maleward", "Male_GetTheKey2", "Found the key", false),
      tB("maleward", "Male_Elevator", "Unlocked elevator", false),
      tB("maleward", "Male_ElevatorDone", "Trager death", true),
      tB("maleward", "Male_Priest", "Father Martin reunion", false),
      tB("maleward", "Male_Cafeteria", "Entering cafeteria", false),
      tB("maleward", "Male_SprinklerOff", "Sprinklers off", false),
      tB("maleward", "Male_SprinklerOn", "Sprinklers turned on", true),
      tB("courtyard", "Courtyard_Start", "Entering Courtyard", true),
      tB("courtyard", "Courtyard_Corridor", "Unlocked corridor", false),
      tB("courtyard", "Courtyard_Chapel", "Upper Courtyard", true),
      tB("courtyard", "Courtyard_Soldier1", "Before first Chris encounter", false),
      tB("courtyard", "Courtyard_Soldier2", "Before second Chris encounter (Do not use in Glitchless)", false),
      tB("courtyard", "Courtyard_FemaleWard", "Escaped Chris", false),
      tB("femaleward", "Female_Start", "Entering Female Ward", true),
      tB("femaleward", "Female_Mainchute", "Passing Laundry chute", false),
      tB("femaleward", "Female_2ndFloor", "Reaching 2nd floor", true),
      tB("femaleward", "Female_2ndfloorChute", "Before fuses", false),
      tB("femaleward", "Female_ChuteActivated", "After fuses", true),
      tB("femaleward", "Female_Keypickedup", "Picked up key", false),
      tB("femaleward", "Female_3rdFloor", "Reaching 3rd floor", false),
      tB("femaleward", "Female_3rdFloorHole", "Before falling through floor", false),
      tB("femaleward", "Female_3rdFloorPostHole", "Encountering the twins", false),
      tB("femaleward", "Female_Tobigjump", "Before losing camera", false),
      tB("femaleward", "Female_LostCam", "Lost camera", true),
      tB("femaleward", "Female_FoundCam", "Pick up Camera", true),
      tB("femaleward", "Female_Chasedone", "End of variant chase", false),
      tB("femaleward", "Female_Exit", "Return to 3rd floor", false),
      tB("femaleward", "Female_Jump", "Before big jump", false),
      tB("return", "Revisit_Soldier1", "Entering Return to Admin", true),
      tB("return", "Revisit_Mezzanine", "Dropping down from first vent", false),
      tB("return", "Revisit_ToRH", "Before ladder", false),
      tB("return", "Revisit_RH", "Entering theater", true),
      tB("return", "Revisit_FoundKey", "Picked up key", false),
      tB("return", "Revisit_To3rdfloor", "Leaving theater", false),
      tB("return", "Revisit_3rdFloor", "Reaching 3rd floor", true),
      tB("return", "Revisit_RoomCrack", "After slipping through crack in the wall", false),
      tB("return", "Revisit_ToChapel", "Before entering chapel", false),
      tB("return", "Revisit_PriestDead", "After Father Martin death", true),
      tB("return", "Revisit_Soldier3", "Before second Chris encounter", false),
      tB("return", "Revisit_ToLab", "After escaping Chris", false),
      tB("lab", "Lab_Start", "Entering lab", true),
      tB("lab", "Lab_PremierAirlock", "Lab front desk", false),
      tB("lab", "Lab_SwarmIntro", "Bush skip checkpoint", true),
      tB("lab", "Lab_SwarmIntro2", "Turnaround", false),
      tB("lab", "Lab_Soldierdead", "After Chris dies", true),
      tB("lab", "Lab_SpeachDone", "After Wernicke cutscene", false),
      tB("lab", "Lab_SwarmCafeteria", "Before decontamination", false),
      tB("lab", "Lab_EBlock", "After decontamination", false),
      tB("lab", "Lab_ToBilly", "Big room", false),
      tB("lab", "Lab_BigRoom", "Valve room", false),
      tB("lab", "Lab_BigRoomDone", "After valve turn", true),
      tB("lab", "Lab_BigTower", "Enter tall room", false),
      tB("lab", "Lab_BigTowerMid", "After wires", true),
      tB("lab", "Lab_BigTowerDone", "After Wallrider cutscene", false),
      tB("hospital", "Hospital_1stFloor_ChaseStart", "First chase", false),
      tB("hospital", "Hospital_1stFloor_ChaseEnd", "After first chase", false),
      tB("hospital", "Hospital_1stFloor_dropairvent", "Drop from vent", false),
      tB("hospital", "Hospital_1stFloor_SAS", "After alarm", false),
      tB("hospital", "Hospital_1stFloor_Lobby", "Before Frank", true),
      tB("hospital", "Hospital_1stFloor_NeedHandCuff", "Open door after Frank", false),
      tB("hospital", "Hospital_1stFloor_GotKey", "Got handcuff key", false),
      tB("hospital", "Hospital_1stFloor_Chase", "Leave room with key", false),
      tB("hospital", "Hospital_1stFloor_Crema", "Unlocking handcuffs", true),
      tB("hospital", "Hospital_1stFloor_Bake", "Inside oven", false),
      tB("hospital", "Hospital_1stFloor_Crema2", "Outside oven", false),
      tB("hospital", "Hospital_2ndFloor_Crema", "Reached 2nd floor", false),
      tB("hospital", "Hospital_2ndFloor_Canibalrun", "Run from Frank", false),
      tB("hospital", "Hospital_2ndFloor_Canibalgone", "Escaped Frank", false),
      tB("hospital", "Hospital_2ndFloor_ExitIsLocked", "Find main valve", false),
      tB("hospital", "Hospital_2ndFloor_RoomsCorridor", "After door jumpscare", false),
      tB("hospital", "Hospital_2ndFloor_ToLab", "Run to laboratory", false),
      tB("hospital", "Hospital_2ndFloor_Start_Lab_2nd", "Enter laboratory", false),
      tB("hospital", "Hospital_2ndFloor_GazOff", "Turning Valve", true),
      tB("hospital", "Hospital_2ndFloor_Labdone", "Exit laboratory", false),
      tB("hospital", "Hospital_2ndFloor_Exit", "Exit Hospital", false),
      tB("rec", "Courtyard1_Start", "Start of Recreational Area", true),
      tB("rec", "Courtyard1_RecreationArea", "Turnaround", false),
      tB("rec", "Courtyard1_DupontIntro", "Top of 1st ladder", true),
      tB("rec", "Courtyard1_Basketball", "In basketball area", false),
      tB("rec", "Courtyard1_SecurityTower", "Top of 2nd ladder", true),
      tB("prision", "PrisonRevisit_Start", "Start of Prison", true),
      tB("prision", "PrisonRevisit_Radio", "After Jeremy cutscene", false),
      tB("prision", "PrisonRevisit_Priest", "To Father Martin", false),
      tB("prision", "PrisonRevisit_ToChase", "Down the drain", false),
      tB("prision", "PrisonRevisit_Chase", "Chris chase", true),
      tB("drying", "Courtyard2_Start", "Start of Drying Ground", true),
      tB("drying", "Courtyard2_FrontBuilding2", "Run to lever", false),
      tB("drying", "Courtyard2_ElecrticityOff", "1st interact with lever", false),
      tB("drying", "Courtyard2_ElectricityOff_2", "2nd interact with lever", true),
      tB("drying", "Courtyard2_ToWaterTower", "Long Hallway", false),
      tB("drying", "Courtyard2_WaterTower", "Inside water tower", false),
      tB("drying", "Courtyard2_TopWaterTower", "Top water tower", false),
      tB("vocation", "Building2_Start", "Start of Vocational Block", true),
      tB("vocation", "Building2_Attic_Mid", "Before push object", false),
      tB("vocation", "Building2_Attic_Denis", "Variant chase", false),
      tB("vocation", "Building2_Floor3_1", "Leaving attic", false),
      tB("vocation", "Building2_Floor3_2", "Meeting Eddie", true),
      tB("vocation", "Building2_Floor3_3", "Escape Eddie", false),
      tB("vocation", "Building2_Floor3_4", "Before 2nd push", false),
      tB("vocation", "Building2_Elevator", "After elevator cutscene", false),
      tB("vocation", "Building2_Post_Elevator", "After leaving elevator", false),
      tB("vocation", "Building2_Torture", "Before Eddie torture cutscene", true),
      tB("vocation", "Building2_TortureDone", "After Eddie torture cutscene (lol)", false),
      tB("vocation", "Building2_Garden", "After jumping out window", true),
      tB("vocation", "Building2_Floor1_1", "Find the key", false),
      tB("vocation", "Building2_Floor1_2", "Entering gym", false),
      tB("vocation", "Building2_Floor1_3", "Leaving gym", false),
      tB("vocation", "Building2_Floor1_4", "Found the key", false),
      tB("vocation", "Building2_Floor1_5", "Drop from vent", false),
      tB("vocation", "Building2_Floor1_5b", "Eddie punches you", true),
      tB("vocation", "Building2_Floor1_6", "Eddie death cutscene", false),
      tB("exit", "MaleRevisit_Start", "Start of Exit", true),
      tB("exit", "AdminBlock_Start", "Long hallway", true),
    };
  foreach(var s in sB)
    {
      settings.Add(s.Item2, s.Item4, s.Item3, s.Item1);
    }

  vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
    {
      vars.Checker1 = 0;
      vars.Checker2 = 0;
      vars.Checker3 = 0;
      vars.Checker4 = 0;
      vars.Checker5 = 0;
      vars.Checker6 = 0;
      vars.Checker7 = 0;
      vars.Checker8 = 0;
      vars.Checker9 = 0;
      vars.Checker10 = 0;
      vars.Checker11 = 0;
      vars.Checker12 = 0;
      vars.Checker13 = 0;
      vars.Checker14 = 0;
      vars.starter = 0; // Generic starting split
      vars.endsplit = 0; // generic end split
      vars.OnceFinalSplit = 0; // So it doesn't split more than once for the end split
      vars.doneMaps.Clear(); // Needed because checkpoints bad in game
      vars.doneMaps.Add(current.map.ToString()); // Adding for the starting map because it's also bad
      vars.Running = 1;
      vars.cz = 0;
      vars.cx = 0;
    });
  // subsequently fixed issues with certain splits as well, so double bonus points
  timer.OnStart += vars.onStart;

  vars.onReset = (LiveSplit.Model.Input.EventHandlerT < LiveSplit.Model.TimerPhase > )((s, e) => {
    vars.doneMaps.Clear(); // Needed because checkpoints bad in game
    vars.OnceFinalSplit = 0; // So it doesn't split more than once for the end split
    vars.Running = 0;
  });
  timer.OnReset += vars.onReset;

  if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
  {
    var timingMessage = MessageBox.Show(
      "This game uses Time without Loads (Game Time) as the main timing method.\n" +
      "LiveSplit is currently set to show Real Time (RTA).\n" +
      "Would you like to set the timing method to Game Time? This will make verification easier",
      "LiveSplit | Outlast / WB",
      MessageBoxButtons.YesNo, MessageBoxIcon.Question
    );

    if (timingMessage == DialogResult.Yes) {
      timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
  }
}

update {
  vars.mapcomparison = current.map;
  if ((vars.Running == 0) && (current.zcoord.ToString("0.00") == "-40.00") && (current.ycoord.ToString("0.00") == "80.00")) //main menu
    {
      vars.Checker1 = 0;
      vars.Checker2 = 0;
      vars.Checker3 = 0;
      vars.Checker4 = 0;
      vars.Checker5 = 0;
      vars.Checker6 = 0;
      vars.Checker7 = 0;
      vars.Checker8 = 0;
      vars.Checker9 = 0;
      vars.Checker10 = 0;
      vars.Checker11 = 0;
      vars.Checker12 = 0;
      vars.Checker13 = 0;
      vars.Checker14 = 0;
    }

  // for outlast to be able to not have it endlessly start if you're resetting from the start of the game
  if ((current.isLoading == 1) && (current.map == "Admin_Gates") && (vars.Running == 0) /*&& (current.xcoord < -16422.93)*/) {
    vars.cx = current.xcoord;
    vars.cz = current.zcoord;
    vars.Checker1 = 1;
  }
  // for WB
  if ((vars.starter == 0) /*&& (current.xcoord < 9544)*/ && (current.map == "Hospital_Free") && (old.isLoading == 1) && (vars.Running == 0)) {
    vars.cx = current.xcoord;
    vars.cz = current.zcoord;
    vars.Checker2 = 1;
  }
  // For outlast to end split
  if (Math.Abs(-4098.51 - current.ycoord) < 0.01 && (current.inControl == 0) && (vars.OnceFinalSplit != 1) && (current.map == "Lab_BigTowerDone")) {
    vars.endsplit = 1;
  }
  // For whistleblower to end split
  if ((Math.Abs(-550.00 - current.ycoord) < 0.01) && (current.inControl == 0) && (vars.OnceFinalSplit != 1) && (current.map == "AdminBlock_Start")) {
    vars.endsplit = 1;
  }
  // outlast starter, ik it doesn't work if you start from new game
  if ((vars.Checker1 == 1) && (current.xcoord != vars.cx || current.zcoord != vars.cz)) {
    vars.starter = 1;
  }
  // For whistleblower starter
  if ((vars.Checker2 == 1) && (current.xcoord != vars.cx || current.zcoord != vars.cz)) {
    vars.starter = 1;
  }

  // IL start
  if ((settings[("il")]) && (vars.Running == 0)) {

    //Prison
    if ((current.isLoading == 1) && (current.map == "Prison_Start") && (current.xcoord > 3700)) {
      vars.Checker14 = 1;
    }
    if((vars.Checker14 == 1) && (current.xcoord < 3700) && (current.isLoading == 0) && (current.map == "Prison_Start")) {
     vars.starter = 1;
    }

    //Sewer
    if ((current.isLoading == 1) && (current.map == "Sewer_start")) {
      vars.cz = current.zcoord;
      vars.Checker3 = 1;
    }
    if((vars.Checker3 == 1) && (current.zcoord != vars.cz) && (current.map == "Sewer_start")) {
     vars.starter = 1;
     vars.Checker3 = 0;
    }

    //Male Ward
    if ((current.isLoading == 1) && (current.map == "Male_Start")) {
      vars.cz = current.zcoord;
      vars.Checker4 = 1;
    }
    if((vars.Checker4 == 1) && (current.zcoord != vars.cz) && (current.map == "Male_Start")) {
     vars.starter = 1;
     vars.Checker4 = 0;
    }

    //Courtyard
    if ((current.isLoading == 1) && (current.map == "Courtyard_Start")) {
      vars.cz = current.zcoord;
      vars.Checker5 = 1;
    }
    if((vars.Checker5 == 1) && (current.zcoord != vars.cz) && (current.map == "Courtyard_Start")) {
     vars.starter = 1;
     vars.Checker5 = 0;
    }

    //Female Ward
    if ((current.isLoading == 1) && (current.map == "Female_Start")) {
      vars.cz = current.zcoord;
      vars.Checker6 = 1;
    }
    if((vars.Checker6 == 1) && (current.zcoord != vars.cz) && (current.map == "Female_Start")) {
     vars.starter = 1;
     vars.Checker6 = 0;
    }

    //Return to Admin
    if ((current.isLoading == 1) && (current.map == "Revisit_Soldier1")) {
      vars.cz = current.zcoord;
      vars.Checker7 = 1;
    }
    if((vars.Checker7 == 1) && (current.zcoord != vars.cz) && (current.map == "Revisit_Soldier1")) {
     vars.starter = 1;
     vars.Checker7 = 0;
    }

    //Underground Lab
    if ((current.isLoading == 1) && (current.map == "Lab_Start")) {
      vars.cx = current.xcoord;
      vars.Checker8 = 1;
    }
    if((vars.Checker8 == 1) && (current.xcoord != vars.cx) && (current.map == "Lab_Start")) {
     vars.starter = 1;
     vars.Checker8 = 0;
    }

    //Recreation Area
    if ((current.isLoading == 1) && (current.map == "Courtyard1_Start")) {
      vars.cx = current.xcoord;
      vars.Checker9 = 1;
    }
    if((vars.Checker9 == 1) && (current.xcoord != vars.cx) && (current.map == "Courtyard1_Start")) {
     vars.starter = 1;
     vars.Checker9 = 0;
    }

    //Return to Prison
    if ((current.isLoading == 1) && (current.map == "PrisonRevisit_Start")) {
      vars.cz = current.zcoord;
      vars.Checker10 = 1;
    }
    if((vars.Checker10 == 1) && (current.zcoord != vars.cz) && (current.map == "PrisonRevisit_Start")) {
     vars.starter = 1;
     vars.Checker10 = 0;
    }

    //Drying Grounds
    if ((current.isLoading == 1) && (current.map == "Courtyard2_Start")) {
      vars.cz = current.zcoord;
      vars.Checker11 = 1;
    }
    if((vars.Checker11 == 1) && (current.zcoord != vars.cz) && (current.map == "Courtyard2_Start")) {
     vars.starter = 1;
     vars.Checker11 = 0;
    }

    //Vocational Block
    if ((current.isLoading == 1) && (current.map == "Building2_Start")) {
      vars.cx = current.xcoord;
      vars.Checker12 = 1;
    }
    if((vars.Checker12 == 1) && (current.xcoord != vars.cx) && (current.map == "Building2_Start")) {
     vars.starter = 1;
     vars.Checker12 = 0;
    }

    //Exit
    if ((current.isLoading == 1) && (current.map == "MaleRevisit_Start")) {
      vars.cx = current.xcoord;
      vars.Checker13 = 1;
    }
    if((vars.Checker13 == 1) && (current.xcoord != vars.cx) && (current.map == "MaleRevisit_Start")) {
     vars.starter = 1;
     vars.Checker13 = 0;
    }
  }

  /*if ((vars.OnceFinalSplit != 1)) {
    print(current.ycoord.ToString());
  }*/
}

start {
  if (vars.starter == 1) {
    vars.starter = 0;
    vars.endsplit = 0;
    vars.OnceFinalSplit = 0;
    vars.Checker1 = 0;
    vars.Checker2 = 0;
    vars.doneMaps.Clear();
    vars.doneMaps.Add(current.map.ToString());
    return true;
  }
}

split {
  if ((settings[(vars.mapcomparison)]) && (!vars.doneMaps.Contains(vars.mapcomparison))) {
    vars.doneMaps.Add(vars.mapcomparison);
    return true;
  }

  if ((vars.endsplit == 1) && (vars.OnceFinalSplit == 0)) {
    vars.OnceFinalSplit = 1;
    vars.Stopwatch.Start();
    if(current.map == "AdminBlock_Start")
      {
        vars.DelayTime = 0.08;
      } else
        {
          vars.DelayTime = 0.07;
        }
  }
  if (vars.Stopwatch.Elapsed.TotalSeconds >= vars.DelayTime)
    {
      vars.Stopwatch.Reset();
      return true;
    }
}

reset {
  if((current.isLoading == 1) && (current.map == "Admin_Gates" || current.map == "Hospital_Free"))
    {
      return true;
    }
  if(settings[("il")])
    {
      if((current.isLoading == 1) && (current.map == "Prison_Start" || current.map == "Sewer_start" || current.map == "Male_Start" || current.map == "Courtyard_Start" || current.map == "Female_Start" || current.map == "Revisit_Soldier1" || current.map == "Lab_Start" || current.map == "Courtyard1_Start" || current.map == "PrisonRevisit_Start" || current.map == "Courtyard2_Start" || current.map == "Building2_Start" || current.map == "MaleRevisit_Start"))
        {
          return true;
        }
    }
}

isLoading {
  return (current.isLoading == 1);
}

shutdown {
  timer.OnStart -= vars.onStart;
}
