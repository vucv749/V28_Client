
local CTRL_NUM = 11
local CTRL = {};

local SELF_PAGE  = 0;
local OTHER_PAGE = 1;
local g_Current_Page;
local SELFDATA_TAB_TEXT = {};

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

-- 界面的默认相对位置
local g_SelfData_Frame_UnifiedXPosition;
local g_SelfData_Frame_UnifiedYPosition;

--统一化下页签显示隐藏 目前固定顺序 新增改序号 每个页签都需要添加
local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		NeedCheck = 0,Tip = ""},
	[2] = {Text = "#{INTERFACE_XML_882}",		NeedCheck = 0,Tip = ""},
	[3] = {Text = "#{INTERFACE_XML_854}",		NeedCheck = 0,Tip = ""},
	[4] = {Text = "#{WH_xml_XX(95)}",			NeedCheck = 0,Tip = ""},
	[5] = {Text = "#{XL_XML_35}",				NeedCheck = 0,Tip = ""},
	[6] = {Text = "#{TalentMP_20210804_57}",	NeedCheck = 1,Tip = ""},
	[7] = {Text = "#{SZXT_221216_22}",			NeedCheck = 0,Tip = "#{SZXT_221216_23}"},
	[8] = {Text = "#{SBFW_20230707_1}",		NeedCheck = 1,Tip = "#{SBFW_20230707_2}"},
	[9] = {Text = "#{DWJJ_240329_153}",  	 	NeedCheck = 0,Tip = ""},
	[10] = {Text = "#{DFJC_250709_1}",		NeedCheck = 0,Tip = ""},
	[11] = {Text = "#{GRYM_221213_22}",  	 	NeedCheck = 0,Tip = ""},
	[12] = {Text = "#{INTERFACE_XML_496}",		NeedCheck = 0,Tip = ""},
}
local g_PageButton = {}
local g_PageTip = {}
local g_PageMask = {}
local g_MaxPage = 12
local g_PageCount = 12
local g_PageOrder = {}

--===============================================
-- OnLoad()
--===============================================
function SelfData_PreLoad()
	this:RegisterEvent("OPEN_PRIVATE_INFO");
	this:RegisterEvent("UPDATE_PRIVATE_INFO");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("UPDATE_EXTERIOR_TIP")
end

function SelfData_OnLoad()
	--生肖
	SelfData_YearAnimal:ComboBoxAddItem("-",0);
	SelfData_YearAnimal:ComboBoxAddItem("鼠",1); 
	SelfData_YearAnimal:ComboBoxAddItem("牛",2); 
	SelfData_YearAnimal:ComboBoxAddItem("虎",3); 
	SelfData_YearAnimal:ComboBoxAddItem("兔",4); 
	SelfData_YearAnimal:ComboBoxAddItem("龙",5); 
	SelfData_YearAnimal:ComboBoxAddItem("蛇",6); 
	SelfData_YearAnimal:ComboBoxAddItem("马",7); 
	SelfData_YearAnimal:ComboBoxAddItem("羊",8); 
	SelfData_YearAnimal:ComboBoxAddItem("猴",9);
	SelfData_YearAnimal:ComboBoxAddItem("鸡",10);
	SelfData_YearAnimal:ComboBoxAddItem("狗",11);
	SelfData_YearAnimal:ComboBoxAddItem("猪",12);
	
	--省份
	SelfData_Province:ComboBoxAddItem("-",		 0);
	SelfData_Province:ComboBoxAddItem("北京",  1); 
	SelfData_Province:ComboBoxAddItem("天津",  2); 
	SelfData_Province:ComboBoxAddItem("上海",  3); 
	SelfData_Province:ComboBoxAddItem("重庆",  4); 
	SelfData_Province:ComboBoxAddItem("河北",  5); 
	SelfData_Province:ComboBoxAddItem("辽宁",  6); 
	SelfData_Province:ComboBoxAddItem("山东",  7); 
	SelfData_Province:ComboBoxAddItem("黑龙江",8); 
	SelfData_Province:ComboBoxAddItem("山西",  9); 
	SelfData_Province:ComboBoxAddItem("吉林",  10);
	SelfData_Province:ComboBoxAddItem("陕西",  11);
	SelfData_Province:ComboBoxAddItem("河南",  12);
	SelfData_Province:ComboBoxAddItem("安徽",  13);
	SelfData_Province:ComboBoxAddItem("江苏",  14);
	SelfData_Province:ComboBoxAddItem("湖北",  15);
	SelfData_Province:ComboBoxAddItem("浙江",  16);
	SelfData_Province:ComboBoxAddItem("湖南",  17);
	SelfData_Province:ComboBoxAddItem("江西",  18);
	SelfData_Province:ComboBoxAddItem("福建",  19);
	SelfData_Province:ComboBoxAddItem("台湾",  20);
	SelfData_Province:ComboBoxAddItem("内蒙古",21);
	SelfData_Province:ComboBoxAddItem("甘肃",  22);
	SelfData_Province:ComboBoxAddItem("宁夏",  23);
	SelfData_Province:ComboBoxAddItem("四川",  24);
	SelfData_Province:ComboBoxAddItem("贵州",  25);
	SelfData_Province:ComboBoxAddItem("云南",  26);
	SelfData_Province:ComboBoxAddItem("广西",  27);
	SelfData_Province:ComboBoxAddItem("广东",  28);
	SelfData_Province:ComboBoxAddItem("海南",  29);
	SelfData_Province:ComboBoxAddItem("新疆",  30);
	SelfData_Province:ComboBoxAddItem("青海",  31);
	SelfData_Province:ComboBoxAddItem("西藏",  32);
	SelfData_Province:ComboBoxAddItem("澳门",  33);
	SelfData_Province:ComboBoxAddItem("香港",  34);
	SelfData_Province:ComboBoxAddItem("其他",  35);
	
	 --澳门  香港 和其他
	                                          
	--性别
	SelfData_Sex:ComboBoxAddItem("-",0);
	SelfData_Sex:ComboBoxAddItem("男",1);
	SelfData_Sex:ComboBoxAddItem("女",2);

	--血型
	SelfData_BloodType:ComboBoxAddItem("-",0);
	SelfData_BloodType:ComboBoxAddItem("A",1);
	SelfData_BloodType:ComboBoxAddItem("B",2);
	SelfData_BloodType:ComboBoxAddItem("AB",3);
	SelfData_BloodType:ComboBoxAddItem("O",4);


	--星座
	SelfData_Constellation:ComboBoxAddItem("-",0); 
	SelfData_Constellation:ComboBoxAddItem("魔羯座",1);
	SelfData_Constellation:ComboBoxAddItem("水瓶座",2); 
	SelfData_Constellation:ComboBoxAddItem("双鱼座",3); 
	SelfData_Constellation:ComboBoxAddItem("白羊座",4); 
	SelfData_Constellation:ComboBoxAddItem("金牛座",5); 
	SelfData_Constellation:ComboBoxAddItem("双子座",6); 
	SelfData_Constellation:ComboBoxAddItem("巨蟹座",7); 
	SelfData_Constellation:ComboBoxAddItem("狮子座",8); 
	SelfData_Constellation:ComboBoxAddItem("处女座",9); 
	SelfData_Constellation:ComboBoxAddItem("天秤座",10);
	SelfData_Constellation:ComboBoxAddItem("天蝎座",11);
	SelfData_Constellation:ComboBoxAddItem("射手座",12);
	
	CTRL[1] = SelfData_Age;
	CTRL[2] = SelfData_Sex;
	CTRL[3] = SelfData_Job;
	CTRL[4] = SelfData_School;
	CTRL[5] = SelfData_BloodType;
	CTRL[6] = SelfData_YearAnimal;
	CTRL[7] = SelfData_Constellation;
	CTRL[8] = SelfData_Province;
	CTRL[9] = SelfData_City;
	CTRL[10] = SelfData_EMail;
	CTRL[11] = SelfData_MessageBoard;
	
	SELFDATA_TAB_TEXT = {
		[0] = "装备",
		"资料",
		"珍兽",
		"其他",
	};
	
	-- 保存界面的默认相对位置
	g_SelfData_Frame_UnifiedXPosition	= SelfData_Frame : GetProperty("UnifiedXPosition");
	g_SelfData_Frame_UnifiedYPosition	= SelfData_Frame : GetProperty("UnifiedYPosition");

	--屏蔽玩家资料页签中“电子邮件相关内容”，TT62640
	SelfData_EMail_Text:Hide();
	SelfData_EMail:Hide();

	g_PageButton[1] = SelfData_SelfEquip
	g_PageButton[2] = SelfData_SelfData
	g_PageButton[3] = SelfData_Pet
	g_PageButton[4] = SelfData_Wuhun
	g_PageButton[5] = SelfData_Xiulian
	g_PageButton[6] = SelfData_Talent
	g_PageButton[7] = SelfData_Lingyu
	g_PageButton[8] = SelfData_Weapon2
	g_PageButton[9] = SelfData_DWJinJie
	g_PageButton[10] = SelfData_Peak
	g_PageButton[11] = SelfData_Profile
	g_PageButton[12] = SelfData_OtherInfo


	
	g_PageMask[1] = SelfData_SelfEquip_Mask
	g_PageMask[2] = SelfData_SelfData_Mask
	g_PageMask[3] = SelfData_Pet_Mask
	g_PageMask[4] = SelfData_Wuhun_Mask
	g_PageMask[5] = SelfData_Xiulian_Mask
	g_PageMask[6] = SelfData_Talent_Mask
	g_PageMask[7] = SelfData_Lingyu_Mask
	g_PageMask[8] = SelfData_Weapon2_Mask
	g_PageMask[9] = SelfData_DWJinJie_Mask
	g_PageMask[10] = SelfData_Peak_Mask
	g_PageMask[11] = SelfData_Profile_Mask
	g_PageMask[12] = SelfData_OtherInfo_Mask
	
	g_PageTip[1] = SelfData_SelfEquip_tips
	g_PageTip[2] = SelfData_SelfData_tips
	g_PageTip[3] = SelfData_Pet_tips
	g_PageTip[4] = SelfData_Wuhun_tips
	g_PageTip[5] = SelfData_Xiulian_tips
	g_PageTip[6] = SelfData_Talent_tips
	g_PageTip[7] = SelfData_Lingyu_tips
	g_PageTip[8] = SelfData_Weapon2_tips
	g_PageTip[9] = SelfData_DWJinJie_tips
	g_PageTip[10] = SelfData_Peak_tips
	g_PageTip[11] = SelfData_Profile_tips
	g_PageTip[12] = SelfData_OtherInfo_tips

end


--===============================================
-- OnEvent()
--===============================================
function SelfData_OnEvent(event)
	if ( event == "OPEN_PRIVATE_INFO" ) then
		local LocArg = arg0;
		SelfData_SetTabColor(1);
		 
		if(LocArg ~= "self")     then
			return;
		end
		
		this:Show();
		local isopen6 = T300Func:IsNoDifOpen(6)
		local isopen5 = T300Func:IsNoDifOpen(5)
		if isopen5 == 1 then
			--SelfData_Wuhun:Disable()
		else
			SelfData_Wuhun:Enable()
		end
		if isopen6 == 1 then
			--SelfData_Xiulian:Disable()
		else
			SelfData_Xiulian:Enable()
		end
		
		objCared = SystemSetup:GetCaredObjId();
		this:CareObject(objCared, 1, "SelfData");

		SelfData_SelfEquip:SetCheck(0);
		SelfData_SelfData:SetCheck(1);
		SelfData_Pet:SetCheck(0);

		if(LocArg == "self")     then
			local selfUnionPos = Variable:GetVariable("SelfUnionPos");
			if(selfUnionPos ~= nil) then
				SelfData_Frame:SetProperty("UnifiedPosition", selfUnionPos);
			end
			
			g_Current_Page = SELF_PAGE;
			SelfData_UpdateFrame("self");
			for i=1 ,CTRL_NUM  do
				CTRL[i]:Enable();
			end
			SelfData_DataShareMode:Show();
			SelfData_Accept:Show();
			SelfData_DataShareMode_Text:Show()
			SelfData_Pet:Show();
			SelfData_ShowPage()
			SelfData_UpdateRedPoint()
		else
			local otherUnionPos = Variable:GetVariable("OtherUnionPos");
			if(otherUnionPos ~= nil) then
				SelfData_Frame:SetProperty("UnifiedPosition", otherUnionPos);
			end
		
			g_Current_Page = OTHER_PAGE;
			SelfData_UpdateFrame("other");
			for i=1 ,CTRL_NUM  do
				CTRL[i]:Disable();
			end
			SelfData_DataShareMode:Hide();
			SelfData_Accept:Hide();
			SelfData_DataShareMode_Text:Hide();
			SelfData_Pet:Hide();
			SelfData_OtherInfo:Hide();
		end
		
	elseif (event == "OBJECT_CARED_EVENT") then
		AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1=="destroy") then
			g_InitiativeClose = 1;
			Variable:SetVariable("PageNumber", tostring(0), 1);
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "SelfData");
		end
		
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		SelfData_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置	
		SelfData_Frame_On_ResetPos()

	end
	
	if event == "UPDATE_EXTERIOR_TIP" and this:IsVisible() then
		SelfData_UpdateRedPoint()
	end
end

--===============================================
-- UpdateFrame()
--===============================================
function SelfData_UpdateFrame(whose)
	
	--标题显示玩家的名字
	local szName = SystemSetup:GetPrivateInfo(whose,"name");
 	SelfData_PageHeader:SetText("#gFF0FA0"..szName);
	
	local nType = SystemSetup:GetPrivateInfo(whose,"type");	
	if nType == 0      then
		SelfData_Mode1:SetCheck(1);
		SelfData_Mode2:SetCheck(0);
		SelfData_Mode3:SetCheck(0);
		
	elseif nType == 1  then
		SelfData_Mode1:SetCheck(0);
		SelfData_Mode2:SetCheck(1);
		SelfData_Mode3:SetCheck(0);
		
	elseif nType == 2  then
		SelfData_Mode1:SetCheck(0);
		SelfData_Mode2:SetCheck(0);
		SelfData_Mode3:SetCheck(1);
		
	end
	
	local szGuid = SystemSetup:GetPrivateInfo(whose,"guid");
	SelfData_ID:SetText("ID:".. szGuid);
	
	local nAge = SystemSetup:GetPrivateInfo(whose,"age");
	SelfData_Age:SetText(tostring(nAge));
	AxTrace(0,0,"SelfData_Age =" .. nAge);
	
	local nSex = SystemSetup:GetPrivateInfo(whose,"sex");
--	AxTrace(0,0,"nSex =" .. nSex);
	SelfData_Sex:SetCurrentSelect(nSex);
	
	local szJob = SystemSetup:GetPrivateInfo(whose,"job");
	SelfData_Job:SetText(szJob);
	AxTrace(0,0,"SelfData_Job =" .. szJob);
	
	local szSchool = SystemSetup:GetPrivateInfo(whose,"school");
	SelfData_School:SetText(szSchool);
	
	local nBlood = SystemSetup:GetPrivateInfo(whose,"blood");
--	AxTrace(0,0,"nBlood =" .. nBlood);
	SelfData_BloodType:SetCurrentSelect(nBlood);
	
	local nAnimal = SystemSetup:GetPrivateInfo(whose,"animal");
--	AxTrace(0,0,"nAnimal =" .. nAnimal);
	SelfData_YearAnimal:SetCurrentSelect(nAnimal);
	
	local nConsella = SystemSetup:GetPrivateInfo(whose,"Consella");
--	AxTrace(0,0,"nConsella =" .. nConsella);
	SelfData_Constellation:SetCurrentSelect(nConsella);
	
	local nProvince = SystemSetup:GetPrivateInfo(whose,"Province");
--	AxTrace(0,0,"nProvince =" .. nProvince);
	SelfData_Province:SetCurrentSelect(nProvince);
		
	local szCity = SystemSetup:GetPrivateInfo(whose,"city");
	SelfData_City:SetText(szCity);
	AxTrace(0,0,"SelfData_City =" .. szCity);
	
	local szEmail = SystemSetup:GetPrivateInfo(whose,"email");
	SelfData_EMail:SetText(szEmail);
	AxTrace(0,0,"SelfData_EMail =" .. szEmail);

	local szLuck = SystemSetup:GetPrivateInfo(whose,"luck");
	SelfData_MessageBoard:SetText(szLuck);
	AxTrace(0,0,"SelfData_MessageBoard =" .. szLuck);

end

--===============================================
-- Accept()
--===============================================
function SelfData_Accept_Clicked()
	
	local nType;
	if SelfData_Mode1:GetCheck() == 1     	then
		nType = 0;
	elseif SelfData_Mode2:GetCheck() == 1   then
		nType = 1;
	elseif SelfData_Mode3:GetCheck() == 1   then
		nType = 2;
	end
	
	local bCanUse=1;
	
	bCanUse = SystemSetup:SetPrivateInfo("self", "type", 		nType);
	--SystemSetup:SetPrivateInfo("self", "guid", 		2);
	
	if(bCanUse == 0)  then
		return;
	end
	
	local nAge = SelfData_Age:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "age", 		nAge);
	if(bCanUse == 0)  then
		return;
	end
	
	local szSex,nSex = SelfData_Sex:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "sex", 		nSex);
	if(bCanUse == 0)  then
		return;
	end
	
	local szJob = SelfData_Job:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "job", 		szJob);
	if(bCanUse == 0)  then
		return;
	end
	
	local szSchool = SelfData_School:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "school",	szSchool);
	if(bCanUse == 0)  then
		return;
	end
	
	local szBlood,nBlood = SelfData_BloodType:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "blood", 	nBlood);
	if(bCanUse == 0)  then
		return;
	end
	
	local szAnimal,nAnimal = SelfData_YearAnimal:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "animal",	nAnimal);
	if(bCanUse == 0)  then
		return;
	end
	
	local szConsella,nConsella = SelfData_Constellation:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "Consella",nConsella);
	if(bCanUse == 0)  then
		return;
	end
	
	local szProvince,nProvince = SelfData_Province:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "Province",nProvince);
	if(bCanUse == 0)  then
		return;
	end
	
	local szCity = SelfData_City:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "city", 		szCity);
	if(bCanUse == 0)  then
		return;
	end
	
	local szEmail = SelfData_EMail:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "email", 	szEmail);
	if(bCanUse == 0)  then
		return;
	end
	
	local szLuck = SelfData_MessageBoard:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "luck", 		szLuck);
	if(bCanUse == 0)  then
		return;
	end
	
	--提交
	SystemSetup:ApplyPrivateInfo();
	Variable:SetVariable("PageNumber", tostring(0), 1);
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "SelfData");

end

--===============================================
-- 打开
--===============================================
function SelfData_SelfEquip_Down()
	if( g_Current_Page == SELF_PAGE )     then
		Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("self");
	else
		Variable:SetVariable("OtherUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("other");
	end
			
	--取消关心
	this:CareObject(objCared, 0, "SelfData");
end

--===============================================
-- 打开
--===============================================
function SelfData_Pet_Down()

	if( g_Current_Page == SELF_PAGE )     then
		Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenPetFrame("self");
		--取消关心
		this:CareObject(objCared, 0, "SelfData");
		
	else
		Variable:SetVariable("OtherUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenPetFrame("other");
	end
			
	
end

--===============================================
-- OnHiden
--===============================================
function SelfData_Frame_OnHiden()
	SelfData_Job:SetProperty("DefaultEditBox", "False");
	SelfData_School:SetProperty("DefaultEditBox", "False");
	SelfData_City:SetProperty("DefaultEditBox", "False");
	SelfData_EMail:SetProperty("DefaultEditBox", "False");
	
	SelfData_Age:SetProperty("DefaultEditBox", "False");
	SelfData_MessageBoard:SetProperty("DefaultEditBox", "False")
	
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

--===============================================
-- SetTabColor
--===============================================
function SelfData_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end	
	
	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = SelfData_SelfEquip,
								SelfData_SelfData,
								SelfData_Pet,
								SelfData_OtherInfo,
							};
	
	while i < 4 do
		if(i == idx) then
			tab[i]:SetText(selColor..SELFDATA_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..SELFDATA_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

function SelfData_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
	SelfData_SelfEquip : SetCheck(0);
	SelfData_SelfData : SetCheck(1);
	SelfData_Pet : SetCheck(0);
	SelfData_OtherInfo : SetCheck(0);
	SelfData_SetTabColor(1);
end

function SelfData_Xiulian_Switch()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		SelfData_Xiulian : SetCheck(0)
		SelfData_ClearPage()
		return
	end
	
    nLevel = Player:GetData("LEVEL")
	if(nLevel >= 70) then
		Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		XiuLianPage();
	else
	    SelfData_Xiulian : SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    SelfData_ClearPage()
	end
end

--显示武魂UI
function SelfData_Wuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		SelfData_Wuhun : SetCheck(0)
		SelfData_ClearPage()
		return
	end
	Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);	
	ToggleWuhunPage();
end

function SelfData_Talent_Switch()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		ToggleTalentPage();
	else
		SelfData_Talent : SetCheck(0)
		SelfData_ClearPage()
	end
end

--切换个人展示界面
function SelfData_Profile_Switch()
	Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);	
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
end

function SelfData_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		SelfData_Lingyu:SetCheck(0)
		SelfData_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function SelfData_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		SelfData_Weapon2:SetCheck(0)
		SelfData_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function SelfData_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		SelfData_DWJinJie:SetCheck(0)
		SelfData_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function SelfData_Frame_On_ResetPos()
	SelfData_Frame : SetProperty("UnifiedXPosition", g_SelfData_Frame_UnifiedXPosition);
	SelfData_Frame : SetProperty("UnifiedYPosition", g_SelfData_Frame_UnifiedYPosition);
end

function SelfData_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"));
	SelfData_ClearPage()
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, g_MaxPage do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, g_MaxPage do
		if SelfData_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if SelfData_IsPageEnable(i) == 1 then
				g_PageButton[g_PageCount]:Enable()
				g_PageMask[g_PageCount]:Hide()
			else
				g_PageButton[g_PageCount]:Disable()
				g_PageMask[g_PageCount]:Show()
				g_PageMask[g_PageCount]:SetToolTip(g_Page[i].Tip)
			end
		end
	end
end

function SelfData_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]
	if idx == 1 then--装备
		SelfData_SelfEquip_Down(0);
	elseif idx == 2 then--资料
		--Pet_Page_SelfData()
		SelfData_ClearPage()
	elseif idx == 3 then--珍兽
		SelfData_Pet_Down()
	elseif idx == 4 then--武魂
		SelfData_Wuhun_Switch()
	elseif idx == 5 then--修炼
		SelfData_Xiulian_Switch()
	elseif idx == 6 then--武道
		SelfData_Talent_Switch()
	elseif idx == 7 then--灵玉
		SelfData_Page_LingYu()
	elseif idx == 8 then--神兵
		SelfData_Page_ShenBing()
	elseif idx == 9 then--雕文进阶
		SelfData_Page_DWJinJie()
	elseif idx == 10 then--巅峰 
		SelfData_Page_Peak()
	elseif idx == 11 then--个人
		SelfData_Profile_Switch()
	elseif idx == 11 then--其他
		SelfData_Other_Info_Page_Switch()
	end
end

function SelfData_CheckPage(idx)
	if idx == 1 then--装备
		return 1
	elseif idx == 2 then--资料
		return 1
	elseif idx == 3 then--珍兽
		return 1
	elseif idx == 4 then--武魂
		return 1
	elseif idx == 5 then--修炼
		return 1
	elseif idx == 6 then--武道
		return DataPool:Lua_CheckIsShowTalent()
	elseif idx == 7 then--灵玉
		return 1
	elseif idx == 8 then--神兵
		return 1
	elseif idx == 9 then--雕文进阶
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 10 then--巅峰

		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end

	elseif idx == 11 then--个人
		local my_level = Player:GetData("LEVEL")
		if my_level >= 15 then
			return 1
		end
	elseif idx == 12 then--其他
		return 1
	end
	return 0
end

function SelfData_IsPageEnable(idx)
	if idx == 1 then--装备
		return 1
	elseif idx == 2 then--资料
		return 1
	elseif idx == 3 then--珍兽
		return 1
	elseif idx == 4 then--武魂
		return 1
	elseif idx == 5 then--修炼
		return 1
	elseif idx == 6 then--武道
		return 1
	elseif idx == 7 then--灵玉
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 8 then--神兵
		local my_level = Player:GetData("LEVEL")
		if my_level >= 65 then
			return 1
		end
	elseif idx == 9 then--雕文进阶
		return 1
	elseif idx == 10 then--巅峰
	
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--个人
		return 1
	elseif idx == 12 then--其他
		return 1
	end
	return 0
end

function SelfData_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--更新分页红点
function SelfData_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end


function SelfData_Page_Peak()
	Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	this:Hide();
end
