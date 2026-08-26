-- ÍòÄÜ´«ËÍ½çÃæ
-- Ñ©Îè¾«¼ò´úÂë 2025-5-7 15:16:22

local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local sceninfog={}
local sceninfo1 = {}
local sceninfo2 = {}
local sceninfo3 = {}
local sceninfo4 = {}
local sceninfo5 = {}
local currentIndex  = 1

local MAX_OBJ_DISTANCE = 3.0;
local ObjCaredIDID = -1;

function ChuanSongSystem_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("OPEN_CHUANSONG_SYSTEM");
	-- this:RegisterEvent("OBJECT_CARED_EVENT");
end

function ChuanSongSystem_OnEvent(event)
	if event == "OPEN_CHUANSONG_SYSTEM"  then
		
		-- local xx = Get_XParam_INT(0);
		-- ObjCaredID = DataPool : GetNPCIDByServerID(xx);
		-- if ObjCaredID == -1 then
			-- PushDebugMessage("server´«¹ýÀ´µÄÊý¾ÝÓÐÎÊÌâ¡£");
			-- return;
		-- end
		-- ObjCaredIDID = xx
		-- BeginCareObject_ChuanSongSystem()
		
		this:Show()
		ChuanSongSystem_ShowCategory(1)
	end
	if( event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
	elseif (event == "ADJEST_UI_POS" ) then	
		ChuanSongSystem_ResetPos()	
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			ChuanSongSystem_Close()
		end
	end
		
end

function ChuanSongSystem_OnLoad()
	for i = 1, 30 do 
		sceninfog[i] = _G["ChuanSongSystem_goto"..i]
	end
	
	sceninfo1 = {
		{str="LÕc Dß½ng thß½ng hµi",Num=ChuanSongSystem_goto1},
		{str="ÐÕi Lý",Num=ChuanSongSystem_goto2},
		{str="Tô Châu",Num=ChuanSongSystem_goto3},
		{str="Tô Châu thþ rèn Phô",Num=ChuanSongSystem_goto4},
		{str="Lâu Lan C± Thành",Num=ChuanSongSystem_goto5},
		{str="Thúc Hà C± Tr¤n",Num=ChuanSongSystem_goto6},
		{str="Tinh Túc",Num=ChuanSongSystem_goto7},
		{str="Tiêu Dao",Num=ChuanSongSystem_goto8},
		{str="Thi¬u Lâm",Num=ChuanSongSystem_goto9},
		{str="Thiên S½n",Num=ChuanSongSystem_goto10},
		{str="Thiên Long",Num=ChuanSongSystem_goto11},
		{str="Nga Mi",Num=ChuanSongSystem_goto12},
		{str="Võ Ðang",Num=ChuanSongSystem_goto13},
		{str="Minh Giáo",Num=ChuanSongSystem_goto14},
		{str="Cái Bang",Num=ChuanSongSystem_goto15},
		--{str="#cff99ccÑ§Ï°ÐÂÊÖ¼¼ÄÜ",Num=ChuanSongSystem_goto16},
	}

	sceninfo2 = {
		{str="Bäo Tàng Ðµng T¥ng 1",Num=ChuanSongSystem_goto1},
		{str="Bäo Tàng Ðµng T¥ng 3",Num=ChuanSongSystem_goto2},
		{str="Bäo Tàng Ðµng T¥ng 5",Num=ChuanSongSystem_goto3},
		{str="Ma Nhai Ðµng",Num=ChuanSongSystem_goto4},
		{str="C± MÕc Nh¤t T¢ng",Num=ChuanSongSystem_goto5},
		{str="C± MÕc Ngû T¢ng",Num=ChuanSongSystem_goto6},
		{str="C± MÕc CØu T¢ng",Num=ChuanSongSystem_goto7},
		{str="Ð¸a Cung Nh¤t T¢ng",Num=ChuanSongSystem_goto8},
		{str="Ð¸a Cung Nh¸ T¢ng",Num=ChuanSongSystem_goto9},
		{str="Ð¸a Cung Tam T¢ng",Num=ChuanSongSystem_goto10},
		{str="Mê Cung",Num=ChuanSongSystem_goto11},
		{str="Ðáp Kh¡c",Num=ChuanSongSystem_goto12},
		{str="Hãn Huyªt Lînh",Num=ChuanSongSystem_goto13},
		{str="Hoä Di®m C¯c",Num=ChuanSongSystem_goto14},
		--{str="#GÎÞÁ¿É½-ÐÂÊÖBOSS",Num=ChuanSongSystem_goto15},
		--{str="#G¶Ø»Í-ÐÂÊÖBOSS",Num=ChuanSongSystem_goto16},
	}

	sceninfo3 = {
		{str="#YTHäo Nguyên-T¤t Thß½ng",Num=ChuanSongSystem_goto1},
		{str="#YTHß½ng S½n-T¤t Thß½ng",Num=ChuanSongSystem_goto2},
		{str="#YV Di-T¤t Thß½ng",Num=ChuanSongSystem_goto3},
		{str="#YHUy«n Võ Ðäo-T¤t Thß½ng",Num=ChuanSongSystem_goto4},
		{str="Xí Nga Vß½ng",Num=ChuanSongSystem_goto5},
		{str="Công H°n Änh Tßþng",Num=ChuanSongSystem_goto6},
		{str="Cái Bang Tôn L§p Giä",Num=ChuanSongSystem_goto7},
		{str="Nga Mi Viên Công TØ",Num=ChuanSongSystem_goto8},
		{str="Minh Giáo Kim Thß¶ng",Num=ChuanSongSystem_goto9},
		{str="Thiªu Lâm Bành H¥u",Num=ChuanSongSystem_goto10},
		{str="Tinh Túc ba mß½i Nß½ng",Num=ChuanSongSystem_goto11},
		{str="Thiên S½n BÕch S¥m",Num=ChuanSongSystem_goto12},
		{str="Võ Ðang MÕnh Muµi",Num=ChuanSongSystem_goto13},
		{str="Tiêu dao C± Xuyên",Num=ChuanSongSystem_goto14},
		{str="Thiên Long Vß½ng Quân",Num=ChuanSongSystem_goto15},
	}

	sceninfo4 = {
		{str="T¯ng Liêu Biên Cänh",Num=ChuanSongSystem_goto1},
		{str="Kiªm Tr× Yêu Ma",Num=ChuanSongSystem_goto2},
		{str="KÏ Cøc",Num=ChuanSongSystem_goto3},
		{str="Xúc Cúc",Num=ChuanSongSystem_goto4},
		{str="Yên TØ ‘",Num=ChuanSongSystem_goto5},
		{str="Phiêu Mi­u Phong",Num=ChuanSongSystem_goto6},
		{str="Lâu Lan t¥m bäo",Num=ChuanSongSystem_goto7},
		
	}

	sceninfo5 = {
		{str="#cFF0000Thánh Thú S½n Long Quân-T¤t Tranh",Num=ChuanSongSystem_goto1},
		{str="#cFF0000Thánh Thú S½n thùng-T¤t Tranh",Num=ChuanSongSystem_goto2},
		{str="#cFF0000Trùng Lâu Sß½ng Änh",Num=ChuanSongSystem_goto3},
	}

	g_Frame_UnifiedXPosition = ChuanSongSystem_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition = ChuanSongSystem_Frame:GetProperty("UnifiedYPosition");
end

function ChuanSongSystem_Close()
	-- StopCareObject_ChuanSongSystem()
	this:Hide();
end

function ChuanSongSystem_ResetPos()
	ChuanSongSystem_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	ChuanSongSystem_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

--Ö´ÐÐ½Å±¾
function ChuanSongSystem_Clicked(index)
	if index > 30 and index < 1 then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Teleport"); 	
		Set_XSCRIPT_ScriptID(990001);
		Set_XSCRIPT_Parameter(0,tonumber(currentIndex ));
		Set_XSCRIPT_Parameter(1,tonumber(index));
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT()
end

-- ÇÐ»»´óÒ³Ãæ
function ChuanSongSystem_ShowCategory(index)
	if index < 1 or index > 6 then 
		return 
	end 
	currentIndex  = index
	local nchuansong = 0
	
	-- Òþ²ØËùÓÐ°´Å¥ 
	for i=1,30 do
		if sceninfog[i] then 
			sceninfog[i]:Hide();
		end
	end
		
	if index == 1 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo1) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 2 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo2) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 3 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo3) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 4 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo4) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 5 then
		ChuanSongSystem_Client:Show()
		for i,j in ipairs(sceninfo5) do
			j.Num:Show()
			j.Num:SetText(j.str)
			nchuansong = nchuansong + 1
		end
	elseif index == 6 then
		ChuanSongSystem_Client:Hide()
	end

end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_ChuanSongSystem()
	this:CareObject(ObjCaredID, 1, "ChuanSongSystem");
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_ChuanSongSystem()
	this:CareObject(ObjCaredID, 0, "ChuanSongSystem");
end
