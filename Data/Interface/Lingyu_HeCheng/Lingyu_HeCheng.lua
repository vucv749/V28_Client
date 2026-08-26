--!!!reloadscript =Lingyu_HeCheng

local g_Lingyu_HeCheng_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_LingYu_BagIndex = -1

local g_Return_Item = {20600005, 20600006, 20600045, 20600046}
local g_Need_Mondy = {20000, 40000, 60000, 100000}

local g_ItemTableIndex = -1
local g_TarItemTableIndex = -1

local g_CompoundIndex = 0
local g_CompoundSubIndex = 0

local g_CompoundInfo = {

	[1] = {
		src = 20600005, 
		tar = {
			[1] = {id = 20600006, money = 20000, count = 4, txt = "#{SZXT_221216_236}"},
			[2] = {id = 20600045, money = 110000, count = 16, txt = "#{SZXT_221216_237}"},
			[3] = {id = 20600046, money = 490000, count = 64, txt = "#{SZXT_221216_238}"},
		}
	},
	
	[2] = {
		src = 20600006, 
		tar = {
			[1] = {id = 20600045, money = 30000, count = 4, txt = "#{SZXT_221216_237}"},
			[2] = {id = 20600046, money = 170000, count = 16, txt = "#{SZXT_221216_238}"},
		}
	},
	
	[3] = {
		src = 20600045, 
		tar = {
			[1] = {id = 20600046, money = 50000, count = 4, txt = "#{SZXT_221216_238}"},
		}
	}
}

function Lingyu_HeCheng_PreLoad()
	this:RegisterEvent("UI_COMMAND")	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("BAG_ITEM_DRAGDROP_TO_UI")
	this:RegisterEvent("BAG_ITEM_RBCLICK_TO_UI")
	this:RegisterEvent("BAG_ITEM_DRAGAWAY_FROM_UI")	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Lingyu_HeCheng_OnLoad()
	g_Lingyu_HeCheng_Frame_UnifiedPosition = Lingyu_HeCheng_Frame:GetProperty("UnifiedPosition")
end

function Lingyu_HeCheng_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880807 then
		if not this:IsVisible() then
			Lingyu_HeCheng_CleanUp()
			this:Show()
			Lingyu_HeCheng_Update(1)
			Lingyu_HeCheng_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Lingyu_HeCheng_ItemCheck()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Lingyu_HeCheng_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Lingyu_HeCheng_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Lingyu_HeCheng_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == 41 and tonumber(arg1) ~= nil then
			Lingyu_HeCheng_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Lingyu_HeCheng" and tonumber(arg0) ~= nil then
			Lingyu_HeCheng_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == 41 then
			Lingyu_HeCheng_Item_OnItemDragedDropAway()
		end
		return
	end
end

function Lingyu_HeCheng_ItemCheck()	
	if g_ItemTableIndex ~= -1 then
		local need_remove = 0
		
		local have_count = PlayerPackage:Lua_GetUnLockItemCount(g_ItemTableIndex)
		if have_count < 1 then
			need_remove = 1
		end
		
		if need_remove == 1 then
			LifeAbility:Lock_Packet_ItemByID(g_ItemTableIndex, 0)
			g_ItemTableIndex = -1
			Lingyu_HeCheng_Update(1)
		else
			LifeAbility:Lock_Packet_ItemByID(g_ItemTableIndex, 1)
			
			local have_stuff_count = PlayerPackage:Lua_GetUnLockItemCount(g_ItemTableIndex)
			local have_stuff_count_bind = PlayerPackage:Lua_GetUnLockBindItemCount(g_ItemTableIndex)
			
			Lingyu_HeCheng_Item:SetActionItem(-1)
			if have_stuff_count_bind == 0 then
				local actionItem = DataPool:CreateActionItemForShow(g_ItemTableIndex, have_stuff_count)
				Lingyu_HeCheng_Item:SetActionItem(actionItem:GetID())
			else
				local actionItem = DataPool:CreateBindActionItemForShow(g_ItemTableIndex, have_stuff_count)
				Lingyu_HeCheng_Item:SetActionItem(actionItem:GetID())
			end
		end
	end
end

function Lingyu_HeCheng_Update(list_update)
	
	Lingyu_HeCheng_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Lingyu_HeCheng_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Lingyu_HeCheng_Item:SetActionItem(-1)
	Lingyu_HeCheng_DemandMoney:SetProperty("MoneyNumber", "0")
	
	if list_update == 1 then
		Lingyu_HeCheng_Bind:ResetList()
		Lingyu_HeCheng_Bind:SetProperty("Text", "")
	end

	if g_ItemTableIndex ~= -1 then
	
		Lingyu_HeCheng_Bind:Enable()
		LifeAbility:Lock_Packet_ItemByID(g_ItemTableIndex, 1)
		
		local have_stuff_count = PlayerPackage:Lua_GetUnLockItemCount(g_ItemTableIndex)
		local have_stuff_count_bind = PlayerPackage:Lua_GetUnLockBindItemCount(g_ItemTableIndex)

		if have_stuff_count_bind == 0 then
			local actionItem = DataPool:CreateActionItemForShow(g_ItemTableIndex, have_stuff_count)
			Lingyu_HeCheng_Item:SetActionItem(actionItem:GetID())
		else
			local actionItem = DataPool:CreateBindActionItemForShow(g_ItemTableIndex, have_stuff_count)
			Lingyu_HeCheng_Item:SetActionItem(actionItem:GetID())
		end

		local need_money = g_CompoundInfo[g_CompoundIndex].tar[g_CompoundSubIndex].money
		Lingyu_HeCheng_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
		
		if list_update == 1 then
			for i = 1, table.getn(g_CompoundInfo[g_CompoundIndex].tar) do
				Lingyu_HeCheng_Bind:AddTextItem(g_CompoundInfo[g_CompoundIndex].tar[i].txt, i)
			end
			
			Lingyu_HeCheng_Bind:SetCurrentSelect(g_CompoundSubIndex - 1)
		end
	else
		Lingyu_HeCheng_Bind:Disable()
	end
end

function Lingyu_HeCheng_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Lingyu_HeCheng_Item_OnItemDragedDropFromBag(iBagIndex)
	
	local item_table_index = PlayerPackage:GetItemTableIndex(iBagIndex)
	if item_table_index ~= g_CompoundInfo[1].src and item_table_index ~= g_CompoundInfo[2].src and item_table_index ~= g_CompoundInfo[3].src then
		PushDebugMessage("#{SZXT_221216_234}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	if g_ItemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_ItemByID(g_ItemTableIndex, 0)
	end
	
	g_ItemTableIndex = item_table_index
	if g_ItemTableIndex == g_CompoundInfo[1].src then
		g_CompoundIndex = 1
	elseif g_ItemTableIndex == g_CompoundInfo[2].src then
		g_CompoundIndex = 2
	elseif g_ItemTableIndex == g_CompoundInfo[3].src then
		g_CompoundIndex = 3
	end
	
	g_CompoundSubIndex = 1

	Lingyu_HeCheng_Update(1)	
end

function Lingyu_HeCheng_Item_OnBagItemRClicked(iBagIndex)
	Lingyu_HeCheng_Item_OnItemDragedDropFromBag(iBagIndex)	
end

function Lingyu_HeCheng_Item_OnItemDragedDropAway()
	Lingyu_HeCheng_LingYu_OnRBClicked()
end

function Lingyu_HeCheng_LingYu_OnRBClicked()
	if g_ItemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_ItemByID(g_ItemTableIndex, 0)
		g_ItemTableIndex = -1
		Lingyu_HeCheng_Update(1)
	end
end

function Lingyu_HeCheng_List_Select()
	local _, index = Lingyu_HeCheng_Bind:GetCurrentSelect()
	if g_CompoundSubIndex == index then
		return
	end

	g_CompoundSubIndex = index
	Lingyu_HeCheng_Update(0)
end

function Lingyu_HeCheng_CleanUp()
	Lingyu_HeCheng_DemandMoney:SetProperty("MoneyNumber", "0")
	Lingyu_HeCheng_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Lingyu_HeCheng_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Lingyu_HeCheng_Item:SetActionItem(-1)
	if g_ItemTableIndex ~= -1 then	
		LifeAbility:Lock_Packet_ItemByID(g_ItemTableIndex, 0)
		g_ItemTableIndex = -1
	end
	
	Lingyu_HeCheng_Bind:ResetList()
end

function Lingyu_HeCheng_OnHidden()
	Lingyu_HeCheng_CleanUp()
	m_ObjServerId = -1
end

function Lingyu_HeCheng_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < 85 then
		PushDebugMessage("#{SZXT_221216_175}")
		return
	end
	
	if DataPool:Lua_IsMissionComplete(2169) ~= 1 then
	--	PushDebugMessage("#{SZXT_221216_113}")
	--	return
	end
	
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end

	if g_CompoundIndex == 0 then
		PushDebugMessage("#{SZXT_221216_246}")
		return
	end
	
	if g_CompoundSubIndex == 0 then
		PushDebugMessage("#{SZXT_221216_247}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888808)
		Set_XSCRIPT_Function_Name("LingYuWashItemCompound")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_ItemTableIndex)
		Set_XSCRIPT_Parameter(2, g_CompoundInfo[g_CompoundIndex].tar[g_CompoundSubIndex].id)
		Set_XSCRIPT_Parameter(3, 1)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function Lingyu_HeCheng_HelpClicked()

end
--Care Obj
function Lingyu_HeCheng_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Lingyu_HeCheng_Frame_On_ResetPos()
	if g_Lingyu_HeCheng_Frame_UnifiedPosition ~= nil then
		Lingyu_HeCheng_Frame:SetProperty("UnifiedPosition", g_Lingyu_HeCheng_Frame_UnifiedPosition)
	end
end
