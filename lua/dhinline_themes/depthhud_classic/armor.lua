ELEMENT.Name = "Armor"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 2
ELEMENT.DefaultGridPosY = 16
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.xRelPosEvo = 0
ELEMENT.yRelPosEvo = -1

ELEMENT.EvoLagMul   = 2.5
ELEMENT.EvoDuration = 2
ELEMENT.EvoPower = 4

ELEMENT.LastArmor = 0

ELEMENT.color = nil
ELEMENT.batteryEmptyColor   = Color(128,164,190,172)
ELEMENT.batteryChargedColor = Color(164,220,255,255)
ELEMENT.accumPositive    = Color(164,220,255,192)
ELEMENT.accumNegative    = Color(128,164,190,128)

ELEMENT.MemRate = 0

function ELEMENT:Initialize( )
end

function ELEMENT:DrawFunction( )
	if (LocalPlayer():Alive() and LocalPlayer():Armor() > 0) or ((not LocalPlayer():Alive()) and (self.LastArmor > 0)) then
		self:FadeIn()
		
		self.MemRate = LocalPlayer():Armor() / 100
	
		if (LocalPlayer():Armor() != self.LastArmor) then
			local accum = self.Theme:GetVolatileStorage("armor_evolution") or 0
			self.color = nil
			local text = ""
			accum = accum + (LocalPlayer():Armor() - self.LastArmor)
			
			if (accum > 0) then
				self.color = self.accumPositive
				text = "+" .. accum
			else
				self.color = self.accumNegative
				text = "" .. accum
			end
			
			
			self:UpdateVolatile(
/*Vola   */ "armor_evolution"
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
	end
	
	if not (LocalPlayer():Alive() and LocalPlayer():Armor() > 0) then
		self.MemRate = 0.0
		self:FadeOut()
		
	end
	
	if self:ShouldDraw() then
			self:DrawGenericInfobox(
	/*Text   */ (LocalPlayer():Armor() > 0) and LocalPlayer():Armor() or 0
	/*Subtxt */ ,""
	/* %     */ ,self.MemRate
	/*atRight*/ ,false
	/*0.0 col*/ ,self.batteryEmptyColor
	/*1.0 col*/ ,self.batteryChargedColor
	/*minSize*/ ,1.0
	/*maxSize*/ ,1.0
	/*blink< */ ,0.0
	/*blinkSz*/ ,1.0
	/*Font   */ ,nil
	/*bStatic*/ ,false
	/*stCol  */ ,nil
	/*stColSm*/ ,nil
			)
	end
	
	self.LastArmor = LocalPlayer():Armor()
	
	return true
end
