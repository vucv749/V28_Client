--UI
local g_CoupleZone_Help_TitleText = ""
local g_CoupleZone_Help_ContentText = ""

local g_CoupleZone_TextDic = 
{
	[1] = { title = "占卜标题", content = "占卜说明"}
}

local g_CoupleZone_Help_IsDebug = 0

function CoupleZone_Help_Debug(str)
	if g_CoupleZone_Help_IsDebug == 1 then
		PushDebugMessage(str)
		Lua_TDU_Log("CoupleZone_Help_Debug : "..str)
	end
end

--!!!reloadscript =CoupleZone_Help

function CoupleZone_Help_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OPEN_COUPLEZONE_HELP")
	
end


function CoupleZone_Help_OnLoad()
	g_CoupleZone_Help_TitleText = CoupleZone_Help_DragTitle
	g_CoupleZone_Help_ContentText = CoupleZone_Help_Info
end

function CoupleZone_Help_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99832402) then
		if this:IsVisible() then
			CoupleZone_Help_OnHidden()
		else
			CoupleZone_Help_OnShow()
		end
	end
	
	if ( event == "OPEN_COUPLEZONE_HELP") then
		if this:IsVisible() then
			CoupleZone_Help_OnHidden()
		else
			local param = tonumber(arg0)
			CoupleZone_Help_OnShow(param)
		end
	end
end

function CoupleZone_Help_OnShow(param)
	CoupleZone_Help_Debug("CoupleZone_Help_OnShow")
	if g_CoupleZone_TextDic[param] ~= nil then
		g_CoupleZone_Help_TitleText:SetText(g_CoupleZone_TextDic[param].title)
		g_CoupleZone_Help_ContentText:SetText(g_CoupleZone_TextDic[param].content)
		this:Show()
	end
end

function CoupleZone_Help_OnClose()
	CoupleZone_Help_Debug("CoupleZone_Help_OnClose")
	CoupleZone_Help_OnHidden()
end

function CoupleZone_Help_OnHidden()
	CoupleZone_Help_Debug("CoupleZone_Help_OnHidden")
	this:Hide()
end

