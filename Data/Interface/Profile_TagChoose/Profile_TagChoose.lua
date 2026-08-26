
--!!!reloadscript =Profile_TagChoose

local g_Profile_TagChoose_UnifiedPosition = ""
local g_Profile_Tag_SetType = 1

local g_Profile_TagChoose_TypeCount = 3

local g_Profile_TagChoose_CurTypePage = 1
local g_Profile_TagChoose_CurSelect = -1

local g_Profile_TagChoose_Text = {}
local g_Profile_TagChoose_Button = {}

local g_Profile_TagChoose_BarNum = 0
local g_Profile_TagChoose_BarList = {}
local g_Profile_TagChoose_List = {}
local g_Profile_TagChoose_Sel = {}

local g_Profile_TagChoose_CurSelCount = 0
local g_Profile_TagChoose_MaxSel = 6

--=========
--PreLoad==
--=========
function Profile_TagChoose_PreLoad()

	this:RegisterEvent("OPEN_EXTERIOR_TAGCHOOSE")
	this:RegisterEvent("OPEN_EXTERIOR_PROFILE")
		
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
end

--=========
--OnLoad
--=========
function Profile_TagChoose_OnLoad()

	g_Profile_TagChoose_UnifiedPosition = Profile_TagChoose_Frame:GetProperty("UnifiedPosition")
	
	g_Profile_TagChoose_Button[1] = Profile_TagChoose_Tab1
	g_Profile_TagChoose_Button[2] = Profile_TagChoose_Tab2
	g_Profile_TagChoose_Button[3] = Profile_TagChoose_Tab3	
	
	g_Profile_TagChoose_Text[1] = Profile_TagChoose_List_TagText1
	g_Profile_TagChoose_Text[2] = Profile_TagChoose_List_TagText2
	g_Profile_TagChoose_Text[3] = Profile_TagChoose_List_TagText3
	g_Profile_TagChoose_Text[4] = Profile_TagChoose_List_TagText4
	g_Profile_TagChoose_Text[5] = Profile_TagChoose_List_TagText5
	g_Profile_TagChoose_Text[6] = Profile_TagChoose_List_TagText6
	
end

--=========
--OnEvent
--=========
function Profile_TagChoose_OnEvent(event)
	
	if event == "OPEN_EXTERIOR_TAGCHOOSE" then
		if this:IsVisible() then	
			Profile_TagChoose_CloseClick()	
			return
		end
		
		Profile_TagChoose_CloseSameGroupWindow()
				
		this:Show()
	
		g_Profile_TagChoose_CurTypePage = 1
		
		Profile_TagChoose_InitInfo()
				
		Profile_TagChoose_Show()
			
		return
	end
	
	if event == "OPEN_EXTERIOR_PROFILE" then
	
		if IsWindowShow("Profile") then
			if (arg0 == "tag") then
				Profile_TagChoose_CloseClick()				
			end
		else
			Profile_TagChoose_CloseClick()	
			return			
		end
			
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			Profile_TagChoose_CloseClick()	
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Profile_TagChoose_On_ResetPos()
	end
	
end

-- 
function Profile_TagChoose_InitInfo()
	
	g_Profile_TagChoose_CurSelCount = 0
		
	for i in pairs(g_Profile_TagChoose_Text) do
		g_Profile_TagChoose_Text[i]:SetText("")
	end	
	
	for i in pairs(g_Profile_TagChoose_Button) do
		if g_Profile_TagChoose_CurTypePage == i then
			g_Profile_TagChoose_Button[i]:SetCheck(1)
		else
			g_Profile_TagChoose_Button[i]:SetCheck(0)
		end
	end
		
	Exterior:LuaFnExteriorPlayerClearTagSel()
	
	local nIndex = 1
	for i = 1, g_Profile_TagChoose_MaxSel do
		local nSelId = Exterior:LuaFnExteriorPlayerGetTagChoose(i-1)
		if nSelId > 0 then
			g_Profile_TagChoose_CurSelCount = g_Profile_TagChoose_CurSelCount + 1
			
			local nId, nType, nStr, nValid = Exterior:LuaFnExteriorPlayerGetTagChooseInfo( nSelId )
			if nId > 0 and nValid == 1 then
				Exterior:LuaFnExteriorProfileSelData(g_Profile_Tag_SetType, nIndex-1, nId)
				
				g_Profile_TagChoose_Text[nIndex]:SetText("#{"..nStr.."}")
				nIndex = nIndex + 1
			end
		end
	end
	
	local str = ScriptGlobal_Format("#{GRYM_221213_130}", g_Profile_TagChoose_CurSelCount)
	Profile_TagChoose_Text2:SetText(str)
	
end

function Profile_TagChoose_Show()

	Profile_TagChoose_CleanUp()
	
	Profile_TagChoose_InitAction()
	
end

-- 方案填充数据
function Profile_TagChoose_InitAction()

	g_Profile_TagChoose_BarNum = Exterior:LuaFnExteriorPlayerGetTagChooseCount()
	
	local TagIndex = 1
	for i = 1, g_Profile_TagChoose_BarNum do
		local nId, nType, nStr, nValid = Exterior:LuaFnExteriorPlayerGetTagChooseInfo(i)
		if nType == g_Profile_TagChoose_CurTypePage and nValid == 1 then
			local bar = Profile_TagChoose_TagList:AddChild("Profile_TagChoose_TagList_Item")
			bar:Show()
			
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			bar:GetSubItem("Profile_TagChoose_TagList_ChecBtn"):SetEvent("MouseButtonUp", string.format("Profile_TagChoose_TagList_CheckClicked(%d)", TagIndex))	
					
			bar:GetSubItem("Profile_TagChoose_TagList_TagName"):SetProperty("AlwaysOnTop", "True")
			bar:GetSubItem("Profile_TagChoose_TagList_TagName"):SetText("#{"..nStr.."}")
			
			table.insert(g_Profile_TagChoose_BarList, bar)
			table.insert(g_Profile_TagChoose_List, {})
			
			g_Profile_TagChoose_List[TagIndex].LableId = nId
			g_Profile_TagChoose_List[TagIndex].LableType = nType
			g_Profile_TagChoose_List[TagIndex].LableImage = nImage
			g_Profile_TagChoose_List[TagIndex].LableStr = nStr
						
			g_Profile_TagChoose_Sel[TagIndex] = 0
			for i = 1, g_Profile_TagChoose_MaxSel do
				if nId == Exterior:LuaFnExteriorProfileGetTagSel(i-1) then
					g_Profile_TagChoose_Sel[TagIndex] = 1
					bar:GetSubItem("Profile_TagChoose_TagList_ChecBtn"):SetCheck(1)
				end
			end
						
			TagIndex = TagIndex + 1
		end
	end
	
end

-- 选择页签
function Profile_TagChoose_SelectTab( nIdx )
	
	if nIdx >= 1 and nIdx <= g_Profile_TagChoose_TypeCount then
	
		if nIdx == g_Profile_TagChoose_CurTypePage then
			return
		end
		
		g_Profile_TagChoose_CurTypePage = nIdx
		
		Profile_TagChoose_Show()
	end
		
end

-- 选择标签
function Profile_TagChoose_TagList_CheckClicked( nIdx )

	if g_Profile_TagChoose_List[nIdx] == nil or g_Profile_TagChoose_BarList[nIdx] == nil then
		return
	end
	
	if g_Profile_TagChoose_Sel[nIdx] == nil then
		return
	end
	
	if g_Profile_TagChoose_Sel[nIdx] == 1 then
		g_Profile_TagChoose_Sel[nIdx] = 0
		g_Profile_TagChoose_CurSelCount = g_Profile_TagChoose_CurSelCount - 1
		
		for i = 1, g_Profile_TagChoose_MaxSel do
			if Exterior:LuaFnExteriorProfileGetTagSel(i-1) == g_Profile_TagChoose_List[nIdx].LableId then		
				Exterior:LuaFnExteriorProfileSelData(g_Profile_Tag_SetType, i-1, -1)
				
				g_Profile_TagChoose_Text[i]:SetText("")
			end
		end
			
		g_Profile_TagChoose_BarList[nIdx]:GetSubItem("Profile_TagChoose_TagList_ChecBtn"):SetCheck(0)
	else
		if g_Profile_TagChoose_CurSelCount >= g_Profile_TagChoose_MaxSel then	
			g_Profile_TagChoose_BarList[nIdx]:GetSubItem("Profile_TagChoose_TagList_ChecBtn"):SetCheck(0)
			PushDebugMessage("#{GRYM_221213_33}")
			return
		end
		g_Profile_TagChoose_Sel[nIdx] = 1
		g_Profile_TagChoose_CurSelCount = g_Profile_TagChoose_CurSelCount + 1
		
		local nFirstPos = 0
		for i = 1, g_Profile_TagChoose_MaxSel do
			if Exterior:LuaFnExteriorProfileGetTagSel(i-1) <= 0 then
				nFirstPos = i
				break
			end
		end
		
		if nFirstPos > 0 then		
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Tag_SetType, nFirstPos-1, g_Profile_TagChoose_List[nIdx].LableId)
			local nId, nType, nStr, nValid = Exterior:LuaFnExteriorPlayerGetTagChooseInfo( g_Profile_TagChoose_List[nIdx].LableId )
			if nId > 0 and nValid == 1 then				
				g_Profile_TagChoose_Text[nFirstPos]:SetText("#{"..nStr.."}")
			end
		end
			
		g_Profile_TagChoose_BarList[nIdx]:GetSubItem("Profile_TagChoose_TagList_ChecBtn"):SetCheck(1)
	end
	
	local str = ScriptGlobal_Format("#{GRYM_221213_130}", g_Profile_TagChoose_CurSelCount)
	Profile_TagChoose_Text2:SetText(str)
	
end

-- 保存修改
function Profile_TagChoose_ConfirmClicked()
	
	Exterior:LuaFnExteriorProfileSaveData(7)
	
end

--小问号
function Profile_TagChoose_HelpClick()

	Helper:GotoHelper("grym")
	
end

--关睜按钮
function Profile_TagChoose_CloseClick()	

	this:Hide()
	
end

function Profile_TagChoose_OnHiden()
	
	Profile_TagChoose_CleanUp()
	
end

function Profile_TagChoose_CleanUp()

	g_Profile_TagChoose_BarList = {}
	g_Profile_TagChoose_List = {}

	for i = 1, g_Profile_TagChoose_BarNum do
		if g_Profile_TagChoose_BarList[i] then
			g_Profile_TagChoose_BarList[i]:GetSubItem("Profile_TagChoose_TagList_ChecBtn"):SetCheck(0)
		end
	end
	
	Profile_TagChoose_TagList:Clear()
	
end

function Profile_TagChoose_On_ResetPos()

	Profile_TagChoose_Frame:SetProperty("UnifiedPosition", g_Profile_TagChoose_UnifiedPosition);
	
end

function Profile_TagChoose_CloseSameGroupWindow()
	--if IsWindowShow("Profile_TagChoose") then
	--	CloseWindow("Profile_TagChoose", true)
	--end
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

--!!!reloadscript =Profile_TagChoose
