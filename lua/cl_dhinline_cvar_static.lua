////////////////////////////////////////////////
// -- Depth HUD : Inline                      //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// ConVar Reg Method - Static                 //
////////////////////////////////////////////////

dhinline.staticvars = {}

function dhinline.GetVar( sVarName, opt_bReturnString )
	if opt_bReturnString or false then
		return tostring(dhinline.staticvars[sVarName] or "")
	end
	return tonumber(dhinline.staticvars[sVarName] or 0)
end

function dhinline.CreateVar( sVarName, sContents, shouldSave, userData )
	dhinline.staticvars[sVarName] = tostring(sContents)
end

function dhinline.SetVar( sVarName, tContents )
	dhinline.staticvars[sVarName] = tostring(tContents)
end
