local Kfs_AttrEx_Text = {}
local Kfs_AttrEx_Value = {}
local KFS_ATTREX_MAX_NUM = 10
local Kfs_Base_Original_Text = {}
local Kfs_Base_Original_Value = {}
local Kfs_Base_Text = {}
local Kfs_Base_Value = {}
local Kfs_Skills = {}

local Kfs_Skill_ID = {}
--风、地、水、火
local Kfs_Magic_tips = {"#{WH_090817_04}" , "#{WH_090817_05}","#{WH_090817_06}","#{WH_090817_07}","#{WH_090817_08}"}
--力量、灵气、体力、身法、平衡
local Kfs_Att_tips = {"#{WH_xml_XX(53)}" , "#{WH_xml_XX(52)}" , "#{WH_xml_XX(54)}"  , "#{WH_xml_XX(60)}" , "#{WH_xml_XX(01)}"}

local Kfs_AttrEx_Mask_L = {}
local	Kfs_AttrEx_Mask_R	=	{}

-- 界面的默认相对位置
local g_Wuhun_Frame_UnifiedXPosition;
local g_Wuhun_Frame_UnifiedYPosition;

local g_EffectDic = {
	"#{WH_210223_142}",	--内功攻击
	"#{WH_210223_143}",	--外功攻击
	"#{WH_210223_138}",	--冰属性
	"#{WH_210223_139}",	--火属性
	"#{WH_210223_140}",	--玄属性
	"#{WH_210223_141}",	--毒属性
}

local g_AttrNameCtrl = {}
local g_AttrValueCtrl = {}

local isYYClicked = 0

local isYYChangeBusy = 0
local g_showPage = 0

local g_TupuBtn = {}
local g_TupuMask = {}

local g_CurrentSelWG = 0
-------------------------------------------
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

function Wuhun_PreLoad()
	--open or close this window
	this:RegisterEvent("TOGGLE_WUHUN_PAGE")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	--update equip
	this:RegisterEvent("REFRESH_EQUIP", false)
	this:RegisterEvent("UNIT_LEVEL", false)

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("WHWG_SLOT_UPDATE", false)
	this:RegisterEvent("WHWG_UPDATE", false)
	this:RegisterEvent("WHWG_YY_SWITCH", false)
	
	this:RegisterEvent("UPDATE_EXTERIOR_TIP")
end

function Wuhun_OnLoad()
	
	g_TupuBtn[1] = Wuhun_TupuItem_1
	g_TupuBtn[2] = Wuhun_TupuItem_2
	g_TupuBtn[3] = Wuhun_TupuItem_3
	g_TupuBtn[4] = Wuhun_TupuItem_4
	g_TupuBtn[5] = Wuhun_TupuItem_5
	g_TupuBtn[6] = Wuhun_TupuItem_6
	
	g_TupuMask[1] = Wuhun_TupuItem_1Mask
	g_TupuMask[2] = Wuhun_TupuItem_2Mask
	g_TupuMask[3] = Wuhun_TupuItem_3Mask
	g_TupuMask[4] = Wuhun_TupuItem_4Mask
	g_TupuMask[5] = Wuhun_TupuItem_5Mask
	g_TupuMask[6] = Wuhun_TupuItem_6Mask

	--AttrEx text
	Kfs_AttrEx_Mask_L[1] = Wuhun_Property1_Text
	Kfs_AttrEx_Mask_L[2] = Wuhun_Property2_Text
	Kfs_AttrEx_Mask_L[3] = Wuhun_Property3_Text
	Kfs_AttrEx_Mask_L[4] = Wuhun_Property4_Text
	Kfs_AttrEx_Mask_L[5] = Wuhun_Property5_Text
	Kfs_AttrEx_Mask_L[6] = Wuhun_Property6_Text
	Kfs_AttrEx_Mask_L[7] = Wuhun_Property7_Text
	Kfs_AttrEx_Mask_L[8] = Wuhun_Property8_Text
	Kfs_AttrEx_Mask_L[9] = Wuhun_Property9_Text
	Kfs_AttrEx_Mask_L[10] = Wuhun_Property10_Text
	--AttrEx value
	Kfs_AttrEx_Mask_R[1] = Wuhun_Property1
	Kfs_AttrEx_Mask_R[2] = Wuhun_Property2
	Kfs_AttrEx_Mask_R[3] = Wuhun_Property3
	Kfs_AttrEx_Mask_R[4] = Wuhun_Property4
	Kfs_AttrEx_Mask_R[5] = Wuhun_Property5
	Kfs_AttrEx_Mask_R[6] = Wuhun_Property6
	Kfs_AttrEx_Mask_R[7] = Wuhun_Property7
	Kfs_AttrEx_Mask_R[8] = Wuhun_Property8
	Kfs_AttrEx_Mask_R[9] = Wuhun_Property9
	Kfs_AttrEx_Mask_R[10] = Wuhun_Property10

	Kfs_AttrEx_Text[1] = Wuhun_Property1_Text_UnVisible;
	Kfs_AttrEx_Text[2] = Wuhun_Property2_Text_UnVisible;
	Kfs_AttrEx_Text[3] = Wuhun_Property3_Text_UnVisible;
	Kfs_AttrEx_Text[4] = Wuhun_Property4_Text_UnVisible;
	Kfs_AttrEx_Text[5] = Wuhun_Property5_Text_UnVisible;
	Kfs_AttrEx_Text[6] = Wuhun_Property6_Text_UnVisible;
	Kfs_AttrEx_Text[7] = Wuhun_Property7_Text_UnVisible;
	Kfs_AttrEx_Text[8] = Wuhun_Property8_Text_UnVisible;
	Kfs_AttrEx_Text[9] = Wuhun_Property9_Text_UnVisible;
	Kfs_AttrEx_Text[10] = Wuhun_Property10_Text_UnVisible;

	Kfs_AttrEx_Value[1] = Wuhun_Property1_UnVisible;
	Kfs_AttrEx_Value[2] = Wuhun_Property2_UnVisible;
	Kfs_AttrEx_Value[3] = Wuhun_Property3_UnVisible;
	Kfs_AttrEx_Value[4] = Wuhun_Property4_UnVisible;
	Kfs_AttrEx_Value[5] = Wuhun_Property5_UnVisible;
	Kfs_AttrEx_Value[6] = Wuhun_Property6_UnVisible;
	Kfs_AttrEx_Value[7] = Wuhun_Property7_UnVisible;
	Kfs_AttrEx_Value[8] = Wuhun_Property8_UnVisible;
	Kfs_AttrEx_Value[9] = Wuhun_Property9_UnVisible;
	Kfs_AttrEx_Value[10] = Wuhun_Property10_UnVisible;
	--Original five text
	Kfs_Base_Original_Text[1] = Wuhun_OriginalStr_Text
	Kfs_Base_Original_Text[2] = Wuhun_OriginalNimbus_Text
	Kfs_Base_Original_Text[3] = Wuhun_OriginalPhysicalStrength_Text
	Kfs_Base_Original_Text[4] = Wuhun_OriginalStability_Text
	Kfs_Base_Original_Text[5] = Wuhun_OriginalFootwork_Text
	--Original five value
	Kfs_Base_Value[1] = Wuhun_OriginalStr
	Kfs_Base_Value[2] = Wuhun_OriginalNimbus
	Kfs_Base_Value[3] = Wuhun_OriginalPhysicalStrength
	Kfs_Base_Value[4] = Wuhun_OriginalStability
	Kfs_Base_Value[5] = Wuhun_OriginalDexterity
	--five text
	Kfs_Base_Text[1] = Wuhun_Str_Text
	Kfs_Base_Text[2] = Wuhun_Nimbus_Text
	Kfs_Base_Text[3] = Wuhun_PhysicalStrength_Text
	Kfs_Base_Text[4] = Wuhun_Stability_Text
	Kfs_Base_Text[5] = Wuhun_Footwork_Text
	--five value 
	Kfs_Base_Original_Value[1] = Wuhun_Str
	Kfs_Base_Original_Value[2] = Wuhun_Nimbus
	Kfs_Base_Original_Value[3] = Wuhun_PhysicalStrength
	Kfs_Base_Original_Value[4] = Wuhun_Stability
	Kfs_Base_Original_Value[5] = Wuhun_Dexterity
	--skills
	Kfs_Skills[1] = Wuhun_Skill2
	Kfs_Skills[2] = Wuhun_Skill3
	Kfs_Skills[3] = Wuhun_Skill4

	-- 保存界面的默认相对位置
	g_Wuhun_Frame_UnifiedXPosition	= Wuhun_Frame : GetProperty("UnifiedXPosition")
	g_Wuhun_Frame_UnifiedYPosition	= Wuhun_Frame : GetProperty("UnifiedYPosition")
	
	g_AttrNameCtrl[1] = Wuhun_BK4_Info2_Info1
	g_AttrNameCtrl[2] = Wuhun_BK4_Info2_Info2
	g_AttrNameCtrl[3] = Wuhun_BK4_Info2_Info3
	g_AttrNameCtrl[4] = Wuhun_BK4_Info2_Info4
	g_AttrNameCtrl[5] = Wuhun_BK4_Info2_Info5
	g_AttrNameCtrl[6] = Wuhun_BK4_Info2_Info6
	g_AttrNameCtrl[7] = Wuhun_BK4_Info2_Info7
	g_AttrNameCtrl[8] = Wuhun_BK4_Info2_Info8
	
	g_AttrValueCtrl[1] = Wuhun_BK4_Info2_Number1
	g_AttrValueCtrl[2] = Wuhun_BK4_Info2_Number2
	g_AttrValueCtrl[3] = Wuhun_BK4_Info2_Number3
	g_AttrValueCtrl[4] = Wuhun_BK4_Info2_Number4
	g_AttrValueCtrl[5] = Wuhun_BK4_Info2_Number5
	g_AttrValueCtrl[6] = Wuhun_BK4_Info2_Number6
	g_AttrValueCtrl[7] = Wuhun_BK4_Info2_Number7
	g_AttrValueCtrl[8] = Wuhun_BK4_Info2_Number8

	g_PageButton[1] = Wuhun_SelfEquip
	g_PageButton[2] = Wuhun_SelfData
	g_PageButton[3] = Wuhun_Pet
	g_PageButton[4] = Wuhun_Wuhun
	g_PageButton[5] = Wuhun_Xiulian
	g_PageButton[6] = Wuhun_Talent
	g_PageButton[7] = Wuhun_Lingyu
	g_PageButton[8] = Wuhun_Weapon2
	g_PageButton[9] = Wuhun_DWJinJie
	g_PageButton[10] = Wuhun_Peak
	g_PageButton[11] = Wuhun_Profile
	g_PageButton[12] = Wuhun_OtherInfo

	g_PageMask[1] = Wuhun_SelfEquip_Mask
	g_PageMask[2] = Wuhun_SelfData_Mask
	g_PageMask[3] = Wuhun_Pet_Mask
	g_PageMask[4] = Wuhun_Wuhun_Mask
	g_PageMask[5] = Wuhun_Xiulian_Mask
	g_PageMask[6] = Wuhun_Talent_Mask
	g_PageMask[7] = Wuhun_Lingyu_Mask
	g_PageMask[8] = Wuhun_Weapon2_Mask
	g_PageMask[9] = Wuhun_DWJinJie_Mask
	g_PageMask[10] = Wuhun_Peak_Mask
	g_PageMask[11] = Wuhun_Profile_Mask
	g_PageMask[12] = Wuhun_OtherInfo_Mask

	g_PageTip[1] = Wuhun_SelfEquip_tips
	g_PageTip[2] = Wuhun_SelfData_tips
	g_PageTip[3] = Wuhun_Pet_tips
	g_PageTip[4] = Wuhun_Wuhun_tips
	g_PageTip[5] = Wuhun_Xiulian_tips
	g_PageTip[6] = Wuhun_Talent_tips
	g_PageTip[7] = Wuhun_Lingyu_tips
	g_PageTip[8] = Wuhun_Weapon2_tips
	g_PageTip[9] = Wuhun_DWJinJie_tips
	g_PageTip[10] = Wuhun_Peak_tips
	g_PageTip[11] = Wuhun_Profile_tips
	g_PageTip[12] = Wuhun_OtherInfo_tips


end

function Wuhun_OnEvent(event)
	
	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end
	
	if event == "TOGGLE_WUHUN_PAGE" then
		
		if this:IsVisible() then
			this:Hide()
			return
		end
		g_CurrentSelWG = 0
		g_showPage = 0
		Wuhun_ShowPage()
		Wuhun_Update()
		this:Show()
		Wuhun_UpdateRedPoint()
		return
	end
	
	if event == "REFRESH_EQUIP" and this:IsVisible() then
		Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1)
		Wuhun_Update()
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		Wuhun_Frame_On_ResetPos()
	end

	if event == "WHWG_SLOT_UPDATE" then
		Wuhun_UpdateTupu()
		Wuhun_UpdateSlot()
		Wuhun_FakeObject:SetFakeObject("")
		DataPool:KFS_UpdateKFSModel()
		Wuhun_FakeObject:SetFakeObject("My_Wuhun")
		return
	end
	
	if event == "WHWG_UPDATE" then
		Wuhun_UpdateTupu()
		Wuhun_UpdateSlot()
		return
	end

	if event == "WHWG_YY_SWITCH" then
		isYYChangeBusy = 0
		Wuhun_FakeObject:SetFakeObject("")
		DataPool:KFS_UpdateKFSModel()
		Wuhun_FakeObject:SetFakeObject("My_Wuhun")
		
		local yyFlag = DataPool:LuaFnGetYYFlag()	
		if yyFlag == 1 then
			Wuhun_FakeObject_ShowCheck:SetCheck(1)
		else
			Wuhun_FakeObject_ShowCheck:SetCheck(0)
		end
		return
	end
	
	if event == "UNIT_LEVEL" then
		Wuhun_Update()	
	end
	
	if event == "UPDATE_EXTERIOR_TIP" and this:IsVisible() then
		Wuhun_UpdateRedPoint()
	end
end

--Update
function Wuhun_Update()
	--Tab
	Wuhun_Wuhun:SetCheck(1)
	--Pos
	local selfUnionPos = Variable:GetVariable("SelfUnionPos");
	if(selfUnionPos ~= nil) then
		Wuhun_Frame:SetProperty("UnifiedPosition", selfUnionPos);
	end
	--Title
	Wuhun_PageHeader:SetText("#gFF0FA0#{WH_xml_XX(95)}")
	
	local data = DataPool:GetKfsData("NAME")
	Kfs_Skills[1]:SetProperty("UseDefaultTooltip", "True")
	Kfs_Skills[2]:SetProperty("UseDefaultTooltip", "True")
	Kfs_Skills[3]:SetProperty("UseDefaultTooltip", "True")
	Kfs_Skills[1]:SetToolTip("")
	Kfs_Skills[2]:SetToolTip("")
	Kfs_Skills[3]:SetToolTip("")
	
	Wuhun_Name:SetText("")
	if data ~= nil then
		Wuhun_Name:SetText(tostring(data))		
		Kfs_Skills[1]:SetToolTip("#{WU_090908_02}")
		Kfs_Skills[2]:SetToolTip("#{WU_090908_03}")
		Kfs_Skills[3]:SetToolTip("#{WU_090908_04}")
	end

	--ICON
	Wuhun_Equip_Mask:Hide()
	
	Wuhun_Equip:SetActionItem(-1)
	
	local ActionKFS = EnumAction(18,"equip")
	Wuhun_Equip:SetActionItem(ActionKFS:GetID());
	--Model
	Wuhun_FakeObject:SetFakeObject( "" );
	DataPool:KFS_UpdateKFSModel()
	Wuhun_FakeObject:SetFakeObject("My_Wuhun");
	
	--NeedLv
	--Wuhun_NeedLevel_Text:SetText("")	
	
	data = DataPool:GetKfsData("NEEDLEVEL")
	if data ~= nil then
	--	Wuhun_NeedLevel_Text:SetText(tostring(data))
	end
	
	--Lv
	Wuhun_Level_Text:SetText("")
	data = DataPool:GetKfsData("LEVEL")
	if data ~= nil then
		Wuhun_Level_Text:SetText(tostring(data))
	end
	
	--ExtraLevel
	Wuhun_ExtraLevel_Text:SetText("")	
	data = DataPool:GetKfsData("EXTRALEVEL")
	if data ~= nil then
		Wuhun_ExtraLevel_Text:SetText(tostring(data))
	end
	
	--AttactType
	Wuhun_Type_Text:SetText("")

	data = DataPool:GetKfsData("ATTACT")
	if data ~= nil and data < 5 and data >= 0 then
		Wuhun_Type_Text:SetText(Kfs_Att_tips[data + 1])
	end
	
	--Life
	Wuhun_Life_Text2:SetText("")

	data = DataPool:GetKfsData("LIFE")
	local maxLife = DataPool:GetKfsData("MAXLIFE")
	if data ~= nil then
		Wuhun_Life_Text2:SetText(tostring(data).."/"..tostring(maxLife))

		if data < 16 then
			Wuhun_Equip_Mask:Show()
		end
	end
	
	--Exp
	Wuhun_Exp:SetText("#{WH_xml_XX(76)}")
	Wuhun_Exp_Text:SetText("")
	data = DataPool:GetKfsData("EXP")
	local needexp = DataPool:GetKfsData("NEEDEXP")
	if data ~= nil then
		Wuhun_Exp_Text:SetText(tostring(data).."/"..tostring(needexp))
	end
	
	--GrowRate
	Wuhun_Growth1:SetText("")
	Wuhun_Growth1:SetToolTip("")
	Wuhun_Growth:SetText("")
	Wuhun_Growth:SetToolTip("")
	local grade = DataPool:GetKfsData("Grade")
	data =DataPool:GetKfsData("GROW")
	if data ~= nil and grade ~= nil then
		Wuhun_Growth1:SetText("#{WH_xml_XX(93)}")
		Wuhun_Growth1:SetToolTip("#{WH_090729_43}")
	  if grade == 0 then
			Wuhun_Growth:SetText("#G#{ZSKSSJ_PT}"..tostring(data))
	  elseif grade == 1 then
			 Wuhun_Growth:SetText("#G#{ZSKSSJ_YX}"..tostring(data))
	  elseif grade == 2 then
	   		Wuhun_Growth:SetText("#G#{ZSKSSJ_JC}"..tostring(data))
	  elseif grade == 3 then
	  		Wuhun_Growth:SetText("#G#{ZSKSSJ_ZY}"..tostring(data))
	  elseif grade == 4 then
	  		Wuhun_Growth:SetText("#G#{ZSKSSJ_WM}"..tostring(data))
	  end
	end
	
	--AttrEx
	local slot = DataPool:GetKfsData("SLOT")
	for i=1,KFS_ATTREX_MAX_NUM do	
		
		Kfs_AttrEx_Text[i]:SetText("")
		Kfs_AttrEx_Value[i]:SetText("")
		
		if slot ~= nil and i <= slot then
			Kfs_AttrEx_Text[i]:Show()
			Kfs_AttrEx_Value[i]:Show()
		else
			Kfs_AttrEx_Text[i]:Hide()
			Kfs_AttrEx_Value[i]:Hide()
		end
		
		local iText , iValue = DataPool:GetKfsFixAttrEx(i - 1)
		if iText ~= nil and iText ~= "" and iValue ~= nil and iValue > 0  then
			Kfs_AttrEx_Text[i]:SetText(iText)
			Kfs_AttrEx_Value[i]:SetText("+"..tostring(iValue))
		end
	end
	
	--BaseAttr
	for i=1,5 do	
		Kfs_Base_Original_Value[i]:SetText("")
		Kfs_Base_Value[i]:SetText("")

		data = DataPool:GetKfsBase(i - 1)
		if data ~= nil then
			Kfs_Base_Original_Value[i]:SetText("+"..tostring(data))
		end

		data = DataPool:GetFixKfsBase(i - 1)
		if data ~= nil then
			Kfs_Base_Value[i]:SetText("+"..tostring(data))
		end
	end
	
	--SKills
	Kfs_Skills[1]:SetActionItem(-1)
	Kfs_Skills[2]:SetActionItem(-1)
	Kfs_Skills[3]:SetActionItem(-1)
	
	local nSumSkill = GetActionNum("skill");
	Kfs_Skill_ID = {}
	for i=1,3 do	
		local skillID = DataPool:GetKfsSkill( i - 1)
		if skillID ~= nil and skillID > 0 then
			Kfs_Skill_ID[i] = skillID
		else
			Kfs_Skill_ID[i] = -1
		end
	end

	for i=1, nSumSkill do
		theAction = EnumAction(i-1, "skill");
		if theAction:GetOwnerXinfa() == -8888 then			
			if theAction:GetDefineID() == Kfs_Skill_ID[1] then
				Kfs_Skills[1]:SetProperty("UseDefaultTooltip", "False")
				Kfs_Skills[1]:SetActionItem(theAction:GetID())
			elseif theAction:GetDefineID() == Kfs_Skill_ID[2] then
				Kfs_Skills[2]:SetProperty("UseDefaultTooltip", "False")
				Kfs_Skills[2]:SetActionItem(theAction:GetID())
			elseif theAction:GetDefineID() == Kfs_Skill_ID[3] then
				Kfs_Skills[3]:SetProperty("UseDefaultTooltip", "False")
				Kfs_Skills[3]:SetActionItem(theAction:GetID())
			end
		end
	end

	Wuhun_UpdateTupu()
	Wuhun_UpdateSlot()
	
	local yyFlag = DataPool:LuaFnGetYYFlag()
	isYYChangeBusy = 0
	if yyFlag == 1 then
		Wuhun_FakeObject_ShowCheck:SetCheck(1)
	else
		Wuhun_FakeObject_ShowCheck:SetCheck(0)
	end
	
	if g_showPage == 0 then
		Wuhun_Page1:SetCheck(1)
		Wuhun_Page2:SetCheck(0)
		Wuhun_Page1Client:Show()
		Wuhun_Page2Client:Hide()
	else
		Wuhun_Page1:SetCheck(0)
		Wuhun_Page2:SetCheck(1)
		Wuhun_Page1Client:Hide()
		Wuhun_Page2Client:Show()
	end
	
	local myLevel = Player:GetData("LEVEL")
	if myLevel < 80 then
		Wuhun_Page2:SetToolTip("#{WH_210223_198}")
	else
		Wuhun_Page2:SetToolTip("")
	end
end

function Wuhun_UpdateSlot()

	Wuhun_BK4_Tupu1_Mask:Hide()
	Wuhun_BK4_Tupu2_Mask:Hide()
	
	Wuhun_BK4_Tupu1:SetActionItem(-1)
	Wuhun_BK4_Tupu2:SetActionItem(-1)
	
	Wuhun_BK4_Tupu1:SetProperty("Empty", "False")
	Wuhun_BK4_Tupu2:SetProperty("Empty", "False")
	
	Wuhun_BK4_Tupu1:SetToolTip("")
	Wuhun_BK4_Tupu2:SetToolTip("")
	
	local bHaveKfs = 1
	local comLevel = DataPool:GetKfsData("EXTRALEVEL")
	if tonumber(comLevel) == nil then
		bHaveKfs = 0
	end
	
	local life = DataPool:GetKfsData("LIFE")
	if tonumber(life) == nil then
		bHaveKfs = 0
	end
	
	local yangWg = DataPool:LuaFnGetWHWGInSlot(0)
	local yinWg = DataPool:LuaFnGetWHWGInSlot(1)
	local attr_count = DataPool:LuaFnGetWHWGAllAttrCount()
	
	local isValid = 1
	Wuhun_BK4_Info3:SetText("")
	if yangWg > 0 or yinWg > 0 or attr_count > 0 then
		if bHaveKfs == 0 or comLevel < 5 or life <= 0 then
			local strTemp = ScriptGlobal_Format("#{WH_210223_23}", tostring(5))
			Wuhun_BK4_Info3:SetText(strTemp)
			isValid = 0
		end
	end
	
	local errColor = "#c808080"
	if isValid == 1 then
		errColor = "#cfff263"
	end
	
	local myLevel = Player:GetData("LEVEL")
	
	local strYangEffect = ""
	local strYangValue = ""
	
	local strYinEffect = ""
	local strYinValue = ""
	
	if yangWg > 0 then
		local theAction = EnumAction(yangWg, "whwg")
		if theAction:GetID() ~= 0 then
			Wuhun_BK4_Tupu1:SetActionItem(theAction:GetID())
		end
		
		local strName = DataPool:LuaFnGetWHWGInfo(yangWg, "Name")
		local grade = DataPool:LuaFnGetWHWGInfo(yangWg, "Grade")
		local level = DataPool:LuaFnGetWHWGInfo(yangWg, "Level")
		
		local strYang, strYin, strFree = DataPool:LuaFnWHWGAttrSTR(yangWg, grade, level)
		
		local effectType, strValue, _, _ = DataPool:LuaFnWHWGEffect(yangWg, grade, level)
		if effectType ~= nil and effectType >= 0 and effectType <= 5 then
			strYangEffect = ScriptGlobal_Format("#{WH_210311_04}", g_EffectDic[effectType + 1])
			strYangValue = strValue
		end
	else		
		Wuhun_BK4_Tupu1:SetProperty("NormalImage", "")
		Wuhun_BK4_Tupu1:SetProperty("UseDefaultTooltip", "True")
		if myLevel < 80 then
			Wuhun_BK4_Tupu1:SetToolTip("#{WH_210223_197}")
		else
			Wuhun_BK4_Tupu1:SetToolTip("#{WH_210223_17}")
		end		
	end
	
	if yinWg > 0 then
		local theAction = EnumAction(yinWg, "whwg")
		if theAction:GetID() ~= 0 then
			Wuhun_BK4_Tupu2:SetActionItem(theAction:GetID())
		end
		
		local strName = DataPool:LuaFnGetWHWGInfo(yinWg, "Name")
		local grade = DataPool:LuaFnGetWHWGInfo(yinWg, "Grade")
		local level = DataPool:LuaFnGetWHWGInfo(yinWg, "Level")
		
		local strYang, strYin, strFree = DataPool:LuaFnWHWGAttrSTR(yinWg, grade, level)
		
		local _, _, effectType, strValue = DataPool:LuaFnWHWGEffect(yinWg, grade, level)
		if effectType ~= nil and effectType >= 0 and effectType <= 5 then
			strYinEffect = ScriptGlobal_Format("#{WH_210311_05}", g_EffectDic[effectType + 1])
			strYinValue = strValue
		end
	else		
		Wuhun_BK4_Tupu2:SetProperty("NormalImage", "")
		Wuhun_BK4_Tupu2:SetProperty("UseDefaultTooltip", "True")
		if myLevel < 80 then
			Wuhun_BK4_Tupu2:SetToolTip("#{WH_210223_197}")
		else
			Wuhun_BK4_Tupu2:SetToolTip("#{WH_210223_17}")
		end		
	end

	local nowIndex = 1
	
	for i = 1, 8 do
		local strAttr, strValue = DataPool:LuaFnGetWHWGAllAttrDesc(i - 1)
		
		if strAttr == "" then
			g_AttrNameCtrl[i]:Hide()
			g_AttrValueCtrl[i]:Hide()
		else
			g_AttrNameCtrl[i]:Show()
			g_AttrValueCtrl[i]:Show()
			g_AttrNameCtrl[i]:SetText(errColor..strAttr)
			g_AttrValueCtrl[i]:SetText(errColor..strValue)
			nowIndex = nowIndex + 1
		end
	end

	if nowIndex <= 8 then
		if strYangEffect ~= "" then
			g_AttrNameCtrl[nowIndex]:Show()
			g_AttrValueCtrl[nowIndex]:Show()
			g_AttrNameCtrl[nowIndex]:SetText(errColor..strYangEffect)
			g_AttrValueCtrl[nowIndex]:SetText(errColor..strYangValue)
			nowIndex = nowIndex + 1
		end	
	end
	
	if nowIndex <= 8 then
		if strYinEffect ~= "" then
			g_AttrNameCtrl[nowIndex]:Show()
			g_AttrValueCtrl[nowIndex]:Show()
			g_AttrNameCtrl[nowIndex]:SetText(errColor..strYinEffect)
			g_AttrValueCtrl[nowIndex]:SetText(errColor..strYinValue)
		end	
	end
end

function Wuhun_UpdateTupu()
	
	DataPool:LuaFnInitWHWGList()
	local nCount = DataPool:LuaFnGetWHWGListCount()
	
	local yangWg = DataPool:LuaFnGetWHWGInSlot(0)
	local yinWg = DataPool:LuaFnGetWHWGInSlot(1)
	
	for idx = 1, 6 do
		
		g_TupuBtn[idx]:SetProperty("DraggingEnabled", "False")
		
		if idx <= nCount then	
			local wgID = DataPool:LuaFnGetWHWGIDFromList(idx - 1)
			local nUnLocked = DataPool:LuaFnGetWHWGInfo(wgID, "UnLocked")
			local nLevel = DataPool:LuaFnGetWHWGInfo(wgID, "Level")
			local nGrade = DataPool:LuaFnGetWHWGInfo(wgID, "Grade")
			local strName = DataPool:LuaFnGetWHWGInfo(wgID, "Name")
		
			--激活锁
			if nUnLocked == 1 then
				g_TupuMask[idx]:Hide()
			else
				g_TupuMask[idx]:Show()
			end

			g_TupuBtn[idx]:SetActionItem(-1)
			local theAction = EnumAction(wgID, "whwg")
			if theAction:GetID() ~= 0 then
				g_TupuBtn[idx]:SetActionItem(theAction:GetID())
			end

			if wgID == g_CurrentSelWG then
				g_TupuBtn[idx]:SetPushed(1)
			else
				g_TupuBtn[idx]:SetPushed(0)
			end
		else
			g_TupuBtn[idx]:SetActionItem(-1)	
			g_TupuMask[idx]:Hide()		
		end
	end
	
	if g_CurrentSelWG == 0 then
		Wuhun_BK4_OK1:SetText("#{WH_210223_37}")
		Wuhun_BK4_OK1:SetToolTip("#{WH_210223_203}")
		
		Wuhun_BK4_OK2:SetText("#{WH_210223_207}")
		Wuhun_BK4_OK2:SetToolTip("#{WH_210223_208}")
	else
		local nUnLocked = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
		if nUnLocked ~= 1 then
			Wuhun_BK4_OK1:SetText("#{WH_210223_37}")
			Wuhun_BK4_OK1:SetToolTip("#{WH_210223_203}")
		
			Wuhun_BK4_OK2:SetText("#{WH_210223_207}")
			Wuhun_BK4_OK2:SetToolTip("#{WH_210223_208}")
		else
			if g_CurrentSelWG ~= yangWg then
				Wuhun_BK4_OK1:SetText("#{WH_210223_37}")
				Wuhun_BK4_OK1:SetToolTip("#{WH_210223_206}")
			else
				Wuhun_BK4_OK1:SetText("#{WH_210223_204}")
				Wuhun_BK4_OK1:SetToolTip("#{WH_210223_205}")
			end
			
			if g_CurrentSelWG ~= yinWg then
				Wuhun_BK4_OK2:SetText("#{WH_210223_207}")
				Wuhun_BK4_OK2:SetToolTip("#{WH_210223_209}")
			else
				Wuhun_BK4_OK2:SetText("#{WH_210223_210}")
				Wuhun_BK4_OK2:SetToolTip("#{WH_210223_211}")
			end
		end
	end

end

function Wuhun_TupuItemClicked(nIndex)
	
	local wgID = DataPool:LuaFnGetWHWGIDFromList(nIndex - 1)
	if g_CurrentSelWG == wgID then
		return
	end
	
	g_CurrentSelWG = wgID
	
	for i = 1, 6 do
		if i == nIndex then
			g_TupuBtn[i]:SetPushed(1)
		else
			g_TupuBtn[i]:SetPushed(0)	
		end
	end
	
	local yangWg = DataPool:LuaFnGetWHWGInSlot(0)
	local yinWg = DataPool:LuaFnGetWHWGInSlot(1)
	
	if g_CurrentSelWG == 0 then
		Wuhun_BK4_OK1:SetText("#{WH_210223_37}")
		Wuhun_BK4_OK1:SetToolTip("#{WH_210223_203}")
		
		Wuhun_BK4_OK2:SetText("#{WH_210223_207}")
		Wuhun_BK4_OK2:SetToolTip("#{WH_210223_208}")
	else
		local nUnLocked = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
		if nUnLocked ~= 1 then
			Wuhun_BK4_OK1:SetText("#{WH_210223_37}")
			Wuhun_BK4_OK1:SetToolTip("#{WH_210223_203}")
		
			Wuhun_BK4_OK2:SetText("#{WH_210223_207}")
			Wuhun_BK4_OK2:SetToolTip("#{WH_210223_208}")
		else
			if g_CurrentSelWG ~= yangWg then
				Wuhun_BK4_OK1:SetText("#{WH_210223_37}")
				Wuhun_BK4_OK1:SetToolTip("#{WH_210223_206}")
			else
				Wuhun_BK4_OK1:SetText("#{WH_210223_204}")
				Wuhun_BK4_OK1:SetToolTip("#{WH_210223_205}")
			end
			
			if g_CurrentSelWG ~= yinWg then
				Wuhun_BK4_OK2:SetText("#{WH_210223_207}")
				Wuhun_BK4_OK2:SetToolTip("#{WH_210223_209}")
			else
				Wuhun_BK4_OK2:SetText("#{WH_210223_210}")
				Wuhun_BK4_OK2:SetToolTip("#{WH_210223_211}")
			end
		end
	end
	
end

function Wuhun_ChangeWG(slot)
	
	if slot ~= 0 and slot ~= 1 then
		return
	end
	
	local slotWG = DataPool:LuaFnGetWHWGInSlot(slot)
	
	if slotWG == 0 or slotWG ~= g_CurrentSelWG then
		DataPool:LuaFnCastChangeWGSkill(slot, g_CurrentSelWG)	
	else
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("TakeOut")
			Set_XSCRIPT_ScriptID(888800)
			Set_XSCRIPT_Parameter(0, slot)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end

--kfs equippoint clicked event
function Wuhun_Equip_Clicked( buttonIn )
	local button = tonumber( buttonIn );
	if( button == 1 ) then
		Wuhun_Equip:DoAction();	
	else
		Wuhun_Equip:DoSubAction();
	end

end

--model turn left
function Wuhun_Model_TurnLeft(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Wuhun_FakeObject:RotateBegin(-0.3);
	--stop
	else
		Wuhun_FakeObject:RotateEnd();
	end
end

--model turn right
function Wuhun_Model_TurnRight(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Wuhun_FakeObject:RotateBegin(0.3);
	--stop
	else
		Wuhun_FakeObject:RotateEnd();
	end
end

--kfs hidden event
function Wuhun_OnHiden()
	Wuhun_FakeObject:SetFakeObject("")
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function Wuhun_OpenWG()
	local comLevel = DataPool:GetKfsData("EXTRALEVEL")
	if tonumber(comLevel) == nil then
		PushDebugMessage("#{WH_210223_27}")
		return
	end
	DataPool:LuaFnOpenWHWG()
end

function Wuhun_SwitchRightPage(index)
	
	isYYClicked = 1
	
	if g_showPage == index then
		isYYClicked = 0
		return
	end
	
	if index == 1 then
		local myLevel = Player:GetData("LEVEL")
		if myLevel < 80 then
			PushDebugMessage("#{WH_210223_213}")
			isYYClicked = 0
			return 
		end		
	end

	g_showPage = index
	
	if g_showPage == 0 then
		Wuhun_Page1:SetCheck(1)
		Wuhun_Page2:SetCheck(0)
		Wuhun_Page1Client:Show()
		Wuhun_Page2Client:Hide()
	else
		Wuhun_Page1:SetCheck(0)
		Wuhun_Page2:SetCheck(1)
		Wuhun_Page1Client:Hide()
		Wuhun_Page2Client:Show()
	end
end

function Wuhun_UpdateSwitch()
	
	if isYYClicked == 1 then
		isYYClicked = 0
		return
	end
	
	if g_showPage == 0 then
		Wuhun_Page1:SetCheck(1)
		Wuhun_Page2:SetCheck(0)
	else
		Wuhun_Page1:SetCheck(0)
		Wuhun_Page2:SetCheck(1)
	end
end

function Wuhun_OpenWGChange()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenChangeWg")
		Set_XSCRIPT_ScriptID(888800)
		Set_XSCRIPT_Parameter(0, -1)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Wuhun_ChangeYY()
	
	if isYYChangeBusy == 1 then
		return
	end

	isYYClicked = 1
	local yyFlag = DataPool:LuaFnGetYYFlag()
	if yyFlag == 1 then
		Wuhun_FakeObject_ShowCheck:SetCheck(0)
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("SwitchYY")
			Set_XSCRIPT_ScriptID(888800)
			Set_XSCRIPT_Parameter(0, 0)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	else
		Wuhun_FakeObject_ShowCheck:SetCheck(1)
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("SwitchYY")
			Set_XSCRIPT_ScriptID(888800)
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end	

end

function Wuhun_RestoreYY()
	if isYYClicked == 1 then
		isYYClicked = 0
		return
	end
	
	local yyFlag = DataPool:LuaFnGetYYFlag()
	
	if yyFlag == 1 then
		Wuhun_FakeObject_ShowCheck:SetCheck(1)
	else
		Wuhun_FakeObject_ShowCheck:SetCheck(0)
	end
end

--player's other info
function Wuhun_OtherInfo_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
end

--player's pet
function Wuhun_Pet_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	TogglePetPage();
end

--player's info
function Wuhun_SelfData_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");
end

--player's equip
function Wuhun_SelfEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenEquip(1);
end


function Wuhun_Talent_Page_Switch()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
		ToggleTalentPage();
	else
		Wuhun_Talent : SetCheck(0)
		Wuhun_ClearPage()
	end
end
--xiu lian
function Wuhun_Xiulian_Page_Switch()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		return
	end
	
    local nLevel = Player:GetData("LEVEL")
	if(nLevel >= 70) then
		Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
		XiuLianPage();
	else
	    Wuhun_Xiulian:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    Wuhun_ClearPage()
	end
end

--切换个人展示界面
function Wuhun_Profile_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);	
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
end

function Wuhun_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function Wuhun_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		Wuhun_Weapon2:SetCheck(0)
		Wuhun_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function Wuhun_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		Wuhun_DWJinJie:SetCheck(0)
		Wuhun_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function Wuhun_Frame_On_ResetPos()

	Wuhun_Frame : SetProperty("UnifiedXPosition", g_Wuhun_Frame_UnifiedXPosition);
	Wuhun_Frame : SetProperty("UnifiedYPosition", g_Wuhun_Frame_UnifiedYPosition);

end

function Wuhun_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"));
	Wuhun_ClearPage()
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
		if Wuhun_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if Wuhun_IsPageEnable(i) == 1 then
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

function Wuhun_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]
	if idx == 1 then--装备
		Wuhun_SelfEquip_Page_Switch()
	elseif idx == 2 then--资料
		Wuhun_SelfData_Page_Switch()
	elseif idx == 3 then--珍兽
		Wuhun_Pet_Page_Switch()
	elseif idx == 4 then--武魂
		--Pet_Wuhun_Switch()
		Wuhun_ClearPage()
	elseif idx == 5 then--修炼
		Wuhun_Xiulian_Page_Switch()
	elseif idx == 6 then--武道
		Wuhun_Talent_Page_Switch()
	elseif idx == 7 then--灵玉
		Wuhun_Page_LingYu()
	elseif idx == 8 then--神兵
		Wuhun_Page_ShenBing()
	elseif idx == 9 then--雕文进阶
		Wuhun_Page_DWJinJie()
	elseif idx == 10 then--巅峰
		Wuhun_Open_Peak()
	elseif idx == 11 then--个人
		Wuhun_Profile_Switch()
	elseif idx == 12 then--其他
		Wuhun_OtherInfo_Page_Switch()
	end
end

function Wuhun_CheckPage(idx)
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

function Wuhun_IsPageEnable(idx)
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

function Wuhun_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--更新分页红点
function Wuhun_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function Wuhun_Open_Peak()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	this:Hide();
end