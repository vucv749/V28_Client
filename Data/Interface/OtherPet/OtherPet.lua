local WuXingTbl = {
			{level =1,	per = "1.0%" ,	maxlevel=1,	color = "#c00D000"},
			{level =2,	per = "1.5%" ,	maxlevel=1,	color = "#c00D000"},
			{level =3,	per = "2.1%" ,	maxlevel=2,	color = "#c00D000"},
			{level =4,	per = "3.0%" ,	maxlevel=2,	color = "#c00D000"},
			{level =5,	per = "8.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =6,	per = "11.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =7,	per = "14.5%" ,	maxlevel=4,	color = "#c43DBFF"},
			{level =8,	per = "23.5%" ,	maxlevel=4,	color = "#cFF8001"},
			{level =9,	per = "30.0%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =10,	per = "39.3%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =11,	per = "42.3%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =12,	per = "46.0%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =13,	per = "50.2%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =14,	per = "54.7%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =15,	per = "59.5%", maxlevel=5,	color = "#cFF8001"},
}
local ShowColor = "#H";
local PETSKILL_BUTTONS_NUM = 12;
local PETSKILL_BUTTONS = {};
local PET_POTREMAIN = 0;
local PET_ATTR_COUNT = 5;
local PET_MAX_NUMBER = 6+4;
local PETNUM = 0;
local PET_REST = 1;
local PET_FIGHT= 0;
local PET_CURRENT_SELECT = 0;
local PET_AITYPE = {};
local Changed_Name_Flag = 0;
--			// ´´½¨ äÊÞ(¼´·Å³ö) 0
--			// Ê »Ø äÊÞ					1
--			// Ïú»Ù äÊÞ(¼´·ÅÉú)	2
--			// ²¶×½ äÊÞ					3
--			¿ÉÒÔÔÚ±»·Å³öºó£¬Í¨¹ýÏûÏ¢£¬¸Ä±ä¸Ã äÊÞÔÚlistboxÖÐµÄÃû×ÖµÄÑ É«¡£
local PET_TAB_TEXT = {};
local PET_ORIGINAL_NAME = "";

------------------------------------------------------
-- äÊÞ×°±¸°´Å¥Êý¾Ý¶¨Òå zchw
local g_Pet_Head; 		--?
local g_Pet_Claw;			--?
local g_Pet_Body; 		--??
local g_Pet_Neck;			--??
local g_Pet_Charm;		--??

local g_OtherPet_Frame_UnifiedPosition;
local g_PetEquipPointNum = 6
------------------------------------------------------

local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		},
	[2] = {Text = "#{INTERFACE_XML_882}",		},
	[3] = {Text = "#{INTERFACE_XML_854}",		},
	[4] = {Text = "#{WH_xml_XX(95)}",			},
	[5] = {Text = "#{SZXT_221216_22}",			},
	[6] = {Text = "#{SBFW_20230707_1}",			},
	[7] = {Text = "#{DWJJ_240329_153}",  	 	},
	[8] = {Text = "#{DFJC_250709_1}",  	 	},
	[9] = {Text = "#{GRYM_221213_22}",  	 	},
}
local g_PageButton = {}
local g_PageOrder = {}
function OtherPet_PreLoad()
	this:RegisterEvent("TOGLE_OTHERPET_PAGE");
	this:RegisterEvent("UPDATE_OTHERPET_PAGE");
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function OtherPet_OnLoad()

	PETSKILL_BUTTONS[1] = OtherPet_Skill1;
	PETSKILL_BUTTONS[2] = OtherPet_Skill2;
	PETSKILL_BUTTONS[3] = OtherPet_Skill3;
	PETSKILL_BUTTONS[4] = OtherPet_Skill4;
	PETSKILL_BUTTONS[5] = OtherPet_Skill5;
	PETSKILL_BUTTONS[6] = OtherPet_Skill6;
	PETSKILL_BUTTONS[7] = OtherPet_Skill7;
	PETSKILL_BUTTONS[8] = OtherPet_Skill8;
	PETSKILL_BUTTONS[9] = OtherPet_Skill9;
	PETSKILL_BUTTONS[10] = OtherPet_Skill10;
	PETSKILL_BUTTONS[11] = OtherPet_Skill11;
	PETSKILL_BUTTONS[12] = OtherPet_Skill12;

	PET_AITYPE[0] = "Nhát gan";
	PET_AITYPE[1] = "C¦n th§n";
	PET_AITYPE[2] = "Trung thñc";
	PET_AITYPE[3] = "Nhanh nh©n";
	PET_AITYPE[4] = "Dûng mãnh";

	PET_TAB_TEXT = {
		[0] = "Trang b¸",
		"Tß li®u",
		"Trân Thú",
	};
	--------------------------
	--  äÊÞ×°±¸ÓëÈ«¾Ö±äÁ¿¹ØÁª zchw
	g_Pet_Head = OtherPetEquip_1;
	g_Pet_Claw = OtherPetEquip_2;
	g_Pet_Body = OtherPetEquip_3;
	g_Pet_Neck = OtherPetEquip_4;
	g_Pet_Charm = OtherPetEquip_5;
	---------------------------

	-- ·ÖÒ³°´Å¥
	g_PageButton[1] = OtherPet_SelfEquip
	g_PageButton[2] = OtherPet_TargetData
	g_PageButton[3] = OtherPet_Pet
	g_PageButton[4] = OtherPet_TargetWuhun
	g_PageButton[5] = OtherPet_TargetLingyu
	g_PageButton[6] = OtherPet_TargetWeapon2
	g_PageButton[7] = OtherPet_TargetDWJinJie
	g_PageButton[8] = OtherPet_TargetPeak
	g_PageButton[9] = OtherPet_TargetProfile

	g_OtherPet_Frame_UnifiedPosition=OtherPet_Frame:GetProperty("UnifiedPosition")
	
	g_Elf_Button[1] = OtherPet_RightFrame2_TopItem1
	g_Elf_Button[2] = OtherPet_RightFrame2_TopItem2
	g_Elf_Button[3] = OtherPet_RightFrame2_TopItem3
	g_Elf_Button[4] = OtherPet_RightFrame2_TopItem4
	g_Elf_Button[5] = OtherPet_RightFrame2_TopItem5
	
	g_Elf_LockImg[1] = OtherPet_RightFrame2_TopItem1Lock
	g_Elf_LockImg[2] = OtherPet_RightFrame2_TopItem2Lock
	g_Elf_LockImg[3] = OtherPet_RightFrame2_TopItem3Lock
	g_Elf_LockImg[4] = OtherPet_RightFrame2_TopItem4Lock
	g_Elf_LockImg[5] = OtherPet_RightFrame2_TopItem5Lock
end

function OtherPet_OnEvent(event)
	OtherPet_SetTabColor(3);
	--this:Show();

	if ( event == "TOGLE_OTHERPET_PAGE" ) then

		if arg0 ~= nil and tonumber(arg0) < PET_MAX_NUMBER and tonumber(arg0) >= 0 then
			PET_CURRENT_SELECT = tonumber(arg0)
		end
		if(IsWindowShow("TargetPet")) then
			CloseWindow("TargetPet", true);
			return;
		end
		
		local obj_id = CachedTarget:GetData("NPCID", 1)
		if (type(obj_id) ~="number") then
			PushDebugMessage ("#{JSCK_90507_1}")				-- ???????,???????
			return
		end
		this:CareObject(obj_id , 1)

		OtherPet_OnShown();
		OtherPet_Open();
		return;
	elseif ( event == "UPDATE_OTHERPET_PAGE" and this:IsVisible() ) then
		OtherPet_Update();
		OtherPet_SetStateTooltip(PET_CURRENT_SELECT);
		return;
		
	elseif (event == "ADJEST_UI_POS" ) then
		OtherPet_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		OtherPet_Frame_On_ResetPos()
	end

end

function OtherPet_OnShown()
	local otherUnionPos = Variable:GetVariable("OtherUnionPos");
	if(otherUnionPos ~= nil) then
		OtherPet_Frame:SetProperty("UnifiedPosition", otherUnionPos);
	end
	

	OtherPet_Page_Clear();
	OtherPet_Update();
	OtherPet_SetStateTooltip(PET_CURRENT_SELECT);

end

function OtherPet_Page_Clear()
	OtherPet_FakeObject:RotateEnd();
	OtherPet_FakeObject:RotateEnd();


	OtherPet_OtherPetName:SetText("")
	OtherPet_Type : SetText("");

	OtherPet_PageHeader : SetText( "#gFF0FA0Trân Thú" );
	OtherPet_ConsortID : SetText( "" );
	OtherPet_Model_Protect_Text : SetText( "" );
	OtherPet_Skin : SetText( "" );
	OtherPet_OtherPetID : SetText( "" );
	OtherPet_Sex : SetText("");
	OtherPet_Life : SetText( "" );
	OtherPet_Happy : SetText("");
	OtherPet_Level : SetText( "" );
	OtherPet_StrAptitude : SetText( "" );
	OtherPet_PhysicalStrengthAptitude : SetText( "" );
	OtherPet_DexterityAptitude : SetText( "" );
	OtherPet_NimbusAptitude : SetText( "" );
	OtherPet_StabilityAptitude : SetText( "" );
	OtherPet_Exp : SetText( "" );
	OtherPet_Blood : SetText( "" );
	OtherPet_Str : SetText( "" );
	OtherPet_Nimbus : SetText( "" );
	OtherPet_Dexterity : SetText( "" );
	OtherPet_PhysicalStrength : SetText( "" );
	OtherPet_Stability : SetText( "" );
	OtherPet_GenGu : SetText( "" );
	OtherPet_Potential : SetText( "" );
	OtherPet_PhysicsAttack : SetText( "" );
	OtherPet_MagicAttack : SetText( "" );
	OtherPet_PhysicsRecovery : SetText( "" );
	OtherPet_MagicRecovery : SetText( "" );
	OtherPet_Miss : SetText( "" );
	OtherPet_WuXing : SetText( "" );
	OtherPet_ShootProbability : SetText( "" );
	OtherPet_CriticalAttack:SetText("");
	OtherPet_CriticalDefence:SetText("")
	OtherPet_FakeObject : SetFakeObject( "" );
	OtherPet_Growth:SetText("");
	OtherPetAttack_Type : Hide();
	OtherPet_Lingxing : SetText("")
	OtherPet_Lingxing_Info : SetText("")
	

	--added by dun.liu
	g_Pet_Head : SetActionItem(-1);
	g_Pet_Claw : SetActionItem(-1);
	g_Pet_Body : SetActionItem(-1);
	g_Pet_Neck : SetActionItem(-1);
	g_Pet_Charm : SetActionItem(-1);
	OtherPet_PetSoul_Equip:SetActionItem(-1)

	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1);
	end
	OtherPetFood_Type : Hide();
	OtherPet_lock : Hide();
	OtherPet_Jian : Hide();

	--ÉèÖÃ äÊÞÊýÁ¿ÐÅÏ¢--add by xindefeng
	local nPetCount = Pet:Other_GetPet_Count();
	local nMaxPetCount = GetOtherCurMaxPetCount();
	OtherPet_List_Text:SetText("Trân Thú Li®t Bi¬u"..nPetCount.."/"..nMaxPetCount);
	
	OtherPet_ClearStateTooltip();
end

function OtherPet_ListBox_Selected()
	PETNUM = OtherPet_List : GetFirstSelectItem();
	local nOtherPetCount = Pet : Other_GetPet_Count();

	if(PETNUM == PET_CURRENT_SELECT) then
		return;
	end

	if(PETNUM < 0 and nPetCount > 0) then
		PETNUM = PET_CURRENT_SELECT;
		return;
	end

	OtherPet_Page_Clear();
	Changed_Name_Flag = 0;
	PET_CURRENT_SELECT = PETNUM;
	AxTrace(0,1,"here="..PET_CURRENT_SELECT)
	OtherPet_FakeObject : SetFakeObject( "" );
	Pet : Other_SetModel(PETNUM);
	OtherPet_FakeObject : SetFakeObject( "My_OtherPet" );


	OtherPet_Show_Appoint(PETNUM);
	OtherPet_Refresh_Equip();
	OtherPet_SetStateTooltip(PETNUM);
	Pet : Other_SetSelectedIdx(PETNUM)

end

function OtherPet_ListBox_RClicked()
	local clkNum = OtherPet_List : GetClickItem();
	--AxTrace(0,0,"OtherPet_ListBox_RClicked "..tostring(clkNum));
	if(clkNum >= 0) then
		Pet:CheckRClick(clkNum);
	end
end

function OtherPet_Update()
	
	--Ò³Ç©
	OtherPet_ShowPage()

	local nPetCount = Pet : Other_GetPet_Count();
	local szPetName;

	OtherPet_Page_Clear();
	OtherPet_List : ClearListBox();

	if nPetCount < 1 then
		return;
	end

	local bSelect = 0;
	AxTrace(0,1,"nPetCount="..nPetCount);
	for	i=1, PET_MAX_NUMBER do
		if Pet:Other_IsPresent(i-1) then
			szPetName = Pet : Other_GetPetList_Appoint(i-1);
			AxTrace(0,1,"Câu"..i.."Chích Khiªu"..szPetName);

			OtherPet_List : AddItem(szPetName, i-1);

			if( i-1 == PET_CURRENT_SELECT) then
				bSelect = 1;
			end
		end
	end

	--yuanfengfeng for tt 50330£¬ÔÚPET_CURRENT_SELECT¶ÔÓ¦µÄ³èÎï²»´æÔÚµÄÇé¿öÏÂ£¬½«PET_CURRENT_SELECTÖÃÎªµÚÒ»¸ö£¬È»ºóÉèÖÃbSelectÎª1
	--ÄÜ×ßµ½ âÀï£¬¿Ï¶¨ÖÁÉÙÓÐÒ»¸ö³èÎï
	if bSelect == 0 then
		bSelect = 1;
		PET_CURRENT_SELECT = 0;
	end

	--ÓÐÑ¡ÖÐ¶ÔÏóµÄ£¬²Å½øÐÐÑ¡ÖÐ²Ù×÷¡£
	if bSelect == 1 then
		OtherPet_List : SetItemSelectByItemID(PET_CURRENT_SELECT);
		OtherPet_FakeObject : SetFakeObject( "" );
		Pet : Other_SetModel(PET_CURRENT_SELECT);
		OtherPet_FakeObject : SetFakeObject( "My_OtherPet" );
		OtherPet_Show_Appoint(PET_CURRENT_SELECT);
	end

	if PET_CURRENT_SELECT > PET_MAX_NUMBER then
		PET_CURRENT_SELECT = PET_MAX_NUMBER;
	end

	local strNeedLevel;
	local strNeedLevelColor;
	local nTakeLevel = Pet:Other_GetTakeLevel(PET_CURRENT_SELECT );

	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor="#cFF0000";
	else
		strNeedLevelColor="#c00FF00";
	end
	strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."C¤p#W Mang theo";
	OtherPet_NeedLevel:SetText( strNeedLevel );
		
end

function OtherPet_Refresh_Equip()

	g_Pet_Head:SetActionItem(-1)
	g_Pet_Claw:SetActionItem(-1)
	g_Pet_Body:SetActionItem(-1)
	g_Pet_Neck:SetActionItem(-1)
	g_Pet_Charm:SetActionItem(-1)

	local ActionClaw = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT, "other_pet_equip")
	local ActionHead = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 1, "other_pet_equip")
	local ActionBody = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 2, "other_pet_equip")
	local ActionNeck = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 3, "other_pet_equip")
	local ActionCharm = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 4, "other_pet_equip")

	g_Pet_Head:SetActionItem(ActionHead:GetID())
	g_Pet_Claw:SetActionItem(ActionClaw:GetID())
	g_Pet_Body:SetActionItem(ActionBody:GetID())
	g_Pet_Neck:SetActionItem(ActionNeck:GetID())
	g_Pet_Charm:SetActionItem(ActionCharm:GetID())
	
	OtherPet_PetSoul_Equip:SetActionItem(-1)
	OtherPet_PetSoul1:SetActionItem(-1)
	OtherPet_PetSoul2:SetProperty("BackImage", "")
	OtherPet_PetSoul_Equip_Check:Disable()
	
	if Pet:LuaFnIsOtherPetEquipPetSoul(PET_CURRENT_SELECT) == 1 then
		local ActionSoul = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 5, "other_pet_equip")
		OtherPet_PetSoul_Equip:SetActionItem(ActionSoul:GetID())
	
		local skillAction = Pet:LuaFnEnumOtherPetSoulSkillActionOnPet(PET_CURRENT_SELECT)
		if skillAction ~= nil then
			OtherPet_PetSoul1:SetActionItem(skillAction:GetID())
		end
		
		OtherPet_PetSoul_Equip_Check:Enable()
		
		local _, szPetPossSkillIcon, _, _ = Pet:LuaFnGetPetSoulPossSkillInfo(PET_CURRENT_SELECT, 1)
		if szPetPossSkillIcon ~= "" then
			OtherPet_PetSoul2:SetProperty( "BackImage", szPetPossSkillIcon )
		end
	end
end

function OtherPet_Show_Appoint(nIndex)

	local i;

	if(not (Pet:Other_IsPresent(nIndex)) ) then
		return;
	end

	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1);
	end

 	local strName = Pet:Other_GetAIType(nIndex);

	local strAI;
	if(strName>4 or strName <0) then
		strAI = "Sai l¥m";
	else
		strAI =	PET_AITYPE[strName];
	end

	local	strName2 = ""
 	strName,strName2 = Pet:Other_GetName(nIndex);
	local nEra, strTypeName = Pet:Other_GetPetTypeName(nIndex);
 	if( 1 == nEra ) then
 	    strName2 = "Ð¶i thÑ 2"..strTypeName
 	end


 	OtherPet_PageHeader : SetText("#gFF0FA0"..strName2);
 	OtherPet_Type :SetText("#gFF8E92"..strAI);

	OtherPet_OtherPetName : SetText( strName );

--	OtherPet_PageHeader : SetText( strAI .. strName2 );

	strName,strName2,sex = Pet : Other_GetID(nIndex);
	OtherPet_OtherPetID : SetText( "Trân Thú ID:"..strName2 );
	AxTrace(0,0,"GetID="..strName .. strName2);

	strName = Pet : Other_GetConsort(nIndex);
	if(strName == "00000000") then
		strName = "";
	end;
	OtherPet_ConsortID : SetText( "Ph¯i ngçu ID:"..strName );
	
	if Pet : Other_GetGoodsProtect_Pet(nIndex) == 1 then
		OtherPet_Model_Protect_Text : SetText( "#{GDWPBH_090507_4}" );
	else
		OtherPet_Model_Protect_Text : SetText( "" );
	end

	if(sex == 1) then
		strName = "Gi¯ng ðñc";
	else
		strName = "Gi¯ng cái";
	end

	local nGeneration  = Pet : Other_GetGeneration(nIndex)
	if nGeneration ~= nil and nGeneration >= 100 then
		strName = "#{RXZS_XML_35}";
	end

	OtherPet_Sex : SetText( strName );
	local strNeedLevel;
	local strNeedLevelColor;
	local nTakeLevel = Pet:Other_GetTakeLevel(nIndex);

	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor="#cFF0000";
	else
		strNeedLevelColor="#c00FF00";
	end
	strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."C¤p#W Mang theo";
	OtherPet_NeedLevel:SetText( strNeedLevel );
	strName = Pet : Other_GetNaturalLife(nIndex);
--	strName2 = OtherPet:	GetMaxLife(nIndex);
	OtherPet_Life : SetText( "S¯ng lâu:"..strName );

--	strName = Pet : Other_GetLoyalgGade(nIndex);
--	OtherPet_LoyalgGade : SetText( strName );

--	strName = Pet : Other_GetBasic(nIndex);
--	OtherPet_GenGu : SetText( "¸ù¹Ç:"..strName );

	strName = Pet : Other_GetLevel(nIndex);
	OtherPet_Level : SetText( "C¤p b§c:"..strName );

--	strName = Pet : Other_GetType(nIndex);
--	OtherPet_Type : SetText( "µÚ".. tostring(strName).."´ú" );

	strName = Pet : Other_GetHappy(nIndex);
	OtherPet_Happy : SetText( "Khoái LÕc:"..strName );

	strName = Pet : Other_GetLixing(nIndex);
	OtherPet_Lingxing : SetText("#{RXZS_XML_28}"..strName)

	strName = Pet : Other_GetPercent_Lx(nIndex)
	if tonumber(strName) ~= nil and tonumber(strName) > 0 then
		local rateStr = string.format("%0.1f" , strName / 10.0)
		OtherPet_Lingxing_Info:SetText("#cFF00FF(+"..rateStr.."%)")
	end

	local iSavvy = Pet:Other_GetSavvy(nIndex)
	OtherPet_WuXing:SetText("Ngµ tính:"..tostring(iSavvy))

	local iStrAptitude = Pet:Other_GetStrAptitude(nIndex)
	local iSprAptitude = Pet:Other_GetIntAptitude(nIndex)
	local iConAptitude = Pet:Other_GetPFAptitude(nIndex)
	local iIntAptitude = Pet:Other_GetStaAptitude(nIndex)
	local iDexAptitude = Pet:Other_GetDexAptitude(nIndex)
	
	local bHavePetSoul = Pet:LuaFnIsOtherPetEquipPetSoul(nIndex)
	local iStrAptitude_ps = Pet:LuaFnOtherGetStrAptitude_ps(nIndex)
	local iSprAptitude_ps = Pet:LuaFnOtherGetSprAptitude_ps(nIndex)
	local iConAptitude_ps = Pet:LuaFnOtherGetConAptitude_ps(nIndex)
	local iIntAptitude_ps = Pet:LuaFnOtherGetIntAptitude_ps(nIndex)
	local iDexAptitude_ps = Pet:LuaFnOtherGetDexAptitude_ps(nIndex)

	if WuXingTbl[iSavvy] ~= nil then
		if bHavePetSoul == 1 then
			OtherPet_StrAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iStrAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iStrAptitude_ps)..")")
			OtherPet_NimbusAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iSprAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iSprAptitude_ps)..")")
			OtherPet_PhysicalStrengthAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iConAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iConAptitude_ps)..")")
			OtherPet_StabilityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iIntAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iIntAptitude_ps)..")")
			OtherPet_DexterityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iDexAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iDexAptitude_ps)..")")
		else
			OtherPet_StrAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iStrAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			OtherPet_NimbusAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iSprAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			OtherPet_PhysicalStrengthAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iConAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			OtherPet_StabilityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iIntAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			OtherPet_DexterityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iDexAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
	end
	else
		if bHavePetSoul == 1 then
			OtherPet_StrAptitude:SetText(tostring(iStrAptitude).."#cFFCC99(+"..tostring(iStrAptitude_ps)..")")
			OtherPet_NimbusAptitude:SetText(tostring(iSprAptitude).."#cFFCC99(+"..tostring(iSprAptitude_ps)..")")
			OtherPet_PhysicalStrengthAptitude:SetText(tostring(iConAptitude).."#cFFCC99(+"..tostring(iConAptitude_ps)..")")
			OtherPet_StabilityAptitude:SetText(tostring(iIntAptitude).."#cFFCC99(+"..tostring(iIntAptitude_ps)..")")
			OtherPet_DexterityAptitude:SetText(tostring(iDexAptitude).."#cFFCC99(+"..tostring(iDexAptitude_ps)..")")
		else
			OtherPet_StrAptitude:SetText(tostring(iStrAptitude))
			OtherPet_NimbusAptitude:SetText(tostring(iSprAptitude))
			OtherPet_PhysicalStrengthAptitude:SetText(tostring(iConAptitude))
			OtherPet_StabilityAptitude:SetText(tostring(iIntAptitude))
			OtherPet_DexterityAptitude:SetText(tostring(iDexAptitude))		
		end
	end

	strName,strName2 = Pet : Other_GetExp(nIndex);
	OtherPet_Exp : SetText( "Kinh nghi®m:"..strName .."/"..strName2);
--yyËµ£¬²»¿ ¸ñ
	strName = Pet : Other_GetHP(nIndex);
	strName2 = Pet:	Other_GetMaxHP(nIndex);
	OtherPet_Blood : SetText( "Huyªt:"..strName .."/".. strName2);
--	strName = Pet : Other_GetMP(nIndex);
--	strName2 = Pet:	Other_GetMaxMP(nIndex);
--	OtherPet_MP : SetText( strName .." / ".. strName2);
	--local Sum_Attr = 0;--modi:lby20071108

	strName = Pet : Other_GetStr(nIndex);
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_Str : SetText( tonumber(strName)  );
--	Pet_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetInt(nIndex);
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_Nimbus : SetText( tonumber(strName)  );
--	OtherPet_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetDex(nIndex);
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_Dexterity : SetText( tonumber(strName) );
--	OtherPet_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetPF(nIndex);
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_PhysicalStrength : SetText( tonumber(strName) );
--	OtherPet_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetSta(nIndex);
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_Stability : SetText( tonumber(strName) );
--	OtherPet_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetBasic(nIndex);
	OtherPet_GenGu : SetText( "Cån C¯t:"..tonumber(strName) );

	OtherPet_CriticalAttack : SetText( Pet:Other_GetCriticalAttack(nIndex)  );
	OtherPet_CriticalDefence : SetText(Pet:Other_GetCriticalDefence(nIndex))

	--modi:lby20071108 start
	strName = Pet : Other_GetPotential(nIndex);
	strName2 = tonumber(strName);
--	strName2 = strName2 - Sum_Attr;
	OtherPet_Potential : SetText( strName2 );
	--modi:lby20071108 end
--	OtherPet_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetPhysicsAttack(nIndex);
	OtherPet_PhysicsAttack : SetText( strName );

	strName = Pet : Other_GetMagicAttack(nIndex);
	OtherPet_MagicAttack : SetText( strName );

	strName = Pet : Other_GetPhysicsRecovery(nIndex);
	OtherPet_PhysicsRecovery : SetText( strName );

	strName = Pet : Other_GetMagicRecovery (nIndex);
	OtherPet_MagicRecovery : SetText( strName );

	--ÉÁ±ÜÂÊ
	strName = Pet : Other_GetMiss(nIndex);
	OtherPet_Miss : SetText( strName );

	--ÃüÖÐÂÊ
	strName = Pet : Other_GetShootProbability(nIndex);
	OtherPet_ShootProbability : SetText( strName );


	strName = Pet : Other_GetGrowRate(nIndex);
	OtherPet_Growth : SetText("#GkHông biªt")
	local nGrowLevel = Pet : Other_GetPetGrowLevel(nIndex,tonumber(strName));
	local strTbl = {"S½ C¤p","Xu¤t S¡c","Ki®t Xu¤t","Trác Vi®t","Toàn MÛ"};

	if(nGrowLevel >= 0) then
		nGrowLevel = nGrowLevel + 1;	--c???0?????
		local nGrowRate = Pet : Other_GetGrowRate(nIndex);
		if(strTbl[nGrowLevel]) then
			OtherPet_Growth : SetText("#G"..strTbl[nGrowLevel]..nGrowRate)
		end
	end

	strName,strIcon = Pet : Other_GetAttackTrait(nIndex);
	AxTrace(0,0,"strIcon="..strIcon)
	if strIcon ~= "" then
		OtherPetAttack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		OtherPetAttack_Type : SetToolTip(strName)
		OtherPetAttack_Type : Show();
	end

	local SumPetSkill = GetActionNum("petskill");
	local k=1;
	local i=1;
	AxTrace(0,1,"SumPetSkill="..SumPetSkill);

	while i <= PETSKILL_BUTTONS_NUM do
		local theSkillAction = Pet:EnumPetSkill( 1000+nIndex, i-1, "petskill");
		i = i + 1;

		if theSkillAction:GetID() ~= 0 then
			AxTrace(0,1,"pet="..nIndex.." skill position="..i.." id="..theSkillAction:GetID());
			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k+1;
		end


	end

	--zchw
	OtherPet_Refresh_Equip();

	local food = Pet : Other_GetFoodType(nIndex);
	strName = "";
	AxTrace(0,1,"food="..food);
	if(food >= 1000) then
		strName = strName .. "Th¸t";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "Thäo";
		food = food - 100;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 10) then
		strName = strName .. "Sâu";
		food = food - 10;
		if food > 0 then
			strName = strName .. ",";
		end
	end

	if(food >= 1) then
		strName = strName .. "Ngû c¯c";
	end
	OtherPetFood_Type : Show();
	OtherPetFood_Type : SetToolTip( strName );

	OtherPet_Jian     : Show();
		
end

function OtherPetEquip_Equip_Click(num, type)
end

----------------------------------------------------------------------------------
--
-- Ðý×ª äÊÞÄ£ÐÍ£¨Ïò×ó)
--
function OtherPet_Modle_TurnLeft(start)
	--Ïò×óÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		OtherPet_FakeObject:RotateBegin(-0.3);
	--Ïò×óÐý×ª½áÊø
	else
		OtherPet_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--Ðý×ª äÊÞÄ£ÐÍ£¨ÏòÓÒ)
--
function OtherPet_Modle_TurnRight(start)
	--ÏòÓÒÐý×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		OtherPet_FakeObject:RotateBegin(0.3);
	--ÏòÓÒÐý×ª½áÊø
	else
		OtherPet_FakeObject:RotateEnd();
	end
end

function TargetEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);

	OpenEquip(1);
	OtherPet_Close();
	
end

function OtherPet_OnHiden()
	Pet:LuaFnClosePetSoulInfo(1)
end

function OtherPet_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 3) then
		return;
	end

	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = OtherPet_SelfEquip,
								OtherPet_TargetData,
								--OtherPet_Blog,
								OtherPet_Pet,
							};

	while i < 3 do
		if(i == idx) then
			tab[i]:SetText(selColor..PET_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..PET_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

--´ò¿ª×Ô¼ºµÄ×ÊÁÏÒ³Ãæ
function OtherPet_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);

	SystemSetup:OpenPrivatePage("self");
	OtherPet_Close();
end


function OtherPet_Open()
	this:Show();
	Pet : Other_SetSelectedIdx(0)
	OtherPet_List : SetItemSelectByItemID(0);
	
	local isopen5 = T300Func:IsNoDifOpen(5)
	if isopen5 == 1 then
		--OtherPet_TargetWuhun:Disable()
	else
		OtherPet_TargetWuhun:Enable()
	end
end
function OtherPet_Close()
	this:Hide();
	Pet : Other_SetSelectedIdx(0)
end

function OtherPet_Skill_Clicked(nIndex)

end

function OtherPet_ShowPage()

	for i = 1, 9 do
		g_PageButton[i]:Hide()
	end
		
	local nPageNumber = tonumber(Variable:GetVariable("TargetPageNumber"));
	OtherPet_ClearPage()
	
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
		if OtherPet_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)
			g_PageOrder[g_PageCount] = i
		end
	end
end

function OtherPet_CheckPage(idx)
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

function OtherPet_ClearPage()
	Variable:SetVariable("TargetPageNumber", tostring(0), 1)
end

function OtherPet_OnPageClicked(idx)

	Variable:SetVariable("TargetPageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]

	if idx == 1 then--??
		OtherPet_TargetEquip_Down()
	elseif idx == 2 then--??
		OtherPet_TargetData_Down()
	elseif idx == 3 then--??
		OtherPet_ClearPage()
	elseif idx == 4 then--??
		OtherPet_TargetWuhun_Switch()
	elseif idx == 5 then--??
		OtherPet_TargetLingyu_Switch()
	elseif idx == 6 then--??
		OtherPet_ShenBing_Switch()
	elseif idx == 7 then--????
		OtherPet_DWJinJie_Switch()

	elseif idx == 8 then
		OtherPet_OtherDFeng_Switch()
	elseif idx == 9 then
		OtherPet_OtherProfile_Switch()
	end
end
--===============================================
-- ´ò¿ªÍæ¼Ò×°±¸UI
--===============================================
function OtherPet_TargetEquip_Down()
  Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenEquipFrame("other");
end

--===============================================
-- ´ò¿ªÍæ¼Ò×ÊÁÏUI
--===============================================
function OtherPet_TargetData_Down()
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end
--===============================================
-- ´ò¿ªÍæ¼Ò²©¿ÍUI
--===============================================
-- function OtherPet_TargetBlog_Down()
-- 	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);

-- 	local strCharName =  CachedTarget:GetData("NAME");
-- 	local strAccount =  CachedTarget:GetData("ACCOUNTNAME")
-- 	Blog:OpenBlogPage(strAccount,strCharName,false);
-- end

--Îä»ê

function OtherPet_TargetWuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		OtherPet_TargetWuhun : SetCheck(0)
		OtherPet_ClearPage()
		return
	end
	
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenOtherWuhun();
end

function OtherPet_TargetLingyu_Switch()
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherLingYuPage()
end

function OtherPet_ShenBing_Switch()
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherShenBingPage()
end

function OtherPet_DWJinJie_Switch()
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherFeaturesPage()
end

function OtherPet_OtherProfile_Switch()
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		OtherPet_TargetProfile:SetCheck(0)
		OtherPet_ClearPage()
		return
	end
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
end

function OtherPet_Jian_Clicked()
	if(not (Pet:Other_IsPresent(PETNUM)) ) then
		return;
	end
	Pet:PetOpenPetJian(PETNUM,"other");
end

--»ñÈ¡Íæ¼Òµ±Ç°µÈ¼¶×î´óÐ¯´øÊýÁ¿ --add by xindefeng
function GetOtherCurMaxPetCount()
	local mylevel = CachedTarget:GetData("LEVEL") --??????
	if mylevel == nil or type(mylevel) ~= "number" then
		return 2;
	end
	local MaxCount = 0	--????

	--¸ù¾ÝµÈ¼¶»ñÈ¡³£¹æÐ¯´øÉÏÏÞ
	if mylevel < 21 then
		MaxCount = 2	--??????????2
	elseif mylevel < 41 then
		MaxCount = 3
	elseif mylevel < 61 then
		MaxCount = 4
	elseif mylevel < 81 then
		MaxCount = 5
	else
		MaxCount = 6
	end
	
	--Ð¯´øÉÏÏÞÔÙ¼ÓÉÏÊÞÀ¸ÊýÁ¿
	MaxCount = MaxCount + CachedTarget:GetData("PET_EXTRANUM")
	
	if MaxCount > PET_MAX_NUMBER then
		MaxCount = PET_MAX_NUMBER
	end

	return MaxCount
end

--added by dun.liu
function OtherPet_SetStateTooltip( nIndex )

	if (nIndex == nil) then
		return;
	end
	-- µÃµ½×´Ì¬ÊôÐÔ
	local iIceAttack  		= Pet:Other_GetAttackCold( nIndex );
	local iFireAttack 		= Pet:Other_GetAttackFire( nIndex );
	local iThunderAttack	= Pet:Other_GetAttackLight( nIndex );
	local iPoisonAttack		= Pet:Other_GetAttackPoison( nIndex );

	local iIceDefine  		= Pet:Other_GetDefenceCold( nIndex );
	local iFireDefine 		= Pet:Other_GetDefenceFire( nIndex );
	local iThunderDefine	= Pet:Other_GetDefenceLight( nIndex );
	local iPoisonDefine		= Pet:Other_GetDefencePoison( nIndex );

	local iIceResistOther		= Pet:Other_GetResistCold( nIndex );
	local iFireResistOther		= Pet:Other_GetResistFire( nIndex );
	local iThunderResistOther	= Pet:Other_GetResistLight( nIndex );
	local iPoisonResistOther	= Pet:Other_GetResistPoison( nIndex );
	
	------------------------------
	if( iIceAttack == nil ) then
		iIceAttack = 0;
	end
	if( iFireAttack == nil ) then
		iFireAttack = 0;
	end
	if( iThunderAttack == nil ) then
		iThunderAttack = 0;
	end
	if( iPoisonAttack == nil ) then
		iPoisonAttack = 0;
	end
	------------------------------
	if( iIceDefine == nil ) then
		iIceDefine = 0;
	end
	
	if( iFireDefine == nil ) then
		iFireDefine = 0;
	end
	
	if( iPoisonDefine == nil ) then
		iPoisonDefine = 0;
	end
	if( iThunderDefine == nil ) then
		iThunderDefine = 0;
	end
	------------------------------
	if( iIceResistOther == nil ) then
		iIceResistOther = 0;
	end
	if( iFireResistOther == nil ) then
		iFireResistOther = 0;
	end
	if( iThunderResistOther == nil ) then
		iThunderResistOther = 0;
	end
	if( iPoisonResistOther == nil ) then
		iPoisonResistOther = 0;
	end


	OtherPet_IceFastness:SetToolTip("Bång công:"..tostring(iIceAttack).."#rBång Kháng:"..tostring(iIceDefine).."#rGiäm Bång Kháng:"..tostring(iIceResistOther) );
	OtherPet_FireFastness:SetToolTip("Höa công:"..tostring(iFireAttack).."#rHoä Kháng:"..tostring(iFireDefine).."#rGiäm Hoä Kháng:"..tostring(iFireResistOther) );
	OtherPet_ThunderFastness:SetToolTip("Huy«n công:"..tostring(iThunderAttack).."#rHuy«n Kháng:"..tostring(iThunderDefine).."#rGiäm Huy«n Kháng:"..tostring(iThunderResistOther) );
	OtherPet_PoisonFastness:SetToolTip("Ðµc công:"..tostring(iPoisonAttack).."#rÐµc Kháng:"..tostring(iPoisonDefine).."#rGiäm Ðµc Kháng:"..tostring(iPoisonResistOther) );

end

--added by dun.liu
function OtherPet_ClearStateTooltip()
	-- µÃµ½×´Ì¬ÊôÐÔ
	local iIceAttack  		= 0;
	local iFireAttack 		= 0;
	local iThunderAttack	= 0;
	local iPoisonAttack		= 0;

	local iIceDefine  		= 0;
	local iFireDefine 		= 0;
	local iThunderDefine	= 0;
	local iPoisonDefine		= 0;

	local iIceResistOther		= 0;
	local iFireResistOther		= 0;
	local iThunderResistOther	= 0;
	local iPoisonResistOther	= 0;

	OtherPet_IceFastness:SetToolTip("Bång công:"..tostring(iIceAttack).."#rBång Kháng:"..tostring(iIceDefine).."#rGiäm Bång Kháng:"..tostring(iIceResistOther) );
	OtherPet_FireFastness:SetToolTip("Höa công:"..tostring(iFireAttack).."#rHoä Kháng:"..tostring(iFireDefine).."#rGiäm Hoä Kháng:"..tostring(iFireResistOther) );
	OtherPet_ThunderFastness:SetToolTip("Huy«n công:"..tostring(iThunderAttack).."#rHuy«n Kháng:"..tostring(iThunderDefine).."#rGiäm Huy«n Kháng:"..tostring(iThunderResistOther) );
	OtherPet_PoisonFastness:SetToolTip("Ðµc công:"..tostring(iPoisonAttack).."#rÐµc Kháng:"..tostring(iPoisonDefine).."#rGiäm Ðµc Kháng:"..tostring(iPoisonResistOther) );

end

function OtherPet_Frame_On_ResetPos()
  OtherPet_Frame:SetProperty("UnifiedPosition", g_OtherPet_Frame_UnifiedPosition);
end

function OtherPet_PetSoul_ShowInfo()
	if Pet:LuaFnIsOtherPetEquipPetSoul(PET_CURRENT_SELECT) ~= 1 then
		return
	end
	
	Pet:LuaFnShowPetSoulInfo(1, PET_CURRENT_SELECT)
end

function OtherPet_PetSoul2_MouseEnter()
	
	if Pet:LuaFnIsOtherPetEquipPetSoul(PET_CURRENT_SELECT) ~= 1 then
		return
	end
	
	local left, right, top, bottom = OtherPet_PetSoul2:GetPixelRect()
	
	Pet:LuaFnShowOtherPetSoulPossSkillInfo(PET_CURRENT_SELECT, 1, left, top, right, bottom)

end

function OtherPet_PetSoul2_MouseLeave()
	
	local left, right, top, bottom = OtherPet_PetSoul2:GetPixelRect()
	Pet:LuaFnShowOtherPetSoulPossSkillInfo(PET_CURRENT_SELECT, 0, left, top, right, bottom)
	
end

function OtherPet_OtherDFeng_Switch()
	--if ZBS:IsZBSFinalDFengBanFlag() == 1 then
	--	PushDebugMessage("#{WCBZ_250812_1}")
	--    return 0
	--end
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 85 then
		PushDebugMessage("#{DFJC_250709_83}")
		OtherPet_TargetPeak:SetCheck(0)
		OtherPet_ClearPage()
		return 0
	end
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1)
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
