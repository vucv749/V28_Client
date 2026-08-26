--!!!reloadscript = NewExterior_Headdress
local g_NewExterior_Headdress_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND	= 0
local g_TargetExteriorIndex			= 0		-- 定位的外观索引，从1开始
local g_TargetExteriorID			= 0		-- 定位的外观ID

local g_CurSelExteriorID			= 0		-- 当前选择的外观ID，从1开始
local g_CurSelExteriorX				= 0		-- 当前选择的外观ID，从1开始
local g_CurSelExteriorY				= 0		-- 当前选择的外观ID，从1开始
local g_CurSelExteriorZ				= 0		-- 当前选择的外观ID，从1开始
local g_CurSelExteriorIndex			= 0		-- 当前选择的外观索引

local g_Distance					= 1
local g_Distance_Ori				= 2
local g_Distance_Max				= 4
local g_InitList					= 0
local g_ExteriorType				= 1		-- 头饰
local g_MaxBarNum					= 0
local g_BarList = {}

local g_SliderChange				= 0
local g_TextChange					= 0
local g_NeedChangeScrollSize		= 1

local g_OrnamentPosXMax				= 255
local g_OrnamentPosYMax				= 255
local g_OrnamentPosZMax				= 255
local g_OrnamentPosXMin				= 1
local g_OrnamentPosYMin				= 1
local g_OrnamentPosZMin				= 1
local g_OrnamentPosMax				= 255
local g_OrnamentPosAdjust			= 1		-- 是否可调节

local g_Ornaments_Name				= "OrnamentsHead"

local g_OrnamentState				= {		-- 状态
	INVALID	= 0,							-- 无效
	EMPTY	= 1,							-- 空闲
	TIME	= 2,							-- 限时
	TIMEOUT	= 3,							-- 过期
	FOREVER	= 4,							-- 永久
}


local g_CameraHeight				= 1     -- 摄影机高度
local g_CameraDistance				= 2		-- 摄影机距离
local g_CameraPitch					= 3     -- 摄影机角度
local g_CameraPosition				= {
	[0] =									-- 女性相关位置
	{
		{fHeight = 0.82, fDistance = 8, fPitch=0.1},
		{fHeight = 0.82, fDistance = 6.5, fPitch=0.1},
		{fHeight = 1.5, fDistance = 2.5, fPitch=0.10},
		{fHeight = 1.57, fDistance = 1.7, fPitch=0.10}
	},
	[1] =									-- 男性相关位置 
	{
		{fHeight = 0.91, fDistance = 8.8, fPitch=0.2},
		{fHeight = 0.91, fDistance = 7.1, fPitch=0.2},
		{fHeight = 1.67, fDistance = 2.5, fPitch=0.2},
		{fHeight = 1.745, fDistance = 1.7, fPitch=0.2}
	},
}

local g_SpecialWeaponCamera = {
-- [1] = {	[0] = {startid = 414, endid = 418, fHeight = 1.25, fDistance = 17, fPitch = -1, timecount = 6000},
-- 		[1] = {startid = 414, endid = 418, fHeight = 1.25, fDistance = 19, fPitch = -1, timecount = 6000},
-- 		},
}

local g_PetSoulLevelLimit = 85
local EXTERIORFILTTING_WEAPONKIND = 5

--=========
--PreLoad==
--=========
function NewExterior_Headdress_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ORNAMENTS_OPEN_HEAD")
	this:RegisterEvent("ORNAMENTS_POS_UPDATE", false)
	this:RegisterEvent("UI_COMMAND", false)
	this:RegisterEvent("ADD_EXTERIOR", false)
	this:RegisterEvent("ADD_EXTERIOR", false)
	this:RegisterEvent("UPDATE_EXTERIOR", false)
	this:RegisterEvent("EXTERIOR_OUTTIME", false)
	this:RegisterEvent("EXTERIOR_ID_CHANGED", false)
	
	this:RegisterEvent("ADD_EXTERIOR_WEAPON", false)
	this:RegisterEvent("UPDATE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("EXTERIOR_OUTTIME_WEAPON", false)
	this:RegisterEvent("REMOVE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_CHANGED", false)
	
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_LEVEL_CHANGED", false)
	
	this:RegisterEvent("EXTERIOR_POSS_VISUAL_INDEX", false)
	this:RegisterEvent("EXTERIOR_HAIR_COLOR_INDEX", false)
	
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
	this:RegisterEvent("OPEN_DRESSPREVIEW", false)
	this:RegisterEvent("ORNAMENTS_DISPLAYUPDATE", false)
end

--=========
--OnLoad
--=========
function NewExterior_Headdress_OnLoad()
	g_NewExterior_Headdress_UnifiedPosition = NewExterior_Headdress_Frame:GetProperty("UnifiedPosition")
	
	NewExterior_Headdress_X:SetProperty( "DocumentSize", tostring(g_OrnamentPosMax) )
	NewExterior_Headdress_X:SetProperty( "PageSize","0" )
	NewExterior_Headdress_X:SetProperty( "StepSize","1" )

	NewExterior_Headdress_Y:SetProperty( "DocumentSize",tostring(g_OrnamentPosMax) )
	NewExterior_Headdress_Y:SetProperty( "PageSize","0" )
	NewExterior_Headdress_Y:SetProperty( "StepSize","1" )

	NewExterior_Headdress_Z:SetProperty( "DocumentSize", tostring(g_OrnamentPosMax) )
	NewExterior_Headdress_Z:SetProperty( "PageSize","0" )
	NewExterior_Headdress_Z:SetProperty( "StepSize","1" )
end
--=========
--OnEvent
--=========
function NewExterior_Headdress_OnEvent(event) 
	if(event == "UI_COMMAND" and arg0 == "202602161") then
		local nOpType = Get_XParam_INT(0);
		local nExteriorId = Get_XParam_INT(1);
		DataPool:EquipOrnament(nOpType, nExteriorId,500)
		return
	end
	if event == "ORNAMENTS_OPEN_HEAD" then
		if this:IsVisible() then
			if tonumber(arg1) == 0 then
				NewExterior_Headdress_SavePosition()
				--this:Hide()
			end
		else
			NewExterior_Headdress_SetPosition()
			NewExterior_Headdress_CloseSameGroupWindow()
			this:Show()
			NewExterior_Headdress_Show()
		end

		return
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 99936103 then
		NewExterior_Headdress_ResetPosition()
		return
	end

	if event == "ORNAMENTS_POS_UPDATE" then
		if tonumber(arg0) == g_ExteriorType and tonumber(arg1) <= 0 then
			NewExterior_Headdress_Show()
		else
			--左侧
			NewExterior_Headdress_UpdateLeftBtn()
			NewExterior_Headdress_UpdateRedPoint()
			Exterior:LuaFnUpdateExteriorPlayerData()
			--Exterior:LuaFnUpdateOrnamentsBackDir()
		end
		return
	end

	if event == "OPEN_STALL_SALE" -- 开始摆摊，还原试穿
		or event == "PROGRESSBAR_SHOW"	-- 读进度条中，还原试穿
		or event == "MODELID_CHANGE" -- 变身 关闭界面
		then
		NewExterior_Headdress_CloseClick()
		return
	end
	
	if event == "EXERIOR_SAVEALL_RET" then
		if not this:IsVisible() then
			return
		end

		Exterior:LuaFnSetCurrentExteriorSetInfo("RESETEX")
		Exterior:LuaFnInitCurrentExteriorSetExceptFashion(0)
		NewExterior_Headdress_Show()
	end
	
	if event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_Headdress_UpdateLeftBtn()
		NewExterior_Headdress_UpdateRedPoint()
		--更新一下模型
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
	
	if event == "ADD_EXTERIOR_WEAPON" or event == "UPDATE_EXTERIOR_WEAPON" or event == "EXTERIOR_OUTTIME_WEAPON" or event == "DEF_EXTERIOR_WEAPON_CHANGED" then
		if not this:IsVisible() then
			return
		end

		NewExterior_Headdress_Show()
		return
	end
	
	if event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		if not this:IsVisible() then
			return
		end

		NewExterior_Headdress_Show()
		return
	end
	
	if event == "EXTERIOR_POSS_VISUAL_INDEX" or event == "EXTERIOR_HAIR_COLOR_INDEX" then
		if not this:IsVisible() then
			return
		end

		--左侧
		NewExterior_Headdress_UpdateLeftBtn()
		NewExterior_Headdress_UpdateRedPoint()
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
			NewExterior_Headdress_UpdateLeftBtn()
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
		NewExterior_Headdress_Frame:SetProperty("UnifiedPosition", g_NewExterior_Headdress_UnifiedPosition)
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

function NewExterior_Headdress_InitList()
	if g_InitList == 0 then		
		g_MaxBarNum = OrnamentsScript:GetOrnamentsMaxCount(g_ExteriorType)
		
		for i = 1, g_MaxBarNum do
			local bar = NewExterior_Headdress_SuperList:AddChild("NewExterior_Headdress_SuperListItem")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("NewExterior_Headdress_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("NewExterior_Headdress_ItemClicked(%d)", i))
			bar:GetSubItem("NewExterior_Headdress_SuperListItemAction"):SetEvent("MouseMove", string.format("NewExterior_Headdress_ItemMouseMove(%d)", i))
			bar:GetSubItem("NewExterior_Headdress_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("NewExterior_Headdress_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end
		g_InitList = 1
	end
end

function NewExterior_Headdress_Show()
	
	g_Distance = g_Distance_Ori

	g_NeedChangeScrollSize = 1
				
	EXTERIORFILTTING_TOTALKIND = Exterior:LuaFnGetExteriorPlayerFittingCount()
	
	NewExterior_Headdress_InitList()
	
	NewExterior_Headdress_CleanUp()
	
	NewExterior_Headdress_FakeObject:SetFakeObject("Exterior_Player")
	Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
	Exterior:LuaFnUpdateExteriorPlayerData()
	
	g_CurSelExteriorID = 0
	g_CurSelExteriorIndex = 0

	g_SliderChange = 0
	g_TextChange = 0
	
	local cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo(g_Ornaments_Name)
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		g_TargetExteriorID = cacheExteriorID
		g_CurSelExteriorID = cacheExteriorID
		g_CurSelExteriorX = cacheExteriorX
		g_CurSelExteriorY = cacheExteriorY
		g_CurSelExteriorZ = cacheExteriorZ
		g_OrnamentPosXMin, g_OrnamentPosXMax, g_OrnamentPosYMin, 
		g_OrnamentPosYMax,g_OrnamentPosZMin, g_OrnamentPosZMax,
		g_OrnamentPosAdjust = OrnamentsScript:GetOrnamentsInfo(g_ExteriorType, g_CurSelExteriorID, "Pos")
	end
	
	NewExterior_Headdress_UpdateList()
	
	NewExterior_Headdress_UpdateLeftBtn()
	
	NewExterior_Headdress_UpdateObj()
	
	NewExterior_Headdress_RemoveTip(g_CurSelExteriorID)

	NewExterior_Headdress_UpdateRedPoint()
	NewExterior_Headdress_UpdateSlider()

	NewExterior_Headdress_ShowDressShareButton()
	NewExterior_Headdress_ShowOrnamentsBackCheckButton()
end

function NewExterior_Headdress_UpdateLeftBtn()
	
	NewExterior_Headdress_CleanUp_LeftButton()
	
	local sex = Player:GetMySex()
	
	--时装
	local nFashionId = -1
	NewExterior_Headdress_Dress_LeftBtn:SetActionItem(-1)
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, cacheExteriorIdx)
		if theAction:GetID() ~= 0 then
			NewExterior_Headdress_Dress_LeftBtn:SetActionItem(theAction:GetID())
			NewExterior_Headdress_Dress_ActionImg:Show()
			
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 and nCurFashionIdx == cacheExteriorIdx then
				NewExterior_Headdress_Dress_ActionImg:Hide()
			end
			
			nFashionId = cacheExteriorID
		end
	else
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
		if cacheExteriorIdx ~= nil and cacheExteriorIdx >= 0 then
			local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(cacheExteriorIdx)
			if theAction:GetID() ~= 0 then
				NewExterior_Headdress_Dress_LeftBtn:SetActionItem(theAction:GetID())
				NewExterior_Headdress_Dress_ActionImg:Show()
				
				local nCurFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 and nCurFashionIdx == cacheExteriorIdx then
					NewExterior_Headdress_Dress_ActionImg:Hide()
				end
				
				nFashionId = cacheExteriorID
			end
		else
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 then
				local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, nCurFashionIdx)
				if theAction:GetID() ~= 0 then
					NewExterior_Headdress_Dress_LeftBtn:SetActionItem(theAction:GetID())
					
					nFashionId = nCurFashionId
				end
			else
				local nCurFashionIdx, nCurFashionId = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 then
					local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(nCurFashionIdx)
					if theAction:GetID() ~= 0 then
						NewExterior_Headdress_Dress_LeftBtn:SetActionItem(theAction:GetID())
						
						nFashionId = nCurFashionId
					end
				end
			end			
		end	
	end
		
	NewExterior_Headdress_Dress_LeftBtnLuxury:Hide()
	if nFashionId ~= -1 then	
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nFashionId, "Number")
		if nFashionNumber ~= nil and nFashionNumber > 0 then
			NewExterior_Headdress_Dress_LeftBtnLuxury:Show()
		end
	end
	
	--坐骑
	local edType = 3
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Headdress_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Headdress_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		NewExterior_Headdress_Ride_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Headdress_Ride_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Headdress_Ride_LockImg:Show()
		end
	end
	
	--脸型
	edType = 0
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Headdress_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Headdress_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_82}", strName)
		NewExterior_Headdress_FaceStyle_LeftBtn:SetToolTip(strTemp)	
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Headdress_FaceStyle_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Headdress_FaceStyle_LockImg:Show()
		end
	end
	
	--发型
	edType = 1
	cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Headdress_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Headdress_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_81}", strName)
		NewExterior_Headdress_HairStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Headdress_HairStyle_ActionImg:Show()
		else
			if Exterior:LuaFnGetExteriorHairColorIndex() ~= cacheColorIndex then
			NewExterior_Headdress_HairStyle_ActionImg:Show()
		end
	end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Headdress_HairStyle_LockImg:Show()
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
		NewExterior_Headdress_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Headdress_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_79}", strName)
		NewExterior_Headdress_PlayerFrame_LeftBtn:SetToolTip(strTemp)
		strHeadTip = strTemp
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Headdress_PlayerFrame_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Headdress_PlayerFrame_LockImg:Show()
		end
	end
	
	--幻武
	local cacheWeaponLevel = 0
	cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Headdress_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Headdress_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{HSWQ_20220607_02}", strName, tostring(cacheWeaponLevel + 1))
		NewExterior_Headdress_Weapon_LeftBtn:SetToolTip(strTemp)
	
		--试穿
		if Exterior:LuaFnGetExteriorWeaponInUse() ~= cacheExteriorID or cacheWeaponLevel ~= Exterior:LuaFnGetExteriorWeaponLevel() then
			NewExterior_Headdress_Weapon_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExteriorWeapon(cacheExteriorID) ~= 1 then
			NewExterior_Headdress_Weapon_LockImg:Show()
		end
	end
	
	--融魂外观
	local buttonShow = 0
	local player_level = Player:GetData("LEVEL")
	if player_level < g_PetSoulLevelLimit then
		NewExterior_Headdress_PetSoul_LeftCheckBtn:Hide()
	else
		NewExterior_Headdress_PetSoul_LeftCheckBtn:Show()
		buttonShow = 1
	end
	
	if buttonShow == 1 and Player : GetData("IsOriginalHJ") == 1 then
		NewExterior_Headdress_PetSoul_LeftCheckBtn:Hide()
	end
	
	edType = 4
	local strPossTip = ""
	local cachePossVisualIndex = 0
	cacheExteriorID, cachePossVisualIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Headdress_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Headdress_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{SHRH_20220427_64}", strName)
		NewExterior_Headdress_PetSoul_LeftBtn:SetToolTip(strTemp)
		
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID or cachePossVisualIndex ~= Exterior:LuaFnGetExteriorPossVisualIndex() then
			NewExterior_Headdress_PetSoul_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Headdress_PetSoul_LockImg:Show()
		end
	end

	-- 背饰
	local edOrnamentsType, cacheExteriorX, cacheExteriorY, cacheExteriorZ = 0,0,0,0
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsBack")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Headdress_Widget_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Headdress_Widget_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_Headdress_Widget_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_Headdress_Widget_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_Headdress_Widget_LockImg:Show()
		end
	end

	edOrnamentsType = 1
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsHead")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Headdress_Headdress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Headdress_Headdress_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_Headdress_Headdress_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_Headdress_Headdress_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_Headdress_Headdress_LockImg:Show()
		end
	end
end

function NewExterior_Headdress_UpdateList()
	
	NewExterior_Headdress_UpdateRedPoint()
	
	OrnamentsScript:InitOrnamentsListInfo(g_ExteriorType)
	local count = OrnamentsScript:GetOrnamentsMaxCount(g_ExteriorType)
	
	for i = 1, g_MaxBarNum do	
		NewExterior_Headdress_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		NewExterior_Headdress_SuperList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	if g_TargetExteriorIndex ~= 0 then
		NewExterior_Headdress_SuperList:SetScrollPosition4Index(g_TargetExteriorIndex - 1)
		g_TargetExteriorID = 0
		g_TargetExteriorIndex = 0
	else
		NewExterior_Headdress_SuperList:SetScrollPosition4Index(0)
	end
end

function NewExterior_Headdress_SetItem(index, max_count)
	
	if g_BarList[index] == nil then
		return
	end
	
	if index > max_count then
		g_BarList[index]:Hide()
		return
	end
	
	local bar = g_BarList[index]
	bar:Show()
	
	local nExteriorID = OrnamentsScript:GetOrnamentsListID(g_ExteriorType, index - 1)
	local strIcon 	= OrnamentsScript:GetOrnamentsInfo(g_ExteriorType, nExteriorID, "Icon")
	local strName 	= OrnamentsScript:GetOrnamentsInfo(g_ExteriorType, nExteriorID, "Name")
	local strImage	= GetIconFullName(strIcon)
	local strDesc 	= OrnamentsScript:GetOrnamentsInfo(g_ExteriorType, nExteriorID, "Desc")
	local nActionID = OrnamentsScript:GetOrnamentsInfo(g_ExteriorType, nExteriorID, "ActionID")
	local nAdjust	= OrnamentsScript:GetOrnamentsInfo(g_ExteriorType, nExteriorID, "Adjust")

	local ctrlAction = bar:GetSubItem("NewExterior_Headdress_SuperListItemAction")
	if ctrlAction ~= nil then
	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		local strToolTip = OrnamentsScript:GetOrnamentsToolTip(g_ExteriorType, nExteriorID)
		if nAdjust < 1 then
			strToolTip = strToolTip.."#{BGTS_220125_63}"
		end
		ctrlAction:SetToolTip(strToolTip)
		
		if g_CurSelExteriorID == nExteriorID then
			ctrlAction:SetPushed(1)
			bar:GetSubItem("NewExterior_Headdress_SuperListItemActionTry"):Show()
			if OrnamentsScript:GetOrnamentsUseID(g_ExteriorType) == nExteriorID then
				bar:GetSubItem("NewExterior_Headdress_SuperListItemActionTry"):Hide()
			end
			g_CurSelExteriorIndex = index
		else
			ctrlAction:SetPushed(0)
			bar:GetSubItem("NewExterior_Headdress_SuperListItemActionTry"):Hide()
		end			

		if g_TargetExteriorID == nExteriorID then
			g_TargetExteriorIndex = index
		end

	end
	
	-- 动作标识
	if nActionID > 0 then
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionButton"):Show()
	else
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionButton"):Hide()
	end

	--解锁&限时标志
	local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(g_ExteriorType, nExteriorID, 0)
	if nIdx > 0 and nState == g_OrnamentState.TIME then
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionTime"):Show()
	else
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionTime"):Hide()
		--bar:GetSubItem("NewExterior_Headdress_SuperListItemActionLock"):Show()
	end	

	if nIdx > 0 and (nState == g_OrnamentState.TIME or nState == g_OrnamentState.FOREVER) then
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionLock"):Hide()
	else
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionLock"):Show()
	end

	--使用中
	if OrnamentsScript:GetOrnamentsUseID(g_ExteriorType) == nExteriorID then
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionDef"):Show()
	else
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionDef"):Hide()
	end
	
	--红点
	local nTip = OrnamentsScript:GetPlayerOrnamentsTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionTip"):Show()
	else
		bar:GetSubItem("NewExterior_Headdress_SuperListItemActionTip"):Hide()
	end

	bar:GetSubItem("NewExterior_Headdress_SuperListItemActionMark"):Hide()
end

function NewExterior_Headdress_UpdateObj()
	local cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo(g_Ornaments_Name)
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		--NewExterior_Headdress_FakeObject:DetachWindowEx()
		--NewExterior_Headdress_FakeObject:AttachWindowEx("Exterior_Player")
		--Exterior:LuaFnUpdateOrnamentsFashion(g_ExteriorType, cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ)
		Exterior:LuaFnUpdateExteriorPlayerData()
		--Exterior:LuaFnUpdateOrnamentsBackDir()
		local actionID = OrnamentsScript:GetOrnamentsInfo(g_ExteriorType, cacheExteriorID, "ActionID")
		if actionID ~= nil and actionID > 0 then
			NewExterior_Headdress_Model_Animate:Show()
		else
			NewExterior_Headdress_Model_Animate:Hide()
		end
	else	
		--NewExterior_Headdress_FakeObject:DetachWindowEx()
		--NewExterior_Headdress_FakeObject:AttachWindowEx("Exterior_Player")
		--Exterior:LuaFnUpdateExteriorPlayerData()

		NewExterior_Headdress_Model_Animate:Hide()
	end

	NewExterior_Headdress_ActionEnd()
	NewExterior_Headdress_UpdateCamera()
end

function NewExterior_Headdress_UpdateSlider()
	if g_CurSelExteriorID > 0 then

		NewExterior_Headdress_CalSliderChange(g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ)
		g_TextChange = 3

		NewExterior_Headdress_X_Input : SetText(tostring(g_CurSelExteriorX))
		NewExterior_Headdress_X :SetPosition(g_CurSelExteriorX)

		NewExterior_Headdress_Y_Input : SetText(tostring(g_CurSelExteriorY))
		NewExterior_Headdress_Y :SetPosition(g_CurSelExteriorY)

		NewExterior_Headdress_Z_Input : SetText(tostring(g_CurSelExteriorZ))
		NewExterior_Headdress_Z :SetPosition(g_CurSelExteriorZ)

		NewExterior_Headdress_AdjustUIShow()
		NewExterior_Headdress_XYZList:Show()
	else
		NewExterior_Headdress_XYZList:Hide()
		NewExterior_Headdress_XYZ_Mask:SetToolTip("")
	end
end


function NewExterior_Headdress_ItemClicked(nIndex)
	local nExteriorID = OrnamentsScript:GetOrnamentsListID(g_ExteriorType, nIndex - 1)
	if g_CurSelExteriorID ~= nExteriorID then
		g_CurSelExteriorID = nExteriorID
		g_CurSelExteriorIndex = nIndex
		g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ = OrnamentsScript:GetOrnamentsDestPos(g_ExteriorType, g_CurSelExteriorID)
		Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", g_CurSelExteriorID, g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ)
	
		g_OrnamentPosXMin, g_OrnamentPosXMax, g_OrnamentPosYMin, 
		g_OrnamentPosYMax,g_OrnamentPosZMin, g_OrnamentPosZMax,
		g_OrnamentPosAdjust = OrnamentsScript:GetOrnamentsInfo(g_ExteriorType, g_CurSelExteriorID, "Pos")

		NewExterior_Headdress_SetItemSelected(nIndex)
		NewExterior_Headdress_UpdateObj()
		NewExterior_Headdress_UpdateLeftBtn()
		NewExterior_Headdress_RemoveTip(g_CurSelExteriorID)
		NewExterior_Headdress_UpdateRedPoint()

		NewExterior_Headdress_UpdateSlider()
	else
		local defExteriorID = OrnamentsScript:GetOrnamentsUseID(g_ExteriorType)
		local X, Y, Z = OrnamentsScript:GetOrnamentsDestPos(g_ExteriorType, defExteriorID)
		Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", defExteriorID, X, Y, Z)
		NewExterior_Headdress_Show()
	end
end

function NewExterior_Headdress_ItemMouseMove(nIndex)

end

function NewExterior_Headdress_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Headdress_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("NewExterior_Headdress_SuperListItemActionTry"):Show()
					if OrnamentsScript:GetOrnamentsUseID(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("NewExterior_Headdress_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("NewExterior_Headdress_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end


function NewExterior_Headdress_TryExterior()
	if Exterior:LuaFnIsHaveExteriorChange() ~= 1 then
		PushDebugMessage("#{WGTJ_201222_72}")
		return
	end
	
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	Exterior:LuaFnSaveExteriorAllChange(1)
end
	
function NewExterior_Headdress_TakeOffRide()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(3)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", 0)
		NewExterior_Headdress_UpdateLeftBtn()
	else
		Exterior:LuaFnSetExteriorInUse(3, 0, 0)
	end
end

function NewExterior_Headdress_TakeOffPoss()
	if Player : GetData("IsOriginalHJ") == 1 then
		PushDebugMessage("#{TSTZ_241223_01}")
		return
	end
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(4)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(4)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_Headdress_UpdateLeftBtn()
		NewExterior_Headdress_UpdateObj()
	else
		Exterior:LuaFnSetExteriorInUse(4, 0, 0)
	end
end

function NewExterior_Headdress_TakeOffWeapon()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorWeaponInUse()
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_WEAPONKIND)
		Exterior:LuaFnUpdateExteriorPlayerData()

		--列表
		NewExterior_Headdress_UpdateList()
		--左侧
		NewExterior_Headdress_UpdateLeftBtn()
		--模型
		NewExterior_Headdress_UpdateObj()
	else
		Exterior:LuaFnSetExteriorWeaponInUse(0, 0)
	end
end

function NewExterior_Headdress_RemovePreview()
	if Exterior:LuaFnIsHaveExteriorChange() == 1 then
		Exterior:LuaFnRemovePlayerExteriorFitting()
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESET")
		Exterior:LuaFnInitCurrentExteriorSet(0)
		NewExterior_Headdress_Show()
		PushDebugMessage("#{WGTJ_201222_98}")
	else
		PushDebugMessage("#{WGTJ_201222_76}")
	end
end

function NewExterior_Headdress_Goto()
	AutoRuntoTargetExWithName(254, 130, 0, "贝师师")
end

function NewExterior_Headdress_CloseClick()
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)	
	NewExterior_Headdress_SetPosition()
	this:Hide()
end

function NewExterior_Headdress_OnHidden()

	if IsWindowShow("Profile_Save") then
		CloseWindow("Profile_Save", true)
	end
	
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_HairStyle")
		or IsWindowShow("NewExterior_PlayerFrame")	
		or IsWindowShow("NewExterior_PetSoul") 
		or IsWindowShow("NewExterior_Weapon")
		or IsWindowShow("NewExterior_Widget") then
	else	
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	end	
	
	NewExterior_Headdress_CleanUp()
end

function NewExterior_Headdress_CleanUp()
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Headdress_SuperListItemAction")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
		end
	end
	
	NewExterior_Headdress_FakeObject:SetFakeObject("")
	
	NewExterior_Headdress_CleanUp_LeftButton()
end

function NewExterior_Headdress_CleanUp_LeftButton()
	
	NewExterior_Headdress_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		NewExterior_Headdress_FaceStyle_LeftBtn,
		NewExterior_Headdress_HairStyle_LeftBtn,
		NewExterior_Headdress_PlayerFrame_LeftBtn,
		NewExterior_Headdress_Ride_LeftBtn,
		NewExterior_Headdress_PetSoul_LeftBtn,
		NewExterior_Headdress_Weapon_LeftBtn,
		NewExterior_Headdress_Widget_LeftBtn,
		NewExterior_Headdress_Headdress_LeftBtn,
	}
	
	for i in pairs(ctrl_list) do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_Headdress_Dress_LeftBtnLuxury:Hide()
	NewExterior_Headdress_Dress_ActionImg:Hide()
	NewExterior_Headdress_FaceStyle_ActionImg:Hide()
	NewExterior_Headdress_HairStyle_ActionImg:Hide()
	NewExterior_Headdress_PlayerFrame_ActionImg:Hide()
	NewExterior_Headdress_Ride_ActionImg:Hide()
	NewExterior_Headdress_PetSoul_ActionImg:Hide()
	NewExterior_Headdress_Weapon_ActionImg:Hide()
	NewExterior_Headdress_Widget_ActionImg:Hide()
	NewExterior_Headdress_Headdress_ActionImg:Hide()

	NewExterior_Headdress_Dress_LockImg:Hide()
	NewExterior_Headdress_FaceStyle_LockImg:Hide()
	NewExterior_Headdress_HairStyle_LockImg:Hide()
	NewExterior_Headdress_PlayerFrame_LockImg:Hide()
	NewExterior_Headdress_Ride_LockImg:Hide()
	NewExterior_Headdress_PetSoul_LockImg:Hide()
	NewExterior_Headdress_Weapon_LockImg:Hide()
	NewExterior_Headdress_Widget_LockImg:Hide()
	NewExterior_Headdress_Headdress_LockImg:Hide()
end

function NewExterior_Headdress_FakeObject_TurnLeft(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		NewExterior_Headdress_FakeObject:RotateBegin(-0.3)
	else
		NewExterior_Headdress_FakeObject:RotateEnd()
	end
end

function NewExterior_Headdress_FakeObject_TurnRight(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
			NewExterior_Headdress_FakeObject:RotateBegin(0.3)
		else
		NewExterior_Headdress_FakeObject:RotateEnd()
	end
end

--缩小
function NewExterior_Headdress_ZoomOut()
	if g_Distance == 1 then
		return
	end

	g_Distance = g_Distance - 1		
	NewExterior_Headdress_UpdateCamera()
end

--放大
function NewExterior_Headdress_ZoomIn()
	if g_Distance == g_Distance_Max then
		return
	end	

	g_Distance = g_Distance + 1	
	NewExterior_Headdress_UpdateCamera()
end

function NewExterior_Headdress_UpdateCamera()
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

function NewExterior_Headdress_Weapon_DoAction(index)	
	local cacheExteriorID,_,_,_ = Exterior:LuaFnGetCurrentExteriorSetInfo(g_Ornaments_Name)
	
	local sex = Player:GetMySex()
	for i = 1, table.getn(g_SpecialWeaponCamera) do
		if g_SpecialWeaponCamera[i][sex] ~= nil and cacheExteriorID >= g_SpecialWeaponCamera[i][sex].startid and cacheExteriorID <= g_SpecialWeaponCamera[i][sex].endid then
			--local fHeight, fDistance, fPitch = NewExterior_Headdress_FakeObject:GetCameraEx()
			local fHeight, fDistance, fPitch = FakeObj_GetCamera("Exterior_Player")
			if g_SpecialWeaponCamera[i][sex].fDistance ~= -1 then
				fDistance = g_SpecialWeaponCamera[i][sex].fDistance
			end
			if g_SpecialWeaponCamera[i][sex].fHeight ~= -1 then
				fHeight = g_SpecialWeaponCamera[i][sex].fHeight
			end
			if g_SpecialWeaponCamera[i][sex].fPitch ~= -1 then
				fPitch = g_SpecialWeaponCamera[i][sex].fPitch
			end
			FakeObj_SetCamera("Exterior_Player", g_CameraHeight, fHeight)
			FakeObj_SetCamera("Exterior_Player", g_CameraDistance, fDistance)
			FakeObj_SetCamera("Exterior_Player", g_CameraPitch, fPitch)

			NewExterior_Headdress_Model_Plus:Disable()
			NewExterior_Headdress_Model_Subtract:Disable()
			NewExterior_Headdress_Model_TurnLeft:Disable()
			NewExterior_Headdress_Model_TurnRight:Disable()
			
			SetTimer("NewExterior_Headdress","NewExterior_Headdress_ActionEnd()", g_SpecialWeaponCamera[i][sex].timecount)
		end		
	end
	
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		Exterior:LuaFnExteriorAvatarPlayAction(3, cacheExteriorID, index - 1)
	end	
end

function NewExterior_Headdress_ActionEnd()
	KillTimer("NewExterior_Headdress_ActionEnd()")
	
	NewExterior_Headdress_Model_Plus:Enable()
	NewExterior_Headdress_Model_Subtract:Enable()
	NewExterior_Headdress_Model_TurnLeft:Enable()
	NewExterior_Headdress_Model_TurnRight:Enable()
	
	NewExterior_Headdress_UpdateCamera()
end

function NewExterior_Headdress_UpdateCheckButton()

end

--右键取下时装
function NewExterior_Headdress_ActionToDressBox()
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		cacheExteriorID = 0
		cacheExteriorIdx = -1
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", cacheExteriorID, cacheExteriorIdx)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(0)			
		NewExterior_Headdress_Show()
		--return
	end
	Exterior:LuaFnUnUseExteriorFashion(1)
end

--时装
function NewExterior_Headdress_OpenFashion()
	NewExterior_Headdress_SavePosition()
	PushEvent("OPEN_EXTERIOR_FASHION", 1, 0)
end

--坐骑
function NewExterior_Headdress_OpenRide()
	NewExterior_Headdress_SavePosition()
	Exterior:LuaFnAskOpenExterior(3)
end

--发型
function NewExterior_Headdress_OpenHair()
	NewExterior_Headdress_SavePosition()	
	Exterior:LuaFnAskOpenExterior(1)
end

--脸型
function NewExterior_Headdress_OpenFace()
	NewExterior_Headdress_SavePosition()	
	Exterior:LuaFnAskOpenExterior(0)
end

--头像
function NewExterior_Headdress_OpenPortrait()
	NewExterior_Headdress_SavePosition()	
	Exterior:LuaFnAskOpenExterior(2)
end

--幻武
function NewExterior_Headdress_OpenWeapon()
	NewExterior_Headdress_SavePosition()	
	Exterior:LuaFnAskOpenExteriorWeapon()
end

--融魂外观
function NewExterior_Headdress_OpenPoss()
	if Player : GetData("IsOriginalHJ") == 1 then
		PushDebugMessage("#{TSTZ_241223_01}")
		return
	end
	NewExterior_Headdress_SavePosition()	
	Exterior:LuaFnAskOpenExterior(4)
end

function NewExterior_Headdress_ActionToOrnamentsBack()
	local useID = OrnamentsScript:GetOrnamentsUseID(0)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(0)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSBACK", 0, 0, 0, 0)
	NewExterior_Headdress_Show()
end

function NewExterior_Headdress_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_Widget", true)
end

function NewExterior_Headdress_SavePosition()
	Variable:SetVariable("ExteriorUnionPos", NewExterior_Headdress_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_Headdress_SetPosition()
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_Headdress_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end
end

function NewExterior_Headdress_RemoveTip(nExteriorID)
	local nTip = OrnamentsScript:GetPlayerOrnamentsTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		OrnamentsScript:RemoveOrnamentsTip(g_ExteriorType, nExteriorID)
		for i = 1, g_MaxBarNum do
			if g_BarList[i] then
				local nID = OrnamentsScript:GetOrnamentsListID(g_ExteriorType, i - 1)
				if OrnamentsScript:RemoveOrnamentsTip(g_ExteriorType, nID) == 1 then
					g_BarList[i]:GetSubItem("NewExterior_Headdress_SuperListItemActionTip"):Show()
				else
					g_BarList[i]:GetSubItem("NewExterior_Headdress_SuperListItemActionTip"):Hide()
				end
			end
		end
	--	NewExterior_Headdress_UpdateCheckButton()		
	end
end

function NewExterior_Headdress_UpdateRedPoint()

	NewExterior_Headdress_Dress_Tip:Hide()
	
	if Exterior:LuaFnIsHaveExteriorShowTip(3) == 1 then
		NewExterior_Headdress_Ride_Tip:Show()
	else
		NewExterior_Headdress_Ride_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(0) == 1 then
		NewExterior_Headdress_FaceStyle_Tip:Show()
	else
		NewExterior_Headdress_FaceStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(1) == 1 or Exterior:LuaFnIsHaveHairColorShowTip() == 1 then
		NewExterior_Headdress_HairStyle_Tip:Show()
	else
		NewExterior_Headdress_HairStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(2) == 1 then
		NewExterior_Headdress_PlayerFrame_Tip:Show()
	else
		NewExterior_Headdress_PlayerFrame_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(4) == 1 then
		NewExterior_Headdress_PetSoul_Tip:Show()
	else
		NewExterior_Headdress_PetSoul_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorWeaponShowTip() == 1 then
		NewExterior_Headdress_Weapon_Tip:Show()
	else
		NewExterior_Headdress_Weapon_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(0) == 1 then
		NewExterior_Headdress_Widget_Tip:Show()
	else
		NewExterior_Headdress_Widget_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(1) == 1 then
		NewExterior_Headdress_Headdress_Tip:Show()
	else
		NewExterior_Headdress_Headdress_Tip:Hide()
	end
end

function NewExterior_Headdress_ShowDressShareButton()
	NewExterior_Headdress_ShareBtn:Show()	
end

function NewExterior_Headdress_Share_Clicked()
	local ret = Exterior:LuaFnExteriorPlayerShareClick(0)
	return ret	
end

function NewExterior_Headdress_SaveChange_Clicked()	
	local ret = Exterior:LuaFnExteriorPlayerOpenSharePlan()
	return ret	
end

-- 显示显隐按钮
function NewExterior_Headdress_ShowOrnamentsBackCheckButton()
	local IsDisplay = OrnamentsScript:GetOrnamentsDisplayState(1)
	NewExterior_Headdress_Type:SetCheck(IsDisplay)
end

function NewExterior_Headdress_OrnamentsBackDisplay()
	local IsDisplay = OrnamentsScript:GetOrnamentsDisplayState(1)
	if IsDisplay == 1 then
		NewExterior_Headdress_Type:SetCheck(0)
		SystemSetup:SetOrnamentsDisplayState(1, 1)
		OrnamentsScript:ResetOrnamentsUseInfo(1)
		Exterior:LuaFnUpdateExteriorPlayerData()
	else
		NewExterior_Headdress_Type:SetCheck(1)
		SystemSetup:SetOrnamentsDisplayState(1, 0)
		Exterior:LuaFnUpdateExteriorPlayerData()
	end	
end

function NewExterior_Headdress_Position_Change()
	--PushDebugMessage("NewExterior_Headdress_Position_Change")
	if g_CurSelExteriorID < 0 then
		return
	end

	if g_TextChange > 0 then
		g_TextChange = g_TextChange - 1
		return
	end

	g_TextChange = 0

	local curXTest = NewExterior_Headdress_X_Input : GetText()
	local curX = 0
	if curXTest ~= "" then
		curX = tonumber(curXTest)
	end

	local curYTest = NewExterior_Headdress_Y_Input : GetText()
	local curY = 0
	if curYTest ~= "" then
		curY = tonumber(curYTest)
	end


	local curZTest = NewExterior_Headdress_Z_Input : GetText()
	local curZ = 0
	if curZTest ~= "" then
		curZ = tonumber(curZTest)
	end

	local cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsHead")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		if curX < g_OrnamentPosXMin or curX > g_OrnamentPosXMax then
			local strTip = ScriptGlobal_Format("#{BGTS_220125_45}", g_OrnamentPosXMin, g_OrnamentPosXMax)
			PushDebugMessage(strTip)
			curX = cacheExteriorX
			NewExterior_Headdress_X_Input:SetTextOriginal(tostring(curX))
		end
		if curY < g_OrnamentPosYMin or curY > g_OrnamentPosYMax then
			local strTip = ScriptGlobal_Format("#{BGTS_220125_46}", g_OrnamentPosYMin, g_OrnamentPosYMax)
			PushDebugMessage(strTip)
			curY = cacheExteriorY
			NewExterior_Headdress_Y_Input:SetTextOriginal(tostring(curY))
		end

		if curZ < g_OrnamentPosZMin or curZ > g_OrnamentPosZMax then
			local strTip = ScriptGlobal_Format("#{BGTS_220125_47}", g_OrnamentPosZMin, g_OrnamentPosZMax)
			PushDebugMessage(strTip)
			curZ = cacheExteriorZ
			NewExterior_Headdress_Z_Input:SetTextOriginal(tostring(curZ))
		end
	end

	NewExterior_Headdress_CalSliderChange(curX, curY, curZ)

	NewExterior_Headdress_X:SetPosition(curX)
	NewExterior_Headdress_Y:SetPosition(curY)
	NewExterior_Headdress_Z:SetPosition(curZ)

	g_CurSelExteriorX = curX
	g_CurSelExteriorY = curY
	g_CurSelExteriorZ = curZ
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", g_CurSelExteriorID, g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ)
	Exterior:LuaFnUpdateOrnamentsFashion(g_ExteriorType, g_CurSelExteriorID, g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ)
end

function NewExterior_Headdress_SliderChanged()

	if g_CurSelExteriorID <= 0 then
		return
	end

	if g_SliderChange > 0 then
		g_SliderChange = g_SliderChange - 1
		return
	end

	g_SliderChange = 0
	g_TextChange = 3

	local curX = math.floor (NewExterior_Headdress_X :GetPosition() + 0.5) 
	if curX < 1 then curX = 1 end
	NewExterior_Headdress_X_Input : SetText(curX)
	
	local curY = math.floor (NewExterior_Headdress_Y :GetPosition() + 0.5)
	if curY < 1 then curY = 1 end
	NewExterior_Headdress_Y_Input : SetText(curY)

	local curZ = math.floor (NewExterior_Headdress_Z :GetPosition() + 0.5)
	if curZ < 1 then curZ = 1 end
	NewExterior_Headdress_Z_Input : SetText(curZ)

	g_CurSelExteriorX = curX
	g_CurSelExteriorY = curY
	g_CurSelExteriorZ = curZ
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", g_CurSelExteriorID, g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ)
	Exterior:LuaFnUpdateOrnamentsFashion(g_ExteriorType, g_CurSelExteriorID, g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ)
end


function NewExterior_Headdress_SavePosition_OnClick()
	if g_CurSelExteriorID <= 0 then
		return
	end

	local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(g_ExteriorType, g_CurSelExteriorID, 0)

	if nIdx > 0 and (nState == g_OrnamentState.TIME or nState == g_OrnamentState.FOREVER ) then
		local bOk = 1
		local curX = g_OrnamentPosXMax + g_OrnamentPosXMax
		local curXTest = NewExterior_Headdress_X_Input : GetText()
		if curXTest ~= "" then
			curX = tonumber(curXTest)
		end
		if curX < g_OrnamentPosXMin or curX > g_OrnamentPosXMax then
			local strTip = ScriptGlobal_Format("#{BGTS_220125_45}", g_OrnamentPosXMin, g_OrnamentPosXMax)
			PushDebugMessage(strTip)
			bOk = 0
		end

		local curY = g_OrnamentPosYMax + g_OrnamentPosYMax
		local curYTest = NewExterior_Headdress_Y_Input : GetText()
		if curYTest ~= "" then
			curY = tonumber(curYTest)
		end
		if curY < g_OrnamentPosYMin or curY > g_OrnamentPosYMax then
			local strTip = ScriptGlobal_Format("#{BGTS_220125_46}", g_OrnamentPosYMin, g_OrnamentPosYMax)
			PushDebugMessage(strTip)
			bOk = 0
		end

		local curZ = g_OrnamentPosZMax + g_OrnamentPosZMax
		local curZTest = NewExterior_Headdress_Z_Input : GetText()
		if curZTest ~= "" then
			curZ = tonumber(curZTest)
		end
		if curZ < g_OrnamentPosZMin or curZ > g_OrnamentPosZMax then
			local strTip = ScriptGlobal_Format("#{BGTS_220125_47}", g_OrnamentPosZMin, g_OrnamentPosZMax)
			PushDebugMessage(strTip)
			bOk = 0
		end

		if bOk > 0 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "ChangeOrnamentsPos" )
				Set_XSCRIPT_ScriptID( 999361 )
				Set_XSCRIPT_Parameter( 0, g_ExteriorType )
				Set_XSCRIPT_Parameter( 1, g_CurSelExteriorID )
				Set_XSCRIPT_Parameter( 2, curX )
				Set_XSCRIPT_Parameter( 3, curY )
				Set_XSCRIPT_Parameter( 4, curZ )
				Set_XSCRIPT_ParamCount( 5 )
			Send_XSCRIPT()
		else
			NewExterior_Headdress_ResetPosition()
		end
	else
		PushDebugMessage("#{BGTS_220125_48}")
		return
	end

end

function NewExterior_Headdress_ResetPosition()
	if g_CurSelExteriorID <= 0 then
		return
	end

	g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ = OrnamentsScript:GetOrnamentsDestPos(g_ExteriorType, g_CurSelExteriorID)
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", g_CurSelExteriorID, g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ)
	--Exterior:LuaFnSetCurExteriorShareInfo(g_Ornaments_Name, g_CurSelExteriorID, g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ)
	Exterior:LuaFnUpdateOrnamentsFashion(g_ExteriorType, g_CurSelExteriorID, g_CurSelExteriorX, g_CurSelExteriorY, g_CurSelExteriorZ)
	NewExterior_Headdress_UpdateSlider()
end

function NewExterior_Headdress_CalSliderChange(x, y, z)
	g_SliderChange = 0
	local curX = NewExterior_Headdress_X :GetPosition()
	local curY = NewExterior_Headdress_Y :GetPosition()
	local curZ = NewExterior_Headdress_Z :GetPosition()
	if curX ~= x then
		g_SliderChange = g_SliderChange + 1
	end
	if curY ~= y then
		g_SliderChange = g_SliderChange + 1
	end
	if curZ ~= z then
		g_SliderChange = g_SliderChange + 1
	end
end

function NewExterior_Headdress_AdjustUIShow()
	if g_OrnamentPosAdjust > 0 then
		NewExterior_Headdress_X:Enable()
		NewExterior_Headdress_Y:Enable()
		NewExterior_Headdress_Z:Enable()
		NewExterior_Headdress_X_Input:Enable()
		NewExterior_Headdress_Y_Input:Enable()
		NewExterior_Headdress_Z_Input:Enable()
		--NewExterior_Headdress_XYZ_Btn_L:Enable()
		--NewExterior_Headdress_XYZ_Btn_R:Enable()
		-- 对tipsUI进行显隐处理
		NewExterior_Headdress_XYZ_Mask:Hide()
	else
		NewExterior_Headdress_X:Disable()
		NewExterior_Headdress_Y:Disable()
		NewExterior_Headdress_Z:Disable()
		NewExterior_Headdress_X_Input:Disable()
		NewExterior_Headdress_Y_Input:Disable()
		NewExterior_Headdress_Z_Input:Disable()
		--NewExterior_Headdress_XYZ_Btn_L:Disable()
		--NewExterior_Headdress_XYZ_Btn_R:Disable()
		-- 对tipsUI进行显隐处理
		NewExterior_Headdress_XYZ_Mask:Show()
	end
	NewExterior_Headdress_XYZ_Mask:SetToolTip("#{BGTS_220125_63}")
end

function NewExterior_Headdress_OpenWidget()
	NewExterior_Headdress_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(0)
end

function NewExterior_Headdress_OpenOrnamentsHead()
end

function NewExterior_Headdress_ActionToOrnamentsHead()
	local useID = OrnamentsScript:GetOrnamentsUseID(1)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(1)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", 0, 0, 0, 0)
	NewExterior_Headdress_Show()
end
--!!!reloadscript =NewExterior_Headdress