ELEMENT.Name = "Health"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 0
ELEMENT.DefaultGridPosY = 16
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.xRelPosEvo = 0
ELEMENT.yRelPosEvo = -1

ELEMENT.EvoLagMul   = 2.5
ELEMENT.EvoDuration = 2
ELEMENT.EvoPower = 4

ELEMENT.LastHealth = 0

ELEMENT.color = nil
ELEMENT.accumPositive    = Color(0,255,0,255)
ELEMENT.accumNegative    = Color(255,0,0,255)

ELEMENT.GoodColor = ELEMENT.Theme:GetColorReference( "basecolor" )
ELEMENT.BadColor = ELEMENT.Theme:GetColorReference( "badcolor" )
ELEMENT.NeutralColor = ELEMENT.Theme:GetColorReference( "backcolor" )

ELEMENT.rate = 0

function ELEMENT:Initialize( )
end

function ELEMENT:DrawFunction( )
	//self:DrawGenericContentbox(512, math.floor(32 * 1.4), 128, "aaa")

	if LocalPlayer():Alive() then
		self:FadeIn()
		
		self.MemRate = LocalPlayer():Health() / 100
		if (self.MemRate > 0.25) then
			self.HealthColor = self.GoodColor
		else
			self.HealthColor = self.BadColor
		end
		
		if (LocalPlayer():Health() != self.LastHealth) then
			local accum = self.Theme:GetVolatileStorage("health_evolution") or 0
			self.color = nil
			local text = ""
			accum = accum + (LocalPlayer():Health() - self.LastHealth)
			
			if (accum > 0) then
				self.color = self.accumPositive
				text = "+" .. accum
			else
				self.color = self.accumNegative
				text = "" .. accum
			end
			
			
			self:UpdateVolatile(
/*Vola   */ "health_evolution"
/*xRelOff*/ ,self.xRelPosEvo
/*yRelOff*/ ,self.yRelPosEvo
/*Text   */ ,text
/*Color  */ ,self.color
/*LagMul */ ,self.EvoLagMul
/*Font   */ ,nil
/*Time   */ ,self.EvoDuration
/*FadePow*/ ,self.EvoPower
/*Storage*/ ,accum
			)
		end
		
	else
		self.MemRate = 0
		self.HealthColor = self.BadColor
		self:FadeOut()
		
	end
	
	
	if self:ShouldDraw() then
		self:DrawGenericInfobox(
/*Text   */ (LocalPlayer():Health() > 0) and LocalPlayer():Health() or 0
/*Subtxt */ ,""
/* %     */ ,self.MemRate
/*atRight*/ ,false
/*0.0 col*/ ,self.BadColor
/*1.0 col*/ ,self.GoodColor
/*minSize*/ ,1.0
/*maxSize*/ ,1.0
/*blink< */ ,0.05
/*blinkSz*/ ,1.0
/*Font   */ ,nil
/*bStatic*/ ,true
/*stCol  */ ,self.HealthColor
/*stColSm*/ ,nil
		)
	end
	
	self.LastHealth = LocalPlayer():Health()
	
	return true
end
