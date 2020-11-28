state("BlackOpsColdWar")
{
    byte round : 0x10CE3958;
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

start
{
    return (current.round == 1);
}

split
{
    string currentMap = (current.round.ToString());

    if ((settings[currentMap]) && (current.round != old.round))    
    {
        return true;
    }
}