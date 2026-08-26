--!!!reloadscript =PetSoul_JiHuo

local g_PetSoul_JiHuo_Frame_UnifiedPosition

local g_clientNpcId = -1
local g_ExteriorType = 4 						--????

local g_InitList = 0
local g_NeedChangeScrollSize = 1

local g_MaxBarNum = 0
local g_BarList = {}
local g_CurSelExteriorID = 0					--???????ID,?1??
local g_QualStr = {"#{SHRH_20220427_06}", "#{SHRH_20220427_05}", "#{SHRH_20220427_04}"}

--==================================
-- PetSoul_JiHuo_PreLoad
--==================================
function PetSoul_JiHuo_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("ADD_EXTERIOR", false)
end

--==================================
-- PetSoul_JiHuo_OnLoad
--==================================
function PetSoul_JiHuo_OnLoad()
	g_PetSoul_JiHuo_Frame_UnifiedPosition = PetSoul_JiHuo_Frame:GetProperty("UnifiedPosition")
	g_CurSelExteriorID = 0
end

function PetSoul_JiHuo_Frame_On_ResetPos()
	PetSoul_JiHuo_Frame:SetProperty("UnifiedPosition", g_PetSoul_JiHuo_Frame_UnifiedPosition)
end
--==================================
-- PetSoul_JiHuo_OnEvent
--==================================
function PetSoul_JiHuo_OnEvent(event)
	
	if event == "UI_COMMAND" then
		if tonumber(arg0) == 99990301 then			
			if this:IsVisible() then
				return
			end
			
			local npcObjId = Get_XParam_INT(0)
			g_clientNpcId = DataPool:GetNPCIDByServerID(npcObjId)
			if g_clientNpcId ~= -1 then
				this:CareObject(g_clientNpcId, 1, "PetSoul_JiHuo")
			end

			this:Show()
			PetSoul_JiHuo_OnShown()
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_JiHuo_Frame_On_ResetPos()
	elseif event == "ADD_EXTERIOR" and this:IsVisible() then		
		if tonumber(arg0) == g_ExteriorType then
			PetSoul_JiHuo_UpdateList()
			PetSoul_JiHuo_ShowDetail()
		end
	end

end

function PetSoul_JiHuo_InitList()
	
	if g_InitList == 0 then		

		g_MaxBarNum = Exterior:LuaFnGetExteriorMaxCount(g_ExteriorType)		
		for i = 1, g_MaxBarNum do
			local bar = PetSoul_JiHuo_StyleList:AddChild("PetSoul_JiHuo_SuperListItem")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("PetSoul_JiHuo_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("PetSoul_JiHuo_ItemClicked(%d)", i))
			bar:GetSubItem("PetSoul_JiHuo_SuperListItemAction"):SetEvent("MouseMove", string.format("PetSoul_JiHuo_ItemMouseMove(%d)", i))
			bar:GetSubItem("PetSoul_JiHuo_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("PetSoul_JiHuo_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end
		g_InitList = 1
	end
end

function PetSoul_JiHuo_OnShown()
	
	g_NeedChangeScrollSize = 1
	
	PetSoul_JiHuo_InitList()	
	
--	g_CurSelExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
	
	PetSoul_JiHuo_UpdateList()
	
	PetSoul_JiHuo_ShowDetail()
end

function PetSoul_JiHuo_UpdateList()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType, 2)

	local count = Exterior:LuaFnGetExteriorListCount(g_ExteriorType, 0)

	for i = 1, g_MaxBarNum do
		PetSoul_JiHuo_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		PetSoul_JiHuo_StyleList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	PetSoul_JiHuo_ShowDetail()
end

function PetSoul_JiHuo_SetItem(index, max_count)
	
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
	local strName 	= Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Name")
	local strIcon 	= Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Icon")
	local strImage = GetIconFullName(strIcon)
	local bDecoration = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Decoration")
	
	local strQual = ""
	local iQual = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Quality")
	if iQual == 0 or iQual == 1 or iQual == 2 then
		strQual = g_QualStr[iQual + 1]
	end

	local ctrlAction = bar:GetSubItem("PetSoul_JiHuo_SuperListItemAction")
	if ctrlAction ~= nil then

		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		if bDecoration == 1 then
			local strTemp = ScriptGlobal_Format("#{SHRH_20240703_02}", strName)
			if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
				ctrlAction:SetToolTip("#{SHRH_20240703_03}#r"..strTemp.."#r#{SHRH_20220427_03}")
			else
				ctrlAction:SetToolTip("#{SHRH_20240703_03}#r"..strTemp)
			end
		else
			local strTemp = ScriptGlobal_Format("#{SHRH_20220427_02}", strName)
			if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
				ctrlAction:SetToolTip(strQual.."#r"..strTemp.."#r#{SHRH_20220427_03}")
			else
				ctrlAction:SetToolTip(strQual.."#r"..strTemp)
			end
		end
		
		if g_CurSelExteriorID == nExteriorID then
			ctrlAction:SetPushed(1)
		else
			ctrlAction:SetPushed(0)
		end
	end

	bar:GetSubItem("PetSoul_JiHuo_SuperListItemActionTry"):Hide()
	bar:GetSubItem("PetSoul_JiHuo_SuperListItemActionDef"):Hide()

	if nExteriorID == Exterior:LuaFnGetExteriorInUse(g_ExteriorType) then
		--当前狚在装备的
	--	bar:GetSubItem("PetSoul_JiHuo_SuperListItemActionDef"):Show()
	end

	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
		bar:GetSubItem("PetSoul_JiHuo_SuperListItemActionLock"):Hide()
	else
		bar:GetSubItem("PetSoul_JiHuo_SuperListItemActionLock"):Show()
	end	

end

function PetSoul_JiHuo_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("PetSoul_JiHuo_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					--g_BarList[i]:GetSubItem("PetSoul_JiHuo_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("PetSoul_JiHuo_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("PetSoul_JiHuo_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function PetSoul_JiHuo_ItemClicked(nIndex)
	
	local nExteriorID 	= Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	if g_CurSelExteriorID == nExteriorID then
		return
	end	

	g_CurSelExteriorID = nExteriorID
	
	PetSoul_JiHuo_SetItemSelected(nIndex)
	
	PetSoul_JiHuo_ShowDetail()
end

function PetSoul_JiHuo_ShowDetail()
	
	if g_CurSelExteriorID == 0 then
		PetSoul_JiHuo_SelectPoss:Hide()
		PetSoul_JiHuo_WarningText:SetText("#{SHRH_20220427_61}")
		return
	end
	
	local strName 	= Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Name")
	local strIcon 	= Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Icon")
	local strImage = GetIconFullName(strIcon)
	
	PetSoul_JiHuo_SelectPoss:Show()
	PetSoul_JiHuo_SelectPoss:SetProperty("NormalImage", strImage)
	PetSoul_JiHuo_SelectPoss:SetProperty("HoverImage", strImage)
	
	
	local need_money = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "NeedMoney")
	local need_item = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "NeedItem")
	local need_item_count = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "NeedCount")
	local bDecoration = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Decoration")
	
	local name, icon = LifeAbility:GetPrescr_Material(need_item)
	
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, g_CurSelExteriorID) == 1 then
		PetSoul_JiHuo_WarningText:SetText("#{SHRH_20220427_62}")
	else
		if bDecoration == 1 then
			local strTemp = ScriptGlobal_Format("#{SHRH_20240703_01}", strName, name, tostring(need_item_count), tostring(need_money))
			PetSoul_JiHuo_WarningText:SetText(strTemp)
		else
			local strTemp = ScriptGlobal_Format("#{SHRH_20220427_63}", strName, name, tostring(need_item_count), tostring(need_money))
			PetSoul_JiHuo_WarningText:SetText(strTemp)
		end
	end
end

function PetSoul_JiHuo_OK_Clicked()

	if g_CurSelExteriorID == 0 then
		PushDebugMessage("#{SHRH_20220427_45}")
		return
	end

	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, g_CurSelExteriorID) == 1 then
		PushDebugMessage("#{SHRH_20220427_46}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UnlockExteriorPoss")
		Set_XSCRIPT_ScriptID(999903)
		Set_XSCRIPT_Parameter(0, g_CurSelExteriorID)
		Set_XSCRIPT_Parameter(1, 0)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

function PetSoul_JiHuo_ItemMouseMove(nIndex)

end


function PetSoul_JiHuo_OnCancel()
	this:Hide()
end

function PetSoul_JiHuo_OnClose()
	this:Hide()	
end

function PetSoul_JiHuo_OnHidden()	
	PetSoul_JiHuo_CleanUp()
end

function PetSoul_JiHuo_CleanUp()
	g_CurSelExteriorID = 0
	this:CareObject(g_clientNpcId, 0, "PetSoul_JiHuo")
	g_clientNpcId = -1
end



