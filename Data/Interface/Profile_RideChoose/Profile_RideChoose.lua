
--!!!reloadscript =Profile_RideChoose

local g_Profile_RideChoose_UnifiedPosition = ""
local g_Profile_Ride_SetType = 3

local g_Profile_Ride_InitList = 0
local g_Profile_ExteriorType = 3

local g_Profile_RideChoose_BarNum = 0
local g_Profile_RideChoose_BarList = {}
local g_Profile_RideChoose_List = {}
local g_Profile_RideChoose_CurSelButton = {}
local g_Profile_RideChoose_CurSelTime = {}
local g_Profile_RideChoose_CurSelLuxury = {}

local g_Profile_RideChoose_PlayerSel = 0
local g_Profile_RideChoose_MaxSel = 6
local g_Profile_RideChoose_CurSel = {-1, -1, -1, -1, -1, -1}
local g_Profile_RideChoose_SelImage = {
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
function Profile_RideChoose_PreLoad()

	this:RegisterEvent("OPEN_EXTERIOR_RIDECHOOSE")
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
	
end

--=========
--OnLoad
--=========
function Profile_RideChoose_OnLoad()

	g_Profile_RideChoose_UnifiedPosition = Profile_RideChoose_Frame:GetProperty("UnifiedPosition")
	
	g_Profile_RideChoose_CurSelButton[1] = Profile_RideChoose_Item1
	g_Profile_RideChoose_CurSelButton[2] = Profile_RideChoose_Item2
	g_Profile_RideChoose_CurSelButton[3] = Profile_RideChoose_Item3
	g_Profile_RideChoose_CurSelButton[4] = Profile_RideChoose_Item4
	g_Profile_RideChoose_CurSelButton[5] = Profile_RideChoose_Item5
	g_Profile_RideChoose_CurSelButton[6] = Profile_RideChoose_Item6
	
	g_Profile_RideChoose_CurSelTime[1] = Profile_RideChoose_List_Item1_TimeImage
	g_Profile_RideChoose_CurSelTime[2] = Profile_RideChoose_List_Item2_TimeImage
	g_Profile_RideChoose_CurSelTime[3] = Profile_RideChoose_List_Item3_TimeImage
	g_Profile_RideChoose_CurSelTime[4] = Profile_RideChoose_List_Item4_TimeImage
	g_Profile_RideChoose_CurSelTime[5] = Profile_RideChoose_List_Item5_TimeImage
	g_Profile_RideChoose_CurSelTime[6] = Profile_RideChoose_List_Item6_TimeImage
	
	g_Profile_RideChoose_CurSelLuxury[1] = Profile_RideChoose_List_Item1_LuxuryImage
	g_Profile_RideChoose_CurSelLuxury[2] = Profile_RideChoose_List_Item2_LuxuryImage
	g_Profile_RideChoose_CurSelLuxury[3] = Profile_RideChoose_List_Item3_LuxuryImage
	g_Profile_RideChoose_CurSelLuxury[4] = Profile_RideChoose_List_Item4_LuxuryImage
	g_Profile_RideChoose_CurSelLuxury[5] = Profile_RideChoose_List_Item5_LuxuryImage
	g_Profile_RideChoose_CurSelLuxury[6] = Profile_RideChoose_List_Item6_LuxuryImage
	
end

--=========
--OnEvent
--=========
function Profile_RideChoose_OnEvent(event)
	
	if event == "OPEN_EXTERIOR_RIDECHOOSE" then
		--if this:IsVisible() then	
		--	Profile_RideChoose_CloseClick()	
		--	return
		--end
		
		if tonumber(arg0) <= 0 then
			if this:IsVisible() then	
				Profile_RideChoose_CloseClick()	
			end
			PushDebugMessage("#{GRYM_221213_154}")
			return
		end
		
		Profile_RideChoose_CloseSameGroupWindow()
		
		this:Show()
				
		Profile_RideChoose_Show()			
		return
	end
	
	if event == "OPEN_EXTERIOR_PROFILE" then
	
		if IsWindowShow("Profile") then
			if (arg0 == "ride") then
				--Profile_RideChoose_UpdateSelect()
				Profile_RideChoose_CloseClick()	
			end
		else
			Profile_RideChoose_CloseClick()	
			return			
		end
			
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			Profile_RideChoose_CloseClick()	
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Profile_RideChoose_On_ResetPos()
	end
	
	if event == "ADD_EXTERIOR" 
		or event == "UPDATE_EXTERIOR" 
		or event == "EXTERIOR_OUTTIME" 
		or event == "EXTERIOR_ID_CHANGED" then
		
		if this:IsVisible() then
			Exterior:LuaFnExteriorProfileAskData(1)
		end
		
	end
	
end

-- 
function Profile_RideChoose_InitInfo()
	
	if g_Profile_Ride_InitList == 0 then	
		Exterior:LuaFnInitExteriorList(g_Profile_ExteriorType)	
		
		g_Profile_RideChoose_BarNum = Exterior:LuaFnGetExteriorMaxCount(g_Profile_ExteriorType)
		
		for i = 1, g_Profile_RideChoose_BarNum do
			local bar = Profile_RideChoose_List:AddChild("Profile_RideChoose_List_Item")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_Profile_RideChoose_BarList[i] = bar	
			bar:GetSubItem("Profile_RideChoose_List_ActionBtn"):SetEvent("MouseLButtonDown", string.format("Profile_RideChoose_ItemClicked(%d)", i))
			bar:GetSubItem("Profile_RideChoose_List_ActionBtn"):SetProperty("Empty", "False")
			bar:GetSubItem("Profile_RideChoose_List_ActionBtn"):SetProperty("UseDefaultTooltip", "True")
		end
		g_Profile_Ride_InitList = 1
	end
	
end

function Profile_RideChoose_Show()

	Profile_RideChoose_InitInfo()

	Profile_RideChoose_CleanUp()
	
	Profile_RideChoose_UpdateSelect()
	
	Profile_RideChoose_UpdateList()
	
end
	
function Profile_RideChoose_UpdateSelect()
				
	--玩家已选择
	g_Profile_RideChoose_PlayerSel = 0
	for i in pairs(g_Profile_RideChoose_CurSel) do
		local nSelExteriorId = Exterior:LuaFnExteriorPlayerGetProfileData(i, "RIDE")
		if nSelExteriorId > 0 then 
			if Exterior:LuaFnIsHaveExterior(g_Profile_ExteriorType, nSelExteriorId) == 1 then
				g_Profile_RideChoose_PlayerSel = g_Profile_RideChoose_PlayerSel + 1
				g_Profile_RideChoose_CurSel[i] = nSelExteriorId
				
				Exterior:LuaFnExteriorProfileSelData(g_Profile_Ride_SetType, i-1, nSelExteriorId)
			else
				-- 去掉
				Exterior:LuaFnExteriorProfileSelData(g_Profile_Ride_SetType, i-1, -1)
			end
		else
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Ride_SetType, i-1, -1)
		end
	end
	
	local str = ScriptGlobal_Format("#{GRYM_221213_134}", g_Profile_RideChoose_PlayerSel)
	Profile_RideChoose_Text2:SetText(str)
	
end

-- 方案填充数据
function Profile_RideChoose_UpdateList()
	
	Exterior:LuaFnInitExteriorList(g_Profile_ExteriorType)
	local count = Exterior:LuaFnGetExteriorListCount(g_Profile_ExteriorType, 0)
	
	for i = 1, g_Profile_RideChoose_BarNum do	
		Profile_RideChoose_SetItem(i, count)
	end
	
	Profile_RideChoose_List:RefreshLayout()
	
end

function Profile_RideChoose_SetItem(index, max_count)
	
	if g_Profile_RideChoose_BarList[index] == nil then
		return
	end
	
	if index > max_count then
		g_Profile_RideChoose_BarList[index]:Hide()
		return
	end
	
	local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_Profile_ExteriorType, index - 1)	
	if Exterior:LuaFnIsHaveExterior(g_Profile_ExteriorType, nExteriorID) ~= 1 then
		g_Profile_RideChoose_BarList[index]:Hide()
		return	
	end
	
	--非本门派蒙红 
	local nMyMenpai = Player:GetData("MEMPAI")
	local nMenpai 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Menpai")
	if nMyMenpai ~= nMenpai and nMenpai ~= -1 then
		g_Profile_RideChoose_BarList[index]:Hide()
		return	
	end
	
	local bar = g_Profile_RideChoose_BarList[index]
	bar:Show()
	
	local strIcon 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Icon")
	local strImage  = GetIconFullName(strIcon)
	local nLuxury 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Luxury")
	
	local ctrlAction = bar:GetSubItem("Profile_RideChoose_List_ActionBtn")
	if ctrlAction ~= nil then	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		local strTemp = Exterior:LuaFnGetRideToolTip(nExteriorID)
		ctrlAction:SetToolTip(strTemp)
		
		ctrlAction:SetPushed(0)
	end

	--限时标志
	local nLeftTime = Exterior:LuaFnGetExteriorLeftTime(g_Profile_ExteriorType, nExteriorID)
	if nLeftTime and nLeftTime < 0 then
		bar:GetSubItem("Profile_RideChoose_List_TimeImage"):Hide()
	elseif nLeftTime and nLeftTime == 0 then
		bar:GetSubItem("Profile_RideChoose_List_TimeImage"):Show()
	elseif nLeftTime and nLeftTime > 0 then
		bar:GetSubItem("Profile_RideChoose_List_TimeImage"):Show()
	end
	
	--奢侈品
	if nLuxury == 1 or nLuxury == 2 then
		bar:GetSubItem("Profile_RideChoose_List_LuxuryImage"):Show()
	else
		bar:GetSubItem("Profile_RideChoose_List_LuxuryImage"):Hide()
	end
	
	--已选编号
	bar:GetSubItem("Profile_RideChoose_List_OrderImage"):Hide()
	for i in pairs(g_Profile_RideChoose_CurSel) do
		if g_Profile_RideChoose_CurSel[i] == nExteriorID and g_Profile_RideChoose_SelImage[i] ~= nil then			
			bar:GetSubItem("Profile_RideChoose_List_OrderImage"):Show()
			bar:GetSubItem("Profile_RideChoose_List_OrderImage"):SetProperty("Image", g_Profile_RideChoose_SelImage[i])

			if ctrlAction ~= nil then
				ctrlAction:SetPushed(1)
			end
					
			if g_Profile_RideChoose_CurSelButton[i] ~= nil then
				g_Profile_RideChoose_CurSelButton[i]:SetProperty("NormalImage", strImage)
				g_Profile_RideChoose_CurSelButton[i]:SetProperty("HoverImage", strImage)
				
				local strTemp = Exterior:LuaFnGetRideToolTip(nExteriorID)
				g_Profile_RideChoose_CurSelButton[i]:SetToolTip(strTemp)

				--限时标志
				if nLeftTime and nLeftTime < 0 then
					g_Profile_RideChoose_CurSelTime[i]:Hide()
				elseif nLeftTime and nLeftTime == 0 then
					g_Profile_RideChoose_CurSelTime[i]:Show()
				elseif nLeftTime and nLeftTime > 0 then
					g_Profile_RideChoose_CurSelTime[i]:Show()
				end
				
				--奢侈品
				if nLuxury == 1 or nLuxury == 2 then
					g_Profile_RideChoose_CurSelLuxury[i]:Show()
				else
					g_Profile_RideChoose_CurSelLuxury[i]:Hide()
				end
			end
		end
	end

end

-- 选择坐骑
function Profile_RideChoose_ItemClicked( nIndex )
	
	local OpRet = 0
	local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_Profile_ExteriorType, nIndex - 1)	
	for i in pairs(g_Profile_RideChoose_CurSel) do
		if g_Profile_RideChoose_CurSel[i] == nExteriorID then
			-- 取消选择
			g_Profile_RideChoose_CurSel[i] = -1
			
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Ride_SetType, i-1, -1)
			
			local bar = g_Profile_RideChoose_BarList[nIndex]
			bar:GetSubItem("Profile_RideChoose_List_OrderImage"):Hide()

			local ctrlAction = bar:GetSubItem("Profile_RideChoose_List_ActionBtn")
			if ctrlAction ~= nil then
				ctrlAction:SetPushed(0)
			end
					
			if g_Profile_RideChoose_CurSelButton[i] ~= nil then	
				g_Profile_RideChoose_CurSelButton[i]:SetProperty("NormalImage", "")
				g_Profile_RideChoose_CurSelButton[i]:SetProperty("HoverImage", "")
				g_Profile_RideChoose_CurSelButton[i]:SetToolTip("")
				
				g_Profile_RideChoose_CurSelTime[i]:Hide()
				g_Profile_RideChoose_CurSelLuxury[i]:Hide()
			end
			
			g_Profile_RideChoose_PlayerSel = g_Profile_RideChoose_PlayerSel - 1
			local str = ScriptGlobal_Format("#{GRYM_221213_134}", g_Profile_RideChoose_PlayerSel)
			Profile_RideChoose_Text2:SetText(str)
			
			OpRet = 1
		end		
	end
	
	local nFirstPos = 0
	if OpRet == 0 then
		if g_Profile_RideChoose_PlayerSel >= g_Profile_RideChoose_MaxSel then
			PushDebugMessage("#{GRYM_221213_39}")
			return
		end
		
		for i in pairs(g_Profile_RideChoose_CurSel) do
			if g_Profile_RideChoose_CurSel[i] == -1 then
				nFirstPos = i
				break
			end
		end
		if nFirstPos ~= 0 and g_Profile_RideChoose_CurSel[nFirstPos] ~= nil then
			g_Profile_RideChoose_CurSel[nFirstPos] = nExteriorID
			
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Ride_SetType, nFirstPos-1, nExteriorID)
			
			local bar = g_Profile_RideChoose_BarList[nIndex]
			bar:GetSubItem("Profile_RideChoose_List_OrderImage"):Show()
			bar:GetSubItem("Profile_RideChoose_List_OrderImage"):SetProperty("Image", g_Profile_RideChoose_SelImage[nFirstPos])

			local ctrlAction = bar:GetSubItem("Profile_RideChoose_List_ActionBtn")
			if ctrlAction ~= nil then
				ctrlAction:SetPushed(1)
			end
					
			if g_Profile_RideChoose_CurSelButton[nFirstPos] ~= nil then
				local strIcon 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID,"Icon")
				local strImage  = GetIconFullName(strIcon)
				
				g_Profile_RideChoose_CurSelButton[nFirstPos]:SetProperty("NormalImage", strImage)
				g_Profile_RideChoose_CurSelButton[nFirstPos]:SetProperty("HoverImage", strImage)
				
				local strTemp = Exterior:LuaFnGetRideToolTip(nExteriorID)
				g_Profile_RideChoose_CurSelButton[nFirstPos]:SetToolTip(strTemp)
				
				--限时标志
				local nLeftTime = Exterior:LuaFnGetExteriorLeftTime(g_Profile_ExteriorType, nExteriorID)
				if nLeftTime and nLeftTime < 0 then
					g_Profile_RideChoose_CurSelTime[nFirstPos]:Hide()
				elseif nLeftTime and nLeftTime == 0 then
					g_Profile_RideChoose_CurSelTime[nFirstPos]:Show()
				elseif nLeftTime and nLeftTime > 0 then
					g_Profile_RideChoose_CurSelTime[nFirstPos]:Show()
				end
				
				--奢侈品
				local nLuxury 	= Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Luxury")
				if nLuxury == 1 or nLuxury == 2 then
					g_Profile_RideChoose_CurSelLuxury[nFirstPos]:Show()
				else
					g_Profile_RideChoose_CurSelLuxury[nFirstPos]:Hide()
				end
			end
			
			g_Profile_RideChoose_PlayerSel = g_Profile_RideChoose_PlayerSel + 1
			local str = ScriptGlobal_Format("#{GRYM_221213_134}", g_Profile_RideChoose_PlayerSel)
			Profile_RideChoose_Text2:SetText(str)
		end
	end
	
end

-- 右键取下
function Profile_RideChoose_ItemRClick( nIndex )

	if g_Profile_RideChoose_CurSel[nIndex] == nil then
		return
	end

	for i in pairs(g_Profile_RideChoose_BarList) do
		local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_Profile_ExteriorType, i - 1)	
		if g_Profile_RideChoose_CurSel[nIndex] == nExteriorID then
			-- 取消选择
			g_Profile_RideChoose_CurSel[nIndex] = -1
			
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Ride_SetType, nIndex-1, -1)
			
			local bar = g_Profile_RideChoose_BarList[i]
			bar:GetSubItem("Profile_RideChoose_List_OrderImage"):Hide()

			local ctrlAction = bar:GetSubItem("Profile_RideChoose_List_ActionBtn")
			if ctrlAction ~= nil then
				ctrlAction:SetPushed(0)
			end
					
			if g_Profile_RideChoose_CurSelButton[nIndex] ~= nil then	
				g_Profile_RideChoose_CurSelButton[nIndex]:SetProperty("NormalImage", "")
				g_Profile_RideChoose_CurSelButton[nIndex]:SetProperty("HoverImage", "")
				g_Profile_RideChoose_CurSelButton[nIndex]:SetToolTip("")
				
				g_Profile_RideChoose_CurSelTime[nIndex]:Hide()
				g_Profile_RideChoose_CurSelLuxury[nIndex]:Hide()
			end
			
			g_Profile_RideChoose_PlayerSel = g_Profile_RideChoose_PlayerSel - 1
			local str = ScriptGlobal_Format("#{GRYM_221213_134}", g_Profile_RideChoose_PlayerSel)
			Profile_RideChoose_Text2:SetText(str)
			
			return
		end		
	end
end

-- 保存修改
function Profile_RideChoose_ConfirmClicked()

	Exterior:LuaFnExteriorProfileSaveData(9)

end

--小问号
function Profile_RideChoose_HelpClick()

	Helper:GotoHelper("grym")
	
end

--关闭按钮
function Profile_RideChoose_CloseClick()	

	Profile_RideChoose_CleanUp()
	this:Hide()
	
end

function Profile_RideChoose_OnHiden()
	
	Profile_RideChoose_CleanUp()
	
end

function Profile_RideChoose_CleanUp()

	for i = 1, g_Profile_RideChoose_BarNum do
		if g_Profile_RideChoose_BarList[i] then
			local ctrlAction = g_Profile_RideChoose_BarList[i]:GetSubItem("Profile_RideChoose_List_ActionBtn")			
			if ctrlAction then
				ctrlAction:SetProperty("NormalImage", "")
				ctrlAction:SetProperty("HoverImage", "")
				ctrlAction:SetToolTip("")
			end
		end
	end
	
	for i in pairs(g_Profile_RideChoose_CurSel) do
		-- 取消选择
		g_Profile_RideChoose_CurSel[i] = -1
			
		Exterior:LuaFnExteriorProfileSelData(g_Profile_Ride_SetType, i-1, -1)
	end
		
	for i in pairs(g_Profile_RideChoose_CurSelButton) do		
		g_Profile_RideChoose_CurSelButton[i]:SetProperty("NormalImage", "")
		g_Profile_RideChoose_CurSelButton[i]:SetProperty("HoverImage", "")
		g_Profile_RideChoose_CurSelButton[i]:SetToolTip("")
		
		g_Profile_RideChoose_CurSelTime[i]:Hide()
		g_Profile_RideChoose_CurSelLuxury[i]:Hide()
	end
	
	g_Profile_RideChoose_PlayerSel = 0
	
end

function Profile_RideChoose_On_ResetPos()

	Profile_RideChoose_Frame:SetProperty("UnifiedPosition", g_Profile_RideChoose_UnifiedPosition);
	
end

function Profile_RideChoose_CloseSameGroupWindow()
	if IsWindowShow("Profile_TagChoose") then
		CloseWindow("Profile_TagChoose", true)
	end
	if IsWindowShow("Profile_DressChoose") then
		CloseWindow("Profile_DressChoose", true)
	end
	--if IsWindowShow("Profile_RideChoose") then
		--CloseWindow("Profile_RideChoose", true)
	--end
	if IsWindowShow("Profile_WeaponChoose") then
		CloseWindow("Profile_WeaponChoose", true)
	end
end

--!!!reloadscript =Profile_RideChoose
