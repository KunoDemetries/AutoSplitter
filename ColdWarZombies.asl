state("BlackOpsColdWar")
{
    int round : 0xF5F945C;
}

startup
{
    settings.Add("rounders", false, "Round Splits");
    

    vars.rounds = new Dictionary<string,string>
    {
        {"5","Round 5"},
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
        return true;
		vars.doneMaps.Clear();
    }
}

split
{
    string currentMap = (current.round.ToString());

    if ((settings[currentMap]) && (current.round != old.round) && (!vars.doneMaps.Contains(currentMap)))    
    {
		vars.doneMaps.Add(old.map);		
        return true;
    }
}

reset
{
    return (current.round == 0);
}
