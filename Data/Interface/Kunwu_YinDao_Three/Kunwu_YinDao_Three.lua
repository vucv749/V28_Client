--Kunwu_YinDao_Three.lua
local g_Kunwu_YinDao_Three_Frame_BK_UnifiedXPosition
local g_Kunwu_YinDao_Three_Frame_BK_UnifiedYPosition
local g_Kunwu_YinDao_Three_MaxItemIdx = 3
local g_Kunwu_YinDao_Three_CurItemIdx = 0
local g_Kunwu_YinDao_Three_CurBagIdx = -1
local g_Kunwu_YinDao_Three_Item = 
{
	[1] = {itemId = 70700057, itemName = "#{ZSYD_241218_62}"},
	[2] = {itemId = 70700066, itemName = "#{ZSYD_241218_63}"},
	[3] = {itemId = 70700075, itemName = "#{ZSYD_241218_64}"},
}
local g_Kunwu_YinDao_Three_ItemBtn = {}
local g_Kunwu_YinDao_Three_ItemMask = {}
local g_Kunwu_YinDao_Three_ItemText = {}
function Kunwu_YinDao_Three_PreLoad()
	--第二个参数代表界面隐藏时事件是否有效,默认为true
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
end

function Kunwu_YinDao_Three_OnLoad()
	g_Kunwu_YinDao_Three_Frame_BK_UnifiedXPosition = Kunwu_YinDao_Three_Frame_BK:GetProperty("UnifiedXPosition")
	g_Kunwu_YinDao_Three_Frame_BK_UnifiedYPosition = Kunwu_YinDao_Three_Frame_BK:GetProperty("UnifiedYPosition")
	g_Kunwu_YinDao_Three_ItemBtn[1] = Kunwu_YinDao_Three_Item1
	g_Kunwu_YinDao_Three_ItemBtn[2] = Kunwu_YinDao_Three_Item2
	g_Kunwu_YinDao_Three_ItemBtn[3] = Kunwu_YinDao_Three_Item3

	g_Kunwu_YinDao_Three_ItemMask[1] = Kunwu_YinDao_Three_Item1_Mask
	g_Kunwu_YinDao_Three_ItemMask[2] = Kunwu_YinDao_Three_Item2_Mask
	g_Kunwu_YinDao_Three_ItemMask[3] = Kunwu_YinDao_Three_Item3_Mask

	g_Kunwu_YinDao_Three_ItemText[1] = Kunwu_YinDao_Three_Item1_Name
	g_Kunwu_YinDao_Three_ItemText[2] = Kunwu_YinDao_Three_Item2_Name
	g_Kunwu_YinDao_Three_ItemText[3] = Kunwu_YinDao_Three_Item3_Name
end

--=========================================================
-- 事件处理
--=========================================================
function Kunwu_YinDao_Three_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 21222401) then
		local opType = Get_XParam_INT(0)
		if opType == 1 then
			g_Kunwu_YinDao_Three_CurBagIdx = Get_XParam_INT(1)
			Kunwu_YinDao_Three_Show()
		elseif opType == 0 then
			Kunwu_YinDao_Three_OnHidden()
		end
	end

	if (event == "ADJEST_UI_POS") then
		Kunwu_YinDao_Three_ResetPos()
	end

	if (event == "VIEW_RESOLUTION_CHANGED") then
		Kunwu_YinDao_Three_ResetPos()
	end

	if (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
end

function Kunwu_YinDao_Three_Show()
	if(g_Kunwu_YinDao_Three_CurBagIdx ~= -1) then
		Kunwu_YinDao_Three_Info:SetText("#{ZSYD_241218_65}")
		LifeAbility : Lock_Packet_Item(g_Kunwu_YinDao_Three_CurBagIdx,1)
		g_Kunwu_YinDao_Three_CurItemIdx = 0
		for i = 1, g_Kunwu_YinDao_Three_MaxItemIdx do
			local theAction = DataPool:CreateBindActionItemForShow(g_Kunwu_YinDao_Three_Item[i].itemId, 1)
			if theAction:GetID() ~= 0 then
				g_Kunwu_YinDao_Three_ItemBtn[i]:SetActionItem(theAction:GetID());
				g_Kunwu_YinDao_Three_ItemBtn[i]:Show();
			else
				g_Kunwu_YinDao_Three_ItemBtn[i]:SetActionItem(-1);
				g_Kunwu_YinDao_Three_ItemBtn[i]:Hide()
			end

			g_Kunwu_YinDao_Three_ItemMask[i]:Hide()
			g_Kunwu_YinDao_Three_ItemText[i]:SetText(g_Kunwu_YinDao_Three_Item[i].itemName)
		end
		Kunwu_YinDao_Three_DragTitle:SetText("#{ZSYD_241218_61}")
		this:Show()
	end
end

function Kunwu_YinDao_Three_OnItemClicked(idx)
	for i = 1, g_Kunwu_YinDao_Three_MaxItemIdx do
		g_Kunwu_YinDao_Three_ItemMask[i]:Hide()
	end
	if idx >= 1 and idx <= g_Kunwu_YinDao_Three_MaxItemIdx then
		g_Kunwu_YinDao_Three_CurItemIdx = idx
		g_Kunwu_YinDao_Three_ItemMask[idx]:Show()
	end
end

function Kunwu_YinDao_Three_OnGetClicked()
	if g_Kunwu_YinDao_Three_CurItemIdx < 1 or g_Kunwu_YinDao_Three_CurItemIdx > g_Kunwu_YinDao_Three_MaxItemIdx then
		PushDebugMessage("#{ZSYD_241218_66}")
		return
	end
	if g_Kunwu_YinDao_Three_CurItemIdx >= 1 and g_Kunwu_YinDao_Three_CurItemIdx <= g_Kunwu_YinDao_Three_MaxItemIdx and g_Kunwu_YinDao_Three_CurBagIdx ~= -1 then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetClick")
		Set_XSCRIPT_ScriptID(212224)
		Set_XSCRIPT_Parameter(0, g_Kunwu_YinDao_Three_CurBagIdx)
		Set_XSCRIPT_Parameter(1, g_Kunwu_YinDao_Three_CurItemIdx)
		Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

function Kunwu_YinDao_Three_OnHidden()
	if g_Kunwu_YinDao_Three_CurBagIdx ~= -1 then
		LifeAbility : Lock_Packet_Item(g_Kunwu_YinDao_Three_CurBagIdx,0)
	end
	g_Kunwu_YinDao_Three_CurItemIdx = 0
	g_Kunwu_YinDao_Three_CurBagIdx = -1
	this:Hide()
end

function Kunwu_YinDao_Three_ResetPos()
	Kunwu_YinDao_Three_Frame_BK:SetProperty("UnifiedXPosition", g_Kunwu_YinDao_Three_Frame_BK_UnifiedXPosition)
	Kunwu_YinDao_Three_Frame_BK:SetProperty("UnifiedYPosition", g_Kunwu_YinDao_Three_Frame_BK_UnifiedYPosition)

end
