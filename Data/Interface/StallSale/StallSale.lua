
local g_CurrentPage = -1;
local g_DefaultPage = -1;

local PAGE_ITEM  =0;
local PAGE_PET   =1;

-- ÎïÆ·Ïà¹Ø
local STALL_BUTTONS_NUM = 20;
local STALL_BUTTON = {};

local g_nCurSelectItemID = -1;	--??ID
local g_nCurSelectItem = -1;		--????

-- äÊÞÏà¹Ø
local MAX_PET_NUM  = 20;		--?????????
local g_nSelectPet = -1;		--?????Pet
local g_nPetID = {};				--??ID?

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_StallSale_Frame_UnifiedXPosition;
local g_StallSale_Frame_UnifiedYPosition;

--===============================================
-- OnLoad()
--===============================================
function StallSale_PreLoad()

	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("UPDATE_STALL_SALE");
	this:RegisterEvent("STALL_SALE_SELECT");
	this:RegisterEvent("OPEN_STALL_BUY");
	this:RegisterEvent("UPDATE_STALL_ITEM_PRICE");
	this:RegisterEvent("UPDATE_STALL_NAME");
	this:RegisterEvent("CLOSE_STALL_SALE");

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function StallSale_OnLoad()
	STALL_BUTTON[1] 	= StallSale_Item1;
	STALL_BUTTON[2] 	= StallSale_Item2;
	STALL_BUTTON[3] 	= StallSale_Item3;
	STALL_BUTTON[4] 	= StallSale_Item4;
	STALL_BUTTON[5] 	= StallSale_Item5;
	STALL_BUTTON[6] 	= StallSale_Item6;
	STALL_BUTTON[7] 	= StallSale_Item7;
	STALL_BUTTON[8] 	= StallSale_Item8;
	STALL_BUTTON[9] 	= StallSale_Item9;
	STALL_BUTTON[10] 	= StallSale_Item10;
	STALL_BUTTON[11] 	= StallSale_Item11;
	STALL_BUTTON[12] 	= StallSale_Item12;
	STALL_BUTTON[13] 	= StallSale_Item13;
	STALL_BUTTON[14]	= StallSale_Item14;
	STALL_BUTTON[15]	= StallSale_Item15;
	STALL_BUTTON[16]	= StallSale_Item16;
	STALL_BUTTON[17]	= StallSale_Item17;
	STALL_BUTTON[18]	= StallSale_Item18;
	STALL_BUTTON[19]	= StallSale_Item19;
	STALL_BUTTON[20]	= StallSale_Item20;
	
	--AxTrace(0,0,"StallSale_OnLoad begin\n");
	for i=0, MAX_PET_NUM  do
		g_nPetID[i] = -1;
	end
	
	--ÔÝÊ±ÆÁ±ÎÍÏ¶¯¹¦ÄÜ
	for i=1 ,STALL_BUTTONS_NUM     do
		STALL_BUTTON[i]:SetProperty("DraggingEnabled","False");
	end

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_StallSale_Frame_UnifiedXPosition	= StallSale_Frame : GetProperty("UnifiedXPosition");
	g_StallSale_Frame_UnifiedYPosition	= StallSale_Frame : GetProperty("UnifiedYPosition");
		
end

--===============================================
-- OnEvent()
--===============================================
function StallSale_StallInfo(event)
	--ÌîÐ´Ì¯Î»Ãû×Ö
	StallSale_Name:SetText(StallSale:GetStallName());
	--ÌîÐ´Ãû×Ö
	StallSale_Master_Text:SetText("Chü sÕp: " .. Player:GetName());
	--ÌîÐ´×Ô¼ºµÄGUID
	StallSale_ID_Text:SetText( "ID:" .. StallSale:GetGuid());
	--Çå³ý¼Û¸ñ
	StallSale_TargetPrice_Money:SetProperty("MoneyNumber","");
	--ÌîÐ´Ë°ÂÊ
	StallSale_Tax_Text:SetText(tostring(StallSale:GetTradeTax()).."%");
end

--===============================================
-- OnEvent()
--===============================================
function StallSale_OnEvent(event)

	--PushDebugMessage ("StallSale : "..event)

	if(event == "OPEN_STALL_SALE") then
		StallSale_OnStallSaleOpen();
		
	elseif(event == "UPDATE_STALL_SALE")  then
		g_DefaultPage = StallSale_GetDefalutPage();
		StallSale_StallInfo();
		StallSale_ChangePage(g_CurrentPage);
		g_nCurSelectItemID = -1;
		g_nCurSelectItem = -1;
	
	elseif(event == "UPDATE_STALL_ITEM_PRICE")   then
		--»ñµÃÐÞ¸ÄµÚ¼¸¸ö£¬È»ºóÐÞ¸Ä¼Û¸ñ
		StallSale_UpdateFrame();
		StallSale_ViewSelectAndPrice();

	elseif(event == "STALL_SALE_SELECT") then
		StallSale_SelectUpdate();
		--½«InputMoneyÐèÒªµÄÊý¾Ý±£´æµ½È«¾ÖÊý¾ÝÇø
		SetGlobalInteger(g_nCurSelectItemID,"StallSale_ItemID");
		SetGlobalInteger(g_nCurSelectItem,"StallSale_Item");

	elseif(event == "OPEN_STALL_BUY") then
		--ÊµÏÖÂòÂô½çÃæµÄ»¥³â
		this:Hide();
		
	elseif(event == "UPDATE_STALL_NAME")  then
		--¸ü¸ÄÉÌµêÃû×Ö
		StallSale_Name:SetText(arg0);
		StallSale:ModifStallName(StallSale_Name:GetText());

	elseif(event == "CLOSE_STALL_SALE")  then
		this:Hide();
	end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ
		StallSale_Frame_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ	
		StallSale_Frame_On_ResetPos()
	end

end

function StallSale_GetDefalutPage()
	
	return StallSale:GetDefaultPage();
	
end

--===============================================
-- ³õÊ¼»¯°ÚÌ¯½çÃæ
--===============================================
function StallSale_OnStallSaleOpen()
	
	StallSale_TargetPrice:Hide();
	StallSale_TargetPrice_Yuanbao:Hide();
	
	--Çå¿ Ñ¡Ôñ
	StallSale_ClearSelect();

	--´ò¿ªÁôÑÔ°æ
	StallSale:OpenMessageSale();

	--´ò¿ª äÊÞÁÐ±í
	StallSale:OpenPetList();
		
	g_DefaultPage = StallSale_GetDefalutPage();
	g_CurrentPage = g_DefaultPage;
	if(g_CurrentPage == PAGE_ITEM)  then
		StallSale_Check_Item:SetCheck(1);
		StallSale_Check_Pet:SetCheck(0);
	else
		StallSale_Check_Item:SetCheck(0);
		StallSale_Check_Pet:SetCheck(1);
	end

	StallSale_StallInfo();
		
	-- ÌîÈëÄÚÈÝ
	StallSale_ChangePage(g_CurrentPage);
	
	local nCoinType = StallSale:GetStallType()
	-- Èç¹ûÊÇ½ð±Ò°ÚÌ¯
	if (nCoinType == 0) then
		StallSale_TargetPrice:Show();
		StallSale_Check_Pet:Show()
		StallSale_Default_Page:Show()
		StallSale_SetPage_Text:Show()

	-- Èç¹ûÊÇÔª±¦°ÚÌ¯
	elseif( nCoinType == 1 ) then
		StallSale_TargetPrice_Yuanbao:Show();
		StallSale_Check_Pet:Show()
		StallSale_Default_Page:Show();
		StallSale_SetPage_Text:Show();
		StallSale_TargetPrice_Yuanbao:SetText("#cff99000 #WKNB")

	else
		PushDebugMessage("LoÕi bày bán b¸ l²i");
	end

	this:Show();

end

--===============================================
-- Ñ¡ÖÐÎïÆ·
--===============================================
function StallSale_SelectUpdate()

	local theAction = EnumAction(arg0+0, "st_self");
	
	g_nCurSelectItemID = theAction:GetID();
	g_nCurSelectItem = tonumber(arg0);

	StallSale_ViewSelectAndPrice();
	
end

--===============================================
-- ÏÔÊ¾Ñ¡ÖÐµÄÎïÆ·£¨ äÊÞ£©£¬ºÍËûÃÇµÄ±ê¼Û
--===============================================
function StallSale_ViewSelectAndPrice()

	local nMoney = 0;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;

	if (g_CurrentPage == PAGE_ITEM) then 
		for i=1, STALL_BUTTONS_NUM do
			if(i==g_nCurSelectItem+1) then
				STALL_BUTTON[i]:SetPushed(1);
			else
				STALL_BUTTON[i]:SetPushed(0);
			end
		end
		nMoney,nGoldCoin,nSilverCoin,nCopperCoin = StallSale:GetPrice("item",g_nCurSelectItem);
		
	elseif(g_CurrentPage == PAGE_PET)  then
		if(g_nSelectPet ~= -1)   then
			StallSale_PetList:SetItemSelect(g_nSelectPet);
			nMoney,nGoldCoin,nSilverCoin,nCopperCoin = StallSale:GetPrice("pet",g_nPetID[g_nSelectPet]);
		end
	end
	
	local nCoinType = StallSale:GetStallType()
	if (nCoinType == 0) then
		StallSale_TargetPrice_Money:SetProperty("MoneyNumber",tostring(nMoney));
		
	elseif( nCoinType == 1 ) then
		StallSale_SetTargetPrice(1, nMoney)
		
	else
		PushDebugMessage("LoÕi bày bán b¸ l²i");
	end
	
end


--===============================================
-- Ñ¡ÖÐ äÊÞ
--===============================================
function StallSale_PetList_Selected()
	
	--ÐèÒªÏÔÊ¾¼Û¸ñ
	g_nSelectPet = StallSale_PetList:GetFirstSelectItem();
	
	if( g_nSelectPet == -1 )  then 
		return;
	end

	StallSale:SetSelectPet(g_nPetID[g_nSelectPet]);
	
	StallSale_ViewSelectAndPrice();
		
end

--===============================================
-- StallSale_UpdateFrame
--===============================================
function StallSale_UpdateFrame()
	
	if(g_CurrentPage == PAGE_ITEM)     then 
		UpdateItem();
		if( g_DefaultPage == g_CurrentPage  )   then
			StallSale_Default_Page:SetCheck(1);
		else
			StallSale_Default_Page:SetCheck(0);
		end

	elseif (g_CurrentPage == PAGE_PET) then
		if( g_DefaultPage == g_CurrentPage  )   then
			StallSale_Default_Page:SetCheck(1);
		else
			StallSale_Default_Page:SetCheck(0);
		end
		UpdatePet();

	end
	
	StallSale_SetTabColor();
end

--===============================================
-- ÖØÐÂÃüÃûÌ¯Î»Ãû³Æ
--===============================================
function StallSaleRename_Clicked()

	StallSale:ModifStallName(StallSale_Name:GetText());

end

--===============================================
-- ÖØÐÂÖ¸¶¨ÎïÆ·µÄ¼Û¸ñ£¨´ò¿ª¼Û¸ñÊäÈë¿ò£©
--===============================================
function StallSaleReprice_Clicked()

	if (g_CurrentPage == PAGE_ITEM) then 
		-- ÐèÒªÏÈÅÐ¶¨ÊÇ·ñÓÐÎïÆ·
		if(g_nCurSelectItemID~=-1) then
			if(g_nCurSelectItem~=-1) then
				StallSale:ModifItemPrice("item");
			end
		end
		
	elseif(g_CurrentPage == PAGE_PET)  then
		if(g_nSelectPet ~= -1) then 
			StallSale:ModifItemPrice("pet",g_nPetID[g_nSelectPet]);
		end
	end
	
end

--===============================================
-- ÈÃÒ»¸öÎïÆ·( äÊÞ)ÏÂ¼Ü
--===============================================
function StallSaleDelete_Clicked()
	
	if (g_CurrentPage == PAGE_ITEM) then 
		-- ÐèÒªÏÈÅÐ¶¨ÊÇ·ñÓÐÎïÆ·
		if(g_nCurSelectItemID~=-1) then
			if(g_nCurSelectItem~=-1) then
				StallSale:DeleteItem("item",g_nCurSelectItemID);
			end
		end

	elseif(g_CurrentPage == PAGE_PET)  then
		if(g_nSelectPet ~= -1) then 
			StallSale:DeleteItem("pet",g_nPetID[g_nSelectPet]);
		end
	end

end

--===============================================
-- Ê Ì¯×ßÈË
--===============================================
function StallSalePutUpTheShutters_Clicked()

	StallSale:ConfirmRemoveStall();

end

--===============================================
-- ´ò¿ªÐÅÏ¢½çÃæ
--===============================================
function StallSale_Message_Clicked()
	
	if (IsWindowShow("StallMessage")) then
		CloseWindow("StallMessage", true);
		return
	end
	StallSale:OpenMessageSale();

end

--===============================================
-- ¹Ø± °´Å¥
--===============================================
function StallSale_Close_Clicked()

	this:Hide();
	StallSale:CloseStallMessage();
	StallSale_Name:SetProperty("DefaultEditBox", "False");
	CloseMessageBoxCommon();
	CloseInputYuanbao();

end

--===============================================
-- ÏÔÊ¾ÎïÆ·
--===============================================
function UpdateItem()

	local nItemNum = GetActionNum("st_self");
	for i=0, STALL_BUTTONS_NUM - 1  do
		local theAction = EnumAction(i, "st_self");
		if theAction:GetID() ~= 0 then
			STALL_BUTTON[i+1]:SetActionItem(theAction:GetID());
		else
			STALL_BUTTON[i+1]:SetActionItem(-1);
		end
	end

end

--===============================================
-- ÏÔÊ¾ äÊÞ
--===============================================
function UpdatePet()
	StallSale_PetList:ClearListBox();
	
	local nIndex = 0;
	for i=1 ,MAX_PET_NUM  do
		local szPetName, szType = StallSale:EnumPet(i-1);
		if(szPetName ~= "") then 
			StallSale_PetList:AddItem(szPetName .. "#cffff00 (" .. szType .. ")" , nIndex);
			g_nPetID[nIndex] = i-1;
			nIndex = nIndex + 1;
		end

	end
	
end

--===============================================
-- »»Ò³
--===============================================
function StallSale_ChangeTabIndex(nIndex)

	if(g_CurrentPage == nIndex)    then
		return;
	else
		StallSale_ChangePage(nIndex)
		StallSale_TargetPrice_Money:SetProperty("MoneyNumber","0");	
	end

end

--===============================================
-- »»Ò³Ë¢ÐÂ
--===============================================
function StallSale_ChangePage(nPage)

	StallSale_ClearSelect();

	g_CurrentPage = nPage;
	if(g_CurrentPage == PAGE_ITEM) then
		StallSale_PetList:Hide();
		StallSale_Item_Set:Show();
		for i=1, STALL_BUTTONS_NUM   do
			STALL_BUTTON[i]:Show();
		end
		StallSale_ViewPets:Hide();
	else
		StallSale_PetList:Show();
		StallSale_Item_Set:Hide();
		for i=1, STALL_BUTTONS_NUM   do
			STALL_BUTTON[i]:Hide();
		end
		StallSale_ViewPets:Show();
	end
	StallSale_UpdateFrame();
	
end

--===============================================
-- Ñ¡ÖÐÈ±Ê¡Ò³Ãæ
--===============================================
function StallSale_Default_Page_Clicked()

	local nCurrent = StallSale_Default_Page:GetCheck();
	if( g_CurrentPage == PAGE_ITEM )  then
		if( nCurrent == 1  )   then
			g_DefaultPage = PAGE_ITEM;
		else
			g_DefaultPage = PAGE_PET;
		end
	else
		if( nCurrent == 1  )   then
			g_DefaultPage = PAGE_PET;
		else
			g_DefaultPage = PAGE_ITEM;
		end
	
	end
	
	StallSale:SetDefaultPage(g_DefaultPage);

end

--===============================================
-- ÓÒ¼üÑ¡ÖÐ
--===============================================
function StallSale_PetList_RClick()

	g_nSelectPet = StallSale_PetList:GetFirstSelectItem();
	if(g_nSelectPet == -1)then
		PushDebugMessage("Hãy ch÷n mµt con Trân Thú sau ðó nh¤n ki¬m tra")
		return;
	end

	--ÏÔÊ¾ äÊÞ
	StallSale:ViewPetDesc("self",g_nPetID[g_nSelectPet]);

end

--===============================================
-- ÉèÖÃTabÑ É«
--===============================================
function StallSale_SetTabColor()
	
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";

	if( PAGE_ITEM == g_CurrentPage ) then
		StallSale_Check_Item:SetText(selColor .. "V§t ph¦m");
		StallSale_Check_Pet:SetText(noselColor .. "Thú");
	else
		StallSale_Check_Item:SetText(noselColor .. "V§t ph¦m");
		StallSale_Check_Pet:SetText(selColor .. "Thú");
	end

end

--===============================================
-- »Ö¸´Ñ¡ÖÐ×´Ì¬£¨Çå¿ Ñ¡ÖÐ£©
--===============================================
function StallSale_ClearSelect()
	g_nSelectPet = -1;				--?????Pet
	g_nCurSelectItemID = -1;	--??ID
	g_nCurSelectItem = -1;		--????
end


function StallSale_SetTargetPrice(nCoinType, nMoney)
	
	local nMoneyEnd = 0;
	local nMoneyBegin = 0
	local nMoneyMid = 0;
	local strMoney = "";
	
	-- Èç¹ûÊÇ½ð±Ò°ÚÌ¯
	if (nCoinType == 0) then
		StallSale_TargetPrice_Money:SetProperty("MoneyNumber",tostring(nMoney));
			-- Ôª±¦°ÚÌ¯
	elseif( nCoinType == 1 ) then
		if (nMoney <100 ) then
			strMoney = string.format("#cff9900%s", nMoney);
		elseif (nMoney < 10000) then
			nMoneyEnd = nMoney - math.floor(nMoney/100)*100;
			nMoneyMid = math.floor(nMoney/100) - math.floor((math.floor(nMoney/100))/100)*100;
			local strEnd = "00";
			if (nMoneyEnd < 10) then
				strEnd = string.format("0%d", nMoneyEnd);
			else
				strEnd = tostring(nMoneyEnd);
			end
			strMoney = string.format("#W%d#cff9900%s", nMoneyMid, strEnd);
		else
			nMoneyEnd = nMoney - math.floor(nMoney/100)*100;
			nMoneyMid = math.floor(nMoney/100) - math.floor((math.floor(nMoney/100))/100)*100;
			nMoneyBegin = math.floor(nMoney/10000);
			local strEnd = "00";
			if (nMoneyEnd < 10) then
				strEnd = string.format("0%d", nMoneyEnd);
			else
				strEnd = tostring(nMoneyEnd);
			end
			local strMid = "00";
			if (nMoneyMid < 10) then
				strMid = string.format("0%d", nMoneyMid);
			else
				strMid = tostring(nMoneyMid);
			end
			strMoney = string.format("#Y%d#W%s#cff9900%s", nMoneyBegin, strMid, strEnd);
		end
		StallSale_TargetPrice_Yuanbao:SetText("#Y"..strMoney.." #WKNB");
	else
		PushDebugMessage("LoÕi bày bán b¸ l²i");
	end
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function StallSale_Frame_On_ResetPos()

	StallSale_Frame : SetProperty("UnifiedXPosition", g_StallSale_Frame_UnifiedXPosition);
	StallSale_Frame : SetProperty("UnifiedYPosition", g_StallSale_Frame_UnifiedYPosition);

end
