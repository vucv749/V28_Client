--!!!reloadscript =Lingyu_JieBang

local g_Lingyu_JieBang_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_LingYu_BagIndex = -1

local g_Return_Item = {20600005, 20600006, 20600045, 20600046}
local g_Need_Mondy = {20000, 40000, 60000, 100000}

function Lingyu_JieBang_PreLoad()
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

function Lingyu_JieBang_OnLoad()
	g_Lingyu_JieBang_Frame_UnifiedPosition = Lingyu_JieBang_Frame:GetProperty("UnifiedPosition")
end

function Lingyu_JieBang_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880810 then
		if not this:IsVisible() then
			Lingyu_JieBang_CleanUp()
			this:Show()
			Lingyu_JieBang_Update()
			Lingyu_JieBang_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Lingyu_JieBang_ItemCheck()	
		Lingyu_JieBang_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Lingyu_JieBang_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Lingyu_JieBang_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Lingyu_JieBang_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == 42 and tonumber(arg1) ~= nil then
			Lingyu_JieBang_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Lingyu_JieBang" and tonumber(arg0) ~= nil then
			Lingyu_JieBang_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == 42 then
			Lingyu_JieBang_Item_OnItemDragedDropAway()
		end
		return
	end
end

function Lingyu_JieBang_ItemCheck()	
	if g_LingYu_BagIndex ~= -1 then
		local need_remove = 0
		if PlayerPackage:LuaFnIsBagItemLingYu(g_LingYu_BagIndex) ~= 1 then
			need_remove = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_LingYu_BagIndex) == 1 then
			need_remove = 1
		end
		
		if need_remove == 0 then
			local lyQual = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "QUAL")
			if lyQual ~= 2 and lyQual ~= 3 then
				need_remove = 1
			end
		end
	
		if need_remove == 0 then
			local lyBindStatus = GetItemBindStatus(g_LingYu_BagIndex)
			if lyBindStatus ~= 1 then
				need_remove = 1
			end
		end
		
		if need_remove == 0 then
			for i = 1, 3 do
				local fix_rate = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "FIXRATE", i - 1)
				if fix_rate ~= 0  then
					need_remove = 1
				end
			end
		end
		
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
			g_LingYu_BagIndex = -1
		end
	end
end

function Lingyu_JieBang_Update()
	
	local strTemp = ""
	Lingyu_JieBang_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Lingyu_JieBang_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Lingyu_JieBang_Item:SetActionItem(-1)
	Lingyu_JieBang_DemandMoney:SetProperty("MoneyNumber", "0")
	
	Lingyu_JieBang_Have:SetText("")

	if g_LingYu_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 1)
		local theAction = EnumAction(g_LingYu_BagIndex, "packageitem")
		Lingyu_JieBang_Item:SetActionItem(theAction:GetID())
		
		local need_money = 100000
		local lyQual = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "QUAL")
		if lyQual == 2 then
			Lingyu_JieBang_Have:SetText("#{SZXT_230410_10}")
		elseif lyQual == 3 then
			Lingyu_JieBang_Have:SetText("#{SZXT_230410_09}")
			need_money = 200000
		end

		Lingyu_JieBang_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))		
	end
end

function Lingyu_JieBang_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Lingyu_JieBang_Item_OnItemDragedDropFromBag(iBagIndex)
	
	if PlayerPackage:LuaFnIsBagItemLingYu(iBagIndex) ~= 1 then
		PushDebugMessage("#{SZXT_230410_06}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	local lyQual = PlayerPackage:LuaFnGetBagLingYuData(iBagIndex, "QUAL")
	if lyQual ~= 2 and lyQual ~= 3 then
		PushDebugMessage("#{SZXT_230410_06}")
		return
	end
	
	local lyBindStatus = GetItemBindStatus(iBagIndex)
	if lyBindStatus ~= 1 then
		PushDebugMessage("#{SZXT_230410_06}")
		return
	end
	
	for i = 1, 3 do
		local fix_rate = PlayerPackage:LuaFnGetBagLingYuData(iBagIndex, "FIXRATE", i - 1)
		if fix_rate ~= 0  then
			PushDebugMessage("#{SZXT_230410_07}")
			return
		end
	end
		
	if g_LingYu_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
	end
	g_LingYu_BagIndex = iBagIndex
	Lingyu_JieBang_Update()	
end

function Lingyu_JieBang_Item_OnBagItemRClicked(iBagIndex)
	Lingyu_JieBang_Item_OnItemDragedDropFromBag(iBagIndex)	
end

function Lingyu_JieBang_Item_OnItemDragedDropAway()
	Lingyu_JieBang_LingYu_OnRBClicked()
end

function Lingyu_JieBang_LingYu_OnRBClicked()
	if g_LingYu_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
		g_LingYu_BagIndex = -1
		Lingyu_JieBang_Update()
	end
end

function Lingyu_JieBang_CleanUp()
	Lingyu_JieBang_DemandMoney:SetProperty("MoneyNumber", "0")
	Lingyu_JieBang_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Lingyu_JieBang_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Lingyu_JieBang_Item:SetActionItem(-1)
	if g_LingYu_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
		g_LingYu_BagIndex = -1
	end
end

function Lingyu_JieBang_OnHidden()
	Lingyu_JieBang_CleanUp()
	m_ObjServerId = -1
end

function Lingyu_JieBang_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < 85 then
		PushDebugMessage("#{SZXT_230410_01}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888808)
		Set_XSCRIPT_Function_Name("LingYuUnbind")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_LingYu_BagIndex)
		Set_XSCRIPT_Parameter(2, 1)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Lingyu_JieBang_HelpClicked()

end
--Care Obj
function Lingyu_JieBang_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Lingyu_JieBang_Frame_On_ResetPos()
	if g_Lingyu_JieBang_Frame_UnifiedPosition ~= nil then
		Lingyu_JieBang_Frame:SetProperty("UnifiedPosition", g_Lingyu_JieBang_Frame_UnifiedPosition)
	end
end
