local m_Item_Idx = -1
local m_minPrice = 1000000
local m_maxPrice = 9999999
local g_Self_AuctionUpItem_Frame_UnifiedPosition

-----------------------------------------------------------------------
-- OnGameEvent
-----------------------------------------------------------------------

function Self_Auction_UpItem_PreLoad()
	this:RegisterEvent("OPEN_WORLD_AUCITON_UP_ITEM")
	this:RegisterEvent("CLOSE_UP_ITEM")
	this:RegisterEvent("UPDATE_UP_ITEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UI_COMMAND")	
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Self_Auction_UpItem_OnLoad()
	g_Self_AuctionUpItem_Frame_UnifiedPosition = Self_Auction_UpItem_Frame:GetProperty("UnifiedPosition")
	--Self_Auction_UpItem_Frame:SetProperty("AlwaysOnTop","True");
end

function Self_Auction_UpItem_OnEvent(event)
	if event == "OPEN_WORLD_AUCITON_UP_ITEM"  then
		if this:IsVisible() then
			Self_Auction_UpItem_Update(m_Item_Idx)
			Self_Auction_UpItem_Frame:SetForce()
			return
		end
		Self_Auction_UpItem_Update(-1)
		this:Show()
	elseif event == "UPDATE_UP_ITEM" and this:IsVisible() then
		if arg0 ~= nil then
			Self_Auction_UpItem_Update( tonumber(arg0) )
		end
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Item_Idx then
			Self_Auction_UpItem_Update(m_Item_Idx)
		end 
	elseif event == "CLOSE_UP_ITEM" and this:IsVisible() then
		this:Hide()	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99979904 then	
		this:Hide()	
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			-- 更新背包界面位置
		Self_AuctionUpItem_Frame_On_ResetPos()
	end
end


function Self_AuctionUpItem_Frame_On_ResetPos()
	Self_Auction_UpItem_Frame:SetProperty("UnifiedPosition", g_Self_AuctionUpItem_Frame_UnifiedPosition)
end
----------------------------------------------------------------------
-- on events
-----------------------------------------------------------------------

function Self_Auction_UpItem_OK_Clicked()
	local price = Self_Auction_UpItem_Moral_Value:GetText()
	if m_Item_Idx ~= -1 and price ~= "" and tonumber(price) > 0  then
		--安全时间
		if tonumber(DataPool:GetLeftProtectTime()) > 0 then
			PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
			return
		end
		--小于30级
		if  Player:GetData("LEVEL") < 30 then
			PushDebugMessage("#{ZZPM_250325_06}")
			return
		end

		--不是可以售卖得商品
		if  DataPool:LuaFnIsWorldAuctionItemByIndex(m_Item_Idx) ~= 1 then
			PushDebugMessage("#{ZZPM_250325_57}")
			return
		end

		--绑定了
		local isBind = GetItemBindStatus(m_Item_Idx)
		if isBind ~= nil and isBind == 1 then
			PushDebugMessage("#{YBSC_100111_46}")
			return
		end

		--输入价格错误
		if tonumber(price) < m_minPrice or tonumber(price) > m_maxPrice then
			PushDebugMessage("#{ZZPM_250325_62}")
			return
		end

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("UpItemByWorldAuction")
			Set_XSCRIPT_ScriptID(999799)
			Set_XSCRIPT_Parameter(0, m_Item_Idx)
			Set_XSCRIPT_Parameter(1, tonumber(price))
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()

	end
end


function Self_Auction_UpItem_Cancel_Clicked()
	this:Hide()
end


function Self_Auction_UpItem_Count_Change()
	Self_Auction_UpItem_Refresh_Bn_and_Money()
end

function Self_Auction_UpItem_OnHidden()
	Self_Auction_UpItem_Object:SetActionItem(-1);			
	LifeAbility : Lock_Packet_Item(m_Item_Idx,0);		
	m_Item_Idx = -1;
	Self_Auction_UpItem_Moral_Value:SetText("")
	Self_Auction_UpItem_OK:Disable()

	if(IsWindowShow("Packet")) then
		CloseWindow("Packet", true);
	end 
end
-----------------------------------------------------------------------
--private function
-----------------------------------------------------------------------
function Self_Auction_UpItem_Update(itemIdx)	
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if PlayerPackage:IsLock( itemIdx ) == 1 then
			PushDebugMessage("物品已加锁")	--道具已上锁
			return
		end

		--不是可以售卖得商品
		if  DataPool:LuaFnIsWorldAuctionItemByIndex(itemIdx) ~= 1 then
			PushDebugMessage("#{ZZPM_250325_57}")
			return
		end
			
		if m_Item_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Item_Idx,0);
		end
		
		Self_Auction_UpItem_Object:SetActionItem(theAction:GetID());
		
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Item_Idx = itemIdx
	else
		
		Self_Auction_UpItem_Object:SetActionItem(-1);
		
		LifeAbility : Lock_Packet_Item(m_Item_Idx,0);		
		m_Item_Idx = -1;
	end
	Self_Auction_UpItem_Refresh_Bn_and_Money()
end


function Self_Auction_UpItem_Refresh_Bn_and_Money()

	local price = Self_Auction_UpItem_Moral_Value:GetText()
	if m_Item_Idx ~= -1 and price ~= "" and tonumber(price) > 0 then
		Self_Auction_UpItem_OK:Enable()
		local nMoney = Auction:GetNeedMoneyForSell(tonumber(price))
	else
		Self_Auction_UpItem_OK:Disable()
	end
end

