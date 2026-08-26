--!!!reloadscript =TargetWeapon2

local g_TargetWeapon2_Frame_UnifiedPosition

local g_SkillAction = {}
local g_SkillActionLock = {}
local g_ExtensionText = {}

function TargetWeapon2_PreLoad()
	--open or close this window
	this:RegisterEvent("TOGGLE_OTHER_SHENBING_PAGE")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	--update equip
	this:RegisterEvent("OTHERPLAYER_UPDATE_EQUIP")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function TargetWeapon2_OnLoad()
	g_TargetWuhun_Frame_UnifiedPosition = TargetWeapon2_Frame:GetProperty("UnifiedPosition")
	
	g_SkillAction[1] = TargetWeapon2_BK4_FirstSkill
	g_SkillAction[2] = TargetWeapon2_BK4_Skill1
	g_SkillAction[3] = TargetWeapon2_BK4_Skill2
	g_SkillAction[4] = TargetWeapon2_BK4_Skill3
	g_SkillAction[5] = TargetWeapon2_BK4_Skill4
	g_SkillAction[6] = TargetWeapon2_BK4_Skill5
	g_SkillAction[7] = TargetWeapon2_BK4_Skill6
	
	g_SkillActionLock[1] = nil
	g_SkillActionLock[2] = TargetWeapon2_BK4_Skill1Lock
	g_SkillActionLock[3] = TargetWeapon2_BK4_Skill2Lock
	g_SkillActionLock[4] = TargetWeapon2_BK4_Skill3Lock
	g_SkillActionLock[5] = TargetWeapon2_BK4_Skill4Lock
	g_SkillActionLock[6] = TargetWeapon2_BK4_Skill5Lock
	g_SkillActionLock[7] = TargetWeapon2_BK4_Skill6Lock
	
	g_ExtensionText[1] = TargetWeapon2_BK2_Info2_Text1
	g_ExtensionText[2] = TargetWeapon2_BK2_Info2_Text2
	g_ExtensionText[3] = TargetWeapon2_BK2_Info2_Text3
	g_ExtensionText[4] = TargetWeapon2_BK2_Info2_Text4
	g_ExtensionText[5] = TargetWeapon2_BK2_Info2_Text5
	g_ExtensionText[6] = TargetWeapon2_BK2_Info2_Text6
end

function TargetWeapon2_OnEvent(event)
	
	if event == "PLAYER_LEAVE_WORLD" then		
		this:Hide()
		return
	end
	
	if event == "TOGGLE_OTHER_SHENBING_PAGE" then
		if this:IsVisible() then
			this:Hide()
			return
		end
	
		if not CachedTarget:IsPresent(1) then
			return
		end

		if not ZBS:IsCanGetTargetEquip() then
			return
		end
		
		if not CachedTarget:CanGetTargetEquip() then
			PushDebugMessage("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
			return
		end
		
		local objCared = CachedTarget:GetData("NPCID", 1)
		if type(objCared) ~= "number" then
			PushDebugMessage ("#{JSCK_90507_1}")			-- 距离该玩家太远，无法查看资料。
			return
		end
		
		this:CareObject(objCared , 1)
		TargetWeapon2_OnShown()
		TargetWeapon2_Update()
		this:Show()
	end
		
	if event == "OTHERPLAYER_UPDATE_EQUIP" and this:IsVisible() then
		Variable:SetVariable("SelfUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1)
		TargetWeapon2_Update()
	end
		
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		TargetWeapon2_Frame_On_ResetPos()
	end
end

--Update
function TargetWeapon2_Update()
	--Tab
	TargetWeapon2_TargetWeapon2:SetCheck(1)
	
	if DataPool:LuaFnOtherIsEquipShenBing() == 1 then
	
		TargetWeapon2_FakeObject:SetFakeObject("")
		DataPool:LuaFnUpdateOtherShenBingModel()
		TargetWeapon2_FakeObject:SetFakeObject("Other_ShenBing")
		
		local sb_action = EnumAction(37, "targetequip")
		TargetWeapon2_Equip:SetActionItem(sb_action:GetID())
		if sb_action:GetEquipDur() < 0.1 then
			TargetWeapon2_Equip_Mask:Show()
		else
			TargetWeapon2_Equip_Mask:Hide()
		end
		
		local sb_id = DataPool:LuaFnOtherGetEquipedShenBingData("ID")
		local sb_level = DataPool:LuaFnOtherGetEquipedShenBingData("LEVEL")
		local sb_star = DataPool:LuaFnOtherGetEquipedShenBingData("STAR")
		
		DataPool:LuaFnUpdateShenBingCamera("Other_ShenBing", sb_id)
		
		local strStar = ScriptGlobal_Format("#{SBFW_20230707_59}", tostring(sb_star))
		TargetWeapon2_Grade_Text:SetText(tostring(strStar))
		
		local stLevel = ScriptGlobal_Format("#{SBFW_20230707_60}", tostring(sb_level))
		TargetWeapon2_Level_Text2:SetText(tostring(stLevel))
		
		local core_skill_time = DataPool:LuaFnOtherGetEquipedShenBingData("CORESKILLTIME")
		local strTime = ScriptGlobal_Format("#{SBFW_20230707_183}", tostring(core_skill_time))
		TargetWeapon2_Time_Text2:SetText(strTime)
		
		local sb_name = DataPool:LuaFnGetItemNameByTableIndex(sb_id)
		TargetWeapon2_Name:SetText(tostring(sb_name))
		
		for i = 1, 7 do
			local skill_action = DataPool:LuaFnOtherEnumEquipShenBingSkillAction(i - 1)
			g_SkillAction[i]:SetActionItem(skill_action:GetID())
			g_SkillAction[i]:SetProperty("DraggingEnabled", "False")
			if i ~= 1 then
				g_SkillActionLock[i]:Hide()
			end
			if i >= 5 and i <= 7 then
				local skill_active = DataPool:LuaFnOtherGetEquipedShenBingData("SKILL_LOCK", i - 5)
				if skill_active ~= 1 then
					g_SkillActionLock[i]:Show()
				end
			end
		end
		
		local fix_rate, valid_count = DataPool:LuaFnGetOtherEquipedShenBingStarInfo()
		
		for i = 1, 6 do
			g_ExtensionText[i]:SetText("")
			local attr_id, attr_value = DataPool:LuaFnGetOtherShenBingExtensionAttr(i - 1)

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
	else
		TargetWeapon2_FakeObject:SetFakeObject("")
		TargetWeapon2_Equip:SetActionItem(-1)
		TargetWeapon2_Equip_Mask:Hide()

		TargetWeapon2_Grade_Text:SetText("")
		TargetWeapon2_Level_Text2:SetText("")
		TargetWeapon2_Time_Text2:SetText("")
		TargetWeapon2_Name:SetText("")
		
		for i = 1, 7 do
			g_SkillAction[i]:SetActionItem(-1)
			g_SkillAction[i]:SetProperty("DraggingEnabled", "False")
			if i ~= 1 then
				g_SkillActionLock[i]:Hide()
			end
		end
		
		for i = 1, 6 do
			g_ExtensionText[i]:SetText("")
		end
	end
end

function TargetWeapon2_OnShown()
	local otherUnionPos = Variable:GetVariable("OtherUnionPos")
	if otherUnionPos ~= nil then
		TargetWeapon2_Frame:SetProperty("UnifiedPosition", otherUnionPos)
	end
end

function TargetWeapon2_OnHiden()
	TargetWeapon2_FakeObject:SetFakeObject("")
end

-- 打开玩家装备UI
function TargetWeapon2_TargetEquip_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(1), 1)
	Variable:SetVariable("OtherUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenEquipFrame("other")
end

-- 打开玩家信息界面
function TargetWeapon2_TargetData_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(2), 1)
	Variable:SetVariable("OtherUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end

-- 打开玩家宠物UI
function TargetWeapon2_OtherPet_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(3), 1)
	Variable:SetVariable("OtherUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end

function TargetWeapon2_TargetWuhun_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(4), 1)
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		TargetWeapon2_TargetWuhun:SetCheck(0)
		return
	end
	
	Variable:SetVariable("OtherUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherWuhun()
end

function TargetWeapon2_TargetLingyu_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(5), 1)
	Variable:SetVariable("OtherUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherLingYuPage()
end

function TargetWeapon2_ShenBing_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(6), 1)
	Variable:SetVariable("OtherUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherShenBingPage()
end

function TargetWeapon2_DWJinJie_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(7), 1)
	Variable:SetVariable("OtherUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherFeaturesPage()
end

function TargetWeapon2_TargetProfile_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(9), 1)
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		TargetWeapon2_TargetProfile:SetCheck(0)
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
end

function TargetWeapon2_OnPageClicked(idx)

	Variable:SetVariable("TargetPageNumber", tostring(idx), 1);
end


function TargetWeapon2_OnClose()
	this:Hide()
end

function TargetWeapon2_OnHelp()
	Helper:GotoHelper("*TargetWeapon2")
end

function TargetWeapon2_Frame_On_ResetPos()
  TargetWeapon2_Frame:SetProperty("UnifiedPosition", g_TargetWeapon2_Frame_UnifiedPosition)
end

function TargetWeapon2_Model_TurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		TargetWeapon2_FakeObject:RotateBegin(-0.3)
	--stop
	else
		TargetWeapon2_FakeObject:RotateEnd()
	end
end

function TargetWeapon2_Model_TurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		TargetWeapon2_FakeObject:RotateBegin(0.3)
	--stop
	else
		TargetWeapon2_FakeObject:RotateEnd()
	end
end

function TargetWeapon2_TargetPeak_Switch()
	Variable:SetVariable("TargetPageNumber", tostring(8), 1)
	--if ZBS:IsZBSFinalDFengBanFlag() == 1 then
	--	PushDebugMessage("#{WCBZ_250812_1}")
--	    return 0
--	end
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 85 then
		PushDebugMessage("#{DFJC_250709_83}")
		TargetWeapon2_TargetPeak:SetCheck(0)
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetWeapon2_Frame:GetProperty("UnifiedPosition"), 1)
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