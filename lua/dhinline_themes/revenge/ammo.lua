ELEMENT.Name = "Ammo"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = ELEMENT.Theme:TranslateAngleToGrid( 90 )
ELEMENT.DefaultGridPosY = 12
ELEMENT.SizeX = -3
ELEMENT.SizeY = -1.50

ELEMENT.MEM_MaxAmmo = {}
ELEMENT.MEM_EverHadPrim = {}
ELEMENT.MEM_EverHadSec = {}
ELEMENT.MEM_LastSwep = nil
ELEMENT.MEM_LastPrim = nil
ELEMENT.MEM_LastSec = nil

ELEMENT.GoodColor = ELEMENT.Theme:GetColorReference( "basecolor" )
ELEMENT.BadColor = ELEMENT.Theme:GetColorReference( "badcolor" )
ELEMENT.NeutralColor = ELEMENT.Theme:GetColorReference( "backcolor" )

local TYPE_NONE = 0
local TYPE_WEAP = 1
local TYPE_PROJ = 0

function ELEMENT:Initialize( )
	self:SetUsePolar()
	
	self:CreateSmoother("primarycharge"  , 1, 0.2)
	self:CreateSmoother("secondarycharge", 1, 0.2)
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
		local primFrac = 1
	
		local SWEP = LocalPlayer():GetActiveWeapon()
		if (self.MEM_LastSwep != SWEP) then
			self:ChangeSmootherCurrent("secondarycharge", 1)
			self:ChangeSmootherCurrent("primarycharge", 1)
			
			self.MEM_LastPrim = nil
			self.MEM_LastSec  = nil
		end
		
		// PRIMARY
		local iWhatWeapon, iRemainInClip, iRemainInPocket, iClipMaxAmmo, bEverHadPrim = self:CalcPrimaryAmmo()
		if iWhatWeapon == TYPE_WEAP then
			local rate = iRemainInClip / iClipMaxAmmo
			self.SizeX = -3 - 1 * math.Clamp( (iClipMaxAmmo - 8) * 0.1, -1, 1)
			
			primFrac = ((iClipMaxAmmo <= 12) and iClipMaxAmmo) or ((iClipMaxAmmo % 3 == 0) and 6 or 4)
			
			self:DrawFractionBoxTrimmed( rate, primFrac, 1, self.GoodColor, (rate > 0 or iClipMaxAmmo <= 1) and self.NeutralColor or self.BadColor, 0, 0.33)
			self:DrawText( iRemainInClip .. " | " .. iRemainInPocket, false, self.GoodColor )

		
		elseif (iWhatWeapon == TYPE_PROJ) and bEverHadPrim then
			if (iRemainInPocket > 0) and self.MEM_LastPrim and self.MEM_LastPrim > iRemainInPocket then
				self:ChangeSmootherCurrent("primarycharge", 0)
			end
			
			self:DrawFractionBoxTrimmed( (iRemainInPocket > 0) and self:GetSmootherCurrent("primarycharge") or 0 , 1, 1, self.GoodColor, self.NeutralColor, 0, 0.33)
			self:DrawText( iRemainInPocket, false, self.GoodColor )
			
			self.MEM_LastPrim = iRemainInPocket
		end
		
		// SECONDARY
		local bHasSecondary, iRemainInOtherPocket, bEverHadSec = self:CalcSecondaryAmmo()
		
		if bEverHadSec then
			if bHasSecondary and self.MEM_LastSec and self.MEM_LastSec > iRemainInOtherPocket then
				self:ChangeSmootherCurrent("secondarycharge", 0)
			end
		
			self:DrawFractionBoxTrimmed( bHasSecondary and self:GetSmootherCurrent("secondarycharge") or 0, 1, 1, self.GoodColor, self.NeutralColor, 0.75, 0, primFrac)
			self:DrawText( (iRemainInOtherPocket > 0) and iRemainInOtherPocket or "" , true, self.GoodColor )
			self.MEM_LastSec = iRemainInOtherPocket
		end
		
		self.MEM_LastSwep = SWEP
	end
	
	return true
end
