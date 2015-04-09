ELEMENT.Name = "Health and Armor"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = ELEMENT.Theme:TranslateAngleToGrid( -90 )
ELEMENT.DefaultGridPosY = 12
ELEMENT.SizeX = -3
ELEMENT.SizeY = -1.50

ELEMENT.GoodColor = ELEMENT.Theme:GetColorReference( "basecolor" )
ELEMENT.BadColor = ELEMENT.Theme:GetColorReference( "badcolor" )
ELEMENT.NeutralColor = ELEMENT.Theme:GetColorReference( "backcolor" )

function ELEMENT:Initialize( )
	self:SetUsePolar()
end

function ELEMENT:DrawFunction( )
	if LocalPlayer():Alive() then
		self:DrawFractionBoxTrimmed( LocalPlayer():Health() / 100, 3, 1, self.GoodColor, self.BadColor, 0, 0.33)
		self:DrawText( "Health", false, self.GoodColor )

		self:DrawFractionBoxTrimmed( LocalPlayer():Armor() / 100, 1, 1, self.GoodColor, self.NeutralColor, 0.75, 0)
		self:DrawText( "Armor", true, self.GoodColor )
	end
end
