--物品 6选1

local g_ShengWang_GiftFrame_UnifiedPosition = ""
local g_ItemIndexSel = 0
local g_UseItemPos = -1
local g_scriptId = -1

local g_ActionItem = {}
local g_ActionMask = {}
local g_ItemNameText = {}
local g_maxnum=0
local g_Count = 6
local g_buyNum = 0

local g_LiBaoName = {

	[1] = "#{SWXT_221213_233}",
	[2] = "#{SWXT_221213_234}",
	[3] = "#{SWXT_221213_235}",
	[4] = "#{SWXT_221213_236}",
	[5] = "#{SWXT_221213_237}",
	[6] = "#{SWXT_221213_238}",
}

local g_LiBaoName1 = {

	[1] = "#{SWXT_221213_227}",
	[2] = "#{SWXT_221213_228}",
	[3] = "#{SWXT_221213_229}",
	[4] = "#{SWXT_221213_230}",
	[5] = "#{SWXT_221213_231}",
	[6] = "#{SWXT_221213_232}",
}

local g_SelectTips=
{
	[38002799]="#{SWXT_221213_207}",
	[38002800]="#{SWXT_221213_207}",
	[38002801]="#{SWXT_221213_207}",
	[38002802]="#{SWXT_221213_207}",
	[38002803]="#{SWXT_221213_207}",
	[38002804]="#{SWXT_221213_207}",
	[38002806]="#{SWXT_221213_224}",
}

function ShengWang_Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
end

function ShengWang_Gift_OnLoad()

	g_ShengWang_GiftFrame_UnifiedPosition = ShengWang_GiftFrame:GetProperty("UnifiedPosition")

	g_ActionItem[1] = ShengWang_GiftGift1_Icon
	g_ActionItem[2] = ShengWang_GiftGift2_Icon
	g_ActionItem[3] = ShengWang_GiftGift3_Icon
	g_ActionItem[4] = ShengWang_GiftGift4_Icon
	g_ActionItem[5] = ShengWang_GiftGift5_Icon
	g_ActionItem[6] = ShengWang_GiftGift6_Icon

	g_ActionMask[1] = ShengWang_GiftGift1_Icon_Mask
	g_ActionMask[2] = ShengWang_GiftGift2_Icon_Mask
	g_ActionMask[3] = ShengWang_GiftGift3_Icon_Mask
	g_ActionMask[4] = ShengWang_GiftGift4_Icon_Mask
	g_ActionMask[5] = ShengWang_GiftGift5_Icon_Mask
	g_ActionMask[6] = ShengWang_GiftGift6_Icon_Mask

	g_ItemNameText[1] = ShengWang_GiftGift1_Text
	g_ItemNameText[2] = ShengWang_GiftGift2_Text
	g_ItemNameText[3] = ShengWang_GiftGift3_Text
	g_ItemNameText[4] = ShengWang_GiftGift4_Text
	g_ItemNameText[5] = ShengWang_GiftGift5_Text
	g_ItemNameText[6] = ShengWang_GiftGift6_Text
end

function ShengWang_Gift_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 89006401 then
		ShengWang_Gift_CleanUp()
		ShengWang_Gift_Update()
		this:Show()

		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		ShengWang_GiftFrame_On_ResetPos()
	end

	if event == "HIDE_ON_SCENE_TRANSED" then
		ShengWang_GiftOnClose()
		return
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 89006402 then
		ShengWang_GiftOnClose()
		return
	end

end

function ShengWang_Gift_Update()

	g_UseItemPos = Get_XParam_INT(0)
	if g_UseItemPos < 0 then
		return
	end

	LifeAbility:Lock_Packet_Item(g_UseItemPos, 1)

	for i = 1, g_Count do
		local awardItemId = Get_XParam_INT(2 * i - 1)
		local awardItemNum = Get_XParam_INT(2 * i)

		local itemAction = DataPool:CreateBindActionItemForShow(awardItemId, awardItemNum)
		if itemAction:GetID() ~= 0 then
			g_ActionItem[i]:SetActionItem(itemAction:GetID())
		end

		local strName = DataPool:LuaFnGetItemNameByTableIndex(awardItemId)
		g_ItemNameText[i]:SetText("#c993333"..strName)
	end

	g_scriptId = Get_XParam_INT(2*g_Count+1)

	local useItemId = PlayerPackage:GetItemTableIndex(g_UseItemPos)
	local useItemName = PlayerPackage:GetItemName(useItemId)
	ShengWang_GiftDragTitle:SetText("#gFF0FA0"..useItemName)
	--ShengWang_Gift_DragTitle:SetText("#{SDHDRW_220808_13}")
	if useItemId ~= 38002806 then
		ShengWang_GiftInfo:SetText("#{SWXT_221213_202}")
		for i = 1, table.getn(g_LiBaoName) do
			g_ItemNameText[i]:SetText("#c993333"..g_LiBaoName1[i])
		end
	else
		ShengWang_GiftInfo:SetText("#{SWXT_221213_210}")
		for i = 1, table.getn(g_LiBaoName) do
			g_ItemNameText[i]:SetText("#c993333"..g_LiBaoName[i])
		end
	end

end

function ShengWang_Gift1_Select(index)

	if g_ItemIndexSel == index then
		g_ItemIndexSel = -1
		for i = 1, g_Count do
			g_ActionItem[i]:SetPushed(0)
			g_ActionMask[i]:Hide()
		end
		return
	end

	g_ItemIndexSel = index

	for i = 1, g_Count do
		g_ActionItem[i]:SetPushed(0)
		g_ActionMask[i]:Hide()
	end
	g_ActionItem[g_ItemIndexSel]:SetPushed(1)
	g_ActionMask[g_ItemIndexSel]:Show()

end

function ShengWang_GiftOnClose()
	ShengWang_Gift_CleanUp()
	this:Hide()
end

function ShengWang_Gift_OnHidden()
	ShengWang_Gift_CleanUp()
	this:Hide()
end

function ShengWang_Gift_CleanUp()


	for i = 1, g_Count do
		g_ActionItem[i]:SetActionItem(-1)
		g_ItemNameText[i]:SetText("")
		g_ActionMask[i]:Hide()
	end

	if g_UseItemPos >= 0 then
		LifeAbility:Lock_Packet_Item(g_UseItemPos, 0)
	end

	g_UseItemPos = -1
	g_ItemIndexSel = 0
end


function ShengWang_GiftConfirm()


	if g_UseItemPos < 0 then
		return
	end

	if g_ItemIndexSel <= 0 then
		local useItemId = PlayerPackage:GetItemTableIndex(g_UseItemPos)
		if g_SelectTips[useItemId] ~= nil then
			PushDebugMessage(g_SelectTips[useItemId])
		end
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ClientActivateOnce")
		Set_XSCRIPT_ScriptID(g_scriptId)
		Set_XSCRIPT_Parameter(0, g_UseItemPos)
		Set_XSCRIPT_Parameter(1, g_ItemIndexSel)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	--关闭界面
	ShengWang_GiftOnClose()

end

function ShengWang_GiftFrame_On_ResetPos()
	if g_ShengWang_GiftFrame_UnifiedPosition == nil then
		return
	end

	ShengWang_GiftFrame:SetProperty("UnifiedPosition", g_ShengWang_GiftFrame_UnifiedPosition)
end

