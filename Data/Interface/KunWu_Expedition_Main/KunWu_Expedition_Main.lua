
local g_KunWu_Expedition_Main_Frame_UnifiedPosition
local g_KunWu_Expedition_Main_Kind = 1
local g_KunWu_Expedition_Main_CurItemIndex = 1
local g_KunWu_Expedition_Main_CurTeamIndex = -1
local g_KunWu_Expedition_Main_PetSelectedIndex = -1
local g_KunWu_Expedition_Main_ListItem ={}
local g_KunWu_Expedition_Main_IsLocked ={}
local g_KunWu_Expedition_Main_PetDispatchCount = 0

local g_KunWu_Expedition_Main_FinishTime = 0
--local g_KunWu_Expedition_Main_StartIndex = 1

--local g_KunWu_Expedition_Main_ChangePetUITalbe = {}
local g_KunWu_Expedition_Main_FenYeUI = {}
local g_KunWu_Expedition_Main_FenYeUITips = {}
local g_KunWu_Expedition_Main_RewardItem = {}
local g_KunWu_Expedition_Main_MengHuiIdList =
{
	[1] = 59,
	[2] = 60,
	[3] = 61,
	[4] = 62,
}

local g_KunWu_Expedition_Main_RateImage =
{
	[1] = "set:KunWu_Expedition01 image:Item_Bichu",
	[2] = "set:KunWu_Expedition01 image:Item_Jigao",
	[3] = "set:KunWu_Expedition01 image:Item_Chaogao",
	[4] = "set:KunWu_Expedition01 image:Item_Jiaogao",
	[5] = "set:KunWu_Expedition01 image:Item_Piangao",
	[6] = "set:KunWu_Expedition01 image:Item_Gao",
	[7] = "set:KunWu_Expedition01 image:Item_Zhong",
	[8] = "set:KunWu_Expedition01 image:Item_Di",
	[9] = "set:KunWu_Expedition01 image:Item_Jiaodi",
	[10] = "set:KunWu_Expedition01 image:Item_Chaodi",
	[11] = "set:KunWu_Expedition01 image:Item_Jidi",
}

local g_KunWu_Expedition_Main_PetMaxTili = 100
local g_KunWu_Expedition_Main_AbilityLevel = 0

local g_Object = -1

function KunWu_Expedition_Main_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("REFRESH_PET_PAIQIAN_MAIN")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("CHOSE_PET_PAIQIAN",false)
	this:RegisterEvent("PET_PAIQIAN_LOCATE",false)
	this:RegisterEvent("OPEN_PET_PAIQIAN_RESULT",false)
	this:RegisterEvent("PET_DISPATCH_STARTPOP", false)
end

function KunWu_Expedition_Main_OnLoad()
	g_KunWu_Expedition_Main_Frame_UnifiedPosition = KunWu_Expedition_MainFrameBK:GetProperty("UnifiedPosition")
	g_KunWu_Expedition_Main_FenYeUI = 
	{
		[0] = KunWu_Expedition_MainQueue_Pet1_HighLight,
		[1] = KunWu_Expedition_MainQueue_Pet2_HighLight,
		[2] = KunWu_Expedition_MainQueue_Pet3_HighLight,
	}

	g_KunWu_Expedition_Main_FenYeUITips =
	{
		[0] = KunWu_Expedition_MainQueue_Pet1Tips,
		[1] = KunWu_Expedition_MainQueue_Pet2Tips,
		[2] = KunWu_Expedition_MainQueue_Pet3Tips,
	}

end

function KunWu_Expedition_Main_BeginCareObject(objCared)
	g_Object = objCared;
	this:CareObject(tonumber(g_Object), 1, "KunWu_Expedition_Main");
end

function KunWu_Expedition_Main_OnEvent(event)
	if event == "OPEN_PET_PAIQIAN_RESULT" or "PET_DISPATCH_STARTPOP" then
		KunWu_Expedition_Main_StateMarkRefresh()
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 2024123001 then
		if( this:IsVisible() == false ) then
			local xx = Get_XParam_INT(0)
			if tonumber(xx) == -1 then
				return
			end
			objCared = -1
			objCared = DataPool : GetNPCIDByServerID(xx)
			if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
				return
			end
			
			g_KunWu_Expedition_Main_Kind =Get_XParam_INT(1)
			KunWu_Expedition_Main_Open()
			KunWu_Expedition_Main_BeginCareObject(objCared)
		end
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		KunWu_Expedition_Main_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		KunWu_Expedition_Main_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		KunWu_Expedition_Main_Close_Click()
	
	elseif event == "PET_PAIQIAN_LOCATE" then
		-- PushDebugMessage("arg0:"..arg0)
		-- PushDebugMessage("g_KunWu_Expedition_Main_CurItemIndex:"..g_KunWu_Expedition_Main_CurItemIndex)
		local temp = tonumber( arg0 )
		if g_KunWu_Expedition_Main_Kind == 2 then
			temp = temp + 4
		end
		if g_KunWu_Expedition_Main_CurItemIndex == temp and g_KunWu_Expedition_Main_CurTeamIndex == tonumber( arg1 ) then
			PushDebugMessage("#{ZSPQ_241216_147}")
			return
		else
			PushDebugMessage("#{ZSPQ_241216_148}")
		end
		KunWu_Expedition_Main_Refresh()
	--	PushDebugMessage("arg0:"..arg0)
	--	PushDebugMessage("arg1:"..arg1)
		KunWu_Expedition_Main_DispatchTypeItem_Check(tonumber( arg0 ),tonumber( arg1 ))
	elseif event == "REFRESH_PET_PAIQIAN_MAIN" then	
		KunWu_Expedition_Main_Refresh()
		KunWu_Expedition_Main_DispatchPetItem_Check(g_KunWu_Expedition_Main_CurTeamIndex)
	elseif event == "CHOSE_PET_PAIQIAN" then	
		g_KunWu_Expedition_Main_PetSelectedIndex = tonumber( arg0 )
		if g_KunWu_Expedition_Main_PetSelectedIndex<1 or g_KunWu_Expedition_Main_PetSelectedIndex>10 then
			return 
		end
		local szPetName = Pet:GetPetList_Appoint(g_KunWu_Expedition_Main_PetSelectedIndex - 1)
		KunWu_Expedition_MainMissionInfo_Pet1Name:SetText(szPetName)
		local nPetDispatchValue, nPetDispatchStrength = Pet:GetPetDispatchInfo(g_KunWu_Expedition_Main_PetSelectedIndex-1)
		KunWu_Expedition_MainMissionInfo_Pet1EXpoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_61}",nPetDispatchStrength,g_KunWu_Expedition_Main_PetMaxTili))
		local szPortrait = Pet:GetPetPortraitByIndex(g_KunWu_Expedition_Main_PetSelectedIndex - 1)
		if(nil ~= szPortrait and "" ~= szPortrait) then
			KunWu_Expedition_MainMissionInfo_Pet1Item:SetProperty("Image", tostring(szPortrait))
		end
		KunWu_Expedition_MainMissionInfo_Pet1Item_ChangeBtn:SetText("#{ZSPQ_241216_32}")
		KunWu_Expedition_MainMission_StartBtn:Enable()

		local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchFightNum,nRequiredKaiwuLevel,nRequiredlingxingLevel = Pet:Lua_EnumPetDispatchTableItem(g_KunWu_Expedition_Main_CurItemIndex)
		if nPetDispatchValue < nRequiredDispatchFightNum then
			KunWu_Expedition_MainDetiail_RequireText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_63}", nPetDispatchValue, nRequiredDispatchFightNum))
		else
			KunWu_Expedition_MainDetiail_RequireText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_121}", nPetDispatchValue, nRequiredDispatchFightNum))
		end
		local nKaiWuLevel = Pet:Lua_EnumPetDispatchList(g_KunWu_Expedition_Main_PetSelectedIndex - 1, "KaiWuLevel")
		if nKaiWuLevel >= nRequiredKaiwuLevel then
			KunWu_Expedition_MainDetiail_JuexingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_166}", nKaiWuLevel, nRequiredKaiwuLevel))
		else
			KunWu_Expedition_MainDetiail_JuexingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_167}", nKaiWuLevel, nRequiredKaiwuLevel))
		end
		local iLingXing = Pet:GetLixing(g_KunWu_Expedition_Main_PetSelectedIndex - 1)
		if iLingXing >= nRequiredlingxingLevel then
			KunWu_Expedition_MainDetiail_LingxingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_168}", iLingXing, nRequiredlingxingLevel))
		else
			KunWu_Expedition_MainDetiail_LingxingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_169}", iLingXing, nRequiredlingxingLevel))
		end

		if g_KunWu_Expedition_Main_Kind == 2 then
			local nItemType1,nItemType2,nItemType3,nItemType4,nItemType5 = Pet:Lua_GetPetDispatchRewardItemRate(g_KunWu_Expedition_Main_CurItemIndex, g_KunWu_Expedition_Main_PetSelectedIndex - 1)
			local ItemTypeList ={nItemType1,nItemType2,nItemType3,nItemType4,nItemType5}
			for i = 1, table.getn(g_KunWu_Expedition_Main_RewardItem) do
				local itemType = ItemTypeList[i]
				--PushDebugMessage("itemType:"..tostring(itemType))
				if itemType ~= nil and g_KunWu_Expedition_Main_RateImage[itemType] ~= nil then
					g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips"):Show()
					g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips"):SetProperty("Image",g_KunWu_Expedition_Main_RateImage[itemType])
				end
			end
		else
			local nItemType1,nItemType2 = Pet:Lua_GetPetDispatchRewardItemRate(g_KunWu_Expedition_Main_CurItemIndex, g_KunWu_Expedition_Main_PetSelectedIndex - 1)
			local ItemTypeList ={nItemType1,nItemType2}
			for i = 1, table.getn(g_KunWu_Expedition_Main_RewardItem) do
				local itemType = ItemTypeList[i]
				if itemType ~= nil and g_KunWu_Expedition_Main_RateImage[itemType] ~= nil then
					g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips"):Show()
					g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips"):SetProperty("Image",g_KunWu_Expedition_Main_RateImage[itemType])
				end
			end
		end

	end
end


function KunWu_Expedition_Main_Open()
	
	this:Show()
	KunWu_Expedition_MainSelfInfo_QueueBtn:Hide()
	KunWu_Expedition_MainSelfInfo_QueueBtn_tips:Hide()
	g_KunWu_Expedition_Main_PetDispatchCount = Pet:Lua_GetPetDispatchTypeCount(g_KunWu_Expedition_Main_Kind)
	--KunWu_Expedition_MainMissionList:Clear()
	-- PushDebugMessage("g_KunWu_Expedition_Main_PetDispatchCount:"..tostring(g_KunWu_Expedition_Main_PetDispatchCount))
	-- PushDebugMessage("g_KunWu_Expedition_Main_StartIndex:"..tostring(g_KunWu_Expedition_Main_StartIndex))
	g_KunWu_Expedition_Main_CurItemIndex = 1
	local subIndex = 0
	for i = 1 , g_KunWu_Expedition_Main_PetDispatchCount do
		--PushDebugMessage("i:"..tostring(i))
		local ItemBar = g_KunWu_Expedition_Main_ListItem[i]
		if ItemBar == nil then
			ItemBar = KunWu_Expedition_MainMissionList:AddChild("KunWu_Expedition_MainMissionListBK")
		end
		if not ItemBar then
			break
		end
		local temp = i
		if g_KunWu_Expedition_Main_Kind == 2 then
			temp = temp + 4
			--g_KunWu_Expedition_Main_CurItemIndex = temp
			ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionTimes"):Show()
			KunWu_Expedition_MainAward_PreviewTitle_Tips:SetToolTip("#{ZSPQ_241216_153}")
		else
			ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionTimes"):Hide()
			KunWu_Expedition_MainAward_PreviewTitle_Tips:SetToolTip("#{ZSPQ_241216_140}")
		end
	
		local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchFightNum =  Pet:Lua_EnumPetDispatchTableItem(temp)
		--ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_MissionName"):SetText(nTypeName)
		ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_MissionName"):Hide()
		ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_CheckBtnImage"):SetProperty("Image",nBgImage)

	
		ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_CheckBtn"):SetEvent( "MouseLClick", "KunWu_Expedition_Main_DispatchTypeItem_Check("..i..","..subIndex..")" )
		ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionLevel"):Hide()
	
		-- if nRequiredDispatchLevel<=0 then
		-- 	ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionLevel"):Hide()
		-- else
		-- 	ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionLevel"):Show()
		-- 	ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionLevel"):SetText(ScriptGlobal_Format("#{ZSPQ_241216_44}",nRequiredDispatchLevel))
		-- end
	
		 if g_KunWu_Expedition_Main_Kind == 2 then
		-- 	ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_MissionLevel"):SetText(ScriptGlobal_Format("#{ZSPQ_241216_45}",nFubenLevel))
			ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_MissionLevel"):Hide()
		 else
			
		 	--ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_MissionLevel"):SetText("--")
			-- local curMengHuiTypeId = g_KunWu_Expedition_Main_MengHuiIdList[temp]
			-- if curMengHuiTypeId ~= nil and curMengHuiTypeId ~= -1 then
			-- 	local nAbilityLevel = Player:GetAbilityInfo(curMengHuiTypeId, "level")
			-- 	if nAbilityLevel ~= nil then
			-- 		g_KunWu_Expedition_Main_AbilityLevel = nAbilityLevel
			-- 		g_KunWu_Expedition_Main_CurItemIndex = temp
			-- 		ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_MissionLevel"):SetText(ScriptGlobal_Format("#{ZSPQ_241216_130}",g_KunWu_Expedition_Main_AbilityLevel))
			-- 	end
			-- end
		end
		g_KunWu_Expedition_Main_ListItem[i] = ItemBar
	end

	if g_KunWu_Expedition_Main_Kind == 2 then
		KunWu_Expedition_MainSelfInfo_ExpeditionLevel:Hide()
		KunWu_Expedition_MainDragTitle:SetText("#{ZSPQ_241216_28}")
		KunWu_Expedition_MainMissionList_Title:SetText("#{ZSPQ_241216_41}")
		KunWu_Expedition_MainIntroText:SetText("#{ZSPQ_241216_29}")

		KunWu_Expedition_MainDetiail_JuexingText:Show()
		KunWu_Expedition_MainDetiail_LingxingText:Show()
		KunWu_Expedition_MainDetiail_JuexingText_Dot:Show()
		KunWu_Expedition_MainDetiail_LingxingText_Dot:Show()

		KunWu_Expedition_MainAward_PreviewInfo_FB:Show()
		KunWu_Expedition_MainAward_PreviewInfo_MH:Hide()
	else
		KunWu_Expedition_MainSelfInfo_ExpeditionLevel:Show()
		KunWu_Expedition_MainDragTitle:SetText("#{ZSPQ_241216_119}")
		KunWu_Expedition_MainMissionList_Title:SetText("#{ZSPQ_241216_125}")
		KunWu_Expedition_MainIntroText:SetText("#{ZSPQ_241216_117}")
		KunWu_Expedition_MainDetiail_JuexingText:Hide()
		KunWu_Expedition_MainDetiail_LingxingText:Hide()
		KunWu_Expedition_MainDetiail_JuexingText_Dot:Hide()
		KunWu_Expedition_MainDetiail_LingxingText_Dot:Hide()

		KunWu_Expedition_MainAward_PreviewInfo_FB:Hide()
		KunWu_Expedition_MainAward_PreviewInfo_MH:Show()

		g_KunWu_Expedition_Main_CurItemIndex = Player:GetData("IBIDENTITYID")
		if g_KunWu_Expedition_Main_CurItemIndex == 0 then
			g_KunWu_Expedition_Main_CurItemIndex = 1
		end
		local curMengHuiTypeId = g_KunWu_Expedition_Main_MengHuiIdList[g_KunWu_Expedition_Main_CurItemIndex]
		if curMengHuiTypeId ~= nil and curMengHuiTypeId ~= -1 then
			local nAbilityLevel = Player:GetAbilityInfo(curMengHuiTypeId, "level")
			if nAbilityLevel ~= nil then
				g_KunWu_Expedition_Main_AbilityLevel = nAbilityLevel
				--g_KunWu_Expedition_Main_CurItemIndex = temp
				g_KunWu_Expedition_Main_ListItem[g_KunWu_Expedition_Main_CurItemIndex]:GetSubItem("KunWu_Expedition_MainMissionList_MissionLevel"):Show()
				g_KunWu_Expedition_Main_ListItem[g_KunWu_Expedition_Main_CurItemIndex]:GetSubItem("KunWu_Expedition_MainMissionList_MissionLevel"):SetText(ScriptGlobal_Format("#{ZSPQ_241216_130}",g_KunWu_Expedition_Main_AbilityLevel))
				
			end
		end
	end
	
	KunWu_Expedition_Main_Refresh()
	--PushDebugMessage("g_KunWu_Expedition_Main_CurItemIndex:"..g_KunWu_Expedition_Main_CurItemIndex)
	KunWu_Expedition_Main_DispatchTypeItem_Check(g_KunWu_Expedition_Main_CurItemIndex,0)

end

function KunWu_Expedition_Main_Refresh()
	--local nPetDispatchLevel,nAddSpeed = Player:GetData("PETDISPATCHLEVEL")

	if g_KunWu_Expedition_Main_Kind == 2 then
		--KunWu_Expedition_MainSelfInfo_ExpeditionLevel:SetText(ScriptGlobal_Format("#{ZSPQ_241216_42}",nPetDispatchLevel))
		-- local nLevelUpDispatchTimes = Player:GetData("LEVELUPDISPATCHTIMES")
		-- if nLevelUpDispatchTimes == 0 then
		-- 	KunWu_Expedition_MainSelfInfo_ExpeditionLevel:SetToolTip(ScriptGlobal_Format("#{ZSPQ_241216_159}",nAddSpeed))
		-- else
		-- 	KunWu_Expedition_MainSelfInfo_ExpeditionLevel:SetToolTip(ScriptGlobal_Format("#{ZSPQ_241216_106}",nLevelUpDispatchTimes,nAddSpeed))
		-- end
		KunWu_Expedition_MainMissionList_LeftTime:SetToolTip("#{ZSPQ_241216_145}")
	else
		KunWu_Expedition_MainSelfInfo_ExpeditionLevel:SetText(ScriptGlobal_Format("#{ZSPQ_241216_129}",g_KunWu_Expedition_Main_AbilityLevel))
		KunWu_Expedition_MainSelfInfo_ExpeditionLevel:SetToolTip("#{ZSPQ_241216_107}")
		KunWu_Expedition_MainMissionList_LeftTime:SetToolTip("#{ZSPQ_241216_146}")
	end

	local nPetDispatchMenghuiNum,nPetDispatchMenghuiMax = Player:GetData("MENGHUIDISPATCHNUM")
	local nPetDispatchFuBenNum,nPetDispatchFuBenMax = Player:GetData("FUBENDISPATCHNUM")
	if g_KunWu_Expedition_Main_Kind == 1 then
		if nPetDispatchMenghuiNum >= nPetDispatchMenghuiMax then
			KunWu_Expedition_MainMissionList_LeftTime:SetText(ScriptGlobal_Format("#{ZSPQ_241216_108}",nPetDispatchMenghuiNum,nPetDispatchMenghuiMax))
		else
			KunWu_Expedition_MainMissionList_LeftTime:SetText(ScriptGlobal_Format("#{ZSPQ_241216_122}",nPetDispatchMenghuiNum,nPetDispatchMenghuiMax))
		end
		--KunWu_Expedition_MainDetiail_BuffText:Hide()
		--KunWu_Expedition_MainDetiail_TimeText:SetToolTip("#{ZSPQ_241216_163}")
	else
		if nPetDispatchFuBenNum >= nPetDispatchFuBenMax then
			KunWu_Expedition_MainMissionList_LeftTime:SetText(ScriptGlobal_Format("#{ZSPQ_241216_108}",nPetDispatchFuBenNum,nPetDispatchFuBenMax))
		else
			KunWu_Expedition_MainMissionList_LeftTime:SetText(ScriptGlobal_Format("#{ZSPQ_241216_122}",nPetDispatchFuBenNum,nPetDispatchFuBenMax))
		end
		--KunWu_Expedition_MainDetiail_BuffText:Show()
		--KunWu_Expedition_MainDetiail_BuffText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_77}",nAddSpeed))
		--KunWu_Expedition_MainDetiail_TimeText:SetToolTip(ScriptGlobal_Format("#{ZSPQ_241216_162}",nAddSpeed))
		for i = 1 , g_KunWu_Expedition_Main_PetDispatchCount do
			local ItemBar = g_KunWu_Expedition_Main_ListItem[i]
			if ItemBar ~= nil then
				local temp = i + 4
				local nPetdispatchCopysceneCount,nMAXCopyScenePetDispatchCount =  Pet:Lua_GetPetDispatchFuBenNum(temp)
				if nMAXCopyScenePetDispatchCount <= 0 then
					ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionTimes"):Hide()
				else 
					ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionTimes"):Show()
					ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionTimes"):SetText(ScriptGlobal_Format("#{ZSPQ_241216_51}",nPetdispatchCopysceneCount,nMAXCopyScenePetDispatchCount))
				end
			end
		end
	end

	
	local curTime = tonumber(DataPool:LuaGetCurrentServerTime())
	for i = 1 , g_KunWu_Expedition_Main_PetDispatchCount do
		local temp = i
		if g_KunWu_Expedition_Main_Kind == 2 then
			temp = temp + 4
		end
		local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchFightNum =  Pet:Lua_EnumPetDispatchTableItem(temp)

		local isInDispatch = 0
		local isFull = 0
		local nDisCount = 0
		local isHaveFinish = 0
		for j = 0 , 2 do
			local nStatus, nParamIndex, nFinishTime, nPetIndex = Pet:Lua_SelectPetDispatchItem(temp, j)
			if nStatus == 1 then
				if curTime >= nFinishTime then
					isHaveFinish = 1
				end
				isInDispatch = 1
				nDisCount = nDisCount+1
			end
			
		end
		if nDisCount >= 3 then
			isFull = 1
		end
		local ItemBar = g_KunWu_Expedition_Main_ListItem[i]
		if ItemBar ~= nil then
			if isInDispatch ==1 then
				g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_StateText"):Show()
				g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_StateText"):SetProperty("Image", "set:KunWu_Expedition01 image:Mark_PQZ")
			else
				g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_StateText"):Hide()
			end
		
			if isFull ==1 then
				g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_StateText"):SetProperty("Image", "set:KunWu_Expedition01 image:Mark_DLM")
			end

			if isHaveFinish ==1 then
				g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_StateText"):SetProperty("Image", "set:KunWu_Expedition01 image:Mark_YGL")
			end
			--g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_ExpeditionLevel"):Hide()
			if g_KunWu_Expedition_Main_Kind == 2 then
				g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_LockImage"):Hide()
				g_KunWu_Expedition_Main_IsLocked[i] =0
				-- local playerLevel = Player:GetData("LEVEL")
				-- if playerLevel < nFubenLevel then
				-- 	g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_MissionLevel"):SetText(ScriptGlobal_Format("#{ZSPQ_241216_142}",nFubenLevel))
				-- else
				-- 	g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_MissionLevel"):SetText(ScriptGlobal_Format("#{ZSPQ_241216_45}",nFubenLevel))
				-- end
				
			else
				local nCurIdentityId = Player:GetData("IBIDENTITYID")
				--PushDebugMessage("nCurIdentityId:"..tostring(nCurIdentityId))
				if nCurIdentityId == temp then
					g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_LockImage"):Hide()
					g_KunWu_Expedition_Main_IsLocked[i] = 0
				else
					g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_LockImage"):Show()
					g_KunWu_Expedition_Main_IsLocked[i] = 1
				end
				-- local curMengHuiTypeId = g_KunWu_Expedition_Main_MengHuiIdList[temp]
				-- if curMengHuiTypeId ~= nil and curMengHuiTypeId ~= -1 then
				-- 	local nAbilityLevel = Player:GetAbilityInfo(curMengHuiTypeId, "level")
				-- 	if nAbilityLevel ~= nil then
				-- 		g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_LockImage"):Hide()
				-- 		g_KunWu_Expedition_Main_IsLocked[i] = 0
				-- 	else
				-- 		g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_LockImage"):Show()
				-- 		g_KunWu_Expedition_Main_IsLocked[i] = 1
				-- 	end
				-- end
			end
		end
	end
	-- if isShowRedPoint == 1 then
	-- 	KunWu_Expedition_MainSelfInfo_QueueBtn_tips:Show()
	-- else
	-- 	KunWu_Expedition_MainSelfInfo_QueueBtn_tips:Hide()
	-- end

end

function KunWu_Expedition_Main_On_ResetPos()
	KunWu_Expedition_MainFrameBK:SetProperty("UnifiedPosition", g_KunWu_Expedition_Main_Frame_UnifiedPosition)
end

function KunWu_Expedition_Main_Close_Click()
	this:Hide()
end

function KunWu_Expedition_MainInfo_GetHelp()
	if g_KunWu_Expedition_Main_Kind == 2 then
		PushEvent("CCSHOP_HELP", 38)
	else
		PushEvent("CCSHOP_HELP", 37)
	end
end

function KunWu_Expedition_Main_OnHidden()
	g_KunWu_Expedition_Main_ListItem = {}
	g_KunWu_Expedition_Main_IsLocked ={}
	g_KunWu_Expedition_Main_CurItemIndex = 1
	g_KunWu_Expedition_Main_CurTeamIndex = -1
	g_KunWu_Expedition_Main_PetSelectedIndex = -1
	g_KunWu_Expedition_Main_AbilityLevel = 0

	KunWu_Expedition_MainMissionList:Clear()	
	KunWu_Expedition_MainAward_PreviewList:Clear()
	KillTimer("KunWu_Expedition_Main_OnTimer()")
	PushEvent("CLOSE_PET_PAIQIAN_QUEUE")
	PushEvent("CLOSE_PET_PAIQIAN_CHANGEPET")
	this:CareObject(tonumber(g_Object), 0, "KunWu_Expedition_Main");
	g_Object = -1

	g_KunWu_Expedition_Main_RewardItem = {}
end

function KunWu_Expedition_Main_DispatchTypeItem_Check(index, subIndex)
	--PushDebugMessage("xtc:")
	for i = 1 , g_KunWu_Expedition_Main_PetDispatchCount do
		local ItemBar = g_KunWu_Expedition_Main_ListItem[i]
		if ItemBar ~= nil then
			ItemBar:GetSubItem("KunWu_Expedition_MainMissionList_CheckBtn"):SetCheck(0)
		end
	end
	g_KunWu_Expedition_Main_CurItemIndex = index
	if g_KunWu_Expedition_Main_Kind == 2 then
		g_KunWu_Expedition_Main_CurItemIndex = index + 4
	end
	--PushDebugMessage("index:"..tostring(index))
	if g_KunWu_Expedition_Main_IsLocked[index] == 1 then
		KunWu_Expedition_MainLockedClient:Show()
		KunWu_Expedition_MainQueueClient:Hide()
		KunWu_Expedition_MainDetiailClient:Hide()
	else
		KunWu_Expedition_MainLockedClient:Hide()
		KunWu_Expedition_MainQueueClient:Show()
		KunWu_Expedition_MainDetiailClient:Show()
	end
	g_KunWu_Expedition_Main_ListItem[index]:GetSubItem("KunWu_Expedition_MainMissionList_CheckBtn"):SetCheck(1)
	--PushDebugMessage("g_KunWu_Expedition_Main_CurItem:"..tostring(g_KunWu_Expedition_Main_CurItem))

	local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchFightNum,nRequiredKaiwuLevel,nRequiredlingxingLevel, nItemId1, nItemId2, nItemId3, nItemId4, nItemId5 = Pet:Lua_EnumPetDispatchTableItem(g_KunWu_Expedition_Main_CurItemIndex)
	KunWu_Expedition_MainDetiail_RequireText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_63}", 0, nRequiredDispatchFightNum))
	KunWu_Expedition_MainAward_PreviewList:Clear()
	
	for i = 0,2 do
		g_KunWu_Expedition_Main_FenYeUI[i]:Show()
	end
	g_KunWu_Expedition_Main_RewardItem = {}
	if g_KunWu_Expedition_Main_Kind == 2 then
		local rewardIdList ={nItemId1,nItemId2,nItemId3,nItemId4,nItemId5}
		for i = 1, table.getn(rewardIdList) do
			local ItemBar = KunWu_Expedition_MainAward_PreviewList:AddChild("KunWu_Expedition_MainAward_PreviewItemBK")
			if (rewardIdList[i] > 0) then
				local theAction = DataPool:CreateBindActionItemForShow(rewardIdList[i], 1)
				if theAction:GetID() ~= 0 then
					ItemBar:GetSubItem("KunWu_Expedition_MainAward_PreviewItem"):SetActionItem(theAction:GetID())
				end
			else
				ItemBar:Hide()
			end 
			g_KunWu_Expedition_Main_RewardItem[i] = ItemBar
		end

		local nPetdispatchCopysceneCount,nMAXCopyScenePetDispatchCount =  Pet:Lua_GetPetDispatchFuBenNum(g_KunWu_Expedition_Main_CurItemIndex)

		if nMAXCopyScenePetDispatchCount > 0 then
			for i = 0,2 do
				g_KunWu_Expedition_Main_FenYeUI[i]:Hide()
			end
			for i=0,nMAXCopyScenePetDispatchCount-1 do
				g_KunWu_Expedition_Main_FenYeUI[i]:Show()
			end
		end
	else
		--PushDebugMessage("g_KunWu_Expedition_Main_CurItemIndex:"..tostring(g_KunWu_Expedition_Main_CurItemIndex))
		local curMengHuiTypeId = g_KunWu_Expedition_Main_MengHuiIdList[g_KunWu_Expedition_Main_CurItemIndex] -- Player:GetData("IBIDENTITYSKILLID")
		--PushDebugMessage("curMengHuiTypeId:"..tostring(curMengHuiTypeId))
		if curMengHuiTypeId ~= nil and curMengHuiTypeId ~= -1 then
			local nlevel = Player:GetAbilityInfo(curMengHuiTypeId, "level")
			if nlevel == nil then
				nlevel = 0
			end
			local nItemId1, nItemId2 = Pet:Lua_EnumPetDispatchMengHuiRewardItem(g_KunWu_Expedition_Main_CurItemIndex,nlevel)
			local rewardIdList ={nItemId1,nItemId2}
			-- PushDebugMessage("nItemId1:"..tostring(nItemId1))
			-- PushDebugMessage("nItemId2:"..tostring(nItemId2))
			for i = 1, table.getn(rewardIdList) do
				local ItemBar = KunWu_Expedition_MainAward_PreviewList:AddChild("KunWu_Expedition_MainAward_PreviewItemBK")
				if (rewardIdList[i] > 0) then
					local theAction = DataPool:CreateBindActionItemForShow(rewardIdList[i], 1)
					if theAction:GetID() ~= 0 then
						ItemBar:GetSubItem("KunWu_Expedition_MainAward_PreviewItem"):SetActionItem(theAction:GetID())
					end
				else
					ItemBar:Hide()
				end 
				g_KunWu_Expedition_Main_RewardItem[i] = ItemBar
			end
		
			--PushDebugMessage("nlevel:"..tostring(nlevel))
		end
	end

	KunWu_Expedition_Main_StateMarkRefresh()
	
	KunWu_Expedition_Main_DispatchPetItem_Check(subIndex)
end

function KunWu_Expedition_Main_StateMarkRefresh()
	local curTime = tonumber(DataPool:LuaGetCurrentServerTime())
	for i = 0,2 do
		local nStatus, nParamIndex, nFinishTime, nPetIndex = Pet:Lua_SelectPetDispatchItem(g_KunWu_Expedition_Main_CurItemIndex, i)
		if nStatus == 1 then
			g_KunWu_Expedition_Main_FenYeUITips[i]:Show()
			if curTime >= nFinishTime then
				g_KunWu_Expedition_Main_FenYeUITips[i]:SetProperty("Image", "set:KunWu_Expedition01 image:Team_YGL")
			else
				g_KunWu_Expedition_Main_FenYeUITips[i]:SetProperty("Image", "set:KunWu_Expedition01 image:Team_YLZ")
			end
		else
			g_KunWu_Expedition_Main_FenYeUITips[i]:Hide()
		end
	end

	for i = 1 , g_KunWu_Expedition_Main_PetDispatchCount do
		local temp = i
		if g_KunWu_Expedition_Main_Kind == 2 then
			temp = temp + 4
		end
		local isHaveFinish = 0
		for j = 0 , 2 do
			local nStatus, nParamIndex, nFinishTime, nPetIndex = Pet:Lua_SelectPetDispatchItem(temp, j)
			if nStatus == 1 then
				if curTime >= nFinishTime then
					isHaveFinish = 1
				end
			end
		end
		local ItemBar = g_KunWu_Expedition_Main_ListItem[i]
		if ItemBar ~= nil then
			if isHaveFinish ==1 then
				g_KunWu_Expedition_Main_ListItem[i]:GetSubItem("KunWu_Expedition_MainMissionList_StateText"):SetProperty("Image", "set:KunWu_Expedition01 image:Mark_YGL")
			end
		end
	end

end

function KunWu_Expedition_Main_DispatchPetItem_Check(index)
	--PushDebugMessage("index:"..tostring(index))
	if index < 0 or index > 2 then
		return
	end
	KillTimer("KunWu_Expedition_Main_OnTimer()")

	KunWu_Expedition_MainDetiail_ProgressText:Hide()
	
	KunWu_Expedition_MainMissionInfo_Pet1Item:SetProperty("Image", "")
	KunWu_Expedition_MainMissionInfo_Pet1Name:SetText("--")
	KunWu_Expedition_MainMissionInfo_Pet1EXpoint:SetText("--")
	g_KunWu_Expedition_Main_PetSelectedIndex = -1
	KunWu_Expedition_MainMissionInfo_Pet1Item_ChangeBtn:SetText("#{ZSPQ_241216_118}")
	KunWu_Expedition_MainMission_StartBtn:Disable()

	
	for i = 1, table.getn(g_KunWu_Expedition_Main_RewardItem) do
		g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips"):Hide()
	end
	

	local nType,nTypeName,nBgImage,nFubenLevel,nRequiredDispatchFightNum,nRequiredKaiwuLevel,nRequiredlingxingLevel = Pet:Lua_EnumPetDispatchTableItem(g_KunWu_Expedition_Main_CurItemIndex)
	KunWu_Expedition_MainDetiail_RequireText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_63}", 0, nRequiredDispatchFightNum))
	KunWu_Expedition_MainDetiail_JuexingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_167}", 0, nRequiredKaiwuLevel))
	KunWu_Expedition_MainDetiail_LingxingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_169}", 0, nRequiredlingxingLevel))

	PushEvent("CLOSE_PET_PAIQIAN_CHANGEPET")
	
	g_KunWu_Expedition_Main_CurTeamIndex = index
	for i = 0,2 do
		if i == g_KunWu_Expedition_Main_CurTeamIndex then
			g_KunWu_Expedition_Main_FenYeUI[i]:SetCheck(1)
		else
			g_KunWu_Expedition_Main_FenYeUI[i]:SetCheck(0)
		end
	end
	
	--PushDebugMessage("g_KunWu_Expedition_Main_CurItemIndex:"..tostring(g_KunWu_Expedition_Main_CurItemIndex))
	--PushDebugMessage("g_KunWu_Expedition_Main_CurTeamIndex:"..tostring(g_KunWu_Expedition_Main_CurTeamIndex))
	local nStatus,nParamIndex, nFinishTime, nPetIndex = Pet:Lua_SelectPetDispatchItem(g_KunWu_Expedition_Main_CurItemIndex, g_KunWu_Expedition_Main_CurTeamIndex)
	--PushDebugMessage("nFinishTime:"..tostring(nFinishTime))
	--PushDebugMessage("nStatus:"..tostring(nStatus))
	g_KunWu_Expedition_Main_FinishTime = nFinishTime
	local curTime = tonumber(DataPool:LuaGetCurrentServerTime())
	--PushDebugMessage("curTime:"..tostring(curTime))
	if nStatus == 1 then
		--KunWu_Expedition_MainDetiail_ProgressText:Show()
		if curTime >= nFinishTime then
			nStatus = 2
			local nStr = string.format("%02d:%02d:%02d", 0, 0, 0)
			KunWu_Expedition_MainDetiail_TimeText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_70}",nStr))
		else
			KunWu_Expedition_Main_OnTimer()
			SetTimer("KunWu_Expedition_Main","KunWu_Expedition_Main_OnTimer()", 1000)
		end
	
		if nPetIndex >= 0 then
			local szPetName = Pet:GetPetList_Appoint(nPetIndex)
			KunWu_Expedition_MainMissionInfo_Pet1Name:SetText(szPetName)
			local nPetDispatchValue, nPetDispatchStrength = Pet:GetPetDispatchInfo(nPetIndex)
			KunWu_Expedition_MainMissionInfo_Pet1EXpoint:SetText(ScriptGlobal_Format("#{ZSPQ_241216_61}",nPetDispatchStrength,g_KunWu_Expedition_Main_PetMaxTili))
			local szPortrait = Pet:GetPetPortraitByIndex(nPetIndex)
			if(nil ~= szPortrait and "" ~= szPortrait) then
				KunWu_Expedition_MainMissionInfo_Pet1Item:SetProperty("Image", tostring(szPortrait))
			end

			if nPetDispatchValue < nRequiredDispatchFightNum then
				KunWu_Expedition_MainDetiail_RequireText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_63}", nPetDispatchValue, nRequiredDispatchFightNum))
			else
				KunWu_Expedition_MainDetiail_RequireText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_121}", nPetDispatchValue, nRequiredDispatchFightNum))
			end
			local nKaiWuLevel = Pet:Lua_EnumPetDispatchList(nPetIndex, "KaiWuLevel")
			if nKaiWuLevel >= nRequiredKaiwuLevel then
				KunWu_Expedition_MainDetiail_JuexingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_166}", nKaiWuLevel, nRequiredKaiwuLevel))
			else
				KunWu_Expedition_MainDetiail_JuexingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_167}", nKaiWuLevel, nRequiredKaiwuLevel))
			end
			local iLingXing = Pet:GetLixing(nPetIndex)
			if iLingXing >= nRequiredlingxingLevel then
				KunWu_Expedition_MainDetiail_LingxingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_168}", iLingXing, nRequiredlingxingLevel))
			else
				KunWu_Expedition_MainDetiail_LingxingText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_169}", iLingXing, nRequiredlingxingLevel))
			end
			
			if g_KunWu_Expedition_Main_Kind == 2 then
				local nItemType1,nItemType2,nItemType3,nItemType4,nItemType5 = Pet:Lua_GetPetDispatchRewardItemRate(g_KunWu_Expedition_Main_CurItemIndex, nPetIndex)
				local ItemTypeList ={nItemType1,nItemType2,nItemType3,nItemType4,nItemType5}
				for i = 1, table.getn(g_KunWu_Expedition_Main_RewardItem) do
					local itemType = ItemTypeList[i]
					if itemType ~= nil and g_KunWu_Expedition_Main_RateImage[itemType] ~= nil then
						g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips"):Show()
						g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips"):SetProperty("Image",g_KunWu_Expedition_Main_RateImage[itemType])
					end
				end
			else
				
				local nItemType1,nItemType2 = Pet:Lua_GetPetDispatchRewardItemRate(g_KunWu_Expedition_Main_CurItemIndex, nPetIndex)
				local ItemTypeList ={nItemType1,nItemType2}
				for i = 1, table.getn(g_KunWu_Expedition_Main_RewardItem) do
					local itemType = ItemTypeList[i]
					--local rewardItem = g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips")
					if itemType ~= nil and g_KunWu_Expedition_Main_RateImage[itemType] ~= nil then
						g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips"):Show()
						g_KunWu_Expedition_Main_RewardItem[i]:GetSubItem("KunWu_Expedition_MainAward_ItemTips"):SetProperty("Image",g_KunWu_Expedition_Main_RateImage[itemType])
					end
				end
			end

		end
		KunWu_Expedition_MainMissionInfo_Pet1Item_ChangeBtn:Disable()
	elseif nStatus == 0 then
		--KunWu_Expedition_MainDetiail_ProgressText:Hide()
		local needTime = 30*60--Pet:GetDispatchNeedTime(g_KunWu_Expedition_Main_Kind)
		local showmin = math.floor(needTime/60)
		local showsec = math.mod(needTime,60)

		local showhour = math.floor(showmin/60)
		showmin = math.mod(showmin,60)

		local nStr = string.format("%02d:%02d:%02d", showhour, showmin, showsec)
		KunWu_Expedition_MainDetiail_TimeText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_70}",nStr))
		KunWu_Expedition_MainMissionInfo_Pet1Item_ChangeBtn:Enable()
	end
	if nStatus == 0 then
		KunWu_Expedition_MainMission_StartBtn:Show()
		KunWu_Expedition_MainMission_StopBtn:Hide()
		KunWu_Expedition_MainMission_GetBtn:Hide()
	elseif nStatus == 1 then
		KunWu_Expedition_MainMission_StartBtn:Hide()
		KunWu_Expedition_MainMission_StopBtn:Show()
		KunWu_Expedition_MainMission_GetBtn:Hide()
	elseif nStatus == 2 then
		KunWu_Expedition_MainMission_StartBtn:Hide()
		KunWu_Expedition_MainMission_StopBtn:Hide()
		KunWu_Expedition_MainMission_GetBtn:Show()
	end

	local nTitle, nDesc, nParam1, nParam2, nParam3, nParam4, nParam5, nImageFile = Pet:GetDispatchTaskInfoByParamIndex(nParamIndex,0)
	if nTitle ~= nil then
		KunWu_Expedition_MainMissionInfo_Name:SetText("#{"..nTitle.."}")
		local descStr = "#{"..nDesc.."}"
		KunWu_Expedition_MainMissionInfo_Intro:SetText(ScriptGlobal_Format(descStr,nParam1,nParam2,nParam3,nParam4,nParam5))
	end
	if nImageFile ~= nil then
		KunWu_Expedition_MainMissionInfo_BKImage:SetProperty("Image", nImageFile)
	end
	--PushDebugMessage("nDesc:"..nDesc)
	--PushDebugMessage(descStr)
end

function KunWu_Expedition_Main_OnTimer()
	local curTime = tonumber(DataPool:LuaGetCurrentServerTime())
	local diffTime = g_KunWu_Expedition_Main_FinishTime - curTime
	--PushDebugMessage("diffTime:"..tostring(diffTime))
	if diffTime<=0 then
		KunWu_Expedition_MainMission_StartBtn:Hide()
		KunWu_Expedition_MainMission_StopBtn:Hide()
		KunWu_Expedition_MainMission_GetBtn:Show()
		diffTime = 0
		KillTimer("KunWu_Expedition_Main_OnTimer()")
	end
	local showmin = math.floor(diffTime/60)
	local showsec = math.mod(diffTime,60)

	local showhour = math.floor(showmin/60)
	showmin = math.mod(showmin,60)

	local nStr = string.format("%02d:%02d:%02d", showhour, showmin, showsec)
	KunWu_Expedition_MainDetiail_TimeText:SetText(ScriptGlobal_Format("#{ZSPQ_241216_70}",nStr))

	KunWu_Expedition_Main_StateMarkRefresh()
end

function KunWu_Expedition_Main_ChangePetBtn_Clicked()
	local nPetCount = Pet:GetPet_Count()
	if nPetCount < 1 then
		PushDebugMessage("#{ZSPQ_241216_20}")
		return
	end
	
	PushEvent("OPEN_PET_PAIQIAN_CHANGEPET", g_KunWu_Expedition_Main_Kind, g_KunWu_Expedition_Main_CurItemIndex, g_KunWu_Expedition_Main_CurTeamIndex)
end

function KunWu_Expedition_Main_DoDispatch_Clicked()
	if g_KunWu_Expedition_Main_PetSelectedIndex<1 or g_KunWu_Expedition_Main_PetSelectedIndex>10 then
		PushDebugMessage("#{ZSPQ_241216_34}")
		return 
	end
	if g_KunWu_Expedition_Main_Kind == 2 then
		local nPetdispatchCopysceneCount,nMAXCopyScenePetDispatchCount = Pet:Lua_GetPetDispatchFuBenNum(g_KunWu_Expedition_Main_CurItemIndex)
		if nPetdispatchCopysceneCount >= nMAXCopyScenePetDispatchCount and nMAXCopyScenePetDispatchCount > 0 then
			local nType,nTypeName,nBgImage = Pet:Lua_EnumPetDispatchTableItem(g_KunWu_Expedition_Main_CurItemIndex)
			PushDebugMessage(ScriptGlobal_Format("#{ZSPQ_241216_143}",nTypeName))
			return 
		end
	end
	--PushEvent("PET_DISPATCH_STARTPOP")
	Pet:Lua_StartPetDispatch(g_KunWu_Expedition_Main_CurItemIndex, g_KunWu_Expedition_Main_CurTeamIndex, g_KunWu_Expedition_Main_PetSelectedIndex)
end

function KunWu_Expedition_Main_StopDispatch_Clicked()
	--PushDebugMessage("KunWu_Expedition_Main_StopDispatch_Clicked")
	PushEvent("PET_PAIQIAN_STOP_CONFIRM", g_KunWu_Expedition_Main_CurItemIndex, g_KunWu_Expedition_Main_CurTeamIndex)
	--Pet:Lua_StopPetDispatch(g_KunWu_Expedition_Main_CurItemIndex, g_KunWu_Expedition_Main_CurTeamIndex)
end

function KunWu_Expedition_Main_GetDispatchReward_Clicked()
	
	Pet:Lua_GetPetDispatchReward(g_KunWu_Expedition_Main_CurItemIndex, g_KunWu_Expedition_Main_CurTeamIndex)
end

-- function KunWu_Expedition_Main_CheckAllDispatchTeam()
-- 	--查看所有派遣队列
-- 	PushEvent("OPEN_PET_PAIQIAN_ALLQUEUE", g_KunWu_Expedition_Main_Kind)
-- 	KunWu_Expedition_Main_Refresh()
-- end

