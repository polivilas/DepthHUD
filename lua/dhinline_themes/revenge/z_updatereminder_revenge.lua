// NOTE : This is ONLY a REMINDER. It doesn't check for updates
// periodically while in the middle of a game.
// Updates are checked when map loads.
// This element ONLY displays a message 45 seconds after map loading,
// for 15 seconds, ONCE a map, and does not display if up to date.

ELEMENT.Name = "On-screen Update Reminder"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 0.5
ELEMENT.SizeX = ScrW() * 0.6
ELEMENT.SizeY = -0.7

ELEMENT.PersistTime    = 15.0 //How long the message displays
ELEMENT.CheckAfterLoadingDelay = 3.0 //The delay before message appears
ELEMENT.SafeEndDraw = 0.0

ELEMENT.GetVersionRealTime = RealTime() + ELEMENT.CheckAfterLoadingDelay

ELEMENT.AlreadyChecked = false
ELEMENT.IsDisplayingPopup = false

ELEMENT.GoodColor = ELEMENT.Theme:GetColorReference( "basecolor" )
ELEMENT.StoredName = ""
ELEMENT.StoredSub = ""

function ELEMENT:Initialize( )
	//self:SetUsePolar()
end

function ELEMENT:DrawFunction( )
	if not self.IsDisplayingPopup then
		if self.AlreadyChecked then return end
		if RealTime() < self.GetVersionRealTime then return end
	end
	
	self.AlreadyChecked = true
	
	local myVer,svnVer,dlLink = dhinline.GetVersionData()
	
	if not self.IsDisplayingPopup and ((svnVer == nil) or (svnVer == -1) or (myVer >= svnVer)) then
		self.IsDisplayingPopup = false
		return
	else
		self.IsDisplayingPopup = true
		
		self.StoredName = DHINLINE_NAME .. " Update : v".. myVer .." to v".. svnVer..". "
		if (math.floor(svnVer*10) - math.floor(myVer*10)) > 0 then
			self.StoredName = self.StoredName .. "(Feature update)"
		elseif (math.floor(svnVer*100) - math.floor(myVer*100)) > 0 then
			self.StoredName = self.StoredName .. "(Fix update)"
		elseif (math.floor(svnVer*1000) - math.floor(myVer*1000)) > 0 then
			self.StoredName = self.StoredName .. "(Betatesting update)"
		end
		self.StoredSub = "Please open the " .. DHINLINE_NAME .. " menu for more information."
		
		if (RealTime() > (self.PersistTime + self.GetVersionRealTime + self.SafeEndDraw)) then
			self.IsDisplayingPopup = false
		end

		
		self:DrawText( self.StoredName, false, self.GoodColor )
		self:DrawFractionBoxTrimmed( ((RealTime() - self.GetVersionRealTime) / self.PersistTime), 1, 1, self.GoodColor, self.NeutralColor, 0, 0)
		self:DrawText( self.StoredSub, true, self.GoodColor )
	end
end
