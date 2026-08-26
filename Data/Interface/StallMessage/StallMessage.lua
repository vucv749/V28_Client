--°ÚÌ¯ĞÅÏ¢

--£¨Ì¯Ö÷£©·¢ËÍĞÂÌû»¹ÊÇ»Ø¸´Ìû×Ó
local NEW_MESSAGE   = 0;
local REPLY_MESSAGE = 1;
local g_NewOrReply  = NEW_MESSAGE;

--Ì¯Ö÷»ò ßÂò¼ÒµÄ±êÖ¾	=1±íÊ¾Ì¯Ö÷  =0±íÊ¾Âò¼Ò
local SALESMAN = 1;
local BUYER  = 0;
local g_nSalesman = -1;

-- ĞŞ¸Ä¹ã¸æÓï°´Å¥µÄÁ½ÖÖ×´Ì¬¡°·¢²¼¡±£¬¡°¸ü¸Ä¡±
local AD_ISSUE		=0  
local AD_REJIGGER =1  
local g_AdState		= AD_REJIGGER;

--»Ø¸´°´Å¥¶ÔÓ¦µÄĞÅÏ¢ID
local g_nMessageId = -1;

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_StallMessage_Frame_UnifiedXPosition;
local g_StallMessage_Frame_UnifiedYPosition;

--===============================================
-- OnLoad()
--===============================================
function StallMessage_PreLoad()

	this:RegisterEvent("OPEN_STALL_MESSAGE");
	this:RegisterEvent("CLOSE_STALL_MESSAGE");
	
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function StallMessage_OnLoad()

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_StallMessage_Frame_UnifiedXPosition	= StallMessage_Frame : GetProperty("UnifiedXPosition");
	g_StallMessage_Frame_UnifiedYPosition	= StallMessage_Frame : GetProperty("UnifiedYPosition");

end

--===============================================
-- OnEvent()
--===============================================
function StallMessage_OnEvent(event)

	if(event == "OPEN_STALL_MESSAGE") then

		--Ì¯Ö÷´ò¿ªµÄBBS
		if(arg0 == "sale") then
			g_nSalesman = SALESMAN;
			StallMessage_Checkbox_Locked:Disable();
			StallMessage_Checkbox_Locked:SetCheck(0);

			if(g_AdState == AD_ISSUE) then
				StallMessage_Ad:SetText("GØi");
				StallMessage_EditText:Show();
				StallMessage_StaticText:Hide();
			else
				StallMessage_Ad:SetText("Ğ±i");
				StallMessage_EditText:Hide();
				StallMessage_StaticText:Show();
				StallMessage_StaticText:SetText("#c9CCF00".. StallSale:GetAdvertise(0));
				StallMessage_EditText:SetText(StallSale:GetAdvertise(1));
			end

			--Ö»ÒªÊÇÌ¯Ö÷´ò¿ª£¬Ê¼Ö ĞèÒªÏÔÊ¾ â¸ö°´Å¥			
			StallMessage_Ad:Show();
			StallMessage_ClearMessage:Show()

		elseif(arg0 == "buy") then
			g_nSalesman = BUYER;
			StallMessage_Ad:Hide();
			StallMessage_ClearMessage:Hide()
		end
		
		this:Show();
		g_nMessageId = -1;
		StallMessage_UpdateFrame();
		
	elseif(event == "CLOSE_STALL_MESSAGE") then
		this:Hide();
	end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ
		StallMessage_Frame_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ	
		StallMessage_Frame_On_ResetPos()
	end

end

--===============================================
-- OnEvent()
--===============================================
--¸øAddChatBoardElementº¯Êı¼Ó¸ö²ÎÊı£¬´«Èëindex±íÊ¾ÊÇµÚ¼¸ÌõÏûÏ¢£¬
--×Ô¼ºµÄ°ÚÌ¯ÖĞindexÎª -2 µ½ -21 £¬ ±ğÈËµÄ°ÚÌ¯ÖĞindexÎª -22 µ½ -41
--ÔÚÉÏÃæµã»÷ÓÒ¼üÊ±ÄÜÍ¨¹ı â¸öIDµÃµ½·¢ÑÔÄÚÈİ£¬ÓÃÓÚ¾Ù±¨¡£
--by wangdw 2008.05.22
function StallMessage_UpdateFrame(event)

	StallMessage_Desc:ClearAllElement();
		
	local nMsgId;
	local szAuthorName;
	local szTime;
	local szMessage;
	local bReply;
	local szReplyMsg;
	
	--¶ÔÓÚÌ¯Ö÷
	if(g_nSalesman == SALESMAN) then
	
		StallMessage_EditText:Hide();
		StallMessage_StaticText:Show();
		
		g_AdState = AD_REJIGGER;
		StallMessage_Ad:SetText("Ğ±i");

		local nMessageNum = StallBbs:GetMessageNum("sale");
		for i=1, nMessageNum do
			
			nMsgId,szAuthorName,szTime,szMessage,bReply,szReplyMsg = StallBbs:EnumMessage(i-1,"sale");
			
			--1¡¢¶Ô±ÈÃû×ÖºÍID×éºÏ£¬Èç¹ûÊÇ×Ô¼º£¬
			if(szAuthorName == "#{_INFOUSR"..Player:GetName().."}("..StallSale:GetGuid()..")" )then
				StallMessage_Desc:AddChatBoardElement(szAuthorName);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement(szTime..":#c9CCF00"..szMessage);
				
			elseif(szAuthorName == "_SYSTEM")  then
				StallMessage_Desc:AddChatBoardElement("Mua bän ghi chép:"..szTime);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement("#R"..szMessage,i-1);
			
			--2¡¢Èç¹û²»ÊÇ×Ô¼º
			else
				StallMessage_Desc:AddChatBoardElement(szAuthorName,i-1);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement(szTime..":#c9CCF00"..szMessage);
				--Èç¹ûÒÑ¾­ÓĞ»Ø¸´ĞÅÏ¢
				if(bReply == true) then
					StallMessage_Desc:AddChatBoardElement("Than Chü h°i phøc:"..szReplyMsg);
				else
					--»Ø¸´°´Å¥
					--StallMessage_Desc:AddOptionElement("»Ø¸´" .. tostring(nMsgId));
					StallMessage_Desc:AddOptionElement("H°i phøc&".. nMsgId ..",0$-1");
				end
			
			end
		end
	
	--¶ÔÓÚÂò¼Ò
	elseif(g_nSalesman == BUYER) then
		StallMessage_StaticText:SetText("#c9CCF00"..StallBuy:GetAdvertise());

		nMessageNum = StallBbs:GetMessageNum("buy");
		
		--²»ÄÜ»Ø¸´
		StallMessage_Checkbox_Locked:SetCheck(0);
		StallMessage_Checkbox_Locked:Disable();

		
		for i=1, nMessageNum do
			
			nMsgId,szAuthorName,szTime,szMessage,bReply,szReplyMsg = StallBbs:EnumMessage(i-1,"buy");
			
			if(szAuthorName == "_SYSTEM")  then
				
				StallMessage_Desc:AddChatBoardElement("Mua bän ghi chép:"..szTime);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement("#R"..szMessage,i-1+20);

			else
				StallMessage_Desc:AddChatBoardElement(szAuthorName,i-1+20);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement(szTime..":#c9CCF00"..szMessage);
				if(bReply == true) then
					StallMessage_Desc:AddChatBoardElement("Than Chü h°i phøc:"..szReplyMsg);
				end
			
			end
			
		end
	end
	StallMessage_Desc:PageEnd();
end

--===============================================
-- OnEvent()
--===============================================
function StallMessage_FrameUpdate()
	
end

--===============================================
-- ·¢²¼ & »Ø¸´£¬ÓĞÁ½¸ö×´Ì¬£¨Ö»ÓĞÔÚÌ¯Ö÷½çÃæÉÏÓĞĞ§£©
--     ×´Ì¬1¡£¡°·¢²¼¡±
--     ×´Ì¬2¡£¡°»Ø¸´¡±
--===============================================
function StallMessage_SendMessage_Clicked()

	--¶ÔÓÚÌ¯Ö÷
	if(g_nSalesman == SALESMAN) then
	
		if(g_NewOrReply == NEW_MESSAGE) then
			--·¢ĞÂĞÅÏ¢
			StallBbs:AddMessage(StallMessage_EditInfoText:GetText(),"sale");
			
		else
			--»Ø¸´
			StallBbs:ReplyMessage(g_nMessageId+0,StallMessage_EditInfoText:GetText());
			g_NewOrReply = NEW_MESSAGE;
			StallMessage_Checkbox_Text:SetText("");
					
		end
		
	-- ¶ÔÓÚÂò¼Ò	£¨Ã»ÓĞ»Ø¸´×´Ì¬£©
	elseif(g_nSalesman == BUYER)  then

			StallBbs:AddMessage(StallMessage_EditInfoText:GetText(),"buy");
		
	end
	
	
	StallMessage_EditInfoText:SetText("");

end


--===============================================
-- Çå³ıÁôÑÔ
--===============================================
function StallMessage_ClearMessage_Clicked()

	local nMessageNum = StallBbs:GetMessageNum("sale");
	if(nMessageNum <= 0) then
	   return
	end
	
	StallMessage_Desc:ClearAllElement();
	StallBbs:DeleteMessageByID(-1)
	StallMessage_Desc:PageEnd();

end

--===============================================
-- ¹ã¸æÈ·¶¨°´Å¥£¬ÓĞÁ½¸ö×´Ì¬£¨Ö»ÓĞÔÚÌ¯Ö÷½çÃæÉÏÓĞĞ§£©
--     ×´Ì¬1¡£¡°·¢²¼¡±
--     ×´Ì¬2¡£¡°¸ü¸Ä¡±
--===============================================
function StallMessage_Ad_Clicked()

	if(g_AdState == AD_ISSUE) then
	
		local ret , uiString = StallSale:ApplyAd(StallMessage_EditText:GetText())
		if ret == 0  then
			return;
		end

		StallMessage_StaticText:SetText("#B"..uiString);
		StallMessage_EditText:Hide();
		StallMessage_StaticText:Show();
		
		g_AdState = AD_REJIGGER;
		StallMessage_Ad:SetText("Ğ±i");
		
		
		StallMessage_EditText:SetProperty("DefaultEditBox", "False");
	
	else

		StallMessage_EditText:Show();
		StallMessage_StaticText:Hide();
		g_AdState = AD_ISSUE;
		StallMessage_Ad:SetText("GØi");
		StallMessage_EditText:SetProperty("DefaultEditBox", "True");

	end

end

--===============================================
-- µã»÷Ò»¸ö»Ø¸´°´Å¥µÄ²Ù×÷ 
--===============================================
function StallMessageOption_Clicked()

	pos1,pos2 = string.find(arg0,"#");
	pos3,pos4 = string.find(arg0,",");
	
	AxTrace(0,0, pos1 .. pos2 .. pos3 .. pos4 );
	
	-- ¼ÇÂ¼µã»÷µÄÏûÏ¢µÄID	
	g_nMessageId = string.sub(arg0, pos2+1,pos3-1 );
	
	-- ÏàÓ¦µÄ½çÃæ±ä¶¯
	StallMessage_Checkbox_Locked:SetCheck(1);
	StallMessage_Checkbox_Locked:Enable();
	
	StallMessage_Checkbox_Text:SetText("H°i phøc nh¡n lÕi");
	
	StallMessage_EditInfoText:SetProperty("DefaultEditBox", "True");
	
	g_NewOrReply = REPLY_MESSAGE;

end

--===============================================
-- £¨µã»÷CheckBox£©È¡Ïû»Ø¸´×´Ì¬ 
--===============================================
function StallMessage_ReplyCheck_Clicked()

	-- ÏàÓ¦µÄ½çÃæ±ä¶¯
	StallMessage_Checkbox_Locked:SetCheck(0);
	StallMessage_Checkbox_Locked:Disable();
	StallMessage_Checkbox_Text:SetText("");
	
	g_NewOrReply = NEW_MESSAGE;

end

function StallMessage_Frame_OnHiden()
	StallMessage_EditInfoText:SetProperty("DefaultEditBox", "False");
	StallMessage_EditText:SetProperty("DefaultEditBox", "False");
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function StallMessage_Frame_On_ResetPos()

	StallMessage_Frame : SetProperty("UnifiedXPosition", g_StallMessage_Frame_UnifiedXPosition);
	StallMessage_Frame : SetProperty("UnifiedYPosition", g_StallMessage_Frame_UnifiedYPosition);

end
