ELEMENT.Name = "Ammo : Secondary"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 16
ELEMENT.DefaultGridPosY = 14
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.MEM_EverHadSec = {}

ELEMENT.GoodColor = ELEMENT.Theme:GetColorReference( "basecolor" )
ELEMENT.BadColor = ELEMENT.Theme:GetColorReference( "badcolor" )
ELEMENT.NeutralColor = ELEMENT.Theme:GetColorReference( "backcolor" )

function ELEMENT:Initialize( )
	self.MemColor = nil
	self.MemRate = 0.0
	self.MemBlinkBelow = 0.0
	self.MemText  = ""
	self.MemSmallText = ""
end

function ELEMENT:CalcSecondaryAmmo()
	local SWEP = LocalPlayer():GetActiveWeapon()
	
	local sSecondaryType = ""
	local iClipMaxAmmo   = -1
	local iRemainInOtherPocket = -1
	local bHasSecondary = false
	local bEverHadSec = false
	
	if SWEP:IsValid() then
		sSecondaryType = SWEP:GetSecondaryAmmoType() or ""
		iRemainInOtherPocket = LocalPlayer():GetAmmoCount(sSecondaryType) or -1
		
	else
		iRemainInOtherPocket = -1
		
	end
	
	bHasSecondary = (iRemainInOtherPocket > 0)
	bEverHadSec = self.MEM_EverHadSec[SWEP] or bHasSecondary
	self.MEM_EverHadSec[SWEP] = bEverHadSec
	
	return bHasSecondary, iRemainInOtherPocket, bEverHadSec
end

function ELEMENT:DrawFunction( )
	if LocalPlayer():Alive() then
		local bHasSecondary, iRemainInOtherPocket, bEverHadSec = self:CalcSecondaryAmmo()
		
		if bEverHadSec then
			if iRemainInOtherPocket > 0 then
				self:FadeIn()
			else
				self:FadeOut()
			end
			
			self.MemRate = 1.0
			self.MemBlinkBelow = -1
			self.MemColor = self.GoodColor
			self.MemText = iRemainInOtherPocket
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
