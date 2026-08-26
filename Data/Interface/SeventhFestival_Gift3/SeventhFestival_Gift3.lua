
--2?1

local g_SeventhFestival_Gift3_Frame_UnifiedPosition = ""

local g_SeventhFestival_Gift3_ItemIndexSel = 0
local g_SeventhFestival_Gift3_ItemBagePos = -1
local g_SeventhFestival_Gift3_ItemScriptId = -1
local g_SeventhFestival_Gift3_ItemBind = -1
local g_SeventhFestival_Gift3_UICOMMAND = -1

-- 2 : 1
local g_SeventhFestival_Gift3_Item = {0, 0}
local g_SeventhFestival_Gift3_ActionItem = {}
local g_SeventhFestival_Gift3_ActionMask = {}
local g_SeventhFestival_Gift3_ItemNameText = {}

-- 4 : 1
local g_SeventhFestival_Gift3_Item2 = {0, 0, 0, 0}
local g_SeventhFestival_Gift3_ActionItem2 = {}
local g_SeventhFestival_Gift3_ActionMask2 = {}
local g_SeventhFestival_Gift3_ItemNameText2 = {}

-- 3 : 1
local g_SeventhFestival_Gift3_Item3 = {0, 0, 0}
local g_SeventhFestival_Gift3_ActionItem3 = {}
local g_SeventhFestival_Gift3_ActionMask3 = {}
local g_SeventhFestival_Gift3_ItemNameText3 = {}

local g_SeventhFestival_Gift3_CurPage = 1

function SeventhFestival_Gift3_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	
end

function SeventhFestival_Gift3_OnLoad()

	g_SeventhFestival_Gift3_Frame_UnifiedPosition = SeventhFestival_Gift3_Frame:GetProperty("UnifiedPosition")
	
	g_SeventhFestival_Gift3_ActionItem[1] = SeventhFestival_Gift3_Gift1_Icon
	g_SeventhFestival_Gift3_ActionItem[2] = SeventhFestival_Gift3_Gift2_Icon
	
	g_SeventhFestival_Gift3_ActionMask[1] = SeventhFestival_Gift3_Gift1_Icon_Mask
	g_SeventhFestival_Gift3_ActionMask[2] = SeventhFestival_Gift3_Gift2_Icon_Mask
	
	g_SeventhFestival_Gift3_ItemNameText[1] = SeventhFestival_Gift3_Gift1_Text
	g_SeventhFestival_Gift3_ItemNameText[2] = SeventhFestival_Gift3_Gift2_Text
	
	g_SeventhFestival_Gift3_ActionItem2[1] = SeventhFestival_Gift3_Gift2_1_Icon
	g_SeventhFestival_Gift3_ActionItem2[2] = SeventhFestival_Gift3_Gift2_2_Icon
	g_SeventhFestival_Gift3_ActionItem2[3] = SeventhFestival_Gift3_Gift2_3_Icon
	g_SeventhFestival_Gift3_ActionItem2[4] = SeventhFestival_Gift3_Gift2_4_Icon
	
	g_SeventhFestival_Gift3_ActionMask2[1] = SeventhFestival_Gift3_Gift2_1_Icon_Mask
	g_SeventhFestival_Gift3_ActionMask2[2] = SeventhFestival_Gift3_Gift2_2_Icon_Mask
	g_SeventhFestival_Gift3_ActionMask2[3] = SeventhFestival_Gift3_Gift2_3_Icon_Mask
	g_SeventhFestival_Gift3_ActionMask2[4] = SeventhFestival_Gift3_Gift2_4_Icon_Mask
	
	g_SeventhFestival_Gift3_ItemNameText2[1] = SeventhFestival_Gift3_Gift2_1_Text
	g_SeventhFestival_Gift3_ItemNameText2[2] = SeventhFestival_Gift3_Gift2_2_Text
	g_SeventhFestival_Gift3_ItemNameText2[3] = SeventhFestival_Gift3_Gift2_3_Text
	g_SeventhFestival_Gift3_ItemNameText2[4] = SeventhFestival_Gift3_Gift2_4_Text
	
	g_SeventhFestival_Gift3_ActionItem3[1] = SeventhFestival_Gift3_Gift3_1_Icon
	g_SeventhFestival_Gift3_ActionItem3[2] = SeventhFestival_Gift3_Gift3_2_Icon
	g_SeventhFestival_Gift3_ActionItem3[3] = SeventhFestival_Gift3_Gift3_3_Icon
	
	g_SeventhFestival_Gift3_ActionMask3[1] = SeventhFestival_Gift3_Gift3_1_Icon_Mask
	g_SeventhFestival_Gift3_ActionMask3[2] = SeventhFestival_Gift3_Gift3_2_Icon_Mask
	g_SeventhFestival_Gift3_ActionMask3[3] = SeventhFestival_Gift3_Gift3_3_Icon_Mask
	
	g_SeventhFestival_Gift3_ItemNameText3[1] = SeventhFestival_Gift3_Gift3_1_Text
	g_SeventhFestival_Gift3_ItemNameText3[2] = SeventhFestival_Gift3_Gift3_2_Text
	g_SeventhFestival_Gift3_ItemNameText3[3] = SeventhFestival_Gift3_Gift3_3_Text
	
end										

function SeventhFestival_Gift3_OnEvent(event)

	if event == "UI_COMMAND" and (tonumber(arg0) == 99850901) then		

		SeventhFestival_Gift3_CleanUp()
		
		SeventhFestival_Gift3_Gift:Show()
		SeventhFestival_Gift3_Gift2:Hide()
		SeventhFestival_Gift3_Gift3:Hide()
		
		g_SeventhFestival_Gift3_CurPage = 1
		
		g_SeventhFestival_Gift3_UICOMMAND = 99850901
		
		g_SeventhFestival_Gift3_ItemBagePos = Get_XParam_INT(0)
		g_SeventhFestival_Gift3_ItemScriptId = Get_XParam_INT(1)
		g_SeventhFestival_Gift3_Item[1] = Get_XParam_INT(2)
		g_SeventhFestival_Gift3_Item[2] = Get_XParam_INT(3)
		
		LifeAbility:Lock_Packet_Item(g_SeventhFestival_Gift3_ItemBagePos,1)
		this:Show()		
		SeventhFestival_Gift3_1_Update()

		return
	end
	
	if event == "UI_COMMAND" and (tonumber(arg0) == 89334603) then		

		SeventhFestival_Gift3_CleanUp()
		
		SeventhFestival_Gift3_Gift:Hide()
		SeventhFestival_Gift3_Gift2:Hide()
		SeventhFestival_Gift3_Gift3:Show()
		
		g_SeventhFestival_Gift3_CurPage = 3
		
		g_SeventhFestival_Gift3_UICOMMAND = 89334603
		
		g_SeventhFestival_Gift3_ItemBagePos = Get_XParam_INT(0)
		g_SeventhFestival_Gift3_ItemScriptId = Get_XParam_INT(1)
		g_SeventhFestival_Gift3_ItemBind = Get_XParam_INT(2)
		g_SeventhFestival_Gift3_Item3[1] = Get_XParam_INT(3)
		g_SeventhFestival_Gift3_Item3[2] = Get_XParam_INT(4)
		g_SeventhFestival_Gift3_Item3[3] = Get_XParam_INT(5)
		
		LifeAbility:Lock_Packet_Item(g_SeventhFestival_Gift3_ItemBagePos,1)
		this:Show()		
		SeventhFestival_Gift3_3_Update()

		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		SeventhFestival_Gift3_Frame_On_ResetPos()
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end
	
	if event == "PACKAGE_ITEM_CHANGED_EX" and tonumber(arg0) == g_SeventhFestival_Gift3_ItemBagePos then
		this:Hide()
		return
	end
	
end

function SeventhFestival_Gift3_1_Update()

	if g_SeventhFestival_Gift3_ItemBagePos < 0 then
		return
	end
	
	local item_table_index = PlayerPackage:GetItemTableIndex(g_SeventhFestival_Gift3_ItemBagePos)	
	if item_table_index < 0 then
		return
	end
	
	DataPool:ClearActionItemForShow()
		
	for i = 1, table.getn(g_SeventhFestival_Gift3_Item) do	
		local itemAction = DataPool:CreateBindActionItemForShow(g_SeventhFestival_Gift3_Item[i], 1)
		if itemAction:GetID() ~= 0 then
			g_SeventhFestival_Gift3_ActionItem[i]:SetActionItem(itemAction:GetID())
		end
			
		local strName = DataPool:Lua_GetItemNameByIndex(g_SeventhFestival_Gift3_Item[i])
		local ItemName = ScriptGlobal_Format("#{QXHB_20210701_306}", strName)
		g_SeventhFestival_Gift3_ItemNameText[i]:SetText(ItemName)
	end
		
	local nDragTitle = "#gFF0FA0"..PlayerPackage:GetItemName(item_table_index)
	SeventhFestival_Gift3_DragTitle:SetText(nDragTitle)

	SeventhFestival_Gift3_Info:SetText("#{QXHB_20230711_31}")
	
end

function SeventhFestival_Gift3_1_Select(index)

	if g_SeventhFestival_Gift3_ItemIndexSel == index then
		g_SeventhFestival_Gift3_ItemIndexSel = -1
		for i = 1, table.getn(g_SeventhFestival_Gift3_ActionItem) do	
			g_SeventhFestival_Gift3_ActionItem[i]:SetPushed(0)
			g_SeventhFestival_Gift3_ActionMask[i]:Hide()
		end
		return
	end
	
	if g_SeventhFestival_Gift3_ActionItem[index] == nil or g_SeventhFestival_Gift3_ActionMask[index] == nil then
		return
	end
	
	g_SeventhFestival_Gift3_ItemIndexSel = index
	
	for i = 1, table.getn(g_SeventhFestival_Gift3_ActionItem) do	
		g_SeventhFestival_Gift3_ActionItem[i]:SetPushed(0)
		g_SeventhFestival_Gift3_ActionMask[i]:Hide()
	end
	g_SeventhFestival_Gift3_ActionItem[g_SeventhFestival_Gift3_ItemIndexSel]:SetPushed(1)
	g_SeventhFestival_Gift3_ActionMask[g_SeventhFestival_Gift3_ItemIndexSel]:Show()
	
end

function SeventhFestival_Gift3_2_Update()

	if g_SeventhFestival_Gift3_ItemBagePos < 0 then
		return
	end
	
	local item_table_index = PlayerPackage:GetItemTableIndex(g_SeventhFestival_Gift3_ItemBagePos)	
	if item_table_index < 0 then
		return
	end
	
	DataPool:ClearActionItemForShow()
		
	for i = 1, table.getn(g_SeventhFestival_Gift3_Item2) do	
		local itemAction = DataPool:CreateBindActionItemForShow(g_SeventhFestival_Gift3_Item2[i], 1)
		if itemAction:GetID() ~= 0 then
			g_SeventhFestival_Gift3_ActionItem2[i]:SetActionItem(itemAction:GetID())
		end
			
		local strName = DataPool:Lua_GetItemNameByIndex(g_SeventhFestival_Gift3_Item2[i])
		local ItemName = ScriptGlobal_Format("#{QXHB_20210701_306}", strName)
		g_SeventhFestival_Gift3_ItemNameText2[i]:SetText(ItemName)
	end
		
	local nDragTitle = "#gFF0FA0"..PlayerPackage:GetItemName(item_table_index)
	SeventhFestival_Gift3_DragTitle:SetText(nDragTitle)
	
	SeventhFestival_Gift3_Info:SetText("#{QXHB_20230711_31}")

end

function SeventhFestival_Gift3_2_Select(index)

	if g_SeventhFestival_Gift3_ItemIndexSel == index then
		g_SeventhFestival_Gift3_ItemIndexSel = -1
		for i = 1, table.getn(g_SeventhFestival_Gift3_ActionItem2) do	
			g_SeventhFestival_Gift3_ActionItem2[i]:SetPushed(0)
			g_SeventhFestival_Gift3_ActionMask2[i]:Hide()
		end
		return
	end
	
	if g_SeventhFestival_Gift3_ActionItem2[index] == nil or g_SeventhFestival_Gift3_ActionMask2[index] == nil then
		return
	end
	
	g_SeventhFestival_Gift3_ItemIndexSel = index
	
	for i = 1, table.getn(g_SeventhFestival_Gift3_ActionItem2) do	
		g_SeventhFestival_Gift3_ActionItem2[i]:SetPushed(0)
		g_SeventhFestival_Gift3_ActionMask2[i]:Hide()
	end
	g_SeventhFestival_Gift3_ActionItem2[g_SeventhFestival_Gift3_ItemIndexSel]:SetPushed(1)
	g_SeventhFestival_Gift3_ActionMask2[g_SeventhFestival_Gift3_ItemIndexSel]:Show()
	
end

function SeventhFestival_Gift3_3_Update()

	if g_SeventhFestival_Gift3_ItemBagePos < 0 then
		return
	end
	
	local item_table_index = PlayerPackage:GetItemTableIndex(g_SeventhFestival_Gift3_ItemBagePos)	
	if item_table_index < 0 then
		return
	end
	
	DataPool:ClearActionItemForShow()
		
	for i = 1, table.getn(g_SeventhFestival_Gift3_Item3) do	
		if g_SeventhFestival_Gift3_ItemBind == 1 then
			local itemAction = DataPool:CreateBindActionItemForShow(g_SeventhFestival_Gift3_Item3[i], 1)
			if itemAction:GetID() ~= 0 then
				g_SeventhFestival_Gift3_ActionItem3[i]:SetActionItem(itemAction:GetID())
			end
		else
			local itemAction = DataPool:CreateActionItemForShow(g_SeventhFestival_Gift3_Item3[i], 1)
			if itemAction:GetID() ~= 0 then
				g_SeventhFestival_Gift3_ActionItem3[i]:SetActionItem(itemAction:GetID())
			end
		end
			
		local strName = DataPool:Lua_GetItemNameByIndex(g_SeventhFestival_Gift3_Item3[i])
		local ItemName = ScriptGlobal_Format("#{QXHB_20210701_306}", strName)
		g_SeventhFestival_Gift3_ItemNameText3[i]:SetText(ItemName)
	end
		
	local nDragTitle = "#gFF0FA0"..PlayerPackage:GetItemName(item_table_index)
	SeventhFestival_Gift3_DragTitle:SetText(nDragTitle)
	
	SeventhFestival_Gift3_Info:SetText("#{QXHB_20230711_38}")

end

function SeventhFestival_Gift3_3_Select(index)

	if g_SeventhFestival_Gift3_ItemIndexSel == index then
		g_SeventhFestival_Gift3_ItemIndexSel = -1
		for i = 1, table.getn(g_SeventhFestival_Gift3_ActionItem3) do	
			g_SeventhFestival_Gift3_ActionItem3[i]:SetPushed(0)
			g_SeventhFestival_Gift3_ActionMask3[i]:Hide()
		end
		return
	end
	
	if g_SeventhFestival_Gift3_ActionItem3[index] == nil or g_SeventhFestival_Gift3_ActionMask3[index] == nil then
		return
	end
	
	g_SeventhFestival_Gift3_ItemIndexSel = index
	
	for i = 1, table.getn(g_SeventhFestival_Gift3_ActionItem3) do	
		g_SeventhFestival_Gift3_ActionItem3[i]:SetPushed(0)
		g_SeventhFestival_Gift3_ActionMask3[i]:Hide()
	end
	g_SeventhFestival_Gift3_ActionItem3[g_SeventhFestival_Gift3_ItemIndexSel]:SetPushed(1)
	g_SeventhFestival_Gift3_ActionMask3[g_SeventhFestival_Gift3_ItemIndexSel]:Show()
	
end

function SeventhFestival_Gift3_OnClose()

	SeventhFestival_Gift3_CleanUp()
	
end

function SeventhFestival_Gift3_CleanUp()	
	
	for i = 1, table.getn(g_SeventhFestival_Gift3_ActionItem) do	
		g_SeventhFestival_Gift3_ActionItem[i]:SetActionItem(-1)
		g_SeventhFestival_Gift3_ItemNameText[i]:SetText("")
		g_SeventhFestival_Gift3_ActionMask[i]:Hide()
	end	
	
	for i = 1, table.getn(g_SeventhFestival_Gift3_ActionItem2) do	
		g_SeventhFestival_Gift3_ActionItem2[i]:SetActionItem(-1)
		g_SeventhFestival_Gift3_ItemNameText2[i]:SetText("")
		g_SeventhFestival_Gift3_ActionMask2[i]:Hide()
	end	
	
	for i = 1, table.getn(g_SeventhFestival_Gift3_ActionItem3) do	
		g_SeventhFestival_Gift3_ActionItem3[i]:SetActionItem(-1)
		g_SeventhFestival_Gift3_ItemNameText3[i]:SetText("")
		g_SeventhFestival_Gift3_ActionMask3[i]:Hide()
	end
	
	if g_SeventhFestival_Gift3_ItemBagePos >= 0 then
		LifeAbility:Lock_Packet_Item(g_SeventhFestival_Gift3_ItemBagePos,0)
	end
	
	g_SeventhFestival_Gift3_ItemBagePos = -1
	g_SeventhFestival_Gift3_ItemIndexSel = 0
	g_SeventhFestival_Gift3_ItemScriptId = -1
	g_SeventhFestival_Gift3_UICOMMAND = -1
	
	this:Hide()
	
end

function SeventhFestival_Gift3_OnHidden()

	SeventhFestival_Gift3_CleanUp()
	
end

function SeventhFestival_Gift3_Confirm()
	
	if g_SeventhFestival_Gift3_ItemBagePos < 0 then
		return
	end
	
	if g_SeventhFestival_Gift3_ItemScriptId < 0 then
		return
	end

	if g_SeventhFestival_Gift3_ItemIndexSel <= 0 then
		PushDebugMessage("#{QXHB_20230711_14}")
		return
	end
	Clear_XSCRIPT()
		if g_SeventhFestival_Gift3_UICOMMAND == 89334603 then
			Set_XSCRIPT_Function_Name("OnWeaponChoice")
		else
			Set_XSCRIPT_Function_Name("OnRideChoice")
		end
		Set_XSCRIPT_ScriptID(g_SeventhFestival_Gift3_ItemScriptId)
		Set_XSCRIPT_Parameter(0, g_SeventhFestival_Gift3_ItemBagePos)
		Set_XSCRIPT_Parameter(1, g_SeventhFestival_Gift3_ItemIndexSel)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

	this:Hide()
end

function SeventhFestival_Gift3_Frame_On_ResetPos()
	if g_SeventhFestival_Gift3_Frame_UnifiedPosition ~= nil then
		SeventhFestival_Gift3_Frame:SetProperty("UnifiedPosition", g_SeventhFestival_Gift3_Frame_UnifiedPosition)
	end
end
