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
local ShowColor = "#H"
local PETSKILL_BUTTONS_NUM = 12
local PETSKILL_BUTTONS = {}
local PETATTR = {}
local PET_POTREMAIN = 0
local PET_ATTR_COUNT = 5
local PET_MAX_NUMBER = 6 + 4
local PETNUM = 0
local PET_REST = 1
local PET_FIGHT= 0
local PET_CURRENT_SELECT = 0
local PET_AITYPE = {}
local Changed_Name_Flag = 0
--			// ´´½¨ äÊÞ(¼´·Å³ö) 0
--			// Ê »Ø äÊÞ					1
--			// Ïú»Ù äÊÞ(¼´·ÅÉú)	2
--			// ²¶×½ äÊÞ					3
--			¿ÉÒÔÔÚ±»·Å³öºó£¬Í¨¹ýÏûÏ¢£¬¸Ä±ä¸Ã äÊÞÔÚlistboxÖÐµÄÃû×ÖµÄÑ É«¡£
local PET_TAB_TEXT = {}
local PET_ORIGINAL_NAME = ""

local g_Pet_Head 		--?
local g_Pet_Claw		--?
local g_Pet_Body		--??
local g_Pet_Neck		--??
local g_Pet_Charm		--??

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_Pet_Frame_UnifiedXPosition
local g_Pet_Frame_UnifiedYPosition

-- Ìá¹©³¤°´×ó¼ü½øÐÐÁ¬¼ÓµÄ¹¦ÄÜ	-- HenryFour@2010-04-16
local g_AutoClick_BtnFlag = -1			-- ????????????????
local g_AutoClickTimer_Step = 144		-- ????(??)???? Click ??
local g_AutoClick_FunList = {}			-- ????? Timer ?????????????
local g_AutoClick_Going = -1			-- ????????????(???LButton???X?Timer????, ????? g_AutoClickTimer_Step * X ??????????, ?????????????????????)

-------------------------------------------
--Í³Ò»»¯ÏÂÒ³Ç©ÏÔÊ¾Òþ²Ø Ä¿Ç°¹Ì¶¨Ë³Ðò ÐÂÔö¸ÄÐòºÅ Ã¿¸öÒ³Ç©¶¼ÐèÒªÌí¼Ó
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

local g_PetEquipPointNum = 6
--!!!reloadscript =Pet

local PET_TYPE = {
[1] = {image = "set:CommonFrame2 image:ZhenShouHeart_Hui", tooltip1 = "#{FZDJ_120717_1}", tooltip2 = "#{FZDJ_120717_2}", tooltip3 = "#{FZDJ_120717_3}", tooltip4 = "#{FZDJ_120717_4}", tooltip5 = "#{FZDJ_120717_5}" },
[2] = {image = "set:CommonFrame2 image:ZhenShouHeart_Hong", tooltip1 = "#{FZDJ_120717_6}", tooltip2 = "#{FZDJ_120717_7}", tooltip3 = "#{FZDJ_120717_8}" } };

function Pet_PreLoad()
	this:RegisterEvent("TOGLE_PET_PAGE")
	this:RegisterEvent("UPDATE_PET_PAGE")
	this:RegisterEvent("DELETE_PET")
	this:RegisterEvent("ACCELERATE_KEYSEND")
	this:RegisterEvent("RESET_ALLUI")
	this:RegisterEvent("UPDATE_PET_EXTRANUM")
	this:RegisterEvent("UNIT_LEVEL")
	this:RegisterEvent("PET_EQUIP_ATTR_CHANGE")

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	this:RegisterEvent("UPDATE_EXTERIOR_TIP")

end

function Pet_OnLoad()

	PETSKILL_BUTTONS[1] = Pet_Skill1
	PETSKILL_BUTTONS[2] = Pet_Skill2
	PETSKILL_BUTTONS[3] = Pet_Skill3
	PETSKILL_BUTTONS[4] = Pet_Skill4
	PETSKILL_BUTTONS[5] = Pet_Skill5
	PETSKILL_BUTTONS[6] = Pet_Skill6
	PETSKILL_BUTTONS[7] = Pet_Skill7
	PETSKILL_BUTTONS[8] = Pet_Skill8
	PETSKILL_BUTTONS[9] = Pet_Skill9
	PETSKILL_BUTTONS[10] = Pet_Skill10
	PETSKILL_BUTTONS[11] = Pet_Skill11
	PETSKILL_BUTTONS[12] = Pet_Skill12
	
	PET_AITYPE[0] = "Nhát gan"
	PET_AITYPE[1] = "C¦n th§n"
	PET_AITYPE[2] = "Trung thñc"
	PET_AITYPE[3] = "Nhanh nh©n"
	PET_AITYPE[4] = "Dûng mãnh"
	
	g_Pet_Head = PetEquip_1
	g_Pet_Claw = PetEquip_2	
	g_Pet_Body = PetEquip_3
	g_Pet_Neck = PetEquip_4		
	g_Pet_Charm = PetEquip_5

	Pet_chenghao:SetText("Danh hi®u")

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_Pet_Frame_UnifiedXPosition = Pet_Frame:GetProperty("UnifiedXPosition")
	g_Pet_Frame_UnifiedYPosition = Pet_Frame:GetProperty("UnifiedYPosition")

	-- ³õÊ¼»¯×Ô¶¯¼Óµã¹¦ÄÜÏà¹Ø±äÁ¿
	g_AutoClick_FunList[1] = Pet_Str_Add_Clicked
	g_AutoClick_FunList[2] = Pet_Int_Add_Clicked
	g_AutoClick_FunList[3] = Pet_PF_Add_Clicked
	g_AutoClick_FunList[4] = Pet_Sta_Add_Clicked
	g_AutoClick_FunList[5] = Pet_Dex_Add_Clicked
	g_AutoClick_FunList[6] = Pet_Str_Sub_Clicked
	g_AutoClick_FunList[7] = Pet_Int_Sub_Clicked
	g_AutoClick_FunList[8] = Pet_PF_Sub_Clicked
	g_AutoClick_FunList[9] = Pet_Sta_Sub_Clicked
	g_AutoClick_FunList[10] = Pet_Dex_Sub_Clicked

	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1

	g_PageButton[1] = Pet_SelfEquip
	g_PageButton[2] = Pet_SelfData
	g_PageButton[3] = Pet_Pet
	g_PageButton[4] = Pet_Wuhun
	g_PageButton[5] = Pet_Xiulian
	g_PageButton[6] = Pet_Talent
	g_PageButton[7] = Pet_Lingyu
	g_PageButton[8] = Pet_Weapon2
	g_PageButton[9] = Pet_DWJinJie
	g_PageButton[10] = Pet_Peak
	g_PageButton[11] = Pet_Profile
	g_PageButton[12] = Pet_OtherInfo

	g_PageMask[1] = Pet_SelfEquip_Mask
	g_PageMask[2] = Pet_SelfData_Mask
	g_PageMask[3] = Pet_Pet_Mask
	g_PageMask[4] = Pet_Wuhun_Mask
	g_PageMask[5] = Pet_Xiulian_Mask
	g_PageMask[6] = Pet_Talent_Mask
	g_PageMask[7] = Pet_Lingyu_Mask
	g_PageMask[8] = Pet_Weapon2_Mask
	g_PageMask[9] = Pet_DWJinJie_Mask
	g_PageMask[10] = Pet_Peak_Mask
	g_PageMask[11] = Pet_Profile_Mask
	g_PageMask[12] = Pet_OtherInfo_Mask
	
	g_PageTip[1] = Pet_SelfEquip_tips
	g_PageTip[2] = Pet_SelfData_tips
	g_PageTip[3] = Pet_Pet_tips
	g_PageTip[4] = Pet_Wuhun_tips
	g_PageTip[5] = Pet_Xiulian_tips
	g_PageTip[6] = Pet_Talent_tips
	g_PageTip[7] = Pet_Lingyu_tips
	g_PageTip[8] = Pet_Weapon2_tips
	g_PageTip[9] = Pet_DWJinJie_tips
	g_PageTip[10] = Pet_Peak_tips
	g_PageTip[11] = Pet_Profile_tips
	g_PageTip[12] = Pet_OtherInfo_tips
end

function Pet_OnEvent(event)
	-- ÏÔÊ¾tooltips zchw
	Pet_SetStateTooltip()
	
	if event == "TOGLE_PET_PAGE" then
		local arg0_cache = nil
		if arg0 ~= nil and tonumber(arg0)~=nil and tonumber(arg0) < PET_MAX_NUMBER and tonumber(arg0) >= 0 then			
			arg0_cache = tonumber(arg0)
		end
		
		if this:IsVisible() then
			Pet_Close()
			return
		else
			Pet_Open()
		end
		for i=1,PET_ATTR_COUNT do
			PETATTR[i] = 0
		end
		
		if arg0_cache ~= nil then			
			PET_CURRENT_SELECT = arg0_cache
		end
		
		Pet_OnShown()
		Pet_ShowPage()
		Pet_UpdateRedPoint()
		return
	elseif event == "UPDATE_PET_PAGE" then
		if this:IsVisible() then
			Pet_Update()
		else
			Pet_Update_NotVisible()
		end
		return
	elseif event == "ACCELERATE_KEYSEND" then
		Pet_HandleAccKey(arg0)
	elseif event == "DELETE_PET" then
		if this:IsVisible() then
			for i=1,PET_ATTR_COUNT do
				PETATTR[i] = 0
			end
			Pet_Update()
		else
			Pet_Update_NotVisible()
		end
	elseif event == "RESET_ALLUI" then
		PET_CURRENT_SELECT = 0
		Pet:SetSelectPetIdx(0)
	elseif event == "UPDATE_PET_EXTRANUM" or event == "UNIT_LEVEL" then
		local nPetCount = Pet:GetPet_Count()
		local nMaxPetCount = Pet_GetMyCurMaxPetCount()
		Pet_List_Text:SetText("Trân Thú Li®t Bi¬u"..nPetCount.."/"..nMaxPetCount)
	
	-- Tooltips ¸üÐÂ zchw	
	elseif event == "PET_EQUIP_ATTR_CHANGE" then
		Pet_SetStateTooltip()

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ	
		Pet_Frame_On_ResetPos()
	end

	if event == "UPDATE_EXTERIOR_TIP" and this:IsVisible() then
		Pet_UpdateRedPoint()
	end

end

function Pet_HandleAccKey(op)
	if op == "acc_pet" then
		if this:IsVisible() then
			Pet_Close()
			return
		end

		--Ä£ÄâÊ µ½ÁËÒ»¸ö´ò¿ª äÊÞ½çÃæµÄÊÂ¼þ¡£
		arg0 = "-1"
		Pet_OnEvent("TOGLE_PET_PAGE")
	end
end

function Pet_OnShown()

	local selfUnionPos = Variable:GetVariable("SelfUnionPos")
	if selfUnionPos ~= nil then
		Pet_Frame:SetProperty("UnifiedPosition", selfUnionPos)
	end

	Pet_SelfEquip:SetCheck(0)
	Pet_SelfData:SetCheck(0)
	Pet_Pet:SetCheck(1)
	Pet_Xiulian:SetCheck(0)
	Pet_OtherInfo:SetCheck(0)

	Pet_Accept:Disable()
	Pet_Cancel:Disable()
	Pet_Amend:Disable()
	Pet_Free:Disable()
	Pet_LockPet:Disable()
	Pet_Domesticate:Disable()
	Pet_Feed:Disable()
	Pet_Heti:Disable()
	Pet_Fenli:Disable()
	Pet_Rest:Disable()
	Pet_Campaign:Disable()
	Pet_Str_Addition:Disable()
	Pet_Int_Addition:Disable()
	Pet_Dex_Addition:Disable()
	Pet_PF_Addition:Disable()
	Pet_Sta_Addition:Disable()
	Pet_Str_Subtraction:Disable()
	Pet_Int_Subtraction:Disable()
	Pet_Dex_Subtraction:Disable()
	Pet_PF_Subtraction:Disable()
	Pet_Sta_Subtraction:Disable()
	Pet_Page_Clear()	
	Pet_Update()
end

function Pet_Page_Clear()
	Pet_FakeObject:RotateEnd()
	Pet_FakeObject:RotateEnd()
	Pet_Accept:Disable()
	Pet_Cancel:Disable()
	Pet_Amend:Disable()
	Pet_Rest:Disable()
	Pet_Free:Disable()
	Pet_LockPet:Disable()
	Pet_Domesticate:Disable()
	Pet_Feed:Disable()
	Pet_Heti:Disable()
	Pet_Fenli:Disable()
	Pet_Campaign:Disable()
	Pet_Str_Addition:Disable()
	Pet_Int_Addition:Disable()
	Pet_Dex_Addition:Disable()
	Pet_PF_Addition:Disable()
	Pet_Sta_Addition:Disable()
	Pet_Str_Subtraction:Disable()
	Pet_Int_Subtraction:Disable()
	Pet_Dex_Subtraction:Disable()
	Pet_PF_Subtraction:Disable()
	Pet_Sta_Subtraction:Disable()
	
	Pet_PetName:SetText("")
	Pet_PetName:Disable()
	
	Pet_Type:SetText("")
	Pet_Type:SetToolTip("")

	Pet_PageHeader:SetText("#gFF0FA0Trân Thú")
	Pet_ConsortID:SetText("")
	Pet_PetID:SetText("")
	Pet_Sex:SetText("")
	Pet_Life:SetText("")
	Pet_Happy:SetText("")
	Pet_Level:SetText("")
	Pet_StrAptitude:SetText("")
	Pet_PhysicalStrengthAptitude:SetText("")
	Pet_DexterityAptitude:SetText("")
	Pet_NimbusAptitude:SetText("")
	Pet_StabilityAptitude:SetText("")
	Pet_Exp:SetText("")
	Pet_Blood:SetText("")
	Pet_Str:SetText("")
	Pet_Nimbus:SetText("")
	Pet_Dexterity:SetText("")
	Pet_PhysicalStrength:SetText("")
	Pet_Stability:SetText("")
	Pet_GenGu:SetText("")
	Pet_Potential:SetText("")
	Pet_PhysicsAttack:SetText("")
	Pet_MagicAttack:SetText("")
	Pet_PhysicsRecovery:SetText("")
	Pet_MagicRecovery:SetText("")
	Pet_Miss:SetText("")
	Pet_WuXing:SetText("")
	Pet_ShootProbability:SetText("")
	Pet_CriticalAttack:SetText("")
	Pet_CriticalDefence:SetText("")
	Pet_Growth : SetText("")
	Pet_Lingxing : SetText("")
	Pet_Lingxing_Info:SetText("")

	Pet_Growth1 : SetText("")
	Pet_GenGu	: SetToolTip("")
	Pet_WuXing : SetToolTip("")
	Pet_Growth : SetToolTip("")
	Pet_Peach : Hide()
	Pet_FakeObject:SetFakeObject("")
	PetAttack_Type:Hide()
	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1)
	end
	
	PetFood_Type:Hide()
	Pet_lock:Hide()
	Pet_Model_Protect_Text:SetText("")
	PET_POTREMAIN = 0
	Pet_Refresh_ADDSUB_Button()
	Pet_NeedLevel:SetText("")
	Pet_Jian:Hide()

	Pet_ChangeSkin:Hide()
	Pet_SkinMark:Hide()
	
	local nPetCount = Pet:GetPet_Count()
	local nMaxPetCount = Pet_GetMyCurMaxPetCount()
	Pet_List_Text:SetText("Trân Thú Li®t Bi¬u"..nPetCount.."/"..nMaxPetCount)
	
	Pet_PetSoul_Equip_Check:Disable()
	Pet_PetSoul_Equip:SetActionItem(-1)
	Pet_PetSoul1:SetActionItem(-1)
	Pet_PetSoul2:SetProperty( "BackImage", "" )
	Pet_PetSoul_Equip_Mask:Hide()
	Pet_PetSoul_Equip_Mask2:Hide()
end

function Pet_ListBox_Selected()
	PETNUM = Pet_List:GetFirstSelectItem()
	local nPetCount = Pet:GetPet_Count()

	if PETNUM == PET_CURRENT_SELECT then
		return
	end

	if PETNUM < 0 and nPetCount > 0 then
		PETNUM = PET_CURRENT_SELECT
		return
	end

	for i=1,PET_ATTR_COUNT do
		PETATTR[i] = 0
	end

	Pet_Page_Clear()
	Changed_Name_Flag = 0
	PET_CURRENT_SELECT = PETNUM

	Pet_FakeObject:SetFakeObject("")
	Pet:SetModel(PETNUM)
	Pet_FakeObject:SetFakeObject("My_Pet")

	Pet_Show_PetInfo(PETNUM)

	Pet:NotifySelChange(PETNUM)

	local tcount = Pet:GetTitleNum(PET_CURRENT_SELECT)
	if tcount > 0 then
		Pet_chenghao:Enable()
	else
		Pet_chenghao:Disable()
	end

	Pet_SetStateTooltip()
	Pet_Refresh_Equip()
end

function Pet_ListBox_RClicked()
	local clkNum = Pet_List:GetClickItem()
	if clkNum >= 0 then
		Pet:CheckRClick(clkNum)
	end
end

function Pet_Update_NotVisible()
	local nPetCount = Pet:GetPet_Count()
	if nPetCount < 1 then
		PET_CURRENT_SELECT = -1
		Pet:SetSelectPetIdx(-1)
		return
	end
	local bSelect = 0
	local firSel = -1
	for	i=1, PET_MAX_NUMBER do
		if Pet:IsPresent(i-1) then
			if firSel == -1 then
				firSel = i - 1
			end
			if i - 1 == PET_CURRENT_SELECT then
				bSelect = 1
			end
		end
	end
	--ÓÐÑ¡ÖÐ¶ÔÏóµÄ£¬²Å½øÐÐÑ¡ÖÐ²Ù×÷¡£
	if bSelect == 1 then
		--do nothing
	else
		PET_CURRENT_SELECT = firSel
		Pet:SetSelectPetIdx(firSel)
	end
end

function Pet_Update()
	Pet_chenghao:Disable()
	Pet_SelfEquip:SetCheck(0)
	Pet_SelfData:SetCheck(0)
	Pet_Pet:SetCheck(1)
	Pet_OtherInfo:SetCheck(0)
	local nPetCount = Pet:GetPet_Count()
	local szPetName

	Pet_Page_Clear()
	Pet_List:ClearListBox()
	if nPetCount < 1 then
		PET_CURRENT_SELECT = -1
		Pet:SetSelectPetIdx(-1)
		OneKeyUnEquip:Disable()
		return
	end

	local bSelect = 0
	local firSel = -1
	for	i=1, PET_MAX_NUMBER do
		if Pet:IsPresent(i-1) then
			if firSel == -1 then
				firSel = i - 1
			end
			szPetName = Pet:GetPetList_Appoint(i - 1)
			if Pet:GetIsFighting(i - 1) then
				Pet_List:AddItem(szPetName, i - 1, "FF0A9605")
			elseif Pet:GetIsPossession(i -1 ) then
				Pet_List:AddItem(szPetName, i - 1, "FF996699");
			else
				Pet_List:AddItem(szPetName, i - 1)
			end
			if i - 1 == PET_CURRENT_SELECT then
				bSelect = 1
			end
			-- âÀï±ØÐëÓÐ âÃ´2¾ä£¬Òª²»»á³ö´í¡£
			Pet_DisableAddButton()
			Pet_DisableSubButton()
		end
	end
	local tcount = 0
	--ÓÐÑ¡ÖÐ¶ÔÏóµÄ£¬²Å½øÐÐÑ¡ÖÐ²Ù×÷¡£
	if bSelect == 1 then
		Pet_List:SetItemSelectByItemID(PET_CURRENT_SELECT)
		Pet_FakeObject:SetFakeObject("")
		Pet:SetModel(PET_CURRENT_SELECT)
		Pet_FakeObject:SetFakeObject("My_Pet")
		Pet_Show_PetInfo(PET_CURRENT_SELECT)
		tcount = Pet:GetTitleNum(PET_CURRENT_SELECT)
		if tcount > 0 then
			Pet_chenghao:Enable()
		end
	else
		PET_CURRENT_SELECT = firSel
		if firSel == -1 then
			Pet:SetSelectPetIdx(-1)
			OneKeyUnEquip:Disable()
			return
		end
		Pet_List:SetItemSelectByItemID(PET_CURRENT_SELECT)
		Pet_FakeObject:SetFakeObject("")
		Pet:SetModel(PET_CURRENT_SELECT)
		Pet_FakeObject:SetFakeObject("My_Pet")
		Pet_Show_PetInfo(PET_CURRENT_SELECT)
		tcount = Pet:GetTitleNum(PET_CURRENT_SELECT)
		if tcount > 0 then
			Pet_chenghao:Enable()
		end
	end
	
	if PET_CURRENT_SELECT > PET_MAX_NUMBER then
		PET_CURRENT_SELECT = PET_MAX_NUMBER
	end
	
	Pet_PetName:SetProperty("DefaultEditBox", "False")
	local strNeedLevel
	local strNeedLevelColor
	local nTakeLevel = Pet:GetTakeLevel(PET_CURRENT_SELECT)
	
	if nTakeLevel > Player:GetData("LEVEL") then
		strNeedLevelColor="#cFF0000"
	else
		strNeedLevelColor="#c00FF00"
	end
	strNeedLevel = strNeedLevelColor..tostring(nTakeLevel).."C¤p#W Mang theo"
	Pet_NeedLevel:SetText(strNeedLevel)
	
end

function PetEquip_Equip_Click(num, type)
	if num == 1 then
		if type == 1 then
			g_Pet_Head:DoAction()
		elseif type == 0 then
			g_Pet_Head:DoSubAction()
		end
	elseif num == 2 then
		if type == 1 then
			g_Pet_Claw:DoAction()
		elseif type == 0 then
			g_Pet_Claw:DoSubAction()
		end
	elseif num == 3 then
		if type == 1 then
			g_Pet_Body:DoAction()
		elseif type == 0 then
			g_Pet_Body:DoSubAction()
		end
	elseif num == 4 then
		if type == 1 then
			g_Pet_Neck:DoAction()
		elseif type == 0 then
			g_Pet_Neck:DoSubAction()
		end
	elseif num == 5 then
		if type == 1 then
			g_Pet_Charm:DoAction()
		elseif type == 0 then
			g_Pet_Charm:DoSubAction()
		end
	end
end

function Pet_Refresh_Equip()

	g_Pet_Head:SetActionItem(-1)
	g_Pet_Claw:SetActionItem(-1)
	g_Pet_Body:SetActionItem(-1)
	g_Pet_Neck:SetActionItem(-1)
	g_Pet_Charm:SetActionItem(-1)	
	
	local ActionClaw = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT, "my_pet_equip")
	local ActionHead = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 1, "my_pet_equip")
	local ActionBody = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 2, "my_pet_equip")
	local ActionNeck = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 3, "my_pet_equip")
	local ActionCharm = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 4, "my_pet_equip")
	
	
	g_Pet_Head:SetActionItem(ActionHead:GetID())
	g_Pet_Claw:SetActionItem(ActionClaw:GetID())
	g_Pet_Body:SetActionItem(ActionBody:GetID())
	g_Pet_Neck:SetActionItem(ActionNeck:GetID())
	g_Pet_Charm:SetActionItem(ActionCharm:GetID())
	
	Pet_PetSoul_Equip:SetActionItem(-1)
	Pet_PetSoul1:SetActionItem(-1)
	Pet_PetSoul2:SetProperty( "BackImage", "" )
	Pet_PetSoul_Equip_Check:Disable()
	Pet_PetSoul_Equip_Mask:Hide()
	local isopen = T300Func:IsNoDifOpen(8)

	if Pet:LuaFnIsPetEquipPetSoul(PET_CURRENT_SELECT) == 1 then
		local ActionSoul = EnumAction(g_PetEquipPointNum*PET_CURRENT_SELECT + 5, "my_pet_equip")
		Pet_PetSoul_Equip:SetActionItem(ActionSoul:GetID())
	
		local skillAction = Pet:LuaFnEnumPetSoulSkillActionOnPet(PET_CURRENT_SELECT)
		if skillAction ~= nil then
			Pet_PetSoul1:SetActionItem(skillAction:GetID())
		end
		
		Pet_PetSoul_Equip_Check:Enable()
		if isopen == 1 then
			Pet_PetSoul_Equip_Check:Disable()
		end
		
		local _, szPetPossSkillIcon, _, _ = Pet:LuaFnGetPetSoulPossSkillInfo(PET_CURRENT_SELECT, 0)
		if szPetPossSkillIcon ~= "" then
			Pet_PetSoul2:SetProperty( "BackImage", szPetPossSkillIcon )
		end
	end
	
	if isopen ~= nil and isopen == 1 then
		Pet_PetSoul_Equip_Mask2:Show()
		Pet_PetSoul_Equip_Mask2:SetToolTip("#{HSSC_191009_135}")
	else
		Pet_PetSoul_Equip_Mask2:Hide()
	end

end

function Pet_SetStateTooltip()
	
	-- µÃµ½×´Ì¬ÊôÐÔ
	local iIceAttack  		= Pet:GetData("ATTACKCOLD")
	local iFireAttack 		= Pet:GetData("ATTACKFIRE")
	local iThunderAttack	= Pet:GetData("ATTACKLIGHT")
	local iPoisonAttack		= Pet:GetData("ATTACKPOISON")
		
	local iIceDefine  		= Pet:GetData("DEFENCECOLD")
	local iFireDefine 		= Pet:GetData("DEFENCEFIRE")
	local iThunderDefine	= Pet:GetData("DEFENCELIGHT")
	local iPoisonDefine		= Pet:GetData("DEFENCEPOISON")
	
	local iIceResistOther	= Pet:GetData("RESISTOTHERCOLD")
	local iFireResistOther	= Pet:GetData("RESISTOTHERFIRE")
	local iThunderResistOther	= Pet:GetData("RESISTOTHERLIGHT")
	local iPoisonResistOther= Pet:GetData("RESISTOTHERPOISON")
	
	Pet_IceFastness:SetToolTip("Bång công:"..tostring(iIceAttack).."#rBång Kháng:"..tostring(iIceDefine).."#rGiäm Bång Kháng:"..tostring(iIceResistOther))
	Pet_FireFastness:SetToolTip("Höa công:"..tostring(iFireAttack).."#rHoä Kháng:"..tostring(iFireDefine).."#rGiäm Hoä Kháng:"..tostring(iFireResistOther))
	Pet_ThunderFastness:SetToolTip("Huy«n công:"..tostring(iThunderAttack).."#rHuy«n Kháng:"..tostring(iThunderDefine).."#rGiäm Huy«n Kháng:"..tostring(iThunderResistOther))
	Pet_PoisonFastness:SetToolTip("Ðµc công:"..tostring(iPoisonAttack).."#rÐµc Kháng:"..tostring(iPoisonDefine).."#rGiäm Ðµc Kháng:"..tostring(iPoisonResistOther))
		
end

function Pet_Show_PetInfo(nIndex)

	if not Pet:IsPresent(nIndex) then
		return
	end
	
	Pet:SetSelectPetIdx(nIndex)
	Pet_Accept:Disable()
	Pet_Cancel:Disable()
	Pet_Amend:Enable()
	Pet_Rest:Enable()
	Pet_Free:Enable()
	Pet_LockPet:Enable()
	Pet_Domesticate:Enable()
	Pet_Feed:Enable()
	Pet_Heti:Enable()
	local isopen = T300Func:IsNoDifOpen(8)
	if isopen ~= nil and isopen == 1 then
		Pet_Heti:Disable()
		Pet_Heti:SetToolTip("#{HSSC_191009_134}")
	else
		Pet_Heti:SetToolTip("")
	end
	
	Pet_Fenli:Enable()
	Pet_Campaign:Enable()
	
	Pet_Str_Addition:Disable()
	Pet_Int_Addition:Disable()
	Pet_Dex_Addition:Disable()
	Pet_PF_Addition:Disable()
	Pet_Sta_Addition:Disable()
	Pet_Str_Subtraction:Disable()
	Pet_Int_Subtraction:Disable()
	Pet_Dex_Subtraction:Disable()
	Pet_PF_Subtraction:Disable()
	Pet_Sta_Subtraction:Disable()
	
	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1)
	end
 	
 	local aiType = Pet:GetAIType(nIndex) 	
	if aiType >= 0 and aiType <= 4 then
		Pet_Type:SetText("#gFF8E92"..PET_AITYPE[aiType])
		Pet_Type:SetToolTip("#{INTERFACE_XML_857}")
	end

 	local strName, strName2 = Pet:GetName(nIndex)
	local nEra, strTypeName = Pet:GetPetTypeName(nIndex)
 	if 1 == nEra then
 	    strName2 = "Ð¶i thÑ 2"..strTypeName
 	end
 	
	Pet_PageHeader:SetText("#gFF0FA0"..strName2)
 
 	if PlayerPackage:IsPetLock(nIndex) == 1 then
	 	Pet_lock:Show()	 	
	 	local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(nIndex)
	 	if nUnlockElapsedTime == 0 then
	 		Pet_lock:SetProperty("Image","set:UIIcons image:Icon_Lock")
	 		Pet_lock:SetToolTip("Ðã khóa")
	 	else
	 		local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime)
	 		Pet_lock:SetProperty("Image","set:CommonFrame6 image:NewLock")
	 		Pet_lock:SetToolTip(strLeftTime)
	 	end
	else
	 	Pet_lock:Hide()
 end
 
	if PlayerPackage:IsGoodsProtect_Pet(nIndex) == 1 then
		Pet_Model_Protect_Text:Show()
		Pet_Model_Protect_Text:SetText("#{GDWPBH_090507_4}")
	else
		Pet_Model_Protect_Text:Hide()
  end
 
	local Changed_Name = Pet_PetName:GetText()
	if Changed_Name ~= strName and Changed_Name ~= "" then
		Pet_PetName:Enable()
	else
		Pet_PetName:Enable()
		Pet_PetName:SetText(strName)
		Pet_PetName : SetProperty("ClearOffset" ,"True" )
	end
	
	local _, strGUID, iSex = Pet:GetID(nIndex)
	Pet_PetID:SetText("Trân Thú ID:"..strGUID)

	local strLoverGUID = Pet:GetConsort(nIndex)
	if strLoverGUID == "00000000" then
		Pet_ConsortID:SetText("Ph¯i ngçu ID:")
	else
		Pet_ConsortID:SetText("Ph¯i ngçu ID:"..strLoverGUID)
	end
		
	if iSex == 1 then 
		Pet_Sex:SetText("Gi¯ng ðñc")
	else
		Pet_Sex:SetText("Gi¯ng cái")
	end
	
	local nGeneration  = Pet : GetGeneration(nIndex)
	if nGeneration ~= nil and nGeneration >= 100 then
		Pet_Sex:SetText("#{RXZS_XML_35}")
	end
	---------------------------------------------------------------------------------------------------
	--¸Ã äÊÞµÄ·±Ö³Çé¿ö
	Pet_Peach:Show();
	local nPetType = Pet:GetPetType(nIndex);
	local nColor = 1;
	if (nGeneration == 1) then
		--1:¶þ´ú
		nColor = 1;
		Pet_Peach:SetToolTip(PET_TYPE[1].tooltip4);
	elseif (nGeneration >= 100) then
		-->=100:»Ã»¯
		nColor = 1;
		Pet_Peach:SetToolTip(PET_TYPE[1].tooltip1);
	else
		if (nPetType == 0) then
			--0:±¦±¦ 2023 ÐÞ¸Ä ÓÉ¼ÇÂ¼ ÉÏ´Î·±Ö³µÈ¼¶ ¸Ä³É¼ÇÂ¼ ÒÑ¾­·±Ö³´ÎÊý
			--ÓÉÓÚÒª¼æÈÝÖ®Ç°µÄÊý¾Ý£¬ÔÙ¸üÐÂºóÃ»·±Ö³Ö®Ç°  â¸öÊýÖµÈÔÈ»¼ÇÂ¼ÉÏ´Î·±Ö³µÈ¼¶£¬·±Ö³Ö®ºó¼ÇÂ¼ÒÑ¾­·±Ö³´ÎÊý
			local nLevel = Pet:GetLevel(nIndex);
			local nLastProcreateLevel = Pet:GetLastProcreateLevel(nIndex);
			if nLastProcreateLevel < 0 then
				nLastProcreateLevel = 0
			end
			local nTarget = {30, 50, 70, 90, 110}
			local nTimes = 0
			local nCounts = 0
			local nRemainCounts = 0
			if nLastProcreateLevel >= 30 then --??????
				if nLastProcreateLevel >= nTarget[5] then
					nRemainCounts = 0
				else
					for i = 1, table.getn(nTarget) do
						if nLastProcreateLevel < nTarget[i] then
							nTimes = i - 1
							break
						end
					end
					for i = 1, table.getn(nTarget) do
						if nLevel < nTarget[i] then
							nCounts = i - 1
							break
						end
					end
					if nLevel >= nTarget[5] then
						nCounts = 5
					end

					nRemainCounts = nCounts - nTimes
				end
			else
				if nLevel >= nTarget[5] then
					nCounts = 5
				else
					for i = 1, table.getn(nTarget) do
						if nLevel < nTarget[i] then
							nCounts = i - 1
							break
						end
					end
				end
				nRemainCounts = nCounts - nLastProcreateLevel
			end

			if nRemainCounts > 0 or nLevel < nTarget[5] then
				nColor = 2
			else
				nColor = 1
			end
			Pet_Peach:SetToolTip(ScriptGlobal_Format("#{ZSFZYH_220606_01}", nRemainCounts));

		elseif (nPetType == 1) then
			--1:±äÒì
			nColor = 1;
			Pet_Peach:SetToolTip(PET_TYPE[1].tooltip3);
		elseif (nPetType == 2) then
			--2:³ÉÄê
			nColor = 1;
			Pet_Peach:SetToolTip(PET_TYPE[1].tooltip2);
		end
	end
	Pet_Peach:SetProperty("Image", PET_TYPE[nColor].image);
	------------------------------------------------------------------------------------------------------
	local strNeedLevelColor = ""
	local nTakeLevel = Pet:GetTakeLevel(nIndex)	
	if nTakeLevel > Player:GetData("LEVEL") then
		strNeedLevelColor = "#cFF0000"
	else
		strNeedLevelColor = "#c00FF00"
	end
	
	local strNeedLevel = strNeedLevelColor..tostring(nTakeLevel).."C¤p#W Mang theo"
	Pet_NeedLevel:SetText(strNeedLevel)

	local iLife = Pet:GetNaturalLife(nIndex)
	Pet_Life:SetText("S¯ng lâu:"..tostring(iLife))
	
	local iLevel = Pet:GetLevel(nIndex)
	Pet_Level:SetText("C¤p b§c:"..tostring(iLevel))

	local iHappy = Pet:GetHappy(nIndex)
	Pet_Happy:SetText("Khoái LÕc:"..tostring(iHappy))

	local iLingXing = Pet:GetLixing(nIndex)
	Pet_Lingxing:SetText("#{RXZS_XML_28}"..tostring(iLingXing))
	
	local iLingXing_Percent = Pet:GetPercent_Lx(nIndex)
	if tonumber(iLingXing_Percent) ~= nil and tonumber(iLingXing_Percent) > 0 then
		local strRate = string.format("%0.1f" , iLingXing_Percent / 10.0)
		Pet_Lingxing_Info:SetText("#cFF00FF(+"..strRate.."%)")
	end
	
	local iSavvy = Pet:GetSavvy(nIndex)
	Pet_WuXing:SetText("Ngµ tính:"..tostring(iSavvy))
	Pet_WuXing:SetToolTip("#{INTERFACE_XML_733}")
	
	local iStrAptitude = Pet:GetStrAptitude(nIndex)
	local iSprAptitude = Pet:GetIntAptitude(nIndex)
	local iConAptitude = Pet:GetPFAptitude(nIndex)
	local iIntAptitude = Pet:GetStaAptitude(nIndex)
	local iDexAptitude = Pet:GetDexAptitude(nIndex)
	
	local bHavePetSoul = Pet:LuaFnIsPetEquipPetSoul(nIndex)
	local iStrAptitude_ps = Pet:LuaFnGetStrAptitude_ps(nIndex)
	local iSprAptitude_ps = Pet:LuaFnGetSprAptitude_ps(nIndex)
	local iConAptitude_ps = Pet:LuaFnGetConAptitude_ps(nIndex)
	local iIntAptitude_ps = Pet:LuaFnGetIntAptitude_ps(nIndex)
	local iDexAptitude_ps = Pet:LuaFnGetDexAptitude_ps(nIndex)
	
	if WuXingTbl[iSavvy] ~= nil then
		if bHavePetSoul == 1 then
			Pet_StrAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iStrAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iStrAptitude_ps)..")")
			Pet_NimbusAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iSprAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iSprAptitude_ps)..")")
			Pet_PhysicalStrengthAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iConAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iConAptitude_ps)..")")
			Pet_StabilityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iIntAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iIntAptitude_ps)..")")
			Pet_DexterityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iDexAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iDexAptitude_ps)..")")
		else
			Pet_StrAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iStrAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			Pet_NimbusAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iSprAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			Pet_PhysicalStrengthAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iConAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			Pet_StabilityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iIntAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			Pet_DexterityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iDexAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
		end
	else
		if bHavePetSoul == 1 then
			Pet_StrAptitude:SetText(tostring(iStrAptitude).."#cFFCC99(+"..tostring(iStrAptitude_ps)..")")
			Pet_NimbusAptitude:SetText(tostring(iSprAptitude).."#cFFCC99(+"..tostring(iSprAptitude_ps)..")")
			Pet_PhysicalStrengthAptitude:SetText(tostring(iConAptitude).."#cFFCC99(+"..tostring(iConAptitude_ps)..")")
			Pet_StabilityAptitude:SetText(tostring(iIntAptitude).."#cFFCC99(+"..tostring(iIntAptitude_ps)..")")
			Pet_DexterityAptitude:SetText(tostring(iDexAptitude).."#cFFCC99(+"..tostring(iDexAptitude_ps)..")")
		else
			Pet_StrAptitude:SetText(tostring(iStrAptitude))
			Pet_NimbusAptitude:SetText(tostring(iSprAptitude))
			Pet_PhysicalStrengthAptitude:SetText(tostring(iConAptitude))
			Pet_StabilityAptitude:SetText(tostring(iIntAptitude))
			Pet_DexterityAptitude:SetText(tostring(iDexAptitude))		
		end
	end
	
	local iExp, iLevelUpExp = Pet:GetExp(nIndex)
	Pet_Exp:SetText("Kinh nghi®m:"..tostring(iExp) .."/"..tostring(iLevelUpExp))
	
	local iHP = Pet:GetHP(nIndex)
	local iMaxHP = Pet:	GetMaxHP(nIndex);
	Pet_Blood:SetText("Huyªt:"..tostring(iHP) .."/".. tostring(iMaxHP))

	local iStr = Pet:GetStr(nIndex)
	Pet_Str:SetText(tostring(iStr) + PETATTR[1])
	
	local iSpr = Pet:GetInt(nIndex)
	Pet_Nimbus:SetText(tostring(iSpr) + PETATTR[2])
	
	local iCon = Pet:GetPF(nIndex)
	Pet_PhysicalStrength:SetText(tostring(iCon) + PETATTR[4])
	
	local iInt = Pet:GetSta(nIndex)
	Pet_Stability:SetText(tostring(iInt) + PETATTR[5])
	
	local iDex = Pet:GetDex(nIndex)
	Pet_Dexterity:SetText(tostring(iDex) + PETATTR[3])
	
	local iGenGu = Pet:GetBasic(nIndex)
	Pet_GenGu:SetText("Cån C¯t:"..tostring(iGenGu))
	Pet_GenGu:SetToolTip("#{INTERFACE_XML_287}")

	Pet_CriticalAttack:SetText(Pet:GetCriticalAttack(nIndex))
	Pet_CriticalDefence : SetText(Pet:GetCriticalDefence(nIndex) )

	local iPotential = Pet:GetPotential(nIndex)
	local Sum_Attr = 0
	for i=1,PET_ATTR_COUNT do
		Sum_Attr = Sum_Attr + PETATTR[i]
	end
	
	--³öÏÖ âÖÖÇé¿öÊÇ
	if iPotential - Sum_Attr < 0 then
		PET_POTREMAIN = 0 
	 for i=1,PET_ATTR_COUNT do
			PETATTR[i] = 0
	 end
	else
		PET_POTREMAIN = iPotential - Sum_Attr
	end

	Pet_Potential:SetText(PET_POTREMAIN)
	Pet_Refresh_ADDSUB_Button()
	
	local iPhysicsAttack = Pet:GetPhysicsAttack(nIndex)
	Pet_PhysicsAttack:SetText(tostring(iPhysicsAttack))
	
	local iMagicAttack = Pet:GetMagicAttack(nIndex)
	Pet_MagicAttack:SetText(tostring(iMagicAttack))
	
	local iPhysicsDefence = Pet:GetPhysicsRecovery(nIndex)
	Pet_PhysicsRecovery:SetText(tostring(iPhysicsDefence))
	
	local iMagicDefence = Pet:GetMagicRecovery(nIndex)
	Pet_MagicRecovery:SetText(tostring(iMagicDefence))

	local iGrowRate = Pet:GetGrowRate(nIndex);

	Pet_Growth1:SetText("#{ZS_CZL}")	
	Pet_Growth:SetToolTip("#{INTERFACE_XML_986}")
	Pet_Growth:SetText("#GkHông biªt")
	local nGrowLevel = Pet:GetPetGrowLevel(nIndex, tonumber(iGrowRate))
	local strTbl = {"S½ C¤p", "Xu¤t S¡c", "Ki®t Xu¤t", "Trác Vi®t", "Toàn MÛ"}
	
	if nGrowLevel >= 0 then
		nGrowLevel = nGrowLevel + 1
		local nGrowRate = Pet:GetGrowRate(nIndex)
		if strTbl[nGrowLevel] ~= nil then
			Pet_Growth : SetText("#G"..strTbl[nGrowLevel]..nGrowRate)
		end
	end

	--ÉÁ±ÜÂÊ
	local iMiss = Pet:GetMiss(nIndex)
	Pet_Miss:SetText(tostring(iMiss))

	--ÃüÖÐÂÊ
	local iHit = Pet:GetShootProbability(nIndex)
	Pet_ShootProbability:SetText(iHit)
	
	local strTip, strIcon = Pet:GetAttackTrait(nIndex)
	if strIcon ~= "" then
		PetAttack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		PetAttack_Type:SetToolTip(strTip)
		PetAttack_Type:Show()
	end
	
	local SumPetSkill = GetActionNum("petskill")
	local k = 1
	local i = 1

	while i <= PETSKILL_BUTTONS_NUM do
		local theSkillAction = Pet:EnumPetSkill(nIndex, i - 1, "petskill")
		i = i + 1
		if theSkillAction:GetID() ~= 0 then
			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID())
			k = k + 1
		end
	end
	
	Pet_Refresh_Equip()
	
	if Pet:IsPetHaveEquip(nIndex) == 1 then
		OneKeyUnEquip:Enable()
	else
		OneKeyUnEquip:Disable()
	end

	if Pet:GetIsPossession(nIndex) then
		Pet_Heti:Hide()
		Pet_Fenli:Show()
	else
		Pet_Fenli:Hide()
		Pet_Heti:Show()
	end

	if Pet:GetIsFighting(nIndex) then
		Pet_Campaign:Hide()
		Pet_Rest:Show()
	else
		Pet_Rest:Hide()
		Pet_Campaign:Show()
	end
	
	local iFoodType = Pet:GetFoodType(nIndex)
	local strFood = ""

	if iFoodType >= 1000 then
		strFood = strFood.."Th¸t"
		iFoodType = iFoodType - 1000
		if iFoodType > 0 then
			strFood = strFood..","
		end
	end
	
	if iFoodType >= 100 then
		strFood = strFood.."Thäo"
		iFoodType = iFoodType - 100
		if iFoodType > 0 then
			strFood = strFood .. ","
		end
	end
	
	if iFoodType >= 10 then
		strFood = strFood.."Sâu"
		iFoodType = iFoodType - 10
		if iFoodType > 0 then
			strFood = strFood .. ","
		end
	end
	
	if iFoodType >= 1 then
		strFood = strFood.."Ngû c¯c"
	end
	
	PetFood_Type:Show()
	PetFood_Type:SetToolTip(strFood)
	
	Pet_Jian:Show()	
		
end

function Pet_Str_Add_Clicked()
	if PET_POTREMAIN > 0 then
		PETATTR[1] = PETATTR[1] + 1
		PET_POTREMAIN = PET_POTREMAIN - 1
		Pet_Potential:SetText(PET_POTREMAIN)
		Pet_Str:SetText(Pet_Str:GetText() + 1)
	Pet_Str_Subtraction:Enable()
	end
	
	if PET_POTREMAIN <= 0 then
		Pet_DisableAddButton()
	end
end

function Pet_Int_Add_Clicked()
	if PET_POTREMAIN > 0 then
		PETATTR[2] = PETATTR[2] + 1
		PET_POTREMAIN = PET_POTREMAIN - 1
		Pet_Potential:SetText(PET_POTREMAIN)
		Pet_Nimbus:SetText(Pet_Nimbus:GetText() + 1)
		Pet_Int_Subtraction:Enable()
	end
	
	if PET_POTREMAIN <= 0 then
		Pet_DisableAddButton()
	end
end

function Pet_Dex_Add_Clicked()
	if PET_POTREMAIN > 0 then
		PETATTR[3] = PETATTR[3] + 1
		PET_POTREMAIN = PET_POTREMAIN - 1
		Pet_Potential:SetText(PET_POTREMAIN )
		Pet_Dexterity:SetText(Pet_Dexterity:GetText() + 1)
		Pet_Dex_Subtraction:Enable()
	end
	
	if PET_POTREMAIN <= 0 then
		Pet_DisableAddButton()
	end
end

function Pet_PF_Add_Clicked()
	if PET_POTREMAIN > 0 then
		PETATTR[4] = PETATTR[4] + 1
		PET_POTREMAIN = PET_POTREMAIN - 1
		Pet_Potential:SetText(PET_POTREMAIN)
		Pet_PhysicalStrength:SetText(Pet_PhysicalStrength:GetText() + 1)
		Pet_PF_Subtraction:Enable()
	end
	
	if PET_POTREMAIN <= 0 then
		Pet_DisableAddButton()
	end
end

function Pet_Sta_Add_Clicked()
	if PET_POTREMAIN > 0 then
		PETATTR[5] = PETATTR[5] + 1
		PET_POTREMAIN = PET_POTREMAIN - 1
		Pet_Potential:SetText(PET_POTREMAIN)
		Pet_Stability:SetText(Pet_Stability:GetText() + 1)
		Pet_Sta_Subtraction:Enable()
	end

	if PET_POTREMAIN <= 0 then
		Pet_DisableAddButton()
	end
end

function Pet_Str_Sub_Clicked()
	if PETATTR[1] > 0 then
		PETATTR[1] = PETATTR[1] - 1
		PET_POTREMAIN = PET_POTREMAIN + 1
		Pet_Potential:SetText(PET_POTREMAIN)
		Pet_Str:SetText(Pet_Str:GetText() - 1)
		Pet_EnableAddButton()
	end
	
	if PETATTR[1] <= 0 then
		Pet_Str_Subtraction:Disable()
	end
end

function Pet_Int_Sub_Clicked()
	if PETATTR[2] > 0 then
		PETATTR[2] = PETATTR[2] - 1
		PET_POTREMAIN = PET_POTREMAIN + 1
		Pet_Potential:SetText(PET_POTREMAIN)
		Pet_Nimbus:SetText(Pet_Nimbus:GetText() - 1)
		Pet_EnableAddButton()
	end
	
	if PETATTR[2] <= 0 then
		Pet_Int_Subtraction:Disable()
	end
end

function Pet_Dex_Sub_Clicked()
	if PETATTR[3] > 0 then
		PETATTR[3] = PETATTR[3] - 1
		PET_POTREMAIN = PET_POTREMAIN + 1
		Pet_Potential:SetText(PET_POTREMAIN)
		Pet_Dexterity:SetText(Pet_Dexterity:GetText() - 1)
		Pet_EnableAddButton()
	end
	
	if PETATTR[3] <= 0 then
		Pet_Dex_Subtraction:Disable()
	end
end

function Pet_PF_Sub_Clicked()
	if PETATTR[4] > 0 then
		PETATTR[4] = PETATTR[4] - 1
		PET_POTREMAIN = PET_POTREMAIN + 1
		Pet_Potential:SetText(PET_POTREMAIN)
		Pet_PhysicalStrength:SetText(Pet_PhysicalStrength:GetText() - 1)
		Pet_EnableAddButton()
	end
	
	if PETATTR[4] <= 0 then
		Pet_PF_Subtraction:Disable()
	end
end

function Pet_Sta_Sub_Clicked()
	if PETATTR[5] > 0 then
		PETATTR[5] = PETATTR[5] - 1
		PET_POTREMAIN = PET_POTREMAIN + 1
		Pet_Potential:SetText(PET_POTREMAIN)
		Pet_Stability:SetText(Pet_Stability:GetText() - 1)
		Pet_EnableAddButton()
	end
	
	if PETATTR[5] <= 0 then
		Pet_Sta_Subtraction:Disable()
	end
end

function Pet_Accept_Clicked()

	if not Pet:IsPresent(PETNUM) then
		return
	end

	if tonumber(DataPool:GetLeftProtectTime()) > 0    then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		for i=1,PET_ATTR_COUNT do
			PETATTR[i] = 0
		end
		Pet_Show_PetInfo(PETNUM)
		return
	end
	
 	Pet:Add_Attribute(PETNUM, PETATTR[1], PETATTR[2], PETATTR[3], PETATTR[4], PETATTR[5])
	for i=1,PET_ATTR_COUNT do
		PETATTR[i] = 0
	end
end

function Pet_Cancel_Clicked()
	if not Pet:IsPresent(PETNUM) then
		return
	end
	
	for i=1,PET_ATTR_COUNT do
		PETATTR[i] = 0
	end

	Pet_Show_PetInfo(PETNUM)
end

function Pet_Relax_Clicked()
	Pet:Go_Relax(PETNUM)
end

function Pet_Fight_Clicked()
	-- ÒÑ¾­Ìá½»µ½Ö¸¶¨½çÃæÈÝÆ÷µÄ äÊÞ²»ÄÜ³ö ½
	if (IsWindowShow("PetSavvy") and Pet:GetPetLocation(PETNUM) == 12)							-- ???????????
		or (IsWindowShow("PetSavvyGGD")	and Pet:GetPetLocation(PETNUM) == 3)				-- ??????????
		or (IsWindowShow("MissionReply") and Pet:GetPetLocation(PETNUM) == 7) then	-- ?????????
		-- " äÊÞ´¦ÓÚÌá½»×´Ì¬£¬ÎÞ·¨³ö ½¡£"
		PushDebugMessage("#{ZSTJZT_090904}")
		return		
	end

	Pet:Go_Fight(PETNUM)
end

function Pet_Free_Clicked()
	if Pet:GetIsFighting(PETNUM) then
		PushDebugMessage("Trân Thú ðang · xu¤t chiªn, không th¬ B¸ phóng sinh")
		return
	end

	if (Pet:GetIsPossession(PETNUM)) then
		PushDebugMessage("#{SHXT_20211230_45}")
		return
	end

	if PlayerPackage:IsPetLock(PETNUM) == 1 then
		PushDebugMessage("#{Pet_Locked}")
		return
	end

	if Pet:GetPetLocation(PETNUM) ~= -1 then
		PushDebugMessage("#{GMGameInterface_Script_Pet_CantFree}")
		return
	end
	
	if Pet:IsFreeing(PETNUM) == 1 then
		--¸Ã äÊÞ ýÔÚ½øÐÐÆäËû²Ù×÷£¬²»ÄÜ·ÅÉú¡£
		return
  end

	Pet:Free_Confirm(PETNUM)
end

function Pet_LockPet_Clicked()
	PlayerPackage:OpenLockFrame(2)
end

function Pet_Feed_Clicked()
	Pet:Feed(PETNUM)
end

function Pet_Dome_Clicked()
	Pet:Dome(PETNUM)
end

function Pet_AmendName_Clicked()
	if not Pet:IsPresent(PETNUM) then
		return
	end
		
	local strName = Pet_PetName:GetText()
	Changed_Name_Flag = 0
	if string.len(strName) < 2  or string.len(strName) > 12 then
		Pet_Update()
		return
	end

	Pet:Change_Name(PETNUM, Pet_PetName:GetText())
end

-- Ðý×ª äÊÞÄ£ÐÍ£¨Ïò×ó)
function Pet_Modle_TurnLeft(start)
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Pet_FakeObject:RotateBegin(-0.3)
	else
		Pet_FakeObject:RotateEnd()
	end
end


--Ðý×ª äÊÞÄ£ÐÍ£¨ÏòÓÒ)
function Pet_Modle_TurnRight(start)
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Pet_FakeObject:RotateBegin(0.3)
	else
		Pet_FakeObject:RotateEnd()
	end
end

function Pet_SelfEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
	
	OpenEquip(1)
	Pet_Close()
	Pet_SelfEquip:SetCheck(0)
	Pet_SelfData:SetCheck(0)
	Pet_Pet:SetCheck(1)	
end

function Pet_Skill_Clicked(nSkillIndex)

	if PETNUM < 0 or PETNUM > PET_MAX_NUMBER then
		return
	end
	
	if not Pet:IsPresent(PETNUM) then
		return
	end
	
	if Pet : GetSkillPassive(PETNUM,nSkillIndex-1) == 0 then
		PushDebugMessage("Thïnh Tß¾ng Cai kÛ nång Ðà Du® Ðáo kÛ nång mau l© Lan sØ døng.")	
	end

end

function Pet_OnHiden()
	Pet:NotifyPetDlgClosed()
	Pet_PetName:SetProperty("DefaultEditBox", "False")
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
	Pet:LuaFnClosePetSoulInfo(0)
end

function Pet_EnableAddButton()
	Pet_Str_Addition:Enable()
	Pet_Int_Addition:Enable()
	Pet_PF_Addition:Enable()
	Pet_Sta_Addition:Enable()
	Pet_Dex_Addition:Enable()
end

function Pet_EnableSubButton()
	Pet_Str_Subtraction:Enable()
	Pet_Int_Subtraction:Enable()
	Pet_PF_Subtraction:Enable()
	Pet_Sta_Subtraction:Enable()
	Pet_Dex_Subtraction:Enable()
end

function Pet_DisableAddButton()
	Pet_Str_Addition:Disable()
	Pet_Int_Addition:Disable()
	Pet_PF_Addition:Disable()
	Pet_Sta_Addition:Disable()
	Pet_Dex_Addition:Disable()
end

function Pet_DisableSubButton()
	Pet_Str_Subtraction:Disable()
	Pet_Int_Subtraction:Disable()
	Pet_PF_Subtraction:Disable()
	Pet_Sta_Subtraction:Disable()
	Pet_Dex_Subtraction:Disable()
end

function Pet_Refresh_ADDSUB_Button()

	if PETATTR[1] > 0 then
		Pet_Str_Subtraction:Enable()
		Pet_Accept:Enable()
		Pet_Cancel:Enable()
	end
	
	if PETATTR[2] > 0 then
		Pet_Int_Subtraction:Enable()
		Pet_Accept:Enable()
		Pet_Cancel:Enable()
	end
	
	if PETATTR[3] > 0 then
		Pet_Dex_Subtraction:Enable()
		Pet_Accept:Enable()
		Pet_Cancel:Enable()
	end
	
	if PETATTR[4] > 0 then
		Pet_PF_Subtraction:Enable()
		Pet_Accept:Enable()
		Pet_Cancel:Enable()
	end
	
	if PETATTR[5] > 0 then
		Pet_Sta_Subtraction:Enable()
		Pet_Accept:Enable()
		Pet_Cancel:Enable()
	end
	
	if PET_POTREMAIN > 0 then
		Pet_EnableAddButton()
		Pet_Accept:Enable()
		Pet_Cancel:Enable()
	else
		Pet_DisableAddButton()
	end
	
	local Sum_Attr = 0
	for i=1,PET_ATTR_COUNT do
		Sum_Attr = Sum_Attr + PETATTR[i]
	end
	
	if PET_POTREMAIN <=0 and Sum_Attr <= 0 then
		Pet_Accept:Disable()
		Pet_Cancel:Disable()
	end
	
end

function PetName_Change()
	if Pet_PetName:GetText() ~= "" then
		Changed_Name_Flag = 0
	end
end

function Pet_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
	OtherInfoPage()
end

function Pet_Xiulian_Switch()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		Pet_Xiulian : SetCheck(0)
		Pet_ClearPage()
		return
	end
	
    nLevel = Player:GetData("LEVEL")
	if nLevel >= 70 then
		Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
		XiuLianPage()
	else
	    Pet_Xiulian:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    Pet_ClearPage()
	end
end

--´ò¿ª×Ô¼ºµÄ×ÊÁÏÒ³Ãæ
function Pet_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPrivatePage("self")
end

function Pet_Open()
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1
	SetTimer("Pet", "Pet_AutoClick_Timer()", g_AutoClickTimer_Step)

	this:Show()
		
	local isopen6 = T300Func:IsNoDifOpen(6)
	local isopen5 = T300Func:IsNoDifOpen(5)
	if isopen5 == 1 then
		--Pet_Wuhun:Disable()
	else
		Pet_Wuhun:Enable()
	end
	if isopen6 == 1 then
		--Pet_Xiulian:Disable()
	else
		Pet_Xiulian:Enable()
	end
end

function Pet_Close()
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1
	KillTimer("Pet_AutoClick_Timer()")

	this:Hide()
end

function Pet_chenghao_Clicked()
	if not Pet:IsPresent(PETNUM) then
		return
	end
	Pet:PetOpenTitleList(PETNUM)
end

function Pet_Jian_Clicked()
	if not Pet:IsPresent(PETNUM) then
		return
	end
	Pet:PetOpenPetJian(PETNUM, "self")
end

function Pet_ChangeSkin_Clicked()
	--if not Pet:IsPresent(PETNUM) then
	--	return
	--end
	--Pet:Lua_OpenPetExteriorUI(PETNUM)
end


--»ñÈ¡Íæ¼Òµ±Ç°µÈ¼¶×î´óÐ¯´øÊýÁ¿(ÒÔºóÔö¼ÓÊÞÀ¸ºóÒª·Ï³ý,¶ø²ÉÓÃÐÂµÄ·½·¨)-add by xindefeng
function Pet_GetMyCurMaxPetCount()
	local mylevel = Player:GetData("LEVEL") --??????
	if mylevel == nil or type(mylevel) ~= "number" then
		return 2
	end 
	local MaxCount = 0	--????
	
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
	MaxCount = MaxCount + Player:GetData("PET_EXTRANUM")
	
	if MaxCount > PET_MAX_NUMBER then
		MaxCount = PET_MAX_NUMBER
	end
	
	return MaxCount
end

--Ò»¼üÐ¶×°
function OneKeyUnEquip_Clicked()
	Pet:Lua_OneKeyUnEquip()
end

--ÏÔÊ¾Îä»êUI
function Pet_Wuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		Pet_Wuhun : SetCheck(0)
		Pet_ClearPage()
		return
	end
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
	ToggleWuhunPage()	
end

--ÇÐ»»Ìì¸³Ò³
function Pet_Talent_Page_Switch()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
		ToggleTalentPage()
	else
		Pet_Talent : SetCheck(0)
		Pet_ClearPage()
	end
end

--ÇÐ»»¸öÈË ¹Ê¾½çÃæ
function Pet_Profile_Switch()
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1);	
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
end

function Pet_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		Pet_LingYu:SetCheck(0)
		Pet_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function Pet_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		Pet_Weapon2:SetCheck(0)
		Pet_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function Pet_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		Pet_DWJinJie:SetCheck(0)
		Pet_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end
--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function Pet_Frame_On_ResetPos()
	Pet_Frame:SetProperty("UnifiedXPosition", g_Pet_Frame_UnifiedXPosition)
	Pet_Frame:SetProperty("UnifiedYPosition", g_Pet_Frame_UnifiedYPosition)
end

--***************************************************
-- Çå¿ Êó±ê³¤°´±ê¼Ç
--***************************************************
function Pet_AutoClick_Clear(id)
	id = tonumber(id)
	if (id == g_AutoClick_BtnFlag) then
		g_AutoClick_BtnFlag = -1
	end
end

--***************************************************
-- ¶¨Ê±Æ÷»Øµ÷º¯Êý
--    ÊµÏÖÂýÆô¶¯, ÒÔºó¿ÉÒÔ¿¼ÂÇ¼ÓËÙ(±ØÒªÐÔ²»´ó)
--***************************************************
function Pet_AutoClick_Timer()
	if (g_AutoClick_BtnFlag ~= -1) then
		-- µÚÒ»´ÎLButtonºó¾­¹ýX¸öTimer²ÅËã¿ªÊ¼, Ò²¾ÍÊÇËµÊÇ g_AutoClickTimer_Step * X µÄÊ±ºò¿ªÊ¼½øÐÐ×Ô¶¯¼Ó,  âÑùÎªÁË·ÀÖ¹±¾À´Òªµã»÷Ò»ÏÂµÄ½á¹ûµãÁËºÃ¶àÏÂ
		if (g_AutoClick_Going < 4) then
			g_AutoClick_Going = g_AutoClick_Going + 1
		else
			--Ä¿Ç°ÏÈÉèÖÃ 6 Step µÄµÈ´ýÊ±¼ä, ÏÂÃæ×¢ÊÍµÄ´úÂë¿ÉÒÔºóÀ´ÓÃÓÚÊµÏÖÂýÆô¶¯, Öð½¥¼ÓËÙÐ§¹û.
			--if (g_AutoClick_Going == 2 or g_AutoClick_Going == 5) then
				--g_AutoClick_FunList[g_AutoClick_BtnFlag]()
			--end
			g_AutoClick_FunList[g_AutoClick_BtnFlag]()
		end
	end
end

--***************************************************
-- Êó±ê×ó¼üËÉ¿ª²Ù×÷
--    ×¢Òâ âÀïÆäÊµÊÇ´úÌæ Click, ËùÒÔÐèÒªÖ´ÐÐÒ»´Î Click ²Ù×÷
--***************************************************
function Pet_AutoClick_LButtonUp(id)
	id = tonumber(id)
	Pet_AutoClick_Clear(id)
	g_AutoClick_FunList[id]()
end

--***************************************************
-- ÉèÖÃ¶¨Ê±Æ÷
--    ÉèÖÃ±ê¼ÇËµÃ÷Êó±êÒÑ¾­°´ÏÂ
--***************************************************
function Pet_AutoClick_SetTimer(id)
	id = tonumber(id)
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = id
end

function Pet_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"))
	Pet_ClearPage()
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
		if Pet_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if Pet_IsPageEnable(i) == 1 then
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

function Pet_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1)
	idx = g_PageOrder[idx]
	if idx == 1 then--??
		Pet_SelfEquip_Page_Switch()
	elseif idx == 2 then--??
		Pet_SelfData_Switch()
	elseif idx == 3 then--??
		--SelfData_Pet_Down()
		Pet_ClearPage()
	elseif idx == 4 then--??
		Pet_Wuhun_Switch()
	elseif idx == 5 then--??
		Pet_Xiulian_Switch()
	elseif idx == 6 then--??
		Pet_Talent_Page_Switch()
	elseif idx == 7 then--??
		Pet_Page_LingYu()
	elseif idx == 8 then--??
		Pet_Page_ShenBing()
	elseif idx == 9 then--????
		Pet_Page_DWJinJie()
	elseif idx == 10 then--??
		Pet_Page_Peak()
	elseif idx == 11 then--??
		Pet_Profile_Switch()
	elseif idx == 12 then--??
		Pet_Other_Info_Page_Switch()
	end
end

function Pet_CheckPage(idx)
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
		return DataPool:Lua_CheckIsShowTalent()
	elseif idx == 7 then--??
		return 1
	elseif idx == 8 then--??
		return 1
	elseif idx == 9 then--????
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 10 then--??
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 15 then
			return 1
		end
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function Pet_IsPageEnable(idx)
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
	elseif idx == 7 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 8 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 65 then
			return 1
		end
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??


		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end

	elseif idx == 11 then--??
		return 1
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function Pet_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--¸üÐÂ·ÖÒ³ºìµã
function Pet_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function Pet_PetSoulEquip_RClick()
	Pet_PetSoul_Equip:DoSubAction()
end

--  äÊÞ¸½Ìå
function Pet_Possession_Clicked()
	-- ÒÑ¾­Ìá½»µ½Ö¸¶¨½çÃæÈÝÆ÷µÄ äÊÞ²»ÄÜ³ö ½
	if (IsWindowShow("PetSavvy") and Pet:GetPetLocation(PETNUM) == 12)			-- ??????????? PET_LOCATION_SAVVY
		or (IsWindowShow("PetSavvyGGD")	and Pet:GetPetLocation(PETNUM) == 3)	-- ?????????? PET_LOCATION_SAVVYGGD
		or (IsWindowShow("MissionReply") and Pet:GetPetLocation(PETNUM) == 7)	-- ????????? PET_LOCATION_MISSIONREPLY
		or (IsWindowShow("PetHuanhua") and Pet:GetPetLocation(PETNUM) == 5)		-- ?????,???5  PET_LOCATION_HUANHUA
		then
		--  äÊÞ´¦ÓÚÌá½»×´Ì¬£¬ÎÞ·¨¸½Ìå¡£
		PushDebugMessage("#{SHXT_20211230_162}")
		return
	end
	Pet:PossessionPet(PETNUM)
end

--  äÊÞ·ÖÀë
function Pet_Restore_Clicked()
	Pet:RestorePet(PETNUM)
end

function Pet_PetSoul_ShowInfo()
	
	if Pet:LuaFnIsPetEquipPetSoul(PET_CURRENT_SELECT) ~= 1 then
		return
	end
	
	Pet:LuaFnShowPetSoulInfo(0, PET_CURRENT_SELECT)

end

function Pet_PetSoul2_MouseEnter()
	
	if Pet:LuaFnIsPetEquipPetSoul(PET_CURRENT_SELECT) ~= 1 then
		return
	end
	
	local left, right, top, bottom = Pet_PetSoul2:GetPixelRect()
	
	Pet:LuaFnShowPetSoulPossSkillInfo(PET_CURRENT_SELECT, 1, left, top, right, bottom)
	
end

function Pet_PetSoul2_MouseLeave()
	
	local left, right, top, bottom = Pet_PetSoul2:GetPixelRect()
	Pet:LuaFnShowPetSoulPossSkillInfo(PET_CURRENT_SELECT, 0, left, top, right, bottom)
	
end
function Pet_Page_Peak()
	
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	this:Hide();
end
