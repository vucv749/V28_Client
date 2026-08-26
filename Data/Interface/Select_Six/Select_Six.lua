-- 6Ñ¡1Àñ°ü

local g_Select_Six_Frame_UnifiedXPosition
local g_Select_Six_Frame_UnifiedYPosition
local g_Select_Six_CurBagPos = -1 --???????????
local g_Select_Six_CurSelIndex = 0 --??????item
local g_Select_Six_CurLiBaoItemIndex = 0 --?????id
local g_Select_Six_TotalNum = 6

-- ¿Ø¼þ±í
local g_Select_Six_UI_ActionItem = {}
local g_Select_Six_UI_ActionChosenMask = {}
local g_Select_Six_UI_ItemName = {}

local g_Select_Six_ItemId ={
	[1] = {
		title = "#{SHYBJ_20210805_29}", --????????·6?
		gift_id = 38003677,
		item_id = {
			38003475,
			38003476,
			38003477,
			38003478,
			38003479,
			38003480
		}
	}
}

--===============================================
-- PreLoad()
--===============================================
function Select_Six_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

--===============================================
-- OnLoad()
--===============================================
function Select_Six_OnLoad()
	g_Select_Six_Frame_UnifiedXPosition = Select_Six_Frame:GetProperty("UnifiedXPosition")
	g_Select_Six_Frame_UnifiedYPosition = Select_Six_Frame:GetProperty("UnifiedYPosition")
	
	g_Select_Six_UI_ActionItem[1] = Select_Six_Item1
	g_Select_Six_UI_ActionItem[2] = Select_Six_Item2
	g_Select_Six_UI_ActionItem[3] = Select_Six_Item3
	g_Select_Six_UI_ActionItem[4] = Select_Six_Item4
	g_Select_Six_UI_ActionItem[5] = Select_Six_Item5
	g_Select_Six_UI_ActionItem[6] = Select_Six_Item6
	
	g_Select_Six_UI_ActionChosenMask[1] = Select_Six_Item1_Mask
	g_Select_Six_UI_ActionChosenMask[2] = Select_Six_Item2_Mask
	g_Select_Six_UI_ActionChosenMask[3] = Select_Six_Item3_Mask
	g_Select_Six_UI_ActionChosenMask[4] = Select_Six_Item4_Mask
	g_Select_Six_UI_ActionChosenMask[5] = Select_Six_Item5_Mask
	g_Select_Six_UI_ActionChosenMask[6] = Select_Six_Item6_Mask
	
	g_Select_Six_UI_ItemName[1] = Select_Six_Item1_Name
	g_Select_Six_UI_ItemName[2] = Select_Six_Item2_Name
	g_Select_Six_UI_ItemName[3] = Select_Six_Item3_Name
	g_Select_Six_UI_ItemName[4] = Select_Six_Item4_Name
	g_Select_Six_UI_ItemName[5] = Select_Six_Item5_Name
	g_Select_Six_UI_ItemName[6] = Select_Six_Item6_Name
end

--===============================================
-- OnEvent()
--===============================================
function Select_Six_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 99825401) then
		g_Select_Six_CurBagPos = Get_XParam_INT(0)
		g_Select_Six_CurLiBaoItemIndex = Get_XParam_INT(1)
		LifeAbility:Lock_Packet_Item(g_Select_Six_CurBagPos, 1)
		Select_Six_Show()

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99825402) then
		Select_Six_CloseShop()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Select_Six_CloseShop()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Select_Six_UpdateUIPos()
	elseif (event == "ADJEST_UI_POS") then
		Select_Six_UpdateUIPos()
	end
end

-- ¿ªÆô½çÃæ
function Select_Six_Show()
	for i = 1, table.getn(g_Select_Six_ItemId) do
		if g_Select_Six_ItemId[i].gift_id == g_Select_Six_CurLiBaoItemIndex then
			local tbl = g_Select_Six_ItemId[i].item_id
			if tbl and table.getn(tbl) == g_Select_Six_TotalNum then
				Select_Six_DragTitle:SetText(g_Select_Six_ItemId[i].title)
				Select_Six_Update(tbl)
				this:Show()
				return
			end
		end
	end
	Select_Six_CleanUp()
end

-- ½çÃæÐÅÏ¢Ìî³ä
function Select_Six_Update(itemTable)
	for i = 1, g_Select_Six_TotalNum do
		local itemAction = DataPool:CreateBindActionItemForShow(itemTable[i], 1)
		if itemAction and itemAction:GetID() ~= 0 then
			g_Select_Six_UI_ActionItem[i]:SetActionItem(itemAction:GetID())
		end
		g_Select_Six_UI_ActionItem[i]:SetPushed(0)
		g_Select_Six_UI_ItemName[i]:SetText("#c6a3906"..DataPool:Lua_GetItemNameByIndex(itemTable[i]))
		g_Select_Six_UI_ActionChosenMask[i]:Hide()
	end
end

-- ¹Ø± ½çÃæ
function Select_Six_CloseShop()
	Select_Six_CleanUp()
	this:Hide()
end

-- Çå¿ Êý¾Ý£¬½âËøÎïÆ·
function Select_Six_CleanUp()
	for i = 1, g_Select_Six_TotalNum do	
		g_Select_Six_UI_ActionItem[i]:SetActionItem(-1)
		g_Select_Six_UI_ItemName[i]:SetText("")
		g_Select_Six_UI_ActionChosenMask[i]:Hide()
	end
	Select_Six_DragTitle:SetText(" ")
	if g_Select_Six_CurBagPos ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Select_Six_CurBagPos, 0)
	end
	g_Select_Six_CurBagPos = -1
	g_Select_Six_CurSelIndex = 0
	g_Select_Six_CurLiBaoItemIndex = 0
end

-- ÁìÈ¡ÎïÆ·
function Select_Six_SelectClicked()
	if g_Select_Six_CurBagPos < 0 then
		return
	end
	if g_Select_Six_CurLiBaoItemIndex <= 0 then
		return
	end
	if g_Select_Six_CurSelIndex <= 0 then
		PushDebugMessage("#{DFXD_250326_138}")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998254)
		Set_XSCRIPT_Function_Name("PickUpItem")
		Set_XSCRIPT_Parameter(0, PlayerPackage:GetItemTableIndex(g_Select_Six_CurBagPos))
		Set_XSCRIPT_Parameter(1, g_Select_Six_CurBagPos)
		Set_XSCRIPT_Parameter(2, g_Select_Six_CurSelIndex)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

-- Ñ¡ÖÐÎïÆ·
function Select_Six_OnItemClicked(index)
	g_Select_Six_CurSelIndex = index
	for i = 1, g_Select_Six_TotalNum do
		g_Select_Six_UI_ActionItem[i]:SetPushed(0)
		g_Select_Six_UI_ActionChosenMask[i]:Hide()
	end
	g_Select_Six_UI_ActionItem[index]:SetPushed(1)
	g_Select_Six_UI_ActionChosenMask[index]:Show()
end

-- µ÷ ûÎ»ÖÃ
function Select_Six_UpdateUIPos()
	Select_Six_Frame:SetProperty("UnifiedXPosition", g_Select_Six_Frame_UnifiedXPosition)
	Select_Six_Frame:SetProperty("UnifiedYPosition", g_Select_Six_Frame_UnifiedYPosition)
end
