--∆ﬂœ¶ª≠æÌ
--
--
--ΩÁ√Ê ˝æ›

local g_Qixi_HuaJuanFrame_UnifiedPosition
local g_UICOMMAND = 99981501
local g_AutoRunUICOMMAND = 99981502
local g_UpdateUICOMMAND = 99981503
local g_FadeAnimateUICOMMAND = 99981504
local g_IsOriginHj = 0                  --??????
local g_bShowShopHotPoint = 0           --?????????
local g_playerLevel = 0                 --??????????
local g_rewardState = 0              --?????????
local g_playerLevelLimit = 30                 --??????????
local g_FadeAnimateParam = {}

local g_QuestState = 0                  --????
local g_IsGetQuest = 0                  --?????1????????????2
local Qixi_HuaJuan_CurTime = -1         --????,?????????
local Qixi_HuaJuan_StoryStateList       --???????????????????
local Qixi_HuaJuan_ShopOpenTime = 20250821         --??????
local Qixi_HuaJuan_ShopCloseTime = 20250917         --??????
local Qixi_HuaJuan_UnlockTime = {
    [1] = 20250821,
    [2] = 20250821,
    [3] = 20250828,
    [4] = 20250831,
}
local Qixi_HuaJuan_GoToMsg = {
    [1] = "#{QNHJ_250609_29}",
    [2] = "#{QNHJ_250609_78}",
    [3] = "#{QNHJ_250609_79}",
    [4] = "#{QNHJ_250609_80}",
}
--OnLoad ˝æ›
local Qixi_HuaJuan_FoldNum = 4          --????
local Qixi_HuaJuan_FoldList = {}        --????
local Qixi_HuaJuan_ItemShow = {}        --1X3?? ????
local Qixi_HuaJuan_RewardState = {}        --????
local Qixi_HuaJuan_IMGUnLock = {}        --????
local Qixi_HuaJuan_rewardNum = 5        --??????
local Qixi_HuaJuan_Item = {             --1X3?? ??
    [1] = { Itemid = 39920221, num = 20 }, ----20??
    [2] = { Itemid = 39920221, num = 20 }, ----20??
    [3] = { Itemid = 39920221, num = 20 }, ----20??
    [4] = { Itemid = 39920221, num = 20 }, ----20??
    [5] = { Itemid = 38003648, num = 1 }, ----????
}
local Qixi_HuaJuan_NPCInfo = {
    posx = 154.5, posy = 115, sceneId = 0, npcName = "Gi‡ nua Thﬂ Sinh"
}
local Qixi_HuaJuan_ClientList = {}
function Qixi_HuaJuan_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
    this:RegisterEvent("ADJEST_UI_POS", false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
end

function Qixi_HuaJuan_OnLoad()
    g_Qixi_HuaJuanFrame_UnifiedPosition = Qixi_HuaJuan_Frame:GetProperty("UnifiedPosition")
    --1X3∏Ò◊” Ω±¿¯œ‘ æ

    Qixi_HuaJuan_ItemShow[1] = Qixi_HuaJuan_MF1_Mission_1_Reward
    Qixi_HuaJuan_ItemShow[2] = Qixi_HuaJuan_MF2_Mission_2_Reward
    Qixi_HuaJuan_ItemShow[3] = Qixi_HuaJuan_MF3_Mission_3_Reward
    Qixi_HuaJuan_ItemShow[4] = Qixi_HuaJuan_MF4_Mission_4_Reward
    Qixi_HuaJuan_ItemShow[5] = Qixi_HuaJuan_MF4_Mission_4_Reward2

    Qixi_HuaJuan_ClientList[1] = Qixi_HuaJuan_Story_BK
    Qixi_HuaJuan_ClientList[2] = Qixi_HuaJuan_Client
    --π  ¬∑÷“≥
    Qixi_HuaJuan_FoldList[1] = Qixi_HuaJuan_MF_1
    Qixi_HuaJuan_FoldList[2] = Qixi_HuaJuan_MF_2
    Qixi_HuaJuan_FoldList[3] = Qixi_HuaJuan_MF_3
    Qixi_HuaJuan_FoldList[4] = Qixi_HuaJuan_MF_4

    Qixi_HuaJuan_RewardState[1] = {
        LightIMG = "set:QXHJ image:QXHJ_PageBtn_1_N",               --??????????
        button = Qixi_HuaJuan_MF_UnfoldBtn_1,                       --??????
        hotpoint = Qixi_HuaJuan_MF_UnfoldBtn_1_Tips,                --????????
        receive = Qixi_HuaJuan_MF1_Mission_1_recive,                --??????????????
        receiveMask = Qixi_HuaJuan_MF1_Mission_1_reciveMask,                --??????????????
        canreceive = Qixi_HuaJuan_MF1_Mission_1_RewardTips,         --??????????????
        gotoButton = Qixi_HuaJuan_MF1_Mission_1_GoBtn,              --???????????????
        receiveButton = Qixi_HuaJuan_MF1_Mission_1_LQBtn,           --??????????????
        havereceiveButton = Qixi_HuaJuan_MF1_Mission_1_Finsh        --???????????????
    }
    Qixi_HuaJuan_RewardState[2] = {
        LightIMG = "set:QXHJ image:QXHJ_PageBtn_2_N",
        button = Qixi_HuaJuan_MF_UnfoldBtn_2,
        lockButton = Qixi_HuaJuan_MF_UnfoldBtn_2_Lock,              --????????????
        hotpoint = Qixi_HuaJuan_MF_UnfoldBtn_2_Tips,
        receive = Qixi_HuaJuan_MF2_Mission_2_recive,
        receiveMask = Qixi_HuaJuan_MF2_Mission_2_reciveMask,                --??????????????
        canreceive = Qixi_HuaJuan_MF2_Mission_2_RewardTips,
        gotoButton = Qixi_HuaJuan_MF2_Mission_2_GoBtn,
        receiveButton = Qixi_HuaJuan_MF2_Mission_2_LQBtn,
        havereceiveButton = Qixi_HuaJuan_MF2_Mission_2_Finsh
    }
    Qixi_HuaJuan_RewardState[3] = {
        LightIMG = "set:QXHJ image:QXHJ_PageBtn_3_N",
        button = Qixi_HuaJuan_MF_UnfoldBtn_3,
        lockButton = Qixi_HuaJuan_MF_UnfoldBtn_3_Lock,
        hotpoint = Qixi_HuaJuan_MF_UnfoldBtn_3_Tips,
        receive = Qixi_HuaJuan_MF3_Mission_3_recive,
        receiveMask = Qixi_HuaJuan_MF3_Mission_3_reciveMask,                --??????????????
        canreceive = Qixi_HuaJuan_MF3_Mission_3_RewardTips,
        gotoButton = Qixi_HuaJuan_MF3_Mission_3_GoBtn,
        receiveButton = Qixi_HuaJuan_MF3_Mission_3_LQBtn,
        havereceiveButton = Qixi_HuaJuan_MF3_Mission_3_Finsh

    }
    Qixi_HuaJuan_RewardState[4] = {
        LightIMG = "set:QXHJ image:QXHJ_PageBtn_4_N",
        button = Qixi_HuaJuan_MF_UnfoldBtn_4,
        lockButton = Qixi_HuaJuan_MF_UnfoldBtn_4_Lock,
        hotpoint = Qixi_HuaJuan_MF_UnfoldBtn_4_Tips,
        receive = Qixi_HuaJuan_MF4_Mission_4_recive,
        receiveMask = Qixi_HuaJuan_MF4_Mission_4_reciveMask,                --??????????????
        canreceive = Qixi_HuaJuan_MF4_Mission_4_RewardTips,
        gotoButton = Qixi_HuaJuan_MF4_Mission_4_GoBtn,
        receiveButton = Qixi_HuaJuan_MF4_Mission_4_LQBtn,
        havereceiveButton = Qixi_HuaJuan_MF4_Mission_4_Finsh
    }
    Qixi_HuaJuan_RewardState[5] = {
        canreceive = Qixi_HuaJuan_MF4_Mission_4_Reward2Tips,
        receive = Qixi_HuaJuan_MF4_Mission_4_recive2,
        receiveMask = Qixi_HuaJuan_MF4_Mission_4_reciveMask2,                --??????????????
    }
    Qixi_HuaJuan_IMGUnLock[1] = Qixi_HuaJuan_Mission_1_Image
    Qixi_HuaJuan_IMGUnLock[2] = Qixi_HuaJuan_Mission_2_Image
    Qixi_HuaJuan_IMGUnLock[3] = Qixi_HuaJuan_Mission_3_Image
    Qixi_HuaJuan_IMGUnLock[4] = Qixi_HuaJuan_Mission_4_Image
end

function Qixi_HuaJuan_OnHidden()
    this:Hide()
end

function Qixi_HuaJuan_Close()
    Qixi_HuaJuan_OnHidden()
end

function Qixi_HuaJuan_ResetPos()
    Qixi_HuaJuan_Frame:SetProperty("UnifiedPosition", g_Qixi_HuaJuanFrame_UnifiedPosition)
end

function Qixi_HuaJuan_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
        -- «∑Ò «≥¨Ãÿ∑˛(”∞œÏΩ±¿¯œ‘ æ)
        -- 1»ŒŒÒΩ¯∂»
        -- 2µ±ÃÏ»†∆⁄
        g_IsOriginHj = Get_XParam_INT(0)
        g_bShowShopHotPoint = Get_XParam_INT(1)
        g_playerLevel = Get_XParam_INT(2)
        g_QuestState = Get_XParam_INT(3)
        g_IsGetQuest = Get_XParam_INT(4)
        local curDay = Get_XParam_INT(5)
        --story ±‰¡ø 0±Í ∂Œ¥ÕÍ≥… 1 ±Í ∂“—ÕÍ≥…Œ¥¡Ï»°£®¡¡∫Ïµ„≤ª¡¡π¥—°£© 2 ±Í ∂ÕÍ≥…“—¡Ï»°£®¡¡π¥—°≤ª¡¡∫Ïµ„£©
        local story1state = Get_XParam_INT(6)
        local story2state = Get_XParam_INT(7)
        local story3state = Get_XParam_INT(8)
        local story4state = Get_XParam_INT(9)
        g_rewardState = Get_XParam_INT(10)
        Qixi_HuaJuan_CurTime = curDay
        Qixi_HuaJuan_StoryStateList = { story1state, story2state, story3state, story4state }	
        --¥Úø™ΩÁ√Ê
        Qixi_HuaJuan_Open(g_QuestState, curDay, Qixi_HuaJuan_StoryStateList)
        this:Show()
        --end
    elseif (event == "UI_COMMAND" and tonumber(arg0) == g_FadeAnimateUICOMMAND) then
        local rewardIndex = Get_XParam_INT(0)
        local isReward1State = Get_XParam_INT(1)
        local isReward2State = Get_XParam_INT(2)
        local isReward3State = Get_XParam_INT(3)
        local isReward4State = Get_XParam_INT(4)
        local rewardState = Get_XParam_INT(5)
        g_rewardState = rewardState
        g_FadeAnimateParam = { rewardIndex, isReward1State, isReward2State, isReward3State, isReward4State }
        Qixi_HuaJuan_IMGUnLock[rewardIndex]:StartFade(0,1,2)
		KillTimer("Qixi_HuaJuan_ReawrdAnimateTimer()")
	    SetTimer("Qixi_HuaJuan","Qixi_HuaJuan_ReawrdAnimateTimer()", 2000)
    elseif (event == "UI_COMMAND" and tonumber(arg0) == g_AutoRunUICOMMAND) then
        local posx = Get_XParam_INT(0)
        local posy = Get_XParam_INT(1)
        local sceneId = Get_XParam_INT(2)
        local npcName = Get_XParam_STR(0)

        AutoRuntoTargetExWithName(posx, posy, sceneId, npcName)
    elseif (IsWindowShow("Qixi_HuaJuan")) == true then
        if (event == "UI_COMMAND" and tonumber(arg0) == g_UpdateUICOMMAND) then
            -- «∑Ò «≥¨Ãÿ∑˛(”∞œÏΩ±¿¯œ‘ æ)
            -- 1»ŒŒÒΩ¯∂»
            -- 2µ±ÃÏ»†∆⁄
            g_IsOriginHj = Get_XParam_INT(0)
            g_bShowShopHotPoint = Get_XParam_INT(1)
            g_playerLevel = Get_XParam_INT(2)
            g_QuestState = Get_XParam_INT(3)
            g_IsGetQuest = Get_XParam_INT(4)
            local curDay = Get_XParam_INT(5)
            --story ±‰¡ø 0±Í ∂Œ¥ÕÍ≥… 1 ±Í ∂“—ÕÍ≥…Œ¥¡Ï»°£®¡¡∫Ïµ„≤ª¡¡π¥—°£© 2 ±Í ∂ÕÍ≥…“—¡Ï»°£®¡¡π¥—°≤ª¡¡∫Ïµ„£©
            local story1state = Get_XParam_INT(6)
            local story2state = Get_XParam_INT(7)
            local story3state = Get_XParam_INT(8)
            local story4state = Get_XParam_INT(9)
            g_rewardState = Get_XParam_INT(10)
            Qixi_HuaJuan_CurTime = curDay
            Qixi_HuaJuan_StoryStateList = { story1state, story2state, story3state, story4state }	
            --¥Úø™ΩÁ√Ê
            Qixi_HuaJuan_Open(g_QuestState, curDay, Qixi_HuaJuan_StoryStateList)
        end
    end

    if this:IsVisible() then
        if event == "ADJEST_UI_POS" or
            event == "VIEW_RESOLUTION_CHANGED" then
            Qixi_HuaJuan_ResetPos()
        elseif event == "HIDE_ON_SCENE_TRANSED" then
            Qixi_HuaJuan_OnHidden()
        end
    end
end

function Qixi_HuaJuan_Open(questState, curDay, storyStateList)
    if questState < 0 then
    end
    if questState == 0 or (questState == 1 and g_IsGetQuest ~= 1) then
        --√ª”–◊ˆπ˝»ŒŒÒ£¨œ‘ æUI1
        Qixi_HuaJuan_SwitchUI(0)
    elseif questState > 1 or (questState == 1 and g_IsGetQuest == 1) then
        Qixi_HuaJuan_SwitchUI(1)
        -- Qixi_HuaJuan_OpenFold(1)
        --∫Ïµ„º∞π¥—°œ‘ æ£¨∞…ª≠æÌ…œµƒÕº∆¨“≤“ª∆Ω‚À¯¡À
        Qixi_HuaJuan_ShowHotPoint(storyStateList)
    end
    this:Show()
end

function Qixi_HuaJuan_SwitchUI(Index)
    if Index == 0 then
        Qixi_HuaJuan_ClientList[1]:Show()
        Qixi_HuaJuan_Story_GoBtn:Show()
        Qixi_HuaJuan_ClientList[2]:Hide()
    else
        Qixi_HuaJuan_ClientList[1]:Hide()
        Qixi_HuaJuan_Story_GoBtn:Hide()
        Qixi_HuaJuan_ClientList[2]:Show()
        Qixi_HuaJuan_ShowUIHuaJuan()
        --¥Úø™ΩÁ√Ê ±◊‘∂ØÃ¯µΩ“—Ω‚À¯µƒ◊Ó–¬“ª“≥
        if Qixi_HuaJuan_CurTime < Qixi_HuaJuan_UnlockTime[math.min(g_rewardState+1, 4)] then 
            Qixi_HuaJuan_Mission_Unfold(g_rewardState)
        else
            Qixi_HuaJuan_Mission_Unfold(math.min(g_rewardState+1, 4))
        end
    end
end

function Qixi_HuaJuan_OpenFold(index)
    Qixi_HuaJuan_MF_Lock:Hide()

    for i = 1, Qixi_HuaJuan_FoldNum, 1 do
        if i == index then
            Qixi_HuaJuan_FoldList[i]:Show()
        else
            Qixi_HuaJuan_FoldList[i]:Hide()
        end
    end
    if Qixi_HuaJuan_CurTime < Qixi_HuaJuan_UnlockTime[index] then 
        --œ‘ æ‘›Œ¥ø™∆Ù“≥√Ê
        Qixi_HuaJuan_FoldList[index]:Hide()
        Qixi_HuaJuan_MF_Lock:Show()
        PushDebugMessage("#{QNHJ_250609_32}")
        -- Qixi_HuaJuan_RewardState[index].button:SetProperty("Selected", "False");
        return 0
    end
    if index > 1 and Qixi_HuaJuan_StoryStateList[index-1] < 1 then
        --œ‘ æ‘›Œ¥ø™∆Ù“≥√Ê
        Qixi_HuaJuan_FoldList[index]:Hide()
        Qixi_HuaJuan_MF_Lock:Show()
        PushDebugMessage("#{QNHJ_250609_94}")
        return 0
    end
    if index > g_rewardState + 1 then
        --œ‘ æ‘›Œ¥ø™∆Ù“≥√Ê
        Qixi_HuaJuan_FoldList[index]:Hide()
        Qixi_HuaJuan_MF_Lock:Show()
        PushDebugMessage("#{QNHJ_250609_96}")
        return 0
    end
    
end

function Qixi_HuaJuan_ShowUIHuaJuan()
    --†π æŒÔ∆∑
    for i = 1, Qixi_HuaJuan_rewardNum, 1 do
        local theAction = DataPool:CreateBindActionItemForShow(Qixi_HuaJuan_Item[i].Itemid, Qixi_HuaJuan_Item[i].num)
        if theAction:GetID() ~= 0 then
            Qixi_HuaJuan_ItemShow[i]:SetActionItem(theAction:GetID())
            Qixi_HuaJuan_ItemShow[i]:Show()
        end
        --÷ÿ÷√∞¥≈•—°÷–◊¥Ã¨
    end
end

function Qixi_HuaJuan_ShowHotPoint(storyStateList)
    Qixi_HuaJuan_ShopButton_Tips:Hide()

    if g_playerLevel < g_playerLevelLimit then
        Qixi_HuaJuan_ShopButton:Hide()
    end
    if Qixi_HuaJuan_CurTime  < Qixi_HuaJuan_ShopOpenTime then
        Qixi_HuaJuan_ShopButton:SetToolTip("#{DHSD_20240522_1}")
    elseif  Qixi_HuaJuan_CurTime  > Qixi_HuaJuan_ShopCloseTime  then
        Qixi_HuaJuan_ShopButton:SetToolTip("#{DHSD_20240522_3}")
    end
    --œ»◊ˆÀ˘”–øÿº˛“˛≤ÿµƒ≥ı ºªØ
    for i = 1,Qixi_HuaJuan_FoldNum,1 do
        for point =1,Qixi_HuaJuan_FoldNum-1,1 do
            Qixi_HuaJuan_RewardState[i].hotpoint:Hide()
        end
        Qixi_HuaJuan_RewardState[math.max(2,i)].lockButton:Show()
        Qixi_HuaJuan_RewardState[i].receive:Hide()
        Qixi_HuaJuan_RewardState[i].receiveMask:Hide()
        Qixi_HuaJuan_RewardState[i].canreceive:Hide()
        Qixi_HuaJuan_RewardState[i].gotoButton:Hide()
        Qixi_HuaJuan_RewardState[i].receiveButton:Hide()
        Qixi_HuaJuan_RewardState[i].havereceiveButton:Hide()
        Qixi_HuaJuan_IMGUnLock[i]:StartFade(1,0,0)
        
        if g_QuestState >= 2 then
            Qixi_HuaJuan_RewardState[i].gotoButton:SetToolTip("")
        end
    end
    Qixi_HuaJuan_RewardState[5].canreceive:Hide()
    Qixi_HuaJuan_RewardState[5].receive:Hide()
    Qixi_HuaJuan_RewardState[5].receiveMask:Hide()
    if g_bShowShopHotPoint == 1 then
        Qixi_HuaJuan_ShopButton_Tips:Show()
    end
    -- ∂‘“—Ω‚À¯µƒ∑÷“≥Ω¯––Ω‚À¯≤Ÿ◊˜£®“˛≤ÿÀ¯∂®∞¥≈•£©
    if g_rewardState >= 1 then
        for i = 1 ,math.min(g_rewardState,3),1 do
            if Qixi_HuaJuan_CurTime >= Qixi_HuaJuan_UnlockTime[i+1] then
                Qixi_HuaJuan_RewardState[i + 1].lockButton:Hide()
            end
        end
    end 
    --∂‘–Ë“™œ‘ æµƒøÿº˛◊ˆ¥¶¿Ì
    for i = 1,Qixi_HuaJuan_FoldNum,1 do
        if storyStateList[i] == 0 then 
            Qixi_HuaJuan_RewardState[i].gotoButton:Show()
        elseif storyStateList[i] == 1 then
            for point =1,Qixi_HuaJuan_FoldNum-1,1 do
                Qixi_HuaJuan_RewardState[i].hotpoint:Show()
            end
            if i == 4 then
                Qixi_HuaJuan_RewardState[5].canreceive:Show()
            end
            Qixi_HuaJuan_RewardState[i].canreceive:Show()
            Qixi_HuaJuan_RewardState[i].receiveButton:Show()
            Qixi_HuaJuan_RewardState[i].button:SetProperty("NormalImage", Qixi_HuaJuan_RewardState[i].LightIMG);


        elseif storyStateList[i] == 2 then
            Qixi_HuaJuan_RewardState[i].havereceiveButton:Show()
            Qixi_HuaJuan_RewardState[i].receive:Show()
            Qixi_HuaJuan_RewardState[i].receiveMask:Show()
			Qixi_HuaJuan_RewardState[i].button:SetProperty("NormalImage", Qixi_HuaJuan_RewardState[i].LightIMG);
            Qixi_HuaJuan_IMGUnLock[i]:StartFade(1,1,0)
            if i == 4 then
                Qixi_HuaJuan_RewardState[5].receive:Show()
                Qixi_HuaJuan_RewardState[5].receiveMask:Show()
            end
        end
    end
end

function Qixi_HuaJuan_Mission_Unfold(index)
    -- if Qixi_HuaJuan_CurTime < Qixi_HuaJuan_UnlockTime[index] then 
    --     PushDebugMessage("#{QNHJ_250609_32}")
    --     -- Qixi_HuaJuan_RewardState[index].button:SetProperty("Selected", "False");
    --     -- return 0
    -- end
    Qixi_HuaJuan_RewardState[index].button:SetProperty("Selected", "True");

    Qixi_HuaJuan_OpenFold(index)
end

function Qixi_HuaJuan_OnRewardClick(index)
    Qixi_HuaJuan_Award(index)
end

--“—¡Ï»°Ω±¿¯
function Qixi_HuaJuan_LinQuPrize(reward1MF, reward2MF, reward3MF)
    if reward1MF == 1 then
        --Ω±¿¯OK
        Qixi_HuaJuan_Award_OK[1]:Show()
    else
        Qixi_HuaJuan_Award_OK[1]:Hide()
    end
    if reward2MF == 1 then
        --Ω±¿¯OK
        Qixi_HuaJuan_Award_OK[2]:Show()
    else
        Qixi_HuaJuan_Award_OK[2]:Hide()
    end
    if reward3MF == 1 then
        --Ω±¿¯OK
        Qixi_HuaJuan_Award_OK[3]:Show()
    else
        Qixi_HuaJuan_Award_OK[3]:Hide()
    end
end
function Qixi_HuaJuan_ReawrdAnimateTimer()
    -- g_FadeAnimateParam = { rewardIndex, isReward1State, isReward2State, isReward3State, isReward4State }
    local rewardIndex = g_FadeAnimateParam[1]
    local isRewardList = {g_FadeAnimateParam[2],g_FadeAnimateParam[3],g_FadeAnimateParam[4],g_FadeAnimateParam[5] }
    Qixi_HuaJuan_Mission_Unfold(rewardIndex)
    Qixi_HuaJuan_ShowHotPoint(isRewardList)
	KillTimer("Qixi_HuaJuan_ReawrdAnimateTimer()")
end
function Qixi_HuaJuan_Help_Clicked()
    local tipStr

    if g_IsOriginHj == 1 then
        tipStr = "#{QNHJ_250609_73}"
    else
        tipStr = "#{QNHJ_250609_72}"
    end
    PushEvent("QUEST_HELPINFO",tipStr)
end
--µ„ª˜ΩÁ√Ê∞¥≈•£¨¡Ï»°»ŒŒÒ≤¢◊‘∂Ø«∞Õ˘
function Qixi_HuaJuan_Story_Goto()
    --◊‘∂Ø«∞Õ˘
    if g_QuestState == 0 then
        -- AutoRuntoTargetExWithName(Qixi_HuaJuan_NPCInfo.posx, Qixi_HuaJuan_NPCInfo.posy, Qixi_HuaJuan_NPCInfo.sceneId, Qixi_HuaJuan_NPCInfo.npcName)
            --Ω”»ŒŒÒ
        Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(999815)
        Set_XSCRIPT_Function_Name("OnAcceptQuest1")
        Set_XSCRIPT_ParamCount(0)
        Send_XSCRIPT()
    elseif g_QuestState == 1 and g_IsGetQuest == 0 then
        Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(999815)
        Set_XSCRIPT_Function_Name("AutoRunToNpc")
        Set_XSCRIPT_Parameter(0, 1)
        Set_XSCRIPT_ParamCount(1)
        Send_XSCRIPT()
    end
    Qixi_HuaJuan_OnHidden()
end

--∑÷“≥÷–◊‘∂Ø«∞Õ˘∞¥≈•
function Qixi_HuaJuan_Goto(index)
    if Qixi_HuaJuan_CurTime < Qixi_HuaJuan_UnlockTime[index] then 
        return 0
    end
    PushDebugMessage(Qixi_HuaJuan_GoToMsg[index])

    Clear_XSCRIPT()
    Set_XSCRIPT_ScriptID(999815)
    Set_XSCRIPT_Function_Name("AutoRunToNpc")
    Set_XSCRIPT_Parameter(0, index)
    Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
    Qixi_HuaJuan_OnHidden()
end

--1-3 ¡ÏΩ±
function Qixi_HuaJuan_RewardClicked(rewardIndex)
    --1-3 ¡ÏΩ±
    Clear_XSCRIPT()
    Set_XSCRIPT_ScriptID(999815)
    Set_XSCRIPT_Function_Name("GetAccumulateReward")
    Set_XSCRIPT_Parameter(0, rewardIndex)
    Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
end
function Qixi_HuaJuan_LQbtn_OnClicked(rewardIndex)
    Qixi_HuaJuan_RewardClicked(rewardIndex)
end
function Qixi_HuaJuan_ShopButton_Clicked()
    if g_playerLevel < g_playerLevelLimit then
        PushDebugMessage("#{QNHJ_250609_28}")
        return 0
    end

    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OnClientAskData")
    Set_XSCRIPT_ScriptID(999236)
    Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()

    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("UpdateHotPointStateFromUI")
    Set_XSCRIPT_ScriptID(999815)
    Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()

    Qixi_HuaJuan_OnHidden()
    
end
