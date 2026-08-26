--****************************************
-- 雁门梦境 boss4 魔气界面
-- limengyue 2023-07-21
--****************************************


local g_YanMenMeng_XinMo_Frame_UnifiedPosition;

--关心NPc
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local g_Object = -1

--===============================================
-- OnLoad()
--===============================================
function YanMenMeng_XinMo_PreLoad()
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
function YanMenMeng_XinMo_OnLoad()   
	-- 保存界面的默认相对位置
	g_YanMenMeng_XinMo_Frame_UnifiedPosition = YanMenMeng_XinMo:GetProperty("UnifiedPosition");
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function YanMenMeng_XinMo_Frame_On_ResetPos()
	YanMenMeng_XinMo:SetProperty("UnifiedPosition", g_YanMenMeng_XinMo_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function YanMenMeng_XinMo_OnEvent(event)

    if(event == "UI_COMMAND" and tonumber(arg0) == 99846201) then
		--打开界面
		if(IsWindowShow("YanMenMeng_XinMo")) then
			CloseWindow("YanMenMeng_XinMo", true)
		end
		YanMenMeng_XinMo_Show(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3))
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 99846202) then
		YanMenMeng_XinMo_OnHiden()
	end
    -- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		YanMenMeng_XinMo_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YanMenMeng_XinMo_Frame_On_ResetPos()
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       YanMenMeng_XinMo_OnHiden()
    end
         
end

--===============================================
-- YanMenMeng_XinMo_OnHiden()
--===============================================
function YanMenMeng_XinMo_OnHiden()
	this:Hide()
end

--===============================================
-- 打开界面
--===============================================
function YanMenMeng_XinMo_Show(nMoqiNum,nMoqiMax,nGolden,nGoldenMax)
	--PushDebugMessage("test UI YanMenMeng_XinMo_Show nMoqiNum="..nMoqiNum.." nMoqiMax="..nMoqiMax.." nGolden="..nGolden.." nGoldenMax="..nGoldenMax)
	--YMMJ_230626_163	%s0/18
	if nMoqiNum < nMoqiMax then
		YanMenMeng_XinMo_Num1:SetText(ScriptGlobal_Format("#{YMMJ_230626_163}",nMoqiNum,nMoqiMax))
		--设置魔气图片
		YanMenMeng_XinMo_LTOP:Hide()
		YanMenMeng_XinMo_Text1:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoL1");
		if nMoqiNum > 0 and nMoqiNum <= 4 then
			YanMenMeng_XinMo_Text1:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoL2");
		elseif nMoqiNum > 4 and nMoqiNum <= 8 then
			YanMenMeng_XinMo_Text1:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoL3");
		elseif nMoqiNum > 8 and nMoqiNum <= 11 then
			YanMenMeng_XinMo_Text1:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoL4");
		elseif nMoqiNum > 11 and nMoqiNum <= 14 then
			YanMenMeng_XinMo_Text1:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoL5");
		elseif nMoqiNum > 14 and nMoqiNum < 18 then
			YanMenMeng_XinMo_Text1:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoL6");
		end
	else
		YanMenMeng_XinMo_Num1:SetText("#{YMMJ_230626_202}")
		--设置魔气图片
		YanMenMeng_XinMo_LTOP:Show()
		YanMenMeng_XinMo_Text1:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoL7");
	end
	if nGolden < nGoldenMax then
		YanMenMeng_XinMo_Num2:SetText(ScriptGlobal_Format("#{YMMJ_230626_205}",nGolden,nGoldenMax))
		--设置魔气图片
		YanMenMeng_XinMo_RTOP:Hide()
		YanMenMeng_XinMo_Text2:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoR1");
		if nGolden == 1 then
			YanMenMeng_XinMo_Text2:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoR2");
		elseif nGolden == 2 then
			YanMenMeng_XinMo_Text2:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoR3");
		elseif nGolden == 3 then
			YanMenMeng_XinMo_Text2:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoR4");
		end
	else
		YanMenMeng_XinMo_Num2:SetText("#{YMMJ_230626_204}")
		--设置魔气图片
		YanMenMeng_XinMo_RTOP:Show()
		YanMenMeng_XinMo_Text2:SetProperty("Image","set:YanMenMeng image:YanMenMeng_XinMoR5");
	end
	this:Show()
end
