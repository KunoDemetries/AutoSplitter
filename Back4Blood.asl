state("Back4Blood", "Xbox Game Pass v1.0.3")
{
    int Loader : 0x666CE20;
    string100 CurrentLevel : 0x067DD4A0, 0xC58, 0X0, 0XF8, 0X3E;
}

state("Back4Blood", "Xbox Game Pass v1.0.5")
{
    int Loader : 0x62A3DB8;
    string100 CurrentLevel : 0x06445F58, 0x10, 0x8, 0x48, 0x0;
}

state("Back4Blood", "Steam V1.13")
{
    int Loader : 0x6490FE8;
    string100 CurrentLevel : 0x0667C630, 0x10, 0x8, 0x48, 0x0;
}

state("Back4Blood", "Steam v1.0.5")
{
    int Loader : 0x64817F8;
    string100 CurrentLevel : 0x066238E8, 0x10, 0x8, 0x48, 0x0;
}

state("Back4Blood", "Steam v1.0.3")
{
    int Loader : 0x640B558;
    string100 CurrentLevel : 0x065A74F8, 0x10, 0x8, 0x48, 0x0;
}

state("Back4Blood", "Steam v1.0.0")
{
    int Loader: 0x67D6FA8; 
    string100 CurrentLevel : 0x0655B9A8, 0x10, 0x8, 0x48, 0x0;
}

init
{
	vars.doneMaps = new List<string>();

    switch (modules.First().ModuleMemorySize) 
    {
        case    486912000: version = "Xbox Game Pass v1.0.3";
            break;
        case    496152576: version = "Xbox Game Pass v1.0.5";
            break;
        case  491970560 : version = "Steam V1.13";
            break;
        case    485240832: version = "Steam v1.0.5";
            break;
        case    489611264: version = "Steam v1.0.3"; 
            break;
        case    520429568: version = "Steam v1.0.0"; 
            break;
        default:        version = ""; 
            break;
    }
    vars.Loading = false;
}

startup
{
    settings.Add("B4B", true, "Back 4 Blood");
    settings.Add("A1", true, "ACT 1 - RESURGENCE", "B4B");
        settings.Add("TDR", true, "THE DEVIL'S RETURN", "A1");
        settings.Add("SAR", true, "SEARCH & RESCUE", "A1");
        settings.Add("TDBTD", true, "THE DARK BEFORE DAWN", "A1");
        settings.Add("BDH", true, "BLUE DOG HOLLOW", "A1");
    settings.Add("A2", true, "ACT 2 - A CALL TO ARMS", "B4B");
        settings.Add("TA", true, "THE ARMORY", "A2");
        settings.Add("PB", true, "PLAN B", "A2");
        settings.Add("JOB", true, "JOB 10:222", "A2");
    settings.Add("A3", true, "ACT 3 - FARTHER AFIELD", "B4B");
        settings.Add("DRN", true, "DR.ROGERS NEIGHBORHOOD", "A3");
        settings.Add("REM", true, "REMNANTS", "A3");
    settings.Add("MAP_PERS_TitanTunnels", true, "ACT 4 - THE ABOMINATION", "B4B");

      var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    	var sB = new List<Tuple<string, string, string>>

    {
        //tB("","",""),
        tB("TDR","MAP_PERS_Evansburgh_A","RESURGENCE"),
        tB("TDR","MAP_PERS_Evansburgh_B","TUNNEL OF BLOOD"),
        tB("TDR","MAP_PERS_Evansburgh_C","PAIN TRAIN"),
        tB("TDR","MAP_PERS_Evansburgh_D","THE CROSSING"),
        tB("SAR","MAP_PERS_Finleyville_Rescue_A","A CLEAN SWEEP"),
        tB("SAR","MAP_PERS_Finleyville_Rescue_B","BOOK WORMS"),
        tB("SAR","MAP_PERS_Finleyville_Rescue_C","BAR ROOM BLITZ"),
        tB("TDBTD","MAP_PERS_Finleyville_Diner_A","SPECIAL DELIVERY"),
        tB("TDBTD","MAP_PERS_Finleyville_Diner_B","THE DINER"),
        tB("BDH","MAP_PERS_Bluedog_A","BAD SEEDS"),
        tB("BDH","MAP_PERS_Bluedog_B","HELL'S BELLS"),
        tB("BDH","MAP_PERS_Bluedog_C","ABANDONED"),
        tB("BDH","MAP_PERS_Bluedog_D","THE SOUND OF THUNDER"),
        tB("TA","MAP_PERS_Finleyville_Police_A","A CALL TO ARMS"),
        tB("TA","MAP_PERS_Finleyville_Police_B","THE HANDY MAN"),
        tB("PB","MAP_PERS_TheClog_A","PIPE CLEANERS"),
        tB("PB","MAP_PERS_TheClog_B","HINTERLAND"),
        tB("PB","MAP_PERS_TheClog_C","TRAILER TRASHED"),
        tB("PB","MAP_PERS_TheClog_D","THE CLOG"),
        tB("PB","MAP_PERS_TheClog_E","THE BROKEN BIRD"),
        tB("JOB","MAP_PERS_Finleyville_Church_A","HERALDS OF THE WORM PART 1"),
        tB("JOB","MAP_PERS_Finleyville_Church_B","HERALDS OF THE WORM PART 2"),
        tB("JOB","MAP_PERS_Finleyville_Church_C","GRAVE DANGER"),
        tB("DRN","MAP_PERS_Manor_A","FARTHER AFIELD"),
        tB("DRN","MAP_PERS_Manor_B","BLAZING TRAILS"),
        tB("DRN","MAP_PERS_Manor_C","CABINS BY THE LAKE"),
        tB("DRN","MAP_PERS_Manor_D","GARDEN PARTY"),
        tB("DRN","MAP_PERS_Manor_E","T-5"),
        tB("REM","MAP_PERS_CDC_A","A FRIEND IN NEED"),
        tB("REM","MAP_PERS_CDC_B","MAKING THE GRADE"),
        tB("REM","MAP_PERS_CDC_C","THE ROAD TO HELL"),
        tB("REM","MAP_PERS_CDC_D","THE BODY DUMP"),
      };
    	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | BACK 4 BLOOD",
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
    if ((current.Loader == 0) || (current.CurrentLevel == "MAP_PERS_FortHope_A"))
    {
        vars.Loading = true;
    }
}

start
{
    return ((settings[current.CurrentLevel]) && (current.Loader != 0));
}

onStart
{
	vars.doneMaps.Add(current.CurrentLevel);
}

isLoading
{
    return (vars.Loading);
}

split
{
    if (!vars.doneMaps.Contains(current.CurrentLevel) && (settings[current.CurrentLevel]) && (current.CurrentLevel != old.CurrentLevel))
    {
        vars.doneMaps.Add(current.CurrentLevel);
        return true;
    }
}

onReset
{
    vars.doneMaps.Clear();
}