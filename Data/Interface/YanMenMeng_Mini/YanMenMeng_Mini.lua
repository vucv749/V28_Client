--****************************************
-- 雁门梦境 休息室 常驻界面
-- limengyue 2023-07-21
--****************************************

local g_YanMenMeng_Mini_Frame_UnifiedPosition;


--===============================================
-- OnLoad()
--===============================================
function YanMenMeng_Mini_PreLoad()
	this:RegisterEvent("YANMENMENGJING_REST_MINI");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--切场景事件
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--===============================================
-- OnLoad()
--===============================================
function YanMenMeng_Mini_OnLoad()   
	-- 保存界面的默认相对位置
	g_YanMenMeng_Mini_Frame_UnifiedPosition = YanMenMeng_Mini_Frame:GetProperty("UnifiedPosition");

end


--================================================
-- 恢复界面的默认相对位置
--================================================
function YanMenMeng_Mini_Frame_On_ResetPos()
	YanMenMeng_Mini_Frame : SetProperty("UnifiedPosition", g_YanMenMeng_Mini_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function YanMenMeng_Mini_OnEvent(event)
    -- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		YanMenMeng_Mini_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YanMenMeng_Mini_Frame_On_ResetPos()
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       YanMenMeng_Mini_OnHiden()
	elseif (event=="YANMENMENGJING_REST_MINI") then
		if arg0=="1111" then
			--PushDebugMessage("YanMenMeng_Mini show")
			YanMenMeng_Mini_Show()
		end
    end
         
end

--===============================================
-- YanMenMeng_Mini_OnHiden()
--===============================================
function YanMenMeng_Mini_OnHiden()
	--PushDebugMessage("YanMenMeng_Mini_OnHiden")
	this:Hide()
end

--===============================================
-- 打开界面
--===============================================
function YanMenMeng_Mini_Show()
	--PushDebugMessage("YanMenMeng_Mini_Show")
	this:Show()
end

--===============================================
-- 打开主界面
--===============================================
function YanMenMeng_Mini_Open()
	PushEvent("YANMENMENGJING_REST_MINI",0)
	YanMenMeng_Mini_OnHiden()
end
