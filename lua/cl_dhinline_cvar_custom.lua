////////////////////////////////////////////////
// -- Depth HUD : Inline                      //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// ConVar Reg Method - Customizable           //
////////////////////////////////////////////////

function dhinline.GetVar( sVarName, opt_bReturnString )
	if opt_bReturnString or false then
		return GetConVarString(sVarName)
	end
	return GetConVarNumber(sVarName)
end

function dhinline.CreateVar( sVarName, sContents, shouldSave, userData )
	CreateClientConVar(sVarName, sContents, shouldSave, userData)
end

function dhinline.SetVar( sVarName, tContents )
	RunConsoleCommand( sVarName , tostring(tContents) )
end
