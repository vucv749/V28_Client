-- ShenBing_Yure 神兵预热 2023-7-12 lishilong
-- !!!reloadscript =ShenBing_Yure
--

local g_ShenBing_Yure_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 		= 3.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredItem 			= 0
local bCaredObj 			= 0
local bCaredMoney 			= 0
local bCaredYuanBao			= 0
local g_nComfirmParam1		= 0

local g_nUICommandID		= 79110001

local g_tStrMissionName		= {"#{SBYR_230707_39}", "#{SBYR_230707_40}", "#{SBYR_230707_41}", "#{SBYR_230707_42}",}
local g_tStrMissionTips		= {"#{SBYR_230707_43}", "#{SBYR_230707_44}", "#{SBYR_230707_45}", "#{SBYR_230707_46}",}
local g_tStrMissionFinish	= {"#{SBYR_230707_48}", "#{SBYR_230707_50}", "#{SBYR_230707_217}", "#{SBYR_230707_52}",}
local g_tStrMissionToDo		= {"#{SBYR_230707_47}", "#{SBYR_230707_49}", "#{SBYR_230707_216}", "#{SBYR_230707_51}",}

local g_tTaskName			= 
{
	"set:ShenBing_YuRe image:ShenBing_Yure_P1",
	"set:ShenBing_YuRe image:ShenBing_Yure_P2",
	"set:ShenBing_YuRe image:ShenBing_Yure_P3",
	"set:ShenBing_YuRe image:ShenBing_Yure_P4",
}

local g_tTaskPart			= 
{
	"set:ShenBing_YuRe image:ShenBing_Yure_Part1",
	"set:ShenBing_YuRe image:ShenBing_Yure_Part2",
	"set:ShenBing_YuRe image:ShenBing_Yure_Part3",
	"set:ShenBing_YuRe image:ShenBing_Yure_Part4",
}

local g_tabRewardInfo		= 
{
	[1] = {nNeedPoint = 1, nItemID = 20600002, nItemNum = 1, },
	[2] = {nNeedPoint = 2, nItemID = 38002519, nItemNum = 1, },
	[3] = {nNeedPoint = 3, nItemID = 20501003, nItemNum = 1, },
	[4] = {nNeedPoint = 4, nItemID = 20502003, nItemNum = 1, },
}

local g_cRewardActionButton = {}
local g_cRewardAnimate 		= {}
local g_cRewardGeted 		= {}

-- 初始化变量
local g_nHuodongStep		= 0
local g_nFinishMissionNum	= 0
local g_bIsMissionDone		= {0, 0, 0, 0}
local g_bIsRewardGeted		= {1, 1, 1, 1}

--=========================================================
-- PreLoad
--=========================================================
function ShenBing_Yure_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	if 1 == bCaredItem then
		this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	end
	if 1 == bCaredMoney then
		this:RegisterEvent("UNIT_MONEY")
		this:RegisterEvent("MONEYJZ_CHANGE")
	end
	if 1 == bCaredYuanBao then
		this:RegisterEvent("UPDATE_YUANBAO")
	end
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function ShenBing_Yure_OnLoad()
	g_ShenBing_Yure_Frame_UnifiedPosition = ShenBing_Yure_Frame:GetProperty("UnifiedPosition")

	-- ShenBing_Yure_OK_Button : SetEvent("Clicked", "ShenBing_Yure_ConfirmClick()")

	g_cRewardActionButton[1] 	= ShenBing_Yure_Gift1_Icon
	g_cRewardActionButton[2] 	= ShenBing_Yure_Gift2_Icon
	g_cRewardActionButton[3] 	= ShenBing_Yure_Gift3_Icon
	g_cRewardActionButton[4] 	= ShenBing_Yure_Gift4_Icon

	g_cRewardAnimate[1] 		= ShenBing_Yure_Gift1_Icon_Animate
	g_cRewardAnimate[2] 		= ShenBing_Yure_Gift2_Icon_Animate
	g_cRewardAnimate[3] 		= ShenBing_Yure_Gift3_Icon_Animate
	g_cRewardAnimate[4] 		= ShenBing_Yure_Gift4_Icon_Animate

	g_cRewardGeted[1] 			= ShenBing_Yure_Gift1_Icon_Get
	g_cRewardGeted[2] 			= ShenBing_Yure_Gift2_Icon_Get
	g_cRewardGeted[3] 			= ShenBing_Yure_Gift3_Icon_Get
	g_cRewardGeted[4] 			= ShenBing_Yure_Gift4_Icon_Get
	
end

--=========================================================
-- OnEvent
--=========================================================
function ShenBing_Yure_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
		-- 0 关睜, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

		-- 关睜界面
		if 0 == nOpType then	
			if this:IsVisible() then
				ShenBing_Yure_OnClose()
			end
		end

		-- 打开界面
		if 1 == nOpType then
			-- 关注npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						ShenBing_Yure_OnClose()
					end
				end
				g_nServerObjID = nServerObjID
				g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
				BeginCareObject_ShenBing_Yure()
			end

			-- 显示界面
			-- 为了解决界面被犣挡的问题，先把界面关了
			-- if this:IsVisible() then
			-- 	ShenBing_Yure_OnClose()
			-- end
			ShenBing_Yure_Reset()
			ShenBing_Yure_Frame_On_ResetPos()
			this:Show()
			ShenBing_Yure_ParamInit()
			ShenBing_Yure_MoneyUpdate()
			ShenBing_Yure_YuanBaoUpdate()
			ShenBing_Yure_Update(1)
		end
			
		-- 刷新界面
		if 2 == nOpType then
			-- 关注npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						ShenBing_Yure_OnClose()
					end
				end
			end
			if this:IsVisible() then
				ShenBing_Yure_ParamInit()
				ShenBing_Yure_Update(0)
			end
		end

		-- 二次确认框
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			MessageBoxSelf3("ShenBing_Yure_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end

	-- ============================================
	-- 通用逻辑
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关睜界面
			ShenBing_Yure_OnClose()
		end	

	-- 物品改变
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- 刷新界面
		if this:IsVisible() then
			ShenBing_Yure_Update(0)
		end

	-- 金钱改变
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		ShenBing_Yure_MoneyUpdate()

	-- 元宝改变
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		ShenBing_Yure_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		ShenBing_Yure_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		ShenBing_Yure_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenBing_Yure_Frame_On_ResetPos()
	end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function ShenBing_Yure_ParamInit()
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
function ShenBing_Yure_OnComfirmedBack(strRet)
	if nil == strRet then
		return
	end

	if "Yes" == strRet or "Ok" == strRet then

	end

	if "No" == strRet then
		
	end
end

--=========================================================
-- 界面更新
--=========================================================
-- !!!reloadscript =ShenBing_Yure
function ShenBing_Yure_Update(bOpen)

	if nil == g_nHuodongStep or g_nHuodongStep <= 0 then
		return
	end

	local strMissionName = g_tStrMissionName[g_nHuodongStep]
	local strCurTaskPart = g_tTaskPart[g_nHuodongStep]
	local strCurTaskName = g_tTaskName[g_nHuodongStep]

	-- 当前任务名字
	-- if nil ~= strMissionName then
	-- 	ShenBing_Yure_TaskInfo : SetText( ScriptGlobal_Format("#{SBYR_230707_38}", strMissionName) )
	-- end

	if nil ~= strCurTaskPart then
		ShenBing_Yure_TaskPart : SetProperty("Image", tostring(strCurTaskPart))
	end

	if nil ~= strCurTaskName then
		ShenBing_Yure_TaskName : SetProperty("Image", tostring(strCurTaskName))
	end

	local strMissionTips = g_tStrMissionTips[g_nHuodongStep]

	-- 任务详情
	if nil ~= strMissionTips then
		ShenBing_Yure_TaskInfo2 : SetText( strMissionTips )
	end

	-- 任务完成提示
	local nCurMissionFinish = g_bIsMissionDone[g_nHuodongStep]
	local strInfo3 = ""
	if nil ~= nCurMissionFinish then
		if 1 == nCurMissionFinish then
			strInfo3 = g_tStrMissionFinish[g_nHuodongStep]
			ShenBing_Yure_TaskOver : Show()
		else
			strInfo3 = g_tStrMissionToDo[g_nHuodongStep]
			ShenBing_Yure_TaskOver : Hide()
		end
	end

	if nil ~= strInfo3 then
		ShenBing_Yure_TaskInfo3 : SetText( strInfo3 )
	end

	-- 奖励区
	for i = 1, table.getn(g_tabRewardInfo) do

		local tReward = g_tabRewardInfo[i]
		if nil == tReward then
			return
		end

		-- local theAction = DataPool:CreateActionItemForShow(tReward.nItemID, tReward.nItemNum)
		local theAction = DataPool:CreateBindActionItemForShow(tReward.nItemID, tReward.nItemNum)
		g_cRewardActionButton[i] : SetActionItem(theAction:GetID())

		local bGetedReward = g_bIsRewardGeted[i]
		g_cRewardAnimate[i] : Hide()
		g_cRewardGeted[i] : Hide()

		-- PushDebugMessage("g_nFinishMissionNum:"..g_nFinishMissionNum)

		if 1 == bGetedReward then
			g_cRewardGeted[i] : Show()
		elseif g_nFinishMissionNum >= i then
			g_cRewardAnimate[i] : Show()
		end
	end

	-- 拥有点数
	-- ShenBing_Yure_Now : Hide()
	ShenBing_Yure_Now : SetText( ScriptGlobal_Format("#{SBYR_230707_267}", g_nFinishMissionNum) )
	
end

--=========================================================
-- 重置界面
--=========================================================
function ShenBing_Yure_Reset()

end

--=========================================================
-- 帮助
--=========================================================
function ShenBing_Yure_Help()
	-- 1、领取奖励 2、自动寻路 3、帮助 4、请求打开主界面
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(791100)
		Set_XSCRIPT_Parameter(0, 3)					
		Set_XSCRIPT_Parameter(1, 1)				
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- 界面确认按钮
--=========================================================
function ShenBing_Yure_PrizeClicked(nIndex)
	-- 1、领取奖励 2、自动寻路 3、帮助 4、请求打开主界面
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(791100)
		Set_XSCRIPT_Parameter(0, 1)					
		Set_XSCRIPT_Parameter(1, nIndex)				
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- 关睜界面
--=========================================================
function ShenBing_Yure_OnClose()	
	this:Hide()
	StopCareObject_ShenBing_Yure()
	-- 重置
	ShenBing_Yure_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="ShenBing_Yure_OnHidden();" />
--=========================================================
function ShenBing_Yure_OnHidden()
	StopCareObject_ShenBing_Yure()
	-- 重置
	ShenBing_Yure_Reset()
end

--=========================================================
-- 关心操作
--=========================================================
function BeginCareObject_ShenBing_Yure()
	-- 关心
	this:CareObject(g_nObjCaredIDClient, 1, "ShenBing_Yure")
end

function StopCareObject_ShenBing_Yure()
	-- 取消关心
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "ShenBing_Yure")
	end
	g_nServerObjID = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function ShenBing_Yure_MoneyUpdate()
	-- ShenBing_Yure_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- ShenBing_Yure_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 元宝刷新：界面更新调用一次 元宝事件调用一次
--=========================================================
function ShenBing_Yure_YuanBaoUpdate()
	-- ShenBing_Yure_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- 界面位置
--=========================================================
function ShenBing_Yure_Frame_On_ResetPos()
	ShenBing_Yure_Frame:SetProperty("UnifiedPosition", g_ShenBing_Yure_Frame_UnifiedPosition)
end
