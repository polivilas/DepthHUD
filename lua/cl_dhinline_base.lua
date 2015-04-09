////////////////////////////////////////////////
// -- Depth HUD : Inline                      //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Main file, with core functions             //
////////////////////////////////////////////////

if not dhinline then dhinline = {} end

include("garbage_module.lua")
include("cl_dhinline_element.lua")
include("cl_dhinline_theme.lua")

dhinline_dat = {}
dhinline_dat.DEBUG = true
dhinline_dat.ui_edgeSpacingRel = 0.01
dhinline_dat.PARAM_GRID_DIVIDE  = 16

dhinline_dat.PANEL_Types = {}
dhinline_dat.PANEL_Constructors = {}
dhinline_dat.PANEL_ConvarSuffixes = {}

dhinline_dat.STOR_Smoothers = {}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// INITIALIZATION FUNCTIONS .

function dhinline.LoadCurrentTheme()
	local sThemeFromConvar = GetConVar("dhinline_core_theme"):GetString()
	print (sThemeFromConvar)
	dhinline_theme.SetTheme(sThemeFromConvar)
end

// DEBUG : TO BE TESTED
function dhinline.DeriveFromTheme( sTheme )
	local path = DHINLINE_THEMEDIR 
	include(path..sTheme.."_theme.lua")
	THEME._derivefrom = sTheme
end

function dhinline.LoadAllThemes()
	print("LOADALLTHEMES")
	dhinline_theme.RemoveAll()

	local path = DHINLINE_THEMEDIR
	if DHINLINE_SPECIAL_ISGAMEMODE_STRAP then
		path = string.Replace(GM.Folder, "gamemodes/", "") .. "/gamemode/" .. path
	end
	for _,file in pairs(file.Find("lua/"..path.."*_theme.lua","GAME")) do
		print("THEME FOUND")
		THEME = {}
		
		include(path..file)
		
		local sKeyword = string.Replace(file, "_theme.lua", "")
		dhinline_theme.Register(sKeyword, THEME)
		
		THEME = nil
	end
	
	local stNames = dhinline_theme.GetNamesTable()
	//table.sort(stNames, function(a,b) return dhinline_element.GetThemeObject(a):GetDisplayName() < dhinline_element.GetThemeObject(b):GetDisplayName() end)
	
	if DHINLINE_DEBUG then
		print(DHINLINE_NAME .. " >> Registered Themes : ")
		for k,name in pairs( stNames ) do
			Msg("["..name.."] ")
		end
		Msg("\n")
	end
	
	dhinline.LoadCurrentTheme()
end

function dhinline.SetTheme( sName )
	if not sName or not table.HasValue( dhinline_theme.GetNamesTable() , sName ) then return end
	
	dhinline.SetVar("dhinline_core_theme", sName )
	dhinline_theme.SetTheme( sName )
end

function dhinline.SetThemeCommand( player, command, stName )
	dhinline.SetTheme( stName[1] )
end

function dhinline.LoadElement( sThemeName, sElementName, opt_ThemeOverride )
	ELEMENT = {}
	local pathBase = DHINLINE_THEMEDIR .. (opt_ThemeOverride or sThemeName) .."_element.lua"
	local pathElem = DHINLINE_THEMEDIR .. (opt_ThemeOverride or sThemeName) .."/"..sElementName..".lua"
	
	ELEMENT._mytheme = sThemeName
	ELEMENT.Theme = dhinline_theme.GetThemeObject(ELEMENT._mytheme)
	
	include( pathBase )
	include( pathElem )
	
	return ELEMENT
end


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// CORE CALC .

function dhinline.CalcCenter( xRel , yRel , width, height )
	local xCalc,yCalc = 0,0
	
	xDist = dhinline_dat.ui_edgeSpacingRel*ScrW() + width*0.5
	xCalc = xRel*ScrW() + (xRel*(-2) + 1)*xDist
	
	yDist = dhinline_dat.ui_edgeSpacingRel*ScrW() + height*0.5 //ScrW here is not a mistake
	yCalc = yRel*ScrH() + (yRel*(-2) + 1)*yDist
	
	return xCalc, yCalc
end

function dhinline.GetGridDivideMax()
	return dhinline_dat.PARAM_GRID_DIVIDE
end

function dhinline.GetRelPosFromGrid( xGrid, yGrid )
	local max = dhinline.GetGridDivideMax()
	local xRel, yRel = (xGrid / max), (yGrid / max)
	
	return xRel, yRel
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// USEFUL FUNCTIONS FOR USER .

function dhinline.StringNiceNameTransform( stringInput )
	local stringParts = string.Explode("_",stringInput)
	local stringOutput = ""
	for k,part in pairs(stringParts) do
		local len = string.len(part)
		if (len == 1) then
			stringOutput = stringOutput .. string.upper(part)
		elseif (len > 1) then
			stringOutput = stringOutput .. string.Left(string.upper(part),1) .. string.Right(part,len-1)
		end
		if (k != #stringParts) then stringOutput = stringOutput .. " " end
	end
	return stringOutput
end


function dhinline.PrimeColorFromTable( cColor, tHyb )
	cColor.r = tHyb[1]
	cColor.g = tHyb[2]
	cColor.b = tHyb[3]
	cColor.a = tHyb[4]
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// DRAWING FUNCTIONS. DO NOT USE IN YOUR ELEMENTS.
//// READ cl_dhinline_element.lua FOR DRAWING FUNCTIONS
//// AND _empty._lua .

function dhinline.DrawSprite(sprite, x, y, width, height, angle, r, g, b, a)
	local spriteid = 0
	if ( type(sprite) == "string" ) then
		spriteid = surface.GetTextureID(sprite)
	else
		spriteid = sprite
	end
	
	surface.SetTexture(spriteid)
	surface.SetDrawColor(r, g, b, a)
	surface.DrawTexturedRectRotated(x, y, width, height, angle)
end

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// SMOOTHING FUNCTIONS. DO NOT USE IN YOUR ELEMENTS.
//// READ cl_dhinline_element.lua FOR SMOOTHING FUNCTIONS.

function dhinline.RecalcSmootherLogic(subtable)
	local previousCurrent = 0
	if (type(subtable[2]) == "table") then
		for subkey,value in pairs(subtable[2]) do
			previousCurrent = subtable[2][subkey]
			subtable[2][subkey] = subtable[2][subkey] + (subtable[1][subkey] - subtable[2][subkey]) * subtable[3] * FrameTime() * 50
			if (previousCurrent < subtable[1][subkey]) and (subtable[2][subkey] > subtable[1][subkey]) then
				subtable[2][subkey] = subtable[1][subkey]
			elseif (previousCurrent > subtable[1][subkey]) and (subtable[2][subkey] < subtable[1][subkey]) then
				subtable[2][subkey] = subtable[1][subkey]
			end
		end
	else
		subtable[2] = subtable[2] + (subtable[1] - subtable[2]) * math.Clamp( subtable[3] * 0.5 * FrameTime() * 50 , 0 , 1 )
	end
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// DERMA PANEL CONSTRUCTORS .

function dhinline.ParamTypeExists( sType )
	return table.HasValue( dhinline_dat.PANEL_Types , string.lower(sType) )
end

function dhinline.RegisterPanelConstructor( sType, fConstructor, stConvarSuffixes )
	sType = string.lower(sType)
	if dhinline.ParamTypeExists( sType ) then return end
	
	dhinline_dat.PANEL_Constructors[sType] = fConstructor
	dhinline_dat.PANEL_ConvarSuffixes[sType] = stConvarSuffixes or nil
	table.insert( dhinline_dat.PANEL_Types, sType)
	
	if DHINLINE_DEBUG then print(DHINLINE_NAME .. " > Registered Panel Constructor : "..sType) end
end

function dhinline.BuildParamConvars( sType, sFullConvarName, sDefault )
	sType = string.lower(sType)
	if not dhinline.ParamTypeExists( sType ) then return end
	
	if dhinline_dat.PANEL_ConvarSuffixes[sType] == nil then
		dhinline.CreateVar(sFullConvarName, tostring(sDefault), true, false)
		if DHINLINE_DEBUG then print(DHINLINE_NAME .. " > Added Var : "..sFullConvarName.." = "..tostring(sDefault)) end
		
	elseif type(dhinline_dat.PANEL_ConvarSuffixes[sType]) == "table" then
		for k,suffix in pairs( dhinline_dat.PANEL_ConvarSuffixes[sType] ) do
			dhinline.CreateVar(sFullConvarName .. "_" .. suffix, tostring(sDefault[k] or sDefault[1] or sDefault), true, false)
			if DHINLINE_DEBUG then print(DHINLINE_NAME .. " > Added Var : "..sFullConvarName .. "_" .. suffix.." = "..tostring(sDefault[k] or sDefault[1] or sDefault)) end
		end
	end
end

function dhinline.GetParamSuffixes( sType )
	sType = string.lower(sType)
	if not dhinline.ParamTypeExists( sType ) then return end
	
	return dhinline_dat.PANEL_ConvarSuffixes[sType]
end

function dhinline.GetParamConvars( sType, sFullConvarName )
	sType = string.lower(sType)
	if not dhinline.ParamTypeExists( sType ) then return end
	
	local myConvars = {}
	
	if dhinline_dat.PANEL_ConvarSuffixes[sType] == nil then
		table.insert(myConvars, sFullConvarName)
		
	elseif type(dhinline_dat.PANEL_ConvarSuffixes[sType]) == "table" then
		for k,suffix in pairs( dhinline_dat.PANEL_ConvarSuffixes[sType] ) do
			table.insert(myConvars, sFullConvarName .. "_" .. suffix)
		end
	end
	return myConvars
end

function dhinline.BuildParamPanel( sFullConvarName, stData )
	if not dhinline.ParamTypeExists( stData.Type ) then return end
	
	return dhinline_dat.PANEL_Constructors[stData.Type](sFullConvarName , stData)
end

function dhinline.InitializeGenericConstructors( )
	dhinline.RegisterPanelConstructor( "label" , function( sFullConvarName, stData )	
		local myPanel = vgui.Create("DLabel")
		myPanel:SetText( stData.Text or "<Error : no text !>" )
		return myPanel
	end , "noconvars" )
	dhinline.RegisterPanelConstructor( "checkbox" , function( sFullConvarName, stData )
		local myPanel = vgui.Create( "DCheckBoxLabel" )
		myPanel:SetText( stData.Text or "<Error : no text !>" )
		myPanel:SetConVar( sFullConvarName )
		return myPanel 
	end )
	dhinline.RegisterPanelConstructor( "slider" , function( sFullConvarName, stData )	
		local myPanel = vgui.Create( "DNumSlider" )
		myPanel:SetText( stData.Text or "<Error : no text !>" )
		myPanel:SetMin( tonumber(stData.Min or 0) )
		myPanel:SetMax( tonumber(stData.Max or ((stData.Min or 0) + 1)) )
		myPanel:SetDecimals( tonumber(stData.Decimals or 0) )
		myPanel:SetConVar( sFullConvarName )
		return myPanel 
	end )
	dhinline.RegisterPanelConstructor( "color" , function( sFullConvarName, stData )	
		local myPanel = vgui.Create("CtrlColor")
		myPanel:SetConVarR(sFullConvarName.."_r")
		myPanel:SetConVarG(sFullConvarName.."_g")
		myPanel:SetConVarB(sFullConvarName.."_b")
		myPanel:SetConVarA(sFullConvarName.."_a")
		return myPanel 
	end , {"r","g","b","a"})
end


/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// MAIN HOOKS .

function dhinline.RemoteCoreThink( themeObj )
	themeObj:CoreThink()
end
function dhinline.RemoteThink( themeObj )
	themeObj:Think()
end
function dhinline.RemotePaint( themeObj )
	themeObj:Paint()
end
function dhinline.RemotePaintMisc( themeObj )
	themeObj:PaintMisc()
end

function dhinline.HUDPaint(name)
	if dhinline.GetVar("dhinline_core_enable") <= 0 then return end
	dhinline_dat.ui_edgeSpacingRel = dhinline.GetVar("dhinline_core_ui_spacing") * 0.015
	
	--dhinline.RecalcAllSmoothers()
	
	local myThemeObjectRef = dhinline_theme.GetCurrentThemeObject()
	
	dhinline.RemoteCoreThink( myThemeObjectRef )
	
	local bOkay, strErr = pcall(function() dhinline.RemoteThink(myThemeObjectRef) end)
	if not bOkay then print(" > " .. DHINLINE_NAME .. " Think ERROR : ".. strErr) end
	
	if bOkay then
		local bOkayTwo, strErrTwo = pcall(function() dhinline.RemotePaint(myThemeObjectRef) end)
		if not bOkayTwo then print(" > " .. DHINLINE_NAME .. " Paint ERROR : ".. strErrTwo) end
	end
	
	if bOkay then
		local bOkayTwo, strErrTwo = pcall(function() dhinline.RemotePaintMisc(myThemeObjectRef) end)
		if not bOkayTwo then print(" > " .. DHINLINE_NAME .. " PaintMisc ERROR : ".. strErrTwo) end
	end
end

function dhinline.HUDShouldDraw( name )
	if (
	(dhinline.GetVar("dhinline_core_enable") <= 0)
	or (dhinline.GetVar("dhinline_core_disabledefault") <= 0)
	) then return end
	
	if name == "CHudHealth"        then return false end
	if name == "CHudBattery"       then return false end
	if name == "CHudAmmo"          then return false end
	if name == "CHudSecondaryAmmo" then return false end
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// MISC .

function dhinline.RevertTheme()
	local theme = dhinline_theme.GetCurrentThemeObject()
	for key,def in pairs(theme:GetThemeDefaultsTable()) do
		print(key .. " = " .. def)
		dhinline.SetVar(key, def)
	end
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// MOUNT FCTS.

function dhinline.ThemeAutoComplete(commandName,args)
	local myTable = dhinline_theme.GetNamesTable()
	for k,v in pairs( myTable ) do
		myTable[k] = commandName .. " " .. v
	end
	return myTable
end

function dhinline.Mount()
	print("")
	print("[ Mounting " .. DHINLINE_NAME .. " ... ]")
	
	dhinline.CreateVar("dhinline_core_enable", "1", true, false)
	dhinline.CreateVar("dhinline_core_disabledefault", "1", true, false)
	dhinline.CreateVar("dhinline_core_theme", DHINLINE_DEFAULTTHEME, true, false)
	dhinline.CreateVar("dhinline_core_ui_spacing", "1", true, false)
	
	if dhinline.MountMenu then
		dhinline.MountMenu()
		
		concommand.Add("dhinline_call_reloadtheme", dhinline.LoadCurrentTheme)
		concommand.Add("dhinline_call_reloadthemelist", dhinline.LoadAllThemes)
		concommand.Add("dhinline_call_settheme", dhinline.SetThemeCommand, dhinline.ThemeAutoComplete)
		concommand.Add("dhinline_call_reverttheme", dhinline.RevertTheme )
	end
	
	dhinline.InitializeGenericConstructors( )
	dhinline.LoadAllThemes( true )

	if DHINLINE_HOOK_HUDSHOULDDRAW then
		hook.Add( "HUDShouldDraw", "dhinlineHUDShouldDraw", dhinline.HUDShouldDraw)
	end
	if DHINLINE_HOOK_HUDPAINT then
		hook.Add( "HUDPaint", "dhinlineHUDPaint", dhinline.HUDPaint)
	end
	
	print("[ " .. DHINLINE_NAME .. " is now mounted. ]")
	print("")
	
end

function dhinline.Unmount()
	print("")
	print("] Unmounting " .. DHINLINE_NAME .. " ... [")
	dhinline_theme.RemoveAll()
	
	if dhinline.UnmountMenu then
		dhinline.UnmountMenu()
		
		concommand.Remove("dhinline_call_reloadtheme")
		concommand.Remove("dhinline_call_reloadthemelist")
		concommand.Remove("dhinline_call_settheme")
		concommand.Remove("dhinline_call_reverttheme")
	end
	
	table.Empty(dhinline_dat)
	table.Empty(dhinline)
	
	dhinline_dat = nil
	dhinline = nil
	
	if DHINLINE_HOOK_HUDSHOULDDRAW then
		hook.Remove( "HUDShouldDraw", "dhinlineHUDShouldDraw" )
	end
	if DHINLINE_HOOK_HUDPAINT then
		hook.Remove( "HUDPaint", "dhinlineHUDPaint" )
	end
	
	print("] " .. DHINLINE_NAME .. " has been unmounted. [")
	print("")
	
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////