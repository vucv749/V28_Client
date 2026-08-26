--!!!reloadscript =SelectHeadstyle

local g_SelectHeadstyle_YuanbaoPay = 1	
local g_SelectHeadstyle_Frame_UnifiedPosition

local g_clientNpcId = -1
local g_ExteriorType = 2 			--??

local g_InitList = 0
local g_NeedChangeScrollSize = 1

local g_MaxBarNum = 0
local g_BarList = {}
local g_CurSelExteriorID = 0		--???????ID,?1??

local g_YB_Clicked = 0

function SelectHeadstyle_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("PLAYER_PORTRAIT_CHANGED", false)
end


function SelectHeadstyle_OnLoad()	
	g_SelectHeadstyle_Frame_UnifiedPosition = SelectHeadstyle_Frame:GetProperty("UnifiedPosition")
end

function SelectHeadstyle_Frame_On_ResetPos()
	SelectHeadstyle_Frame:SetProperty("UnifiedPosition", g_SelectHeadstyle_Frame_UnifiedPosition)
end

function SelectHeadstyle_OnEvent(event)
	if event == "UI_COMMAND" then
		if tonumber(arg0) == 80503001 then
		
			if this:IsVisible() then
				return
			end
			
			local npcObjId = Get_XParam_INT(0)
			g_clientNpcId = DataPool:GetNPCIDByServerID(npcObjId)
			if g_clientNpcId ~= -1 then
				this:CareObject(g_clientNpcId, 1, "SelectHeadstyle")
			end			

			if IsWindowShow("SelectHairstyle") then
				CloseWindow("SelectHairstyle", true)
			end

			if IsWindowShow("SelectHairColor") then
				CloseWindow("SelectHairColor", true)
			end

			if IsWindowShow("SelectFacestyle") then
				CloseWindow("SelectFacestyle", true)
			end

			if IsWindowShow("DressPaint_TB") then
				CloseWindow("DressPaint_TB", true)
			end
			
			this:Show()
			SelectHeadstyle_OnShown()
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		SelectHeadstyle_Frame_On_ResetPos()
	elseif event == "PLAYER_PORTRAIT_CHANGED" and this:IsVisible() then
		SelectHeadstyle_UpdateList()	
		SelectHeadstyle_ShowDetail()
	end
end

function SelectHeadstyle_InitList()
	
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetExteriorMaxCount(g_ExteriorType)
		
		for i = 1, g_MaxBarNum do
			local bar = SelectHeadGroup_StyleList:AddChild("SelectHeadstyle_SuperListItem")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("SelectHeadstyle_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("SelectHeadstyle_ItemClicked(%d)", i))
			bar:GetSubItem("SelectHeadstyle_SuperListItemAction"):SetEvent("MouseMove", string.format("SelectHeadstyle_ItemMouseMove(%d)", i))
			bar:GetSubItem("SelectHeadstyle_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("SelectHeadstyle_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end
		g_InitList = 1
	end
end

function SelectHeadstyle_OnShown()
	
	g_NeedChangeScrollSize = 1
	
	if g_SelectHeadstyle_YuanbaoPay == 1 or g_SelectHeadstyle_YuanbaoPay == 0 then
		SelectHeadstyle_Blank_Queren:SetCheck(g_SelectHeadstyle_YuanbaoPay)
	end
	
	SelectHeadstyle_InitList()
	
	g_CurSelExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)

	SelectHeadstyle_UpdateList()
	
	SelectHeadstyle_ShowDetail()
end

function SelectHeadstyle_UpdateList()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType)
	
	local count = Exterior:LuaFnGetExteriorListCount(g_ExteriorType, 0)

	for i = 1, g_MaxBarNum do
		SelectHeadstyle_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		SelectHeadGroup_StyleList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end	
end

function SelectHeadstyle_SetItem(index, max_count)
	if g_BarList[index] == nil then
		return
	end
	
	if index > max_count then
		g_BarList[index]:Hide()
		return
	end
	
	local bar = g_BarList[index]
	bar:Show()
	
	local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, index - 1)
	local nID, ItemID, ItemCount, SelectType, IconFile, CostMoney, StyleName, _ = Exterior:LuaFnGetExteriorHeadStyleInfo(nExteriorID)
	
	if nID > 0 then
		local ctrlAction = bar:GetSubItem("SelectHeadstyle_SuperListItemAction")
		if ctrlAction ~= nil then
			IconFile = GetIconFullName(IconFile)
			ctrlAction:SetProperty("NormalImage", IconFile)
			ctrlAction:SetProperty("HoverImage", IconFile)
			ctrlAction:SetToolTip(StyleName)
			
			if g_CurSelExteriorID == nExteriorID then
				ctrlAction:SetPushed(1)
			else
				ctrlAction:SetPushed(0)
			end
		end

		bar:GetSubItem("SelectHeadGroup_SuperListItemActionTry"):Hide()
		bar:GetSubItem("SelectHeadGroup_SuperListItemActionDef"):Hide()
		
		if nExteriorID == Exterior:LuaFnGetExteriorInUse(g_ExteriorType) then
			--当前狚在装备的
			bar:GetSubItem("SelectHeadGroup_SuperListItemActionDef"):Show()
		end

		if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
			bar:GetSubItem("SelectHeadGroup_SuperListItemActionLock"):Hide()
		else
			bar:GetSubItem("SelectHeadGroup_SuperListItemActionLock"):Show()
		end	
	end

end

function SelectHeadstyle_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do
		if g_BarList[i] ~= nil then
			local ctrlAction = g_BarList[i]:GetSubItem("SelectHeadstyle_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					--g_BarList[i]:GetSubItem("SelectHeadGroup_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("SelectHeadGroup_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)
					g_BarList[i]:GetSubItem("SelectHeadGroup_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function SelectHeadstyle_ItemClicked(nIndex)

	local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	if g_CurSelExteriorID == nExteriorID then
		return
	end	

	g_CurSelExteriorID = nExteriorID
	
	SelectHeadstyle_SetItemSelected(nIndex)
	
	SelectHeadstyle_ShowDetail()
end

function SelectHeadstyle_ShowDetail()
	
	if g_CurSelExteriorID == 0 then
		SelectHeadstyle_Accept:SetText("#{GXHDZ_141121_10}")
		SelectHeadstyle_WarningText:SetText("#{INTERHEAD_XML_016}")
		return
	end
	
	local nID, ItemID, ItemCount, SelectType, IconFile, CostMoney, StyleName, TitleInfo = Exterior:LuaFnGetExteriorHeadStyleInfo(g_CurSelExteriorID)
	if nID <= 0 then
		return
	end
	
	IconFile = GetIconFullName(IconFile)
	SelectHeadstyle_Skill1_BKG:SetProperty("NormalImage", IconFile)
	SelectHeadstyle_Skill1_BKG:SetProperty("HoverImage", IconFile)
	SelectHeadstyle_Skill1_BKG:SetToolTip(StyleName)

	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, g_CurSelExteriorID) == 1 then
		
		SelectHeadstyle_WarningText:SetText("#{WGYH_210827_03}")
		SelectHeadstyle_Accept:SetText("#{GXHDZ_141121_04}")

		if g_CurSelExteriorID == Exterior:LuaFnGetExteriorInUse(g_ExteriorType) then
			--当前狚在装备的
			SelectHeadstyle_WarningText:SetText("#{WGYH_210827_04}")
		end
	else
		SelectHeadstyle_Accept:SetText("#{GXHDZ_141121_10}")
		local name, icon = LifeAbility:GetPrescr_Material(ItemID)
		SelectHeadstyle_WarningText:SetText("#{INTERHEAD_XML_013}"..TitleInfo.."#{INTERHEAD_XML_014}"..name.."#{INTERHEAD_XML_015}#{_EXCHG"..CostMoney.."}")
	end
end

function SelectHeadstyle_OK_Clicked()
	
	if g_CurSelExteriorID == 0 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UnlockAndChangeExteriorHeadId")
		Set_XSCRIPT_ScriptID(805030)
		Set_XSCRIPT_Parameter(0, g_CurSelExteriorID)
		Set_XSCRIPT_Parameter(1, g_SelectHeadstyle_YuanbaoPay)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function SelectHeadstyle_ItemMouseMove(nIndex)

end

function SelectHeadstyle_YB_Clicked()
	g_YB_Clicked = 1
	g_SelectHeadstyle_YuanbaoPay = SelectHeadstyle_Blank_Queren:GetCheck()
end

function SelectHeadstyle_YB_MouseButtonUp()
	if g_YB_Clicked == 1 then
		g_YB_Clicked = 0
	end
	
	if g_SelectHeadstyle_YuanbaoPay == 1 or g_SelectHeadstyle_YuanbaoPay == 0 then
		SelectHeadstyle_Blank_Queren:SetCheck(g_SelectHeadstyle_YuanbaoPay)
	end
end

function SelectHeadstyle_OnCancel()
	this:Hide()
end

function SelectHeadstyle_OnClose()
	this:Hide()	
end

function SelectHeadstyle_OnHidden()
	SelectHeadstyle_CleanUp()
	PushEvent("CONVENIENT_BUY_CONFIRM_CLOSE")
end

function SelectHeadstyle_CleanUp()
	g_CurSelExteriorID = 0
	this:CareObject(g_clientNpcId, 0, "SelectHeadstyle")
	g_clientNpcId = -1
end

