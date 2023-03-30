state("FAITH")
{
    int CurRoom : 0x6C4DB8;
    byte inCutscene : 0x004B477C, 0x0, 0x68, 0x10, 0x80;
}

init
{
    vars.doneMaps = new List<string>(); 
    vars.CurRoomToString = "";

	vars.sheepcounter = "";
	
}

startup
{
    settings.Add("Faith", true, "Faith: The Unholy Trinity");
    settings.Add("Ch1", true, "Faith: Chapter One", "Faith");
    settings.Add("Ch2", true, "Faith: Chapter Two", "Faith");
    settings.Add("Ch3", true, "Faith: Chapter Three", "Faith");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>>
    {
        tB("Ch1", "353", "Start of Chapter 1"),
        tB("Ch1", "375", "Entering Worn-Down, Ugly, Brown, Shack"),
        tB("Ch1", "397", "Entering Worn-Down, Ugly, Red, House"),
        tB("Ch1", "349", "Amy climbs into bed for cuddles"),
        tB("Ch1", "410", "Entering Attic"),
        tB("Ch1", "348", "Title Card"),
        tB("Ch2", "425", "Beginning Room"),
        tB("Ch2", "515", "Descending beneath Chapel"),
        tB("Ch2", "468", "Spider transformation complete"),
        tB("Ch2", "517", "Title Card"),
        tB("Ch3", "112", "Missing exorcism spot that shows scene in clinic - Ending specific"),
        tB("Ch3", "324", "Opening nightmare and House 1"),
        tB("Ch3", "53", "Waking up in house"),
        tB("Ch3", "113", "Waking up in clinic basement on stretcher with Jeremy demon checking bodies"),
        tB("Ch3", "54", "Nightmare section 2"),
        tB("Ch3", "59", "House and waking up section 2."),
        tB("Ch3", "123", "Inside Lisas room + Lisa fight"),
        tB("Ch3", "187", "Tiffany boss intro and fight"),
        tB("Ch3", "73", " Nightmare section again"),
        tB("Ch3", "76", "Image with text about X night before Profane Sabbath after nightmare sequence in house which is for Ending I and II"),
        tB("Ch3", "94", "Waking up in the house yet again"),
        tB("Ch3", "191", "School entrance"),
        tB("Ch3", "331", "Needle that's shot into John and he trips balls cutscene"),
        tB("Ch3", "84", "Nightmare section again right after tripping balls cutscene"),
        tB("Ch3", "209", "Weird cult section underneath the school after tripping balls"),
        tB("Ch3", "269", "First Gary battle before the end of the game"),
        tB("Ch3", "281", "Second Gary fight for Ending II which is right before the final end of the game and Ending specific to II"),
        tB("Ch3", "284", "The Ending for Ending II right before last automatic split triggers. Choosing to leave with Fr. Garcia"),
        tB("Ch3", "290", "Waking up in house for Ending III where it is all dark with lightning strikes and an inverted cross is over the protagonists head on Night 3"),
        tB("Ch3", "297", "Grabbing key in basement of protagonists house during lightning strike - Ending specific to III I think"),
        tB("Ch3", "293", "Going inside the room locked up with all the crosses in the protagonists house for Ending III"),
        tB("Ch3", "308", "Ending placard for Ending III. Needs to have final time split here"),
        tB("Ch3", "289", "Title Card"),
    };
        foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);   

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{        
		var timingMessage = MessageBox.Show (
			"This game uses Time without Loads (Game Time) as the main timing method.\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"Would you like to set the timing method to Game Time?",
			"LiveSplit | Faith The Unholy Trinity",
			MessageBoxButtons.YesNo,MessageBoxIcon.Question
		);
		if (timingMessage == DialogResult.Yes)
		{
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}

    vars.LoadValues = new List<int>
    {
        152,
        187,
        207,
        259,
        260,
        261,
        270,
        280,
        283,
        284,
        285,
        286,
        288,
        324,
        325,
        326,
        327,
        328,
        329,
        330,
        331,
        332,
        343,
        349,
        353,
        //411,
        419,
        428,
        458,
        466,
        468,
        505,
        512,
        515,
        516,
        153,
        35,
        36,
        75,
        77,
        91,
        92,
        93,
    };

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
	settings.Add("sheep_count", true, "Sheep Count");
}

update
{
    vars.CurRoomToString = current.CurRoom.ToString();
    print(vars.CurRoomToString);
		if (settings["sheep_count"]) {vars.SetTextComponent("RoomID", (current.CurRoom).ToString()); }

}

start
{
    return (settings[vars.CurRoomToString]);
}

onStart
{
    vars.doneMaps.Add(vars.CurRoomToString);
}

split
{
    if (settings[vars.CurRoomToString] && (!vars.doneMaps.Contains(vars.CurRoomToString)))
    {
        vars.doneMaps.Add(vars.CurRoomToString);
        return true;
    }
}

isLoading
{
    return (vars.LoadValues.Contains(current.CurRoom));
}

onReset
{
    vars.doneMaps.Clear();
}