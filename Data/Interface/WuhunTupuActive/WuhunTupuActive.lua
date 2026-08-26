--!!!reloadscript =WuhunTupuActive

local g_WuhunTupuActive_UnifiedPosition = ""
local g_MaxBarNum = 100

local g_BarList = {}

local g_CurrentFilter = 0
local g_InitList = 0
local g_CurrentSelWG = 0
local g_MaxCardLevel = 5
local g_NeedChangeScrollSize = 0

function WuhunTupuActive_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("WHWG_UPDATE", false)
	
	this:RegisterEvent("UNIT_MONEY", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	
	--离开场景，自动关闭
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)

	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED", false)

end

function WuhunTupuActive_OnLoad()	
	g_WuhunTupuActive_UnifiedPosition = WuhunTupuActive_Frame:GetProperty("UnifiedPosition")	
end

function WuhunTupuActive_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880001 then
		this:Show()
		g_CurrentSelWG = 0
		--m_ItemBagIndex = -1
		--OpenWindow("Packet")
		WuhunTupuActive_Update()
		WuhunTupuActive_BeginCareObj(Get_XParam_INT(0))
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WuhunTupuActive_On_ResetPos()
	end
	
	if event == "UNIT_MONEY" then
		WuhunTupuActive_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	end
	
	if event == "MONEYJZ_CHANGE" then 
		WuhunTupuActive_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end
	
	if event == "WHWG_UPDATE" then
		WuhunTupuActive_Update()
		return
	end
	
	if event == "PACKAGE_ITEM_CHANGED" then
		WuhunTupuActive_UpdateSel()
		return		
	end
end

function WuhunTupuActive_InitListBar()	
	if g_InitList == 0 then		
		g_MaxBarNum = DataPool:LuaFnGetWHWGMaxCount()
		for i = 1, g_MaxBarNum do
			local bar = WuhunTupuActive_Item_Lace:AddChild("WuhunTupuActive_ItemBK")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("WuhunTupuActive_Item"):SetEvent("MouseLButtonDown", string.format("WuhunTupuActive_ItemClicked(%d)", i))
		end	
		g_InitList = 1
	end
end

--刷新
function WuhunTupuActive_Update()	
	
	WuhunTupuActive_InitListBar()
	
	WuhunTupuActive_ListCleanUpAction()
	DataPool:LuaFnInitWHWGList()
	local nCount = DataPool:LuaFnGetWHWGListCount()
	
	for i = 1, g_MaxBarNum do
		WuhunTupuActive_SetItem(i, nCount)
	end
	
	if g_NeedChangeScrollSize == 1 then		
	--	WuhunTupuActive_Item_Lace:RefreshLayout()
		WuhunTupuActive_Item_Lace:SetScrollPosition(0)
		g_NeedChangeScrollSize = 0
	end
	
	WuhunTupuActive_UpdateSel()
	
	WuhunTupuActive_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	WuhunTupuActive_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

function WuhunTupuActive_UpdateSel()
	
	if g_CurrentSelWG ~= 0 then
		local nUnLocked = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
		local strName = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Name")
		
		local need_item = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItem")
		local need_item_bind = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItemBind")
		local need_money = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveCost")
		
		local strTemp = ScriptGlobal_Format("#{WH_210223_65}", tostring(strName))
		local strText = "#{WH_210223_64}"..strTemp
		WuhunTupuActive_ItemName:SetText(strText)
		
		if nUnLocked == 0 then
			strText = "#{WH_210223_66}".."#{WH_210223_67}"
			WuhunTupuActive_ItemState:SetText(strText)
		else
			strText = "#{WH_210223_66}".."#{WH_210223_68}"
			WuhunTupuActive_ItemState:SetText(strText)
		end
		
		local theAction = EnumAction(g_CurrentSelWG, "whwg")
		if theAction:GetID() ~= 0 then
			WuhunTupuActive_ItemIcon:SetActionItem(theAction:GetID())
		end		
		
		
		if nUnLocked == 0 then
		
			local need_item = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItem")
			local need_item_bind = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItemBind")
			local need_item_count = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItemCount")
			local item_count = PlayerPackage:Lua_GetUnLockItemCount(need_item)
			local item_bind_count = PlayerPackage:Lua_GetUnLockItemCount(need_item_bind)
			
			if item_bind_count > 0 then
				local showAction = DataPool:CreateBindActionItemForShow(need_item_bind, 1)
				if showAction:GetID() ~= 0 then
					WuhunTupuActive_Need_Object:SetActionItem(showAction:GetID())
				end
			else
				local showAction = DataPool:CreateActionItemForShow(need_item, 1)
				if showAction:GetID() ~= 0 then
					WuhunTupuActive_Need_Object:SetActionItem(showAction:GetID())
				end
			end
			
			if item_count + item_bind_count < need_item_count then
				WuhunTupuActive_Need_Object_Number:SetText("#cff0000"..tostring(need_item_count))
			else
				WuhunTupuActive_Need_Object_Number:SetText("#G"..tostring(need_item_count))
			end		
			
			WuhunTupuActive_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
		else
			WuhunTupuActive_Need_Object:SetActionItem(-1)
			WuhunTupuActive_Need_Object_Number:SetText("")
			WuhunTupuActive_DemandMoney:SetProperty("MoneyNumber", "0")
		end
	else
		WuhunTupuActive_ItemName:SetText("#{WH_210223_64}")
		WuhunTupuActive_ItemState:SetText("#{WH_210223_66}")
		WuhunTupuActive_ItemIcon:SetActionItem(-1)
		
		WuhunTupuActive_DemandMoney:SetProperty("MoneyNumber", "0")
		
		WuhunTupuActive_Need_Object:SetActionItem(-1)
		
		WuhunTupuActive_Need_Object_Number:SetText("")
	end
end

function WuhunTupuActive_SetItem(idx, max_count)

	if g_BarList[idx] == nil then
		return
	end
	
	if idx > max_count then
		g_BarList[idx]:Hide()
		return
	end
	
	local bar = g_BarList[idx]
	bar:Show()
	
	local wgID = DataPool:LuaFnGetWHWGIDFromList(idx - 1)
	local nUnLocked = DataPool:LuaFnGetWHWGInfo(wgID, "UnLocked")
	local nLevel = DataPool:LuaFnGetWHWGInfo(wgID, "Level")
	local nGrade = DataPool:LuaFnGetWHWGInfo(wgID, "Grade")
	local strName = DataPool:LuaFnGetWHWGInfo(wgID, "Name")
	
	--激活锁
	if nUnLocked == 1 then
		bar:GetSubItem("WuhunTupuActive_Item_Mask"):Hide()
	else
		bar:GetSubItem("WuhunTupuActive_Item_Mask"):Show()
	end

	local ctrlAction = bar:GetSubItem("WuhunTupuActive_Item")
	if ctrlAction ~= nil then

		ctrlAction:SetActionItem(-1)
		
		local theAction = EnumAction(wgID, "whwg")
		if theAction:GetID() ~= 0 then
			ctrlAction:SetActionItem(theAction:GetID())
		end
	
		ctrlAction:SetProperty("DraggingEnabled", "False")
		
		if wgID == g_CurrentSelWG then
			ctrlAction:SetPushed(1)
		else
			ctrlAction:SetPushed(0)
		end
	end
end

function WuhunTupuActive_ItemClicked(nIndex)
	
	local wgID = DataPool:LuaFnGetWHWGIDFromList(nIndex - 1)
	if g_CurrentSelWG == wgID then
		return
	end
	
	g_CurrentSelWG = wgID
	
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuActive_Item")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
				else
					ctrlAction:SetPushed(0)	
				end
			end			
		end
	end
	
	WuhunTupuActive_UpdateSel()
	
end

function WuhunTupuActive_DoOk()
	
	if g_CurrentSelWG == 0 then
		PushDebugMessage("#{WH_210223_78}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ActiveWg")
		Set_XSCRIPT_ScriptID(888800)
		Set_XSCRIPT_Parameter(0, g_CurrentSelWG)
		Set_XSCRIPT_Parameter(1, 1)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function WuhunTupuActive_DoCancel()
	WuhunTupuActive_OnCloseClicked()
end

function WuhunTupuActive_OnCloseClicked()
	this:Hide()
end

function WuhunTupuActive_OnHidden()
	WuhunTupuActive_ListCleanUpAction()
	WuhunTupuActive_ItemIcon:SetActionItem(-1)
	WuhunTupuActive_Need_Object:SetActionItem(-1)
end

function WuhunTupuActive_ListCleanUpAction()	
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then			
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuActive_Item")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end	
	end
end

function WuhunTupuActive_On_ResetPos()
	if g_WuhunTupuActive_UnifiedPosition ~= nil then
		WuhunTupuActive_Frame:SetProperty("UnifiedPosition", g_WuhunTupuActive_UnifiedPosition)
	end
end

function WuhunTupuActive_BeginCareObj(obj_id)	
	local m_ObjCared = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(m_ObjCared, 1)
end


--!!!reloadscript =WuhunTupuActive
