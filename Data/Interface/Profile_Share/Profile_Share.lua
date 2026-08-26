
--!!!reloadscript =Profile_Share

local g_Profile_Share_UnifiedPosition = ""

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4

local g_CameraHeight = 1     --摄影机高度
local g_CameraDistance = 2   --摄影机距离
local g_CameraPitch = 3      --摄影机角度
local g_CameraPosition =
{
	--女性相关位置
	[0] = {
		{fHeight = 0.82, fDistance = 8,   fPitch=0.1},
		{fHeight = 0.82, fDistance = 6.5, fPitch=0.1},
		{fHeight = 1.5,  fDistance = 2.5, fPitch=0.1},
		{fHeight = 1.57, fDistance = 1.7, fPitch=0.1}
	},
	--男性相关位置
	[1] = {
		{fHeight = 0.91,  fDistance = 8.8, fPitch=0.2},
		{fHeight = 0.91,  fDistance = 7.1, fPitch=0.2},
		{fHeight = 1.67,  fDistance = 2.5, fPitch=0.2},
		{fHeight = 1.745, fDistance = 1.7, fPitch=0.2}
	},
}

local g_Profile_Share_ViewMode = 0 --0是角色 1是上坐骑

local g_Profile_Share_Button = {}

--=========
--PreLoad==
--=========
function Profile_Share_PreLoad()

	this:RegisterEvent("OPEN_EXTERIOR_SHAREUI")
		
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("OPEN_STALL_SALE",false)
	this:RegisterEvent("PROGRESSBAR_SHOW",false)
	
end

--=========
--OnLoad
--=========
function Profile_Share_OnLoad()

	g_Profile_Share_UnifiedPosition = Profile_Share_Frame:GetProperty("UnifiedPosition")
	
	g_Profile_Share_Button[1] = Profile_Share_Dress_LeftBtn
	g_Profile_Share_Button[2] = Profile_Share_Ride_LeftBtn
	g_Profile_Share_Button[3] = Profile_Share_FaceStyle_LeftBtn
	g_Profile_Share_Button[4] = Profile_Share_HairStyle_LeftBtn
	g_Profile_Share_Button[5] = Profile_Share_Weapon_LeftBtn
	g_Profile_Share_Button[6] = Profile_Share_PetSoul_LeftBtn
	
end

--=========
--OnEvent
--=========
function Profile_Share_OnEvent(event)
	
	if event == "OPEN_EXTERIOR_SHAREUI" then
		if this:IsVisible() then
			Profile_Share_Close()	
		end	
		
		Profile_Share_Show()
			
		--Profile_Share_FakeObject:SetFakeObject("Exterior_Share")
		--Profile_Share_UpdateCamera()			
		return
	end
	
	if event == "OPEN_STALL_SALE"			-- 开始摆摊，还原试穿
		or event == "PROGRESSBAR_SHOW"		-- 读进度条中，还原试穿
		then
			Profile_Share_Close()	
		return
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			Profile_Share_Close()	
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Profile_Share_On_ResetPos()
	end
	
end

function Profile_Share_Show()		
				
	this:Show()
	
	g_Distance = g_Distance_Ori
	
	Profile_Share_CleanUp()
		
	local theDragTitle = Exterior:LuaFnGetExteriorOtherShareLinkInfo("NAME")
	theDragTitle = "#gFF0FA0"..theDragTitle
	Profile_Share_DragTitle:SetText(theDragTitle)
				
	--左侧
	Profile_Share_UpdateBtn()
	
	--模型
	Profile_Share_UpdateObj()
	
end

--左侧
function Profile_Share_UpdateBtn()
	
	--时装
	local theAction, bLocked = Exterior:LuaFnGetExteriorOtherShareLinkInfo("DRESS")
	local theDressId = Exterior:LuaFnGetExteriorOtherShareLinkInfo("DRESSID")
	if theAction ~= nil and theAction:GetID() ~= 0 then
		Profile_Share_Dress_LeftBtn:SetActionItem(theAction:GetID())
			
		Profile_Share_Dress_LuxuryImage:Hide()
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(theDressId, "Number")
		if nFashionNumber ~= nil and nFashionNumber > 0 then
			Profile_Share_Dress_LuxuryImage:Show()
		end
	else
		Profile_Share_Dress_LeftBtn:SetActionItem(-1)	
	end
	
	--坐骑
	local nRideId, nRideTime = Exterior:LuaFnGetExteriorOtherShareLinkInfo("RIDE")
	if nRideId ~= nil and nRideId > 0 then
		local strName = Exterior:LuaFnGetExteriorRideInfo(nRideId, "Name")
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(nRideId, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		Profile_Share_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		Profile_Share_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		Profile_Share_Ride_LeftBtn:SetToolTip(strTemp)
	end
		
	local sex = Exterior:LuaFnGetExteriorOtherShareLinkInfo("SEX")
	--脸型
	local nFaceId = Exterior:LuaFnGetExteriorOtherShareLinkInfo("FACE")
	if nFaceId ~= nil and nFaceId > 0 then
		local strName 	= Exterior:LuaFnGetExteriorFaceInfo(nFaceId, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(nFaceId, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		
		Profile_Share_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		Profile_Share_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_82}", strName)
		Profile_Share_FaceStyle_LeftBtn:SetToolTip(strTemp)
	end
	
	--发型
	local nHairId = Exterior:LuaFnGetExteriorOtherShareLinkInfo("HAIR")
	if nHairId ~= nil and nHairId > 0 then
		local strName 	= Exterior:LuaFnGetExteriorHairInfo(nHairId, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(nHairId, "Icon", sex)
		local strImage = GetIconFullName(strIcon)
		
		Profile_Share_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		Profile_Share_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_81}", strName)
		Profile_Share_HairStyle_LeftBtn:SetToolTip(strTemp)
	end
	
	--幻武
	local nWeaponId, nWeaponLevel, nWeaponTime = Exterior:LuaFnGetExteriorOtherShareLinkInfo("WEAPON")
	if nWeaponId ~= nil and nWeaponId > 0 then
		local strName = Exterior:LuaFnGetExteriorWeaponInfo(nWeaponId, "Name")
		local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(nWeaponId, "Icon")
		local strImage = GetIconFullName(strIcon)	
		
		Profile_Share_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		Profile_Share_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{HSWQ_20220607_02}", strName, tostring(nWeaponLevel + 1))
		Profile_Share_Weapon_LeftBtn:SetToolTip(strTemp)
	end
	
	--融魂外观
	local nPossId, nPossVisual = Exterior:LuaFnGetExteriorOtherShareLinkInfo("POSS")
	if nPossId ~= nil and nPossId > 0 then
		local strName 	= Exterior:LuaFnGetExteriorPossInfo(nPossId, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorPossInfo(nPossId, "Icon", sex)
		local strImage = GetIconFullName(strIcon)	
		
		Profile_Share_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		Profile_Share_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{SHRH_20220427_64}", strName)
		Profile_Share_PetSoul_LeftBtn:SetToolTip(strTemp)

		local nColor = Exterior:LuaFnGetExteriorOtherShareLinkInfo("COLOR")
		if nColor > 0 then
			local planstr =  Exterior:LuaFnGetRanSePlanNameTips(nPossId, nColor)
			if planstr ~= nil and planstr ~= "" then
				Profile_Share_PetSoul_LeftBtn:SetToolTip(strTemp.."#r"..planstr)
			end
		end
		
	end
	
end

--模型
function Profile_Share_UpdateObj()

	Profile_Share_FakeObject:SetFakeObject("")
		
	Exterior:LuaFnExteriorOtherShareLinkAvatar()
	
	if g_Profile_Share_ViewMode == 0 then	
		Exterior:LuaFnExteriorOtherShareLinkAvatarMount(-1)	
	
		Profile_Share_FakeObject:SetFakeObject("Exterior_Share")	
		
		Profile_Share_UpdateCamera()
	else
		local nRideId, nRideTime = Exterior:LuaFnGetExteriorOtherShareLinkInfo("RIDE")
		if nRideId ~= nil and nRideId > 0 then		
			local nMountId = Exterior:LuaFnGetExteriorRideInfo(nRideId, "MountId")	
			Exterior:LuaFnExteriorOtherShareLinkAvatarMount(nMountId)
	
			Profile_Share_FakeObject:SetFakeObject("Exterior_Share")	
			
			local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId, 0)	
			FakeObj_SetCamera("Exterior_Share", g_CameraHeight, fHeight)
			FakeObj_SetCamera("Exterior_Share", g_CameraDistance, fDistance)	
		end
	end
	
end

--试乘
function Profile_Share_Preview_SwithViewMode()

	local nRideId, nRideTime = Exterior:LuaFnGetExteriorOtherShareLinkInfo("RIDE")
	if nRideId ~= nil and nRideId > 0 then
		if g_Profile_Share_ViewMode == 0 then
			g_Profile_Share_ViewMode = 1	

			Profile_Share_Model_Plus:Hide()
			Profile_Share_Model_Subtract:Hide()
		else
			g_Profile_Share_ViewMode = 0
			
			Profile_Share_Model_Plus:Show()
			Profile_Share_Model_Subtract:Show()
		end	
			
		Profile_Share_UpdateObj()
	end	
	
end

function Profile_Share_On_ResetPos()

	Profile_Share_Frame:SetProperty("UnifiedPosition", g_Profile_Share_UnifiedPosition);
	
end

--关闭按钮
function Profile_Share_Close()	
		
	this:Hide()
	
end

function Profile_Share_OnHidden()
	
	Profile_Share_CleanUp()
	
end

function Profile_Share_CleanUp()
	
	g_Profile_Share_ViewMode = 0

	Profile_Share_FakeObject:SetFakeObject("")
	
	for i in pairs(g_Profile_Share_Button) do
		g_Profile_Share_Button[i]:SetProperty("Empty", "False")
		g_Profile_Share_Button[i]:SetProperty("UseDefaultTooltip", "True")
		g_Profile_Share_Button[i]:SetProperty("NormalImage", "")
		g_Profile_Share_Button[i]:SetProperty("HoverImage", "")
		g_Profile_Share_Button[i]:SetToolTip("")
	end

	Profile_Share_Dress_LuxuryImage:Hide()
	Profile_Share_Dress_LockImg:Hide()
	Profile_Share_Ride_LockImg:Hide()
	Profile_Share_FaceStyle_LockImg:Hide()
	Profile_Share_HairStyle_LockImg:Hide()
	Profile_Share_Weapon_LockImg:Hide()
	Profile_Share_PetSoul_LockImg:Hide()
	
	Profile_Share_Model_Plus:Show()
	Profile_Share_Model_Subtract:Show()
			
end

--摄像机
function Profile_Share_UpdateCamera()

	local sex = Exterior:LuaFnGetExteriorOtherShareLinkInfo("SEX")
	if sex ~= 0 and sex ~= 1 then 
		return
	end
		
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end

	local fHeight = g_CameraPosition[sex][g_Distance].fHeight
	local fDistance = g_CameraPosition[sex][g_Distance].fDistance
	local fPitch = g_CameraPosition[sex][g_Distance].fPitch

	FakeObj_SetCamera("Exterior_Share", g_CameraHeight, fHeight)
	FakeObj_SetCamera("Exterior_Share", g_CameraDistance, fDistance)
	FakeObj_SetCamera("Exterior_Share", g_CameraPitch, fPitch)

end

--左转
function Profile_Share_FakeObject_TurnLeft(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Profile_Share_FakeObject:RotateBegin(-0.3)
	else
		Profile_Share_FakeObject:RotateEnd()
	end
	
end

--右转
function Profile_Share_FakeObject_TurnRight(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Profile_Share_FakeObject:RotateBegin(0.3)
	else
		Profile_Share_FakeObject:RotateEnd()
	end
	
end

--缩小
function Profile_Share_ZoomOut()

	if g_Distance == 1 then
		return
	end
	
	g_Distance = g_Distance - 1	

	Profile_Share_UpdateCamera()
	
end

--放大
function Profile_Share_ZoomIn()

	if g_Distance == g_Distance_Max then
		return
	end
	
	g_Distance = g_Distance + 1	
	
	Profile_Share_UpdateCamera()

end

--小问号
function Profile_Share_HelpClick()
end

--!!!reloadscript =Profile_Share