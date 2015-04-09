THEME.Name = "Revenger"


THEME.GenericBoxHeight = ScreenScale(16)
THEME.GenericBoxWidth  = ScreenScale(16)

THEME.BaseColor = Color(0,0,0,0)
THEME.BackColor = Color(0,0,0,0)
THEME.BadColor  = Color(0,0,0,0)

THEME.hudlag = {}
THEME.hudlag.la = EyeAngles()
THEME.hudlag.wasInVeh = false
THEME.hudlag.x = 0
THEME.hudlag.y = 0
THEME.hudlag.mul = 2
THEME.hudlag.retab = 0.2

function THEME:Load()
	surface.CreateFont("DefaultLarge", {
	font = "Arial", 
	size = 26, 
	weight = 500})
	self:AddParameter("hudlag_mul", { Type = "slider", Defaults = "2", Min = "0", Max = "4", Decimals = "2", Text = "HUD Lag : Dispersion" } )
	self:AddParameter("hudlag_retab", { Type = "slider", Defaults = "0.2", Min = "0.1", Max = "0.4", Decimals = "2", Text = "HUD Lag : Repel (0.2 Recommended)" } )

	self:AddParameter("basecolor_label", { Type = "label", Defaults = "", Text = "Base Color" } )
	self:AddParameter("basecolor", { Type = "color", Defaults = {"240","240","255","192"} } )
	self:AddParameter("backcolor_label", { Type = "label", Defaults = "", Text = "Back Color" } )
	self:AddParameter("backcolor", { Type = "color", Defaults = {"0","0","0","92"} } )
	self:AddParameter("badcolor_label", { Type = "label", Defaults = "", Text = "Bad Color" } )
	self:AddParameter("badcolor", { Type = "color", Defaults = {"192","0","0","192"} } )
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:GetFontName( sText )
	return "DefaultLarge"
end

function THEME:TranslateAngleToGrid( iAngle )
	return (iAngle/360)*dhinline.GetGridDivideMax() % dhinline.GetGridDivideMax()
end

function THEME:GetRelPosFromPolar( fGAngle, fGDistance )
	fGAngle = fGAngle + self:HudLagX()*0.01
	local fAngle = math.rad((fGAngle / dhinline.GetGridDivideMax())*360)
	local fDistance = (fGDistance / dhinline.GetGridDivideMax())
	
	return (1+math.cos(fAngle)*fDistance)*0.5, (1+math.sin(fAngle)*fDistance)*0.5 * (1 + self:HudLagY()*0.01)
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:RAW_DrawRoundedBox( xPos, yPos, width, height, color, opt_ForceRound )
	local boxSizeCalc = math.Min(width, height) / 44
	local boxRound = 8
	if opt_ForceRound then
		boxRound = opt_ForceRound
	elseif boxSizeCalc <= 0.25 then
		boxRound = 0
	elseif boxSizeCalc > 0.25 and boxSizeCalc <= 0.5 then
		boxRound = 4
	elseif boxSizeCalc > 0.5 and boxSizeCalc <= 0.75 then
		boxRound = 6
	else
		boxRound = 8
	end
	
	draw.RoundedBox( boxRound, xPos, yPos, width, height, color )
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:DrawText( xRel , yRel , width , height, sText, bBottom, cColor )
	local xCenter,yCenter = dhinline.CalcCenter( xRel , yRel , width , height )
	
	surface.SetFont(self:GetFontName())
	local wB, hB = surface.GetTextSize( sText )
	
	local cColorRef = cColor or self:GetColorReference("basecolor")
	
	surface.SetTextPos(xCenter - wB * 0.5, yCenter + (bBottom and 1 or -1) * (height + hB)* 0.5 - hB * 0.5)
	surface.SetTextColor(cColorRef.r, cColorRef.g, cColorRef.b, cColorRef.a)
	surface.DrawText( tostring(sText) )
end

function THEME:DrawFractionBoxTrimmed( xRel , yRel , width , height, rate, fractionning, levels, cFirst, cLast, fTop, fBottom, opt_FracSim )
	
	if (fractionning <= 0) then fractionning = 1 end
	
	local gap = 2
	local widthGlobal = math.ceil(width / (opt_FracSim or fractionning))
	
	width = widthGlobal * (opt_FracSim or fractionning)
	
	widthGlobal = math.ceil(width / fractionning)
	widthDrawn = widthGlobal - gap
	
	local xCenter,yCenter = dhinline.CalcCenter( xRel , yRel , width , height )
	
	rate = math.Clamp(rate, 0, 1)
	
	local todraw = math.ceil(fractionning * rate)
	
	for i=1,todraw do
		self:RAW_DrawRoundedBox( xCenter - width * 0.5 + (widthGlobal * (i-1)) + gap/2,
								 yCenter - height * 0.5 + fTop * height,
								 (i != todraw) and widthDrawn or widthDrawn * (rate - (todraw - 1)*(1.0/fractionning))*fractionning ,
								 height * (1 - fTop - fBottom),
								 cFirst or self:GetColorReference("basecolor"),
								 0
								)
	end
	for i=todraw,fractionning do
		self:RAW_DrawRoundedBox( xCenter - width * 0.5 + (widthGlobal * (i-1)) + ((i == todraw) and (widthDrawn * (rate - (todraw - 1)*(1.0/fractionning))*fractionning) or 0) + gap/2,
								 yCenter - height * 0.5 + fTop * height,
								 (i != todraw) and widthDrawn or widthDrawn * (1 - (rate - (todraw - 1)*(1.0/fractionning))*fractionning) ,
								 height * (1 - fTop - fBottom),
								 cLast or self:GetColorReference("backcolor"),
								 0
								)
	end
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:CalcHudLag( )
	if (self.hudlag.wasInVeh == LocalPlayer():InVehicle()) then
		
		self.hudlag.ca = EyeAngles()
	
		local targetX = math.AngleDifference(self.hudlag.ca.y , self.hudlag.la.y)*self.hudlag.mul
		local targetY = -math.AngleDifference(self.hudlag.ca.p , self.hudlag.la.p)*self.hudlag.mul
		
		self.hudlag.x = self.hudlag.x + (targetX - self.hudlag.x) * math.Clamp(self.hudlag.retab * 0.5 * FrameTime() * 50 , 0 , 1 )
		self.hudlag.y = self.hudlag.y + (targetY - self.hudlag.y) * math.Clamp(self.hudlag.retab * 0.5 * FrameTime() * 50 , 0 , 1 )
	
	end
	
	self.hudlag.wasInVeh = LocalPlayer():InVehicle()
	self.hudlag.la = EyeAngles()
end

function THEME:HudLagX( )
	return self.hudlag.x
end

function THEME:HudLagY( )
	return self.hudlag.y
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:GetColorReference( sColorLitteral )
	if     sColorLitteral == "basecolor" then return self.BaseColor
	elseif sColorLitteral == "backcolor" then return self.BackColor
	elseif sColorLitteral == "badcolor"  then return self.BadColor end
	
	print(">-- Revenge Theme ERROR : Requested color ".. sColorLitteral .. " that doesn't exist !")
	
	return self.ErrorColor
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:Think( )
	dhinline.PrimeColorFromTable( self.BaseColor, self:GetParameterSettings("basecolor") )
	dhinline.PrimeColorFromTable( self.BackColor, self:GetParameterSettings("backcolor") )
	dhinline.PrimeColorFromTable( self.BadColor,  self:GetParameterSettings("badcolor") )
	
	self.hudlag.mul   = self:GetParameterSettings("hudlag_mul")
	self.hudlag.retab = self:GetParameterSettings("hudlag_retab")
	self:CalcHudLag( )
end
