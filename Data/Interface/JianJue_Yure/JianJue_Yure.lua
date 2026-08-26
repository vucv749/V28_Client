-- 【2024Q2】新版本预热-山重水复
local g_JianJue_Yure_Frame_UnifiedPosition

local g_nUICommandID		    = 99877201

local g_tabRewardInfo		= 
{
	[1] = {nNeedPoint = 1, nItemID = 20310168, nItemNum = 5, },
	[2] = {nNeedPoint = 2, nItemID = 20600002, nItemNum = 1, },
	[3] = {nNeedPoint = 3, nItemID = 30900045, nItemNum = 1, },
	[4] = {nNeedPoint = 4, nItemID = 38002519, nItemNum = 1, },
}

local g_cRewardActionButton     = {}
local g_cRewardAnimate          = {}
local g_cRewardGeted            = {}

-- 点击页签编号
local g_nClickTabIndex          = 1
local g_tClickTabs              = {}

local g_tTaskLockTips           =
{
    "","#{JJFY_240407_28}","#{JJFY_240407_29}","#{JJFY_240407_30}"
}

local g_TaskNames			    = 
{
	"set:JianJue_Yure image:JianJue_Yure_P1",
	"set:JianJue_Yure image:JianJue_Yure_P2",
	"set:JianJue_Yure image:JianJue_Yure_P3",
	"set:JianJue_Yure image:JianJue_Yure_P4",
}
local g_TaskInfos              =
{
    "#{JJFY_240407_35}", "#{JJFY_240407_36}", "#{JJFY_240407_37}", "#{JJFY_240407_38}"
}
local g_TaskUnlockTips         =
{
    "#{JJFY_240407_31}", "#{JJFY_240407_32}", "#{JJFY_240407_33}", "#{JJFY_240407_34}"
}
-- 初始化变量
local g_nHuodongStep            = 0
local g_nFinishMissionNum       = 0
local g_bIsMissionDone          = {0,0,0,0}
local g_bIsRewardGeted          = {1,1,1,1}

--=========================================================
-- PreLoad
--=========================================================
function JianJue_Yure_PreLoad()
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("OBJECT_CARED_EVENT")
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
    this:RegisterEvent("ADJEST_UI_POS")
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function JianJue_Yure_OnLoad()
    g_JianJue_Yure_Frame_UnifiedPosition = JianJue_Yure_Frame:GetProperty("UnifiedPosition")
    g_cRewardActionButton[1] = JianJue_Yure_Gift1_Icon
    g_cRewardActionButton[2] = JianJue_Yure_Gift2_Icon
    g_cRewardActionButton[3] = JianJue_Yure_Gift3_Icon
    g_cRewardActionButton[4] = JianJue_Yure_Gift4_Icon

    g_cRewardAnimate[1] = JianJue_Yure_Gift1_Icon_Animate
    g_cRewardAnimate[2] = JianJue_Yure_Gift2_Icon_Animate
    g_cRewardAnimate[3] = JianJue_Yure_Gift3_Icon_Animate
    g_cRewardAnimate[4] = JianJue_Yure_Gift4_Icon_Animate

    g_cRewardGeted[1] = JianJue_Yure_Gift1_Icon_Get
    g_cRewardGeted[2] = JianJue_Yure_Gift2_Icon_Get
    g_cRewardGeted[3] = JianJue_Yure_Gift3_Icon_Get
    g_cRewardGeted[4] = JianJue_Yure_Gift4_Icon_Get

    g_tClickTabs[1] = JianJue_Yure_CheckButton1
    g_tClickTabs[2] = JianJue_Yure_CheckButton2
    g_tClickTabs[3] = JianJue_Yure_CheckButton3
    g_tClickTabs[4] = JianJue_Yure_CheckButton4

end

--=========================================================
-- OnEvent
--=========================================================
function JianJue_Yure_OnEvent(event)
    if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
        -- 0 关闭, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

        -- 关闭界面
		if 0 == nOpType then	
			if this:IsVisible() then
				JianJue_Yure_OnClose()
			end
		end

        -- 打开界面
		if 1 == nOpType then
            JianJue_Yure_Reset()
			JianJue_Yure_Frame_On_ResetPos()
			this:Show()
			JianJue_Yure_ParamInit()
			JianJue_Yure_Update(1)
        end

        -- 刷新界面
        if 2 == nOpType then
            if this:IsVisible() then
				JianJue_Yure_ParamInit()
				JianJue_Yure_Update(2)
			end
        end

        -- 二次确认框
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			MessageBoxSelf3("JianJue_Yure_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		JianJue_Yure_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		JianJue_Yure_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		JianJue_Yure_Frame_On_ResetPos()
	end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function JianJue_Yure_ParamInit()
	g_nHuodongStep		= Get_XParam_INT(1)
	g_nFinishMissionNum = 0
	for i = 1, table.getn(g_bIsMissionDone) do
		g_bIsMissionDone[i] = Get_XParam_INT(1 + i)
		if 1 == g_bIsMissionDone[i] then
			g_nFinishMissionNum = g_nFinishMissionNum + 1
		end		
	end
	for i = 1, table.getn(g_bIsRewardGeted) do
		g_bIsRewardGeted[i] = Get_XParam_INT(5 + i)
	end
end

--=========================================================
-- 二次确认框回调 ["Type"] "Ok"的返回值有"Ok"； ["Type"] "YesNo"的返回值有 "Yes" "No"
--=========================================================
function JianJue_Yure_OnComfirmedBack(strRet)
	if nil == strRet then
		return
	end

	if "Yes" == strRet or "Ok" == strRet then

	end

	if "No" == strRet then
		
	end
end

--=========================================================
-- 切换页面
--=========================================================
function JianJue_Yure_CheckButton_ButtonDown(nClickTab)
    if nClickTab == nil then
        return 
    end
    if nClickTab < 1 or nClickTab > table.getn(g_tClickTabs) then
        return
    end

    g_nClickTabIndex = nClickTab
    JianJue_Yure_Update(2)
end

--=========================================================
-- 界面更新
-- bOpen 1 打开 2 刷新界面
--=========================================================
function JianJue_Yure_Update(bOpen)
    if nil == g_nHuodongStep or g_nHuodongStep <= 0 then
		return
	end

    -- 更新页签
    if bOpen == 1 then
        g_nClickTabIndex = g_nHuodongStep
    end
    for i = 1, table.getn(g_tClickTabs) do
        if i ~= g_nClickTabIndex then
            g_tClickTabs[i]:SetCheck(0)
        else
            g_tClickTabs[i]:SetCheck(1)
        end
    end

    -- 更新内容
    if g_nClickTabIndex > g_nHuodongStep then
        -- 未解锁
        JianJue_Yure_Lock:Show()
        JianJue_Yure_Unlock:Hide()

        JianJue_Yure_Lock_Tips:SetText(g_tTaskLockTips[g_nClickTabIndex])
    else
        -- 已解锁
        JianJue_Yure_Lock:Hide()
        JianJue_Yure_Unlock:Show()

        JianJue_Yure_Unlock_TaskName:SetProperty("Image", g_TaskNames[g_nClickTabIndex])
        JianJue_Yure_Unlock_TaskInfo:SetText(g_TaskInfos[g_nClickTabIndex])
        JianJue_Yure_Unlock_Tips:SetText(g_TaskUnlockTips[g_nClickTabIndex])

        if g_bIsMissionDone[g_nClickTabIndex] == 1 then
            JianJue_Yure_Unlock_TaskOver:Show()
        else
            JianJue_Yure_Unlock_TaskOver:Hide()
        end
    end

    -- 奖励区
	for i = 1, table.getn(g_tabRewardInfo) do
		local tReward = g_tabRewardInfo[i]
		if nil == tReward then
			return
		end

		local theAction = DataPool:CreateBindActionItemForShow(tReward.nItemID, tReward.nItemNum)
		g_cRewardActionButton[i] : SetActionItem(theAction:GetID())

		local bGetedReward = g_bIsRewardGeted[i]
		g_cRewardAnimate[i] : Hide()
		g_cRewardGeted[i] : Hide()

		if 1 == bGetedReward then
			g_cRewardGeted[i] : Show()
		elseif g_nFinishMissionNum >= i then
			g_cRewardAnimate[i] : Show()
		end
	end

	-- 拥有点数
	JianJue_Yure_Now : SetText( ScriptGlobal_Format("#{JJFY_240407_46}", g_nFinishMissionNum) )
end

--=========================================================
-- 重置界面
--=========================================================
function JianJue_Yure_Reset()

end

--=========================================================
-- 帮助
--=========================================================
function JianJue_Yure_Help()
	-- 1、领取奖励 2、自动寻路 3、帮助 4、请求打开主界面
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(998772)
		Set_XSCRIPT_Parameter(0, 3)					
		Set_XSCRIPT_Parameter(1, 0)				
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- 界面确认按钮
--=========================================================
function JianJue_Yure_PrizeClicked(nIndex)
	-- 1、领取奖励 2、自动寻路 3、帮助 4、请求打开主界面
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(998772)
		Set_XSCRIPT_Parameter(0, 1)					
		Set_XSCRIPT_Parameter(1, nIndex)				
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- 关闭界面
--=========================================================
function JianJue_Yure_OnClose()
    this:Hide()
	-- 重置
	JianJue_Yure_Reset()
end

--=========================================================
-- 界面隐藏
--=========================================================
function JianJue_Yure_OnHidden()
	-- 重置
	JianJue_Yure_Reset()
end

--=========================================================
-- 界面位置
--=========================================================
function JianJue_Yure_Frame_On_ResetPos()
	JianJue_Yure_Frame:SetProperty("UnifiedPosition", g_JianJue_Yure_Frame_UnifiedPosition)
end