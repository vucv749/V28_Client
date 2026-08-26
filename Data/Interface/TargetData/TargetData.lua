
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
	--生肖
	TargetData_YearAnimal:ComboBoxAddItem("-",0);
	TargetData_YearAnimal:ComboBoxAddItem("鼠",1); 
	TargetData_YearAnimal:ComboBoxAddItem("牛",2); 
	TargetData_YearAnimal:ComboBoxAddItem("虎",3); 
	TargetData_YearAnimal:ComboBoxAddItem("兔",4); 
	TargetData_YearAnimal:ComboBoxAddItem("龙",5); 
	TargetData_YearAnimal:ComboBoxAddItem("蛇",6); 
	TargetData_YearAnimal:ComboBoxAddItem("马",7); 
	TargetData_YearAnimal:ComboBoxAddItem("羊",8); 
	TargetData_YearAnimal:ComboBoxAddItem("猴",9);
	TargetData_YearAnimal:ComboBoxAddItem("鸡",10);
	TargetData_YearAnimal:ComboBoxAddItem("狗",11);
	TargetData_YearAnimal:ComboBoxAddItem("猪",12);
	
	--省份
	TargetData_Province:ComboBoxAddItem("-",		 0);
	TargetData_Province:ComboBoxAddItem("北京",  1); 
	TargetData_Province:ComboBoxAddItem("天津",  2); 
	TargetData_Province:ComboBoxAddItem("上海",  3); 
	TargetData_Province:ComboBoxAddItem("重庆",  4); 
	TargetData_Province:ComboBoxAddItem("河北",  5); 
	TargetData_Province:ComboBoxAddItem("辽宁",  6); 
	TargetData_Province:ComboBoxAddItem("山东",  7); 
	TargetData_Province:ComboBoxAddItem("黑龙江",8); 
	TargetData_Province:ComboBoxAddItem("山西",  9); 
	TargetData_Province:ComboBoxAddItem("吉林",  10);
	TargetData_Province:ComboBoxAddItem("陕西",  11);
	TargetData_Province:ComboBoxAddItem("河南",  12);
	TargetData_Province:ComboBoxAddItem("安徽",  13);
	TargetData_Province:ComboBoxAddItem("江苏",  14);
	TargetData_Province:ComboBoxAddItem("湖北",  15);
	TargetData_Province:ComboBoxAddItem("浙江",  16);
	TargetData_Province:ComboBoxAddItem("湖南",  17);
	TargetData_Province:ComboBoxAddItem("江西",  18);
	TargetData_Province:ComboBoxAddItem("福建",  19);
	TargetData_Province:ComboBoxAddItem("台湾",  20);
	TargetData_Province:ComboBoxAddItem("内蒙古",21);
	TargetData_Province:ComboBoxAddItem("甘肃",  22);
	TargetData_Province:ComboBoxAddItem("宁夏",  23);
	TargetData_Province:ComboBoxAddItem("四川",  24);
	TargetData_Province:ComboBoxAddItem("贵州",  25);
	TargetData_Province:ComboBoxAddItem("云南",  26);
	TargetData_Province:ComboBoxAddItem("广西",  27);
	TargetData_Province:ComboBoxAddItem("广东",  28);
	TargetData_Province:ComboBoxAddItem("海南",  29);
	TargetData_Province:ComboBoxAddItem("新疆",  30);
	TargetData_Province:ComboBoxAddItem("青海",  31);
	TargetData_Province:ComboBoxAddItem("西藏",  32);
	TargetData_Province:ComboBoxAddItem("澳门",  33);
	TargetData_Province:ComboBoxAddItem("香港",  34);
	TargetData_Province:ComboBoxAddItem("其他",  35);
	
	 --澳门  香港 和其他
	                                          
	--性别
	TargetData_Sex:ComboBoxAddItem("-",0);
	TargetData_Sex:ComboBoxAddItem("男",1);
	TargetData_Sex:ComboBoxAddItem("女",2);

	--血型
	TargetData_BloodType:ComboBoxAddItem("-",0);
	TargetData_BloodType:ComboBoxAddItem("A",1);
	TargetData_BloodType:ComboBoxAddItem("B",2);
	TargetData_BloodType:ComboBoxAddItem("AB",3);
	TargetData_BloodType:ComboBoxAddItem("O",4);


	--星座
	TargetData_Constellation:ComboBoxAddItem("-",0); 
	TargetData_Constellation:ComboBoxAddItem("魔羯座",1);
	TargetData_Constellation:ComboBoxAddItem("水瓶座",2); 
	TargetData_Constellation:ComboBoxAddItem("双鱼座",3); 
	TargetData_Constellation:ComboBoxAddItem("白羊座",4); 
	TargetData_Constellation:ComboBoxAddItem("金牛座",5); 
	TargetData_Constellation:ComboBoxAddItem("双子座",6); 
	TargetData_Constellation:ComboBoxAddItem("巨蟹座",7); 
	TargetData_Constellation:ComboBoxAddItem("狮子座",8); 
	TargetData_Constellation:ComboBoxAddItem("处女座",9); 
	TargetData_Constellation:ComboBoxAddItem("天秤座",10);
	TargetData_Constellation:ComboBoxAddItem("天蝎座",11);
	TargetData_Constellation:ComboBoxAddItem("射手座",12);
	
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
		[0] = "装备",
		"资料",
		"珍兽",
	};	
	
	--屏蔽玩家资料页签中“电子邮件相关内容”，TT62640
	TargetData_EMail_Text:Hide();
	TargetData_EMail:Hide();
	
	-- 分页按钮
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
			PushDebugMessage ("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
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
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--取消关心
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
	
	--标题显示玩家的名字
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
	
	--提交
	SystemSetup:ApplyPrivateInfo();
	
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "SelfData");

end

--===============================================
-- 打开
--===============================================
function TargetData_TargetEquip_Down()
	if( g_Current_Page == SELF_PAGE )     then
		Variable:SetVariable("SelfUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("self");
	else
		Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("other");
	end
	--取消关心
	this:CareObject(objCared, 0, "SelfData");
end


-- function TargetData_TargetBlog_Down()
-- 	Variable:SetVariable("OtherUnionPos", TargetData_Frame:GetProperty("UnifiedPosition"), 1);

-- 	local strCharName =  CachedTarget:GetData("NAME");
-- 	local strAccount =  CachedTarget:GetData("ACCOUNTNAME")
-- 	Blog:OpenBlogPage(strAccount,strCharName,false);
	
-- end
--===============================================
-- 打开
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

--武魂

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
	if idx == 1 then--装备
		return 1
	elseif idx == 2 then--资料
		return 1
	elseif idx == 3 then--珍兽
		return 1
	elseif idx == 4 then--武魂
		return 1
	elseif idx == 5 then--灵玉

		return 1
	elseif idx == 6 then--神兵

		return 1
	elseif idx == 7 then--雕文进阶

		return 1
	elseif idx == 8 then--巅峰


		return 1
	elseif idx == 9 then--个人
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

	if idx == 1 then--装备
		TargetData_TargetEquip_Down()
	elseif idx == 2 then--资料
		TargetData_ClearPage()
	elseif idx == 3 then--珍兽
		TargetData_OtherPet_Down()
	elseif idx == 4 then--武魂
		TargetData_TargetWuhun_Switch()
	elseif idx == 5 then--灵玉
		TargetData_TargetLingyu_Switch()
	elseif idx == 6 then--神兵
		TargetData_ShenBing_Switch()
	elseif idx == 7 then--雕文进阶
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