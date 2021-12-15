/*
* Code by EpicYoshiMaster
*
* HUD Element to display the current Coyote Time of the player
*/
class Yoshi_HUDElement_CoyoteTime extends Hat_HUDElement;

const NUM_COLORS = 3;
const HUD_SIZE_MULTIPLIER = 0.07;
const HUD_PROJECTION_SPACING = 0.055;

var() MaterialInterface CoyoteTimeMaterial;

var MaterialInstanceConstant CoyoteMatInst;
var const Color ColorChoices[NUM_COLORS];

function bool Render(HUD H)
{
	local Vector HUDPos;
	local LinearColor HUDColor;
	local Hat_Player ply;
	local float iconscale, CurrCoyoteAlpha;
    if (!Super.Render(H)) return false;

	ply = Hat_Player(H.PlayerOwner.Pawn);
	if(ply == None) return true;

	if(CoyoteMatInst == None) {
		CoyoteMatInst = new class'MaterialInstanceConstant';
		CoyoteMatInst.SetParent(CoyoteTimeMaterial);
	}
	
	HUDPos = GetHUDPosition(H, ply);
	CurrCoyoteAlpha = GetCoyoteTimeAlpha(H, ply);
	HUDColor = GetHUDColor();
	iconscale = FMin(H.Canvas.ClipX, H.Canvas.ClipY) * HUD_SIZE_MULTIPLIER;

	if(ShouldShowHUD(CurrCoyoteAlpha)) {
		CoyoteMatInst.SetScalarParameterValue('Value', CurrCoyoteAlpha);
		CoyoteMatInst.SetVectorParameterValue('PositiveColor', HUDColor);

		DrawCenterMat(H, HUDPos.X, HUDPos.Y, iconscale, iconscale, CoyoteMatInst);
	}

    return true;
}

function Vector GetHUDPosition(HUD H, Hat_Player ply) {
	local Vector ProjectedPosition;

	ProjectedPosition = H.Canvas.Project(ply.Location); 
	ProjectedPosition.X += H.Canvas.ClipX * HUD_PROJECTION_SPACING;

	if (class'Engine'.static.GetEngine().bMirrorMode)
	{
		ProjectedPosition.X = H.Canvas.ClipX - ProjectedPosition.X;
	}

	return ProjectedPosition;
}

function float GetCoyoteTimeAlpha(HUD H, Hat_Player ply) {
	local float MaxCoyoteTime;

	MaxCoyoteTime = class'Hat_Pawn'.const.WalkOverEdgeJumpDuration; 

	return FClamp((ply.WalkOverEdgeJumpTime / MaxCoyoteTime),0,1);
}

function LinearColor GetHUDColor() {
	local int ColorChoice;

	ColorChoice = class'Yoshi_GameMod_CoyoteTimeIndicator'.default.HUDIndicatorColor;

	if(ColorChoice >= 0 && ColorChoice < NUM_COLORS) {
		return ColorToLinearColor(default.ColorChoices[ColorChoice]);
	}

	return ColorToLinearColor(default.ColorChoices[0]);
}

function bool ShouldShowHUD(float CurrCoyoteAlpha) {
	local int ShowHUDConfig;

	ShowHUDConfig = class'Yoshi_GameMod_CoyoteTimeIndicator'.default.HUDAlwaysShow;

	if(ShowHUDConfig == 2) return false; //Never Show
	else if(ShowHUDConfig == 0 && CurrCoyoteAlpha <= 0) return false; //When Needed
	return true;
}

defaultproperties
{
	CoyoteTimeMaterial=MaterialInstanceConstant'Yoshi_CoyoteTime_Content.Materials.MatInstConst_Cooldown_CoyoteTime'

	ColorChoices(0)=(R=244,G=26,B=26,A=255) //Red
	ColorChoices(1)=(R=31,G=191,B=29,A=255) //Green
	ColorChoices(2)=(R=73,G=137,B=253,A=255) //Blue
}