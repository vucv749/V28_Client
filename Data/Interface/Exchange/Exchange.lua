local g_InitiativeClose = 0;

--Ö÷¶¯¹Ø± ´°¿ÚµÄÒ»¸ö±êÖ¾
local g_CloseSign;		-- 

--buttonµÄ¸öÊý
local BUTTON_NUMBER = 5;
--×Ô¼ºµÄ
local SELF_BUTTON = {};
local SELF_TEXT = {};
--¶Ô·½µÄ
local OTHER_BUTTON = {};
local OTHER_TEXT = {};

local objCared = -1;
local MAX_OBJ_DISTANCE = 6.0;

--½»Ò×ÄÜ·ÅÈëµÄ×î¶àµÄ³èÎïÊýÁ¿
local MAX_PET_NUM  = 5;
local g_nSelfPetID = {};				--??ID?
local g_nOtherPetID = {};				--??ID?

local g_LastLockTime = 0;
local LOCK_TIME_DIFF = 10000           --10?

local g_Exchange_Frame_UnifiedPosition;

--===============================================
-- OnLoad()
--===============================================
function Exchange_PreLoad()

	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("UPDATE_EXCHANGE");
	this:RegisterEvent("CANCEL_EXCHANGE");
	this:RegisterEvent("SUCCEED_EXCHANGE_CLOSE");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("EXCHANGE_ENABLE_ACCBTN");	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function Exchange_OnLoad()
	
	SELF_BUTTON[1] = Self_Exchange_Item1;
	SELF_BUTTON[2] = Self_Exchange_Item2;
	SELF_BUTTON[3] = Self_Exchange_Item3;
	SELF_BUTTON[4] = Self_Exchange_Item4;
	SELF_BUTTON[5] = Self_Exchange_Item5;
	SELF_BUTTON[6] = Self_Exchange_Item6;
	
	SELF_TEXT[1] = Self_Exchange_Item_Text1;
	SELF_TEXT[2] = Self_Exchange_Item_Text2;
	SELF_TEXT[3] = Self_Exchange_Item_Text3;
	SELF_TEXT[4] = Self_Exchange_Item_Text4;
	SELF_TEXT[5] = Self_Exchange_Item_Text5;
	SELF_TEXT[6] = Self_Exchange_Item_Text6;
	
	OTHER_BUTTON[1] = Other_Exchange_Item1;
	OTHER_BUTTON[2] = Other_Exchange_Item2;
	OTHER_BUTTON[3] = Other_Exchange_Item3;
	OTHER_BUTTON[4] = Other_Exchange_Item4;
	OTHER_BUTTON[5] = Other_Exchange_Item5;
	OTHER_BUTTON[6] = Other_Exchange_Item6;

	OTHER_TEXT[1] = Other_Exchange_Item_Text1;
	OTHER_TEXT[2] = Other_Exchange_Item_Text2;
	OTHER_TEXT[3] = Other_Exchange_Item_Text3;
	OTHER_TEXT[4] = Other_Exchange_Item_Text4;
	OTHER_TEXT[5] = Other_Exchange_Item_Text5;
	OTHER_TEXT[6] = Other_Exchange_Item_Text6;
	
	for i=0, MAX_PET_NUM    do
		g_nSelfPetID[i] = -1;
		g_nOtherPetID[i] = -1
	end
	
	 g_Exchange_Frame_UnifiedPosition=Exchange_Frame:GetProperty("UnifiedPosition");
	 
end

--===============================================
-- OnEvent()
--===============================================
function Exchange_OnEvent(event)

	if(event == "OPEN_EXCHANGE_FRAME") then
		--¹ØÐÄNPC
		objCared = tonumber(arg0);
		this:CareObject(objCared, 1, "Exchange");
		ExchangeValidate_StopWatch1:SetProperty("Timer", "300");
		g_InitiativeClose = 0;
		--Update	
		Exchange_UpdateFrame();
		Exchange_Checkbox_other_Locked:Disable();
		Exchange_Frame:SetProperty("UnifiedXPosition","{0.0,0}");
		Exchange_Frame:SetProperty("UnifiedYPosition","{0.12,0}");
		this:Show();
		
	elseif(event == "UPDATE_EXCHANGE") then
		Exchange_UpdateFrame();
		
	elseif(evnet == "CANCEL_EXCHANGE") then
		g_InitiativeClose = 1;
		this:Hide();
		Exchange:CloseExchangeInfo();
		--È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "Exchange");
		
	elseif(event == "SUCCEED_EXCHANGE_CLOSE") then
		g_InitiativeClose = 1;
		this:Hide();
		Exchange:CloseExchangeInfo();
		--È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "Exchange");
	
	--ËÀÍöµÄÊ±ºòÐèÒªÈ¡Ïû½»Ò×
	elseif(event == "RELIVE_SHOW" and this:IsVisible()) then
		g_InitiativeClose = 1;
		this:Hide();
		Exchange:CloseExchangeInfo();
		--È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "Exchange");
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();
			Exchange:CloseExchangeInfo();
			
			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "Exchange");
		end
	
	elseif( event == "ACCELERATE_KEYSEND" and this:IsVisible()) then
		this:Hide();
		Exchange:CloseExchangeInfo();
		--È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "Exchange");
	elseif(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide();
		Exchange:CloseExchangeInfo();
		--È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "Exchange");
	end

	if event == "EXCHANGE_ENABLE_ACCBTN" then	--???????????....

		if not this:IsVisible() then
			return;
		end
		Exchange_UpdateFrame();
	end

	if (event == "ADJEST_UI_POS" ) then
		Exchange_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Exchange_Frame_On_ResetPos()
	end
		
end

--===============================================
-- ¸üÐÂ½çÃæ
--===============================================
function Exchange_UpdateFrame()

	--½»Ò×Ë«·½µÄÃû×Ö
	--×Ô¼ºµÄ
	Exchange_SelfName:SetText(Player:GetName());
	
	--¶Ô·½µÄ
	Exchange_OtherName:SetText("#b#c0000FF#effffff"..Exchange:GetOthersName());

	--¶Ô·½µÄËø¶¨°´Å¥£¬£¨Ò»Ö±²»¿ÉÓÃ£©
	Exchange_Other_Locked_Button:Disable();
	--×Ô¼ºµÄ½»Ò×°´Å¥£¬£¨Ë«·½Ëø¶¨ºó¿ÉÓÃ£©
	Trade_Accept_Button:Disable();
	
	--======================
	--´¦Àí½ðÇ®
	local nMoney;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;

	--¶Ô·½µÄ½ðÇ®Êý×Ö
	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Exchange:GetMoney("other");
	Exchange_Other_Money:SetProperty("MoneyNumber", tostring(nMoney));

	--×Ô¼ºµÄ½ðÇ®Êý×Ö
	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Exchange:GetMoney("self");
	Exchange_Slfe_Money:SetProperty("MoneyNumber", tostring(nMoney));

	--=======================
	--´¦ÀíÎïÆ·
	--×Ô¼ºµÄ
	local nSelfTotalNum = GetActionNum("ex_self");
	--AxTrace(0, 0, "Exchange:nSelfTotalNum =  " .. nSelfTotalNum);
	
	for i=0, BUTTON_NUMBER-1  do

		local theAction = EnumAction(i, "ex_self");

		--AxTrace(0, 0, "Exchange:nActIndex =  " .. i);

		if theAction:GetID() ~= 0 then
			SELF_BUTTON[i+1]:SetActionItem(theAction:GetID());
			SELF_TEXT[i+1]:SetText(theAction:GetName());
		else
			SELF_BUTTON[i+1]:SetActionItem(-1);
			SELF_TEXT[i+1]:SetText("");
		end
	
	end

	--¶Ô·½µÄ
	local nOtherTotalNum = GetActionNum("ex_other");
	--AxTrace(0, 0, "Exchange:nOtherTotalNum =  " .. nOtherTotalNum);

	for i=0, BUTTON_NUMBER-1  do

		local theAction = EnumAction(i, "ex_other");

		--AxTrace(0, 0, "Bank:nActIndex =  " .. i);

		if theAction:GetID() ~= 0 then
			OTHER_BUTTON[i+1]:SetActionItem(theAction:GetID());
			OTHER_TEXT[i+1]:SetText(theAction:GetName());
		else
			OTHER_BUTTON[i+1]:SetActionItem(-1);
			OTHER_TEXT[i+1]:SetText("");
		end

	end
	
	--=======================
	--´¦ÀíËø¶¨×´Ì¬,´ÓÊý¾Ý³Ø»ñµÃÊý¾Ý£¬È»ºóÍ¨Öª½çÃæ±íÏÖ³öÀ´
	local bIsSelfLocked = Exchange:IsLocked("self");
	local bIsOtherLocked = Exchange:IsLocked("other");

	--×Ô¼ºµÄ½»Ò×°´Å¥£¬£¨Ë«·½Ëø¶¨ºó¿ÉÓÃ£©
	if( bIsSelfLocked == true ) then
		if( bIsOtherLocked == true ) then
			Trade_Accept_Button:Enable();
		end
	end
	
	--×Ô¼ºµÄ
	local bIsSelfLocked = Exchange:IsLocked("self");
	if( bIsSelfLocked == true ) then
		Exchange_Checkbox_Locked:SetCheck(1);
		Exchange_Locked_Button:SetText("Hüy bö b¸ khóa");
	elseif ( bIsSelfLocked == false) then
		Exchange_Checkbox_Locked:SetCheck(0);
		Exchange_Locked_Button:SetText("B¸ khóa giao d¸ch");
	end
	
	--¶Ô·½µÄ
	if( bIsOtherLocked == true ) then
		Exchange_Checkbox_other_Locked:SetCheck(1);
		Exchange_Other_Locked_Button:SetText("Ðã b¸ khóa");
	elseif ( bIsOtherLocked == false) then
		Exchange_Checkbox_other_Locked:SetCheck(0);
		Exchange_Other_Locked_Button:SetText("Chßa b¸ khóa");
	end
	
	--=======================
	--´¦Àí³èÎï
	--×Ô¼ºµÄ
	Exchange_Self_PetList:ClearListBox();
	
	--local nNum = Exchange:GetPetNum("self");
	local nIndex = 0;
	for i=1, MAX_PET_NUM     do
		local szPetName = Exchange:EnumPet("self", i-1);
		if( szPetName ~= "" )then
			Exchange_Self_PetList:AddItem(szPetName, nIndex);
			g_nSelfPetID[nIndex] = i-1;
			nIndex = nIndex + 1;
		end
	end
	
	--¶Ô·½µÄ
	Exchange_Other_PetList:ClearListBox();
	nIndex = 0;
	--local nNum = Exchange:GetPetNum("other");
	for i=1, MAX_PET_NUM      do
		local szPetName = Exchange:EnumPet("other", i-1);
		if( szPetName ~= "" )  then
			Exchange_Other_PetList:AddItem(szPetName, nIndex);
			g_nOtherPetID[nIndex] = i-1;
			nIndex = nIndex+1;
		end
	end

end

--===============================================
-- ´°¿Ú¹Ø± Ö´ÐÐµÄ   Hidden
--===============================================
function Exchange_Cancel()

	Exchange:ExchangeCancel();
	
	Exchange:CloseExchangeInfo()
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "Exchange");

end

--===============================================
-- µã»÷Ëø¶¨
--===============================================
function Exchange_Lock_Button_Clicked()

	local nNowTickCount = Exchange:GetTickCount();
	local bSelfIsLock = Exchange:IsLocked("self");
	
	if (bSelfIsLock == true) then	    --?????,??????
		g_LastLockTime = nNowTickCount;		
	else                               --?????,????
		if(g_LastLockTime >0 and (nNowTickCount - g_LastLockTime) < LOCK_TIME_DIFF) then
			Exchange_Checkbox_Locked:SetCheck(0);
			PushDebugMessage("#{JYTX_090303_1}");
			return;
		end
	end
	
	Exchange:LockExchange();
end


--===============================================
-- µã»÷½»Ò×£¨Í¬Òâ½»Ò×£©
--===============================================
function Trade_Accept_Button_Clicked()

	Trade_Accept_Button:Disable();
	Exchange:AcceptExchange();

end


--===============================================
-- ´ò¿ª½ðÇ®¶Ô»°¿ò
--===============================================
function Exchange_Open_InputMoney_Clicked()
	local ret = Exchange:GetWeGameLimit()
	if ret == 0 then
		Exchange:OpenPetFrame();
	elseif ret == 1 then -- ??WeGame?????????????WeGame?????????????
		PushDebugMessage( "#{XZJY_231206_1}" )
	elseif ret == 2 then -- ???WeGame????????????WeGame?????????????
		PushDebugMessage( "#{XZJY_231206_3}" )
	end
end

--===============================================
-- É¾³ýÑ¡ÖÐµÄ³èÎï
--===============================================
function Trade_DeletePet_Button_Clicked()
	
	local nIndex = Exchange_Self_PetList:GetFirstSelectItem();
	if(nIndex == -1)    then
		return ;
	end
	Exchange:DelSelectPet(g_nSelfPetID[nIndex]);
	
end 

--===============================================
-- ÓÒ¼üµã»÷
--===============================================
function Exchange_Other_PetList_RClick()
	local nIndex = Exchange_Other_PetList:GetFirstSelectItem();
	
	if(nIndex == -1) then
		return ;
	end
	
	Exchange:ViewPetDesc("other",g_nOtherPetID[nIndex]);
end

--===============================================
-- ÓÒ¼üµã»÷
--===============================================
function Exchange_Self_PetList_RClick()
	local nIndex = Exchange_Self_PetList:GetFirstSelectItem();

	if(nIndex == -1) then
		return ;
	end

	Exchange:ViewPetDesc("self",g_nSelfPetID[nIndex]);	
end

function ExchangeValidate_TimeReach1()
    PushDebugMessage("Giao d¸ch Siêu Th¶i, Thïnh mµt l¥n næa giao d¸ch.");
    Exchange_Cancel();
    ExchangeValidate_StopWatch1:SetProperty("Timer", "-1");
end

function Exchange_Frame_On_ResetPos()
  Exchange_Frame:SetProperty("UnifiedPosition", g_Exchange_Frame_UnifiedPosition);
end
