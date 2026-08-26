--ŒÔ∆∑ 5—°1

local g_Jiyuan_FiveChoice_Frame_UnifiedPosition = ""
local g_ItemIndexSel = 0
local g_UseItemPos = -1
local g_scriptId = -1

local g_ActionItem = {}
local g_ActionMask = {}
local g_ItemNameText = {}
local g_maxnum=0
local g_Count = 5
local g_buyNum = 0

function Jiyuan_FiveChoice_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
end

function Jiyuan_FiveChoice_OnLoad()

	g_Jiyuan_FiveChoice_Frame_UnifiedPosition = Jiyuan_FiveChoice_Frame:GetProperty("UnifiedPosition")
	
	g_ActionItem[1] = Jiyuan_FiveChoice_Gift1_Icon
	g_ActionItem[2] = Jiyuan_FiveChoice_Gift2_Icon 
	g_ActionItem[3] = Jiyuan_FiveChoice_Gift3_Icon
	g_ActionItem[4] = Jiyuan_FiveChoice_Gift4_Icon 
	g_ActionItem[5] = Jiyuan_FiveChoice_Gift5_Icon 
	
	g_ActionMask[1] = Jiyuan_FiveChoice_Gift1_OKBtnOK
	g_ActionMask[2] = Jiyuan_FiveChoice_Gift2_OKBtnOK 
	g_ActionMask[3] = Jiyuan_FiveChoice_Gift3_OKBtnOK
	g_ActionMask[4] = Jiyuan_FiveChoice_Gift4_OKBtnOK 
	g_ActionMask[5] = Jiyuan_FiveChoice_Gift5_OKBtnOK 
	
	g_ItemNameText[1] = Jiyuan_FiveChoice_Gift1_Text
	g_ItemNameText[2] = Jiyuan_FiveChoice_Gift2_Text 
	g_ItemNameText[3] = Jiyuan_FiveChoice_Gift3_Text 
	g_ItemNameText[4] = Jiyuan_FiveChoice_Gift4_Text 
	g_ItemNameText[5] = Jiyuan_FiveChoice_Gift5_Text 
end										

function Jiyuan_FiveChoice_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 89312701 then		 
		Jiyuan_FiveChoice_CleanUp()	
		Jiyuan_FiveChoice_Update()
		this:Show()	

		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Jiyuan_FiveChoice_Frame_On_ResetPos()
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		Jiyuan_FiveChoice_OnClose()
		return
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 89312702 then	
		Jiyuan_FiveChoice_OnClose()
		return
	end 
	
end

function Jiyuan_FiveChoice_Update()

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
	Jiyuan_FiveChoice_DragTitle:SetText("#gFF0FA0"..useItemName)
	Jiyuan_FiveChoice_DragTitle:SetText("#{SDHDRW_220808_13}")
    Jiyuan_FiveChoice_Info:SetText("#{SDHDRW_220808_14}")
	  
end 

function Jiyuan_FiveChoice_2_Select(index)
 
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

function Jiyuan_FiveChoice_OnClose()
	Jiyuan_FiveChoice_CleanUp()
	this:Hide()
end

function Jiyuan_FiveChoice_CleanUp()	
 
	
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
 

function Jiyuan_FiveChoice_Confirm()
 
	
	if g_UseItemPos < 0 then
		return
	end
	
	if g_ItemIndexSel <= 0 then
		PushDebugMessage("#{SDHDRW_220808_22}")
		return
	end
 	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ClientActivateOnce")
		Set_XSCRIPT_ScriptID(g_scriptId)
		Set_XSCRIPT_Parameter(0, g_UseItemPos)
		Set_XSCRIPT_Parameter(1, g_ItemIndexSel) 
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
 
end

function Jiyuan_FiveChoice_Frame_On_ResetPos()
	if g_Jiyuan_FiveChoice_Frame_UnifiedPosition == nil then
		return
	end
	
	Jiyuan_FiveChoice_Frame:SetProperty("UnifiedPosition", g_Jiyuan_FiveChoice_Frame_UnifiedPosition)
end

