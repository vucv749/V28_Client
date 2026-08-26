--!!!reloadscript =SelectHairstyle

local g_SelectHairstyle_Frame_UnifiedPosition
local g_SelectHairstyle_YuanbaoPay = 1

local g_clientNpcId = -1
local g_ExteriorType = 1 						--??

local g_InitList = 0
local g_NeedChangeScrollSize = 1

local g_MaxBarNum = 0
local g_BarList = {}
local g_CurSelExteriorID = 0					--???????ID,?1??
local g_OriCharHair = 0

local SelectHairstyle_CameraHeight = 1			--?????
local SelectHairstyle_CameraDistance = 2		--?????
local SelectHairstyle_CameraPitch = 3
local g_SelectHairstyle_CameraLevel = 0
local g_SelectHairstyle_CameraPosition =
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

function SelectHairstyle_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("PLAYER_HAIR_CHANGED", false)
	this:RegisterEvent("OPEN_DRESSPREVIEW")
end

function SelectHairstyle_OnLoad()	
	g_SelectHairstyle_Frame_UnifiedPosition=SelectHairstyle_Frame:GetProperty("UnifiedPosition")
end

function SelectHairstyle_Frame_On_ResetPos()
	SelectHairstyle_Frame:SetProperty("UnifiedPosition", g_SelectHairstyle_Frame_UnifiedPosition);
end

function SelectHairstyle_OnEvent(event)
	if event == "UI_COMMAND" then
		if tonumber(arg0) == 80101001 then
		
			if this:IsVisible() then
				return
			end
			
			local npcObjId = Get_XParam_INT(0)
			g_clientNpcId = DataPool:GetNPCIDByServerID(npcObjId)
			if g_clientNpcId ~= -1 then
				this:CareObject(g_clientNpcId, 1, "SelectHairstyle")
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
			
			PushEvent( "CLOSE_DRESSPREVIEW")
			PushEvent( "CLOSE_GEMEFFECTPREVIEW")

			this:Show()
			SelectHairstyle_OnShown()
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		SelectHairstyle_Frame_On_ResetPos()
	elseif event == "PLAYER_HAIR_CHANGED" and this:IsVisible() then
		g_OriCharHair = DataPool:Get_MyHairStyle()
		SelectHairstyle_UpdateList()
		SelectHairstyle_ShowDetail()
	end
	
	-- FakeObjectÄ£ÐÍ½çÃæ»¥³â
	if ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then   --????
		if (this:IsVisible()) then
			this:Hide()
			return
		end
	end	
end

function SelectHairstyle_InitList()
	
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetExteriorMaxCount(g_ExteriorType)
		
		for i = 1, g_MaxBarNum do
			local bar = SelectHairstyle_StyleList:AddChild("SelectHairstyle_SuperListItem")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("SelectHairstyle_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("SelectHairstyle_ItemClicked(%d)", i))
			bar:GetSubItem("SelectHairstyle_SuperListItemAction"):SetEvent("MouseMove", string.format("SelectHairstyle_ItemMouseMove(%d)", i))
			bar:GetSubItem("SelectHairstyle_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("SelectHairstyle_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end
		g_InitList = 1
	end
end

function SelectHairstyle_OnShown()
	
	g_NeedChangeScrollSize = 1
	g_Distance = 1

	if g_SelectHairstyle_YuanbaoPay == 1 or g_SelectHairstyle_YuanbaoPay == 0 then
		SelectHairstyle_Blank_Queren:SetCheck(g_SelectHairstyle_YuanbaoPay)
	end
	
	g_OriCharHair = DataPool:Get_MyHairStyle()
	
	SelectHairstyle_InitList()
	
	SelectHairstyle_Model:SetFakeObject("Player_Head")

	g_CurSelExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
	
	SelectHairstyle_UpdateList()
	
	SelectHairstyle_ShowDetail()
	
	SelectHairstyle_SetCameraPosition()

end

function SelectHairstyle_UpdateList()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType)
	
	local count = Exterior:LuaFnGetExteriorListCount(g_ExteriorType, 0)

	for i = 1, g_MaxBarNum do
		SelectHairstyle_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		SelectHairstyle_StyleList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
end

function SelectHairstyle_SetItem(index, max_count)
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
	local charHairId, _, _, _, IconFile, _, StyleName, reqMenPai = Exterior:LuaFnGetExteriorHairStyleInfo(nExteriorID)
	local player_menpai = Player:GetData("MEMPAI")
	
	if charHairId >= 0 then
		local ctrlAction = bar:GetSubItem("SelectHairstyle_SuperListItemAction")
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
		bar:GetSubItem("SelectHairstyle_SuperListItemActionTry"):Hide()
		bar:GetSubItem("SelectHairstyle_SuperListItemActionDef"):Hide()
		
		if nExteriorID == Exterior:LuaFnGetExteriorInUse(g_ExteriorType) then
			--µ±Ç° ýÔÚ×°±¸µÄ
			bar:GetSubItem("SelectHairstyle_SuperListItemActionDef"):Show()
		end

		if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
			bar:GetSubItem("SelectHairstyle_SuperListItemActionMask"):Hide()
			bar:GetSubItem("SelectHairstyle_SuperListItemActionLock"):Hide()
		else
			if reqMenPai ~= -1 and player_menpai ~= reqMenPai then
				bar:GetSubItem("SelectHairstyle_SuperListItemActionMask"):Show()
			else 
				bar:GetSubItem("SelectHairstyle_SuperListItemActionMask"):Hide()
			end
			bar:GetSubItem("SelectHairstyle_SuperListItemActionLock"):Show()
		end	
	end
end

function SelectHairstyle_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do
		if g_BarList[i] ~= nil then
			local ctrlAction = g_BarList[i]:GetSubItem("SelectHairstyle_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					--g_BarList[i]:GetSubItem("SelectHairstyle_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("SelectHairstyle_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)
					g_BarList[i]:GetSubItem("SelectHairstyle_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function SelectHairstyle_ItemClicked(nIndex)

	local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	if g_CurSelExteriorID == nExteriorID then
		return
	end	

	g_CurSelExteriorID = nExteriorID
	
	SelectHairstyle_SetItemSelected(nIndex)
	
	SelectHairstyle_ShowDetail()
end

function SelectHairstyle_ShowDetail()
	
	if g_CurSelExteriorID == 0 then
		SelectHairstyle_WarningText:SetText("#{GXHDZ_141121_89}")
		return
	end
	
	local charHairId, ItemID, ItemCount, _, _, CostMoney, _, reqMenPai = Exterior:LuaFnGetExteriorHairStyleInfo(g_CurSelExteriorID)
	if charHairId < 0 then
		return
	end
	
	local player_menpai = Player:GetData("MEMPAI")
	
	local name, icon = LifeAbility:GetPrescr_Material(ItemID)
	
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, g_CurSelExteriorID) == 1 then	
		
		SelectHairstyle_Accept:SetText("#{GXHDZ_141121_04}")
		
		if reqMenPai == -1 then
			SelectHairstyle_WarningText:SetText("#{GXHDZ_141121_21}")			
		elseif  player_menpai ==  reqMenPai then
			local menpainame = SelectHairstyle_GetMenpaiString(reqMenPai)
			local scriptglobal = ScriptGlobal_Format("#{HWMP_200619_13}", menpainame)
			SelectHairstyle_WarningText:SetText(scriptglobal.."#r".."#{GXHDZ_141121_21}")
		else
			local menpainame = SelectHairstyle_GetMenpaiString(reqMenPai)
			local scriptglobal = ScriptGlobal_Format("#{HWMP_200619_12}",menpainame)
			SelectHairstyle_WarningText:SetText(scriptglobal.."#r".."#{GXHDZ_141121_21}")
		end
		
		if g_CurSelExteriorID == Exterior:LuaFnGetExteriorInUse(g_ExteriorType) then
			--µ±Ç° ýÔÚ×°±¸µÄ
			SelectHairstyle_WarningText:SetText("#{WGYH_210827_02}")
		end
	else

		SelectHairstyle_Accept:SetText("#{GXHDZ_141121_10}")
		
		if reqMenPai == -1 then
			SelectHairstyle_WarningText:SetText("C¥n"..name.." : "..ItemCount.."#rc¥n ti«n tài: #{_EXCHG"..CostMoney.."}#r#{GXHDZ_141121_83}")
		elseif  player_menpai ==  reqMenPai then
			local menpainame = SelectHairstyle_GetMenpaiString(reqMenPai)
			local scriptglobal = ScriptGlobal_Format("#{HWMP_200619_11}",menpainame)
			SelectHairstyle_WarningText:SetText("C¥n"..name.." : "..ItemCount.."#rc¥n ti«n tài: #{_EXCHG"..CostMoney.."}#r"..scriptglobal.."#r#{GXHDZ_141121_83}")			
		else
			local menpainame = SelectHairstyle_GetMenpaiString(reqMenPai)
			local scriptglobal = ScriptGlobal_Format("#{HWMP_200619_10}",menpainame)
			SelectHairstyle_WarningText:SetText("C¥n"..name.." : "..ItemCount.."#rc¥n ti«n tài: #{_EXCHG"..CostMoney.."}#r"..scriptglobal.."#r#{GXHDZ_141121_83}")			
		end		
	end

	DataPool:Change_MyHairStyle(charHairId)
end

function SelectHairstyle_OK_Clicked()
	
	if g_CurSelExteriorID == 0 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UnlockAndChangeExteriorHairId")
		Set_XSCRIPT_ScriptID(801010)
		Set_XSCRIPT_Parameter(0, g_CurSelExteriorID)
		Set_XSCRIPT_Parameter(1, g_SelectHairstyle_YuanbaoPay)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function SelectHairstyle_ItemMouseMove(nIndex)

end

function SelectHairstyle_YB_Clicked()
	g_YB_Clicked = 1
	g_SelectHairstyle_YuanbaoPay = SelectHairstyle_Blank_Queren:GetCheck()
end

function SelectHairstyle_YB_MouseButtonUp()
	if g_YB_Clicked == 1 then
		g_YB_Clicked = 0
	end
	
	if g_SelectHairstyle_YuanbaoPay == 1 or g_SelectHairstyle_YuanbaoPay == 0 then
		SelectHairstyle_Blank_Queren:SetCheck(g_SelectHairstyle_YuanbaoPay)
	end
end

function SelectHairstyle_OnCancel()
	this:Hide()
end

function SelectHairstyle_OnClose()
	this:Hide()	
end

function SelectHairstyle_OnHidden()
	SelectHairstyle_CleanUp()
	PushEvent("CONVENIENT_BUY_CONFIRM_CLOSE")
	DataPool:Change_MyHairStyle(g_OriCharHair)
end

function SelectHairstyle_CleanUp()
	SelectHairstyle_Model:SetFakeObject("")
	g_CurSelExteriorID = 0
	this:CareObject(g_clientNpcId, 0, "SelectHairstyle")
	g_clientNpcId = -1
end

--·Å´ó
function SelectHairstyle_ZoomIn()
	if g_SelectHairstyle_CameraLevel < 1  or g_SelectHairstyle_CameraLevel > 2 then
		return
	end
	
	g_SelectHairstyle_CameraLevel = g_SelectHairstyle_CameraLevel - 1
	SelectHairstyle_SetCameraPosition()
end

--ËõÐ¡
function SelectHairstyle_ZoomOut()

	if g_SelectHairstyle_CameraLevel < 0  or g_SelectHairstyle_CameraLevel > 1 then
		return
	end
	
	g_SelectHairstyle_CameraLevel = g_SelectHairstyle_CameraLevel + 1
	SelectHairstyle_SetCameraPosition()
end

function SelectHairstyle_SetCameraPosition()
	
	local sex = Player:GetMySex()
	if sex ~= 0 and sex ~= 1 then
		return
	end

	if g_SelectHairstyle_CameraLevel > -1 and g_SelectHairstyle_CameraLevel < 3 then
		FakeObj_SetCamera( "Player_Head", SelectHairstyle_CameraHeight, g_SelectHairstyle_CameraPosition[sex][g_SelectHairstyle_CameraLevel].fHeight )
		FakeObj_SetCamera( "Player_Head", SelectHairstyle_CameraDistance, g_SelectHairstyle_CameraPosition[sex][g_SelectHairstyle_CameraLevel].fDistance )
		FakeObj_SetCamera( "Player_Head", SelectHairstyle_CameraPitch, g_SelectHairstyle_CameraPosition[sex][g_SelectHairstyle_CameraLevel].fPitch )
	end
end
----------------------------------------------------------------------------------
-- Ðý×ªÈËÎïÍ·ÏñÄ£ÐÍ£¨Ïò×ó)
function Player_Head_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--Ïò×óÐý×ª¿ªÊ¼
		if(start == 1) then
			SelectHairstyle_Model:RotateBegin(-0.3);
		--Ïò×óÐý×ª½áÊø
		else
			SelectHairstyle_Model:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--Ðý×ªÈËÎïÍ·ÏñÄ£ÐÍ£¨ÏòÓÒ)
function Player_Head_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--ÏòÓÒÐý×ª¿ªÊ¼
		if(start == 1) then
			SelectHairstyle_Model:RotateBegin(0.3);
		--ÏòÓÒÐý×ª½áÊø
		else
			SelectHairstyle_Model:RotateEnd();
		end
	end
end

function SelectHairstyle_GetMenpaiString(menpai)
	
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



