-- ============================================
-- µä²ØÏµÍ³ (¹ÖÎïÍ¼¼ø) ¿Í»§¶ËUI
-- Ñ©Îè 2026-1-22
-- ============================================

-- UI¿Ø¼þÒýÓÃ
local g_frameUnifiedPosition          -- ???????
local g_tabButtons = {}               -- ??????
local g_currentPage = -1              -- ?????? (1-4)
local g_monsterSlots = {}             -- ??????
local g_monsterNames = {}             -- ????????
local g_activateButtons = {}          -- ????
local g_teleportButtons = {}          -- ????
local g_activatedIcons = {}           -- ?????
local g_currentGroupIndex = 0         -- ?????????
local g_currentSubPage                -- ????? (????8??????)

-- ÉãÏñ»ú²ÎÊýË÷Òý³£Á¿
local CAMERA_HEIGHT = 1               -- ?????
local CAMERA_DISTANCE = 2             -- ?????
local CAMERA_PITCH = 3                -- ?????

-- ÊôÐÔ¼¼ÄÜIDÓ³Éä±í (·ÖÒ³1-4)
local g_attrSkillIds_Page1 = {
	[1] = { 751 },
	[2] = { 752, 753 },
	[3] = { 754 },
	[4] = { 755 },
	[5] = { 756 },
	[6] = { 757 },
	[7] = { 758 },
	[8] = { 759, 760 },
	[9] = { 761, 762 },
	[10] = { 763, 764 },
	[11] = { 765, 766 },
	[12] = { 767, 768 },
	[13] = { 769 },
	[14] = { 770 },
	[15] = { 771 },
	[16] = { 772 },
	[17] = { 773, 774 },
	[18] = { 775 },
	[19] = { 776 },
	[20] = { 777 },
	[21] = { 778 },
	[22] = { 779 },
	[23] = { 780 },
	[24] = { 781 },
}

local g_attrSkillIds_Page2 = {
	[1] = { 782 },
	[2] = { 783 },
	[3] = { 784 },
	[4] = { 785 },
	[5] = { 786 },
	[6] = { 787 },
	[7] = { 788 },
	[8] = { 789 },
	[9] = { 790 },
	[10] = { 791 },
	[11] = { 792 },
	[12] = { 793 },
	[13] = { 794 },
	[14] = { 795 },
	[15] = { 796 },
	[16] = { 797 },
	[17] = { 798 },
	[18] = { 799 },
	[19] = { 800 },
	[20] = { 801 },
	[21] = { 802 },
	[22] = { 803 },
	[23] = { 804 },
}

local g_attrSkillIds_Page3 = {
	[1] = { 805 },
	[2] = { 806 },
	[3] = { 807 },
	[4] = { 808 },
	[5] = { 809 },
	[6] = { 810 },
	[7] = { 811 },
	[8] = { 812 },
	[9] = { 813 },
	[10] = { 814 },
	[11] = { 815 },
	[12] = { 816 },
	[13] = { 817 },
}

local g_attrSkillIds_Page4 = {
	[1] = { 818 },
	[2] = { 819 },
	[3] = { 820 },
	[4] = { 821, 822 },
	[5] = { 823, 824 },
	[6] = { 825 },
	[7] = { 826 },
	[8] = { 827 },
	[9] = { 828, 829 },
	[10] = { 830 },
	[11] = { 831 },
	[12] = { 832 },
	[13] = { 833 },
}

-- ÊôÐÔÏÔÊ¾¿Ø¼þºÍÉý¼¶°´Å¥
local g_attrDisplayLabels = {}        -- ??????
local g_upgradeButtons = {}           -- ????

-- ¹ÖÎïÄ£ÐÍÏà¹Ø
local g_monsterModelIds = {}          -- ????ID??? (CharMount ID?1000??)
local g_fakeObjectSlots = {}          -- 3D??????

-- ============================================
-- Ô¤¼ÓÔØ - ×¢²áÊÂ¼þ
-- ============================================
function DianCang_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
end

-- ============================================
-- ÊÂ¼þ´¦Àí
-- ============================================
function DianCang_OnEvent(event)
	if (event == "PLAYER_LEAVE_WORLD") then
		DianCang_Close()
	elseif (event == "ADJEST_UI_POS") then
		DianCang_OnResetPosition()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DianCang_OnResetPosition()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99222222) then
		this:Show()
		DianCang_OnTabClick(1)
		-- ½çÃæ´ò¿ªÊ±¸üÐÂ×ÜÊôÐÔÐü¸¡ÌáÊ¾
		--DianCang_UpdateTotalAttrTooltip()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99222223) then
		local pageIndex = Get_XParam_INT(0)
		local groupIndex = Get_XParam_INT(1)
		local subPageIndex = Get_XParam_INT(2)
		g_currentSubPage = subPageIndex
		g_currentPage = pageIndex
		DianCang_OnGroupSelected(pageIndex, groupIndex, groupIndex)
		-- ·þÎñÆ÷·µ»Øºó¸üÐÂ×ÜÊôÐÔÐü¸¡ÌáÊ¾
		DianCang_UpdateTotalAttrTooltip()
	end
end

-- ============================================
-- ½çÃæ¼ÓÔØ³õÊ¼»¯
-- ============================================
function DianCang_OnLoad()
	g_frameUnifiedPosition = DianCang_Frame:GetProperty("UnifiedPosition")
	
	-- ³õÊ¼»¯·ÖÒ³°´Å¥
	g_tabButtons[1] = DianCang_FenYe1
	g_tabButtons[2] = DianCang_FenYe2
	g_tabButtons[3] = DianCang_FenYe3
	g_tabButtons[4] = DianCang_FenYe4
	
	-- ³õÊ¼»¯8¸ö¹ÖÎï ¹Ê¾²ÛÎ»µÄ¿Ø¼þÒýÓÃ
	for slotIndex = 1, 8 do
		g_fakeObjectSlots[slotIndex] = _G[string.format("DianCang_FakeObj%d", slotIndex)]
		g_monsterSlots[slotIndex] = _G[string.format("DianCang_CFK_%d", slotIndex)]
		g_monsterNames[slotIndex] = _G[string.format("DianCang_name%d", slotIndex)]
		g_activateButtons[slotIndex] = _G[string.format("DianCang_JH_%d", slotIndex)]
		g_teleportButtons[slotIndex] = _G[string.format("DianCang_qianwang%d", slotIndex)]
		g_activatedIcons[slotIndex] = _G[string.format("DianCang_jh%d", slotIndex)]
		g_attrDisplayLabels[slotIndex] = _G[string.format("DianCang_shuxing%d", slotIndex)]
		g_upgradeButtons[slotIndex] = _G[string.format("DianCang_SJ%d", slotIndex)]
	end
	
	DianCang_InitMonsterModelIds()
end

-- ============================================
-- ³õÊ¼»¯¹ÖÎïÄ£ÐÍIDÓ³Éä
-- ============================================
function DianCang_InitMonsterModelIds()
	for pageIndex = 1, 4 do
		local groupCount = GetDianCangFenYeGroupCount(pageIndex)
		g_monsterModelIds[pageIndex] = {}
		
		for groupIndex = 1, groupCount do
			g_monsterModelIds[pageIndex][groupIndex] = {}
			local monsterCount = GetDianCangGroupCount(pageIndex, groupIndex)
			
			for monsterIndex = 1, monsterCount do
				g_monsterModelIds[pageIndex][groupIndex][monsterIndex] = GetDianCangMonsterModelID(pageIndex, groupIndex, monsterIndex)
			end
		end
	end
end

-- ============================================
-- ÉèÖÃ3DÄ£ÐÍÏÔÊ¾
-- ============================================
function DianCang_SetMonsterModel(slotIndex, pageIndex, groupIndex, monsterIndex)
	local fakeObjSlot = g_fakeObjectSlots[slotIndex]
	if not fakeObjSlot or not g_monsterModelIds[pageIndex] then
		return
	end
	
	local modelId = g_monsterModelIds[pageIndex][groupIndex] and g_monsterModelIds[pageIndex][groupIndex][monsterIndex]
	if not modelId then
		return
	end
	
	fakeObjSlot:SetFakeObject("")
	TuJian:SetModel(slotIndex, modelId)
	TuJian:SetDirection(slotIndex, 1)
	fakeObjSlot:SetFakeObject("TuJian_Model" .. slotIndex)
	
	-- ÉãÏñ»ú²ÎÊý
	local cameraHeight = GetDianCangMonsterCameraHeight(pageIndex, groupIndex, monsterIndex)
	local cameraDistance = GetDianCangMonsterCameraDistance(pageIndex, groupIndex, monsterIndex)
	FakeObj_SetCamera("TuJian_Model" .. slotIndex, CAMERA_HEIGHT, cameraHeight)
	FakeObj_SetCamera("TuJian_Model" .. slotIndex, CAMERA_DISTANCE, cameraDistance)
end

-- ============================================
-- Çå³ý3DÄ£ÐÍÏÔÊ¾
-- ============================================
function DianCang_ClearMonsterModel(slotIndex)
	if g_fakeObjectSlots[slotIndex] then
		g_fakeObjectSlots[slotIndex]:SetFakeObject("")
	end
end

-- ============================================
-- Ç°Íù¹ÖÎïËùÔÚÎ»ÖÃ
-- ============================================
function DianCang_qianwangFunc(slotIndex)
	local monsterIndex = slotIndex
	if g_currentSubPage == 1 then
		monsterIndex = slotIndex + 8
	end
	
	local mapId, posX, posZ = GetDianCangMonsterCoord(g_currentPage, g_currentGroupIndex, monsterIndex)
	if mapId and mapId > 0 then
		AutoRunToTargetEx(posX, posZ, mapId)
	end
end

-- ============================================
-- ½çÃæ¹Ø± 
-- ============================================
function DianCang_Hide()
	DianCang_Close()
end

function DianCang_Close()
	this:Hide()
end

-- ============================================
-- ÖØÖÃ´°¿ÚÎ»ÖÃ
-- ============================================
function DianCang_OnResetPosition()
	DianCang_Frame:SetProperty("UnifiedPosition", g_frameUnifiedPosition)
end

-- ============================================
-- »ñÈ¡¹ÖÎïÃû³Æ´úÀí±í
-- ============================================
local function CreateMonsterNameProxy(pageIndex)
	local proxy = {}
	setmetatable(proxy, {
		__index = function(t, groupIndex)
			local groupProxy = {}
			setmetatable(groupProxy, {
				__index = function(gt, monsterIndex)
					return GetDianCangMonsterName(pageIndex, groupIndex, monsterIndex)
				end
			})
			return groupProxy
		end
	})
	return proxy
end

-- ============================================
-- »ñÈ¡¹ÖÎï¼¤»îÊýÁ¿´úÀí±í
-- ============================================
local function CreateMonsterRequiredNumProxy(pageIndex)
	local proxy = {}
	setmetatable(proxy, {
		__index = function(t, groupIndex)
			local groupProxy = {}
			setmetatable(groupProxy, {
				__index = function(gt, monsterIndex)
					return GetDianCangMonsterNum(pageIndex, groupIndex, monsterIndex)
				end
			})
			return groupProxy
		end
	})
	return proxy
end


-- ============================================
-- ·Ö×éÑ¡ÖÐ´¦Àí - ÏÔÊ¾¹ÖÎïÁÐ±í
-- ============================================
function DianCang_OnGroupSelected(pageOverride, groupOverride, subPageOverride)
	-- ´¦Àí²ÎÊý
	if pageOverride == nil then
		g_currentSubPage = 0
	end
	
	local selectedIndex
	if groupOverride == nil then
		selectedIndex = DianCang_List:GetFirstSelectItem()
	else
		selectedIndex = 0
	end
	
	if subPageOverride == nil then
		selectedIndex = DianCang_List:GetFirstSelectItem()
	else
		selectedIndex = subPageOverride
	end
	
	selectedIndex = selectedIndex + 1
	g_currentGroupIndex = selectedIndex
	
	if selectedIndex == -1 then
		return
	end

	-- Çå¿ ËùÓÐ ¹Ê¾²ÛÎ»
	for slotIndex = 1, 8 do
		g_monsterSlots[slotIndex]:Hide()
		DianCang_ClearMonsterModel(slotIndex)
		g_activateButtons[slotIndex]:Show()
		g_teleportButtons[slotIndex]:Show()
		g_activatedIcons[slotIndex]:Hide()
		g_fakeObjectSlots[slotIndex]:SetToolTip("")
		g_attrDisplayLabels[slotIndex]:Hide()
		g_upgradeButtons[slotIndex]:Hide()
		g_upgradeButtons[slotIndex]:Enable()
		g_upgradeButtons[slotIndex]:SetText("Thång c¤p")
		
		g_fakeObjectSlots[slotIndex]:Disable()
	end
	
	local playerLevel = Player:GetData("LEVEL")
	DianCang_UpPage:Disable()
	DianCang_DownPage:Disable()
	
	if selectedIndex <= 0 then return end
	
	local monsterCount = GetDianCangGroupCount(g_currentPage, selectedIndex) --??????
	local monsterNameProxy = CreateMonsterNameProxy(g_currentPage)
	local requiredNumProxy = CreateMonsterRequiredNumProxy(g_currentPage)
	
	if monsterCount <= 0 then return end
	
	-- ¼ÆËãÊôÐÔË÷ÒýÆ«ÒÆÁ¿ (²»Í¬·ÖÒ³µÄÊôÐÔÅäÖÃÆðÊ¼Î»ÖÃ²»Í¬)
	local attrIndexOffset = 0
	if g_currentPage == 2 then attrIndexOffset = 24
	elseif g_currentPage == 3 then attrIndexOffset = 47
	elseif g_currentPage == 4 then attrIndexOffset = 60
	end
	
	-- »ñÈ¡µ±Ç°·ÖÒ³¶ÔÓ¦µÄÊôÐÔ¼¼ÄÜID±í
	local attrSkillIdTable = nil
	if g_currentPage == 1 then attrSkillIdTable = g_attrSkillIds_Page1
	elseif g_currentPage == 2 then attrSkillIdTable = g_attrSkillIds_Page2
	elseif g_currentPage == 3 then attrSkillIdTable = g_attrSkillIds_Page3
	elseif g_currentPage == 4 then attrSkillIdTable = g_attrSkillIds_Page4
	end
	
	-- »ñÈ¡¼¤»îµÈ¼¶×´Ì¬
	local activationLevels = {}
	if attrSkillIdTable and attrSkillIdTable[selectedIndex] then
		local subPageIdx = (g_currentSubPage == 0) and 1 or 2
		if attrSkillIdTable[selectedIndex][subPageIdx] then
			activationLevels = DianCang_ParseActivationData(attrSkillIdTable[selectedIndex][subPageIdx])
		else
			activationLevels = DianCang_ParseActivationData(attrSkillIdTable[selectedIndex][1])
		end
	else
		for i = 1, 8 do activationLevels[i] = 0 end
	end

	-- ¸ù¾Ý¹ÖÎïÊýÁ¿¾ö¶¨ÊÇ·ñÐèÒª·­Ò³
	DianCang_DisplayMonsters(selectedIndex, monsterCount, monsterNameProxy, requiredNumProxy, attrIndexOffset, activationLevels, playerLevel)
end

-- ============================================
-- ÏÔÊ¾¹ÖÎïÁÐ±í (´¦Àí·­Ò³Âß¼­)
-- ============================================
function DianCang_DisplayMonsters(groupIndex, monsterCount, nameProxy, numProxy, attrOffset, activationLevels, playerLevel)
	if monsterCount > 8 then
		-- ÐèÒª·­Ò³ÏÔÊ¾
		if g_currentSubPage == 0 then
			-- ÏÔÊ¾µÚÒ»Ò³ (Ç°8¸ö¹ÖÎï)
			DianCang_UpPage:Disable()
			DianCang_DownPage:Enable()
			
			for slotIndex = 1, 8 do
				DianCang_ShowMonsterSlot(slotIndex, groupIndex, slotIndex, nameProxy, numProxy,attrOffset, activationLevels[slotIndex], playerLevel)
			end
		elseif g_currentSubPage == 1 then
			-- ÏÔÊ¾µÚ¶þÒ³ (µÚ9¸ö¼°Ö®ºóµÄ¹ÖÎï)
			DianCang_UpPage:Enable()
			DianCang_DownPage:Disable()
			
			local remainingCount = monsterCount - 8
			for slotIndex = 1, math.min(remainingCount, 8) do
				local monsterIndex = slotIndex + 8
				if nameProxy[groupIndex][monsterIndex] then
					DianCang_ShowMonsterSlot(slotIndex, groupIndex, monsterIndex, nameProxy, numProxy,attrOffset, activationLevels[slotIndex], playerLevel)
				end
			end
		end
	else
		-- ²»ÐèÒª·­Ò³£¬Ö±½ÓÏÔÊ¾ËùÓÐ¹ÖÎï
		for slotIndex = 1, monsterCount do
			if nameProxy[groupIndex][slotIndex] then
				g_monsterSlots[slotIndex]:Show()
				g_monsterNames[slotIndex]:SetText("#H" .. nameProxy[groupIndex][slotIndex])
				DianCang_SetMonsterModel(slotIndex, g_currentPage, groupIndex, slotIndex)
			end
		end
		
		-- ÉèÖÃÊôÐÔÏÔÊ¾
		local attrGroupIndex = groupIndex + attrOffset
		for slotIndex = 1, 8 do
			DianCang_UpdateSlotAttribute(slotIndex, attrGroupIndex, groupIndex, nameProxy, numProxy,activationLevels[slotIndex], playerLevel)
		end
	end
end

-- ============================================
-- ÏÔÊ¾µ¥¸ö¹ÖÎï²ÛÎ»
-- ============================================
function DianCang_ShowMonsterSlot(slotIndex, groupIndex, monsterIndex, nameProxy, numProxy,attrOffset, activationLevel, playerLevel)
	g_monsterSlots[slotIndex]:Show()
	g_monsterNames[slotIndex]:SetText("#H" .. nameProxy[groupIndex][monsterIndex])
	DianCang_SetMonsterModel(slotIndex, g_currentPage, groupIndex, monsterIndex)
	
	local attrGroupIndex = groupIndex + attrOffset
	local attrIndex = GetDianCangAttrIndex(attrGroupIndex, monsterIndex)	--??????
	local attrValue = GetDianCangAttrValue(attrGroupIndex, monsterIndex) --?????
	local attrName = GetDianCangAttrName(attrIndex)	--??????
	
	if activationLevel > 0 then
		-- ÒÑ¼¤»î×´Ì¬
		g_activateButtons[slotIndex]:Hide()
		g_teleportButtons[slotIndex]:Hide()
		g_activatedIcons[slotIndex]:Show()
		g_fakeObjectSlots[slotIndex]:Enable()
		local totalAttrValue = attrValue * activationLevel
		g_fakeObjectSlots[slotIndex]:SetToolTip("#WCAi Ði¬n Tàng Dî kích hoÕt#r#G" .. attrName .. "" .. totalAttrValue)
		g_attrDisplayLabels[slotIndex]:Show()
		g_attrDisplayLabels[slotIndex]:SetText("#G" .. attrName .. "" .. totalAttrValue)
		
		-- 70¼¶ÒÔÉÏÏÔÊ¾Éý¼¶°´Å¥
		if playerLevel > 69 then
			g_upgradeButtons[slotIndex]:Show()
		end
		
		-- Âú¼¶¼ì²é (µÈ¼¶>8ÎªÂú¼¶)
		if activationLevel > 8 then
			g_upgradeButtons[slotIndex]:Disable()
			g_upgradeButtons[slotIndex]:SetText("Dî Mãn C¤p")
		end
	else
		-- Î´¼¤»î×´Ì¬ - ÏÔÊ¾¼¤»îÌõ¼þÌáÊ¾
		if attrName and attrName ~= "" and numProxy[groupIndex][monsterIndex] then
			local tooltipText = "#cff9966kích hoÕt thuµc tính: #r#W" .. attrName .. "" .. attrValue .. "#r#cff9966kích hoÕt tài li®u: #r#W" .. nameProxy[groupIndex][monsterIndex] .. "*" .. numProxy[groupIndex][monsterIndex] .. "#r#{_EXCHG100000}"
			g_fakeObjectSlots[slotIndex]:SetToolTip(tooltipText)
		end
	end
end

-- ============================================
-- ¸üÐÂ²ÛÎ»ÊôÐÔÏÔÊ¾ (²»·­Ò³Ê±Ê¹ÓÃ)
-- ============================================
function DianCang_UpdateSlotAttribute(slotIndex, attrGroupIndex, groupIndex, nameProxy, numProxy,activationLevel, playerLevel)
	local attrIndex = GetDianCangAttrIndex(attrGroupIndex, slotIndex)
	local attrValue = GetDianCangAttrValue(attrGroupIndex, slotIndex)
	local attrName = GetDianCangAttrName(attrIndex)
	
	if not (attrIndex and attrIndex > 0 and attrName and attrName ~= "") then
		return
	end
	
	if activationLevel > 0 then
		-- ÒÑ¼¤»î×´Ì¬
		g_activateButtons[slotIndex]:Hide()
		g_teleportButtons[slotIndex]:Hide()
		g_activatedIcons[slotIndex]:Show()
		g_fakeObjectSlots[slotIndex]:Enable()
		local totalAttrValue = attrValue * activationLevel
		g_fakeObjectSlots[slotIndex]:SetToolTip("#WCAi Ði¬n Tàng Dî kích hoÕt#r#G" .. attrName .. "" .. totalAttrValue)
		g_attrDisplayLabels[slotIndex]:Show()
		g_attrDisplayLabels[slotIndex]:SetText("#G" .. attrName .. "" .. totalAttrValue)
		
		if playerLevel > 69 then
			g_upgradeButtons[slotIndex]:Show()
		end
		
		if activationLevel > 8 then
			g_upgradeButtons[slotIndex]:Disable()
			g_upgradeButtons[slotIndex]:SetText("Dî Mãn C¤p")
		end
	else
		-- Î´¼¤»î×´Ì¬
		if numProxy[groupIndex] and numProxy[groupIndex][slotIndex] and nameProxy[groupIndex][slotIndex] then
			local tooltipText = "#cff9966kích hoÕt thuµc tính: #r#W" .. attrName .. "" .. attrValue .. "#r#cff9966kích hoÕt tài li®u: #r#W" .. nameProxy[groupIndex][slotIndex] .. "*" .. numProxy[groupIndex][slotIndex] .. "#r#{_EXCHG100000}"
			g_fakeObjectSlots[slotIndex]:SetToolTip(tooltipText)
		end
	end
end

-- ============================================
-- ½âÎö¼¤»îÊý¾Ý (´ÓÈÎÎñÊý¾ÝÖÐÌáÈ¡8Î»¼¤»îµÈ¼¶)
-- ============================================
function DianCang_ParseActivationData(skillId)
	local activationLevels = {}
	for i = 1, 8 do
		activationLevels[i] = 0
	end
	
	if skillId ~= nil then
		local rawData = DataPool:GetPlayerMission_DataRound(skillId)
		activationLevels[1] = math.mod(math.floor(rawData / 1), 10)
		activationLevels[2] = math.mod(math.floor(rawData / 10), 10)
		activationLevels[3] = math.mod(math.floor(rawData / 100), 10)
		activationLevels[4] = math.mod(math.floor(rawData / 1000), 10)
		activationLevels[5] = math.mod(math.floor(rawData / 10000), 10)
		activationLevels[6] = math.mod(math.floor(rawData / 100000), 10)
		activationLevels[7] = math.mod(math.floor(rawData / 1000000), 10)
		activationLevels[8] = math.mod(math.floor(rawData / 10000000), 10)
	end
	
	return activationLevels
end


-- ============================================
-- ·­Ò³°´Å¥µã»÷´¦Àí
-- ============================================
function DianCang_Pre_Click(direction)
	if direction == 1 then
		-- ÉÏÒ»Ò³
		g_currentSubPage = g_currentSubPage - 1
		if g_currentSubPage < 0 then
			g_currentSubPage = 0
		end
	elseif direction == 2 then
		-- ÏÂÒ»Ò³
		g_currentSubPage = g_currentSubPage + 1
		if g_currentSubPage > 1 then
			g_currentSubPage = 1
		end
	end
	DianCang_OnGroupSelected(g_currentSubPage, nil)
end

-- ============================================
-- ·ÖÒ³±êÇ©µã»÷´¦Àí
-- ============================================
function DianCang_OnTabClick(tabIndex)
	-- ¸üÐÂ·ÖÒ³°´Å¥Ñ¡ÖÐ×´Ì¬
	for i = 1, 4 do
		g_tabButtons[i]:SetCheck(0)
	end
	g_tabButtons[tabIndex]:SetCheck(1)
	
	-- Çå¿ ²¢ÖØÐÂÌî³ä·Ö×éÁÐ±í
	DianCang_List:ClearListBox()
	local groupCount = GetDianCangFenYeGroupCount(tabIndex)
	for groupIndex = 1, groupCount do
		local groupName = GetDianCangGroupName(tabIndex, groupIndex)
		if groupName and groupName ~= "" then
			DianCang_List:AddItem(" "..groupName, groupIndex - 1)
		end
	end
	
	g_currentPage = tabIndex
	DianCang_List:SetItemSelectByItemID(0)
	DianCang_OnGroupSelected(nil, g_currentPage)
	-- ¸üÐÂÒÑ¼¤»î×ÜÊôÐÔÐü¸¡ÌáÊ¾
	DianCang_UpdateTotalAttrTooltip()
end

-- ============================================
-- ¼¤»î°´Å¥µã»÷´¦Àí
-- ============================================
function DianCang_JH_Click(slotIndex)
	if g_currentPage == -1 then
		PushDebugMessage("Không biªt sai l¥m Thïnh mµt l¥n næa Tá Khai m£t biên")
		return
	end
	if g_currentGroupIndex < 1 then
		PushDebugMessage("Không biªt sai l¥m Thïnh mµt l¥n næa Tá Khai m£t biên")
		return
	end
	
	-- ·¢ËÍ¼¤»îÇëÇóµ½·þÎñÆ÷
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("MonsterBookMain")
	Set_XSCRIPT_ScriptID(912217)
	Set_XSCRIPT_Parameter(0, g_currentPage)
	Set_XSCRIPT_Parameter(1, g_currentGroupIndex)
	Set_XSCRIPT_Parameter(2, slotIndex)
	Set_XSCRIPT_Parameter(3, g_currentSubPage)
	Set_XSCRIPT_Parameter(4, 1)  -- ????: 1=??
	Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
end

-- ============================================
-- Éý¼¶°´Å¥µã»÷´¦Àí
-- ============================================
function DianCang_SJ_Click(slotIndex)
	if g_currentPage == -1 then
		PushDebugMessage("Không biªt sai l¥m Thïnh mµt l¥n næa Tá Khai m£t biên")
		return
	end
	if g_currentGroupIndex < 1 then
		PushDebugMessage("Không biªt sai l¥m Thïnh mµt l¥n næa Tá Khai m£t biên")
		return
	end
	
	-- ·¢ËÍÉý¼¶ÇëÇóµ½·þÎñÆ÷
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("MonsterBookMain")
	Set_XSCRIPT_ScriptID(912217)
	Set_XSCRIPT_Parameter(0, g_currentPage)
	Set_XSCRIPT_Parameter(1, g_currentGroupIndex)
	Set_XSCRIPT_Parameter(2, slotIndex)
	Set_XSCRIPT_Parameter(3, g_currentSubPage)
	Set_XSCRIPT_Parameter(4, 2)  -- ????: 2=??
	Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
end


-- ============================================
-- »ã×ÜÒÑ¼¤»î×ÜÊôÐÔ²¢¸üÐÂÐü¸¡ÌáÊ¾
-- ============================================
function DianCang_UpdateTotalAttrTooltip()
	-- ÊôÐÔ»ã×Ü±í (°´ÊôÐÔIDÀÛ¼Ó)
	local totalAttrs = {}
	
	-- ËùÓÐÒ³ÃæµÄ¼¼ÄÜID±í
	local allSkillTables = {
		g_attrSkillIds_Page1,
		g_attrSkillIds_Page2,
		g_attrSkillIds_Page3,
		g_attrSkillIds_Page4
	}
	
	-- ÊôÐÔÆ«ÒÆÁ¿ (Ã¿¸öÒ³ÃæµÄÆðÊ¼GroupID)
	local attrOffsets = { 0, 24, 47, 60 }
	
	-- ±éÀúËùÓÐÒ³Ãæ
	for pageIndex = 1, 4 do
		local skillTable = allSkillTables[pageIndex]
		local attrOffset = attrOffsets[pageIndex]
		
		if skillTable then
			-- ±éÀú¸ÃÒ³ÃæµÄËùÓÐ·Ö×é
			for groupIndex, skillIds in pairs(skillTable) do
				-- ±éÀú¸Ã·Ö×éµÄËùÓÐ¼¼ÄÜID (´¦Àí·ÖÒ³Çé¿ö)
				for subPageIdx, skillId in ipairs(skillIds) do
					-- »ñÈ¡¼¤»îµÈ¼¶Êý¾Ý
					local activationLevels = DianCang_ParseActivationData(skillId)
					
					-- ¼ÆËã¸Ã·Ö×éµÄ¹ÖÎïÊýÁ¿
					local monsterCount = GetDianCangGroupCount(pageIndex, groupIndex)
					local startMonster = (subPageIdx == 1) and 1 or 9
					local endMonster = (subPageIdx == 1) and math.min(8, monsterCount) or monsterCount
					
					-- ±éÀú¸Ã·Ö×éµÄ¹ÖÎï
					for slotIndex = 1, 8 do
						local monsterIndex = startMonster + slotIndex - 1
						if monsterIndex <= endMonster and activationLevels[slotIndex] > 0 then
							local attrGroupIndex = groupIndex + attrOffset
							local attrIndex = GetDianCangAttrIndex(attrGroupIndex, monsterIndex)
							local attrValue = GetDianCangAttrValue(attrGroupIndex, monsterIndex)
							
							if attrIndex and attrIndex > 0 and attrValue then
								local totalValue = attrValue * activationLevels[slotIndex]
								totalAttrs[attrIndex] = (totalAttrs[attrIndex] or 0) + totalValue
							end
						end
					end
				end
			end
		end
	end
	
	-- Éú³ÉÐü¸¡ÌáÊ¾ÎÄ±¾
	local tooltipText = "Dî kích hoÕt Ði¬n Tàng gia tång T±ng thuµc tính: #G"
	local hasAttr = false
	
	-- °´ÊôÐÔIDÅÅÐòÊä³ö
	local sortedAttrIds = {}
	for attrId, _ in pairs(totalAttrs) do
		table.insert(sortedAttrIds, attrId)
	end
	table.sort(sortedAttrIds)
	
	for _, attrId in ipairs(sortedAttrIds) do
		local attrName = GetDianCangAttrName(attrId)
		local attrValue = totalAttrs[attrId]
		if attrName and attrName ~= "" and attrValue > 0 then
			tooltipText = tooltipText .. "#r" .. attrName .. attrValue
			hasAttr = true
		end
	end
	
	if not hasAttr then
		tooltipText = "Dî kích hoÕt Ði¬n Tàng gia tång T±ng thuµc tính: #r#WT?m Vô Dî kích hoÕt thuµc tính"
	end
	
	-- ¸üÐÂÐü¸¡ÌáÊ¾
	if DianCang_AttrText then
		DianCang_AttrText:SetToolTip(tooltipText)
	end
end
