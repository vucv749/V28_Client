
--!!!reloadscript =Profile_WeaponChoose

local g_Profile_WeaponChoose_UnifiedPosition = ""
local g_Profile_Weapon_SetType = 4

local g_Profile_Weapon_InitList = 0

local g_Profile_WeaponChoose_BarNum = 0
local g_Profile_WeaponChoose_BarList = {}
local g_Profile_WeaponChoose_List = {}
local g_Profile_WeaponChoose_CurSelButton = {}
local g_Profile_WeaponChoose_CurSelTime = {}

local g_Profile_WeaponChoose_PlayerSel = 0
local g_Profile_WeaponChoose_MaxSel = 6
local g_Profile_WeaponChoose_CurSel = {-1, -1, -1, -1, -1, -1}
local g_Profile_WeaponChoose_SelImage = {
[1] = "set:CommonFrame37 image:Item_Choices_Checkmark",
[2] = "set:CommonFrame37 image:Item_Choices_Checkmark",
[3] = "set:CommonFrame37 image:Item_Choices_Checkmark",
[4] = "set:CommonFrame37 image:Item_Choices_Checkmark",
[5] = "set:CommonFrame37 image:Item_Choices_Checkmark",
[6] = "set:CommonFrame37 image:Item_Choices_Checkmark",
}

--=========
--PreLoad==
--=========
function Profile_WeaponChoose_PreLoad()

	this:RegisterEvent("OPEN_EXTERIOR_WEAPONCHOOSE")
	this:RegisterEvent("OPEN_EXTERIOR_PROFILE")
		
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("ADD_EXTERIOR_WEAPON", false)
	this:RegisterEvent("UPDATE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("EXTERIOR_OUTTIME_WEAPON", false)
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_CHANGED", false)	
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_LEVEL_CHANGED", false)
	
end

--=========
--OnLoad
--=========
function Profile_WeaponChoose_OnLoad()

	g_Profile_WeaponChoose_UnifiedPosition = Profile_WeaponChoose_Frame:GetProperty("UnifiedPosition")
	
	g_Profile_WeaponChoose_CurSelButton[1] = Profile_WeaponChoose_Item1
	g_Profile_WeaponChoose_CurSelButton[2] = Profile_WeaponChoose_Item2
	g_Profile_WeaponChoose_CurSelButton[3] = Profile_WeaponChoose_Item3
	g_Profile_WeaponChoose_CurSelButton[4] = Profile_WeaponChoose_Item4
	g_Profile_WeaponChoose_CurSelButton[5] = Profile_WeaponChoose_Item5
	g_Profile_WeaponChoose_CurSelButton[6] = Profile_WeaponChoose_Item6
	
	g_Profile_WeaponChoose_CurSelTime[1] = Profile_WeaponChoose_List_Item1_TimeImage
	g_Profile_WeaponChoose_CurSelTime[2] = Profile_WeaponChoose_List_Item2_TimeImage
	g_Profile_WeaponChoose_CurSelTime[3] = Profile_WeaponChoose_List_Item3_TimeImage
	g_Profile_WeaponChoose_CurSelTime[4] = Profile_WeaponChoose_List_Item4_TimeImage
	g_Profile_WeaponChoose_CurSelTime[5] = Profile_WeaponChoose_List_Item5_TimeImage
	g_Profile_WeaponChoose_CurSelTime[6] = Profile_WeaponChoose_List_Item6_TimeImage
	
end

--=========
--OnEvent
--=========
function Profile_WeaponChoose_OnEvent(event)
	
	if event == "OPEN_EXTERIOR_WEAPONCHOOSE" then
		--if this:IsVisible() then	
		--	Profile_WeaponChoose_CloseClick()	
		--	return
		--end
		
		if tonumber(arg0) <= 0 then
			if this:IsVisible() then	
				Profile_WeaponChoose_CloseClick()	
			end
			PushDebugMessage("#{GRYM_221213_156}")
			return
		end
		
		Profile_WeaponChoose_CloseSameGroupWindow()
				
		this:Show()
				
		Profile_WeaponChoose_Show()			
		return
	end
	
	if event == "OPEN_EXTERIOR_PROFILE" then
	
		if IsWindowShow("Profile") then
			if (arg0 == "weapon") then
				--Profile_WeaponChoose_UpdateSelect()
				Profile_WeaponChoose_CloseClick()
			end
		else
			Profile_WeaponChoose_CloseClick()	
			return			
		end
			
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			Profile_WeaponChoose_CloseClick()	
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Profile_WeaponChoose_On_ResetPos()
	end
	
	if event == "ADD_EXTERIOR_WEAPON" 
		or event == "UPDATE_EXTERIOR_WEAPON" 
		or event == "EXTERIOR_OUTTIME_WEAPON"
		or event == "DEF_EXTERIOR_WEAPON_CHANGED"
		or event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		
		if this:IsVisible() then
			Exterior:LuaFnExteriorProfileAskData(2)
		end
		
	end
	
end

function Profile_WeaponChoose_InitInfo()
	
	if g_Profile_Weapon_InitList == 0 then	
		Exterior:LuaFnInitExteriorWeaponList()
	
		g_Profile_WeaponChoose_BarNum = Exterior:LuaFnGetExteriorWeaponMaxCount()
		
		for i = 1, g_Profile_WeaponChoose_BarNum do
			local bar = Profile_WeaponChoose_List:AddChild("Profile_WeaponChoose_List_Item")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_Profile_WeaponChoose_BarList[i] = bar	
			bar:GetSubItem("Profile_WeaponChoose_List_ActionBtn"):SetEvent("MouseLButtonDown", string.format("Profile_WeaponChoose_ItemClicked(%d)", i))
			bar:GetSubItem("Profile_WeaponChoose_List_ActionBtn"):SetProperty("Empty", "False")
			bar:GetSubItem("Profile_WeaponChoose_List_ActionBtn"):SetProperty("UseDefaultTooltip", "True")
		end
		g_Profile_Weapon_InitList = 1
	end
	
end

function Profile_WeaponChoose_Show()
		
	Profile_WeaponChoose_InitInfo()

	Profile_WeaponChoose_CleanUp()
	
	Profile_WeaponChoose_UpdateSelect()
	
	Profile_WeaponChoose_UpdateList()
	
end
	
function Profile_WeaponChoose_UpdateSelect()
				
	--玩家已选择
	g_Profile_WeaponChoose_PlayerSel = 0
	for i in pairs(g_Profile_WeaponChoose_CurSel) do
		local nSelExteriorId = Exterior:LuaFnExteriorPlayerGetProfileData(i, "WEAPON")
		if nSelExteriorId > 0 then 
			if Exterior:LuaFnIsHaveExteriorWeapon(nSelExteriorId) == 1 then
				g_Profile_WeaponChoose_PlayerSel = g_Profile_WeaponChoose_PlayerSel + 1
				g_Profile_WeaponChoose_CurSel[i] = nSelExteriorId
			
				Exterior:LuaFnExteriorProfileSelData(g_Profile_Weapon_SetType, i-1, nSelExteriorId)
			else
				-- 去掉			
				Exterior:LuaFnExteriorProfileSelData(g_Profile_Weapon_SetType, i-1, -1)
			end
		else
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Weapon_SetType, i-1, -1)
		end
	end
	
	local str = ScriptGlobal_Format("#{GRYM_221213_137}", g_Profile_WeaponChoose_PlayerSel)
	Profile_WeaponChoose_Text2:SetText(str)
	
end

-- 方案填充数据
function Profile_WeaponChoose_UpdateList()
	
	Exterior:LuaFnInitExteriorWeaponList()
	local count = Exterior:LuaFnGetExteriorWeaponListCount()
	
	for i = 1, g_Profile_WeaponChoose_BarNum do	
		Profile_WeaponChoose_SetItem(i, count)
	end
	
end

function Profile_WeaponChoose_SetItem(index, max_count)
	
	if g_Profile_WeaponChoose_BarList[index] == nil then
		return
	end
	
	if index > max_count then
		g_Profile_WeaponChoose_BarList[index]:Hide()
		return
	end
	
	local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(index - 1)
	if Exterior:LuaFnIsHaveExteriorWeapon(nExteriorID) ~= 1 then
		g_Profile_WeaponChoose_BarList[index]:Hide()
		return	
	end
	
	local bar = g_Profile_WeaponChoose_BarList[index]
	bar:Show()
	
	local strIcon 	= Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Icon")
	local strImage = GetIconFullName(strIcon)
	
	local ctrlAction = bar:GetSubItem("Profile_WeaponChoose_List_ActionBtn")
	if ctrlAction ~= nil then	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		local strTip = Exterior:LuaFnGetExteriorWeaponToolTip(nExteriorID)
		ctrlAction:SetToolTip(strTip)
		
		ctrlAction:SetPushed(0)
	end
	
	--限时标志
	local nLeftTime = Exterior:LuaFnGetExteriorWeaponLeftTime(nExteriorID)
	if nLeftTime and nLeftTime < 0 then
		bar:GetSubItem("Profile_WeaponChoose_List_TimeImage"):Hide()
	elseif nLeftTime and nLeftTime == 0 then
		bar:GetSubItem("Profile_WeaponChoose_List_TimeImage"):Show()
	elseif nLeftTime and nLeftTime > 0 then
		bar:GetSubItem("Profile_WeaponChoose_List_TimeImage"):Show()
	end
	
	--已选编号
	bar:GetSubItem("Profile_WeaponChoose_List_OrderImage"):Hide()
	for i in pairs(g_Profile_WeaponChoose_CurSel) do
		if g_Profile_WeaponChoose_CurSel[i] == nExteriorID and g_Profile_WeaponChoose_SelImage[i] ~= nil then			
			bar:GetSubItem("Profile_WeaponChoose_List_OrderImage"):Show()
			bar:GetSubItem("Profile_WeaponChoose_List_OrderImage"):SetProperty("Image", g_Profile_WeaponChoose_SelImage[i])

			if ctrlAction ~= nil then
				ctrlAction:SetPushed(1)
			end
					
			if g_Profile_WeaponChoose_CurSelButton[i] ~= nil then
				g_Profile_WeaponChoose_CurSelButton[i]:SetProperty("NormalImage", strImage)
				g_Profile_WeaponChoose_CurSelButton[i]:SetProperty("HoverImage", strImage)
				
				local strTemp = Exterior:LuaFnGetExteriorWeaponToolTip(nExteriorID)
				g_Profile_WeaponChoose_CurSelButton[i]:SetToolTip(strTemp)

				--限时标志
				if nLeftTime and nLeftTime < 0 then
					g_Profile_WeaponChoose_CurSelTime[i]:Hide()
				elseif nLeftTime and nLeftTime == 0 then
					g_Profile_WeaponChoose_CurSelTime[i]:Show()
				elseif nLeftTime and nLeftTime > 0 then
					g_Profile_WeaponChoose_CurSelTime[i]:Show()
				end
			end
		end
	end

end

-- 选择坐骑
function Profile_WeaponChoose_ItemClicked( nIndex )
	
	local OpRet = 0
	local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(nIndex - 1)
	for i in pairs(g_Profile_WeaponChoose_CurSel) do
		if g_Profile_WeaponChoose_CurSel[i] == nExteriorID then
			-- 取消选择
			g_Profile_WeaponChoose_CurSel[i] = -1
			
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Weapon_SetType, i-1, -1)
			
			local bar = g_Profile_WeaponChoose_BarList[nIndex]
			bar:GetSubItem("Profile_WeaponChoose_List_OrderImage"):Hide()

			local ctrlAction = bar:GetSubItem("Profile_WeaponChoose_List_ActionBtn")
			if ctrlAction ~= nil then
				ctrlAction:SetPushed(0)
			end
					
			if g_Profile_WeaponChoose_CurSelButton[i] ~= nil then	
				g_Profile_WeaponChoose_CurSelButton[i]:SetProperty("NormalImage", "")
				g_Profile_WeaponChoose_CurSelButton[i]:SetProperty("HoverImage", "")
				g_Profile_WeaponChoose_CurSelButton[i]:SetToolTip("")
					
				g_Profile_WeaponChoose_CurSelTime[i]:Hide()
			end
			
			g_Profile_WeaponChoose_PlayerSel = g_Profile_WeaponChoose_PlayerSel - 1
			local str = ScriptGlobal_Format("#{GRYM_221213_137}", g_Profile_WeaponChoose_PlayerSel)
			Profile_WeaponChoose_Text2:SetText(str)
			
			OpRet = 1
		end		
	end
	
	local nFirstPos = 0
	if OpRet == 0 then
		if g_Profile_WeaponChoose_PlayerSel >= g_Profile_WeaponChoose_MaxSel then
			PushDebugMessage("#{GRYM_221213_41}")
			return
		end
		
		for i in pairs(g_Profile_WeaponChoose_CurSel) do
			if g_Profile_WeaponChoose_CurSel[i] == -1 then
				nFirstPos = i
				break
			end
		end
		if nFirstPos ~= 0 and g_Profile_WeaponChoose_CurSel[nFirstPos] ~= nil then
			g_Profile_WeaponChoose_CurSel[nFirstPos] = nExteriorID
			
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Weapon_SetType, nFirstPos-1, nExteriorID)
			
			local bar = g_Profile_WeaponChoose_BarList[nIndex]
			bar:GetSubItem("Profile_WeaponChoose_List_OrderImage"):Show()
			bar:GetSubItem("Profile_WeaponChoose_List_OrderImage"):SetProperty("Image", g_Profile_WeaponChoose_SelImage[nFirstPos])

			local ctrlAction = bar:GetSubItem("Profile_WeaponChoose_List_ActionBtn")
			if ctrlAction ~= nil then
				ctrlAction:SetPushed(1)
			end
					
			if g_Profile_WeaponChoose_CurSelButton[nFirstPos] ~= nil then
				local strIcon 	= Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Icon")
				local strImage = GetIconFullName(strIcon)
				
				g_Profile_WeaponChoose_CurSelButton[nFirstPos]:SetProperty("NormalImage", strImage)
				g_Profile_WeaponChoose_CurSelButton[nFirstPos]:SetProperty("HoverImage", strImage)
				
				local strTemp = Exterior:LuaFnGetExteriorWeaponToolTip(nExteriorID)
				g_Profile_WeaponChoose_CurSelButton[nFirstPos]:SetToolTip(strTemp)
				
				--限时标志
				local nLeftTime = Exterior:LuaFnGetExteriorWeaponLeftTime(nExteriorID)
				if nLeftTime and nLeftTime < 0 then
					g_Profile_WeaponChoose_CurSelTime[nFirstPos]:Hide()
				elseif nLeftTime and nLeftTime == 0 then
					g_Profile_WeaponChoose_CurSelTime[nFirstPos]:Show()
				elseif nLeftTime and nLeftTime > 0 then
					g_Profile_WeaponChoose_CurSelTime[nFirstPos]:Show()
				end
			end
			
			g_Profile_WeaponChoose_PlayerSel = g_Profile_WeaponChoose_PlayerSel + 1
			local str = ScriptGlobal_Format("#{GRYM_221213_137}", g_Profile_WeaponChoose_PlayerSel)
			Profile_WeaponChoose_Text2:SetText(str)
		end
	end
	
end

-- 右键取下
function Profile_WeaponChoose_ItemRClick( nIndex )

	if g_Profile_WeaponChoose_CurSel[nIndex] == nil then
		return
	end

	for i in pairs(g_Profile_WeaponChoose_BarList) do
		local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(i - 1)
		if g_Profile_WeaponChoose_CurSel[nIndex] == nExteriorID then
			-- 取消选择
			g_Profile_WeaponChoose_CurSel[nIndex] = -1
			
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Weapon_SetType, nIndex-1, -1)
			
			local bar = g_Profile_WeaponChoose_BarList[i]
			bar:GetSubItem("Profile_WeaponChoose_List_OrderImage"):Hide()

			local ctrlAction = bar:GetSubItem("Profile_WeaponChoose_List_ActionBtn")
			if ctrlAction ~= nil then
				ctrlAction:SetPushed(0)
			end
					
			if g_Profile_WeaponChoose_CurSelButton[nIndex] ~= nil then	
				g_Profile_WeaponChoose_CurSelButton[nIndex]:SetProperty("NormalImage", "")
				g_Profile_WeaponChoose_CurSelButton[nIndex]:SetProperty("HoverImage", "")
				g_Profile_WeaponChoose_CurSelButton[nIndex]:SetToolTip("")
				
				g_Profile_WeaponChoose_CurSelTime[nIndex]:Hide()
			end
			
			g_Profile_WeaponChoose_PlayerSel = g_Profile_WeaponChoose_PlayerSel - 1
			local str = ScriptGlobal_Format("#{GRYM_221213_134}", g_Profile_WeaponChoose_PlayerSel)
			Profile_WeaponChoose_Text2:SetText(str)
			
			return
		end		
	end
end

-- 保存修改
function Profile_WeaponChoose_ConfirmClicked()

	Exterior:LuaFnExteriorProfileSaveData(10)

end

--小问号
function Profile_WeaponChoose_HelpClick()

	Helper:GotoHelper("grym")
	
end

--关睜按钮
function Profile_WeaponChoose_CloseClick()	

	Profile_WeaponChoose_CleanUp()
	this:Hide()
	
end

function Profile_WeaponChoose_OnHiden()
	
	Profile_WeaponChoose_CleanUp()
	
end

function Profile_WeaponChoose_CleanUp()

	for i = 1, g_Profile_WeaponChoose_BarNum do
		if g_Profile_WeaponChoose_BarList[i] then
			local ctrlAction = g_Profile_WeaponChoose_BarList[i]:GetSubItem("Profile_WeaponChoose_List_ActionBtn")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
		end
	end
	
	for i in pairs(g_Profile_WeaponChoose_CurSel) do
		-- 取消选择
		g_Profile_WeaponChoose_CurSel[i] = -1
			
		Exterior:LuaFnExteriorProfileSelData(g_Profile_Weapon_SetType, i-1, -1)
	end
		
	for i in pairs(g_Profile_WeaponChoose_CurSelButton) do		
		g_Profile_WeaponChoose_CurSelButton[i]:SetProperty("NormalImage", "")
		g_Profile_WeaponChoose_CurSelButton[i]:SetProperty("HoverImage", "")
		g_Profile_WeaponChoose_CurSelButton[i]:SetToolTip("")
		
		g_Profile_WeaponChoose_CurSelTime[i]:Hide()
	end
	
	g_Profile_WeaponChoose_PlayerSel = 0
	
end

function Profile_WeaponChoose_On_ResetPos()

	Profile_WeaponChoose_Frame:SetProperty("UnifiedPosition", g_Profile_WeaponChoose_UnifiedPosition);
	
end

function Profile_WeaponChoose_CloseSameGroupWindow()
	if IsWindowShow("Profile_TagChoose") then
		CloseWindow("Profile_TagChoose", true)
	end
	if IsWindowShow("Profile_DressChoose") then
		CloseWindow("Profile_DressChoose", true)
	end
	if IsWindowShow("Profile_RideChoose") then
		CloseWindow("Profile_RideChoose", true)
	end
	--if IsWindowShow("Profile_WeaponChoose") then
	--	CloseWindow("Profile_WeaponChoose", true)
	--end
end

--!!!reloadscript =Profile_WeaponChoose
