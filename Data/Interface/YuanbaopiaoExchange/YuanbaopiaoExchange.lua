local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;
local g_YuanbaopiaoExchange_Frame_UnifiedPosition;

function YuanbaopiaoExchange_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_YUANBAO");
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function YuanbaopiaoExchange_OnLoad()
	g_YuanbaopiaoExchange_Frame_UnifiedPosition=YuanbaopiaoExchange_Frame:GetProperty("UnifiedPosition");
end

function YuanbaopiaoExchange_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 2002 ) then
			if this:IsVisible() then
				YuanbaopiaoExchange_Close();
				return
			end

			g_Object = Get_XParam_INT(0);
			BeginCareObject_YuanbaopiaoExchange(Target:GetServerId2ClientId(g_Object));
			
			YuanbaopiaoExchange_OnShown();
			this:Show();
	elseif ( event == "OBJECT_CARED_EVENT") then
		YuanbaopiaoExchange_CareEventHandle(arg0,arg1,arg2);
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		YuanbaopiaoExchange_Update();
	end
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		YuanbaopiaoExchange_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YuanbaopiaoExchange_Frame_On_ResetPos()
	end
end

function YuanbaopiaoExchange_OnShown()
	YuanbaopiaoExchange_Clear();
	YuanbaopiaoExchange_Update();
end

function YuanbaopiaoExchange_Clear()
	YuanbaopiaoExchange_Text1 : SetText("")
	YuanbaopiaoExchange_Moral_Value : SetText("")
end

function YuanbaopiaoExchange_Update()
	YuanbaopiaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
	YuanbaopiaoExchange_Moral_Value:SetSelected( 0, -1 );
	YuanbaopiaoExchange_Text1 : SetText("KNB còn:"..tostring(Player:GetData("YUANBAO")))
end

function YuanbaopiaoExchange_OK_Clicked()
	local str = YuanbaopiaoExchange_Moral_Value : GetText();
	
	if (str==nil or str=="") then
		return
	end
	
	if tonumber(str) > tonumber(Player:GetData("YUANBAO")) then
		PushDebugMessage("S¯ Kim Nguyên Bäo cüa các hÕ không ðü ð¬ quy ð±i!");
		YuanbaopiaoExchange_Max_Clicked();
		return
	end
	
	if tonumber(str) < 0 or tonumber(str) > 50000 then
		PushDebugMessage("M²i Trß½ng Nguyên Bäo Phiªu l¾n nh¤t m£t trán Vi 50000.");
		YuanbaopiaoExchange_Moral_Value : SetTextOriginal("50000");
		return
	end
	
	local ret = Player:YuanBaoToTicket(tonumber(str));
	if(-1 == ret) then
		PushDebugMessage("S¯ ngân lßþng các hÕ nh§p vào sai.");
	else
	--	YuanbaopiaoExchange_Close();
		YuanbaopiaoExchange_Update()
	end
end

function YuanbaopiaoExchange_Close()
	YuanbaopiaoExchange_OnHiden();
	this:Hide()
end

function YuanbaopiaoExchange_Cancel_Clicked()
	YuanbaopiaoExchange_Close();
	return;
end

function YuanbaopiaoExchange_OnHiden()
	StopCareObject_YuanbaopiaoExchange(objCared)
	YuanbaopiaoExchange_Clear()
	return
end

function YuanbaopiaoExchange_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			YuanbaopiaoExchange_Close();
		end
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_YuanbaopiaoExchange(objCaredId)

	g_Object = objCaredId;
	--AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "YuanbaopiaoExchange");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_YuanbaopiaoExchange(objCaredId)
	this:CareObject(objCaredId, 0, "YuanbaopiaoExchange");
	g_Object = -1;

end



function YuanbaoPiaoExchange_Count_Change()
	local str = YuanbaopiaoExchange_Moral_Value : GetText();
	local strNumber = 0;	
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	str = tostring( strNumber );
	YuanbaopiaoExchange_Moral_Value:SetTextOriginal( str );
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function YuanbaopiaoExchange_Frame_On_ResetPos()
  YuanbaopiaoExchange_Frame:SetProperty("UnifiedPosition", g_YuanbaopiaoExchange_Frame_UnifiedPosition);
end

function YuanbaopiaoExchange_Max_Clicked()
	local maxYuanBao = 50000;
	local nHaveYuanbao = Player:GetData("YUANBAO");
	if maxYuanBao > nHaveYuanbao then
		maxYuanBao = nHaveYuanbao;
	end
	
	YuanbaopiaoExchange_Moral_Value:SetProperty("ClearOffset", "True");
	YuanbaopiaoExchange_Moral_Value:SetText( tostring(maxYuanBao) );
	YuanbaopiaoExchange_Moral_Value:SetProperty("CaratIndex", 1024);
end
