
local TargetKfs_AttrEx_Text = {}
local TargetKfs_AttrEx_Value = {}
local TargetKfs_ATTREX_MAX_NUM = 10
local TargetKfs_Base_Original_Text = {}
local TargetKfs_Base_Original_Value = {}
local TargetKfs_Base_Text = {}
local TargetKfs_Base_Value = {}
local TargetKfs_Skills = {}

local TargetKfs_Skill_ID = {}
--力量、灵气、体力、身法、平衡
local TargetKfs_Att_tips = {"#{WH_xml_XX(53)}" , "#{WH_xml_XX(52)}" , "#{WH_xml_XX(54)}"  , "#{WH_xml_XX(60)}" , "#{WH_xml_XX(01)}"}

local TargetKfs_AttrEx_Mask_L = {}
local	TargetKfs_AttrEx_Mask_R	=	{}

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

local g_showPage = 0

local g_TupuBtn = {}
local g_TupuMask = {}

local g_TargetWuhun_Frame_UnifiedPosition;

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

function TargetWuhun_PreLoad()
	--open or close this window
	this:RegisterEvent("OPEN_OTHERPLAYER_WUHUN");
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--update equip
	this:RegisterEvent("OTHERPLAYER_UPDATE_EQUIP");
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function TargetWuhun_OnLoad()

	g_TupuBtn[1] = TargetWuhun_TupuItem_1
	g_TupuBtn[2] = TargetWuhun_TupuItem_2
	g_TupuBtn[3] = TargetWuhun_TupuItem_3
	g_TupuBtn[4] = TargetWuhun_TupuItem_4
	g_TupuBtn[5] = TargetWuhun_TupuItem_5
	g_TupuBtn[6] = TargetWuhun_TupuItem_6
	
	g_TupuMask[1] = TargetWuhun_TupuItem_1Mask
	g_TupuMask[2] = TargetWuhun_TupuItem_2Mask
	g_TupuMask[3] = TargetWuhun_TupuItem_3Mask
	g_TupuMask[4] = TargetWuhun_TupuItem_4Mask
	g_TupuMask[5] = TargetWuhun_TupuItem_5Mask
	g_TupuMask[6] = TargetWuhun_TupuItem_6Mask
	
	--AttrEx text
	TargetKfs_AttrEx_Mask_L[1] = TargetWuhun_Property1_Text
	TargetKfs_AttrEx_Mask_L[2] = TargetWuhun_Property2_Text
	TargetKfs_AttrEx_Mask_L[3] = TargetWuhun_Property3_Text
	TargetKfs_AttrEx_Mask_L[4] = TargetWuhun_Property4_Text
	TargetKfs_AttrEx_Mask_L[5] = TargetWuhun_Property5_Text
	TargetKfs_AttrEx_Mask_L[6] = TargetWuhun_Property6_Text
	TargetKfs_AttrEx_Mask_L[7] = TargetWuhun_Property7_Text
	TargetKfs_AttrEx_Mask_L[8] = TargetWuhun_Property8_Text
	TargetKfs_AttrEx_Mask_L[9] = TargetWuhun_Property9_Text
	TargetKfs_AttrEx_Mask_L[10] = TargetWuhun_Property10_Text
	--AttrEx value
	TargetKfs_AttrEx_Mask_R[1] = TargetWuhun_Property1
	TargetKfs_AttrEx_Mask_R[2] = TargetWuhun_Property2
	TargetKfs_AttrEx_Mask_R[3] = TargetWuhun_Property3
	TargetKfs_AttrEx_Mask_R[4] = TargetWuhun_Property4
	TargetKfs_AttrEx_Mask_R[5] = TargetWuhun_Property5
	TargetKfs_AttrEx_Mask_R[6] = TargetWuhun_Property6
	TargetKfs_AttrEx_Mask_R[7] = TargetWuhun_Property7
	TargetKfs_AttrEx_Mask_R[8] = TargetWuhun_Property8
	TargetKfs_AttrEx_Mask_R[9] = TargetWuhun_Property9
	TargetKfs_AttrEx_Mask_R[10] = TargetWuhun_Property10

	TargetKfs_AttrEx_Text[1] = TargetWuhun_Property1_Text_UnVisible;
	TargetKfs_AttrEx_Text[2] = TargetWuhun_Property2_Text_UnVisible;
	TargetKfs_AttrEx_Text[3] = TargetWuhun_Property3_Text_UnVisible;
	TargetKfs_AttrEx_Text[4] = TargetWuhun_Property4_Text_UnVisible;
	TargetKfs_AttrEx_Text[5] = TargetWuhun_Property5_Text_UnVisible;
	TargetKfs_AttrEx_Text[6] = TargetWuhun_Property6_Text_UnVisible;
	TargetKfs_AttrEx_Text[7] = TargetWuhun_Property7_Text_UnVisible;
	TargetKfs_AttrEx_Text[8] = TargetWuhun_Property8_Text_UnVisible;
	TargetKfs_AttrEx_Text[9] = TargetWuhun_Property9_Text_UnVisible;
	TargetKfs_AttrEx_Text[10] = TargetWuhun_Property10_Text_UnVisible;

	TargetKfs_AttrEx_Value[1] = TargetWuhun_Property1_UnVisible;
	TargetKfs_AttrEx_Value[2] = TargetWuhun_Property2_UnVisible;
	TargetKfs_AttrEx_Value[3] = TargetWuhun_Property3_UnVisible;
	TargetKfs_AttrEx_Value[4] = TargetWuhun_Property4_UnVisible;
	TargetKfs_AttrEx_Value[5] = TargetWuhun_Property5_UnVisible;
	TargetKfs_AttrEx_Value[6] = TargetWuhun_Property6_UnVisible;
	TargetKfs_AttrEx_Value[7] = TargetWuhun_Property7_UnVisible;
	TargetKfs_AttrEx_Value[8] = TargetWuhun_Property8_UnVisible;
	TargetKfs_AttrEx_Value[9] = TargetWuhun_Property9_UnVisible;
	TargetKfs_AttrEx_Value[10] = TargetWuhun_Property10_UnVisible;
	--Original five text
	TargetKfs_Base_Original_Text[1] = TargetWuhun_OriginalStr_Text
	TargetKfs_Base_Original_Text[2] = TargetWuhun_OriginalNimbus_Text
	TargetKfs_Base_Original_Text[3] = TargetWuhun_OriginalPhysicalStrength_Text
	TargetKfs_Base_Original_Text[4] = TargetWuhun_OriginalStability_Text
	TargetKfs_Base_Original_Text[5] = TargetWuhun_OriginalFootwork_Text
	--Original five value
	TargetKfs_Base_Value[1] = TargetWuhun_OriginalStr
	TargetKfs_Base_Value[2] = TargetWuhun_OriginalNimbus
	TargetKfs_Base_Value[3] = TargetWuhun_OriginalPhysicalStrength
	TargetKfs_Base_Value[4] = TargetWuhun_OriginalStability
	TargetKfs_Base_Value[5] = TargetWuhun_OriginalDexterity
	--five text
	TargetKfs_Base_Text[1] = TargetWuhun_Str_Text
	TargetKfs_Base_Text[2] = TargetWuhun_Nimbus_Text
	TargetKfs_Base_Text[3] = TargetWuhun_PhysicalStrength_Text
	TargetKfs_Base_Text[4] = TargetWuhun_Stability_Text
	TargetKfs_Base_Text[5] = TargetWuhun_Footwork_Text
	--five value 
	TargetKfs_Base_Original_Value[1] = TargetWuhun_Str
	TargetKfs_Base_Original_Value[2] = TargetWuhun_Nimbus
	TargetKfs_Base_Original_Value[3] = TargetWuhun_PhysicalStrength
	TargetKfs_Base_Original_Value[4] = TargetWuhun_Stability
	TargetKfs_Base_Original_Value[5] = TargetWuhun_Dexterity
	--skills
	TargetKfs_Skills[1] = TargetWuhun_Skill2
	TargetKfs_Skills[2] = TargetWuhun_Skill3
	TargetKfs_Skills[3] = TargetWuhun_Skill4
	
	 g_TargetWuhun_Frame_UnifiedPosition=TargetWuhun_Frame:GetProperty("UnifiedPosition");

	g_AttrNameCtrl[1] = TargetWuhun_BK4_Info2_Info1
	g_AttrNameCtrl[2] = TargetWuhun_BK4_Info2_Info2
	g_AttrNameCtrl[3] = TargetWuhun_BK4_Info2_Info3
	g_AttrNameCtrl[4] = TargetWuhun_BK4_Info2_Info4
	g_AttrNameCtrl[5] = TargetWuhun_BK4_Info2_Info5
	g_AttrNameCtrl[6] = TargetWuhun_BK4_Info2_Info6
	g_AttrNameCtrl[7] = TargetWuhun_BK4_Info2_Info7
	g_AttrNameCtrl[8] = TargetWuhun_BK4_Info2_Info8
	
	g_AttrValueCtrl[1] = TargetWuhun_BK4_Info2_Number1
	g_AttrValueCtrl[2] = TargetWuhun_BK4_Info2_Number2
	g_AttrValueCtrl[3] = TargetWuhun_BK4_Info2_Number3
	g_AttrValueCtrl[4] = TargetWuhun_BK4_Info2_Number4
	g_AttrValueCtrl[5] = TargetWuhun_BK4_Info2_Number5
	g_AttrValueCtrl[6] = TargetWuhun_BK4_Info2_Number6
	g_AttrValueCtrl[7] = TargetWuhun_BK4_Info2_Number7
	g_AttrValueCtrl[8] = TargetWuhun_BK4_Info2_Number8

	-- 分页按钮
	g_PageButton[1] = TargetWuhun_OtherEquip
	g_PageButton[2] = TargetWuhun_OtherData
	g_PageButton[3] = TargetWuhun_OtherPet
	g_PageButton[4] = TargetWuhun_TargetWuhun
	g_PageButton[5] = TargetWuhun_TargetLingyu
	g_PageButton[6] = TargetWuhun_TargetWeapon2
	g_PageButton[7] = TargetWuhun_TargetDWJinJie
	g_PageButton[8] = TargetWuhun_TargetPeak
	g_PageButton[9] = TargetWuhun_TargetProfile

end

function TargetWuhun_OnEvent(event)
	
	if event == "PLAYER_LEAVE_WORLD" then		
		this:Hide()
		return
	end
	
	if event == "OPEN_OTHERPLAYER_WUHUN" then
		
		if not CachedTarget:IsPresent(1) then
			return
		end
		
		if not ZBS:IsCanGetTargetEquip() then
			return
		end

		if not CachedTarget:CanGetTargetEquip() then
			PushDebugMessage ("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
			return
		end
		
		g_objCared = CachedTarget:GetData("NPCID", 1)
		if type(g_objCared) ~= "number" then
			PushDebugMessage ("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
			return
		end
		
		this:CareObject(g_objCared , 1)
		g_showPage = 0
		TargetWuhun_Update()
		this:Show()
	end
		
	if event == "OTHERPLAYER_UPDATE_EQUIP" and this:IsVisible() then
		Variable:SetVariable("SelfUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1)
		TargetWuhun_Update()
	end
		
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		TargetWuhun_Frame_On_ResetPos()
	end
end

--Update
function TargetWuhun_Update()
	--Tab
	TargetWuhun_TargetWuhun:SetCheck(1)
	TargetWuhun_Equip_Mask:Hide()
	--Pos
	local otherUnionPos = Variable:GetVariable("OtherUnionPos");
	if(otherUnionPos ~= nil) then
		TargetWuhun_Frame:SetProperty("UnifiedPosition", otherUnionPos);
	end
	--Title
	TargetWuhun_PageHeader:SetText("#gFF0FA0#{WH_xml_XX(95)}")
	
	TargetWuhun_Name:SetText("")
	local data = CachedTarget:GetKfsData("NAME")
	if data ~= nil then
		TargetWuhun_Name:SetText(tostring(data))
	end

	--ICON
	TargetWuhun_Equip:SetActionItem(-1)
	local ActionKFS = EnumAction(18, "targetequip")
	TargetWuhun_Equip:SetActionItem(ActionKFS:GetID());
	--Model
	TargetWuhun_FakeObject:SetFakeObject("");
	CachedTarget:UpdateOtherKFSModel();
	TargetWuhun_FakeObject:SetFakeObject("Other_Wuhun");
	
	--NeedLv
	--TargetWuhun_NeedLevel_Text:SetText("")	
	
	data = CachedTarget:GetKfsData("NEEDLEVEL")
	if data ~= nil then
	--	TargetWuhun_NeedLevel_Text:SetText(tostring(data))
	end
	
	--Lv
	TargetWuhun_Level_Text:SetText("")

	data = CachedTarget:GetKfsData("LEVEL")
	if data ~= nil then
		TargetWuhun_Level_Text:SetText(tostring(data))
	end
	
	--ExtraLevel
	TargetWuhun_ExtraLevel_Text:SetText("")	
	data = CachedTarget:GetKfsData("EXTRALEVEL")
	if data ~= nil then
		TargetWuhun_ExtraLevel_Text:SetText(tostring(data))
	end
	
	--AttactType
	TargetWuhun_Type_Text:SetText("")

	data = CachedTarget:GetKfsData("ATTACT")
	if data ~= nil and data < 5 and data >= 0 then
		TargetWuhun_Type_Text:SetText(TargetKfs_Att_tips[data + 1])
	end
	
	--Life
	TargetWuhun_Life_Text2:SetText("")

	data = CachedTarget:GetKfsData("LIFE")
	local maxLife = CachedTarget:GetKfsData("MAXLIFE")
	if data ~= nil then
		TargetWuhun_Life_Text2:SetText(tostring(data).."/"..tostring(maxLife))
	end
	
	--Exp
	TargetWuhun_Exp:SetText("#{WH_xml_XX(76)}")
	TargetWuhun_Exp_Text:SetText("")
	data = CachedTarget:GetKfsData("EXP")
	local needexp = CachedTarget:GetKfsData("NEEDEXP")
	if data ~= nil then
		TargetWuhun_Exp_Text:SetText(tostring(data).."/"..tostring(needexp))
	end
	
	--GrowRate
	TargetWuhun_Growth1:SetText("")
	TargetWuhun_Growth1:SetToolTip("")
	TargetWuhun_Growth:SetText("")
	TargetWuhun_Growth:SetToolTip("")
	local grade = CachedTarget:GetKfsData("Grade")
	data = CachedTarget:GetKfsData("GROW")
	if data ~= nil and grade ~= nil then
		TargetWuhun_Growth1:SetText("#{WH_xml_XX(93)}")
		TargetWuhun_Growth1:SetToolTip("#{WH_090729_43}")
	  if grade == 0 then
			TargetWuhun_Growth:SetText("#G#{ZSKSSJ_PT}"..tostring(data))
	  elseif grade  == 1 then
			 TargetWuhun_Growth:SetText("#G#{ZSKSSJ_YX}"..tostring(data))
	  elseif grade == 2 then
	   		TargetWuhun_Growth:SetText("#G#{ZSKSSJ_JC}"..tostring(data))
	  elseif grade == 3 then
	  		TargetWuhun_Growth:SetText("#G#{ZSKSSJ_ZY}"..tostring(data))
	  elseif grade == 4 then
	  		TargetWuhun_Growth:SetText("#G#{ZSKSSJ_WM}"..tostring(data))
	  end
	end
	
	--AttrEx
	local slot = CachedTarget:GetKfsData("SLOT")
	for i=1,TargetKfs_ATTREX_MAX_NUM do	
		
		TargetKfs_AttrEx_Text[i]:SetText("")
		TargetKfs_AttrEx_Value[i]:SetText("")
		
		if slot ~= nil and i <= slot then
			TargetKfs_AttrEx_Text[i]:Show()
			TargetKfs_AttrEx_Value[i]:Show()
		else
			TargetKfs_AttrEx_Text[i]:Hide()
			TargetKfs_AttrEx_Value[i]:Hide()
		end
		
		local iText , iValue = CachedTarget:GetKfsFixAttrEx(i - 1)
		if iText ~= nil and iText ~= "" and iValue ~= nil and iValue > 0  then
			TargetKfs_AttrEx_Text[i]:SetText(iText)
			TargetKfs_AttrEx_Value[i]:SetText("+"..tostring(iValue))
		end
	end
	
	--BaseAttr
	for i=1,5 do	
		TargetKfs_Base_Original_Value[i]:SetText("")
		TargetKfs_Base_Value[i]:SetText("")

		data = CachedTarget:GetKfsBase(i - 1)
		if data ~= nil then
			TargetKfs_Base_Original_Value[i]:SetText("+"..tostring(data))
		end

		data = CachedTarget:GetFixKfsBase(i - 1)
		if data ~= nil then
			TargetKfs_Base_Value[i]:SetText("+"..tostring(data))
		end
	end
	
	--SKills
	TargetKfs_Skills[1]:SetActionItem(-1)
	TargetKfs_Skills[2]:SetActionItem(-1)
	TargetKfs_Skills[3]:SetActionItem(-1)

	local kfsID = -1
	if ActionKFS:GetID() ~= 0 then
		kfsID = ActionKFS:GetItemID();
	end
			
	for i=1, 3 do
		local theAction = EnumAction(kfsID * 3 + i -1 , "kfsskill");
		if theAction:GetID() ~= 0 then
			TargetKfs_Skills[i]:SetActionItem(theAction:GetID());
		end
	end

	TargetWuhun_UpdateTupu()
	TargetWuhun_UpdateSlot()
	
	if g_showPage == 0 then
		TargetWuhun_Page1:SetCheck(1)
		TargetWuhun_Page2:SetCheck(0)
		TargetWuhun_Page1Client:Show()
		TargetWuhun_Page2Client:Hide()
	else
		TargetWuhun_Page1:SetCheck(0)
		TargetWuhun_Page2:SetCheck(1)
		TargetWuhun_Page1Client:Hide()
		TargetWuhun_Page2Client:Show()
	end
	
	local otherLevel = CachedTarget:GetData("LEVEL", 1)
	if otherLevel < 80 then
		TargetWuhun_Page2:SetToolTip("#{WH_210223_198}")
	else
		TargetWuhun_Page2:SetToolTip("")
	end
		
	--页签
	TargetWuhun_ShowPage()
	
end

function TargetWuhun_UpdateSlot()

	TargetWuhun_BK4_Tupu1_Mask:Hide()
	TargetWuhun_BK4_Tupu2_Mask:Hide()
	
	TargetWuhun_BK4_Tupu1:SetActionItem(-1)
	TargetWuhun_BK4_Tupu2:SetActionItem(-1)
	
	TargetWuhun_BK4_Tupu1:SetProperty("Empty", "False")
	TargetWuhun_BK4_Tupu2:SetProperty("Empty", "False")
	
	TargetWuhun_BK4_Tupu1:SetToolTip("")
	TargetWuhun_BK4_Tupu2:SetToolTip("")
	
	local bHaveKfs = 1
	local comLevel = CachedTarget:GetKfsData("EXTRALEVEL")
	if tonumber(comLevel) == nil then
		bHaveKfs = 0
	end
	
	local life = CachedTarget:GetKfsData("LIFE")
	if tonumber(life) == nil then
		bHaveKfs = 0
		end
	
	local yangWg = CachedTarget:LuaFnGetWHWGInSlot(0)
	local yinWg = CachedTarget:LuaFnGetWHWGInSlot(1)
	local attr_count = DataPool:LuaFnGetOtherWHWGAllAttrCount()
	
	local isValid = 1
	TargetWuhun_BK4_Info3:SetText("")

	local errColor = "#cff0000"
	if isValid == 1 then
		errColor = "#cfff263"
	end
	
	local otherLevel = CachedTarget:GetData("LEVEL", 1)
	
	local strYangEffect = ""
	local strYangValue = ""
	
	local strYinEffect = ""
	local strYinValue = ""
	
	if yangWg > 0 then
		local theAction = EnumAction(yangWg, "other_whwg")
		if theAction:GetID() ~= 0 then
			TargetWuhun_BK4_Tupu1:SetActionItem(theAction:GetID())
		end
		
		local strName = CachedTarget:LuaFnGetWHWGInfo(yangWg, "Name")
		local grade = CachedTarget:LuaFnGetWHWGInfo(yangWg, "Grade")
		local level = CachedTarget:LuaFnGetWHWGInfo(yangWg, "Level")
		
		local strYang, strYin, strFree = DataPool:LuaFnWHWGAttrSTR(yangWg, grade, level)
		
		local effectType, strValue, _, _ = DataPool:LuaFnWHWGEffect(yangWg, grade, level)
		if effectType ~= nil and effectType >= 0 and effectType <= 5 then
			strYangEffect = ScriptGlobal_Format("#{WH_210311_04}", g_EffectDic[effectType + 1])
			strYangValue = strValue
		end
	else		
		TargetWuhun_BK4_Tupu1:SetProperty("NormalImage", "")
		TargetWuhun_BK4_Tupu1:SetProperty("UseDefaultTooltip", "True")
		if otherLevel < 80 then
			TargetWuhun_BK4_Tupu1:SetToolTip("#{WH_210223_197}")
		else
		TargetWuhun_BK4_Tupu1:SetToolTip("#{WH_210223_17}")
		end
	end
	
	if yinWg > 0 then
		local theAction = EnumAction(yinWg, "other_whwg")
		if theAction:GetID() ~= 0 then
			TargetWuhun_BK4_Tupu2:SetActionItem(theAction:GetID())
	end
		
		local strName = CachedTarget:LuaFnGetWHWGInfo(yinWg, "Name")
		local grade = CachedTarget:LuaFnGetWHWGInfo(yinWg, "Grade")
		local level = CachedTarget:LuaFnGetWHWGInfo(yinWg, "Level")
		
		local strYang, strYin, strFree = DataPool:LuaFnWHWGAttrSTR(yinWg, grade, level)
		
		local _, _, effectType, strValue = DataPool:LuaFnWHWGEffect(yinWg, grade, level)
		if effectType ~= nil and effectType >= 0 and effectType <= 5 then
			strYinEffect = ScriptGlobal_Format("#{WH_210311_05}", g_EffectDic[effectType + 1])
			strYinValue = strValue
		end
	else		
		TargetWuhun_BK4_Tupu2:SetProperty("NormalImage", "")
		TargetWuhun_BK4_Tupu2:SetProperty("UseDefaultTooltip", "True")
		if otherLevel < 80 then
			TargetWuhun_BK4_Tupu2:SetToolTip("#{WH_210223_197}")
		else
		TargetWuhun_BK4_Tupu2:SetToolTip("#{WH_210223_17}")
		end	
	end
	
	local nowIndex = 1
	for i = 1, 8 do
		local strAttr, strValue = DataPool:LuaFnGetOtherWHWGAllAttrDesc(i - 1)
		
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

function TargetWuhun_UpdateTupu()
	
	DataPool:LuaFnInitWHWGList()
	local nCount = DataPool:LuaFnGetWHWGListCount()
	
	local yangWg = CachedTarget:LuaFnGetWHWGInSlot(0)
	local yinWg = CachedTarget:LuaFnGetWHWGInSlot(1)
	
	for idx = 1, 6 do
		
		g_TupuBtn[idx]:SetProperty("DraggingEnabled", "False")
		
		if idx <= nCount then	
			local wgID = DataPool:LuaFnGetWHWGIDFromList(idx - 1)
			local nUnLocked = CachedTarget:LuaFnGetWHWGInfo(wgID, "UnLocked")
			local nLevel = CachedTarget:LuaFnGetWHWGInfo(wgID, "Level")
			local nGrade = CachedTarget:LuaFnGetWHWGInfo(wgID, "Grade")
			local strName = CachedTarget:LuaFnGetWHWGInfo(wgID, "Name")
		
			--激活锁
			if nUnLocked == 1 then
				g_TupuMask[idx]:Hide()
			else
				g_TupuMask[idx]:Show()
			end

			g_TupuBtn[idx]:SetActionItem(-1)
			local theAction = EnumAction(wgID, "other_whwg")
			if theAction:GetID() ~= 0 then
				g_TupuBtn[idx]:SetActionItem(theAction:GetID())
			end
		else
			g_TupuBtn[idx]:SetActionItem(-1)
			g_TupuMask[idx]:Hide()
		end
	end

end

function TargetWuhun_SwitchRightPage(index)
	
	isYYClicked = 1
	
	if g_showPage == index then
		isYYClicked = 0
		return
	end
	
	if index == 1 then
		local otherLevel = CachedTarget:GetData("LEVEL", 1)
		if otherLevel < 80 then
			PushDebugMessage("#{WH_210223_213}")
			isYYClicked = 0
			return 
		end		
	end

	g_showPage = index
	
	if g_showPage == 0 then
		TargetWuhun_Page1:SetCheck(1)
		TargetWuhun_Page2:SetCheck(0)
		TargetWuhun_Page1Client:Show()
		TargetWuhun_Page2Client:Hide()
	else
		TargetWuhun_Page1:SetCheck(0)
		TargetWuhun_Page2:SetCheck(1)
		TargetWuhun_Page1Client:Hide()
		TargetWuhun_Page2Client:Show()
	end
end

function TargetWuhun_UpdateSwitch()
	
	if isYYClicked == 1 then
		isYYClicked = 0
		return
	end
	
	if g_showPage == 0 then
		TargetWuhun_Page1:SetCheck(1)
		TargetWuhun_Page2:SetCheck(0)
	else
		TargetWuhun_Page1:SetCheck(0)
		TargetWuhun_Page2:SetCheck(1)
	end
end

function TargetWuhun_TupuItemClicked()

end

--model turn left
function TargetWuhun_Model_TurnLeft(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetWuhun_FakeObject:RotateBegin(-0.3);
	--stop
	else
		TargetWuhun_FakeObject:RotateEnd();
	end
end

--model turn right
function TargetWuhun_Model_TurnRight(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetWuhun_FakeObject:RotateBegin(0.3);
	--stop
	else
		TargetWuhun_FakeObject:RotateEnd();
	end
end

--kfs hidden event
function TargetWuhun_OnHiden()
	TargetWuhun_FakeObject:SetFakeObject("");	
end


function TargetWuhun_ShowPage()

	for i = 1, 9 do
		g_PageButton[i]:Hide()
	end
		
	local nPageNumber = tonumber(Variable:GetVariable("TargetPageNumber"));
	TargetWuhun_ClearPage()
	
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
		if TargetWuhun_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)
			g_PageOrder[g_PageCount] = i
		end
	end
end

function TargetWuhun_CheckPage(idx)
	if idx == 1 then--装备
		return 1
	elseif idx == 2 then--资料
		return 1
	elseif idx == 3 then--珍兽
		return 1
	elseif idx == 4 then--武魂
		return 1
	elseif idx == 5 then--灵玉
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 6 then--神兵
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 7 then--雕文进阶
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 8 then--巅峰 
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 9 then--个人
		return 1

	end
	return 0
end

function TargetWuhun_ClearPage()
	Variable:SetVariable("TargetPageNumber", tostring(0), 1)
end
function TargetWuhun_OtherDFeng_Switch()
	-- if ZBS:IsZBSFinalDFengBanFlag() == 1 then
		-- PushDebugMessage("#{WCBZ_250812_1}")
	    -- return 0
	-- end
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 85 then
		PushDebugMessage("#{DFJC_250709_83}")
		TargetWuhun_TargetPeak:SetCheck(0)
		TargetWuhun_ClearPage()
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1)
	-- SystemSetup:Lua_OpenDFengOther
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
function TargetWuhun_OnPageClicked(idx)

	Variable:SetVariable("TargetPageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]

	if idx == 1 then--装备
		TargetWuhun_OtherEquip_Page_Switch()
	elseif idx == 2 then--资料
		TargetWuhun_OtherData_Page_Switch()
	elseif idx == 3 then--珍兽
		TargetWuhun_OtherPet_Page_Switch()
	elseif idx == 4 then--武魂
		TargetWuhun_ClearPage()
	elseif idx == 5 then--灵玉
		TargetWuhun_TargetLingyu_Switch()
	elseif idx == 6 then--神兵
		TargetWuhun_ShenBing_Switch()
	elseif idx == 7 then--雕文进阶
		TargetWuhun_DWJinJie_Switch()
	elseif idx == 8 then
		TargetWuhun_OtherDFeng_Switch()
	elseif idx == 9 then
		TargetWuhun_OtherProfile_Switch()
	end
end


--============================================================================================================
-- 打开玩家信息界面
function TargetWuhun_OtherData_Page_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end
-- 打开玩家装备UI
function TargetWuhun_OtherEquip_Page_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenEquipFrame("other");
end
-- 打开玩家宠物UI
function TargetWuhun_OtherPet_Page_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end

function TargetWuhun_TargetLingyu_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherLingYuPage()
end

function TargetWuhun_ShenBing_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherShenBingPage()
end

function TargetWuhun_DWJinJie_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherFeaturesPage()
end

function TargetWuhun_OtherProfile_Switch()
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		TargetWuhun_TargetProfile:SetCheck(0)
		TargetWuhun_ClearPage()
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
end

function TargetWuhun_Frame_On_ResetPos()
  TargetWuhun_Frame:SetProperty("UnifiedPosition", g_TargetWuhun_Frame_UnifiedPosition);
end