state("Ghostrunner2-Win64-Shipping")
{
    //Address found by Kuno for the beta, still works here (unused)
    string100 CurAudioPlaying : "fmod.dll",0x001B0C10, 0x1A0, 0x1D0, 0x28, 0x60, 0x70, 0x2E0, 0x0;
}

startup
{
    // Generic map list Kuno uses
	vars.doneMaps = new List<string>();
    vars.DoLoad = false;
    vars.EndSplit = false;
    //There is a few instances where the game loads worlds out of order so we're adding a counter to fix it
    vars.Counter = 0;

    // Taken from Dude Simulator 3 (Meta worked on it)
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Ghostrunner 2",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    //This text comp. has been floating around for years (4+) I'm unsure who originally wrote it
	vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
	        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
	        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
	        if (textSetting == null)
	        {
	        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
	        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
	        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
	
	        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
	        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
	        }
	
	        if (textSetting != null)
	        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });

    settings.Add("GR2", true, "Ghostrunner 2 Auto Splitting");

    // Mission Autosplitting Parent
    settings.Add("Mission Splits", true, "Mission Autosplits (Checkpoint subsplits are experimental)", "GR2");
        // Mission Splits
        settings.Add("00_01_world", true, "Uninvited Guests", "Mission Splits");
        settings.Add("00_02_world", true, "Will Bushido Allow It?", "Mission Splits");
        settings.Add("01_01_World", true, "Setting The Stage", "Mission Splits");
        settings.Add("01_02_World", true, "The Hacker's Den", "Mission Splits");
        settings.Add("01_03_World", true, "Behind The Curtain", "Mission Splits");
        settings.Add("01_04_world", true, "You Shouldn't Have Peeked", "Mission Splits");
        settings.Add("02_01_WORLD", true, "A Price To Be Paid", "Mission Splits");
        settings.Add("VSL_01_World", true, "Licking The Wounds", "Mission Splits");
        settings.Add("VSL_02_World", true, "I Won't Be Back Today", "Mission Splits");
        settings.Add("02_04_WORLD", true, "Winds Of The Desolate", "Mission Splits");
        settings.Add("02_05_World", true, "Pillars Of Creation", "Mission Splits");
        settings.Add("02_06_world", true, "Something Lurks In The Sand", "Mission Splits");
        settings.Add("02_07_world", true, "Minigames", "Mission Splits");
        settings.Add("2", true, "Can Anyone Hear Me?", "Mission Splits");
        settings.Add("03_02_world", true, "Danse Macabre", "Mission Splits");
        settings.Add("03_03_World", true, "Elevator Maintenance", "Mission Splits");
        settings.Add("03_04_World", true, "Too Close To The Sun", "Mission Splits");
        settings.Add("03_05_World", true, "The Monolith of Inhumanity", "Mission Splits");

    // Hub Autosplitting
    settings.Add("Hub Splits", true, "Toggle Hub levels in autosplitter", "GR2");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>>
    {
        //Uninvited Guests
        tB("00_01_world","00_01_worldBP_CheckpointTrigger37","Arena I"),
        tB("00_01_world","00_01_worldBP_CheckpointTrigger22","Arena II"),
        tB("00_01_world","00_01_worldBP_CheckpointTrigger31","Trains I"),
        tB("00_01_world","00_01_worldBP_CheckpointTrigger16","Arena III"),
        tB("00_01_world","00_01_worldBP_CheckpointTrigger20","Platforming I"),
        tB("00_01_world","00_01_worldBP_CheckpointTrigger21","Arena IV"),
        tB("00_01_world","00_01_worldBP_CheckpointTrigger24","Trains II"),
        tB("00_01_world","00_01_worldBP_CheckpointTrigger27","Platforming II"),
        //Will Bushido Allow It?
        tB("00_02_world","00_02_worldBP_CheckpointTrigger2","Ahriman Phase I"),
        tB("00_02_world","00_02_worldBP_CheckpointTrigger3","Ahriman Platforming"),
        //Setting The Stage
        tB("01_01_World","01_01_WorldBP_CheckpointTrigger4","Pipes Section"),
        tB("01_01_World","01_01_WorldBP_CheckpointTrigger34","Water Room"),
        tB("01_01_World","01_01_WorldBP_CheckpointTrigger3","Single Barrel Blowup Checkpoint [Restricted Route]"),
        tB("01_01_World","01_01_WorldBP_CheckpointTrigger28","Flux Skip[Route Dependant]"),
        tB("01_01_World","01_01_WorldBP_CheckpointTrigger_Cybervoid","Final Arena Complete"),
        tB("01_01_World","01_01_WorldBP_CheckpointTrigger_Cybervoid2","Cybervoid I"),
        //The Hackers Den
        tB("01_02_World","01_02_WorldBP_CheckpointTrigger24","Right Side"),
        tB("01_02_World","01_02_WorldBP_CheckpointTrigger5","Time Cybervoid I"),
        tB("01_02_World","01_02_WorldBP_CheckpointTriggerAfterTimeCV","Time Cybervoid II"),
        tB("01_02_World","01_02_WorldBP_CheckpointTrigger20","Left Side"),
        tB("01_02_World","01_02_WorldBP_CheckpointTrigger19","Shuriken Cybervoid I"),
        tB("01_02_World","01_02_WorldBP_CheckpointTriggerAfterShurikenCV","Shuriken Cybervoid II"),
        tB("01_02_World","01_02_WorldBP_CheckpointTrigger23","Middle"),
        tB("01_02_World","01_02_WorldBP_CheckpointTrigger15","Gravity Cybervoid I"),
        tB("01_02_World","01_02_WorldBP_CheckpointTriggerAfterGravityCV","Gravity Cybervoid II"),
        //Behind The Curtain
        tB("01_03_World","01_03_WorldBP_CheckpointTrigger43","Cybervoid I"),
        tB("01_03_World","01_03_WorldBP_CheckpointTrigger10","Checkpoint before Arena I"),
        tB("01_03_World","01_03_WorldBP_CheckpointTrigger31","Arena I"),
        tB("01_03_World","01_03_WorldBP_CheckpointTrigger22","Arena II"),
        tB("01_03_World","01_03_WorldBP_CheckpointTrigger25","Arena III"),
        tB("01_03_World","01_03_WorldBP_CheckpointTrigger17","Arena IV"),
        //You Shouldn't Have Peeked
        tB("01_04_world","01_04_worldBP_CheckpointTrigger","Avatar Tutorial"),
        tB("01_04_world","01_04_worldBP_CheckpointTrigger6","Mini Avatar's Defeated"),
        tB("01_04_world","01_04_worldBP_CheckpointTrigger2","Rahu I [Restricted Route]"),
        tB("01_04_world","01_04_worldBP_CheckpointTrigger3","Rahu II [Rahu Phase Skip]"),
        tB("01_04_world","01_04_worldBP_CheckpointTrigger4","Rahu III"),
        tB("01_04_world","01_04_worldBP_CheckpointTrigger5","Rahu IV"),
        tB("01_04_world","01_04_worldBP_CheckpointTrigger7","Rahu V"),
        tB("01_04_world","01_04_worldBP_CheckpointTrigger8","Rahu VI"),
        //A Price To Be Paid
        tB("02_01_WORLD","02_01_WORLDBP_CheckpointTrigger12","Laser Guy Intro Arena [Restricted Route]"),
        tB("02_01_WORLD","02_01_WORLDBP_CheckpointTrigger7","Grapple Walls [Restricted Route]"),
        tB("02_01_WORLD","02_01_WORLDBP_CheckpointTrigger21","Hostiles Bossfight Halfway Complete [Restricted Route]"), //?????
        //Licking The Wounds
        tB("VSL_01_World","VSL_01_WorldBP_CheckpointTrigger31","Arena I"),
        tB("VSL_01_World","VSL_01_WorldBP_CheckpointTrigger8","Right Side Skip"),
        tB("VSL_01_World","VSL_01_WorldBP_CheckpointTrigger10","Arena II"),
        tB("VSL_01_World","VSL_01_WorldBP_CheckpointTrigger13","Vents"),
        tB("VSL_01_World","VSL_01_WorldBP_CheckpointTrigger17","Various Mini Fights"),
        tB("VSL_01_World","VSL_01_WorldBP_CheckpointTrigger18","Arena III"),
        tB("VSL_01_World","VSL_01_WorldBP_CheckpointTrigger21","Crane Room"),
        tB("VSL_01_World","VSL_01_WorldBP_CheckpointTrigger24","Shuriken Tempest Puzzle Skip"),              //!!!old2==BP_CheckpointTrigger2"),
        tB("VSL_01_World","VSL_01_WorldBP_CheckpointTrigger27","Triple Enemy Rail"),                   //!!!old2==BP_CheckpointTrigger28"),
        //I Won't Be Back Today
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger2","Power Core Tutorial"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger4","Power Core II"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger25","Power Core III"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger7","Wallriding I"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger9","Tunnels I"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger11","Power Core IV"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger13","Wallriding II"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger14","Tunnels II"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger18","Crawlers I"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger21","Crawlers II"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger22","Bollards I"),
        tB("VSL_02_World","VSL_02_WorldBP_CheckpointTrigger24","Bollards II"),
        //Winds of The Desolate
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger52","Shuriken Puzzle"),                      
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger33","Bike (Lasers)"),
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger34","Bike (Downtown)"),
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger50","Gate I"),
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger11","Bike (Bridge)"),
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger41","Gate II"),           
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger16","Gate III"),         
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger54","Gate IV"),
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger40","Gate V"),
        tB("02_04_WORLD","02_04_WORLDBP_CheckpointTrigger15","Entering Cybervoid"),
        //Pillars of Creation
        tB("02_05_World","02_05_WorldBP_CheckpointTrigger8","Arena I"),
        tB("02_05_World","02_05_WorldBP_CheckpointTrigger76","Bike Section I[Restricted Route]"),
        tB("02_05_World","02_05_WorldBP_CheckpointCV1","LeftPillar[Restricted Route]"),
        tB("02_05_World","02_05_WorldBP_CheckpointTriggerLeftTower","LeftPillarCybervoid[Restricted Route]"),
        tB("02_05_World","02_05_WorldBP_CheckpointCV2","RightPillar[Restricted Route]"),
        tB("02_05_World","02_05_WorldBP_CheckpointTriggerRightTower","RightPillarCybervoid[Restricted Route]"),
        tB("02_05_World","02_05_WorldBP_CheckpointCV3","MiddlePillar[Restricted Route]"),
        tB("02_05_World","02_05_WorldBP_CheckpointTriggerMiddleTower","MiddlePillarCybervoid[Restricted Route]"),
        //Something Lurking In The Sand
        tB("02_06_world","02_06_worldBP_CheckpointTrigger13","Bike Section I"),
        tB("02_06_world","02_06_worldBP_CheckpointTrigger16","Bike Section II"),
        tB("02_06_world","02_06_worldCheckpoint6","Bike Section III"),
        tB("02_06_world","02_06_worldBP_CheckpointTrigger20","Bike Section IV (Bridge I)"),
        tB("02_06_world","02_06_worldCheckpoint10","Bike Section IV (Bridge II)"),
        tB("02_06_world","02_06_worldBP_Checkpoint_Inside1","Bike Section V (Barrage)"),
        tB("02_06_world","02_06_worldBP_Checkpoint_Inside4","Naga Phase I"),
        tB("02_06_world","02_06_worldBP_Checkpoint_Inside7","Naga Phase II"),
        tB("02_06_world","02_06_worldBP_Checkpoint_Inside9","Naga Phase III"),
        tB("02_06_world","02_06_worldBP_Checkpoint_Inside11","Naga Phase IV"),
        //Mindgames
        tB("02_07_world","02_07_worldCheckpoint_start_loop2","Loop I"),
        tB("02_07_world","02_07_worldCheckpoint_start_loop3","Loop II"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable12","Loop III"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable6","Colour Puzzle I"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable5","Fight & Cutscene I"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable15","Platforming I"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable20","Colour Puzzle II"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable10","Fight & Cutscene II"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable24","Platforming II"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable27","Colour Puzzle III"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable13","Fight & Cutscene III"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable30","Platforming III"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable32","Colour Puzzle IV"),
        tB("02_07_world","02_07_worldBP_CheckpointTriggerMovable14","Fight & Cutscene IV"),
        //Can Anyone Hear Me?
        tB("2","03_01_worldBP_CheckpointTrigger19","Bike Section I"),
        tB("2","03_01_worldBP_CheckpointTrigger8","Bike Section II"),
        tB("2","03_01_worldBP_CheckpointTrigger18","Bike Section III"),
        tB("2","03_01_worldBP_CheckpointTrigger9","Bike Section IV"),
        tB("2","03_01_worldBP_CheckpointTrigger11","Bike Section V (Biker Maniacs I)"),
        tB("2","03_01_worldBP_CheckpointTrigger12","Bike Section VI"),
        tB("2","03_01_worldBP_CheckpointTrigger13","Bike Section VII"),
        tB("2","03_01_worldBP_CheckpointTrigger14","Bike Section VIII (Biker Maniacs 2)"),
        tB("2","03_01_worldBP_CheckpointTrigger3","Bike Section IX"),
        tB("2","03_01_worldBP_CheckpointTrigger4","Bike Section X (Inside Dharma)"),
        tB("2","03_01_worldBP_CheckpointTrigger16","Arena Fight"),
        //Danse Macabre
        tB("03_02_world","03_02_worldBP_CheckpointTrigger2","Dismantler Phase I"),
        tB("03_02_world","03_02_worldBP_CheckpointTrigger5","Green Trees Phase I"),
        tB("03_02_world","03_02_worldBP_CheckpointTrigger6","Dismantler Phase II"),
        tB("03_02_world","03_02_worldBP_CheckpointTrigger4","Green Trees Phase II"),
        //Elevator Maintenance
        tB("03_03_World","03_03_WorldBP_CheckpointTrigger23","Arena I"),
        tB("03_03_World","03_03_WorldBP_CheckpointTrigger27","Interior I[Restricted Route]"),
        tB("03_03_World","03_03_WorldBP_CheckpointTrigger31","Exterior I[Restricted Route]"),
        tB("03_03_World","03_03_WorldBP_CheckpointTrigger2","Rail Grinding I[Restricted Route]"),
        tB("03_03_World","03_03_WorldBP_CheckpointTrigger25","Arena II[Restricted Route]"),
        tB("03_03_World","03_03_WorldBP_CheckpointTrigger10","Rail Grinding II"),
        tB("03_03_World","03_03_WorldBP_CheckpointTrigger18","Rail Grinding III"),
        tB("03_03_World","03_03_WorldBP_CheckpointTrigger37","Exterior III[Restricted Route]"),
        tB("03_03_World","03_03_WorldBP_CheckpointTrigger26","Arena III[Restricted Route]"),
        //Too Close To The Sun
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger14","Flying I (Glider Intro)"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger18","Flying II (Air Bounce / OOB Skip)"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger30","Flying III (Grapple Wall + Chook)[Restricted Route]"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger10","Flying IV (Rail Grinding + Fans I)"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger27","Arena I"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger16","Flying V (Big Tube I)"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger25","Arena II[Restricted Route]"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger23","Flying VI (Tempest Grapples)[Restricted Route]"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger22","Hell Hallway / Biter's Hallway"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger","Flying VII (Shuriken Gaps)"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger24","Arena III"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger34","Flying VIII (Big Tube II) [Restricted Route]"),
        tB("03_04_World","03_04_WorldBP_CheckpointTrigger38","Arena IV [Restricted Route]"),
        //The Monolith of Inhumanity
        tB("03_05_World","03_05_WorldBP_CheckpointTrigger5","Mitra Phase I"),
        tB("03_05_World","03_05_WorldBP_CheckpointTriggerPlaterReactor","Mitra Phase II"),
        tB("03_05_World","03_05_WorldBP_CheckpointTriggerVR1Start","Mitra Phase III"),
        //tB("03_05_World","03_05_WorldBP_CheckpointTriggerPlaterReactor","Mitra Phase IV"), literally the only time this method breaks bruh lol
        tB("03_05_World","03_05_WorldBP_CheckpointTriggerVR2Start","Mitra Phase IV & V"),
    };
    foreach (var s in sB) settings.Add(s.Item2, false, s.Item3, s.Item1);   

    // Code assistance by Ero, written by Kuno / Meta
    vars.ILStartCamTargets = new Dictionary<string, Tuple<string, string>>
    {
        { "00_02_world", Tuple.Create("ExpiredSpawnable", "BP_PlayerCharacter_C") },
        { "01_01_World", Tuple.Create("BP_PlayerCharacter_C", "-") },
        { "01_02_World", Tuple.Create("BP_PlayerCharacter_C", "-") },
        { "01_03_World", Tuple.Create("BP_PlayerCharacter_C", "-") },
        { "01_04_world", Tuple.Create("BP_PlayerCharacter_C", "-") },
        { "02_01_WORLD", Tuple.Create("CineCameraActor", "CS_09_Connor_s_Death") },
        { "VSL_01_World", Tuple.Create("CS1_Opening01", "BP_PlayerCharacter_C") },
        { "VSL_02_World", Tuple.Create("BP_PlayerCharacter_C", "BP_MotorcycleVehicle") },
        { "02_04_WORLD", Tuple.Create("BP_PlayerCharacter_C", "BP_MotorcycleVehicle") },
        { "02_05_World", Tuple.Create("BP_PlayerCharacter_C", "BP_MotorcycleVehicle") },
        { "02_06_world", Tuple.Create("BP_PlayerCharacter_C", "BP_MotorcycleVehicle") },
        { "02_07_world", Tuple.Create("01_Opening_02_07", "BP_PlayerCharacter_C") },
        { "03_01_world", Tuple.Create("CS2_CineCameraActor1", "BP_MotorcycleVehicle") },
        { "03_02_world", Tuple.Create("BP_CinematicCamera", "BP_PlayerCharacter_C") },
        { "03_03_World", Tuple.Create("BP_PlayerCharacter_C", "-") },
        //{ "03_03_World", Tuple.Create("BP_CinematicCamera", "BP_PlayerCharacter_C") },
        { "03_04_World", Tuple.Create("BP_PlayerCharacter_C", "-") },
        { "03_05_World", Tuple.Create("CS4_Mitra_Intro", "BP_PlayerCharacter_C") },
        // ...
    };

    // Code written by Kuno / Meta
    settings.Add("ILMode", true, "IL MODE: Enables unique autostarts for IL runs");

    // Code written by Micrologist
    //Parent setting
	settings.Add("Variable Information", true, "Variable Information");
	//Child settings that will sit beneath Parent setting
	settings.Add("Camera", true, "Current Camera Target", "Variable Information");
    settings.Add("Map", true, "Current Map", "Variable Information");

    // Code written by Kuno / Meta
    settings.Add("Checkpoint", true, "Current Checkpoint", "Variable Information");
    settings.Add("Speed", true, "Current Speed", "Variable Information");
}

init
{

    
    //Code original written by Micrologist
    var scn = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
    var syncLoadTrg = new SigScanTarget(5, "89 43 60 8B 05 ?? ?? ?? ??") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var syncLoadCounterPtr = scn.Scan(syncLoadTrg);
    var uWorldTrg = new SigScanTarget(8, "0F 2E ?? 74 ?? 48 8B 1D ?? ?? ?? ?? 48 85 DB 74") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var uWorld = scn.Scan(uWorldTrg);
    var gameEngineTrg = new SigScanTarget(3, "48 39 35 ?? ?? ?? ?? 0F 85 ?? ?? ?? ?? 48 8B 0D") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var gameEngine = scn.Scan(gameEngineTrg);
    var fNamePoolTrg = new SigScanTarget(13, "89 5C 24 ?? 89 44 24 ?? 74 ?? 48 8D 15") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var fNamePool = scn.Scan(fNamePoolTrg);

    // Code written by Kuno / Meta
    var PlayerControllerTrg = new SigScanTarget(3, "48 89 3D ?? ?? ?? ?? C7 05 ?? ?? ?? ?? 00 00 B4 42 89 05") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var PlayerController = scn.Scan(PlayerControllerTrg);
    var EndLeveltrg = new SigScanTarget(3, "4c 8b 05 ?? ?? ?? ?? 33 ff 4c 8b c9"){ OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var EndLevel = scn.Scan(EndLeveltrg);


    print(uWorld.ToString("X"));

    // Code original written by Diggity (converted into a sgiscan by Kuno/Meta)
    var GNamePoolTrg = new SigScanTarget(3, "48 89 05 ?? ?? ?? ?? 48 83 c4 ?? c3") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var GNamePool = scn.Scan(GNamePoolTrg);

    // Throwing in case any base pointers can't be found (yet, hopefully)
    if(syncLoadCounterPtr == IntPtr.Zero || uWorld == IntPtr.Zero || gameEngine == IntPtr.Zero || fNamePool == IntPtr.Zero || GNamePool == IntPtr.Zero || PlayerController == IntPtr.Zero || EndLevel == IntPtr.Zero)
    {
        throw new Exception("One or more base pointers not found - retrying");
    }

    vars.Watchers = new MemoryWatcherList
    {
        //Code original written by Micrologist (changed from ulong to long to work with diggity's FnameReader)
        new MemoryWatcher<int>(new DeepPointer(syncLoadCounterPtr)) { Name = "syncLoadCount" },
        new MemoryWatcher<long>(new DeepPointer(uWorld, 0x18)) { Name = "worldFName"},
        new MemoryWatcher<long>(new DeepPointer(gameEngine, 0xD28, 0x38, 0x0, 0x30, 0x2B8, 0xE90, 0x18)) { Name = "camViewTargetFName"},
        
        // Code original written by Diggity (converted from a stated address into memorywatcher by Kuno/Meta)
        new MemoryWatcher<long>(new DeepPointer(GNamePool)) {Name = "GNamePool"},
        new MemoryWatcher<long>(new DeepPointer(uWorld, 0x180, 0xF0)) {Name = "giss"},
        new MemoryWatcher<int>(new DeepPointer(uWorld, 0x180, 0xF8)) {Name = "gissCount"},

        // Code written by Kuno / Meta
            //End of level scene
        new MemoryWatcher<int>(new DeepPointer(EndLevel, 0x80)) {Name = "EndLevel"},
            //Current velocity shown on the motorcycle in KMH
        new MemoryWatcher<float>(new DeepPointer(EndLevel + 0x1000, 0x20, 0x294)) {Name = "MotorcycleVelocity"},
            //Typically only works on the last two end movies and the intro one (excludes the credits one)
        new MemoryWatcher<long>(new DeepPointer(uWorld, 0x138, 0x20, 0xE8, 0x248, 0x0 + 0x3bc)) { Name = "curMovieName"},
            //Current player x and y velocity not on the motorcycle, in UE4 units
        new MemoryWatcher<float>(new DeepPointer(PlayerController, 0x30, 0x250, 0x290, 0x140)) {Name = "xVel"},
        new MemoryWatcher<float>(new DeepPointer(PlayerController, 0x30, 0x250, 0x290, 0x144)) {Name = "yVel"},
    };

    //Generic line of text updating the watchers list and creating current.camtarget and world (to not have it print null errors later on) 
    vars.Watchers.UpdateAll(game);
    current.camTarget = "";
    current.world = "";
    current.Movie = "";
    
    // Code original written by Diggity (until bottom unstated message)
    var giss = vars.Watchers["giss"].Current;
    var gissCount = vars.Watchers["gissCount"].Current;
    var gNamePool = vars.Watchers["GNamePool"].Current;
    
    if (giss == null || giss == 0)
    {
        throw new Exception("--Couldn't find a pointer I want! Game is still starting or an update broke things!");
    }

    var cachedFNames = new Dictionary<long, string>();
    vars.ReadFName = (Func<long, string>)(fname => 
    {
        string name;
        if (cachedFNames.TryGetValue(fname, out name))
            return name;

        int name_offset  = (int) fname & 0xFFFF;
        int chunk_offset = (int) (fname >> 0x10) & 0xFFFF;

        var base_ptr = new DeepPointer((IntPtr) gNamePool + chunk_offset * 0x8, name_offset * 0x2);
        byte[] name_metadata = base_ptr.DerefBytes(game, 2);

        // First 10 bits are the size, but we read the bytes out of order
        // e.g. 3C05 in memory is 0011 1100 0000 0101, but really the bytes we want are the last 8 and the first two, in that order.
        int size = name_metadata[1] << 2 | (name_metadata[0] & 0xC0) >> 6;

        // read the next (size) bytes after the name_metadata
        IntPtr name_addr;
        base_ptr.DerefOffsets(game, out name_addr);
        // 2 bytes here for the name_metadata
        name = game.ReadString(name_addr + 0x2, size);

        cachedFNames[fname] = name;
        return name;
    });

    vars.ReadFNameOfObject = (Func<IntPtr, string>)(obj => vars.ReadFName(game.ReadValue<long>(obj + 0x18)));
    vars.Checkpoint = null;
    vars.RefreshSubsystemCache = (Action<dynamic>)((curr) =>
    {
        print("Reloading subsystem cache...");

        // iterate over game instances and check for the checkpoint trigger
        for (int i = 0; i < gissCount; i++)
        {
            var ssPtr = game.ReadValue<IntPtr>((IntPtr) (giss + i * 0x18 + 0x8));
            var name = vars.ReadFNameOfObject(ssPtr);
            //print(name + " at " + ssPtr.ToString("X"));
            if (name == "CheckpointSubsystem") {
                vars.Checkpoint = new MemoryWatcher<long>(new DeepPointer(ssPtr + 0x50, 0x18));
            }

        }
    });
    vars.RefreshSubsystemCache(current);
    //End of code written by Diggity
}

update
{
    //Generic line of text updating the watchers list
    vars.Watchers.UpdateAll(game);
  
    // Code original written by Diggity (interpreted to watchers by kuno/meta)
    vars.Checkpoint.Update(game);
    current.giss = vars.Watchers["giss"].Current;
    current.gissCount  = vars.Watchers["gissCount"].Current;
    current.checkpoint = old.checkpoint = vars.ReadFName(vars.Checkpoint.Current);
    if (old.gissCount == 0 && current.gissCount != 0)
    {
        vars.RefreshSubsystemCache(current);
    }

    //Code assitance by DMGvol, written by Kuno / Meta
    float xVel = (float)vars.Watchers["xVel"].Current;
    float yVel = (float)vars.Watchers["yVel"].Current;
    double hVel = Math.Floor(Math.Sqrt((xVel * xVel) + (yVel * yVel)) + 0.5f);
    current.CurrentSpeed = (float)hVel;
    current.MotorcycleSpeed = vars.Watchers["MotorcycleVelocity"].Current;
    
    // Code original written by Micrologist (until unstated)
        // The game is considered to be loading if any scenes are loading synchronously
    current.loading = vars.Watchers["syncLoadCount"].Current > 0;
        // Get the current world name as string, only if *UWorld isnt null
    var worldFName = vars.Watchers["worldFName"].Current;
    current.world = worldFName != 0x0 ? vars.ReadFName(worldFName) : old.world;
        // Get the Name of the current target for the CameraManager
    current.camTarget = vars.ReadFName(vars.Watchers["camViewTargetFName"].Current);
    // End of code original written by Micrologist

    //Code written by Kuno / Meta
    current.EndLoading = vars.Watchers["EndLevel"].Current;
    current.WorldNewCheckpoint = (current.world + current.checkpoint).Replace(" ", "");
        // The movie address doesn't initialize until the movie actually starts playing, so doing this so it doesn't constantly throw an error message saying it's a nullptr

    try 
    {
        current.Movie = vars.ReadFName(vars.Watchers["curMovieName"].Current);
    }
    catch
    {

    }    

    if (current.world == "03_01_world" && old.world != "03_01_world")
    {
        vars.Counter++;
    }

    //Code written by Kuno / Meta
        //There is a weird space between when the end level screen appears vs when loading starts, so we're checking if we're on an endloading screen then setting doload to true
    if (vars.DoLoad == false && current.EndLoading == 1)
    {
        print("DOLOAD");
        vars.DoLoad = true;
    }
        // After the above if is ran and do load is enabled, we check if we're currently loading (which doesn't equal 0 when loading) and disable it as the syncloadcount should be actively removing them anyway
    if (vars.DoLoad == true && vars.Watchers["syncLoadCount"].Current != 0)
    {
        vars.DoLoad = false;
    }

        //All of these settings are added to have the user be able to see the current camera, map, checkpoint names are and the current player speed
    if(settings["Camera"]) 
    {
        vars.SetTextComponent("Camera Target:",current.camTarget.ToString());
        if (old.camTarget != current.camTarget) print("Camera Target:" + current.camTarget.ToString());
    }

        if(settings["Map"]) 
    {
        vars.SetTextComponent("Map:",current.world.ToString());
        if (old.world != current.world) print("Map:" + current.world.ToString());
    }

    if(settings["Checkpoint"]) 
    {
        vars.SetTextComponent("Checkpoint:",current.checkpoint.ToString());
        if (old.world != current.world) print("Checkpoint:" + current.checkpoint.ToString());
    }
    
        //The way the game handles player velocity is changed when on the motorcycle so we're just checking to see if we're moving on the bike and the camera target is the motorcycle
    if (settings["Speed"])
    {
        if (current.MotorcycleSpeed != 0 && current.camTarget == "BP_MotorcycleVehicle")
        {
            // Different rounding as the bike likes to gitter
            vars.SetTextComponent("Speed:",current.MotorcycleSpeed.ToString("0000"));
        }
        else
        {
            vars.SetTextComponent("Speed:",current.CurrentSpeed.ToString("0000.00"));
        }
    }
}

isLoading
{
    //Generic loading information
    return current.loading || vars.DoLoad;
}

start
{
    // written by Kuno / Meta, Used for generic starting for full game runs
    if (current.world == "00_01_world" && old.camTarget == "CS1_CineCameraActor" && current.camTarget == "CS1_01_Opening")
    {
        print("Normal Start");
        vars.doneMaps.Add(current.world);
        return true;
    }

    // Code assistance by Ero, written by Kuno / Meta. In a try statement due to the vars.ILStartCamTargets throwing some errors if the current world doesn't equal one in the index
    if (settings["ILMode"])
    {
        try 
        {
            var targets = vars.ILStartCamTargets[current.world];

            //Check one is checking if we're inbetween two camera regions, check two is for certain levels without cutscenes. Can anyone hear me is the only one with an issue being able to work with both so we just excluded it from the second check
            if (old.camTarget == targets.Item1 && current.camTarget == targets.Item2 || old.camTarget == targets.Item1 && old.loading != current.loading && current.world != "03_01_world")
            {
                vars.Checkpoint.Reset();
                return true;
            }
        }
        catch
        {

        }
    }
}

onStart
{
    timer.IsGameTimePaused = true;
    vars.doneMaps.Add(current.world);
}

split
{
    //Split if the current world is enabled, and not inside of our donemaps list
    if (settings[current.world] && (!vars.doneMaps.Contains(current.world)) && (!current.loading))
    {
        vars.doneMaps.Add(current.world);
        print("Splti on:" + current.world);
        return true;
    }

    if (settings[vars.Counter.ToString()] && !vars.doneMaps.Contains(vars.Counter.ToString()))
    {
        vars.doneMaps.Add(vars.Counter.ToString());
        return true;
    }

    //Split if the current world we're in and the checkpoint we just reached is in settings, and not in our donemaps (also used for done checkpoints)
    if (settings[current.WorldNewCheckpoint] && (!vars.doneMaps.Contains(current.WorldNewCheckpoint)))
    {
        vars.doneMaps.Add(current.WorldNewCheckpoint);
        return true;
    }

    //There is a hub section we return to a few times throughout the game, this is a generic check nothing major
    if (settings["Hub Splits"] && (current.world == "HUB_Blockout" && old.world != "HUB_Blockout"))
    {
        return true;
    }

    //End time for full game runs is on the ending movie, DMGvol helped us find the current.Movie playing and we're just checking if we reached it. Alongside, if we already endsplitted just in case so it doesn't split a billion times if the runner wasn't on their end split (for whatever reason)
    if (current.Movie == "UI.Video.Outro" && vars.EndSplit == false)
    {
        vars.EndSplit = true;
        print("end splitt");
        return true;
    }
}

onReset
{
    //Clearing out donemaps, and setting endsplit back to false
    vars.doneMaps.Clear();
    vars.EndSplit = false;
    current.Movie = "";
    vars.Counter = 0;
}

exit
{
    //Just in case the game crashes we'll have the time paused until the user loads into the mainmenu
	timer.IsGameTimePaused = true;
    vars.Checkpoint.Reset();
}
