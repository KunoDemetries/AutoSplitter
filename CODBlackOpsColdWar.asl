state("BlackOpsColdWar")
{
    int round : 0xFC8434C;
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
}

start
{
    if (current.round == 1)
    {
		vars.doneMaps.Clear();
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

reset
{
    if (current.round == 0)
    {
        return true;
    }
}
