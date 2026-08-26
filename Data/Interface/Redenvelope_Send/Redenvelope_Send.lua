--******************************
--红包主界面
--******************************
local RedPacket_Send_Frame_UnifiedPosition;

local NeedAmount = 10;
--单个金额
local SingleAmount = 10;
--0是定额,1是拼手气
local DistributeType = 1;
--1是金币，2是元宝
local RedEnvelopeMoneyType = 1;
local RedEnvelopeNum = 1;

--0不发口令，1后续为口令
local CiphereIndex = 0;

--0世界,1同城，2帮会
local ChannelType = 1;


--MD
local MDRecord = 0;
--发送红包数量限制
local SendLimit = 20;

local MoneyStr =
{
    --定额
            --单个金额字典                          --需要金币字典                         --拥有金币字典
	[0] = {SingleAmountStr = "#{HBXTS_221214_18}", NeedAmountStr = "#{HBXTS_221214_16}",OwnAmountStr = "#{HBXTS_221214_13}"},
    --拼手气
           --总金额字典                           --拥有金币字典
	[1] = {TotalAmountStr = "#{HBXTS_221214_17}",OwnAmountStr = "#{HBXTS_221214_13}"},

}

local YuanBaoStr =
{
           --单个金额字典                          --需要元宝字典                        --拥有元宝字典
	[0] = {SingleAmountStr = "#{HBXTS_221214_18}", NeedAmountStr = "#{HBXTS_221214_15}",OwnAmountStr = "#{HBXTS_221214_14}"},
            --总金额字典                          --拥有元宝字典
	[1] = {TotalAmountStr = "#{HBXTS_221214_17}",OwnAmountStr = "#{HBXTS_221214_14}"},

}

function Redenvelope_Send_PreLoad()
    this:RegisterEvent("UI_COMMAND");
    -- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS");
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
    --玩家切场景
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED");

    --监听事件
    this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("UPDATE_YUANBAO");
end

function Redenvelope_Send_OnEvent(event)

    if ( event == "UI_COMMAND" and tonumber(arg0) == 89025301) then
        --更新MD
        MDRecord = Get_XParam_INT(0);
        Redenvelope_Send_Open();
    elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89025302) then
        --更新MD
        MDRecord = Get_XParam_INT(0);

        
        local temp = math.floor(MDRecord/100);
        local nMoneyRedEnvelope = math.mod(temp,100);
    
        local nYuanBaoRedEnvelope = math.mod(MDRecord,100);
        
        --1是金币，2是元宝
        if RedEnvelopeMoneyType == 1 then
            if (SendLimit - nMoneyRedEnvelope) < 0 then
                local text = ScriptGlobal_Format("#{HBXTS_221214_28}", 0);
                RedPacket_Send_LeftTimes:SetText(text);
            else
                local text = ScriptGlobal_Format("#{HBXTS_221214_28}", SendLimit - nMoneyRedEnvelope);
                RedPacket_Send_LeftTimes:SetText(text);
            end
        else
            if (SendLimit - nMoneyRedEnvelope) < 0 then
                local text = ScriptGlobal_Format("#{HBXTS_221214_27}", 0);
                RedPacket_Send_LeftTimes:SetText(text);
            else
                local text = ScriptGlobal_Format("#{HBXTS_221214_27}", SendLimit - nYuanBaoRedEnvelope);
                RedPacket_Send_LeftTimes:SetText(text);
            end
        end

    elseif event== "HIDE_ON_SCENE_TRANSED"  then
        Redenvelope_Send_CloseUI();

    -- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		Redenvelope_Send_Frame_On_ResetPos();

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Redenvelope_Send_Frame_On_ResetPos();

	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		Redenvelope_Send_UpdateMoney( DistributeType, 2);
        
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Redenvelope_Send_UpdateMoney( DistributeType, 1);
    end

end

--**********************************
--关睜UI
--**********************************
function Redenvelope_Send_CloseUI()
    this:Hide();
end

--=========================================================
--界面隐藏
--=========================================================
function Redenvelope_Send_OnHiden()
    this:Hide();
end

--**********************************
--打开红包界面
--**********************************
function Redenvelope_Send_Open()
	this:Show();


    --红包分配方式
    DistributeType = 0;
    --是否点击允许发送红包按钮
    CiphereIndex = 0;
    --红包发送范围
    ChannelType = 0;


    --设置下拉菜单
    RedPacket_Send_Distribute:SetCurrentSelect(DistributeType);

    --需要减1,SetCurrentSelect貌似从0开始
    RedPacket_Send_Type:SetCurrentSelect(0);
    --设置发送范围下拉菜单
    RedPacket_Send_Range:SetCurrentSelect(ChannelType);
    --设置发送第几个口令
    RedPacket_Send_Word:SetCurrentSelect(0);
    --关睜口令按钮
    RedPacket_Send_WordCheck:SetCheck(0);

    --更新UI界面
    --红包种类
    RedEnvelopeMoneyType = 1;

    UpdateUIState( DistributeType, RedEnvelopeMoneyType);


end

function Redenvelope_Send_OnLoad()
    RedPacket_Send_Frame_UnifiedPosition = RedPacket_Send_Frame:GetProperty("UnifiedPosition");


    --红包分配方式
    RedPacket_Send_Distribute:ResetList();
    RedPacket_Send_Distribute:AddTextItem("#{HBXTS_221214_7}" ,0);
    RedPacket_Send_Distribute:AddTextItem("#{HBXTS_221214_6}" ,1);

    --红包种类
    RedPacket_Send_Type:ResetList();
    RedPacket_Send_Type:AddTextItem("#{HBXTS_221214_24}" ,1);
	RedPacket_Send_Type:AddTextItem("#{HBXTS_221214_4}" ,2);

    --红包发送范围
    RedPacket_Send_Range:ResetList();
    RedPacket_Send_Range:AddTextItem("#{HBXTS_221214_9}" ,0);
	RedPacket_Send_Range:AddTextItem("#{HBXTS_221214_10}" ,1);
    RedPacket_Send_Range:AddTextItem("#{HBXTS_221214_12}" ,2);

    --红包数量
    RedPacket_Send_Numbers:SetTextOriginal( tostring(1));

    --口令
    RedPacket_Send_Word:ResetList();
    RedPacket_Send_Word:AddTextItem("#{HBXTS_221214_11}" ,1);
	RedPacket_Send_Word:AddTextItem("#{HBXTS_221214_30}" ,2);
    RedPacket_Send_Word:AddTextItem("#{HBXTS_221214_119}",3);
    RedPacket_Send_Word:AddTextItem("#{HBXTS_221214_120}",4);
    RedPacket_Send_Word:AddTextItem("#{HBXTS_221214_121}",5);
    RedPacket_Send_Word:AddTextItem("#{HBXTS_221214_126}",6);
    RedPacket_Send_Word:AddTextItem("#{HBXTS_221214_127}",7);
    RedPacket_Send_Word:AddTextItem("#{HBXTS_221214_128}",8);
end

function Redenvelope_Send_Frame_On_ResetPos()
    RedPacket_Send_Frame:SetProperty("UnifiedPosition", RedPacket_Send_Frame_UnifiedPosition);
end


--**********************************
--分配方式下拉条变化
--**********************************
function Redenvelope_Send_TypeChanged()
    local str, nIndex = RedPacket_Send_Distribute:GetCurrentSelect();
    DistributeType = nIndex;
    UpdateUIState( DistributeType, RedEnvelopeMoneyType);
end


--**********************************
--红包种类下拉条变化
--**********************************
function Redenvelope_Send_MoneyTypeChanged()
    local str, nIndex = RedPacket_Send_Type:GetCurrentSelect();
    RedEnvelopeMoneyType = nIndex;
    UpdateUIState( DistributeType, RedEnvelopeMoneyType);
end

--**********************************
--红包/分配方式变化刷新
--**********************************
function UpdateUIState( DistributeType, RedEnvelopeMoneyType)
    RedPacket_Send_Numbers:SetProperty("Text", tostring(1));

    --更新MD

    local temp = math.floor(MDRecord/100);
    local nMoneyRedEnvelope = math.mod(temp,100);

    local nYuanBaoRedEnvelope = math.mod(MDRecord,100);

    RedPacket_Send_Numbers:SetProperty("MaxTextLength","3");

    --拼手气
    if DistributeType == 1 then
        --1是金币，2是元宝
        if RedEnvelopeMoneyType == 1 then
            --设置最低
            RedPacket_Send_Amount:SetProperty("Text", tostring(100));
            --拥有金币字典
            local nMoney = Player:GetData("MONEY")
            if num == nil then
                num = 0
            end

            RedPacket_Send_Balance_HaveText:Show();
            RedPacket_Send_Balance_HaveText:SetText(MoneyStr[DistributeType].OwnAmountStr);
            RedPacket_Send_Balance_HaveTextNumber:SetProperty("MoneyNumber", tostring(nMoney));
            RedPacket_Send_Balance_HaveTextNumber:Show();
            
            RedPacket_Send_Balance_HaveYuanbaoNumber:Hide();
            RedPacket_Send_Balance_HaveYuanbaoIcon:Hide();

            --隐藏需要元宝/金币字典
            RedPacket_Send_Balance_NeedText:Hide();
            RedPacket_Send_Balance_NeedTextNumber:Hide();
            RedPacket_Send_Balance_NeedYuanbaoNumber:Hide();
            RedPacket_Send_Balance_NeedYuanbaoIcon:Hide();

            --改成总金额字典
            RedPacket_Send_AmountText:SetText(MoneyStr[DistributeType].TotalAmountStr);
            RedPacket_Send_Amount:SetProperty("MaxTextLength","5");

            if (SendLimit - nMoneyRedEnvelope) < 0 then
                local text = ScriptGlobal_Format("#{HBXTS_221214_28}", 0);
                RedPacket_Send_LeftTimes:SetText(text);
            else
                local text = ScriptGlobal_Format("#{HBXTS_221214_28}", SendLimit - nMoneyRedEnvelope);
                RedPacket_Send_LeftTimes:SetText(text);
            end

        else
            --设置最低
            RedPacket_Send_Amount:SetProperty("Text", tostring(500));
            RedPacket_Send_Amount:SetProperty("MaxTextLength","6");
            --拥有元宝字典
            RedPacket_Send_Balance_HaveText:Show();
            RedPacket_Send_Balance_HaveText:SetText(YuanBaoStr[DistributeType].OwnAmountStr);

            RedPacket_Send_Balance_HaveTextNumber:Hide();
            
            RedPacket_Send_Balance_HaveYuanbaoNumber:SetText(tostring(Player:GetData("YUANBAO")));
            RedPacket_Send_Balance_HaveYuanbaoNumber:Show();
            RedPacket_Send_Balance_HaveYuanbaoIcon:Show();

            --隐藏需要元宝/金币字典
            RedPacket_Send_Balance_NeedText:Hide();
            RedPacket_Send_Balance_NeedTextNumber:Hide();
            RedPacket_Send_Balance_NeedYuanbaoNumber:Hide();
            RedPacket_Send_Balance_NeedYuanbaoIcon:Hide();

            --改成单个金额字典
            RedPacket_Send_AmountText:SetText(YuanBaoStr[DistributeType].TotalAmountStr);

            if (SendLimit - nMoneyRedEnvelope) < 0 then
                local text = ScriptGlobal_Format("#{HBXTS_221214_27}", 0);
                RedPacket_Send_LeftTimes:SetText(text);
            else
                local text = ScriptGlobal_Format("#{HBXTS_221214_27}", SendLimit - nYuanBaoRedEnvelope);
                RedPacket_Send_LeftTimes:SetText(text);
            end

        end
    else
        --1是金币，2是元宝
        if RedEnvelopeMoneyType == 1 then

            --设置最低
            RedPacket_Send_Amount:SetProperty("Text", tostring(10));
            RedPacket_Send_Amount:SetProperty("MaxTextLength","4");
            --拥有金币字典
            local nMoney = Player:GetData("MONEY")
            if num == nil then
                num = 0
            end

            RedPacket_Send_Balance_HaveText:Show();
            RedPacket_Send_Balance_HaveText:SetText(MoneyStr[DistributeType].OwnAmountStr);
            RedPacket_Send_Balance_HaveTextNumber:SetProperty("MoneyNumber", tostring(nMoney));
            RedPacket_Send_Balance_HaveTextNumber:Show();

            RedPacket_Send_Balance_HaveYuanbaoNumber:Hide();
            RedPacket_Send_Balance_HaveYuanbaoIcon:Hide();

            --需要金币字典
            RedPacket_Send_Balance_NeedText:Show();
            RedPacket_Send_Balance_NeedText:SetText(MoneyStr[DistributeType].NeedAmountStr);

            RedPacket_Send_Balance_NeedYuanbaoNumber:Hide();
            RedPacket_Send_Balance_NeedYuanbaoIcon:Hide();

            RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyNumber", tostring(NeedAmount*10000));
            RedPacket_Send_Balance_NeedTextNumber:Show();

            --改成单个金额字典
            RedPacket_Send_AmountText:SetText(MoneyStr[DistributeType].SingleAmountStr);

            if (SendLimit - nMoneyRedEnvelope) < 0 then
                local text = ScriptGlobal_Format("#{HBXTS_221214_28}", 0);
                RedPacket_Send_LeftTimes:SetText(text);
            else
                local text = ScriptGlobal_Format("#{HBXTS_221214_28}", SendLimit - nMoneyRedEnvelope);
                RedPacket_Send_LeftTimes:SetText(text);
            end
        else
            --设置最低
            RedPacket_Send_Amount:SetProperty("Text", tostring(50));
            RedPacket_Send_Amount:SetProperty("MaxTextLength","5");

            --拥有元宝字典
            RedPacket_Send_Balance_HaveText:Show();
            RedPacket_Send_Balance_HaveText:SetText(YuanBaoStr[DistributeType].OwnAmountStr);

            RedPacket_Send_Balance_HaveTextNumber:Hide();

            RedPacket_Send_Balance_HaveYuanbaoNumber:SetText(tostring(Player:GetData("YUANBAO")));
            RedPacket_Send_Balance_HaveYuanbaoNumber:Show();
            RedPacket_Send_Balance_HaveYuanbaoIcon:Show();


            --需要元宝字典
            RedPacket_Send_Balance_NeedText:Show();
            RedPacket_Send_Balance_NeedText:SetText(YuanBaoStr[DistributeType].NeedAmountStr);

            RedPacket_Send_Balance_NeedTextNumber:Hide();

            RedPacket_Send_Balance_NeedYuanbaoNumber:SetText(tostring(NeedAmount));
            RedPacket_Send_Balance_NeedYuanbaoNumber:Show();
            RedPacket_Send_Balance_NeedYuanbaoIcon:Show();

            --改成单个金额字典
            RedPacket_Send_AmountText:SetText(YuanBaoStr[DistributeType].SingleAmountStr);

            if (SendLimit - nMoneyRedEnvelope) < 0 then
                local text = ScriptGlobal_Format("#{HBXTS_221214_27}", 0);
                RedPacket_Send_LeftTimes:SetText(text);
            else
                local text = ScriptGlobal_Format("#{HBXTS_221214_27}", SendLimit - nYuanBaoRedEnvelope);
                RedPacket_Send_LeftTimes:SetText(text);
            end

        end
    end

end

--=========================================================
--输入数字，立刻计算
--=========================================================
function Redenvelope_Send_MoneyCountChanged()
    --填入的金额
    local str = RedPacket_Send_Amount:GetText();
	local strNumber = 0;
    strNumber = tonumber( str );

    if(nil == strNumber or(strNumber and strNumber < 0)) then
        strNumber = 0;
        if DistributeType == 1 then
            NeedAmount = strNumber;
        else
            SingleAmount = strNumber;
        end
        RedEnvelopeNumClicked(2);

        --金币
        RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyNumber", tostring(0));
        RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyColor", "FFFFFFFF");
        --元宝
        RedPacket_Send_Balance_NeedYuanbaoNumber:SetText(tostring(0));

        return;
	end

    if RedEnvelopeMoneyType == 1 and DistributeType == 1 then

        if strNumber > 10000 then
            strNumber = 10000;
            RedPacket_Send_Amount:SetProperty("Text", tostring(strNumber));
        end

    elseif RedEnvelopeMoneyType == 2 and DistributeType == 1 then

        if strNumber > 100000 then
            strNumber = 100000;
            RedPacket_Send_Amount:SetProperty("Text", tostring(strNumber));
        end

    elseif RedEnvelopeMoneyType == 1 and DistributeType == 0 then

        if strNumber > 1000 then
            strNumber = 1000;
            RedPacket_Send_Amount:SetProperty("Text", tostring(strNumber));
        end

    elseif RedEnvelopeMoneyType == 2 and DistributeType == 0 then

        if strNumber > 10000 then
            strNumber = 10000;
            RedPacket_Send_Amount:SetProperty("Text", tostring(strNumber));
        end

    end


    local getMoney = Player:GetData("MONEY")
    local money = tonumber(getMoney)

    local getYuanBao = Player:GetData("YUANBAO")
    local yuanBao = tonumber(getYuanBao)

    if DistributeType == 1 then

        NeedAmount = strNumber;

    else
        SingleAmount = strNumber;
        NeedAmount = RedEnvelopeNum * SingleAmount;

        --刷新需要金额
        if RedEnvelopeMoneyType == 1 then
            if NeedAmount*10000 > money then
                RedPacket_Send_Balance_NeedText:SetText(MoneyStr[DistributeType].NeedAmountStr);
                RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyNumber", tostring(NeedAmount*10000));
                RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyColor", "FFFF0000");
            else
                RedPacket_Send_Balance_NeedText:SetText(MoneyStr[DistributeType].NeedAmountStr);
                RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyNumber", tostring(NeedAmount*10000));
                RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyColor", "FFFFFFFF");
            end
        else
            if NeedAmount > yuanBao then
                RedPacket_Send_Balance_NeedText:SetText(YuanBaoStr[DistributeType].NeedAmountStr);
                RedPacket_Send_Balance_NeedYuanbaoNumber:SetText(tostring(NeedAmount));
                RedPacket_Send_Balance_NeedYuanbaoNumber:SetProperty("TextColor", "FFFF0000");
            else
                RedPacket_Send_Balance_NeedText:SetText(YuanBaoStr[DistributeType].NeedAmountStr);
                RedPacket_Send_Balance_NeedYuanbaoNumber:SetText(tostring(NeedAmount));
                RedPacket_Send_Balance_NeedYuanbaoNumber:SetProperty("TextColor", "FFFFF263");
            end
        end

    end

    --修改总金额后,刷新红包数量
    RedEnvelopeNumClicked(2)

end

--**********************************
--金币/元宝刷新
--**********************************
function Redenvelope_Send_UpdateMoney( DistributeType, RedEnvelopeMoneyType)

    local nMoney = Player:GetData("MONEY")
    if nMoney == nil then
        nMoney = 0
    end

    local getYuanBao = Player:GetData("YUANBAO")
    if getYuanBao == nil then
        getYuanBao = 0
    end
 
    --拼手气
    if DistributeType == 1 then
        if RedEnvelopeMoneyType == 1 then
            RedPacket_Send_Balance_HaveText:SetText(MoneyStr[DistributeType].OwnAmountStr);
            RedPacket_Send_Balance_HaveTextNumber:SetProperty("MoneyNumber", tostring(nMoney));
        else
            RedPacket_Send_Balance_HaveText:SetText(YuanBaoStr[DistributeType].OwnAmountStr);
            RedPacket_Send_Balance_HaveYuanbaoNumber:SetText(tostring(getYuanBao));
        end
    else
        if RedEnvelopeMoneyType == 1 then
            RedPacket_Send_Balance_HaveText:SetText(MoneyStr[DistributeType].OwnAmountStr);
            RedPacket_Send_Balance_HaveTextNumber:SetProperty("MoneyNumber", tostring(nMoney));
        else

            RedPacket_Send_Balance_HaveText:SetText(YuanBaoStr[DistributeType].OwnAmountStr);
            RedPacket_Send_Balance_HaveYuanbaoNumber:SetText(tostring(getYuanBao));
        end
    end


    if RedEnvelopeMoneyType == 1 then
        if NeedAmount*10000 > nMoney then
            RedPacket_Send_Balance_NeedText:SetText(MoneyStr[DistributeType].NeedAmountStr);
            RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyNumber", tostring(NeedAmount*10000));
            RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyColor", "FFFF0000");
        else
            RedPacket_Send_Balance_NeedText:SetText(MoneyStr[DistributeType].NeedAmountStr);
            RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyNumber", tostring(NeedAmount*10000));
            RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyColor", "FFFFFFFF");
        end
    else
        if NeedAmount > getYuanBao then
            RedPacket_Send_Balance_NeedText:SetText(YuanBaoStr[DistributeType].NeedAmountStr);
            RedPacket_Send_Balance_NeedYuanbaoNumber:SetText(tostring(NeedAmount));
            RedPacket_Send_Balance_NeedYuanbaoNumber:SetProperty("TextColor", "FFFF0000");
        else
            RedPacket_Send_Balance_NeedText:SetText(YuanBaoStr[DistributeType].NeedAmountStr);
            RedPacket_Send_Balance_NeedYuanbaoNumber:SetText(tostring(NeedAmount));
            RedPacket_Send_Balance_NeedYuanbaoNumber:SetProperty("TextColor", "FFFFF263");
        end
    end
end


--**********************************
--红包数量按钮
--type:减(0)/加(1)
--**********************************
function RedEnvelopeNumClicked( type)

    --输入框输入
    if type == 2 then
        --输入红包数
        local str = RedPacket_Send_Numbers:GetText();
        RedEnvelopeNum = tonumber( str );

        if RedEnvelopeNum == nil then
            RedEnvelopeNum = 1;
            RedPacket_Send_Numbers:SetProperty("Text", tostring(RedEnvelopeNum));

        --拼手气
        elseif NeedAmount > 0 and (RedEnvelopeNum >  math.min( math.ceil(NeedAmount/10), 100 )) and RedEnvelopeMoneyType == 1 and DistributeType == 1 then
            RedEnvelopeNum = math.min( math.ceil(NeedAmount/10), 100 );
            --最多发送金币红包
           local str = ScriptGlobal_Format("#{HBXTS_221214_115}",RedEnvelopeNum)
            PushDebugMessage(str);

            --设置红包数量
            RedPacket_Send_Numbers:SetProperty("Text", tostring(RedEnvelopeNum));

        elseif NeedAmount > 0 and (RedEnvelopeNum >  math.min( math.ceil(NeedAmount/100), 100 )) and RedEnvelopeMoneyType == 2 and DistributeType == 1 then
            RedEnvelopeNum = math.min( math.ceil(NeedAmount/100), 100 );
            --最多发送元宝红包
            local str = ScriptGlobal_Format("#{HBXTS_221214_116}",RedEnvelopeNum)
            PushDebugMessage(str);

            --设置红包数量
            RedPacket_Send_Numbers:SetProperty("Text", tostring(RedEnvelopeNum));

        --定额
        elseif RedEnvelopeNum > 100 and RedEnvelopeMoneyType == 1 and DistributeType == 0 then
            RedEnvelopeNum = 100;
            --最多发送金币红包
            PushDebugMessage("#{HBXTS_221214_117}");

            --设置红包数量
            RedPacket_Send_Numbers:SetProperty("Text", tostring(RedEnvelopeNum));

        elseif RedEnvelopeNum > 100 and RedEnvelopeMoneyType == 2 and DistributeType == 0 then
            RedEnvelopeNum = 100;
            --最多发送元宝红包
            PushDebugMessage("#{HBXTS_221214_118}");

            --设置红包数量
            RedPacket_Send_Numbers:SetProperty("Text", tostring(RedEnvelopeNum));

        elseif RedEnvelopeNum < 1 then
            RedEnvelopeNum = 1;
            if RedEnvelopeMoneyType == 1 then
                --最少发送1个金币红包
             PushDebugMessage("#{HBXTS_221214_20}");
            else
                --最少发送1个元宝红包
             PushDebugMessage("#{HBXTS_221214_21}");
            end

            --设置红包数量
            RedPacket_Send_Numbers:SetProperty("Text", tostring(RedEnvelopeNum));

        elseif NeedAmount == 0 then
            RedEnvelopeNum = 1;

            if tonumber(str) ~= RedEnvelopeNum then
                --设置红包数量
                RedPacket_Send_Numbers:SetProperty("Text", tostring(RedEnvelopeNum));
            end

        end

    elseif type  == 1 then
    --加

        --红包数
        local str = RedPacket_Send_Numbers:GetText();
        RedEnvelopeNum = tonumber( str );

        if RedEnvelopeNum == nil then
            RedEnvelopeNum = 0;
        end
                
        --拼手气
        if RedEnvelopeNum <=  math.min( math.ceil(NeedAmount/10), 100 ) and RedEnvelopeMoneyType == 1 and DistributeType == 1 then
            RedEnvelopeNum = RedEnvelopeNum + 1;

        elseif RedEnvelopeNum <=  math.min( math.ceil(NeedAmount/100), 100 ) and RedEnvelopeMoneyType == 2 and DistributeType == 1 then
            RedEnvelopeNum = RedEnvelopeNum + 1;

        --定额
        elseif RedEnvelopeNum < 100 and RedEnvelopeMoneyType == 1 and DistributeType == 0 then
            RedEnvelopeNum = RedEnvelopeNum + 1;

        elseif RedEnvelopeNum < 100 and RedEnvelopeMoneyType == 2 and DistributeType == 0 then
            RedEnvelopeNum = RedEnvelopeNum + 1;

        
        --拼手气最大
        elseif RedEnvelopeNum >= math.min( math.ceil(NeedAmount/10), 100 ) and RedEnvelopeMoneyType == 1 and DistributeType == 1 then
            RedEnvelopeNum = math.min( math.ceil(NeedAmount/10), 100 );
            --特殊限制金额为0
            if RedEnvelopeNum <= 0 then
                RedEnvelopeNum = 1;
            else
                --最多发送金币红包
                local str = ScriptGlobal_Format("#{HBXTS_221214_115}",RedEnvelopeNum)
                PushDebugMessage(str);
            end
    
        elseif RedEnvelopeNum >= math.min( math.ceil(NeedAmount/100), 100 ) and RedEnvelopeMoneyType == 2 and DistributeType == 1 then
            RedEnvelopeNum = math.min( math.ceil(NeedAmount/100), 100 );
            --特殊限制金额为0
            if RedEnvelopeNum <= 0 then
                RedEnvelopeNum = 1;
            else
                --最多发送元宝红包
                local str = ScriptGlobal_Format("#{HBXTS_221214_116}",RedEnvelopeNum)
                PushDebugMessage(str);

            end

        --定额最大
        elseif RedEnvelopeNum >= 100 and RedEnvelopeMoneyType == 1 and DistributeType == 0 then
            RedEnvelopeNum = 100;
            --最多发送金币红包
            PushDebugMessage("#{HBXTS_221214_117}");

        elseif RedEnvelopeNum >= 100 and RedEnvelopeMoneyType == 2 and DistributeType == 0 then
            RedEnvelopeNum = 100;
            --最多发送元宝红包
            PushDebugMessage("#{HBXTS_221214_118}");
        end

        --设置红包数量
        RedPacket_Send_Numbers:SetProperty("Text", tostring(RedEnvelopeNum));

    elseif type == 0 then
    --减(最少1个)

        --红包数
        local str = RedPacket_Send_Numbers:GetText();
        RedEnvelopeNum = tonumber( str );

        if RedEnvelopeNum == nil then
            RedEnvelopeNum = 1;
        end
        
        if RedEnvelopeNum > 1 then
            RedEnvelopeNum = RedEnvelopeNum - 1;
        else
            if RedEnvelopeMoneyType == 1 then
                --您最低可发送1个金币红包
                PushDebugMessage("#{HBXTS_221214_20}");
            else
                --您最低可发送1个元宝红包
                PushDebugMessage("#{HBXTS_221214_21}");
            end
        end

        --设置红包数量
        RedPacket_Send_Numbers:SetProperty("Text", tostring(RedEnvelopeNum));
    end

    local getMoney = Player:GetData("MONEY")
    local money = tonumber(getMoney)

    local getYuanBao = Player:GetData("YUANBAO")
    local yuanBao = tonumber(getYuanBao)

    if DistributeType == 0 then
        NeedAmount = RedEnvelopeNum * SingleAmount;
        --刷新需要金额
        if RedEnvelopeMoneyType == 1 then
            if NeedAmount*10000 > money then
                RedPacket_Send_Balance_NeedText:SetText(MoneyStr[DistributeType].NeedAmountStr);
                RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyNumber", tostring(NeedAmount*10000));
                RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyColor", "FFFF0000");
            else
                RedPacket_Send_Balance_NeedText:SetText(MoneyStr[DistributeType].NeedAmountStr);
                RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyNumber", tostring(NeedAmount*10000));
                RedPacket_Send_Balance_NeedTextNumber:SetProperty("MoneyColor", "FFFFFFFF");
            end
        else
            if NeedAmount > yuanBao then
                RedPacket_Send_Balance_NeedText:SetText(YuanBaoStr[DistributeType].NeedAmountStr);
                RedPacket_Send_Balance_NeedYuanbaoNumber:SetText(tostring(NeedAmount));
                RedPacket_Send_Balance_NeedYuanbaoNumber:SetProperty("TextColor", "FFFF0000");
            else
                RedPacket_Send_Balance_NeedText:SetText(YuanBaoStr[DistributeType].NeedAmountStr);
                RedPacket_Send_Balance_NeedYuanbaoNumber:SetText(tostring(NeedAmount));
                RedPacket_Send_Balance_NeedYuanbaoNumber:SetProperty("TextColor", "FFFFF263");
            end
        end
    end
end


--**********************************
--口令按钮点击
--**********************************
function Redenvelope_Send_CiphereClicked()
    if CiphereIndex == 0 then
        local str, nIndex = RedPacket_Send_Word:GetCurrentSelect();
        CiphereIndex = nIndex;
    else
        CiphereIndex = 0;
    end
end

--**********************************
--口令下拉栏改变
--**********************************
function Redenvelope_Send_CiphereChanged()

    if CiphereIndex ~= 0 then
        local str, nIndex = RedPacket_Send_Word:GetCurrentSelect();
        CiphereIndex = nIndex;
    end
end


--**********************************
--发送范围下拉栏改变
--**********************************
function Redenvelope_Send_ChannelChanged()
    local str, nIndex = RedPacket_Send_Range:GetCurrentSelect();
    ChannelType = nIndex;
end


--**********************************
--发送红包
--**********************************
function Redenvelope_Send_SendOut_Clicked()

    if NeedAmount < 100 and RedEnvelopeMoneyType == 1  and DistributeType == 1 then
        local str = ScriptGlobal_Format("#{HBXTS_221214_131}",100)
        PushDebugMessage(str);
        return;
    elseif NeedAmount < 500 and RedEnvelopeMoneyType == 2  and DistributeType == 1 then
        local str = ScriptGlobal_Format("#{HBXTS_221214_131}",500)
        PushDebugMessage(str);
        return;
    elseif SingleAmount < 10 and RedEnvelopeMoneyType == 1  and DistributeType == 0 then
        local str = ScriptGlobal_Format("#{HBXTS_221214_130}",10)
        PushDebugMessage(str);
        return;
    elseif SingleAmount < 50 and RedEnvelopeMoneyType == 2  and DistributeType == 0 then
        local str = ScriptGlobal_Format("#{HBXTS_221214_130}",50)
        PushDebugMessage(str);
        return;
     end


    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("CheckPlayer");
        Set_XSCRIPT_ScriptID(890253);
        Set_XSCRIPT_Parameter(0,DistributeType);
        Set_XSCRIPT_Parameter(1,CiphereIndex);
        Set_XSCRIPT_Parameter(2,ChannelType);
        Set_XSCRIPT_Parameter(3,RedEnvelopeMoneyType);
        Set_XSCRIPT_Parameter(4,NeedAmount);
        Set_XSCRIPT_Parameter(5,RedEnvelopeNum);
        Set_XSCRIPT_ParamCount(6);
    Send_XSCRIPT()
end

--**********************************
--历史记录
--**********************************
function Redenvelope_Send_History_Clicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("QueryRedEnvelope");
		Set_XSCRIPT_ScriptID(890253);
        Set_XSCRIPT_Parameter(0,2);
        Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()
end

--**********************************
--关睜
--**********************************
function RedPacket_Send_Close_Clicked()
    this:Hide();
end

