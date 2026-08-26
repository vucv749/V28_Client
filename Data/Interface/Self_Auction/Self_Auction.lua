--!!!reloadscript =Self_Auction

local g_Self_Auction_Frame_UnifiedPosition

local g_MaxPageCount = 5
local g_PageButtons = {}
local g_BarList = {}

local g_CurSectionTimeFlag = 0
local g_LastItemCount = 0


local g_SelfCloth = 10126025
local g_ItemForSell = 10142940


local g_CurShowImageIndex = 1

function Self_Auction_PreLoad()
	this:RegisterEvent("OPEN_WORLD_AUCTION_LIST")
	this:RegisterEvent("UPDATE_WORLD_AUCTION_CURRENT_LIST")
	this:RegisterEvent("UPDATE_WORLD_AUCTION_CERTAIN_LIST")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UPDATE_YUANBAO")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("REFRESH_WORLD_AUCTION_FOLLOW")
end

function Self_Auction_OnLoad()
	g_Self_Auction_Frame_UnifiedPosition = Self_Auction_Frame:GetProperty("UnifiedPosition")

	Self_Auction_Search:AddTextItem("#{ZQPM_240402_130}", 0)
	Self_Auction_Search:AddTextItem("#{ZQPM_240402_131}", 1)
	Self_Auction_Search:AddTextItem("#{ZQPM_240402_132}", 2)
end


function Self_Auction_OnShown(bHaveItem,bHaveYb)

	-- 设置元宝数量
	local strYuanBao = ScriptGlobal_Format("#{ZZPM_250325_44}", tostring(Player:GetData("YUANBAO")))
	Self_Auction_Page1_YuanbaoText:SetText(strYuanBao)


	local nUpBeginHour = 	DataPool:LuaFnGetWorldAuctionGetTime(0)
	local nUpEndHour = 	DataPool:LuaFnGetWorldAuctionGetTime(1)
	local nBiddingHour = 	DataPool:LuaFnGetWorldAuctionGetTime(3)
	local nBidding = 	DataPool:LuaFnGetWorldAuctionGetTime(2)

	local nBiddMouthTemp = math.mod(nBidding,10000)
	local nBiddMouth = math.floor(nBiddMouthTemp/100) 
	local nBiddDay = math.mod(nBiddMouthTemp,100)	
	Self_Auction_Frame1_Info:SetText(ScriptGlobal_Format("#{ZZPM_250325_09}", nBiddMouth,nBiddDay,nUpBeginHour,nUpEndHour,nBiddingHour))

	Self_Auction_DragTitle:SetText("#{ZZPM_250325_08}")
		
	local nowType = DataPool:LuaFnGetWorldAuctionTopBidSortType()
	Self_Auction_Search:SetCurrentSelect(nowType)

	if bHaveYb == 1 then
		Self_Auction_Page1_ReceiveYuanbaoTip:Show()
	else
		Self_Auction_Page1_ReceiveYuanbaoTip:Hide()
	end
	
	if bHaveItem == 1 then
		Self_Auction_Page1_ReceivePropTip:Show()
	else
		Self_Auction_Page1_ReceivePropTip:Hide()
	end
end

function Self_Auction_OnEvent(event)

	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end
	
	if event == "OPEN_WORLD_AUCTION_LIST" then
		if this:IsVisible() then
			this:Hide()
			return
		end
		this:Show()
		local bHaveItem = tonumber(arg0)
		local bHaveYb = tonumber(arg1)

		Self_Auction_OnShown(bHaveItem,bHaveYb)
		Self_Auction_Update()
		return
	end
	
	if event == "UPDATE_WORLD_AUCTION_CURRENT_LIST" and this:IsVisible() then
		Self_Auction_Update()
		return
	end
	
	if event == "UPDATE_WORLD_AUCTION_CERTAIN_LIST" and this:IsVisible() then
		Self_Auction_Update()
		return
	end
	
	if event == "REFRESH_WORLD_AUCTION_FOLLOW" and this:IsVisible() then
		Self_Auction_Update()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		Self_Auction_Frame_On_ResetPos()
	end
	
	if event == "UPDATE_YUANBAO" and this:IsVisible() then
		local strYuanBao = ScriptGlobal_Format("#{SZPM_230913_31}", tostring(Player:GetData("YUANBAO")))
		Self_Auction_Page1_YuanbaoText:SetText(strYuanBao)
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 99979901 then
		local have_reciveItem = Get_XParam_INT(0)
		local have_reciveYb = Get_XParam_INT(1)
		
		if have_reciveYb == 1 then
			Self_Auction_Page1_ReceiveYuanbaoTip:Show()
		else
			Self_Auction_Page1_ReceiveYuanbaoTip:Hide()
		end
		
		if have_reciveItem == 1 then
			Self_Auction_Page1_ReceivePropTip:Show()
		else
			Self_Auction_Page1_ReceivePropTip:Hide()
		end
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 99979902 then
		this:Hide()
	end
	
end

--Update
function Self_Auction_Update()
	-- 清繝现有得数据信息
	Self_Auction_List_CleanUp()

	-- 设置当前列数
	g_LastItemCount = DataPool:LuaFnGetWorldAuctionListCount()
	
	local all_set = 1
	local bid_start = 0
	for i = 1, g_LastItemCount do	
		local nId  = DataPool:LuaFnGetWorldAuctionIdByIndex(i - 1)
		if nId < 0  then
			break
		end
		
		Self_Auction_AddItem(i,nId)
	end
end

function Self_Auction_AddItem(idx,nId)

	local new_bar = Self_Auction_Page1_List:AddChild("Self_Auction_Page1_ListItem")	
	g_BarList[idx] = new_bar
	
	--道具ID
	local nItemTableIndex = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "ITEMID")
	--道具数量
	local uItemNum = 1
	--最高出价
	local nHighPrice = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "TOPBID")
	--最高出价人袪名
	local nHighName = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "NAME")
	--最高出价人的世界号
	local nHighZoneWorld = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId,"TOPWORLD")
	--当前时间标志
	local nTimeFlag = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "TIMEFLAG")
	--底价
	local nBaseValue = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "BASEPRICE")
	--是否有人出价
	local nHaveBid = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "HAVEBID")
	--当前是否是最高出价人
	local bIsTop = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId,"ISTOP")
	--是否关注
	local bFollowed = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId,"FOLLOW")
	--是否是我出售的
	local bIsMySell = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId,"ISMYSELL")

	new_bar:GetSubItem("Self_Auction_Page1_ListItem_Collect"):SetEvent("MouseButtonUp", string.format("Self_Auction_Follow(%d)", idx))
	
	new_bar:GetSubItem("Self_Auction_Page1_ListItem_Icon_Tips"):SetEvent("Clicked", string.format("Self_Auction_Preview(%d)", idx))

	new_bar:GetSubItem("Self_Auction_Page1_XiaJia"):Hide()
	new_bar:GetSubItem("Self_Auction_Page1_XiaJia"):SetEvent("Clicked", string.format("Self_Auction_Page1_XiaJia_Clicked(%d)", idx))
	if bIsMySell  == 1 then
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Collect"):Disable()

		if  nTimeFlag == 2 then
			new_bar:GetSubItem("Self_Auction_Page1_XiaJia"):Show()
			new_bar:GetSubItem("Self_Auction_Page1_ListItem_TipsIcon"):Hide()
		else
			new_bar:GetSubItem("Self_Auction_Page1_ListItem_TipsIcon"):Show()
		end
	else
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Collect"):Enable()
		if bFollowed == 1 then
			new_bar:GetSubItem("Self_Auction_Page1_ListItem_Collect"):SetCheck(1)
		else
			new_bar:GetSubItem("Self_Auction_Page1_ListItem_Collect"):SetCheck(0)
		end

		new_bar:GetSubItem("Self_Auction_Page1_ListItem_TipsIcon"):Hide()
	end

	local theAction = DataPool:CreateActionItemForShow(nItemTableIndex, uItemNum)
	if theAction:GetID() ~= 0 then
		local ctrlAction = new_bar:GetSubItem("Self_Auction_Page1_ListItem_Icon")
		if ctrlAction ~= nil then
			ctrlAction:SetActionItem(theAction:GetID())
		end
	end
	-- 名字处理
	local strName = DataPool:LuaFnGetWorldAuctionItemNameById(nItemTableIndex)
	if strName == nil then
		local item_name = DataPool:Lua_GetItemNameByIndex(nItemTableIndex)
		local strTemp = tostring(item_name)
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text1"):SetText( "#cfff263"..strTemp)
	else
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text1"):SetText("#cfff263"..strName)
	end


	--local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nItemTableIndex, "NumberStr")
	--new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text1Num"):SetText(tostring(nFashionNumber))

	if nHaveBid == 0 then
		local strNum = tostring(nBaseValue)
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text2"):SetText("#cfff263"..strNum)
	else
		if bIsTop == 1 then
			local strNum = "#cfff263" .. tostring(nHighPrice)
			new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text2"):SetText(strNum)
		else
			local strNum = "#cfff263" .. tostring(nHighPrice)
			new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text2"):SetText(strNum)
		end
	end
	
	if nTimeFlag  <= 4 then
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text3"):SetText("#{ZZPM_250325_29}")
	else
		if nHaveBid == 0 then
			new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text3"):SetText("#{ZZPM_250325_30}")
		else
			if bIsTop == 1 then
				new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text3"):SetText("#{ZZPM_250325_31}")
			else
				new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text3"):SetText("#{ZZPM_250325_32}")
			end
		end
	end
	
	if nTimeFlag  <= 4 then
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Name"):SetText("#{ZZPM_250325_36}")
	else
		if nHaveBid == 0 then
			new_bar:GetSubItem("Self_Auction_Page1_ListItem_Name"):SetText("#{ZZPM_250325_39}")
		else
			if nTimeFlag  <= 6 then
				if bIsTop == 1 then
					local my_name = Player:GetName()
					new_bar:GetSubItem("Self_Auction_Page1_ListItem_Name"):SetText("#cfff263"..tostring(my_name))
				else
					new_bar:GetSubItem("Self_Auction_Page1_ListItem_Name"):SetText("#{ZZPM_250325_38}")
				end
			elseif nTimeFlag > 6 then
				if tonumber(nHighZoneWorld) ~= nil and tonumber(nHighZoneWorld) >= 0 then
					local myZoneWorld = DataPool:GetSelfZoneWorldID()
					if myZoneWorld ~= nHighZoneWorld then
						local strHighZoneWorldName = DataPool:GetServerName(tonumber(nHighZoneWorld))
						nHighName = nHighName.."@"..tostring(strHighZoneWorldName)
					end
				end
				local strHightName = tostring(nHighName)
				new_bar:GetSubItem("Self_Auction_Page1_ListItem_Name"):SetText("#cfff263"..strHightName)
			else
				new_bar:GetSubItem("Self_Auction_Page1_ListItem_Name"):SetText("#{ZZPM_250325_39}")
			end
		end
	end
	
	new_bar:GetSubItem("Self_Auction_Page1_ListItem_Button"):Hide()
	new_bar:GetSubItem("Self_Auction_Page1_ListItem_Button"):SetEvent( "Clicked", string.format("Self_Auction_OpenBidUI(%d)", idx))
	
	--PushDebugMessage(tostring(nTimeFlag))
	if nTimeFlag  <= 4 then
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_BeforeText"):Show()
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_BeforeText"):SetText("#{ZZPM_250325_33}")

		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text4"):Hide()
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Button"):Hide()
	elseif nTimeFlag == 5 or nTimeFlag == 6 then
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_BeforeText"):Hide()
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text4"):Hide()
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Button"):Show()

		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Button"):SetText("#{ZZPM_250325_34}")
	else
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_BeforeText"):Hide()
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Text4"):Show()
		new_bar:GetSubItem("Self_Auction_Page1_ListItem_Button"):Hide()
	end
end

-- 竞价
function Self_Auction_OpenBidUI(idx)

	local nId = DataPool:LuaFnGetWorldAuctionIdByIndex(idx - 1)

	local bIsMySell = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId,"ISMYSELL")
	if bIsMySell == 1 then
		PushDebugMessage("#{ZZPM_250325_122}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenBidUI")
		Set_XSCRIPT_ScriptID(999799)
		Set_XSCRIPT_Parameter(0, 1)				--??
		Set_XSCRIPT_Parameter(1, nId)	--??
		Set_XSCRIPT_Parameter(2, 0)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

-- 关注
function Self_Auction_Follow(idx)
	local nId = DataPool:LuaFnGetWorldAuctionIdByIndex(idx - 1)
	local bid_id = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "BIDINDEX")
	local bFollowed = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "FOLLOW")

	local bIsMySell = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId,"ISMYSELL")
	if bIsMySell == 1 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Follow")
		Set_XSCRIPT_ScriptID(999799)
		Set_XSCRIPT_Parameter(0, bid_id)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	
	if g_BarList[idx] ~= nil then
		if bFollowed == 1 then
			g_BarList[idx]:GetSubItem("Self_Auction_Page1_ListItem_Collect"):SetCheck(1)
		else
			g_BarList[idx]:GetSubItem("Self_Auction_Page1_ListItem_Collect"):SetCheck(0)
		end
	end
end

-- 上架
function Self_Auction_Page1_ShangJia_Clicked() 
	local IsOpenTime = DataPool:LuaFnGetWorldAuctionIsUpItemTime()
	if IsOpenTime == 0 then
		PushDebugMessage("#{ZZPM_250325_05}")
		return
	end
	PushEvent("OPEN_WORLD_AUCITON_UP_ITEM")
	OpenWindow("Packet")
end

function Self_Auction_Preview(idx)
	local nId = DataPool:LuaFnGetWorldAuctionIdByIndex(idx - 1)
	local nItemTableIndex = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId,   "ITEMID")


	if tonumber(nItemTableIndex) ~= nil then
		local nExteriorRideId = Exterior:LuaFnGetExteriorIdByItem(tonumber(nItemTableIndex)) -- ??
		if(nExteriorRideId ~= 0) then
			PushEvent("OPEN_RIDE_PREVIEW", nExteriorRideId)
		else
			PushEvent("OPEN_DRESSPREVIEW", tonumber(nItemTableIndex), 111, 75) --??\??\??
		end
	end
end

function Self_Auction_List_CleanUp()
	for i = 1 , g_LastItemCount do
		if g_BarList[i] then
			local ctrlAction = g_BarList[i]:GetSubItem("Self_Auction_Page1_ListItem_Icon")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end
	end
	
	g_BarList = {}
	Self_Auction_Page1_List:Clear()
end

function Self_Auction_CloseClicked()
	this:Hide()
end

function Self_Auction_OnHidden()
	Self_Auction_List_CleanUp()
	CloseWindow("Self_AuctionBidding", true)
	CloseWindow("Self_Auction_UpItem", true)
	--默认排序
	DataPool:LuaFnSetWorldAuctionTopBidSortType(0)
end

function Self_Auction_Help_Clicked()
end

function Self_Auction_Help_Btn_Clicked()
	PushEvent("OPEN_SWEEPPAGE_QUEST", "Self_Auction_Help")
end

-- 刷新
function Self_Auction_Shuaxin()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("TryOpenWorldAuction")
		Set_XSCRIPT_ScriptID(999799)
		Set_XSCRIPT_Parameter(0, 0)
		Set_XSCRIPT_Parameter(1, 1) --?????cd??
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

-- 领取物品
function Self_Auction_Get_Self()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("TakeBonusWorld")
		Set_XSCRIPT_ScriptID(999799)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--领取元宝
function Self_Auction_Get_YuanBao()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("TakeBackYuanBao")
		Set_XSCRIPT_ScriptID(999799)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end


function Self_Auction_Preview_Click()

	PushEvent("OPEN_DRESSPREVIEW", g_SelfCloth, 111, 75) --??\??\??
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function Self_Auction_Frame_On_ResetPos()
	Self_Auction_Frame:SetProperty("UnifiedPosition", g_Self_Auction_Frame_UnifiedPosition)
end

function Self_Auction_Type_Changed()
	local str, nIndex = Self_Auction_Search:GetCurrentSelect()
	local nowType = DataPool:LuaFnGetWorldAuctionTopBidSortType()
	if nowType ~= nIndex then
		DataPool:LuaFnSetWorldAuctionTopBidSortType(nIndex)
		DataPool:LuaFnSortWorldAuctionList()
		Self_Auction_Update()
	end
end

-- 下架物品
function Self_Auction_Page1_XiaJia_Clicked(idx)
	if idx < 0 then
		PushDebugMessage("#{ZZPM_250325_136}")
		return
	end

	local nId = DataPool:LuaFnGetWorldAuctionIdByIndex(idx - 1)
	local bIsMySell = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId,"ISMYSELL")

	if bIsMySell ~= 1 then
		PushDebugMessage("#{ZZPM_250325_137}")
		return
	end

	local nItemTableIndex = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "ITEMID")
	--底价
	local nBaseValue = DataPool:LuaFnGetWorldAuctionBiddingInfo(nId, "BASEPRICE")

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UnderItemByClient")
		Set_XSCRIPT_ScriptID(999799)
		Set_XSCRIPT_Parameter(0, nId)
		Set_XSCRIPT_Parameter(1, nItemTableIndex)
		Set_XSCRIPT_Parameter(2, nBaseValue)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end
