--2023Q380级神兵剧情任务

local g_MengQianChen_Letter_Frame_UnifiedXPosition
local g_MengQianChen_Letter_Frame_UnifiedYPosition
local g_MengQianChen_Letter_Image = {}
local g_Qingyuan_ShowingIndex = 0

function MengQianChen_Letter_PreLoad()
	this:RegisterEvent("UI_COMMAND")

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function MengQianChen_Letter_OnLoad()
	for i=1,6 do
		g_MengQianChen_Letter_Image[i] = _G[string.format( "MengQianChen_Letter_Text%d_line",i)]
	end
	
	g_Qingyuan_ShowingIndex = 1
end

function MengQianChen_Letter_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0)==99839603) then
		g_Qingyuan_ShowingIndex = 1
		MengQianChen_Letter_OnShow()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		MengQianChen_Letter_OnHidden()
	end
end

function MengQianChen_Letter_RePos()
	MengQianChen_Letter:SetProperty("UnifiedXPosition", g_MengQianChen_Letter_Frame_UnifiedXPosition)
	MengQianChen_Letter:SetProperty("UnifiedYPosition", g_MengQianChen_Letter_Frame_UnifiedYPosition)
end

function MengQianChen_Letter_OnHidden()
	KillTimer("MengQianChen_Letter_OnTwoSecTimer()")
	KillTimer("MengQianChen_Letter_OnFadeIn()")
	KillTimer("MengQianChen_Letter_FadeShowing()")
	this:CareObject(-1, 1, "MengQianChen_Letter")
	this:Hide()
end

function MengQianChen_Letter_OnShow()
	MengQianChen_Letter_Frame:SetProperty("Alpha",0)
	MengQianChen_Letter_Frame:Show()
	this:Show()
		
	KillTimer("MengQianChen_Letter_OnTwoSecTimer()")
	SetTimer("MengQianChen_Letter","MengQianChen_Letter_OnFadeIn()", 2000)
	this:CareObject(-1, 1, "MengQianChen_Letter")
	
	local strFadeIn = string.format("curve:Liner mode:Once duration:%s startx:0 starty:0 endx:1 endy:0",2)
	MengQianChen_Letter_Frame:Tween_SetInfo("Alpha", strFadeIn)		
	MengQianChen_Letter_Frame:Tween_Play("Alpha", true, true)
	
	for i=1,6 do
		g_MengQianChen_Letter_Image[i]:SetProperty("Alpha",0)
		g_MengQianChen_Letter_Image[i]:Show()
	end
	
	MengQianChen_Letter_FadeIn()
end

function MengQianChen_Letter_FadeIn()
	KillTimer("MengQianChen_Letter_OnFadeIn()")
	SetTimer("MengQianChen_Letter","MengQianChen_Letter_OnFadeIn()", 2*1000)
end

function MengQianChen_Letter_OnFadeIn()
	KillTimer("MengQianChen_Letter_OnFadeIn()")
	MengQianChen_Letter_FadeShowing()
end

function MengQianChen_Letter_FadeShowing()
	KillTimer("MengQianChen_Letter_FadeShowing()")
	if g_MengQianChen_Letter_Image[g_Qingyuan_ShowingIndex] ~= nil then
		local strShowing = string.format("curve:Liner mode:Once duration:%s startx:0 starty:0 endx:1 endy:0",1)
		g_MengQianChen_Letter_Image[g_Qingyuan_ShowingIndex]:Tween_SetInfo("Alpha", strShowing)
		g_MengQianChen_Letter_Image[g_Qingyuan_ShowingIndex]:Tween_Play("Alpha", true, true)
	end
	
	if g_Qingyuan_ShowingIndex >= 6 then
		MengQianChen_Letter_FadeDisappear()
		return		
	end
	
	g_Qingyuan_ShowingIndex = g_Qingyuan_ShowingIndex + 1
	SetTimer("MengQianChen_Letter","MengQianChen_Letter_FadeShowing()", 2000)
end

function MengQianChen_Letter_FadeDisappear()
	KillTimer("MengQianChen_Letter_FadeDisappearing()")
	SetTimer("MengQianChen_Letter","MengQianChen_Letter_FadeDisappearing()", 2*1000)
end

function MengQianChen_Letter_FadeDisappearing()
	KillTimer("MengQianChen_Letter_FadeDisappearing()")
	SetTimer("MengQianChen_Letter","MengQianChen_Letter_OnFadeDisappearing()", 2000)
	
end

function MengQianChen_Letter_OnFadeDisappearing()
	KillTimer("MengQianChen_Letter_OnFadeDisappearing()")
	MengQianChen_Letter_OnHidden()
end

