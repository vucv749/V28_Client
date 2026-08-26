--2023Q380级神兵剧情任务

local g_Frame_UnifiedPosition = nil
local g_objCared = -1

function MengQianChen_Time2_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false) 
end

function MengQianChen_Time2_OnLoad()
    g_Frame_UnifiedPosition = MengQianChen_Time2_Frame:GetProperty("UnifiedPosition")
end


function MengQianChen_Time2_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == 99839604 then
		local nOpt = Get_XParam_INT(0)
		if nOpt == 1 then
			this:Show()
			MengQianChen_Time2_Begin()
		elseif nOpt == 0 then
			MengQianChen_Time2_OnClose()
		end

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        MengQianChen_Time2_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		MengQianChen_Time2_OnClose()

	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MengQianChen_Time2_MAX_OBJ_DISTANCE or arg1=="destroy") then
			MengQianChen_Time2_OnClose()
			--取消关心
			this:CareObject(-1, 1, "MengQianChen_Time2");
		end	
	end

end

function MengQianChen_Time2_Begin()
	SetTimer("MengQianChen_Time2", "MengQianChen_Time2_Timer()", 3000);
	MengQianChen_Time2_Animate:Show()
end

--游戏时间结束
function MengQianChen_Time2_Timer()
	KillTimer("MengQianChen_Time2_Timer()")
	MengQianChen_Time2_OnClose()
	MengQianChen_Time2_Animate:Hide()
end

function MengQianChen_Time2_On_ResetPos()
    if (this:IsVisible()) then
        if (g_Frame_UnifiedPosition ~= nil) then
            MengQianChen_Time2_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
        end
    end
end



function MengQianChen_Time2_OnClose()
	--取消关心
	this:CareObject(-1, 1, "MengQianChen_Time2");
    this:Hide()
end




