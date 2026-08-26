--!!!reloadscript =NewExterior_HairStyle
local g_NewExterior_HairStyle_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 0;
local g_TargetExteriorIndex = 0		--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID

local g_CurSelExteriorID = 0			--当前选择的外观ID，从1开始
local g_CurSelColorIndex = 0			--当前选中的颜色
local g_CurSelColorValue = 0			--当前选中的颜色

local g_NeedChangeScrollSize = 1

local g_Distance = 1
local g_Distance_Ori = 4
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 1 --发型
local g_MaxBarNum = 0
local g_BarList = {}
local g_ColorList = {}
local g_MaxColor = 20

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

local g_PetSoulLevelLimit = 85
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
function NewExterior_HairStyle_PreLoad()
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
	
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("UPDATE_EXTERIOR_FASHION", false)
	
	this:RegisterEvent("EXERIOR_SAVEALL_RET", false)
	
	this:RegisterEvent("OPEN_STALL_SALE",false)
	this:RegisterEvent("PROGRESSBAR_SHOW",false)
	this:RegisterEvent("MODELID_CHANGE",false)
	
	this:RegisterEvent("UNIT_LEVEL", false)
	this:RegisterEvent("OPEN_DRESSPREVIEW", false)
	this:RegisterEvent("UPDATE_RIDE_CARD_INFO", false)	
	this:RegisterEvent("ORNAMENTS_DISPLAYUPDATE", false)
end

--=========
--OnLoad
--=========
function NewExterior_HairStyle_OnLoad()
	g_NewExterior_HairStyle_UnifiedPosition = NewExterior_HairStyle_Frame:GetProperty("UnifiedPosition")
end
--=========
--OnEvent
--=========
function NewExterior_HairStyle_OnEvent(event)

	if event == "OPEN_EXTERIOR" then
		if tonumber(arg0) == g_ExteriorType then
			if this:IsVisible() then
				if tonumber(arg1) == 0 then
					NewExterior_HairStyle_SavePosition()
					this:Hide()
				end
			else
				NewExterior_HairStyle_SetPosition()
				NewExterior_HairStyle_CloseSameGroupWindow()
				this:Show()
				NewExterior_HairStyle_Show()
			end
		end
		return
	end
	
	if event == "OPEN_STALL_SALE"			-- 开始摆摊，还原试穿
		or event == "PROGRESSBAR_SHOW"		-- 读进度条中，还原试穿
		or event == "MODELID_CHANGE" 		-- 变身 关闭界面
		then
		NewExterior_HairStyle_CloseClick()
		return
	end
	
	if event == "EXERIOR_SAVEALL_RET" then
		if not this:IsVisible() then
			return
		end

		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESETEX")
		Exterior:LuaFnInitCurrentExteriorSetExceptFashion(0)
		NewExterior_HairStyle_Show()
	end
	
	if event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if not this:IsVisible() then
			return
		end

		if tonumber(arg0) == g_ExteriorType then
			NewExterior_HairStyle_Show()
		else
			--左侧
			NewExterior_HairStyle_UpdateLeftBtn()
			NewExterior_HairStyle_UpdateRedPoint()
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
			NewExterior_HairStyle_Show()
		else
			--左侧
			NewExterior_HairStyle_UpdateLeftBtn()
			NewExterior_HairStyle_UpdateRedPoint()
			--更新一下模型
			Exterior:LuaFnUpdateExteriorPlayerData()
		end
		return
	end
	
	if event == "EXTERIOR_POSS_VISUAL_INDEX" or event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		if not this:IsVisible() then
			return
		end

		--左侧
		NewExterior_HairStyle_UpdateLeftBtn()
		NewExterior_HairStyle_UpdateRedPoint()
		--更新一下模型
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
	
	if event == "EXTERIOR_HAIR_COLOR_INDEX" then
		if not this:IsVisible() then
			return
		end

		NewExterior_HairStyle_Show()
		return
	end
	
	if event == "UPDATE_EXTERIOR_FASHION" then
		if not this:IsVisible() then
			return
		end

		if tonumber(arg0) == 1 then
			--左侧
			NewExterior_HairStyle_UpdateLeftBtn()
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
		NewExterior_HairStyle_Frame:SetProperty("UnifiedPosition", g_NewExterior_HairStyle_UnifiedPosition)
	end

	if event == "UNIT_LEVEL" and arg0 == "player" then
		if this:IsVisible() then
			NewExterior_HairStyle_UpdateLeftBtn()
		end
	end
	
	if event == "UPDATE_RIDE_CARD_INFO" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_HairStyle_UpdateLeftBtn()
		NewExterior_HairStyle_UpdateRedPoint()
		--更新一下模型
		Exterior:LuaFnUpdateExteriorPlayerData()
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

function NewExterior_HairStyle_InitList()
	
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetExteriorMaxCount(g_ExteriorType)
		
		for i = 1, g_MaxBarNum do
			local bar = NewExterior_HairStyle_SuperList:AddChild("NewExterior_HairStyle_SuperListItem")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("NewExterior_HairStyle_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("NewExterior_HairStyle_ItemClicked(%d)", i))
			bar:GetSubItem("NewExterior_HairStyle_SuperListItemAction"):SetEvent("MouseMove", string.format("NewExterior_HairStyle_ItemMouseMove(%d)", i))
			bar:GetSubItem("NewExterior_HairStyle_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("NewExterior_HairStyle_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end
		
		for i = 1, g_MaxColor do
			local bar = NewExterior_HairStyle_ColorList:AddChild("NewExterior_HairStyle_ColorListItem")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_ColorList[i] = bar	
			bar:GetSubItem("NewExterior_HairStyle_ColorListItemAction"):SetEvent("MouseLButtonDown", string.format("NewExterior_HairStyle_ColorClicked(%d)", i))
			bar:GetSubItem("NewExterior_HairStyle_ColorListItemAction"):SetEvent("MouseMove", string.format("NewExterior_HairStyle_ColorMouseMove(%d)", i))
			bar:GetSubItem("NewExterior_HairStyle_ColorListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("NewExterior_HairStyle_ColorListItemAction"):SetProperty("UseDefaultTooltip", "True")
			
			--bar:GetSubItem("NewExterior_HairStyle_ColorListColor"):SetEvent("MouseLButtonDown", string.format("NewExterior_HairStyle_ColorClicked(%d)", i))
			bar:GetSubItem("NewExterior_HairStyle_ColorListColor"):SetImageColor("FFFFFFFF")
		end
		g_InitList = 1
	end
end

function NewExterior_HairStyle_Show()
	
	g_Distance = g_Distance_Ori
	g_NeedChangeScrollSize = 1
				
	EXTERIORFILTTING_TOTALKIND = Exterior:LuaFnGetExteriorPlayerFittingCount()
	
	NewExterior_HairStyle_InitList()
	
	NewExterior_HairStyle_CleanUp()
	
	NewExterior_HairStyle_FakeObject:SetFakeObject("Exterior_Player")
	Exterior:LuaFnShowExteriorPlayerPetSoulEffect(0)
	Exterior:LuaFnUpdateExteriorPlayerData()
	
	g_CurSelExteriorID = 0
	
	local cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
	if cacheExteriorID > 0 then
		g_TargetExteriorID = cacheExteriorID
		g_CurSelExteriorID = cacheExteriorID
		g_CurSelColorValue = cacheColorIndex
	end
	
	--列表
	NewExterior_HairStyle_UpdateList()
	
	NewExterior_HairStyle_UpdateColorList()
	--左侧
	NewExterior_HairStyle_UpdateLeftBtn()
	
	NewExterior_HairStyle_UpdateObj()

	NewExterior_HairStyle_RemoveTip(g_CurSelExteriorID)
	NewExterior_HairStyle_RemoveColorTip(g_CurSelColorIndex)
	NewExterior_HairStyle_UpdateRedPoint()

	NewExterior_HairStyle_ShowFashionWeaponCheckButton()
	
	NewExterior_HairStyle_ShowDressShareButton()
end

function NewExterior_HairStyle_UpdateLeftBtn()
	
	NewExterior_HairStyle_CleanUp_LeftButton()
	
	local sex = Player:GetMySex()
	
	--时装
	local nFashionId = -1
	NewExterior_HairStyle_Dress_LeftBtn:SetActionItem(-1)
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, cacheExteriorIdx)
		--local theAction = Exterior:LuaFnEnumExteriorFashionAction(1, cacheExteriorID, 0)
		if theAction:GetID() ~= 0 then
			NewExterior_HairStyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
			NewExterior_HairStyle_Dress_ActionImg:Show()
			
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 and nCurFashionIdx == cacheExteriorIdx then
				NewExterior_HairStyle_Dress_ActionImg:Hide()
			end
				
			nFashionId = cacheExteriorID
		end
	else
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
		if cacheExteriorIdx ~= nil and cacheExteriorIdx >= 0 then
			local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(cacheExteriorIdx)
			if theAction:GetID() ~= 0 then
				NewExterior_HairStyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
				NewExterior_HairStyle_Dress_ActionImg:Show()
				
				local nCurFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 and nCurFashionIdx == cacheExteriorIdx then
						NewExterior_HairStyle_Dress_ActionImg:Hide()
				end
				
				nFashionId = cacheExteriorID
			end
		else
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 then
				local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, nCurFashionIdx)
				if theAction:GetID() ~= 0 then
					NewExterior_HairStyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
						
					nFashionId = nCurFashionId
				end
			else
				local nCurFashionIdx, nCurFashionId = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 then
					local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(nCurFashionIdx)
					if theAction:GetID() ~= 0 then
						NewExterior_HairStyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
						
						nFashionId = nCurFashionId
					end
				end
			end			
		end		
	end
		
	NewExterior_HairStyle_Dress_LeftBtnLuxury:Hide()
	if nFashionId ~= -1 then	
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nFashionId, "Number")
		if nFashionNumber ~= nil and nFashionNumber > 0 then
			NewExterior_HairStyle_Dress_LeftBtnLuxury:Show()
		end
	end
	
	--坐骑
	local edType = 3
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		NewExterior_HairStyle_Ride_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_HairStyle_Ride_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 and DataPool:LuaFnIsExteriorRideActiveByRideCard(cacheExteriorID) ~= 1 then
			NewExterior_HairStyle_Ride_LockImg:Show()
		end
	end

	--脸型
	edType = 0
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_82}", strName)
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_HairStyle_FaceStyle_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_HairStyle_FaceStyle_LockImg:Show()
		end
	end

	--发型
	edType = 1
	cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)

		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_81}", strName)		
		NewExterior_HairStyle_HairStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_HairStyle_HairStyle_ActionImg:Show()
		else
			if Exterior:LuaFnGetExteriorHairColorIndex() ~= cacheColorIndex then
			NewExterior_HairStyle_HairStyle_ActionImg:Show()
		end
	end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_HairStyle_HairStyle_LockImg:Show()
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
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_79}", strName)
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetToolTip(strTemp)
		strHeadTip = strTemp
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_HairStyle_PlayerFrame_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_HairStyle_PlayerFrame_LockImg:Show()
		end
	end

	--幻武
	local cacheWeaponLevel = 0
	cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{HSWQ_20220607_02}", strName, tostring(cacheWeaponLevel + 1))
		NewExterior_HairStyle_Weapon_LeftBtn:SetToolTip(strTemp)
	
		--试穿
		if Exterior:LuaFnGetExteriorWeaponInUse() ~= cacheExteriorID or cacheWeaponLevel ~= Exterior:LuaFnGetExteriorWeaponLevel() then
			NewExterior_HairStyle_Weapon_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExteriorWeapon(cacheExteriorID) ~= 1 then
			NewExterior_HairStyle_Weapon_LockImg:Show()
		end
	end

	--融魂外观
	local player_level = Player:GetData("LEVEL")
	if player_level < g_PetSoulLevelLimit then
		NewExterior_HairStyle_PetSoul_LeftCheckBtn:Hide()
	else
		NewExterior_HairStyle_PetSoul_LeftCheckBtn:Show()
	end

	edType = 4
	local strPossTip = ""
	local cachePossVisualIndex = 0
	cacheExteriorID, cachePossVisualIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Name", sex)
		local strIcon = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{SHRH_20220427_64}", strName)
		NewExterior_HairStyle_PetSoul_LeftBtn:SetToolTip(strTemp)
		
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID or cachePossVisualIndex ~= Exterior:LuaFnGetExteriorPossVisualIndex() then
			NewExterior_HairStyle_PetSoul_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_HairStyle_PetSoul_LockImg:Show()
		end
	end

	-- 背饰
	local edOrnamentsType, cacheExteriorX, cacheExteriorY, cacheExteriorZ = 0,0,0,0
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsBack")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_HairStyle_Widget_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_Widget_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_HairStyle_Widget_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_HairStyle_Widget_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_HairStyle_Widget_LockImg:Show()
		end
	end

	-- 头饰
	edOrnamentsType = 1
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsHead")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_HairStyle_Headdress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_Headdress_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_HairStyle_Headdress_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_HairStyle_Headdress_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_HairStyle_Headdress_LockImg:Show()
		end
	end
end

function NewExterior_HairStyle_UpdateList()
	
	NewExterior_HairStyle_UpdateCheckButton()
	NewExterior_HairStyle_UpdateRedPoint()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType)
	local count = Exterior:LuaFnGetExteriorListCount(g_ExteriorType, 0)
	
	for i = 1, g_MaxBarNum do	
		NewExterior_HairStyle_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		NewExterior_HairStyle_SuperList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	if g_TargetExteriorIndex ~= 0 then
		NewExterior_HairStyle_SuperList:SetScrollPosition4Index(g_TargetExteriorIndex - 1)
		g_TargetExteriorID = 0
		g_TargetExteriorIndex = 0
	else
		NewExterior_HairStyle_SuperList:SetScrollPosition4Index(0)
	end	
end

function NewExterior_HairStyle_SetItem(index, max_count)
	
	if g_BarList[index] == nil then
		return
	end
	
	if index > max_count then
		g_BarList[index]:Hide()
		return
	end
	
	local bar = g_BarList[index]
	bar:Show()
	
	local sex = Player:GetMySex()
	local nMyMenpai = Player:GetData("MEMPAI")
	
	local nExteriorID 	= Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, index - 1)
	local strName 	= Exterior:LuaFnGetExteriorHairInfo(nExteriorID,"Name", sex)
	local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(nExteriorID,"Icon", sex)
	local strImage = GetIconFullName(strIcon)
	local nMenpai 	= Exterior:LuaFnGetExteriorHairInfo(nExteriorID,"Menpai", sex)
	
	local ctrlAction = bar:GetSubItem("NewExterior_HairStyle_SuperListItemAction")
	if ctrlAction ~= nil then
	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
	
		local strTemp = Exterior:LuaFnGetExteriorHairInfo(nExteriorID, "ToolTips", sex) --ScriptGlobal_Format("#{WGTJ_201222_81}", strName)		
		ctrlAction:SetToolTip(strTemp)
	
		if g_CurSelExteriorID == nExteriorID then
			ctrlAction:SetPushed(1)
			bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionTry"):Show()
			if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
				bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionTry"):Hide()
			end
		else
			ctrlAction:SetPushed(0)
			bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionTry"):Hide()
		end
		
		if g_TargetExteriorID == nExteriorID then
			g_TargetExteriorIndex = index
		end
	end
	
	--非本门派蒙红 
	if nMyMenpai == nMenpai or nMenpai == -1 then			
		bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionMark"):Hide()
	else
		bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionMark"):Show()
	end	

	bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionTime"):Hide()
	--锁
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then			
		bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionLock"):Hide()
	else
		bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionLock"):Show()
	end	

	--使用中
	if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
		bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionDef"):Show()
	else
		bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionDef"):Hide()
	end
	
	--红点
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionTip"):Show()
	else
		bar:GetSubItem("NewExterior_HairStyle_SuperListItemActionTip"):Hide()
	end

end

function NewExterior_HairStyle_UpdateColorList()
	
	local uColorCount = Exterior:LuaFnGetExteriorHairColorCount()
	g_CurSelColorIndex = 0

	for i = 1, g_MaxColor do	
		
		if g_ColorList[i] ~= nil then
			
			local bar = g_ColorList[i]
			bar:GetSubItem("NewExterior_HairStyle_ColorListItemActionLock"):Hide()
			bar:GetSubItem("NewExterior_HairStyle_ColorListItemActionDef"):Hide()
			bar:GetSubItem("NewExterior_HairStyle_ColorListItemActionTip"):Hide()
			bar:GetSubItem("NewExterior_HairStyle_ColorListItemActionTry"):Hide()
		
			if i > uColorCount then
				bar:GetSubItem("NewExterior_HairStyle_ColorListItemActionLock"):Show()
				bar:GetSubItem("NewExterior_HairStyle_ColorListColor"):SetImageColor("00FFFFFF")
			else			
				local uRed, uGreee, uBlue, uAlpha, uColor = Exterior:LuaFnEnumExteriorHairColor(i - 1)
				if NewExterior_HairStyle_IsColorValid(uRed, uGreee, uBlue, uAlpha) == 1 then
				--	local imgColor = string.format("%02X",255)..string.format("%02X", uRed)..string.format("%02X",g_Index_HairColor_G[datai])..string.format("%02X",g_Index_HairColor_B[datai])
					
					local imgColor = string.format("%02X%02X%02X%02X", 255, uRed, uGreee, uBlue)
					bar:GetSubItem("NewExterior_HairStyle_ColorListColor"):SetImageColor(imgColor)
				else
					bar:GetSubItem("NewExterior_HairStyle_ColorListColor"):SetImageColor("00FFFFFF")
				end			
		
				if g_CurSelColorValue == uColor then 
					g_CurSelColorIndex = i - 1
				end
				if Exterior:LuaFnGetExteriorHairColorIndex() == uColor then
					bar:GetSubItem("NewExterior_HairStyle_ColorListItemActionDef"):Show()
				else
					if g_CurSelColorIndex == i - 1 then
						bar:GetSubItem("NewExterior_HairStyle_ColorListItemActionTry"):Show()
						bar:GetSubItem("NewExterior_HairStyle_ColorListItemAction"):SetPushed(1)
					else
						bar:GetSubItem("NewExterior_HairStyle_ColorListItemAction"):SetPushed(0)
					end
				end			
		
				if Exterior:LuaFnEnumExteriorHairColorTip(i - 1) == 1 then
					bar:GetSubItem("NewExterior_HairStyle_ColorListItemActionTip"):Show()
				end
			end			
		end
	end

	NewExterior_HairStyle_SetColorSelected(g_CurSelColorIndex + 1)
	NewExterior_HairStyle_ColorList:SetScrollPosition4Index(g_CurSelColorIndex)
end

function NewExterior_HairStyle_UpdateObj()	
	local cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
	if cacheExteriorID ~= nil and cacheExteriorID >= 0 then
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_HairStyle_UpdateCamera()
	end	
end

function NewExterior_HairStyle_UpdateOpBtn()

end

function NewExterior_HairStyle_ItemClicked(nIndex)
	local nExteriorID 	= Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	if g_CurSelExteriorID ~= nExteriorID then
		g_CurSelExteriorID = nExteriorID
		Exterior:LuaFnSetCurrentExteriorSetInfo("HAIR", g_CurSelExteriorID, g_CurSelColorValue)
		
		NewExterior_HairStyle_SetItemSelected(nIndex)
		NewExterior_HairStyle_UpdateObj()
		
		NewExterior_HairStyle_UpdateLeftBtn()
	
	NewExterior_HairStyle_RemoveTip(g_CurSelExteriorID)
		NewExterior_HairStyle_UpdateRedPoint()
	else
		local defExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
		Exterior:LuaFnSetCurrentExteriorSetInfo("HAIR", defExteriorID, g_CurSelColorValue)		
		NewExterior_HairStyle_Show()
	end	
	
	
end

function NewExterior_HairStyle_ItemMouseMove(nIndex)

end

function NewExterior_HairStyle_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_HairStyle_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("NewExterior_HairStyle_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("NewExterior_HairStyle_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("NewExterior_HairStyle_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function NewExterior_HairStyle_TryExterior()
	if Exterior:LuaFnIsHaveExteriorChange() ~= 1 then
		PushDebugMessage("#{WGTJ_201222_72}")
		return
	end

	Exterior:LuaFnSaveExteriorAllChange(1)
end

function NewExterior_HairStyle_TakeOffRide()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(3)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", 0)
		NewExterior_HairStyle_UpdateLeftBtn()
	else
		Exterior:LuaFnSetExteriorInUse(3, 0, 0)
	end
end

function NewExterior_HairStyle_TakeOffPoss()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(4)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(4)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_HairStyle_UpdateLeftBtn()
		NewExterior_HairStyle_UpdateObj()
	else
		Exterior:LuaFnSetExteriorInUse(4, 0, 0)
	end
end

function NewExterior_HairStyle_TakeOffWeapon()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorWeaponInUse()
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(5)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_HairStyle_UpdateLeftBtn()
		NewExterior_HairStyle_UpdateObj()
	else
		Exterior:LuaFnSetExteriorWeaponInUse(0, 0)
	end
end

function NewExterior_HairStyle_RemovePreview()
	if Exterior:LuaFnIsHaveExteriorChange() == 1 then
		Exterior:LuaFnRemovePlayerExteriorFitting()
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESET")
		Exterior:LuaFnInitCurrentExteriorSet(0)
		NewExterior_HairStyle_Show()
		PushDebugMessage("#{WGTJ_201222_98}")
	else
		PushDebugMessage("#{WGTJ_201222_76}")
	end
end

function NewExterior_HairStyle_ColorClicked(nIndex)
	
	local uColorCount = Exterior:LuaFnGetExteriorHairColorCount()
	
	if nIndex > uColorCount then
		return
	end
	
	if g_CurSelColorIndex ~= nIndex - 1 then
		g_CurSelColorIndex = nIndex - 1
		local _,_,_,_,nColor = Exterior:LuaFnEnumExteriorHairColor(g_CurSelColorIndex)
		g_CurSelColorValue = nColor
		Exterior:LuaFnSetCurrentExteriorSetInfo("HAIR", g_CurSelExteriorID, g_CurSelColorValue)
		NewExterior_HairStyle_SetColorSelected(nIndex)
		NewExterior_HairStyle_UpdateObj()
		
		NewExterior_HairStyle_UpdateLeftBtn()
		NewExterior_HairStyle_RemoveColorTip(g_CurSelColorIndex)
		NewExterior_HairStyle_UpdateRedPoint()
	else
		local defColorIndex = Exterior:LuaFnGetExteriorHairColorIndex()
		Exterior:LuaFnSetCurrentExteriorSetInfo("HAIR", g_CurSelExteriorID, defColorIndex)
		NewExterior_HairStyle_Show()
	end	
	
	
	
end

function NewExterior_HairStyle_ColorMouseMove(nIndex)

end

function NewExterior_HairStyle_SetColorSelected(nIndex)
	for i = 1, g_MaxColor do		
		if g_ColorList[i] ~= nil then	
			local ctrlAction = g_ColorList[i]:GetSubItem("NewExterior_HairStyle_ColorListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then					
					ctrlAction:SetPushed(1)
					local uRed, uGreee, uBlue, uAlpha, uColor = Exterior:LuaFnEnumExteriorHairColor(nIndex - 1)
					if Exterior:LuaFnGetExteriorHairColorIndex() ~= uColor then
						g_ColorList[i]:GetSubItem("NewExterior_HairStyle_ColorListItemActionTry"):Show()	
					end
				else
					ctrlAction:SetPushed(0)	
					g_ColorList[i]:GetSubItem("NewExterior_HairStyle_ColorListItemActionTry"):Hide()
				end
			end
		end
	end
end

function NewExterior_HairStyle_Goto()
	--激活
	AutoRuntoTargetExWithName(250, 129, 0, "燕如雪")
	--染色
	--AutoRuntoTargetExWithName(346, 270, 0, "何灵芝")
end

function NewExterior_HairStyle_CloseClick()
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	
	NewExterior_HairStyle_SavePosition()
	this:Hide()
end

function NewExterior_HairStyle_OnHidden()

	if IsWindowShow("Profile_Save") then
		CloseWindow("Profile_Save", true)
	end
	
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_PlayerFrame")
		or IsWindowShow("NewExterior_PetSoul") 
		or IsWindowShow("NewExterior_Weapon")
		or IsWindowShow("NewExterior_Widget")
		or IsWindowShow("NewExterior_Headdress") then
	else	
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	end	
	
	NewExterior_HairStyle_CleanUp()
end

function NewExterior_HairStyle_CleanUp()
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_HairStyle_SuperListItemAction")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
		end
	end
	
	for i = 1, g_MaxColor do
		if g_ColorList[i] then
			local ctrlAction = g_ColorList[i]:GetSubItem("NewExterior_HairStyle_ColorListItemAction")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
			
			local ctrlColor = g_ColorList[i]:GetSubItem("NewExterior_HairStyle_ColorListColor")	
			if ctrlColor then
				ctrlColor:SetImageColor("FFFFFFFF")
			end
		end
	end

	NewExterior_HairStyle_FakeObject:SetFakeObject("")
	
	NewExterior_HairStyle_CleanUp_LeftButton()
end

function NewExterior_HairStyle_CleanUp_LeftButton()

	NewExterior_HairStyle_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		NewExterior_HairStyle_FaceStyle_LeftBtn,
		NewExterior_HairStyle_HairStyle_LeftBtn,
		NewExterior_HairStyle_PlayerFrame_LeftBtn,
		NewExterior_HairStyle_Ride_LeftBtn,	
		NewExterior_HairStyle_PetSoul_LeftBtn,
		NewExterior_HairStyle_Weapon_LeftBtn,
		NewExterior_HairStyle_Widget_LeftBtn,
		NewExterior_HairStyle_Headdress_LeftBtn,
	}
	
	for i in pairs(ctrl_list) do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end

	NewExterior_HairStyle_Dress_LeftBtnLuxury:Hide()
	NewExterior_HairStyle_Dress_ActionImg:Hide()
	NewExterior_HairStyle_FaceStyle_ActionImg:Hide()
	NewExterior_HairStyle_HairStyle_ActionImg:Hide()
	NewExterior_HairStyle_PlayerFrame_ActionImg:Hide()
	NewExterior_HairStyle_Ride_ActionImg:Hide()
	NewExterior_HairStyle_PetSoul_ActionImg:Hide()
	NewExterior_HairStyle_Weapon_ActionImg:Hide()
	NewExterior_HairStyle_Widget_ActionImg:Hide()
	NewExterior_HairStyle_Headdress_ActionImg:Hide()

	NewExterior_HairStyle_Dress_LockImg:Hide()
	NewExterior_HairStyle_FaceStyle_LockImg:Hide()
	NewExterior_HairStyle_HairStyle_LockImg:Hide()
	NewExterior_HairStyle_PlayerFrame_LockImg:Hide()
	NewExterior_HairStyle_Ride_LockImg:Hide()
	NewExterior_HairStyle_PetSoul_LockImg:Hide()
	NewExterior_HairStyle_Weapon_LockImg:Hide()
	NewExterior_HairStyle_Widget_LockImg:Hide()
	NewExterior_HairStyle_Headdress_LockImg:Hide()
end

function NewExterior_HairStyle_FakeObject_TurnLeft(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
			NewExterior_HairStyle_FakeObject:RotateBegin(-0.3)
		else
		NewExterior_HairStyle_FakeObject:RotateEnd()
	end
end

function NewExterior_HairStyle_FakeObject_TurnRight(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
			NewExterior_HairStyle_FakeObject:RotateBegin(0.3)
		else
		NewExterior_HairStyle_FakeObject:RotateEnd()
	end
end
--缩小
function NewExterior_HairStyle_ZoomOut()
	if g_Distance == 1 then
		return
	end
	g_Distance = g_Distance - 1		
	NewExterior_HairStyle_UpdateCamera()
end
--放大
function NewExterior_HairStyle_ZoomIn()
	if g_Distance == g_Distance_Max then
		return
	end	
	g_Distance = g_Distance + 1	
	NewExterior_HairStyle_UpdateCamera()
end

function NewExterior_HairStyle_UpdateCamera()
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

function NewExterior_HairStyle_SwithViewMode()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID > 0 then
		if g_ViewMode == 0 then
			g_ViewMode = 1
		else
			g_ViewMode = 0
		end	
		NewExterior_HairStyle_UpdateObj()
	end	
end

function NewExterior_HairStyle_UpdateCheckButton()
--	NewExterior_HairStyle_ButtonHuanwu:SetCheck(0)
--	NewExterior_HairStyle_ButtonZhuangrong:SetCheck(0)
--	NewExterior_HairStyle_ButtonFuti:SetCheck(0)
--	NewExterior_HairStyle_ButtonZuoqi:SetCheck(1)
end

--右键取下时装
function NewExterior_HairStyle_ActionToDressBox()
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		cacheExteriorID = 0
		cacheExteriorIdx = -1
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", cacheExteriorID, cacheExteriorIdx)			
		NewExterior_HairStyle_Show()
		--return
	end
	Exterior:LuaFnUnUseExteriorFashion(1)
end

--时装
function NewExterior_HairStyle_OpenFashion()
	NewExterior_HairStyle_SavePosition()
	PushEvent("OPEN_EXTERIOR_FASHION", 1, 0)
end

--坐骑
function NewExterior_HairStyle_OpenRide()
	NewExterior_HairStyle_SavePosition()
	Exterior:LuaFnAskOpenExterior(3)
end

--发型
function NewExterior_HairStyle_OpenHair()
	--NewExterior_HairStyle_SavePosition()	
	--Exterior:LuaFnAskOpenExterior(1)
end

--脸型
function NewExterior_HairStyle_OpenFace()
	NewExterior_HairStyle_SavePosition()	
	Exterior:LuaFnAskOpenExterior(0)
end

--头像
function NewExterior_HairStyle_OpenPortrait()
	NewExterior_HairStyle_SavePosition()	
	Exterior:LuaFnAskOpenExterior(2)
end

--幻武
function NewExterior_HairStyle_OpenWeapon()
	NewExterior_HairStyle_SavePosition()
	Exterior:LuaFnAskOpenExteriorWeapon()
end

--融魂外观
function NewExterior_HairStyle_OpenPoss()
	NewExterior_HairStyle_SavePosition()	
	Exterior:LuaFnAskOpenExterior(4)
end

function NewExterior_HairStyle_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Facestyle", true)
	--CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_Widget", true)
	CloseWindow("NewExterior_Headdress", true)
end

function NewExterior_HairStyle_SavePosition()
	Variable:SetVariable("ExteriorUnionPos", NewExterior_HairStyle_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_HairStyle_SetPosition()
	
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_HairStyle_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end

end

function NewExterior_HairStyle_RemoveTip(nExteriorID)
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		Exterior:LuaFnRemoveExteriorTip(g_ExteriorType, nExteriorID)
		
		for i = 1, g_MaxBarNum do
			if g_BarList[i] then
				local nID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, i - 1)
				if Exterior:LuaFnGetExteriorTip(g_ExteriorType, nID) == 1 then
					g_BarList[i]:GetSubItem("NewExterior_HairStyle_SuperListItemActionTip"):Show()
				else
					g_BarList[i]:GetSubItem("NewExterior_HairStyle_SuperListItemActionTip"):Hide()
				end
			end
		end
	--	NewExterior_Ride_UpdateCheckButton()
	end	
	end
	
function NewExterior_HairStyle_RemoveColorTip(index)
	local nTip = Exterior:LuaFnEnumExteriorHairColorTip(index)
	if nTip == 1 then
		Exterior:LuaFnRemoveHairColorTip(index)
	
		for i = 1, g_MaxColor do
			if g_ColorList[i] then
				if Exterior:LuaFnEnumExteriorHairColorTip(i - 1) == 1 then
					g_ColorList[i]:GetSubItem("NewExterior_HairStyle_ColorListItemActionTip"):Show()
				else
					g_ColorList[i]:GetSubItem("NewExterior_HairStyle_ColorListItemActionTip"):Hide()
				end
			end
		end
	--	NewExterior_Ride_UpdateCheckButton()
	end	
end

function NewExterior_HairStyle_UpdateRedPoint()

	NewExterior_HairStyle_Dress_Tip:Hide()
	
	if Exterior:LuaFnIsHaveExteriorShowTip(3) == 1 then
		NewExterior_HairStyle_Ride_Tip:Show()
	else
		NewExterior_HairStyle_Ride_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(0) == 1 then
		NewExterior_HairStyle_FaceStyle_Tip:Show()
	else
		NewExterior_HairStyle_FaceStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(1) == 1 or Exterior:LuaFnIsHaveHairColorShowTip() == 1 then
		NewExterior_HairStyle_HairStyle_Tip:Show()
	else
		NewExterior_HairStyle_HairStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(2) == 1 then
		NewExterior_HairStyle_PlayerFrame_Tip:Show()
	else
		NewExterior_HairStyle_PlayerFrame_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(4) == 1 then
		NewExterior_HairStyle_PetSoul_Tip:Show()
	else
		NewExterior_HairStyle_PetSoul_Tip:Hide()
	end

	if Exterior:LuaFnIsHaveExteriorWeaponShowTip() == 1 then
		NewExterior_HairStyle_Weapon_Tip:Show()
	else
		NewExterior_HairStyle_Weapon_Tip:Hide()
	end
	
	if OrnamentsScript:IsHaveOrnamentsShowTip(0) == 1 then
		NewExterior_HairStyle_Widget_Tip:Show()
	else
		NewExterior_HairStyle_Widget_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(1) == 1 then
		NewExterior_HairStyle_Headdress_Tip:Show()
	else
		NewExterior_HairStyle_Headdress_Tip:Hide()
	end
end

function NewExterior_HairStyle_IsColorValid(red, green, blue, alpha)
	if red >= 0 and red <= 255 and green >= 0 and green <= 255 and blue >= 0 and blue <= 255 and alpha >= 0 and alpha <= 255 then
		return 1
	end
	return 0
end

function NewExterior_HairStyle_ShowFashionWeaponCheckButton()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	-- NewExterior_HairStyle_Dress_Type:SetCheck(IsDisplay)
end

function NewExterior_HairStyle_FashionDisplay()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	if IsDisplay == 1 then
		-- NewExterior_HairStyle_Dress_Type:SetCheck(0)
		SystemSetup:Set_Display_Dress(0)
	else
		-- NewExterior_HairStyle_Dress_Type:SetCheck(1)
		SystemSetup:Set_Display_Dress(1)
	end	
end

function NewExterior_HairStyle_ShowDressShareButton()
	
	local player_level = Player:GetData("LEVEL")
	if player_level >= 15 then
		NewExterior_HairStyle_SaveChangeBtn:Hide()
		NewExterior_HairStyle_ShareBtn:Show()
	else
		NewExterior_HairStyle_SaveChangeBtn:Hide()
		NewExterior_HairStyle_ShareBtn:Hide()
	end
	
end

function NewExterior_HairStyle_Share_Clicked()
	local ret = Exterior:LuaFnExteriorPlayerShareClick(0)
	return ret	
end

function NewExterior_HairStyle_SaveChange_Clicked()	
	local ret = Exterior:LuaFnExteriorPlayerOpenSharePlan()
	return ret	
end

-- 背挂
function NewExterior_HairStyle_OpenOrnamentsBack()
	NewExterior_HairStyle_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(0)
end

function NewExterior_HairStyle_ActionToOrnamentsBack()
	local useID = OrnamentsScript:GetOrnamentsUseID(0)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(0)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSBACK", 0, 0, 0, 0)
	NewExterior_HairStyle_UpdateLeftBtn()
	NewExterior_HairStyle_UpdateObj()
end

-- 头饰
function NewExterior_HairStyle_OpenOrnamentsHead()
	NewExterior_HairStyle_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(1)
end

function NewExterior_HairStyle_ActionToOrnamentsHead()
	local useID = OrnamentsScript:GetOrnamentsUseID(1)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(1)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", 0, 0, 0, 0)
	NewExterior_HairStyle_UpdateLeftBtn()
	NewExterior_HairStyle_UpdateObj()
end
--!!!reloadscript =NewExterior_HairStyle