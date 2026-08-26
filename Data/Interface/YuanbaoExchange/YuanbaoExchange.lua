local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Exchange_Rate = 1;
local g_Point = 0;
local g_Object = -1;
local g_SuiShenDuihuan = 1
local g_YuanbaoExchange_Frame_UnifiedPosition;

function YuanbaoExchange_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
end

function YuanbaoExchange_OnLoad()
	g_YuanbaoExchange_Frame_UnifiedPosition=YuanbaoExchange_Frame:GetProperty("UnifiedPosition");
end

function YuanbaoExchange_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 2001 ) then
			if this:IsVisible() then
				YuanbaoExchange_Close();
				return
			end
			local serverObjId = Get_XParam_INT(0);
			if 0 <= serverObjId then --???
				--YuanbaoExchange_Frame:SetProperty("UnifiedSize","{{0.000000,292.000000},{0.000000,292.000000}}");
				--YuanbaoExchange_Text2:SetText("")
				--YuanbaoExchange_Cancel:SetText("")
				BeginCareObject_YuanbaoExchange(Target:GetServerId2ClientId(serverObjId));
				g_SuiShenDuihuan = 0
			else --???
				--YuanbaoExchange_Frame:SetProperty("UnifiedSize", "{{0.000000,292.000000},{0.000000,379.000000}}");
				--YuanbaoExchange_Text2:SetText("")
			  g_SuiShenDuihuan = 1
			end
			YuanbaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
			YuanbaoExchange_Moral_Value:SetSelected( 0, -1 );
			YuanbaoExchange_OnShown();
			this:Show();
			YuanbaoExchange_Count_Change();
			YuanbaoExchange_Max:Disable()
			YuanbaoExchange_OK : Disable()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2003 ) then
		if(this:IsVisible()) then
			YuanbaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
			YuanbaoExchange_Moral_Value:SetSelected( 0, -1 );
			--g_Point = Get_XParam_INT(0)/1000;
			g_Point = Get_XParam_UINT(0) / 10
			local nPLow = math.mod( Get_XParam_UINT(0), 10000 );
			local nPHigh = math.floor( (Get_XParam_UINT(0) - nPLow) / 10000 );
			--local strPoint = tostring(nPHigh)..tostring(math.floor(nPLow/10));
			--´¦Àí ûÊý²¿·Ö
			local strPoint = "";
			if ( nPHigh > 0 ) then
				strPoint = tostring(nPHigh)..string.format("%03d", math.floor(nPLow/10) );
			else
				strPoint = string.format("%d", math.floor(nPLow/10) );
			end
			--¼ÓÉÏÐ¡Êý²¿·Ö
			if( math.mod(nPLow, 10) > 0 ) then
				strPoint = strPoint.."."..math.mod(nPLow,10);
			end
			YuanbaoExchange_Text1 : SetText("Nhçm trß¾c m¡t tài khoän còn th×a ðªm:"..strPoint*10 );
			--×¨ÊôµãÊý
			local nExPoint = Get_XParam_UINT(1)/10;
			if nExPoint > 0 then
				local tipsPoint = ScriptGlobal_Format("#{XFYC_210111_01}", nExPoint)
				YuanbaoExchange_Text1:SetToolTip(tipsPoint);
			else
				YuanbaoExchange_Text1:SetToolTip("");
			end
			YuanbaoExchange_Max:Enable()
			YuanbaoExchange_OK:Enable()
			YuanbaoExchange_Moral_Value:Enable();
		end
	elseif ( event == "OBJECT_CARED_EVENT") then
		YuanbaoExchange_CareEventHandle(arg0,arg1,arg2);
	elseif event == "HIDE_ON_SCENE_TRANSED" or event == "PLAYER_LEAVE_WORLD" then
		YuanbaoExchange_Close()
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		YuanbaoExchange_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YuanbaoExchange_Frame_On_ResetPos()
	end

end

function YuanbaoExchange_OnShown()
	YuanbaoExchange_Clear();
	YuanbaoExchange_Update();
end

function YuanbaoExchange_Clear()
	YuanbaoExchange_Text1 : SetText("")
	YuanbaoExchange_Moral_Value : SetText("")
	YuanbaoExchange_Text3 : SetText("")
	YuanbaoExchange_Text1:SetToolTip("");
	g_Point = 0;
	Exchange_Rate = 1;
end

function YuanbaoExchange_Update()
	Exchange_Rate = Get_XParam_INT(1)/10

	YuanbaoExchange_Text1 : SetText("#cff0000#bcòn th×a ðªm ðang · tu¥n tra Trung, Thïnh ch¶ mµt chút……")
	YuanbaoExchange_Text3 : SetText("C¥n tiêu phí ðªm: 0")

end

function YuanbaoExchange_OK_Clicked()
	local str = YuanbaoExchange_Moral_Value : GetText();

	--AxTrace(0,0,"YuanbaoExchange_OK_Clicked 1 "..tostring(str));

	if str == nil or str == "" then
		YuanbaoExchange_Text3 : SetText("C¥n tiêu phí ðªm: 0")
		PushDebugMessage("Thïnh ðßa vào Yêu ð±i Ðích nguyên bäo mÑc")
		return
	end

	if tonumber(str) > 20000 then
		--PushDebugMessage("#{DHYB_180524_31}")
		PushDebugMessage("M²i l¥n l¾n nh¤t Khä ð±i 20000ðªm.")
		return
	end
	if( tonumber(str) <= 0 ) then
		PushDebugMessage("M²i l¥n ð±i Ðích nguyên bäo s¯ lßþng ít nh¤t Vi 1Ði¬m, Thïnh ðßa vào l¾n h½n tß½ng ðß½ng 1Ði¬m Ðích con s¯.")
		return
	end

	--AxTrace(0,0,"YuanbaoExchange_OK_Clicked 2");
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("BuyYuanbao");
		Set_XSCRIPT_ScriptID(181000);
		Set_XSCRIPT_Parameter(0,tonumber(str));
		Set_XSCRIPT_Parameter(1,tonumber(g_SuiShenDuihuan));
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
	
	
	YuanbaoExchange_Close();
end

function YuanbaoExchange_Close()
	YuanbaoExchange_OnHiden();
	this:Hide()
end

function YuanbaoExchange_Cancel_Clicked()
	YuanbaoExchange_Close();
	return;
end

function YuanbaoExchange_OnHiden()
	StopCareObject_YuanbaoExchange()
	YuanbaoExchange_Clear()
	return
end

function YuanbaoExchange_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end

		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			YuanbaoExchange_Close();
		end
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_YuanbaoExchange(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "YuanbaoExchange")
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_YuanbaoExchange()
	if g_Object ~= -1 then
		this:CareObject(g_Object, 0, "YuanbaoExchange")
		g_Object = -1
	end
end

function YuanbaoExchange_Count_Change()
	local str = YuanbaoExchange_Moral_Value : GetText();
	local strNumber = 0;

	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	str = tostring( strNumber );
	YuanbaoExchange_Moral_Value:SetTextOriginal( str );
	YuanbaoExchange_Text3 : SetText("C¥n tiêu phí ðªm:"..tostring( Exchange_Rate * strNumber*10 ) )
end

function YuanbaoExchange_Max_Clicked()
	local maxYuanBao = 20000;
	local point2YuanBao = g_Point/Exchange_Rate;
	if point2YuanBao < 0 then point2YuanBao = 0; end

	YuanbaoExchange_Moral_Value:SetProperty("ClearOffset", "True");
	if point2YuanBao > maxYuanBao then
		YuanbaoExchange_Moral_Value:SetText(tostring(maxYuanBao));
	else
		YuanbaoExchange_Moral_Value:SetText(tostring(point2YuanBao));
	end
	YuanbaoExchange_Moral_Value:SetProperty("CaratIndex", 1024);
end

function YuanbaoExchange_ChongZhi_Clicked()
	Chongzhi()
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function YuanbaoExchange_Frame_On_ResetPos()
  YuanbaoExchange_Frame:SetProperty("UnifiedPosition", g_YuanbaoExchange_Frame_UnifiedPosition);
end
