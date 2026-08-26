--!!!reloadscript =Kunwu_GiftBox

local g_Kunwu_GiftBox_Frame_UnifiedPosition = ""

local g_Box_BagIndex = -1
local g_Sel_Page = 1
local g_Sel_Index = 0

local g_Elf_List = {
	[1] = {70700140, 70700143, 70700146},
	[2] = {70700139, 70700142, 70700145},
	[3] = {70700138, 70700141, 70700144},
}


local g_Skill_List = {
	[70700138] = {11, 12, 13, 14, 15, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47},
	[70700141] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 61, 62, 63, 64},
	[70700144] = {32, 33, 34, 35, 58, 59},
	[70700139] = {11, 12, 13, 14, 15, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47},
	[70700142] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 61, 62, 63, 64},
	[70700145] = {32, 33, 34, 35, 58, 59},
	[70700140] = {11, 12, 13, 14, 15, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47},
	[70700143] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 61, 62, 63, 64},
	[70700146] = {32, 33, 34, 35, 58, 59},
}

local g_CurElfList = {}
local g_CurSkillList = {}

local g_MaxBarNum = 37

local g_Init = 0
local g_BarList = {}

function Kunwu_GiftBox_PreLoad()
	this:RegisterEvent("UI_COMMAND")	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Kunwu_GiftBox_OnLoad()
	g_Kunwu_GiftBox_Frame_UnifiedPosition = Kunwu_GiftBox_Frame_BK:GetProperty("UnifiedPosition")
end

function Kunwu_GiftBox_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88884201 then
		if not this:IsVisible() then
			g_Box_BagIndex = Get_XParam_INT(0)
			Kunwu_GiftBox_CleanUp()
			this:Show()
			Kunwu_GiftBox_Update()
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Kunwu_GiftBox_ItemCheck()	
		Kunwu_GiftBox_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_GiftBox_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
end

function Kunwu_GiftBox_ItemCheck()
	if Kunwu_GiftBox_NeedRemove(g_Box_BagIndex) == 1 then
		this:Hide()
	end
end

function Kunwu_GiftBox_NeedRemove(idx)
	if g_Box_BagIndex ~= -1 then
		if PlayerPackage:IsLock(g_Box_BagIndex) == 1 then
			return 1
		end
		
		local item_table_index = PlayerPackage:GetItemTableIndex(g_Box_BagIndex)
		if item_table_index ~= 38003520 then
			return 1
		end
	end
	return 0
end

function Kunwu_GiftBox_InitList()
	if g_Init == 1 then
		return
	end
	
	for i = 1, g_MaxBarNum do
		local bar = Kunwu_GiftBox_Action_SuperList:AddChild("Kunwu_GiftBox_Action_SuperListItem")
		bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
		g_BarList[i] = bar	
		bar:GetSubItem("Kunwu_GiftBox_Item1"):SetEvent("MouseLButtonDown", string.format("Kunwu_GiftBox_ItemClicked(%d)", i))
	end
	
	g_Init = 1
	
end

function Kunwu_GiftBox_ItemClicked(nIndex)
	if g_Sel_Index ~= nIndex then
		g_Sel_Index = nIndex
		Kunwu_GiftBox_SetItemSelected(nIndex)
	end
end

function Kunwu_GiftBox_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("Kunwu_GiftBox_Item1")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("Kunwu_GiftBox_Item1_Object1Select"):Show()
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("Kunwu_GiftBox_Item1_Object1Select"):Hide()
				end
			end
		end
	end
end

function Kunwu_GiftBox_Update()

	local strTemp = ""
	Kunwu_GiftBox_InitList()
	Kunwu_GiftBox_UpdatePageButton()
	
	local count = 1
	for i = 1, 3 do
		if g_Sel_Page >= 1 and g_Sel_Page <= 3 then
			local elf_table_index = g_Elf_List[g_Sel_Page][i]
			if g_Skill_List[elf_table_index] ~= nil then
				for j = 1, table.getn(g_Skill_List[elf_table_index]) do
					if count <= g_MaxBarNum then
						local skill = g_Skill_List[elf_table_index][j]
						Kunwu_GiftBox_SetItem(count, elf_table_index, skill)
						count = count + 1
					end
				end
			end
		end
	end

	for i = count, g_MaxBarNum do
		if g_BarList[i] ~= nil then
			g_BarList[i]:Hide()
		end
	end
	
	Kunwu_GiftBox_Action_SuperList:RefreshLayout()
	Kunwu_GiftBox_Action_SuperList:SetScrollPosition4Index(0)
	
	if g_Box_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Box_BagIndex, 1)
	end	
end

function Kunwu_GiftBox_SetItem(index, elf_table_index, skill)
	if g_BarList[index] == nil then
		return
	end
	
	local bar = g_BarList[index]
	bar:Show()
	
	bar:GetSubItem("Kunwu_GiftBox_Item1"):SetActionItem(-1)
	local actionItem = DataPool:LuaFnCreateActionElfForSelect(elf_table_index, skill)

	if actionItem:GetID() ~= 0 then
		bar:GetSubItem("Kunwu_GiftBox_Item1"):SetActionItem(actionItem:GetID())
	end
	
	local elf_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(elf_table_index))
	local elf_skill_name = Pet:LuaFnPetElfSkillName(tonumber(skill))
	
	bar:GetSubItem("Kunwu_GiftBox_ItemInfo1_Text"):SetText(elf_skill_name..elf_item_name)
	
	bar:GetSubItem("Kunwu_GiftBox_Item1_Object1Select"):Hide()
	if index == g_Sel_Index then
		bar:GetSubItem("Kunwu_GiftBox_Item1_Object1Select"):Show()
	end
	
	g_CurElfList[index] = elf_table_index
	g_CurSkillList[index] = skill
end

function Kunwu_GiftBox_SelectPage(page)
	if g_Sel_Page == page then
		return
	end
	g_Sel_Page = page
	g_Sel_Index = 0
	Kunwu_GiftBox_Update()
end

function Kunwu_GiftBox_UpdatePageButton()
	Kunwu_GiftBox_Page1_Btn:SetCheck(0)
	Kunwu_GiftBox_Page2_Btn:SetCheck(0)
	Kunwu_GiftBox_Page3_Btn:SetCheck(0)
	if g_Sel_Page == 1 then
		Kunwu_GiftBox_Page1_Btn:SetCheck(1)
	elseif g_Sel_Page == 2 then
		Kunwu_GiftBox_Page2_Btn:SetCheck(1)
	elseif g_Sel_Page == 3 then
		Kunwu_GiftBox_Page3_Btn:SetCheck(1)
	end
end

function Kunwu_GiftBox_CloseClicked()
	this:Hide()
end

function Kunwu_GiftBox_CleanUp()
	g_Sel_Index = 0
	g_Sel_Page = 1
end

function Kunwu_GiftBox_OnHidden()
	Kunwu_GiftBox_CleanUp()
	g_CurElfList = {}
	g_CurSkillList = {}
	
	if g_Box_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Box_BagIndex, 0)
	end
	g_Box_BagIndex = -1
end

function Kunwu_GiftBox_OK_Clicked()
	
	if g_Sel_Index < 1 or g_Sel_Index > g_MaxBarNum then
		PushDebugMessage("#{JLJC_241216_69}")
		return
	end
	
	local elf_table_index = g_CurElfList[g_Sel_Index]
	local skill = g_CurSkillList[g_Sel_Index]
	
	if elf_table_index == nil or skill == nil then
		PushDebugMessage("#{JLJC_241216_69}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888842)
		Set_XSCRIPT_Function_Name("SelectOne")
		Set_XSCRIPT_Parameter(0, g_Box_BagIndex)
		Set_XSCRIPT_Parameter(1, elf_table_index)
		Set_XSCRIPT_Parameter(2, skill)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Kunwu_GiftBox_HelpClicked()

end

function Kunwu_GiftBox_Frame_On_ResetPos()
	if g_Kunwu_GiftBox_Frame_UnifiedPosition ~= nil then
		Kunwu_GiftBox_Frame_BK:SetProperty("UnifiedPosition", g_Kunwu_GiftBox_Frame_UnifiedPosition)
	end
end
