--!!!reloadscript =Weapon2_Jian

local g_Weapon2_Jian_Frame_UnifiedPosition

local g_SkillAction = {}

local g_QualStr = {
	"#W#{SBFW_20230707_214}",
	"#G#{SBFW_20230707_215}",
	"#B#{SBFW_20230707_216}",
	"#cbe38ff#{SBFW_20230707_217}",
	"#cff0000#{SBFW_20230707_218}",
}

function Weapon2_Jian_PreLoad()
	this:RegisterEvent("OPEN_SHENBING_EXHIBITION")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Weapon2_Jian_OnLoad()
	g_Weapon2_Jian_Frame_UnifiedPosition = Weapon2_Jian_Frame:GetProperty("UnifiedPosition")
	g_SkillAction[1] = Weapon2_Jian_List_BK_Skill1
	g_SkillAction[2] = Weapon2_Jian_List_BK_Skill2
	g_SkillAction[3] = Weapon2_Jian_List_BK_Skill3
	g_SkillAction[4] = Weapon2_Jian_List_BK_Skill4
	g_SkillAction[5] = Weapon2_Jian_List_BK_Skill5
	g_SkillAction[6] = Weapon2_Jian_List_BK_Skill6
	g_SkillAction[7] = Weapon2_Jian_List_BK_Skill7
end

function Weapon2_Jian_OnEvent(event)

	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end
	
	if event == "OPEN_SHENBING_EXHIBITION" then
		if this:IsVisible() then
			this:Hide()
			return
		end
		
	--	Weapon2_Jian_ShowPage()
		Weapon2_Jian_Update()
	--	Weapon2_Jian_OnShown()
		this:Show()
		Weapon2_Jian_OnShown()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		Weapon2_Jian_Frame_On_ResetPos()
	end
end

function Weapon2_Jian_OnShown()
	Weapon2_Jian_List:SetItemSelect(0)
end

--Update
function Weapon2_Jian_Update()
	Weapon2_Jian_List:ClearListBox()
	local sb_count = DataPool:LuaFnGetShenBingCount()
	for i = 1, sb_count do	
		local item_table_index = DataPool:LuaFnGetShenBingFromJian(i - 1)
		if tonumber(item_table_index) ~= nil and tonumber(item_table_index) > 0 then
			local sb_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(item_table_index))
			Weapon2_Jian_List:AddItem(sb_name, i - 1)
		end
	end
end

function Weapon2_Jian_Equip_Clicked(buttonIn)
	local button = tonumber(buttonIn)
	if button == 1 then
		Weapon2_Jian_Equip:DoAction()
	else
		Weapon2_Jian_Equip:DoSubAction()
	end
end

function Weapon2_Jian_OnHiden()
	Weapon2_Jian_FakeObject:SetFakeObject("")
	Weapon2_Jian_List:ClearListBox()
	
	for i = 1, 7 do
		g_SkillAction[i]:SetActionItem(-1)
	end
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Weapon2_Jian_Frame_On_ResetPos()
	Weapon2_Jian_Frame:SetProperty("UnifiedPosition", g_Weapon2_Jian_Frame_UnifiedPosition)
end

function Weapon2_Jian_Model_TurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Weapon2_Jian_FakeObject:RotateBegin(-0.3)
	--stop
	else
		Weapon2_Jian_FakeObject:RotateEnd()
	end
end

function Weapon2_Jian_Model_TurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Weapon2_Jian_FakeObject:RotateBegin(0.3)
	--stop
	else
		Weapon2_Jian_FakeObject:RotateEnd()
	end
end

function Weapon2_Jian_Jian_Clicked()
	LuaFnOpenShenBingExhibition()
end

function Weapon2_Jian_ListBox_Selected()
	local line_index = Weapon2_Jian_List:GetFirstSelectItem()
	if tonumber(line_index) ~= nil and tonumber(line_index) >= 0 then
		local item_table_index = DataPool:LuaFnGetShenBingFromJian(tonumber(line_index))
		Weapon2_Jian_FakeObject:SetFakeObject("")
		DataPool:LuaFnUpdateShenBingJianModel(item_table_index)
		Weapon2_Jian_FakeObject:SetFakeObject("Jian_ShenBing")
		DataPool:LuaFnUpdateShenBingCamera("Jian_ShenBing", item_table_index)
		for i = 1, 7 do
			local skill_action = DataPool:LuaFnEnumShenBingJianSkillAction(tonumber(line_index), i - 1)
			g_SkillAction[i]:SetActionItem(skill_action:GetID())
		end
	end
end