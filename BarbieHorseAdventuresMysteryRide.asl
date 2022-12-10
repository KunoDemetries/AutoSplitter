state("Barbie Horse")
{
    byte loading : 0x37720C;
    string90 CurMiniGame : 0x0037933C, 0x90;
    string110 CurAudio : "fmod.dll", 0x0003B044, 0x212;
    string100 CurMap : 0x36F5ED;
}

init
{
    vars.doneMaps = new List<string>();
    vars.OldMinigame = string.Empty;
}

startup
{
        settings.Add("Loc", true, "Split on leaving Prairie Town & Entering Cave?"); 

    	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    	var timingMessage = MessageBox.Show 
        (
           "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | Barbie Horse Adventures: Mystery Ride",
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
    current.Minigame = current.CurMiniGame.ToUpper();

    if ((current.Minigame.Contains("SUBGAMES"))  && (current.loading == 1))
    {
        vars.OldMinigame = current.Minigame;
    }
}

start
{
    return ((current.Minigame != old.CurMiniGame) && (current.CurMiniGame.Contains("Worlds")) && (current.loading == 0));
}

split
{
    if ((current.Minigame != vars.OldMinigame) && (!vars.doneMaps.Contains(vars.OldMinigame)) && (vars.OldMinigame.Contains("SUBGAMES")))
    {
        vars.doneMaps.Add(vars.OldMinigame);
        return true;
    }

    if (((settings["Loc"]) && (current.CurMap.Contains("=LnW") || (current.CurMap.Contains("=DnW")))) && (current.loading == 1) && (!vars.doneMaps.Contains(current.CurMap)))
    {
        print("split on" + current.CurMap);
        vars.doneMaps.Add(current.CurMap);
        return true;
    }

    return (current.CurAudio == "\\VOICEOVER\\ENGLISH\\GENERALAUDIO_103.WAV");
}

reset
{
    return (current.CurMiniGame == "\\FRONTEND\\UP_ARROW_GOLD.PNG");
}

onReset
{
    vars.OldMinigame = String.Empty;
    vars.doneMaps.Clear();
}

isLoading
{
    return (current.loading == 1);
}