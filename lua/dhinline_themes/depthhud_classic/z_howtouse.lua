ELEMENT.Name = "##Menu Notice (Disable me !)"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 4
ELEMENT.SizeX = nil
ELEMENT.SizeY = -0.7

ELEMENT.BlinkColor = Color(0, 255, 0, 255)
ELEMENT.SpinTimeInPersist = 0.5
ELEMENT.PersistTime = 30.0
ELEMENT.SafeTime = 4.0

ELEMENT.Text = DHINLINE_NAME .. " has been loaded ! Type dhinline_menu in the console to customize it !"
ELEMENT.SmallText = "( You may also want to disable this popup in the menu ! )"

ELEMENT.NeverDraw = false
ELEMENT.CalcTextd = false

function ELEMENT:Initialize( )
	self.InitTime = RealTime()
end

function ELEMENT:DrawFunction( )
	if self.NeverDraw then return end
	
	if RealTime() > (self.InitTime + self.SpinTimeInPersist) and RealTime() < (self.InitTime + self.PersistTime) then
		
		self:FadeIn()
		
		if not self.CalcTextd then
			surface.SetFont( self.Theme:GetAppropriateFont(self.Text, 1) )
			local wB, hB = surface.GetTextSize( self.Text )
			surface.SetFont( self.Theme:GetAppropriateFont(self.SmallText, 0) )
			local wS, hS = surface.GetTextSize( self.SmallText )
			local w = math.Max(wB,wS)
			self.SizeX = w + 44
			
			self.CalcTextd = true
		end
		
	else
		self:FadeOut()
		
	end
	
	if self:ShouldDraw() then
		self:DrawGenericInfobox(
	/*Text   */ self.Text
	/*Subtxt */ ,self.SmallText
	/* %     */ ,0.0
	/*atRight*/ ,false
	/*0.0 col*/ ,self.BlinkColor
	/*1.0 col*/ ,nil
	/*minSize*/ ,0.5
	/*maxSize*/ ,1.0
	/*blink< */ ,1.0
	/*blinkSz*/ ,1.0
	/*Font   */ ,1
	/*bStatic*/ ,true
	/*stCol  */ ,nil
	/*stColSm*/ ,nil
		)
	end
	
	if RealTime() > (self.InitTime + self.PersistTime + self.SafeTime) then
		self.NeverDraw = true
	end
	
	return true
end
