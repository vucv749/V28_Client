--!!!reloadscript =NewExterior_Facestyle
local g_NewExterior_Facestyle_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 0;
local g_TargetExteriorIndex = 0		--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID

local g_CurSelExteriorID = 0			--当前选择的外观ID，从1开始

local g_NeedChangeScrollSize = 1

local g_Distance = 1
local g_Distance_Ori = 4
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 0 --脸型
local g_MaxBarNum = 0
local g_BarList = {}

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
function NewExterior_Facestyle_PreLoad()
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
function NewExterior_Facestyle_OnLoad()
	g_NewExterior_Facestyle_UnifiedPosition = NewExterior_Facestyle_Frame:GetProperty("UnifiedPosition")
end
--=========
--OnEvent
--=========
function NewExterior_Facestyle_OnEvent(event)

	if event == "OPEN_EXTERIOR" then
		if tonumber(arg0) == g_ExteriorType then
			if this:IsVisible() then
				if tonumber(arg1) == 0 then
					NewExterior_Facestyle_SavePosition()
					this:Hide()
				end
			else
				NewExterior_Facestyle_SetPosition()
				NewExterior_Facestyle_CloseSameGroupWindow()
				this:Show()
				NewExterior_Facestyle_Show()
			end	
		end
		return
	end
	
	if event == "OPEN_STALL_SALE"			-- 开始摆摊，还原试穿
		or event == "PROGRESSBAR_SHOW"		-- 读进度条中，还原试穿
		or event == "MODELID_CHANGE" 		-- 变身 关闭界面
		then
		NewExterior_Facestyle_CloseClick()
		return
	end
	
	if event == "EXERIOR_SAVEALL_RET" then
		if not this:IsVisible() then
			return
		end

		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESETEX")
		Exterior:LuaFnInitCurrentExteriorSetExceptFashion(0)
		NewExterior_Facestyle_Show()
	end
	
	if event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if not this:IsVisible() then
			return
		end

		if tonumber(arg0) == g_ExteriorType then
			NewExterior_Facestyle_Show()
		else
			--左侧
			NewExterior_Facestyle_UpdateLeftBtn()
			NewExterior_Facestyle_UpdateRedPoint()
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
			NewExterior_Facestyle_Show()
		else
			--左侧
			NewExterior_Facestyle_UpdateLeftBtn()
			NewExterior_Facestyle_UpdateRedPoint()
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
		NewExterior_Facestyle_UpdateLeftBtn()
		NewExterior_Facestyle_UpdateRedPoint()
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
			NewExterior_Facestyle_UpdateLeftBtn()
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
		NewExterior_Facestyle_Frame:SetProperty("UnifiedPosition", g_NewExterior_Facestyle_UnifiedPosition)
	end

	if event == "UNIT_LEVEL" and arg0 == "player" then
		if this:IsVisible() then
			NewExterior_Facestyle_UpdateLeftBtn()
		end
	end
	
	if event == "UPDATE_RIDE_CARD_INFO" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_Facestyle_UpdateLeftBtn()
		NewExterior_Facestyle_UpdateRedPoint()
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

function NewExterior_Facestyle_InitList()
	
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetExteriorMaxCount(g_ExteriorType)
		
		for i = 1, g_MaxBarNum do
			local bar = NewExterior_Facestyle_SuperList:AddChild("NewExterior_Facestyle_SuperListItem")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("NewExterior_Facestyle_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("NewExterior_Facestyle_ItemClicked(%d)", i))
			bar:GetSubItem("NewExterior_Facestyle_SuperListItemAction"):SetEvent("MouseMove", string.format("NewExterior_Facestyle_ItemMouseMove(%d)", i))
			bar:GetSubItem("NewExterior_Facestyle_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("NewExterior_Facestyle_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end
		g_InitList = 1
	end
end

function NewExterior_Facestyle_Show()
	
	g_Distance = g_Distance_Ori
	g_NeedChangeScrollSize = 1
				
	EXTERIORFILTTING_TOTALKIND = Exterior:LuaFnGetExteriorPlayerFittingCount()
	
	NewExterior_Facestyle_InitList()
	
	NewExterior_Facestyle_CleanUp()
	
	NewExterior_Facestyle_FakeObject:SetFakeObject("Exterior_Player")
	Exterior:LuaFnShowExteriorPlayerPetSoulEffect(0)
	Exterior:LuaFnUpdateExteriorPlayerData()
	
	g_CurSelExteriorID = 0

	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID > 0 then
		g_TargetExteriorID = cacheExteriorID
		g_CurSelExteriorID = cacheExteriorID
	end	

	--列表
	NewExterior_Facestyle_UpdateList()
	--左侧
	NewExterior_Facestyle_UpdateLeftBtn()
	--模型
	NewExterior_Facestyle_UpdateObj()

	NewExterior_Facestyle_RemoveTip(g_CurSelExteriorID)
	NewExterior_Facestyle_UpdateRedPoint()

	NewExterior_Facestyle_ShowFashionWeaponCheckButton()
	
	NewExterior_Facestyle_ShowDressShareButton()	

end

function NewExterior_Facestyle_UpdateLeftBtn()
	
	NewExterior_Facestyle_CleanUp_LeftButton()
	
	local sex = Player:GetMySex()
	
	--时装
	local nFashionId = -1
	NewExterior_Facestyle_Dress_LeftBtn:SetActionItem(-1)
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, cacheExteriorIdx)
		--local theAction = Exterior:LuaFnEnumExteriorFashionAction(1, cacheExteriorID, 0)
		if theAction:GetID() ~= 0 then
			NewExterior_Facestyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
			NewExterior_Facestyle_Dress_ActionImg:Show()
			
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 and nCurFashionIdx == cacheExteriorIdx then
				NewExterior_Facestyle_Dress_ActionImg:Hide()
			end
			
			nFashionId = cacheExteriorID
		end
	else
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
		if cacheExteriorIdx ~= nil and cacheExteriorIdx >= 0 then
			local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(cacheExteriorIdx)
			if theAction:GetID() ~= 0 then
				NewExterior_Facestyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
				NewExterior_Facestyle_Dress_ActionImg:Show()
				
				local nCurFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 and nCurFashionIdx == cacheExteriorIdx then
					NewExterior_Facestyle_Dress_ActionImg:Hide()
				end
			
				nFashionId = cacheExteriorID
			end
		else
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 then
				local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, nCurFashionIdx)
				if theAction:GetID() ~= 0 then
					NewExterior_Facestyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
					
					nFashionId = nCurFashionId
				end
			else
				local nCurFashionIdx, nCurFashionId = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 then
					local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(nCurFashionIdx)
					if theAction:GetID() ~= 0 then
						NewExterior_Facestyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
					
						nFashionId = nCurFashionId
					end
				end
			end			
		end		
	end	
		
	NewExterior_Facestyle_Dress_LeftBtnLuxury:Hide()
	if nFashionId ~= -1 then	
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nFashionId, "Number")
		if nFashionNumber ~= nil and nFashionNumber > 0 then
			NewExterior_Facestyle_Dress_LeftBtnLuxury:Show()
		end
	end
	
	--坐骑
	local edType = 3
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		NewExterior_Facestyle_Ride_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Facestyle_Ride_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 and DataPool:LuaFnIsExteriorRideActiveByRideCard(cacheExteriorID) ~= 1 then
			NewExterior_Facestyle_Ride_LockImg:Show()
		end
	end
	
	--脸型
	edType = 0
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_82}", strName)
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Facestyle_FaceStyle_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Facestyle_FaceStyle_LockImg:Show()
		end
	end
	
	--发型
	edType = 1
	cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_81}", strName)
		NewExterior_Facestyle_HairStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Facestyle_HairStyle_ActionImg:Show()
		else
			if Exterior:LuaFnGetExteriorHairColorIndex() ~= cacheColorIndex then
			NewExterior_Facestyle_HairStyle_ActionImg:Show()
		end
	end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Facestyle_HairStyle_LockImg:Show()
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
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_79}", strName)
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetToolTip(strTemp)
		strHeadTip = strTemp
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Facestyle_PlayerFrame_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Facestyle_PlayerFrame_LockImg:Show()
		end
	end
	
	--幻武
	local cacheWeaponLevel = 0
	cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{HSWQ_20220607_02}", strName, tostring(cacheWeaponLevel + 1))
		NewExterior_Facestyle_Weapon_LeftBtn:SetToolTip(strTemp)
	
		--试穿
		if Exterior:LuaFnGetExteriorWeaponInUse() ~= cacheExteriorID or cacheWeaponLevel ~= Exterior:LuaFnGetExteriorWeaponLevel() then
			NewExterior_Facestyle_Weapon_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExteriorWeapon(cacheExteriorID) ~= 1 then
			NewExterior_Facestyle_Weapon_LockImg:Show()
		end
	end
	
	--融魂外观
	local player_level = Player:GetData("LEVEL")
	if player_level < g_PetSoulLevelLimit then
		NewExterior_Facestyle_PetSoul_LeftCheckBtn:Hide()
	else
		NewExterior_Facestyle_PetSoul_LeftCheckBtn:Show()
	end

	edType = 4
	local strPossTip = ""
	local cachePossVisualIndex = 0
	cacheExteriorID, cachePossVisualIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Name", sex)
		local strIcon = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{SHRH_20220427_64}", strName)
		NewExterior_Facestyle_PetSoul_LeftBtn:SetToolTip(strTemp)
		
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID or cachePossVisualIndex ~= Exterior:LuaFnGetExteriorPossVisualIndex() then
			NewExterior_Facestyle_PetSoul_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Facestyle_PetSoul_LockImg:Show()
		end
	end

	-- 背饰
	local edOrnamentsType, cacheExteriorX, cacheExteriorY, cacheExteriorZ = 0,0,0,0
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsBack")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Facestyle_Widget_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_Widget_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_Facestyle_Widget_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_Facestyle_Widget_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_Facestyle_Widget_LockImg:Show()
		end
	end

	-- 头饰
	edOrnamentsType = 1
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsHead")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Facestyle_Headdress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_Headdress_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_Facestyle_Headdress_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_Facestyle_Headdress_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_Facestyle_Headdress_LockImg:Show()
		end
	end
end

function NewExterior_Facestyle_UpdateList()
	
	NewExterior_Facestyle_UpdateCheckButton()
	NewExterior_Facestyle_UpdateRedPoint()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType)
	local count = Exterior:LuaFnGetExteriorListCount(g_ExteriorType, 0)
	
	for i = 1, g_MaxBarNum do	
		NewExterior_Facestyle_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		NewExterior_Facestyle_SuperList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	if g_TargetExteriorIndex ~= 0 then
		NewExterior_Facestyle_SuperList:SetScrollPosition4Index(g_TargetExteriorIndex - 1)
		g_TargetExteriorID = 0
		g_TargetExteriorIndex = 0
	else
		NewExterior_Facestyle_SuperList:SetScrollPosition4Index(0)
	end	
	
end

function NewExterior_Facestyle_SetItem(index, max_count)
	
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
	local strName 	= Exterior:LuaFnGetExteriorFaceInfo(nExteriorID, "Name", sex)
	local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(nExteriorID, "Icon", sex)	
	local strImage = GetIconFullName(strIcon)
	local nMenpai 	= Exterior:LuaFnGetExteriorFaceInfo(nExteriorID, "Menpai", sex)
	
	local ctrlAction = bar:GetSubItem("NewExterior_Facestyle_SuperListItemAction")
	if ctrlAction ~= nil then
	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		local strTemp = Exterior:LuaFnGetExteriorFaceInfo(nExteriorID, "ToolTips", sex) --ScriptGlobal_Format("#{WGTJ_201222_82}", strName)
		ctrlAction:SetToolTip(strTemp)
		
			if g_CurSelExteriorID == nExteriorID then
				ctrlAction:SetPushed(1)
			bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionTry"):Show()
			if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
				bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionTry"):Hide()
			end
			else
				ctrlAction:SetPushed(0)
			bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionTry"):Hide()
			end
			
			if g_TargetExteriorID == nExteriorID then
				g_TargetExteriorIndex = index
		end
	end
	
	--非本门派蒙红 
	if nMyMenpai == nMenpai or nMenpai == -1 then			
		bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionMark"):Hide()
	else
		bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionMark"):Show()
	end	
		
	bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionTime"):Hide()
	--锁
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then			
		bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionLock"):Hide()
	else
		bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionLock"):Show()
	end	

	--使用中
	if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
		bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionDef"):Show()
	else
		bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionDef"):Hide()
	end
	
	--红点
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionTip"):Show()
	else
		bar:GetSubItem("NewExterior_Facestyle_SuperListItemActionTip"):Hide()
	end

end

function NewExterior_Facestyle_UpdateObj()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID ~= nil and cacheExteriorID >= 0 then
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_Facestyle_UpdateCamera()
	end		
end
		
function NewExterior_Facestyle_UpdateOpBtn()	

end

function NewExterior_Facestyle_ItemClicked(nIndex)
	
	local nExteriorID 	= Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	if g_CurSelExteriorID ~= nExteriorID then
		g_CurSelExteriorID = nExteriorID
		Exterior:LuaFnSetCurrentExteriorSetInfo("FACE", g_CurSelExteriorID)
		
		NewExterior_Facestyle_SetItemSelected(nIndex)
		NewExterior_Facestyle_UpdateObj()
		NewExterior_Facestyle_UpdateLeftBtn()
	
		NewExterior_Facestyle_RemoveTip(g_CurSelExteriorID)
		NewExterior_Facestyle_UpdateRedPoint()
	else
		local defExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
		Exterior:LuaFnSetCurrentExteriorSetInfo("FACE", defExteriorID)
		NewExterior_Facestyle_Show()
	end	
	
	
end

function NewExterior_Facestyle_ItemMouseMove(nIndex)

end

function NewExterior_Facestyle_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function NewExterior_Facestyle_TryExterior()
	if Exterior:LuaFnIsHaveExteriorChange() ~= 1 then
		PushDebugMessage("#{WGTJ_201222_72}")
		return
	end

	Exterior:LuaFnSaveExteriorAllChange(1)
end

function NewExterior_Facestyle_TakeOffRide()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(3)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", 0)
		NewExterior_Facestyle_UpdateLeftBtn()
	else
		Exterior:LuaFnSetExteriorInUse(3, 0, 0)
	end
end

function NewExterior_Facestyle_TakeOffPoss()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(4)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(4)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_Facestyle_UpdateLeftBtn()
		NewExterior_Facestyle_UpdateObj()
	else
		Exterior:LuaFnSetExteriorInUse(4, 0, 0)
	end
end

function NewExterior_Facestyle_TakeOffWeapon()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorWeaponInUse()
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(5)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_Facestyle_UpdateLeftBtn()
		NewExterior_Facestyle_UpdateObj()
	else
		Exterior:LuaFnSetExteriorWeaponInUse(0, 0)
	end
end

function NewExterior_Facestyle_RemovePreview()
	if Exterior:LuaFnIsHaveExteriorChange() == 1 then
		Exterior:LuaFnRemovePlayerExteriorFitting()
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESET")
		Exterior:LuaFnInitCurrentExteriorSet(0)
		NewExterior_Facestyle_Show()
		PushDebugMessage("#{WGTJ_201222_98}")
	else
		PushDebugMessage("#{WGTJ_201222_76}")
	end
end

function NewExterior_Facestyle_Goto()
	AutoRuntoTargetExWithName(252, 130, 0, "颜如玉")
end

function NewExterior_Facestyle_CloseClick()
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	
	NewExterior_Facestyle_SavePosition()
	this:Hide()
end

function NewExterior_Facestyle_OnHidden()

	if IsWindowShow("Profile_Save") then
		CloseWindow("Profile_Save", true)
	end
	
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_HairStyle") 
		or IsWindowShow("NewExterior_PlayerFrame")
		or IsWindowShow("NewExterior_PetSoul") 
		or IsWindowShow("NewExterior_Weapon")
		or IsWindowShow("NewExterior_Widget")
		or IsWindowShow("NewExterior_Headdress") then
	else	
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	end	
	
	NewExterior_Facestyle_CleanUp()
end

function NewExterior_Facestyle_CleanUp()
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemAction")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
		end
	end
	NewExterior_Facestyle_FakeObject:SetFakeObject("")
end

function NewExterior_Facestyle_CleanUp_LeftButton()
	
	NewExterior_Facestyle_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		NewExterior_Facestyle_FaceStyle_LeftBtn,
		NewExterior_Facestyle_HairStyle_LeftBtn,
		NewExterior_Facestyle_PlayerFrame_LeftBtn,
		NewExterior_Facestyle_Ride_LeftBtn,	
		NewExterior_Facestyle_PetSoul_LeftBtn,
		NewExterior_Facestyle_Weapon_LeftBtn,
		NewExterior_Facestyle_Widget_LeftBtn,
		NewExterior_Facestyle_Headdress_LeftBtn,
	}
	
	for i in pairs(ctrl_list) do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_Facestyle_Dress_LeftBtnLuxury:Hide()
	NewExterior_Facestyle_Dress_ActionImg:Hide()
	NewExterior_Facestyle_FaceStyle_ActionImg:Hide()
	NewExterior_Facestyle_HairStyle_ActionImg:Hide()
	NewExterior_Facestyle_PlayerFrame_ActionImg:Hide()
	NewExterior_Facestyle_Ride_ActionImg:Hide()
	NewExterior_Facestyle_PetSoul_ActionImg:Hide()
	NewExterior_Facestyle_Weapon_ActionImg:Hide()
	NewExterior_Facestyle_Widget_ActionImg:Hide()
	NewExterior_Facestyle_Headdress_ActionImg:Hide()

	NewExterior_Facestyle_Dress_LockImg:Hide()
	NewExterior_Facestyle_FaceStyle_LockImg:Hide()
	NewExterior_Facestyle_HairStyle_LockImg:Hide()
	NewExterior_Facestyle_PlayerFrame_LockImg:Hide()
	NewExterior_Facestyle_Ride_LockImg:Hide()
	NewExterior_Facestyle_PetSoul_LockImg:Hide()
	NewExterior_Facestyle_Weapon_LockImg:Hide()
	NewExterior_Facestyle_Widget_LockImg:Hide()
	NewExterior_Facestyle_Headdress_LockImg:Hide()
end

function NewExterior_Facestyle_FakeObject_TurnLeft(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		NewExterior_Facestyle_FakeObject:RotateBegin(-0.3)
	else
		NewExterior_Facestyle_FakeObject:RotateEnd()
	end
end

function NewExterior_Facestyle_FakeObject_TurnRight(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		NewExterior_Facestyle_FakeObject:RotateBegin(0.3)
	else
		NewExterior_Facestyle_FakeObject:RotateEnd()
	end
end
--缩小
function NewExterior_Facestyle_ZoomOut()
	if g_Distance == 1 then
		return
	end
	g_Distance = g_Distance - 1
	NewExterior_Facestyle_UpdateCamera()
end
--放大
function NewExterior_Facestyle_ZoomIn()
	if g_Distance == g_Distance_Max then
		return
	end	
	g_Distance = g_Distance + 1
	NewExterior_Facestyle_UpdateCamera()
end

function NewExterior_Facestyle_UpdateCamera()
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

function NewExterior_Facestyle_UpdateCheckButton()
--	NewExterior_Facestyle_ButtonHuanwu:SetCheck(0)
--	NewExterior_Facestyle_ButtonZhuangrong:SetCheck(0)
--	NewExterior_Facestyle_ButtonFuti:SetCheck(0)
--	NewExterior_Facestyle_ButtonZuoqi:SetCheck(1)
end

--右键取下时装
function NewExterior_Facestyle_ActionToDressBox()
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		cacheExteriorID = 0
		cacheExteriorIdx = -1
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", cacheExteriorID, cacheExteriorIdx)			
		NewExterior_Facestyle_Show()
		--return
	end
	Exterior:LuaFnUnUseExteriorFashion(1)
end

--时装
function NewExterior_Facestyle_OpenFashion()
	NewExterior_Facestyle_SavePosition()
	PushEvent("OPEN_EXTERIOR_FASHION", 1, 0)
end

--坐骑
function NewExterior_Facestyle_OpenRide()
	NewExterior_Facestyle_SavePosition()
	Exterior:LuaFnAskOpenExterior(3)
end

--发型
function NewExterior_Facestyle_OpenHair()
	NewExterior_Facestyle_SavePosition()	
	Exterior:LuaFnAskOpenExterior(1)
end

--脸型
function NewExterior_Facestyle_OpenFace()
	--NewExterior_Facestyle_SavePosition()	
	--Exterior:LuaFnAskOpenExterior(0)
end

--头像
function NewExterior_Facestyle_OpenPortrait()
	NewExterior_Facestyle_SavePosition()	
	Exterior:LuaFnAskOpenExterior(2)
end

--幻武
function NewExterior_Facestyle_OpenWeapon()
	NewExterior_Facestyle_SavePosition()
	Exterior:LuaFnAskOpenExteriorWeapon()
end

--融魂外观
function NewExterior_Facestyle_OpenPoss()
	NewExterior_Facestyle_SavePosition()	
	Exterior:LuaFnAskOpenExterior(4)
end

-- 背挂
function NewExterior_Facestyle_OpenOrnamentsBack()
	NewExterior_Facestyle_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(0)
end

-- 头饰
function NewExterior_Facestyle_OpenOrnamentsHead()
	NewExterior_Facestyle_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(1)
end

function NewExterior_Facestyle_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	--CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_Widget", true)
	CloseWindow("NewExterior_Headdress", true)
end

function NewExterior_Facestyle_SavePosition()
	Variable:SetVariable("ExteriorUnionPos", NewExterior_Facestyle_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_Facestyle_SetPosition()
	
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_Facestyle_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end

end

function NewExterior_Facestyle_RemoveTip(nExteriorID)
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		Exterior:LuaFnRemoveExteriorTip(g_ExteriorType, nExteriorID)
	
		for i = 1, g_MaxBarNum do
			if g_BarList[i] then
				local nID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, i - 1)
				if Exterior:LuaFnGetExteriorTip(g_ExteriorType, nID) == 1 then
					g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemActionTip"):Show()
				else
					g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemActionTip"):Hide()
				end
			end
		end
	--	NewExterior_Ride_UpdateCheckButton()
	end	
end

function NewExterior_Facestyle_UpdateRedPoint()

	NewExterior_Facestyle_Dress_Tip:Hide()
	
	if Exterior:LuaFnIsHaveExteriorShowTip(3) == 1 then
		NewExterior_Facestyle_Ride_Tip:Show()
	else
		NewExterior_Facestyle_Ride_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(0) == 1 then
		NewExterior_Facestyle_FaceStyle_Tip:Show()
	else
		NewExterior_Facestyle_FaceStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(1) == 1 or Exterior:LuaFnIsHaveHairColorShowTip() == 1 then
		NewExterior_Facestyle_HairStyle_Tip:Show()
	else
		NewExterior_Facestyle_HairStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(2) == 1 then
		NewExterior_Facestyle_PlayerFrame_Tip:Show()
	else
		NewExterior_Facestyle_PlayerFrame_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(4) == 1 then
		NewExterior_Facestyle_PetSoul_Tip:Show()
	else
		NewExterior_Facestyle_PetSoul_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorWeaponShowTip() == 1 then
		NewExterior_Facestyle_Weapon_Tip:Show()
	else
		NewExterior_Facestyle_Weapon_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(0) == 1 then
		NewExterior_Facestyle_Widget_Tip:Show()
	else
		NewExterior_Facestyle_Widget_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(1) == 1 then
		NewExterior_Facestyle_Headdress_Tip:Show()
	else
		NewExterior_Facestyle_Headdress_Tip:Hide()
	end
end

function NewExterior_Facestyle_ShowFashionWeaponCheckButton()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	-- NewExterior_Facestyle_Dress_Type:SetCheck(IsDisplay)
end

function NewExterior_Facestyle_FashionDisplay()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	if IsDisplay == 1 then
		-- NewExterior_Facestyle_Dress_Type:SetCheck(0)
		SystemSetup:Set_Display_Dress(0)
	else
		-- NewExterior_Facestyle_Dress_Type:SetCheck(1)
		SystemSetup:Set_Display_Dress(1)
	end	
end

function NewExterior_Facestyle_ShowDressShareButton()
	
	local player_level = Player:GetData("LEVEL")
	if player_level >= 15 then
		NewExterior_Facestyle_SaveChangeBtn:Hide()
		NewExterior_Facestyle_ShareBtn:Show()
	else
		NewExterior_Facestyle_SaveChangeBtn:Hide()
		NewExterior_Facestyle_ShareBtn:Hide()
	end
	
end

function NewExterior_Facestyle_Share_Clicked()
	local ret = Exterior:LuaFnExteriorPlayerShareClick(0)
	return ret	
end

function NewExterior_Facestyle_SaveChange_Clicked()	
	local ret = Exterior:LuaFnExteriorPlayerOpenSharePlan()
	return ret	
end

function NewExterior_Facestyle_ActionToOrnamentsBack()
	local useID = OrnamentsScript:GetOrnamentsUseID(0)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(0)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSBACK", 0, 0, 0, 0)
	NewExterior_Facestyle_UpdateLeftBtn()
	NewExterior_Facestyle_UpdateObj()
end

function NewExterior_Facestyle_ActionToOrnamentsHead()
	local useID = OrnamentsScript:GetOrnamentsUseID(1)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(1)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", 0, 0, 0, 0)
	NewExterior_Facestyle_UpdateLeftBtn()
	NewExterior_Facestyle_UpdateObj()
end

--!!!reloadscript =NewExterior_Facestyle