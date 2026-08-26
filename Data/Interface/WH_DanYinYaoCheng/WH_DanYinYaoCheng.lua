--丹引药成
--
--
--界面数据

local g_WH_DanYinYaoChengFrame_UnifiedPosition
local g_UICOMMAND = 99881201
local g_objId = -1
local g_objCared = -1
local MAX_OBJ_DISTANCE = 3.0

--OnLoad数据
local WH_DanYinYaoCheng_ItemShow = {} --1X3?? ????
local WH_DanYinYaoCheng_ItemAnimate = {} --1X3 ??????
local WH_DanYinYaoCheng_Item = { --1X3?? ??
    [1] = { Itemid = 20600002,num = 1},	----?????
    [2] = { Itemid = 20501003,num = 1},	----3???
    [3] = { Itemid = 20502003,num = 1},	----3???
}
local WH_DanYinYaoCheng_ItemList = {}  --????
local WH_DanYinYaoCheng_Receive = {} --1X3?? ???
local WH_DanYinYaoCheng_Advanced = {} --1X8?? ???
local WH_DanYinYaoCheng_Advanced_Animate = {} --1X8?? ??? ??
local WH_DanYinYaoCheng_Text = nil
local WH_DanYinYaoCheng_MaxNum = 14 --???????????
local WH_DanYinYaoCheng_NeedNum = { 3, 8 ,14 }
local WH_DanYinYaoCheng_Award_OK = {} --??OK ????
local WH_DanYinYaoCheng_rewardMF = {}
function WH_DanYinYaoCheng_PreLoad()
    this:RegisterEvent("UI_COMMAND",true)
    this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function WH_DanYinYaoCheng_OnLoad()
    g_WH_DanYinYaoChengFrame_UnifiedPosition = WH_DanYinYaoChengFrame:GetProperty("UnifiedPosition")
    --累计奖励累计值文本框
    WH_DanYinYaoCheng_Text = WH_DanYinYaoCheng_CUMText
    --1X3格子 奖励显示
	WH_DanYinYaoCheng_ItemShow[1]	= WH_DanYinYaoCheng_CUM1Btn
	WH_DanYinYaoCheng_ItemShow[2]	= WH_DanYinYaoCheng_CUM2Btn
	WH_DanYinYaoCheng_ItemShow[3]	= WH_DanYinYaoCheng_CUM3Btn

    WH_DanYinYaoCheng_ItemAnimate[1]	= WH_DanYinYaoCheng_CUM1Btn_ItemAnimate
	WH_DanYinYaoCheng_ItemAnimate[2]	= WH_DanYinYaoCheng_CUM2Btn_ItemAnimate
	WH_DanYinYaoCheng_ItemAnimate[3]	= WH_DanYinYaoCheng_CUM3Btn_ItemAnimate

    --1X3格子 已领取
	WH_DanYinYaoCheng_Award_OK[1]	= WH_DanYinYaoCheng_CUM1BtnOK
	WH_DanYinYaoCheng_Award_OK[2]	= WH_DanYinYaoCheng_CUM2BtnOK
	WH_DanYinYaoCheng_Award_OK[3]	= WH_DanYinYaoCheng_CUM3BtnOK
end

function WH_DanYinYaoCheng_OnHidden()

    if nil ~= g_objCared and g_objCared > 0 then
		this:CareObject(g_objCared, 0, "WH_DanYinYaoCheng")
    end

    this:Hide()

end

function WH_DanYinYaoCheng_Close()
    WH_DanYinYaoCheng_OnHidden()
end

function WH_DanYinYaoCheng_ResetPos()
    WH_DanYinYaoChengFrame:SetProperty("UnifiedPosition", g_WH_DanYinYaoChengFrame_UnifiedPosition)
end

function WH_DanYinYaoCheng_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
        --打开七夕鹊桥界面
        -- 1累计次数
        -- 2npcid
        -- 3第一个奖励是否已领取
        -- 4第二个奖励是否已领取
        -- 5第一个奖励是否已领取
        
        local accumulateTime = Get_XParam_INT(0)
              g_objId   = Get_XParam_INT(1)
        local reward1MF = Get_XParam_INT(2)
        local reward2MF = Get_XParam_INT(3)
        local reward3MF = Get_XParam_INT(4)
        WH_DanYinYaoCheng_rewardMF = {reward1MF, reward2MF ,reward3MF}
        --打开界面
        WH_DanYinYaoCheng_Open(accumulateTime,reward1MF,reward2MF,reward3MF)

        --end
    elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
        if(arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy") then
            WH_DanYinYaoCheng_Close()
        end
    end

    if this:IsVisible() then
        if event == "ADJEST_UI_POS" or
			event == "VIEW_RESOLUTION_CHANGED" then
				WH_DanYinYaoCheng_ResetPos()
        elseif event == "HIDE_ON_SCENE_TRANSED" then
            WH_DanYinYaoCheng_OnHidden()
        end
    end
end

--打开界面
-- 1累计次数
-- 2第一个奖励是否已领取
-- 3第二个奖励是否已领取
-- 4第一个奖励是否已领取
function WH_DanYinYaoCheng_Open(accumulateTime,reward1MF,reward2MF,reward3MF)
    --设置累计次数数值
    WH_DanYinYaoCheng_Text:SetText(ScriptGlobal_Format("#{XRBG_20240412_97}", accumulateTime))
    --已领取奖励
    WH_DanYinYaoCheng_LinQuPrize(reward1MF,reward2MF,reward3MF)
    --进度条染色
    WH_DanYinYaoCheng_JinDuTiao(accumulateTime)

    --牴示物品
	for i = 1, 3, 1 do
		local theAction = DataPool:CreateBindActionItemForShow(WH_DanYinYaoCheng_Item[i].Itemid, WH_DanYinYaoCheng_Item[i].num)
		if theAction:GetID() ~= 0 then
			WH_DanYinYaoCheng_ItemShow[i]:SetActionItem(theAction:GetID())
			WH_DanYinYaoCheng_ItemShow[i]:Show()
		end
	end
    this:Show()

end
function WH_DanYinYaoCheng_OnRewardClick(index)
    WH_DanYinYaoCheng_Award(index)
end
--已领取奖励
function WH_DanYinYaoCheng_LinQuPrize(reward1MF,reward2MF,reward3MF)
    
    if reward1MF == 1 then
        --奖励OK
        WH_DanYinYaoCheng_Award_OK[1]:Show()
    else
        WH_DanYinYaoCheng_Award_OK[1]:Hide()
    end
    if reward2MF == 1 then
        --奖励OK
        WH_DanYinYaoCheng_Award_OK[2]:Show()
    else
        WH_DanYinYaoCheng_Award_OK[2]:Hide()
    end
    if reward3MF == 1 then
        --奖励OK
        WH_DanYinYaoCheng_Award_OK[3]:Show()
    else
        WH_DanYinYaoCheng_Award_OK[3]:Hide()
    end

end

--进度条
function WH_DanYinYaoCheng_JinDuTiao(accumulateTime)
    for i = 1, 3, 1 do
        if accumulateTime >= WH_DanYinYaoCheng_NeedNum[i] and WH_DanYinYaoCheng_rewardMF[i]~= 1 then
            WH_DanYinYaoCheng_ItemAnimate[i]:Show()
        else
            WH_DanYinYaoCheng_ItemAnimate[i]:Hide()
        end
	end
    WH_DanYinYaoCheng_Progress:SetProgress(accumulateTime,WH_DanYinYaoCheng_MaxNum)
end

--1-3 领奖
function WH_DanYinYaoCheng_Award(rewardIndex)
    --1-3 领奖
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(998812)
        Set_XSCRIPT_Function_Name("GetAccumulateReward")
        Set_XSCRIPT_Parameter( 0, g_objId )
        Set_XSCRIPT_Parameter( 1, rewardIndex )
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end
