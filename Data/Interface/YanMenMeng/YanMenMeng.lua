--****************************************
-- 雁门梦境 休息室 常驻界面
-- limengyue 2023-07-21
--****************************************

local g_YanMenMeng_Frame_UnifiedPosition;

--===============================================
-- OnLoad()
--===============================================
function YanMenMeng_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("YANMENMENGJING_REST_MINI");
	--距离NPC距离
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
end

--===============================================
-- OnLoad()
--===============================================
function YanMenMeng_OnLoad()   
	-- 保存界面的默认相对位置
	g_YanMenMeng_Frame_UnifiedPosition = YanMenMeng:GetProperty("UnifiedPosition");

end


--================================================
-- 恢复界面的默认相对位置
--================================================
function YanMenMeng_Frame_On_ResetPos()
	YanMenMeng:SetProperty("UnifiedPosition", g_YanMenMeng_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function YanMenMeng_OnEvent(event)
    if(event == "UI_COMMAND" and tonumber(arg0) == 99846701) then
		--打开界面
		if(IsWindowShow("YanMenMeng")) then
			CloseWindow("YanMenMeng", true)
		end
		--检测是不是要打开界面
		if Get_XParam_INT(0) == 1 then
			YanMenMeng_Show()
		else
			YanMenMeng_OnHiden()
		end
	end	
    -- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		YanMenMeng_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YanMenMeng_Frame_On_ResetPos()
	elseif (event=="YANMENMENGJING_REST_MINI") then
		if arg0=="0" then
			YanMenMeng_Show()
		end
    end
         
end

--===============================================
-- YanMenMeng_OnHiden()
--===============================================
function YanMenMeng_OnHiden()
	this:Hide()
end


--===============================================
-- 打开界面
--===============================================
function YanMenMeng_Show()
	--PushDebugMessage("YanMenMeng_Show")
	this:Show()
end

--===============================================
-- 打开小窗口
--===============================================
function YanMenMeng_OpenMini()
	--PushDebugMessage("YanMenMeng_OpenMini")
	PushEvent("YANMENMENGJING_REST_MINI",1111)
	YanMenMeng_OnHiden()
end

