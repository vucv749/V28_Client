--!!!reloadscript =Kunwu_JL_Shop

local g_Kunwu_JL_Shop_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_ActionBtn = {}
local g_ItemTipImage = {}
local g_ItemNumText = {}
local g_ItemMask = {}
local g_ItemNameText = {}
local g_ItemPrice = {}

local g_PayConfirm = 1

local g_ItemOnePage = 12
local g_ItemListSize = 7
local g_ItemList = {
	[1] = {id = 38003512, price = 480000, limit = 2, limit_idx = 0},
	[2] = {id = 38003513, price = 1300000, limit = 2, limit_idx = 1},
	[3] = {id = 38003514, price = 2000000, limit = 2, limit_idx = 2},
	[4] = {id = 38003515, price = 4100000, limit = 2, limit_idx = 3},
	[5] = {id = 38003516, price = 6200000, limit = 2, limit_idx = 4},
	[6] = {id = 38003517, price = 9000000, limit = 2, limit_idx = 5},
	[7] = {id = 38003511, price = 30000, limit = 0},
}

function Kunwu_JL_Shop_PreLoad()
	this:RegisterEvent("UI_COMMAND")	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ELF_SHOP_UPDATE")
end

function Kunwu_JL_Shop_OnLoad()
	g_Kunwu_JL_Shop_Frame_UnifiedPosition = Kunwu_JL_Shop_Frame:GetProperty("UnifiedPosition")
	
	g_ActionBtn[1] = Kunwu_JL_Shop_Item1
	g_ActionBtn[2] = Kunwu_JL_Shop_Item2
	g_ActionBtn[3] = Kunwu_JL_Shop_Item3
	g_ActionBtn[4] = Kunwu_JL_Shop_Item4
	g_ActionBtn[5] = Kunwu_JL_Shop_Item5
	g_ActionBtn[6] = Kunwu_JL_Shop_Item6
	g_ActionBtn[7] = Kunwu_JL_Shop_Item7
	g_ActionBtn[8] = Kunwu_JL_Shop_Item8
	g_ActionBtn[9] = Kunwu_JL_Shop_Item9
	g_ActionBtn[10] = Kunwu_JL_Shop_Item10
	g_ActionBtn[11] = Kunwu_JL_Shop_Item11
	g_ActionBtn[12] = Kunwu_JL_Shop_Item12
	
	g_ItemTipImage[1] = Kunwu_JL_Shop_Item_Amount1_Discount
	g_ItemTipImage[2] = Kunwu_JL_Shop_Item_Amount2_Discount
	g_ItemTipImage[3] = Kunwu_JL_Shop_Item_Amount3_Discount
	g_ItemTipImage[4] = Kunwu_JL_Shop_Item_Amount4_Discount
	g_ItemTipImage[5] = Kunwu_JL_Shop_Item_Amount5_Discount
	g_ItemTipImage[6] = Kunwu_JL_Shop_Item_Amount6_Discount
	g_ItemTipImage[7] = Kunwu_JL_Shop_Item_Amount7_Discount
	g_ItemTipImage[8] = Kunwu_JL_Shop_Item_Amount8_Discount
	g_ItemTipImage[9] = Kunwu_JL_Shop_Item_Amount9_Discount
	g_ItemTipImage[10] = Kunwu_JL_Shop_Item_Amount10_Discount
	g_ItemTipImage[11] = Kunwu_JL_Shop_Item_Amount11_Discount
	g_ItemTipImage[12] = Kunwu_JL_Shop_Item_Amount12_Discount
	
	g_ItemNumText[1] = Kunwu_JL_Shop_Item_Amount1
	g_ItemNumText[2] = Kunwu_JL_Shop_Item_Amount2
	g_ItemNumText[3] = Kunwu_JL_Shop_Item_Amount3
	g_ItemNumText[4] = Kunwu_JL_Shop_Item_Amount4
	g_ItemNumText[5] = Kunwu_JL_Shop_Item_Amount5
	g_ItemNumText[6] = Kunwu_JL_Shop_Item_Amount6
	g_ItemNumText[7] = Kunwu_JL_Shop_Item_Amount7
	g_ItemNumText[8] = Kunwu_JL_Shop_Item_Amount8
	g_ItemNumText[9] = Kunwu_JL_Shop_Item_Amount9
	g_ItemNumText[10] = Kunwu_JL_Shop_Item_Amount10
	g_ItemNumText[11] = Kunwu_JL_Shop_Item_Amount11
	g_ItemNumText[12] = Kunwu_JL_Shop_Item_Amount12
	
	g_ItemMask[1] = Kunwu_JL_Shop_Item_Amount1_Mask
	g_ItemMask[2] = Kunwu_JL_Shop_Item_Amount2_Mask
	g_ItemMask[3] = Kunwu_JL_Shop_Item_Amount3_Mask
	g_ItemMask[4] = Kunwu_JL_Shop_Item_Amount4_Mask
	g_ItemMask[5] = Kunwu_JL_Shop_Item_Amount5_Mask
	g_ItemMask[6] = Kunwu_JL_Shop_Item_Amount6_Mask
	g_ItemMask[7] = Kunwu_JL_Shop_Item_Amount7_Mask
	g_ItemMask[8] = Kunwu_JL_Shop_Item_Amount8_Mask
	g_ItemMask[9] = Kunwu_JL_Shop_Item_Amount9_Mask
	g_ItemMask[10] = Kunwu_JL_Shop_Item_Amount10_Mask
	g_ItemMask[11] = Kunwu_JL_Shop_Item_Amount11_Mask
	g_ItemMask[12] = Kunwu_JL_Shop_Item_Amount12_Mask	
	
	g_ItemNameText[1] = Kunwu_JL_Shop_ItemInfo1_Text
	g_ItemNameText[2] = Kunwu_JL_Shop_ItemInfo2_Text
	g_ItemNameText[3] = Kunwu_JL_Shop_ItemInfo3_Text
	g_ItemNameText[4] = Kunwu_JL_Shop_ItemInfo4_Text
	g_ItemNameText[5] = Kunwu_JL_Shop_ItemInfo5_Text
	g_ItemNameText[6] = Kunwu_JL_Shop_ItemInfo6_Text
	g_ItemNameText[7] = Kunwu_JL_Shop_ItemInfo7_Text
	g_ItemNameText[8] = Kunwu_JL_Shop_ItemInfo8_Text
	g_ItemNameText[9] = Kunwu_JL_Shop_ItemInfo9_Text
	g_ItemNameText[10] = Kunwu_JL_Shop_ItemInfo10_Text
	g_ItemNameText[11] = Kunwu_JL_Shop_ItemInfo11_Text
	g_ItemNameText[12] = Kunwu_JL_Shop_ItemInfo12_Text
	
	g_ItemPrice[1] = Kunwu_JL_Shop_ItemInfo1_GB
	g_ItemPrice[2] = Kunwu_JL_Shop_ItemInfo2_GB
	g_ItemPrice[3] = Kunwu_JL_Shop_ItemInfo3_GB
	g_ItemPrice[4] = Kunwu_JL_Shop_ItemInfo4_GB
	g_ItemPrice[5] = Kunwu_JL_Shop_ItemInfo5_GB
	g_ItemPrice[6] = Kunwu_JL_Shop_ItemInfo6_GB
	g_ItemPrice[7] = Kunwu_JL_Shop_ItemInfo7_GB
	g_ItemPrice[8] = Kunwu_JL_Shop_ItemInfo8_GB
	g_ItemPrice[9] = Kunwu_JL_Shop_ItemInfo9_GB
	g_ItemPrice[10] = Kunwu_JL_Shop_ItemInfo10_GB
	g_ItemPrice[11] = Kunwu_JL_Shop_ItemInfo11_GB
	g_ItemPrice[12] = Kunwu_JL_Shop_ItemInfo12_GB

	local pay_confirm = Variable:GetVariable("ElfShopPayConfirm")
	if pay_confirm == "0" then
		g_PayConfirm = 0
	else
		g_PayConfirm = 1
	end

end

function Kunwu_JL_Shop_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88883901 then
		if not this:IsVisible() then
			Kunwu_JL_Shop_CleanUp()
			this:Show()
			OpenWindow("Packet")
			g_PayMode = 0
			Kunwu_JL_Shop_Update()
			Kunwu_JL_Shop_BeginCareObj(Get_XParam_INT(0))
			if g_PayConfirm == 1 then
				Kunwu_JL_Shop_Buy:SetCheck(1)
			else
				Kunwu_JL_Shop_Buy:SetCheck(0)
			end
		end
		return
	end	

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_JL_Shop_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "ELF_SHOP_UPDATE" then
		if this:IsVisible() then
			Kunwu_JL_Shop_Update()
		end
		return
	end
end

function Kunwu_JL_Shop_Update()
	
	local strTemp = ""
	
	for i = 1, g_ItemListSize do
		
		local theAction = DataPool:CreateBindActionItemForShow(g_ItemList[i].id, 1)
		g_ActionBtn[i]:SetActionItem(theAction:GetID())
		
		local item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(g_ItemList[i].id))
		g_ItemNameText[i]:SetText(item_name)
		g_ItemPrice[i]:Show()
		g_ItemPrice[i]:SetProperty("MoneyNumber", tostring(g_ItemList[i].price))
		
		g_ItemMask[i]:Hide()
		g_ItemNumText[i]:SetText("")
		if g_ItemList[i].limit > 0 then
			local bought_count = Pet:LuaFnElfShopBoughtCount(g_ItemList[i].limit_idx)
			if bought_count >= g_ItemList[i].limit then
				g_ItemMask[i]:Show()
			else
				g_ItemNumText[i]:SetText(tostring(2 - bought_count))
			end
		end
	end

end

function Kunwu_JL_Shop_CloseClicked()
	this:Hide()
end

function Kunwu_JL_Shop_CleanUp()
	for i = 1, g_ItemOnePage do
		g_ActionBtn[i]:SetActionItem(-1)
		g_ItemTipImage[i]:Hide()
		g_ItemMask[i]:Hide()
		g_ItemNumText[i]:SetText("")
		g_ItemNameText[i]:SetText("")
		g_ItemPrice[i]:Hide()
		g_ItemPrice[i]:SetProperty("MoneyNumber", "0")
	end
end

function Kunwu_JL_Shop_OnHidden()
	Kunwu_JL_Shop_CleanUp()
	m_ObjServerId = -1
	g_PayMode = 0
	
	if Kunwu_JL_Shop_Buy:GetCheck() == 1 then
		g_PayConfirm = 1
	else
		g_PayConfirm = 0
	end
	
	Variable:SetVariable("ElfShopPayConfirm", tostring(g_PayConfirm), 0)
end

function Kunwu_JL_Shop_Btn_Clicked(idx)
	
	if idx < 1 or idx > g_ItemListSize then
		return
	end
	
	if g_ItemList[idx].limit > 0 then
		local bought_count = Pet:LuaFnElfShopBoughtCount(g_ItemList[idx].limit_idx)
		if bought_count >= g_ItemList[idx].limit then
			return
		end
	end
	
	local my_level = Player:GetData("LEVEL")
	if my_level < 65 then
		PushDebugMessage("#{JLYC_241217_12}")
		return
	end
	
	local money_jz = Player:GetData("MONEY_JZ")
	local money = Player:GetData("MONEY")
	if money + money_jz < g_ItemList[idx].price then
		PushDebugMessage("#{JLYC_241217_37}")
		return
	end
	
	if Kunwu_JL_Shop_Buy:GetCheck() == 1 then
		Pet:LuaFnElfShopBuyConfirm(idx, g_ItemList[idx].id, g_ItemList[idx].price, m_ObjServerId)
		return
	else
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888839)
			Set_XSCRIPT_Function_Name("ElfShopBuy")			
			Set_XSCRIPT_Parameter(0, idx)
			Set_XSCRIPT_Parameter(1, m_ObjServerId)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

function Kunwu_JL_Shop_HelpClicked()

end
--Care Obj
function Kunwu_JL_Shop_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Kunwu_JL_Shop_Frame_On_ResetPos()
	if g_Kunwu_JL_Shop_Frame_UnifiedPosition ~= nil then
		Kunwu_JL_Shop_Frame:SetProperty("UnifiedPosition", g_Kunwu_JL_Shop_Frame_UnifiedPosition)
	end
end

function Kunwu_JL_Shop_PayConfirmClick()

end

function Kunwu_JL_Shop_PageUp()

end

function Kunwu_JL_Shop_PageDown()

end