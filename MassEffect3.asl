state("MassEffect3") {
	int loading1  : 0x15216BC;
	byte loading2 : 0x1522394;
}

startup {
	timer.CurrentTimingMethod = TimingMethod.GameTime;
}

isLoading {
	return current.loading1 == 0 || current.loading2 != 0;
}
