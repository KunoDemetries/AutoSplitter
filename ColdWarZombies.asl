// An Autosplitter made for BOCW for zombies
// This usually will have some bugs just because online MP will always be trash
// Message KunoDemetries#6969 on discord if there is a problem or join the zombies discord 
state("BlackOpsColdWar")
{
    int round : 0xFC8434C;
    int loading1 : 0xEC61758;

}

startup
{
    settings.Add("rounders", false, "Round Splits");
    

    vars.rounds = new Dictionary<string,string>
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

 	foreach (var Tag in vars.rounds)
	{
	    settings.Add(Tag.Key, true, Tag.Value, "rounders");
    };    
}

init
{
    vars.doneMaps = new List<string>(); 
    vars.starter = false;
}

start
{
    if ((current.round == 1) && (current.loading1 != 0))
    {
		vars.doneMaps.Clear();
       vars.starter = true;
        return true;
    }
}

split
{
    string currentMap = (current.round.ToString());

    if ((settings[(current.round.ToString())]) && (current.round != old.round) && (!vars.doneMaps.Contains((current.round.ToString()))))    
    {
		vars.doneMaps.Add(current.round.ToString());		
        return true;
    }
}

gameTime
{
    if ((vars.starter == true) && (current.round == 1) && (current.loading1 != 0) && (current.loading1 == 1))
    {
        vars.starter = false;
        return TimeSpan.FromSeconds(-10);
    }
}

reset
{
    if (current.round == 0)
    {
        return true;
    }
}
