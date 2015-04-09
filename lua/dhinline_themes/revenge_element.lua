function ELEMENT:SetUsePolar()
	self.UsePolar = true
end

function ELEMENT:UsesPolar()
	return self.UsePolar or false
end

function ELEMENT:ConvertPolarData()
	local fGAngle, fGDistance = self:GetMyGridPos()
	local xRel , yRel  = self.Theme:GetRelPosFromPolar( fGAngle, fGDistance )
	local width, height = self:GetMySizes()
	
	return xRel, yRel, width, height
end

function ELEMENT:UseAppropriateConversion()
	if self:UsesPolar() then
		return self:ConvertPolarData()
	else
		return self:ConvertGridData()
	end
end

function ELEMENT:DrawFractionBoxTrimmed( rate, fractionning, levels, cFirst, cLast, fTop, fBottom, opt_FracSim )
	local xRel, yRel, width, height = self:UseAppropriateConversion()
	self.Theme:DrawFractionBoxTrimmed( xRel , yRel , width , height , rate, fractionning, levels, cFirst, cLast, fTop, fBottom, opt_FracSim )
end


function ELEMENT:DrawFractionBox( rate, fractionning, levels, cFirst, cLast, opt_FracSim )
	self:DrawFractionBoxTrimmed( rate, fractionning, levels, cFirst, cLast, 0, 0, opt_FracSim )
end

function ELEMENT:DrawText( sText, bBottom, cColor )
	local xRel, yRel, width, height = self:UseAppropriateConversion()
	self.Theme:DrawText( xRel , yRel , width , height , sText, bBottom, cColor )
end