--2025巅峰系统引导任务

local g_Frame_UnifiedPosition = nil
local g_GameTime = 0
local g_objCared = -1
local g_type = -1

function Peak_Guide_Time_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false) 
end

function Peak_Guide_Time_OnLoad()
    g_Frame_UnifiedPosition = Peak_Guide_Time_Frame:GetProperty("UnifiedPosition")
	g_GameTime = 0
	g_objCared = -1
	g_type = -1
end


function Peak_Guide_Time_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == 99984801 then
		local nOpt = Get_XParam_INT(0)
		if nOpt == 1 then
			g_GameTime = Get_XParam_INT(1)
			g_type = Get_XParam_INT(2)
			if g_type==2 then
				Peak_Guide_Time_Text:SetText("#{DFYD_250716_225}")
				Peak_Guide_Time_Text2:Show()
				Peak_Guide_Time_ImageBK:Show()
			else
				Peak_Guide_Time_ImageBK:Hide()
			end
			this:Show()
			Peak_Guide_Time_Begin()
		elseif nOpt == 0 then
			Peak_Guide_Time_OnClose()
		end

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        Peak_Guide_Time_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		Peak_Guide_Time_OnClose()

	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>Peak_Guide_Time_MAX_OBJ_DISTANCE or arg1=="destroy") then
			Peak_Guide_Time_OnClose()
			--取消关心
			this:CareObject(-1, 1, "Peak_Guide_Time");
		end	
	end

end

function Peak_Guide_Time_Begin()
	Peak_Guide_Time_Text2:SetProperty("Timer",g_GameTime)
	Peak_Guide_Time_Animate:Show()
end

--游戏时间结束
function Peak_Guide_Time_TimeOut()
	if g_type==2 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("DaoJiShiOver")
			Set_XSCRIPT_ScriptID(999849)
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT();	
	end
	Peak_Guide_Time_OnClose()
	Peak_Guide_Time_Animate:Hide()
end

function Peak_Guide_Time_On_ResetPos()
    if (this:IsVisible()) then
        if (g_Frame_UnifiedPosition ~= nil) then
            Peak_Guide_Time_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
        end
    end
end

function Peak_Guide_Time_OnClose()
	--取消关心
	this:CareObject(-1, 1, "Peak_Guide_Time");
    this:Hide()
end




