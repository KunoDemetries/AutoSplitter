state("deadrising3")
{
    string9 BackupCC: 0x1713ABB;
    string9 CurrentChapter: 0X01714FA0, 0XE98, 0X0;
    string110 CurrentObjective: 0x01713D38, 0xCD0, 0X2A0, 0X7B0, 0X130, 0X2D0, 0X460;
    uint Loader: 0x0199DE40, 0xE0, 0X8, 0X1308;
    long CurBossPtr: 0x019A78D0, 0x120, 0x50, 0x530, 0x1A8, 0x678;
    string110 LastOBJGiven: 0x01713D28, 0x30, 0x58, 0x468, 0xF0;  //ONLY APPLIES TO SIDE OBJS NOT MAIN OBJS
    int BossHealth: 0x01A0CF38, 0x90, 0x28, 0x8, 0xB0, 0x8, 0x10;
    int FrankStatues: 0x01A0D130, 0x90, 0x810, 0x0, 0x120, 0x18, 0x40, 0x7B0;
    int EnterPlane: 0x016F4128, 0x138, 0x30, 0x18, 0x140;
}

init
{
	vars.doneMaps = new List<string>();
    vars.BossName = ".";
    vars.lastBoss = ".";
} 


startup
{
    settings.Add("DS3", true, "Dead Rising 3");
    settings.Add("Chapter00", true, "Chapter 0", "DS3");
    settings.Add("Chapter01", true, "Chapter 1", "DS3");
    settings.Add("Chapter02", true, "Chapter 2", "DS3");
    settings.Add("Chapter03", true, "Chapter 3", "DS3");
    settings.Add("Chapter04", true, "Chapter 4", "DS3");
    settings.Add("Chapter05", true, "Chapter 5", "DS3");
    settings.Add("Chapter06", true, "Chapter 6", "DS3");
    settings.Add("Chapter07", true, "Chapter 7", "DS3");
    settings.Add("Chapter08", true, "Chapter 8", "DS3");
    settings.Add("OB", true, "Optional Bosses", "DS3");
    settings.Add("DLC", true, "DLC Episodes", "DS3");
        settings.Add("OBE", true, "Operation Broken Eagle", "DLC");
        settings.Add("FA", true, "Fallen Angel", "DLC");
        settings.Add("CR", true, "Chaos Rising", "DLC");
        settings.Add("TLA", true, "The Last Agent", "DLC");
    settings.Add("AFS", true, "All Frank Statues", "DS3");
        settings.Add("10C", false, "10 collected", "AFS");
        settings.Add("20C", false, "20 collected", "AFS");
        settings.Add("30C", false, "30 collected", "AFS");
        settings.Add("40C", false, "40 collected", "AFS");
        settings.Add("50C", false, "50 collected", "AFS");
        settings.Add("60C", false, "60 collected", "AFS");
        settings.Add("70C", false, "70 collected", "AFS");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
        var sB = new List<Tuple<string, string, string>> 
    {
        tB("Chapter00","Eat Food To Restore Health","Eat Food To Restore Health"),
        tB("Chapter00","Find Supplies","Find Supplies"),
        // redundant tB("Chapter00","Get Through the Blockade","Get Through the Blockade"),
        tB("Chapter00","Explore the Tunnel","Explore the Tunnel"),
        //tB("Chapter00","Find a Way Out","Find a Way Out"),
        tB("Chapter00","Get to the Diner","Get to the Diner"),
        tB("Chapter00","Combine Two Weapons","Combine Two Weapons"),
        tB("Chapter00","Get Everyone to Rhonda's Garage","Get Everyone to Rhonda's Garage"),
        tB("Chapter00","Lower the Barricade","Lower the Barricade"),
        //redundant tB("Chapter00","Get in the Car","Get in the Car"),
        tB("Chapter00","Explore while Rhonda's Busy","Explore while Rhonda's Busy"),
        tB("Chapter00","Talk to Rhonda","Talk to Rhonda"),
        tB("Chapter01","Combine Two Vehicles","Combine Two Vehicles"),
        tB("Chapter01","Get to the Quarantine Station","Get to the Quarantine Station"),
        tB("Chapter01","Defeat 10 Bikers","Defeat 10 Bikers"),
        tB("Chapter01","Defeat the Gang Leader","Defeat the Gang Leader"),
        tB("Chapter02","Get to the Sewers","Get to the Sewers"),
        tB("Chapter02","Get Zombrex at the Morgue","Get Zombrex at the Morgue"),
        tB("Chapter02","Break in through Skylight","Break in through Skylight"),
        tB("Chapter02","Let Gary in","Let Gary in"),
        tB("Chapter02","Get to Cold Storage","Get to Cold Storage"),
        tB("Chapter02","Find Nicole White's Corpse","Find Nicole White's Corpse"),
        tB("Chapter02","Find Keys to Morgue Drawers","Find Keys to Morgue Drawers"),
        tB("Chapter02","Help Gary","Help Gary"),
        tB("Chapter02","Get the Corpse to the Club","Get the Corpse to the Club"),
        tB("Chapter03","Get to the Plane","Get to the Plane"),
        tB("Chapter03","Find the Illegally Infected","Find the Illegally Infected"),
        tB("Chapter03","Talk to Lauren","Talk to Lauren"),
        tB("Chapter03","Find Tattoo Kit","Find Tattoo Kit"),
        tB("Chapter03","Find Lauren's Ring Box","Find Lauren's Ring Box"),
        tB("Chapter03","Return to Lauren","Return to Lauren"),
        tB("Chapter03","Find Annie","Find Annie"),
        tB("Chapter03","Destroy 3 camera","Destroy 3 camera"),
        tB("Chapter03","Destroy 2 Relays","Destroy 2 Relays"),
        tB("Chapter03","Burn 2 Sets of Supplies","Burn 2 Sets of Supplies"),
        tB("Chapter03","Defeat the Real Albert","Defeat the Real Albert"),
        tB("Chapter03","Return to the Comm Tower","Return to the Comm Tower"),
        tB("Chapter03","Get to the Police Station","Get to the Police Station"),
        tB("Chapter03","Follow Hilde","Follow Hilde"),
        tB("Chapter03","Defeat Hilde, the Sergeant","Defeat Hilde, the Sergeant"),
        tB("Chapter03","Meet Red and Annie at the Hotel","Meet Red and Annie at the Hotel"),
        tB("Chapter03","Explore While Red Gets Fuel","Explore While Red Gets Fuel"),
        tB("Chapter03","Meet Red at the Comm Tower","Meet Red at the Comm Tower"),
        tB("Chapter04","Get to Car Lot Rooftop","Get to Car Lot Rooftop"),
        tB("Chapter04","Infiltrate the Compound","Infiltrate the Compound"),
        tB("Chapter04","Enter the HQ","Enter the HQ"),
        tB("Chapter04","Destroy the Generators","Destroy the Generators"),
        tB("Chapter04","Free the Captives","Free the Captives"),
        tB("Chapter04","Defeat all Spec Ops","Defeat all Spec Ops"),
        tB("Chapter04","Defeat the Commander","Defeat the Commander"),
        tB("Chapter04","Get to Central Storage","Get to Central Storage"),
        tB("Chapter04","Find the Fuel","Find the Fuel"),
        tB("Chapter04","Get into the Fuel Car","Get into the Fuel Car"),
        tB("Chapter05","Find Diego at Museum","Find Diego at Museum"),
        tB("Chapter05","Defeat Diego","Defeat Diego"),
        tB("Chapter05","Find the Gang Members","Find the Gang Members"),
        tB("Chapter05","Bring Diego to the Plane","Bring Diego to the Plane"),
        tB("Chapter05","Explore While Rhonda Researches","Explore While Rhonda Researches"),
        tB("Chapter06","Get to the Collector's House","Get to the Collector's House"),
        tB("Chapter06","Clear the Room","Clear the Room"),
        tB("Chapter06","Disable the Alarm","Disable the Alarm"),
        tB("Chapter06","Find the Rudder Arm","Find the Rudder Arm"),
        tB("Chapter06","Get to the Courier","Get to the Courier"),
        tB("Chapter06","Find the Flywheel","Find the Flywheel"),
        //tB("Chapter06","Get to the Plane","Get to the Plane"),
        tB("Chapter06","Find a Way Out","Find a Way Out"),
        tB("Chapter06","Destroy the Loaders to Escape","Destroy the Loaders to Escape"),
        tB("Chapter07","Get to the Karaoke Bar","Get to the Karaoke Bar"),
        tB("Chapter07","Unlock the Doors","Unlock the Doors"),
        tB("Chapter07","Turn on the Power","Turn on the Power"),
        tB("Chapter07","Find Some Wire","Find Some Wire"),
        //tB("Chapter07","Turn on the Power","Turn on the Power"),
        //tB("Chapter07","Unlock the Doors","Unlock the Doors"),
        tB("Chapter07","Escape the Metro","Escape the Metro"),
        tB("Chapter07","PLANE","Enter the Plane"),
        tB("Chapter07","Find Rhonda","Find Rhonda"),
        tB("Chapter07","Find First Aid Kit","Find First Aid Kit"),
        tB("Chapter07","Find an Acetylene Tank","Find an Acetylene Tank"),
        tB("Chapter07","Bring Rhonda to Gary","Bring Rhonda to Gary"),
        tB("Chapter07","Clear Zombies Around Annie","Clear Zombies Around Annie"),
        tB("Chapter07","Help Annie","Help Annie"),
        tB("Chapter07","Take Annie to the Plane","Take Annie to the Plane"),
        tB("Chapter07","Destroy the Crane","Destroy the Crane"),
        tB("Chapter07","Free Annie and Isabella","Free Annie and Isabella"),
        tB("Chapter08","Track Down Hemlock","Track Down Hemlock"),
        tB("Chapter08","Destroy 60 Harvest Drones","Destroy 60 Harvest Drones"),
        tB("OB","Zhi","Zhi"),
        tB("OB","Darlene","Darlene"),
        tB("OB","Jherii","Jherii"),
        tB("OB","Sloth","Sloth"),
        tB("OB","Dylan","Dylan"),
        tB("OB","Kenny","Kenny"),
        tB("OB","Find Teddy's Location","Teddy"),
        tB("OB","Gang Leader","Gang Leader"),
        tB("OBE","Escape the Aquaduct","Escape the Aquaduct"),
        tB("OBE","Locate Precious Cargo","Locate Precious Cargo"),
        tB("OBE","Get to the Motel","Get to the Motel"),
        tB("OBE","Cleanse Illegals Base","Cleanse Illegals Base"),
        tB("OBE","Go to Ingleton Taxi Company","Go to Ingleton Taxi Company"),
        tB("OBE","Close the Gate","Close the Gate"),
        tB("OBE","Clear Taxi Company","Clear Taxi Company"),
        tB("OBE","Get to the Roof","Get to the Roof"),
        tB("OBE","Signal Bravo with Flare","Signal Bravo with Flare"),
        tB("OBE","Locate Charlie Unit's Supplies","Locate Charlie Unit's Supplies"),
        tB("OBE","Return supplies to Base Camp","Return supplies to Base Camp"),
        tB("OBE","Park the Vehicle","Park the Vehicle"),
        tB("OBE","Investigate the Stage","Investigate the Stage"),
        tB("OBE","Track the President","Track the President"),
        tB("OBE","Eliminate the President's Forces","Eliminate the President's Forces"),
        tB("OBE","Secure the President","Secure the President"),
        tB("FA","Investigate the Yacht","Investigate the Yacht"),
        //tB("FA","Find Supplies","Find Supplies"),
        tB("FA","Get to the Safe Zone in South Almuda","Get to the Safe Zone in South Almuda"),
        tB("FA","Search for Clues","Search for Clues"),
        tB("FA","Follow the Blood Trail","Follow the Blood Trail"),
        tB("FA","Talk to Winnie","Talk to Winnie"),
        tB("FA","Get to Sunset High School","Get to Sunset High School"),
        tB("FA","Stop the Intruders","Stop the Intruders"),
        tB("FA","Get to the Communications Tower","Get to the Communications Tower"),
        tB("FA","Defend Doug","Defend Doug"),
        tB("FA","Clear Out the Zombies Inside","Clear Out the Zombies Inside"),
        tB("FA","Talk to Doug","Talk to Doug"),
        tB("FA","Find the Food Truck","Find the Food Truck"),
        tB("FA","Return Food Truck to Communications Tower","Return Food Truck to Communications Tower"),
        tB("FA","Meet Doug at the Trap Location","Meet Doug at the Trap Location"),
        tB("FA","Get to the Vantage Point","Get to the Vantage Point"),
        tB("FA","Take out the Spec Ops","Take out the Spec Ops"),
        tB("FA","Follow Doug","Follow Doug"),
        tB("FA","Investigate the Lab","Investigate the Lab"),
        tB("FA","Find the Lab Key","Find the Lab Key"),
        tB("FA","Clear Enemies from Lab","Clear Enemies from Lab"),
        tB("FA","Rescue the Trapped Survivors","Rescue the Trapped Survivors"),
        tB("CR","Get the Station Key","Get the Station Key"),
        tB("CR","Escape the Police Station","Escape the Police Station"),
        tB("CR","Get to Production Bridge","Get to Production Bridge"),
        tB("CR","Talk to Spider","Talk to Spider"),
        tB("CR","Collect the Special Whiskey","Collect the Special Whiskey"),
        tB("CR","Deliver the Whiskey","Deliver the Whiskey"),
        //tB("CR","Talk to Spider","Talk to Spider"),
        tB("CR","Survive the Doublecross","Survive the Doublecross"),
        tB("CR","Talk to Torque","Talk to Torque"),
        tB("CR","Collect Bikes for Torque","Collect Bikes for Torque"),
        //tB("CR","Talk to Torque","Talk to Torque"),
        tB("CR","Get Torque's Bike","Get Torque's Bike"),
        tB("CR","Explore while Torque works","Explore while Torque works"),
        tB("CR","Collect Razorface's Ring","Collect Razorface's Ring"),
        tB("CR","Collect Snake's Ring","Collect Snake's Ring"),
        tB("CR","Collect Cannon's Ring","Collect Cannon's Ring"),
        tB("CR","Go get Torque","Go get Torque"),
        tB("CR","Get to Shavey's","Get to Shavey's"),
        tB("CR","Get on the Rollerhawg","Get on the Rollerhawg"),
        //tB("CR","Get to Production Bridge","Get to Production Bridge"),
        tB("CR","Defeat Spider","Defeat Spider"),
        tB("TLA","Find the Collins Chemicals Van","Find the Collins Chemicals Van"),
        tB("TLA","Deliver the Zombrex Van to Cora","Deliver the Zombrex Van to Cora"),
        tB("TLA","Talk to Cora","Talk to Cora"),
        tB("TLA","Locate the Pacifier Weapon","Locate the Pacifier Weapon"),
        tB("TLA","Collect Chips from Kings","Collect Chips from Kings"),
        tB("TLA","Return to the Doctor with the Collected Chips","Return to the Doctor with the Collected Chips"),
        tB("TLA","Investigate the Gunshots and Explosions","Investigate the Gunshots and Explosions"),
        tB("TLA","Return to the Hospital and Kill the Bikers","Return to the Hospital and Kill the Bikers"),
        //tB("TLA","Talk to Cora","Talk to Cora"),
        tB("TLA","Retrieve the Bootlegged Zombrex","Retrieve the Bootlegged Zombrex"),
        tB("TLA","Return to the Doctor","Return to the Doctor"),
        tB("TLA","Talk to the Hacker in Sunset Hills","Talk to the Hacker in Sunset Hills"),
        tB("TLA","Clear Zombies from immediate area","Clear Zombies from immediate area"),
        tB("TLA","Give Nelson Zombrex","Give Nelson Zombrex"),
        tB("TLA","Talk to Nelson","Talk to Nelson"),
        tB("TLA","Find the Spectrum Analyzer","Find the Spectrum Analyzer"),
        tB("TLA","Find the Computer Parts","Find the Computer Parts"),
        tB("TLA","Go to the Control Room at Annie's XXX","Go to the Control Room at Annie's XXX"),
        //tB("TLA","Talk to Nelson","Talk to Nelson"),
        tB("TLA","Explore While Nelson Works","Explore While Nelson Works"),
        tB("TLA","Go see the Hacker","Go see the Hacker"),
        tB("TLA","Get to the Source of the Jamming Signal","Get to the Source of the Jamming Signal"),
        tB("TLA","Kill all the Spec Ops in the Area","Kill all the Spec Ops in the Area"),
        tB("TLA","Investigate the Server Station","Investigate the Server Station"),
        tB("TLA","Get to the Military Lab","Get to the Military Lab"),
        tB("TLA","Get to the Military Base","Get to the Military Base"),
        tB("TLA","Gather the Survivors at the Hospital","Gather the Survivors at the Hospital"),
        tB("TLA","Gather the Illegals at the Comm Tower","Gather the Illegals at the Comm Tower"),
        tB("TLA","Pick up Nelson","Pick up Nelson"),
        tB("TLA","Escape the City","Escape the City"),
        
    };
    foreach (var s in sB) settings.Add(s.Item2, false, s.Item3, s.Item1);

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Dead Rising 3",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

update
{
    vars.BossName = memory.ReadString(new IntPtr(current.CurBossPtr), 256);
}

onReset
{
    vars.doneMaps.Clear();
    vars.lastBoss = vars.BossName;
}

start
{
    return (current.BackupCC == "Chapter00" && current.Loader == 3452816641 ||
            current.CurrentChapter == "Episode1" && current.Loader == 3452816641 ||
            current.CurrentChapter == "Episode2" && current.Loader == 3452816641 ||
            current.CurrentChapter == "Episode3" && current.Loader == 3452816641 ||
            current.CurrentChapter == "Episode4" && current.Loader == 3452816641);
}

onStart
{
    vars.doneMaps.Add(current.CurrentChapter);
    vars.doneMaps.Add(current.CurrentObjective);
    vars.lastBoss = vars.BossName;
}

split
{
    if (current.CurrentChapter != old.CurrentChapter && !vars.doneMaps.Contains(old.CurrentChapter))
    {
        vars.doneMaps.Add(old.CurrentChapter);
        return settings[old.CurrentChapter];
    }

    if (current.CurrentObjective != old.CurrentObjective && !vars.doneMaps.Contains(old.CurrentObjective))
    {
        vars.doneMaps.Add(old.CurrentObjective);
        return settings[old.CurrentObjective];
    }

    if (settings[vars.BossName] && !vars.doneMaps.Contains(vars.BossName) && vars.lastBoss != vars.BossName && current.BossHealth == 0)
    {
        vars.doneMaps.Add(vars.BossName);
        return true;
    }

    if (old.EnterPlane == 0 && current.EnterPlane == 3 && current.CurrentChapter == "Chapter07")
    {
        vars.doneMaps.Add("PLANE");
        return settings["PLANE"];
    }

    //Splits on collecting a certain number of Frank West Statues
    if (current.FrankStatues!= old.FrankStatues && !vars.doneMaps.Contains(current.FrankStatues+"C"))
    {
        vars.doneMaps.Add(current.FrankStatues+"C");
        return settings[current.FrankStatues+"C"];
    }
}

isLoading
{
    return current.Loader == 3452816641;
}

reset
{
    return current.CurrentChapter == "main_menu" && old.CurrentChapter != "main_menu";
}
