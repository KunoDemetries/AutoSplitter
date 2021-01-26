state("nevermind") {
    int loading : 0x1342198;
}

startup {
	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

isLoading {
    return current.loading != 3;
}
