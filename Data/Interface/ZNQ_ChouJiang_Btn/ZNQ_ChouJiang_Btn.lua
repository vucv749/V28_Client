-- ZNQ_ChouJiang_Btn 周年庆稳在线 小地图界面 2022-7-4 lishilong
-- !!!reloadscript =ZNQ_ChouJiang_Btn
--

local g_ZNQ_ChouJiang_Btn_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 		= 3.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredItem 			= 0
local bCaredObj 			= 0
local bCaredMoney 			= 0
local bCaredYuanBao			= 0
local g_nComfirmParam1		= 0

-- 抽奖波次
local g_nMaxRewardWave		= 3
-- 奖励等级
local g_nMaxRewardLevel		= 3

local g_nCurPageIndex		= 1

local g_nHuoDongDayStep		= 0
local g_nStartFlag			= 0
local g_nGetedFlag			= 0
local g_nDownTick			= 0
local g_nServerHourToSecond	= 0
local g_tJoinRewardInfo		= {0, 0, 0}
local g_tHaveRewardInfo		= {0, 0, 0}
local g_tGetedRewardInfo	= {0, 0, 0}
-- 按10进制位存 低位开始 1 领券红点; 2-4 参与红点; 5-7 领奖红点 
local g_tHotPointInfo		= {0, 0, 0, 0, 0, 0, 0}

local g_nLastSyncServerTime	= 0

-- 定时器 单位ms
local g_nTimerTickTime		= 1 * 1000

-- 自动刷新
local g_nAutoRefreshStep	= 0
local g_nLastRefreshTime	= 0
-- local g_tabAutoRefreshInfo	= 
-- {
-- 	[1] = 180000,
-- 	[2] = 210000,
-- 	[3] = 210900,
-- 	[4] = 211006,
-- 	[5] = 211900,
-- 	[6] = 212006,
-- 	[7] = 212900,
-- 	[8] = 213006,
-- }

-- 自动刷新的时间 单位s
local g_nAutoRefreshTime 	= 60

-- 在线Tick倒计时时间段 [g_nDownTickStart, g_nDownTickEnd)
local g_nDownTickStart		= 180000
local g_nDownTickEnd		= 210000

-- 抽奖时时间段 [g_nRewardTimeStart, g_nRewardTimeEnd]
local g_nRewardTimeStart	= 210000
local g_nRewardTimeEnd		= 223000

local g_tabRewardStepInfo	= 
{
	[1] = {nCanTicketStartTime = 210000, nCanTicketEndTime = 212900, nWaitEndTime = 213006, nRewardTimeMinute = 30, },
	[2] = {nCanTicketStartTime = 213000, nCanTicketEndTime = 215900, nWaitEndTime = 220006, nRewardTimeMinute = 60, },
	[3] = {nCanTicketStartTime = 220000, nCanTicketEndTime = 222900, nWaitEndTime = 223006, nRewardTimeMinute = 30, },
}

--=========================================================
-- PreLoad
--=========================================================
function ZNQ_ChouJiang_Btn_PreLoad()
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

	this:RegisterEvent("ANN_ONLINE_MINIMAP_UI_OPEN")
    this:RegisterEvent("ANN_ONLINE_MINIMAP_UI_REFRESH")
    this:RegisterEvent("ANN_ONLINE_MINIMAP_UI_CLOSE")
end

--=========================================================
-- OnLoad
--=========================================================
function ZNQ_ChouJiang_Btn_OnLoad()
	g_ZNQ_ChouJiang_Btn_Frame_UnifiedPosition = ZNQ_ChouJiang_Btn_Frame:GetProperty("UnifiedPosition")

	-- ZNQ_ChouJiang_Btn_OK_Button : SetEvent("Clicked", "ZNQ_ChouJiang_Btn_ConfirmClick()")
end

--=========================================================
-- OnEvent
--=========================================================
function ZNQ_ChouJiang_Btn_OnEvent(event)
	if event == "ANN_ONLINE_MINIMAP_UI_CLOSE" then

		-- PushDebugMessage("ANN_ONLINE_MINIMAP_UI_CLOSE")

		if this:IsVisible() then
			ZNQ_ChouJiang_Btn_OnClose()
		end

	elseif ( event == "ANN_ONLINE_MINIMAP_UI_OPEN" ) then
		-- 显示界面
		-- 为了解决界面被犣挡的问题，先把界面关了
		-- if this:IsVisible() then
		-- 	ZNQ_ChouJiang_Btn_OnClose()
		-- end

		-- PushDebugMessage("ANN_ONLINE_MINIMAP_UI_OPEN")

		ZNQ_ChouJiang_Btn_Reset()
		ZNQ_ChouJiang_Btn_Frame_On_ResetPos()
		this:Show()
		-- ZNQ_ChouJiang_Btn_InitTimer()
		ZNQ_ChouJiang_Btn_ParamInit()
		ZNQ_ChouJiang_Btn_MoneyUpdate()
		ZNQ_ChouJiang_Btn_YuanBaoUpdate()
		ZNQ_ChouJiang_Btn_Update(1)

	elseif ( event == "ANN_ONLINE_MINIMAP_UI_REFRESH" ) then

		-- PushDebugMessage("ANN_ONLINE_MINIMAP_UI_REFRESH")

		if this:IsVisible() then
			ZNQ_ChouJiang_Btn_ParamInit()
			ZNQ_ChouJiang_Btn_Update(0)
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
			ZNQ_ChouJiang_Btn_OnClose()
		end	

	-- 物品改变
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- 刷新界面
		if this:IsVisible() then
			ZNQ_ChouJiang_Btn_Update(0)
		end

	-- 金钱改变
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		ZNQ_ChouJiang_Btn_MoneyUpdate()

	-- 元宝改变
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		ZNQ_ChouJiang_Btn_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		if DataPool:Lua_IsInTServer() == 1 then		
			ZNQ_ChouJiang_Btn_OnClose()
		end
	
	elseif (event == "ADJEST_UI_POS" ) then
		ZNQ_ChouJiang_Btn_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZNQ_ChouJiang_Btn_Frame_On_ResetPos()
	end
end

--=========================================================
-- 初始化定时器
--=========================================================
-- function ZNQ_ChouJiang_Btn_InitTimer()
-- 	if this:IsVisible() then
-- 		KillTimer( "ZNQ_ChouJiang_Btn_OnTimer()" )
-- 		SetTimer("ZNQ_ChouJiang_Btn", "ZNQ_ChouJiang_Btn_OnTimer()", g_nTimerTickTime)
-- 	end
-- end

--=========================================================
-- 定时器逻辑
--=========================================================
-- function ZNQ_ChouJiang_Btn_OnTimer()
-- 	if this:IsVisible() then
-- 		-- 活动当天
-- 		if 2 == g_nHuoDongDayStep then
-- 			-- 经过客户端自校验的服务器秒格式时间 = 时 * 10000 + 分 * 100 + 秒
-- 			local nCurServerSecondTime = tonumber(DataPool:GetServerMinuteTime())
-- 			-- 经过客户端自校验的服务器ANSI时间
-- 			local nCurServerANSITime = tonumber(DataPool:LuaGetCurrentServerTime())

-- 			local bNeedRefresh = 0

-- 			-- 初始化上次刷新时间
-- 			if 0 == g_nLastRefreshTime then
-- 				g_nLastRefreshTime = nCurServerANSITime
-- 			end

-- 			-- 计算特殊刷新step
-- 			local nCurAutoRefreshStep = 0
-- 			local nTotalStep = table.getn(g_tabAutoRefreshInfo)
-- 			for i = 1, nTotalStep do
-- 				if nCurServerSecondTime > g_tabAutoRefreshInfo[i] then
-- 					nCurAutoRefreshStep = i
-- 				end
-- 			end

-- 			-- 检测是否触发特殊刷新
-- 			if nCurAutoRefreshStep > g_nAutoRefreshStep then
-- 				bNeedRefresh = 1
-- 				g_nAutoRefreshStep = nCurAutoRefreshStep
-- 				g_nLastRefreshTime = nCurServerANSITime
-- 			end

-- 			-- 检测是否触发每分钟的自动刷新
-- 			if nCurServerANSITime - g_nLastRefreshTime >= g_nAutoRefreshTime then
-- 				bNeedRefresh = 1
-- 				g_nLastRefreshTime = nCurServerANSITime
-- 			end

-- 			if 1 == bNeedRefresh then
-- 				-- ZNQ_ChouJiang_Btn_Update(0)
-- 				-- 1 AskOpenMainUI 请求打开主界面; 2 AskRefreshAllUI 请求刷新所有界面; 3 OnGetTicket 领取活动券; 
-- 				-- 4 OnSubmitTicket(nSelectedStep) 提交活动券; 5 OnGetReward(nSelectedStep) 领取奖励; 
-- 				-- 6 OnClickHelp 帮助; 7 OnHotPointClicked(nSelectedStep) 消除红点事件（参与抽奖点击分页签）
-- 				-- PushDebugMessage("ZNQ_ChouJiang_Btn_OnTimer 1 == bNeedRefresh")

-- 				Clear_XSCRIPT()
-- 					Set_XSCRIPT_Function_Name( "OnUIEvent" )
-- 					Set_XSCRIPT_ScriptID(791050)
-- 					Set_XSCRIPT_Parameter(0, 2)								
-- 					Set_XSCRIPT_ParamCount(1)
-- 				Send_XSCRIPT()
-- 			end
-- 		end
		
-- 	else
-- 		KillTimer( "ZNQ_ChouJiang_Btn_OnTimer()" )
-- 	end
-- end

--=========================================================
-- 界面参数初始化
--=========================================================
function ZNQ_ChouJiang_Btn_ParamInit()

	-- 前三个参数服务器用，客户端从第4个参数开始缓存
	-- LuaFnOperateAnnOnlineUI(sceneId, selfId, x791050_g_nHuoDongRewardDay, nMainUIOpType, bShowMiniMapUI, nHuoDongDayStep, nStartFlag, nGetedFlag, nDownTick, nJoinRewardInfo, nHaveRewardInfo, nGetedRewardInfo, nSimpleHotPointInfo, 0, 0)

	-- PushDebugMessage("ZNQ_ChouJiang_Btn_ParamInit")

	g_nHuoDongDayStep			= DataPool:Lua_GetAnnINTParamByIndex(3)
	g_nStartFlag				= DataPool:Lua_GetAnnINTParamByIndex(4)
	g_nGetedFlag				= DataPool:Lua_GetAnnINTParamByIndex(5)
	g_nDownTick					= DataPool:Lua_GetAnnINTParamByIndex(6) 
	local nJoinRewardInfo		= DataPool:Lua_GetAnnINTParamByIndex(7)
	local nHaveRewardInfo		= DataPool:Lua_GetAnnINTParamByIndex(8)
	local nGetedRewardInfo		= DataPool:Lua_GetAnnINTParamByIndex(9)
	local nSimpleHotPointInfo	= DataPool:Lua_GetAnnINTParamByIndex(10)
	g_nServerHourToSecond		= DataPool:Lua_GetAnnINTParamByIndex(11)

	local nTempValue = 0

	nTempValue = nJoinRewardInfo
	for i = 1, g_nMaxRewardWave do
		g_tJoinRewardInfo[i] = math.mod(nTempValue, 10)
		nTempValue = math.floor(nTempValue / 10)
	end

	nTempValue = nHaveRewardInfo
	for i = 1, g_nMaxRewardWave do
		g_tHaveRewardInfo[i] = math.mod(nTempValue, 10)
		nTempValue = math.floor(nTempValue / 10)
	end

	nTempValue = nGetedRewardInfo
	for i = 1, g_nMaxRewardWave do
		g_tGetedRewardInfo[i] = math.mod(nTempValue, 10)
		nTempValue = math.floor(nTempValue / 10)	
	end

	-- 按10进制位存 低位开始 1 领券红点; 2-4 参与红点; 5-7 领奖红点 
	nTempValue = nSimpleHotPointInfo
	for i = 1, table.getn(g_tHotPointInfo) do
		g_tHotPointInfo[i] = math.mod(nTempValue, 10)
		nTempValue = math.floor(nTempValue / 10)	
	end

	-- 经过客户端自校验的服务器ANSI时间
	g_nLastSyncServerTime = tonumber(DataPool:LuaGetCurrentServerTime())

end

--=========================================================
-- 界面更新
--=========================================================
-- !!!reloadscript =ZNQ_ChouJiang_Btn
function ZNQ_ChouJiang_Btn_Update(bOpen)

	-- PushDebugMessage("ZNQ_ChouJiang_Btn_Update")

	-- 获得活动的阶段信息 1 仅牴示界面阶段; 2 抽奖当天; 3 抽奖过后的可领奖阶段; -1 未开启活动; -2 活动结束第一天; -3 活动已结束;
	-- 自校验关睜
	if g_nHuoDongDayStep < 0 then
		-- PushDebugMessage("g_nHuoDongDayStep < 0")
		ZNQ_ChouJiang_Btn_OnClose()	
	end

	-- 废控件隐藏
	-- ZNQ_ChouJiang_Btn_Animate : Hide()

	-- 红点逻辑
	local nSimpleHotPointInfo	= DataPool:Lua_GetAnnINTParamByIndex(10)
	if nSimpleHotPointInfo > 0 then
		ZNQ_ChouJiang_Btn_Tips : Show()
		ZNQ_ChouJiang_Btn_Animate : Show()
	else
		ZNQ_ChouJiang_Btn_Tips : Hide()
		ZNQ_ChouJiang_Btn_Animate : Hide()
	end
	
	-- 获取两种服务器计时时间
	-- 经过客户端自校验的服务器ANSI时间
	local nCurServerANSITime = tonumber(DataPool:LuaGetCurrentServerTime())
	-- 经过客户端自校验的服务器秒格式时间 = 时 * 10000 + 分 * 100 + 秒
	-- local nCurServerSecondTime = tonumber(DataPool:GetServerMinuteTime())
	local nCurServerSecondTime = g_nServerHourToSecond

	local nCurSecond = math.mod(nCurServerSecondTime, 100 )
	local nTempValueTime = math.floor(nCurServerSecondTime / 100 )

	local nCurMinute= math.mod(nTempValueTime, 100 )
	local nCurHour = math.floor(nTempValueTime / 100 )

	-- 左侧领券区的倒计时 倒计时提示和按钮变化

	-- x/3 角标默认隐藏
	-- ZNQ_ChouJiang_Btn_123_Text : Hide()

	-- 默认使用小BK，如果ZNQ_ChouJiang_Btn_123_Text使用的时候，换用大BK
	-- ZNQ_ChouJiang_Btn_Time_Text_BK_Small	: Show()
	-- ZNQ_ChouJiang_Btn_Time_Text_BK_Big		: Hide()

	-- 默认显示两行了
	ZNQ_ChouJiang_Btn_123_Text : Show()
	-- ZNQ_ChouJiang_Btn_Time_Text_BK_Small	: Hide()
	-- ZNQ_ChouJiang_Btn_Time_Text_BK_Big		: Show()

	-- 倒计时未开始
	if g_nHuoDongDayStep < 2 or (2 == g_nHuoDongDayStep and nCurServerSecondTime < g_nDownTickStart) then
		ZNQ_ChouJiang_Btn_Time_Text : SetText( "#{ZNQCJ_20220616_58}" )
		ZNQ_ChouJiang_Btn_123_Text 	: SetText( "#{ZNQCJ_20220616_94}" )
		ZNQ_ChouJiang_Btn_BK 		: SetToolTip( "#{ZNQCJ_20220616_59}" )
	end

	-- 活动全部结束
	if g_nHuoDongDayStep > 2 or (2 == g_nHuoDongDayStep and nCurServerSecondTime >= g_nRewardTimeEnd) then
		ZNQ_ChouJiang_Btn_Time_Text : SetText( "#{ZNQCJ_20220616_90}" )
		ZNQ_ChouJiang_Btn_123_Text 	: SetText( "#{ZNQCJ_20220616_64}" )
		ZNQ_ChouJiang_Btn_BK 		: SetToolTip( "#{ZNQCJ_20220616_65}" )
	end

	-- 活动当天
	if 2 == g_nHuoDongDayStep then

		-- 倒计时进行中
		if nCurServerSecondTime >= g_nDownTickStart and nCurServerSecondTime < g_nDownTickEnd then
			
			if g_nGetedFlag >= 3 then
				-- 全部领完了
				ZNQ_ChouJiang_Btn_Time_Text : SetText( "#{ZNQCJ_20220616_09}" )
				ZNQ_ChouJiang_Btn_123_Text 	: SetText( "#{ZNQCJ_20220616_95}" )
				ZNQ_ChouJiang_Btn_BK 		: SetToolTip( "#{ZNQCJ_20220616_59}" )
			else
				-- 还没领完
				local nFixTime = nCurServerANSITime - g_nLastSyncServerTime
				local nLeftTime = g_nDownTick - nFixTime
				if nLeftTime < 0 then
					nLeftTime = 0
				end
				local nLeftMinute = math.ceil(nLeftTime / 60)
				local nLeftSecond = math.mod(nLeftTime, 60)
				ZNQ_ChouJiang_Btn_Time_Text : SetText( ScriptGlobal_Format("#{ZNQCJ_20220616_10}", g_nGetedFlag ) )
				ZNQ_ChouJiang_Btn_123_Text 	: SetText( ScriptGlobal_Format("#{ZNQCJ_20220616_11}", nLeftMinute, nLeftSecond ) )
				ZNQ_ChouJiang_Btn_BK 		: SetToolTip( "#{ZNQCJ_20220616_59}" )

				if nLeftMinute <= 0  then
					ZNQ_ChouJiang_Btn_Time_Text : SetText( ScriptGlobal_Format("#{ZNQCJ_20220616_10}", g_nGetedFlag ) )
					ZNQ_ChouJiang_Btn_123_Text 	: SetText( "#{ZNQCJ_20220616_84}" )
				end
			end
		end

		-- 抽奖中
		for nPage = 1, g_nMaxRewardWave do
			if 1 == ZNQ_ChouJiang_Btn_GetCurPageChouJiangProcess(nPage) then

				ZNQ_ChouJiang_Btn_BK : SetToolTip( "#{ZNQCJ_20220616_14}" )

				local tStepInfoCurPage = g_tabRewardStepInfo[nPage]
				local nShowCountMinute = tStepInfoCurPage.nRewardTimeMinute - nCurMinute

				-- 第一轮
				if 1 == nPage then
					ZNQ_ChouJiang_Btn_Time_Text : SetText( "#{ZNQCJ_20220616_91}" )
					local strShowMsg02 	= ScriptGlobal_Format("#{ZNQCJ_20220616_11}", nShowCountMinute )
					ZNQ_ChouJiang_Btn_123_Text 	: SetText( strShowMsg02 )
				end

				-- 第二轮
				if 2 == nPage then
					ZNQ_ChouJiang_Btn_Time_Text : SetText( "#{ZNQCJ_20220616_88}" )
					local strShowMsg02 = ScriptGlobal_Format("#{ZNQCJ_20220616_89}", nShowCountMinute )
					ZNQ_ChouJiang_Btn_123_Text 	: SetText( strShowMsg02 )
				end

				-- 第三轮
				if 3 == nPage then
					ZNQ_ChouJiang_Btn_Time_Text : SetText( "#{ZNQCJ_20220616_97}" )
					local strShowMsg02 = ScriptGlobal_Format("#{ZNQCJ_20220616_89}", nShowCountMinute )
					ZNQ_ChouJiang_Btn_123_Text 	: SetText( strShowMsg02 )
				end

			end

			-- 等待时间有5秒钟的延迟 会和其它时间段冲突，放在全部逻辑最后 保证优先显示等待提示
			if 2 == ZNQ_ChouJiang_Btn_GetCurPageChouJiangProcess(nPage) then
				ZNQ_ChouJiang_Btn_BK : SetToolTip( "#{ZNQCJ_20220616_14}" )

				-- 第一轮
				if 1 == nPage then
					ZNQ_ChouJiang_Btn_Time_Text : SetText( "#{ZNQCJ_20220616_91}" )
					ZNQ_ChouJiang_Btn_123_Text 	: SetText( "#{ZNQCJ_20220616_55}" )
				end

				-- 第二轮
				if 2 == nPage then
					ZNQ_ChouJiang_Btn_Time_Text : SetText( "#{ZNQCJ_20220616_96}" )
					ZNQ_ChouJiang_Btn_123_Text 	: SetText( "#{ZNQCJ_20220616_55}" )
				end

				-- 第三轮
				if 3 == nPage then
					ZNQ_ChouJiang_Btn_Time_Text : SetText( "#{ZNQCJ_20220616_98}" )
					ZNQ_ChouJiang_Btn_123_Text 	: SetText( "#{ZNQCJ_20220616_55}" )
				end
			end
		end
		
	end

end

--=========================================================
-- 内部功能函数 获取当前页面的抽奖进程 0 未开始 1 可投奖券 2 等待开奖 3 可领奖
--=========================================================
function ZNQ_ChouJiang_Btn_GetCurPageChouJiangProcess(nPage)

	-- 经过客户端自校验的服务器秒格式时间 = 时 * 10000 + 分 * 100 + 秒
	-- local nCurServerSecondTime = tonumber(DataPool:GetServerMinuteTime())
	local nCurServerSecondTime = g_nServerHourToSecond

	local tStepInfoCurPage = g_tabRewardStepInfo[nPage]
	
	-- 本页抽奖未开始
	if g_nHuoDongDayStep < 2 or (2 == g_nHuoDongDayStep and nCurServerSecondTime < tStepInfoCurPage.nCanTicketStartTime) then
		return 0
	end

	-- 可投奖券
	if 2 == g_nHuoDongDayStep and nCurServerSecondTime >= tStepInfoCurPage.nCanTicketStartTime and nCurServerSecondTime < tStepInfoCurPage.nCanTicketEndTime then
		return 1
	end

	-- 等待开奖
	if 2 == g_nHuoDongDayStep and nCurServerSecondTime >= tStepInfoCurPage.nCanTicketEndTime and nCurServerSecondTime < tStepInfoCurPage.nWaitEndTime then
		return 2
	end

	-- 可领奖
	if g_nHuoDongDayStep > 2 or (2 == g_nHuoDongDayStep and nCurServerSecondTime >= tStepInfoCurPage.nWaitEndTime) then
		return 3
	end
end

--=========================================================
-- 界面点击操作
--=========================================================
function ZNQ_ChouJiang_Btn_OnClickEvent()
	if( IsWindowShow("ZNQ_ChouJiang") ) then
		CloseWindow("ZNQ_ChouJiang", true)
	else
		-- 1 AskOpenMainUI 请求打开主界面; 2 AskRefreshAllUI 请求刷新所有界面; 3 OnGetTicket 领取活动券; 
		-- 4 OnSubmitTicket(nSelectedStep) 提交活动券; 5 OnGetReward(nSelectedStep) 领取奖励; 
		-- 6 OnClickHelp 帮助; 7 OnHotPointClicked(nSelectedStep) 消除红点事件（参与抽奖点击分页签）

		-- PushDebugMessage("ZNQ_ChouJiang_Btn_OnClickEvent")

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnUIEvent" )
			Set_XSCRIPT_ScriptID(791050)
			Set_XSCRIPT_Parameter(0, 1)								
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end

--=========================================================
-- 重置界面
--=========================================================
function ZNQ_ChouJiang_Btn_Reset()
	g_nCurPageIndex 		= 1
	g_nHuoDongDayStep		= 0
	g_nStartFlag			= 0
	g_nGetedFlag			= 0
	g_nDownTick				= 0
	g_nLastSyncServerTime	= 0
	g_nServerHourToSecond	= 0
	g_nAutoRefreshStep		= 0
	g_nLastRefreshTime		= 0

	for i = 1, g_nMaxRewardWave do
		g_tJoinRewardInfo[i] = 0
	end
	for i = 1, g_nMaxRewardWave do
		g_tHaveRewardInfo[i] = 0
	end
	for i = 1, g_nMaxRewardWave do
		g_tGetedRewardInfo[i] = 0
	end

	-- KillTimer( "ZNQ_ChouJiang_Btn_OnTimer()" )
end

--=========================================================
-- 关睜界面
--=========================================================
function ZNQ_ChouJiang_Btn_OnClose()	

	-- PushDebugMessage("ZNQ_ChouJiang_Btn_OnClose")

	this:Hide()
	StopCareObject_ZNQ_ChouJiang_Btn()
	-- 重置
	ZNQ_ChouJiang_Btn_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="ZNQ_ChouJiang_Btn_OnHiden();" />
--=========================================================
function ZNQ_ChouJiang_Btn_OnHiden()

	-- PushDebugMessage("ZNQ_ChouJiang_Btn_OnHiden")

	StopCareObject_ZNQ_ChouJiang_Btn()
	-- 重置
	ZNQ_ChouJiang_Btn_Reset()
end

--=========================================================
-- 关心操作
--=========================================================
function BeginCareObject_ZNQ_ChouJiang_Btn()
	-- 关心
	this:CareObject(g_nObjCaredIDClient, 1, "ZNQ_ChouJiang_Btn")
end

function StopCareObject_ZNQ_ChouJiang_Btn()
	-- 取消关心
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "ZNQ_ChouJiang_Btn")
	end
	g_nServerObjID = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function ZNQ_ChouJiang_Btn_MoneyUpdate()
	-- ZNQ_ChouJiang_Btn_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- ZNQ_ChouJiang_Btn_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 元宝刷新：界面更新调用一次 元宝事件调用一次
--=========================================================
function ZNQ_ChouJiang_Btn_YuanBaoUpdate()
	-- ZNQ_ChouJiang_Btn_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- 界面位置
--=========================================================
function ZNQ_ChouJiang_Btn_Frame_On_ResetPos()
	ZNQ_ChouJiang_Btn_Frame:SetProperty("UnifiedPosition", g_ZNQ_ChouJiang_Btn_Frame_UnifiedPosition)
end
