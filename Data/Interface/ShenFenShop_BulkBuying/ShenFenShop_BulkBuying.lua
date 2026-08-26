
local g_ShenFenShop_ItemMax = 0;
local g_ShenFenShop_ItemPage = -1;
local g_ShenFenShop_ItemIdx = -1;
local g_ShenFenShop_ItemId = -1;
local g_ShenFenShop_ItemPrice = -1;
local g_ShenFenShop_CurIdentity = 0

local g_ShenFenShop_ARR_PRICE = {};

local g_ShenFenShop_objCared = -1;
local g_ShenFenShop_ServerCareID = -1;

local MAX_OBJ_DISTANCE = 3.0;

local CU_MONEY			= 1	-- ?
local CU_MONEYJZ		= 8 -- ??

function ShenFenShop_BulkBuying_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("CLOSE_BOOTH");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function ShenFenShop_BulkBuying_OnLoad()
	g_ShenFenShop_ARR_PRICE[1] = ShenFenShop_BulkBuying_Money1;
	g_ShenFenShop_ARR_PRICE[2] = ShenFenShop_BulkBuying_Money2;
	g_ShenFenShop_ARR_PRICE[3] = ShenFenShop_BulkBuying_Money3;
end

function ShenFenShop_BulkBuying_OnEvent(event)
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99858503 ) then	
		if Get_XParam_INT( 0 ) <= 0 then
			this:Hide();
			return
		end
		
		--¹ØÐÄÉÌÈËObj
		g_ShenFenShop_ServerCareID = Get_XParam_INT(1)
		g_ShenFenShop_objCared = DataPool:GetNPCIDByServerID(g_ShenFenShop_ServerCareID);
		if( 0 > g_ShenFenShop_objCared ) then
			PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
			return
		end
		this:CareObject(g_ShenFenShop_objCared, 1, "ShenFenShop_BulkBuying");
		
		g_ShenFenShop_ItemPage = Get_XParam_INT(2)
		g_ShenFenShop_ItemIdx = Get_XParam_INT(3)
		g_ShenFenShop_CurIdentity = Get_XParam_INT(4)
		
		ShenFenShop_BulkBuying_Open();
		
	elseif(event == "OPEN_BULKBUY_BOOTH") then
		this:Hide();
		
	elseif( (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and this:IsVisible()) then
		local playerMoney = Player:GetData("MONEY");
		local playerMoneyJZ = Player:GetData("MONEY_JZ");
		ShenFenShop_BulkBuying_Money2:SetProperty("MoneyMaxNumber", playerMoney);
		ShenFenShop_BulkBuying_Money3:SetProperty("MoneyNumber", playerMoney);
		ShenFenShop_BulkBuying_Money4:SetProperty("MoneyNumber", playerMoneyJZ);
	end
	
end

function ShenFenShop_BulkBuying_Open()

	local nActIndex = g_ShenFenShop_ItemIdx + (g_ShenFenShop_ItemPage - 1) * 12 - 1
	local nRet, itemid, itemnum, itemcosttype, price, itemlimit = NpcShop:GetReputationShopItemByIdx(g_ShenFenShop_CurIdentity, nActIndex)
	if nRet == nil or nRet <= 0 then
		return
	end
	
	--·ûºÏÌõ¼þ£¬ÏÔÊ¾½çÃæ
	local i = 0;
	for i = 1, 2 do
		g_ShenFenShop_ARR_PRICE[i]:SetProperty("GoldIcon", "set:Button2 image:Icon_GoldCoin")
		g_ShenFenShop_ARR_PRICE[i]:SetProperty("SilverIcon", "set:Button2 image:Icon_SilverCoin")
		g_ShenFenShop_ARR_PRICE[i]:SetProperty("CopperIcon", "set:Button2 image:Icon_CopperCoin")
	end
		
	local playerMoney = Player:GetData("MONEY");
	local playerMoneyJZ = Player:GetData("MONEY_JZ");
	--ÐèÒª»¨·Ñ
	ShenFenShop_BulkBuying_Money2:SetProperty("MoneyMaxNumber", playerMoney);
	ShenFenShop_BulkBuying_Money2:SetProperty("MoneyNumber", price);
	
	--ÎïÆ·µ¥¼Û
	ShenFenShop_BulkBuying_Money1:SetProperty("MoneyNumber", price);
			
	--ÉíÌåÐ¯´ø
	ShenFenShop_BulkBuying_Money3:SetProperty("MoneyNumber", playerMoney);
	ShenFenShop_BulkBuying_Money4:SetProperty("MoneyNumber", playerMoneyJZ);
			
	--ÊýÁ¿
	local nHaveBuy = NpcShop:GetReputationShopBuyCountByIdx(nActIndex)
	g_ShenFenShop_ItemMax = itemlimit-nHaveBuy 
	g_ShenFenShop_ItemPrice = price
	ShenFenShop_BulkBuying_IME:SetProperty("DefaultEditBox", "True");
	ShenFenShop_BulkBuying_IME:SetText(g_ShenFenShop_ItemMax)
	ShenFenShop_BulkBuying_IME:SetSelected( 0, -1 );
			
	--Ãû³Æ
	g_ShenFenShop_ItemId = itemid
	local item_name = DataPool:LuaFnGetItemNameByTableIndex(itemid)
	ShenFenShop_BulkBuying_PageHeader:SetText("#gFF0FA0"..item_name);
	this:Show();
		
end

function ShenFenShop_BulkBuying_Accept_Clicked()

	--¹ºÂò¶à¸ö
	local num = tonumber(ShenFenShop_BulkBuying_IME:GetText());
	if(nil ~= num) then
		if( tonumber( num ) == 0  ) then
		else			
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("ReputationShopBuyItem")
				Set_XSCRIPT_ScriptID(998585)
				Set_XSCRIPT_Parameter( 0, g_ShenFenShop_ServerCareID )
				Set_XSCRIPT_Parameter( 1, g_ShenFenShop_ItemPage )
				Set_XSCRIPT_Parameter( 2, g_ShenFenShop_ItemIdx )
				Set_XSCRIPT_Parameter( 3, g_ShenFenShop_ItemId )
				Set_XSCRIPT_Parameter( 4, num )
				Set_XSCRIPT_Parameter( 5, 0 )
				Set_XSCRIPT_ParamCount(6)
			Send_XSCRIPT()
		end
	end
	
	this:Hide();
	
end

function ShenFenShop_BulkBuying_TextChanged()

	local num = tonumber(ShenFenShop_BulkBuying_IME:GetText());
	if(nil == num or(num and num < 0)) then 
		ShenFenShop_BulkBuying_Money2:SetProperty("MoneyNumber", 0);
		return; 
	end

	local itemnum = NpcShop:EnumItemMaxOverlay(g_ShenFenShop_ItemIdx)
	
	if(num > g_ShenFenShop_ItemMax) then
		num = g_ShenFenShop_ItemMax;
	end
	if(num == 0) then
		ShenFenShop_BulkBuying_Money2:SetText("");
		ShenFenShop_BulkBuying_Money2:SetProperty("MoneyNumber", 0);
	end
	
	local price = g_ShenFenShop_ItemPrice*num;
	ShenFenShop_BulkBuying_Money2:SetProperty("MoneyNumber", price);
	ShenFenShop_BulkBuying_IME:SetTextOriginal(num); 
	
end
