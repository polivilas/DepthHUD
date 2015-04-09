ELEMENT.Name = "Target Information"
ELEMENT.DefaultOff = true
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 10
ELEMENT.SizeX = 0
ELEMENT.SizeY = -0.7

ELEMENT.LastTimeStored = 0
ELEMENT.PersistTime    = 1.0
ELEMENT.FadeOutTime    = 1.5
ELEMENT.StoredName = ""
ELEMENT.StoredSub = ""

ELEMENT.HeightRateDispell = 0.4

ELEMENT.MyTraceData = {}
ELEMENT.MyTraceRes = {}

ELEMENT.textColor = Color(0, 255, 255, 255)

ELEMENT.baseColor = ELEMENT.Theme:GetColorReference("basecolor")
ELEMENT.baseColorLesser = ELEMENT.Theme:GetColorReference("basecolor") --_lesser")

function ELEMENT:Initialize( )
	self:CreateSmoother("width", 0, 0.7)
	self:CreateSmoother("color" , self.baseColorLesser, 0.1)
	self:CreateSmoother("health", 1, 0.2)
end

function ELEMENT:DrawFunction( )
	self.MyTraceData = util.GetPlayerTrace( LocalPlayer())
	self.MyTraceData.filter = LocalPlayer():GetVehicle()
	local found = false
	local blinkSize = -1
	
	self.MyTraceRes = util.TraceLine( self.MyTraceData )
	if (self.MyTraceRes.Hit) and (self.MyTraceRes.HitNonWorld) and IsValid(self.MyTraceRes.Entity) and (self.MyTraceRes.Entity != LocalPlayer()) then
		local name = ""
		local HitEntity = self.MyTraceRes.Entity
	
		if (HitEntity:IsPlayer()) then
			name = HitEntity:Nick()
			if (HitEntity.dhradar_communitycolor) then
				self:ChangeSmootherTarget("color", HitEntity.dhradar_communitycolor)
			else
				self:ChangeSmootherTarget("color", team.GetColor(HitEntity:Team()))
			end
			self:ChangeSmootherTarget("health", math.Clamp(HitEntity:Health()/100,0,1))
			self.StoredSub = "Player"
			if (team.GetAllTeams != nil) and (table.Count(team.GetAllTeams()) > 3) then
				self.StoredSub = self.StoredSub .. " (" .. team.GetName(HitEntity:Team()) .. ")"
			end
		else
			name = HitEntity:GetClass()
			self:ChangeSmootherTarget("color", self.baseColorLesser)
			self:ChangeSmootherTarget("health", 1)
			if HitEntity:IsNPC() then
				self.StoredSub = "NPC"
			else
				local subName = ""
				if string.Right(HitEntity:GetModel() , 4) == ".mdl" then
					local parts = string.Explode("/", HitEntity:GetModel() )
					subName = dhinline.StringNiceNameTransform( string.Left(parts[#parts] , -5) )
				else
					if (string.Left(HitEntity:GetClass(),4) == "prop") then
						subName = "Prop"	
					elseif (string.Left(HitEntity:GetClass(),4) == "func") then
						subName = "World Entity"
					else
						subName = "Entity"
					end
				end
				self.StoredSub = subName
			end
		end
		
		name = dhinline.StringNiceNameTransform( name )
		
		surface.SetFont( self.Theme:GetAppropriateFont(name, 1) )
		local wB, hB = surface.GetTextSize( name )
		surface.SetFont( self.Theme:GetAppropriateFont(self.StoredSub, 0) )
		local wS, hS = surface.GetTextSize( self.StoredSub )
		local w = math.Max(wB,wS)
		local x, y = self:GetMySizes()
		
		self:ChangeSmootherTarget("width", 44 + w)
		self:ChangeSmootherRate("width", 0.6)
		self.StoredName = name
		
		found = true
		self.LastTimeStored = RealTime()
	end
	
	if (self.StoredName != "") and (not found) and ((RealTime() - self.LastTimeStored) > self.PersistTime) then
		self.StoredName = ""
		self.StoredSub = ""
		self:ChangeSmootherTarget("color", self.baseColorLesser)
		self:ChangeSmootherTarget("health", 1)
		
		local mX,mY = self:GetMySizes()
		
		self:ChangeSmootherTarget("width", mY)
		self:ChangeSmootherRate("width", 0.2)
	end
	
	self.SizeX = self:GetSmootherCurrent("width")
	local color = self:GetSmootherCurrent("color")
	local rate = self:GetSmootherCurrent("health")

	self.textColor.r = self.baseColor.r
	self.textColor.g = self.baseColor.g
	self.textColor.b = self.baseColor.b
	self.textColor.a = ( 1 - ((RealTime() - self.LastTimeStored)/self.PersistTime)^8 ) * 255
	
	if ((RealTime() - self.LastTimeStored) > self.FadeOutTime) then
		self:FadeOut()
	else
		self:FadeIn()
	end
	
	
	if self:ShouldDraw() then
		self:DrawGenericInfobox(
	/*Text   */ self.StoredName
	/*Subtxt */ ,self.StoredSub
	/* %     */ ,rate
	/*atRight*/ ,false
	/*0.0 col*/ ,color
	/*1.0 col*/ ,color
	/*minSize*/ ,0.2
	/*maxSize*/ ,1.0
	/*blink< */ ,-1
	/*blinkSz*/ ,blinkSize
	/*Font   */ ,1
	/*bStatic*/ ,true
	/*stCol  */ ,self.textColor
	/*stColSm*/ ,nil
		)
	end
	return false
end
