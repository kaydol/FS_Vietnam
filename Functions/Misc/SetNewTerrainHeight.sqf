params ["_positionsAndHeights"];

if (isServer) then 
{
	setTerrainHeight [_positionsAndHeights, true];
}
else 
{
	[_positionsAndHeights, {setTerrainHeight [_this, true];}] remoteExec ["call", 2];
};
