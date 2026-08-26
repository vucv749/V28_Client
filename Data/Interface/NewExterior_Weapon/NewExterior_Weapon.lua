--!!!reloadscript =NewExterior_Weapon
local g_NewExterior_Weapon_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 0
local g_TargetExteriorIndex = 0			--???????,?1??
local g_TargetExteriorID = 0			--?????ID

local g_CurSelExteriorID = 0			--???????ID,?1??

local g_CurWeaponLevel = 0

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 4 --????
local g_MaxBarNum = 0
local g_BarList = {}

local g_NeedChangeScrollSize = 1

local g_CameraHeight = 1     --?????
local g_CameraDistance = 2   --?????
local g_CameraPitch = 3      --?????
local g_CameraPosition =
{
	--≈Æ–‘œ‡πÿŒª÷√
	[0] = 
	{
		{fHeight = 0.82, fDistance = 8, fPitch=0.1},
		{fHeight = 0.82, fDistance = 6.5, fPitch=0.1},
		{fHeight = 1.5, fDistance = 2.5, fPitch=0.10},
		{fHeight = 1.57, fDistance = 1.7, fPitch=0.10}
	},
	--ƒ––‘œ‡πÿŒª÷√
	[1] = 
	{
		{fHeight = 0.91, fDistance = 8.8, fPitch=0.2},
		{fHeight = 0.91, fDistance = 7.1, fPitch=0.2},
		{fHeight = 1.67, fDistance = 2.5, fPitch=0.2},
		{fHeight = 1.745, fDistance = 1.7, fPitch=0.2}
	},
}

local g_SpecialWeaponCamera = {
 [1] = {	-- ?????
			[0] = {startid = 31, endid = 31, fHeight = 1.25, fDistance = 23, fPitch = -1, timecount = 17280},
			[1] = {startid = 31, endid = 31, fHeight = 1.25, fDistance = 23, fPitch = -1, timecount = 17280},
 		},
 [2] = {	-- ????
			[0] = {startid = 32, endid = 32, fHeight = 1.25, fDistance = 24, fPitch = 0.5, timecount = 10000},
			[1] = {startid = 32, endid = 32, fHeight = 1.25, fDistance = 24, fPitch = 0.5, timecount = 10000},
 		},
[3] =  {	-- ????
			[0] = {startid = 33, endid = 33, fHeight = 1.25, fDistance = 16, fPitch = -1, timecount = 7400},
			[1] = {startid = 33, endid = 33, fHeight = 1.25, fDistance = 18, fPitch = -1, timecount = 7400},
		},
[4] = {	-- ???
			[0] = {startid = 28, endid = 28, fHeight = 1.25, fDistance = 16, fPitch = -1, timecount = 6800},
			[1] = {startid = 28, endid = 28, fHeight = 1.25, fDistance = 18, fPitch = -1, timecount = 6800},
		},
-- ªÏÃÏ–˛Í™
[5] = {	
			[0] = {startid = 29, endid = 29, fHeight = 1.25, fDistance = 16, fPitch = -1, timecount = 6800},
			[1] = {startid = 29, endid = 29, fHeight = 1.25, fDistance = 18, fPitch = -1, timecount = 6800},
		},
-- ¿«—Ã¬“
[6] = {	
			[0] = {startid = 41, endid = 41, fHeight = 1.25, fDistance = 16, fPitch = -1, timecount = 6000},
			[1] = {startid = 41, endid = 41, fHeight = 1.25, fDistance = 18, fPitch = -1, timecount = 6000},
		},
-- ∂œ¿Î≥Ó
[7] = {	
			[0] = {startid = 40, endid = 40, fHeight = 1.25, fDistance = 16, fPitch = -1, timecount = 7160},
			[1] = {startid = 40, endid = 40, fHeight = 1.25, fDistance = 18, fPitch = -1, timecount = 7160},
		},
-- »˝«ß‘¬œ‡
[8] = {	
			[0] = {startid = 39, endid = 39, fHeight = 1.25, fDistance = 10, fPitch = -1, timecount = 9280},
			[1] = {startid = 39, endid = 39, fHeight = 1.25, fDistance = 12, fPitch = -1, timecount = 9280},
		},
}

local g_RankButtons = {}
local g_QualStr = {"#{SHRH_20220427_06}", "#{SHRH_20220427_05}", "#{SHRH_20220427_04}"}

local g_strRank = {
	"#{SHRH_20220427_15}",
	"#{SHRH_20220427_16}",
	"#{SHRH_20220427_17}",
	"#{SHRH_20220427_18}",
	"#{SHRH_20220427_19}",
	"#{SHRH_20220427_20}",
}

local g_PetSoulLevelLimit = 85
local EXTERIORFILTTING_WEAPONKIND = 5

local g_OrnamentState				= {		-- ??
	INVALID	= 0,							-- ??
	EMPTY	= 1,							-- ??
	TIME	= 2,							-- ??
	TIMEOUT	= 3,							-- ??
	FOREVER	= 4,							-- ??
}
--=========
--PreLoad==
--=========
function NewExterior_Weapon_PreLoad()
	this:RegisterEvent("OPEN_EXTERIOR_WEAPON")
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
	this:RegisterEvent("UI_COMMAND")
end

--=========
--OnLoad
--=========
function NewExterior_Weapon_OnLoad()
	g_NewExterior_Weapon_UnifiedPosition = NewExterior_Weapon_Frame:GetProperty("UnifiedPosition")
	
	g_RankButtons[1] = NewExterior_Weapon_Level1
	g_RankButtons[2] = NewExterior_Weapon_Level2
	g_RankButtons[3] = NewExterior_Weapon_Level3
	g_RankButtons[4] = NewExterior_Weapon_Level4
end
--=========
--OnEvent
--=========
function NewExterior_Weapon_OnEvent(event)
	if event == "UI_COMMAND" then
		local cmdId = tonumber(arg0) or 0
		if cmdId >= 88888880 and cmdId <= 88888899 then
			local str0 = Get_XParam_STR(0) or ""
			if str0 == "" then
				return
			end
			local result = LuaFnApplyExtWeaponBatch(str0)
			if result >= 0 then
				PushEvent("UPDATE_EXTERIOR_WEAPON")
			end
			return
		end
	end
	
	if event == "OPEN_EXTERIOR_WEAPON" then
		if this:IsVisible() then
			if tonumber(arg1) == 0 then
				NewExterior_Weapon_SavePosition()
				this:Hide()
			end
		else
			NewExterior_Weapon_SetPosition()
			NewExterior_Weapon_CloseSameGroupWindow()
			this:Show()
			NewExterior_Weapon_Show()
		end

		return
	end
		
	if event == "OPEN_STALL_SALE" -- ????,????
		or event == "PROGRESSBAR_SHOW"	-- ?????,????
		or event == "MODELID_CHANGE" -- ?? ????
		then
		NewExterior_Weapon_CloseClick()
		return
	end
	
	if event == "EXERIOR_SAVEALL_RET" then
		if not this:IsVisible() then
			return
		end

		Exterior:LuaFnSetCurrentExteriorSetInfo("RESETEX")
		Exterior:LuaFnInitCurrentExteriorSetExceptFashion(0)
		NewExterior_Weapon_Show()
	end
	
	if event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if not this:IsVisible() then
			return
		end
		--◊Û≤‡
		NewExterior_Weapon_UpdateLeftBtn()
		NewExterior_Weapon_UpdateRedPoint()
		--∏¸–¬“ªœ¬ƒ£–Õ
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
	
	if event == "ADD_EXTERIOR_WEAPON" or event == "UPDATE_EXTERIOR_WEAPON" or event == "EXTERIOR_OUTTIME_WEAPON" or event == "DEF_EXTERIOR_WEAPON_CHANGED" then
		if not this:IsVisible() then
			return
		end

		NewExterior_Weapon_Show()
		return
	end
	
	if event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		if not this:IsVisible() then
			return
		end

		NewExterior_Weapon_Show()
		return
	end
	
	if event == "EXTERIOR_POSS_VISUAL_INDEX" or event == "EXTERIOR_HAIR_COLOR_INDEX" then
		if not this:IsVisible() then
			return
		end

		--◊Û≤‡
		NewExterior_Weapon_UpdateLeftBtn()
		NewExterior_Weapon_UpdateRedPoint()
		--∏¸–¬“ªœ¬ƒ£–Õ
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
	
	if event == "UPDATE_EXTERIOR_FASHION" then
		if not this:IsVisible() then
			return
		end

		if tonumber(arg0) == 1 then
			--◊Û≤‡
			NewExterior_Weapon_UpdateLeftBtn()
			--∏¸–¬“ªœ¬ƒ£–Õ
			Exterior:LuaFnUpdateExteriorPlayerData()
		end
		return
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			this:Hide()
		end
	end
	
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ or ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_Weapon_Frame:SetProperty("UnifiedPosition", g_NewExterior_Weapon_UnifiedPosition)
	end
	
		-- FakeObjectƒ£–ÕΩÁ√Êª•≥‚
	if ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then   --????
		if (this:IsVisible()) then
			this:Hide()
			return
		end
	end		

	if event == "ORNAMENTS_DISPLAYUPDATE" then
		-- À¢–¬ƒ£–Õ
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
end

function NewExterior_Weapon_InitList()
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetExteriorWeaponMaxCount()
		for i = 1, g_MaxBarNum do
			local bar = NewExterior_Weapon_SuperList:AddChild("NewExterior_Weapon_SuperListItem")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("NewExterior_Weapon_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("NewExterior_Weapon_ItemClicked(%d)", i))
			bar:GetSubItem("NewExterior_Weapon_SuperListItemAction"):SetEvent("MouseMove", string.format("NewExterior_Weapon_ItemMouseMove(%d)", i))
			bar:GetSubItem("NewExterior_Weapon_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("NewExterior_Weapon_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		end		
		g_InitList = 1
	end
end

function NewExterior_Weapon_Show()
	
	g_Distance = g_Distance_Ori
	g_NeedChangeScrollSize = 1
				
	EXTERIORFILTTING_TOTALKIND = Exterior:LuaFnGetExteriorPlayerFittingCount()
	
	NewExterior_Weapon_InitList()
	
	NewExterior_Weapon_CleanUp()
	
	NewExterior_Weapon_FakeObject:SetFakeObject("Exterior_Player")
	Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
	Exterior:LuaFnUpdateExteriorPlayerData()
	
	g_CurSelExteriorID = 0
	g_CurWeaponLevel = 0
	
	local cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID > 0 then
		g_TargetExteriorID = cacheExteriorID
		g_CurSelExteriorID = cacheExteriorID
		
		g_CurWeaponLevel = cacheWeaponLevel + 1
	end
	
	NewExterior_Weapon_UpdateList()
	
	NewExterior_Weapon_UpdateLeftBtn()
	
	NewExterior_Weapon_UpdateObj()
	
	NewExterior_Weapon_RemoveTip(g_CurSelExteriorID)

	NewExterior_Weapon_UpdateRedPoint()
	
	NewExterior_Weapon_UpdateRankButton()
	
	NewExterior_Weapon_ShowDressShareButton()
end

function NewExterior_Weapon_UpdateLeftBtn()
	
	NewExterior_Weapon_CleanUp_LeftButton()
	
	local sex = Player:GetMySex()
	
	-- ±◊∞
	local nFashionId = -1
	NewExterior_Weapon_Dress_LeftBtn:SetActionItem(-1)
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, cacheExteriorIdx)
		if theAction:GetID() ~= 0 then
			NewExterior_Weapon_Dress_LeftBtn:SetActionItem(theAction:GetID())
			NewExterior_Weapon_Dress_ActionImg:Show()
			
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 and nCurFashionIdx == cacheExteriorIdx then
				NewExterior_Weapon_Dress_ActionImg:Hide()
			end
			
			nFashionId = cacheExteriorID
		end
	else
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
		if cacheExteriorIdx ~= nil and cacheExteriorIdx >= 0 then
			local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(cacheExteriorIdx)
			if theAction:GetID() ~= 0 then
				NewExterior_Weapon_Dress_LeftBtn:SetActionItem(theAction:GetID())
				NewExterior_Weapon_Dress_ActionImg:Show()
				
				local nCurFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 and nCurFashionIdx == cacheExteriorIdx then
					NewExterior_Weapon_Dress_ActionImg:Hide()
				end
				
				nFashionId = cacheExteriorID
			end
		else
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 then
				local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(1, nCurFashionIdx)
				if theAction:GetID() ~= 0 then
					NewExterior_Weapon_Dress_LeftBtn:SetActionItem(theAction:GetID())
					
					nFashionId = nCurFashionId
				end
			else
				local nCurFashionIdx, nCurFashionId = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 then
					local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(nCurFashionIdx)
					if theAction:GetID() ~= 0 then
						NewExterior_Weapon_Dress_LeftBtn:SetActionItem(theAction:GetID())
						
						nFashionId = nCurFashionId
					end
				end
			end			
		end	
	end
		
	NewExterior_Weapon_Dress_LeftBtnLuxury:Hide()
	if nFashionId ~= -1 then	
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nFashionId, "Number")
		if nFashionNumber ~= nil and nFashionNumber > 0 then
			NewExterior_Weapon_Dress_LeftBtnLuxury:Show()
		end
	end
	
	--◊¯∆Ô
	local edType = 3
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		NewExterior_Weapon_Ride_LeftBtn:SetToolTip(strTemp)
		-- ‘¥©
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Weapon_Ride_ActionImg:Show()
		end
		--Œ¥º§ªÓ
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Weapon_Ride_LockImg:Show()
		end
	end
	
	--¡≥–Õ
	edType = 0
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_82}", strName)
		NewExterior_Weapon_FaceStyle_LeftBtn:SetToolTip(strTemp)	
		-- ‘¥©
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Weapon_FaceStyle_ActionImg:Show()
		end
		--Œ¥º§ªÓ
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Weapon_FaceStyle_LockImg:Show()
		end
	end
	
	--∑¢–Õ
	edType = 1
	cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_81}", strName)
		NewExterior_Weapon_HairStyle_LeftBtn:SetToolTip(strTemp)
		-- ‘¥©
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Weapon_HairStyle_ActionImg:Show()
		else
			if Exterior:LuaFnGetExteriorHairColorIndex() ~= cacheColorIndex then
			NewExterior_Weapon_HairStyle_ActionImg:Show()
		end
	end
		--Œ¥º§ªÓ
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Weapon_HairStyle_LockImg:Show()
		end
	end
	
	--Õ∑œÒ
	edType = 2
	local strHeadTip = ""
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("PORTRAIT")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_79}", strName)
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetToolTip(strTemp)
		strHeadTip = strTemp
		-- ‘¥©
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_Weapon_PlayerFrame_ActionImg:Show()
		end
		--Œ¥º§ªÓ
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Weapon_PlayerFrame_LockImg:Show()
		end
	end
	
	--ª√Œ‰
	local cacheWeaponLevel = 0
	cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{HSWQ_20220607_02}", strName, tostring(cacheWeaponLevel + 1))
		NewExterior_Weapon_Weapon_LeftBtn:SetToolTip(strTemp)
	
		-- ‘¥©
		if Exterior:LuaFnGetExteriorWeaponInUse() ~= cacheExteriorID or cacheWeaponLevel ~= Exterior:LuaFnGetExteriorWeaponLevel() then
			NewExterior_Weapon_Weapon_ActionImg:Show()
		end
		--Œ¥º§ªÓ
		if Exterior:LuaFnIsHaveExteriorWeapon(cacheExteriorID) ~= 1 then
			NewExterior_Weapon_Weapon_LockImg:Show()
		end
	end
	
	--»⁄ªÍÕ‚π€
	local player_level = Player:GetData("LEVEL")
	if player_level < g_PetSoulLevelLimit then
		NewExterior_Weapon_PetSoul_LeftCheckBtn:Hide()
	else
		NewExterior_Weapon_PetSoul_LeftCheckBtn:Show()
	end
	
	edType = 4
	local strPossTip = ""
	local cachePossVisualIndex = 0
	cacheExteriorID, cachePossVisualIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{SHRH_20220427_64}", strName)
		NewExterior_Weapon_PetSoul_LeftBtn:SetToolTip(strTemp)
		
		-- ‘¥©
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID or cachePossVisualIndex ~= Exterior:LuaFnGetExteriorPossVisualIndex() then
			NewExterior_Weapon_PetSoul_ActionImg:Show()
		end
		--Œ¥º§ªÓ
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_Weapon_PetSoul_LockImg:Show()
		end
	end

	-- ±≥ Œ
	local edOrnamentsType, cacheExteriorX, cacheExteriorY, cacheExteriorZ = 0,0,0,0
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsBack")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Weapon_Widget_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_Widget_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_Weapon_Widget_LeftBtn:SetToolTip(strTemp)
		-- ‘¥©
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_Weapon_Widget_ActionImg:Show()
		end
		--Œ¥º§ªÓ
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_Weapon_Widget_LockImg:Show()
		end
	end
	-- Õ∑ Œ
	edOrnamentsType = 1
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsHead")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_Weapon_Widget_Headdress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_Widget_Headdress_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_Weapon_Widget_Headdress_LeftBtn:SetToolTip(strTemp)
		-- ‘¥©
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_Weapon_Widget_Headdress_ActionImg:Show()
		end
		--Œ¥º§ªÓ
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_Weapon_Widget_Headdress_LockImg:Show()
		end
	end
end

function NewExterior_Weapon_UpdateList()
	
	NewExterior_Weapon_UpdateRedPoint()
	
	Exterior:LuaFnInitExteriorWeaponList()
	local count = Exterior:LuaFnGetExteriorWeaponListCount()
	
	for i = 1, g_MaxBarNum do	
		NewExterior_Weapon_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		NewExterior_Weapon_SuperList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	if g_TargetExteriorIndex ~= 0 then
		NewExterior_Weapon_SuperList:SetScrollPosition4Index(g_TargetExteriorIndex - 1)
		g_TargetExteriorID = 0
		g_TargetExteriorIndex = 0
	else
		NewExterior_Weapon_SuperList:SetScrollPosition4Index(0)
	end
end

function NewExterior_Weapon_SetItem(index, max_count)
	
	if g_BarList[index] == nil then
		return
	end
	
	if index > max_count then
		g_BarList[index]:Hide()
		return
	end
	
	local bar = g_BarList[index]
	bar:Show()
	
	local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(index - 1)
	local strName = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Name")
	local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Icon")
	local strImage = GetIconFullName(strIcon)
	
	local iQual = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Quality")
	local iWeaponTypeLimit = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "WeaponTypeLimit")
	
	local ctrlAction = bar:GetSubItem("NewExterior_Weapon_SuperListItemAction")
	if ctrlAction ~= nil then
	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		local strTip = Exterior:LuaFnGetExteriorWeaponToolTip(nExteriorID)
		ctrlAction:SetToolTip(strTip)
		
		if g_CurSelExteriorID == nExteriorID then
			ctrlAction:SetPushed(1)
			bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTry"):Show()
			if Exterior:LuaFnGetExteriorWeaponInUse() == nExteriorID then
				bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTry"):Hide()
			end
		else
			ctrlAction:SetPushed(0)
			bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTry"):Hide()
		end
			
		if g_TargetExteriorID == nExteriorID then
			g_TargetExteriorIndex = index
		end
			
		if g_TargetExteriorID == nExteriorID then
			g_TargetExteriorIndex = index
		end
	end

	bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTime"):Hide()	
	bar:GetSubItem("NewExterior_Weapon_SuperListItemActionMark"):Hide()
	
	--Ω‚À¯&œﬁ ±±Í÷æ
	if Exterior:LuaFnIsHaveExteriorWeapon(nExteriorID) == 1 then
		bar:GetSubItem("NewExterior_Weapon_SuperListItemActionLock"):Hide()
		local nLeftTime = Exterior:LuaFnGetExteriorWeaponLeftTime(nExteriorID)
		if nLeftTime and nLeftTime < 0 then
			bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTime"):Hide()
		elseif nLeftTime and nLeftTime == 0 then
			bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTime"):Show()
		elseif nLeftTime and nLeftTime > 0 then
			bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTime"):Show()
		end
	else
		bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTime"):Hide()
		bar:GetSubItem("NewExterior_Weapon_SuperListItemActionLock"):Show()
	end
	
	-- π”√÷–
	if Exterior:LuaFnGetExteriorWeaponInUse() == nExteriorID then
		bar:GetSubItem("NewExterior_Weapon_SuperListItemActionDef"):Show()
	else
		bar:GetSubItem("NewExterior_Weapon_SuperListItemActionDef"):Hide()
	end
	
	--∫Ïµ„
	local nTip = Exterior:LuaFnGetExteriorWeaponTip(nExteriorID)
	if nTip == 1 then
		bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTip"):Show()
	else
		bar:GetSubItem("NewExterior_Weapon_SuperListItemActionTip"):Hide()
	end

	bar:GetSubItem("NewExterior_Weapon_SuperListItemActionButton"):Hide()
	local maxLevel = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "MaxLevel")
	for i = 0, maxLevel do
		local ActionNum = Exterior:LuaFnGetExteriorWeaponActionNum(nExteriorID, i)
		if ActionNum > 0 then
			bar:GetSubItem("NewExterior_Weapon_SuperListItemActionButton"):Show()
			break
		end
	end

end

function NewExterior_Weapon_UpdateObj()
	local cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID ~= nil and cacheExteriorID >= 0 then
		Exterior:LuaFnUpdateExteriorPlayerData()	
		NewExterior_Weapon_MidClient1:Hide()
		NewExterior_Weapon_MidClient2:Hide()
		NewExterior_Weapon_MidClient3:Hide()
		local ActionNum = Exterior:LuaFnGetExteriorWeaponActionNum(cacheExteriorID, g_CurWeaponLevel - 1)
		
		if ActionNum == 1 then
			NewExterior_Weapon_MidClient1:Show()
		elseif ActionNum == 2 then
			NewExterior_Weapon_MidClient2:Show()		
		elseif ActionNum == 3 then
			NewExterior_Weapon_MidClient3:Show()
		end	
	else
		NewExterior_Weapon_MidClient1:Hide()
		NewExterior_Weapon_MidClient2:Hide()
		NewExterior_Weapon_MidClient3:Hide()	
	end	
	NewExterior_Weapon_ActionEnd()
	NewExterior_Weapon_UpdateCamera()
end

function NewExterior_Weapon_ItemClicked(nIndex)
	local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(nIndex - 1)	
	if g_CurSelExteriorID ~= nExteriorID then
		g_CurSelExteriorID = nExteriorID
		local iLevel = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "LEVEL")
		if iLevel == nil then
		g_CurWeaponLevel = 1
		else
			g_CurWeaponLevel = iLevel + 1
		end
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", g_CurSelExteriorID, g_CurWeaponLevel - 1)
		NewExterior_Weapon_UpdateRankButton()
		NewExterior_Weapon_SetItemSelected(nIndex)
		NewExterior_Weapon_UpdateObj()
		NewExterior_Weapon_UpdateLeftBtn()
		NewExterior_Weapon_RemoveTip(g_CurSelExteriorID)
		NewExterior_Weapon_UpdateRedPoint()
	else
		local defExteriorID = Exterior:LuaFnGetExteriorWeaponInUse()
		local defWeaponLevel = Exterior:LuaFnGetExteriorWeaponLevel()
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", defExteriorID, defWeaponLevel)
		NewExterior_Weapon_Show()
	end
end

function NewExterior_Weapon_ItemMouseMove(nIndex)

end

function NewExterior_Weapon_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Weapon_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("NewExterior_Weapon_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("NewExterior_Weapon_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("NewExterior_Weapon_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function NewExterior_Weapon_RankClicked(index)
	if g_CurSelExteriorID == 0 then
		NewExterior_Weapon_UpdateRankButton()
		return
	end
	if g_CurWeaponLevel ~= index then
		g_CurWeaponLevel = index
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", g_CurSelExteriorID, g_CurWeaponLevel - 1)
		NewExterior_Weapon_UpdateRankButton()
		
		NewExterior_Weapon_UpdateObj()
		NewExterior_Weapon_UpdateLeftBtn()
	end
end

function NewExterior_Weapon_UpdateRankButton()
	if g_CurSelExteriorID == 0 then
		for i = 1, 4 do
			g_RankButtons[i]:Show()
			g_RankButtons[i]:SetCheck(0)
			g_RankButtons[i]:Disable()
		end	
	else
		local maxLevel = Exterior:LuaFnGetExteriorWeaponInfo(g_CurSelExteriorID, "MaxLevel")
		for i = 1, 4 do
			if i <= maxLevel then
				g_RankButtons[i]:Show()
				g_RankButtons[i]:Enable()
				if i == g_CurWeaponLevel then
					g_RankButtons[i]:SetCheck(1)
				else
					g_RankButtons[i]:SetCheck(0)
				end
			else
				g_RankButtons[i]:Hide()
			end
		end
	end
end

function NewExterior_Weapon_TryExterior()
	if Exterior:LuaFnIsHaveExteriorChange() ~= 1 then
		PushDebugMessage("#{WGTJ_201222_72}")
		return
	end
	
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	Exterior:LuaFnSaveExteriorAllChange(1)
end
	
function NewExterior_Weapon_TakeOffRide()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(3)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", 0)
		NewExterior_Weapon_UpdateLeftBtn()
	else
		Exterior:LuaFnSetExteriorInUse(3, 0, 0)
	end
end

function NewExterior_Weapon_TakeOffPoss()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(4)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(4)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_Weapon_UpdateLeftBtn()
		NewExterior_Weapon_UpdateObj()
	else
		Exterior:LuaFnSetExteriorInUse(4, 0, 0)
	end
end

function NewExterior_Weapon_TakeOffWeapon()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorWeaponInUse()
	if defExteriorID == 0 then
		g_CurSelExteriorID = 0
		g_CurWeaponLevel = 0
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_WEAPONKIND)
		Exterior:LuaFnUpdateExteriorPlayerData()
		
		NewExterior_Weapon_UpdateRankButton()
		--¡–±Ì
		NewExterior_Weapon_UpdateList()
		--◊Û≤‡
		NewExterior_Weapon_UpdateLeftBtn()
		--ƒ£–Õ
		NewExterior_Weapon_UpdateObj()
	else
		Exterior:LuaFnSetExteriorWeaponInUse(0, 0)
	end
end

function NewExterior_Weapon_RemovePreview()
	if Exterior:LuaFnIsHaveExteriorChange() == 1 then
		Exterior:LuaFnRemovePlayerExteriorFitting()
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESET")
		Exterior:LuaFnInitCurrentExteriorSet(0)
		NewExterior_Weapon_Show()
		PushDebugMessage("#{WGTJ_201222_98}")
	else
		PushDebugMessage("#{WGTJ_201222_76}")
	end
end

function NewExterior_Weapon_Goto()
	AutoRuntoTargetExWithName(252, 130, 0, "Nhan Nhﬂ Ng˜c")
end

function NewExterior_Weapon_CloseClick()
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)	
	NewExterior_Weapon_SetPosition()
	this:Hide()
end

function NewExterior_Weapon_OnHidden()

	if IsWindowShow("Profile_Save") then
		CloseWindow("Profile_Save", true)
	end
	
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_HairStyle")
		or IsWindowShow("NewExterior_PlayerFrame")	
		or IsWindowShow("NewExterior_PetSoul")
		or IsWindowShow("NewExterior_Widget")
		or IsWindowShow("NewExterior_Headdress") then
	else	
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	end	
	
	NewExterior_Weapon_CleanUp()
end

function NewExterior_Weapon_CleanUp()
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Weapon_SuperListItemAction")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
		end
	end
	
	NewExterior_Weapon_FakeObject:SetFakeObject("")
	
	NewExterior_Weapon_CleanUp_LeftButton()
end

function NewExterior_Weapon_CleanUp_LeftButton()
	
	NewExterior_Weapon_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		NewExterior_Weapon_FaceStyle_LeftBtn,
		NewExterior_Weapon_HairStyle_LeftBtn,
		NewExterior_Weapon_PlayerFrame_LeftBtn,
		NewExterior_Weapon_Ride_LeftBtn,
		NewExterior_Weapon_PetSoul_LeftBtn,
		NewExterior_Weapon_Weapon_LeftBtn,
		NewExterior_Weapon_Widget_LeftBtn,
		NewExterior_Weapon_Widget_Headdress_LeftBtn,
	}
	
	for i in pairs(ctrl_list) do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_Weapon_Dress_LeftBtnLuxury:Hide()
	NewExterior_Weapon_Dress_ActionImg:Hide()
	NewExterior_Weapon_FaceStyle_ActionImg:Hide()
	NewExterior_Weapon_HairStyle_ActionImg:Hide()
	NewExterior_Weapon_PlayerFrame_ActionImg:Hide()
	NewExterior_Weapon_Ride_ActionImg:Hide()
	NewExterior_Weapon_PetSoul_ActionImg:Hide()
	NewExterior_Weapon_Weapon_ActionImg:Hide()
	NewExterior_Weapon_Widget_ActionImg:Hide()
	NewExterior_Weapon_Widget_Headdress_ActionImg:Hide()

	NewExterior_Weapon_Dress_LockImg:Hide()
	NewExterior_Weapon_FaceStyle_LockImg:Hide()
	NewExterior_Weapon_HairStyle_LockImg:Hide()
	NewExterior_Weapon_PlayerFrame_LockImg:Hide()
	NewExterior_Weapon_Ride_LockImg:Hide()
	NewExterior_Weapon_PetSoul_LockImg:Hide()
	NewExterior_Weapon_Weapon_LockImg:Hide()
	NewExterior_Weapon_Widget_LockImg:Hide()
	NewExterior_Weapon_Widget_Headdress_LockImg:Hide()
end

function NewExterior_Weapon_FakeObject_TurnLeft(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		NewExterior_Weapon_FakeObject:RotateBegin(-0.3)
	else
		NewExterior_Weapon_FakeObject:RotateEnd()
	end
end

function NewExterior_Weapon_FakeObject_TurnRight(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
			NewExterior_Weapon_FakeObject:RotateBegin(0.3)
		else
		NewExterior_Weapon_FakeObject:RotateEnd()
	end
end

--Àı–°
function NewExterior_Weapon_ZoomOut()
	if g_Distance == 1 then
		return
	end
	g_Distance = g_Distance - 1		
	NewExterior_Weapon_UpdateCamera()
end

--∑≈¥Û
function NewExterior_Weapon_ZoomIn()
	if g_Distance == g_Distance_Max then
		return
	end	
	g_Distance = g_Distance + 1	
	NewExterior_Weapon_UpdateCamera()
end

function NewExterior_Weapon_UpdateCamera()
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

function NewExterior_Weapon_DoAction(index)	
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	
	local sex = Player:GetMySex()
	for i = 1, table.getn(g_SpecialWeaponCamera) do
		if g_SpecialWeaponCamera[i][sex] ~= nil and cacheExteriorID >= g_SpecialWeaponCamera[i][sex].startid and cacheExteriorID <= g_SpecialWeaponCamera[i][sex].endid then
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

			NewExterior_Weapon_Model_Plus:Disable()
			NewExterior_Weapon_Model_Subtract:Disable()
			NewExterior_Weapon_Model_TurnLeft:Disable()
			NewExterior_Weapon_Model_TurnRight:Disable()
			
			SetTimer("NewExterior_Weapon","NewExterior_Weapon_ActionEnd()", g_SpecialWeaponCamera[i][sex].timecount)
		end		
	end
	
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		Exterior:LuaFnExteriorAvatarPlayAction(0, cacheExteriorID, index - 1)
	end	
end

function NewExterior_Weapon_ActionEnd()
	KillTimer("NewExterior_Weapon_ActionEnd()");
	
	NewExterior_Weapon_Model_Plus:Enable()
	NewExterior_Weapon_Model_Subtract:Enable()
	NewExterior_Weapon_Model_TurnLeft:Enable()
	NewExterior_Weapon_Model_TurnRight:Enable()
	
	NewExterior_Weapon_UpdateCamera()
end

function NewExterior_Weapon_UpdateCheckButton()

end

--”“º¸»°œ¬ ±◊∞
function NewExterior_Weapon_ActionToDressBox()
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		cacheExteriorID = 0
		cacheExteriorIdx = -1
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", cacheExteriorID, cacheExteriorIdx)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(0)			
		NewExterior_Weapon_Show()
		--return
	end
	Exterior:LuaFnUnUseExteriorFashion(1)
end

-- ±◊∞
function NewExterior_Weapon_OpenFashion()
	NewExterior_Weapon_SavePosition()
	PushEvent("OPEN_EXTERIOR_FASHION", 1, 0)
end

--◊¯∆Ô
function NewExterior_Weapon_OpenRide()
	NewExterior_Weapon_SavePosition()
	Exterior:LuaFnAskOpenExterior(3)
end

--∑¢–Õ
function NewExterior_Weapon_OpenHair()
	NewExterior_Weapon_SavePosition()	
	Exterior:LuaFnAskOpenExterior(1)
end

--¡≥–Õ
function NewExterior_Weapon_OpenFace()
	NewExterior_Weapon_SavePosition()	
	Exterior:LuaFnAskOpenExterior(0)
end

--Õ∑œÒ
function NewExterior_Weapon_OpenPortrait()
	NewExterior_Weapon_SavePosition()	
	Exterior:LuaFnAskOpenExterior(2)
end

--ª√Œ‰
function NewExterior_Weapon_OpenWeapon()
	--NewExterior_Weapon_SavePosition()	
	--Exterior:LuaFnAskOpenExteriorWeapon()
end

--»⁄ªÍÕ‚π€
function NewExterior_Weapon_OpenPoss()
	NewExterior_Weapon_SavePosition()	
	Exterior:LuaFnAskOpenExterior(4)
end

function NewExterior_Weapon_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	CloseWindow("NewExterior_PetSoul", true)
	--CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_Widget", true)
	CloseWindow("NewExterior_Headdress", true)
end

function NewExterior_Weapon_SavePosition()
	Variable:SetVariable("ExteriorUnionPos", NewExterior_Weapon_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_Weapon_SetPosition()
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_Weapon_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end
end

function NewExterior_Weapon_RemoveTip(nExteriorID)
	local nTip = Exterior:LuaFnGetExteriorWeaponTip(nExteriorID)
	if nTip == 1 then
		Exterior:LuaFnRemoveExteriorWeaponTip(nExteriorID)
		
		for i = 1, g_MaxBarNum do
			if g_BarList[i] then
				local nID = Exterior:LuaFnGetExteriorWeaponIDFromList(i - 1)
				if Exterior:LuaFnGetExteriorWeaponTip(nID) == 1 then
					g_BarList[i]:GetSubItem("NewExterior_Weapon_SuperListItemActionTip"):Show()
				else
					g_BarList[i]:GetSubItem("NewExterior_Weapon_SuperListItemActionTip"):Hide()
				end
			end
		end
	--	NewExterior_Ride_UpdateCheckButton()
	end	
end

function NewExterior_Weapon_UpdateRedPoint()

	NewExterior_Weapon_Dress_Tip:Hide()
	
	if Exterior:LuaFnIsHaveExteriorShowTip(3) == 1 then
		NewExterior_Weapon_Ride_Tip:Show()
	else
		NewExterior_Weapon_Ride_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(0) == 1 then
		NewExterior_Weapon_FaceStyle_Tip:Show()
	else
		NewExterior_Weapon_FaceStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(1) == 1 or Exterior:LuaFnIsHaveHairColorShowTip() == 1 then
		NewExterior_Weapon_HairStyle_Tip:Show()
	else
		NewExterior_Weapon_HairStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(2) == 1 then
		NewExterior_Weapon_PlayerFrame_Tip:Show()
	else
		NewExterior_Weapon_PlayerFrame_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(4) == 1 then
		NewExterior_Weapon_PetSoul_Tip:Show()
	else
		NewExterior_Weapon_PetSoul_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorWeaponShowTip() == 1 then
		NewExterior_Weapon_Weapon_Tip:Show()
	else
		NewExterior_Weapon_Weapon_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(0) == 1 then
		NewExterior_Weapon_Widget_Tip:Show()
	else
		NewExterior_Weapon_Widget_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(1) == 1 then
		NewExterior_Weapon_Widget_Headdress_Tip:Show()
	else
		NewExterior_Weapon_Widget_Headdress_Tip:Hide()
	end
end

function NewExterior_Weapon_ShowDressShareButton()
	
	local player_level = Player:GetData("LEVEL")
	if player_level >= 15 then
		NewExterior_Weapon_SaveChangeBtn:Hide()
		NewExterior_Weapon_ShareBtn:Show()
	else
		NewExterior_Weapon_SaveChangeBtn:Hide()
		NewExterior_Weapon_ShareBtn:Hide()
	end
	
end

function NewExterior_Weapon_Share_Clicked()
	local ret = Exterior:LuaFnExteriorPlayerShareClick(0)
	return ret	
end

function NewExterior_Weapon_SaveChange_Clicked()	
	local ret = Exterior:LuaFnExteriorPlayerOpenSharePlan()
	return ret	
end

-- ±≥π“
function NewExterior_Weapon_OpenOrnamentsBack()
	NewExterior_Weapon_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(0)
end

function NewExterior_Weapon_ActionToOrnamentsBack()
	local useID = OrnamentsScript:GetOrnamentsUseID(0)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(0)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSBACK", 0, 0, 0, 0)
	NewExterior_Weapon_UpdateLeftBtn()
	NewExterior_Weapon_UpdateObj()
end

-- Õ∑ Œ
function NewExterior_Weapon_OpenOrnamentsHead()
	NewExterior_Weapon_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(1)
end

function NewExterior_Weapon_ActionToOrnamentsHead()
	local useID = OrnamentsScript:GetOrnamentsUseID(1)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(1)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", 0, 0, 0, 0)
	NewExterior_Weapon_UpdateLeftBtn()
	NewExterior_Weapon_UpdateObj()
end
--!!!reloadscript =NewExterior_Weapon
