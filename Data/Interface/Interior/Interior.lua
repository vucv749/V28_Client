--UI COMMAND ID 100
--UI COMMAND ID 103 ÔİÊ±²âÊÔ½«´óÆìĞŞ¸Ä·ÅÔÚ âÀï
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_MembersCtl = {};
local g_NeedVal = {};
local g_selIdx = -1;

function Interior_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");	
	
	this:RegisterEvent("CITY_SHOW_MANAGE");
end

function Interior_OnLoad()
	g_NeedVal[0] = "Công nghi®p Tr¸:"
	g_NeedVal[1] = "Nông nghi®p Tr¸:"
	g_NeedVal[2] = "Buôn bán Tr¸:"
	g_NeedVal[3] = "Qu¯c phòng Tr¸:"
	g_NeedVal[4] = "Khoa h÷c kÛ thu§t Tr¸:"
	g_NeedVal[5] = "Khuªch trß½ng Tr¸:"
end
  
function Interior_OnEvent(event)
	City_Manage_SetCtl();
	if(event == "UI_COMMAND" and tonumber(arg0) == 100) then
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
		City:AskCityManageInfo();
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 103) then
		City:SetCityGuildFlag(1,1);
	elseif (event == "CITY_SHOW_MANAGE") then
		this:CareObject(g_clientNpcId, 1, "CityManage");
		City_Manage_Clear();
		City_Manage_Update();
		this:Show();
	elseif ( event == "OBJECT_CARED_EVENT") then
		City_Manage_CareEventHandle(arg0,arg1,arg2);
	end
end

function City_Manage_SetCtl()
	g_MembersCtl = {
									--Left
									guildname = 		{txt = "",							ctl = Interior_Text1},
									mainbuilding = 	{txt = "C¤p b§c:",				ctl = Interior_Text2},
									
									guildmoney = 		{txt = "Bang hµi tài chính:",		ctl = Interior_Text3},
									degree = {
																	{txt = "Công nghi®p Tr¸:",			ctl = Interior_Text4},
																	{txt = "Nông nghi®p Tr¸:",			ctl = Interior_Text5},
																	{txt = "Buôn bán Tr¸:",			ctl = Interior_Text6},
																	{txt = "Qu¯c phòng Tr¸:",			ctl = Interior_Text7},
																	{txt = "Khoa h÷c kÛ thu§t Tr¸:",			ctl = Interior_Text8},
																	{txt = "Khuªch trß½ng Tr¸:",			ctl = Interior_Text9},
													 },
									
									curbuilding = 	{txt = "Trß¾c m£t kiªn thiªt:",		ctl = Interior_Text10},
									progress = 			{txt = "Kiªn thiªt tiªn ğµ:",		ctl = Interior_Text11},
									                
									--Right         
									buildinglist = 	Interior_Info,
									                
									--RightBottom   
									needmsg = 			{txt = "Kiªn thiªt:",				ctl = Interior_Text12},
									needmoney = 		{txt = "Tài chính:",				ctl = Interior_Text13},
									needval = 			{txt = "",							ctl = Interior_Text14},
									needmission =  	{txt = "Nhi®m vø:",				ctl = Interior_Text15},
								 };
end

function City_Manage_Clear()
	local k;
	g_MembersCtl.buildinglist:RemoveAllItem();
	
	g_MembersCtl.guildname.ctl:SetText("");
	g_MembersCtl.mainbuilding.ctl:SetText("");
	g_MembersCtl.guildmoney.ctl:SetText("");
	
	for k = 1, table.getn(g_MembersCtl.degree) do
		g_MembersCtl.degree[k].ctl:SetText("");
	end
	
	g_MembersCtl.curbuilding.ctl:SetText("");
	g_MembersCtl.progress.ctl:SetText("");
	
	g_MembersCtl.needmsg.ctl:SetText("");
	g_MembersCtl.needmoney.ctl:SetText("");
	g_MembersCtl.needval.ctl:SetText("");
	g_MembersCtl.needmission.ctl:SetText("");
	
	g_selIdx = -1;
end

function City_Manage_Update()
	local k;
	--°ï»áÃû³Æ
	local txt = g_MembersCtl.guildname.txt..City:GetCityManageInfo("GuildName");
	txt = txt.."("..tostring(City:GetCityManageInfo("GuildId"))..")";
	g_MembersCtl.guildname.ctl:SetText(txt);
	--Ö÷Òª½¨Öş
	local bName, bLevel = City:GetCityManageInfo("MainBuilding");
	txt = g_MembersCtl.mainbuilding.txt..bName;
	txt = txt.."("..tostring(bLevel+1)..")";
	g_MembersCtl.mainbuilding.ctl:SetText(txt);
	--°ï»á×Ê½ğ
	local money = City:GetCityManageInfo("GuildMoney");
	txt = g_MembersCtl.guildmoney.txt;
	if(0 ~= tonumber(money)) then
		txt = txt.."#{_MONEY"..tostring(money).."}";
	else
		txt = txt.."0#-02";
	end
	--AxTrace(0,0,"City_Manage guildmoney:"..txt);
	g_MembersCtl.guildmoney.ctl:SetText(txt);
	--City:GetCityManageInfo("GuildLevel")
	--°ï»ádegree
	local de = {City:GetCityManageInfo("GuildDegree")};
	local deNum = table.getn(de);
	if(deNum > table.getn(g_MembersCtl.degree)) then deNum = table.getn(g_MembersCtl.degree); end
	for k = 1, deNum do
		txt = g_MembersCtl.degree[k].txt;
		txt = txt..tostring(de[k]);
		g_MembersCtl.degree[k].ctl:SetText(txt);
	end
	--µ±Ç°½¨Éè½¨Öş
	local	_idx = 0
	bName, bLevel, _idx = City:GetCityManageInfo("CurBuilding");
	if( -1 == bLevel ) then
	else
		local showLevel = City_Manage_Get_Display_Level(_idx,bLevel);
		txt = g_MembersCtl.curbuilding.txt..bName;
		txt = txt.."("..tostring(showLevel)..")";
		g_MembersCtl.curbuilding.ctl:SetText(txt);
		--µ±Ç°½¨Öş½ø¶È
		local curPro,maxPro = City:GetCityManageInfo("CurProgress");
		txt = g_MembersCtl.progress.txt..tostring(curPro);
		txt = txt.."/"..tostring(maxPro);
		g_MembersCtl.progress.ctl:SetText(txt);
	end
	--ËùÓĞ½¨ÖşÎïÌí¼Óµ½ÁĞ±í
	local bd = {City:GetCityManageInfo("BuildingList")};
	local listIdx = 0;
	local bdidx = 0;
	for k = 1, table.getn(bd), 3 do
		if( 0 > City_Manage_Is_Hide_Idx(bdidx)) then
			--g_MembersCtl.buildinglist:AddNewItem(bd[k],0,listIdx,"FF277112");
			g_MembersCtl.buildinglist:AddNewItem(bd[k],0,listIdx);
			local bDisplayLevel = City_Manage_Get_Display_Level(bdidx, bd[k+1]);
			if(bd[k+2] > 0) then
				g_MembersCtl.buildinglist:AddNewItem(bDisplayLevel,1,listIdx);
			else
				g_MembersCtl.buildinglist:AddNewItem("V¸ Kiªn",1,listIdx);
				--AxTrace(0,0,"default not exist building:"..tostring(bdidx));
			end
			g_MembersCtl.buildinglist:SetRowUserData(listIdx, bdidx);
			--g_MembersCtl.buildinglist:SetRowTooltip(listIdx, bd[k]);
			listIdx = listIdx + 1;
		end
		bdidx = bdidx + 1;
	end
	--½¨ÉèÏûÏ¢
	g_MembersCtl.needmsg.ctl:SetText(g_MembersCtl.needmsg.txt);
	--½¨Éè½ğÇ®
	g_MembersCtl.needmoney.ctl:SetText(g_MembersCtl.needmoney.txt.."0#-02");
	--½¨ÉèÏûºÄÖµ
	g_MembersCtl.needval.ctl:SetText(g_MembersCtl.needval.txt);
	--½¨ÉèÈÎÎñÊı
	g_MembersCtl.needmission.ctl:SetText(g_MembersCtl.needmission.txt);
end

function City_Manage_SelectChanged()
	local listidx = g_MembersCtl.buildinglist:GetSelectItem();
	g_selIdx = g_MembersCtl.buildinglist:GetRowUserData(listidx);
	
	if g_selIdx < 0 then
		--½¨ÉèÏûÏ¢
		g_MembersCtl.needmsg.ctl:SetText(g_MembersCtl.needmsg.txt);
		--½¨Éè½ğÇ®
		g_MembersCtl.needmoney.ctl:SetText(g_MembersCtl.needmoney.txt.."0#-02");
		--½¨ÉèÏûºÄÖµ
		g_MembersCtl.needval.ctl:SetText(g_MembersCtl.needval.txt);
		--½¨ÉèÈÎÎñÊı
		g_MembersCtl.needmission.ctl:SetText(g_MembersCtl.needmission.txt);
		return
	end
	--½¨ÉèÏûÏ¢
	local bName, bNextName = City:GetBuildingInfo(g_selIdx, "name");
	local bExist = City:GetBuildingInfo(g_selIdx, "exist");
	local txt = g_MembersCtl.needmsg.txt;
	if( "" == bNextName ) then
		txt = txt..tostring(bName);
	else
		if(bExist > 0) then
		txt = txt..tostring(bName).."->"..tostring(bNextName);
		else
			txt = txt.."V¸ Kiªn->"..tostring(bNextName);
		end
	end
	g_MembersCtl.needmsg.ctl:SetText(txt);
	--½¨ÉèÌõ¼ş
	local cd = {City:GetBuildingInfo(g_selIdx, "condition")};
	if(cd[1] == -2) then
		--Ã»ÓĞ½¨ÖşÌõ¼şµÄ£¬Çå¿ ÏÔÊ¾
		g_MembersCtl.needmsg.ctl:SetText("");
		g_MembersCtl.needmoney.ctl:SetText("");
		g_MembersCtl.needval.ctl:SetText("");
		g_MembersCtl.needmission.ctl:SetText("");
		return; 
	end
	--0.½ğÇ®
	local money = cd[1];
	txt = g_MembersCtl.needmoney.txt;
	if(0 ~= tonumber(money)) then
		txt = txt.."#{_MONEY"..tostring(money).."}";
	else
		txt = txt.."0#-02";
	end
	g_MembersCtl.needmoney.ctl:SetText(txt);
	--1.ÏûºÄÖµ
	local nt,nv = cd[3], cd[4];
	txt = g_MembersCtl.needval.txt..tostring(City_Manage_GetNeedTxt(nt));
	txt = txt..":"..tostring(nv);
	g_MembersCtl.needval.ctl:SetText(txt);
	--2.ÈÎÎñÊı
	local mn = cd[2];
	txt = g_MembersCtl.needmission.txt..tostring(mn);
	g_MembersCtl.needmission.ctl:SetText(txt);
end

function City_Manage_GetNeedTxt(nt)
	if( tonumber(nt) == 0 ) then
		return "Công nghi®p Tr¸";
	elseif( tonumber(nt) == 1 ) then
		return "Nông nghi®p Tr¸";
	elseif( tonumber(nt) == 2 ) then
		return "Buôn bán Tr¸";
	elseif( tonumber(nt) == 3 ) then
		return "Qu¯c phòng Tr¸";
	elseif( tonumber(nt) == 4 ) then
		return "Khoa h÷c kÛ thu§t Tr¸";
	elseif( tonumber(nt) == 5 ) then
		return "Khuªch trß½ng Tr¸";
	else
		return "";
	end
end

function City_Manage_Hide()
	this:Hide();
end

function City_Manage_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ı£¬×Ô¶¯¹Ø± 
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			City_Manage_Hide();
		end
end

function City_Manage_DoBuilding(act)
	if(tonumber(g_selIdx) < 0) then 
		PushDebugMessage("Thïnh Tiên lña ch÷n mµt loÕi kiªn trúc."); 
		return;
	end

	--2 ĞŞ½¨È·ÈÏ
	--3 Éı¼¶È·ÈÏ
	--4 ½µ¼¶È·ÈÏ
	--5 ²ğ»ÙÈ·ÈÏ
	local actC = {2,3,4,5};
	City:DoConfirm(actC[tonumber(act)], tonumber(g_selIdx));
end

function City_Manage_Is_Hide_Idx(idx)
	--Ä¿Ç°²»ÏÔÊ¾µÄ½¨ÖşÎïÀàĞÍ£¬¶ÔÓ¦enum BUILDING_TYPE
	local tHide = {8,12,14,16,17};
	local i = 1;
	while i <= table.getn(tHide) do
		if(tHide[i] == idx) then return 1; end
		i = i + 1;
	end
	return -1;
end

function City_Manage_Get_Display_Level(idx,idxlv)
	--È±Ê¡µÄÎ´½¨ÉèµÄ½¨ÖşÎï¼¶±ğÏÔÊ¾Ê±²»+1 ¶ÔÓ¦enum BUILDING_TYPE
	local tNoCreate = {2,4,6,10};
	local i = 1;
	while i <= table.getn(tNoCreate) do
		if(tNoCreate[i] == idx) then return idxlv; end
		i = i + 1;
	end
	return idxlv+1;
end
