if (isMultiplayer) then 
{
	0 cutText ["", "BLACK IN", 1000, true, true]; 
	[] spawn
	{
		while {time < 3} do {
			sleep 0.1;
			endLoadingScreen;
		};
		
		waitUntil { sleep 0.1; !dialog };
		0 cutText ["", "BLACK IN", 10, true, true];
	};
};