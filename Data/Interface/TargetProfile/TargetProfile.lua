
--!!!reloadscript =TargetProfile

local g_TargetProfile_UnifiedPosition = ""

local g_TargetProfile_Type_Dress = 1
local g_TargetProfile_Type_Ride = 2
local g_TargetProfile_Type_Weapon = 3

local g_TargetProfile_MaxBtn = 6
local g_TargetProfile_DressCurSel = 0
local g_TargetProfile_WeaponCurSel = 0
local g_TargetProfile_RideCurSel = 0
local g_TargetProfile_ViewMode = 0	--0是角色 1是上坐骑

local g_TargetProfile_Tag_Text = {}
local g_TargetProfile_Dress_Btn = {}
local g_TargetProfile_Dress_Luxury = {}
local g_TargetProfile_Ride_Btn = {}
local g_TargetProfile_Ride_Luxury = {}
local g_TargetProfile_Ride_Time = {}
local g_TargetProfile_Weapon_Btn = {}
local g_TargetProfile_Weapon_Time = {}

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4

local m_PlayerfashionDepotType = 1 	--仓库类型 1 玩家时装仓库 2 子女时装仓库

local g_CameraHeight = 1     --摄影机高度
local g_CameraDistance = 2   --摄影机距离
local g_CameraPitch = 3      --摄影机角度
local g_CameraPosition =
{
	--女性相关位置
	[0] = {
		{fHeight = 0.82, fDistance = 8, fPitch=0.1},
		{fHeight = 0.82, fDistance = 6.5, fPitch=0.1},
		{fHeight = 1.5, fDistance = 2.5, fPitch=0.10},
		{fHeight = 1.57, fDistance = 1.7, fPitch=0.10}
	},
	--男性相关位置
	[1] = {
		{fHeight = 0.91, fDistance = 8.8, fPitch=0.2},
		{fHeight = 0.91, fDistance = 7.1, fPitch=0.2},
		{fHeight = 1.67, fDistance = 2.5, fPitch=0.2},
		{fHeight = 1.745, fDistance = 1.7, fPitch=0.2}
	},
}

local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		},
	[2] = {Text = "#{INTERFACE_XML_882}",		},
	[3] = {Text = "#{INTERFACE_XML_854}",		},
	[4] = {Text = "#{WH_xml_XX(95)}",			},
	[5] = {Text = "#{SZXT_221216_22}",			},
	[6] = {Text = "#{SBFW_20230707_1}",			},
	[7] = {Text = "#{DWJJ_240329_153}",  	 	},
	[8] = {Text = "#{DFJC_250709_1}",  	 	},
	[9] = {Text = "#{GRYM_221213_22}",  	 	},
}
local g_PageButton = {}
local g_PageOrder = {}

local g_TargetProfile_Tag_Num = 0
local g_TargetProfile_Tag_CanChoose = 6

local g_objCared = -1;
--=========
--PreLoad==
--=========
function TargetProfile_PreLoad()

	this:RegisterEvent("OPEN_EXTERIOR_TARGETPROFILE")
	this:RegisterEvent("UPDATE_EXTERIOR_TARGETPROFILE_DIANZAN", false)
		
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)

end

--=========
--OnLoad
--=========
function TargetProfile_OnLoad()

	g_TargetProfile_UnifiedPosition = TargetProfile_Frame:GetProperty("UnifiedPosition")
	
	g_TargetProfile_Tag_Text[1] = TargetProfile_Frame_Tag_TagText1
	g_TargetProfile_Tag_Text[2] = TargetProfile_Frame_Tag_TagText2
	g_TargetProfile_Tag_Text[3] = TargetProfile_Frame_Tag_TagText3
	g_TargetProfile_Tag_Text[4] = TargetProfile_Frame_Tag_TagText4
	g_TargetProfile_Tag_Text[5] = TargetProfile_Frame_Tag_TagText5
	g_TargetProfile_Tag_Text[6] = TargetProfile_Frame_Tag_TagText6
	--展示
	g_TargetProfile_Dress_Btn[1] = TargetProfile_Frame_Dress_Object1
	g_TargetProfile_Dress_Btn[2] = TargetProfile_Frame_Dress_Object2
	g_TargetProfile_Dress_Btn[3] = TargetProfile_Frame_Dress_Object3
	g_TargetProfile_Dress_Btn[4] = TargetProfile_Frame_Dress_Object4
	g_TargetProfile_Dress_Btn[5] = TargetProfile_Frame_Dress_Object5
	g_TargetProfile_Dress_Btn[6] = TargetProfile_Frame_Dress_Object6
	
	g_TargetProfile_Dress_Luxury[1] = TargetProfile_Frame_Dress_Object1Luxury
	g_TargetProfile_Dress_Luxury[2] = TargetProfile_Frame_Dress_Object2Luxury
	g_TargetProfile_Dress_Luxury[3] = TargetProfile_Frame_Dress_Object3Luxury
	g_TargetProfile_Dress_Luxury[4] = TargetProfile_Frame_Dress_Object4Luxury
	g_TargetProfile_Dress_Luxury[5] = TargetProfile_Frame_Dress_Object5Luxury
	g_TargetProfile_Dress_Luxury[6] = TargetProfile_Frame_Dress_Object6Luxury
	
	g_TargetProfile_Ride_Btn[1] = TargetProfile_Frame_Ride_Object1
	g_TargetProfile_Ride_Btn[2] = TargetProfile_Frame_Ride_Object2
	g_TargetProfile_Ride_Btn[3] = TargetProfile_Frame_Ride_Object3
	g_TargetProfile_Ride_Btn[4] = TargetProfile_Frame_Ride_Object4
	g_TargetProfile_Ride_Btn[5] = TargetProfile_Frame_Ride_Object5
	g_TargetProfile_Ride_Btn[6] = TargetProfile_Frame_Ride_Object6
	
	g_TargetProfile_Ride_Luxury[1] = TargetProfile_Frame_Ride_Object1Luxury
	g_TargetProfile_Ride_Luxury[2] = TargetProfile_Frame_Ride_Object2Luxury
	g_TargetProfile_Ride_Luxury[3] = TargetProfile_Frame_Ride_Object3Luxury
	g_TargetProfile_Ride_Luxury[4] = TargetProfile_Frame_Ride_Object4Luxury
	g_TargetProfile_Ride_Luxury[5] = TargetProfile_Frame_Ride_Object5Luxury
	g_TargetProfile_Ride_Luxury[6] = TargetProfile_Frame_Ride_Object6Luxury
	
	g_TargetProfile_Ride_Time[1] = TargetProfile_Frame_Ride_Object1Time
	g_TargetProfile_Ride_Time[2] = TargetProfile_Frame_Ride_Object2Time
	g_TargetProfile_Ride_Time[3] = TargetProfile_Frame_Ride_Object3Time
	g_TargetProfile_Ride_Time[4] = TargetProfile_Frame_Ride_Object4Time
	g_TargetProfile_Ride_Time[5] = TargetProfile_Frame_Ride_Object5Time
	g_TargetProfile_Ride_Time[6] = TargetProfile_Frame_Ride_Object6Time
	
	g_TargetProfile_Weapon_Btn[1] = TargetProfile_Frame_Weapon_Object1
	g_TargetProfile_Weapon_Btn[2] = TargetProfile_Frame_Weapon_Object2
	g_TargetProfile_Weapon_Btn[3] = TargetProfile_Frame_Weapon_Object3
	g_TargetProfile_Weapon_Btn[4] = TargetProfile_Frame_Weapon_Object4
	g_TargetProfile_Weapon_Btn[5] = TargetProfile_Frame_Weapon_Object5
	g_TargetProfile_Weapon_Btn[6] = TargetProfile_Frame_Weapon_Object6
	
	g_TargetProfile_Weapon_Time[1] = TargetProfile_Frame_Weapon_Object1Time
	g_TargetProfile_Weapon_Time[2] = TargetProfile_Frame_Weapon_Object2Time
	g_TargetProfile_Weapon_Time[3] = TargetProfile_Frame_Weapon_Object3Time
	g_TargetProfile_Weapon_Time[4] = TargetProfile_Frame_Weapon_Object4Time
	g_TargetProfile_Weapon_Time[5] = TargetProfile_Frame_Weapon_Object5Time
	g_TargetProfile_Weapon_Time[6] = TargetProfile_Frame_Weapon_Object6Time
	
	-- 分页按钮
	g_PageButton[1] = TargetProfile_SelfEquip
	g_PageButton[2] = TargetProfile_TargetProfile
	g_PageButton[3] = TargetProfile_Pet
	g_PageButton[4] = TargetProfile_TargetWuhun
	g_PageButton[5] = TargetProfile_Lingyu
	g_PageButton[6] = TargetProfile_TargetWeapon2
	g_PageButton[7] = TargetProfile_TargetDWJinJie
	g_PageButton[8] = TargetProfile_Peak
	g_PageButton[9] = TargetProfile_Profile
	
end

--=========
--OnEvent
--=========
function TargetProfile_OnEvent(event)
	
	if event == "OPEN_EXTERIOR_TARGETPROFILE" then
		if this:IsVisible() then
			return
		end

		if not CachedTarget:IsPresent(1) then
			return
		end

		if not ZBS:IsCanGetTargetEquip() then
			return
		end
		
		if not CachedTarget:CanGetTargetEquip() then
			PushDebugMessage ("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
			return
		end
		
		local objCaredId = CachedTarget:GetData("NPCID", 1)
		if type(objCaredId) ~= "number" then
			PushDebugMessage ("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
			return
		end
		
		TargetProfile_BeginCareObject(objCaredId)

		TargetProfile_Show()
		CachedTarget:TargetProfile_ChangeModel();
		TargetProfile_FakeObject:SetFakeObject("Exterior_TargetProfile");	
		TargetProfile_UpdateCamera()
		return
	end
	
	if event == "UPDATE_EXTERIOR_TARGETPROFILE_DIANZAN" then
		if this:IsVisible() then
			TargetProfile_Update_Like()
			return
		end
		return
	end

	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			TargetProfile_CloseClick()
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		TargetProfile_Frame_On_ResetPos()
	end
	
end


-- 显示自己
function TargetProfile_Show()		
		
	this:Show()
	
	g_Distance = g_Distance_Ori
	
	TargetProfile_CleanUp()
	-- 得到名字
  	--local strName = CachedTarget:GetData("NAME", 1)
  	TargetProfile_PageHeader:SetText("#{GRYM_221213_163}")

	TargetProfile_Frame_LikeBtn:Show()

	--点赞
	TargetProfile_Update_Like()
			
	--图标
	TargetProfile_Update_Button()	
	
	--模型
	TargetProfile_UpdateObj()
	
	--页签
	TargetProfile_ShowPage()
	
	--标签
	TargetProfile_Update_Tag()

end
	
--标签
function TargetProfile_Update_Tag()
		
	local nIndex = 1
	for i = 1, g_TargetProfile_Tag_CanChoose do
		local nSelId = Exterior:LuaFnGetOtherPlayerTag(i-1)
		if nSelId > 0 then			
			local nId, nType, nStr, nValid = Exterior:LuaFnExteriorPlayerGetTagChooseInfo( nSelId )
			if nId > 0 and nValid == 1 then			
				g_TargetProfile_Tag_Text[nIndex]:Show()
				nStr = "#{"..nStr.."}"
				g_TargetProfile_Tag_Text[nIndex]:SetText(nStr)
				nIndex = nIndex + 1
			end
		end
	end
	
end

function TargetProfile_Update_Button_Dress()
	for i in pairs(g_TargetProfile_Dress_Btn) do
		local cacheExteriorIDX, cacheDressId, strName, strIcon = Exterior:LuaFnGetOtherProfileData(i, "DRESS")
		if cacheExteriorIDX ~= nil and cacheExteriorIDX >= 0 and cacheDressId ~= nil and cacheDressId > 0 then
			local theAction, bLocked = FashionDepot:LuaFnGetFashionProfileDressItem(i - 1)
			if theAction:GetID() ~= 0 then
				g_TargetProfile_Dress_Btn[i]:SetActionItem(theAction:GetID())
					
				g_TargetProfile_Dress_Luxury[i]:Hide()
				local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(cacheDressId, "Number")
				if nFashionNumber ~= nil and nFashionNumber > 0 then
					g_TargetProfile_Dress_Luxury[i]:Show()
				end
			else
				g_TargetProfile_Dress_Btn[i]:SetActionItem(-1)
			end	
		end
		g_TargetProfile_Dress_Btn[i]:SetPushed(0)
	end
end

function TargetProfile_Update_Button_Ride()
	local j = 1
	for i in pairs(g_TargetProfile_Ride_Btn) do
		local cacheExteriorID, nLeftTime = Exterior:LuaFnGetOtherProfileData(i, "RIDE")
		if cacheExteriorID ~= nil and cacheExteriorID > 0 and nLeftTime ~= 0 then
			local nLuxury = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Luxury")
			local strName = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Name")
			local strIcon = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Icon")
			local strImage = GetIconFullName(strIcon)
			
			g_TargetProfile_Ride_Btn[j]:SetProperty("Empty", "False")
			g_TargetProfile_Ride_Btn[j]:SetProperty("UseDefaultTooltip", "True")
			g_TargetProfile_Ride_Btn[j]:SetProperty("NormalImage", strImage)
			g_TargetProfile_Ride_Btn[j]:SetProperty("HoverImage", strImage)
			
			local strTemp = Exterior:LuaFnGetRideToolTip(cacheExteriorID)
			g_TargetProfile_Ride_Btn[j]:SetToolTip(strTemp)	

			if nLeftTime and nLeftTime < 0 then
				g_TargetProfile_Ride_Time[j]:Hide()
			elseif nLeftTime and nLeftTime == 0 then
				g_TargetProfile_Ride_Time[j]:Hide()
			elseif nLeftTime and nLeftTime > 0 then
				g_TargetProfile_Ride_Time[j]:Show()
			end	
			
			if nLuxury == 1 or nLuxury == 2 then
				g_TargetProfile_Ride_Luxury[j]:Show()
			else
				g_TargetProfile_Ride_Luxury[j]:Hide()
			end
			j = j + 1
		end
		g_TargetProfile_Ride_Btn[i]:SetPushed(0)
	end
end

function TargetProfile_Update_Button_Weapon()
	for i in pairs(g_TargetProfile_Weapon_Btn) do
		local cacheExteriorID, cacheWeaponLevel, nLeftTime = Exterior:LuaFnGetOtherProfileData(i, "WEAPON")
		if cacheExteriorID ~= nil and cacheExteriorID > 0 then
			local strName = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
			local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
			local strImage = GetIconFullName(strIcon)	
			
			g_TargetProfile_Weapon_Btn[i]:SetProperty("Empty", "False")
			g_TargetProfile_Weapon_Btn[i]:SetProperty("UseDefaultTooltip", "True")
			g_TargetProfile_Weapon_Btn[i]:SetProperty("NormalImage", strImage)
			g_TargetProfile_Weapon_Btn[i]:SetProperty("HoverImage", strImage)
			
			local strTemp = Exterior:LuaFnGetOtherExteriorWeaponToolTip(i)
			g_TargetProfile_Weapon_Btn[i]:SetToolTip(strTemp)
			
			if nLeftTime and nLeftTime < 0 then
				g_TargetProfile_Weapon_Time[i]:Hide()
			elseif nLeftTime and nLeftTime == 0 then
				g_TargetProfile_Weapon_Time[i]:Hide()
			elseif nLeftTime and nLeftTime > 0 then
				g_TargetProfile_Weapon_Time[i]:Show()
			end
		end
		g_TargetProfile_Weapon_Btn[i]:SetPushed(0)
	end
end

--图标
function TargetProfile_Update_Button()
	
	-- 时装
	TargetProfile_Update_Button_Dress()
	
	-- 坐骑
	TargetProfile_Update_Button_Ride()
	
	-- 幻武
	TargetProfile_Update_Button_Weapon()
	
end
	
--模型
function TargetProfile_UpdateObj()

	TargetProfile_FakeObject:SetFakeObject("")
	
	local CurDressSel = g_TargetProfile_DressCurSel - g_TargetProfile_Type_Dress * 10
	if CurDressSel < 1 or CurDressSel > g_TargetProfile_MaxBtn then
		CurDressSel = 0
	end
	local CurRideSel = g_TargetProfile_RideCurSel - g_TargetProfile_Type_Ride * 10
	if CurRideSel < 1 or CurRideSel > g_TargetProfile_MaxBtn then
		CurRideSel = 0
	end
	local CurWeaponSel = g_TargetProfile_WeaponCurSel - g_TargetProfile_Type_Weapon * 10
	if CurWeaponSel < 1 or CurWeaponSel > g_TargetProfile_MaxBtn then
		CurWeaponSel = 0
	end

	Exterior:LuaFnUpdateOtherProfileAvatarObj(CurDressSel, CurRideSel, CurWeaponSel)
	
	if g_TargetProfile_ViewMode == 0 then	
		TargetProfile_Model_Plus:Show()
		TargetProfile_Model_Subtract:Show()
		Exterior:LuaFnUpdateOhterProfileAvatarMount(-1)	
		Exterior:LuaFnUpdateOtherProfileAvatar("WEAPON", CurWeaponSel)	
		TargetProfile_FakeObject:SetFakeObject("Exterior_TargetProfile")		
	end
	
	TargetProfile_UpdateCamera()
end

--点选坐骑
function TargetProfile_Ride_ObjectClick( nIdx )
	
	if g_TargetProfile_Ride_Btn[nIdx] == nil then
		return
	end
	
	local cacheExteriorID = Exterior:LuaFnGetOtherProfileData(nIdx, "RIDE")
	if cacheExteriorID == nil or cacheExteriorID <= 0 then
		return
	end
	
	for i in pairs(g_TargetProfile_Ride_Btn) do
		g_TargetProfile_Ride_Btn[i]:SetPushed(0)
	end
	
	local nNewSel = g_TargetProfile_Type_Ride * 10 + nIdx
	if nNewSel == g_TargetProfile_RideCurSel then
		g_TargetProfile_RideCurSel = 0
		g_TargetProfile_ViewMode = 0				
		TargetProfile_Model_Plus:Show()
		TargetProfile_Model_Subtract:Show()
		TargetProfile_UpdateObj()
		return
	end
	
	g_TargetProfile_RideCurSel = nNewSel
	g_TargetProfile_Ride_Btn[nIdx]:SetPushed(1)	
	
	TargetProfile_FakeObject:SetFakeObject("")

	local nRideID = Exterior:LuaFnGetOtherProfileData(nIdx, "RIDE")
	if nRideID ~= nil and nRideID > 0 then	
		Exterior:LuaFnUpdateOtherProfileAvatar("RIDE", nIdx)

		TargetProfile_FakeObject:SetFakeObject("Exterior_TargetProfile")	

		local nMountId = Exterior:LuaFnGetExteriorRideInfo(nRideID, "MountId")	
		local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId, 0)
		FakeObj_SetCamera("Exterior_TargetProfile", g_CameraHeight, fHeight)
		FakeObj_SetCamera("Exterior_TargetProfile", g_CameraDistance, fDistance)

		g_TargetProfile_ViewMode = 1	
		TargetProfile_Model_Plus:Hide()
		TargetProfile_Model_Subtract:Hide()
	end
	
end

--点选幻武
function TargetProfile_Weapon_ObjectClick( nIdx )

	if g_TargetProfile_Weapon_Btn[nIdx] == nil then
		return
	end
	
	local cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetOtherProfileData(nIdx, "WEAPON")
	if cacheExteriorID == nil or cacheExteriorID <= 0 then
		return
	end
	
	for i in pairs(g_TargetProfile_Weapon_Btn) do
		g_TargetProfile_Weapon_Btn[i]:SetPushed(0)
	end
	
	local nNewSel = g_TargetProfile_Type_Weapon * 10 + nIdx
	if nNewSel == g_TargetProfile_WeaponCurSel then
		g_TargetProfile_WeaponCurSel = 0
		TargetProfile_UpdateObj()
		return
	end
	
	g_TargetProfile_WeaponCurSel = nNewSel
	g_TargetProfile_Weapon_Btn[nIdx]:SetPushed(1)
	
	Exterior:LuaFnUpdateOtherProfileAvatar("WEAPON", nIdx)	
	TargetProfile_UpdateCamera()
	
end

--点选时装
function TargetProfile_Dress_ObjectClick( nIdx )

	if g_TargetProfile_Dress_Btn[nIdx] == nil then
		return
	end
	
	local cacheExteriorIDX, cacheDressId, strName, strIcon = Exterior:LuaFnGetOtherProfileData(nIdx, "DRESS")
	if cacheExteriorIDX == nil or cacheExteriorIDX < 0 or cacheDressId == nil or cacheDressId <= 0 then
		return
	end
	
	for i in pairs(g_TargetProfile_Dress_Btn) do
		g_TargetProfile_Dress_Btn[i]:SetPushed(0)
	end
	
	local nNewSel = g_TargetProfile_Type_Dress * 10 + nIdx
	if nNewSel == g_TargetProfile_DressCurSel then
		g_TargetProfile_DressCurSel = 0
		TargetProfile_UpdateObj()
		return
	end
	
	g_TargetProfile_DressCurSel = nNewSel
	g_TargetProfile_Dress_Btn[nIdx]:SetPushed(1)
	
	Exterior:LuaFnUpdateOtherProfileAvatar("DRESS", nIdx)	
	TargetProfile_UpdateCamera()
	
end

--点赞
function TargetProfile_Frame_LikeBtn_Clicked()
	Exterior:LuaFnDianZan()
end

--关闭按钮
function TargetProfile_CloseClick()	

	TargetProfile_OnHidden()

end

function TargetProfile_OnHidden()
	
	TargetProfile_StopCareObject(g_objCared)

	this:Hide()

	TargetProfile_CleanUp()
	
end

function TargetProfile_CleanUp_Tag()
		
	for i in pairs(g_TargetProfile_Tag_Text) do
		g_TargetProfile_Tag_Text[i]:SetText("")
		g_TargetProfile_Tag_Text[i]:Hide()
	end
	
end

function TargetProfile_CleanUp_Dress()
		
	for i in pairs(g_TargetProfile_Dress_Btn) do
		g_TargetProfile_Dress_Btn[i]:SetActionItem(-1)	
		g_TargetProfile_Dress_Luxury[i]:Hide()
	end
	
end

function TargetProfile_CleanUp_Ride()
		
	for i in pairs(g_TargetProfile_Ride_Btn) do
		g_TargetProfile_Ride_Btn[i]:SetProperty("NormalImage", "")
		g_TargetProfile_Ride_Btn[i]:SetProperty("HoverImage", "")
		g_TargetProfile_Ride_Btn[i]:SetToolTip("")
		g_TargetProfile_Ride_Luxury[i]:Hide()
		g_TargetProfile_Ride_Time[i]:Hide()
	end
	
end

function TargetProfile_CleanUp_Weapon()

	for i in pairs(g_TargetProfile_Weapon_Btn) do
		g_TargetProfile_Weapon_Btn[i]:SetProperty("NormalImage", "")
		g_TargetProfile_Weapon_Btn[i]:SetProperty("HoverImage", "")
		g_TargetProfile_Weapon_Btn[i]:SetToolTip("")
		g_TargetProfile_Weapon_Time[i]:Hide()
	end
	
end

--清空搭配展示
function TargetProfile_CleanUp()

	TargetProfile_FakeObject:SetFakeObject("")
	
	TargetProfile_CleanUp_Tag()
	
	TargetProfile_CleanUp_Dress()
	
	TargetProfile_CleanUp_Ride()
	
	TargetProfile_CleanUp_Weapon()
	
	TargetProfile_Frame_LikeBtn:Hide()
	TargetProfile_Dress_LikeBtn_Text:SetText("")
	
	g_TargetProfile_ViewMode = 0
	
	g_TargetProfile_DressCurSel = 0
	g_TargetProfile_WeaponCurSel = 0
	g_TargetProfile_RideCurSel = 0

	CachedTarget:TargetProfile_DestroyUIModel()
end

--摄像机
function TargetProfile_UpdateCamera()

	local sex = CachedTarget:GetData("RACE")
	if sex ~= 0 and sex ~= 1 then 
		return
	end
		
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end
	
	if g_TargetProfile_ViewMode == 1 then
		if g_TargetProfile_RideCurSel >= g_TargetProfile_Type_Ride * 10 + 1 and g_TargetProfile_RideCurSel <= g_TargetProfile_Type_Ride * 10 + g_TargetProfile_MaxBtn then
			local CurSel = g_TargetProfile_RideCurSel - g_TargetProfile_Type_Ride * 10
			local nRideId = Exterior:LuaFnGetOtherProfileData(CurSel, "RIDE")
			if nRideId ~= nil and nRideId > 0 then		
				local nMountId = Exterior:LuaFnGetExteriorRideInfo(nRideId, "MountId")	
				Exterior:LuaFnUpdateOhterProfileAvatarMount(nMountId)	
				TargetProfile_FakeObject:SetFakeObject("Exterior_TargetProfile")			
				local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId, 0)	
				FakeObj_SetCamera("Exterior_TargetProfile", g_CameraHeight, fHeight)
				FakeObj_SetCamera("Exterior_TargetProfile", g_CameraDistance, fDistance)	
				return
			end
		end
	end
	
	local fHeight = g_CameraPosition[sex][g_Distance].fHeight
	local fDistance = g_CameraPosition[sex][g_Distance].fDistance
	local fPitch = g_CameraPosition[sex][g_Distance].fPitch

	FakeObj_SetCamera("Exterior_TargetProfile", g_CameraHeight, fHeight)
	FakeObj_SetCamera("Exterior_TargetProfile", g_CameraDistance, fDistance)
	FakeObj_SetCamera("Exterior_TargetProfile", g_CameraPitch, fPitch)

end

--左转
function TargetProfile_FakeObject_TurnLeft(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		TargetProfile_FakeObject:RotateBegin(-0.3)
	else
		TargetProfile_FakeObject:RotateEnd()
	end
	
end

--右转
function TargetProfile_FakeObject_TurnRight(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		TargetProfile_FakeObject:RotateBegin(0.3)
	else
		TargetProfile_FakeObject:RotateEnd()
	end
	
end

--缩小
function TargetProfile_ZoomOut()

	if g_Distance == 1 then
		return
	end
	
	g_Distance = g_Distance - 1	

	TargetProfile_UpdateCamera()
	
end

--放大
function TargetProfile_ZoomIn()

	if g_Distance == g_Distance_Max then
		return
	end
	
	g_Distance = g_Distance + 1	
	
	TargetProfile_UpdateCamera()

end

function TargetProfile_Frame_On_ResetPos()

	TargetProfile_Frame:SetProperty("UnifiedPosition", g_TargetProfile_UnifiedPosition);
	
end

--小问号
function TargetProfile_HelpClick()

	Helper:GotoHelper("grym")
	
end

-- 打开玩家装备UI
function TargetProfile_OtherEquip_Page_Switch()
	Variable:SetVariable("OtherUnionPos", TargetProfile_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenEquipFrame("other");
end

function TargetProfile_TargetData_Down()
	Variable:SetVariable("OtherUnionPos", TargetProfile_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end

-- 珍兽
--
function TargetProfile_OtherPet_Down()
	Variable:SetVariable("OtherUnionPos", TargetProfile_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end
--

--武魂
function TargetProfile_TargetWuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		TargetProfile_TargetWuhun : SetCheck(0)
		TargetProfile_ClearPage()
		return
	end
	
	Variable:SetVariable("OtherUnionPos", TargetProfile_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenOtherWuhun();
end

function TargetProfile_TargetLingyu_Switch()
	Variable:SetVariable("OtherUnionPos", TargetProfile_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherLingYuPage()
end

function TargetProfile_ShenBing_Switch()
	Variable:SetVariable("OtherUnionPos", TargetProfile_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherShenBingPage()
end

function TargetProfile_DWJinJie_Switch()
	Variable:SetVariable("OtherUnionPos", TargetProfile_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleOtherFeaturesPage()
end

function TargetProfile_OtherProfile_Switch()
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 15 then
		PushDebugMessage("#{GRYM_221213_162}")
		TargetProfile_ClearPage()
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetProfile_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherProfile()
end

function TargetProfile_Update_Like()
	local nLikeNum = Exterior:LuaFnGetOtherProfileData(1, "LIKE")
	if nLikeNum < 0 then
		nLikeNum = 0
	end
	local nLikeStr = ScriptGlobal_Format("#{GRYM_221213_30}", nLikeNum)
	TargetProfile_Dress_LikeBtn_Text:SetText(nLikeStr)
	nLikeStr = ScriptGlobal_Format("#{GRYM_221213_48}", Exterior:LuaFnGetOtherProfileData(1, "GIVE"))
	TargetProfile_Frame_LikeBtn:SetToolTip(nLikeStr)
end

function TargetProfile_ShowPage()

	for i = 1, 9 do
		g_PageButton[i]:Hide()
	end
		
	local nPageNumber = tonumber(Variable:GetVariable("TargetPageNumber"));
	TargetProfile_ClearPage()
	
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, 9 do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, 9 do
		if TargetProfile_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)
			g_PageOrder[g_PageCount] = i
		end
	end
end

function TargetProfile_CheckPage(idx)
	if idx == 1 then--装备
		return 1
	elseif idx == 2 then--资料
		return 1
	elseif idx == 3 then--珍兽
		return 1
	elseif idx == 4 then--武魂
		return 1
	elseif idx == 5 then--灵玉
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 6 then--神兵
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 7 then--雕文进阶
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 8 then--巅峰 
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		return 1
	elseif idx == 9 then--雕文进阶
		return 1
	end
	return 0
end

function TargetProfile_ClearPage()
	Variable:SetVariable("TargetPageNumber", tostring(0), 1)
end

function TargetProfile_OnPageClicked(idx)

	Variable:SetVariable("TargetPageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]

	if idx == 1 then--装备
		TargetProfile_OtherEquip_Page_Switch()
	elseif idx == 2 then--资料
		TargetProfile_TargetData_Down()
	elseif idx == 3 then--珍兽
		TargetProfile_OtherPet_Down()
	elseif idx == 4 then--武魂
		TargetProfile_TargetWuhun_Switch()
	elseif idx == 5 then--灵玉
		TargetProfile_TargetLingyu_Switch()
	elseif idx == 6 then--神兵
		TargetProfile_ShenBing_Switch()
	elseif idx == 7 then--雕文进阶
		TargetProfile_DWJinJie_Switch()
	elseif idx == 8 then
		TargetProfile_TargetPeak_Switch()
	elseif idx == 9 then
		TargetProfile_ClearPage()		
	end
end

function TargetProfile_BeginCareObject(objCaredId)

	if (type(objCaredId) == "number") then
		g_objCared = objCaredId;
		this:CareObject(g_objCared, 1, "TargetProfile");
	else
		return;
	end

end

--=========================================================
--停止对某OBJ的关心
--=========================================================
function TargetProfile_StopCareObject(objCaredId)

	if (type(objCaredId) == "number") then
		this:CareObject(objCaredId, 0, "TargetProfile");
		g_objCared = -1;
	else
		return;
	end

end
function TargetProfile_TargetPeak_Switch()
	--if ZBS:IsZBSFinalDFengBanFlag() == 1 then
	--	PushDebugMessage("#{WCBZ_250812_1}")
	--    return 0
	--end
	local lv = CachedTarget:GetData("LEVEL", 1);
	if lv < 85 then
		PushDebugMessage("#{DFJC_250709_83}")
		TargetProfile_Peak:SetCheck(0)
		return
	end
	Variable:SetVariable("OtherUnionPos", TargetProfile_Frame:GetProperty("UnifiedPosition"), 1)
	--SystemSetup:Lua_OpenDFengOther()
	local eLoad = GetTargetPlayerGUID();
	if eLoad ~=nil and eLoad ~= -1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GetTargetWuJingData");
			Set_XSCRIPT_ScriptID(502161);
			Set_XSCRIPT_Parameter(0,tonumber(eLoad));
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	this:Hide();
end
--!!!reloadscript =TargetProfile