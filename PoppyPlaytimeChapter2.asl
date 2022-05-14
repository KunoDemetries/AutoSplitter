/* Pretty much a very straight forward ASL; I wish the int CurCheckpoint was consistent throughout the game. It somewhat dies towards checkpoint 10 and there is no other memory address I found.
However; through the save file is pretty much the most "Won't break with update," thing I've made thus far so I can't complain. 

Made by: Kuno Demetries
Discord: Kuno Demetries#6969
Linktree: https://linktr.ee/KunoDemetries
*/
state("Playtime_Prototype4-Win64-Shipping", "Steam Version 1.2")
{
    int CurCheckpoint : 0x04D2EEE0, 0x118, 0x2E4; // Can be found by searching for .PersistentLevel.Chapter2_Gamemode_C and adding 0x2e4
    int GameLoaded : 0x04D2EEE0, 0x118, 0x2F8; // Can be found by searching for .PersistentLevel.Chapter2_Gamemode_C and adding 0x2F8
    int IsPaused : 0x04D2B5C8, 0x8A8; // search for a byte 1 paused/ 0 not
    float X : 0x04D2B580, 0x8, 0x8, 0x190, 0x22C; // cheat engine dumper -> player controller -> lastupdatedxvalue
    float LeverPulled : 0x04D2EEE0, 0x260, 0x0, 0xA0, 0x5D8, 0x2A0; // TrainStopLever_C TrainBlueprints.TrainBlueprints.PersistentLevel.TrainStopLever2
}

init
{
    vars.CurCheckpoint = null;
    vars.doneMaps = new List<string>();
    vars.Combination = "1423";
   
    switch (modules.First().ModuleMemorySize) 
    {
        case    85676032: version = "Steam Version 1.2";
            break;
        default:        version = "Steam Version 1.2"; 
            break;
    } 
}

startup
{
    settings.Add("chap", true, "Poppy Playtime: Chapter 2");

    vars.Chapters = new Dictionary<string,string> 
	{
        {"01", "Fixed power, and Opened B/R Door"},
        {"02", "After sliding down the blue slide"},
        {"03", "Fixed power section 2"},
        {"04", "Mommy's Monologue Finished"},
        {"05", "Entering Molding Room"},
        {"06", "Green Hand Fixed"},
        {"07", "Entering Musical Memory"},
        {"08", "End of introuction to Musical Memory, starting game"},
        {"09", "End of round 1 of Musical Memory"},
        {"0A", "End of round 2 of Musical Memory"},
        {"0B", "End of round 3 of Musical Memory"},
        {"0C", "End of round 4 of Musical Memory"},
        {"0D", "Entering Product Storage"},
        {"0E", "Leaving Product Storage"},
        {"0F", "Return to Train Section"},
        {"10", "Entering Wack-A-Wuggy"},
        {"11", "End of introuction to Wack-A-Wuggy, starting game"},
        {"12", "End of Wack-A-Wuggy"},
        {"13", "Entering Cart Corridors"},
        {"14", "Pushing Barry The Cart down the trackway (Returning to Hub)"},
        {"15", "Entering Statues"},
        {"16", "Fixed electricty to statues"},
        {"17", "Start of statues"},
        {"18", "Leaving statues"},
        {"1A", "Water Treatment"},
        {"1B", "Leaving Water Treatment"},
        {"1C", "Fixed electricty in the underground"},
        {"1D", "Hide and Seek with Mommy"},
        {"1E", "Power lever section"},
        {"1F", "Finished Power lever section"},
        {"20", "Hide from mommy"},
        {"22", "Chase scene through tunnels with mommy"},
        {"23", "Entering hallway, past the tunnel section"},
        };
        foreach (var Tag in vars.Chapters)
	    {
	    	settings.Add(Tag.Key, true, Tag.Value, "chap");
        };

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | POPPY PLAYTIME: CHAPTER 2",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    vars.SetTextComponent = (Action<string, string>)((id, text) =>
    {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });
	settings.Add("Combo_Setting", true, "Current Combination");
}

update
{
    string CurTrain = null;
    string CurTrainHex = "00-54-72-61-69-6E-43-6F-64-65-56-61-72-69-61-74-69-6F-6E-49-6E-55-73-65-00-0C-00-00-00-49-6E-74-50-72-6F-70-65-72-74-79-00-04-00-00-00-00-00-00-00-00-";
    string CurCheckpointHex = "43-68-65-63-6B-70-6F-69-6E-74-00-0C-00-00-00-49-6E-74-50-72-6F-70-65-72-74-79-00-04-00-00-00-00-00-00-00-00-";

    if ((current.GameLoaded == 1))
    {
        string logPath = Environment.GetEnvironmentVariable("AppData")+"\\..\\local\\Playtime_Prototype4\\Saved\\SaveGames\\Chap2Checkpoint.sav";
            
        byte[] data = File.ReadAllBytes(logPath);
        string hex = BitConverter.ToString(data);

        int traincode = hex.IndexOf(CurTrainHex);
        int checkpoint = hex.IndexOf(CurCheckpointHex);
        if ((traincode != -1) || (checkpoint != -1))
        {
            CurTrain = hex.Substring(traincode + CurTrainHex.Length, 2);
            vars.CurCheckpoint = hex.Substring(checkpoint + CurCheckpointHex.Length, 2);
        }

        if (settings["Combo_Setting"]) 
        {
            switch (CurTrain) 
            {
                case "00" : vars.Combination = "1423"; 
                    break;
                case "01" : vars.Combination = "2431"; 
                    break;
                case "02" : vars.Combination = "1324";
                    break;
                case "03" : vars.Combination = "4312"; 
                    break;
                case "04" : vars.Combination = "3241"; 
                    break;
                case "05" : vars.Combination = "4213"; 
                    break;
                case "06" : vars.Combination = "3124"; 
                    break;
                case "07" : vars.Combination = "2314"; 
                    break;
                case "08" : vars.Combination = "4231"; 
                    break;
                case "09" : vars.Combination = "1243"; 
                    break;
                default:  vars.Combination = "1423"; 
                    break;
            }
            vars.SetTextComponent("Current Combination:", (vars.Combination.ToString())); 
        }
    }
    print(vars.CurCheckpoint);
}

start
{
    return ((current.CurCheckpoint == 0) && (current.GameLoaded == 1) && (current.X != 0));  //bad as it'll start everywhere but you know
}

onReset
{
    vars.doneMaps.Clear();
}

split
{
    if ((settings[vars.CurCheckpoint.ToString()]) && (!vars.doneMaps.Contains(vars.CurCheckpoint.ToString())))
    {
        vars.doneMaps.Add(vars.CurCheckpoint.ToString());
        return true;
    }

    return ((current.LeverPulled == 1));
}

isLoading
{
    return ((current.GameLoaded == null) || (current.GameLoaded == 0) || (current.IsPaused == 1));
}
