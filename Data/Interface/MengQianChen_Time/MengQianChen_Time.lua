--2023Q380级神兵剧情任务

local g_Frame_UnifiedPosition = nil
local g_GameTime = 0
local g_objCared = -1

function MengQianChen_Time_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false) 
end

function MengQianChen_Time_OnLoad()
    g_Frame_UnifiedPosition = MengQianChen_Time_Frame:GetProperty("UnifiedPosition")
	g_GameTime = 0
end


function MengQianChen_Time_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == 99839602 then
		local nOpt = Get_XParam_INT(0)
		if nOpt == 1 then
			g_GameTime = Get_XParam_INT(1)
			this:Show()
			MengQianChen_Time_Begin()
		elseif nOpt == 0 then
			MengQianChen_Time_OnClose()
		end

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        MengQianChen_Time_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		MengQianChen_Time_OnClose()

	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MengQianChen_Time_MAX_OBJ_DISTANCE or arg1=="destroy") then
			MengQianChen_Time_OnClose()
			--取消关心
			this:CareObject(-1, 1, "MengQianChen_Time");
		end	
	end

end

function MengQianChen_Time_Begin()
	MengQianChen_Time_Text2:SetProperty("Timer",g_GameTime)
	MengQianChen_Time_Animate:Show()
end

--游戏时间结束
function MengQianChen_Time_TimeOut()
	--倒计时结束后的逻辑处理，放在server触发了
	--弹这个界面的同时，Server也在自动计时，防止客户端出错
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("DaoJiShiOver")
		Set_XSCRIPT_ScriptID(998417)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT();

	MengQianChen_Time_OnClose()
	MengQianChen_Time_Animate:Hide()
end

function MengQianChen_Time_On_ResetPos()
    if (this:IsVisible()) then
        if (g_Frame_UnifiedPosition ~= nil) then
            MengQianChen_Time_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
        end
    end
end



function MengQianChen_Time_OnClose()
	--取消关心
	this:CareObject(-1, 1, "MengQianChen_Time");
    this:Hide()
end




