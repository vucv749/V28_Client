local PS_BUTTON_NUM = 20;
local PS_BUTTON = {};

local PS_STALL_NUM = 10;
local PS_STALL_BOTTON = {};

local g_nCurSelectItem = -1;
local g_nCurStallIndex = -1;

local g_StallNum = 0;
local g_bCurStallOpen = 0;

--±êÖ¾µ±Ç°ÊÇ äÊÞ½çÃæ»¹ÊÇÎïÆ·½çÃæ
local STALL_NONE = 0
local STALL_ITEM = 1;
local STALL_PET  = 2;
local g_CurStallObj = STALL_NONE;

local g_SaleOuting = 0;
 
local g_PetIndex  = {};

local STATUS_LOCKED = 0;
local STATUS_UNLOCKED = 1;
local STATUS_UNLOCKING = 2;

--±êÖ¾×Ô¼ºÉí·Ý£¨µêÖ÷»¹ÊÇ»ï¼Æ£©
local g_SelfPlace  = "";

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_lastIndex = -1;
--===============================================
-- PreLoad
--===============================================
function PS_ShopMag_PreLoad()
	this:RegisterEvent("PS_OPEN_MY_SHOP");
	this:RegisterEvent("PS_UPDATE_MY_SHOP");
	this:RegisterEvent("PS_SELF_ITEM_CHANGED");
	this:RegisterEvent("PS_SELF_SELECT");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_SHOP_RENAME");
	this:RegisterEvent("PS_CLOSE_ALL_SHOP");
    this:RegisterEvent("UI_COMMAND");
	
end

--===============================================
-- OnLoad
--===============================================
function PS_ShopMag_OnLoad()
	
	PS_BUTTON[1]  = PS_ShopMag_Item1; 
	PS_BUTTON[2]  = PS_ShopMag_Item2; 
	PS_BUTTON[3]  = PS_ShopMag_Item3; 
	PS_BUTTON[4]  = PS_ShopMag_Item4; 
	PS_BUTTON[5]  = PS_ShopMag_Item5; 
	PS_BUTTON[6]  = PS_ShopMag_Item6; 
	PS_BUTTON[7]  = PS_ShopMag_Item7; 
	PS_BUTTON[8]  = PS_ShopMag_Item8; 
	PS_BUTTON[9]  = PS_ShopMag_Item9; 
	PS_BUTTON[10] = PS_ShopMag_Item10;
	PS_BUTTON[11] = PS_ShopMag_Item11;
	PS_BUTTON[12] = PS_ShopMag_Item12;
	PS_BUTTON[13] = PS_ShopMag_Item13;
	PS_BUTTON[14] = PS_ShopMag_Item14;
	PS_BUTTON[15] = PS_ShopMag_Item15;
	PS_BUTTON[16] = PS_ShopMag_Item16;
	PS_BUTTON[17] = PS_ShopMag_Item17;
	PS_BUTTON[18] = PS_ShopMag_Item18;
	PS_BUTTON[19] = PS_ShopMag_Item19;
	PS_BUTTON[20] = PS_ShopMag_Item20;
	
	PS_STALL_BOTTON[1]   = PS_ShopMag_Page1;
	PS_STALL_BOTTON[2]   = PS_ShopMag_Page2;
	PS_STALL_BOTTON[3]   = PS_ShopMag_Page3;
	PS_STALL_BOTTON[4]   = PS_ShopMag_Page4;
	PS_STALL_BOTTON[5]   = PS_ShopMag_Page5;
	PS_STALL_BOTTON[6]   = PS_ShopMag_Page6;
	PS_STALL_BOTTON[7]   = PS_ShopMag_Page7;
	PS_STALL_BOTTON[8]   = PS_ShopMag_Page8;
	PS_STALL_BOTTON[9]   = PS_ShopMag_Page9;
	PS_STALL_BOTTON[10]  = PS_ShopMag_Page10;
	
	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end
	
end

--===============================================
-- OnEvent
--===============================================
function PS_ShopMag_OnEvent(event)
	if ( event == "PS_OPEN_MY_SHOP" )   then
	
		this:Show();
		--objCared = tonumber(arg0);
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_ShopMag");	
		PS_ShopMag_FriendID:SetText( "" );


		--²éÑ¯ÊÇ²»ÊÇ´¦ÓÚÅÌ³ö×´Ì¬
		g_SaleOuting = PlayerShop:IsSaleOut("self");

		--ÇÐ»»ÊÇ äÊÞ»¹ÊÇÎïÆ·
		if( tonumber(arg1) == 1 ) then
			g_CurStallObj = STALL_ITEM;
			PS_ShopMag_PetList:Hide();
			PS_ShopMag_Item_Frame:Show();
			PS_ShopMag_OpenRecycleShop_Btn:Show();
		else
			g_CurStallObj = STALL_PET;
			PS_ShopMag_PetList:Show();
			PS_ShopMag_Item_Frame:Hide();
			PS_ShopMag_OpenRecycleShop_Btn:Hide();
		end
		
		g_nCurStallIndex = 1;

		local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
		PlayerShop:SetCurSelectPage("self", actIndex);
		g_StallNum = PlayerShop:GetStallNum("self");
		
		PS_ShopMag_UpdateFrame();
		
	--¸üÃûÉÌµê
	elseif(event == "PS_SHOP_RENAME")      then
		--µêÃû
		local szShopName = PS_ShopMag_MerchantName:GetText();
		PS_ShopMag_MerchantName:SetText(szShopName);
		PS_ShopMag_PageHeader:SetText("#gFF0FA0"..szShopName);
		
		
	--¸üÐÂÉÌµê
	elseif(event == "PS_UPDATE_MY_SHOP")      then
		if(this:IsVisible() == false)  then
			return;
		end
		
		-- É¾³ýµ±Ç°¹ñÌ¨³É¹¦µÄÊ±ºò£¬ÒªÖØÐÂÇëÇóµÚÒ»¸ö¹ñÌ¨
		if ( arg0 ~= nil ) and ( tonumber(arg0) == 12 ) then
			g_nCurStallIndex = 1;
			local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
			PlayerShop:AskStallData("self",actIndex);
			return;
		end
		
		--²éÑ¯ÊÇ²»ÊÇ´¦ÓÚÅÌ³ö×´Ì¬
		g_SaleOuting = PlayerShop:IsSaleOut("self");
		PlayerShop:ClearSelectPos("self");
		g_StallNum = PlayerShop:GetStallNum("self");
		PS_ShopMag_UpdateFrame();
		
	elseif(event == "PS_SELF_ITEM_CHANGED")   then
		--²éÑ¯ÊÇ²»ÊÇ´¦ÓÚÅÌ³ö×´Ì¬
		g_SaleOuting = PlayerShop:IsSaleOut("self");
		PS_ShopMag_UpdateFrame();
		
	--Ñ¡ÖÐÎïÆ·µÄ²Ù×÷
	elseif(event == "PS_SELF_SELECT")   then
		--²éÑ¯ÊÇ²»ÊÇ´¦ÓÚÅÌ³ö×´Ì¬
		g_SaleOuting = PlayerShop:IsSaleOut("self");
		g_nCurSelectItem = PlayerShop:GetSelectIndex("self");
		PS_ShopMag_UpdateFrame();
		
		local nOnSale = PlayerShop:IsSelectOnSale("item");
	 	
	 	if nOnSale == 0  then
	 		PS_ShopMag_DownStall:SetText("Thßþng Giá");
	 	else
	 		PS_ShopMag_DownStall:SetText("HÕ Giá");
	 	end

	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_ShopMag");
		end	
		
	elseif( event == "PS_CLOSE_ALL_SHOP" )    then
		this:Hide();
		
		--È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "PS_ShopMag");
		
	elseif( event == "UI_COMMAND" )    then
	
	    if( tonumber(arg0) == 19810222 ) then
    	    this:Hide();
		
		    --È¡Ïû¹ØÐÄ
		    this:CareObject(objCared, 0, "PS_ShopMag");
    	
    	elseif( tonumber(arg0) == 701800 ) then
				-- ¸üÐÂËø¶¨×´Ì¬
				local lockStatus = Get_XParam_INT( 0 );
				local leftTime = Get_XParam_INT( 1 );
				PlayerShop : SetLockStatus( lockStatus );
				PlayerShop : SetUnlockTime( leftTime );
				PS_ShopMag_UpdateFrame( );
	 			
	 		end
	end
end

--===============================================
-- Ñ¡ÖÐ äÊÞµÄ²Ù×÷
--===============================================
function PS_ShopMag_PetList_Selected()
	
	local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
	
	if(nIndex == -1)  then
		return;
	end
	
	PlayerShop:SetSelectPet( g_PetIndex[nIndex] );
	local nOnSale = PlayerShop:IsSelectOnSale("pet",g_PetIndex[nIndex]);

 	if nOnSale == 0  then
 		PS_ShopMag_DownStall:SetText("Thßþng Giá");
 	else
 		PS_ShopMag_DownStall:SetText("HÕ Giá");
 	end
 	
 	--Í¨ÖªC£«£«
	local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
	PlayerShop:SetCurSelectPetIndex("self", actIndex,g_PetIndex[nIndex]);
	
	--Í¨Öª½çÃæË¢ÐÂ"Ãû³Æ"ºÍ"¼Û¸ñ"
	-- ÏÔÊ¾ÏÖÔÚµÄÑ¡ÖÐµÄÎïÆ·»ò ßÊÇ äÊÞµÄ¼Û¸ñ
	if( g_CurStallObj == STALL_PET )then
		local nMoney = PlayerShop:GetObjPrice("self","pet");
		PS_ShopMag_PriceTag:SetProperty("MoneyNumber", tostring(nMoney));
		local szPetName = PlayerShop:GetObjName("self","pet");
		PS_ShopMag_TradeName:SetText(szPetName);
		
	end	
	
end

--===============================================
-- UpdateFrame()
--===============================================
function PS_ShopMag_UpdateFrame()
	
	if( g_nCurStallIndex > g_StallNum )   then 
		g_nCurStallIndex = 1;
		local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
		PlayerShop:AskStallData("self",actIndex);
		return;
	end
	
	--µêÖ÷  --¸ÄÎª³¬Á´½Ó by wangdw
	local szName = PlayerShop:GetShopInfo("self","ownername");
	PS_ShopMag_Shopkeeper_Name:SetChatString("#YðIªm chü: #{_INFOUSR".. szName .. "}");
	
	--µêÖ÷ID
	local szID = PlayerShop:GetShopInfo("self","ownerid");
	PS_ShopMag_Shopkeeper_ID:SetText("Ðiªm chü ID:".. szID);
	
	--µêÃû
	local szShopName = PlayerShop:GetShopInfo("self","shopname");
	PS_ShopMag_MerchantName:SetText(szShopName);
	PS_ShopMag_PageHeader:SetText("#gFF0FA0"..szShopName);

	--ÃèÊö
	local szShopDesc = PlayerShop:GetShopInfo("self","desc");
	PS_ShopMag_Bewrite:SetText(szShopDesc);
	
	--µêÖ÷±¾½ð
	local nBaseMoney = PlayerShop:GetMoney("base","self");
	PS_ShopMag_ShopCorpus:SetProperty("MoneyNumber", tostring(nBaseMoney));
	
	--Ó¯Àû×Ê½ð
	local nProfitMoney = PlayerShop:GetMoney("profit","self");
	PS_ShopMag_ShopProfit:SetProperty("MoneyNumber", tostring(nProfitMoney));
	
	--ÉÌÒµÖ¸Êý
	local szCommercialFactor = PlayerShop:GetCommercialFactor();
	PS_ShopMag_CommerceExponential:SetText("Buôn bán luÛ th×a:" .. szCommercialFactor);
	
	--À©½¨ºÍËõ¼õ
	PS_ShopMag_Curtail:Enable();
	PS_ShopMag_Continuation:Enable();
	if ( g_StallNum == 1 )   then
		PS_ShopMag_Curtail:Disable();					--??
	end
	
	if(g_StallNum == 10)  then
		PS_ShopMag_Continuation:Disable();			--??
	end
	
	--Í¨ÖªC£«£«
	local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
	PlayerShop:SetCurSelectPage("self",actIndex);
	
	--Ë¢ÐÂ½çÃæÏà¹Ø¿Ø¼þ
	if( g_nCurStallIndex == 1 )  then
		PS_ShopMag_Last:Disable();
	else
		PS_ShopMag_Last:Enable();
	end
	
	if( g_nCurStallIndex == g_StallNum )   then
		PS_ShopMag_Next:Disable();
	else
		PS_ShopMag_Next:Enable();
	end
	
	PS_ShopMag_CurrentlyPageNumber:SetText(tostring(g_nCurStallIndex).."/".. tostring(g_StallNum));
	for i=1 ,PS_STALL_NUM  do
		PS_STALL_BOTTON[i]:Disable();
	end
	for i=1 ,g_StallNum  do
		PS_STALL_BOTTON[i]:Enable();
	end
	
	if( g_CurStallObj == STALL_ITEM )then
		PS_ShopMag_UpdateItem();
	else
		PS_ShopMag_UpdatePet();
	end
	

	--µêÆÌID
	local shopIndex = PlayerShop:GetShopInfo("self","shopindex")
	if (tonumber(shopIndex) <= 0) then
		PS_ShopMag_DPID:SetText("CØa hàng ID:")
	else
		PS_ShopMag_DPID:SetText("CØa hàng ID:" .. shopIndex)
	end

	--ÌáÊ¾ â¸ö¹ñÌ¨µ±Ç°µÄ×´Ì¬ÊÇOpen»¹ÊÇClose
	local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
	g_bCurStallOpen = PlayerShop:IsOpenStall("self",actIndex);
	
	if (g_bCurStallOpen == 2)  then 
		PS_ShopMag_Open:SetText("Ðóng cØa");
		PS_ShopMag_DownStall:Enable();
		PS_ShopMag_Stall_State:SetText("Trß¾c m£t qu¥y trÕng thái: #GkHai trß½ng");
	else
		PS_ShopMag_Open:SetText("Khai trß½ng");
		PS_ShopMag_DownStall:Disable();
		PS_ShopMag_Stall_State:SetText("Trß¾c m£t qu¥y trÕng thái: #RðÓng cØa");
	end
	
	-- ÏÔÊ¾ÏÖÔÚµÄÑ¡ÖÐµÄÎïÆ·»ò ßÊÇ äÊÞµÄ¼Û¸ñ
	if( g_CurStallObj == STALL_ITEM )then
		local nMoney = PlayerShop:GetObjPrice("self","item");
		PS_ShopMag_PriceTag:SetProperty("MoneyNumber", tostring(nMoney));
		local szItemName = PlayerShop:GetObjName("self","item");
		PS_ShopMag_TradeName:SetText(szItemName);
		
	else
		local nMoney = PlayerShop:GetObjPrice("self","pet");
		PS_ShopMag_PriceTag:SetProperty("MoneyNumber", tostring(nMoney));
		local szPetName = PlayerShop:GetObjName("self","pet");
		PS_ShopMag_TradeName:SetText(szPetName);
		 
	end	
	
	PS_ShopMag_ShowHide_Windows();

	--ºÏ»ïÈË¹ÜÀí²¿·Ö
	PS_ShopMag_FriendList:ClearListBox();
	local nNum = PlayerShop:GetFriendNum();
	for i=0 ,nNum-1  do
		local szFriendName = PlayerShop:EnumFriend(i);
		PS_ShopMag_FriendList:AddItem(szFriendName, i);
	
	end
	PS_STALL_BOTTON[g_nCurStallIndex]:SetCheck(1);
		

	-- ¸üÐÂËø¶¨×´Ì¬
	PS_Update_LockStatus( );
	
end

--===============================================
-- ¸üÐÂÎïÆ·,ÏÈShowËùÓÐµÄWindow£¬È»ºó¸ù¾ÝÐèÒªHideÏà¹Ø
--===============================================
function PS_ShopMag_ShowHide_Windows()

	PS_ShopMag_NameAmend:Show();			-- ????
	PS_ShopMag_BewriteAmend:Show();		-- ??????
	PS_ShopMag_SortAmend:Show();			-- ????

	PS_ShopMag_DrawMoney:Show();			-- ??
	
	PS_ShopMag_AccountBook:Show();		-- ??
	PS_ShopMag_Open:Show();						-- ??
	PS_ShopMag_DownStall:Show();			-- ?(?)?
	PS_ShopMag_TakeBack:Show();				-- ??
	PS_ShopMag_DisposeOf:Show();			-- ??
	PS_ShopMag_Curtail:Show();				-- ??
	PS_ShopMag_Continuation:Show();		-- ??
	
	PS_ShopMag_Add:Show();						-- ??????
	PS_ShopMag_FriendID:Show();				-- ??ID???
	PS_ShopMag_Del:Show();						-- ??????
	PS_ShopMag_ViewLog:Show();				-- ??????
	
	-- [xh 2009--05-22 Íæ¼ÒÉÌµê±£»¤]
	PS_ShopMag_Stall_StateSuo2 : Show( );					-- ????
	PS_ShopMag_Stall_StateSuo2 : Enable( );
	PS_ShopMag_OpenRecycleShop_BtnSuo2 : Show( );	-- ???????
	PS_ShopMag_OpenRecycleShop_BtnSuo2 : Enable( );
	PS_ShopMag_DisposeOf : Show( );								-- ????
	PS_ShopMag_DisposeOf : Enable( );
	-- [xh]
	
	if( g_CurStallObj == STALL_ITEM ) then
			PS_ShopMag_OpenRecycleShop_Btn:Show();
	else
			PS_ShopMag_OpenRecycleShop_Btn:Hide();
	end
	--PS_ShopMag_OpenRecycleShop_Btn:Show();			--Ê ¹º
	
		
	if( g_SaleOuting == 1) then --??????
		PS_ShopMag_DisposeOf:SetText("H°i C¤u");
		--ÖÃ»Ò²»ÄÜÊ¹ÓÃµÄ¹¦ÄÜ						
		PS_ShopMag_SortAmend:Hide();		-- ????
		PS_ShopMag_Open:Hide();         -- ??
		PS_ShopMag_DownStall:Hide();    -- ?(?)?
		PS_ShopMag_TakeBack:Hide();     -- ??
		PS_ShopMag_NameAmend:Hide();    -- ????
		PS_ShopMag_BewriteAmend:Hide(); -- ??????
		PS_ShopMag_DrawMoney:Hide();    -- ??
		PS_ShopMag_AccountBook:Hide();	-- ??
		PS_ShopMag_Curtail:Hide();			-- ??
		PS_ShopMag_Continuation:Hide();	-- ??
			
		-- [xh 2009--05-22 Íæ¼ÒÉÌµê±£»¤]
		PS_ShopMag_Stall_StateSuo2 : Hide( );							-- ??????
		PS_ShopMag_OpenRecycleShop_BtnSuo2 : Disable( );	-- ?????????
		-- [xh]
			
		--µêÃû
		local szShopName = PlayerShop:GetShopInfo("self","shopname");
		szShopName = szShopName .. "(Bàn Xu¤t Trung)"
		PS_ShopMag_PageHeader:SetText("#gFF0FA0"..szShopName);
		
		--ÎïÆ·½«²»ÄÜÍÏ¶¯
		for i=1 , 20   do
			PS_BUTTON[i]:SetProperty("DraggingEnabled", "False");
		end
		
		PS_ShopMag_OpenRecycleShop_Btn:Hide();	--??
			
		PS_ShopMag_ImmitCorpus : Disable();
		PS_ShopMag_Immit : Disable();
		PS_ShopMag_Add : Disable();
		PS_ShopMag_Del : Disable();
		PS_ShopMag_ViewLog : Disable();
	else
		PS_ShopMag_DisposeOf:SetText("Bàn Xu¤t");
		--»Ø¸´ÎïÆ·µÄÍÏ¶¯
		for i=1 , 20   do
			PS_BUTTON[i]:SetProperty("DraggingEnabled", "True");
		end
		
		-- [xh 2009--05-22 Íæ¼ÒÉÌµê±£»¤]
		-- Èç¹ûÊÇÎ´ÅÌ³ö×´Ì¬£¬ÇÒÊÇ½âËøÖÐ£¬¾Í»ÒÉ«ÅÌ³ö°´Å¥£¬Èç¹ûÊÇËø¶¨×´Ì¬¾Í»ÒÉ«Ëø¶¨°´Å¥
		local lockStatus = PlayerShop : GetLockStatus( );
		if( lockStatus == STATUS_UNLOCKING ) then
			PS_ShopMag_DisposeOf : Disable( );
		elseif( lockStatus == STATUS_LOCKED ) then
			PS_ShopMag_OpenRecycleShop_BtnSuo2 : Disable( );
		end
		-- [xh]
		
		PS_ShopMag_ImmitCorpus : Enable();
		PS_ShopMag_Immit : Enable();
		PS_ShopMag_Add : Enable();
		PS_ShopMag_Del : Enable();
		PS_ShopMag_ViewLog : Enable();
	end

	-- »ñµÃ×Ô¼ºµÄÉí·Ý
	g_SelfPlace = PlayerShop:GetSelfPlace();
	if(g_SelfPlace ~= "boss")   then
		PS_ShopMag_NameAmend:Hide();
		PS_ShopMag_BewriteAmend:Hide();
		PS_ShopMag_SortAmend:Hide();
		PS_ShopMag_DisposeOf:Hide();
		PS_ShopMag_Curtail:Hide();
		PS_ShopMag_Continuation:Hide();
		PS_ShopMag_Add:Hide();
		PS_ShopMag_FriendID:Hide();
		PS_ShopMag_DrawMoney:Hide();
		PS_ShopMag_Del:Hide();
		PS_ShopMag_OpenRecycleShop_BtnSuo2:Hide();
	end
		
end
--Ê ¹º°´Å¥
function PS_ShopMag_OpenRecycleShop_Click()
	local SelfPlace = PlayerShop:GetSelfPlace();
	PlayerShop:OpenRecycleShopDLG(SelfPlace);
end

--===============================================
-- ¸üÐÂÎïÆ·
--===============================================
function PS_ShopMag_UpdateItem()

	-- ¸üÐÂ×ÓÀàÁÐ±í
	PS_ShopMag_SelectSort:ResetList();
	PS_ShopMag_SelectSort:ComboBoxAddItem("V§t ph¦m Ðiªm",0);
	PS_ShopMag_SelectSort:ComboBoxAddItem("Bäo thÕch Ðiªm",1);
	PS_ShopMag_SelectSort:ComboBoxAddItem("Vû khí ðiªm",2);
	PS_ShopMag_SelectSort:ComboBoxAddItem("Hµ giáp Ðiªm",3);
	PS_ShopMag_SelectSort:ComboBoxAddItem("Tài li®u Ðiªm",4);

	--ÉÌµê×ÓÀà
	local nShopSubType = PlayerShop:GetCurShopType("self");
	PS_ShopMag_SelectSort:SetCurrentSelect(nShopSubType - 1);
	-- ×¢Òâµ±Ç°»æÖÆµÄÊÇµÚg_nCurStallIndex¸ö¹ñÌ¨ÉÏµÄÎïÆ·
	g_nCurSelectItem = PlayerShop:GetSelectIndex("self");
	
	for i=1, PS_BUTTON_NUM    do
		local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
		local theAction, bLocked = PlayerShop:EnumItem(actIndex, i-1, "self");

		if theAction:GetID() ~= 0 then
			PS_BUTTON[i]:SetActionItem(theAction:GetID());
			if g_nCurSelectItem == i   then
				PS_BUTTON[i]:SetPushed(1);
			else
				PS_BUTTON[i]:SetPushed(0);
			end
		else
			PS_BUTTON[i]:SetActionItem(-1);
		end
	end

end

--===============================================
-- ¸üÐÂ äÊÞÁÐ±í
--===============================================
function PS_ShopMag_UpdatePet()

	-- ¸üÐÂ×ÓÀàÁÐ±í
	PS_ShopMag_SelectSort:ResetList();
	PS_ShopMag_SelectSort:ComboBoxAddItem("CØa hàng Trân Thú",0);

	--ÉÌµê×ÓÀà
	local nShopSubType = PlayerShop:GetCurShopType("self");
	PS_ShopMag_SelectSort:SetCurrentSelect(nShopSubType - 6);
	
	PS_ShopMag_PetList:ClearListBox();
	
	local PetInListIndex = 0
	for i=1,  20  do
		local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
		local szPetName,bOnSale,szType = PlayerShop:EnumPet("self",actIndex, i-1);
		if (szPetName ~= "")   then
			if(bOnSale ~= 0)  then
				-- ºìÉ«±íÊ¾ÏÖÔÚµÄÎïÆ·ÊÇ´¦ÓÚÉÏ¼ÜµÄ×´Ì¬
				szPetName = "#c808080" .. szPetName;
			end
			PS_ShopMag_PetList:AddItem(szPetName .. "#cffff00 (" .. szType .. ")", PetInListIndex);
			g_PetIndex[PetInListIndex] = i-1;
			PetInListIndex = PetInListIndex + 1 ;
		end
	end
	
end

--===============================================
-- È¡»Ø
--===============================================
function PS_ShopMag_Retake_Click()
	
	if( g_CurStallObj == STALL_ITEM )    then
		PlayerShop:RetackItem("item");
	else
		--¼ì²âÊÇ²»ÊÇÓÐ äÊÞ±»Ñ¡ÖÐ
		local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
		
		if(nIndex == -1)  then
			PushDebugMessage("Thïnh Tiên lña ch÷n mµt cái Trân Thú.")
			return;
		end
		
		PlayerShop:RetackItem("pet");
	end
end

--===============================================
-- ÉÏ¼Ü(ÏÂ¼Ü)
--===============================================
function PS_ShopMag_UpDownStall_Click()

	if( g_CurStallObj == STALL_ITEM )     then
		if(PS_ShopMag_DownStall:GetText() == "Thßþng Giá")  then
			PlayerShop:InputMoney("ps_upitem");
		else
			PlayerShop:DownSale("item");
		end
		
	elseif( g_CurStallObj == STALL_PET )  then
		
		--¼ì²âÊÇ²»ÊÇÓÐ äÊÞ±»Ñ¡ÖÐ
		local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
		
		if(nIndex == -1)  then
			return;
		end
		
		if(PS_ShopMag_DownStall:GetText() == "Thßþng Giá")  then
			PlayerShop:InputMoney("ps_uppet");
		else
			PlayerShop:DownSale("pet");
		end
	end
	
end

--===============================================
-- ÉÏÒ»¼ä
--===============================================
function PS_ShopMag_Last_Click()
	if(g_nCurStallIndex == 1) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex - 1;
	
	--Ïò·þÎñÆ÷ÇëÇóÊý¾Ý
	PS_ShopMag_Last:Disable();
	PS_ShopMag_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	
	local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
	PlayerShop:AskStallData("self",actIndex);

end

--===============================================
-- ÏÂÒ»¼ä
--===============================================
function PS_ShopMag_Next_Click()
	if(g_nCurStallIndex == g_StallNum) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex + 1;
	
	--Ïò·þÎñÆ÷ÇëÇóÊý¾Ý
	PS_ShopMag_Last:Disable();
	PS_ShopMag_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
	PlayerShop:AskStallData("self",actIndex);

end

--===============================================
-- 1 2 3 4 5 6 7 8 9 10
--===============================================
function PS_ShopMag_Page_Click(nIndex)
	g_nCurStallIndex = nIndex;

	--Ïò·þÎñÆ÷ÇëÇóÊý¾Ý
	PS_ShopMag_Last:Disable();
	PS_ShopMag_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	
	local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
	PlayerShop:AskStallData("self",actIndex);

end

--===============================================
-- ³åÈë±¾½ð
--===============================================
function PS_ShopMag_ImmitCorpus_Click()
	PlayerShop:InputMoney("immitbase");
end

--===============================================
-- ³åÈë
--===============================================
function PS_ShopMag_Immit_Click()
	PlayerShop:InputMoney("immit");
end

--===============================================
-- Ö§È¡
--===============================================
function PS_ShopMag_DrawMoney_Click()
	PlayerShop:InputMoney("draw");
end

--===============================================
-- ¿ª Å(´òìÈ)           "PS_ShopMag_Open"
--===============================================
function PS_ShopMag_OpenCloseStall_Click()
	if(g_nCurStallIndex ~= -1)  then
		if ( g_bCurStallOpen == 1 )  then
			local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
			PlayerShop:OpenStall(actIndex, 1);
		else
			local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
			PlayerShop:OpenStall(actIndex, 0);
		end		
	end
	
end

--===============================================
-- ÐÞ¸Ä¹ã¸æÓïÑÔ
--===============================================
function PS_ShopMag_ModifyShopAD()

	local szAd = PS_ShopMag_Bewrite:GetText();
	PlayerShop:Modify("ad",szAd);

end

--===============================================
-- ÐÞ¸ÄÉÌµêÃû³Æ
--===============================================
function PS_ShopMag_ModifyShopName()

	local szName = PS_ShopMag_MerchantName:GetText();
	PlayerShop:Modify("name",szName);

end

--===============================================
-- ÓÒ¼üÑ¡ÖÐ äÊÞ£¨²é¿´ äÊÞ£©
--===============================================
function PS_ShopMag_PetList_RClick()
	local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
	
	if(nIndex == -1)  then
		return;
	end
	
	PlayerShop:ViewPetDesc("self",g_PetIndex[nIndex]);
end

--===============================================
-- ÅÌ³ö(ÅÌ»Ø)
--===============================================
function PS_ShopMag_DisposeOf_Click()
				
	if(g_SaleOuting == 0)   then
		-- Èç¹ûËø¶¨»ò ß½âËøÖÐ£¬¾Íµ¯³öÌáÊ¾
		local lockStatus = PlayerShop : GetLockStatus();
		if ( lockStatus ~= STATUS_UNLOCKED ) then
			PS_ShopMag_DoLock( 0 );	-- ??
			-- PushDebugMessage("click panchu, excute unlock!");
		else
			PlayerShop:Transfer("sale");
		end
	else
		PlayerShop:Transfer("info","back",0);
	end
end

--===============================================
-- ÊÇ·ñ´¦ÓÚÅÌ³ö×´Ì¬µÄ½çÃæ¸üÐÂ£¬1=ÅÌ³ö×´Ì¬£¬
--===============================================
function PS_ShopMag_Close()
	PlayerShop:CloseShop("self");
end

--===============================================
-- ´ò¿ª¹Ø±  Ë±¾
--===============================================
function PS_ShopMag_AccountBook_Clicked()
	PlayerShop:OpenMessage("exchange",0);
end

--===============================================
-- É¾³ýºÏ×÷»ï°é
--===============================================
function PS_ShopMag_Del_Click()

	local nIndex = PS_ShopMag_FriendList:GetFirstSelectItem();
	
	if(nIndex == -1)  then
		return;
	end

	PlayerShop:DealFriend("del", nIndex);
end

--===============================================
-- ²é¿´»ï°é¼ÇÂ¼
--===============================================
function PS_ShopMag_ViewLog_Click()
	PlayerShop:OpenMessage("manager",0);
end

--===============================================
-- Ìí¼ÓºÏ×÷»ï°é
--===============================================
function PS_ShopMag_Add_Click()
	PlayerShop:DealFriend("add", PS_ShopMag_FriendID:GetText());
end

--===============================================
-- Ñ¡ÖÐºÏ»ïÈË
--===============================================
function PS_ShopMag_FriendList_Selected()
	
end

--===============================================
-- Ëõ¼õ
--===============================================
function PS_ShopMag_Curtail_Click()
	local actIndex = PlayerShop:UIIndexToLogicIndex(g_nCurStallIndex-1, true)
	if( actIndex ~= -1 ) then
		PlayerShop:ChangeShopNum("del", actIndex);
	end
end

--===============================================
-- À©½¨
--===============================================
function PS_ShopMag_Continuation_Click()
	PlayerShop:ChangeShopNum("add");
end

function PS_ShopMag_SelectSort_Selected()
	
	local szName, nIndex = PS_ShopMag_SelectSort:GetCurrentSelect();
	if(nIndex == -1)  then
		return;
	end
	
	if(g_lastIndex ~= nIndex)then
		--¹Ø± µ¯³ö¿ò
		PlayerShop:CloseChangeTypeMsgBox();
	end
end
--===============================================
-- ÐÞ¸ÄÉÌµêÀàÐÍ
--===============================================
function PS_ShopMag_SortAmend_Click()
	local szName, nIndex = PS_ShopMag_SelectSort:GetCurrentSelect();
	if(nIndex == -1)then
		PushDebugMessage("Nhçm lña ch÷n Li­u mµt cái không có hi®u quä Tr¸, Thïnh mµt l¥n næa lña ch÷n");
		return;
	end
	if( g_CurStallObj == STALL_ITEM )     then
		local nShopSubType = PlayerShop:GetCurShopType("self");		
		if(nIndex+1 == nShopSubType)then
			PushDebugMessage("Thïnh lña ch÷n mµt cái khác nhau Ðích cØa hàng loÕi hình Tái sØa chæa!");
			return;
		end
		g_lastIndex = nIndex;
		PlayerShop:ModifySubType("ps_type", nIndex+1);
	else
		PushDebugMessage("Thïnh lña ch÷n mµt cái khác nhau Ðích cØa hàng loÕi hình Tái sØa chæa!");
		return;		
	end	
end

--===============================================
-- OnHiden
--===============================================
function PS_ShopMag_Frame_OnHiden()
	-- Í¨ÖªÏà¹ØµÄ½çÃæ¹Ø± £¬(PetList,PS_Input,)
	PlayerShop:CloseShopMag();
end

function PS_Update_LockStatus( )
	
	local lockStatus = PlayerShop : GetLockStatus();
	local leftTime = PlayerShop : GetUnlockTime();
		
	if ( lockStatus == STATUS_LOCKED ) then				-- ??
		PS_ShopMag_Stall_StateSuo2 : SetText( "#{SDS_90511_22}#{SDS_90511_4}" );
	elseif ( lockStatus == STATUS_UNLOCKED ) then		-- ???
		PS_ShopMag_Stall_StateSuo2 : SetText( "#{SDS_90511_22}#{SDS_90511_5}" );
	elseif ( lockStatus == STATUS_UNLOCKING ) then		-- ????
		local leftHour = math.floor( leftTime / 3600 );
		local leftDay = math.floor( leftHour / 24 );
		local lastDayLeftHour = math.mod( leftHour , 24 );
		local minute = math.floor(math.mod(leftTime, 3600)/60)
		if leftTime < 60 then
			minute = 1
		end
		local str1 = ScriptGlobal_Format("#{SDS_90511_25}", leftDay, lastDayLeftHour, minute )
		PS_ShopMag_Stall_StateSuo2 : SetText( "#{SDS_90511_22}"..str1 );
	end
	
end

function PS_ShopMag_Suo_Click( )

	PS_ShopMag_DoLock( 1 );	--??
	
end

function PS_ShopMag_DoLock( isLock )
	
	-- ¸ø·þÎñÆ÷¶Ë·¢ËÍ½Å±¾Ö´ÐÐÃüÁî
	Clear_XSCRIPT( )
		Set_XSCRIPT_Function_Name( "SetLock" )
		Set_XSCRIPT_ScriptID( 701800 )
		Set_XSCRIPT_Parameter( 0, g_CurStallObj - 1 )
		Set_XSCRIPT_Parameter( 1, isLock )
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT( )
	
end
