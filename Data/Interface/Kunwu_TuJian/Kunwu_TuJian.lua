--!!!reloadscript =Kunwu_TuJian

local m_ObjServerId = -1

local g_Kunwu_TuJian_Frame_UnifiedPosition

local g_SkillType = 0

local g_Select_Skill = 0

local g_SkillStage2Level = {1, 4, 7, 10, 13, 16, 20}

local g_SkillStageStr = {
"#{JLJC_241216_53}",
"#{JLJC_241216_54}",
"#{JLJC_241216_55}",
"#{JLJC_241216_56}",
"#{JLJC_241216_57}",
"#{JLJC_241216_58}",
"#{JLJC_241216_59}",
}



function Kunwu_TuJian_PreLoad()
	
	this:RegisterEvent("OPEN_PET_ELF_BOOK")
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	

end

function Kunwu_TuJian_OnLoad()
	 g_Kunwu_TuJian_Frame_UnifiedPosition = Kunwu_TuJian_Frame:GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent()
--===============================================
function Kunwu_TuJian_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 88883011 then
		this:Show()
		Kunwu_TuJian_Update(0)
		Kunwu_TuJian_BeginCareObj(Get_XParam_INT(0))
		this:Activate()
		return
	end
	
	if event == "OPEN_PET_ELF_BOOK" then
		local toSkill = tonumber(arg0)
		local obj_id = tonumber(arg1)
		this:Show()
		Kunwu_TuJian_Update(toSkill)
		Kunwu_TuJian_BeginCareObj(obj_id)
		this:Activate()
		return
	end

	-- 游戏窗口尺寸发生了变化
	if event == "ADJEST_UI_POS" then
		Kunwu_TuJian_Frame_On_ResetPos()
		return
	end
	
	-- 游戏分辨率发生了变化
	if event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_TuJian_Frame_On_ResetPos()
		return
	end
end

function Kunwu_TuJian_Update(toSkill)
	if toSkill == 0 then
		g_SkillType = 0
		g_Select_Skill = 0
		Kunwu_TuJian_Page1:SetCheck(1)
		Kunwu_TuJian_Page2:SetCheck(0)
	else
		local use_type = Pet:LuaFnPetElfSkillUseType(toSkill)
		if use_type == 1 then
			g_SkillType = 0
			g_Select_Skill = toSkill
			Kunwu_TuJian_Page1:SetCheck(1)
			Kunwu_TuJian_Page2:SetCheck(0)
		elseif use_type == 2 then
			g_SkillType = 1
			g_Select_Skill = toSkill
			Kunwu_TuJian_Page1:SetCheck(0)
			Kunwu_TuJian_Page2:SetCheck(1)
		else
			g_SkillType = 0
			g_Select_Skill = 0
			Kunwu_TuJian_Page1:SetCheck(1)
			Kunwu_TuJian_Page2:SetCheck(0)
		end
	end
	Kunwu_TuJian_UpdateList(g_Select_Skill)
	Kunwu_TuJian_UpdateSkillDes()
end

-- 更新界面
function Kunwu_TuJian_UpdateList(toSkill)
	Kunwu_TuJian_List:ClearListBox()
	local skill_num = Pet:LuaFnPetElfSkillMaxNum()
	for i = 1, skill_num do
		local skill_id = Pet:LuaFnEnumPetElfSkillId(i - 1)
		local use_type = Pet:LuaFnPetElfSkillUseType(skill_id)
		local skill_name = Pet:LuaFnPetElfSkillName(skill_id)
		if g_SkillType == 0 and use_type == 1 then
			Kunwu_TuJian_List:AddItem("#cfff263"..skill_name, skill_id)
		elseif g_SkillType == 1 and use_type == 2 then
			Kunwu_TuJian_List:AddItem("#cfff263"..skill_name, skill_id)
		end	
	end
	
	if toSkill > 0 then
		Kunwu_TuJian_List:SetItemSelectByItemID(toSkill)
		local item_num = Kunwu_TuJian_List:GetItemNumByItemId(toSkill)
		Kunwu_TuJian_List:EnsureItemIsVisable(item_num)
	else
		Kunwu_TuJian_List:SetItemSelect(0)
	end
end

function Kunwu_TuJian_UpdateSkillDes()
	Kunwu_TuJian_TextList:SetText("")
	if g_Select_Skill ~= 0 then
		local skill_name = Pet:LuaFnPetElfSkillName(g_Select_Skill)
		local desc_txt = ""
		for i = 1, 7 do
			local strTemp = ScriptGlobal_Format(g_SkillStageStr[i], skill_name)
			if i ~= 1 then
				desc_txt = desc_txt.."#r#r"
			end
			desc_txt = desc_txt..tostring(strTemp)
			local skill_desc = Pet:LuaFnPetElfSkillDesc(g_Select_Skill, g_SkillStage2Level[i])
			
			desc_txt = desc_txt.."#r"..tostring(skill_desc)
		end
		Kunwu_TuJian_TextList:SetText(desc_txt)
	end
end

function Kunwu_TuJian_Page_Switch(idx)
	if g_SkillType ~= idx then
		if idx == 0 then
			g_SkillType = idx
			Kunwu_TuJian_Page1:SetCheck(1)
			Kunwu_TuJian_Page2:SetCheck(0)
			Kunwu_TuJian_UpdateList(0)
		elseif idx == 1 then
			g_SkillType = idx
			Kunwu_TuJian_Page1:SetCheck(0)
			Kunwu_TuJian_Page2:SetCheck(1)
			Kunwu_TuJian_UpdateList(0)
		end
	end
end

function Kunwu_TuJian_List_Clicked()
	local skill_id = Kunwu_TuJian_List:GetFirstSelectItem()
	if g_Select_Skill ~= skill_id then
		g_Select_Skill = skill_id
		Kunwu_TuJian_UpdateSkillDes()
	end
end

function Kunwu_TuJian_OnCloseClicked()
	this:Hide()
end

function Kunwu_TuJian_OnHidden()

end

-- 恢复界面的默认相对位置
function Kunwu_TuJian_Frame_On_ResetPos()
	Kunwu_TuJian_Frame:SetProperty("UnifiedPosition", g_Kunwu_TuJian_Frame_UnifiedPosition)
end

--Care Obj
function Kunwu_TuJian_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end
