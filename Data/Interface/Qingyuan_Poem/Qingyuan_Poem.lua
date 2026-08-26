
local g_Qingyuan_Poem_Frame_UnifiedXPosition
local g_Qingyuan_Poem_Frame_UnifiedYPosition
local g_Qingyuan_Poem_Image = {}
local g_Qingyuan_ShowingIndex = 0

function Qingyuan_Poem_PreLoad()
	this:RegisterEvent("UI_COMMAND")

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function Qingyuan_Poem_OnLoad()
	for i=1,4 do
		g_Qingyuan_Poem_Image[i] = _G[string.format( "Qingyuan_Poem_Text%d_line",i)]
	end
	
	g_Qingyuan_ShowingIndex = 1
end

function Qingyuan_Poem_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0)==50501101) then
		g_Qingyuan_ShowingIndex = 1
		Qingyuan_Poem_OnShow()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		Qingyuan_Poem_OnHidden()
	end
end

function Qingyuan_Poem_RePos()
	Qingyuan_Poem:SetProperty("UnifiedXPosition", g_Qingyuan_Poem_Frame_UnifiedXPosition)
	Qingyuan_Poem:SetProperty("UnifiedYPosition", g_Qingyuan_Poem_Frame_UnifiedYPosition)
end

function Qingyuan_Poem_OnHidden()
	KillTimer("Qingyuan_Poem_OnTwoSecTimer()")
	KillTimer("Qingyuan_Poem_OnFadeIn()")
	KillTimer("Qingyuan_Poem_FadeShowing()")
	this:CareObject(-1, 1, "Qingyuan_Poem")
	this:Hide()
end

function Qingyuan_Poem_OnShow()
	Qingyuan_Poem_Frame:SetProperty("Alpha",0)
	Qingyuan_Poem_Frame:Show()
	this:Show()
		
	KillTimer("Qingyuan_Poem_OnTwoSecTimer()")
	SetTimer("Qingyuan_Poem","Qingyuan_Poem_OnFadeIn()", 2000)
	this:CareObject(-1, 1, "Qingyuan_Poem")
	
	local strFadeIn = string.format("curve:Liner mode:Once duration:%s startx:0 starty:0 endx:1 endy:0",2)
	Qingyuan_Poem_Frame:Tween_SetInfo("Alpha", strFadeIn)		
	Qingyuan_Poem_Frame:Tween_Play("Alpha", true, true)
	
	for i=1,4 do
		g_Qingyuan_Poem_Image[i]:SetProperty("Alpha",0)
		g_Qingyuan_Poem_Image[i]:Show()
	end
	
	Qingyuan_Poem_FadeIn()
end

function Qingyuan_Poem_FadeIn()
	KillTimer("Qingyuan_Poem_OnFadeIn()")
	SetTimer("Qingyuan_Poem","Qingyuan_Poem_OnFadeIn()", 2*1000)
end

function Qingyuan_Poem_OnFadeIn()
	KillTimer("Qingyuan_Poem_OnFadeIn()")
	Qingyuan_Poem_FadeShowing()
end

function Qingyuan_Poem_FadeShowing()
	KillTimer("Qingyuan_Poem_FadeShowing()")
	if g_Qingyuan_Poem_Image[g_Qingyuan_ShowingIndex] ~= nil then
		local strShowing = string.format("curve:Liner mode:Once duration:%s startx:0 starty:0 endx:1 endy:0",1)
		g_Qingyuan_Poem_Image[g_Qingyuan_ShowingIndex]:Tween_SetInfo("Alpha", strShowing)
		g_Qingyuan_Poem_Image[g_Qingyuan_ShowingIndex]:Tween_Play("Alpha", true, true)
	end
	
	if g_Qingyuan_ShowingIndex >= 4 then
		Qingyuan_Poem_FadeDisappear()
		return		
	end
	
	g_Qingyuan_ShowingIndex = g_Qingyuan_ShowingIndex + 1
	SetTimer("Qingyuan_Poem","Qingyuan_Poem_FadeShowing()", 2000)
end

function Qingyuan_Poem_FadeDisappear()
	KillTimer("Qingyuan_Poem_FadeDisappearing()")
	SetTimer("Qingyuan_Poem","Qingyuan_Poem_FadeDisappearing()", 2*1000)
end

function Qingyuan_Poem_FadeDisappearing()
	KillTimer("Qingyuan_Poem_FadeDisappearing()")
	SetTimer("Qingyuan_Poem","Qingyuan_Poem_OnFadeDisappearing()", 2000)
	
end

function Qingyuan_Poem_OnFadeDisappearing()
	KillTimer("Qingyuan_Poem_OnFadeDisappearing()")
	Qingyuan_Poem_OnHidden()
end

