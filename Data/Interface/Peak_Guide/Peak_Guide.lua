--2025巅峰系统引导任务

local g_Peak_Guide_Frame_UnifiedPosition
local g_Peak_Guide_Button = {}
local g_Peak_Guide_Index

--=========
-- PreLoad()
--=========
function Peak_Guide_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--???????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
end

--=========
-- OnLoad()
--=========
function Peak_Guide_OnLoad()
	g_Peak_Guide_Frame_UnifiedPosition = Peak_Guide_Frame:GetProperty("UnifiedPosition")
	
	g_Peak_Guide_Button[1] = {button=Peak_Guide_Bind1,text="#{DFYD_250716_248}"}
	g_Peak_Guide_Button[2] = {button=Peak_Guide_Bind2,text="#{DFYD_250716_250}"}
	g_Peak_Guide_Button[3] = {button=Peak_Guide_Bind4,text="#{DFYD_250716_254}"}
	
	g_Peak_Guide_Index = 1
end

--=========
-- Event
--=========
function Peak_Guide_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 9998451 then
		if( this:IsVisible() ) then
			this:Hide()
		else
			g_Peak_Guide_Index = 1
			Peak_Guide_Update()
			this:Show()
		end
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		Peak_Guide_OnClose()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Peak_Guide_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		Peak_Guide_ResetPos()
	end
end

function Peak_Guide_ModeClicked(index)
	if index>=1 and index<=table.getn(g_Peak_Guide_Button) then
		g_Peak_Guide_Index = index
		Peak_Guide_Update()
	end
end

function Peak_Guide_Update()
	for i=1, table.getn(g_Peak_Guide_Button) do
		if i==g_Peak_Guide_Index then
			g_Peak_Guide_Button[i].button:SetCheck(1)
			Peak_Guide_Right1_Text:SetText(g_Peak_Guide_Button[i].text)
		else
			g_Peak_Guide_Button[i].button:SetCheck(0)
		end
	end
end

--调狖：界面位置
function Peak_Guide_ResetPos()
	Peak_Guide_Frame:SetProperty("UnifiedPosition", g_Peak_Guide_Frame_UnifiedPosition)
end

--关睜：界面
function Peak_Guide_OnClose()
	this:Hide()
end

