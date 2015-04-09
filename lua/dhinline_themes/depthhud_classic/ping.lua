ELEMENT.Name = "Ping"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 0
ELEMENT.DefaultGridPosY = 2
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.PingAlert = 0.15 //IN SECONDS, 0.1 = 100 MS
ELEMENT.PingCur   = RealTime() - CurTime()

ELEMENT.xRelPosEvo = -0.55
ELEMENT.yRelPosEvo = 0

ELEMENT.EvoLagMul   = 1.25
ELEMENT.EvoDuration = 2
ELEMENT.EvoPower = 4

ELEMENT.SmootherColor = nil

ELEMENT.GoodColor = ELEMENT.Theme:GetColorReference( "basecolor" )
ELEMENT.BadColor = ELEMENT.Theme:GetColorReference( "badcolor" )
ELEMENT.NeutralColor = ELEMENT.Theme:GetColorReference( "backcolor" )

ELEMENT.colorVolatile  = Color(255,192,128,192)

function ELEMENT:Initialize( )
	self:CreateSmoother("ping", 10, 0.1)
	self:CreateSmoother("color", self.GoodColor, 0.1)
	
	self:CreateSmoother("unsyncpercent", 0, 0.05)
end

function ELEMENT:DrawFunction( )
	if not game.SinglePlayer() then
		self:FadeIn()
		
		local ping_smooth = math.floor(self:GetSmootherCurrent("ping"))
		local smallText = "MS"
		self:ChangeSmootherTarget("ping", LocalPlayer():Ping())
		
		local estimaCheck = math.abs( RealTime() - self.PingCur - CurTime() )
		
		self:ChangeSmootherTarget("unsyncpercent", estimaCheck / self.PingAlert)
		local currentunsync = self:GetSmootherCurrent("unsyncpercent")
		
		//Zero is too perfect
		if (estimaCheck > self.PingAlert) or (estimaCheck == 0) then
			self.PingCur = RealTime() - CurTime()
			
			self:ChangeSmootherCurrent("color",  self.BadColor)
			
			local accum = self.Theme:GetVolatileStorage("ping_loss") or 0
			accum = accum + 1
			
			local text = ""
			/*if (accum < 100) then
				text = accum .. " UNSYNC"
			else
				text = accum .. " UNSYNC (ISSUE)"
			end*/
			text = "x" .. accum .. ""
			if (estimaCheck == 0) then
				text = text .. ".."
			end
			
			self:UpdateVolatile(
/*Vola   */ "ping_loss"
/*xRelOff*/ ,self.xRelPosEvo
/*yRelOff*/ ,self.yRelPosEvo
/*Text   */ ,text
/*Color  */ ,self.colorVolatile
/*LagMul */ ,self.EvoLagMul
/*Font   */ ,-1
/*Time   */ ,self.EvoDuration
/*FadePow*/ ,self.EvoPower
/*Storage*/ ,accum
			)
			
		else
			self.PingCur = self.PingCur + (RealTime() - self.PingCur - CurTime()) * 0.05 * FrameTime()
			
		end
		self.SmootherColor = self:GetSmootherCurrent("color")
		
		self:DrawGenericInfobox(
	/*Text   */ ping_smooth
	/*Subtxt */ ,smallText
	/* %     */ ,1 - currentunsync
	/*atRight*/ ,false
	/*0.0 col*/ ,self.BadColor
	/*1.0 col*/ ,nil
	/*minSize*/ ,0.2
	/*maxSize*/ ,1.0
	/*blink< */ ,-1
	/*blinkSz*/ ,1.0
	/*Font   */ ,nil
	/*bStatic*/ ,true
	/*stCol  */ ,self.SmootherColor
	/*stColSm*/ ,nil
		)
	end
	
	return true
end
