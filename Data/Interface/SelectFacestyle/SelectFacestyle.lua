--!!!reloadscript =SelectFacestyle

local g_SelectFacestyle_Frame_UnifiedPosition
local g_SelectFacestyle_YuanbaoPay = 1

local g_clientNpcId = -1
local g_ExteriorType = 0 						--??

local g_InitList = 0
local g_NeedChangeScrollSize = 1

local g_MaxBarNum = 0
local g_BarList = {}
local g_CurSelExteriorID = 0					--???????ID,?1??
local g_OriCharFace = 0

local SelectFacestyle_CameraHeight = 1			--?????
local SelectFacestyle_CameraDistance = 2		--?????
local SelectFacestyle_CameraPitch = 3
local g_SelectFacestyle_CameraLevel = 0
local g_SelectFacestyle_CameraPosition =
{
	--Å®ÐÔÏà¹ØÎ»ÖÃ
	[0] = {
		[0] = {fHeight = 1.6, fDistance = 1.8, fPitch = 0.1},
		[1] = {fHeight = 1.6, fDistance = 2, fPitch = 0.1},
		[2] = {fHeight = 1.6, fDistance = 4, fPitch = 0.1},
		},
	--ÄÐÐÔÏà¹ØÎ»ÖÃ
	[1] = {
		[0] = {fHeight = 1.80, fDistance = 1.85, fPitch = 0.2},
		[1] = {fHeight = 1.78, fDistance = 1.35, fPitch = 0.2},
		[2] = {fHeight = 1.78, fDistance = 1.35, fPitch = 0.2},
		},
}

local g_YB_Clicked = 0

--==================================
-- SelectFacestyle_PreLoad
--==================================
function SelectFacestyle_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("PLAYER_FACE_CHANGED", false)
	this:RegisterEvent("OPEN_DRESSPREVIEW")
end

--==================================
-- SelectFacestyle_OnLoad
--==================================
function SelectFacestyle_OnLoad()
	g_SelectFacestyle_Frame_UnifiedPosition = SelectFacestyle_Frame:GetProperty("UnifiedPosition")
	g_CurSelExteriorID = 0
end

function SelectFacestyle_Frame_On_ResetPos()
	SelectFacestyle_Frame:SetProperty("UnifiedPosition", g_SelectFacestyle_Frame_UnifiedPosition)
end
--==================================
-- SelectFacestyle_OnEvent
--==================================
function SelectFacestyle_OnEvent(event)
	if event == "UI_COMMAND" then
		if tonumber(arg0) == 80502901 then
			
			if this:IsVisible() then
				return
			end
			
			local npcObjId = Get_XParam_INT(0)
			g_clientNpcId = DataPool:GetNPCIDByServerID(npcObjId)
			if g_clientNpcId ~= -1 then
				this:CareObject(g_clientNpcId, 1, "SelectFacestyle")
			end
		
			if IsWindowShow("SelectHairstyle") then
				CloseWindow("SelectHairstyle", true)
			end

			if IsWindowShow("SelectHairColor") then
				CloseWindow("SelectHairColor", true)
			end
			
			if IsWindowShow("DressPaint_TB") then
				CloseWindow("DressPaint_TB", true)
			end

			PushEvent( "CLOSE_DRESSPREVIEW") 	
			PushEvent( "CLOSE_GEMEFFECTPREVIEW")

			this:Show()
			SelectFacestyle_OnShown()
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		SelectFacestyle_Frame_On_ResetPos()
	elseif event == "PLAYER_FACE_CHANGED" and this:IsVisible() then
		g_OriCharFace = DataPool:Get_MyFaceStyle()
		SelectFacestyle_UpdateList()
		SelectFacestyle_ShowDetail()
	end
	
	-- FakeObjectÄ£ÐÍ½çÃæ»¥³â
	if ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then   --????
		if (this:IsVisible()) then
			this:Hide()
			return
		end
	end	

end

function SelectFacestyle_InitList()
	
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetExteriorMaxCount(g_ExteriorType)
		
		for i = 1, g_MaxBarNum do
			local bar = SelectFacestyle_StyleList:AddChild("SelectFacestyle_SuperListItem")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("SelectFacestyle_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("SelectFacestyle_ItemClicked(%d)", i))
			bar:GetSubItem("SelectFacestyle_SuperListItemAction"):SetEvent("MouseMove", string.format("SelectFacestyle_ItemMouseMove(%d)", i))
			bar:GetSubItem("SelectFacestyle_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("SelectFacestyle_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end
		g_InitList = 1
	end
end

function SelectFacestyle_OnShown()
	
	g_NeedChangeScrollSize = 1
	g_Distance = 1
	
	if g_SelectFacestyle_YuanbaoPay == 1 or g_SelectFacestyle_YuanbaoPay == 0 then
		SelectFacestyle_Blank_Queren:SetCheck(g_SelectFacestyle_YuanbaoPay)
	end
	
	g_OriCharFace = DataPool:Get_MyFaceStyle()
	
	SelectFacestyle_InitList()
	
	SelectFacestyle_Model:SetFakeObject("Player_Head")
	
	g_CurSelExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
	
	SelectFacestyle_UpdateList()
	
	SelectFacestyle_ShowDetail()
	
	SelectFacestyle_SetCameraPosition()
end

function SelectFacestyle_UpdateList()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType)

	local count = Exterior:LuaFnGetExteriorListCount(g_ExteriorType, 0)
	
	for i = 1, g_MaxBarNum do
		SelectFacestyle_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		SelectFacestyle_StyleList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	SelectFacestyle_ShowDetail()
end

function SelectFacestyle_SetItem(index, max_count)
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
	local charFaceId, _, _, _, IconFile, _, StyleName, reqMenPai = Exterior:LuaFnGetExteriorFaceStyleInfo(nExteriorID)
	local player_menpai = Player:GetData("MEMPAI")
	
	if charFaceId > 0 then
		local ctrlAction = bar:GetSubItem("SelectFacestyle_SuperListItemAction")
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
		bar:GetSubItem("SelectFacestyle_SuperListItemActionTry"):Hide()
		bar:GetSubItem("SelectFacestyle_SuperListItemActionDef"):Hide()

		if nExteriorID == Exterior:LuaFnGetExteriorInUse(g_ExteriorType) then
			--µ±Ç° ýÔÚ×°±¸µÄ
			bar:GetSubItem("SelectFacestyle_SuperListItemActionDef"):Show()
		end

		if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then		
			bar:GetSubItem("SelectFacestyle_SuperListItemActionMask"):Hide()
			bar:GetSubItem("SelectFacestyle_SuperListItemActionLock"):Hide()
		else
			if reqMenPai ~= -1 and player_menpai ~= reqMenPai then
				bar:GetSubItem("SelectFacestyle_SuperListItemActionMask"):Show()
			else 
				bar:GetSubItem("SelectFacestyle_SuperListItemActionMask"):Hide()
			end
			bar:GetSubItem("SelectFacestyle_SuperListItemActionLock"):Show()
		end	
	end
end

function SelectFacestyle_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("SelectFacestyle_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					--g_BarList[i]:GetSubItem("SelectFacestyle_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("SelectFacestyle_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("SelectFacestyle_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function SelectFacestyle_ItemClicked(nIndex)
	
	local nExteriorID 	= Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	if g_CurSelExteriorID == nExteriorID then
		return
	end	

	g_CurSelExteriorID = nExteriorID
	
	SelectFacestyle_SetItemSelected(nIndex)
	
	SelectFacestyle_ShowDetail()
end

function SelectFacestyle_ShowDetail()
	
	if g_CurSelExteriorID == 0 then
		SelectFacestyle_WarningText:SetText("#{GXHDZ_141121_02}")
		return
	end
	
	local charFaceId, ItemID, _, _, _, CostMoney, _, reqMenPai = Exterior:LuaFnGetExteriorFaceStyleInfo(g_CurSelExteriorID)
	if charFaceId <= 0 then
		return
	end
	
	local player_menpai = Player:GetData("MEMPAI")
	
	local name, icon = LifeAbility:GetPrescr_Material(ItemID)
	
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, g_CurSelExteriorID) == 1 then	
		
		SelectFacestyle_Accept:SetText("#{GXHDZ_141121_04}")
		
		if reqMenPai == -1 then
			SelectFacestyle_WarningText:SetText("#{GXHDZ_141121_03}")				
		elseif player_menpai == reqMenPai then
			local menpainame = SelectFacestyle_GetMenpaiString(reqMenPai)
			local scriptglobal = ScriptGlobal_Format("#{HWMP_200619_06}", menpainame)
			SelectFacestyle_WarningText:SetText(scriptglobal.."#r".."#{GXHDZ_141121_03}")
		else 
			local menpainame = SelectFacestyle_GetMenpaiString(reqMenPai)
			local scriptglobal = ScriptGlobal_Format("#{HWMP_200619_05}", menpainame)
			SelectFacestyle_WarningText:SetText(scriptglobal.."#r".."#{GXHDZ_141121_03}")
		end
		
		if g_CurSelExteriorID == Exterior:LuaFnGetExteriorInUse(g_ExteriorType) then
			--µ±Ç° ýÔÚ×°±¸µÄ
			SelectFacestyle_WarningText:SetText("#{WGYH_210827_01}")
		end
	else
		SelectFacestyle_Accept:SetText("#{GXHDZ_141121_10}")
		if reqMenPai == -1 then
			SelectFacestyle_WarningText:SetText("C¥n ðÕo cø: #G"..name.."#r#W C¥n tiêu hao: #Y#{_EXCHG"..CostMoney.."}#r".."#{GXHDZ_141121_05}")
		elseif player_menpai ==  reqMenPai then
			local menpainame = SelectFacestyle_GetMenpaiString(reqMenPai)
			local scriptglobal = ScriptGlobal_Format("#{HWMP_200619_04}", menpainame)
			SelectFacestyle_WarningText : SetText("C¥n ðÕo cø: #G"..name.."#r#W C¥n tiêu hao: #Y#{_EXCHG"..CostMoney.."}".."#r"..scriptglobal.."#r".."#{GXHDZ_141121_05}")		
		else 
			local menpainame = SelectFacestyle_GetMenpaiString(reqMenPai)
			local scriptglobal = ScriptGlobal_Format("#{HWMP_200619_03}", menpainame)
			SelectFacestyle_WarningText:SetText("C¥n ðÕo cø: #G"..name.."#r#W C¥n tiêu hao: #Y#{_EXCHG"..CostMoney.."}".."#r"..scriptglobal.."#r".."#{GXHDZ_141121_05}")	
		end
	end

	DataPool:Change_MyFaceStyle(charFaceId)
end

function SelectFacestyle_OK_Clicked()
	
	if g_CurSelExteriorID == 0 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UnlockAndChangeExteriorFaceId")
		Set_XSCRIPT_ScriptID(805029)
		Set_XSCRIPT_Parameter(0, g_CurSelExteriorID)
		Set_XSCRIPT_Parameter(1, g_SelectFacestyle_YuanbaoPay)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	

end

function SelectFacestyle_ItemMouseMove(nIndex)

end

function SelectFacestyle_YB_Clicked()
	g_YB_Clicked = 1
	g_SelectFacestyle_YuanbaoPay = SelectFacestyle_Blank_Queren:GetCheck()
end

function SelectFacestyle_YB_MouseButtonUp()
	if g_YB_Clicked == 1 then
		g_YB_Clicked = 0
	end
	
	if g_SelectFacestyle_YuanbaoPay == 1 or g_SelectFacestyle_YuanbaoPay == 0 then
		SelectFacestyle_Blank_Queren:SetCheck(g_SelectFacestyle_YuanbaoPay)
	end
end

function SelectFacestyle_OnCancel()
	this:Hide()
end

function SelectFacestyle_OnClose()
	this:Hide()	
end

function SelectFacestyle_OnHidden()	
	PushEvent("CONVENIENT_BUY_CONFIRM_CLOSE")
	DataPool:Change_MyFaceStyle(g_OriCharFace)
	SelectFacestyle_CleanUp()
end

function SelectFacestyle_CleanUp()
	SelectFacestyle_Model:SetFakeObject("")
	g_CurSelExteriorID = 0
	this:CareObject(g_clientNpcId, 0, "SelectFacestyle")
	g_clientNpcId = -1
end

--==================================
--×ó×ª
--==================================
function SelectFacestyle_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			SelectFacestyle_Model:RotateBegin(-0.3);
		else
			SelectFacestyle_Model:RotateEnd();
		end
	end
end

--==================================
--ÓÒ×ª
--==================================
function SelectFacestyle_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			SelectFacestyle_Model:RotateBegin(0.3);
		else
			SelectFacestyle_Model:RotateEnd();
		end
	end
end

--·Å´ó
function SelectFacestyle_ZoomIn()
	if g_SelectFacestyle_CameraLevel < 1  or g_SelectFacestyle_CameraLevel > 2 then
		return
	end
	
	g_SelectFacestyle_CameraLevel = g_SelectFacestyle_CameraLevel - 1
	SelectFacestyle_SetCameraPosition()

end

--ËõÐ¡
function SelectFacestyle_ZoomOut()
	if g_SelectFacestyle_CameraLevel < 0  or g_SelectFacestyle_CameraLevel > 1 then
		return
	end
	
	g_SelectFacestyle_CameraLevel = g_SelectFacestyle_CameraLevel + 1
	SelectFacestyle_SetCameraPosition()
end

function SelectFacestyle_SetCameraPosition()
	local sex = Player:GetMySex()
	if sex ~= 0 and sex ~= 1 then
		return
	end

	if g_SelectFacestyle_CameraLevel > -1 and g_SelectFacestyle_CameraLevel < 3 then
		FakeObj_SetCamera( "Player_Head", SelectFacestyle_CameraHeight, g_SelectFacestyle_CameraPosition[sex][g_SelectFacestyle_CameraLevel].fHeight )
		FakeObj_SetCamera( "Player_Head", SelectFacestyle_CameraDistance, g_SelectFacestyle_CameraPosition[sex][g_SelectFacestyle_CameraLevel].fDistance )
		FakeObj_SetCamera( "Player_Head", SelectFacestyle_CameraPitch, g_SelectFacestyle_CameraPosition[sex][g_SelectFacestyle_CameraLevel].fPitch )
	end
end

function SelectFacestyle_GetMenpaiString(menpai)
	
	local strName = ""

	--µÃµ½ÃÅÅÉÃû³Æ
	if 0 == menpai then
		strName = "#{GMItem_4}"
	elseif 1 == menpai then
		strName = "#{GMItem_5}"
	elseif 2 == menpai then
		strName = "#{GMItem_6}"
	elseif 3 == menpai then
		strName = "#{GMItem_7}"
	elseif 4 == menpai then
		strName = "#{GMItem_8}"
	elseif 5 == menpai then
		strName = "#{GMItem_9}"
	elseif 6 == menpai then
		strName = "#{GMItem_10}"
	elseif 7 == menpai then
		strName = "#{GMItem_11}"
	elseif 8 == menpai then
		strName = "#{GMItem_12}"
	elseif 9 == menpai then
		strName = "Tñ do"
	elseif 10 == menpai then
		strName = "#{GMItem_17}"
	elseif 11 == menpai then--MPTODO menpai11
		strName = "#{GMGameInterface_Script_DataPool_Info_ERenGu}"
	end

	return strName
end
