--!!!reloadscript =WuhuJian

local g_WuhunJian_UnifiedPosition = ""
local g_MaxBarNum = 100

local g_BarList = {}

local g_InitList = 0
local g_CurrentSelWG = 0

local g_NeedChangeScrollSize = 0

local g_CurrentSlot = 0
local g_CurrentGrade = 0

function WuhunJian_PreLoad()

	this:RegisterEvent("OPEN_WHWG")
	this:RegisterEvent("XINGZHEN_UPDATE", false)
	--离开场景，自动关睜
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	--更新装备
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)

end

function WuhunJian_OnLoad()	
	g_WuhunJian_UnifiedPosition = WuhunJian_Frame:GetProperty("UnifiedPosition")	
end

function WuhunJian_OnEvent(event)

	if event == "OPEN_WHWG" then
		this:Show()
		g_CurrentSelWG = 0
		g_CurrentGrade = 1
		g_CurrentSlot = 0
		g_NeedChangeScrollSize = 1
		WuhunJian_Update()		
	end

	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end
	
	if event == "CLOSE_XINGZHENUI_GROUP" then
		this:Hide()
		return
	end

	if event == "XINGZHEN_UPDATE"  and this:IsVisible() then
		Variable:SetVariable("RuneStarPos", WuhunJian_Frame:GetProperty("UnifiedPosition"), 1)
		WuhunJian_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WuhunJian_On_ResetPos()
	end
end

function WuhunJian_InitListBar()	
	if g_InitList == 0 then		
		g_MaxBarNum = DataPool:LuaFnGetWHWGMaxCount()
		for i = 1, g_MaxBarNum do
			local bar = WuhunJian_RightItem_Lace:AddChild("WuhunJian_RightItemBK")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("WuhunJian_RightItem"):SetEvent("MouseLButtonDown", string.format("WuhunJian_ItemClicked(%d)", i))
		end	
		g_InitList = 1
	end
end

--刷新
function WuhunJian_Update()	
	
	WuhunJian_InitListBar()
	
	WuhunJian_ListCleanUpAction()
	DataPool:LuaFnInitWHWGList()
	local nCount = DataPool:LuaFnGetWHWGListCount()
	
	for i = 1, g_MaxBarNum do
		WuhunJian_SetItem(i, nCount)
	end
	
	if g_NeedChangeScrollSize == 1 then		
	--	WuhunJian_RightItem_Lace:RefreshLayout()
		WuhunJian_RightItem_Lace:SetScrollPosition(0)
		g_NeedChangeScrollSize = 0
	end
	
	WuhunJian_UpdateSel()
end

function WuhunJian_UpdateSel()
	
	if g_CurrentSelWG ~= 0 then
		local nModel = DataPool:LuaFnGetWHWGInfo(g_CurrentSelWG, "Model", g_CurrentGrade, g_CurrentSlot)
		WuhunJian_FakeObject:SetFakeObject("")
		DataPool:LuaFnUpdateWHWGModel(nModel)
		WuhunJian_FakeObject:SetFakeObject("WH_WG")
	end
	
	WuhunJian_UpdateButtonCheck()
end

function WuhunJian_SetItem(idx, max_count)

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
		bar:GetSubItem("WuhunJian_RightItem_Mask"):Hide()
	else
		bar:GetSubItem("WuhunJian_RightItem_Mask"):Show()
	end

	local ctrlAction = bar:GetSubItem("WuhunJian_RightItem")
	if ctrlAction ~= nil then

		ctrlAction:SetActionItem(-1)
		
		local theAction = EnumAction(wgID, "whwg")
		if theAction:GetID() ~= 0 then
			ctrlAction:SetActionItem(theAction:GetID())
		end
	
		ctrlAction:SetProperty("DraggingEnabled", "False")
		
		if g_CurrentSelWG == 0 then
			g_CurrentSelWG = wgID
		end
		
		if wgID == g_CurrentSelWG then
			ctrlAction:SetPushed(1)
		else
			ctrlAction:SetPushed(0)
		end
	end
end

function WuhunJian_ItemClicked(nIndex)
	
	local wgID = DataPool:LuaFnGetWHWGIDFromList(nIndex - 1)
	if g_CurrentSelWG == wgID then
		return
	end
	
	g_CurrentSelWG = wgID
	
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunJian_RightItem")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
				else
					ctrlAction:SetPushed(0)	
				end
			end			
		end
	end
	
	WuhunJian_UpdateSel()
	
end

function WuhunJian_Model_TurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		WuhunJian_FakeObject:RotateBegin(-0.3)
	--stop
	else
		WuhunJian_FakeObject:RotateEnd()
	end
end

function WuhunJian_Model_TurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		WuhunJian_FakeObject:RotateBegin(0.3)
	--stop
	else
		WuhunJian_FakeObject:RotateEnd()
	end
end

function WuhunJian_ChangeView(slot, grade)
		
	if slot == g_CurrentSlot and grade == g_CurrentGrade then
		return
	end
	
	g_CurrentSlot = slot
	g_CurrentGrade = grade
	
	WuhunJian_UpdateSel()

end

function WuhunJian_DoCancel()
	WuhunJian_OnCloseClicked()
end

function WuhunJian_OnCloseClicked()
	this:Hide()
end

function WuhunJian_OnHidden()
	WuhunJian_ListCleanUpAction()	
end

function WuhunJian_ListCleanUpAction()	
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then			
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunJian_RightItem")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end	
	end
end

function WuhunJian_On_ResetPos()
	if g_WuhunJian_UnifiedPosition ~= nil then
		WuhunJian_Frame:SetProperty("UnifiedPosition", g_WuhunJian_UnifiedPosition)
	end
end

function WuhunJian_UpdateButtonCheck()
	WuhunJian_Right_Set2_Button1:SetCheck(0)
	WuhunJian_Right_Set2_Button2:SetCheck(0)
	WuhunJian_Right_Set2_Button3:SetCheck(0)
	
	WuhunJian_Right_Set3_Button1:SetCheck(0)
	WuhunJian_Right_Set3_Button2:SetCheck(0)
	WuhunJian_Right_Set3_Button3:SetCheck(0)
	
	if g_CurrentSlot == 0 then
		if g_CurrentGrade == 1 then
			WuhunJian_Right_Set2_Button1:SetCheck(1)
		elseif g_CurrentGrade == 5 then
			WuhunJian_Right_Set2_Button2:SetCheck(1)
		elseif g_CurrentGrade == 8 then
			WuhunJian_Right_Set2_Button3:SetCheck(1)
		end	
	else
		if g_CurrentGrade == 1 then
			WuhunJian_Right_Set3_Button1:SetCheck(1)
		elseif g_CurrentGrade == 5 then
			WuhunJian_Right_Set3_Button2:SetCheck(1)
		elseif g_CurrentGrade == 8 then
			WuhunJian_Right_Set3_Button3:SetCheck(1)
		end
	end	
end


--!!!reloadscript =WuhuJian
