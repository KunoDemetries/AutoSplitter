//ASL made by Meta and KunoDemetries
/*
    Kuno notes:
    Just wanted to say thank you to Mr. Meta, Speedrun.com, and the Jetrunner development team for giving me the opportunity to work on the ASL with them.
    The game is really addicting and genuinely the most fun I've had with a platformer-esk game like this. 

    The ASL is pretty base for an unreal engine system game, nothing flashy. 
*/

state("JetrunnerGame") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.GameName = "JETRUNNER";
	vars.Helper.AlertLoadless();
	vars.completedSplits = new List<string>();
    vars.LevelsEntered = new List<string>();
    vars.LevelsEntered.Add("Jetrunner");

    vars.Stopwatch = new Stopwatch();

		//Autosplitter Settings Creation
		dynamic[,] _settings =
		{
		{ "Level Splits", true, "Level Splits", null },
		{"GameInfo", 					true, "Print Various Game Info",						null},
			{"Level",                   true, "Current Level",                                 "GameInfo"},
            {"mIGT",                   false, "Current marathon IGT",                                 "GameInfo"},
            {"placeholder",                   false, "placeholder",                                 "GameInfo"},
		};
		vars.Helper.Settings.Create(_settings);
		
        vars.missions2 = new Dictionary<string,string> 
	    { 	
            //{"Ready","Ready"},
            {"EnterJetLeap","Enter Jet Leap"},
            {"Pillars","Pillars"},
            {"TheOldTracks", "The Old Tracks"},
            {"Serenity", "Serenity"},
            {"RoundRave", "Round Rave"},
            {"Unstoppable", "Unstoppable"},
            {"RiseAndFall", "Rise & Fall"},
            {"AmmoClimb", "Ammo Climb"},
            {"Fortress", "Fortress"},
            {"Kickoff_WB", "Kickoff"},
            {"EnterJetSlam_WB", "Enter Jet Slam"},
            {"ComingThrough_WB", "Coming Through"},
            {"Belfries_WB", "The Belfries"},
            {"EnterJetJelly_WB", "Enter Jet Jelly"},
            {"Reinforcements_WB", "Reinforcements"},
            {"ArmsRace_WB", "Arms Race"},
            {"Bombardier_WB", "Bombardier"},
            {"Limbo_WB", "Limbo"},
            {"Infiltration_WB", "Infiltration"},
            {"Lobby_WB", "Lobby"},
            {"Escalation_02", "Escalation"},
            {"Facade_WB_02", "Facade"},
            {"Fastlane_RobinEdit_03", "Fast Lane"},
            {"BreakSpeed_02", "Break Speed"},
            {"Highroller_02", "Highroller"},
            {"TheTowerWithin_02", "The Tower Within"},
            {"EnterJetHook_02", "Enter Jet Hook"},
            {"OnTheRopes_02", "On The Ropes"},
            {"Spire_WB", "The Spire"},
            {"Harbor_WB", "Harbor"},
            {"IceIsNice_WB", "Ice Is Nice"},
            {"GripAndSlide_WB", "Grip 'n' Slide"},
            {"ThroughTheWindow_WB", "Through the Window"},
            {"Iceberg_WB", "Iceberg"},
            {"CrossIce_WB", "Cross Iced"},
            {"Skater_WB", "Figure Skater"},
            {"IceClimber_WB", "Ice Climber"},
            {"RimeRim_WB", "Rime Rim"},
            {"TheDistance_WB", "The Distance"},
            {"StageSet_WB", "Stage Set"},
            {"EnterJetFreeze_WB", "Enter Jet Freeze"},
            {"Cooldown_WB", "Cooldown"},
            {"Disco_WB", "Disco"},
            {"Stagefright_WB", "Stage Fright"},
            {"Hopper_WB", "Hopper"},
            {"PolarShift_WB", "Polar Shift"},
            {"Shutdown_WB", "Shutdown"},
            {"Watchtower_WB", "Watchtower"},
            {"KeepItCool_WB", "Keep It Cool"},
            {"SacredGrounds_WB", "Sacred Grounds"},
            {"Skydiving_WB", "Skydiving"},
            {"Crevasse_WB", "The Crevasse"},
            {"JetValley_WB", "Jet Valley"},
            {"DoubleTrouble_WB", "Double Trouble"},
            {"HookJungle_WB", "Hook Jungle"},
            {"HighTech_WB", "High Tech"},
            {"TheGreatWall_WB", "The Great Wall"},
            {"CoolCoolMountain_WB", "Cool Cool Mountain"},
            {"TheSummit_WB", "The Summit"},
           // {"", ""},
         //   {"", ""},
        //    {"", ""},

        };
 	    foreach (var Tag in vars.missions2)
	    {
	    	settings.Add(Tag.Key, true, Tag.Value, "Level Splits");
        };



		vars.lcCache = new Dictionary<string, LiveSplit.UI.Components.ILayoutComponent>();
		vars.SetText = (Action<string, object>)((text1, text2) =>
		{
			const string FileName = "LiveSplit.Text.dll";
			LiveSplit.UI.Components.ILayoutComponent lc;

			if (!vars.lcCache.TryGetValue(text1, out lc))
			{
				lc = timer.Layout.LayoutComponents.Reverse().Cast<dynamic>()
					.FirstOrDefault(llc => llc.Path.EndsWith(FileName) && llc.Component.Settings.Text1 == text1)
					?? LiveSplit.UI.Components.ComponentManager.LoadLayoutComponent(FileName, timer);

				vars.lcCache.Add(text1, lc);
			}

			if (!timer.Layout.LayoutComponents.Contains(lc)) timer.Layout.LayoutComponents.Add(lc);
			dynamic tc = lc.Component;
			tc.Settings.Text1 = text1;
			tc.Settings.Text2 = text2.ToString();
		});
		vars.RemoveText = (Action<string>)(text1 =>
		{
			LiveSplit.UI.Components.ILayoutComponent lc;
			if (vars.lcCache.TryGetValue(text1, out lc))
			{
				timer.Layout.LayoutComponents.Remove(lc);
				vars.lcCache.Remove(text1);
			}
		});
        
}

init
{
	//Pointer Bool Vars, lets us set up so we can keep the script going even when one or more pointers are null
    
    vars.hasWorldPtr   = false;
	vars.hasCamPtr     = false;
    vars.hasCampaignIDPtr = false;
    vars.hasIndividualIGTPtr     = false;
    vars.hasMarathonIGTPtr     = false;
/*
    GEngine - SBGameInstance(1248) - CurrentCampaign(1D8) - CampaignId(030)/CampaignName(038)/CampaignDescription(048) might work
    GEngine - SBGameInstance(1248) - SBLocalPlayer[0](38) - StateName(2E0)

    ?? GameSession - SessionName(2B8 - FName)
*/

	//Sig Scans
	IntPtr gWorld  = vars.Helper.ScanRel(3, "48 8B 1D ?? ?? ?? ?? 48 85 DB 74 ?? 41 B0");
	IntPtr gEngine = vars.Helper.ScanRel(3, "48 8b 0d ?? ?? ?? ?? 48 85 c9 74 ?? 48 8b 89 ?? ?? ?? ?? 48 85 c9 74 ?? 48 8b 01 ff 50 ?? 88 06");
	IntPtr fNamePool = vars.Helper.ScanRel(3, "48 8d 05 ?? ?? ?? ?? eb ?? 48 8d 0d ?? ?? ?? ?? e8 ?? ?? ?? ?? c6 05 ?? ?? ?? ?? ?? 0f 10 07");
    print(gWorld.ToString("X"));
	vars.Helper["WorldFName"]         = vars.Helper.Make<ulong>(gWorld, 0x18);    vars.hasWorldPtr    = true;
    vars.Helper["IndividiaulIGT"]         = vars.Helper.Make<float>(gWorld, 0x1B0, 0x230, 0x20, 0x194);    vars.hasIndividualIGTPtr    = true; 
    vars.Helper["MarathonIGT"]         = vars.Helper.Make<float>(gWorld, 0x1B0, 0x230, 0x20, 0x214);    vars.hasMarathonIGTPtr    = true; 
    // GEngine - SBGameInstance(1248) - CurrentCampaign(1D8) - CampaignId(030)
	vars.Helper["campaignIDName"] = vars.Helper.Make<ulong>(gEngine, 0x1248, 0x1D8, 0x038); 
   
        print("  hasWorldPtr   = " + vars.hasWorldPtr);
        print("  hasIGTPtr= " +      vars.hasIndividualIGTPtr);

    //FName Reader (define before RefreshNames)
	vars.FNameToString = (Func<ulong, string>)(fName =>
		{
			var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
			var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
			var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

			// IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
			IntPtr chunk = vars.Helper.Read<IntPtr>(fNamePool + 0x10 + (int)chunkIdx * 0x8);
			IntPtr entry = chunk + (int)nameIdx * sizeof(short);

			int length = vars.Helper.Read<short>(entry) >> 6;
			string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

			return number == 0 ? name : name + "_" + number;
		});
    
    vars.RefreshNames = (Action)(() =>
    {
        current.World = vars.FNameToString(current.WorldFName);
        current.campaignID = vars.FNameToString(current.campaignIDName); 
    });

    //Text Component Part 2
    vars.SetTextIfEnabled = (Action<string, object>)((text1, text2) =>
		{
			if (settings[text1]) vars.SetText(text1, text2); 
			else vars.RemoveText(text1);
		});

    // defaults
	current.World     = "";
	current.camTarget = "";
    current.mapPretty = "";
    current.timerStarted = 0;
    current.campaignID = "";
    vars.attemptTime = 0f;
    vars.newinigt = 0f;
    current.CurTimingMethod = 0; // 0 = we haven't figured out the player's intentions; 1 = we're doing a marathon run; 2 = new game runs
    vars.runhasleftstart = 0;
    vars.previousinigt = 0f;
    vars.added = 0;
    vars.split = 0; 
    vars.lastCount = vars.LevelsEntered.Count;
    vars.Helper.Update();
    vars.Helper.MapPointers();
    ((Action)vars.RefreshNames)();
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();
    ((Action)vars.RefreshNames)();

    vars.SetTextIfEnabled("Level", current.mapPretty);
    vars.SetTextIfEnabled("mIGT", current.IndividiaulIGT);

    if (current.CurTimingMethod == 0)
        vars.SetTextIfEnabled("placeholder", "we're not in marathon");
    if (current.CurTimingMethod == 1)
        vars.SetTextIfEnabled("placeholder", "we're in marathon");

    // Null check
    if (String.IsNullOrWhiteSpace(current.World)) { current.mapPretty = "No Map Detected"; }

    // Pretty map name
    if (!String.IsNullOrWhiteSpace(current.World))
    {
        var mapFullString = current.World.ToString();
        var mapFirstIndex = mapFullString.IndexOf("_");
        if (current.World != null)
        {
            if (mapFirstIndex != -1) current.mapPretty = mapFullString.Substring(mapFirstIndex + 1);
            else current.mapPretty = "No Map Detected";
        }
    }

    // Initialize newinigt for second level
    if (vars.LevelsEntered.Count == 2 && current.timerStarted == 1)
    {
        vars.attemptTime = current.IndividiaulIGT;
        //vars.attemptTime = vars.newinigt;
    }

    // Level count >=3 logic
    if (current.timerStarted == 1 && vars.LevelsEntered.Count >= 3)
    {
        if (vars.lastCount >= 3)
        {
            vars.newinigt = current.MarathonIGT;
        }
    }
    
    // Detect new level
    if (current.timerStarted == 1 && !vars.LevelsEntered.Contains(current.mapPretty) && (current.World != old.World) && vars.missions2.ContainsKey(current.mapPretty))
    {

        vars.previousinigt = current.IndividiaulIGT;
        vars.LevelsEntered.Add(current.mapPretty);
        vars.runhasleftstart = 1;
        vars.lastCount = vars.LevelsEntered.Count;

            // Switch to marathon timing
        if (current.CurTimingMethod == 0)
        {
            if (vars.LevelsEntered.Count >= 3)
            {
                vars.Stopwatch.Start();
                print("starting stop watch, current marathon time is:" + current.MarathonIGT);
            }
        }

        if (vars.LevelsEntered.Count > 3) 
        {
            // Add last segment’s time
            vars.attemptTime += vars.newinigt;
            vars.newinigt = 0f; // reset for next segment
            print("[Debug] Added old.MarathonIGT to attemptTime: " + old.MarathonIGT + " -> attemptTime now " + vars.attemptTime);
        }

        if (!string.IsNullOrWhiteSpace(current.mapPretty)          // Make sure we actually have something, not null/empty/"??"
        && settings.ContainsKey(current.mapPretty)             // Make sure LiveSplit’s settings dictionary has this key
        && settings[current.mapPretty]                         // And that the runner left it ticked in the UI
        && !vars.completedSplits.Contains(current.mapPretty)   // And that we haven’t already split on it)
        )
        {
            vars.split = 1;
            vars.completedSplits.Add(current.mapPretty);

            print("split for" + current.mapPretty);
        }
    }

        if (vars.Stopwatch.Elapsed.TotalMilliseconds >= 800 && current.CurTimingMethod != 1)
    {
        if (current.MarathonIGT > 1 && vars.LevelsEntered.Count == 3)
        {
            current.CurTimingMethod = 1;
            print("[Debug] CurTimingMethod switched to 1 (marathon)");
        }
        else
        {
            vars.Stopwatch.Reset();
                        print("stopping stop watch, current marathon time is:" + current.MarathonIGT);

        }
    }

}



onStart
{
    //Add the start split to the dictionary
    var id = current.mapPretty; 
    current.timerStarted = 1;
    vars.completedSplits.Add(id);
    vars.LevelsEntered.Add(id);
    vars.lastCount = vars.LevelsEntered.Count;
}

isLoading
{
    return true;
}

start
{
    current.CurTimingMethod = 0;
    var id = current.mapPretty;                 // Store so we don't repeatedly read a potentially changing value from memory, and to ensure we can safely check/skip if it's null, empty, whitespace, or a placeholder like "??"
    var oid = old.mapPretty;
    return ((oid == id) && (current.IndividiaulIGT != 0) && (old.IndividiaulIGT == 0));
}

gameTime
{
    var id = current.mapPretty;                 // Store so we don't repeatedly read a potentially changing value from memory, and to ensure we can safely check/skip if it's null, empty, whitespace, or a placeholder like "??"
    var oid = old.mapPretty;
    var newmarigt = current.MarathonIGT;

    switch ((int)current.CurTimingMethod) 
    {
        case    0: // newgame

        if (current.timerStarted == 1)
        {
            return TimeSpan.FromSeconds(vars.attemptTime + vars.newinigt);
        }

        break;

        case    1: // marathon
        {
            // If map is the same and time is moving forward
            vars.attemptTime = newmarigt;
            return TimeSpan.FromSeconds(vars.attemptTime);

        }; 
        break;
    } 
}

onReset
{
    current.timerStarted = 0;
    vars.added = 0;
    vars.attemptTime = 0;
    vars.newinigt = 0f;
    vars.completedSplits.Clear();
    vars.LevelsEntered.Clear();
    vars.LevelsEntered.Add("Jetrunner");
    vars.runhasleftstart = 0;
    vars.lastCount = vars.LevelsEntered.Count;
}

split
{
    if (  vars.split == 1 )
    {
            vars.split = 0; 
        return true;
    }


}

