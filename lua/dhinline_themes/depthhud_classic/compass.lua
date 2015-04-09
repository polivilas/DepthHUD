ELEMENT.Name = "Compass"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 1
ELEMENT.SizeX = -2.0
ELEMENT.SizeY = -0.75

ELEMENT.baseAlpha = -1
ELEMENT.textColor = Color(0,0,0)
ELEMENT.textSmall = ""
ELEMENT.textSmallColor = Color(0,0,0)
ELEMENT.textSmallColorReference = nil
ELEMENT.textColorBaseAlpha = 0
ELEMENT.MaxFramerate = 100
ELEMENT.colorXcoords = Color(255,0,0,192)
ELEMENT.colorYcoords = Color(0,255,0,192)
ELEMENT.EyeAng = nil
ELEMENT.yaw = nil

ELEMENT.myReferal = 0
ELEMENT.myXEquirel = 0
ELEMENT.myYEquirel = 0
ELEMENT.myAlphaAlter = 0

ELEMENT.baseColor = ELEMENT.Theme:GetColorReference("basecolor")

ELEMENT.tvars = {}
ELEMENT.pointsCard = {
	[0] = "N",
	[45] = "NE",
	[90] = "E",
	[135] = "SE",
	[180] = "S",
	[225] = "SW",
	[270] = "W",
	[315] = "NW",
}
ELEMENT.pointsSmall = {
	[0] = "Y+",
	[45] = "|",
	[90] = "X+",
	[135] = "|",
	[180] = "Y-",
	[225] = "|",
	[270] = "X-",
	[315] = "|",
}
ELEMENT.pointsSmallColor = {
	[0]   = ELEMENT.colorYcoords,
	[90]  = ELEMENT.colorXcoords,
	[180] = ELEMENT.colorYcoords,
	[270] = ELEMENT.colorXcoords
}

function ELEMENT:Initialize( )
	for i = 0,359,15 do
		if not self.pointsCard[i] then
			self.pointsCard[i] = "."
		end
	end
end

function ELEMENT:DrawFunction( )
	self:FadeIn()
	
	self.EyeAng = EyeAngles()
	self.yaw = self.EyeAng.y
	
	self:DrawGenericContentbox(
/*Text   */ ""
/*Subtxt */ ,""
/*Txtcol */ ,nil
/*Stxtcol*/ ,nil
/*FontN  */ ,0
	)
	GC_ColorCopy( self.textColor, self.baseColor )
	self.baseTextAlpha = self.textColor.a
	
	for k,text in pairs(self.pointsCard) do
		self.myReferal = (self.yaw + k) / 180 * math.pi
		self.myXEquirel = math.sin(self.myReferal)
		if self.myXEquirel > 0 then
			self.myYEquirel = math.cos(self.myReferal)
			
			self.myAlphaAlter =  (1 - (1 - self.myXEquirel ^ 2) )
			
			// Big compass stands
			self.textColor.a = self.baseTextAlpha * self.myAlphaAlter
			
			// Small compass stands
			if (self.pointsSmall[k]) then
				if self.pointsSmallColor[k] then
					// Direct color override.
					self.textSmallColor = self.pointsSmallColor[k]
					self.textSmallColor.a = self.baseTextAlpha * self.myAlphaAlter
					self.textSmallColorReference = self.textSmallColor
					
				else
					self.textSmallColorReference = self.textColor
					
				end
					
				self.textSmall = self.pointsSmall[k]
			
			else
				self.textSmall = ""
				self.textSmallColorReference = nil
			end

			self:DrawGenericText(text, self.textSmall, self.textColor, self.textSmallColorReference, -1, self.myXEquirel * 0.2, self.myYEquirel * 0.9, -0.3 )
		end
	end
	
	return true
end
