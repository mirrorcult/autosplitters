// Flow:
// X -> MAINMENU: Reset
// MAINMENU -> LEVEL_START or LEVEL_PAUSED: Start, Pause
// LEVEL_RUNNING -> LEVEL_START while not TYPE_START_OR_END: Split, Pause
// LEVEL_START -> LEVEL_RUNNING while not TYPE_START_OR_END: Resume
// LEVEL_RUNNING -> LEVEL_PAUSED: Pause
// LEVEL_PAUSED -> LEVEL_RUNNING while not TYPE_START_OR_END: Resume
// X -> FINISH: End

/*
STATE_MAIN_MENU:uint = 0xABCDEF;
STATE_LEVEL_START:uint = 0xBCDEFA;
STATE_LEVEL_RUNNING:uint = 0xCDEFAB;
STATE_LEVEL_PAUSED:uint = 0xDEFABC;
STATE_LEVEL_TRANSITION:uint = 0xFABCDE;
STATE_FINISH:uint = 0xFFFFFF;

TYPE_START_OR_END:uint = 0xAABBCC;
TYPE_NORMAL:uint = 0xDDEEFF;
*/

state("GiveUpRobot2")
{
    uint GameState : "Adobe Air.dll", 0x00E17A30, 0x2C, 0x20, 0x0, 0xC4, 0x8, 0xC, 0x8, 0x54;
    uint LevelType : "Adobe Air.dll", 0x00E17A30, 0x2C, 0x20, 0x0, 0xC4, 0x8, 0xC, 0x8, 0x58;
    uint TotalTime : "Adobe Air.dll", 0x00E17A30, 0x2C, 0x20, 0x0, 0xC4, 0x8, 0xC, 0x8, 0x5C;
}

startup
{
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var mbox = MessageBox.Show(
            "Give Up, Robot 2 uses in-game time.\nWould you like to switch to it?",
            "LiveSplit | Give Up, Robot 2",
            MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

start
{
    return old.GameState == 0xABCDEF && (current.GameState == 0xBCDEFA || current.GameState == 0xDEFABC);
}

reset
{
    return current.GameState == 0xABCDEF;
}

split
{
    return (current.GameState == 0xFABCDE || current.GameState == 0xFFFFFF) && (old.GameState == 0xCDEFAB || old.GameState == 0xDEFABC) && current.LevelType == 0xDDEEFF;
}

gameTime
{
    return TimeSpan.FromSeconds(Math.Round(current.TotalTime / 60f, 2));
}

isLoading
{
    return true;
}