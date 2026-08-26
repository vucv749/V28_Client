
--!!!reloadscript =Profile_DressChoose

local g_Profile_DressChoose_UnifiedPosition = ""
local g_Profile_Dress_SetType = 2

local g_Profile_Dress_InitList = 0
local m_PlayerfashionDepotType = 1 	--???? 1 ?????? 2 ??????

local g_Profile_DressChoose_BarNum = 100
local g_Profile_DressChoose_BarList = {}
local g_Profile_DressChoose_List = {}
local g_Profile_DressChoose_CurSelButton = {}
local g_Profile_DressChoose_CurSelLuxury = {}

local g_Profile_DressChoose_PlayerSel = 0
local g_Profile_DressChoose_MaxSel = 6
local g_Profile_DressChoose_CurSelIdx = {-1, -1, -1, -1, -1, -1}
local g_Profile_DressChoose_CurSelId = {-1, -1, -1, -1, -1, -1}
local g_Profile_DressChoose_SelImage = {
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
function Profile_DressChoose_PreLoad()

	this:RegisterEvent("OPEN_EXTERIOR_DRESSCHOOSE")
	this:RegisterEvent("OPEN_EXTERIOR_PROFILE")
		
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("UPDATE_EXTERIOR_FASHION",false)
	
end

--=========
--OnLoad
--=========
function Profile_DressChoose_OnLoad()

	g_Profile_DressChoose_UnifiedPosition = Profile_DressChoose_Frame:GetProperty("UnifiedPosition")
	
	g_Profile_DressChoose_CurSelButton[1] = Profile_DressChoose_Item1
	g_Profile_DressChoose_CurSelButton[2] = Profile_DressChoose_Item2
	g_Profile_DressChoose_CurSelButton[3] = Profile_DressChoose_Item3
	g_Profile_DressChoose_CurSelButton[4] = Profile_DressChoose_Item4
	g_Profile_DressChoose_CurSelButton[5] = Profile_DressChoose_Item5
	g_Profile_DressChoose_CurSelButton[6] = Profile_DressChoose_Item6
	
	g_Profile_DressChoose_CurSelLuxury[1] = Profile_DressChoose_Item1_LuxuryImage
	g_Profile_DressChoose_CurSelLuxury[2] = Profile_DressChoose_Item2_LuxuryImage
	g_Profile_DressChoose_CurSelLuxury[3] = Profile_DressChoose_Item3_LuxuryImage
	g_Profile_DressChoose_CurSelLuxury[4] = Profile_DressChoose_Item4_LuxuryImage
	g_Profile_DressChoose_CurSelLuxury[5] = Profile_DressChoose_Item5_LuxuryImage
	g_Profile_DressChoose_CurSelLuxury[6] = Profile_DressChoose_Item6_LuxuryImage
	
end

--=========
--OnEvent
--=========
function Profile_DressChoose_OnEvent(event)
	
	if event == "OPEN_EXTERIOR_DRESSCHOOSE" then
		--if this:IsVisible() then	
		--	Profile_DressChoose_CloseClick()	
		--	return
		--end
		
		if not IsWindowShow("Profile") then	
			Profile_DressChoose_CloseClick()	
			return
		end
		
		if tonumber(arg1) <= 0 then
			if this:IsVisible() then	
				Profile_DressChoose_CloseClick()	
			end
			PushDebugMessage("#{GRYM_221213_155}")
			return
		end
		
		Profile_DressChoose_CloseSameGroupWindow()
				
		this:Show()
				
		Profile_DressChoose_Show()			
		return
	end
	
	if event == "OPEN_EXTERIOR_PROFILE" then
	
		if IsWindowShow("Profile") then
			if (arg0 == "dress") then
				Profile_DressChoose_CloseClick()
			end
		else
			Profile_DressChoose_CloseClick()	
			return			
		end
			
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			Profile_DressChoose_CloseClick()	
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Profile_DressChoose_On_ResetPos()
	end
	
	if event == "UPDATE_EXTERIOR_FASHION" then
		
		if this:IsVisible() then
			Exterior:LuaFnExteriorProfileAskData(0)
		end
		
	end
	
end

-- 
function Profile_DressChoose_InitInfo()
	
	if g_Profile_Dress_InitList == 0 then			
		for i = 1, g_Profile_DressChoose_BarNum do
			local bar = Profile_DressChoose_List:AddChild("Profile_DressChoose_List_Item")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_Profile_DressChoose_BarList[i] = bar	
			bar:GetSubItem("Profile_DressChoose_List_ActionBtn"):SetEvent("MouseLButtonDown", string.format("Profile_DressChoose_ItemClicked(%d)", i))
			bar:GetSubItem("Profile_DressChoose_List_ActionBtn"):SetProperty("Empty", "False")
			bar:GetSubItem("Profile_DressChoose_List_ActionBtn"):SetProperty("UseDefaultTooltip", "True")
			
			bar:GetSubItem("Profile_DressChoose_List_OrderImage"):Hide()
			bar:GetSubItem("Profile_DressChoose_List_LuxuryImage"):Hide()
			
			table.insert(g_Profile_DressChoose_List, {})
		end
		g_Profile_Dress_InitList = 1
	end
		
	-- 填充时装数据
	for i=1, g_Profile_DressChoose_BarNum do 
		local nVecIndex = i-1
		local nExteriorID = FashionDepot:LuaFnGetFashionId(m_PlayerfashionDepotType, i-1)
		g_Profile_DressChoose_List[i].nVecIndex = nVecIndex				
		if nExteriorID and nExteriorID > 0 then
			g_Profile_DressChoose_List[i].nExteriorID = nExteriorID
		else
			g_Profile_DressChoose_List[i].nExteriorID = -1
		end
	end
	
end
	
function Profile_DressChoose_UpdateSelect()
				
	--玩家已选择
	g_Profile_DressChoose_PlayerSel = 0
	for i in pairs(g_Profile_DressChoose_CurSelIdx) do
		local nSelExteriorIdx, nSelExteriorId = Exterior:LuaFnExteriorPlayerGetProfileData(i, "DRESS")
		if nSelExteriorIdx ~= nil and nSelExteriorIdx >= 0 and nSelExteriorId ~= nil and nSelExteriorId > 0 then 
			g_Profile_DressChoose_PlayerSel = g_Profile_DressChoose_PlayerSel + 1
			
			g_Profile_DressChoose_CurSelIdx[i] = nSelExteriorIdx
			g_Profile_DressChoose_CurSelId[i] = nSelExteriorId
				
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Dress_SetType, i-1, nSelExteriorIdx, nSelExteriorId)
		else
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Dress_SetType, i-1, -1, -1)
		end
	end
	
	local str = ScriptGlobal_Format("#{GRYM_221213_144}", g_Profile_DressChoose_PlayerSel)
	Profile_DressChoose_Text2:SetText(str)
	
end

function Profile_DressChoose_Show()
		
	Profile_DressChoose_InitInfo()

	Profile_DressChoose_CleanUp()
	
	Profile_DressChoose_UpdateSelect()
	
	Profile_DressChoose_UpdateList()
	
end

-- 方案填充数据
function Profile_DressChoose_UpdateList()
			
	-- 显示
	for i=1, g_Profile_DressChoose_BarNum do 
	
		local bar = g_Profile_DressChoose_BarList[i]
		bar:Show()
	
		local nVecIndex = g_Profile_DressChoose_List[i].nVecIndex
		local nExteriorID = FashionDepot:LuaFnGetFashionId(m_PlayerfashionDepotType, nVecIndex)
		
		if g_Profile_DressChoose_List[i].nExteriorID == nExteriorID then
			-- ActionButton
			local ctrlAction = bar:GetSubItem("Profile_DressChoose_List_ActionBtn")
			local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(m_PlayerfashionDepotType, nVecIndex)
			if theAction:GetID() ~= 0 then
				ctrlAction:SetActionItem(theAction:GetID())
			else
				ctrlAction:SetActionItem(-1)
			end
			
			bar:GetSubItem("Profile_DressChoose_List_LuxuryImage"):Hide()
			local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nExteriorID, "Number")
			if nFashionNumber ~= nil and nFashionNumber > 0 then
				bar:GetSubItem("Profile_DressChoose_List_LuxuryImage"):Show()
			end
		
			--已选编号
			for i in pairs(g_Profile_DressChoose_CurSelIdx) do
				if g_Profile_DressChoose_CurSelIdx[i] == nVecIndex and g_Profile_DressChoose_CurSelId[i] == nExteriorID and g_Profile_DressChoose_SelImage[i] ~= nil then			
					bar:GetSubItem("Profile_DressChoose_List_OrderImage"):Show()
					bar:GetSubItem("Profile_DressChoose_List_OrderImage"):SetProperty("Image", g_Profile_DressChoose_SelImage[i])

					if ctrlAction ~= nil then
						ctrlAction:SetPushed(1)
					end
					
					if g_Profile_DressChoose_CurSelButton[i] ~= nil then
						g_Profile_DressChoose_CurSelButton[i]:SetActionItem(theAction:GetID())
						
						g_Profile_DressChoose_CurSelLuxury[i]:Hide()
						local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nExteriorID, "Number")
						if nFashionNumber ~= nil and nFashionNumber > 0 then
							g_Profile_DressChoose_CurSelLuxury[i]:Show()
						end
					end
				end
			end
		end
	end
	
end

-- 选择时装
function Profile_DressChoose_ItemClicked( nIndex )

	local tabInfo = g_Profile_DressChoose_List[nIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		return
	end
	
	local OpRet = 0
	for i in pairs(g_Profile_DressChoose_CurSelIdx) do
		if g_Profile_DressChoose_CurSelIdx[i] == tabInfo.nVecIndex and g_Profile_DressChoose_CurSelId[i] == tabInfo.nExteriorID then
			-- 取消选择
			g_Profile_DressChoose_CurSelIdx[i] = -1
			g_Profile_DressChoose_CurSelId[i] = -1
			
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Dress_SetType, i-1, -1, -1)
			
			local bar = g_Profile_DressChoose_BarList[nIndex]
			if bar then
				bar:GetSubItem("Profile_DressChoose_List_OrderImage"):Hide()

				local ctrlAction = bar:GetSubItem("Profile_DressChoose_List_ActionBtn")
				if ctrlAction ~= nil then
					ctrlAction:SetPushed(0)
				end
			end
					
			if g_Profile_DressChoose_CurSelButton[i] ~= nil then
				g_Profile_DressChoose_CurSelButton[i]:SetActionItem(-1)
				g_Profile_DressChoose_CurSelLuxury[i]:Hide()
			end
			
			g_Profile_DressChoose_PlayerSel = g_Profile_DressChoose_PlayerSel - 1
			local str = ScriptGlobal_Format("#{GRYM_221213_144}", g_Profile_DressChoose_PlayerSel)
			Profile_DressChoose_Text2:SetText(str)
			
			OpRet = 1
		end		
	end
	
	local nFirstPos = 0
	if OpRet == 0 then
		if g_Profile_DressChoose_PlayerSel >= g_Profile_DressChoose_MaxSel then
			PushDebugMessage("#{GRYM_221213_157}")
			return
		end
		
		for i in pairs(g_Profile_DressChoose_CurSelIdx) do
			if g_Profile_DressChoose_CurSelIdx[i] == -1 then
				nFirstPos = i
				break
			end
		end
		if nFirstPos ~= 0 and g_Profile_DressChoose_CurSelIdx[nFirstPos] ~= nil then
			g_Profile_DressChoose_CurSelIdx[nFirstPos] = tabInfo.nVecIndex
			g_Profile_DressChoose_CurSelId[nFirstPos] = tabInfo.nExteriorID
			
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Dress_SetType, nFirstPos-1, tabInfo.nVecIndex, tabInfo.nExteriorID)
			
			local bar = g_Profile_DressChoose_BarList[nIndex]
			if bar and g_Profile_DressChoose_SelImage[nFirstPos] ~= nil then
				bar:GetSubItem("Profile_DressChoose_List_OrderImage"):Show()
				bar:GetSubItem("Profile_DressChoose_List_OrderImage"):SetProperty("Image", g_Profile_DressChoose_SelImage[nFirstPos])

				local ctrlAction = bar:GetSubItem("Profile_DressChoose_List_ActionBtn")
				if ctrlAction ~= nil then
					ctrlAction:SetPushed(1)
				end
			end
					
			if g_Profile_DressChoose_CurSelButton[nFirstPos] ~= nil then
				g_Profile_DressChoose_CurSelLuxury[nFirstPos]:Hide()
				local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(m_PlayerfashionDepotType, tabInfo.nVecIndex)
				if theAction:GetID() ~= 0 then
					g_Profile_DressChoose_CurSelButton[nFirstPos]:SetActionItem(theAction:GetID())
											
					local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(tabInfo.nExteriorID, "Number")
					if nFashionNumber ~= nil and nFashionNumber > 0 then
						g_Profile_DressChoose_CurSelLuxury[nFirstPos]:Show()
					end
				else
					g_Profile_DressChoose_CurSelButton[nFirstPos]:SetActionItem(-1)
				end
			end
			
			g_Profile_DressChoose_PlayerSel = g_Profile_DressChoose_PlayerSel + 1
			local str = ScriptGlobal_Format("#{GRYM_221213_144}", g_Profile_DressChoose_PlayerSel)
			Profile_DressChoose_Text2:SetText(str)
		end
	end
	
end

-- 右键取下
function Profile_DressChoose_ItemRClick( nIndex )

	if g_Profile_DressChoose_CurSelIdx[nIndex] == nil or g_Profile_DressChoose_CurSelId[nIndex] == nil then
		return
	end

	for i in pairs(g_Profile_DressChoose_List) do
		local tabInfo = g_Profile_DressChoose_List[i]
		if g_Profile_DressChoose_CurSelIdx[nIndex] == tabInfo.nVecIndex and g_Profile_DressChoose_CurSelId[nIndex] == tabInfo.nExteriorID then
			-- 取消选择
			g_Profile_DressChoose_CurSelIdx[nIndex] = -1
			g_Profile_DressChoose_CurSelId[nIndex] = -1
			
			Exterior:LuaFnExteriorProfileSelData(g_Profile_Dress_SetType, nIndex-1, -1, -1)
			
			local bar = g_Profile_DressChoose_BarList[i]
			if bar then
				bar:GetSubItem("Profile_DressChoose_List_OrderImage"):Hide()

				local ctrlAction = bar:GetSubItem("Profile_DressChoose_List_ActionBtn")
				if ctrlAction ~= nil then
					ctrlAction:SetPushed(0)
				end
			end
					
			if g_Profile_DressChoose_CurSelButton[nIndex] ~= nil then
				g_Profile_DressChoose_CurSelButton[nIndex]:SetActionItem(-1)
				g_Profile_DressChoose_CurSelLuxury[nIndex]:Hide()
			end
			
			g_Profile_DressChoose_PlayerSel = g_Profile_DressChoose_PlayerSel - 1
			local str = ScriptGlobal_Format("#{GRYM_221213_144}", g_Profile_DressChoose_PlayerSel)
			Profile_DressChoose_Text2:SetText(str)
			
			return
		end		
	end
end

-- 保存修改
function Profile_DressChoose_ConfirmClicked()
	
	Exterior:LuaFnExteriorProfileSaveData(8)
	
end

--小问号
function Profile_DressChoose_HelpClick()

	Helper:GotoHelper("grym")
	
end

--关睜按钮
function Profile_DressChoose_CloseClick()	

	Profile_DressChoose_CleanUp()
	this:Hide()
	
end

function Profile_DressChoose_OnHiden()
	
	Profile_DressChoose_CleanUp()
	
end

function Profile_DressChoose_CleanUp()

	for i = 1, g_Profile_DressChoose_BarNum do
		if g_Profile_DressChoose_BarList[i] then
			local ctrlAction = g_Profile_DressChoose_BarList[i]:GetSubItem("Profile_DressChoose_List_ActionBtn")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
			g_Profile_DressChoose_BarList[i]:GetSubItem("Profile_DressChoose_List_OrderImage"):Hide()
			g_Profile_DressChoose_BarList[i]:GetSubItem("Profile_DressChoose_List_LuxuryImage"):Hide()
		end
	end
	
	for i in pairs(g_Profile_DressChoose_CurSelIdx) do
		-- 取消选择
		g_Profile_DressChoose_CurSelIdx[i] = -1
		g_Profile_DressChoose_CurSelId[i] = -1
			
		Exterior:LuaFnExteriorProfileSelData(g_Profile_Dress_SetType, i-1, -1, -1)
	end
		
	for i in pairs(g_Profile_DressChoose_CurSelButton) do
		g_Profile_DressChoose_CurSelButton[i]:SetActionItem(-1)
		g_Profile_DressChoose_CurSelLuxury[i]:Hide()
	end
	
	g_Profile_DressChoose_PlayerSel = 0
	
end

function Profile_DressChoose_On_ResetPos()

	Profile_DressChoose_Frame:SetProperty("UnifiedPosition", g_Profile_DressChoose_UnifiedPosition);
	
end

function Profile_DressChoose_CloseSameGroupWindow()
	if IsWindowShow("Profile_TagChoose") then
		CloseWindow("Profile_TagChoose", true)
	end
	--if IsWindowShow("Profile_DressChoose") then
	--	CloseWindow("Profile_DressChoose", true)
	--end
	if IsWindowShow("Profile_RideChoose") then
		CloseWindow("Profile_RideChoose", true)
	end
	if IsWindowShow("Profile_WeaponChoose") then
		CloseWindow("Profile_WeaponChoose", true)
	end
end

--!!!reloadscript =Profile_DressChoose
