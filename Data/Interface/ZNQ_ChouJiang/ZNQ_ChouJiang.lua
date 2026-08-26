-- ZNQ_ChouJiang 周年庆稳在线 主界面 2022-7-4 lishilong
-- !!!reloadscript =ZNQ_ChouJiang
--

local g_ZNQ_ChouJiang_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 		= 3.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredItem 			= 1
local bCaredObj 			= 0
local bCaredMoney 			= 0
local bCaredYuanBao			= 0
local g_nComfirmParam1		= 0

-- 主UICommand
local g_nUICommandID		= 79105001

-- 抽奖波次
local g_nMaxRewardWave		= 3
-- 奖励等级
local g_nMaxRewardLevel		= 3

local g_nCurPageIndex		= 1

local g_nHuoDongDayStep		= 0
local g_nStartFlag			= 0
local g_nGetedFlag			= 0
local g_nDownTick			= 0
local g_tJoinRewardInfo		= {0, 0, 0}
local g_tHaveRewardInfo		= {0, 0, 0}
local g_tGetedRewardInfo	= {0, 0, 0}
-- 按10进制位存 低位开始 1 领券红点; 2-4 参与红点; 5-7 领奖红点 
local g_tHotPointInfo		= {0, 0, 0, 0, 0, 0, 0}
local g_nServerHourToSecond	= 0
local g_nLastSyncServerTime	= 0

-- 定时器 单位ms
local g_nTimerTickTime		= 3 * 1000

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

-- 分页蒙版
local g_hPageClient			= {}
-- 分页页签按钮
local g_hPageButton			= {}
local g_hPageButtonTips		= {}
-- 参与抽奖 领奖按钮
-- local g_hJoinAndGetButton	= {}
-- local g_hJoinAndGetButtonD	= {}
local g_hJoinButton			= {}
local g_hGetButton			= {}
local g_hJoinedPic			= {}
local g_hGetedRewardPic		= {}
local g_hJoinAndGetButtonTips	= {}
-- 抽奖提示信息
local g_hRewardIntroText	= {}

-- 中奖玩家控件
local g_hRewardPlayerInfo	= {}
local g_nUseRewardPlayerNum = 4
local g_nMaxRewardPlayerNum = 6

-- 所有页面的奖励控件 二维数组 第一维是分页 第二维是第x个奖励
local g_hTabRewardActionButton	= {}
local g_hTabRewardGeted		= {}
local g_hTabRewardDisable	= {}
local g_hTabRewardAnimate	= {}

-- 在线Tick倒计时时间段 [g_nDownTickStart, g_nDownTickEnd)
local g_nDownTickStart		= 180000
local g_nDownTickEnd		= 210000

-- 抽奖时时间段 [g_nRewardTimeStart, g_nRewardTimeEnd]
local g_nRewardTimeStart	= 210000
local g_nRewardTimeEnd		= 223000

-- 抽奖券ID
local g_nTicketItemID		= 38002596

local g_tabRewardStepInfo	= 
{
	[1] = {nCanTicketStartTime = 210000, nCanTicketEndTime = 212900, nWaitEndTime = 213006, nRewardTimeMinute = 30, },
	[2] = {nCanTicketStartTime = 213000, nCanTicketEndTime = 215900, nWaitEndTime = 220006, nRewardTimeMinute = 60, },
	[3] = {nCanTicketStartTime = 220000, nCanTicketEndTime = 222900, nWaitEndTime = 223006, nRewardTimeMinute = 30, },
}

local g_tabRewardItemInfo			= 
{
	[1] = 
	{
		-- 	奖项	数量	奖励	id
		-- 一等奖	1	坐骑：绝地（永久，拾取绑定）	10141936
		-- 二等奖	3	坐骑：绝地（180天，拾取绑定）	10141935
		-- 茽牋奖	参与即得	礼包1	38002640
		[1] = {nItemID = 10141936, nItemNum = 1, nNeedBagSpace = 1, nNeedMatSpace = 0, bCast = 0, },
		[2] = {nItemID = 10141935, nItemNum = 1, nNeedBagSpace = 1, nNeedMatSpace = 0, bCast = 0, },
		[3] = {nItemID = 38002640, nItemNum = 1, nNeedBagSpace = 1, nNeedMatSpace = 0, bCast = 0, },
	},

	[2] = 
	{
		-- 奖项	数量	奖励	id
		-- 一等奖	1	新时装特殊染色（永久，拾取绑定）	10124811
		-- 二等奖	3	新时装（永久，拾取绑定）	10124810
		-- 茽牋奖	参与即得	礼包2	38002641

		-- 奖项	数量	奖励	id
		-- 一等奖	1	新时装（永久，拾取绑定）	10124876
		-- 二等奖	3	新时装（180天，拾取绑定）	10124875
		-- 茽牋奖	参与即得	礼包2	38002641

		[1] = {nItemID = 10124876, nItemNum = 1, nNeedBagSpace = 1, nNeedMatSpace = 0, bCast = 0, },
		[2] = {nItemID = 10124875, nItemNum = 1, nNeedBagSpace = 1, nNeedMatSpace = 0, bCast = 0, },
		[3] = {nItemID = 38002641, nItemNum = 1, nNeedBagSpace = 1, nNeedMatSpace = 0, bCast = 0, },
	},

	[3] = 
	{
		-- 奖项	数量	奖励	id
		-- 一等奖	1	九尾魂玉*40	38002519 （强绑）
		-- 二等奖	3	九尾魂玉*20	38002519 （强绑）
		-- 茽牋奖	参与即得	礼包3	38002642
		[1] = {nItemID = 38002519, nItemNum = 40, nNeedBagSpace = 1, nNeedMatSpace = 0, bCast = 0, },
		[2] = {nItemID = 38002519, nItemNum = 20, nNeedBagSpace = 1, nNeedMatSpace = 0, bCast = 0, },
		[3] = {nItemID = 38002642, nItemNum = 1, nNeedBagSpace = 1, nNeedMatSpace = 0, bCast = 0, },
	},
}

--=========================================================
-- PreLoad
--=========================================================
function ZNQ_ChouJiang_PreLoad()
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

	this:RegisterEvent("ANN_ONLINE_MAIN_UI_OPEN")
    this:RegisterEvent("ANN_ONLINE_MAIN_UI_REFRESH")
    this:RegisterEvent("ANN_ONLINE_MAIN_UI_CLOSE")
end

--=========================================================
-- OnLoad
--=========================================================
function ZNQ_ChouJiang_OnLoad()
	g_ZNQ_ChouJiang_Frame_UnifiedPosition = ZNQ_ChouJiang_MainFrame:GetProperty("UnifiedPosition")

	-- ZNQ_ChouJiang_OK_Button : SetEvent("Clicked", "ZNQ_ChouJiang_ConfirmClick()")

	g_hPageClient[1] = ZNQ_ChouJiang_Client1
	g_hPageClient[2] = ZNQ_ChouJiang_Client2
	g_hPageClient[3] = ZNQ_ChouJiang_Client3

	g_hPageButton[1] = ZNQ_ChouJiang_Page1_Btn
	g_hPageButton[2] = ZNQ_ChouJiang_Page2_Btn
	g_hPageButton[3] = ZNQ_ChouJiang_Page3_Btn

	g_hPageButtonTips[1] = ZNQ_ChouJiang_Page1_Btn_Tips
	g_hPageButtonTips[2] = ZNQ_ChouJiang_Page2_Btn_Tips
	g_hPageButtonTips[3] = ZNQ_ChouJiang_Page3_Btn_Tips


	local hPlayerLevel01 = {}
	local hPlayerLevel02_01 = {}
	local hPlayerLevel02_02 = {}
	local hPlayerLevel02_03 = {}

	hPlayerLevel01[1] = ZNQ_ChouJiang_Client1_Info2
	hPlayerLevel01[2] = ZNQ_ChouJiang_Client2_Info2
	hPlayerLevel01[3] = ZNQ_ChouJiang_Client3_Info2

	hPlayerLevel02_01[1] = ZNQ_ChouJiang_Client1_Info3
	hPlayerLevel02_01[2] = ZNQ_ChouJiang_Client2_Info3
	hPlayerLevel02_01[3] = ZNQ_ChouJiang_Client3_Info3

	hPlayerLevel02_02[1] = ZNQ_ChouJiang_Client1_Info4
	hPlayerLevel02_02[2] = ZNQ_ChouJiang_Client2_Info4
	hPlayerLevel02_02[3] = ZNQ_ChouJiang_Client3_Info4

	hPlayerLevel02_03[1] = ZNQ_ChouJiang_Client1_Info6
	hPlayerLevel02_03[2] = ZNQ_ChouJiang_Client2_Info6
	hPlayerLevel02_03[3] = ZNQ_ChouJiang_Client3_Info6

	g_hRewardPlayerInfo[1] = hPlayerLevel01
	g_hRewardPlayerInfo[2] = hPlayerLevel02_01
	g_hRewardPlayerInfo[3] = hPlayerLevel02_02
	g_hRewardPlayerInfo[4] = hPlayerLevel02_03

	g_hRewardIntroText[1] = ZNQ_ChouJiang_Client1_Info5
	g_hRewardIntroText[2] = ZNQ_ChouJiang_Client2_Info5
	g_hRewardIntroText[3] = ZNQ_ChouJiang_Client3_Info5

	-- g_hJoinAndGetButton[1] = ZNQ_ChouJiang_Client1_btn
	-- g_hJoinAndGetButton[2] = ZNQ_ChouJiang_Client2_btn
	-- g_hJoinAndGetButton[3] = ZNQ_ChouJiang_Client3_btn

	-- g_hJoinAndGetButtonD[1] = ZNQ_ChouJiang_Client1_btn_D
	-- g_hJoinAndGetButtonD[2] = ZNQ_ChouJiang_Client2_btn_D
	-- g_hJoinAndGetButtonD[3] = ZNQ_ChouJiang_Client3_btn_D

	g_hJoinButton[1] = ZNQ_ChouJiang_Client1_JQbtn
	g_hJoinButton[2] = ZNQ_ChouJiang_Client2_JQbtn
	g_hJoinButton[3] = ZNQ_ChouJiang_Client3_JQbtn

	g_hGetButton[1] = ZNQ_ChouJiang_Client1_btn
	g_hGetButton[2] = ZNQ_ChouJiang_Client2_btn
	g_hGetButton[3] = ZNQ_ChouJiang_Client3_btn	

	g_hJoinedPic[1] = ZNQ_ChouJiang_Client1_YTJQ_Pic
	g_hJoinedPic[2] = ZNQ_ChouJiang_Client2_YTJQ_Pic
	g_hJoinedPic[3] = ZNQ_ChouJiang_Client3_YTJQ_Pic

	g_hGetedRewardPic[1] = ZNQ_ChouJiang_Client1_btn_D
	g_hGetedRewardPic[2] = ZNQ_ChouJiang_Client2_btn_D
	g_hGetedRewardPic[3] = ZNQ_ChouJiang_Client3_btn_D

	g_hJoinAndGetButtonTips[1] = ZNQ_ChouJiang_Client1_btn_Tips
	g_hJoinAndGetButtonTips[2] = ZNQ_ChouJiang_Client2_btn_Tips
	g_hJoinAndGetButtonTips[3] = ZNQ_ChouJiang_Client3_btn_Tips

	----------------------------------------
	local hRewardActionButtonPage1 = {}
	hRewardActionButtonPage1[1] = ZNQ_ChouJiang_Client1_icon1
	hRewardActionButtonPage1[2] = ZNQ_ChouJiang_Client1_icon2
	hRewardActionButtonPage1[3] = ZNQ_ChouJiang_Client1_icon3

	local hRewardActionButtonPage2 = {}
	hRewardActionButtonPage2[1] = ZNQ_ChouJiang_Client2_icon1
	hRewardActionButtonPage2[2] = ZNQ_ChouJiang_Client2_icon2
	hRewardActionButtonPage2[3] = ZNQ_ChouJiang_Client2_icon3

	local hRewardActionButtonPage3 = {}
	hRewardActionButtonPage3[1] = ZNQ_ChouJiang_Client3_icon1
	hRewardActionButtonPage3[2] = ZNQ_ChouJiang_Client3_icon2
	hRewardActionButtonPage3[3] = ZNQ_ChouJiang_Client3_icon3

	g_hTabRewardActionButton[1] = hRewardActionButtonPage1
	g_hTabRewardActionButton[2] = hRewardActionButtonPage2
	g_hTabRewardActionButton[3] = hRewardActionButtonPage3

	----------------------------------------
	local hRewardGeted1 = {}
	hRewardGeted1[1] = ZNQ_ChouJiang_Client1_icon1_ItemOK
	hRewardGeted1[2] = ZNQ_ChouJiang_Client1_icon2_ItemOK
	hRewardGeted1[3] = ZNQ_ChouJiang_Client1_icon3_ItemOK

	local hRewardGeted2 = {}
	hRewardGeted2[1] = ZNQ_ChouJiang_Client2_icon1_ItemOK
	hRewardGeted2[2] = ZNQ_ChouJiang_Client2_icon2_ItemOK
	hRewardGeted2[3] = ZNQ_ChouJiang_Client2_icon3_ItemOK

	local hRewardGeted3 = {}
	hRewardGeted3[1] = ZNQ_ChouJiang_Client3_icon1_ItemOK
	hRewardGeted3[2] = ZNQ_ChouJiang_Client3_icon2_ItemOK
	hRewardGeted3[3] = ZNQ_ChouJiang_Client3_icon3_ItemOK

	g_hTabRewardGeted[1] = hRewardGeted1
	g_hTabRewardGeted[2] = hRewardGeted2
	g_hTabRewardGeted[3] = hRewardGeted3

	----------------------------------------
	local hRewardDisable1 = {}
	hRewardDisable1[1] = ZNQ_ChouJiang_Client1_icon1_Disable
	hRewardDisable1[2] = ZNQ_ChouJiang_Client1_icon2_Disable
	hRewardDisable1[3] = ZNQ_ChouJiang_Client1_icon3_Disable

	local hRewardDisable2 = {}
	hRewardDisable2[1] = ZNQ_ChouJiang_Client2_icon1_Disable
	hRewardDisable2[2] = ZNQ_ChouJiang_Client2_icon2_Disable
	hRewardDisable2[3] = ZNQ_ChouJiang_Client2_icon3_Disable

	local hRewardDisable3 = {}
	hRewardDisable3[1] = ZNQ_ChouJiang_Client3_icon1_Disable
	hRewardDisable3[2] = ZNQ_ChouJiang_Client3_icon2_Disable
	hRewardDisable3[3] = ZNQ_ChouJiang_Client3_icon3_Disable

	g_hTabRewardDisable[1] = hRewardDisable1
	g_hTabRewardDisable[2] = hRewardDisable2
	g_hTabRewardDisable[3] = hRewardDisable3

	----------------------------------------
	local hRewardAnimate1 = {}
	hRewardAnimate1[1] = ZNQ_ChouJiang_Client1_icon1_ItemAnimate
	hRewardAnimate1[2] = ZNQ_ChouJiang_Client1_icon2_ItemAnimate
	hRewardAnimate1[3] = ZNQ_ChouJiang_Client1_icon3_ItemAnimate

	local hRewardAnimate2 = {}
	hRewardAnimate2[1] = ZNQ_ChouJiang_Client2_icon1_ItemAnimate
	hRewardAnimate2[2] = ZNQ_ChouJiang_Client2_icon2_ItemAnimate
	hRewardAnimate2[3] = ZNQ_ChouJiang_Client2_icon3_ItemAnimate

	local hRewardAnimate3 = {}
	hRewardAnimate3[1] = ZNQ_ChouJiang_Client3_icon1_ItemAnimate
	hRewardAnimate3[2] = ZNQ_ChouJiang_Client3_icon2_ItemAnimate
	hRewardAnimate3[3] = ZNQ_ChouJiang_Client3_icon3_ItemAnimate

	g_hTabRewardAnimate[1] = hRewardAnimate1
	g_hTabRewardAnimate[2] = hRewardAnimate2
	g_hTabRewardAnimate[3] = hRewardAnimate3

end

--=========================================================
-- OnEvent
--=========================================================
function ZNQ_ChouJiang_OnEvent(event)
	if event == "ANN_ONLINE_MAIN_UI_CLOSE" then
		if this:IsVisible() then
			ZNQ_ChouJiang_OnClose()
		end

	elseif ( event == "ANN_ONLINE_MAIN_UI_OPEN" ) then
		-- 显示界面
		-- 为了解决界面被犣挡的问题，先把界面关了
		-- if this:IsVisible() then
		-- 	ZNQ_ChouJiang_OnClose()
		-- end
		ZNQ_ChouJiang_Reset()
		ZNQ_ChouJiang_Frame_On_ResetPos()
		local nOpenType = 1
		if this:IsVisible() then
			nOpenType = 0
		end
		this:Show()
		-- ZNQ_ChouJiang_InitTimer()
		ZNQ_ChouJiang_ParamInit()
		ZNQ_ChouJiang_MoneyUpdate()
		ZNQ_ChouJiang_YuanBaoUpdate()
		ZNQ_ChouJiang_Update(nOpenType)

	elseif ( event == "ANN_ONLINE_MAIN_UI_REFRESH" ) then

		if this:IsVisible() then
			ZNQ_ChouJiang_ParamInit()
			ZNQ_ChouJiang_Update(0)
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
			ZNQ_ChouJiang_OnClose()
		end	

	-- 物品改变
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- 刷新界面
		if this:IsVisible() then
			ZNQ_ChouJiang_Update(0)
		end

	-- 金钱改变
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		ZNQ_ChouJiang_MoneyUpdate()

	-- 元宝改变
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		ZNQ_ChouJiang_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		ZNQ_ChouJiang_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		ZNQ_ChouJiang_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZNQ_ChouJiang_Frame_On_ResetPos()
	end
end

--=========================================================
-- 初始化定时器
--=========================================================
-- function ZNQ_ChouJiang_InitTimer()
-- 	if this:IsVisible() then
-- 		KillTimer( "ZNQ_ChouJiang_OnTimer()" )
-- 		SetTimer("ZNQ_ChouJiang", "ZNQ_ChouJiang_OnTimer()", g_nTimerTickTime)
-- 	end
-- end

--=========================================================
-- 定时器逻辑
--=========================================================
-- function ZNQ_ChouJiang_OnTimer()
-- 	if this:IsVisible() then

-- 		-- 活动当天
-- 		if 2 == g_nHuoDongDayStep then
-- 			-- 经过客户端自校验的服务器秒格式时间 = 时 * 10000 + 分 * 100 + 秒
-- 			local nCurServerSecondTime = tonumber(DataPool:GetServerMinuteTime())
-- 			-- 经过客户端自校验的服务器ANSI时间
-- 			local nCurServerANSITime = tonumber(DataPool:LuaGetCurrentServerTime())

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
-- 				g_nAutoRefreshStep = nCurAutoRefreshStep
-- 				g_nLastRefreshTime = nCurServerANSITime
-- 				ZNQ_ChouJiang_Update(0)
-- 			end

-- 			-- 检测是否触发每分钟的自动刷新
-- 			if nCurServerANSITime - g_nLastRefreshTime >= g_nAutoRefreshTime then				
-- 				g_nLastRefreshTime = nCurServerANSITime
-- 				ZNQ_ChouJiang_Update(0)
-- 			end
-- 		end
	
-- 	else
-- 		KillTimer( "ZNQ_ChouJiang_OnTimer()" )
-- 	end
-- end

--=========================================================
-- 界面参数初始化
--=========================================================
function ZNQ_ChouJiang_ParamInit()

	-- 前三个参数服务器用，客户端从第4个参数开始缓存
	-- LuaFnOperateAnnOnlineUI(sceneId, selfId, x791050_g_nHuoDongRewardDay, nMainUIOpType, bShowMiniMapUI, nHuoDongDayStep, nStartFlag, nGetedFlag, nDownTick, nJoinRewardInfo, nHaveRewardInfo, nGetedRewardInfo, nSimpleHotPointInfo, nServerHourToSecond, 0)

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
-- 二次确认框回调 ["Type"] "Ok"的返回值有"Ok"； ["Type"] "YesNo"的返回值有 "Yes" "No"
--=========================================================
function ZNQ_ChouJiang_OnComfirmedBack(strRet)
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
-- !!!reloadscript =ZNQ_ChouJiang
function ZNQ_ChouJiang_Update(bOpen)

	-- 获得活动的阶段信息 1 仅牴示界面阶段; 2 抽奖当天; 3 抽奖过后的可领奖阶段; -1 未开启活动; -2 活动结束第一天; -3 活动已结束;
	-- 自校验关睜
	if g_nHuoDongDayStep < 0 then
		ZNQ_ChouJiang_OnClose()
	end

	-- 获取两种服务器计时时间
	-- 经过客户端自校验的服务器ANSI时间
	local nCurServerANSITime = tonumber(DataPool:LuaGetCurrentServerTime())
	-- 经过客户端自校验的服务器秒格式时间 = 时 * 10000 + 分 * 100 + 秒
	-- local nCurServerSecondTime = tonumber(DataPool:GetServerMinuteTime())
	local nCurServerSecondTime = g_nServerHourToSecond

	-- local nCurSecond = math.mod(nCurServerSecondTime, 100 )
	local nCurMinute= math.mod( math.floor(nCurServerSecondTime / 100 ), 100 )
	-- local nCurHour = math.floor(nTempValueTime / 100 )

	-- 左侧领券区的倒计时 倒计时提示和按钮变化

	-- 自动选择页面
	local nAutoSelectPage = 1

	-- 左侧的券牴示
	local theAction = DataPool:CreateBindActionItemForShow(g_nTicketItemID, 1)
	ZNQ_ChouJiang_Piao_Icon : SetActionItem(theAction:GetID())

	-- 领取 ZNQCJ_20220616_74
	-- ZNQ_ChouJiang_Piao_Btn : SetText( "#{ZNQCJ_20220616_74}" )
	if g_nGetedFlag >= 3 then
		ZNQ_ChouJiang_Piao_Btn : Hide()
		ZNQ_ChouJiang_Piao_Btn : Disable()
		ZNQ_ChouJiang_Piao_Img : Show()
	else
		ZNQ_ChouJiang_Piao_Btn : Show()
		ZNQ_ChouJiang_Piao_Btn : Enable()
		ZNQ_ChouJiang_Piao_Img : Hide()
	end

	-- 倒计时未开始
	if g_nHuoDongDayStep < 2 or (2 == g_nHuoDongDayStep and nCurServerSecondTime < g_nDownTickStart) then
		ZNQ_ChouJiang_Piao_Text : SetText( "#{ZNQCJ_20220616_67}" )
	end

	-- 活动全部结束
	if g_nHuoDongDayStep > 2 or (2 == g_nHuoDongDayStep and nCurServerSecondTime >= g_nRewardTimeEnd) then
		ZNQ_ChouJiang_Piao_Text : SetText( "#{ZNQCJ_20220616_79}" )

		-- ZNQ_ChouJiang_Piao_Btn : SetText( "#{ZNQCJ_20220616_78}" )
		ZNQ_ChouJiang_Piao_Btn : Disable()

		nAutoSelectPage = 3
	end

	-- PushDebugMessage("ZNQ_ChouJiang_Update g_nHuoDongDayStep:"..g_nHuoDongDayStep)

	-- 活动当天
	if 2 == g_nHuoDongDayStep then

		-- 倒计时进行中
		if nCurServerSecondTime >= g_nDownTickStart and nCurServerSecondTime < g_nDownTickEnd then
			-- 全部领完了
			if g_nGetedFlag >= 3 then
				ZNQ_ChouJiang_Piao_Text : SetText( "#{ZNQCJ_20220616_75}" )
				ZNQ_ChouJiang_Piao_Btn : Hide()
				ZNQ_ChouJiang_Piao_Img : Show()
			else
				local nFixTime = nCurServerANSITime - g_nLastSyncServerTime
				local nLeftTime = g_nDownTick - nFixTime
				if nLeftTime < 0 then
					nLeftTime = 0
				end
				local nLeftMinute = math.ceil(nLeftTime / 60)
				local nLeftSecond = math.mod(nLeftTime, 60)
				ZNQ_ChouJiang_Piao_Text : SetText( ScriptGlobal_Format("#{ZNQCJ_20220616_73}", nLeftMinute, nLeftSecond ) )

				if nLeftMinute <= 0  then
					ZNQ_ChouJiang_Piao_Text : SetText( "#{ZNQCJ_20220616_85}" )
				end
			end
		end

		-- 抽奖中
		if nCurServerSecondTime >= g_nRewardTimeStart and nCurServerSecondTime < g_nRewardTimeEnd then
			ZNQ_ChouJiang_Piao_Text : SetText( "#{ZNQCJ_20220616_78}" )

			-- ZNQ_ChouJiang_Piao_Btn : SetText( "#{ZNQCJ_20220616_78}" )
			ZNQ_ChouJiang_Piao_Btn : Disable()
		end
	end

	-- 左侧已领取奖券的显示 x/3
	ZNQ_ChouJiang_Piao_Text2 : Hide()
	ZNQ_ChouJiang_Piao_Text2 : SetText( ScriptGlobal_Format("#{ZNQCJ_20220616_80}", g_nGetedFlag ) )

	-- 领取按钮的红点显示逻辑
	if 1 == g_tHotPointInfo[1] then
		ZNQ_ChouJiang_Piao_Btn_Tips : Show()
	else
		ZNQ_ChouJiang_Piao_Btn_Tips : Hide()
	end

	-- 拥有奖券
	local nHaveTicketCount = PlayerPackage:Lua_GetUnLockItemCount(g_nTicketItemID)
	ZNQ_ChouJiang_PiaoNum : SetText( ScriptGlobal_Format("#{ZNQCJ_20220616_86}", nHaveTicketCount ) )

	ZNQ_ChouJiang_UpdateRight(bOpen, nCurMinute, nAutoSelectPage)
end

function ZNQ_ChouJiang_UpdateRight(bOpen, nCurMinute, nAutoSelectPage)

	local nLocalAutoSelectPage = nAutoSelectPage

	-- 右侧界面逻辑
	for nPage = 1, g_nMaxRewardWave do

		local hTabRewardActionButtonCurPage 	= g_hTabRewardActionButton[nPage]
		local hTabRewardGetedCurPage 			= g_hTabRewardGeted[nPage]
		local hTabRewardDisableCurPage 			= g_hTabRewardDisable[nPage]
		local hTabRewardAnimateCurPage 			= g_hTabRewardAnimate[nPage]
		local tRewardItemInfoCurPage 			= g_tabRewardItemInfo[nPage]

		-- 右侧页签显示
		if nPage == g_nCurPageIndex then
			g_hPageClient[nPage] : Show()
			g_hPageButton[nPage] : SetCheck(1)
		else
			g_hPageClient[nPage] : Hide()
			g_hPageButton[nPage] : SetCheck(0)
		end
	
		-- 右侧页签红点
		g_hPageButtonTips[nPage] : Hide()
		-- 右侧抽奖按钮红点
		g_hJoinAndGetButtonTips[nPage]	: Hide()

		-- 按10进制位存 低位开始 1 领券红点; 2-4 参与红点; 5-7 领奖红点 

		-- 参与红点逻辑
		if 1 == g_tHotPointInfo[nPage + 1] then
			-- 当前页就把红点直接消除了
			if nPage == g_nCurPageIndex then
				ZNQ_ChouJiang_HotPointClicked(nPage)
				g_tHotPointInfo[nPage + 1] = 0
			else
				g_hPageButtonTips[nPage] : Show()	
			end
		end

		-- 领奖红点逻辑
		if 1 == g_tHotPointInfo[4 + nPage] then
			g_hPageButtonTips[nPage] : Show()	
			g_hJoinAndGetButtonTips[nPage] : Show()	
		end

		-- 右侧奖励牴示缺省状态
		for i = 1, g_nMaxRewardLevel do
			local nItemID = tRewardItemInfoCurPage[i].nItemID
			local nItemNum = tRewardItemInfoCurPage[i].nItemNum
			local hActionButton = hTabRewardActionButtonCurPage[i]

			-- ActionButton
			-- local theAction = DataPool:CreateActionItemForShow(nItemID, nItemNum)
			local theAction = DataPool:CreateBindActionItemForShow(nItemID, nItemNum)
			hActionButton : SetActionItem(theAction:GetID())

			-- 奖励状态先全部隐藏 后面的逻辑会选择性牴示
			hTabRewardGetedCurPage[i] 	: Hide()
			hTabRewardDisableCurPage[i] : Hide()
			hTabRewardAnimateCurPage[i] : Hide()
		end

		-- 右侧中奖犨名单缺省状态
		g_hRewardPlayerInfo[1][nPage] 	: SetText( "#{ZNQCJ_20220616_71}" )
		g_hRewardPlayerInfo[2][nPage] 	: SetText( "#{ZNQCJ_20220616_72}" )
		-- g_hRewardPlayerInfo[3][nPage] 	: SetText( "#{ZNQCJ_20220616_72}" )
		-- g_hRewardPlayerInfo[4][nPage] 	: SetText( "#{ZNQCJ_20220616_72}" )

		-- 右侧抽奖提示信息缺省状态	
		g_hRewardIntroText[nPage] 		: SetText( "#{ZNQCJ_20220616_87}" )

		-- 右侧抽奖按钮缺省状态 灰态的投奖
		-- g_hJoinAndGetButton[nPage]		: SetText( "#{ZNQCJ_20220616_17}" )
		-- g_hJoinAndGetButton[nPage]		: Disable()
		-- g_hJoinAndGetButtonD[nPage]		: Hide()

		g_hJoinButton[nPage] 			: Show()
		g_hJoinButton[nPage] 			: Disable()
		g_hGetButton[nPage] 			: Hide()
		g_hGetedRewardPic[nPage] 		: Hide()
		g_hJoinedPic[nPage]				: Hide()
		
		--  获取当前页面的抽奖进程 0 未开始 1 可投奖券 2 等待开奖 3 可领奖
		local nCurPageChouJiangProcess = ZNQ_ChouJiang_GetCurPageChouJiangProcess(nPage)

		-- 0 未开始 时间段保持上述控件的缺省状态

		-- 可投奖券期间
		if 1 == nCurPageChouJiangProcess then
			-- 右侧抽奖提示信息 犫里只计算分钟差 犫个阶段的天和小时是一致的
			local tStepInfoCurPage = g_tabRewardStepInfo[nPage]
			local nShowCountMinute = tStepInfoCurPage.nRewardTimeMinute - nCurMinute
			g_hRewardIntroText[nPage] : SetText( ScriptGlobal_Format("#{ZNQCJ_20220616_18}", nShowCountMinute ) )

			-- 右侧抽奖按钮
			if 1 == g_tJoinRewardInfo[nPage] then
				-- 投了 置灰
				-- g_hJoinAndGetButton[nPage]		: SetText( "#{ZNQCJ_20220616_68}" )
				-- g_hJoinAndGetButton[nPage]		: Disable()
				g_hJoinButton[nPage]		: Hide()
				g_hJoinedPic[nPage]			: Show()
			else
				-- 还没投 点亮
				-- g_hJoinAndGetButton[nPage]		: SetText( "#{ZNQCJ_20220616_17}" )
				-- g_hJoinAndGetButton[nPage]		: Enable()
				g_hJoinButton[nPage] 		: Enable()
			end

			nLocalAutoSelectPage = nPage
		end

		-- 等待开奖期间
		if 2 == nCurPageChouJiangProcess then
			-- 右侧抽奖提示信息
			g_hRewardIntroText[nPage] : SetText( "#{ZNQCJ_20220616_56}" )

			-- 右侧抽奖按钮
			if 1 == g_tJoinRewardInfo[nPage] then
				-- 投了 置灰
				-- g_hJoinAndGetButton[nPage]		: SetText( "#{ZNQCJ_20220616_68}" )
				g_hJoinButton[nPage]		: Hide()
				g_hJoinedPic[nPage]			: Show()
			else
				-- 还没投 置灰
				-- g_hJoinAndGetButton[nPage]		: SetText( "#{ZNQCJ_20220616_17}" )
				g_hJoinButton[nPage]		: Disable()
			end

			nLocalAutoSelectPage = nPage
		end

		--可领奖期间
		if 3 == nCurPageChouJiangProcess then
			-- 右侧抽奖提示信息 已开奖ZNQCJ_20220616_19
			g_hRewardIntroText[nPage] : SetText( "#{ZNQCJ_20220616_19}" )

			-- PushDebugMessage("g_tGetedRewardInfo[nPage]"..g_tGetedRewardInfo[nPage])

			-- 右侧抽奖按钮
			if g_tHaveRewardInfo[nPage] > 0 then
				-- 有奖励
				if 1 == g_tGetedRewardInfo[nPage] then
					-- 领过了
					-- g_hJoinAndGetButton[nPage]		: SetText( "#{ZNQCJ_20220616_70}" )
					-- g_hJoinAndGetButton[nPage]		: Disable()
					g_hJoinButton[nPage]		: Hide()
					g_hGetedRewardPic[nPage] 	: Show()
				else
					-- 没领
					-- g_hJoinAndGetButton[nPage]		: SetText( "#{ZNQCJ_20220616_69}" )
					-- g_hJoinAndGetButton[nPage]		: Enable()
					g_hJoinButton[nPage]		: Hide()
					g_hGetButton[nPage] 		: Show()
				end
			else
				-- 没奖励
				if 1 == g_tJoinRewardInfo[nPage] then
					-- 投了 置灰
					-- g_hJoinAndGetButton[nPage]		: SetText( "#{ZNQCJ_20220616_68}" )
					-- g_hJoinAndGetButton[nPage]		: Disable()
					g_hJoinButton[nPage]		: Hide()
					g_hJoinedPic[nPage]			: Show()
				else
					-- 还没投 置灰
					-- g_hJoinAndGetButton[nPage]		: SetText( "#{ZNQCJ_20220616_17}" )
					-- g_hJoinAndGetButton[nPage]		: Disable()
					g_hJoinButton[nPage]		: Disable()
				end
			end

			-- 右侧奖励牴示
			for i = 1, g_nMaxRewardLevel do

				-- PushDebugMessage("g_tHaveRewardInfo[nPage]"..g_tHaveRewardInfo[nPage])

				local nRewardLevel = g_tHaveRewardInfo[nPage]
				if i == nRewardLevel then
					if 1 == g_tGetedRewardInfo[nPage] then
						-- 领过了
						hTabRewardGetedCurPage[i] 	: Show()
					else
						-- 没领
					end	
					-- 现在犫个表示中奖了
					hTabRewardAnimateCurPage[i] : Show()
				else
					hTabRewardDisableCurPage[i] :Show()
				end				
			end

			-- 右侧中奖犨名单
			-- local tabStrDic = {"#{ZNQCJ_20220616_26}", "#{ZNQCJ_20220616_54}", "#{ZNQCJ_20220616_54}", "#{ZNQCJ_20220616_54}"}
			
			-- 一等奖
			local bRet, nHuoDongRewardDay, nSelfGUID, nValue3, nValue4, strPlayerName, strGuildName = DataPool:Lua_GetAnnWGDataByIndex(1 + (nPage-1) * g_nMaxRewardPlayerNum)

			if nil ~= bRet and 1 == bRet and nHuoDongRewardDay > 0 then
				g_hRewardPlayerInfo[1][nPage] : SetText( ScriptGlobal_Format("#{ZNQCJ_20220616_26}", strPlayerName ) )
			end

			-- 二等奖
			local strAllName = ""
			for i = 2, g_nUseRewardPlayerNum do
				-- x791050_SetWorldGlobalDataEx(sceneId, nDataIndex, 1, x791050_g_nHuoDongRewardDay, nSelfGUID, 0, 0, strPlayerName, strGuildName)
				local bRet, nHuoDongRewardDay, nSelfGUID, nValue3, nValue4, strPlayerName, strGuildName = DataPool:Lua_GetAnnWGDataByIndex(i + (nPage-1) * g_nMaxRewardPlayerNum)

				if nil ~= bRet and 1 == bRet and nHuoDongRewardDay > 0 then
					if "" == strAllName then
						strAllName = strPlayerName
					else
						strAllName = strAllName..","..strPlayerName
					end
				end
			end
			if "" ~= strAllName then
				g_hRewardPlayerInfo[2][nPage] : SetText( ScriptGlobal_Format("#{ZNQCJ_20220616_54}", strAllName ) )
			end

			-- for i = 1, g_nUseRewardPlayerNum do
			-- 	-- x791050_SetWorldGlobalDataEx(sceneId, nDataIndex, 1, x791050_g_nHuoDongRewardDay, nSelfGUID, 0, 0, strPlayerName, strGuildName)
			-- 	local bRet, nHuoDongRewardDay, nSelfGUID, nValue3, nValue4, strPlayerName, strGuildName = DataPool:Lua_GetAnnWGDataByIndex(i + (nPage-1) * g_nMaxRewardPlayerNum)

			-- 	if nil ~= bRet and 1 == bRet and nHuoDongRewardDay > 0 then
			-- 		g_hRewardPlayerInfo[i][nPage] : SetText( ScriptGlobal_Format(tabStrDic[i], strPlayerName ) )
			-- 	end
			-- end
		end
	end

	-- 打开逻辑 自动选择页面
	if 1 == bOpen then
		ZNQ_ChouJiang_OnChangePage(nLocalAutoSelectPage)
	end
	
end

--=========================================================
-- 内部功能函数 获取当前页面的抽奖进程 0 未开始 1 可投奖券 2 等待开奖 3 可领奖
--=========================================================
function ZNQ_ChouJiang_GetCurPageChouJiangProcess(nPage)

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
-- 获取奖券按钮
--=========================================================
function ZNQ_ChouJiang_OnGetTicket()
	-- 1 AskOpenMainUI 请求打开主界面; 2 AskRefreshAllUI 请求刷新所有界面; 3 OnGetTicket 领取活动券; 
	-- 4 OnSubmitTicket(nSelectedStep) 提交活动券; 5 OnGetReward(nSelectedStep) 领取奖励; 
	-- 6 OnClickHelp 帮助; 7 OnHotPointClicked(nSelectedStep) 消除红点事件（参与抽奖点击分页签）

	-- PushDebugMessage("ZNQ_ChouJiang_OnGetTicket")

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(791050)
		Set_XSCRIPT_Parameter(0, 3)								
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--=========================================================
-- 切换页签
--=========================================================
function ZNQ_ChouJiang_OnChangePage(nPageIndex)

	-- PushDebugMessage("ZNQ_ChouJiang_OnChangePage"..nPageIndex)

	if nPageIndex == g_nCurPageIndex then
		return
	end

	-- 红点消除逻辑
	-- 按10进制位存 低位开始 1 领券红点; 2-4 参与红点; 5-7 领奖红点 
	if 1 == g_tHotPointInfo[nPageIndex + 1] then
		ZNQ_ChouJiang_HotPointClicked(nPageIndex)
		g_tHotPointInfo[nPageIndex + 1] = 0
	end

	g_nCurPageIndex = nPageIndex
	ZNQ_ChouJiang_Update(0)
end

--=========================================================
-- 消除红点事件（参与抽奖点击分页签）
--=========================================================
function ZNQ_ChouJiang_HotPointClicked(nSelectedStep)
	-- 1 AskOpenMainUI 请求打开主界面; 2 AskRefreshAllUI 请求刷新所有界面; 3 OnGetTicket 领取活动券; 
	-- 4 OnSubmitTicket(nSelectedStep) 提交活动券; 5 OnGetReward(nSelectedStep) 领取奖励; 
	-- 6 OnClickHelp 帮助; 7 OnHotPointClicked(nSelectedStep) 消除红点事件（参与抽奖点击分页签）
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(791050)
		Set_XSCRIPT_Parameter(0, 7)								
		Set_XSCRIPT_Parameter(1, nSelectedStep)								
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- 参与抽奖和领奖按钮
--=========================================================
function ZNQ_ChouJiang_OnRewardClick(nSelectedStep)

	--  获取当前页面的抽奖进程 0 未开始 1 可投奖券 2 等待开奖 3 可领奖
	local nCurPageChouJiangProcess = ZNQ_ChouJiang_GetCurPageChouJiangProcess(nSelectedStep)

	-- 1 AskOpenMainUI 请求打开主界面; 2 AskRefreshAllUI 请求刷新所有界面; 3 OnGetTicket 领取活动券; 
	-- 4 OnSubmitTicket(nSelectedStep) 提交活动券; 5 OnGetReward(nSelectedStep) 领取奖励; 
	-- 6 OnClickHelp 帮助; 7 OnHotPointClicked(nSelectedStep) 消除红点事件（参与抽奖点击分页签）

	if 1 == nCurPageChouJiangProcess then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnUIEvent" )
			Set_XSCRIPT_ScriptID(791050)
			Set_XSCRIPT_Parameter(0, 4)								
			Set_XSCRIPT_Parameter(1, nSelectedStep)								
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end

	if 3 == nCurPageChouJiangProcess then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnUIEvent" )
			Set_XSCRIPT_ScriptID(791050)
			Set_XSCRIPT_Parameter(0, 5)								
			Set_XSCRIPT_Parameter(1, nSelectedStep)								
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end

end

--=========================================================
-- 帮助按钮
--=========================================================
function ZNQ_ChouJiang_OnClickHelp()
	-- 1 AskOpenMainUI 请求打开主界面; 2 AskRefreshAllUI 请求刷新所有界面; 3 OnGetTicket 领取活动券; 
	-- 4 OnSubmitTicket(nSelectedStep) 提交活动券; 5 OnGetReward(nSelectedStep) 领取奖励; 
	-- 6 OnClickHelp 帮助; 7 OnHotPointClicked(nSelectedStep) 消除红点事件（参与抽奖点击分页签）
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(791050)
		Set_XSCRIPT_Parameter(0, 6)								
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--=========================================================
-- 重置界面
--=========================================================
function ZNQ_ChouJiang_Reset()
	-- g_nCurPageIndex 		= 1
	g_nHuoDongDayStep		= 0
	g_nStartFlag			= 0
	g_nGetedFlag			= 0
	g_nDownTick				= 0
	g_nServerHourToSecond	= 0
	g_nLastSyncServerTime	= 0
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

	-- KillTimer( "ZNQ_ChouJiang_OnTimer()" )
end

--=========================================================
-- 关睜界面
--=========================================================
function ZNQ_ChouJiang_OnClose()	
	this:Hide()
	StopCareObject_ZNQ_ChouJiang()
	-- 重置
	ZNQ_ChouJiang_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="ZNQ_ChouJiang_OnHiden();" />
--=========================================================
function ZNQ_ChouJiang_OnHiden()
	StopCareObject_ZNQ_ChouJiang()
	-- 重置
	ZNQ_ChouJiang_Reset()
end

--=========================================================
-- 关心操作
--=========================================================
function BeginCareObject_ZNQ_ChouJiang()
	-- 关心
	this:CareObject(g_nObjCaredIDClient, 1, "ZNQ_ChouJiang")
end

function StopCareObject_ZNQ_ChouJiang()
	-- 取消关心
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "ZNQ_ChouJiang")
	end
	g_nServerObjID = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function ZNQ_ChouJiang_MoneyUpdate()
	-- ZNQ_ChouJiang_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- ZNQ_ChouJiang_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 元宝刷新：界面更新调用一次 元宝事件调用一次
--=========================================================
function ZNQ_ChouJiang_YuanBaoUpdate()
	-- ZNQ_ChouJiang_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- 界面位置
--=========================================================
function ZNQ_ChouJiang_Frame_On_ResetPos()
	ZNQ_ChouJiang_MainFrame:SetProperty("UnifiedPosition", g_ZNQ_ChouJiang_Frame_UnifiedPosition)
end
