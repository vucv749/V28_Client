
local CTRL_NUM = 11
local CTRL = {};

local SELF_PAGE  = 0;
local OTHER_PAGE = 1;
local g_Current_Page;
local SELFDATA_TAB_TEXT = {};

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_TargetData_Frame_UnifiedPosition;

local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		},
	[2] = {Text = "#{INTERFACE_XML_882}",		},
	[3] = {Text = "#{INTERFACE_XML_854}",		},
	[4] = {Text = "#{WH_xml_XX(95)}",			},
	[5] = {Text = "#{SZXT_221216_22}",			},
	[6] = {Text = "#{SBFW_20230707_1}",			},
	[7] = {Text = "#{DWJJ_240329_153}",  	 	},
	[8] = {Text = "#{DFJC_250709_1}",  	 		},
	[9] = {Text = "#{GRYM_221213_22}",  	 	},
}
local g_PageButton = {}
local g_PageOrder = {}

--===============================================
-- OnLoad()
--===============================================
function TargetData_PreLoad()
	this:RegisterEvent("OPEN_PRIVATE_INFO");
	this:RegisterEvent("UPDATE_PRIVATE_INFO");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function TargetData_OnLoad()
	--ÉúÐ¤
	TargetData_YearAnimal:ComboBoxAddItem("-",0);
	TargetData_YearAnimal:ComboBoxAddItem("ThØ",1); 
	TargetData_YearAnimal:ComboBoxAddItem("Ngßu",2); 
	TargetData_YearAnimal:ComboBoxAddItem("H±",3); 
	TargetData_YearAnimal:ComboBoxAddItem("Th¯",4); 
	TargetData_YearAnimal:ComboBoxAddItem("Thìn",5); 
	TargetData_YearAnimal:ComboBoxAddItem("Xà",6); 
	TargetData_YearAnimal:ComboBoxAddItem("Mã",7); 
	TargetData_YearAnimal:ComboBoxAddItem("Dß½ng",8); 
	TargetData_YearAnimal:ComboBoxAddItem("H¥u",9);
	TargetData_YearAnimal:ComboBoxAddItem("Kê",10);
	TargetData_YearAnimal:ComboBoxAddItem("C¦u",11);
	TargetData_YearAnimal:ComboBoxAddItem("Trß",12);
	
	--Ê¡·Ý
	TargetData_Province:ComboBoxAddItem("-",		 0);
	TargetData_Province:ComboBoxAddItem("B¡c Kinh",  1); 
	TargetData_Province:ComboBoxAddItem("Thiên Tân",  2); 
	TargetData_Province:ComboBoxAddItem("Thßþng Häi",  3); 
	TargetData_Province:ComboBoxAddItem("Trùng Khánh",  4); 
	TargetData_Province:ComboBoxAddItem("Hà B¡c",  5); 
	TargetData_Province:ComboBoxAddItem("Liêu Ninh",  6); 
	TargetData_Province:ComboBoxAddItem("S½n Ðông",  7); 
	TargetData_Province:ComboBoxAddItem("H¡c Long Giang",8); 
	TargetData_Province:ComboBoxAddItem("S½n Tây",  9); 
	TargetData_Province:ComboBoxAddItem("Cát Lâm",  10);
	TargetData_Province:ComboBoxAddItem("Thi¬m Tây",  11);
	TargetData_Province:ComboBoxAddItem("Hà Nam",  12);
	TargetData_Province:ComboBoxAddItem("An Huy",  13);
	TargetData_Province:ComboBoxAddItem("Giang Tô",  14);
	TargetData_Province:ComboBoxAddItem("H° B¡c",  15);
	TargetData_Province:ComboBoxAddItem("Chiªt Giang",  16);
	TargetData_Province:ComboBoxAddItem("H° Nam",  17);
	TargetData_Province:ComboBoxAddItem("Giang Tây",  18);
	TargetData_Province:ComboBoxAddItem("Phúc Kiªn",  19);
	TargetData_Province:ComboBoxAddItem("Ðài Loan",  20);
	TargetData_Province:ComboBoxAddItem("Nµi Mông C±",21);
	TargetData_Province:ComboBoxAddItem("Cam Túc",  22);
	TargetData_Province:ComboBoxAddItem("Ninh HÕ",  23);
	TargetData_Province:ComboBoxAddItem("TÑ Xuyên",  24);
	TargetData_Province:ComboBoxAddItem("Quý Châu",  25);
	TargetData_Province:ComboBoxAddItem("Vân Nam",  26);
	TargetData_Province:ComboBoxAddItem("Quäng Tây",  27);
	TargetData_Province:ComboBoxAddItem("Quäng Ðông",  28);
	TargetData_Province:ComboBoxAddItem("Häi Nam",  29);
	TargetData_Province:ComboBoxAddItem("Tân Cß½ng",  30);
	TargetData_Province:ComboBoxAddItem("Thanh Häi",  31);
	TargetData_Province:ComboBoxAddItem("Tây TÕng",  32);
	TargetData_Province:ComboBoxAddItem("Macao",  33);
	TargetData_Province:ComboBoxAddItem("H°ng Kông",  34);
	TargetData_Province:ComboBoxAddItem("M£t khác",  35);
	
	 --°ÄÃÅ  Ïã¸Û ºÍÆäËû
	                                          
	--ÐÔ±ð
	TargetData_Sex:ComboBoxAddItem("-",0);
	TargetData_Sex:ComboBoxAddItem("Nam",1);
	TargetData_Sex:ComboBoxAddItem("Næ",2);

	--ÑªÐÍ
	TargetData_BloodType:ComboBoxAddItem("-",0);
	TargetData_BloodType:ComboBoxAddItem("A",1);
	TargetData_BloodType:ComboBoxAddItem("B",2);
	TargetData_BloodType:ComboBoxAddItem("AB",3);
	TargetData_BloodType:ComboBoxAddItem("O",4);


	--ÐÇ×ù
	TargetData_Constellation:ComboBoxAddItem("-",0); 
	TargetData_Constellation:ComboBoxAddItem("Ma HÕt ToÕ",1);
	TargetData_Constellation:ComboBoxAddItem("Chòm Thüy Bình",2); 
	TargetData_Constellation:ComboBoxAddItem("Chòm Song Ngß",3); 
	TargetData_Constellation:ComboBoxAddItem("Chòm BÕch Dß½ng",4); 
	TargetData_Constellation:ComboBoxAddItem("Chòm Kim Ngßu",5); 
	TargetData_Constellation:ComboBoxAddItem("Chòm song nam",6); 
	TargetData_Constellation:ComboBoxAddItem("Chòm cñ giäi",7); 
	TargetData_Constellation:ComboBoxAddItem("Chòm Sß TØ",8); 
	TargetData_Constellation:ComboBoxAddItem("XØ næ ToÕ",9); 
	TargetData_Constellation:ComboBoxAddItem("Chòm Thiên Bình",10);
	TargetData_Constellation:ComboBoxAddItem("Chòm sao bò cÕp",11);
	TargetData_Constellation:ComboBoxAddItem("XÕ thü ToÕ",12);
	
	CTRL[1] = TargetData_Age;
	CTRL[2] = TargetData_Sex;
	CTRL[3] = TargetData_Job;
	CTRL[4] = TargetData_School;
	CTRL[5] = TargetData_BloodType;
	CTRL[6] = TargetData_YearAnimal;
	CTRL[7] = TargetData_Constellation;
	CTRL[8] = TargetData_Province;
	CTRL[9] = TargetData_City;
	CTRL[10] = TargetData_EMail;
	CTRL[11] = TargetData_MessageBoard;
	
	SELFDATA_TAB_TEXT = {
		[0] = "Trang b¸",
		"Tß li®u",
		"Trân Thú",
	};	
	
	--ÆÁ±ÎÍæ¼Ò×ÊÁÏÒ³Ç©ÖÐ¡°µç×ÓÓÊ¼þÏà¹ØÄÚÈÝ¡±£¬TT62640
	TargetData_EMail_Text:Hide();
	TargetData_EMail:Hide();
	
	-- ·ÖÒ³°´Å¥
	g_PageButton[1] = TargetData_SelfEquip
	g_PageButton[2] = TargetData_TargetData
	g_PageButton[3] = TargetData_Pet
	g_PageButton[4] = TargetData_TargetWuhun
	g_PageButton[5] = TargetData_TargetLingyu
	g_PageButton[6] = TargetData_TargetWeapon2
	g_PageButton[7] = TargetData_TargetDWJinJie
	g_PageButton[8] = TargetData_TargetPeak
	g_PageButton[9] = TargetData_TargetProfile

	
	 g_TargetData_Frame_UnifiedPosition=TargetData_Frame:GetProperty("UnifiedPosition");
end

function TargetData_SetTabColor(idx)

	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = TargetData_SelfEquip,
								TargetData_TargetData,								
								-- TargetData_Blog,
								TargetData_Pet,
							};
	
	while i < 3 do
		if(i == idx) then
			tab[i]:SetText(selColor..SELFDATA_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..SELFDATA_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end
--===============================================
-- OnEvent()
--===============================================
function TargetData_OnEvent(event)
	if ( event == "OPEN_PRIVATE_INFO" ) then
	
		if(arg0 == "self")     then
			return;
		end
		
		local obj_id = CachedTarget:GetData("NPCID", 1)
		if (type(obj_id) ~="number") then
			PushDebugMessage ("#{JSCK_90507_1}")				-- ???????,???????
			return
		end
		this:CareObject(obj_id , 1)
		
		this:Show();
		local isopen5 = T300Func:IsNoDifOpen(5)
		if isopen5 == 1 then
			--TargetData_TargetWuhun:Disable()
		else
			TargetData_TargetWuhun:Enable()
		end
		
--		objCared = SystemSetup:GetCaredObjId();
--		this:CareObject(objCared, 1, "TargetData");
		TargetData_SetTabColor(1);
		
		TargetData_ShowPage()
		
		if(arg0 == "self")     then
			local selfUnionPos = Variable:GetVariable("SelfUnionPos");
			if(selfUnionPos ~= nil) then
				TargetData_Frame:SetProperty("UnifiedPosition", selfUnionPos);
			end
			
			g_Current_Page = SELF_PAGE;
			TargetData_UpdateFrame("self");
			for i=1 ,CTRL_NUM  do
				CTRL[i]:Enable();
			end
			TargetData_DataShareMode:Show();
			TargetData_Accept:Show();
			TargetData_DataShareMode_Text:Show()
			--TargetData_Blog:Show();
		else
			local otherUnionPos = Variable:GetVariable("OtherUnionPos");
			if(otherUnionPos ~= nil) then
				TargetData_Frame:SetProperty("UnifiedPosition", otherUnionPos);
			end
		
			g_Current_Page = OTHER_PAGE;
			TargetData_UpdateFrame("other");
			for i=1 ,CTRL_NUM -1   do
				CTRL[i]:Disable();
			end
			TargetData_DataShareMode:Hide();
			TargetData_Accept:Hide();
			TargetData_DataShareMode_Text:Hide();
			--TargetData_Blog:Hide();
			
		end
		
	elseif (event == "OBJECT_CARED_EVENT") then
		AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "SelfData");
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		TargetData_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TargetData_Frame_On_ResetPos()
		
	end
end

--===============================================
-- UpdateFrame()
--===============================================
function TargetData_UpdateFrame(whose)
	
	--±êÌâÏÔÊ¾Íæ¼ÒµÄÃû×Ö
	local szName = SystemSetup:GetPrivateInfo(whose,"name");
 	TargetData_PageHeader:SetText("#gFF0FA0"..szName);
	
	local nType = SystemSetup:GetPrivateInfo(whose,"type");	
	if nType == 0      then
		TargetData_Mode1:SetCheck(1);
		TargetData_Mode2:SetCheck(0);
		TargetData_Mode3:SetCheck(0);
		
	elseif nType == 1  then
		TargetData_Mode1:SetCheck(0);
		TargetData_Mode2:SetCheck(1);
		TargetData_Mode3:SetCheck(0);
		
	elseif nType == 2  then
		TargetData_Mode1:SetCheck(0);
		TargetData_Mode2:SetCheck(0);
		TargetData_Mode3:SetCheck(1);
		
	end
	
	local szGuid = SystemSetup:GetPrivateInfo(whose,"guid");
	TargetData_ID:SetText("ID:".. szGuid);
	
	local nAge = SystemSetup:GetPrivateInfo(whose,"age");
	TargetData_Age:SetText(tostring(nAge));
	AxTrace(0,0,"SelfData_Age =" .. nAge);
	
	local nSex = SystemSetup:GetPrivateInfo(whose,"sex");
--	AxTrace(0,0,"nSex =" .. nSex);
	TargetData_Sex:SetCurrentSelect(nSex);
	
	local szJob = SystemSetup:GetPrivateInfo(whose,"job");
	TargetData_Job:SetText(szJob);
	AxTrace(0,0,"SelfData_Job =" .. szJob);
	
	local szSchool = SystemSetup:GetPrivateInfo(whose,"school");
	TargetData_School:SetText(szSchool);
	
	local nBlood = SystemSetup:GetPrivateInfo(whose,"blood");
--	AxTrace(0,0,"nBlood =" .. nBlood);
	TargetData_BloodType:SetCurrentSelect(nBlood);
	
	local nAnimal = SystemSetup:GetPrivateInfo(whose,"animal");
--	AxTrace(0,0,"nAnimal =" .. nAnimal);
	TargetData_YearAnimal:SetCurrentSelect(nAnimal);
	
	local nConsella = SystemSetup:GetPrivateInfo(whose,"Consella");
--	AxTrace(0,0,"nConsella =" .. nConsella);
	TargetData_Constellation:SetCurrentSelect(nConsella);
	
	local nProvince = SystemSetup:GetPrivateInfo(whose,"Province");
--	AxTrace(0,0,"nProvince =" .. nProvince);
	TargetData_Province:SetCurrentSelect(nProvince);
		
	local szCity = SystemSetup:GetPrivateInfo(whose,"city");
	TargetData_City:SetText(szCity);
	AxTrace(0,0,"SelfData_City =" .. szCity);
	
	local szEmail = SystemSetup:GetPrivateInfo(whose,"email");
	TargetData_EMail:SetText(szEmail);
	AxTrace(0,0,"SelfData_EMail =" .. szEmail);

	local szLuck = SystemSetup:GetPrivateInfo(whose,"luck");
	TargetData_MessageBoard:SetText(szLuck);
	AxTrace(0,0,"SelfData_MessageBoard =" .. szLuck);

end

--===============================================
-- Accept()
--===============================================
function TargetData_Accept_Clicked()
	
	local nType;
	if TargetData_Mode1:GetCheck() == 1     	then
		nType = 0;
	elseif TargetData_Mode2:GetCheck() == 1   then
		nType = 1;
	elseif TargetData_Mode3:GetCheck() == 1   then
		nType = 2;
	end
	
	local bCanUse=1;
	
	bCanUse = SystemSetup:SetPrivateInfo("self", "type", 		nType);
	--SystemSetup:SetPrivateInfo("self", "guid", 		2);
	
	if(bCanUse == 0)  then
		return;
	end
	
	local nAge = TargetData_Age:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "age", 		nAge);
	if(bCanUse == 0)  then
		return;
	end
	
	local szSex,nSex = TargetData_Sex:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "sex", 		nSex);
	if(bCanUse == 0)  then
		return;
	end
	
	local szJob = TargetData_Job:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "job", 		szJob);
	if(bCanUse == 0)  then
		return;
	end
	
	local szSchool = TargetData_School:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "school",	szSchool);
	if(bCanUse == 0)  then
		return;
	end
	
	local szBlood,nBlood = TargetData_BloodType:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "blood", 	nBlood);
	if(bCanUse == 0)  then
		return;
	end
	
	local szAnimal,nAnimal = TargetData_YearAnimal:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "animal",	nAnimal);
	if(bCanUse == 0)  then
		return;
	end
	
	local szConsella,nConsella = TargetData_Constellation:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "Consella",nConsella);
	if(bCanUse == 0)  then
		return;
	end
	
	local szProvince,nProvince = TargetData_Province:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "Province",nProvince);
	if(bCanUse == 0)  then
		return;
	end
	
	local szCity = TargetData_City:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "city", 		szCity);
	if(bCanUse == 0)  then
		return;
	end
	
	local szEmail = TargetData_EMail:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "email", 	szEmail);
	if(bCanUse == 0)  then
		return;
	end
	
	local szLuck = TargetData_MessageBoard:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "luck", 		szLuck);
	if(bCanUse == 0)  then
		return;
	end
	
	--Ìá½»
	SystemSetup:ApplyPrivateInfo();
	
	this:Hide();
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "SelfData");

end

--===============================================
-- ´ò¿ª
--===============================================
function TargetData_TargetEquip_Down()
	if( g_Current_Page == SELF_PAGE )     then
		Variable:SetVariable("SelfUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("self");
	else
		Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("other");
	end
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "SelfData");
end


-- function TargetData_TargetBlog_Down()
-- 	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);

-- 	local strCharName =  CachedTarget:GetData("NAME");
-- 	local strAccount =  CachedTarget:GetData("ACCOUNTNAME")
-- 	Blog:OpenBlogPage(strAccount,strCharName,false);
	
-- end
--===============================================
-- ´ò¿ª
--===============================================
function TargetData_OtherPet_Down()

	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
			
end

--===============================================
-- OnHiden
--===============================================
function TargetData_Frame_OnHiden()
	TargetData_Job:SetProperty("DefaultEditBox", "False");
	TargetData_School:SetProperty("DefaultEditBox", "False");
	TargetData_City:SetProperty("DefaultEditBox", "False");
	TargetData_EMail:SetProperty("DefaultEditBox", "False");
	
	TargetData_Age:SetProperty("DefaultEditBox", "False");
	TargetData_MessageBoard:SetProperty("DefaultEditBox", "False");
end


function TargetData_Ride_Switch()
	Variable:SetVariable("SelfUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	OpenRidePage();

end

function TargetData_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
end
function TargetData_OtherRide_Down()
	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenRidePage("other");
end

--Îä»ê

function TargetData_TargetWuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		TargetData_TargetWuhun : SetCheck(0)
		TargetData_ClearPage()
		return
	end
	
	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenOtherWuhun();
end

function TargetData_TargetLingyu_Switch()
	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherLingYuPage()
end

function TargetData_ShenBing_Switch()
	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherShenBingPage()
end

function TargetData_DWJinJie_Switch()
	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherFeaturesPage()
end

function TargetData_OtherProfile_Switch()
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		TargetData_TargetProfile:SetCheck(0)
		TargetData_ClearPage()
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
end

function TargetData_ShowPage()

	for i = 1, 9 do
		g_PageButton[i]:Hide()
	end
		
	local nPageNumber = tonumber(Variable:GetVariable("TargetPageNumber"));
	TargetData_ClearPage()
	
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, 9 do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, 9 do
		if TargetData_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)
			g_PageOrder[g_PageCount] = i
		end
	end
end

function TargetData_CheckPage(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??

		return 1
	elseif idx == 6 then--??

		return 1
	elseif idx == 7 then--????

		return 1
	elseif idx == 8 then--??


		return 1
	elseif idx == 9 then--??
		return 1
	end
	return 0
end

function TargetData_ClearPage()
	Variable:SetVariable("TargetPageNumber", tostring(0), 1)
end

function TargetData_OnPageClicked(idx)

	Variable:SetVariable("TargetPageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]

	if idx == 1 then--??
		TargetData_TargetEquip_Down()
	elseif idx == 2 then--??
		TargetData_ClearPage()
	elseif idx == 3 then--??
		TargetData_OtherPet_Down()
	elseif idx == 4 then--??
		TargetData_TargetWuhun_Switch()
	elseif idx == 5 then--??
		TargetData_TargetLingyu_Switch()
	elseif idx == 6 then--??
		TargetData_ShenBing_Switch()
	elseif idx == 7 then--????
		TargetData_DWJinJie_Switch()
	elseif idx == 8 then
		TargetData_OtherDFeng_Switch()
	elseif idx == 9 then
		TargetData_OtherProfile_Switch()
	end
end

function TargetData_Frame_On_ResetPos()
  TargetData_Frame:SetProperty("UnifiedPosition", g_TargetData_Frame_UnifiedPosition);
end

function TargetData_OtherDFeng_Switch()
	-- if ZBS:IsZBSFinalDFengBanFlag() == 1 then
		-- PushDebugMessage("#{WCBZ_250812_1}")
	    -- return 0
	-- end
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 85 then
		PushDebugMessage("#{DFJC_250709_83}")
		TargetData_TargetPeak:SetCheck(0)
		TargetData_ClearPage()
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1)
	--SystemSetup:Lua_OpenDFengOther()
	local eLoad = GetTargetPlayerGUID();
	if eLoad ~=nil and eLoad ~= -1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GetTargetWuJingData");
			Set_XSCRIPT_ScriptID(502161);
			Set_XSCRIPT_Parameter(0,tonumber(eLoad));
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	this:Hide();
end
