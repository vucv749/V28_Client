--7ѡ1

local g_SeventhFestival_Gift_Frame_UnifiedPosition = ""
local m_ItemIndexSel = 0
local m_ItemBagePos = -1
local m_ItemScriptId = -1

local g_ActionItem = {}
local g_ActionMask = {}
local g_ItemNameText = {}

local g_flag = {0,0,0,0,0,0,0}
local g_Count = 7

local g_SetItem = {	
	[38002656] = {38002608, 38002609, 38002610, 38002611, 38002612, 38002613, 38002614},
	[38002657] = {38002608, 38002609, 38002610, 38002611, 38002612, 38002613, 38002614},
}

function SeventhFestival_Gift_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	
end

function SeventhFestival_Gift_OnLoad()

	g_SeventhFestival_Gift_Frame_UnifiedPosition = SeventhFestival_GiftFrame:GetProperty("UnifiedPosition")
	
	g_ActionItem[1] = SeventhFestival_GiftGift1_Icon
	g_ActionItem[2] = SeventhFestival_GiftGift2_Icon
	g_ActionItem[3] = SeventhFestival_GiftGift3_Icon
	g_ActionItem[4] = SeventhFestival_GiftGift4_Icon
	g_ActionItem[5] = SeventhFestival_GiftGift5_Icon
	g_ActionItem[6] = SeventhFestival_GiftGift6_Icon
	g_ActionItem[7] = SeventhFestival_GiftGift7_Icon
	
	g_ActionMask[1] = SeventhFestival_GiftGift1_Icon_Mask
	g_ActionMask[2] = SeventhFestival_GiftGift2_Icon_Mask
	g_ActionMask[3] = SeventhFestival_GiftGift3_Icon_Mask
	g_ActionMask[4] = SeventhFestival_GiftGift4_Icon_Mask
	g_ActionMask[5] = SeventhFestival_GiftGift5_Icon_Mask
	g_ActionMask[6] = SeventhFestival_GiftGift6_Icon_Mask
	g_ActionMask[7] = SeventhFestival_GiftGift7_Icon_Mask
	
	g_ItemNameText[1] = SeventhFestival_GiftGift1_Text
	g_ItemNameText[2] = SeventhFestival_GiftGift2_Text
	g_ItemNameText[3] = SeventhFestival_GiftGift3_Text
	g_ItemNameText[4] = SeventhFestival_GiftGift4_Text
	g_ItemNameText[5] = SeventhFestival_GiftGift5_Text
	g_ItemNameText[6] = SeventhFestival_GiftGift6_Text
	g_ItemNameText[7] = SeventhFestival_GiftGift7_Text
end										

function SeventhFestival_Gift_OnEvent(event)

	if event == "UI_COMMAND" and (tonumber(arg0) == 89334601) then		

		SeventhFestival_Gift_CleanUp()
		
		m_ItemBagePos = Get_XParam_INT(0)
		m_ItemScriptId = Get_XParam_INT(1)
		
		LifeAbility:Lock_Packet_Item(m_ItemBagePos,1)
		this:Show()		
		SeventhFestival_Gift_Update()

		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		SeventhFestival_Gift_Frame_On_ResetPos()
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end
	
	if event == "PACKAGE_ITEM_CHANGED_EX" and tonumber(arg0) == m_ItemBagePos then
		this:Hide()
		return
	end
	
end

function SeventhFestival_Gift_Update()

	if m_ItemBagePos < 0 then
		return
	end
	
	local item_table_index = PlayerPackage:GetItemTableIndex(m_ItemBagePos)	
	if g_SetItem[item_table_index] == nil then
		return
	end
	
	for i = 1, g_Count do
		local itemAction = DataPool:CreateActionItemForShow(g_SetItem[item_table_index][i], 1)
		if itemAction:GetID() ~= 0 then
			g_ActionItem[i]:SetActionItem(itemAction:GetID())
		end
		
		local strName = PlayerPackage:GetItemName(g_SetItem[item_table_index][i])
		local ItemName = ScriptGlobal_Format("#{QXHB_20210701_306}", strName)
		g_ItemNameText[i]:SetText(ItemName)
	end
	
	local nDragTitle = "#gFF0FA0"..PlayerPackage:GetItemName(item_table_index)
	SeventhFestival_GiftDragTitle:SetText(nDragTitle)

end

function SeventhFestival_Gift1_Select(index)

	if m_ItemIndexSel == index then
		m_ItemIndexSel = -1
		for i = 1, g_Count do	
			g_ActionItem[i]:SetPushed(0)
			g_ActionMask[i]:Hide()
		end
		return
	end
	
	m_ItemIndexSel = index
	
	for i = 1, g_Count do	
		g_ActionItem[i]:SetPushed(0)
		g_ActionMask[i]:Hide()
	end
	g_ActionItem[m_ItemIndexSel]:SetPushed(1)
	g_ActionMask[m_ItemIndexSel]:Show()
	
end

function SeventhFestival_GiftOnClose()

	SeventhFestival_Gift_CleanUp()
	
end

function SeventhFestival_Gift_CleanUp()	
	
	for i = 1, g_Count do	
		g_ActionItem[i]:SetActionItem(-1)
		g_ItemNameText[i]:SetText("")
		g_ActionMask[i]:Hide()
	end
	
	if m_ItemBagePos >= 0 then
		LifeAbility:Lock_Packet_Item(m_ItemBagePos,0)
	end
	
	m_ItemBagePos = -1
	m_ItemIndexSel = 0
	m_ItemScriptId = -1
	
	this:Hide()
	
end

function SeventhFestival_Gift_OnHidden()

	SeventhFestival_Gift_CleanUp()
	
end

function SeventhFestival_GiftConfirm()
	
	if m_ItemBagePos < 0 then
		return
	end
	
	if m_ItemScriptId < 0 then
		return
	end

	if m_ItemIndexSel <= 0 then
		PushDebugMessage("#{QXHB_20210701_296}")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnWeaponChoice")
		Set_XSCRIPT_ScriptID(m_ItemScriptId)
		Set_XSCRIPT_Parameter(0, m_ItemBagePos)
		Set_XSCRIPT_Parameter(1, m_ItemIndexSel)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

	this:Hide()
end

function SeventhFestival_Gift_Frame_On_ResetPos()
	if g_SeventhFestival_Gift_Frame_UnifiedPosition ~= nil then
		SeventhFestival_GiftFrame:SetProperty("UnifiedPosition", g_SeventhFestival_Gift_Frame_UnifiedPosition)
	end
end