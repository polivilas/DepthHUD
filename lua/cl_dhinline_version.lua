////////////////////////////////////////////////
// -- Depth HUD : Inline                      //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Version                                    //
local MY_VERSION = 2.02
local SVN_VERSION = 2.02
local DOWNLOAD_LINK = 2.02

function dhinline.GetVersionData()
	return MY_VERSION, SVN_VERSION, DOWNLOAD_LINK
end

function dhinline.GetVersion()
	local version = 2.02
	
	print( MY_VERSION , SVN_VERSION , DOWNLOAD_LINK )
end