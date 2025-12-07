
// Prevents loss of leadership after unit was killed\incapacitated

params ["_unit"];

if (_unit == player) then 
{
	
	if !(player diarySubjectExists "Readme") then 
	{
		player createDiarySubject ["Readme","Your abilities"];
		player setDiarySubjectPicture ["Readme","Your abilities"];
	};

	player createDiaryRecord ["Readme", ["Born Leader", "<br/>You will always be the leader of your group.<br/><br/>Lead your men by your own example and make them proud of you.<br/><br/>"]];
	

	while {true} do
	{
		sleep 3;
		private _isIncapacitated = _unit getVariable ["vn_revive_incapacitated", false];
		if (player != leader group player && !_isIncapacitated) then {
			[group player, player] remoteExec ["selectLeader", groupOwner group player];
		};
	};
};
