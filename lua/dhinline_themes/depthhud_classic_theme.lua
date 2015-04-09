THEME.Name = "DepthHUD Classic"


THEME.GenericBoxHeight = 44
THEME.GenericBoxWidth  = math.floor(THEME.GenericBoxHeight * 2.2)
THEME.InnerSquareProportions = 0.7

THEME.hudlag = {}
THEME.hudlag.la = EyeAngles()
THEME.hudlag.wasInVeh = false
THEME.hudlag.x = 0
THEME.hudlag.y = 0
THEME.hudlag.mul = 2
THEME.hudlag.retab = 0.2
THEME.GlowTexture       = surface.GetTextureID("sprites/light_glow02_add")

THEME.BaseColor = Color(0,0,0,0)
THEME.BaseLesserColor = Color(0,0,0,0)
THEME.BackColor = Color(0,0,0,0)
THEME.BadColor = Color(0,0,0,0)
THEME.ErrorColor  = Color(255,0,0,0)

THEME.STOR_HUDPATCH_Volatile = {}
THEME.TEMP_ACalc = Color(0,0,0,0)
THEME.TEMP_BCalc = Color(0,0,0,0)
THEME.TEMP_CCalc = Color(0,0,0,0)

THEME.PARAM_HUDLAG_BOX    = 1
THEME.PARAM_HUDLAG_INBOX  = 1.5
THEME.PARAM_HUDLAG_TEXT   = 1.25
THEME.PARAM_BLINK_PERIOD  = 0.5

function THEME:Load()
	self:AddParameter("hudlag_mul", { Type = "slider", Defaults = "2", Min = "0", Max = "4", Decimals = "2", Text = "HUD Lag : Dispersion" } )
	self:AddParameter("hudlag_retab", { Type = "slider", Defaults = "0.2", Min = "0.1", Max = "0.4", Decimals = "2", Text = "HUD Lag : Repel (0.2 Recommended)" } )

	self:AddParameter("blendfonts", { Type = "checkbox", Defaults = "1", Text = "Fonts use Additive Mode" } )
	//self:AddParameter("dynamicbackground", { Type = "checkbox", Defaults = "0", Text = "Enable Dynamic Background" } )
	self:AddParameter("glow", { Type = "checkbox", Defaults = "1", Text = "Enable HUD Glow" } )
	
	self:AddParameter("glowintensity", { Type = "slider", Defaults = "0.4", Min = "0", Max = "1", Decimals = "2", Text = "Glow Intensity" } )
	self:AddParameter("glowsize", { Type = "slider", Defaults = "5", Min = "2", Max = "10", Decimals = "1", Text = "Glow Size" } )
	
	self:AddParameter("basecolor_label", { Type = "label", Defaults = "", Text = "Base Color" } )
	self:AddParameter("basecolor", { Type = "color", Defaults = {"255","220","0","192"} } )
	self:AddParameter("backcolor_label", { Type = "label", Defaults = "", Text = "Back Color" } )
	self:AddParameter("backcolor", { Type = "color", Defaults = {"0","0","0","92"} } )
	self:AddParameter("badcolor_label", { Type = "label", Defaults = "", Text = "Bad Color" } )
	self:AddParameter("badcolor", { Type = "color", Defaults = {"255","0","0","192"} } )
	
	self:AddParameter("box_scale", { Type = "slider", Defaults = "44", Min = "34", Max = "54", Decimals = "0", Text = "Base Scale" } )
	self:AddParameter("box_width", { Type = "slider", Defaults = "2.2", Min = "2.2", Max = "5", Decimals = "1", Text = "Width Scale" } )
	surface.CreateFont("dhfont_hl2num", 		{font = "halflife2",size = 36, weight = 0})
	surface.CreateFont("dhfont_hl2nummedium",   {font = "halflife2",size = 26, weight = 0})
	surface.CreateFont("dhfont_hl2numsmall", 	{font = "halflife2",size = 20, weight = 0})
	surface.CreateFont("dhfont_textlarge", 		{font = "DIN Light",size = 36, weight = 0})
	surface.CreateFont("dhfont_textmedium", 	{font = "DIN Light",size = 24, weight = 0})
	surface.CreateFont("dhfont_textsmall", 		{font = "DIN Medium",size = 16, weight = 400})
	surface.CreateFont("dhfont_textmediumbold", {font = "DIN Medium",size = 24, weight = 0})
	
	surface.CreateFont("dhfont_hl2num_noblend", 		{font = "halflife2",size = 36, weight = 0})
	surface.CreateFont("dhfont_hl2nummedium_noblend",   {font = "halflife2",size = 26, weight = 0})
	surface.CreateFont("dhfont_hl2numsmall_noblend", 	{font = "halflife2",size = 20, weight = 0})
	surface.CreateFont("dhfont_textlarge_noblend", 		{font = "DIN Light",size = 36, weight = 0})
	surface.CreateFont("dhfont_textmedium_noblend", 	{font = "DIN Light",size = 24, weight = 0})
	surface.CreateFont("dhfont_textsmall_noblend", 		{font = "DIN Medium",size = 16, weight = 400})
	surface.CreateFont("dhfont_textmediumbold_noblend", {font = "DIN Medium",size = 24, weight = 0})
	-- surface.CreateFont("halflife2", 36, 0   , 0, 0, "dhfont_hl2num" )
	-- surface.CreateFont("halflife2", 26, 2   , 0, 0, "dhfont_hl2nummedium" )
	-- surface.CreateFont("halflife2", 20, 0   , 0, 0, "dhfont_hl2numsmall" )
	-- surface.CreateFont("DIN Light", 36, 0   , 0, 0, "dhfont_textlarge" )
	-- surface.CreateFont("DIN Light", 24, 2   , 0, 0, "dhfont_textmedium" )
	-- surface.CreateFont("DIN Medium", 16, 400, 0, 0, "dhfont_textsmall" )
	-- surface.CreateFont("DIN Medium", 24, 2  , 0, 0, "dhfont_textmediumbold" )

	-- surface.CreateFont("halflife2", 36, 0   , 0, false, "dhfont_hl2num_noblend" )
	-- surface.CreateFont("halflife2", 26, 2   , 0, false, "dhfont_hl2nummedium_noblend" )
	-- surface.CreateFont("halflife2", 20, 0   , 0, false, "dhfont_hl2numsmall_noblend" )
	-- surface.CreateFont("DIN Light", 36, 0   , 0, false, "dhfont_textlarge_noblend" )
	-- surface.CreateFont("DIN Light", 24, 2   , 0, false, "dhfont_textmedium_noblend" )
	-- surface.CreateFont("DIN Medium", 16, 400, 0, false, "dhfont_textsmall_noblend" )
	-- surface.CreateFont("DIN Medium", 24, 2  , 0, false, "dhfont_textmediumbold_noblend" )
end

function THEME:Unload()
	self:DeleteAllVolatiles()
end

function THEME:GetAppropriateFont(text, desiredChoice)
	local font = ""
	desiredChoice = desiredChoice or 2
	if (desiredChoice == -1) then
		if type(text) == "number" then
			font = "dhfont_hl2nummedium"
		else
			font = "dhfont_textmediumbold"
		end
	elseif (desiredChoice >= 2) then
		if type(text) == "number" then
			font = "dhfont_hl2num"
		else
			font = "dhfont_textlarge"
		end

	elseif (desiredChoice == 1) then 
		if type(text) == "number" then
			font = "dhfont_hl2nummedium"
		else
			font = "dhfont_textmedium"
		end
	else
		if type(text) == "number" then
			font = "dhfont_hl2numsmall"
		else
			font = "dhfont_textsmall"
		end
	end
	if (self:GetNumber("blendfonts") <= 0) then
		font = font .. "_noblend"
	end
	return font
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:RAW_DrawRoundedBox( xPos, yPos, width, height, cColor, opt_ForceRound )
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
	
	draw.RoundedBox( boxRound, xPos, yPos, width, height, cColor )
end


function THEME:CalcDispellModifiers(xRel, yRel, width, height, dispell)
	local xCenter, yCenter = dhinline.CalcCenter( xRel , yRel , width , height )
	
	width  = (1.0 + dispell*0.5) * width
	height = (1.0 + dispell*0.5) * height

	return xCenter, yCenter, width, height
end

function THEME:DrawElementSizedBoxFromCenter(xCenter, yCenter, width, height, cColor, dispell)
	if dispell > 0.95 then return end
	
	xCenter = xCenter + self:HudLagX() * self.PARAM_HUDLAG_BOX
	yCenter = yCenter + self:HudLagY() * self.PARAM_HUDLAG_BOX
	
	cColor = cColor or self:GetColorReference( "backcolor" )
	GC_ColorCopy(self.TEMP_ACalc, cColor)
	if dispell > 0 then
		self.TEMP_ACalc.a = self.TEMP_ACalc.a * (1.0 - dispell)
	end
	
	self:RAW_DrawRoundedBox(xCenter - width * 0.5, yCenter - height * 0.5, width, height, self.TEMP_ACalc)
end

function THEME:DrawInnerBoxFromCenter(xCenter, yCenter, width, height, rate, bIsAtRight, cColor, dispell)
	if dispell > 0.95 then return end
	
	xCenter = xCenter + self:HudLagX() * self.PARAM_HUDLAG_INBOX
	yCenter = yCenter + self:HudLagY() * self.PARAM_HUDLAG_INBOX
	
	cColor = cColor or self:GetColorReference( "basecolor" ) --_lesser" )
	GC_ColorCopy(self.TEMP_ACalc, cColor)
	self.TEMP_ACalc.a = self.TEMP_ACalc.a * 0.5
	
	if dispell > 0 then
		self.TEMP_ACalc.a = self.TEMP_ACalc.a * (1.0 - dispell)
	end
	
	local mySize = height * self.InnerSquareProportions * rate
	local myGap  = (height - mySize) * 0.5
	
	xCenter = xCenter + ( -width * 0.5 + myGap + mySize * 0.5) * (bIsAtRight and -1 or 1)
	yCenter = yCenter - height * 0.5 + myGap + mySize * 0.5
	
	self:RAW_DrawRoundedBox(xCenter - mySize*0.5, yCenter - mySize*0.5, mySize, mySize, self.TEMP_ACalc)
	
	if (self:GetNumber("glow") > 0) then
		local glowAlpha = self:GetNumber("glowintensity") * ( self.TEMP_ACalc.a / 255 )
		local glowSize = mySize * self:GetNumber("glowsize")
		GC_ColorRatio( self.TEMP_ACalc, glowAlpha, glowAlpha, glowAlpha, 1)
		dhinline.DrawSprite(self.GlowTexture, xCenter, yCenter, glowSize, glowSize, 0, self.TEMP_ACalc.r, self.TEMP_ACalc.g, self.TEMP_ACalc.b, 255)
	end
end

function THEME:DrawGenericTextFromCenter(xCenter, yCenter, width, height, text, smallText, textColor, textColorSmall, fontChoice, lagAdditive, insideBoxXEquirel, insideBoxYEquirel, dispell)
	
	textColor = textColor or self:GetColorReference( "basecolor" )
	textColorSmall = textColorSmall or textColor
	
	GC_ColorCopy(self.TEMP_ACalc, textColor)
	GC_ColorCopy(self.TEMP_BCalc, textColorSmall)
	if dispell > 0 then
		self.TEMP_ACalc.a = self.TEMP_ACalc.a * (1.0 - dispell)
		self.TEMP_BCalc.a = self.TEMP_BCalc.a * (1.0 - dispell)
	end
	
	xText = self:HudLagX() * self.PARAM_HUDLAG_TEXT + self:HudLagX() * lagAdditive + xCenter + insideBoxXEquirel*0.5*width
	
	yText = self:HudLagY() * self.PARAM_HUDLAG_TEXT + self:HudLagY() * lagAdditive + yCenter + insideBoxYEquirel*0.5*height
	
	yTextSmall = self.hudlag.y*self.PARAM_HUDLAG_TEXT + self:HudLagY() * lagAdditive + yCenter + height*0.40 + insideBoxYEquirel*0.5*height
	
	
	local font = self:GetAppropriateFont(text, fontChoice)
	draw.SimpleText(text or "", font, xText, yText, self.TEMP_ACalc, 1, 1 )
	
	if (smallText != "") then
		local fontSmall = self:GetAppropriateFont(smallText, 0)
		draw.SimpleText(smallText, fontSmall, xText, yTextSmall, self.TEMP_BCalc, 1, 1 )
	end
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:DrawGenericTextForInfobox(xRel, yRel, width, height, text, smallText, boxIsAtRight, textColor, textColorSmall, fontChoice, lagAdditive, insideBoxXEquirel, insideBoxYEquirel, dispell)

	local xCenter, yCenter = 0, 0
	xCenter, yCenter, width, height = self:CalcDispellModifiers(xRel, yRel, width, height, dispell)
	
	local myDist = ((height + height * (1 - self.InnerSquareProportions * 0.5)) * 0.5) / width
	
	self:DrawGenericTextFromCenter(xCenter, yCenter, width, height, text, smallText, textColor, textColorSmall, fontChoice, 0, (boxIsAtRight and -1 or 1) * (myDist), 0, dispell)
	
end

function THEME:DrawGenericInfobox(xRel, yRel, width, height, text, smallText, rate, boxIsAtRight, falseColor, trueColor, minSize, maxSize, blinkBelowRate, blinkSize, mainFontChoice, useStaticTextColor, opt_textColor, opt_smallTextColor, dispell)

	local xCenter, yCenter = 0, 0
	local newRate = 0
	xCenter, yCenter, width, height = self:CalcDispellModifiers(xRel, yRel, width, height, dispell)
	
	falseColor = falseColor or self:GetColorReference( "basecolor" ) --_lesser" )
	trueColor = trueColor or self:GetColorReference( "basecolor" ) --_lesser" )
	GC_ColorBlend(self.TEMP_BCalc, falseColor, trueColor, rate)
	
	local originalAlpha = self.TEMP_BCalc.a
	if (rate <= blinkBelowRate) then
		self.TEMP_BCalc.a = self.TEMP_BCalc.a * (RealTime() % self.PARAM_BLINK_PERIOD) * (1 / self.PARAM_BLINK_PERIOD)
		newRate = blinkSize
	else
		newRate = minSize + rate * (maxSize - minSize) 
	end
	
	local myDist = ((height + height * (1 - self.InnerSquareProportions * 0.5)) * 0.5) / width
	
	self:DrawElementSizedBoxFromCenter(xCenter, yCenter, width, height, cColor, dispell)
	
	self:DrawInnerBoxFromCenter(xCenter, yCenter, width, height, newRate, boxIsAtRight, self.TEMP_BCalc, dispell)
	
	self.TEMP_BCalc.a = originalAlpha
	self:DrawGenericTextFromCenter(xCenter, yCenter, width, height, text, smallText, (not useStaticTextColor and self.TEMP_BCalc) or opt_textColor, (not useStaticTextColor and self.TEMP_BCalc) or opt_smallTextColor, mainFontChoice, 0, (boxIsAtRight and -1 or 1) * (myDist), 0, dispell)

end

function THEME:DrawGenericContentbox(xRel, yRel, width, height, text, smallText, textColor, textColorSmall, fontChoice, dispell)
	local xCenter, yCenter = 0, 0
	xCenter, yCenter, width, height = self:CalcDispellModifiers(xRel, yRel, width, height, dispell)
	
	
	self:DrawElementSizedBoxFromCenter(xCenter, yCenter, width, height, nil, dispell)
	self:DrawGenericTextFromCenter(xCenter, yCenter, width, height, text, smallText, textColor, textColorSmall, fontChoice, 0, 0, 0.02, dispell)
end

function THEME:DrawGenericText(xRel, yRel, width, height, text, smallText, textColor, textColorSmall, fontChoice, lagAdditive, insideBoxXEquirel, insideBoxYEquirel, dispell)

	local xCenter, yCenter = 0, 0
	xCenter, yCenter, width, height = self:CalcDispellModifiers(xRel, yRel, width, height, dispell)
	
	self:DrawGenericTextFromCenter(xCenter, yCenter, width, height, text, smallText, textColor, textColorSmall, fontChoice, lagAdditive, insideBoxXEquirel, insideBoxYEquirel, dispell)
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

function THEME:DrawVolatile( xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice)
	local xCalc, yCalc = dhinline.CalcCenter( xRel , yRel , width , height )
	local xCalcOffset, yCalcOffset = xRelOffset*0.5*width, yRelOffset*0.5*height
	
	xCalc, yCalc = xCalc + xCalcOffset + self.hudlag.x*lagMultiplier , yCalc + yCalcOffset + self.hudlag.y*lagMultiplier
	
	local font = self:GetAppropriateFont(text, fontChoice)
	draw.SimpleText(text, font, xCalc, yCalc, textColor, 1, 1 )
end

function THEME:GetVolatileStorage(name)
	if (self.STOR_HUDPATCH_Volatile[name] == nil) then
		return nil
	end
	return self.STOR_HUDPATCH_Volatile[name][10] or nil
end

function THEME:UpdateVolatile(name, xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice, duration, fadePower, storage)
	self.STOR_HUDPATCH_Volatile[name] = {}
	self.STOR_HUDPATCH_Volatile[name][1] = xRel
	self.STOR_HUDPATCH_Volatile[name][2] = yRel
	self.STOR_HUDPATCH_Volatile[name][3] = text
	self.STOR_HUDPATCH_Volatile[name][4] = textColor
	self.STOR_HUDPATCH_Volatile[name][5] = lagMultiplier
	self.STOR_HUDPATCH_Volatile[name][6] = duration
	self.STOR_HUDPATCH_Volatile[name][7] = fadePower
	self.STOR_HUDPATCH_Volatile[name][8] = fontChoice
	self.STOR_HUDPATCH_Volatile[name][9] = RealTime()
	self.STOR_HUDPATCH_Volatile[name][10] = storage
	self.STOR_HUDPATCH_Volatile[name][11] = width
	self.STOR_HUDPATCH_Volatile[name][12] = height
	self.STOR_HUDPATCH_Volatile[name][13] = xRelOffset
	self.STOR_HUDPATCH_Volatile[name][14] = yRelOffset
end

function THEME:DrawVolatiles()
	for name,subtable in pairs(self.STOR_HUDPATCH_Volatile) do	
		if (subtable[1] != nil) then
			local timeSpawned = self.STOR_HUDPATCH_Volatile[name][9]
			local duration    = self.STOR_HUDPATCH_Volatile[name][6]
			
			if ((RealTime() - timeSpawned) > duration) then
				self.STOR_HUDPATCH_Volatile[name] = {nil}
			else
				local stayedUpRel = (RealTime() - timeSpawned) / duration
				
				local xRel = self.STOR_HUDPATCH_Volatile[name][1]
				local yRel = self.STOR_HUDPATCH_Volatile[name][2]
				local text = self.STOR_HUDPATCH_Volatile[name][3]
				local lagMultiplier = self.STOR_HUDPATCH_Volatile[name][5]
				local fadePower = self.STOR_HUDPATCH_Volatile[name][7]
				local fontChoice = self.STOR_HUDPATCH_Volatile[name][8]
				local width = self.STOR_HUDPATCH_Volatile[name][11]
				local height = self.STOR_HUDPATCH_Volatile[name][12]
				local xRelOffset = self.STOR_HUDPATCH_Volatile[name][13]
				local yRelOffset = self.STOR_HUDPATCH_Volatile[name][14]
				
				local textColor = Color(self.STOR_HUDPATCH_Volatile[name][4].r, self.STOR_HUDPATCH_Volatile[name][4].g, self.STOR_HUDPATCH_Volatile[name][4].b, self.STOR_HUDPATCH_Volatile[name][4].a)
				textColor.a = textColor.a * (1 - (stayedUpRel^fadePower))
				
				self:DrawVolatile(xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice)
			end
		end
		
	end
end

function THEME:DeleteAllVolatiles()
	self.STOR_HUDPATCH_Volatile = {}
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:GetColorReference( sColorLitteral )
	if     sColorLitteral == "basecolor" then return self.BaseColor
	elseif sColorLitteral == "backcolor" then return self.BackColor
	elseif sColorLitteral == "basecolor_lesser" then return self.BaseLesserColor
	elseif sColorLitteral == "badcolor" then return self.BadColor end
	
	print(">-- Classic Theme ERROR : Requested color ".. sColorLitteral .. " that doesn't exist !")
	
	return self.ErrorColor
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

function THEME:Think( )
	self.hudlag.mul   = self:GetParameterSettings("hudlag_mul")
	self.hudlag.retab = self:GetParameterSettings("hudlag_retab")

	dhinline.PrimeColorFromTable( self.BaseColor, self:GetParameterSettings("basecolor") )
	dhinline.PrimeColorFromTable( self.BackColor, self:GetParameterSettings("backcolor") )
	dhinline.PrimeColorFromTable( self.BadColor, self:GetParameterSettings("badcolor") )
	
	self.GenericBoxHeight = self:GetParameterSettings("box_scale")
	self.GenericBoxWidth = math.floor(self.GenericBoxHeight * self:GetParameterSettings("box_width"))
	
	GC_ColorCopy( self.BaseLesserColor , self.BaseColor )
	self.BaseLesserColor.a = self.BaseLesserColor.a * 0.5
	
	self:CalcHudLag( )
end

function THEME:PaintMisc( )
	self:DrawVolatiles()
end
