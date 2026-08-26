
--!!!reloadscript =Profile

local g_Profile_UnifiedPosition = ""

local g_Profile_Type_Dress = 1
local g_Profile_Type_Ride = 2
local g_Profile_Type_Weapon = 3

local g_Profile_MaxBtn = 6
local g_Profile_DressCurSel = 0
local g_Profile_WeaponCurSel = 0
local g_Profile_RideCurSel = 0
local g_Profile_ViewMode = 0	--0??? 1????

local g_Profile_Tag_Text = {}
local g_Profile_Dress_Btn = {}
local g_Profile_Dress_Mark = {}
local g_Profile_Dress_Luxury = {}
local g_Profile_Ride_Btn = {}
local g_Profile_Ride_Luxury = {}
local g_Profile_Ride_Time = {}
local g_Profile_Weapon_Btn = {}
local g_Profile_Weapon_Time = {}

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4

local m_PlayerfashionDepotType = 1 	--???? 1 ?????? 2 ??????

local g_CameraHeight = 1     --?????
local g_CameraDistance = 2   --?????
local g_CameraPitch = 3      --?????
local g_CameraPosition =
{
	--Å®ÐÔÏà¹ØÎ»ÖÃ
	[0] = {
		{fHeight = 0.82, fDistance = 8, fPitch=0.1},
		{fHeight = 0.82, fDistance = 6.5, fPitch=0.1},
		{fHeight = 1.5, fDistance = 2.5, fPitch=0.10},
		{fHeight = 1.57, fDistance = 1.7, fPitch=0.10}
	},
	--ÄÐÐÔÏà¹ØÎ»ÖÃ
	[1] = {
		{fHeight = 0.91, fDistance = 8.8, fPitch=0.2},
		{fHeight = 0.91, fDistance = 7.1, fPitch=0.2},
		{fHeight = 1.67, fDistance = 2.5, fPitch=0.2},
		{fHeight = 1.745, fDistance = 1.7, fPitch=0.2}
	},
}

local SELF_PAGE  = 0;
local OTHER_PAGE = 1;
local g_Current_Page;

--Í³Ò»»¯ÏÂÒ³Ç©ÏÔÊ¾Òþ²Ø Ä¿Ç°¹Ì¶¨Ë³Ðò ÐÂÔö¸ÄÐòºÅ Ã¿¸öÒ³Ç©¶¼ÐèÒªÌí¼Ó
local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		NeedCheck = 0,Tip = ""},
	[2] = {Text = "#{INTERFACE_XML_882}",		NeedCheck = 0,Tip = ""},
	[3] = {Text = "#{INTERFACE_XML_854}",		NeedCheck = 0,Tip = ""},
	[4] = {Text = "#{WH_xml_XX(95)}",			NeedCheck = 0,Tip = ""},
	[5] = {Text = "#{XL_XML_35}",				NeedCheck = 0,Tip = ""},
	[6] = {Text = "#{TalentMP_20210804_57}",	NeedCheck = 1,Tip = ""},
	[7] = {Text = "#{SZXT_221216_22}",			NeedCheck = 0,Tip = "#{SZXT_221216_23}"},
	[8] = {Text = "#{SBFW_20230707_1}",		NeedCheck = 1,Tip = "#{SBFW_20230707_2}"},
	[9] = {Text = "#{DWJJ_240329_153}",  	 	NeedCheck = 0,Tip = ""},
	[10] = {Text = "#{DFJC_250709_1}",		NeedCheck = 0,Tip = ""},
	[11] = {Text = "#{GRYM_221213_22}",  	 	NeedCheck = 0,Tip = ""},
	[12] = {Text = "#{INTERFACE_XML_496}",		NeedCheck = 0,Tip = ""},

}
local g_PageButton = {}
local g_PageTip = {}
local g_PageMask = {}
local g_MaxPage = 12
local g_PageCount = 12
local g_PageOrder = {}

local g_Profile_Tag_Num = 0
local g_Profile_Tag_CanChoose = 6
--=========
--PreLoad==
--=========
function Profile_PreLoad()

	this:RegisterEvent("OPEN_EXTERIOR_PROFILE")
		
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("ADD_EXTERIOR",false)
	this:RegisterEvent("UPDATE_EXTERIOR",false)
	this:RegisterEvent("EXTERIOR_OUTTIME",false)
	this:RegisterEvent("EXTERIOR_ID_CHANGED",false)
	
	this:RegisterEvent("ADD_EXTERIOR_WEAPON", false)
	this:RegisterEvent("UPDATE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("EXTERIOR_OUTTIME_WEAPON", false)
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_CHANGED", false)	
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_LEVEL_CHANGED", false)
	
	this:RegisterEvent("UPDATE_EXTERIOR_FASHION",false)
	
end

--=========
--OnLoad
--=========
function Profile_OnLoad()

	g_Profile_UnifiedPosition = Profile_Frame:GetProperty("UnifiedPosition")
	
	g_Profile_Tag_Text[1] = Profile_Frame_Tag_TagText1
	g_Profile_Tag_Text[2] = Profile_Frame_Tag_TagText2
	g_Profile_Tag_Text[3] = Profile_Frame_Tag_TagText3
	g_Profile_Tag_Text[4] = Profile_Frame_Tag_TagText4
	g_Profile_Tag_Text[5] = Profile_Frame_Tag_TagText5
	g_Profile_Tag_Text[6] = Profile_Frame_Tag_TagText6
	
	-- ¹Ê¾
	g_Profile_Dress_Btn[1] = Profile_Frame_Dress_Object1
	g_Profile_Dress_Btn[2] = Profile_Frame_Dress_Object2
	g_Profile_Dress_Btn[3] = Profile_Frame_Dress_Object3
	g_Profile_Dress_Btn[4] = Profile_Frame_Dress_Object4
	g_Profile_Dress_Btn[5] = Profile_Frame_Dress_Object5
	g_Profile_Dress_Btn[6] = Profile_Frame_Dress_Object6
	
	g_Profile_Dress_Mark[1] = Profile_Frame_Dress_Object1Select
	g_Profile_Dress_Mark[2] = Profile_Frame_Dress_Object2Select
	g_Profile_Dress_Mark[3] = Profile_Frame_Dress_Object3Select
	g_Profile_Dress_Mark[4] = Profile_Frame_Dress_Object4Select
	g_Profile_Dress_Mark[5] = Profile_Frame_Dress_Object5Select
	g_Profile_Dress_Mark[6] = Profile_Frame_Dress_Object6Select
	
	g_Profile_Dress_Luxury[1] = Profile_Frame_Dress_Object1Luxury
	g_Profile_Dress_Luxury[2] = Profile_Frame_Dress_Object2Luxury
	g_Profile_Dress_Luxury[3] = Profile_Frame_Dress_Object3Luxury
	g_Profile_Dress_Luxury[4] = Profile_Frame_Dress_Object4Luxury
	g_Profile_Dress_Luxury[5] = Profile_Frame_Dress_Object5Luxury
	g_Profile_Dress_Luxury[6] = Profile_Frame_Dress_Object6Luxury
	
	g_Profile_Ride_Btn[1] = Profile_Frame_Ride_Object1
	g_Profile_Ride_Btn[2] = Profile_Frame_Ride_Object2
	g_Profile_Ride_Btn[3] = Profile_Frame_Ride_Object3
	g_Profile_Ride_Btn[4] = Profile_Frame_Ride_Object4
	g_Profile_Ride_Btn[5] = Profile_Frame_Ride_Object5
	g_Profile_Ride_Btn[6] = Profile_Frame_Ride_Object6
	
	g_Profile_Ride_Luxury[1] = Profile_Frame_Ride_Object1Luxury
	g_Profile_Ride_Luxury[2] = Profile_Frame_Ride_Object2Luxury
	g_Profile_Ride_Luxury[3] = Profile_Frame_Ride_Object3Luxury
	g_Profile_Ride_Luxury[4] = Profile_Frame_Ride_Object4Luxury
	g_Profile_Ride_Luxury[5] = Profile_Frame_Ride_Object5Luxury
	g_Profile_Ride_Luxury[6] = Profile_Frame_Ride_Object6Luxury
	
	g_Profile_Ride_Time[1] = Profile_Frame_Ride_Object1Time
	g_Profile_Ride_Time[2] = Profile_Frame_Ride_Object2Time
	g_Profile_Ride_Time[3] = Profile_Frame_Ride_Object3Time
	g_Profile_Ride_Time[4] = Profile_Frame_Ride_Object4Time
	g_Profile_Ride_Time[5] = Profile_Frame_Ride_Object5Time
	g_Profile_Ride_Time[6] = Profile_Frame_Ride_Object6Time
	
	g_Profile_Weapon_Btn[1] = Profile_Frame_Weapon_Object1
	g_Profile_Weapon_Btn[2] = Profile_Frame_Weapon_Object2
	g_Profile_Weapon_Btn[3] = Profile_Frame_Weapon_Object3
	g_Profile_Weapon_Btn[4] = Profile_Frame_Weapon_Object4
	g_Profile_Weapon_Btn[5] = Profile_Frame_Weapon_Object5
	g_Profile_Weapon_Btn[6] = Profile_Frame_Weapon_Object6
	
	g_Profile_Weapon_Time[1] = Profile_Frame_Weapon_Object1Time
	g_Profile_Weapon_Time[2] = Profile_Frame_Weapon_Object2Time
	g_Profile_Weapon_Time[3] = Profile_Frame_Weapon_Object3Time
	g_Profile_Weapon_Time[4] = Profile_Frame_Weapon_Object4Time
	g_Profile_Weapon_Time[5] = Profile_Frame_Weapon_Object5Time
	g_Profile_Weapon_Time[6] = Profile_Frame_Weapon_Object6Time
	
	-- ·ÖÒ³°´Å¥
	g_PageButton[1] = Profile_SelfEquip
	g_PageButton[2] = Profile_SelfData
	g_PageButton[3] = Profile_Pet
	g_PageButton[4] = Profile_Wuhun
	g_PageButton[5] = Profile_Xiulian
	g_PageButton[6] = Profile_Talent
	g_PageButton[7] = Profile_Lingyu
	g_PageButton[8] = Profile_Weapon2
	g_PageButton[9] = Profile_DWJinJie
	g_PageButton[10] = Profile_Peak
	g_PageButton[11] = Profile_Profile
	g_PageButton[12] = Profile_OtherInfo

	
	g_PageMask[1] = Profile_SelfEquip_Mask
	g_PageMask[2] = Profile_SelfData_Mask
	g_PageMask[3] = Profile_Pet_Mask
	g_PageMask[4] = Profile_Wuhun_Mask
	g_PageMask[5] = Profile_Xiulian_Mask
	g_PageMask[6] = Profile_Talent_Mask
	g_PageMask[7] = Profile_Lingyu_Mask
	g_PageMask[8] = Profile_Weapon2_Mask
	g_PageMask[9] = Profile_DWJinJie_Mask
	g_PageMask[10] = Profile_Peak_Mask	
	g_PageMask[11] = Profile_Profile_Mask
	g_PageMask[12] = Profile_OtherInfo_Mask	
	

	
	g_PageTip[1] = Profile_SelfEquip_tips
	g_PageTip[2] = Profile_SelfData_tips
	g_PageTip[3] = Profile_Pet_tips
	g_PageTip[4] = Profile_Wuhun_tips
	g_PageTip[5] = Profile_Xiulian_tips
	g_PageTip[6] = Profile_Talent_tips
	g_PageTip[7] = Profile_Lingyu_tips
	g_PageTip[8] = Profile_Weapon2_tips
	g_PageTip[9] = Profile_DWJinJie_tips
	g_PageTip[10] = Profile_Peak_tips
	g_PageTip[11] = Profile_Profile_tips
	g_PageTip[12] = Profile_OtherInfo_tips
	

	
end

--=========
--OnEvent
--=========
function Profile_OnEvent(event)
	
	if event == "OPEN_EXTERIOR_PROFILE" then
		if this:IsVisible() then
			if (arg0 == "tag") then

				Profile_CleanUp_Tag()
			
				Profile_Update_Tag()
			
			elseif (arg0 == "dress") then
			
				Profile_CleanUp_Dress()
				
				g_Profile_DressCurSel = 0
			
				Profile_Update_Button_Dress()
				
				Profile_UpdateObj()	
			
			elseif (arg0 == "ride") then
	
				Profile_CleanUp_Ride()
				
				g_Profile_RideCurSel = 0
				g_Profile_ViewMode = 0
			
				Profile_Update_Button_Ride()
				
				Profile_UpdateObj()	
			
			elseif (arg0 == "weapon") then
	
				Profile_CleanUp_Weapon()
				
				g_Profile_WeaponCurSel = 0
			
				Profile_Update_Button_Weapon()
				
				Profile_UpdateObj()	
			
			end			
		else	
			if (arg0 == "self") then
				local selfUnionPos = Variable:GetVariable("SelfUnionPos");
				if (selfUnionPos ~= nil) then
					Profile_Frame:SetProperty("UnifiedPosition", selfUnionPos);
				end
			
				g_Current_Page = SELF_PAGE;
			
				Profile_Show()
				
				Profile_FakeObject:SetFakeObject("Exterior_Profile")		
				Profile_UpdateCamera()
			end
		end
		return
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			Profile_CloseClick()
		end
	end
	
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯ or ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Profile_Frame_On_ResetPos()
	end
	
	if event == "UPDATE_EXTERIOR_FASHION" 
		or event == "ADD_EXTERIOR" 
		or event == "UPDATE_EXTERIOR" 
		or event == "EXTERIOR_OUTTIME" 
		or event == "EXTERIOR_ID_CHANGED" 
		or event == "ADD_EXTERIOR_WEAPON" 
		or event == "UPDATE_EXTERIOR_WEAPON" 
		or event == "EXTERIOR_OUTTIME_WEAPON"
		or event == "DEF_EXTERIOR_WEAPON_CHANGED"
		or event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		
		if this:IsVisible() then
			Profile_UpdateObj()	
			
			Profile_Update_Button_RideLeftTime()
		end
		
	end
	
end

-- ÏÔÊ¾×Ô¼º
function Profile_Show()		
		
	this:Show()
	
	g_Distance = g_Distance_Ori
	
	Profile_CleanUp()
	
	-- Òþ²ØµãÔÞ°´Å¥
	Profile_Frame_LikeBtn:Hide()
	-- µãÔÞÊý
	local nLikeNum = Exterior:LuaFnExteriorPlayerGetProfileData(1, "LIKE")
	if nLikeNum < 0 then
		nLikeNum = 0
	end
	local nLikeStr = ScriptGlobal_Format("#{GRYM_221213_30}", nLikeNum)
	Profile_Dress_LikeBtn_Text:SetText(nLikeStr)
			
	--Í¼±ê
	Profile_Update_Button()	
	
	--Ä£ÐÍ
	Profile_UpdateObj()
	
	--±êÇ©
	Profile_Update_Tag()
	
	--Ò³Ç©
	Profile_ShowPage()
	Profile_UpdateRedPoint()
end
	
--±êÇ©
function Profile_Update_Tag()
		
	local nIndex = 1
	for i = 1, g_Profile_Tag_CanChoose do
		local nSelId = Exterior:LuaFnExteriorPlayerGetTagChoose(i-1)
		if nSelId > 0 then			
			local nId, nType, nStr, nValid = Exterior:LuaFnExteriorPlayerGetTagChooseInfo( nSelId )
			if nId > 0 and nValid == 1 then			
				g_Profile_Tag_Text[nIndex]:Show()
				nStr = "#{"..nStr.."}"
				g_Profile_Tag_Text[nIndex]:SetText(nStr)
				nIndex = nIndex + 1
			end
		end
	end
	
end

function Profile_Update_Button_Dress()
	for i in pairs(g_Profile_Dress_Btn) do
		local cacheExteriorIDX, cacheDressId, strName, strIcon = Exterior:LuaFnExteriorPlayerGetProfileData(i, "DRESS")
		if cacheExteriorIDX ~= nil and cacheExteriorIDX >= 0 and cacheDressId ~= nil and cacheDressId > 0 then
			local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(m_PlayerfashionDepotType, cacheExteriorIDX)
			if theAction:GetID() ~= 0 then
				g_Profile_Dress_Btn[i]:SetActionItem(theAction:GetID())
								
				g_Profile_Dress_Luxury[i]:Hide()
				local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(cacheDressId, "Number")
				if nFashionNumber ~= nil and nFashionNumber > 0 then
					g_Profile_Dress_Luxury[i]:Show()
				end
			else
				g_Profile_Dress_Btn[i]:SetActionItem(-1)
			end	
		end
		--g_Profile_Dress_Btn[i]:SetPushed(0)
		g_Profile_Dress_Mark[i]:Hide()
	end
end

function Profile_Update_Button_RideLeftTime()
	for i in pairs(g_Profile_Ride_Btn) do
		local cacheExteriorID, nLeftTime = Exterior:LuaFnExteriorPlayerGetProfileData(i, "RIDE")
		if cacheExteriorID ~= nil and cacheExteriorID > 0 and Exterior:LuaFnIsHaveExterior(3, cacheExteriorID) == 1 then
			local strTemp = Exterior:LuaFnGetRideToolTip(cacheExteriorID)
			g_Profile_Ride_Btn[i]:SetToolTip(strTemp)	

			local nLeftTime = Exterior:LuaFnGetExteriorLeftTime(3, cacheExteriorID)
			if nLeftTime and nLeftTime < 0 then
				g_Profile_Ride_Time[i]:Hide()
			elseif nLeftTime and nLeftTime == 0 then
				g_Profile_Ride_Time[i]:Show()
			elseif nLeftTime and nLeftTime > 0 then
				g_Profile_Ride_Time[i]:Show()
			end	
		end
	end
end

function Profile_Update_Button_Ride()
	for i in pairs(g_Profile_Ride_Btn) do
		local cacheExteriorID, nLeftTime = Exterior:LuaFnExteriorPlayerGetProfileData(i, "RIDE")
		if cacheExteriorID ~= nil and cacheExteriorID > 0 and Exterior:LuaFnIsHaveExterior(3, cacheExteriorID) == 1 then
			local nLuxury = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Luxury")
			local strName = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Name")
			local strIcon = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Icon")
			local strImage = GetIconFullName(strIcon)
			
			g_Profile_Ride_Btn[i]:SetProperty("Empty", "False")
			g_Profile_Ride_Btn[i]:SetProperty("UseDefaultTooltip", "True")
			g_Profile_Ride_Btn[i]:SetProperty("NormalImage", strImage)
			g_Profile_Ride_Btn[i]:SetProperty("HoverImage", strImage)
			
			local strTemp = Exterior:LuaFnGetRideToolTip(cacheExteriorID)
			g_Profile_Ride_Btn[i]:SetToolTip(strTemp)	

			local nLeftTime = Exterior:LuaFnGetExteriorLeftTime(3, cacheExteriorID)
			if nLeftTime and nLeftTime < 0 then
				g_Profile_Ride_Time[i]:Hide()
			elseif nLeftTime and nLeftTime == 0 then
				g_Profile_Ride_Time[i]:Show()
			elseif nLeftTime and nLeftTime > 0 then
				g_Profile_Ride_Time[i]:Show()
			end	
			
			if nLuxury == 1 or nLuxury == 2 then
				g_Profile_Ride_Luxury[i]:Show()
			else
				g_Profile_Ride_Luxury[i]:Hide()
			end
		end
		g_Profile_Ride_Btn[i]:SetPushed(0)
	end
end

function Profile_Update_Button_Weapon()
	for i in pairs(g_Profile_Weapon_Btn) do
		local cacheExteriorID, cacheWeaponLevel, nLeftTime = Exterior:LuaFnExteriorPlayerGetProfileData(i, "WEAPON")
		if cacheExteriorID ~= nil and cacheExteriorID > 0 and Exterior:LuaFnIsHaveExteriorWeapon(cacheExteriorID) == 1 then
			local strName = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
			local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
			local strImage = GetIconFullName(strIcon)	
			
			g_Profile_Weapon_Btn[i]:SetProperty("Empty", "False")
			g_Profile_Weapon_Btn[i]:SetProperty("UseDefaultTooltip", "True")
			g_Profile_Weapon_Btn[i]:SetProperty("NormalImage", strImage)
			g_Profile_Weapon_Btn[i]:SetProperty("HoverImage", strImage)
			
			local strTemp = Exterior:LuaFnGetExteriorWeaponToolTip(cacheExteriorID)
			g_Profile_Weapon_Btn[i]:SetToolTip(strTemp)
			
			local nLeftTime = Exterior:LuaFnGetExteriorWeaponLeftTime(cacheExteriorID)
			if nLeftTime and nLeftTime < 0 then
				g_Profile_Weapon_Time[i]:Hide()
			elseif nLeftTime and nLeftTime == 0 then
				g_Profile_Weapon_Time[i]:Show()
			elseif nLeftTime and nLeftTime > 0 then
				g_Profile_Weapon_Time[i]:Show()
			end
		end
		g_Profile_Weapon_Btn[i]:SetPushed(0)
	end
end

--Í¼±ê
function Profile_Update_Button()
	
	-- Ê±×°
	Profile_Update_Button_Dress()
	
	-- ×øÆï
	Profile_Update_Button_Ride()
	
	-- »ÃÎä
	Profile_Update_Button_Weapon()
	
end
	
--Ä£ÐÍ
function Profile_UpdateObj()

	Profile_FakeObject:SetFakeObject("")
	
	local CurDressSel = g_Profile_DressCurSel - g_Profile_Type_Dress * 10
	if CurDressSel < 1 or CurDressSel > g_Profile_MaxBtn then
		CurDressSel = 0
	end
	local CurRideSel = g_Profile_RideCurSel - g_Profile_Type_Ride * 10
	if CurRideSel < 1 or CurRideSel > g_Profile_MaxBtn then
		CurRideSel = 0
	end
	local CurWeaponSel = g_Profile_WeaponCurSel - g_Profile_Type_Weapon * 10
	if CurWeaponSel < 1 or CurWeaponSel > g_Profile_MaxBtn then
		CurWeaponSel = 0
	end
	Exterior:LuaFnUpdateExteriorSharePlayerData(CurDressSel, CurRideSel, CurWeaponSel)
	
	if g_Profile_ViewMode == 0 then					
		Profile_Model_Plus:Show()
		Profile_Model_Subtract:Show()
		
		Exterior:LuaFnUpdateExteriorProfileAvatarMount(-1)	
		Profile_FakeObject:SetFakeObject("Exterior_Profile")		
	end
	
	Profile_UpdateCamera()
	
end

--µãÑ¡×øÆï
function Profile_Ride_ObjectClick( nIdx )
	
	if ( g_Current_Page ~= SELF_PAGE ) then
		return
	end
	
	if g_Profile_Ride_Btn[nIdx] == nil then
		return
	end
	
	local cacheExteriorID = Exterior:LuaFnExteriorPlayerGetProfileData(nIdx, "RIDE")
	if cacheExteriorID == nil or cacheExteriorID <= 0 or Exterior:LuaFnIsHaveExterior(3, cacheExteriorID) ~= 1 then
		return
	end
	
	for i in pairs(g_Profile_Ride_Btn) do
		g_Profile_Ride_Btn[i]:SetPushed(0)
	end
	
	local nNewSel = g_Profile_Type_Ride * 10 + nIdx
	if nNewSel == g_Profile_RideCurSel then
		g_Profile_RideCurSel = 0
		g_Profile_ViewMode = 0				
		Profile_Model_Plus:Show()
		Profile_Model_Subtract:Show()
		Profile_UpdateObj()
		return
	end
	
	g_Profile_RideCurSel = nNewSel
	g_Profile_Ride_Btn[nIdx]:SetPushed(1)	
	
	Profile_FakeObject:SetFakeObject("")

	local nRideID = Exterior:LuaFnExteriorPlayerGetProfileData(nIdx, "RIDE")
	if nRideID ~= nil and nRideID > 0 then	
		Exterior:LuaFnUpdateExteriorProfileAvatar("RIDE", nIdx)

		Profile_FakeObject:SetFakeObject("Exterior_Profile")	

		local nMountId = Exterior:LuaFnGetExteriorRideInfo(nRideID, "MountId")	
		local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId, 0)
		FakeObj_SetCamera("Exterior_Profile", g_CameraHeight, fHeight)
		FakeObj_SetCamera("Exterior_Profile", g_CameraDistance, fDistance)

		g_Profile_ViewMode = 1	
		Profile_Model_Plus:Hide()
		Profile_Model_Subtract:Hide()
	end
	
end

--µãÑ¡»ÃÎä
function Profile_Weapon_ObjectClick( nIdx )
	
	if ( g_Current_Page ~= SELF_PAGE ) then
		return
	end

	if g_Profile_Weapon_Btn[nIdx] == nil then
		return
	end
	
	local cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnExteriorPlayerGetProfileData(nIdx, "WEAPON")
	if cacheExteriorID == nil or cacheExteriorID <= 0 or Exterior:LuaFnIsHaveExteriorWeapon(cacheExteriorID) ~= 1 then
		return
	end
	
	for i in pairs(g_Profile_Weapon_Btn) do
		g_Profile_Weapon_Btn[i]:SetPushed(0)
	end
	
	local nNewSel = g_Profile_Type_Weapon * 10 + nIdx
	if nNewSel == g_Profile_WeaponCurSel then
		g_Profile_WeaponCurSel = 0
		Profile_UpdateObj()
		return
	end
	
	g_Profile_WeaponCurSel = nNewSel
	g_Profile_Weapon_Btn[nIdx]:SetPushed(1)
	
	Exterior:LuaFnUpdateExteriorProfileAvatar("WEAPON", nIdx)	
	Profile_UpdateCamera()
	
end

--µãÑ¡Ê±×°
function Profile_Dress_ObjectClick( nIdx )
	
	if ( g_Current_Page ~= SELF_PAGE ) then
		return
	end

	if g_Profile_Dress_Btn[nIdx] == nil then
		return
	end
	
	local cacheExteriorIDX, cacheDressId, strName, strIcon = Exterior:LuaFnExteriorPlayerGetProfileData(nIdx, "DRESS")
	if cacheExteriorIDX == nil or cacheExteriorIDX < 0 or cacheDressId == nil or cacheDressId <= 0 then
		return
	end
	
	for i in pairs(g_Profile_Dress_Btn) do
		--g_Profile_Dress_Btn[i]:SetPushed(0)
		g_Profile_Dress_Mark[i]:Hide()
	end
	
	local nNewSel = g_Profile_Type_Dress * 10 + nIdx
	if nNewSel == g_Profile_DressCurSel then
		g_Profile_DressCurSel = 0
		Profile_UpdateObj()
		return
	end
	
	g_Profile_DressCurSel = nNewSel
	--g_Profile_Dress_Btn[nIdx]:SetPushed(1)
	g_Profile_Dress_Mark[nIdx]:Show()
	
	Exterior:LuaFnUpdateExteriorProfileAvatar("DRESS", nIdx)	
	Profile_UpdateCamera()
	
end

function Profile_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"));
	Profile_ClearPage()
	
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, g_MaxPage do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, g_MaxPage do
		if Profile_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if Profile_IsPageEnable(i) == 1 then
				g_PageButton[g_PageCount]:Enable()
				g_PageMask[g_PageCount]:Disable()
			else
				g_PageButton[g_PageCount]:Disable()
				g_PageMask[g_PageCount]:Show()
				g_PageMask[g_PageCount]:SetToolTip(g_Page[i].Tip)
			end
		end
	end
end

function Profile_OnPageClicked(idx)

	Variable:SetVariable("PageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]

	if idx == 1 then--??
		Profile_SelfEquip_Down()
	elseif idx == 2 then--??
		Profile_SelfData_Down()
	elseif idx == 3 then--??
		Profile_Pet_Down()
	elseif idx == 4 then--??
		Profile_Wuhun_Switch()
	elseif idx == 5 then--??
		Profile_Xiulian_Switch()
	elseif idx == 6 then--??
		Profile_Talent_Switch()
	elseif idx == 7 then--??
		Profile_Page_LingYu()
	elseif idx == 8 then--??
		Profile_Page_ShenBing()
	elseif idx == 9 then--????
		Profile_Page_DWJinJie()
	elseif idx == 10 then--??
		Profile_Page_Peak()
	elseif idx == 11 then--??
		Profile_ClearPage()
	elseif idx == 12 then--??
		Profile_Other_Info_Switch()
	end
end

function Profile_CheckPage(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return DataPool:Lua_CheckIsShowTalent()
	elseif idx == 7 then--??
		return 1
	elseif idx == 8 then--??
		return 1
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??

		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end

	elseif idx == 11 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 15 then
			return 1
		end
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function Profile_IsPageEnable(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return 1
	elseif idx == 7 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 8 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 65 then
			return 1
		end
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??


		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--??
		return 1
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function Profile_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--¸üÐÂ·ÖÒ³ºìµã
function Profile_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

-- ´ò¿ª×°±¸
function Profile_SelfEquip_Down()
	if ( g_Current_Page == SELF_PAGE ) then
		Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("self");
	end
end

--´ò¿ª×Ô¼ºµÄ×ÊÁÏÒ³Ãæ
function Profile_SelfData_Down()

	if ( g_Current_Page == SELF_PAGE ) then
		Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenPrivatePage("self");
	end

end

--ÏÔÊ¾ äÊÞ½çÃæ
function Profile_Pet_Down()

	if ( g_Current_Page == SELF_PAGE ) then
		Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenPetFrame("self");	
	end		
	
end

--ÏÔÊ¾Îä»êUI
function Profile_Wuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		Profile_Wuhun : SetCheck(0)
		Profile_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1);	
	ToggleWuhunPage();
end

--ÏÔÊ¾ÐÞÁ¶UI
function Profile_Xiulian_Switch()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		Profile_Xiulian : SetCheck(0)
		Profile_ClearPage()
		return
	end
	
    nLevel = Player:GetData("LEVEL")
	if(nLevel >= 70) then
		Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1);
		XiuLianPage();
	else
	    Profile_Xiulian : SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    Profile_ClearPage()
	end
end

--ÏÔÊ¾ÎäµÀUI
function Profile_Talent_Switch()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1);
		ToggleTalentPage();
	else
		Profile_Talent : SetCheck(0)
		Profile_ClearPage()
	end
end

function Profile_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		Profile_Lingyu:SetCheck(0)
		Profile_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function Profile_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		Profile_Weapon2:SetCheck(0)
		Profile_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function Profile_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		Profile_DWJinJie:SetCheck(0)
		Profile_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end

--ÏÔÊ¾ÆäËûUI
function Profile_Other_Info_Switch()
	Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
    UpdateDoubleExpData();
end

--ÇÐ»»×øÆï
function Profile_Ride_SwithViewMode()

	if g_Profile_RideCurSel >= g_Profile_Type_Ride * 10 + 1 and g_Profile_RideCurSel <= g_Profile_Type_Ride * 10 + g_Profile_MaxBtn then
		local CurSel = g_Profile_RideCurSel - g_Profile_Type_Ride * 10
		local nRideId = Exterior:LuaFnExteriorPlayerGetProfileData(CurSel, "RIDE")
		if nRideId ~= nil and nRideId > 0 then
			if g_Profile_ViewMode == 0 then
				g_Profile_ViewMode = 1	

				Profile_Model_Plus:Hide()
				Profile_Model_Subtract:Hide()
			else
				g_Profile_ViewMode = 0
				
				Profile_Model_Plus:Show()
				Profile_Model_Subtract:Show()
			end	
				
			Profile_UpdateObj()
		end	
	end

end

--µãÔÞ
function Profile_Frame_LikeBtn_Clicked()
end

--·ÖÏí
function Profile_Frame_ShareBtn_Clicked()

	if g_Profile_DressCurSel >= g_Profile_Type_Dress * 10 + 1 and g_Profile_DressCurSel <= g_Profile_Type_Dress * 10 + g_Profile_MaxBtn then
		local CurSel = g_Profile_DressCurSel - g_Profile_Type_Dress * 10
		if g_Profile_Dress_Btn[CurSel] == nil then
			PushDebugMessage("Chia xë th¤t bÕi")
		else
			Exterior:LuaFnExteriorPlayerShareClick(CurSel)
		end
	else
		PushDebugMessage("Chia xë th¤t bÕi")
	end
	
end

--±à¼­tag
function Profile_Tag_ChangeBtn_Clicked()
	if IsWindowShow("Profile_TagChoose") then
		CloseWindow("Profile_TagChoose", true)
	else
		Exterior:LuaFnExteriorProfileAskData(3)
	end
end

--±à¼­Ê±×°
function Profile_Dress_ChangeBtn_Clicked()
	if IsWindowShow("Profile_DressChoose") then
		CloseWindow("Profile_DressChoose", true)
	else
		Exterior:LuaFnExteriorProfileAskData(0)
	end
end

--±à¼­×øÆï
function Profile_Ride_ChangeBtn_Clicked()
	if IsWindowShow("Profile_RideChoose") then
		CloseWindow("Profile_RideChoose", true)
	else
		Exterior:LuaFnExteriorProfileAskData(1)
	end
end

--±à¼­»ÃÎä
function Profile_WeaponChangeBtn_Clicked()
	if IsWindowShow("Profile_WeaponChoose") then
		CloseWindow("Profile_WeaponChoose", true)
	else
		Exterior:LuaFnExteriorProfileAskData(2)
	end
end

--¹Ø± °´Å¥
function Profile_CloseClick()	
		
	this:Hide()
	
end

function Profile_OnHidden()
	
	Profile_CleanUp()
	
	Profile_CloseSameGroupWindow()
	
end

function Profile_CleanUp_Tag()
		
	for i in pairs(g_Profile_Tag_Text) do
		g_Profile_Tag_Text[i]:SetText("")
		g_Profile_Tag_Text[i]:Hide()
	end
	
end

function Profile_CleanUp_Dress()
		
	for i in pairs(g_Profile_Dress_Btn) do
		g_Profile_Dress_Btn[i]:SetActionItem(-1)		
		g_Profile_Dress_Mark[i]:Hide()		
		g_Profile_Dress_Luxury[i]:Hide()
	end
	
end

function Profile_CleanUp_Ride()
		
	for i in pairs(g_Profile_Ride_Btn) do
		g_Profile_Ride_Btn[i]:SetProperty("NormalImage", "")
		g_Profile_Ride_Btn[i]:SetProperty("HoverImage", "")
		g_Profile_Ride_Btn[i]:SetToolTip("")
		g_Profile_Ride_Luxury[i]:Hide()
		g_Profile_Ride_Time[i]:Hide()
	end
	
end

function Profile_CleanUp_Weapon()

	for i in pairs(g_Profile_Weapon_Btn) do
		g_Profile_Weapon_Btn[i]:SetProperty("NormalImage", "")
		g_Profile_Weapon_Btn[i]:SetProperty("HoverImage", "")
		g_Profile_Weapon_Btn[i]:SetToolTip("")
		g_Profile_Weapon_Time[i]:Hide()
	end
	
end

--Çå¿ ´îÅä ¹Ê¾
function Profile_CleanUp()

	Profile_FakeObject:SetFakeObject("")
	
	Profile_CleanUp_Tag()
	
	Profile_CleanUp_Dress()
	
	Profile_CleanUp_Ride()
	
	Profile_CleanUp_Weapon()
	
	Profile_Frame_LikeBtn:Hide()
	
	Profile_Model_Plus:Show()
	Profile_Model_Subtract:Show()

	g_Profile_ViewMode = 0
	
	g_Profile_DressCurSel = 0
	g_Profile_WeaponCurSel = 0
	g_Profile_RideCurSel = 0

end

function Profile_CloseSameGroupWindow()
	if IsWindowShow("Profile_TagChoose") then
		CloseWindow("Profile_TagChoose", true)
	end
	if IsWindowShow("Profile_DressChoose") then
		CloseWindow("Profile_DressChoose", true)
	end
	if IsWindowShow("Profile_RideChoose") then
		CloseWindow("Profile_RideChoose", true)
	end
	if IsWindowShow("Profile_WeaponChoose") then
		CloseWindow("Profile_WeaponChoose", true)
	end
end

--ÉãÏñ»ú
function Profile_UpdateCamera()

	local sex = Player:GetMySex()
	if sex ~= 0 and sex ~= 1 then 
		return
	end
		
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end
	
	if g_Profile_ViewMode == 1 then
		if g_Profile_RideCurSel >= g_Profile_Type_Ride * 10 + 1 and g_Profile_RideCurSel <= g_Profile_Type_Ride * 10 + g_Profile_MaxBtn then
			local CurSel = g_Profile_RideCurSel - g_Profile_Type_Ride * 10
			local nRideId = Exterior:LuaFnExteriorPlayerGetProfileData(CurSel, "RIDE")
			if nRideId ~= nil and nRideId > 0 then		
				local nMountId = Exterior:LuaFnGetExteriorRideInfo(nRideId, "MountId")	
				Exterior:LuaFnUpdateExteriorProfileAvatarMount(nMountId)	
				Profile_FakeObject:SetFakeObject("Exterior_Profile")			
				local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId, 0)	
				FakeObj_SetCamera("Exterior_Profile", g_CameraHeight, fHeight)
				FakeObj_SetCamera("Exterior_Profile", g_CameraDistance, fDistance)	
				return
			end
		end
	end
	
	local fHeight = g_CameraPosition[sex][g_Distance].fHeight
	local fDistance = g_CameraPosition[sex][g_Distance].fDistance
	local fPitch = g_CameraPosition[sex][g_Distance].fPitch

	FakeObj_SetCamera("Exterior_Profile", g_CameraHeight, fHeight)
	FakeObj_SetCamera("Exterior_Profile", g_CameraDistance, fDistance)
	FakeObj_SetCamera("Exterior_Profile", g_CameraPitch, fPitch)

end

--×ó×ª
function Profile_FakeObject_TurnLeft(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Profile_FakeObject:RotateBegin(-0.3)
	else
		Profile_FakeObject:RotateEnd()
	end
	
end

--ÓÒ×ª
function Profile_FakeObject_TurnRight(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Profile_FakeObject:RotateBegin(0.3)
	else
		Profile_FakeObject:RotateEnd()
	end
	
end

--ËõÐ¡
function Profile_ZoomOut()

	if g_Distance == 1 then
		return
	end
	
	g_Distance = g_Distance - 1	

	Profile_UpdateCamera()
	
end

--·Å´ó
function Profile_ZoomIn()

	if g_Distance == g_Distance_Max then
		return
	end
	
	g_Distance = g_Distance + 1	
	
	Profile_UpdateCamera()

end

function Profile_Frame_On_ResetPos()

	Profile_Frame:SetProperty("UnifiedPosition", g_Profile_UnifiedPosition);
	
end

--Ð¡ÎÊºÅ
function Profile_HelpClick()

	Helper:GotoHelper("grym")
	
end

--!!!reloadscript =Profile

function Profile_Page_Peak()
	Variable:SetVariable("SelfUnionPos", Profile_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	this:Hide();
end
