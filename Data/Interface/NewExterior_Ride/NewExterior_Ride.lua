--!!!reloadscript =NewExterior_Ride
local g_NewExterior_Ride_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 0;
local g_TargetExteriorIndex = 0		--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID

local g_CurSelExteriorID = 0			--当前选择的外观ID，从1开始

local g_NeedChangeScrollSize = 1
local g_NeedChangeCollectionListScrollSize = 1

local g_Distance = 1
local g_Distance_Ori = 1
local g_Distance_Max = 3
local g_InitList = 0
local g_ExteriorType = 3 --坐骑
local g_MaxBarNum = 0
local g_BarList = {}
local g_ViewMode = 0 --0是角色骑马1是只有马

local g_MaxRideCardHaveRide = 0
local g_RideCardBarList = {}
local g_CameraHeight = 1     --摄影机高度
local g_CameraDistance = 2   --摄影机距离
local g_CameraPitch = 3      --摄影机角度
local g_CameraPosition =
{
	--女性相关位置
	[0] = {fHeight = 0.82, fDistance = 6.5, fPitch=0.1},
	--男性相关位置
	[1] = {fHeight = 0.91, fDistance = 7.1, fPitch=0.2},
}

local g_PetSoulLevelLimit = 85

local g_CurSubPage = 0

local g_RideCollectionBarList = {}
local g_MaxRideCollectionCount = 0

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
function NewExterior_Ride_PreLoad()
	this:RegisterEvent("OPEN_EXTERIOR")
	this:RegisterEvent("ADD_EXTERIOR", false)
	this:RegisterEvent("UPDATE_EXTERIOR", false)
	this:RegisterEvent("EXTERIOR_OUTTIME", false)	
	this:RegisterEvent("EXTERIOR_ID_CHANGED", false)
	this:RegisterEvent("EXTERIOR_POSS_VISUAL_INDEX", false)
	this:RegisterEvent("EXTERIOR_HAIR_COLOR_INDEX", false)
	this:RegisterEvent("STOP_FITTING_EXTERIOR_RIDE", false)
	
	this:RegisterEvent("ADD_EXTERIOR_WEAPON", false)
	this:RegisterEvent("UPDATE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("EXTERIOR_OUTTIME_WEAPON", false)
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_CHANGED", false)	
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_LEVEL_CHANGED", false)
	
	this:RegisterEvent("UPDATE_EXTERIOR_RIDE", false)
	
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("UPDATE_EXTERIOR_FASHION", false)
	this:RegisterEvent("REMOVE_EXTERIOR", false)
	
	this:RegisterEvent("EXERIOR_SAVEALL_RET", false)
	
	this:RegisterEvent("OPEN_STALL_SALE",false)
	this:RegisterEvent("PROGRESSBAR_SHOW",false)
	this:RegisterEvent("MODELID_CHANGE",false)
	
	this:RegisterEvent("UNIT_LEVEL", false)
	
	this:RegisterEvent("UPDATE_RIDE_CARD_INFO", false)
	this:RegisterEvent("OPEN_RIDE_CARD_INFO")
	this:RegisterEvent("OPEN_DRESSPREVIEW", false)
	this:RegisterEvent("ORNAMENTS_DISPLAYUPDATE", false)
end

--=========
--OnLoad
--=========
function NewExterior_Ride_OnLoad()
	g_NewExterior_Ride_UnifiedPosition = NewExterior_Ride_Frame:GetProperty("UnifiedPosition")
end
--=========
--OnEvent
--=========
function NewExterior_Ride_OnEvent(event)

	if event == "OPEN_EXTERIOR" then
		if tonumber(arg0) == g_ExteriorType then
			if this:IsVisible() then
				if tonumber(arg1) == 0 then
					NewExterior_Ride_SavePosition()
					this:Hide()
				end
			else
				NewExterior_Ride_SetPosition()
				NewExterior_Ride_CloseSameGroupWindow()
				this:Show()
				g_CurSubPage = 0
				NewExterior_Ride_Show()
			end
		end
		return
	end
	
	if event == "OPEN_RIDE_CARD_INFO" then
		this:Show()
		g_CurSubPage = 1
		NewExterior_Ride_Show()
		return
	end
	
	if event == "OPEN_STALL_SALE"			-- 开始摆摊，还原试穿
		or event == "PROGRESSBAR_SHOW"		-- 读进度条中，还原试穿
		or event == "MODELID_CHANGE" 		-- 变身 关闭界面
		then
		NewExterior_Ride_CloseClick()
		return
	end
	
	if event == "EXERIOR_SAVEALL_RET" then
		if not this:IsVisible() then
			return
		end
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESETEX")
		Exterior:LuaFnInitCurrentExteriorSetExceptFashion(0)
		NewExterior_Ride_Show()	
	end
	
	if event == "UPDATE_EXTERIOR_RIDE" or event == "STOP_FITTING_EXTERIOR_RIDE" then
		if not this:IsVisible() then
			return
		end
		local defExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", defExteriorID)
		NewExterior_Ride_Show()
	end
	
	if event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "REMOVE_EXTERIOR"  or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if not this:IsVisible() then
			return
		end
		if tonumber(arg0) == g_ExteriorType then
			NewExterior_Ride_Show()
		else
			--左侧
			NewExterior_Ride_UpdateLeftBtn()
			NewExterior_Ride_UpdateRedPoint()
			--更新一下模型
			Exterior:LuaFnUpdateExteriorPlayerData()
			Exterior:LuaFnUpdateExteriorPlayerData()
		end
		return
	end
	
	if event == "EXTERIOR_POSS_VISUAL_INDEX" or event == "EXTERIOR_HAIR_COLOR_INDEX" or event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_Ride_UpdateLeftBtn()
		NewExterior_Ride_UpdateRedPoint()
		--更新一下模型
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
	
	if event == "ADD_EXTERIOR_WEAPON" or event == "UPDATE_EXTERIOR_WEAPON" or event == "EXTERIOR_OUTTIME_WEAPON" or event == "DEF_EXTERIOR_WEAPON_CHANGED" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_Ride_UpdateLeftBtn()
		NewExterior_Ride_UpdateRedPoint()
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
			NewExterior_Ride_UpdateLeftBtn()
			--更新一下模型
			Exterior:LuaFnUpdateExteriorPlayerData()
		end
		return
	end	
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			this:Hide()
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_Ride_Frame:SetProperty("UnifiedPosition", g_NewExterior_Ride_UnifiedPosition)
	end
	
	if event == "UNIT_LEVEL" and arg0 == "player" then
		if this:IsVisible() then
			NewExterior_Ride_UpdateLeftBtn()
		end
	end
	
	if event == "UPDATE_RIDE_CARD_INFO" then
		if not this:IsVisible() then
			return
		end

		NewExterior_Ride_Show()
	end
	
	-- FakeObject模型界面互斥
	if ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then   --时装预览
		if (this:IsVisible()) then
			this:Hide()
			return
		end
	end		
	
	if event == "ORNAMENTS_DISPLAYUPDATE" then
		-- 刷新模型
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
end

function NewExterior_Ride_InitList()
	
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetExteriorMaxCount(g_ExteriorType)
		
		for i = 1, g_MaxBarNum do
			local bar = NewExterior_Ride_SuperList:AddChild("NewExterior_Ride_SuperListItem")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("NewExterior_Ride_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("NewExterior_Ride_ItemClicked(%d)", i))
			bar:GetSubItem("NewExterior_Ride_SuperListItemAction"):SetEvent("MouseMove", string.format("NewExterior_Ride_ItemMouseMove(%d)", i))
			bar:GetSubItem("NewExterior_Ride_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("NewExterior_Ride_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
			bar:GetSubItem("NewExterior_Ride_SuperListItemAction"):SetEvent("MouseRClick", string.format("NewExterior_Ride_ItemRClicked(%d)", i))
		end
		
		g_MaxRideCardHaveRide = 30
		for i = 1,  30 do
			local bar = NewExterior_Ride_SuperList2:AddChild("NewExterior_Ride_SuperList2Item")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_RideCardBarList[i] = bar	
			bar:GetSubItem("NewExterior_Ride_SuperList2ItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("NewExterior_Ride_SuperList2ItemAction"):SetProperty("UseDefaultTooltip", "True")
		end
		
		g_MaxRideCollectionCount = DataPool:LuaFnGetRideCollectionMaxCount()
		for i = 1,  g_MaxRideCollectionCount do
			local bar = NewExterior_Ride_SuperList3_1:AddChild("NewExterior_Ride_SuperList3_1_ItemCommon1")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_RideCollectionBarList[i] = bar	
			bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1"):SetProperty("Empty", "False")
			bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1"):SetProperty("UseDefaultTooltip", "True")
		end
		g_InitList = 1
	end
end

function NewExterior_Ride_Show()
	NewExterior_Ride_SuperListOurBtn_Tip:Hide()
	
	--显示分页
	NewExterior_Ride_ShowSubPage()
	
	g_NeedChangeScrollSize = 1
	g_NeedChangeCollectionListScrollSize = 1
				
	EXTERIORFILTTING_TOTALKIND = Exterior:LuaFnGetExteriorPlayerFittingCount()
	
	NewExterior_Ride_InitList()
	
	NewExterior_Ride_CleanUp()
	
	Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
	Exterior:LuaFnUpdateExteriorPlayerData()
	
	g_CurSelExteriorID = 0
	
	--坐骑
	g_ViewMode = 0
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		g_ViewMode = 1
		g_TargetExteriorID = cacheExteriorID
		g_CurSelExteriorID = cacheExteriorID
	end
	
	--列表
	NewExterior_Ride_UpdateList()
	NewExterior_Ride_UpdateRideCardList()
	NewExterior_Ride_UpdateRideCollectionList()
	--左侧
	NewExterior_Ride_UpdateLeftBtn()
	--模型
	NewExterior_Ride_UpdateObj()
	
	NewExterior_Ride_RemoveTip(g_CurSelExteriorID)
	NewExterior_Ride_UpdateRedPoint()
	
	NewExterior_Ride_Model_Plus:Hide()
	NewExterior_Ride_Model_Subtract:Hide()
	
	local max_speed = Exterior:LuaFnGetExteriorRideMaxSpeed()
	local strTemp = ScriptGlobal_Format("#{WGTJ_201222_111}", tostring(max_speed))
	NewExterior_Ride_Text1:SetText(strTemp)
	
	NewExterior_Ride_ShowFashionWeaponCheckButton()
	
	NewExterior_Ride_ShowDressShareButton()
	
end
--左侧
function NewExterior_Ride_UpdateLeftBtn()
	
	NewExterior_Ride_CleanUp_LeftButton()
	
	local sex = Player:GetMySex()
	
	--时装
	local nFashionId = -1
	NewExterior_Ride_Dress_LeftBtn:SetActionItem(-1)
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, cacheExteriorIdx)
		--local theAction = Exterior:LuaFnEnumExteriorFashionAction(1, cacheExteriorID, 0)
		if theAction:GetID() ~= 0 then
			NewExterior_Ride_Dress_LeftBtn:SetActionItem(theAction:GetID())
			NewExterior_Ride_Dress_ActionImg:Show()
			
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 and nCurFashionIdx == cacheExteriorIdx then
				NewExterior_Ride_Dress_ActionImg:Hide()
			end
			
			nFashionId = cacheExteriorID
		end
	else
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
		if cacheExteriorIdx ~= nil and cacheExteriorIdx >= 0 then
			local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(cacheExteriorIdx)
			if theAction:GetID() ~= 0 then
				NewExterior_Ride_Dress_LeftBtn:SetActionItem(theAction:GetID())
				NewExterior_Ride_Dress_ActionImg:Show()
				
				local nCurFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 and nCurFashionIdx == cacheExteriorIdx then
					NewExterior_Ride_Dress_ActionImg:Hide()
				end
				
				nFashionId = cacheExteriorID
			end
		else
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 then
				local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, nCurFashionIdx)
				if theAction:GetID() ~= 0 then
					NewExterior_Ride_Dress_LeftBtn:SetActionItem(theAction:GetID())
					
					nFashionId = nCurFashionId
				end
			else
				local nCurFashionIdx, nCurFashionId = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 then
					local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(nCurFashionIdx)
					if theAction:GetID() ~= 0 then
						NewExterior_Ride_Dress_LeftBtn:SetActionItem(theAction:GetID())
						
						nFashionId = nCurFashionId
					end
				end
			end			
		end	
	end
		
	NewExterior_Ride_Dress_LeftBtnLuxury:Hide()
	if nFashionId ~= -1 then	
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nFashionId, "Number")
		if nFashionNumber ~= nil and nFashionNumber > 0 then
			NewExterior_Ride_Dress_LeftBtnLuxury:Show()
		end
	end
	
	--坐骑
	local edType = 3
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Ride_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		NewExterior_Ride_Ride_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Ride_Ride_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 and DataPool:LuaFnIsExteriorRideActiveByRideCard(cacheExteriorID) ~= 1 then
			NewExterior_Ride_Ride_LockImg:Show()
		end
	end

	--脸型
	edType = 0
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_82}", strName)
		NewExterior_Ride_FaceStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Ride_FaceStyle_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Ride_FaceStyle_LockImg:Show()
		end
	end
	
	--发型
	edType = 1
	cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Ride_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_81}", strName)
		NewExterior_Ride_HairStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Ride_HairStyle_ActionImg:Show()
		else
			if Exterior:LuaFnGetExteriorHairColorIndex() ~= cacheColorIndex then
				NewExterior_Ride_HairStyle_ActionImg:Show()
			end
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Ride_HairStyle_LockImg:Show()
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
		NewExterior_Ride_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_79}", strName)
		NewExterior_Ride_PlayerFrame_LeftBtn:SetToolTip(strTemp)
		strHeadTip = strTemp
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Ride_PlayerFrame_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Ride_PlayerFrame_LockImg:Show()
		end		
	end
	
	--幻武
	local cacheWeaponLevel = 0
	cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{HSWQ_20220607_02}", strName, tostring(cacheWeaponLevel + 1))
		NewExterior_Ride_Weapon_LeftBtn:SetToolTip(strTemp)
	
		--试穿
		if Exterior:LuaFnGetExteriorWeaponInUse() ~= cacheExteriorID or cacheWeaponLevel ~= Exterior:LuaFnGetExteriorWeaponLevel() then
			NewExterior_Ride_Weapon_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExteriorWeapon(cacheExteriorID) ~= 1 then
			NewExterior_Ride_Weapon_LockImg:Show()
		end
	end
	
	--融魂外观
	local player_level = Player:GetData("LEVEL")
	if player_level < g_PetSoulLevelLimit then
		NewExterior_Ride_PetSoul_LeftCheckBtn:Hide()
	else
		NewExterior_Ride_PetSoul_LeftCheckBtn:Show()
	end

	edType = 4
	local strPossTip = ""
	local cachePossVisualIndex = 0
	cacheExteriorID, cachePossVisualIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Name", sex)
		local strIcon = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{SHRH_20220427_64}", strName)
		NewExterior_Ride_PetSoul_LeftBtn:SetToolTip(strTemp)
		
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID or cachePossVisualIndex ~= Exterior:LuaFnGetExteriorPossVisualIndex() then
			NewExterior_Ride_PetSoul_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Ride_PetSoul_LockImg:Show()
		end
	end

	-- 背饰
	local edOrnamentsType, cacheExteriorX, cacheExteriorY, cacheExteriorZ = 0,0,0,0
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsBack")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Ride_Widget_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_Widget_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_Ride_Widget_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_Ride_Widget_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_Ride_Widget_LockImg:Show()
		end
	end

	-- 头饰
	edOrnamentsType = 1
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsHead")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Ride_Headdress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_Headdress_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_Ride_Headdress_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_Ride_Headdress_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_Ride_Headdress_LockImg:Show()
		end
	end
end
--列表
function NewExterior_Ride_UpdateList()
	
	NewExterior_Ride_UpdateCheckButton()
	NewExterior_Ride_UpdateRedPoint()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType)
	local count = Exterior:LuaFnGetExteriorListCount(g_ExteriorType, 0)
	
	for i = 1, g_MaxBarNum do	
		NewExterior_Ride_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		NewExterior_Ride_SuperList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	if g_TargetExteriorIndex ~= 0 then
		NewExterior_Ride_SuperList:SetScrollPosition4Index(g_TargetExteriorIndex - 1)
		g_TargetExteriorID = 0
		g_TargetExteriorIndex = 0
	else
		NewExterior_Ride_SuperList:SetScrollPosition4Index(0)
	end

end

function NewExterior_Ride_SetItem(index, max_count)
	
	if g_BarList[index] == nil then
		return
	end
	
	if index > max_count then
		g_BarList[index]:Hide()
		return
	end
	
	local bar = g_BarList[index]
	bar:Show()
	
	local nMyMenpai = Player:GetData("MEMPAI")
	local nExteriorID 	= Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, index - 1)
	local strIcon 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Icon")
	local strName 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Name")
	local nQuality 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Quality")
	local strImage = GetIconFullName(strIcon)
	local nLuxury 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Luxury")
	local nMenpai 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Menpai")
	
	local ctrlAction = bar:GetSubItem("NewExterior_Ride_SuperListItemAction")
	if ctrlAction ~= nil then
	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		local strTemp = Exterior:LuaFnGetRideToolTip(nExteriorID)
		ctrlAction:SetToolTip(strTemp)
		
		if g_CurSelExteriorID == nExteriorID then
			ctrlAction:SetPushed(1)
			bar:GetSubItem("NewExterior_Ride_SuperListItemActionTry"):Show()
			if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
				bar:GetSubItem("NewExterior_Ride_SuperListItemActionTry"):Hide()
			end
		else
			ctrlAction:SetPushed(0)
			bar:GetSubItem("NewExterior_Ride_SuperListItemActionTry"):Hide()
		end			

		if g_TargetExteriorID == nExteriorID then
			g_TargetExteriorIndex = index
		end

	end
	
	--非本门派蒙红 
	if nMyMenpai == nMenpai or nMenpai == -1 then			
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionMark"):Hide()
	else
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionMark"):Show()
	end	

	--解锁&限时标志
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 or DataPool:LuaFnIsExteriorRideActiveByRideCard(nExteriorID) == 1 then
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionLock"):Hide()
		if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
			local nLeftTime = Exterior:LuaFnGetExteriorLeftTime(g_ExteriorType, nExteriorID)
			if nLeftTime and nLeftTime < 0 then
				bar:GetSubItem("NewExterior_Ride_SuperListItemActionTime"):Hide()
			elseif nLeftTime and nLeftTime == 0 then
				bar:GetSubItem("NewExterior_Ride_SuperListItemActionTime"):Show()
			elseif nLeftTime and nLeftTime > 0 then
				bar:GetSubItem("NewExterior_Ride_SuperListItemActionTime"):Show()
			end
		else
			bar:GetSubItem("NewExterior_Ride_SuperListItemActionTime"):Show()
		end
	else
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionTime"):Hide()
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionLock"):Show()
	end	

	--使用中
	if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionDef"):Show()
	else
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionDef"):Hide()
	end
	
	--红点
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionTip"):Show()
	else
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionTip"):Hide()
	end
	
	--奢侈品
	if nLuxury == 1 or nLuxury == 2 then
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionLuxury"):Show()
	else
		bar:GetSubItem("NewExterior_Ride_SuperListItemActionLuxury"):Hide()
	end

end
--模型
function NewExterior_Ride_UpdateObj()
	
	NewExterior_Ride_FakeObject:SetFakeObject("")
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then				
		
		local nMountId = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "MountId")		
		Exterior:LuaFnUpdateExteriorRideAvatarMount(nMountId)
		
		if g_ViewMode == 0 then
			NewExterior_Ride_FakeObject:SetFakeObject("Exterior_Player")
			Exterior:LuaFnUpdateExteriorPlayerData()
			local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId,0)	
			FakeObj_SetCamera("Exterior_Player", g_CameraHeight, fHeight)
			FakeObj_SetCamera("Exterior_Player", g_CameraDistance, fDistance)	
		else
			NewExterior_Ride_FakeObject:SetFakeObject("My_Horse")
			Exterior:LuaFnUpdateExteriorPlayerData()
			local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId,1)
			FakeObj_SetCamera("My_Horse", g_CameraHeight, fHeight)
			FakeObj_SetCamera("My_Horse", g_CameraDistance, fDistance)
		end		
	else	
		g_ViewMode = 0
		Exterior:LuaFnUpdateExteriorRideAvatarMount(-1)
		NewExterior_Ride_FakeObject:SetFakeObject("Exterior_Player")
		Exterior:LuaFnUpdateExteriorPlayerData()
	
		local sex = Player:GetMySex()
		if sex == 0 or sex == 1 then 
			local fHeight = g_CameraPosition[sex].fHeight
			local fDistance = g_CameraPosition[sex].fDistance
			local fPitch = g_CameraPosition[sex].fPitch
			FakeObj_SetCamera("Exterior_Player", g_CameraHeight, fHeight)
			FakeObj_SetCamera("Exterior_Player", g_CameraDistance, fDistance)
			FakeObj_SetCamera("Exterior_Player", g_CameraPitch, fPitch)
		end			
	end
	
end

function NewExterior_Ride_UpdateOpBtn()
	
end

function NewExterior_Ride_MountHorse()
--	Player:UseSkillInLua_Const()
end

function NewExterior_Ride_MakeHyperlink(nExteriorID)
	local ret = Exterior:LuaFnExteriorRideItemClick(nExteriorID)
	if ret == 2 then
		PushDebugMessage("#{WGTJ_201222_132}")
	end
	return ret
end

function NewExterior_Ride_ItemClicked(nIndex)
	local nExteriorID 	= Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	local ret = NewExterior_Ride_MakeHyperlink(nExteriorID)
	if ret == 1 or ret == 2 then
		return
	end
	if g_CurSelExteriorID ~= nExteriorID then
		g_CurSelExteriorID = nExteriorID		
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", g_CurSelExteriorID)
		
		NewExterior_Ride_SetItemSelected(nIndex)
		
		NewExterior_Ride_UpdateObj()
	
		NewExterior_Ride_UpdateLeftBtn()
	
		NewExterior_Ride_RemoveTip(g_CurSelExteriorID)
		NewExterior_Ride_UpdateRedPoint()
	else
		local defExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", defExteriorID)
		NewExterior_Ride_Show()
	end	
end

function NewExterior_Ride_ItemRClicked(nIndex)
	local nExteriorID 	= Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	

	local iReverseItem = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "ReverseItem")
	
	if iReverseItem == nil or iReverseItem == 0 then
		return
	end
	
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) ~= 1 then
		PushDebugMessage("#{ZJGN_211105_64}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ReverseExteriorRideToItem")
		Set_XSCRIPT_ScriptID(999900)
		Set_XSCRIPT_Parameter(0, nExteriorID)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function NewExterior_Ride_ItemMouseMove(nIndex)

end

function NewExterior_Ride_UpdateRideCardList()
	
	local cid = 0
	local iActivedFlag = DataPool:LuaFnGetRideCardActivedFlag(cid)
	local left_time = DataPool:LuaFnGetRideCardLeftTime(cid)
	
	local count = DataPool:LuaFnGetRideCardHaveRideCount(cid)
	for i = 1, g_MaxRideCardHaveRide do
		NewExterior_Ride_RideCard_SetItem(cid, i, count)
	end
	
	if iActivedFlag ~= 1 then
		NewExterior_Ride_SuperList2Text:SetText("#{ZJYK_231019_04}")
	else
		if left_time == 0 then
			NewExterior_Ride_SuperList2Text:SetText("#{ZJYK_231019_03}")
		else
			if left_time >= 1440 then
				local left_day = math.floor(left_time / 1440)
				local strTemp = ScriptGlobal_Format("#{ZJYK_231019_27}", tostring(left_day))
				NewExterior_Ride_SuperList2Text:SetText(strTemp)
			elseif left_time > 60 then
				local left_hour = math.floor(left_time / 60)
				local strTemp = ScriptGlobal_Format("#{ZJYK_231019_28}", tostring(left_hour))
				NewExterior_Ride_SuperList2Text:SetText(strTemp)
			else
				local strTemp = ScriptGlobal_Format("#{ZJYK_231019_29}", tostring(left_time))
				NewExterior_Ride_SuperList2Text:SetText(strTemp)
			end			
		end
	end
end

function NewExterior_Ride_RideCard_SetItem(cid, index, max_count)
	
	if g_RideCardBarList[index] == nil then
		return
	end
	
	local bar = g_RideCardBarList[index]
	bar:Show()
	
	if index > max_count then
		local ctrlAction = bar:GetSubItem("NewExterior_Ride_SuperList2ItemAction")
		if ctrlAction ~= nil then
			ctrlAction:SetProperty("NormalImage", "")
			ctrlAction:SetProperty("HoverImage", "")
			ctrlAction:SetToolTip("")
		end
		
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionMark"):Hide()
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionTry"):Hide()
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionLock"):Hide()
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionTime"):Hide()
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionDef"):Hide()
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionTip"):Hide()
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionLuxury"):Hide()
		return
	end
	
	local nMyMenpai = Player:GetData("MEMPAI")
	local nExteriorID = DataPool:LuaFnGetExteriorRideIdFromRideCard(cid, index - 1)
	local strIcon 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Icon")
	local strName 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Name")
	local nQuality 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Quality")
	local strImage = GetIconFullName(strIcon)
	local nLuxury 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Luxury")
	local nMenpai 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Menpai")
	
	local ctrlAction = bar:GetSubItem("NewExterior_Ride_SuperList2ItemAction")
	if ctrlAction ~= nil then
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		local strTemp = Exterior:LuaFnGetRideCardRideToolTip(nExteriorID)
		ctrlAction:SetToolTip(strTemp)
	end
	
	--非本门派蒙红 
	if nMyMenpai == nMenpai or nMenpai == -1 then			
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionMark"):Hide()
	else
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionMark"):Show()
	end	
	
	bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionTry"):Hide()
	
	--解锁&限时标志
	local left_time = DataPool:LuaFnGetRideCardLeftTime(cid)
	if left_time == 0 then
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionLock"):Show()
	else
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionLock"):Hide()
	end
	
	bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionTime"):Hide()
	
	bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionDef"):Hide()
	bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionTip"):Hide()
	
	--奢侈品
	if nLuxury == 1 or nLuxury == 2 then
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionLuxury"):Show()
	else
		bar:GetSubItem("NewExterior_Ride_SuperList2ItemActionLuxury"):Hide()
	end
end

function NewExterior_Ride_UpdateRideCollectionList()

	local nMyMenpai = Player:GetData("MEMPAI")	
	DataPool:LuaFnInitRideCollectionList()	
	local count = DataPool:LuaFnGetRideCollectionListCount()
	
	local iActiveCollectionCount = 0
	
	for i = 1, g_MaxRideCollectionCount do
		NewExterior_Ride_RideCollection_SetItem(i, count)
	end
	
	for i = 1, count do
		local id, id_type = DataPool:LuaFnEnumRideCollectionFromList(i - 1)
		if id_type == 0 then
			if Exterior:LuaFnIsHaveExterior(g_ExteriorType, id) == 1 or DataPool:LuaFnIsExteriorRideActiveByRideCard(id) == 1 then
				iActiveCollectionCount = iActiveCollectionCount + 1
			end
		elseif id_type == 1 then
			local a = NewExterior_Ride_GetRideSeriesActiveCount(id)
			iActiveCollectionCount = iActiveCollectionCount + a
		end
	end
	
	local strTemp = ScriptGlobal_Format("#{ZJYK_231019_65}", tostring(iActiveCollectionCount), tostring(count))
	NewExterior_Ride_SuperListTit_Text2:SetText(strTemp)

	if g_NeedChangeCollectionListScrollSize == 1 then
		NewExterior_Ride_SuperList3_1:RefreshLayout()
		g_NeedChangeCollectionListScrollSize = 0
	end
	
	NewExterior_Ride_SuperList3Text_Desc:ClearAllElement()
	NewExterior_Ride_SuperList3Text_Desc:AddTextElement("#{ZJYK_231019_56}")
	local questTip = NewExterior_Ride_GetCollectionSeriesTip(iActiveCollectionCount)
	NewExterior_Ride_SuperList3Text_Desc:AddTextElement(questTip)
end

function NewExterior_Ride_SuperList3Tips_Clicked()
	PushEvent("OPEN_SWEEPPAGE_QUEST", "NewExterior_Ride_Collection_Help")
end

function NewExterior_Ride_RideCollection_SetItem(index, max_count)

	if g_RideCollectionBarList[index] == nil then
		return
	end
	
	if index > max_count then
		g_RideCollectionBarList[index]:Hide()
		return
	end

	local bar = g_RideCollectionBarList[index]
	bar:Show()
	
	local nMyMenpai = Player:GetData("MEMPAI")
	local id, id_type = DataPool:LuaFnEnumRideCollectionFromList(index - 1)

	local nExteriorID = 0
	if id_type == 0 then
		nExteriorID = id
	elseif id_type == 1 then
		nExteriorID = DataPool:LuaFnEnumRideSeriesExteriorRideId(id, 0)
		for i = 1, 10 do
			local ride_id = DataPool:LuaFnEnumRideSeriesExteriorRideId(id, i - 1)
			if ride_id > 0 then
				if Exterior:LuaFnIsHaveExterior(g_ExteriorType, ride_id) == 1 or DataPool:LuaFnIsExteriorRideActiveByRideCard(ride_id) == 1 then
					nExteriorID = ride_id
					break
				end
			end
		end
	end
	
	local strIcon 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Icon")
	local strName 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Name")
	local nQuality 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Quality")
	local strImage = GetIconFullName(strIcon)
	local nLuxury 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Luxury")
	local nMenpai 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Menpai")
	
	local ctrlAction = bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1")
	if ctrlAction ~= nil then
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		if id_type == 0 then
			local strTemp = Exterior:LuaFnGetRideToolTip(nExteriorID)
			ctrlAction:SetToolTip(strTemp)
		elseif id_type == 1 then
			local series_name = DataPool:LuaFnGetRideSeriesInfo(id, "NAME")
			local strTemp = ScriptGlobal_Format("#{ZJYK_231019_64}", tostring(series_name))
			for i = 1, 10 do
				local ride_id = DataPool:LuaFnEnumRideSeriesExteriorRideId(id, i - 1)
				if tonumber(ride_id) ~= nil and tonumber(ride_id) > 0 then
					local ride_name	= Exterior:LuaFnGetExteriorRideInfo(ride_id, "Name")
					if Exterior:LuaFnIsHaveExterior(g_ExteriorType, ride_id) == 1 or DataPool:LuaFnIsExteriorRideActiveByRideCard(ride_id) == 1 then
						strTemp = strTemp.."#r#G"..tostring(ride_name)
					else
						strTemp = strTemp.."#r#c808080"..tostring(ride_name)
					end
				end
			end			
			ctrlAction:SetToolTip(strTemp)
		end
	end
	
	--非本门派蒙红 
	if nMyMenpai == nMenpai or nMenpai == -1 then			
		bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Mark"):Hide()
	else
		bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Mark"):Show()
	end	
	
	--解锁&限时标志
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 or DataPool:LuaFnIsExteriorRideActiveByRideCard(nExteriorID) == 1 then
		bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Lock"):Hide()
		if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
			local nLeftTime = Exterior:LuaFnGetExteriorLeftTime(g_ExteriorType, nExteriorID)
			if nLeftTime and nLeftTime < 0 then
				bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Time"):Hide()
			elseif nLeftTime and nLeftTime == 0 then
				bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Time"):Show()
			elseif nLeftTime and nLeftTime > 0 then
				bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Time"):Show()
			end
		else
			bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Time"):Show()
		end
	else
		bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Time"):Hide()
		bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Lock"):Show()
	end

	--奢侈品
	if nLuxury == 1 or nLuxury == 2 then
		bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Luxury"):Show()
	else
		bar:GetSubItem("NewExterior_Ride_SuperList3_1_ItemAction1Luxury"):Hide()
	end
end

function NewExterior_Ride_GetRideSeriesActiveCount(cid)
	local count_type = DataPool:LuaFnGetRideSeriesInfo(cid, "COUNTTYPE")
	local ride_count = DataPool:LuaFnGetRideSeriesInfo(cid, "RIDECOUNT")
	local min_req = DataPool:LuaFnGetRideSeriesInfo(cid, "MINIREQ")
	local have_count = 0
	for index = 1, 9 do
		if index <= ride_count then
			local nExteriorID = DataPool:LuaFnEnumRideSeriesExteriorRideId(cid, index - 1)
			if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 or DataPool:LuaFnIsExteriorRideActiveByRideCard(nExteriorID) == 1 then
				have_count = have_count + 1
			end
		end
	end
	
	if count_type == 0 then
		if have_count >= min_req then
			return 1
		end
	elseif count_type == 1 then
		return have_count
	end
	return 0
end

function NewExterior_Ride_GetCollectionSeriesTip(active_count)

	local g_TipEffectString = {"#{ZJYK_231019_35}", "#{ZJYK_231019_36}"}
	local g_TipEffectString_Lock = {"#{ZJYK_231019_57}", "#{ZJYK_231019_58}"}
	
	local questTip = ""
	local bFirstLine = 1
	for i = 1, 4 do
		local effect_type, effect_value, rep_count = DataPool:LuaFnEnumRideCollectionEffect(0, i - 1)
		if tonumber(effect_type) ~= nil and tonumber(effect_value) ~= nil and tonumber(rep_count) ~= nil then
			if active_count >= rep_count then
				if g_TipEffectString[effect_type] ~= nil then
					local strTemp = ScriptGlobal_Format(g_TipEffectString[effect_type], tostring(rep_count), tostring(effect_value))
					if bFirstLine == 1 then
						bFirstLine = 0
						questTip = questTip..strTemp
					else
						questTip = questTip.."#r"..strTemp
					end
				end
			else
				if g_TipEffectString_Lock[effect_type] ~= nil then
					local strTemp = ScriptGlobal_Format(g_TipEffectString_Lock[effect_type], tostring(rep_count), tostring(effect_value))
					if bFirstLine == 1 then
						bFirstLine = 0
						questTip = questTip..strTemp
					else
						questTip = questTip.."#r"..strTemp
					end
				end
			end
		end		
	end
	
	return questTip
end

function NewExterior_Ride_OpenRidePage()
	if g_CurSubPage ~= 0 then
		g_CurSubPage = 0
		NewExterior_Ride_ShowSubPage()
		NewExterior_Ride_SuperListTit_Text:SetText("#{WGTJ_201222_177}")
	end
end

function NewExterior_Ride_OpenCardPage()
	if g_CurSubPage ~= 1 then
		g_CurSubPage = 1
		NewExterior_Ride_ShowSubPage()
		NewExterior_Ride_SuperListTit_Text:SetText("#{WGTJ_201222_177}")
	end
end

function NewExterior_Ride_OpenCollectPage()
	if g_CurSubPage ~= 2 then
		g_CurSubPage = 2
		NewExterior_Ride_ShowSubPage()
		NewExterior_Ride_SuperListTit_Text:SetText("#{ZJYK_231019_32}")
	end
end

function NewExterior_Ride_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Ride_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("NewExterior_Ride_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("NewExterior_Ride_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("NewExterior_Ride_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function NewExterior_Ride_TryExterior()
	if Exterior:LuaFnIsHaveExteriorChange() ~= 1 then
		PushDebugMessage("#{WGTJ_201222_72}")
		return
	end
	
	Exterior:LuaFnSaveExteriorAllChange(1)
end

function NewExterior_Ride_TakeOffRide()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(3)
	if defExteriorID == 0 then
		g_CurSelExteriorID = 0
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", 0)
		--列表
		NewExterior_Ride_UpdateList()
		--左侧
		NewExterior_Ride_UpdateLeftBtn()
		--模型
		NewExterior_Ride_UpdateObj()
	else
		Exterior:LuaFnSetExteriorInUse(3, 0, 0)
	end
end

function NewExterior_Ride_TakeOffPoss()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(4)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(4)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_Ride_UpdateLeftBtn()
		NewExterior_Ride_UpdateObj()
	else
		Exterior:LuaFnSetExteriorInUse(4, 0, 0)
	end
end

function NewExterior_Ride_TakeOffWeapon()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorWeaponInUse()
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(5)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_Ride_UpdateLeftBtn()
		NewExterior_Ride_UpdateObj()
	else
		Exterior:LuaFnSetExteriorWeaponInUse(0, 0)
	end
end

function NewExterior_Ride_ReviewClick()

	if Lua_IsInBianShen() == 1 then
		PushDebugMessage("#{ZJGN_211105_06}")
		return
	end

	if IsInStall() == 1 then
		PushDebugMessage("#{ZJGN_211105_07}")
		return
	end	

	if IsIdleLogic() ~= 1 and IsMoveLogic() ~= 1 then
		SetNotifyTip("#{ZJGN_211105_08}")
		return
	end

	MouseCmd_ShopFittingSet()
	PushDebugMessage("#{ZJGN_211105_09}")
	
end

function NewExterior_Ride_RemovePreview()
	if Exterior:LuaFnIsHaveExteriorChange() == 1 then
		Exterior:LuaFnRemovePlayerExteriorFitting()
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESET")
		Exterior:LuaFnInitCurrentExteriorSet(0)
		NewExterior_Ride_Show()
		PushDebugMessage("#{WGTJ_201222_98}")
	else
		PushDebugMessage("#{WGTJ_201222_76}")
	end
end

function NewExterior_Ride_CloseClick()
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	
	NewExterior_Ride_SavePosition()
	this:Hide()
end

function NewExterior_Ride_OnHidden()

	if IsWindowShow("Profile_Save") then
		CloseWindow("Profile_Save", true)
	end
	
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_HairStyle") 
		or IsWindowShow("NewExterior_PlayerFrame")
		or IsWindowShow("NewExterior_PetSoul") 
		or IsWindowShow("NewExterior_Weapon")
		or IsWindowShow("NewExterior_Widget")
		or IsWindowShow("NewExterior_Headdress") then
	else	
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	end	
	Exterior:LuaFnUpdateExteriorRideAvatarMount(-1)
	NewExterior_Ride_CleanUp()
end

function NewExterior_Ride_CleanUp()
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Ride_SuperListItemAction")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
		end
	end
	NewExterior_Ride_FakeObject:SetFakeObject("")
	
	NewExterior_Ride_CleanUp_LeftButton()
	
	SetDefaultMouse()
	
end

function NewExterior_Ride_CleanUp_LeftButton()

	NewExterior_Ride_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		NewExterior_Ride_FaceStyle_LeftBtn,
		NewExterior_Ride_HairStyle_LeftBtn,
		NewExterior_Ride_PlayerFrame_LeftBtn,
		NewExterior_Ride_Ride_LeftBtn,	
		NewExterior_Ride_PetSoul_LeftBtn,
		NewExterior_Ride_Weapon_LeftBtn,
		NewExterior_Ride_Widget_LeftBtn,
		NewExterior_Ride_Headdress_LeftBtn,
	}
	
	for i in pairs(ctrl_list) do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_Ride_Dress_LeftBtnLuxury:Hide()
	NewExterior_Ride_Dress_ActionImg:Hide()
	NewExterior_Ride_FaceStyle_ActionImg:Hide()
	NewExterior_Ride_HairStyle_ActionImg:Hide()
	NewExterior_Ride_PlayerFrame_ActionImg:Hide()
	NewExterior_Ride_Ride_ActionImg:Hide()
	NewExterior_Ride_PetSoul_ActionImg:Hide()
	NewExterior_Ride_Weapon_ActionImg:Hide()
	NewExterior_Ride_Widget_ActionImg:Hide()
	NewExterior_Ride_Headdress_ActionImg:Hide()

	NewExterior_Ride_Dress_LockImg:Hide()
	NewExterior_Ride_FaceStyle_LockImg:Hide()
	NewExterior_Ride_HairStyle_LockImg:Hide()
	NewExterior_Ride_PlayerFrame_LockImg:Hide()
	NewExterior_Ride_Ride_LockImg:Hide()
	NewExterior_Ride_PetSoul_LockImg:Hide()
	NewExterior_Ride_Weapon_LockImg:Hide()
	NewExterior_Ride_Widget_LockImg:Hide()
	NewExterior_Ride_Headdress_LockImg:Hide()
end

function NewExterior_Ride_FakeObject_TurnLeft(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		if g_ViewMode == 0 then
			NewExterior_Ride_FakeObject:RotateBegin(-0.3)
		else
			NewExterior_Ride_FakeObject:RotateBegin(-0.3)
		end
	else
		NewExterior_Ride_FakeObject:RotateEnd()
	end
end

function NewExterior_Ride_FakeObject_TurnRight(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		if g_ViewMode == 0 then
			NewExterior_Ride_FakeObject:RotateBegin(0.3)
		else
			NewExterior_Ride_FakeObject:RotateBegin(0.3)
		end		
	else
		NewExterior_Ride_FakeObject:RotateEnd()
	end
end
--缩小
function NewExterior_Ride_ZoomOut()
--	if g_Distance == 1 then
--		return
--	end
	
--	g_Distance = g_Distance - 1	

end
--放大
function NewExterior_Ride_ZoomIn()
--	if g_Distance == g_Distance_Max then
--		return
--	end
	
--	g_Distance = g_Distance + 1	
end

function NewExterior_Ride_SwithViewMode()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID > 0 then
		if g_ViewMode == 0 then
			g_ViewMode = 1
		else
			g_ViewMode = 0
		end	
		NewExterior_Ride_UpdateObj()
	end	
end

function NewExterior_Ride_UpdateCheckButton()
--	NewExterior_Ride_ButtonHuanwu:SetCheck(0)
--	NewExterior_Ride_ButtonZhuangrong:SetCheck(0)
--	NewExterior_Ride_ButtonFuti:SetCheck(0)
--	NewExterior_Ride_ButtonZuoqi:SetCheck(1)
end

--右键取下时装
function NewExterior_Ride_ActionToDressBox()
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		cacheExteriorID = 0
		cacheExteriorIdx = -1
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", cacheExteriorID, cacheExteriorIdx)			
		NewExterior_Ride_Show()
		--return
	end
	Exterior:LuaFnUnUseExteriorFashion(1)
end

--时装
function NewExterior_Ride_OpenFashion()
	NewExterior_Ride_SavePosition()
	PushEvent("OPEN_EXTERIOR_FASHION", 1, 0)
end

--坐骑
function NewExterior_Ride_OpenRide()
	--NewExterior_Ride_SavePosition()
	--Exterior:LuaFnAskOpenExterior(0)
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	Exterior:LuaFnExteriorRideItemClick(cacheExteriorID)
end

--发型
function NewExterior_Ride_OpenHair()
	NewExterior_Ride_SavePosition()	
	Exterior:LuaFnAskOpenExterior(1)
end

--脸型
function NewExterior_Ride_OpenFace()
	NewExterior_Ride_SavePosition()	
	Exterior:LuaFnAskOpenExterior(0)
end

--头像
function NewExterior_Ride_OpenPortrait()
	NewExterior_Ride_SavePosition()	
	Exterior:LuaFnAskOpenExterior(2)
end

--幻武
function NewExterior_Ride_OpenWeapon()
	NewExterior_Ride_SavePosition()
	Exterior:LuaFnAskOpenExteriorWeapon()
end

--融魂外观
function NewExterior_Ride_OpenPoss()
	NewExterior_Ride_SavePosition()	
	Exterior:LuaFnAskOpenExterior(4)
end


function NewExterior_Ride_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	--CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_Widget", true)
	CloseWindow("NewExterior_Headdress", true)
	CloseWindow("NewExterior_Headdress", true)
end

function NewExterior_Ride_SavePosition()
	Variable:SetVariable("ExteriorUnionPos", NewExterior_Ride_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_Ride_SetPosition()
	
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_Ride_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end

end

function NewExterior_Ride_RemoveTip(nExteriorID)
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		Exterior:LuaFnRemoveExteriorTip(g_ExteriorType, nExteriorID)
		for i = 1, g_MaxBarNum do
			if g_BarList[i] then
				local nID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, i - 1)
				if Exterior:LuaFnGetExteriorTip(g_ExteriorType, nID) == 1 then
					g_BarList[i]:GetSubItem("NewExterior_Ride_SuperListItemActionTip"):Show()
				else
					g_BarList[i]:GetSubItem("NewExterior_Ride_SuperListItemActionTip"):Hide()
				end
			end
		end
	--	NewExterior_Ride_UpdateCheckButton()		
	end
end

function NewExterior_Ride_UpdateRedPoint()

	NewExterior_Ride_Dress_Tip:Hide()
	
	if Exterior:LuaFnIsHaveExteriorShowTip(3) == 1 then
		NewExterior_Ride_Ride_Tip:Show()
	else
		NewExterior_Ride_Ride_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(0) == 1 then
		NewExterior_Ride_FaceStyle_Tip:Show()
	else
		NewExterior_Ride_FaceStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(1) == 1 or Exterior:LuaFnIsHaveHairColorShowTip() == 1 then
		NewExterior_Ride_HairStyle_Tip:Show()
	else
		NewExterior_Ride_HairStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(2) == 1 then
		NewExterior_Ride_PlayerFrame_Tip:Show()
	else
		NewExterior_Ride_PlayerFrame_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(4) == 1 then
		NewExterior_Ride_PetSoul_Tip:Show()
	else
		NewExterior_Ride_PetSoul_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorWeaponShowTip() == 1 then
		NewExterior_Ride_Weapon_Tip:Show()
	else
		NewExterior_Ride_Weapon_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(0) == 1 then
		NewExterior_Ride_Widget_Tip:Show()
	else
		NewExterior_Ride_Widget_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(1) == 1 then
		NewExterior_Ride_Headdress_Tip:Show()
	else
		NewExterior_Ride_Headdress_Tip:Hide()
	end
end

function NewExterior_Ride_ShowFashionWeaponCheckButton()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	-- NewExterior_Ride_Dress_Type:SetCheck(IsDisplay)
end

function NewExterior_Ride_FashionDisplay()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	if IsDisplay == 1 then
		-- NewExterior_Ride_Dress_Type:SetCheck(0)
		SystemSetup:Set_Display_Dress(0)
	else
		-- NewExterior_Ride_Dress_Type:SetCheck(1)
		SystemSetup:Set_Display_Dress(1)
	end	
end

function NewExterior_Ride_ShowDressShareButton()
	
	local player_level = Player:GetData("LEVEL")
	if player_level >= 15 then
		NewExterior_Ride_SaveChangeBtn:Hide()
		NewExterior_Ride_ShareBtn:Show()
	else
		NewExterior_Ride_SaveChangeBtn:Hide()
		NewExterior_Ride_ShareBtn:Hide()
	end
	
end

function NewExterior_Ride_Share_Clicked()
	local ret = Exterior:LuaFnExteriorPlayerShareClick(0)
	return ret	
end

function NewExterior_Ride_SaveChange_Clicked()	
	local ret = Exterior:LuaFnExteriorPlayerOpenSharePlan()
	return ret	
end

function NewExterior_Ride_ShowSubPage()
	if g_CurSubPage == 0 then
		NewExterior_Ride_SuperListMineBtn:SetCheck(1)
		NewExterior_Ride_SuperListOurBtn:SetCheck(0)
		NewExterior_Ride_SuperListCollectBtn:SetCheck(0)
		--坐骑
		NewExterior_Ride_SuperList:Show()
		--月卡
		NewExterior_Ride_SuperList2:Hide()
		NewExterior_Ride_SuperList2TextBK:Hide()
		--典藏
		NewExterior_Ride_SuperList3_1_Frame:Hide()
		NewExterior_Ride_SuperList3Text_Desc:Hide()
		NewExterior_Ride_SuperList3Title:Hide()
		NewExterior_Ride_SuperListTit_Text2:Hide()
	elseif g_CurSubPage == 1 then
		NewExterior_Ride_SuperListMineBtn:SetCheck(0)
		NewExterior_Ride_SuperListOurBtn:SetCheck(1)
		NewExterior_Ride_SuperListCollectBtn:SetCheck(0)
		--坐骑
		NewExterior_Ride_SuperList:Hide()
		--月卡
		NewExterior_Ride_SuperList2:Show()
		NewExterior_Ride_SuperList2TextBK:Show()
		--典藏
		NewExterior_Ride_SuperList3_1_Frame:Hide()
		NewExterior_Ride_SuperList3Text_Desc:Hide()
		NewExterior_Ride_SuperList3Title:Hide()
		NewExterior_Ride_SuperListTit_Text2:Hide()
	elseif g_CurSubPage == 2 then
		NewExterior_Ride_SuperListMineBtn:SetCheck(0)
		NewExterior_Ride_SuperListOurBtn:SetCheck(0)
		NewExterior_Ride_SuperListCollectBtn:SetCheck(1)
		--坐骑
		NewExterior_Ride_SuperList:Hide()
		--月卡
		NewExterior_Ride_SuperList2:Hide()
		NewExterior_Ride_SuperList2TextBK:Hide()
		--典藏
		NewExterior_Ride_SuperList3_1_Frame:Show()
		NewExterior_Ride_SuperList3Text_Desc:Show()
		NewExterior_Ride_SuperList3Title:Show()
		NewExterior_Ride_SuperListTit_Text2:Show()
	end
end

-- 背挂
function NewExterior_Ride_OpenOrnamentsBack()
	NewExterior_Ride_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(0)
end

function NewExterior_Ride_ActionToOrnamentsBack()
	local useID = OrnamentsScript:GetOrnamentsUseID(0)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(0)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSBACK", 0, 0, 0, 0)
	NewExterior_Ride_UpdateLeftBtn()
	NewExterior_Ride_UpdateObj()
end

function NewExterior_Ride_OpenOrnamentsHead()
	NewExterior_Ride_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(1)
end

function NewExterior_Ride_ActionToOrnamentsHead()
	local useID = OrnamentsScript:GetOrnamentsUseID(1)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(1)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", 0, 0, 0, 0)
	NewExterior_Ride_UpdateLeftBtn()
	NewExterior_Ride_UpdateObj()
end
--!!!reloadscript =NewExterior_Ride