-- buglevel
local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

--******************************
--牻令补充进度界面
--******************************

local g_CurMonthPoint = 0
local g_MaxAddNum = 0
local g_MinAddNum = 0
local g_AddNum = 0
local g_ButtonLastTime =0
local g_ButtonCDTime = 2


function NewZhanLing_BuyLevel_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("UPDATE_YUANBAO",false)
end

function NewZhanLing_BuyLevel_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		NewZhanLing_BuyLevel_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		NewZhanLing_BuyLevel_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
        this:Hide()
    elseif (event == "UPDATE_YUANBAO") then
        NewZhanLing_BuyLevel_UpdateYuanBao()
    elseif event == "UI_COMMAND" and (tonumber(arg0) == 99852603) then	--??????
        local optType = Get_XParam_INT(0)	--??????(0 ??,1??, 2??)
        if 0 == optType then
            --关睜
            this:Hide()
        end 
        if  2 == optType and not this:IsVisible() then
            return 
        end
        if 1 == optType or 2 == optType then
            --打开或刷新
            g_CurMonthPoint = Get_XParam_INT(1)
			g_MaxAddNum = Get_XParam_INT(2)
			g_MaxAddNum = math.ceil(g_MaxAddNum/200)
            g_MinAddNum = Get_XParam_INT(3)
            NewZhanLing_BuyLevel_Open()
        end
	end
end

function NewZhanLing_BuyLevel_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= NewZhanLing_BuyLevel_Frame:GetProperty("UnifiedXPosition")
	g_Frame_UnifiedYPosition	= NewZhanLing_BuyLevel_Frame:GetProperty("UnifiedYPosition")
end

function NewZhanLing_BuyLevel_Open()
    g_AddNum = 1
    NewZhanLing_BuyLevel_InputNum:SetProperty("DefaultEditBox", "True")
    NewZhanLing_BuyLevel_InputNum:SetText("1")
    NewZhanLing_BuyLevel_InputNum:SetSelected(0, -1)
    local nHaveYuanbao =  Player:GetData( "YUANBAO" )
	local playerCoin_bindyuanbao = Player:GetData("BIND_YUANBAO");
    -- local strMsg = "#{TLZL_190802_155}"
    -- if 10 > nHaveYuanbao then
        -- strMsg = "#{TLZL_190802_154}"
    -- end
	if nHaveYuanbao + playerCoin_bindyuanbao >= 100 then
		NewZhanLing_BuyLevel_Cash_Yuanbao:SetText(ScriptGlobal_Format("#{ZLSJ_231106_35}",tostring(playerCoin_bindyuanbao),tostring(nHaveYuanbao)))
	else
		NewZhanLing_BuyLevel_Cash_Yuanbao:SetText(ScriptGlobal_Format("#{ZLSJ_231106_34}",tostring(playerCoin_bindyuanbao),tostring(nHaveYuanbao)))
	end
    NewZhanLing_BuyLevel_Price_Yuanbao:SetText(tostring(100))
    this:Show()
end

function NewZhanLing_BuyLevel_EditEnter()
    if g_MaxAddNum == 0 then
        g_MaxAddNum = 1
    end
    --获取数量
    local num = tonumber(NewZhanLing_BuyLevel_InputNum:GetText())
    
    if nil == num then
        num = 0
    elseif num > g_MaxAddNum then
        num = g_MaxAddNum
        NewZhanLing_BuyLevel_InputNum:SetText(tostring(num))
    elseif num < g_MinAddNum then
        num = g_MinAddNum
        NewZhanLing_BuyLevel_InputNum:SetText(tostring(num))

    end

    --计算所需元宝数
    --刷新玩家元宝数
    local nHaveYuanbao =  Player:GetData( "YUANBAO" )
    local nNeedYuanbao = num * 100
    -- local strMsg = "#{TLZL_190802_155}"
    -- if nNeedYuanbao > nHaveYuanbao then
        -- strMsg = "#{TLZL_190802_154}"
    -- end
	local playerCoin_bindyuanbao = Player:GetData("BIND_YUANBAO");
    NewZhanLing_BuyLevel_Price_Yuanbao:SetText(tostring(nNeedYuanbao))
	
   if nHaveYuanbao + playerCoin_bindyuanbao >= nNeedYuanbao then
		NewZhanLing_BuyLevel_Cash_Yuanbao:SetText(ScriptGlobal_Format("#{ZLSJ_231106_35}",tostring(playerCoin_bindyuanbao),tostring(nHaveYuanbao)))
	else
		NewZhanLing_BuyLevel_Cash_Yuanbao:SetText(ScriptGlobal_Format("#{ZLSJ_231106_34}",tostring(playerCoin_bindyuanbao),tostring(nHaveYuanbao)))
	end

    g_AddNum = num
end

function NewZhanLing_BuyLevel_UpdateYuanBao()
    --local strMsg = "#{TLZL_190802_155}"
    local nHaveYuanbao =  Player:GetData( "YUANBAO" )
	local playerCoin_bindyuanbao = Player:GetData("BIND_YUANBAO");
    local nNeedYuanbao = g_AddNum * 100
    -- if nNeedYuanbao > nHaveYuanbao then
        -- strMsg = "#{TLZL_190802_154}"
    -- end
  if nHaveYuanbao + playerCoin_bindyuanbao >= nNeedYuanbao then
		NewZhanLing_BuyLevel_Cash_Yuanbao:SetText(ScriptGlobal_Format("#{ZLSJ_231106_35}",tostring(playerCoin_bindyuanbao),tostring(nHaveYuanbao)))
	else
		NewZhanLing_BuyLevel_Cash_Yuanbao:SetText(ScriptGlobal_Format("#{ZLSJ_231106_34}",tostring(playerCoin_bindyuanbao),tostring(nHaveYuanbao)))
	end
end

function NewZhanLing_BuyLevel_OnMax()
    NewZhanLing_BuyLevel_InputNum:SetText(tostring(g_MaxAddNum))
    NewZhanLing_BuyLevel_EditEnter()
end

function NewZhanLing_BuyLevel_OK_Clicked()
	local curTime = OSAPI:GetTickCount();
	if ( curTime - g_ButtonLastTime < g_ButtonCDTime * 1000) then
 	 	PushDebugMessage("#{SWXT_221213_220}"); --??????,?????????
   		return;
   	end
   	g_ButtonLastTime = curTime;
	
    if "" == NewZhanLing_BuyLevel_InputNum:GetText() then
        PushDebugMessage("#{SWXT_221213_27}")
        return 
    end
    --通知服务端脚本传数据
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name( "AskAddProgress" )
    Set_XSCRIPT_ScriptID( 998526 )
    Set_XSCRIPT_Parameter(0,g_AddNum)
    Set_XSCRIPT_Parameter(1,0)
    Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end

function NewZhanLing_BuyLevel_Close_Clicked()
    this:Hide()
end

--================================================
-- 界面的默认相对位置
--================================================
function NewZhanLing_BuyLevel_ResetPos()
	NewZhanLing_BuyLevel_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	NewZhanLing_BuyLevel_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function NewZhanLing_BuyLevel_OnHiden()
    NewZhanLing_BuyLevel_InputNum:SetProperty("DefaultEditBox", "False")
end
