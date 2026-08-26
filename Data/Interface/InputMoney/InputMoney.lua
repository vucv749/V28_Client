
local g_nSaveOrGetMoney;
local SAVE_MONEY				= 1;
local GET_MONEY					= 2;
local EXCHANGE_MONEY 		= 3;
local STALLSALE_PRICE		= 4;
local STALLSALE_REPRICE	= 5;
local PS_PRICE_ITEM		  = 6;
local PS_IMMITBASE			= 7;
local PS_IMMIT					= 8;
local PS_DRAW						= 9;
local STALL_PET_UP			= 10;
local STALL_PRICE_PET		= 11;
local PS_PRICE_PET			= 12;
--local PS_TRANSFER				= 13;
local SAFEBOX_GET_MONEY = 14;
local SAFEBOX_SAVE_MONEY= 15;

--ĞŞ¸ÄÌ¯Î»ÎïÆ·¼Û¸ñĞèÒªµÄ
local nStallItemID = -1;
local nStallItemIndex = -1;

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_InputMoney_Frame_UnifiedXPosition;
local g_InputMoney_Frame_UnifiedYPosition;

--===============================================
-- OnLoad()
--===============================================
function InputMoney_PreLoad()
	this:RegisterEvent("TOGLE_INPUT_MONEY");
	
	this:RegisterEvent("BEING_MONEY");
	this:RegisterEvent("CLOSE_INPUT_MONEY");

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function InputMoney_OnLoad()

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_InputMoney_Frame_UnifiedXPosition	= InputMoney_Frame : GetProperty("UnifiedXPosition");
	g_InputMoney_Frame_UnifiedYPosition	= InputMoney_Frame : GetProperty("UnifiedYPosition");

end

--===============================================
-- OnEvent
--===============================================
function InputMoney_OnEvent(event)

	if(event == "TOGLE_INPUT_MONEY") then
		if(arg0~="price")then
			StallSale:UnlockSelItem();
		end
		if (arg0 == "get") then
			this:TogleShow();
			
			
			g_nSaveOrGetMoney = GET_MONEY;
			InputMoney_Title:SetText("#gFF0FA0Thü Ti«n");
			InputMoney_Accept_Button:SetText("Xác nh§n");
			
		elseif (arg0 == "save") then
			this:TogleShow();
			
			g_nSaveOrGetMoney = SAVE_MONEY;
			InputMoney_Title:SetText("#gFF0FA0T°n Ti«n");
			InputMoney_Accept_Button:SetText("Xác nh§n");
			
		elseif (arg0 == "exch") then
			this:TogleShow();
		
			g_nSaveOrGetMoney = EXCHANGE_MONEY;
			InputMoney_Title:SetText("#gFF0FA0ğßa vào giao d¸ch ti«n tài");
			InputMoney_Accept_Button:SetText("Xác nh§n");
			
		elseif (arg0 == "get_safebox") then
			this:TogleShow();
		
			g_nSaveOrGetMoney = SAFEBOX_GET_MONEY;
			InputMoney_Title:SetText("#gFF0FA0ğßa vào l¤y ti«n Ğích s¯ lßşng");
			InputMoney_Accept_Button:SetText("Xác nh§n");
		
		elseif (arg0 == "save_safebox") then
			this:TogleShow();
		
			g_nSaveOrGetMoney = SAFEBOX_SAVE_MONEY;
			InputMoney_Title:SetText("#gFF0FA0ğßa vào T°n Ti«n Ğích s¯ lßşng");
			InputMoney_Accept_Button:SetText("Xác nh§n");
		
		elseif (arg0 == "price") then
			this:Show();
			
			g_nSaveOrGetMoney = STALLSALE_PRICE;
			InputMoney_Title:SetText("#gFF0FA0thß½ng ph¦m báo giá");
			InputMoney_Accept_Button:SetText("Thßşng Giá");
			
		elseif (arg0 == "reprice") then
			this:TogleShow();
			
			g_nSaveOrGetMoney = STALLSALE_REPRICE;
			InputMoney_Title:SetText("#gFF0FA0sØa chæa báo giá");
			InputMoney_Accept_Button:SetText("Ğ±i");
			
		--Íæ¼ÒÉÌµêÉÏ¼Ü(ÎïÆ·)
		elseif (arg0 == "ps_upitem" ) then
			this:Show();
			g_nSaveOrGetMoney = PS_PRICE_ITEM;
			InputMoney_Title:SetText("#gFF0FA0thß½ng ph¦m giá cä");
			InputMoney_Accept_Button:SetText("Thßşng Giá");
			
		elseif (arg0 == "ps_uppet" ) then
			this:Show();
			g_nSaveOrGetMoney = PS_PRICE_PET;
			InputMoney_Title:SetText("#gFF0FA0Trân Thú giá cä");
			InputMoney_Accept_Button:SetText("Thßşng Giá");
		
--		--Íæ¼ÒÉÌµê³åÈë±¾½ğ
--		elseif (arg0 == "immitbase") then
--			this:Show();
--			g_nSaveOrGetMoney = PS_IMMITBASE;
--			InputMoney_Title:SetText("#gFF0FA0³äÈë±¾½ğ");
--			InputMoney_Accept_Button:SetText("È·¶¨");
--		
--		--Íæ¼ÒÉÌµê³åÈë
--		elseif (arg0 == "immit") then
--			this:Show();
--			g_nSaveOrGetMoney = PS_IMMIT;
--			InputMoney_Title:SetText("#gFF0FA0³äÈë");
--			InputMoney_Accept_Button:SetText("È·¶¨");
--		
--		--Íæ¼ÒÉÌµêÈ¡³ö
--		elseif (arg0 == "draw") then
--			this:Show();
--			g_nSaveOrGetMoney = PS_DRAW;
--			InputMoney_Title:SetText("#gFF0FA0Ö§È¡");
--			InputMoney_Accept_Button:SetText("È·¶¨");
			
		elseif (arg0 == "st_pet") then
			this:Show();
			g_nSaveOrGetMoney = STALL_PET_UP;
			InputMoney_Title:SetText("#gFF0FA0Trân Thú giá cä");
			InputMoney_Accept_Button:SetText("Thßşng Giá");
		
		elseif (arg0 == "petrepice") then
			this:Show();
			g_nSaveOrGetMoney = STALL_PRICE_PET;
			InputMoney_Title:SetText("#gFF0FA0Trân Thú giá cä");
			InputMoney_Accept_Button:SetText("Xác nh§n");
			
		elseif (arg0 == "transfershop") then
			-- this:Show();
			-- g_nSaveOrGetMoney = PS_TRANSFER;
			-- InputMoney_Title:SetText("#gFF0FA0ÊäÈëÉÌµê¶¨¼Û");
			-- InputMoney_Accept_Button:SetText("È·¶¨");
			
		end
		
		InputMoney_Gold:SetText("");
		InputMoney_Silver:SetText("");
		InputMoney_CopperCoin:SetText("");
		InputMoney_Accept_Button:Disable();
		
		if (g_nSaveOrGetMoney == GET_MONEY) then
			local nMoney,nGold,nSilver,nCopper = Bank:GetBankMoney();
			if nGold>99999 then nGold = 99999; nSilver = 99; nCopper = 99; end
			if (nGold == 0) then 
				if (nSilver == 0) then
					InputMoney_Gold:SetText(tostring(nGold));
					InputMoney_Silver:SetText(tostring(nSilver));
					InputMoney_CopperCoin:SetText(tostring(nCopper));
					InputMoney_CopperCoin:SetSelected(0,-1);
					InputMoney_CopperCoin:SetProperty("DefaultEditBox", "True");
				else
					InputMoney_Gold:SetText(tostring(nGold));
					InputMoney_Silver:SetText(tostring(nSilver));
					InputMoney_Silver:SetSelected(0,-1);
					InputMoney_Silver:SetProperty("DefaultEditBox", "True");
					InputMoney_CopperCoin:SetText("0");
				end
			else
				InputMoney_Gold:SetText(tostring(nGold));
				InputMoney_Gold:SetSelected(0,-1);
				InputMoney_Gold:SetProperty("DefaultEditBox", "True");
				InputMoney_Silver:SetText("0");
				InputMoney_CopperCoin:SetText("0");
			end
			
		elseif (g_nSaveOrGetMoney == SAVE_MONEY) then
			local nGold,nSilver,nCopper = Bank:GetBagMoney();
			if nGold>99999 then nGold = 99999; nSilver = 99; nCopper = 99; end
			if (nGold == 0) then 
				if (nSilver == 0) then
					InputMoney_Gold:SetText(tostring(nGold));
					InputMoney_Silver:SetText(tostring(nSilver));
					InputMoney_CopperCoin:SetText(tostring(nCopper));
					InputMoney_CopperCoin:SetSelected(0,-1);
					InputMoney_CopperCoin:SetProperty("DefaultEditBox", "True");
				else
					InputMoney_Gold:SetText(tostring(nGold));
					InputMoney_Silver:SetText(tostring(nSilver));
					InputMoney_Silver:SetSelected(0,-1);
					InputMoney_Silver:SetProperty("DefaultEditBox", "True");
					InputMoney_CopperCoin:SetText("0");
				end
			else
				InputMoney_Gold:SetText(tostring(nGold));
				InputMoney_Gold:SetSelected(0,-1);
				InputMoney_Gold:SetProperty("DefaultEditBox", "True");
				InputMoney_Silver:SetText("0");
				InputMoney_CopperCoin:SetText("0");
			end			
		end

		
		if( (this:IsVisible() == true) and (g_nSaveOrGetMoney ~= GET_MONEY) and (g_nSaveOrGetMoney ~= SAVE_MONEY) )  then 
			InputMoney_Gold:SetProperty("DefaultEditBox", "True");
			
			--È·¶¨ â¸ö´°¿ÚµÄ·ÅÖÃÎ»ÖÃ
			--local nPosX ;
			--local nPosY ;
			--nPosX,nPosY = GetCurMousePos();
			--AxTrace(0,0,"nPosX =" .. tostring(nPosX) "   nPosY =" .. tostring(nPosY));
			--InputMoney_Frame:AutoMousePosition(nPosX, nPosY);

		end
		
	elseif( event == "CLOSE_INPUT_MONEY")	 then
		this:Hide();
	
	end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ
		InputMoney_Frame_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ	
		InputMoney_Frame_On_ResetPos()
	end

end


--===============================================
-- ÊäÈë½ğÇ®ºóÈ·¶¨
--===============================================
function InputMoneyAccept_Clicked()

	local szGold = InputMoney_Gold:GetText();
	local szSilver = InputMoney_Silver:GetText();
	local szCopperCoin = InputMoney_CopperCoin:GetText();
	
	--ÔÚ³ÌĞòÀïÍ·ÔÙ¼ì²âÊäÈë×Ö·ûµÄÓĞĞ§ĞÔºÍÊıÖµ
	local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin);
	
	--???Ê²Ã´Çé¿öÏÂÊ§°ÜĞèÒªÔÙ¶¨
	if(bAvailability == true) then
		
		if( g_nSaveOrGetMoney == SAVE_MONEY ) then
			--Ö´ĞĞ´æÇ®²Ù×÷
			Bank:SaveMoneyToBank(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == GET_MONEY ) then
			--Ö´ĞĞÈ¡Ç®²Ù×÷
			Bank:GetMoneyFromBank(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == EXCHANGE_MONEY ) then
			--Ö´ĞĞExchangÖĞµÄ½ğÇ®µÄÊäÈë
			Exchange:GetMoneyFromInput(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == SAFEBOX_GET_MONEY ) then
			--Ö´ĞĞ±£Ï ÏäÖĞµÄ½ğÇ®µÄÊäÈë
			SafeBox("realgetmoney", nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == SAFEBOX_SAVE_MONEY ) then
			--Ö´ĞĞ±£Ï ÏäÖĞµÄ½ğÇ®µÄÊäÈë
			SafeBox("realsavemoney", nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == STALLSALE_PRICE ) then
			--Ö´ĞĞStallSaleÖĞµÄÉÌÆ·±ê¼Û(Ìá½»ÉÌÆ·¼Û¸ñ)
			StallSale:ReferItemPrice(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == STALLSALE_REPRICE ) then
			--Ö´ĞĞStallSaleÖĞµÄÉÌÆ·¸ü¸Ä¼Û¸ñ

			--´ÓÈ«¾Ö±äÁ¿ÖĞÈ¡³öÊı¾İ
			nStallItemID		= GetGlobalInteger("StallSale_ItemID");
			nStallItemIndex = GetGlobalInteger("StallSale_Item");

			if nMoney==0 then 
				PushDebugMessage("#{GMGameInterface_Script_StallSale_Info_Pet_Price_Is_0_re}")
				this:Hide();
				return
			end
			StallSale:ItemReprice(nMoney,nStallItemID,nStallItemIndex);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == PS_PRICE_ITEM ) then
			--Ö´ĞĞÍæ¼ÒÉÌµêµÄ¼Û¸ñÊäÈë(ÎïÆ·)
			if nMoney < 10000 * 10000 then		-- ??(???)1W???????, hjj 09/08/11 #53038	
				PlayerShop:UpStall("item",nMoney);
				if nMoney >=50 then             -- ??50????????  fsy 09/10/10 #57798
					this:Hide();
				end
			else
				PushDebugMessage("#{WJSD_090810_01}");
			end
			
--		elseif( g_nSaveOrGetMoney == PS_IMMITBASE ) then
--			--³äÈë±¾½ğ
--			PlayerShop:DealMoney("immitbase",nMoney);
--			this:Hide();
--		
--		elseif( g_nSaveOrGetMoney == PS_IMMIT ) then
--			--³äÈë
--			PlayerShop:DealMoney("immit",nMoney);
--			this:Hide();
--		
--		elseif( g_nSaveOrGetMoney == PS_DRAW ) then
--			--Ö§È¡
--			PlayerShop:DealMoney("draw",nMoney);
--			this:Hide();
			
		elseif( g_nSaveOrGetMoney == STALL_PET_UP ) then
			-- äÊŞÉÏ¼Ü
			StallSale:PetUpStall(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == STALL_PRICE_PET ) then
			StallSale:PetReprice(nMoney);
			this:Hide();
		
		elseif( g_nSaveOrGetMoney == PS_PRICE_PET ) then
			--Ö´ĞĞÍæ¼ÒÉÌµêµÄ¼Û¸ñÊäÈë( äÊŞ)
			if nMoney < 10000 * 10000 then		-- ??(???)1W???????, hjj 09/08/11 #53038	
				PlayerShop:UpStall("pet",nMoney);
				if nMoney >=50 then             -- ??50????????  fsy 09/10/10 #57798
					this:Hide();
				end
			else
				PushDebugMessage("#{WJSD_090810_01}");
			end
			
		elseif( g_nSaveOrGetMoney == PS_TRANSFER )  then
			-- --³ö¼ÛÅÌµê
			-- -- add by zchw
			-- if (tonumber(nMoney) > 100000000) then
			-- 	InputMoney_Gold:SetText("");
			-- 	InputMoney_Silver:SetText("");
			-- 	InputMoney_CopperCoin:SetText("");
			-- 	PushDebugMessage("ÅÌ³öÉÌµê¼Û¸ñ²»ÄÜ³¬¹ı10000½ğ£¬ÇëÖØĞÂÊäÈë");
			-- 	return;
			-- end
			-- PlayerShop:Transfer("info", "sale", nMoney);
			-- this:Hide();
			
		end
		
	end
end


--===============================================
-- È¡Ïû
--===============================================
function InputMoneyRefuse_Clicked()
	StallSale:UnlockSelItem();
	this:Hide();
	InputMoney_CopperCoin:SetProperty("DefaultEditBox", "False");
	InputMoney_Gold:SetProperty("DefaultEditBox", "False");
	InputMoney_Silver:SetProperty("DefaultEditBox", "False");
end


--===============================================
-- ÊäÈë¸Ä±ä
--===============================================
function InputMoney_ChangeMoney()
	
	local szGold = InputMoney_Gold:GetText();
	local szSilver = InputMoney_Silver:GetText();
	local szCopperCoin = InputMoney_CopperCoin:GetText();
	
	if(szGold=="" and szSilver=="" and szCopperCoin=="")then
		InputMoney_Accept_Button:Disable();
	else
		InputMoney_Accept_Button:Enable();
	end

end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function InputMoney_Frame_On_ResetPos()

	InputMoney_Frame : SetProperty("UnifiedXPosition", g_InputMoney_Frame_UnifiedXPosition);
	InputMoney_Frame : SetProperty("UnifiedYPosition", g_InputMoney_Frame_UnifiedYPosition);

end
