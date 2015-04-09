////////////////////////////////////////////////
// -- Depth HUD : Inline                      //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Menu                                       //
////////////////////////////////////////////////

include( 'CtrlColor.lua' )
include( 'DhCheckPos.lua' )
include( 'control_presets.lua' )

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// DERMA PANEL .

function dhinline.MakePresetPanel( data )
	local ctrl = vgui.Create( "ControlPresets", self )
	
	ctrl:SetPreset( data.folder )
	
	if ( data.options ) then
		for k, v in pairs( data.options ) do
			if ( k != "id" ) then
				ctrl:AddOption( k, v )
			end
		end
	end
	
	if ( data.cvars ) then
		for k, v in pairs( data.cvars ) do
			ctrl:AddConVar( v )
		end
	end
	
	return ctrl
end

function dhinline.MenuGetExpandTable()
	return {
		dhinline.DermaPanel.GeneralCategory:GetExpanded(),
		dhinline.DermaPanel.ElementsCategory:GetExpanded(),
		dhinline.DermaPanel.UIStyleCategory:GetExpanded()
		}
end

function dhinline.BuildMenu( opt_tExpand )
	print("buildmenu")
	--PrintTable(opt_tExpand)
	if dhinline.DermaPanel then dhinline.DermaPanel:Remove() end
	
	local MY_VERSION, SVN_VERSION, DOWNLOAD_LINK = dhinline.GetVersionData()
	
	dhinline.DermaPanel = vgui.Create( "DFrame" )
	local w, h = 300, ScrH() * 0.8
	local border = 4
	local W_WIDTH = w - 2*border
	
	local theme = dhinline_theme.GetCurrentThemeObject()
	
	////// // // THE FRAME
	dhinline.DermaPanel:SetPos( ScrW()*0.5 - w*0.5 , ScrH()*0.5 - h*0.5 )
	dhinline.DermaPanel:SetSize( w, h )
	dhinline.DermaPanel:SetTitle( DHINLINE_NAME )
	dhinline.DermaPanel:SetVisible( false )
	dhinline.DermaPanel:SetDraggable( true )
	dhinline.DermaPanel:ShowCloseButton( true )
	dhinline.DermaPanel:SetDeleteOnClose( false )
	
	local PanelList = vgui.Create( "DPanelList", dhinline.DermaPanel )
	PanelList:SetPos( border , 22 + border )
	PanelList:SetSize( W_WIDTH, h - 2*border - 22 )
	PanelList:SetSpacing( 5 )
	PanelList:EnableHorizontal( false )
	PanelList:EnableVerticalScrollbar( false )
	
	
	
	////// CATEGORY : GENERAL
	dhinline.DermaPanel.GeneralCategory = vgui.Create("DCollapsibleCategory", PanelList)
	dhinline.DermaPanel.GeneralCategory:SetSize( W_WIDTH, (dhinline.DermaPanel:GetTall() / 3)  )
	dhinline.DermaPanel.GeneralCategory:SetLabel( "General [Theme : "..theme:GetDisplayName().."]" )
	dhinline.DermaPanel.GeneralCategory:SetExpanded( 1 )											 
	
	local GeneralCatList = vgui.Create( "DPanelList" )
	GeneralCatList:SetSize(W_WIDTH, 20)
	GeneralCatList:EnableHorizontal( false )
	GeneralCatList:EnableVerticalScrollbar( false )
	
	// ENABLE CHECK
	local GeneralEnableCheck = vgui.Create( "DCheckBoxLabel" )
	GeneralEnableCheck:SetText( "Enable" )
	GeneralEnableCheck:SetConVar( "dhinline_core_enable" )
	GeneralEnableCheck:SetValue( dhinline.GetVar( "dhinline_core_enable" ) )
	
	// DISABLE BASE HUD CHECK
	local GeneralDefaultCheck = vgui.Create( "DCheckBoxLabel" )
	GeneralDefaultCheck:SetText( "Disable Base HUD" )
	GeneralDefaultCheck:SetConVar( "dhinline_core_disabledefault" )
	GeneralDefaultCheck:SetValue( dhinline.GetVar( "dhinline_core_disabledefault" ) )
	
	
	// THEME LABEL
	local ThemeTextLabel = vgui.Create("DLabel")
	ThemeTextLabel:SetWrap( true )
	ThemeTextLabel:SetText( "Theme selection :" )
	ThemeTextLabel:SetContentAlignment( 2 )
	ThemeTextLabel:SetSize( W_WIDTH, 20 )
	
	// THEME CHOICE
	local ThemeMultiChoice = vgui.Create( "DComboBox" )
	
	ThemeMultiChoice.ConversionTable = {}
	ThemeMultiChoice.Current = dhinline_theme.GetCurrentTheme()
	ThemeMultiChoice.Preselect = 1
	
	for k,sThemeName in pairs(dhinline_theme.GetNamesTable()) do
		ThemeMultiChoice:AddChoice( dhinline_theme.GetThemeObject( sThemeName ):GetDisplayName() )
		table.insert( ThemeMultiChoice.ConversionTable , sThemeName )
		
		if sThemeName == ThemeMultiChoice.Current then 
			ThemeMultiChoice.Preselect = #ThemeMultiChoice.ConversionTable
		end
	end
	
	ThemeMultiChoice.OnSelect = function(index,value,data)
		local selection = ThemeMultiChoice.ConversionTable[value]
		if selection != ThemeMultiChoice.Current then
			local myExpand = dhinline.MenuGetExpandTable()
			dhinline.SetTheme( selection )
			dhinline.BuildMenu( myExpand )
			dhinline.ShowMenu()
		end
	end
	
	ThemeMultiChoice:ChooseOptionID(ThemeMultiChoice.Preselect)
	
	ThemeMultiChoice:PerformLayout()
	ThemeMultiChoice:SizeToContents()
	
	//THEME-ELEMENTSCOMPO
	// THEME LABEL
	local ThemeElementsTextLabel = vgui.Create("DLabel")
	ThemeElementsTextLabel:SetWrap( true )
	ThemeElementsTextLabel:SetText( "Elements presets for "..theme:GetDisplayName().." :" )
	ThemeElementsTextLabel:SetContentAlignment( 2 )
	ThemeElementsTextLabel:SetSize( W_WIDTH, 20 )
	
	local ThemeElementsCompoSaver = dhinline.MakePresetPanel( {
		options = { ["default"] = theme:GetElementsDefaultsTable() },
		cvars = theme:GetElementsConvarTable(),
		folder = "dhinline_elements_"..theme:GetRawName()
	} )
	
	
	//THEME-STYLECOMPO
	// THEME LABEL
	local ThemeUIStyleTextLabel = vgui.Create("DLabel")
	ThemeUIStyleTextLabel:SetWrap( true )
	ThemeUIStyleTextLabel:SetText( "Theme presets for "..theme:GetDisplayName().." :" )
	ThemeUIStyleTextLabel:SetContentAlignment( 2 )
	ThemeUIStyleTextLabel:SetSize( W_WIDTH, 20 )
	
	local ThemeUIStyleSaver = dhinline.MakePresetPanel( {
		options = { ["default"] = theme:GetThemeDefaultsTable() },
		cvars = theme:GetThemeConvarTable(),
		folder = "dhinline_themes_"..theme:GetRawName()
	} )
	
	// THEME AFTERLABEL
	local ThemeAfterLabel = vgui.Create("DLabel")
	ThemeAfterLabel:SetWrap( true )
	ThemeAfterLabel:SetText( "" )
	ThemeAfterLabel:SetContentAlignment( 2 )
	ThemeAfterLabel:SetSize( W_WIDTH, 10 )
	
	// RELOAD BUTTON
	local ThemeListReloadButton = vgui.Create("DButton")
	ThemeListReloadButton:SetText( "Reload Themes" )
	ThemeListReloadButton.DoClick = function()
		local myExpand = dhinline.MenuGetExpandTable()
		dhinline.LoadAllThemes( )
		dhinline.BuildMenu( myExpand )
		dhinline.ShowMenu()
	end
	
	
	// DHDIV	
	local GeneralTextLabel = vgui.Create("DLabel")
	local GeneralTextLabelMessage = "The command \"dhinline_menu\" calls this menu.\n"
	if not (MY_VERSION and SVN_VERSION and (MY_VERSION < SVN_VERSION)) then
		GeneralTextLabelMessage = GeneralTextLabelMessage .. "Example : To assign inline menu to F7, type in the console :"
	else
		GeneralTextLabelMessage = GeneralTextLabelMessage .. "Your version is "..MY_VERSION.." and the updated one is "..SVN_VERSION.." ! You should update !"
	end
	GeneralTextLabel:SetWrap( true )
	GeneralTextLabel:SetText( GeneralTextLabelMessage )
	GeneralTextLabel:SetContentAlignment( 2 )
	GeneralTextLabel:SetSize( W_WIDTH, 50 )
	
	// DHMENU BUTTON
	local GeneralCommandLabel = vgui.Create("DTextEntry")
	if not (MY_VERSION and SVN_VERSION and (MY_VERSION < SVN_VERSION) and DOWNLOAD_LINK) then
		GeneralCommandLabel:SetText( "bind \"F7\" \"dhinline_menu\"" )
	else
		GeneralCommandLabel:SetText( DOWNLOAD_LINK )
	end
	GeneralCommandLabel:SetEditable( false )
	
	// MAKE: GENERAL
	GeneralCatList:AddItem( GeneralEnableCheck )
	GeneralCatList:AddItem( GeneralDefaultCheck )
	GeneralCatList:AddItem( ThemeTextLabel )
	GeneralCatList:AddItem( ThemeMultiChoice )
	GeneralCatList:AddItem( ThemeUIStyleTextLabel )
	GeneralCatList:AddItem( ThemeUIStyleSaver )
	GeneralCatList:AddItem( ThemeElementsTextLabel )
	GeneralCatList:AddItem( ThemeElementsCompoSaver )
	GeneralCatList:AddItem( ThemeAfterLabel )
	GeneralCatList:AddItem( ThemeListReloadButton )
	GeneralCatList:AddItem( GeneralTextLabel )
	GeneralCatList:AddItem( GeneralCommandLabel )
	GeneralCatList:PerformLayout()
	GeneralCatList:SizeToContents()
	dhinline.DermaPanel.GeneralCategory:SetContents( GeneralCatList ) // CATEGORY GENERAL FILLED

	
	////// CATEGORY : ELEMENTS
	dhinline.DermaPanel.ElementsCategory = vgui.Create("DCollapsibleCategory", PanelList)
	dhinline.DermaPanel.ElementsCategory:SetSize( W_WIDTH, (dhinline.DermaPanel:GetTall() / 3) )
	dhinline.DermaPanel.ElementsCategory:SetLabel( "Elements" )
	dhinline.DermaPanel.GeneralCategory:SetExpanded( 1 )
	
	local ElementsCatList = vgui.Create( "DPanelList" )
	ElementsCatList:SetSize(W_WIDTH, h*0.6 )
	ElementsCatList:EnableHorizontal( false )
	ElementsCatList:EnableVerticalScrollbar( false )
	
	// PRESETS : ELEMENTS
	local ElementsCompoSaver = dhinline.MakePresetPanel( {
		options = { ["default"] = theme:GetElementsDefaultsTable() },
		cvars = theme:GetElementsConvarTable(),
		folder = "dhinline_elements_"..theme:GetRawName()
	} )
	
	// MAIN ELEMENT LIST
	local ElementsList = vgui.Create( "DPanelList" )
	ElementsList:SetSize( W_WIDTH, h*0.6 )
	ElementsList:SetSpacing( 5 )
	ElementsList:EnableHorizontal( false )
	ElementsList:EnableVerticalScrollbar( true )
	local names = theme:GetElementsNames()
	for k,name in pairs(names) do
		local myElement = theme:GetElement( name )
		
		local sFullConvarName = "dhinline_element_".. theme:GetRawName() .."_".. myElement:GetRawName()
		
		local ListCheck = vgui.Create( "DhCheckPos" )
		ListCheck:SetText( myElement:GetDisplayName() )
		ListCheck:SetConVar( sFullConvarName )
		ListCheck:SetConVarX( sFullConvarName .. "_x" )
		ListCheck:SetConVarY( sFullConvarName .. "_y" )
		ListCheck:SetMinMax( 0 , dhinline.GetGridDivideMax() )

		ListCheck.button.DoClick = function()
			dhinline.SetVar( sFullConvarName .. "_x", myElement.DefaultGridPosX )
			dhinline.SetVar( sFullConvarName .. "_y", myElement.DefaultGridPosY )
		end
		ElementsList:AddItem( ListCheck ) -- Add the item above
	end
	
	// RELOAD BUTTON
	local ElementReloadButton = vgui.Create("DButton")
	ElementReloadButton:SetText( "Reload Theme Elements" )
	ElementReloadButton.DoClick = function()
		local myExpand = dhinline.MenuGetExpandTable()
		dhinline.LoadCurrentTheme( )
		dhinline.SetTheme( selection )
		dhinline.BuildMenu( myExpand )
		dhinline.ShowMenu()
	end
	
	// MAKE: ELEMENTS
	ElementsCatList:AddItem( ElementsCompoSaver )
	ElementsCatList:AddItem( ElementsList )
	ElementsCatList:AddItem( ElementReloadButton )
	ElementsCatList:PerformLayout()
	ElementsCatList:SizeToContents()
	dhinline.DermaPanel.ElementsCategory:SetContents( ElementsCatList ) // CATEGORY ELEMENTS FILLED
	
	
	
	
	
	////// CATEGORY : UIStyle
	dhinline.DermaPanel.UIStyleCategory = vgui.Create("DCollapsibleCategory", PanelList)
	dhinline.DermaPanel.UIStyleCategory:SetSize( W_WIDTH, (dhinline.DermaPanel:GetTall() / 3))
	dhinline.DermaPanel.UIStyleCategory:SetLabel( "UI Design" )
	dhinline.DermaPanel.GeneralCategory:SetExpanded( 1 )
	
	local UIStyleCatList = vgui.Create( "DPanelList" )
	UIStyleCatList:SetSize(W_WIDTH, 128 )
	UIStyleCatList:EnableHorizontal( false )
	UIStyleCatList:EnableVerticalScrollbar( false )
	
	// REVERT BUTTON
	local UIStyleRevertButton = vgui.Create("DButton")
	UIStyleRevertButton:SetText( "Revert Theme back to Defaults" )
	UIStyleRevertButton.DoClick = function()
		dhinline.RevertTheme( )
	end
	
	// PRESETS : STYLE
	local UIStyleSaver = dhinline.MakePresetPanel( {
		options = { ["default"] = theme:GetThemeDefaultsTable() },
		cvars = theme:GetThemeConvarTable(),
		folder = "dhinline_themes_"..theme:GetRawName()
	} )
	
	// SIZE XREL
	local UIStyleSpacingSlider = vgui.Create("DNumSlider")
	UIStyleSpacingSlider:SetText( "Spacing" )
	UIStyleSpacingSlider:SetMin( 0 )
	UIStyleSpacingSlider:SetMax( 2 )
	UIStyleSpacingSlider:SetDecimals( 1 )
	UIStyleSpacingSlider:SetConVar("dhinline_core_ui_spacing")
	
	// MAKE: UIStyle
	UIStyleCatList:AddItem( UIStyleRevertButton )
	UIStyleCatList:AddItem( UIStyleSaver )
	UIStyleCatList:AddItem( UIStyleSpacingSlider )
	
	
	local themeParamsNames = theme:GetParametersNames()
	for k,sName in pairs(themeParamsNames) do
		local myPanel = theme:BuildParameterPanel( sName )
		UIStyleCatList:AddItem( myPanel )
	end
	
	UIStyleCatList:PerformLayout()
	UIStyleCatList:SizeToContents()
	dhinline.DermaPanel.UIStyleCategory:SetContents( UIStyleCatList ) // CATEGORY GENERAL FILLED
	
	dhinline.DermaPanel.GeneralCategory:SetExpanded( opt_tExpand and (opt_tExpand[1] and 1 or 0) or 1 )
	dhinline.DermaPanel.ElementsCategory:SetExpanded( opt_tExpand and (opt_tExpand[2] and 1 or 0) or 1 )
	dhinline.DermaPanel.UIStyleCategory:SetExpanded( opt_tExpand and (opt_tExpand[3] and 1 or 0) or 1 )
	
	//FINISHING THE PANEL
	PanelList:AddItem( dhinline.DermaPanel.GeneralCategory )  //CATEGORY GENERAL CREATED
	PanelList:AddItem( dhinline.DermaPanel.ElementsCategory ) //CATEGORY ELEMENTS CREATED
	PanelList:AddItem( dhinline.DermaPanel.UIStyleCategory )  //CATEGORY UIStyle CREATED
end

function dhinline.ShowMenu()
	if not dhinline.DermaPanel then
		dhinline.BuildMenu()
	end
	//dhinline.DermaPanel:Center()
	dhinline.DermaPanel:MakePopup()
	dhinline.DermaPanel:SetVisible( true )
end

function dhinline.DestroyMenu()
	if dhinline.DermaPanel then
		dhinline.DermaPanel:Remove()
		dhinline.DermaPanel = nil
	end
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// SANDBOX PANEL .

function dhinline.Panel(Panel)	
	Panel:AddControl("Checkbox", {
			Label = "Enable", 
			Description = "Enable", 
			Command = "dhinline_core_enable" 
		}
	)
	Panel:AddControl("Checkbox", {
			Label = "Disable Base HUD",
			Description = "Disable Base HUD",
			Command = "dhinline_core_disabledefault" 
		}
	)
	Panel:AddControl("Button", {
			Label = "Open Menu (dhinline_menu)", 
			Description = "Open Menu (dhinline_menu)", 
			Command = "dhinline_menu"
		}
	)
	
	Panel:Help("To trigger the menu in any gamemode, type dhinline_menu in the console, or bind this command to any key.")
end

function dhinline.AddPanel()
	spawnmenu.AddToolMenuOption("Options","Player",DHINLINE_NAME,DHINLINE_NAME,"","",dhinline.Panel,{SwitchConVar = 'dhinline_core_enable'})
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
// MOUNT FCTS.

function dhinline.MountMenu()
	concommand.Add( "dhinline_menu", dhinline.ShowMenu )
	concommand.Add( "dhinline_call_menu", dhinline.ShowMenu )
	hook.Add( "PopulateToolMenu", "AddDepthHUDInlinePanel", dhinline.AddPanel )
end

function dhinline.UnmountMenu()
	dhinline.DestroyMenu()

	concommand.Remove( "dhinline_call_menu" )
	concommand.Remove( "dhinline_menu" )
	hook.Remove( "PopulateToolMenu", "AddDepthHUDInlinePanel" )
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////