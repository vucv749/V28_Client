--付费商店改造，元宝商店批量购买 by liuyong
-- !!!reloadscript =Shop_MBuy

local CU_YUANBAO			= 5	-- 钱
local g_MaxBuyNum_PerTime = 7500		-- 这个不是常量，打开窗口的时候会根据商店重新初始化，但最大7500
local g_ItemMax = 0;
local g_ItemIdx = -1;
local g_ItemTableIdx = -1;
local g_ItemDefaultNum = 1;
local g_Friendgroup = 0
local g_Friendindex = -1
local g_Friendguid = ""
local g_FriendName = ""
local g_bFromRecentBooth = 0
local g_MaxInt = 2147483647
local ShopUnitID = {
		YuanBao = 5,			--元宝
		Bind = 9,					--绑定元宝
		-- GiftToken = 10,		--返券
}


-- 大话七夕商店批量购买
local g_Shop_MBuy_DaHuaQiXiShop_Flag = false
local g_Shop_MBuy_DaHuaQiXiShop_ID = -1 -- 表格里的Id
local g_Shop_MBuy_DaHuaQiXiShop_MaxNum = 1
local g_Shop_MBuy_DaHuaQiXiShop_ItemInfo = nil

function Shop_MBuy_PreLoad()
	this:RegisterEvent("OPEN_YUANBAOSHOP_MULTI_BUYWND");
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("CLOSE_BOOTH");
	-- this:RegisterEvent("OPEN_GIVEGIFT_COMPLETE_CHOOSE");
	-- this:RegisterEvent("OPEN_YUANBAOSHOP_RECENTLY")
end

function Shop_MBuy_OnLoad()

end
function Shop_MBuy_OnEvent(event)
	if(event == "OPEN_YUANBAOSHOP_MULTI_BUYWND") then
		g_bFromRecentBooth = tonumber(arg1)
		if g_bFromRecentBooth == 999236 then --大话七夕商店批量购买
			g_bFromRecentBooth = 0
			g_Shop_MBuy_DaHuaQiXiShop_Flag = true
			Shop_MBuy_OpenByDaHuaQiXiShop(tonumber(arg0))
			return
		else
			g_Shop_MBuy_DaHuaQiXiShop_Flag = false
			g_Shop_MBuy_DaHuaQiXiShop_ID = -1
		end
		--Shop_MBuy_Open 必须在 g_bFromRecentBooth 赋值的后面
		Shop_MBuy_Open(tonumber(arg0));

		-- 这个shop本身的限制先不加了 以后如果需要再加 2022-9-15 移植 
		-- local nCurShopLimit = GetMultiUpperLimit()
		-- g_MaxBuyNum_PerTime = nCurShopLimit
		if g_MaxBuyNum_PerTime > 7500 then
			g_MaxBuyNum_PerTime = 7500
		end
	elseif(event == "CLOSE_BOOTH") then
		this:Hide();
	elseif( (event == "UPDATE_YUANBAO" or event == "UPDATE_ZENGDIAN" or event == "UPDATE_BIND_YUANBAO") and this:IsVisible() ) then
		--需要花费
		local num = tonumber(Shop_MBuy_InputNum:GetText());
		if(nil == num or(num and num < 0)) then
			Shop_MBuy_Price_Yuanbao:SetText("0")
			return;
		end

		if(num > g_MaxBuyNum_PerTime) then
			num = g_MaxBuyNum_PerTime;
		end

		Shop_MBuy_UpdateCurMoneyInfo(num)
	-- elseif ( event == "OPEN_YUANBAOSHOP_RECENTLY" ) then
	-- 	if g_bFromRecentBooth > 0 then
	-- 		Shop_MBuy_Close_Clicked()
	-- 	end
	elseif (event == "DAHUAQIXI_DAIBI_CHANGED") and this:IsVisible() then
		if g_Shop_MBuy_DaHuaQiXiShop_Flag then --大话七夕商店批量购买
			g_Shop_MBuy_DaHuaQiXiShop_MaxNum = Shop_MBuy_CalMax_DaHuaQiXiShop()
			local num = tonumber(Shop_MBuy_InputNum:GetText())
			if not num or num < 0 then
				num = 0
			end
			Shop_MBuy_UpdateCurMoney_DaHuaQiXiShop(num)
		end
	end
end

function Shop_MBuy_OpenByDaHuaQiXiShop( itemIdInTable )
	local tblInfo = Lua_GetDaHuaQiXiShopDataByID(itemIdInTable)
	if not tblInfo then
		return
	end
	g_Shop_MBuy_DaHuaQiXiShop_ItemInfo = tblInfo
	g_Shop_MBuy_DaHuaQiXiShop_ItemInfo.ID = itemIdInTable
	g_Shop_MBuy_DaHuaQiXiShop_ID = itemIdInTable
	g_Shop_MBuy_DaHuaQiXiShop_MaxNum = Shop_MBuy_CalMax_DaHuaQiXiShop(tblInfo)
	
	local theAction = DataPool:CreateBindActionItemForShow(tblInfo.itemId, tblInfo.itemNum)
    local actionId = theAction:GetID()
    if actionId ~= 0 then
        Shop_MBuy_Item:SetActionItem(actionId)
		local colorStr = theAction:GetItemColorInShop()
		if colorStr ~= "" then
			Shop_MBuy_ItemInfo_Text:SetText( colorStr..theAction:GetName() );
		else
			Shop_MBuy_ItemInfo_Text:SetText( theAction:GetName() );
		end
	else
		Shop_MBuy_Item:SetActionItem(-1)
		Shop_MBuy_Close_Clicked()
    end

	if tblInfo.daibiType == 1 then
		Shop_MBuy_ItemInfo_GB:SetText("#cfff263"..ScriptGlobal_Format("#{DHSD_20240522_17}", tblInfo.daibiNum))
	elseif tblInfo.daibiType == 2 then
		Shop_MBuy_ItemInfo_GB:SetText("#cfff263"..ScriptGlobal_Format("#{DHSD_20240522_18}", tblInfo.daibiNum))
	end

	Shop_MBuy_InputNum:SetProperty("DefaultEditBox", "True")
	Shop_MBuy_InputNum:SetText("1")
	Shop_MBuy_InputNum:SetSelected(0, -1)

	-- 限购标记
	-- Shop_MBuy_HideUI_XianGou()

	Shop_MBuy_UpdateCurMoney_DaHuaQiXiShop(1)
	this:Show()
end

function Shop_MBuy_UpdateCurMoney_DaHuaQiXiShop(num)
	if g_Shop_MBuy_DaHuaQiXiShop_ID < 0 then
		return
	end
	local tblInfo = g_Shop_MBuy_DaHuaQiXiShop_ItemInfo
	if not tblInfo or tblInfo.ID ~= g_Shop_MBuy_DaHuaQiXiShop_ID then
		return
	end

	local playerCoin_Token = 0 --持有货币数量
	local daibiCount1, daibiCount2, weekGain1 = Lua_GetDaHuaQiXiShop_GetDaibiCount()
	if not daibiCount1 then
		return
	end
	if tblInfo.daibiType == 1 then
		playerCoin_Token = daibiCount1
		Shop_MBuy_Price:SetText("#{DHSD_20240522_49}")
		Shop_MBuy_Cash:SetText("#{DHSD_20240522_50}")
	elseif tblInfo.daibiType == 2 then
		playerCoin_Token = daibiCount2
		Shop_MBuy_Price:SetText("#{DHSD_20240522_51}")
		Shop_MBuy_Cash:SetText("#{DHSD_20240522_52}")
	end

	if num > g_Shop_MBuy_DaHuaQiXiShop_MaxNum then
		num = g_Shop_MBuy_DaHuaQiXiShop_MaxNum
		Shop_MBuy_InputNum:SetText(tostring(num))
	end
	if num > 0 then
		Shop_MBuy_Buy:Enable()
	else
		Shop_MBuy_Buy:Disable()
	end

	local nNeedMoney = num * tblInfo.daibiNum
	Shop_MBuy_Price_Yuanbao:SetText("#cfff263"..tostring( nNeedMoney ))
	Shop_MBuy_Cash_Yuanbao:SetText("#cfff263"..tostring(playerCoin_Token))
end

-- 返回可购买的最大数量（大话七夕商店商品）
function Shop_MBuy_CalMax_DaHuaQiXiShop(tblInfo)
	if not tblInfo then
		if g_Shop_MBuy_DaHuaQiXiShop_ID < 0 then
			return 0
		end
		tblInfo = g_Shop_MBuy_DaHuaQiXiShop_ItemInfo
		if not tblInfo or tblInfo.ID ~= g_Shop_MBuy_DaHuaQiXiShop_ID then
			return 0
		end
	end
    local num = Lua_GetDaHuaQiXiShop_MaxNumCanBuy(tblInfo.itemId, tblInfo.itemNum) --计算空间后的最大购买组数（有空间不足的提示）
    if num <= 0 then
		Shop_MBuy_Close_Clicked()
        return 0
    end
    if num > tblInfo.leftNum and tblInfo.leftNum >= 0 then --不能超过限购数
        num = tblInfo.leftNum
    end
	local playerCnt = 0 --玩家拥有钱数
	local daibiCount1, daibiCount2, weekGain1 = Lua_GetDaHuaQiXiShop_GetDaibiCount()
	if tblInfo.daibiType == 1 then
		playerCnt = daibiCount1 or 0
	elseif tblInfo.daibiType == 2 then
		playerCnt = daibiCount2 or 0
	end
	local max_cnt = math.floor(playerCnt / tblInfo.daibiNum)
	if num > max_cnt then --不能超过财力承受范围
		num = max_cnt
	end
	if num < 0 then num = 0 end
	return num
end

function Shop_MBuy_Open( idx )

	-- 二级密码 电话密保检查
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end

	--商店是消耗元宝
	local i = 0;
	--这个位置的物品的叠加数量是大于1的
	g_ItemMax = NpcShop:EnumItemMaxOverlay(idx);

	g_ItemIdx = idx;
	local	nPrice	= NpcShop:EnumItemPrice(g_ItemIdx);
	local theAction = EnumAction(idx, "boothitem");
	-- if g_bFromRecentBooth > 0 then
	-- 	theAction = EnumAction(idx, "yuanbaorecently");
	-- 	nPrice = NpcShop:EnumItemPriceRecently(g_ItemIdx);
	-- end
	g_ItemTableIdx = theAction:GetItemTableIndex()
	if theAction:GetID() ~= 0 then
		Shop_MBuy_Item:SetActionItem(theAction:GetID());
		if(theAction:GetItemColorInShop() ~= "") then
			Shop_MBuy_ItemInfo_Text:SetText( theAction:GetItemColorInShop()..theAction:GetName() );
		else
			Shop_MBuy_ItemInfo_Text:SetText( theAction:GetName() );
		end

		if (NpcShop:GetShopType("unit") == ShopUnitID.YuanBao) then
			Shop_MBuy_ItemInfo_GB:SetText("#cfff263".."#{YBSD_081225_101}" .. tostring(nPrice))
		elseif (NpcShop:GetShopType("unit") == ShopUnitID.Bind) then
			Shop_MBuy_ItemInfo_GB:SetText("#cfff263".."#{BDYB_090714_01}" .. tostring(nPrice))
		-- elseif (NpcShop:GetShopType("unit") == ShopUnitID.GiftToken) then
			-- Shop_MBuy_ItemInfo_GB:SetText("#cfff263".."#{YBFQ_XML_1}" .. tostring(nPrice))
		end
	else
		Shop_MBuy_Item:SetActionItem(-1);
		Shop_MBuy_ItemInfo_Text:SetText("");
		Shop_MBuy_ItemInfo_GB:SetText("");
	end
	Shop_MBuy_InputNum:SetProperty("DefaultEditBox", "True");
	Shop_MBuy_InputNum:SetText(tostring(g_ItemDefaultNum));
	Shop_MBuy_InputNum:SetSelected( 0, -1 );

	Shop_MBuy_UpdateCurMoneyInfo(g_ItemDefaultNum)

	-- 隐藏最大按钮 移植不开放这个功能
	-- Shop_MBuy_MAX : Hide()

	this:Show();

end

function Shop_MBuy_UpdateCurMoneyInfo(num)
	local	nPrice	= NpcShop:EnumItemPrice(g_ItemIdx);
	-- if g_bFromRecentBooth > 0 then
	-- 	nPrice = NpcShop:EnumItemPriceRecently(g_ItemIdx);
	-- end
	if nPrice > 0 and Division(g_MaxInt, nPrice) < num then
		Shop_MBuy_Price_Yuanbao:SetText("0")
		PushDebugMessage("#{FFSDGZ_120615_127}")
		return
	end
	if (NpcShop:GetShopType("unit") == ShopUnitID.YuanBao) then
		local playerCoin_yuanbao = Player:GetData("YUANBAO");
		Shop_MBuy_Price:SetText("#{FFSDGZ_120615_24}")
		Shop_MBuy_Cash:SetText("#{FFSDGZ_120615_25}")
		--需要花费
		local needYuanBaoColor = ""
		local nNeedMoney = Lua_Multiply(num, nPrice)
		if playerCoin_yuanbao >= nNeedMoney then
			needYuanBaoColor="#cfff263"
			Shop_MBuy_Buy:Enable()
		else
			needYuanBaoColor="#cff0000"
			Shop_MBuy_Buy:Disable()
		end
		Shop_MBuy_Price_Yuanbao:SetText(needYuanBaoColor..tostring( nNeedMoney ))
		--身体携带
		Shop_MBuy_Cash_Yuanbao:SetText("#cfff263"..tostring(playerCoin_yuanbao))
		--数量

	elseif (NpcShop:GetShopType("unit") == ShopUnitID.Bind) then
		local playerCoin_bindyuanbao = Player:GetData("BIND_YUANBAO");
		local playerCoin_yuanbao = Player:GetData("YUANBAO");
		Shop_MBuy_Price:SetText("#{FFSDGZ_120615_26}")
		Shop_MBuy_Cash:SetText("#{FFSDGZ_120615_113}")

		--需要花费
		local needYuanBaoColor = ""
		local nNeedMoney = Lua_Multiply(num, nPrice)
		if playerCoin_bindyuanbao + playerCoin_yuanbao >= nNeedMoney then
			needYuanBaoColor="#cfff263"
			Shop_MBuy_Buy:Enable()
		else
			needYuanBaoColor="#cff0000"
			Shop_MBuy_Buy:Disable()
		end
		Shop_MBuy_Price_Yuanbao:SetText(needYuanBaoColor..tostring( nNeedMoney))
		--身体携带
		Shop_MBuy_Cash_Yuanbao:SetText("#cfff263"..playerCoin_bindyuanbao.."/"..playerCoin_yuanbao)
		--数量
	-- elseif (NpcShop:GetShopType("unit") == ShopUnitID.GiftToken) then
	-- 	local playerCoin_Token = Player:GetData("GIFTTOKEN");
	-- 	Shop_MBuy_Price:SetText("#{FFSDGZ_120615_69}")
	-- 	Shop_MBuy_Cash:SetText("#{FFSDGZ_120615_70}")

	-- 	--需要花费
	-- 	local needYuanBaoColor = ""
	-- 	local nNeedMoney = Lua_Multiply(num, nPrice)
	-- 	if playerCoin_Token >= nNeedMoney then
	-- 		needYuanBaoColor="#cfff263"
	-- 		Shop_MBuy_Buy:Enable()
	-- 	else
	-- 		needYuanBaoColor="#cff0000"
	-- 		Shop_MBuy_Buy:Disable()
	-- 	end
	-- 	Shop_MBuy_Price_Yuanbao:SetText(needYuanBaoColor..tostring( nNeedMoney))
	-- 	--身体携带
	-- 	Shop_MBuy_Cash_Yuanbao:SetText("#cfff263"..tostring(playerCoin_Token))
	-- 	--数量
	end
end

function Shop_MBuy_CalMax()

	if g_Shop_MBuy_DaHuaQiXiShop_Flag then --大话七夕商店批量购买
		Shop_MBuy_InputNum:SetText(tostring(g_Shop_MBuy_DaHuaQiXiShop_MaxNum))
		return
	end

	if g_ItemIdx == nil or g_ItemIdx < 0 then
		return
	end
	local theAction = EnumAction(g_ItemIdx, "boothitem");
	
	
	local 	nMaxCount = CalcItemSpace_BindProperty(theAction:GetItemTableIndex()) --根据背包计算出的最大可放物品个数
	--数量为零 格子不够
	if nMaxCount == 0 then
		local SpaceType = CalcItemSpaceType(theAction:GetItemTableIndex())
		if SpaceType == 1 then
			PushDebugMessage("#{PLYH_171128_01}")
		end
		if SpaceType == 2 then
			PushDebugMessage("#{PLYH_171128_02}")
		end		
		Shop_MBuy_InputNum:SetText("0");
		return;
	end
	
	local	nPrice	= NpcShop:EnumItemPrice(g_ItemIdx);
	-- if g_bFromRecentBooth > 0 then
	-- 	theAction = EnumAction(g_ItemIdx, "yuanbaorecently");
	-- 	nPrice = NpcShop:EnumItemPriceRecently(g_ItemIdx);
	-- end
	local	nPileNum = theAction:GetNum();
	nMaxCount = math.floor(nMaxCount/nPileNum);
	local	nTotalMoney = 0
	if (NpcShop:GetShopType("unit") == ShopUnitID.YuanBao) then
		nTotalMoney = Player:GetData("YUANBAO");
		--新增判断，是否有足够的货币购买1个道具
		if math.floor(nTotalMoney/nPrice) == 0 then
			PushDebugMessage("#{PLYH_171128_03}")
		end
	elseif (NpcShop:GetShopType("unit") == ShopUnitID.Bind) then
		nTotalMoney = Player:GetData("YUANBAO") + Player:GetData("BIND_YUANBAO");
		if math.floor(nTotalMoney/nPrice) == 0 then
			PushDebugMessage("#{PLYH_171128_05}")
		end
	elseif (NpcShop:GetShopType("unit") == ShopUnitID.GiftToken) then
		nTotalMoney = Player:GetData("GIFTTOKEN");
		if math.floor(nTotalMoney/nPrice) == 0 then
			PushDebugMessage("#{PLYH_171128_06}")
		end
	end
	
	local	nMaxCanBuyByMoney = math.floor(nTotalMoney/nPrice)
	if nMaxCount > nMaxCanBuyByMoney then
		nMaxCount = nMaxCanBuyByMoney
	end
	if nMaxCount > g_MaxBuyNum_PerTime then
		nMaxCount = g_MaxBuyNum_PerTime
	end
	Shop_MBuy_InputNum:SetText(tostring(nMaxCount));
end

function Shop_MBuy_TextChanged()
	local num = tonumber(Shop_MBuy_InputNum:GetText());
	if(nil == num or(num and num < 0)) then
		if g_Shop_MBuy_DaHuaQiXiShop_Flag then
			num = 0
		else
			Shop_MBuy_Price_Yuanbao:SetText("0")
			return;
		end
	end

	if g_Shop_MBuy_DaHuaQiXiShop_Flag then --大话七夕商店批量购买
		Shop_MBuy_UpdateCurMoney_DaHuaQiXiShop(num)
		return
	end

	if(num > g_MaxBuyNum_PerTime) then
		num = g_MaxBuyNum_PerTime;
		Shop_MBuy_InputNum:SetText(tostring(num))
	end

	Shop_MBuy_UpdateCurMoneyInfo(num)
end

function Shop_MBuy_Close_Clicked()
	
	if g_Shop_MBuy_DaHuaQiXiShop_Flag then
		PushEvent("DAHUAQIXI_SHOP_UPDATE", "on_cancel")
	end

	this:Hide()
end

function Shop_MBuy_BuyMulti_Clicked()
	local num = tonumber(Shop_MBuy_InputNum:GetText());
	if g_Shop_MBuy_DaHuaQiXiShop_Flag and g_Shop_MBuy_DaHuaQiXiShop_ID >= 0 then
			-- 大话七夕商店批量购买，需要二次确认
			if num > g_Shop_MBuy_DaHuaQiXiShop_MaxNum then
				PushDebugMessage("#{DHSD_20240522_31}") -- 您输入的数量不符合规定。
			else
				PushEvent("DAHUAQIXI_SHOP_UPDATE", "on_confirm", g_Shop_MBuy_DaHuaQiXiShop_ID, num)
				this:Hide()
			end
	elseif num ~= nil and num > 0 then
		NpcShop:BulkBuyItem(g_ItemIdx,num, g_bFromRecentBooth);
		Shop_MBuy_Close_Clicked()
	else
		if g_Shop_MBuy_DaHuaQiXiShop_Flag then --大话七夕商店批量购买
			PushDebugMessage("#{DHSD_20240522_31}") -- 您输入的数量不符合规定。
		else
			PushDebugMessage("#{FFSDGZ_120615_47}")
		end
	end
end
