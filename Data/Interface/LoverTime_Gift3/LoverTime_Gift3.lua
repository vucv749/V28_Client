
--2?1

local g_LoverTime_Gift3_Frame_UnifiedPosition = ""

local g_LoverTime_Gift3_ItemIndexSel = 0
local g_LoverTime_Gift3_ItemBagePos = -1
local g_LoverTime_Gift3_ItemScriptId = -1
local g_LoverTime_Gift3_Item = {0, 0}
local g_LoverTime_Gift3_Item1 = -1
local g_LoverTime_Gift3_Item2 = -1

local g_LoverTime_Gift3_ActionItem = {}
local g_LoverTime_Gift3_ActionMask = {}
local g_LoverTime_Gift3_ItemNameText = {}

local g_LoverTime_Gift3_Count = 2

function LoverTime_Gift3_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	
end

function LoverTime_Gift3_OnLoad()

	g_LoverTime_Gift3_Frame_UnifiedPosition = LoverTime_Gift3_Frame:GetProperty("UnifiedPosition")
	
	g_LoverTime_Gift3_ActionItem[1] = LoverTime_Gift3_Gift1_Icon
	g_LoverTime_Gift3_ActionItem[2] = LoverTime_Gift3_Gift2_Icon
	
	g_LoverTime_Gift3_ActionMask[1] = LoverTime_Gift3_Gift1_Icon_Mask
	g_LoverTime_Gift3_ActionMask[2] = LoverTime_Gift3_Gift2_Icon_Mask
	
	g_LoverTime_Gift3_ItemNameText[1] = LoverTime_Gift3_Gift1_Text
	g_LoverTime_Gift3_ItemNameText[2] = LoverTime_Gift3_Gift2_Text
	
end										

function LoverTime_Gift3_OnEvent(event)

	if event == "UI_COMMAND" and (tonumber(arg0) == 99854101) then		

		LoverTime_Gift3_CleanUp()
		
		g_LoverTime_Gift3_ItemBagePos = Get_XParam_INT(0)
		g_LoverTime_Gift3_ItemScriptId = Get_XParam_INT(1)
		g_LoverTime_Gift3_Item[1] = Get_XParam_INT(2)
		g_LoverTime_Gift3_Item[2] = Get_XParam_INT(3)
		
		LifeAbility:Lock_Packet_Item(g_LoverTime_Gift3_ItemBagePos,1)
		this:Show()		
		LoverTime_Gift3_Update()

		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		LoverTime_Gift3_Frame_On_ResetPos()
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end
	
	if event == "PACKAGE_ITEM_CHANGED_EX" and tonumber(arg0) == g_LoverTime_Gift3_ItemBagePos then
		this:Hide()
		return
	end
	
end

function LoverTime_Gift3_Update()

	if g_LoverTime_Gift3_ItemBagePos < 0 then
		return
	end
	
	local item_table_index = PlayerPackage:GetItemTableIndex(g_LoverTime_Gift3_ItemBagePos)	
	if item_table_index < 0 then
		return
	end
		
	for i = 1, g_LoverTime_Gift3_Count do	
		local itemAction = DataPool:CreateBindActionItemForShow(g_LoverTime_Gift3_Item[i], 1)
		if itemAction:GetID() ~= 0 then
			g_LoverTime_Gift3_ActionItem[i]:SetActionItem(itemAction:GetID())
		end
			
		local strName = DataPool:Lua_GetItemNameByIndex(g_LoverTime_Gift3_Item[i])
		local ItemName = ScriptGlobal_Format("#{QXHB_20210701_306}", strName)
		g_LoverTime_Gift3_ItemNameText[i]:SetText(ItemName)
	end
		
	local nDragTitle = "#gFF0FA0"..PlayerPackage:GetItemName(item_table_index)
	LoverTime_Gift3_DragTitle:SetText(nDragTitle)

end

function LoverTime_Gift3_1_Select(index)

	if g_LoverTime_Gift3_ItemIndexSel == index then
		g_LoverTime_Gift3_ItemIndexSel = -1
		for i = 1, g_LoverTime_Gift3_Count do	
			g_LoverTime_Gift3_ActionItem[i]:SetPushed(0)
			g_LoverTime_Gift3_ActionMask[i]:Hide()
		end
		return
	end
	
	g_LoverTime_Gift3_ItemIndexSel = index
	
	for i = 1, g_LoverTime_Gift3_Count do	
		g_LoverTime_Gift3_ActionItem[i]:SetPushed(0)
		g_LoverTime_Gift3_ActionMask[i]:Hide()
	end
	g_LoverTime_Gift3_ActionItem[g_LoverTime_Gift3_ItemIndexSel]:SetPushed(1)
	g_LoverTime_Gift3_ActionMask[g_LoverTime_Gift3_ItemIndexSel]:Show()
	
end

function LoverTime_Gift3_OnClose()

	LoverTime_Gift3_CleanUp()
	
end

function LoverTime_Gift3_CleanUp()	
	
	for i = 1, g_LoverTime_Gift3_Count do	
		g_LoverTime_Gift3_ActionItem[i]:SetActionItem(-1)
		g_LoverTime_Gift3_ItemNameText[i]:SetText("")
		g_LoverTime_Gift3_ActionMask[i]:Hide()
	end
	
	if g_LoverTime_Gift3_ItemBagePos >= 0 then
		LifeAbility:Lock_Packet_Item(g_LoverTime_Gift3_ItemBagePos,0)
	end
	
	g_LoverTime_Gift3_ItemBagePos = -1
	g_LoverTime_Gift3_ItemIndexSel = 0
	g_LoverTime_Gift3_ItemScriptId = -1
	
	this:Hide()
	
end

function LoverTime_Gift3_OnHidden()

	LoverTime_Gift3_CleanUp()
	
end

function LoverTime_Gift3_Confirm()
	
	if g_LoverTime_Gift3_ItemBagePos < 0 then
		return
	end
	
	if g_LoverTime_Gift3_ItemScriptId < 0 then
		return
	end

	if g_LoverTime_Gift3_ItemIndexSel <= 0 then
		PushDebugMessage("#{QXHB_20230711_14}")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnRideChoice")
		Set_XSCRIPT_ScriptID(g_LoverTime_Gift3_ItemScriptId)
		Set_XSCRIPT_Parameter(0, g_LoverTime_Gift3_ItemBagePos)
		Set_XSCRIPT_Parameter(1, g_LoverTime_Gift3_ItemIndexSel)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

	this:Hide()
end

function LoverTime_Gift3_Frame_On_ResetPos()
	if g_LoverTime_Gift3_Frame_UnifiedPosition ~= nil then
		LoverTime_Gift3_Frame:SetProperty("UnifiedPosition", g_LoverTime_Gift3_Frame_UnifiedPosition)
	end
end