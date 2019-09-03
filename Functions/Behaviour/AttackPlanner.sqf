
#define PREDICTION_CONE 60

params ["_cluster", "_unitsToHideFrom", "_sufficientClusterShift", "_distanceToSpawn", "_groupSize", "_groupsCount", ["_debug", false, [true]]];

private _queue = _cluster # 2;
private _coordinates = [_queue] call FS_fnc_QueueGetData;

private _trend = _coordinates # 0 vectorDiff _coordinates # (count _coordinates - 1);
private _trendDir = _coordinates # (count _coordinates - 1) getDir _coordinates # 0;

private _target = [];
private _angleMin = 0;
private _angleMax = 360;
private _proposedClasses = [];

// Select action based on whether the cluster has been moving or not
private _distanceTravelled = vectorMagnitude _trend;
if ( _distanceTravelled > _sufficientClusterShift ) then 
{
	/* If the cluster has been moving... */ 
	// Getting a hidden position along the direction of movement 
	_angleMin = abs( ( _trendDir - PREDICTION_CONE / 2 ) % 360 );
	_angleMax = abs( ( _trendDir + PREDICTION_CONE / 2 ) % 360 );
	
	// Spawn only sappers, so they would lay down traps in front of the advancing enemy cluster 
	_proposedClasses = ["uns_men_VC_regional_SAP2", "uns_men_VC_regional_SAP", "uns_men_VC_recon_SAP2", "uns_men_VC_recon_SAP", "uns_men_VC_local_SAP", "uns_men_VC_mainforce_SAP", "uns_men_VC_mainforce_68_SAP"];
}
else {
	/* The cluster has been standing still for some time... */
	_target = _cluster # 0;
};

private _result = [_unitsToHideFrom, _cluster # 0, _distanceToSpawn, [_angleMin, _angleMax], 10, _debug] call FS_fnc_GetHiddenPos2;
	
// If hidden position found
if !( _result isEqualTo [] ) then 
{
	if ( _target isEqualTo [] ) then {
		_target = _result getDir _cluster # 0; // Passing the heading to look at to the FSM
	};

	if ( _debug ) then {
		_marker = createMarkerLocal [str(round random(1000000)), _result];
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerText "Ambush here!";
	};
	
	private _handler = [_result, _target, _groupSize, _groupsCount, _proposedClasses, _debug] spawn FS_fnc_SpawnGooks;
	waitUntil { sleep 2; scriptDone _handler };
};
