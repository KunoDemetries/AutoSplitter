// An Autosplitter made for BOCW for zombies
// This usually will have some bugs just because online MP will always be trash
// Message KunoDemetries#6969 on discord if there is a problem or join the zombies discord 
state("BlackOpsColdWar")
{
    int round : 0xFC390E4; // A built in counter for rounds (TY 3arc)
    int loading1 : 0xE179120; // taken from the campaign load remover because it works here

}

startup
{
    settings.Add("rounders", false, "Round Splits"); // A grouping for settings for rounds
    

    vars.rounds = new Dictionary<string,string> // creating a string dictionary
    {
        {"2","Round 2"},
        {"3","Round 3"},
        {"4","Round 4"},
        {"5","Round 5"},
        {"10","Round 10"},
        {"15","Round 15"},
        {"30","Round 30"},
        {"50","Round 50"},
        {"70","Round 70"},
        {"100","Round 100"},
    };

 	foreach (var Tag in vars.rounds) // setting each variable in the Dictionary to the word tag rounders to link it to the master setting
	{
	    settings.Add(Tag.Key, true, Tag.Value, "rounders");
    }; 

    
  	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
		vars.doneMaps.Clear(); //clear the done rounds if the run was reset
      	 	vars.starter = true; // setting the gameTimer to true
        });

        timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Call of Duty: Black Ops Cold War Zombies",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }
}

init // creating strings just for functioning the split and start a little clearer 
{
    vars.doneMaps = new List<string>(); 
    vars.starter = false; // used to activate the gameTime setting
}

start
{
    if ((current.round == 1) && (current.loading1 != 0)) // if round is 1 and loading is done start
    {
		vars.doneMaps.Clear(); //clear the done rounds if the run was reset
       vars.starter = true; // setting the gameTimer to true
        return true; // returning true to start the timer
    }
}

split
{
    if ((settings[(current.round.ToString())]) && (current.round != old.round) && (!vars.doneMaps.Contains((current.round.ToString()))))    
    {
		vars.doneMaps.Add(current.round.ToString());		
        return true;
    }
}

gameTime
{
    if ((vars.starter == true) && (current.round == 1) && (current.loading1 != 0) && (current.loading1 == 1)) // doing a check if were actually playing
    {
        vars.starter = false; //setting the starter to false for the next run (could also do this in reset)
        return TimeSpan.FromSeconds(-10); // removing 10 seconds to match up with the timing method (could also be used to add time)
    }
}

reset
{
    if (current.round == 0) // if you're back in main menu round is 0
    {
        return true;
    }
}
