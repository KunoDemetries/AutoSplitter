state("Spiderwick")
{
    int cutscenes : 0xAE4DB0;
    int cinematics : 0x32C4A8;
    int loading1 : 0xA356B8;
    string25 playarea : 0xA57F68;
    string20 chapter : 0x2E47A5;
	//string20 levels : 0xA57F88; just keeping in case I want to add it back
}

startup 
{
	settings.Add("chapters", false, "Chapter Splits");
    
	vars.Chapters = new Dictionary<string,string> 
		{
    	    {"Chapter1","Chapter 1"},
    	    {"Chapter2","Chapter 2"},
    	    {"Chapter3","Chapter 3"},
    	    {"Chapter4","Chapter 4"},
    	    {"Chapter5","Chapter 5"},
    	    {"Chapter6","Chapter 6"},
    	    {"Chapter7","Chapter 7"},
    	    {"Chapter8","Chapter 8"},
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
            "LiveSplit | The Spiderwick Chronicles",
           MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );    
    	if (timingMessage == DialogResult.Yes)
        	{
    	        timer.CurrentTimingMethod = TimingMethod.GameTime;
	        }
    }	
}

start
{
    return ((current.playarea != "shell") && (old.playarea == "shell"));
}

split
{ 
	return ((current.chapter != old.chapter) && (settings[(current.chapter)]));
}

reset
{
    return (current.playarea =="shell");
}

isLoading
{
    return (current.loading1 == 1);
}
