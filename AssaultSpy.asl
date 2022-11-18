state("ASSAULT_SPY-Win64-Shipping")
{
    string1111 MapID : 0x02A7DD20, 0x7C8, 0x12;
    byte Loader : 0x27EACF8; //0, 255 load, not
}

init
{
    vars.doneMaps = new List<string>();
}

startup
{
    settings.Add("AS", true, "All Chapters");

    vars.Chapters = new Dictionary<string,string> 
	{
        {"/ステージ/00_アサルプロローグ/マップ/アサルプロローグP","Prologue"},
        {"/ステージ/01_エントランス/エントランスステージ/エントランスステージ_P","Entrance"},
        {"/ステージ/01_エントランス/エントランスホール/エントランスホールP","Entrance Hall"},
        {"/ステージ/02_オフィスエリア/オフィスステージ/オフィス_パーシスタント","Office"},
        {"/ステージ/03_地下エリア/地下ステージ/地下_P","Underground Stage"},
        {"/ステージ/03_地下エリア/地下ステージ/地下_後半P","Underground Late"},
        {"/ステージ/04_中庭エリア/中庭ステージ/中庭_P","Courtyard Stage"},
        {"/ステージ/04_中庭エリア/中庭ステージ/中庭_後半P","Courtyard Late"},
        {"/ステージ/05_屋上エリア/屋上ステージ/屋上_P","Rooftop"},
        {"/ステージ/05_屋上エリア/屋上ステージ/屋上_後半P","Rooftop Late"},
        {"/ステージ/06_バックヤード/マップ/バックヤード前半P","Backyard First Half"},
        {"/ステージ/06_バックヤード/マップ/バックヤード_後半P","Backyard Late"},
        {"/ステージ/07_エグゼクティブエリア/マップ/エグゼクティブ_P","Executive Stage"},
        {"/ステージ/07_エグゼクティブエリア/マップ/エグゼクティブ_後半P","Executive Late"},
        {"/ステージ/08_ラボエリア/マップ/ラボ_P","Lab"},
        {"/ステージ/08_ラボエリア/マップ/ラボ_後半P","Lab Late"},
        {"/ステージ/09_エピローグ/エピローグ_P","Epilogue"},
        {"/ステージ/10_デスマーチ/デスマーチベース1","Desmarch Base 1"},
    };
    foreach (var Tag in vars.Chapters)
		{
			settings.Add(Tag.Key, true, Tag.Value, "AS");
    	};


	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
        // Asks user to change to game time if LiveSplit is currently set to Real Time.
        {        
            var timingMessage = MessageBox.Show (
                "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time?",
                "LiveSplit | A Plague Tale Innocence",
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
    return ((current.Loader == 0) && (settings[current.MapID]));
}

onStart
{
    vars.doneMaps.Add(current.MapID);
}

split
{
    if((settings[current.MapID]) && (!vars.doneMaps.Contains(current.MapID) && current.Loader == 0))
    {
        vars.doneMaps.Add(current.MapID);
        return true;
    }
}

onReset
{
    vars.doneMaps.Clear();
}

isLoading
{
    return (current.Loader == 0);
}