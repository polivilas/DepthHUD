ELEMENT.Name = "Vehicle Speedometer (KMH)"
ELEMENT.DefaultOff = true
ELEMENT.DefaultGridPosX = 16
ELEMENT.DefaultGridPosY = 0
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.Unit = "KM/H"
ELEMENT.UNITLIST = {
	["MPH"] = {
		63360 / 3600,
		"MPH",
	},
	["KM/H"] = {
		39370.0787 / 3600,
		"KM/H",
	},
}

function ELEMENT:Initialize( )
	self.LastText = ""
	self.MemRate = 0
end

function ELEMENT:DrawFunction( )
	//Vehicle Speed
	if LocalPlayer():InVehicle() then
		self:FadeIn()
		
		local vehicleVel = LocalPlayer():GetVehicle():GetVelocity():Length()
		local vehicleConv = -1
		local terminal = 0
		
		terminal = math.Clamp(vehicleVel/2000, 0, 1)
		vehicleConv = math.Round(vehicleVel / self.UNITLIST[self.Unit][1])
		
		self.MemRate = terminal
		self.LastText = vehicleConv
		
	else
		self:FadeOut()
		
	end
	
	if self:ShouldDraw() then
		self:DrawGenericInfobox(
/*Text   */ self.LastText
/*Subtxt */ ,self.UNITLIST[self.Unit][2]
/* %     */ ,self.MemRate or 0
/*atRight*/ ,true
/*0.0 col*/ ,nil
/*1.0 col*/ ,nil
/*minSize*/ ,0
/*maxSize*/ ,1.0
/*blink< */ ,-1
/*blinkSz*/ ,1.0
/*Font   */ ,nil
/*bStatic*/ ,true
/*stCol  */ ,nil
/*stColSm*/ ,nil
		)
	end
	
	return true
end
