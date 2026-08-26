--兽魂染色

local EXTERIORFILTTING_TOTALKIND = 0
local g_TargetExteriorIndex = 0			--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID

local g_CurSelExteriorID = 0			--当前选择的外观ID，从1开始

local g_CurPossVisualIndex = 0 --当前魂镜
local g_TargetPlan = 0
local g_Distance = 1
local g_Distance_Ori = 1
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 4 --融魂外观
local g_MaxBarNum = 0
local g_BarList = {}
local g_PlanButton = {}
local g_NeedChangeScrollSize = 1

local g_CameraHeight = 1     --摄影机高度
local g_CameraDistance = 2   --摄影机距离
local g_CameraPitch = 3      --摄影机角度
local g_CameraPosition =
{
	--女性相关位置
	[0] = 
	{
		{fHeight = 0.82, fDistance = 8, fPitch=0.2},
		{fHeight = 0.82, fDistance = 6.5, fPitch=0.2},
		{fHeight = 1.5, fDistance = 2.5, fPitch=0.20},
		{fHeight = 1.57, fDistance = 1.7, fPitch=0.20}
	},
	--男性相关位置
	[1] = 
	{
		{fHeight = 0.91, fDistance = 8.8, fPitch=0.2},
		{fHeight = 0.91, fDistance = 7.1, fPitch=0.2},
		{fHeight = 1.67, fDistance = 2.5, fPitch=0.2},
		{fHeight = 1.745, fDistance = 1.7, fPitch=0.2}
	},
}
local g_clientNpcId = -1
local g_RankButtons = {}
local g_QualStr = {"#{SHRH_20220427_06}", "#{SHRH_20220427_05}", "#{SHRH_20220427_04}", "#{SHRH_20220427_71}"}

local g_strRank = {
	"#{SHRH_20220427_15}",
	"#{SHRH_20220427_16}",
	"#{SHRH_20220427_17}",
}

local m_PetSoulQual = -1
local g_PetSoul_RanSe_Frame_UnifiedPosition = 0

local g_Item = 30503154
local g_SelectPlan = 0
local g_TargetId = -1
local g_NeedMoney = 50000
local g_RanSeButtonLock = {}
local g_ZiDongState = 0
local g_Zidong_ClickTime = 800
local g_RecvGRespState = 0
local g_IsXiYouStop = 0
local g_Confirm = 0
local g_EquipExId = 0
local g_YuanbaoPay = 1
local g_RanSeButtonQuality = {}

function PetSoul_RanSe_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_RANSE_FRAME")
	this:RegisterEvent("UPDATE_PETSOUL_RANSE", false)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)	--离开场景关闭界面
	this:RegisterEvent("UNIT_MONEY", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	this:RegisterEvent("PETSOUL_RANSE_ZIDONG_CONFIRM_BACK", false)
end

function PetSoul_RanSe_OnLoad() 
	g_PetSoul_RanSe_Frame_UnifiedPosition = PetSoul_RanSe_Frame:GetProperty("UnifiedPosition")

	g_PlanButton[1] = PetSoul_RanSe_ColorItem1
	g_PlanButton[2] = PetSoul_RanSe_ColorItem2
	g_PlanButton[3] = PetSoul_RanSe_ColorItem3

	g_RanSeButtonLock[1] = PetSoul_RanSe_ColorListItemLock1
	g_RanSeButtonLock[2] = PetSoul_RanSe_ColorListItemLock2
	g_RanSeButtonLock[3] = PetSoul_RanSe_ColorListItemLock3

	g_RanSeButtonQuality[1] = PetSoul_RanSe_Item1ActionLuxury
	g_RanSeButtonQuality[2] = PetSoul_RanSe_Item2ActionLuxury
	g_RanSeButtonQuality[3] = PetSoul_RanSe_Item3ActionLuxury
	
end

function PetSoul_RanSe_OnEvent(event)
	if event == "UI_COMMAND" and arg0 ~=nil and tonumber(arg0) == 99850601 then
		PetSoul_RanSe_ResetZiDongState()

	elseif event == "UI_COMMAND" and arg0 ~=nil and tonumber(arg0) == 99850604 then
		PetSoul_RanSe_RetSetZidongButtonText()

	elseif event == "UI_COMMAND" and arg0 ~=nil and tonumber(arg0) == 99850603 then

		local strName = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Name")
		--local strTemp = ScriptGlobal_Format("#{SHRH_20220427_02}", strName)
		local planstr = Exterior:LuaFnGetRanSePlanName(g_CurSelExteriorID, Get_XParam_INT(0))
		local str = ScriptGlobal_Format("#{SHRS_230621_40}", strName,planstr)
		PushDebugMessage(str)

	elseif event == "OPEN_RANSE_FRAME" then
		PetSoul_RanSe_OnShow()

	elseif event == "PETSOUL_RANSE_ZIDONG_CONFIRM_BACK" then
		g_Confirm = 1
		PetSoul_RanSe_Zidong_Clicked()	
	elseif event == "UPDATE_PETSOUL_RANSE" then
		
		PetSoul_RanSe_UpdateNeedItem()
		PetSoul_RanSe_UpdateColorItem()
		g_PlanButton[g_SelectPlan]:SetPushed(1)
		if g_ZiDongState == 1 then  
			local nColor = Exterior:LuaFnGetRanSeColorItem(g_CurSelExteriorID, g_SelectPlan)
			local nQuality = Exterior:LuaFnGetQualityForRanSe(g_CurSelExteriorID, nColor)

			if nColor == g_TargetPlan then
				PetSoul_RanSe_ResetZiDongState()
				PetSoul_RanSe_SuccDestMode() 

				if nQuality>= 3 then
					local strName = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Name")
					local planstr = Exterior:LuaFnGetRanSePlanName(g_CurSelExteriorID, nColor)
					local Msg = ScriptGlobal_Format("#{SHRS_230621_40}", strName, planstr) 
					PushDebugMessage(Msg)
				else
					PushDebugMessage("#{SHRS_230621_39}")
				end
			end

			if g_IsXiYouStop == 1 and nQuality >= 3 then
				PetSoul_RanSe_ResetZiDongState()
				PetSoul_RanSe_SuccDestMode() 
				local strName = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Name")
				local planstr = Exterior:LuaFnGetRanSePlanName(g_CurSelExteriorID, nColor)
				local Msg = ScriptGlobal_Format("#{SHRS_230621_40}", strName, planstr) 
				PushDebugMessage(Msg)
			end

			g_RecvGRespState = 1 

		end 

		local nColor = Exterior:LuaFnGetRanSeColorItem(g_CurSelExteriorID, g_SelectPlan)

		Exterior:LuaFnSetCurrentRanSeSetInfo("RANSE", g_CurSelExteriorID, nColor)

		PetSoul_RanSe_UpdateObj()

	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_RanSe_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_RanSe_Frame_On_ResetPos()

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		PetSoul_RanSe_Close()

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		PetSoul_RanSe_HaveGoldNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetSoul_RanSe_HaveNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
		
end

function PetSoul_RanSe_Frame_On_ResetPos()
	PetSoul_RanSe_Frame:SetProperty("UnifiedPosition", g_PetSoul_RanSe_Frame_UnifiedPosition);
end

function PetSoul_RanSe_InitList()
	Exterior:LuaFnInitExteriorListForRanSe()
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetRanSeListCount()
		for i = 1, g_MaxBarNum do
			local bar = PetSoul_RanSe_List:AddChild("PetSoul_RanSe_SuperListItem")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("PetSoul_RanSe_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("PetSoul_RanSe_ItemClicked(%d)", i))
			bar:GetSubItem("PetSoul_RanSe_SuperListItemAction"):SetEvent("MouseMove", string.format("PetSoul_RanSe_ItemMouseMove(%d)", i))
			bar:GetSubItem("PetSoul_RanSe_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("PetSoul_RanSe_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end		
		g_InitList = 1
	end	
end


function PetSoul_RanSe_OnShow()
	if this : IsVisible() then	-- 如果界面开着，则不处理
		return
	end
	
	g_TargetId = tonumber(arg0)
	g_clientNpcId = DataPool : GetNPCIDByServerID(g_TargetId)
	if g_clientNpcId == -1 then
		PetSoul_RanSe_Close()
		return
	end

	this:CareObject( g_clientNpcId, 1, "PetSoul_RanSe" )

	this:Show()

	g_Distance = g_Distance_Ori	
	g_NeedChangeScrollSize = 1

	Exterior:LuaFnInitCurrentRanSeSet(1)
	Exterior:LuaFnUpdatePetSoulRanSePlayerData()

	local curPossessionPetIndex = Pet:LuaFnGetPossessionPetIndex()
	if curPossessionPetIndex >= 0 then
		m_PetSoulQual = Pet:LuaFnGetPetSoulDataOnPet(curPossessionPetIndex, "QUAL")
	else
		m_PetSoulQual = -1
	end	

	g_CurSelExteriorID = 0
	g_CurPossVisualIndex = 0
	g_SelectPlan = 0
	g_EquipExId = 0
	PetSoul_RanSe_Zidong_Animate:Play(false)
	PetSoul_RanSe_Zidong:Disable()

	local cacheExteriorID, cachePossVisualIndex = Exterior:LuaFnGetCurrentRanSeSetInfo("POSS")
	g_CurPossVisualIndex = cachePossVisualIndex + 1
	if cacheExteriorID > 0 then
		g_TargetExteriorID = cacheExteriorID
		--g_CurSelExteriorID = cacheExteriorID	
	end

	--EXTERIORFILTTING_TOTALKIND = Exterior:LuaFnGetExteriorPlayerFittingCount()
	
	PetSoul_RanSe_InitList()
	PetSoul_RanSe_CleanUp()
	PetSoul_RanSe_FakeObject:SetFakeObject("PetSoul_RanSe")

	PetSoul_RanSe_UpdateList()

	PetSoul_RanSe_Zidong_ALLChoice_Init()

	PetSoul_RanSe_UpdateObj()
	
	PetSoul_RanSe_UpdateNeedItem()

	PetSoul_RanSe_WantNum:SetProperty("MoneyNumber", tostring(g_NeedMoney));
	PetSoul_RanSe_HaveGoldNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	PetSoul_RanSe_HaveNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	PetSoul_RanSe_RightTitle2:SetText("#{SHRS_230621_148}")
	PetSoul_RanSe_UpdateColorItem()
	PetSoul_RanSe_Jian:Hide()

	if g_YuanbaoPay == 1 or g_YuanbaoPay == 0 then
		PetSoul_RanSe_querenzhifuBind:SetCheck(g_YuanbaoPay)
	end
end

function PetSoul_RanSe_ItemClicked(nIndex)

	if g_ZiDongState == 1 then
		PushDebugMessage("#{SHRS_230621_154}") 
		return
	end 

	local nExteriorID = Exterior:LuaFnGetExteriorIDFromListForRanSe(nIndex - 1)	
	if g_CurSelExteriorID ~= nExteriorID then
		g_CurSelExteriorID = nExteriorID
		if g_CurPossVisualIndex == 0 then
			g_CurPossVisualIndex = 1
		end
		
		g_SelectPlan = 0
		
		Exterior:LuaFnSetCurrentRanSeSetInfo("POSS", g_CurSelExteriorID, g_CurPossVisualIndex - 1)

		Exterior:LuaFnSetCurrentRanSeSetInfo("RANSE", g_CurSelExteriorID, 0)

		PetSoul_RanSe_UpdateObj()

		PetSoul_RanSe_SetItemSelected(nIndex)

		PetSoul_RanSe_UpdateColorItem()

		if g_ZiDongState == 0 then
			PetSoul_RanSe_UpdateAutoList()
		end 
		PetSoul_RanSe_Jian:Show()
		PushEvent("CHANGE_PETSOUL_RANSE_JIAN", g_CurSelExteriorID)
	end

end

function PetSoul_RanSe_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("PetSoul_RanSe_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					
				else
					ctrlAction:SetPushed(0)	
				
				end
			end
		end
	end
end

function PetSoul_RanSe_ItemMouseMove(idx)

end

function PetSoul_RanSe_UpdateNeedItem()
	local nCount = PlayerPackage:Lua_GetUnLockItemCount(g_Item)
	local nBindCount = PlayerPackage:Lua_GetUnLockBindItemCount(g_Item)
	--PetSoul_RanSe_NeedNumBK:Hide()
	if nBindCount == 0 then
		local theAction = DataPool:CreateActionItemForShow(g_Item, nCount)
		PetSoul_RanSe_NeedIcon:SetActionItem(theAction:GetID())
		--PetSoul_RanSe_NeedNum:SetText(nCount)
	else
		local theAction = DataPool:CreateBindActionItemForShow(g_Item, nBindCount)
		PetSoul_RanSe_NeedIcon:SetActionItem(theAction:GetID())
		--PetSoul_RanSe_NeedNum:SetText(nBindCount)
	end
end



function PetSoul_RanSe_UpdateObj()
	local cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentRanSeSetInfo("POSS")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		Exterior:LuaFnUpdatePetSoulRanSePlayerData()		
	end	
	local planstr = Exterior:LuaFnGetCurrentRanSeSetInfo("PLANNAME")
	if planstr ~= nil and planstr ~= "" and planstr ~= -1 then
		local nQuality = Exterior:LuaFnGetCurrentRanSeSetInfo("QUALITY")
		local strdic = ""
		if nQuality == 1 then
			strdic = planstr
		elseif nQuality == 2 then
			strdic = ScriptGlobal_Format("#{RSYH_231120_15}", planstr)
		elseif nQuality == 3 then
			strdic = ScriptGlobal_Format("#{RSYH_231120_16}", planstr)
		end
		PetSoul_RanSe_Text2:SetText(strdic)
	else
		PetSoul_RanSe_Text2:SetText("原始风格")
	end
	PetSoul_RanSe_UpdateCamera()
end

function PetSoul_RanSe_UpdateList()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType, m_PetSoulQual)
	
	local count = Exterior:LuaFnGetRanSeListCount()
	
	for i = 1, g_MaxBarNum do	
		PetSoul_RanSe_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		PetSoul_RanSe_List:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	if g_TargetExteriorIndex ~= 0 then
		PetSoul_RanSe_List:SetScrollPosition4Index(g_TargetExteriorIndex - 1)
		g_TargetExteriorID = 0
		g_TargetExteriorIndex = 0
	else
		PetSoul_RanSe_List:SetScrollPosition4Index(0)
	end
end

function PetSoul_RanSe_SetItem(index, max_count)
	
	if g_BarList[index] == nil then
		return
	end
	
	if index > max_count then
		g_BarList[index]:Hide()
		return
	end
	
	local bar = g_BarList[index]
	bar:Show()
	
	local nExteriorID = Exterior:LuaFnGetExteriorIDFromListForRanSe(index - 1)
	local strName = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Name")
	local strIcon = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Icon")
	local strImage = GetIconFullName(strIcon)
	local bDecoration = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Decoration")
	
	local strQual = ""
	local iQual = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Quality")
	if iQual == 0 or iQual == 1 or iQual == 2 or iQual == 3 then
		strQual = g_QualStr[iQual + 1]
	end
	
	local ctrlAction = bar:GetSubItem("PetSoul_RanSe_SuperListItemAction")
	if ctrlAction ~= nil then
	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		if bDecoration == 1 then
			local strTemp = ScriptGlobal_Format("#{SHRH_20240703_02}", strName)
			if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
				ctrlAction:SetToolTip("#{SHRH_20240703_03}#r"..strTemp.."#r#{SHRH_20220427_03}")
			else
				ctrlAction:SetToolTip("#{SHRH_20240703_03}#r"..strTemp.."#r#{SHRH_20240703_04}")
			end
		else
			local strTemp = ScriptGlobal_Format("#{SHRH_20220427_02}", strName)
			if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
				ctrlAction:SetToolTip(strQual.."#r"..strTemp.."#r#{SHRH_20220427_03}")
			else
				ctrlAction:SetToolTip(strQual.."#r"..strTemp.."#r#{SHRH_20220427_70}")
			end
		end
		--bar:GetSubItem("PetSoul_RanSe_ShiYong"):Hide()
		if g_CurSelExteriorID == nExteriorID then
			ctrlAction:SetPushed(1)
			--if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
				--bar:GetSubItem("PetSoul_RanSe_ShiYong"):Show()
			--end
		else
			ctrlAction:SetPushed(0)
		end
		
		if g_TargetExteriorID == nExteriorID then
			g_TargetExteriorIndex = index
		end
	end

	bar:GetSubItem("PetSoul_RanSe_Mark"):Hide()

	--锁
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
		bar:GetSubItem("PetSoul_RanSe_Lock"):Hide()
		if m_PetSoulQual < iQual and bDecoration ~= 1 then
			bar:GetSubItem("PetSoul_RanSe_Mark"):Show()
		end
	else
		bar:GetSubItem("PetSoul_RanSe_Lock"):Show()
	end	

	--显示装备在身上的
	local curPossessionPetIndex = Pet:LuaFnGetPossessionPetIndex()
	if curPossessionPetIndex and curPossessionPetIndex >= 0 then
		local curPetSoulAction = EnumAction(6*curPossessionPetIndex + 5, "my_pet_equip")
		if curPetSoulAction:GetID() ~= 0 then
			local nTableIndex = Pet:LuaFnGetEquipPetSoulTableIndex(curPossessionPetIndex)
			local nEquipExId = Exterior:LuaFnGetExteriorIdByItemIndex(nTableIndex)
			if nEquipExId == nExteriorID then
				bar:GetSubItem("PetSoul_RanSe_Equip"):Show()
				bar:GetSubItem("PetSoul_RanSe_ShiYong"):Hide()
				bar:GetSubItem("PetSoul_RanSe_Lock"):Hide()
				g_EquipExId = nEquipExId
			else
				bar:GetSubItem("PetSoul_RanSe_Equip"):Hide()
			end
		end
	else
		bar:GetSubItem("PetSoul_RanSe_Equip"):Hide()
	end


	--使用中
	if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID and Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
		bar:GetSubItem("PetSoul_RanSe_ShiYong"):Show()
	else
		bar:GetSubItem("PetSoul_RanSe_ShiYong"):Hide()
	end
	

end

function PetSoul_RanSe_OK_Clicked()
	--
	if g_ZiDongState == 1 then
		PushDebugMessage("#{SHRS_230621_154}") 
		return
	end 

	if g_CurSelExteriorID <= 0 then
		PushDebugMessage("#{SHRS_230621_33}") 
		return 
	end

	if g_SelectPlan <= 0 then
		PushDebugMessage("#{SHRS_230621_35}") 
		return
	end
	
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, g_CurSelExteriorID) ~= 1 and Exterior:LuaFnGetRanSeColorItem(g_CurSelExteriorID, g_SelectPlan) <= 0 
		and g_EquipExId ~= g_CurSelExteriorID then
		PushEvent("PETSOUL_RANSE_CONFIRM",g_TargetId,g_SelectPlan,g_CurSelExteriorID, 0, g_YuanbaoPay)
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnPossPaint")
		Set_XSCRIPT_ScriptID(998506)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_Parameter(1, g_SelectPlan)
		Set_XSCRIPT_Parameter(2, g_CurSelExteriorID)
		Set_XSCRIPT_Parameter(3, 0)
		Set_XSCRIPT_Parameter(4, g_YuanbaoPay)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT() 
end

function PetSoul_RanSe_CleanUp()
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then
			local ctrlAction = g_BarList[i]:GetSubItem("PetSoul_RanSe_SuperList_ItemAction")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
		end
	end
	
	for j = 1, 3 do
		g_PlanButton[j]:SetPushed(0)
		g_RanSeButtonLock[j]:Hide()
		g_RanSeButtonQuality[j]:Hide()
		g_PlanButton[j]:SetProperty("NormalImage", "")
		g_PlanButton[j]:SetProperty("HoverImage", "")
		g_PlanButton[j]:SetProperty("Empty", "False")
		g_PlanButton[j]:SetProperty("UseDefaultTooltip", "True")
	end

	PetSoul_RanSe_FakeObject:SetFakeObject("")
	PetSoul_RanSe_NeedIcon:SetActionItem(-1)
	PetSoul_RanSe_ColorItem1:SetProperty("NormalImage", "")
	PetSoul_RanSe_ColorItem2:SetProperty("NormalImage", "")
	PetSoul_RanSe_ColorItem3:SetProperty("NormalImage", "")
	PetSoul_RanSe_ColorItem1:SetProperty("HoverImage", "")
	PetSoul_RanSe_ColorItem2:SetProperty("HoverImage", "")
	PetSoul_RanSe_ColorItem3:SetProperty("HoverImage", "")
	PetSoul_RanSe_ColorItem1:SetToolTip("")
	PetSoul_RanSe_ColorItem2:SetToolTip("")
	PetSoul_RanSe_ColorItem3:SetToolTip("")
	PetSoul_RanSe_RightText:SetText("")
	PetSoul_RanSe_RightTitle2:SetText("")
	PetSoul_RanSe_Text2:SetText("")
end

function PetSoul_RanSe_Close()
	PetSoul_RanSe_ResetZiDongState()
	PushEvent("PETSOUL_RANSE_CLOSE")
	Exterior:LuaFnSetCurrentRanSeSetInfo("RESET")
	this:Hide()
end

function PetSoul_RanSe_FakeObject_TurnLeft(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		PetSoul_RanSe_FakeObject:RotateBegin(-0.3)
	else
		PetSoul_RanSe_FakeObject:RotateEnd()
	end
end

function PetSoul_RanSe_FakeObject_TurnRight(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
			PetSoul_RanSe_FakeObject:RotateBegin(0.3)
		else
		PetSoul_RanSe_FakeObject:RotateEnd()
	end
end

function PetSoul_RanSe_ZoomIn()
	if g_Distance == g_Distance_Max then
		return
	end	
	g_Distance = g_Distance + 1	
	PetSoul_RanSe_UpdateCamera()
end

function PetSoul_RanSe_ZoomOut()
	if g_Distance == 1 then
		return
	end
	g_Distance = g_Distance - 1		
	PetSoul_RanSe_UpdateCamera()
end


function PetSoul_RanSe_UpdateCamera()
	local sex = Player:GetMySex()
	if sex ~= 0 and sex ~= 1 then 
		return
		end	
		
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end	
	
	local fHeight = g_CameraPosition[sex][g_Distance].fHeight
	local fDistance = g_CameraPosition[sex][g_Distance].fDistance
	local fPitch = g_CameraPosition[sex][g_Distance].fPitch
	FakeObj_SetCamera("PetSoul_RanSe", g_CameraHeight, fHeight)
	FakeObj_SetCamera("PetSoul_RanSe", g_CameraDistance, fDistance)
	FakeObj_SetCamera("PetSoul_RanSe", g_CameraPitch, fPitch)
end


function PetSoul_RanSe_SelectColorButton(idx)

	if g_ZiDongState == 1 then
		PushDebugMessage("#{SHRS_230621_154}") 
		return
	end 

	if idx < 1 or idx > 3 then
		return
	end

	g_SelectPlan = idx;
	
	if g_CurSelExteriorID <= 0 then
		return 
	end
	for j = 1, 3 do
		g_PlanButton[j]:SetPushed(0)
	end

	g_PlanButton[idx]:SetPushed(1)

	local nColor = Exterior:LuaFnGetRanSeColorItem(g_CurSelExteriorID, g_SelectPlan)

	Exterior:LuaFnSetCurrentRanSeSetInfo("RANSE", g_CurSelExteriorID, nColor)

	PetSoul_RanSe_UpdateAutoList()

	PetSoul_RanSe_UpdateObj()

end

function PetSoul_RanSe_UpdateColorItem()

	if g_CurSelExteriorID <= 0 then
		return 
	end

	for j = 1, 3 do
		g_PlanButton[j]:SetPushed(0)
		g_RanSeButtonLock[j]:Hide()
		g_RanSeButtonQuality[j]:Hide()
		g_PlanButton[j]:SetProperty("NormalImage", "")
		g_PlanButton[j]:SetProperty("HoverImage", "")
		g_PlanButton[j]:SetProperty("Empty", "False")
		g_PlanButton[j]:SetProperty("UseDefaultTooltip", "True")
	end

	for j = 1, 3 do
		local nColor = Exterior:LuaFnGetRanSeColorItem(g_CurSelExteriorID, j)
		local planstr

		if (nColor <= 0) then
			planstr = "原始风格"
			g_RanSeButtonLock[j]:Show()
			g_RanSeButtonQuality[j]:Hide()
			local strIcon = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Icon")
			local strImage = GetIconFullName(strIcon)
			g_PlanButton[j]:SetProperty("NormalImage", strImage)
			g_PlanButton[j]:SetProperty("HoverImage", strImage)

		else
			planstr = Exterior:LuaFnGetRanSePlanName(g_CurSelExteriorID, nColor)
			local strIcon = Exterior:LuaFnGetRanSePlanImage(g_CurSelExteriorID, nColor)
			local strImage = GetIconFullName(strIcon)
			g_PlanButton[j]:SetProperty("NormalImage", strImage)
			g_PlanButton[j]:SetProperty("HoverImage", strImage)

			g_RanSeButtonLock[j]:Hide()

			local nQuality = Exterior:LuaFnGetQualityForRanSe(g_CurSelExteriorID, nColor)
			if nQuality >= 3 then
				g_RanSeButtonQuality[j]:Show()
			end
		end

		g_PlanButton[j]:SetToolTip(planstr)

	end

	local strName = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Name")
	local strTemp = ScriptGlobal_Format("#{SHRS_230621_15}", strName)
	PetSoul_RanSe_RightTitle2:SetText(strTemp)

	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, g_CurSelExteriorID) == 1 then
		local iQual = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Quality")
		local bDecoration = Exterior:LuaFnGetExteriorPossInfo(g_CurSelExteriorID, "Decoration")
		if m_PetSoulQual < iQual and bDecoration ~= 1 then
			PetSoul_RanSe_RightText:SetText("#{SHRS_230621_145}")
			return
		end
		PetSoul_RanSe_RightText:SetText("#{SHRS_230621_146}")
	else
		--显示装备在身上的
		local curPossessionPetIndex = Pet:LuaFnGetPossessionPetIndex()
		if curPossessionPetIndex and curPossessionPetIndex >= 0 then
			local curPetSoulAction = EnumAction(6*curPossessionPetIndex + 5, "my_pet_equip")
			if curPetSoulAction:GetID() ~= 0 then
				local nTableIndex = Pet:LuaFnGetEquipPetSoulTableIndex(curPossessionPetIndex)
				local nEquipExId = Exterior:LuaFnGetExteriorIdByItemIndex(nTableIndex)
				if nEquipExId == g_CurSelExteriorID then
					PetSoul_RanSe_RightText:SetText("#{SHRS_230621_146}")
				end
			end
		else
			PetSoul_RanSe_RightText:SetText("#{SHRS_230621_145}")
		end
	end	

end


--初始化自动状态 并构造数据
function PetSoul_RanSe_Zidong_ALLChoice_Init() 
	PetSoul_RanSe_Zidong_ALLChoice:ResetList()  	
	PetSoul_RanSe_Zidong_ALLChoice:SetText("#{SHRS_230621_149}")--选择目标染色风格  

	if ( g_CurSelExteriorID <= 0 ) then  
		
		PetSoul_RanSe_Zidong_ALLChoice:Disable()
		PetSoul_RanSe_Zidong_ALLChoice:SetText("#{SHRS_230621_149}")--选择目标染色风格  
		PetSoul_RanSe_Zidong_Animate:Play(false)
		PetSoul_RanSe_Zidong:SetText("#{SHRS_230621_152}")
		PetSoul_RanSe_Zidong:Disable()
		return
	end

	local nPlanCount = Exterior:LuaFnGetRanSePlanCount(g_CurSelExteriorID)
	if nPlanCount == 0 then
		return 
	end

	for i = 1, nPlanCount do
		local planstr = Exterior:LuaFnGetRanSePlanName(g_CurSelExteriorID, i)
		if planstr ~= nil then
			PetSoul_RanSe_Zidong_ALLChoice:AddTextItem(planstr, i)
		end
	end
	PetSoul_RanSe_Zidong_ALLChoice:AddTextItem("#{SHRS_230621_150}",nPlanCount+1)

	PetSoul_RanSe_Zidong_ALLChoice:Enable() 
end

function PetSoul_RanSe_UpdateAutoList()

	PetSoul_RanSe_Zidong_ALLChoice:ResetList()  	
	PetSoul_RanSe_Zidong_ALLChoice:SetText("#{SHRS_230621_149}")--选择目标染色风格  
	PetSoul_RanSe_Zidong_ALLChoice:Disable()
	PetSoul_RanSe_Zidong_Animate:Play(false)
	PetSoul_RanSe_Zidong:SetText("#{SHRS_230621_152}")
	PetSoul_RanSe_Zidong:Disable()
	g_TargetPlan = 0
	g_IsXiYouStop = 0
	local nPlanCount = Exterior:LuaFnGetRanSePlanCount(g_CurSelExteriorID)
	if nPlanCount == 0 then
		return 
	end

	for i = 1, nPlanCount do
		local planstr = Exterior:LuaFnGetRanSePlanName(g_CurSelExteriorID, i)
		if planstr ~= nil then
			PetSoul_RanSe_Zidong_ALLChoice:AddTextItem(planstr, i)
		end
	end
	PetSoul_RanSe_Zidong_ALLChoice:AddTextItem("#{SHRS_230621_150}",nPlanCount+1)

	PetSoul_RanSe_Zidong_ALLChoice:Enable() 

end

function PetSoul_RanSe_AutoListChanged()

	if g_ZiDongState == 1 then
		PushDebugMessage("#{SHRS_230621_154}") 
		PetSoul_RanSe_Zidong_ALLChoice:SetCurrentSelect(g_TargetPlan)
		return
	end 

	local nPlanCount = Exterior:LuaFnGetRanSePlanCount(g_CurSelExteriorID)
	if nPlanCount == 0 then
		return 
	end

	local _name,ComIdx = PetSoul_RanSe_Zidong_ALLChoice:GetCurrentSelect()
	if ComIdx == nPlanCount + 1 then
		g_IsXiYouStop = 1
	else
		g_IsXiYouStop = 0
	end 

	g_TargetPlan = ComIdx

	if ComIdx > 0 then 
		PetSoul_RanSe_Zidong:SetText("#G#{SHRS_230621_152}") 
		PetSoul_RanSe_Zidong:Enable()
		PetSoul_RanSe_Zidong_Animate:Play(true)
	else
		PetSoul_RanSe_Zidong:SetText("#{SHRS_230621_152}") 
		PetSoul_RanSe_Zidong:Disable() 
		PetSoul_RanSe_Zidong_Animate:Play(false)
	end 

	local nColor = Exterior:LuaFnGetRanSeColorItem(g_CurSelExteriorID, g_SelectPlan)
	local nQuality = Exterior:LuaFnGetQualityForRanSe(g_CurSelExteriorID, nColor)

	if nColor == ComIdx or (nQuality >= 3 and g_IsXiYouStop == 1) then 
		PetSoul_RanSe_Zidong:SetText("#{SHRS_230621_152}") 
		PetSoul_RanSe_Zidong:Disable()
		PetSoul_RanSe_Zidong_Animate:Play(false)
		PushDebugMessage("#{SHRS_230621_151}")
	end  

end

--点击自动染色事件
function PetSoul_RanSe_Zidong_Clicked()			--自动开启  开启timer事件
	if g_ZiDongState == 0 then 
		
		if g_SelectPlan <= 0 then
			PushDebugMessage("#{SHRS_230621_35}")
			return
		end

		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
		if selfMoney < g_NeedMoney then
			PushDebugMessage("#{SHRS_230621_155}")
			return
		end

		if Exterior:LuaFnIsHaveExterior(g_ExteriorType, g_CurSelExteriorID) ~= 1 and Exterior:LuaFnGetRanSeColorItem(g_CurSelExteriorID, g_SelectPlan) <= 0 and 
			g_Confirm == 0 and g_EquipExId ~= g_CurSelExteriorID then
			PushEvent("PETSOUL_RANSE_ZIDONG_CONFIRM", 1,g_SelectPlan, g_CurSelExteriorID)
			return
		end

		local nColor = Exterior:LuaFnGetRanSeColorItem(g_CurSelExteriorID, g_SelectPlan);
		local nQuality = Exterior:LuaFnGetQualityForRanSe(g_CurSelExteriorID, nColor)

		if nQuality >= 3 and g_Confirm == 0 then
			PushEvent("PETSOUL_RANSE_ZIDONG_CONFIRM",2,g_SelectPlan, g_CurSelExteriorID)
			return
		end

		g_IsFirstAuto       = 1

		g_ZiDongState 		= 1
		g_ZiDongTimerState	= 1
		g_RecvGRespState    = 1
		SetTimer("PetSoul_RanSe","PetSoul_RanSe_TimerEvent()", g_Zidong_ClickTime)
		PetSoul_RanSe_Zidong_ALLChoice:Disable() 

	else 
		PushDebugMessage("#{YJRS_140613_17}")
		PetSoul_RanSe_ResetZiDongState()
	end
end

function PetSoul_RanSe_TimerEvent()
	if g_ZiDongTimerState == 1  and g_RecvGRespState == 1 then 
 	  	
 	  	if g_SelectPlan <= 0 then
			PushDebugMessage("#{SHRS_230621_35}")
			return
		end

		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
		if selfMoney < g_NeedMoney then
			PushDebugMessage("#{YJRS_140613_14}")
			PetSoul_RanSe_ResetZiDongState()
			return
		end
		

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAutoRanSe")
				Set_XSCRIPT_ScriptID(998506)
				Set_XSCRIPT_Parameter(0, g_TargetId)
				Set_XSCRIPT_Parameter(1, g_SelectPlan)
				Set_XSCRIPT_Parameter(2, g_CurSelExteriorID)
				Set_XSCRIPT_Parameter(3, g_IsFirstAuto)			--是否是第一次自动染色  为了区别显示不同内容  1 代表第一次 0不是
				Set_XSCRIPT_ParamCount(4)
			Send_XSCRIPT() 
		g_RecvGRespState    = 0 
		g_IsFirstAuto       = 0
 	end 
end

--重置自动状态 1.点击停止 关闭窗口时
function PetSoul_RanSe_ResetZiDongState()
	local _name,ComIdx = PetSoul_RanSe_Zidong_ALLChoice:GetCurrentSelect()
	if ComIdx > 0 then
		PetSoul_RanSe_Zidong:SetText("#{SHRS_230621_152}") 
		PetSoul_RanSe_Zidong:Disable()
		PetSoul_RanSe_Zidong_Animate:Play(false)
		PetSoul_RanSe_Zidong_ALLChoice:Enable() 
		PetSoul_RanSe_Zidong_ALLChoice:SetText("#{SHRS_230621_149}")--选择目标染色风格  
	end 

	PetSoul_RanSe_Zidong:SetText("#{SHRS_230621_152}")
	
	if g_ZiDongState == 1  then 
		KillTimer("PetSoul_RanSe_TimerEvent()") 
	end  

	g_ZiDongState 		= 0			
	g_ZiDongTimerState	= 0
	g_RecvGRespState    = 0 
	g_Confirm 			= 0
end	

--染出目标颜色
function PetSoul_RanSe_SuccDestMode()
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnSuccRanSe")
		Set_XSCRIPT_ScriptID(998506) 
		Set_XSCRIPT_Parameter(0, g_SelectPlan)
		Set_XSCRIPT_Parameter(1, g_CurSelExteriorID)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()  

end

function PetSoul_RanSe_JianClicked()
	PushEvent("OPEN_PETSOUL_RANSE_JIAN", g_CurSelExteriorID)
end

-- 将按钮设置成终止状态
function PetSoul_RanSe_RetSetZidongButtonText()
	PetSoul_RanSe_Zidong:SetText("#{SHRS_230621_153}")
end

function PetSoul_RanSe_QueRenZhiFu_Clicked()
	if g_YuanbaoPay == 1 then
		PushDebugMessage("#{RSYH_231120_05}")
	else
		PushDebugMessage("#{RSYH_231120_04}")
	end

	g_YuanbaoPay = PetSoul_RanSe_querenzhifuBind:GetCheck()

end