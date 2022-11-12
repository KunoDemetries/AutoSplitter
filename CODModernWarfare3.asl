 state("iw5sp")
{
    int loading1 : 0x19ECCC4;
    string200 map : 0x18002C0;
    int poser : 0x18002C3;
    int dad : 0x5AC158;
}

startup 
{

    settings.Add("missions", true, "Missions");

    vars.diamond1 = new Dictionary<string,string> 
        { 
            {"sp_ny_harbor", "Hunter Killer"}, 
            {"sp_intro", "Persona Non Grata"},
            {"hijack", "Turbulence"},
            {"sp_warlord", "Back on the Grid"},
            {"london", "Mind the Gap"},
            {"hamburg", "Goalpost"},
            {"sp_payback", "Return To Sender"},
            {"sp_paris_a", "Bag and Drag"},
            {"paris_ac130", "Iron Lady"},
            {"sp_prague", "Eye of the Storm"},
            {"prague_escape", "Blood Brothers"}, 
            {"castle", "Stronghold"},
            {"sp_berlin", "Scorched Earth"},
            {"rescue_2", "Down the Rabbit Hole"},
            {"sp_dubai", "Dust to Dust"},
        };  
         foreach (var Tag in vars.diamond1)
        {
            settings.Add(Tag.Key, true, Tag.Value, "missions");
        };

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Call of Duty: Modern Warfare 3",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }    
}

split
{
    return ((current.map != old.map) && (settings[current.map]));
}
 
start
{
    return ((current.map == "sp_ny_manhattan") && (current.dad != 0) && (current.loading1 != 0));
}
 
reset
{
    return ((current.poser == 0) && (old.poser != 0));
}

isLoading
{
    return (current.loading1 == 0);
}
