--!!!reloadscript =Weapon2

local g_Weapon2_Frame_UnifiedPosition

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

local g_SkillAction = {}
local g_SkillActionLock = {}
local g_ExtensionText = {}

function Weapon2_PreLoad()
	--open or close this window
	this:RegisterEvent("TOGGLE_SHENBING_PAGE")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	--update equip
	this:RegisterEvent("REFRESH_EQUIP", false)
	this:RegisterEvent("UNIT_LEVEL", false)

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("UPDATE_EXTERIOR_TIP")
	
	this:RegisterEvent("UPDATE_CURRENT_LINGYU_PLAN")
	this:RegisterEvent("SKILL_UPDATE")
end

function Weapon2_OnLoad()
	g_Weapon2_Frame_UnifiedPosition	= Weapon2_Frame:GetProperty("UnifiedPosition")
	
	g_PageButton[1] = Weapon2_SelfEquip
	g_PageButton[2] = Weapon2_SelfData
	g_PageButton[3] = Weapon2_Pet
	g_PageButton[4] = Weapon2_Lingyu
	g_PageButton[5] = Weapon2_Xiulian
	g_PageButton[6] = Weapon2_Talent
	g_PageButton[7] = Weapon2_Lingyu
	g_PageButton[8] = Weapon2_Weapon2
	g_PageButton[9] = Weapon2_DWJinJie
	g_PageButton[10] = Weapon2_Peak
	g_PageButton[11] = Weapon2_Profile
	g_PageButton[12] = Weapon2_OtherInfo

	
	g_PageMask[1] = Weapon2_SelfEquip_Mask
	g_PageMask[2] = Weapon2_SelfData_Mask
	g_PageMask[3] = Weapon2_Pet_Mask
	g_PageMask[4] = Weapon2_Lingyu_Mask
	g_PageMask[5] = Weapon2_Xiulian_Mask
	g_PageMask[6] = Weapon2_Talent_Mask
	g_PageMask[7] = Weapon2_Lingyu_Mask
	g_PageMask[8] = Weapon2_Weapon2_Mask
	g_PageMask[9] = Weapon2_DWJinJie_Mask
	g_PageMask[10] = Weapon2_Peak_Mask
	g_PageMask[11] = Weapon2_Profile_Mask
	g_PageMask[12] = Weapon2_OtherInfo_Mask
	

	g_PageTip[1] = Weapon2_SelfEquip_tips
	g_PageTip[2] = Weapon2_SelfData_tips
	g_PageTip[3] = Weapon2_Pet_tips
	g_PageTip[4] = Weapon2_Wuhun_tips
	g_PageTip[5] = Weapon2_Xiulian_tips
	g_PageTip[6] = Weapon2_Talent_tips
	g_PageTip[7] = Weapon2_Lingyu_tips
	g_PageTip[8] = Weapon2_Weapon2_tips
	g_PageTip[9] = Weapon2_DWJinJie_tips
	g_PageTip[10] = Weapon2_Peak_tips
	g_PageTip[11] = Weapon2_Profile_tips
	g_PageTip[12] = Weapon2_OtherInfo_tips
	

	g_SkillAction[1] = Weapon2_BK4_FirstSkill
	g_SkillAction[2] = Weapon2_BK4_Skill1
	g_SkillAction[3] = Weapon2_BK4_Skill2
	g_SkillAction[4] = Weapon2_BK4_Skill3
	g_SkillAction[5] = Weapon2_BK4_Skill4
	g_SkillAction[6] = Weapon2_BK4_Skill5
	g_SkillAction[7] = Weapon2_BK4_Skill6
	
	g_SkillActionLock[1] = nil
	g_SkillActionLock[2] = Weapon2_BK4_Skill1Lock
	g_SkillActionLock[3] = Weapon2_BK4_Skill2Lock
	g_SkillActionLock[4] = Weapon2_BK4_Skill3Lock
	g_SkillActionLock[5] = Weapon2_BK4_Skill4Lock
	g_SkillActionLock[6] = Weapon2_BK4_Skill5Lock
	g_SkillActionLock[7] = Weapon2_BK4_Skill6Lock
	
	g_ExtensionText[1] = Weapon2_BK2_Info2_Text1
	g_ExtensionText[2] = Weapon2_BK2_Info2_Text2
	g_ExtensionText[3] = Weapon2_BK2_Info2_Text3
	g_ExtensionText[4] = Weapon2_BK2_Info2_Text4
	g_ExtensionText[5] = Weapon2_BK2_Info2_Text5
	g_ExtensionText[6] = Weapon2_BK2_Info2_Text6
end

function Weapon2_OnEvent(event)

	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end
	
	if event == "TOGGLE_SHENBING_PAGE" then
		
		if this:IsVisible() then
			this:Hide()
			return
		end
		
		Weapon2_ShowPage()
		Weapon2_Update()
		Weapon2_OnShown()
		this:Show()
		Weapon2_UpdateRedPoint()
		return
	end
	
	if event == "REFRESH_EQUIP" and this:IsVisible() then
		Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
		Weapon2_Update()
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		Weapon2_Frame_On_ResetPos()
	end

	if event == "UNIT_LEVEL" and this:IsVisible() then
		Weapon2_Update()	
	end
	
	if event == "UPDATE_CURRENT_LINGYU_PLAN" and this:IsVisible() then
		Weapon2_Update()	
	end
	
	if event == "UPDATE_EXTERIOR_TIP" and this:IsVisible() then
		Weapon2_UpdateRedPoint()
	end
	
	if event == "SKILL_UPDATE" and this:IsVisible() then
		if DataPool:LuaFnIsEquipShenBing() == 1 then
			local core_skill_id = DataPool:LuaFnGetEquipedShenBingData("CORESKILL")
			local nSumSkill = GetActionNum("skill")
			for i = 1, nSumSkill do
				local theSkillAction = EnumAction(i - 1, "skill")
				if theSkillAction:GetDefineID() == core_skill_id then			
					Weapon2_BK4_FirstSkill:SetProperty("UseDefaultTooltip", "False")
					Weapon2_BK4_FirstSkill:SetActionItem(theSkillAction:GetID())
				end
			end
		end
		return
	end
end

--Update
function Weapon2_Update()
	--Tab
	Weapon2_Weapon2:SetCheck(1)
	
	if DataPool:LuaFnIsEquipShenBing() == 1 then
	
		Weapon2_FakeObject:SetFakeObject("")
		DataPool:LuaFnUpdateShenBingModel()
		Weapon2_FakeObject:SetFakeObject("Self_ShenBing")
		
		local sb_action = EnumAction(37, "equip")
		Weapon2_Equip:SetActionItem(sb_action:GetID())
		if sb_action:GetEquipDur() < 0.1 then
			Weapon2_Equip_Mask:Show()
		else
			Weapon2_Equip_Mask:Hide()
		end
		
		local sb_id = DataPool:LuaFnGetEquipedShenBingData("ID")
		local sb_level = DataPool:LuaFnGetEquipedShenBingData("LEVEL")

		local sb_star = DataPool:LuaFnGetEquipedShenBingData("STAR")
		
		DataPool:LuaFnUpdateShenBingCamera("Self_ShenBing", sb_id)
		
		local strStar = ScriptGlobal_Format("#{SBFW_20230707_59}", tostring(sb_star))
		Weapon2_Grade_Text:SetText(tostring(strStar))
		
		local stLevel = ScriptGlobal_Format("#{SBFW_20230707_60}", tostring(sb_level))
		Weapon2_Level_Text2:SetText(tostring(stLevel))
		
		local core_skill_time = DataPool:LuaFnGetEquipedShenBingData("CORESKILLTIME")
		local strTime = ScriptGlobal_Format("#{SBFW_20230707_183}", tostring(core_skill_time))
		Weapon2_Time_Text2:SetText(strTime)
		
		local sb_name = DataPool:LuaFnGetItemNameByTableIndex(sb_id)
		Weapon2_Name:SetText(tostring(sb_name))
		
		for i = 2, 7 do
			local skill_action = DataPool:LuaFnEnumEquipShenBingSkillAction(i - 1)
			g_SkillAction[i]:SetActionItem(skill_action:GetID())
			g_SkillAction[i]:SetProperty("DraggingEnabled", "False")
			g_SkillActionLock[i]:Hide()
			if i >= 5 and i <= 7 then
				local skill_active = DataPool:LuaFnGetEquipedShenBingData("SKILL_LOCK", i - 5)
				if skill_active ~= 1 then
					g_SkillActionLock[i]:Show()
				end
			end
		end
		
		local fix_rate, valid_count = DataPool:LuaFnGetEquipedShenBingStarInfo()

		for i = 1, 6 do
			g_ExtensionText[i]:SetText("")
			local attr_id, attr_value = DataPool:LuaFnGetShenBingExtensionAttr(i - 1)

			if tonumber(attr_value) ~= nil and tonumber(attr_value) > 0 then
				local attr_name, attr_value_string = DataPool:LuaFnGetAttributeDesc(tonumber(attr_id), tonumber(attr_value))
				
				if i > valid_count then
					local show_text = "#c605C4F"..tostring(attr_name).." +"..tostring(attr_value_string)				
					g_ExtensionText[i]:SetText(show_text)
				else
					local show_text = "#cffcc00"..tostring(attr_name).." +"..tostring(attr_value_string)
					g_ExtensionText[i]:SetText(show_text)
				end
			end
		end
		
		local core_skill_id = DataPool:LuaFnGetEquipedShenBingData("CORESKILL")

		local nSumSkill = GetActionNum("skill")
		for i = 1, nSumSkill do
			local theSkillAction = EnumAction(i - 1, "skill")
			if theSkillAction:GetDefineID() == core_skill_id then			
				Weapon2_BK4_FirstSkill:SetProperty("UseDefaultTooltip", "False")
				Weapon2_BK4_FirstSkill:SetActionItem(theSkillAction:GetID())
			end
		end

	else
		Weapon2_FakeObject:SetFakeObject("")
		Weapon2_Equip:SetActionItem(-1)
		Weapon2_Equip_Mask:Hide()
		
		Weapon2_Grade_Text:SetText("")
		Weapon2_Level_Text2:SetText("")
		Weapon2_Time_Text2:SetText("")
		Weapon2_Name:SetText("")
		
		for i = 2, 7 do
			g_SkillAction[i]:SetActionItem(-1)
			g_SkillAction[i]:SetProperty("DraggingEnabled", "False")
			g_SkillActionLock[i]:Hide()
		end
		
		for i = 1, 6 do
			g_ExtensionText[i]:SetText("")
		end
		
		Weapon2_BK4_FirstSkill:SetActionItem(-1)
	end
	
end

function Weapon2_Equip_Clicked(buttonIn)
	local button = tonumber(buttonIn)
	if button == 1 then
		Weapon2_Equip:DoAction()
	else
		Weapon2_Equip:DoSubAction()
	end
end

function Weapon2_OnShown()
	local selfUnionPos = Variable:GetVariable("SelfUnionPos")
	if selfUnionPos ~= nil then
		Weapon2_Frame:SetProperty("UnifiedPosition", selfUnionPos)
	end
end

function Weapon2_OnHiden()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
	
	Weapon2_FakeObject:SetFakeObject("")
end

--player's equip
function Weapon2_Page_SelfEquip()
	Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
	OpenEquip(1)
end

--player's info
function Weapon2_Page_SelfData()
	Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPrivatePage("self")
end

--player's pet
function Weapon2_Page_Pet()
	Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePetPage()
end

function Weapon2_Page_Wuhun()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		SelfEquip_Wuhun : SetCheck(0)
		SelfEquip_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1);	
	ToggleWuhunPage();
end

--xiu lian
function Weapon2_Page_Xiulian()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		return
	end
	
    local nLevel = Player:GetData("LEVEL")
	if nLevel >= 70 then
		Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
		XiuLianPage()
	else
	    Weapon2_Xiulian:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    Weapon2_ClearPage()
	end
end

function Weapon2_Page_Talent()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
		ToggleTalentPage()
	else
		Weapon2_Talent:SetCheck(0)
		Weapon2_ClearPage()
	end
end

function Weapon2_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		Weapon2_Lingyu:SetCheck(0)
		Weapon2_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function Weapon2_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		Weapon2_DWJinJie:SetCheck(0)
		Weapon2_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end

--切换个人牴示界面
function Weapon2_Page_Profile()
	Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1);
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
end

--player's other info
function Weapon2_Page_OtherInfo()
	Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
	OtherInfoPage()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Weapon2_Frame_On_ResetPos()
	Weapon2_Frame:SetProperty("UnifiedPosition", g_Weapon2_Frame_UnifiedPosition)
end

function Weapon2_ShowPage()
	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"))
	Weapon2_ClearPage()
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
		if Weapon2_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if Weapon2_IsPageEnable(i) == 1 then
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

function Weapon2_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1)
	idx = g_PageOrder[idx]
	if idx == 1 then--??
		Weapon2_Page_SelfEquip()
	elseif idx == 2 then--??
		Weapon2_Page_SelfData()
	elseif idx == 3 then--??
		Weapon2_Page_Pet()
	elseif idx == 4 then--??
		Weapon2_Page_Wuhun()
	elseif idx == 5 then--??
		Weapon2_Page_Xiulian()
	elseif idx == 6 then--??
		Weapon2_Page_Talent()
	elseif idx == 7 then--??
		Weapon2_Page_LingYu()
	elseif idx == 8 then--??
		Weapon2_ClearPage()
	elseif idx == 9 then--????
		Weapon2_Page_DWJinJie()
	elseif idx == 10 then--??
		Weapon2_Page_Peak()
	elseif idx == 11 then--??
		Weapon2_Page_Profile()
	elseif idx == 12 then--??
		Weapon2_Page_OtherInfo()
	end
end

function Weapon2_CheckPage(idx)
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
		return 1
	elseif idx == 10 then--??
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

function Weapon2_IsPageEnable(idx)
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

function Weapon2_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--更新分页红点
function Weapon2_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function Weapon2_Model_TurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Weapon2_FakeObject:RotateBegin(-0.3)
	--stop
	else
		Weapon2_FakeObject:RotateEnd()
	end
end

function Weapon2_Model_TurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Weapon2_FakeObject:RotateBegin(0.3)
	--stop
	else
		Weapon2_FakeObject:RotateEnd()
	end
end

function Weapon2_Jian_Clicked()
	LuaFnOpenShenBingExhibition()
end

function Weapon2_Page_Peak()
	Variable:SetVariable("SelfUnionPos", Weapon2_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	this:Hide();
end
