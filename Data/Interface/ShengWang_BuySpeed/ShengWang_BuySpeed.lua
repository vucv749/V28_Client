local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

--******************************
--战令补充进度界面
--******************************

local g_CurMonthPoint = 0
local g_MaxAddNum = 0
local g_MinAddNum = 0
local g_AddNum = 0
local g_ButtonLastTime =0
local g_ButtonCDTime = 2


function ShengWang_BuySpeed_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("UPDATE_YUANBAO",false)
end

function ShengWang_BuySpeed_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		ShengWang_BuySpeed_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ShengWang_BuySpeed_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
        this:Hide()
    elseif (event == "UPDATE_YUANBAO") then
        ShengWang_BuySpeed_UpdateYuanBao()
    elseif event == "UI_COMMAND" and (tonumber(arg0) == 89021503) then	--服务端传数据
        local optType = Get_XParam_INT(0)	--界面操作类型（0 关闭，1打开， 2刷新）
        if 0 == optType then
            --关闭
            this:Hide()
        end 
        if  2 == optType and not this:IsVisible() then
            return 
        end
        if 1 == optType or 2 == optType then
            --打开或刷新
            g_CurMonthPoint = Get_XParam_INT(1)
            g_MaxAddNum = Get_XParam_INT(2)
            g_MinAddNum = Get_XParam_INT(3)
            ShengWang_BuySpeed_Open()
        end
	end
end

function ShengWang_BuySpeed_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= ShengWang_BuySpeed_Frame:GetProperty("UnifiedXPosition")
	g_Frame_UnifiedYPosition	= ShengWang_BuySpeed_Frame:GetProperty("UnifiedYPosition")
end

function ShengWang_BuySpeed_Open()
    g_AddNum = 1
    ShengWang_BuySpeed_InputNum:SetProperty("DefaultEditBox", "True")
    ShengWang_BuySpeed_InputNum:SetText("1")
    ShengWang_BuySpeed_InputNum:SetSelected(0, -1)
    local nHaveYuanbao =  Player:GetData( "YUANBAO" )
    -- local strMsg = "#{TLZL_190802_155}"
    -- if 10 > nHaveYuanbao then
        -- strMsg = "#{TLZL_190802_154}"
    -- end
    ShengWang_BuySpeed_Cash_Yuanbao:SetText(tostring(nHaveYuanbao))
    ShengWang_BuySpeed_Price_Yuanbao:SetText(tostring(50))
    this:Show()
end

function ShengWang_BuySpeed_EditEnter()
    if g_MaxAddNum == 0 then
        g_MaxAddNum = 1
    end
    --获取数量
    local num = tonumber(ShengWang_BuySpeed_InputNum:GetText())
    
    if nil == num then
        num = 0
    elseif num > g_MaxAddNum then
        num = g_MaxAddNum
        ShengWang_BuySpeed_InputNum:SetText(tostring(num))
    elseif num < g_MinAddNum then
        num = g_MinAddNum
        ShengWang_BuySpeed_InputNum:SetText(tostring(num))

    end

    --计算所需元宝数
    --刷新玩家元宝数
    local nHaveYuanbao =  Player:GetData( "YUANBAO" )
    local nNeedYuanbao = num * 50
    -- local strMsg = "#{TLZL_190802_155}"
    -- if nNeedYuanbao > nHaveYuanbao then
        -- strMsg = "#{TLZL_190802_154}"
    -- end
    ShengWang_BuySpeed_Price_Yuanbao:SetText(tostring(nNeedYuanbao))

    ShengWang_BuySpeed_Cash_Yuanbao:SetText(tostring(nHaveYuanbao))

    g_AddNum = num
end

function ShengWang_BuySpeed_UpdateYuanBao()
    --local strMsg = "#{TLZL_190802_155}"
    local nHaveYuanbao =  Player:GetData( "YUANBAO" )
    local nNeedYuanbao = g_AddNum * 50
    -- if nNeedYuanbao > nHaveYuanbao then
        -- strMsg = "#{TLZL_190802_154}"
    -- end
    ShengWang_BuySpeed_Cash_Yuanbao:SetText(tostring(nHaveYuanbao))
end

function ShengWang_BuySpeed_OnMax()
    ShengWang_BuySpeed_InputNum:SetText(tostring(g_MaxAddNum))
    ShengWang_BuySpeed_EditEnter()
end

function ShengWang_BuySpeed_OK_Clicked()
	local curTime = OSAPI:GetTickCount();
	if ( curTime - g_ButtonLastTime < g_ButtonCDTime * 1000) then
 	 	PushDebugMessage("#{SWXT_221213_220}"); --不可连续点击，请稍等片刻后再点击
   		return;
   	end
   	g_ButtonLastTime = curTime;
	
    if "" == ShengWang_BuySpeed_InputNum:GetText() then
        PushDebugMessage("#{SWXT_221213_27}")
        return 
    end
    --通知服务端脚本传数据
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name( "AskAddProgress" )
    Set_XSCRIPT_ScriptID( 890215 )
    Set_XSCRIPT_Parameter(0,g_AddNum)
    Set_XSCRIPT_Parameter(1,1)
    Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end

function ShengWang_BuySpeed_Close_Clicked()
    this:Hide()
end

--================================================
-- 界面的默认相对位置
--================================================
function ShengWang_BuySpeed_ResetPos()
	ShengWang_BuySpeed_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	ShengWang_BuySpeed_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function ShengWang_BuySpeed_OnHiden()
    ShengWang_BuySpeed_InputNum:SetProperty("DefaultEditBox", "False")
end