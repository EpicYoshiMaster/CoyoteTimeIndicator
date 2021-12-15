/*
* Code by EpicYoshiMaster
*
* Mod for displaying Coyote Time information visually to the player
*/
class Yoshi_GameMod_CoyoteTimeIndicator extends GameMod;

var config int HUDIndicatorColor;
var config int HUDAlwaysShow;

var class<Hat_HUDElement> CoyoteTimeHUDClass;

event OnModLoaded() {
	if(`GameManager.GetCurrentMapFilename() ~= `GameManager.TitleScreenMapName) return;

    HookActorSpawn(class'Hat_Player', 'Hat_Player');
}

event OnModUnloaded() {
	local Hat_Player ply;
	foreach DynamicActors(class'Hat_Player', ply) {
		if(ply != None) {
			Hat_HUD(PlayerController(ply.Controller).myHUD).CloseHUD(CoyoteTimeHUDClass);
		}
	}
}

event OnHookedActorSpawn(Object NewActor, Name Identifier) {
	local Hat_Player ply;
    if(Identifier == 'Hat_Player')
    {
        ply = Hat_Player(NewActor);

		if(ply != None) {
			SetTimer(0.01, false, NameOf(GiveHUD), self, ply);
		}
    }
}

function GiveHUD(Hat_Player ply) {
	Hat_HUD(PlayerController(ply.Controller).myHUD).OpenHUD(CoyoteTimeHUDClass);
}

defaultproperties
{
	CoyoteTimeHUDClass = class'Yoshi_HUDElement_CoyoteTime';
}