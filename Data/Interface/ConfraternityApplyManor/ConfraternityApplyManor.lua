local MAX_CHARACTER_INPUTNAME = 12; --??????
local MAX_COUNTRY_INPUTNAME   = 12; --??????
local g_PortId = -1;
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Type = 0;
local g_ConfraternityApplyManor_Frame_UnifiedXPosition;
local g_ConfraternityApplyManor_Frame_UnifiedYPosition;

function ConfraternityApplyManor_PreLoad()
	this:RegisterEvent("CITY_SHOW_INPUT_NAME");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UI_COMMAND");
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function ConfraternityApplyManor_OnLoad()
		-- ±£¥Ê±≥∞¸ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
	g_ConfraternityApplyManor_Frame_UnifiedXPosition	= ConfraternityApplyManor_Frame:GetProperty("UnifiedXPosition");
	g_ConfraternityApplyManor_Frame_UnifiedYPosition	= ConfraternityApplyManor_Frame:GetProperty("UnifiedYPosition");
end

function ConfraternityApplyManor_OnEvent(event)
	if(event == "CITY_SHOW_INPUT_NAME" and arg0 == "open") then
		g_PortId = -1;
		g_PortId = tonumber(arg1);
		g_Type =0;
		ConfraternityApplyManor_Update(0, tonumber(arg2))
		this:Show();
	elseif(event == "CITY_SHOW_INPUT_NAME" and arg0 == "close") then
		this:Hide();
	elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		City_InputName_CareEventHandle(arg0,arg1,arg2);
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 5423  or tonumber(arg0) == 5424 or tonumber(arg0) == 5425 or tonumber(arg0) == 54266 or tonumber(arg0) == 54267) then
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
			PushDebugMessage("DÊ liÆu m·y ch¸ cÛ v§n ´");
			return;
		end
		if(tonumber(arg0) == 5423)then---HJWQ
			g_Type =1;
		elseif (tonumber(arg0) == 5424) then
			g_Type =2;
		elseif (tonumber(arg0) == 54266) then
			g_Type =4;
		elseif (tonumber(arg0) == 54267) then
			g_Type =5;
		else
			g_Type =3;
		end
		
		ConfraternityApplyManor_Update(g_Type,objCared);
		this:Show();
	
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	elseif (event == "ADJEST_UI_POS" ) then
		ConfraternityApplyManor_Frame_On_ResetPos()
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityApplyManor_Frame_On_ResetPos()
	end
end

function ConfraternityApplyManor_Update(type,clientNpcId)
		ConfraternityApplyManor_FeudalName:SetProperty("DefaultEditBox", "True");
		ConfraternityApplyManor_FeudalName:SetText("");
		g_clientNpcId = clientNpcId;
		this:CareObject(g_clientNpcId, 1, "CityInputName");
		if(type == 0)then
			--–¬Ω®≥« –
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength","12");
			ConfraternityApplyManor_Text:SetText("#{INTERFACE_XML_56}");	--#gFF0FA0??????
			ConfraternityApplyManor_Text1:SetText("#{INTERFACE_XML_627}"); --??????????1000??????????
			ConfraternityApplyManor_Text1:Show();
			ConfraternityApplyManor_Text2:SetText("#{INTERFACE_XML_525}"); --??????
		elseif(type == 1)then
			--»ÀŒÔ∏ƒ√˚
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_CHARACTER_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{INTERFACE_XML_GAIMING_0}");	--#gFF0FA0????
			ConfraternityApplyManor_Text1:Hide();
			ConfraternityApplyManor_Text2:SetText("#{INTERFACE_XML_GAIMING_1}"); --?????????:
		elseif(type == 2)then
			--∞Ô≈…∏ƒ√˚
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_COUNTRY_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{INTERFACE_XML_GAIMING_2}");	--#gFF0FA0????
			ConfraternityApplyManor_Text1:SetText("#{INTERFACE_XML_GAIMING_3}");
			ConfraternityApplyManor_Text1:Hide();
			ConfraternityApplyManor_Text2:SetText("#{INTERFACE_XML_GAIMING_3}"); --?????????:
			ConfraternityApplyManor_Text2:Show();
		elseif(type == 3)then
			--Ω«…´∏ƒ√˚
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_CHARACTER_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{GMT_20100811_3}");	--#gFF0FA0????
			ConfraternityApplyManor_Text1:SetText("#{GMT_20100811_27}"); --#cfff263????,????#G1????#cfff263?
			ConfraternityApplyManor_Text1:Show();
			ConfraternityApplyManor_Text2:SetText("#{GMT_20100811_18}"); --?????????:
		------
		elseif ( type == 4 ) then
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_CHARACTER_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{CMCL_210713_53}");	-- ??????
			ConfraternityApplyManor_Text1:SetText("#{CMCL_210713_55}"); -- ?????????:
			ConfraternityApplyManor_Text1:Hide();
			ConfraternityApplyManor_Text2:SetText("#{CMCL_210713_55}");
			ConfraternityApplyManor_Text2:Show();
		elseif ( type == 5 ) then
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_CHARACTER_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{CMCL_210713_64}");	-- ????
			ConfraternityApplyManor_Text1:SetText("#{CMCL_210713_66}"); -- ?????????:
			ConfraternityApplyManor_Text1:Hide();
			ConfraternityApplyManor_Text2:SetText("#{CMCL_210713_66}");
			ConfraternityApplyManor_Text2:Show();
		end
end

function City_InputName_Clear()
	g_PortId = -1;
	ConfraternityApplyManor_FeudalName:SetText("");
end

function City_InputName_Confirm()
	if(g_PortId >= 0) then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		City:DoConfirm(1, g_PortId, txt);
	end
end

function City_InputName_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--»Áπ˚∫ÕNPCµƒæ‡¿Î¥Û”⁄“ª∂®æ‡¿ÎªÚ†ﬂ±ª…æ≥˝£¨◊‘∂Øπÿ±†
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end

function ConfraternityApplyManor_Release_Button_Clicked()
	if g_Type == 0 then
		City_InputName_Confirm();
	elseif g_Type == 1 then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Target:CharRnameCheck(txt);
		if(ret>0)then
			Target:CharRnameConfirm(txt);
			this:Hide();
		else
			City_InputName_Clear();
		end
	elseif g_Type == 2 then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Guild:CityRnameCheck(txt);
		if(ret>0)then
			Guild:CityRnameConfirm(txt);
			this:Hide();
		else
			City_InputName_Clear();
		end
	elseif g_Type == 3 then
		-- Ω«…´∏ƒ√˚
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Target:CharRnameCheck(txt);
		if(ret>0)then
			Target:ChangeNameConfirm(txt,g_clientNpcId);
			this:Hide();
		else
			City_InputName_Clear();
		end
	----
	elseif g_Type == 4 then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Guild:CityLeagueRnameCheck(txt);
		if(ret>0)then
			Guild:RealCityRnameConfirm(txt,g_clientNpcId);
			this:Hide();
		else
			City_InputName_Clear();
		end
	elseif g_Type == 5 then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Guild:CityLeagueRnameCheck(txt);
		if(ret>0)then
			Guild:RealLeagueRnameConfirm(txt,g_clientNpcId);
			this:Hide();
		else
			City_InputName_Clear();
		end
	end
end

--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function ConfraternityApplyManor_Frame_On_ResetPos()
  ConfraternityApplyManor_Frame:SetProperty("UnifiedXPosition", g_ConfraternityApplyManor_Frame_UnifiedXPosition);
	ConfraternityApplyManor_Frame:SetProperty("UnifiedYPosition", g_ConfraternityApplyManor_Frame_UnifiedYPosition);
end
