--****************************************
-- 雁门梦境 梦魇值界面
-- limengyue 2023-07-24
--****************************************

local g_YanMenMeng_MengYan_Frame_UnifiedPosition;

--===============================================
-- OnLoad()
--===============================================
function YanMenMeng_MengYan_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--距离NPC距离
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
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
function YanMenMeng_MengYan_OnLoad()   
	-- 保存界面的默认相对位置
	g_YanMenMeng_MengYan_Frame_UnifiedPosition = YanMenMeng_MengYan_Frame:GetProperty("UnifiedPosition");
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function YanMenMeng_MengYan_Frame_On_ResetPos()
	YanMenMeng_MengYan_Frame : SetProperty("UnifiedPosition", g_YanMenMeng_MengYan_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function YanMenMeng_MengYan_OnEvent(event)

    if(event == "UI_COMMAND" and tonumber(arg0) == 99844501) then
		--打开界面
		if(IsWindowShow("YanMenMeng_MengYan")) then
			CloseWindow("YanMenMeng_MengYan", true)
		end
		YanMenMeng_MengYan_Show(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2))
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 99844502) then
		--进入梦魇时间
		YanMenMeng_MengYan_ShowTime(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2))
	end
    -- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		YanMenMeng_MengYan_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YanMenMeng_MengYan_Frame_On_ResetPos()
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       YanMenMeng_MengYan_OnHiden()
    end
         
end

--===============================================
-- YanMenMeng_MengYan_OnHiden()
--===============================================
function YanMenMeng_MengYan_OnHiden()
	this:Hide()
end

--===============================================
-- 打开界面
--===============================================
function YanMenMeng_MengYan_Show(nNightmare,nNightmareMax,nNightTick)
	--梦魇累计
	--PushDebugMessage("test UI YanMenMeng_MengYan_ShowTime nNightTick="..nNightTick)
	if nNightTick <= 0 then
		--特效界面
		YanMenMeng_MengYan_info:Hide()--倒计时
		YanMenMeng_MengYan_MengYanTime:Hide()
	end
	--%s0/300
	YanMenMeng_MengYan_info2:Show()--积蓄中
	YanMenMeng_MengYan_Text2:SetText(ScriptGlobal_Format("#{YMMJ_230626_60}",nNightmare,nNightmareMax))
	YanMenMeng_MengYan_FeelGoodProgress:SetProgress(nNightmare, nNightmareMax)
	this:Show()
end

--===============================================
-- 进入梦魇时间
--===============================================
function YanMenMeng_MengYan_ShowTime(nNightmare,nNightmareMax,nNightTick)
	--梦魇降临时文字
	if nNightTick > 0 then
		--PushDebugMessage("test UI YanMenMeng_MengYan_ShowTime nNightTick="..nNightTick)		
		--特效界面
		YanMenMeng_MengYan_MengYanTime:Show()
		--梦魇ing
		YanMenMeng_MengYan_info2:Hide()--积蓄中
		YanMenMeng_MengYan_info:Show()--倒计时
		--%s0：%s1
		if nNightTick > 0 then
			YanMenMeng_MengYan_Time:SetProperty("Timer", nNightTick)
		else
			YanMenMeng_MengYan_Time:SetProperty("Timer", 0)
		end
		YanMenMeng_MengYan_Time:SetProperty("TextColor","FFFFF263")
		YanMenMeng_MengYan_Text2:SetText(ScriptGlobal_Format("#{YMMJ_230626_60}",nNightmare,nNightmareMax))
		YanMenMeng_MengYan_FeelGoodProgress:SetProgress(nNightmare, nNightmareMax)
	end
end

--===============================================
-- 帮助说明
--===============================================
function YanMenMeng_MengYan_ShowHelp()
	--PushDebugMessage("test UI YanMenMeng_MengYan_ShowHelp")
	PushEvent("QUEST_HELPINFO", "#{YMMJ_230626_61}")
end
--===============================================
-- 梦魇结束
--===============================================
function YanMenMeng_MengYan_OnTimerEnd()
	--特效界面
	YanMenMeng_MengYan_MengYanTime:Hide()
	YanMenMeng_MengYan_info2:Show()--积蓄中
	YanMenMeng_MengYan_info:Hide()--倒计时
end