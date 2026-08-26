--!!!reloadscript =Self_AuctionBidding

local g_Self_AuctionBidding_Frame_UnifiedPosition

local g_CurlId = -1

local g_OfferBid = 0
local g_MaxPrice = 9999999

function Self_AuctionBidding_PreLoad()
	this:RegisterEvent("OPEN_WORLD_AUCTION_BIDDING")
	this:RegisterEvent("UPDATE_WORLD_AUCTION_CURRENT_BIDDING")
	this:RegisterEvent("UPDATE_WORLD_AUCTION_CERTAIN_BIDDING")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UPDATE_YUANBAO")
	this:RegisterEvent("UI_COMMAND")
end

function Self_AuctionBidding_OnLoad()
	g_Self_AuctionBidding_Frame_UnifiedPosition = Self_AuctionBidding_Frame:GetProperty("UnifiedPosition")
end

function Self_AuctionBidding_OnEvent(event)

	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end
	
	if event == "OPEN_WORLD_AUCTION_BIDDING" then
		g_CurlId = tonumber(arg0)
		if this:IsVisible() then
			Self_AuctionBidding_Update(0)
			return
		end
		
		this:Show()
		Self_AuctionBidding_Update(0)
		return
	end
	
	if event == "UPDATE_WORLD_AUCTION_CURRENT_BIDDING" and this:IsVisible() then

		g_CurlId = tonumber(arg0)

		Self_AuctionBidding_Update(tonumber(arg1))
	end
	
	if event == "UPDATE_WORLD_AUCTION_CERTAIN_BIDDING" and this:IsVisible() then
		if g_CurlId == tonumber(arg0) then
			Self_AuctionBidding_Update(0)
		end
		PushDebugMessage("#{ZZPM_250325_116}")
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		Self_AuctionBidding_Frame_On_ResetPos()
	end
	
	if event == "UPDATE_YUANBAO" and this:IsVisible() then
		local my_yb = Player:GetData("YUANBAO")
		local strTemp = ScriptGlobal_Format("#{ZZPM_250325_96}", tostring(my_yb))	
		Self_AuctionBidding_YuanbaoNum:SetText(strTemp)
	end

end

--Update
function Self_AuctionBidding_Update(bddingFlag)
	
	local strTemp = ""
	Self_AuctionBidding_CleanUp()
	
	--道具ID
	local nItemTableIndex = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "ITEMID")
	--道具数量
	local uItemNum = 1
	--最高出价
	local nHighPrice = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "TOPBID")
	--当前时间标志
	local nTimeFlag = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "TIMEFLAG")
	--底价
	local nBaseValue = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "BASEPRICE")
	--是否有人出价
	local nHaveBid = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "HAVEBID")
	--当前是否是最高出价人
	local bIsTop = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "ISTOP")
	--加价幅度
	local nMinAdd = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "MINADD")
	
	if nHaveBid == 1 then
		nMinAdd = math.ceil(nHighPrice * 0.05)
		g_OfferBid = nHighPrice + nMinAdd
		if g_OfferBid > g_MaxPrice then
			g_OfferBid = g_MaxPrice
		end
	else
		g_OfferBid = nBaseValue
	end
	
	Self_AuctionBidding_Item:SetActionItem(-1)
	local theAction = DataPool:CreateActionItemForShow(nItemTableIndex, 1)
	if theAction:GetID() ~= 0 then
		Self_AuctionBidding_Item:SetActionItem(theAction:GetID())
	end
	
	local item_name = DataPool:Lua_GetItemNameByIndex(nItemTableIndex)

	strTemp = ScriptGlobal_Format("#{ZZPM_250325_80}", item_name)
	Self_AuctionBidding_ItemInfo_Text1:SetText(strTemp)
	
	Self_AuctionBidding_ItemInfo_Text2:SetText("#{ZZPM_250325_81}")

	-- 当前还没有开始竞拍
	if nTimeFlag < 4 then
		strTemp = ScriptGlobal_Format("#{ZZPM_250325_84}", tostring(nBaseValue))
		Self_AuctionBidding_HighestNum:SetText(strTemp)
		Self_AuctionBidding_MineNum:SetText("#{ZZPM_250325_87}")

	--竞拍当中
	elseif nTimeFlag >= 4 then
		if nHaveBid == 0 then
			strTemp = ScriptGlobal_Format("#{ZZPM_250325_84}", tostring(nBaseValue))
			Self_AuctionBidding_HighestNum:SetText(strTemp)
			Self_AuctionBidding_MineNum:SetText("#{ZZPM_250325_87}")
		else
			if bIsTop == 1 then
				strTemp = ScriptGlobal_Format("#{ZZPM_250325_84}", tostring(nHighPrice))
				Self_AuctionBidding_HighestNum:SetText(strTemp)
				Self_AuctionBidding_MineNum:SetText("#{ZZPM_250325_86}")
			else
				strTemp = ScriptGlobal_Format("#{ZZPM_250325_84}", tostring(nHighPrice))
				Self_AuctionBidding_HighestNum:SetText(strTemp)
				Self_AuctionBidding_MineNum:SetText("#{ZZPM_250325_87}")
			end
		end
	end
	
	local my_yb = Player:GetData("YUANBAO")
	strTemp = ScriptGlobal_Format("#{ZZPM_250325_96}", tostring(my_yb))	
	Self_AuctionBidding_YuanbaoNum:SetText(strTemp)
	
	if nTimeFlag < 5 then
		Self_AuctionBidding_NotStarted:Show()
		Self_AuctionBidding_NumBK:Hide()
		Self_AuctionBidding_ButtonFrame:Hide()

		local nBidding = 	DataPool:LuaFnGetWorldAuctionGetTime(2)
		local nBiddMouthTemp = math.mod(nBidding,10000)
		local nBiddMouth = math.floor(nBiddMouthTemp/100) 
		local nBiddDay = math.mod(nBiddMouthTemp,100)	
		Self_AuctionBidding_NotStarted:SetText(ScriptGlobal_Format("#{ZZPM_250325_99}",nBiddMouth, nBiddDay))

	elseif nTimeFlag == 5 or nTimeFlag == 6 then
		Self_AuctionBidding_NotStarted:Hide()
		Self_AuctionBidding_NumBK:Show()
		Self_AuctionBidding_ButtonFrame:Show()
	else
		Self_AuctionBidding_NotStarted:Show()
		Self_AuctionBidding_NumBK:Hide()
		Self_AuctionBidding_ButtonFrame:Hide()
	
		Self_AuctionBidding_NotStarted:SetText("#{ZZPM_250325_100}")
	end
	

	strTemp = ScriptGlobal_Format("#{ZZPM_250325_98}", tostring(nMinAdd))
	Self_AuctionBidding_RaiseSub:SetToolTip(strTemp)
	strTemp = ScriptGlobal_Format("#{ZZPM_250325_97}", tostring(nMinAdd))
	Self_AuctionBidding_RaiseAdd:SetToolTip(strTemp)

	
	Self_AuctionBidding_Num:SetText(tostring(g_OfferBid))
	local nMinValue = 0
	local nMaxValue = Player:GetData("YUANBAO")
	
	if nHaveBid == 0 then
		nMinValue = nBaseValue
	else
		nMinValue = nHighPrice + nMinAdd
	end
	
	-- 默认灰
	if g_OfferBid > 0 then
		Self_AuctionBidding_RaiseSub:Disable()
	end
	
	if g_OfferBid >= nMaxValue then
		Self_AuctionBidding_RaiseAdd:Disable()
	else
		Self_AuctionBidding_RaiseAdd:Enable()
	end
	
	if g_OfferBid < nMinValue then
		if g_OfferBid == g_MaxPrice and nMinValue > g_MaxPrice then
			Self_AuctionBidding_Submit:Enable()
		else
			Self_AuctionBidding_Submit:Disable()
		end
	else
		Self_AuctionBidding_Submit:Enable()
	end
	
	local CountDownTime = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "COUNTDOWN")
	Self_AuctionBidding_ItemInfo_StopWatch:SetProperty("Timer", tostring(CountDownTime))

	if bddingFlag == 1 then
		Self_AuctionBidding_HighestAnimate:Show()
		Self_AuctionBidding_HighestAnimate:Play(true)
	else
		Self_AuctionBidding_HighestAnimate:Play(false)
	end
end

-- 刷新一下界面
function Self_AuctionBidding_TimeOut()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenBidUI")
		Set_XSCRIPT_ScriptID(999799)
		Set_XSCRIPT_Parameter(0, 0)								--??
		Set_XSCRIPT_Parameter(1, tonumber(g_CurlId))		--??
		Set_XSCRIPT_Parameter(2, 2)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Self_AuctionBidding_CleanUp()
	Self_AuctionBidding_Item:SetActionItem(-1)
	Self_AuctionBidding_NotStarted:Hide()
	Self_AuctionBidding_NumBK:Hide()
	Self_AuctionBidding_ButtonFrame:Hide()
end

function Self_AuctionBidding_CloseClicked()
	this:Hide()
end

function Self_AuctionBidding_OnHidden()
	Self_AuctionBidding_CleanUp()
end

function Self_AuctionBidding_AddYuanBao(flag)
	
	--最高出价
	local nHighPrice = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "TOPBID")
	--底价
	local nBaseValue = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "BASEPRICE")
	--是否有人出价
	local nHaveBid = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "HAVEBID")
	--加价幅度
	local nMinAdd = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "MINADD")
	
	local nMinValue = 0
	local nMaxValue = Player:GetData("YUANBAO")
	
	if nHaveBid == 0 then
		nMinValue = nBaseValue
	else
		nMinAdd = math.ceil(nHighPrice * 0.05)
		nMinValue = nHighPrice + nMinAdd
	end
	
	local nString = Self_AuctionBidding_Num:GetText()
	local nCurNum = 0
	if nString == nil or nString == "" then
		nCurNum = 0
	else
		nCurNum = tonumber(nString)
	end

	if flag == 0 then
		if nCurNum > nMinValue then
			nCurNum = nCurNum - nMinAdd
			if nCurNum < nMinValue then
				nCurNum = nMinValue
			end
			g_OfferBid = nCurNum
			Self_AuctionBidding_Num:SetText(tostring(g_OfferBid))
		end
	else
		if nCurNum < nMaxValue then
			nCurNum = nCurNum + nMinAdd
			if nCurNum > nMaxValue then
				nCurNum = nMaxValue
			end
			g_OfferBid = nCurNum
			Self_AuctionBidding_Num:SetText(tostring(g_OfferBid))
		end
	end
	
	if g_OfferBid <= 0 then
		if g_OfferBid == g_MaxPrice and nMinValue > g_MaxPrice then
			Self_AuctionBidding_Submit:Enable()
		else
			Self_AuctionBidding_Submit:Disable()
		end
	else
		if g_OfferBid == nMinValue then
			Self_AuctionBidding_RaiseSub:Disable()
		else
			Self_AuctionBidding_RaiseSub:Enable()
		end
	end
	
	if g_OfferBid >= nMaxValue then
		Self_AuctionBidding_RaiseAdd:Disable()
	else
		Self_AuctionBidding_RaiseAdd:Enable()
	end
	
	if g_OfferBid < nMinValue then
		Self_AuctionBidding_Submit:Disable()
	else
		Self_AuctionBidding_Submit:Enable()
	end
	
end

function Self_AuctionBidding_TextChanged()
	local nString = Self_AuctionBidding_Num:GetText()
	if nString == nil or nString == "" then
		Self_AuctionBidding_Submit:Disable()
		Self_AuctionBidding_RaiseSub:Disable()
		Self_AuctionBidding_RaiseAdd:Enable()
		return
	end
	
	--最高出价
	local nHighPrice = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "TOPBID")
	--底价
	local nBaseValue = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "BASEPRICE")
	--是否有人出价
	local nHaveBid = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "HAVEBID")
	--加价幅度
	local nMinAdd = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "MINADD")
	
	local nMinValue = 0
	local nMaxValue = Player:GetData("YUANBAO")
	
	if nHaveBid == 0 then
		nMinValue = nBaseValue
	else
		nMinAdd = math.ceil(nHighPrice * 0.05)
		nMinValue = nHighPrice + nMinAdd
	end

	local nChangNum = tonumber(nString)
	
	local nMaxValue = Player:GetData("YUANBAO")
	if nChangNum >= nMaxValue then
		nChangNum = nMaxValue
	end
	
	if g_OfferBid ~= tonumber(nString) then
		g_OfferBid = nChangNum
		Self_AuctionBidding_Num:SetText(tostring(g_OfferBid))
	end
	
	if g_OfferBid <= 0 then
		if g_OfferBid == g_MaxPrice and nMinValue > g_MaxPrice then
			Self_AuctionBidding_Submit:Enable()
		else
			Self_AuctionBidding_Submit:Disable()
		end
	else
		Self_AuctionBidding_RaiseSub:Enable()
	end
	
	if g_OfferBid >= nMaxValue then
		Self_AuctionBidding_RaiseAdd:Disable()
	else
		Self_AuctionBidding_RaiseAdd:Enable()
	end
	
	if g_OfferBid < nMinValue then
		Self_AuctionBidding_Submit:Disable()
	else
		Self_AuctionBidding_Submit:Enable()
	end
end

function Self_AuctionBidding_Refresh()

	--当前时间标志
	local nTimeFlag = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "TIMEFLAG")
	if nTimeFlag ~= 5 and nTimeFlag ~= 6 then
		PushDebugMessage("#{ZZPM_250325_91}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenBidUI")
		Set_XSCRIPT_ScriptID(999799)
		Set_XSCRIPT_Parameter(0, 0)								--??
		Set_XSCRIPT_Parameter(1, tonumber(g_CurlId))		--??
		Set_XSCRIPT_Parameter(2, 1)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Self_AuctionBidding_DoBidding()
	local nString = Self_AuctionBidding_Num:GetText()
	if nString == nil or nString == "" then
		return
	end
	
	--最高出价
	local nHighPrice = DataPool:LuaFnGetWorldAuctionBiddingInfo(g_CurlId, "TOPBID")
	--底价
	local nBaseValue = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "BASEPRICE")
	--是否有人出价
	local nHaveBid = DataPool:LuaFnGetWorldAuctionBiddingInfo( g_CurlId, "HAVEBID")
	--加价幅度
	local nMinAdd = DataPool:LuaFnGetWorldAuctionBiddingInfo(g_CurlId, "MINADD")
	
	local nMinValue = 0
	local nMaxValue = Player:GetData("YUANBAO")
	
	if nHaveBid == 0 then
		nMinValue = nBaseValue
	else
		nMinAdd = math.ceil(nHighPrice * 0.05)
		nMinValue = nHighPrice + nMinAdd
	end
	
	if nMinValue <= g_MaxPrice then
		if tonumber(nString) < nMinValue then
			return
		end
	else
		if tonumber(nString) < g_MaxPrice then
			return
		end
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("NewBidding")
		Set_XSCRIPT_ScriptID(999799)
		Set_XSCRIPT_Parameter(0, tonumber(g_CurlId))		--??
		Set_XSCRIPT_Parameter(1, tonumber(nString))				--??
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function Self_AuctionBidding_Frame_On_ResetPos()
	Self_AuctionBidding_Frame:SetProperty("UnifiedPosition", g_Self_AuctionBidding_Frame_UnifiedPosition)
end
