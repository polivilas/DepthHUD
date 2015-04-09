ELEMENT.Name = "Ammo : Primary"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 16
ELEMENT.DefaultGridPosY = 16
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.MEM_MaxAmmo = {}
ELEMENT.MEM_EverHadPrim = {}

ELEMENT.GoodColor = ELEMENT.Theme:GetColorReference( "basecolor" )
ELEMENT.BadColor = ELEMENT.Theme:GetColorReference( "badcolor" )
ELEMENT.NeutralColor = ELEMENT.Theme:GetColorReference( "backcolor" )

local TYPE_NONE = 0
local TYPE_WEAP = 1
local TYPE_PROJ = 0

function ELEMENT:Initialize( )
	self.MemColor = nil
	self.MemRate = 0.0
	self.MemBlinkBelow = 0.0
	self.MemText  = ""
	self.MemSmallText = ""
end

function ELEMENT:CalcPrimaryAmmo()
	local SWEP = LocalPlayer():GetActiveWeapon()
	
	local sPrimaryType = ""
	local iClipMaxAmmo   = -1
	local iRemainInClip   = -1
	local iRemainInPocket = -1
	local bEverHadPrim = false
	
	if SWEP:IsValid() then
		sPrimaryType = SWEP:GetPrimaryAmmoType() or ""
		iRemainInClip   = tonumber(SWEP:Clip1()) or -1
		iRemainInPocket = LocalPlayer():GetAmmoCount(sPrimaryType)
		
	else
		iRemainInClip = -1
		iRemainInPocket = -1
	end
	
	if not self.MEM_MaxAmmo[SWEP] then
		self.MEM_MaxAmmo[SWEP] = iRemainInClip
		
	elseif iRemainInClip > self.MEM_MaxAmmo[SWEP] then
		self.MEM_MaxAmmo[SWEP] = iRemainInClip
		
	end
	
	iClipMaxAmmo = tonumber(self.MEM_MaxAmmo[SWEP]) or 1
	
	local iWhatWeapon =
		((iRemainInClip >= 0 and sPrimaryType != -1) and TYPE_WEAP)
		or ((iRemainInPocket > 0) and TYPE_PROJ)
		or TYPE_NONE
	
	if iWhatWeapon == TYPE_PROJ then
		bEverHadPrim = self.MEM_EverHadPrim[SWEP] or (iRemainInPocket > 0)
		self.MEM_EverHadPrim[SWEP] = bEverHadPrim
	end
	
	return iWhatWeapon, iRemainInClip, iRemainInPocket, iClipMaxAmmo, bEverHadPrim
end

function ELEMENT:DrawFunction( )
	if LocalPlayer():Alive() then
		local primFrac = 1
	
		local SWEP = LocalPlayer():GetActiveWeapon()
		
		// PRIMARY
		local iWhatWeapon, iRemainInClip, iRemainInPocket, iClipMaxAmmo, bEverHadPrim = self:CalcPrimaryAmmo()
		if iWhatWeapon == TYPE_WEAP then
			self:FadeIn()
		
			self.MemRate = iRemainInClip / iClipMaxAmmo
			self.MemBlinkBelow = 0.0
			self.MemColor = (iRemainInClip > 0) and self.GoodColor or self.BadColor
			self.MemText = iRemainInClip
			self.MemTextSmall = (iRemainInPocket > 0) and iRemainInPocket or ""
			
		elseif (iWhatWeapon == TYPE_PROJ) and bEverHadPrim  then
			self:FadeIn()
		
			self.MemRate = 1.0
			self.MemBlinkBelow = -1
			self.MemColor = self.GoodColor
			self.MemText = iRemainInPocket
			self.MemTextSmall = ""
			
		else
			self:FadeOut()
			
		end
		
	else
		self:FadeOut()
		
	end
	
	if self:ShouldDraw() then
			self:DrawGenericInfobox(
	/*Text   */ self.MemText or ""
	/*Subtxt */ ,self.MemTextSmall or ""
	/* %     */ ,self.MemRate
	/*atRight*/ ,true
	/*0.0 col*/ ,self.MemColor
	/*1.0 col*/ ,self.MemColor
	/*minSize*/ ,0.0
	/*maxSize*/ ,1.0
	/*blink< */ ,self.MemBlinkBelow
	/*blinkSz*/ ,1.0
	/*Font   */ ,nil
	/*bStatic*/ ,false
	/*stCol  */ ,nil
	/*stColSm*/ ,nil
			)
	end
	
	return true
end
