state("FixitFelixJr")
{
	int start1 :  0x1B294;
	int reset1 : 0x24264;
}

start
{
	return (current.start1 == 4);
}


split
{
	return (current.reset1 == 6);
}

 reset
{
    	return (current.reset1 == 0);
}
