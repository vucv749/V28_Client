
local g_KunWu_Expedition_Change_Frame_UnifiedPosition
local g_KunWu_Expedition_Change_CurItemIndex = 1
local g_KunWu_Expedition_Change_CurTeamIndex = 0
local g_KunWu_Expedition_Change_CurIndex = 1
local g_KunWu_Expedition_Change_Kind = 1
local PET_MAX_NUMBER = 6 + 4
local g_KunWu_Expedition_Change_SelectedPetIndex = -1
local g_KunWu_Expedition_Change_PetMaxTili = 100
local g_KunWu_Expedition_Change_PetRequiredTili = 50
local g_KunWu_Expedition_Change_ListItem ={}
local g_KunWu_Expedition_Change_KWText = 
{
	[0] = "#{ZSPQ_241216_149}",
	[1] = "#{JLJC_241216_27}",
	[2] = "#{JLJC_241216_28}",
	[3] = "#{JLJC_241216_29}",
	[4] = "#{JLJC_241216_30}",
	[5] = "#{JLJC_241216_31}",
}

function KunWu_Expedition_Change_PreLoad()
	this:RegisterEvent("OPEN_PET_PAIQIAN_CHANGEPET")
	this:RegisterEvent("CLOSE_PET_PAIQIAN_CHANGEPET",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("REFRESH_PET_PAIQIAN_CHOSE",false)
end

function KunWu_Expedition_Change_OnLoad()
	g_KunWu_Expedition_Change_Frame_UnifiedPosition = KunWu_Expedition_ChangeFrameBK:GetProperty("UnifiedPosition")

end

function KunWu_Expedition_Change_OnEvent(event)
	if event == "VIEW_RESOLUTION_CHANGED" then
		KunWu_Expedition_Change_On_ResetPos()
	elseif event == "CLOSE_PET_PAIQIAN_CHANGEPET" then
		KunWu_Expedition_Change_Close()
	elseif event == "ADJEST_UI_POS" then
		KunWu_Expedition_Change_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		KunWu_Expedition_Change_Close()
	elseif event == "REFRESH_PET_PAIQIAN_CHOSE" then
		local nPetDispatchValue, nPetDispatchStrength = Pet:GetPetDispatchInfo(g_KunWu_Expedition_Change_SelectedPetIndex-1)
		if nPetDispatchStrength < g_KunWu_Expedition_Change_PetRequiredTili then
			KunWu_Expedition_ChangePeteRequireTravelPoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_75}",nPetDispatchStrength,g_KunWu_Expedition_Change_PetMaxTili))
		else
			KunWu_Expedition_ChangePeteRequireTravelPoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_124}",nPetDispatchStrength,g_KunWu_Expedition_Change_PetMaxTili))
		end
		local ItemBar = g_KunWu_Expedition_Change_ListItem[g_KunWu_Expedition_Change_CurIndex]
		if ItemBar ~= nil then
			ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_53}")
			local nPetIndex = Pet:Lua_GetPetDispatchIndexFromList(g_KunWu_Expedition_Change_CurIndex - 1)
			local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchFightNum =  Pet:Lua_EnumPetDispatchTableItem(g_KunWu_Expedition_Change_CurItemIndex)
			local nDispatchValue = Pet:Lua_EnumPetDispatchList(nPetIndex, "DispatchValue")
			if nDispatchValue < nRequiredDispatchFightNum then
				ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
			end
			local nDispatchStrength = Pet:Lua_EnumPetDispatchList(nPetIndex, "DispatchStrength")
			if nDispatchStrength < g_KunWu_Expedition_Change_PetRequiredTili then
				ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
			end
			local nIsKaiWu = Pet:Lua_EnumPetDispatchList(nPetIndex, "IsKaiWu")
			if nIsKaiWu ~= 1 then
				ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
			end
			local nIsJianDing = Pet:Lua_EnumPetDispatchList(nPetIndex, "IsJianDing")
			if nIsJianDing ~= 1 then
				ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
			end
		end
		--KunWu_Expedition_Change_OnChosePet()
	elseif event == "OPEN_PET_PAIQIAN_CHANGEPET" then	
		if this:IsVisible() then
			KunWu_Expedition_Change_Close()
			return
		end
		g_KunWu_Expedition_Change_Kind = tonumber( arg0 )
		g_KunWu_Expedition_Change_CurItemIndex = tonumber( arg1 )
		g_KunWu_Expedition_Change_CurTeamIndex = tonumber( arg2 )
		this:Show()
		KunWu_Expedition_Change_Open()
		
	end
	
end

function KunWu_Expedition_Change_Open()
	if g_KunWu_Expedition_Change_Kind == 2 then
		KunWu_Expedition_ChangePetRequirePoint:Show()
	else
		KunWu_Expedition_ChangePetRequirePoint:Hide()
	end
	-- PushDebugMessage("g_KunWu_Expedition_Change_CurItemIndex:"..tostring(g_KunWu_Expedition_Change_CurItemIndex))
	-- PushDebugMessage("g_KunWu_Expedition_Change_CurTeamIndex:"..tostring(g_KunWu_Expedition_Change_CurTeamIndex))
	local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchFightNum,nRequiredKaiwuLevel,nRequiredlingxingLevel =  Pet:Lua_EnumPetDispatchTableItem(g_KunWu_Expedition_Change_CurItemIndex)

	--local nType,nTypeName,nFubenLevel,nRequiredDispatchLevel =  Pet:Lua_EnumPetDispatchTableItem(g_KunWu_Expedition_Change_CurItemIndex)
	KunWu_Expedition_ChangeMissionInfo_Name:SetText(nTypeName)

	local nPetCount = Pet:GetPet_Count()
	--PushDebugMessage("nPetCount:"..tostring(nPetCount))
	if nPetCount < 1 or nPetCount > PET_MAX_NUMBER then
		--PushDebugMessage("没有宠物")

		return
	end

	-- local nPetDispatchLevel,nAddSpeed = Player:GetData("PETDISPATCHLEVEL")
	-- if nPetDispatchLevel < nRequiredDispatchLevel then
	-- 	KunWu_Expedition_ChangeMissionInfo_Level:SetText(ScriptGlobal_Format("#{ZSPQ_241216_68}",nPetDispatchLevel,nRequiredDispatchLevel))
	-- else
	-- 	KunWu_Expedition_ChangeMissionInfo_Level:SetText(ScriptGlobal_Format("#{ZSPQ_241216_123}",nPetDispatchLevel,nRequiredDispatchLevel))

	-- end
	
	-- if g_KunWu_Expedition_Change_Kind == 2 then
	-- 	KunWu_Expedition_ChangeMissionInfo_Level:Show()
	-- else
	--KunWu_Expedition_ChangeMissionInfo_Level:Hide()
	-- end
	Pet:Lua_FilterPetDispatchList(nRequiredDispatchFightNum, nRequiredKaiwuLevel, nRequiredlingxingLevel)
	local nPetNum = Pet:Lua_GetPetDispatchListCount()
	--PushDebugMessage("npetNum:"..tostring(npetNum))
	for i = 1 , nPetNum do
		local nPetIndex = Pet:Lua_GetPetDispatchIndexFromList(i - 1)
		local szPetName = Pet:GetPetList_Appoint(nPetIndex)
		if nPetIndex >=0 and szPetName ~= "" then
			local ItemBar = KunWu_Expedition_ChangePetList:AddChild("KunWu_Expedition_ChangePetList_Item")
		
			local nState = Pet:Lua_EnumPetDispatchList(nPetIndex, "State")
			if nState == 1 then
				ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_54}")
			else
				ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_53}")
				local nDispatchValue = Pet:Lua_EnumPetDispatchList(nPetIndex, "DispatchValue")
				if nDispatchValue < nRequiredDispatchFightNum then
					ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
				end
				local nDispatchStrength = Pet:Lua_EnumPetDispatchList(nPetIndex, "DispatchStrength")
				if nDispatchStrength < g_KunWu_Expedition_Change_PetRequiredTili then
					ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
				end
				local nIsKaiWu = Pet:Lua_EnumPetDispatchList(nPetIndex, "IsKaiWu")
				if nIsKaiWu ~= 1 then
					ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
				end

				local nKaiWuLevel = Pet:Lua_EnumPetDispatchList(nPetIndex, "KaiWuLevel")
				if nKaiWuLevel < nRequiredKaiwuLevel then
					ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
				end
				if g_KunWu_Expedition_Change_Kind == 2 then
					local iLingXing = Pet:GetLixing(nPetIndex)
					if iLingXing < nRequiredlingxingLevel then
						ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
					end
				end

				local nIsJianDing = Pet:Lua_EnumPetDispatchList(nPetIndex, "IsJianDing")
				if nIsJianDing ~= 1 then
					ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetState"):SetText("#{ZSPQ_241216_52}")
				end
			end
			ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetName"):SetText(szPetName)
			ItemBar:SetEvent( "MouseLClick", "KunWu_Expedition_Change_PetItem_Check("..i..")" )
			g_KunWu_Expedition_Change_ListItem[i] = ItemBar
		end
	end
	-- for i = 1 , nPetCount do
	-- 	local ItemBar = KunWu_Expedition_ChangePetList:AddChild("KunWu_Expedition_ChangePetList_Item")
	-- 	local szPetName = Pet:GetPetList_Appoint(i - 1)
	-- 	ItemBar:GetSubItem("KunWu_Expedition_ChangePetList_PetName"):SetText(szPetName)
	-- 	ItemBar:SetEvent( "MouseLClick", "KunWu_Expedition_Change_PetItem_Check("..i..")" )
	-- 	--g_KunWu_Expedition_Change_ListItem[i] = ItemBar
	-- end
	local nStatus,nParamIndex, nFinishTime = Pet:Lua_SelectPetDispatchItem(g_KunWu_Expedition_Change_CurItemIndex, g_KunWu_Expedition_Change_CurTeamIndex)
	local nTitle, nDesc, nParam1, nParam2, nParam3, nParam4, nParam5 = Pet:GetDispatchTaskInfoByParamIndex(nParamIndex,0)
	if nTitle ~= nil then
		KunWu_Expedition_ChangeMissionInfo_Intro:SetText("#{"..nTitle.."}")
	end
	
	local needTime = 30*60--Pet:GetDispatchNeedTime(g_KunWu_Expedition_Change_Kind)
	local showmin = math.floor(needTime/60)
	local showsec = math.mod(needTime,60)

	local showhour = math.floor(showmin/60)
	showmin = math.mod(showmin,60)

	local nStr = string.format("%02d:%02d:%02d", showhour, showmin, showsec)
	KunWu_Expedition_ChangeMissionInfo_Time:SetText(ScriptGlobal_Format("#{ZSPQ_241216_64}",nStr))
	
	KunWu_Expedition_Change_PetItem_Check(1)
end

function KunWu_Expedition_Change_PetItem_Check(index)
	g_KunWu_Expedition_Change_CurIndex = index
	local nPetIndex = Pet:Lua_GetPetDispatchIndexFromList(g_KunWu_Expedition_Change_CurIndex - 1)
	g_KunWu_Expedition_Change_SelectedPetIndex = nPetIndex +1
	if g_KunWu_Expedition_Change_SelectedPetIndex<1 or g_KunWu_Expedition_Change_SelectedPetIndex>10 then
		return
	end
	
	local szPetName = Pet:GetPetList_Appoint(g_KunWu_Expedition_Change_SelectedPetIndex - 1)
	KunWu_Expedition_ChangeFakeObject_PetName:SetText(ScriptGlobal_Format("#{ZSPQ_241216_72}",szPetName))
	-- local nLevel = Pet:GetLevel(g_KunWu_Expedition_Change_SelectedPetIndex-1)
	-- KunWu_Expedition_ChangePetRequirePoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_73}",nLevel))

	local nPetDispatchValue, nPetDispatchStrength = Pet:GetPetDispatchInfo(g_KunWu_Expedition_Change_SelectedPetIndex-1)
	KunWu_Expedition_ChangePeteRequireEnergy:SetText(ScriptGlobal_Format("#{ZSPQ_241216_74}",nPetDispatchValue))
	if nPetDispatchStrength < g_KunWu_Expedition_Change_PetRequiredTili then
		KunWu_Expedition_ChangePeteRequireTravelPoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_75}",nPetDispatchStrength,g_KunWu_Expedition_Change_PetMaxTili))
	else
		KunWu_Expedition_ChangePeteRequireTravelPoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_124}",nPetDispatchStrength,g_KunWu_Expedition_Change_PetMaxTili))

	end
	local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchFightNum,nRequiredKaiwuLevel,nRequiredlingxingLevel =  Pet:Lua_EnumPetDispatchTableItem(g_KunWu_Expedition_Change_CurItemIndex)
	
	if nPetDispatchValue < nRequiredDispatchFightNum then
		KunWu_Expedition_ChangeMissionInfo_RequirePoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_63}", nPetDispatchValue, nRequiredDispatchFightNum))
		KunWu_Expedition_ChangeMissionInfo_RequirePoint_Tips:Show()
	else
		KunWu_Expedition_ChangeMissionInfo_RequirePoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_121}", nPetDispatchValue, nRequiredDispatchFightNum))
		KunWu_Expedition_ChangeMissionInfo_RequirePoint_Tips:Hide()
	end
	if g_KunWu_Expedition_Change_Kind == 2 then
		local iLingXing = Pet:GetLixing(g_KunWu_Expedition_Change_SelectedPetIndex-1)
		if iLingXing >= nRequiredlingxingLevel then
			KunWu_Expedition_ChangePetRequirePoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_176}", iLingXing, nRequiredlingxingLevel))
		else
			KunWu_Expedition_ChangePetRequirePoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_177}", iLingXing, nRequiredlingxingLevel))
		end
	end

	local nKaiWuLevel = Pet:Lua_EnumPetDispatchList(g_KunWu_Expedition_Change_SelectedPetIndex-1, "KaiWuLevel")
	if nKaiWuLevel >= nRequiredKaiwuLevel then
		KunWu_Expedition_ChangeMissionInfo_Level:SetText(ScriptGlobal_Format("#{ZSPQ_241216_123}", nKaiWuLevel, nRequiredKaiwuLevel))
	else
		KunWu_Expedition_ChangeMissionInfo_Level:SetText(ScriptGlobal_Format("#{ZSPQ_241216_68}", nKaiWuLevel, nRequiredKaiwuLevel))
	end

	KunWu_Expedition_ChangeFakeObject:SetFakeObject("")

	Pet:SetDispatchModel(g_KunWu_Expedition_Change_SelectedPetIndex-1)
	KunWu_Expedition_ChangeFakeObject:SetFakeObject("My_DispatchPet")
	local active_count = 0
	for i = 1, 5 do
		local active = Pet:LuaFnIsPetElfActived(g_KunWu_Expedition_Change_SelectedPetIndex-1, i - 1)
		if active == 1 then
			active_count = active_count + 1
		end
	end
	KunWu_Expedition_ChangeFakeObject_PetKaiwu:SetText(tostring(g_KunWu_Expedition_Change_KWText[active_count]))

	local iGrowRate = Pet:GetGrowRate(g_KunWu_Expedition_Change_SelectedPetIndex-1)
	KunWu_Expedition_ChangeFakeObject_PetGrowth:SetText("#cff0000未知")
	local nGrowLevel = Pet:GetPetGrowLevel(g_KunWu_Expedition_Change_SelectedPetIndex-1, tonumber(iGrowRate))
	local strTbl = {"普通", "优秀", "杰出", "卓越", "完美"}
	
	if nGrowLevel >= 0 then
		nGrowLevel = nGrowLevel + 1
		if strTbl[nGrowLevel] ~= nil then
			KunWu_Expedition_ChangeFakeObject_PetGrowth : SetText("#G"..strTbl[nGrowLevel]..iGrowRate)
		end
	end
end

function KunWu_Expedition_Change_FeedPet()
	Pet:Lua_FeedPetAddTili(g_KunWu_Expedition_Change_SelectedPetIndex)
end


function KunWu_Expedition_Change_OnChosePet()
	local nState = Pet:Lua_EnumPetDispatchList(g_KunWu_Expedition_Change_SelectedPetIndex-1, "State")
	if nState == 1 then
		PushDebugMessage("#{ZSPQ_241216_174}")
		return
	else
		local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchFightNum, nRequiredKaiwuLevel, nRequiredlingxingLevel =  Pet:Lua_EnumPetDispatchTableItem(g_KunWu_Expedition_Change_CurItemIndex)
		local nDispatchValue = Pet:Lua_EnumPetDispatchList(g_KunWu_Expedition_Change_SelectedPetIndex-1, "DispatchValue")
		local nIsKaiWu = Pet:Lua_EnumPetDispatchList(g_KunWu_Expedition_Change_SelectedPetIndex-1, "IsKaiWu")
		if nIsKaiWu ~= 1 then
			PushDebugMessage("#{ZSPQ_241216_17}")
			return
		end
		
		if nDispatchValue < nRequiredDispatchFightNum then
			PushDebugMessage("#{ZSPQ_241216_25}")
			return
		end
		
		local nDispatchStrength = Pet:Lua_EnumPetDispatchList(g_KunWu_Expedition_Change_SelectedPetIndex-1, "DispatchStrength")
		if nDispatchStrength < g_KunWu_Expedition_Change_PetRequiredTili then
			PushDebugMessage("#{ZSPQ_241216_35}")
			return
		end
		
		local nKaiWuLevel = Pet:Lua_EnumPetDispatchList(g_KunWu_Expedition_Change_SelectedPetIndex-1, "KaiWuLevel")
		if nKaiWuLevel < nRequiredKaiwuLevel then
			PushDebugMessage(ScriptGlobal_Format("#{ZSPQ_241216_178}", nRequiredKaiwuLevel))
			return
		end
		if g_KunWu_Expedition_Change_Kind == 2 then
			local iLingXing = Pet:GetLixing(g_KunWu_Expedition_Change_SelectedPetIndex-1)
			if iLingXing < nRequiredlingxingLevel then
				PushDebugMessage(ScriptGlobal_Format("#{ZSPQ_241216_179}", nRequiredlingxingLevel))
				return
			end
		end

		local nIsJianDing = Pet:Lua_EnumPetDispatchList(g_KunWu_Expedition_Change_SelectedPetIndex-1, "IsJianDing")
		if nIsJianDing ~= 1 then
			PushDebugMessage("#{ZSPQ_241216_126}")
			return
		end
	end

	PushEvent("CHOSE_PET_PAIQIAN", g_KunWu_Expedition_Change_SelectedPetIndex)
	this:Hide()
end

function KunWu_Expedition_Change_On_ResetPos()
	KunWu_Expedition_ChangeFrameBK:SetProperty("UnifiedPosition", g_KunWu_Expedition_Change_Frame_UnifiedPosition)
end

function KunWu_Expedition_Change_OnHidden()
	g_KunWu_Expedition_Change_CurItemIndex = 1
	g_KunWu_Expedition_Change_CurTeamIndex = 0
	g_KunWu_Expedition_Change_Kind = 1
	g_KunWu_Expedition_Change_SelectedPetIndex = -1
	KunWu_Expedition_ChangePetList:Clear()	
	KunWu_Expedition_ChangeFakeObject:SetFakeObject("")
	g_KunWu_Expedition_Change_ListItem ={}
	g_KunWu_Expedition_Change_CurIndex = 1
end

function KunWu_Expedition_Change_Close()
	this:Hide()
end
