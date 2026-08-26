--7ѡ1

local g_LoverTime_Gift2_Frame_UnifiedPosition = ""
local g_LoverTime_Gift2_ItemIndexSel = 0
local g_LoverTime_Gift2_ItemBagePos = -1
local g_LoverTime_Gift2_ItemScriptId = -1

local g_LoverTime_Gift2_ActionItem = {}
local g_LoverTime_Gift2_ActionMask = {}
local g_LoverTime_Gift2_ItemNameText = {}

local g_LoverTime_Gift2_Count = 4

local g_LoverTime_Gift2_SetItem = {	
	[38003017] = {39920133, 39920134, 39920135, 39920136},
	[38003018] = {39920127, 39920128, 39920129, 39920130},
}

function LoverTime_Gift2_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	
end

function LoverTime_Gift2_OnLoad()

	g_LoverTime_Gift2_Frame_UnifiedPosition = LoverTime_Gift2Frame:GetProperty("UnifiedPosition")
	
	g_LoverTime_Gift2_ActionItem[1] = LoverTime_Gift2Gift1_Icon
	g_LoverTime_Gift2_ActionItem[2] = LoverTime_Gift2Gift2_Icon
	g_LoverTime_Gift2_ActionItem[3] = LoverTime_Gift2Gift3_Icon
	g_LoverTime_Gift2_ActionItem[4] = LoverTime_Gift2Gift4_Icon
	
	g_LoverTime_Gift2_ActionMask[1] = LoverTime_Gift2Gift1_Icon_Mask
	g_LoverTime_Gift2_ActionMask[2] = LoverTime_Gift2Gift2_Icon_Mask
	g_LoverTime_Gift2_ActionMask[3] = LoverTime_Gift2Gift3_Icon_Mask
	g_LoverTime_Gift2_ActionMask[4] = LoverTime_Gift2Gift4_Icon_Mask
	
	g_LoverTime_Gift2_ItemNameText[1] = LoverTime_Gift2Gift1_Text
	g_LoverTime_Gift2_ItemNameText[2] = LoverTime_Gift2Gift2_Text
	g_LoverTime_Gift2_ItemNameText[3] = LoverTime_Gift2Gift3_Text
	g_LoverTime_Gift2_ItemNameText[4] = LoverTime_Gift2Gift4_Text
end										

function LoverTime_Gift2_OnEvent(event)

	if event == "UI_COMMAND" and (tonumber(arg0) == 99854201) then		

		LoverTime_Gift2_CleanUp()
		
		g_LoverTime_Gift2_ItemBagePos = Get_XParam_INT(0)
		g_LoverTime_Gift2_ItemScriptId = Get_XParam_INT(1)
		
		LifeAbility:Lock_Packet_Item(g_LoverTime_Gift2_ItemBagePos,1)
		this:Show()		
		LoverTime_Gift2_Update()

		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		LoverTime_Gift2_Frame_On_ResetPos()
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end
	
	if event == "PACKAGE_ITEM_CHANGED_EX" and tonumber(arg0) == g_LoverTime_Gift2_ItemBagePos then
		this:Hide()
		return
	end
	
end

function LoverTime_Gift2_Update()

	if g_LoverTime_Gift2_ItemBagePos < 0 then
		return
	end
	
	local item_table_index = PlayerPackage:GetItemTableIndex(g_LoverTime_Gift2_ItemBagePos)	
	if g_LoverTime_Gift2_SetItem[item_table_index] == nil then
		return
	end
	
	for i = 1, g_LoverTime_Gift2_Count do
		local itemAction = DataPool:CreateActionItemForShow(g_LoverTime_Gift2_SetItem[item_table_index][i], 1)
		if itemAction:GetID() ~= 0 then
			g_LoverTime_Gift2_ActionItem[i]:SetActionItem(itemAction:GetID())
		end
		
		local strName = DataPool:Lua_GetItemNameByIndex(g_LoverTime_Gift2_SetItem[item_table_index][i])
		local ItemName = ScriptGlobal_Format("#{QXHB_20210701_306}", strName)
		g_LoverTime_Gift2_ItemNameText[i]:SetText(ItemName)
	end
	
	local nDragTitle = "#gFF0FA0"..DataPool:Lua_GetItemNameByIndex(item_table_index)
	LoverTime_Gift2DragTitle:SetText(nDragTitle)

end

function LoverTime_Gift21_Select(index)

	if g_LoverTime_Gift2_ItemIndexSel == index then
		g_LoverTime_Gift2_ItemIndexSel = -1
		for i = 1, g_LoverTime_Gift2_Count do	
			g_LoverTime_Gift2_ActionItem[i]:SetPushed(0)
			g_LoverTime_Gift2_ActionMask[i]:Hide()
		end
		return
	end
	
	g_LoverTime_Gift2_ItemIndexSel = index
	
	for i = 1, g_LoverTime_Gift2_Count do	
		g_LoverTime_Gift2_ActionItem[i]:SetPushed(0)
		g_LoverTime_Gift2_ActionMask[i]:Hide()
	end
	g_LoverTime_Gift2_ActionItem[g_LoverTime_Gift2_ItemIndexSel]:SetPushed(1)
	g_LoverTime_Gift2_ActionMask[g_LoverTime_Gift2_ItemIndexSel]:Show()
	
end

function LoverTime_Gift2OnClose()

	LoverTime_Gift2_CleanUp()
	
end

function LoverTime_Gift2_CleanUp()	
	
	for i = 1, g_LoverTime_Gift2_Count do	
		g_LoverTime_Gift2_ActionItem[i]:SetActionItem(-1)
		g_LoverTime_Gift2_ItemNameText[i]:SetText("")
		g_LoverTime_Gift2_ActionMask[i]:Hide()
	end
	
	if g_LoverTime_Gift2_ItemBagePos >= 0 then
		LifeAbility:Lock_Packet_Item(g_LoverTime_Gift2_ItemBagePos,0)
	end
	
	g_LoverTime_Gift2_ItemBagePos = -1
	g_LoverTime_Gift2_ItemIndexSel = 0
	g_LoverTime_Gift2_ItemScriptId = -1
	
	this:Hide()
	
end

function LoverTime_Gift2_OnHidden()

	LoverTime_Gift2_CleanUp()
	
end

function LoverTime_Gift2Confirm()
	
	if g_LoverTime_Gift2_ItemBagePos < 0 then
		return
	end
	
	if g_LoverTime_Gift2_ItemScriptId < 0 then
		return
	end

	if g_LoverTime_Gift2_ItemIndexSel <= 0 then
		PushDebugMessage("#{QXHB_20210701_296}")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnWeaponChoice")
		Set_XSCRIPT_ScriptID(g_LoverTime_Gift2_ItemScriptId)
		Set_XSCRIPT_Parameter(0, g_LoverTime_Gift2_ItemBagePos)
		Set_XSCRIPT_Parameter(1, g_LoverTime_Gift2_ItemIndexSel)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

	this:Hide()
end

function LoverTime_Gift2_Frame_On_ResetPos()
	if g_LoverTime_Gift2_Frame_UnifiedPosition ~= nil then
		LoverTime_Gift2Frame:SetProperty("UnifiedPosition", g_LoverTime_Gift2_Frame_UnifiedPosition)
	end
end
