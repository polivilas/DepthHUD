function ELEMENT:CoreInitialize()
	self:CreateSmoother("_dispell", 1.0, 0.32)
	//self:ChangeSmootherTarget("_dispell", 0.5)
end

// Don't call fade fcts on initialize
function ELEMENT:FadeIn()
	self:ChangeSmootherTarget("_dispell", 0.0)
end

function ELEMENT:FadeOut()
	self:ChangeSmootherTarget("_dispell", 1.0)
end

function ELEMENT:ShouldDraw()
	return self:GetSmootherCurrent("_dispell") < 0.95
end


function ELEMENT:DrawGenericTextForInfobox(text, smallText, boxIsAtRight, textColor, textColorSmall, fontChoice, lagAdditive, insideBoxXEquirel, insideBoxYEquirel)
	local xRel, yRel, width, height = self:ConvertGridData()
	local dispell = self:GetSmootherCurrent("_dispell")
	
	self.Theme:DrawGenericTextForInfobox(xRel, yRel, width, height, text, smallText, boxIsAtRight, textColor, textColorSmall, fontChoice, lagAdditive, insideBoxXEquirel, insideBoxYEquirel, dispell)
end

function ELEMENT:DrawGenericInfobox(text, smallText, rate, boxIsAtRight, falseColor, trueColor, minSize, maxSize, blinkBelowRate, blinkSize, mainFontChoice, useStaticTextColor, opt_textColor, opt_smallTextColor)
	local xRel, yRel, width, height = self:ConvertGridData()
	local dispell = self:GetSmootherCurrent("_dispell")
	
	self.Theme:DrawGenericInfobox(xRel, yRel, width, height, text, smallText, rate, boxIsAtRight, falseColor, trueColor, minSize, maxSize, blinkBelowRate, blinkSize, mainFontChoice, useStaticTextColor, opt_textColor, opt_smallTextColor, dispell)
end


function ELEMENT:DrawGenericContentbox(text, smallText, textColor, textColorSmall, fontChoice)
	local xRel, yRel, width, height = self:ConvertGridData()
	local dispell = self:GetSmootherCurrent("_dispell")
	
	self.Theme:DrawGenericContentbox(xRel, yRel, width, height, text, smallText, textColor, textColorSmall, fontChoice, dispell)
end

function ELEMENT:DrawGenericText(text, smallText, textColor, textColorSmall, fontChoice, lagAdditive, insideBoxXEquirel, insideBoxYEquirel)
	local xRel, yRel, width, height = self:ConvertGridData()
	local dispell = self:GetSmootherCurrent("_dispell")
	
	self.Theme:DrawGenericText(xRel, yRel, width, height, text, smallText, textColor, textColorSmall, fontChoice, lagAdditive, insideBoxXEquirel, insideBoxYEquirel, dispell)
end

function ELEMENT:UpdateVolatile(name, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice, duration, fadePower, storage)
	local xRel, yRel, width, height = self:ConvertGridData()
	
	self.Theme:UpdateVolatile(name, xRel, yRel, width, height, xRelOffset, yRelOffset, text, textColor, lagMultiplier, fontChoice, duration, fadePower, storage)
end

