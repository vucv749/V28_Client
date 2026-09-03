
local PS_BUTTON_NUM = 20;
local PS_BUTTON = {};

-- ÏÂÁÐÁ½¸öÖµÐèÒª±£³ÖÍ¬²½£¨ÎïÆ·ID¡¢ÎïÆ·Î»ÖÃ£©
local g_nCurSelectItemID = -1;
local g_nCurSelectItem = -1;
local g_nCurStallIndex = -1;
local g_StallNum = 0;

--±êÖ¾µ±Ç°ÊÇ³èÎï½çÃæ»¹ÊÇÎïÆ·½çÃæ
local STALL_NONE = 0
local STALL_ITEM = 1;
local STALL_PET  = 2;
local g_CurStallObj = STALL_NONE;
local g_PetIndex = {};

local PS_STALL_NUM = 10;
local PS_STALL_BOTTON = {};

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;


--===============================================
-- OnLoad()
--===============================================
function PS_Transfer_PreLoad()

	this:RegisterEvent("PS_OPEN_OTHER_TRANS");
	this:RegisterEvent("PS_UPDATE_OTHER_TRANS");
	this:RegisterEvent("PS_OTHER_TRANS_SELECT");
	this:RegisterEvent("BUYPSSUCCESS_CLOSE_SHOPLIST") --???????????????
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_MONEY");

end

function PS_Transfer_OnLoad()
	PS_BUTTON[1]  = PS_Transfer_Item1; 
	PS_BUTTON[2]  = PS_Transfer_Item2; 
	PS_BUTTON[3]  = PS_Transfer_Item3; 
	PS_BUTTON[4]  = PS_Transfer_Item4; 
	PS_BUTTON[5]  = PS_Transfer_Item5; 
	PS_BUTTON[6]  = PS_Transfer_Item6; 
	PS_BUTTON[7]  = PS_Transfer_Item7; 
	PS_BUTTON[8]  = PS_Transfer_Item8; 
	PS_BUTTON[9]  = PS_Transfer_Item9; 
	PS_BUTTON[10] = PS_Transfer_Item10;
	PS_BUTTON[11] = PS_Transfer_Item11;
	PS_BUTTON[12] = PS_Transfer_Item12;
	PS_BUTTON[13] = PS_Transfer_Item13;
	PS_BUTTON[14] = PS_Transfer_Item14;
	PS_BUTTON[15] = PS_Transfer_Item15;
	PS_BUTTON[16] = PS_Transfer_Item16;
	PS_BUTTON[17] = PS_Transfer_Item17;
	PS_BUTTON[18] = PS_Transfer_Item18;
	PS_BUTTON[19] = PS_Transfer_Item19;
	PS_BUTTON[20] = PS_Transfer_Item20;

	PS_STALL_BOTTON[1]   = PS_Transfer_Page1;
	PS_STALL_BOTTON[2]   = PS_Transfer_Page2;
	PS_STALL_BOTTON[3]   = PS_Transfer_Page3;
	PS_STALL_BOTTON[4]   = PS_Transfer_Page4;
	PS_STALL_BOTTON[5]   = PS_Transfer_Page5;
	PS_STALL_BOTTON[6]   = PS_Transfer_Page6;
	PS_STALL_BOTTON[7]   = PS_Transfer_Page7;
	PS_STALL_BOTTON[8]   = PS_Transfer_Page8;
	PS_STALL_BOTTON[9]   = PS_Transfer_Page9;
	PS_STALL_BOTTON[10]  = PS_Transfer_Page10;
	
	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end

end

--===============================================
-- OnEvent
--===============================================
function PS_Transfer_OnEvent(event)

	if ( event == "PS_OPEN_OTHER_TRANS" )   then
	
		this:Show();
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Transfer");	
		
		--ÇÐ»»ÊÇ³èÎï»¹ÊÇÎïÆ·
		if( tonumber(arg1) == 1 ) then
			g_CurStallObj = STALL_ITEM;
			PS_Transfer_Item_Set:Show();
			PS_Transfer_PetList:Hide();
			for  i=1, PS_BUTTON_NUM   do
				PS_BUTTON[i]:Show();
			end
		else
			g_CurStallObj = STALL_PET;
			PS_Transfer_Item_Set:Hide();
			PS_Transfer_PetList:Show();
			for  i=1, PS_BUTTON_NUM   do
				PS_BUTTON[i]:Hide();
			end
		end
		
		g_nCurStallIndex = 1;
		g_StallNum = PlayerShop:GetStallNum("other");
		
		PS_Transfer_UpdateFrame();
		
	elseif ( event == "PS_UPDATE_OTHER_TRANS" )   then
		PS_Transfer_UpdateFrame();
	
	elseif ( event == "PS_OTHER_TRANS_SELECT" )   then
		--PS_Transfer_UpdateFrame();
	elseif event == "BUYPSSUCCESS_CLOSE_SHOPLIST" then --???????????????
		--Òþ²Ø½çÃæ		
		this:Hide();		
		this:CareObject(objCared, 0, "PS_Transfer");
	
	elseif ( event == "OBJECT_CARED_EVENT" )   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_Transfer");
		end	
	elseif(event =="UNIT_MONEY") then
		PS_Transfer_Self_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
end


--===============================================
-- OnEvent
--===============================================
function PS_Transfer_UpdateFrame()
	--Í¨ÖªC ++
	PlayerShop:SetCurSelectPage("other",g_nCurStallIndex-1);
	
	--µêÖ÷	--¸ÄÎª³¬Á´½Ó by wangdw
	local szName = PlayerShop:GetShopInfo("other","ownername");
	PS_Transfer_Master:SetChatString("#GChü ti®m: #{_INFOUSR".. szName .. "}");

	--µêÆÌID
	local shopIndex = PlayerShop:GetShopInfo("other", "shopindex")
	if (tonumber(shopIndex) <= 0) then
		PS_Transfer_DPID_Text:SetText("ID cØa ti®m:")
	else
		PS_Transfer_DPID_Text:SetText("ID cØa ti®m:" .. shopIndex)
	end

	--µêÖ÷ID
	local szID = PlayerShop:GetShopInfo("other","ownerid");
	PS_Transfer_ID:SetText("ID chü ti®m:  ".. szID);
	
	--µêÃû
	local szShopName = PlayerShop:GetShopInfo("other","shopname");
	PS_Transfer_Name_Text:SetText("Tên ti®m: " .. szShopName);
	PS_Transfer_PageHeader_Name:SetText("#gFF0FA0" ..szShopName);
	
	--µ±Ç°±¾½ð
	local nBaseMoney = PlayerShop:GetMoney("base","other");
	PS_Transfer_CurBase_Money:SetProperty("MoneyNumber", tostring(nBaseMoney));
	
	--Ó®Àû×Ê½ð
	local nProfitMoney = PlayerShop:GetMoney("profit","other");
	PS_Transfer_Gain_Money:SetProperty("MoneyNumber", tostring(nProfitMoney));

	local bSaleType = PlayerShop:LuaFnGetSaleType("other");
	local nSaleOutMoney = PlayerShop:GetMoney("saleout","other");
	--ÅÐ¶Ï½ðÇ®ºÍÔª±¦
	if bSaleType == 0 then--????
		PS_Transfer_Sale_Name:SetText("#{INTERFACE_XML_483}")
		PS_Transfer_Self_Name:SetText("#{INTERFACE_XML_631}")
		PS_Transfer_Sale_Money:Show()
		PS_Transfer_Self_Money:Show()
		PS_Transfer_Sale_YuanBao:Hide()
		PS_Transfer_Self_YuanBao:Hide()
		--ÅÌ³öµê¼Û¸ñ
		PS_Transfer_Sale_Money:SetProperty("MoneyNumber", tostring(nSaleOutMoney));
		--ÉíÉÏÏÖ½ð
		PS_Transfer_Self_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif bSaleType == 1 then--????
		PS_Transfer_Sale_Name:SetText("#{DPPC_150327_11}")
		PS_Transfer_Self_Name:SetText("#{DPPC_150327_18}")
		PS_Transfer_Sale_Money:Hide()
		PS_Transfer_Self_Money:Hide()
		PS_Transfer_Sale_YuanBao:Show()
		PS_Transfer_Self_YuanBao:Show()
		PS_Transfer_Sale_YuanBao:SetText(tostring(nSaleOutMoney))
		PS_Transfer_Self_YuanBao:SetText(tostring(Player:GetData("YUANBAO")));
	end

	--½çÃæ¿Ø¼þµÄÒ»Ð©¸üÐÂ
	if( g_nCurStallIndex == 1 )  then
		PS_Transfer_Last:Disable();
	else
		PS_Transfer_Last:Enable();
	end
	if( g_nCurStallIndex == g_StallNum )   then
		PS_Transfer_Next:Disable();
	else
		PS_Transfer_Next:Enable();
	end
	PS_Transfer_PageNum:SetText(tostring(g_nCurStallIndex).."/".. tostring(g_StallNum));
	
	--ÄÜ¹»µã»÷µÄ1234567890
	for i=1 ,PS_STALL_NUM  do
		PS_STALL_BOTTON[i]:Disable();
	end
	for i=1 ,g_StallNum  do
		PS_STALL_BOTTON[i]:Enable();
	end
	
	if( g_CurStallObj == STALL_ITEM )then
		PS_Transfer_UpdateItem();
	else
		PS_Transfer_UpdatePet();
	end
	PS_STALL_BOTTON[g_nCurStallIndex]:SetCheck(1);
end

--===============================================
-- UpdatePet
--===============================================
function PS_Transfer_UpdatePet()
	PS_Transfer_PetList:ClearListBox();
	
	local PetInListIndex = 0
	for i=1,  20  do
		local szPetName,szType = PlayerShop:EnumPet("other",g_nCurStallIndex -1, i-1);
		if (szPetName ~= "")   then

			PS_Transfer_PetList:AddItem(szPetName .. "#cffff00 (" .. szType .. ")", PetInListIndex);
			g_PetIndex[PetInListIndex] = i-1;
			PetInListIndex = PetInListIndex + 1 ;
		end
	end
end


--===============================================
-- UpdateItem
--===============================================
function PS_Transfer_UpdateItem()
	--¸üÐÂÉÌÆ·
	for i=1, PS_BUTTON_NUM    do
		local theAction, bLocked = PlayerShop:EnumItem(g_nCurStallIndex-1, i-1, "other");

		if theAction:GetID() ~= 0 then
			PS_BUTTON[i]:SetActionItem(theAction:GetID());
			
			if g_nCurSelectItem == i   then 
				PS_BUTTON[i]:SetPushed(1);
			else
				PS_BUTTON[i]:SetPushed(0);
			end
			if(bLocked == true) then 
				PS_BUTTON[i]:Disable();
			else
				PS_BUTTON[i]:Enable();
			end
		else
			PS_BUTTON[i]:SetActionItem(-1);
		end
	end
end


--===============================================
-- ¹ºÂò
--===============================================
function PS_Transfer_BuyClick()
	local bSaleType = PlayerShop:LuaFnGetSaleType("other");
	local nSaleOutMoney = PlayerShop:GetMoney("saleout","other");
	if bSaleType == 0 then
		local HaveMoney = Player:GetData("MONEY");
		if(tonumber(HaveMoney)<tonumber(nSaleOutMoney))then
			PushDebugMessage("#{GMGameInterface_Script_PlayerShop_NOMONEY}")
			return
		end
	elseif bSaleType == 1 then
		local HaveYuanBao = Player:GetData("YUANBAO");
		if(tonumber(HaveYuanBao)<tonumber(nSaleOutMoney))then
			PushDebugMessage("#{DPPC_150327_13}")
			return
		end
	else
		return
	end
	local nlevel = Player:GetData( "LEVEL" );
	if(nlevel<50)then
		PushDebugMessage("#{GMGameInterface_Script_PlayerShop_12}")
		return
	end
	local szName = PlayerShop:GetShopInfo("other","ownername");
	local shopIndex = PlayerShop:GetShopInfo("other", "shopindex")
	PushEvent("OPEN_PS_MESSAGE_FRAME", "ps_buy", bSaleType, nSaleOutMoney, szName, shopIndex)
	-- this:Hide();
	-- --È¡Ïû¹ØÐÄ
	-- this:CareObject(objCared, 0, "PS_Transfer");
end

--===============================================
-- Àë¿ª
--===============================================
function PS_Transfer_ExitClick()
	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_Transfer");
end

--===============================================
-- Ñ¡Ôñ±àºÅ
--===============================================
function PS_Transfer_Page_Click(nIndex)

	g_nCurStallIndex = nIndex;

	--Ïò·þÎñÆ÷ÇëÇóÊý¾Ý
	PS_Transfer_Last:Disable();	
	PS_Transfer_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	PlayerShop:AskStallData("other",g_nCurStallIndex -1);

end

--===============================================
-- ÉÏÒ»¼ä
--===============================================
function PS_Transfer_Last_Click()
	
	if(g_nCurStallIndex == 1) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex - 1;

	--Ïò·þÎñÆ÷ÇëÇóÊý¾Ý
	PS_Transfer_Last:Disable();	
	PS_Transfer_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	
	PlayerShop:AskStallData("other",g_nCurStallIndex -1);

end

--===============================================
-- ÏÂÒ»¼ä
--===============================================
function PS_Transfer_Next_Click()
	
	if(g_nCurStallIndex == g_StallNum) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex + 1;

	--Ïò·þÎñÆ÷ÇëÇóÊý¾Ý
	PS_Transfer_Last:Disable();	
	PS_Transfer_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	
	PlayerShop:AskStallData("other",g_nCurStallIndex -1);

end

--===============================================
-- ×ó¼üÑ¡ÖÐ³èÎï
--===============================================
function PS_Transfer_PetList_Selected()
	
	local nIndex = PS_Transfer_PetList:GetFirstSelectItem();

end

--===============================================
-- ÓÒ¼üÑ¡ÖÐ³èÎï
--===============================================
function PS_Transfer_PetList_RClick()

	local nIndex = PS_Transfer_PetList:GetFirstSelectItem();
	
	if( nIndex == -1 )   then
		return;
	end
	
	PlayerShop:ViewPetDesc("other",g_PetIndex[nIndex]);

end
