state("RICO")
{
	int resetMenu 	: "GameAssembly.dll", 0x02147120, 0x5C, 0x1C, 0x30, 0x1C;
	int levelEnd 	: "GameAssembly.dll", 0x0201260C, 0x5C, 0x1C, 0x3C, 0x44, 0x1C;
	byte skipped 	: "GameAssembly.dll", 0x02144FCC, 0x5C, 0x4, 0x48, 0xC8, 0x18, 0x4C, 0x28C;
	byte success 	: "GameAssembly.dll", 0x02144F9C, 0x5C, 0x24, 0x3C, 0x4C, 0x1C;
 	float toLoad	: "GameAssembly.dll", 0x02126C5C, 0x8E8, 0x20;
}

startup
{
	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | RICO",
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
	return ((current.skipped != old.skipped) && (current.skipped == 2) || (current.skipped != old.skipped) && (current.skipped == 1));
}

split
{
	return ((current.levelEnd != old.levelEnd) && (current.levelEnd == 2) || (current.success != old.success) && (current.success == 2));
}

reset
{
	return ((current.resetMenu != old.resetMenu) && (current.resetMenu == 2));
}


isLoading
{
    return (current.toLoad != 0);
}

