
-- µ±Ç°µÄÒ³Êý
local g_CurPage = -1;

-- È«²¿µÄÒ³Êý
local g_AllPage;

-- Ã¿Ò³ÏÔÊ¾µÄÊýÁ¿
local MESSAGE_EACH_PAGE = 10;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_szMseeageType = "";


--===============================================
-- PreLoad()
--===============================================
function PS_Message_PreLoad()

	this:RegisterEvent("PS_OPEN_MESSAGE");
	this:RegisterEvent("PS_UPDATE_MESSAGE");

end

--===============================================
-- OnLoad()
--===============================================
function PS_Message_OnLoad()
	
end

--===============================================
-- OnEvent()
--===============================================
function PS_Message_OnEvent(event)

	if ( event == "PS_OPEN_MESSAGE" )      then
		this:Show();
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Message");
		
		g_CurPage = tonumber(arg0);
		PS_Message_UpdateFrame();
		
	elseif ( event == "PS_UPDATE_MESSAGE" )  then
	
		g_CurPage = tonumber(arg0);
		PS_Message_UpdateFrame();
	

	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PS_Message");
		end	


	end	
end

--===============================================
-- UpdateFrame
--===============================================
function PS_Message_UpdateFrame()
	
	g_szMseeageType = PlayerShop:GetMessageType();
	
	
	if( g_szMseeageType == "exchange") then
		PS_Message_DragTitle:SetText("Ghi chép giao d¸ch");
		g_AllPage = math.floor((PlayerShop:GetMessageNum("exchange")-1)/MESSAGE_EACH_PAGE)+1;
	else
		PS_Message_DragTitle:SetText("Ghi chép quän lý");
		g_AllPage = math.floor((PlayerShop:GetMessageNum("manage")-1)/MESSAGE_EACH_PAGE)+1;
	end
	
	PS_Message_List:ClearAllElement();
	
	local nMessageNum = PlayerShop:GetCurPageMessageNum("exchange");
	
	--  Ã¿Ò»Ò³ÏÔÊ¾×î¶à10¸ö
	local szInfo;
	for i=0, nMessageNum-1 do
		szInfo = PlayerShop:EnumMessage(i);
		PS_Message_List:AddTextElement(szInfo);
	end
	
	PS_Message_Pre:Enable();
	PS_Message_Next:Enable();
	
	if( g_CurPage == 0 )  then
		PS_Message_Pre:Disable();
	end
	
	if( g_CurPage == g_AllPage-1 ) then
		PS_Message_Next:Disable();
	end
	
end

--===============================================
-- ÉÏÒ»Ò³
--===============================================
function PS_Message_Pre_Clicked()
	
	if(g_szMseeageType == "exchange")  then
		PlayerShop:OpenMessage("exchange",g_CurPage - 1);
	else
		PlayerShop:OpenMessage("manager",g_CurPage - 1);
	end
end

--===============================================
-- ÏÂÒ»Ò³
--===============================================
function PS_Message_Next_Clicked()

	if(g_szMseeageType == "exchange")  then
		PlayerShop:OpenMessage("exchange",g_CurPage + 1);
	else
		PlayerShop:OpenMessage("manager",g_CurPage + 1);
	end
end

--===============================================
-- ¹Ø± 
--===============================================
function PS_Message_Close1_Clicked()

	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_Message");

end

--===============================================
-- OnClose
--===============================================
function PS_Message_Close_Clicked()
	
end

