--!!!reloadscript =NewExterior_PetSoul
local g_NewExterior_PetSoul_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 0
local g_TargetExteriorIndex = 0			--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID

local g_CurSelExteriorID = 0			--当前选择的外观ID，从1开始

local g_CurPossVisualIndex = 0

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 4 --融魂外观
local g_MaxBarNum = 0
local g_BarList = {}

local g_NeedChangeScrollSize = 1
local g_NeedChangeFrameScrollSize = 1

local g_CameraHeight = 1     --摄影机高度
local g_CameraDistance = 2   --摄影机距离
local g_CameraPitch = 3      --摄影机角度
local g_CameraPosition =
{
	--女性相关位置
	[0] = 
	{
		{fHeight = 0.82, fDistance = 8, fPitch=0.1},
		{fHeight = 0.82, fDistance = 6.5, fPitch=0.1},
		{fHeight = 1.5, fDistance = 2.5, fPitch=0.10},
		{fHeight = 1.57, fDistance = 1.7, fPitch=0.10}
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

local g_RankButtons = {}
local g_RanSeButtons = {}
local g_QualStr = {"#{SHRH_20220427_06}", "#{SHRH_20220427_05}", "#{SHRH_20220427_04}", "#{SHRH_20220427_71}"}

local g_strRank = {
	"#{SHRH_20220427_15}",
	"#{SHRH_20220427_16}",
	"#{SHRH_20220427_17}",
}

local m_PetSoulQual = -1
local g_SelectPlan = 0
local g_RanSeButtonLock = {}
local g_RanSeButtonDef = {}
local g_RanSeButtonTry = {}
local g_EquipExteriorId = 0
local g_RanSeButtonQuality = {}

local g_OrnamentState				= {		-- 状态
	INVALID	= 0,							-- 无效
	EMPTY	= 1,							-- 空闲
	TIME	= 2,							-- 限时
	TIMEOUT	= 3,							-- 过期
	FOREVER	= 4,							-- 永久
}
--=========
--PreLoad==
--=========
function NewExterior_PetSoul_PreLoad()
	this:RegisterEvent("OPEN_EXTERIOR")
	this:RegisterEvent("ADD_EXTERIOR", false)
	this:RegisterEvent("UPDATE_EXTERIOR", false)
	this:RegisterEvent("EXTERIOR_OUTTIME", false)
	this:RegisterEvent("EXTERIOR_ID_CHANGED", false)
	this:RegisterEvent("EXTERIOR_POSS_VISUAL_INDEX", false)
	this:RegisterEvent("EXTERIOR_HAIR_COLOR_INDEX", false)
	
	this:RegisterEvent("ADD_EXTERIOR_WEAPON", false)
	this:RegisterEvent("UPDATE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("EXTERIOR_OUTTIME_WEAPON", false)
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_CHANGED", false)
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_LEVEL_CHANGED", false)
	this:RegisterEvent("POSSESSION_PET_GUID_UPDATE", false)

	this:RegisterEvent("UNIT_LEVEL", false)
	
	this:RegisterEvent("ON_SCENE_TRANS", false)
	this:RegisterEvent("ON_SERVER_TRANS", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS", false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	
	this:RegisterEvent("UPDATE_EXTERIOR_FASHION", false)
	
	this:RegisterEvent("EXERIOR_SAVEALL_RET", false)
	
	this:RegisterEvent("OPEN_STALL_SALE", false)
	this:RegisterEvent("PROGRESSBAR_SHOW", false)
	this:RegisterEvent("MODELID_CHANGE", false)
	
	this:RegisterEvent("UPDATE_RIDE_CARD_INFO", false)
	this:RegisterEvent("ORNAMENTS_DISPLAYUPDATE", false)
end

--=========
--OnLoad
--=========
function NewExterior_PetSoul_OnLoad()
	g_NewExterior_PetSoul_UnifiedPosition = NewExterior_PetSoul_Frame:GetProperty("UnifiedPosition")
	
	g_RankButtons[1] = NewExterior_PetSoul_Level1
	g_RankButtons[2] = NewExterior_PetSoul_Level2
	g_RankButtons[3] = NewExterior_PetSoul_Level3
	
	g_RanSeButtons[1] = NewExterior_PetSoul_ColorItem1
	g_RanSeButtons[2] = NewExterior_PetSoul_ColorItem2
	g_RanSeButtons[3] = NewExterior_PetSoul_ColorItem3

	g_RanSeButtonLock[1] = NewExterior_PetSoul_ColorListItemLock1
	g_RanSeButtonLock[2] = NewExterior_PetSoul_ColorListItemLock2
	g_RanSeButtonLock[3] = NewExterior_PetSoul_ColorListItemLock3

	g_RanSeButtonDef[1] = NewExterior_PetSoul_ColorListItemActionDef1
	g_RanSeButtonDef[2] = NewExterior_PetSoul_ColorListItemActionDef2
	g_RanSeButtonDef[3] = NewExterior_PetSoul_ColorListItemActionDef3

	g_RanSeButtonTry[1] = NewExterior_PetSoul_ColorListItemActionTry1
	g_RanSeButtonTry[2] = NewExterior_PetSoul_ColorListItemActionTry2
	g_RanSeButtonTry[3] = NewExterior_PetSoul_ColorListItemActionTry3

	g_RanSeButtonQuality[1] = NewExterior_PetSoul_ItemActionLuxury1
	g_RanSeButtonQuality[2] = NewExterior_PetSoul_ItemActionLuxury2
	g_RanSeButtonQuality[3] = NewExterior_PetSoul_ItemActionLuxury3


	for i = 1, 3 do		
		local strTip = ScriptGlobal_Format("#{SHRH_20220427_21}", g_strRank[i])
		g_RankButtons[i]:SetToolTip(strTip)
	end
	
end
--=========
--OnEvent
--=========
function NewExterior_PetSoul_OnEvent(event)

	if event == "OPEN_EXTERIOR" then
		if tonumber(arg0) == g_ExteriorType then
			if this:IsVisible() then
				if tonumber(arg1) == 0 then
					NewExterior_PetSoul_SavePosition()
					this:Hide()
				end
			else
				NewExterior_PetSoul_SetPosition()
				NewExterior_PetSoul_CloseSameGroupWindow()
				this:Show()
				NewExterior_PetSoul_Show()
				NewExterior_PetSoul_SetDefaultState()
			end
		end
		return
	end
		
	if event == "OPEN_STALL_SALE" -- 开始摆摊，还原试穿
		or event == "PROGRESSBAR_SHOW"	-- 读进度条中，还原试穿
		or event == "MODELID_CHANGE" -- 变身 关闭界面
		then
		NewExterior_PetSoul_CloseClick()
		return
	end
	
	if event == "EXERIOR_SAVEALL_RET" then
		if not this:IsVisible() then
			return
		end

		Exterior:LuaFnSetCurrentExteriorSetInfo("RESETEX")
		Exterior:LuaFnInitCurrentExteriorSetExceptFashion(0)
		NewExterior_PetSoul_Show()
		NewExterior_PetSoul_SetDefaultState()
	end
	
	if event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if not this:IsVisible() then
			return
		end

		if tonumber(arg0) == g_ExteriorType then			
			NewExterior_PetSoul_Show()
		else
			--左侧
			NewExterior_PetSoul_UpdateLeftBtn()
			NewExterior_PetSoul_UpdateRedPoint()
			--更新一下模型
			Exterior:LuaFnUpdateExteriorPlayerData()
		end
		return
	end
	
	if event == "ADD_EXTERIOR_WEAPON" or event == "UPDATE_EXTERIOR_WEAPON" or event == "EXTERIOR_OUTTIME_WEAPON" or event == "DEF_EXTERIOR_WEAPON_CHANGED" then
		if not this:IsVisible() then
			return
		end

		if tonumber(arg0) == g_ExteriorType then			
			NewExterior_PetSoul_Show()
		else
			--左侧
			NewExterior_PetSoul_UpdateLeftBtn()
			NewExterior_PetSoul_UpdateRedPoint()
			--更新一下模型
			Exterior:LuaFnUpdateExteriorPlayerData()
		end
		return
	end
	
	if event == "EXTERIOR_POSS_VISUAL_INDEX" or event == "EXTERIOR_HAIR_COLOR_INDEX" or event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		if not this:IsVisible() then
			return
		end

		--左侧
		NewExterior_PetSoul_UpdateLeftBtn()
		NewExterior_PetSoul_UpdateRedPoint()
		--更新一下模型
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
	
	if event == "UPDATE_EXTERIOR_FASHION" then
		if not this:IsVisible() then
			return
		end

		if tonumber(arg0) == 1 then
			--左侧
			NewExterior_PetSoul_UpdateLeftBtn()
			--更新一下模型
			Exterior:LuaFnUpdateExteriorPlayerData()
		end
		return
	end
	
	if event == "POSSESSION_PET_GUID_UPDATE" then
		if not this:IsVisible() then
			return
		end

		NewExterior_PetSoul_Show()
		return
	end

	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			this:Hide()
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_PetSoul_Frame:SetProperty("UnifiedPosition", g_NewExterior_PetSoul_UnifiedPosition)
	end
	
	if event == "UPDATE_RIDE_CARD_INFO" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_PetSoul_UpdateLeftBtn()
		NewExterior_PetSoul_UpdateRedPoint()
		--更新一下模型
		Exterior:LuaFnUpdateExteriorPlayerData()
	end

	if event == "ORNAMENTS_DISPLAYUPDATE" then
		-- 刷新模型
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
end

function NewExterior_PetSoul_InitList()
	
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetExteriorMaxCount(g_ExteriorType)
		for i = 1, g_MaxBarNum do
			local bar = NewExterior_PetSoul_SuperList:AddChild("NewExterior_PetSoul_SuperListItem")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("NewExterior_PetSoul_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("NewExterior_PetSoul_ItemClicked(%d)", i))
			bar:GetSubItem("NewExterior_PetSoul_SuperListItemAction"):SetEvent("MouseMove", string.format("NewExterior_PetSoul_ItemMouseMove(%d)", i))
			bar:GetSubItem("NewExterior_PetSoul_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("NewExterior_PetSoul_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end		
		g_InitList = 1
	end
end

function NewExterior_PetSoul_Show()
	
	g_Distance = g_Distance_Ori	
	g_NeedChangeScrollSize = 1
	g_NeedChangeFrameScrollSize = 1
				
	local curPossessionPetIndex = Pet:LuaFnGetPossessionPetIndex()
	if curPossessionPetIndex >= 0 then
		m_PetSoulQual = Pet:LuaFnGetPetSoulDataOnPet(curPossessionPetIndex, "QUAL")
	else
		m_PetSoulQual = -1
	end	
	
	EXTERIORFILTTING_TOTALKIND = Exterior:LuaFnGetExteriorPlayerFittingCount()
	
	NewExterior_PetSoul_InitList()
	
	NewExterior_PetSoul_CleanUp()
	
	NewExterior_PetSoul_FakeObject:SetFakeObject("Exterior_Player")
	Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
	Exterior:LuaFnUpdateExteriorPlayerData()
	
	g_CurSelExteriorID = 0
	g_CurPossVisualIndex = 0
	g_SelectPlan = 0

	local cacheExteriorID, cachePossVisualIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	g_CurPossVisualIndex = cachePossVisualIndex + 1
	if cacheExteriorID > 0 then
		g_TargetExteriorID = cacheExteriorID
		g_CurSelExteriorID = cacheExteriorID
	end
	
	NewExterior_PetSoul_UpdateList()
	
	NewExterior_PetSoul_UpdateColorItem()

	NewExterior_PetSoul_UpdateLeftBtn()
	
	NewExterior_PetSoul_UpdateObj()
	
	NewExterior_PetSoul_RemoveTip(g_CurSelExteriorID)

	NewExterior_PetSoul_UpdateRedPoint()

	NewExterior_PetSoul_ShowFashionWeaponCheckButton()
	
	NewExterior_PetSoul_ShowDressShareButton()
	
	NewExterior_PetSoul_UpdateRankButton()
	
	local curPossessionPetIndex = Pet:LuaFnGetPossessionPetIndex()
	if curPossessionPetIndex and curPossessionPetIndex >= 0 then
		
		NewExterior_PetSoul_SuperListNow:Show()
		NewExterior_PetSoul_SuperListNowText1:Show()
		NewExterior_PetSoul_SuperListNowText2:Show()
		NewExterior_PetSoul_SuperListNowText3:Show()
		NewExterior_PetSoul_Frame_RightClientBK:Hide()
		
		local curPetSoulAction = EnumAction(6*curPossessionPetIndex + 5, "my_pet_equip")
		if curPetSoulAction:GetID() ~= 0 then
			NewExterior_PetSoul_SuperListNow:SetActionItem(curPetSoulAction:GetID())
		end
		
		local strName = Pet:LuaFnGetPetSoulDataOnPet(curPossessionPetIndex, "NAME")
		local iQual = Pet:LuaFnGetPetSoulDataOnPet(curPossessionPetIndex, "QUAL")
		local iBloodRank = Pet:LuaFnGetPetSoulDataOnPet(curPossessionPetIndex, "BR")
		
		local strTemp = ScriptGlobal_Format("#{SHRH_20220427_65}", strName)
		NewExterior_PetSoul_SuperListNowText1:SetText(strTemp)
		
		local strQual = ""
		if iQual == 0 or iQual == 1 or iQual == 2 or iQual == 3 then
			strQual = g_QualStr[iQual + 1]
		end
		strTemp = ScriptGlobal_Format("#{SHRH_20220427_66}", strQual)
		NewExterior_PetSoul_SuperListNowText2:SetText(strTemp)
		
		strTemp = ScriptGlobal_Format("#{SHRH_20220427_67}", tostring(iBloodRank + 1))
		NewExterior_PetSoul_SuperListNowText3:SetText(strTemp)
		NewExterior_PetSoul_SuperListNow:SetProperty("Empty", "False")

		NewExterior_PetSoul_SuperListNowDef:Hide()
		
		if Exterior:LuaFnIsEquipExteriorInUse() == 1 then
			NewExterior_PetSoul_SuperListNowDef:Show()
		end
	else
		NewExterior_PetSoul_SuperListNow:Hide()
		NewExterior_PetSoul_SuperListNowText1:Hide()
		NewExterior_PetSoul_SuperListNowText2:Hide()
		NewExterior_PetSoul_SuperListNowText3:Hide()
		NewExterior_PetSoul_Frame_RightClientBK:Show()
	end
end

function NewExterior_PetSoul_SetDefaultState()
	local isEquip, nExteriorId, nPlanId = Exterior:LuaFnGetPossDefaultData()
	if isEquip > 0 then
		NewExterior_PetSoul_OnPetSoulEquipClick()
	else
		if (nExteriorId > 0) then
			local nIndex = 0
			for i = 1, g_MaxBarNum do
				local nID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, i - 1)
				if nID == nExteriorId then
					nIndex = i
				end
			end
			NewExterior_PetSoul_ItemClicked(nIndex)
		end
	end
	if Exterior:LuaFnIsCanRanSe(nExteriorId) <= 0 then
		return
	end
	if nPlanId > 0 then
		NewExterior_PetSoul_SelectColorButton(nPlanId)
	end
end

function NewExterior_PetSoul_UpdateLeftBtn()
	
	NewExterior_PetSoul_CleanUp_LeftButton()
	
	local sex = Player:GetMySex()
	
	--时装
	local nFashionId = -1
	NewExterior_PetSoul_Dress_LeftBtn:SetActionItem(-1)
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, cacheExteriorIdx)
		--local theAction = Exterior:LuaFnEnumExteriorFashionAction(1, cacheExteriorID, 0)
		if theAction:GetID() ~= 0 then
			NewExterior_PetSoul_Dress_LeftBtn:SetActionItem(theAction:GetID())
			NewExterior_PetSoul_Dress_ActionImg:Show()
			
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 and nCurFashionIdx == cacheExteriorIdx then
				NewExterior_PetSoul_Dress_ActionImg:Hide()
			end
			
			nFashionId = cacheExteriorID
		end
	else
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
		if cacheExteriorIdx ~= nil and cacheExteriorIdx >= 0 then
			local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(cacheExteriorIdx)
			if theAction:GetID() ~= 0 then
				NewExterior_PetSoul_Dress_LeftBtn:SetActionItem(theAction:GetID())
				NewExterior_PetSoul_Dress_ActionImg:Show()
				
				local nCurFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 and nCurFashionIdx == cacheExteriorIdx then
					NewExterior_PetSoul_Dress_ActionImg:Hide()
				end
			
				nFashionId = cacheExteriorID
			end
		else
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 then
				local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, nCurFashionIdx)
				if theAction:GetID() ~= 0 then
					NewExterior_PetSoul_Dress_LeftBtn:SetActionItem(theAction:GetID())
					
					nFashionId = nCurFashionId
				end
			else
				local nCurFashionIdx, nCurFashionId = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 then
					local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(nCurFashionIdx)
					if theAction:GetID() ~= 0 then
						NewExterior_PetSoul_Dress_LeftBtn:SetActionItem(theAction:GetID())
					
						nFashionId = nCurFashionId
					end
				end
			end			
		end			
	end
		
	NewExterior_PetSoul_Dress_LeftBtnLuxury:Hide()
	if nFashionId ~= -1 then	
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nFashionId, "Number")
		if nFashionNumber ~= nil and nFashionNumber > 0 then
			NewExterior_PetSoul_Dress_LeftBtnLuxury:Show()
		end
	end
	
	--坐骑
	local edType = 3
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		NewExterior_PetSoul_Ride_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_PetSoul_Ride_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 and DataPool:LuaFnIsExteriorRideActiveByRideCard(cacheExteriorID) ~= 1 then
			NewExterior_PetSoul_Ride_LockImg:Show()
		end
	end
	
	--脸型
	edType = 0
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_82}", strName)
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetToolTip(strTemp)	
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_PetSoul_FaceStyle_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_PetSoul_FaceStyle_LockImg:Show()
		end
	end
	
	--发型
	edType = 1
	cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_81}", strName)
		NewExterior_PetSoul_HairStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_PetSoul_HairStyle_ActionImg:Show()
		else
			if Exterior:LuaFnGetExteriorHairColorIndex() ~= cacheColorIndex then
			NewExterior_PetSoul_HairStyle_ActionImg:Show()
		end
	end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_PetSoul_HairStyle_LockImg:Show()
		end
	end
	
	--头像
	edType = 2
	local strHeadTip = ""
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("PORTRAIT")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_79}", strName)
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetToolTip(strTemp)
		strHeadTip = strTemp
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_PetSoul_PlayerFrame_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_PetSoul_PlayerFrame_LockImg:Show()
		end
	end
	
	--幻武
	local cacheWeaponLevel = 0
	cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{HSWQ_20220607_02}", strName, tostring(cacheWeaponLevel + 1))
		NewExterior_PetSoul_Weapon_LeftBtn:SetToolTip(strTemp)
	
		--试穿
		if Exterior:LuaFnGetExteriorWeaponInUse() ~= cacheExteriorID or cacheWeaponLevel ~= Exterior:LuaFnGetExteriorWeaponLevel() then
			NewExterior_PetSoul_Weapon_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExteriorWeapon(cacheExteriorID) ~= 1 then
			NewExterior_PetSoul_Weapon_LockImg:Show()
		end
	end
	
	--融魂外观
	edType = 4
	local strPossTip = ""
	local cachePossVisualIndex = 0
	cacheExteriorID, cachePossVisualIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{SHRH_20220427_64}", strName)
		NewExterior_PetSoul_PetSoul_LeftBtn:SetToolTip(strTemp)
		
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID or cachePossVisualIndex ~= Exterior:LuaFnGetExteriorPossVisualIndex() then
			NewExterior_PetSoul_PetSoul_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_PetSoul_PetSoul_LockImg:Show()
		end
	end

	-- 背饰
	local edOrnamentsType, cacheExteriorX, cacheExteriorY, cacheExteriorZ = 0,0,0,0
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsBack")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_PetSoul_Widget_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_Widget_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_PetSoul_Widget_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_PetSoul_Widget_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_PetSoul_Widget_LockImg:Show()
		end
	end
	-- 头饰
	edOrnamentsType = 1
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsHead")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_PetSoul_Headdress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_Headdress_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_PetSoul_Headdress_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_PetSoul_Headdress_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_PetSoul_Headdress_LockImg:Show()
		end
	end
end

function NewExterior_PetSoul_UpdateList()
	
	NewExterior_PetSoul_UpdateCheckButton()
	NewExterior_PetSoul_UpdateRedPoint()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType, m_PetSoulQual)
	
	local count = Exterior:LuaFnGetExteriorListCount(g_ExteriorType, 0)
	
	for i = 1, g_MaxBarNum do	
		NewExterior_PetSoul_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		NewExterior_PetSoul_SuperList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	if g_TargetExteriorIndex ~= 0 then
		NewExterior_PetSoul_SuperList:SetScrollPosition4Index(g_TargetExteriorIndex - 1)
		g_TargetExteriorID = 0
		g_TargetExteriorIndex = 0
	else
		NewExterior_PetSoul_SuperList:SetScrollPosition4Index(0)
	end
end

function NewExterior_PetSoul_SetItem(index, max_count)
	
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
	local strName = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Name")
	local strIcon = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Icon")
	local strImage = GetIconFullName(strIcon)
	local bDecoration = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Decoration")
	
	local strQual = ""
	local iQual = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Quality")
	if iQual == 0 or iQual == 1 or iQual == 2 or iQual == 3 then
		strQual = g_QualStr[iQual + 1]
	end
	
	local ctrlAction = bar:GetSubItem("NewExterior_PetSoul_SuperListItemAction")
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
		
		if g_CurSelExteriorID == nExteriorID and g_EquipExteriorId <= 0 then
			ctrlAction:SetPushed(1)
			bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionTry"):Show()
			if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
				bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionTry"):Hide()
			end
		else
			ctrlAction:SetPushed(0)
			bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionTry"):Hide()
		end
			
		if g_TargetExteriorID == nExteriorID then
			g_TargetExteriorIndex = index
		end
			
	end

	bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionTime"):Hide()
	
	bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionMark"):Hide()
	
	--锁
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
		bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionLock"):Hide()
		if m_PetSoulQual < iQual and bDecoration ~= 1 then
			bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionMark"):Show()	
		end
	else
		bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionLock"):Show()
	end	

	--使用中
	if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID and Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
		bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionDef"):Show()
	else
		bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionDef"):Hide()
	end
	
	--红点
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionTip"):Show()
	else
		bar:GetSubItem("NewExterior_PetSoul_SuperListItemActionTip"):Hide()
	end

end

function NewExterior_PetSoul_UpdateObj()
	local cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID ~= nil and cacheExteriorID >= 0 then
		Exterior:LuaFnUpdateExteriorPlayerData()		
	end	
	NewExterior_PetSoul_UpdateCamera()
end

function NewExterior_PetSoul_ItemClicked(nIndex)

	Exterior:LuaFnSetCurrentExteriorSetInfo("EQUIPPOSS", 0, g_CurPossVisualIndex - 1)
	g_EquipExteriorId = 0

	local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	if g_CurSelExteriorID ~= nExteriorID then
		g_CurSelExteriorID = nExteriorID
		if g_CurPossVisualIndex == 0 then
			g_CurPossVisualIndex = 1
		end
		--NewExterior_PetSoul_RanSeInfo()
		g_SelectPlan = 0
		Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", g_CurSelExteriorID, g_CurPossVisualIndex - 1)

		Exterior:LuaFnSetCurrentExteriorSetInfo("RANSE", 0)
		NewExterior_PetSoul_UpdateColorItem()

		NewExterior_PetSoul_UpdateRankButton()
		NewExterior_PetSoul_SetItemSelected(nIndex)
		NewExterior_PetSoul_UpdateObj()
		NewExterior_PetSoul_UpdateLeftBtn()
		NewExterior_PetSoul_RemoveTip(g_CurSelExteriorID)
		NewExterior_PetSoul_UpdateRedPoint()
	else
		local defExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
		local defPossVisualIndex = Exterior:LuaFnGetExteriorPossVisualIndex()
		Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", defExteriorID, defPossVisualIndex)
		NewExterior_PetSoul_Show()
	end
	
end

function NewExterior_PetSoul_ItemMouseMove(nIndex)

end

function NewExterior_PetSoul_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_PetSoul_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("NewExterior_PetSoul_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("NewExterior_PetSoul_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("NewExterior_PetSoul_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
	NewExterior_PetSoul_SuperListNow:SetPushed(0)

end

function NewExterior_PetSoul_RankClicked(index)
	if g_CurSelExteriorID == 0 and g_EquipExteriorId == 0 then
		NewExterior_PetSoul_UpdateRankButton()
		return
	end
	if g_CurPossVisualIndex ~= index then
		g_CurPossVisualIndex = index
		if g_CurSelExteriorID ~= 0 then
			Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", g_CurSelExteriorID, g_CurPossVisualIndex - 1)
		elseif g_EquipExteriorId ~= 0 then
			Exterior:LuaFnSetCurrentExteriorSetInfo("EQUIPPOSS", g_EquipExteriorId, g_CurPossVisualIndex - 1)
		end
		NewExterior_PetSoul_UpdateRankButton()
		
		NewExterior_PetSoul_UpdateObj()
		NewExterior_PetSoul_UpdateLeftBtn()
	end
end

function NewExterior_PetSoul_UpdateRankButton()
	for i = 1, 3 do
		
		if g_CurSelExteriorID == 0 and g_EquipExteriorId == 0 then
			g_RankButtons[i]:SetCheck(0)
			g_RankButtons[i]:Disable()
		else
			g_RankButtons[i]:Enable()
			if i == g_CurPossVisualIndex then
				g_RankButtons[i]:SetCheck(1)
			else
				g_RankButtons[i]:SetCheck(0)
			end
		end		
	end
end

function NewExterior_PetSoul_TryExterior()
	if Exterior:LuaFnIsHaveExteriorChange() ~= 1 then
		PushDebugMessage("#{WGTJ_201222_72}")
		return
	end
	
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	Exterior:LuaFnSaveExteriorAllChange(1)
end
	
function NewExterior_PetSoul_TakeOffRide()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(3)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", 0)
		NewExterior_PetSoul_UpdateLeftBtn()
	else
		Exterior:LuaFnSetExteriorInUse(3, 0, 0)
	end
end

function NewExterior_PetSoul_TakeOffPoss()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID == 0 then
		return
	end
	
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(4)
	if defExteriorID == 0 then
		g_CurSelExteriorID = 0
		g_CurPossVisualIndex = 0
		Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(4)
		Exterior:LuaFnUpdateExteriorPlayerData()
		
		NewExterior_PetSoul_UpdateRankButton()
		--列表
		NewExterior_PetSoul_UpdateList()
		--左侧
		NewExterior_PetSoul_UpdateLeftBtn()
		--模型
		NewExterior_PetSoul_UpdateObj()
	else
		Exterior:LuaFnSetExteriorInUse(4, 0, 0)
	end

	--清除染色方案
	NewExterior_PetSoul_HideRanSePlan()
end

function NewExterior_PetSoul_TakeOffWeapon()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorWeaponInUse()
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(5)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_PetSoul_UpdateLeftBtn()
		NewExterior_PetSoul_UpdateObj()
	else
		Exterior:LuaFnSetExteriorWeaponInUse(0, 0)
	end
end

function NewExterior_PetSoul_RemovePreview()
	if Exterior:LuaFnIsHaveExteriorChange() == 1 then
		Exterior:LuaFnRemovePlayerExteriorFitting()
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESET")
		Exterior:LuaFnInitCurrentExteriorSet(0)
		NewExterior_PetSoul_Show()
		PushDebugMessage("#{WGTJ_201222_98}")
	else
		PushDebugMessage("#{WGTJ_201222_76}")
	end
end

function NewExterior_PetSoul_Goto()
	AutoRuntoTargetExWithName(92, 134, 1, "云宸宸")
end

function NewExterior_PetSoul_CloseClick()
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)	
	NewExterior_PetSoul_SetPosition()
	this:Hide()
end

function NewExterior_PetSoul_OnHidden()

	if IsWindowShow("Profile_Save") then
		CloseWindow("Profile_Save", true)
	end
	
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_HairStyle")
		or IsWindowShow("NewExterior_PlayerFrame") 
		or IsWindowShow("NewExterior_Weapon")
		or IsWindowShow("NewExterior_Widget")
		or IsWindowShow("NewExterior_Headdress") then
	else	
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	end	
	
	NewExterior_PetSoul_CleanUp()
end

function NewExterior_PetSoul_CleanUp()
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_PetSoul_SuperListItemAction")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
		end
	end
	
	NewExterior_PetSoul_HideRanSePlan()

	g_EquipExteriorId = 0
	NewExterior_PetSoul_FakeObject:SetFakeObject("")
	
	NewExterior_PetSoul_CleanUp_LeftButton()
	
	NewExterior_PetSoul_SuperListNow:SetActionItem(-1)

	NewExterior_PetSoul_ColorItem1:SetProperty("NormalImage", "")
	NewExterior_PetSoul_ColorItem1:SetProperty("HoverImage", "")
	NewExterior_PetSoul_ColorItem2:SetProperty("NormalImage", "")
	NewExterior_PetSoul_ColorItem2:SetProperty("HoverImage", "")
	NewExterior_PetSoul_ColorItem3:SetProperty("NormalImage", "")
	NewExterior_PetSoul_ColorItem3:SetProperty("HoverImage", "")

	g_RanSeButtonQuality[1]:Hide()
	g_RanSeButtonQuality[2]:Hide()
	g_RanSeButtonQuality[3]:Hide()
end

function NewExterior_PetSoul_CleanUp_LeftButton()
	
	NewExterior_PetSoul_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		NewExterior_PetSoul_FaceStyle_LeftBtn,
		NewExterior_PetSoul_HairStyle_LeftBtn,
		NewExterior_PetSoul_PlayerFrame_LeftBtn,
		NewExterior_PetSoul_Ride_LeftBtn,
		NewExterior_PetSoul_PetSoul_LeftBtn,
		NewExterior_PetSoul_Weapon_LeftBtn,
		NewExterior_PetSoul_Widget_LeftBtn,
		NewExterior_PetSoul_Headdress_LeftBtn,
	}
	
	for i in pairs(ctrl_list) do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_PetSoul_Dress_LeftBtnLuxury:Hide()
	NewExterior_PetSoul_Dress_ActionImg:Hide()
	NewExterior_PetSoul_FaceStyle_ActionImg:Hide()
	NewExterior_PetSoul_HairStyle_ActionImg:Hide()
	NewExterior_PetSoul_PlayerFrame_ActionImg:Hide()
	NewExterior_PetSoul_Ride_ActionImg:Hide()
	NewExterior_PetSoul_PetSoul_ActionImg:Hide()
	NewExterior_PetSoul_Weapon_ActionImg:Hide()
	NewExterior_PetSoul_Widget_ActionImg:Hide()
	NewExterior_PetSoul_Headdress_ActionImg:Hide()

	NewExterior_PetSoul_Dress_LockImg:Hide()
	NewExterior_PetSoul_FaceStyle_LockImg:Hide()
	NewExterior_PetSoul_HairStyle_LockImg:Hide()
	NewExterior_PetSoul_PlayerFrame_LockImg:Hide()
	NewExterior_PetSoul_Ride_LockImg:Hide()
	NewExterior_PetSoul_PetSoul_LockImg:Hide()
	NewExterior_PetSoul_Weapon_LockImg:Hide()
	NewExterior_PetSoul_Widget_LockImg:Hide()
	NewExterior_PetSoul_Headdress_LockImg:Hide()
end

function NewExterior_PetSoul_FakeObject_TurnLeft(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		NewExterior_PetSoul_FakeObject:RotateBegin(-0.3)
	else
		NewExterior_PetSoul_FakeObject:RotateEnd()
	end
end

function NewExterior_PetSoul_FakeObject_TurnRight(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
			NewExterior_PetSoul_FakeObject:RotateBegin(0.3)
		else
		NewExterior_PetSoul_FakeObject:RotateEnd()
	end
end
--缩小
function NewExterior_PetSoul_ZoomOut()
	if g_Distance == 1 then
		return
	end
	g_Distance = g_Distance - 1		
	NewExterior_PetSoul_UpdateCamera()
end
--放大
function NewExterior_PetSoul_ZoomIn()
	if g_Distance == g_Distance_Max then
		return
	end	
	g_Distance = g_Distance + 1	
	NewExterior_PetSoul_UpdateCamera()
end

function NewExterior_PetSoul_UpdateCamera()
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
	FakeObj_SetCamera("Exterior_Player", g_CameraHeight, fHeight)
	FakeObj_SetCamera("Exterior_Player", g_CameraDistance, fDistance)
	FakeObj_SetCamera("Exterior_Player", g_CameraPitch, fPitch)
end

function NewExterior_PetSoul_UpdateCheckButton()
--	NewExterior_PetSoul_ButtonHuanwu:SetCheck(0)
--	NewExterior_PetSoul_ButtonZhuangrong:SetCheck(0)
--	NewExterior_PetSoul_ButtonFuti:SetCheck(0)
--	NewExterior_PetSoul_ButtonZuoqi:SetCheck(1)
end

--右键取下时装
function NewExterior_PetSoul_ActionToDressBox()
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		cacheExteriorID = 0
		cacheExteriorIdx = -1
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", cacheExteriorID, cacheExteriorIdx)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(0)			
		NewExterior_PetSoul_Show()
		--return
	end
	Exterior:LuaFnUnUseExteriorFashion(1)
end

--时装
function NewExterior_PetSoul_OpenFashion()
	NewExterior_PetSoul_SavePosition()
	PushEvent("OPEN_EXTERIOR_FASHION", 1, 0)
end

--坐骑
function NewExterior_PetSoul_OpenRide()
	NewExterior_PetSoul_SavePosition()
	Exterior:LuaFnAskOpenExterior(3)
end

--发型
function NewExterior_PetSoul_OpenHair()
	NewExterior_PetSoul_SavePosition()	
	Exterior:LuaFnAskOpenExterior(1)
end

--脸型
function NewExterior_PetSoul_OpenFace()
	NewExterior_PetSoul_SavePosition()	
	Exterior:LuaFnAskOpenExterior(0)
end

--头像
function NewExterior_PetSoul_OpenPortrait()
	NewExterior_PetSoul_SavePosition()	
	Exterior:LuaFnAskOpenExterior(2)
end

--幻武
function NewExterior_PetSoul_OpenWeapon()
	NewExterior_PetSoul_SavePosition()
	Exterior:LuaFnAskOpenExteriorWeapon()
end

--融魂外观
function NewExterior_PetSoul_OpenPoss()
	--NewExterior_PetSoul_SavePosition()	
	--Exterior:LuaFnAskOpenExterior(4)
end

function NewExterior_PetSoul_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	--CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_Widget", true)
	CloseWindow("NewExterior_Headdress", true)
end

function NewExterior_PetSoul_SavePosition()
	Variable:SetVariable("ExteriorUnionPos", NewExterior_PetSoul_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_PetSoul_SetPosition()
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_PetSoul_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end
end

function NewExterior_PetSoul_RemoveTip(nExteriorID)
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		Exterior:LuaFnRemoveExteriorTip(g_ExteriorType, nExteriorID)
		
		for i = 1, g_MaxBarNum do
			if g_BarList[i] then
				local nID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, i - 1)
				if Exterior:LuaFnGetExteriorTip(g_ExteriorType, nID) == 1 then
					g_BarList[i]:GetSubItem("NewExterior_PetSoul_SuperListItemActionTip"):Show()
				else
					g_BarList[i]:GetSubItem("NewExterior_PetSoul_SuperListItemActionTip"):Hide()
				end
			end
		end
	--	NewExterior_Ride_UpdateCheckButton()
	end	
end

function NewExterior_PetSoul_UpdateRedPoint()

	NewExterior_PetSoul_Dress_Tip:Hide()
	
	if Exterior:LuaFnIsHaveExteriorShowTip(3) == 1 then
		NewExterior_PetSoul_Ride_Tip:Show()
	else
		NewExterior_PetSoul_Ride_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(0) == 1 then
		NewExterior_PetSoul_FaceStyle_Tip:Show()
	else
		NewExterior_PetSoul_FaceStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(1) == 1 or Exterior:LuaFnIsHaveHairColorShowTip() == 1 then
		NewExterior_PetSoul_HairStyle_Tip:Show()
	else
		NewExterior_PetSoul_HairStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(2) == 1 then
		NewExterior_PetSoul_PlayerFrame_Tip:Show()
	else
		NewExterior_PetSoul_PlayerFrame_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(4) == 1 then
		NewExterior_PetSoul_PetSoul_Tip:Show()
	else
		NewExterior_PetSoul_PetSoul_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorWeaponShowTip() == 1 then
		NewExterior_PetSoul_Weapon_Tip:Show()
	else
		NewExterior_PetSoul_Weapon_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(0) == 1 then
		NewExterior_PetSoul_Widget_Tip:Show()
	else
		NewExterior_PetSoul_Widget_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(1) == 1 then
		NewExterior_PetSoul_Headdress_Tip:Show()
	else
		NewExterior_PetSoul_Headdress_Tip:Hide()
	end
end

function NewExterior_PetSoul_ShowFashionWeaponCheckButton()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	--NewExterior_PetSoul_Dress_Type:SetCheck(IsDisplay)
end

function NewExterior_PetSoul_FashionDisplay()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	if IsDisplay == 1 then
		SystemSetup:Set_Display_Dress(0)
	else
		SystemSetup:Set_Display_Dress(1)
	end	
end

function NewExterior_PetSoul_ShowDressShareButton()
	
	local player_level = Player:GetData("LEVEL")
	if player_level >= 15 then
		NewExterior_PetSoul_SaveChangeBtn:Hide()
		NewExterior_PetSoul_ShareBtn:Show()
	else
		NewExterior_PetSoul_SaveChangeBtn:Hide()
		NewExterior_PetSoul_ShareBtn:Hide()
	end
	
end

function NewExterior_PetSoul_Share_Clicked()
	local ret = Exterior:LuaFnExteriorPlayerShareClick(0)
	return ret	
end

function NewExterior_PetSoul_SaveChange_Clicked()	
	local ret = Exterior:LuaFnExteriorPlayerOpenSharePlan()
	return ret	
end

function NewExterior_PetSoul_SelectColorButton(idx)

	if idx < 1 or idx > 3 then
		return
	end

	if g_CurSelExteriorID <= 0 and g_EquipExteriorId <= 0 then
		return 
	end

	local nExteriorID = 0
	if g_CurSelExteriorID > 0 then
		nExteriorID = g_CurSelExteriorID
	else
		nExteriorID = g_EquipExteriorId
	end

	local nColor = Exterior:LuaFnGetRanSeColorItem(nExteriorID, idx)

	g_SelectPlan = idx;
	Exterior:LuaFnSetCurrentExteriorSetInfo("RANSE", nColor)
	
	NewExterior_PetSoul_UpdateColorItem()
	NewExterior_PetSoul_UpdateObj()
end

function NewExterior_PetSoul_UpdateColorItem()

	if g_CurSelExteriorID <= 0 and g_EquipExteriorId <= 0 then
		return 
	end

	local nExteriorID = 0
	if g_CurSelExteriorID > 0 then
		nExteriorID = g_CurSelExteriorID
	elseif g_EquipExteriorId > 0 then
		nExteriorID = g_EquipExteriorId
	else
		return
	end

	if Exterior:LuaFnIsCanRanSe(nExteriorID) <= 0 then
		NewExterior_PetSoul_HideRanSePlan()
		return
	end
	
	for j = 1, 3 do
		g_RanSeButtons[j]:Show()
		g_RanSeButtons[j]:SetPushed(0)
		g_RanSeButtonLock[j]:Hide()
		g_RanSeButtonTry[j]:Hide()
		g_RanSeButtonDef[j]:Hide()
		g_RanSeButtons[j]:SetProperty("NormalImage", "")
		g_RanSeButtons[j]:SetProperty("HoverImage", "")
		g_RanSeButtons[j]:SetProperty("Empty", "False")
		g_RanSeButtons[j]:SetProperty("UseDefaultTooltip", "True")
	end

	NewExterior_PetSoul_F5Btn:Show()
	for j = 1, 3 do
		local nColor = Exterior:LuaFnGetRanSeColorItem(nExteriorID, j)
		local planstr

		if (nColor <= 0) then
			planstr = "原始风格"
			g_RanSeButtonLock[j]:Show()
			local strIcon = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "Icon")
			local strImage = GetIconFullName(strIcon)
			g_RanSeButtons[j]:SetProperty("NormalImage", strImage)
			g_RanSeButtons[j]:SetProperty("HoverImage", strImage)
			--g_RanSeButtons[j]:SetProperty("PushedImage", strImage)
			g_RanSeButtonQuality[j]:Hide()
		else
			planstr = Exterior:LuaFnGetRanSePlanName(nExteriorID, nColor)
			local strIcon = Exterior:LuaFnGetRanSePlanImage(nExteriorID, nColor)
			local strImage = GetIconFullName(strIcon)
			g_RanSeButtons[j]:SetProperty("NormalImage", strImage)
			g_RanSeButtons[j]:SetProperty("HoverImage", strImage)
			--g_RanSeButtons[j]:SetProperty("PushedImage", strImage)

			g_RanSeButtonLock[j]:Hide()
			local nQuality = Exterior:LuaFnGetQualityForRanSe(nExteriorID, nColor)
			if nQuality >= 3 then
				g_RanSeButtonQuality[j]:Show()
			end
		end

		g_RanSeButtons[j]:SetToolTip(planstr)

		if g_CurSelExteriorID > 0 then
			if Exterior:LuaFnIsPlanInUsing(nExteriorID, j) == 1 then
				g_RanSeButtonDef[j]:Show()
				g_RanSeButtonLock[j]:Hide()
			end	
		elseif g_EquipExteriorId > 0 then
			if Exterior:LuaFnIsPlanInUsingByEquip(nExteriorID, j) == 1 then
				g_RanSeButtonDef[j]:Show()
				g_RanSeButtonLock[j]:Hide()
			end	
		end

	end

	if g_SelectPlan <= 0 then
		return
	end

	for j = 1, 3 do
		g_RanSeButtons[j]:SetPushed(0)
	end
	g_RanSeButtons[g_SelectPlan]:SetPushed(1)

	local nColor = Exterior:LuaFnGetRanSeColorItem(nExteriorID, g_SelectPlan)
	if (nColor <= 0) then
		g_RanSeButtonLock[g_SelectPlan]:Show()
		g_RanSeButtonTry[g_SelectPlan]:Hide()
		g_RanSeButtonDef[g_SelectPlan]:Hide()
	else
		if g_CurSelExteriorID > 0 then
			if Exterior:LuaFnIsPlanInUsing(nExteriorID, g_SelectPlan) == 1 then
				g_RanSeButtonDef[g_SelectPlan]:Show()
				g_RanSeButtonLock[g_SelectPlan]:Hide()
				g_RanSeButtonTry[g_SelectPlan]:Hide()
				return
			end	
		end
		if g_EquipExteriorId > 0 then
			if Exterior:LuaFnIsPlanInUsingByEquip(nExteriorID, g_SelectPlan) == 1 then
				g_RanSeButtonDef[g_SelectPlan]:Show()
				g_RanSeButtonLock[g_SelectPlan]:Hide()
				g_RanSeButtonTry[g_SelectPlan]:Hide()
				return
			end	
		end
		g_RanSeButtonDef[g_SelectPlan]:Hide()
		g_RanSeButtonLock[g_SelectPlan]:Hide()
		g_RanSeButtonTry[g_SelectPlan]:Show()
	end
end

function NewExterior_PetSoul_RemoveRanSe()
	
	Exterior:LuaFnSetCurrentExteriorSetInfo("RESETRANSE")
	g_SelectPlan = 0
	NewExterior_PetSoul_UpdateColorItem()

	NewExterior_PetSoul_UpdateObj()
end

function NewExterior_PetSoul_HideRanSePlan()
	for j = 1, 3 do
		g_RanSeButtons[j]:SetPushed(0)
		g_RanSeButtons[j]:Hide()
		g_RanSeButtonLock[j]:Hide()
		g_RanSeButtonTry[j]:Hide()
		g_RanSeButtonDef[j]:Hide()
		g_RanSeButtons[j]:SetProperty("NormalImage", "")
		g_RanSeButtons[j]:SetProperty("HoverImage", "")
		g_RanSeButtons[j]:SetProperty("Empty", "False")
		g_RanSeButtons[j]:SetProperty("UseDefaultTooltip", "True")
	end
	NewExterior_PetSoul_F5Btn:Hide()
end

function NewExterior_PetSoul_OnPetSoulEquipClick()

	g_SelectPlan = 0
	g_CurSelExteriorID = 0

	--清除染色方案
	NewExterior_PetSoul_HideRanSePlan()

	NewExterior_PetSoul_SuperListNow:SetPushed(1)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_PetSoul_SuperListItemAction")
			if ctrlAction ~= nil then
				ctrlAction:SetPushed(0)	
				g_BarList[i]:GetSubItem("NewExterior_PetSoul_SuperListItemActionTry"):Hide()
			end
			
		end
	end
	if g_CurPossVisualIndex == 0 then
		g_CurPossVisualIndex = 1
	end

	for j = 1, 3 do
		g_RanSeButtons[j]:Show()
	end

	local nColor, nExteriorID = Exterior:LuaFnGetRanSePlanByEquip(1)
	if nExteriorID <= 0 then
		NewExterior_PetSoul_HideRanSePlan()
	end

	g_EquipExteriorId = nExteriorID 

	Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", 0, g_CurPossVisualIndex - 1)
	Exterior:LuaFnSetCurrentExteriorSetInfo("RANSE", 0)
	Exterior:LuaFnSetCurrentExteriorSetInfo("EQUIPPOSS", g_EquipExteriorId, g_CurPossVisualIndex - 1)

	NewExterior_PetSoul_UpdateObj()
	NewExterior_PetSoul_UpdateColorItem()
	NewExterior_PetSoul_UpdateRankButton()
	NewExterior_PetSoul_UpdateLeftBtn()
end

-- 背挂
function NewExterior_PetSoul_OpenOrnamentsBack()
	NewExterior_PetSoul_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(0)
end

function NewExterior_PetSoul_ActionToOrnamentsBack()
	local useID = OrnamentsScript:GetOrnamentsUseID(0)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(0)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSBACK", 0, 0, 0, 0)
	NewExterior_PetSoul_UpdateLeftBtn()
	NewExterior_PetSoul_UpdateObj()
end

-- 头饰
function NewExterior_PetSoul_OpenOrnamentsHead()
	NewExterior_PetSoul_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(1)
end

function NewExterior_PetSoul_ActionToOrnamentsHead()
	local useID = OrnamentsScript:GetOrnamentsUseID(1)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(1)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", 0, 0, 0, 0)
	NewExterior_PetSoul_UpdateLeftBtn()
	NewExterior_PetSoul_UpdateObj()
end
--!!!reloadscript =NewExterior_PetSoul