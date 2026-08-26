-- ============================================
-- 典藏系统 (怪物图鉴) 客户端UI
-- 雪舞 2026-1-22
-- ============================================

-- UI控件引用
local g_frameUnifiedPosition          -- 主窗口统一位置
local g_tabButtons = {}               -- 分页按钮数组
local g_currentPage = -1              -- 当前分页索引 (1-4)
local g_monsterSlots = {}             -- 怪物展示槽位
local g_monsterNames = {}             -- 怪物名称文本控件
local g_activateButtons = {}          -- 激活按钮
local g_teleportButtons = {}          -- 前往按钮
local g_activatedIcons = {}           -- 已激活图标
local g_currentGroupIndex = 0         -- 当前选中的分组索引
local g_currentSubPage                -- 当前子页面 (用于超过8个怪物时翻页)

-- 摄像机参数索引常量
local CAMERA_HEIGHT = 1               -- 摄影机高度
local CAMERA_DISTANCE = 2             -- 摄影机距离
local CAMERA_PITCH = 3                -- 摄影机角度

-- 属性技能ID映射表 (分页1-4)
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

-- 属性显示控件和升级按钮
local g_attrDisplayLabels = {}        -- 属性显示文本
local g_upgradeButtons = {}           -- 升级按钮

-- 怪物模型相关
local g_monsterModelIds = {}          -- 怪物模型ID映射表 (CharMount ID从1000开始)
local g_fakeObjectSlots = {}          -- 3D模型显示控件

-- ============================================
-- 预加载 - 注册事件
-- ============================================
function DianCang_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
end

-- ============================================
-- 事件处理
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
		-- 界面打开时更新总属性悬浮提示
		--DianCang_UpdateTotalAttrTooltip()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99222223) then
		local pageIndex = Get_XParam_INT(0)
		local groupIndex = Get_XParam_INT(1)
		local subPageIndex = Get_XParam_INT(2)
		g_currentSubPage = subPageIndex
		g_currentPage = pageIndex
		DianCang_OnGroupSelected(pageIndex, groupIndex, groupIndex)
		-- 服务器返回后更新总属性悬浮提示
		DianCang_UpdateTotalAttrTooltip()
	end
end

-- ============================================
-- 界面加载初始化
-- ============================================
function DianCang_OnLoad()
	g_frameUnifiedPosition = DianCang_Frame:GetProperty("UnifiedPosition")
	
	-- 初始化分页按钮
	g_tabButtons[1] = DianCang_FenYe1
	g_tabButtons[2] = DianCang_FenYe2
	g_tabButtons[3] = DianCang_FenYe3
	g_tabButtons[4] = DianCang_FenYe4
	
	-- 初始化8个怪物展示槽位的控件引用
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
-- 初始化怪物模型ID映射
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
-- 设置3D模型显示
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
	
	-- 摄像机参数
	local cameraHeight = GetDianCangMonsterCameraHeight(pageIndex, groupIndex, monsterIndex)
	local cameraDistance = GetDianCangMonsterCameraDistance(pageIndex, groupIndex, monsterIndex)
	FakeObj_SetCamera("TuJian_Model" .. slotIndex, CAMERA_HEIGHT, cameraHeight)
	FakeObj_SetCamera("TuJian_Model" .. slotIndex, CAMERA_DISTANCE, cameraDistance)
end

-- ============================================
-- 清除3D模型显示
-- ============================================
function DianCang_ClearMonsterModel(slotIndex)
	if g_fakeObjectSlots[slotIndex] then
		g_fakeObjectSlots[slotIndex]:SetFakeObject("")
	end
end

-- ============================================
-- 前往怪物所在位置
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
-- 界面关闭
-- ============================================
function DianCang_Hide()
	DianCang_Close()
end

function DianCang_Close()
	this:Hide()
end

-- ============================================
-- 重置窗口位置
-- ============================================
function DianCang_OnResetPosition()
	DianCang_Frame:SetProperty("UnifiedPosition", g_frameUnifiedPosition)
end

-- ============================================
-- 获取怪物名称代理表
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
-- 获取怪物激活数量代理表
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
-- 分组选中处理 - 显示怪物列表
-- ============================================
function DianCang_OnGroupSelected(pageOverride, groupOverride, subPageOverride)
	-- 处理参数
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

	-- 清空所有展示槽位
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
		g_upgradeButtons[slotIndex]:SetText("升级")
		
		g_fakeObjectSlots[slotIndex]:Disable()
	end
	
	local playerLevel = Player:GetData("LEVEL")
	DianCang_UpPage:Disable()
	DianCang_DownPage:Disable()
	
	if selectedIndex <= 0 then return end
	
	local monsterCount = GetDianCangGroupCount(g_currentPage, selectedIndex) --获取怪物数量
	local monsterNameProxy = CreateMonsterNameProxy(g_currentPage)
	local requiredNumProxy = CreateMonsterRequiredNumProxy(g_currentPage)
	
	if monsterCount <= 0 then return end
	
	-- 计算属性索引偏移量 (不同分页的属性配置起始位置不同)
	local attrIndexOffset = 0
	if g_currentPage == 2 then attrIndexOffset = 24
	elseif g_currentPage == 3 then attrIndexOffset = 47
	elseif g_currentPage == 4 then attrIndexOffset = 60
	end
	
	-- 获取当前分页对应的属性技能ID表
	local attrSkillIdTable = nil
	if g_currentPage == 1 then attrSkillIdTable = g_attrSkillIds_Page1
	elseif g_currentPage == 2 then attrSkillIdTable = g_attrSkillIds_Page2
	elseif g_currentPage == 3 then attrSkillIdTable = g_attrSkillIds_Page3
	elseif g_currentPage == 4 then attrSkillIdTable = g_attrSkillIds_Page4
	end
	
	-- 获取激活等级状态
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

	-- 根据怪物数量决定是否需要翻页
	DianCang_DisplayMonsters(selectedIndex, monsterCount, monsterNameProxy, requiredNumProxy, attrIndexOffset, activationLevels, playerLevel)
end

-- ============================================
-- 显示怪物列表 (处理翻页逻辑)
-- ============================================
function DianCang_DisplayMonsters(groupIndex, monsterCount, nameProxy, numProxy, attrOffset, activationLevels, playerLevel)
	if monsterCount > 8 then
		-- 需要翻页显示
		if g_currentSubPage == 0 then
			-- 显示第一页 (前8个怪物)
			DianCang_UpPage:Disable()
			DianCang_DownPage:Enable()
			
			for slotIndex = 1, 8 do
				DianCang_ShowMonsterSlot(slotIndex, groupIndex, slotIndex, nameProxy, numProxy,attrOffset, activationLevels[slotIndex], playerLevel)
			end
		elseif g_currentSubPage == 1 then
			-- 显示第二页 (第9个及之后的怪物)
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
		-- 不需要翻页，直接显示所有怪物
		for slotIndex = 1, monsterCount do
			if nameProxy[groupIndex][slotIndex] then
				g_monsterSlots[slotIndex]:Show()
				g_monsterNames[slotIndex]:SetText("#H" .. nameProxy[groupIndex][slotIndex])
				DianCang_SetMonsterModel(slotIndex, g_currentPage, groupIndex, slotIndex)
			end
		end
		
		-- 设置属性显示
		local attrGroupIndex = groupIndex + attrOffset
		for slotIndex = 1, 8 do
			DianCang_UpdateSlotAttribute(slotIndex, attrGroupIndex, groupIndex, nameProxy, numProxy,activationLevels[slotIndex], playerLevel)
		end
	end
end

-- ============================================
-- 显示单个怪物槽位
-- ============================================
function DianCang_ShowMonsterSlot(slotIndex, groupIndex, monsterIndex, nameProxy, numProxy,attrOffset, activationLevel, playerLevel)
	g_monsterSlots[slotIndex]:Show()
	g_monsterNames[slotIndex]:SetText("#H" .. nameProxy[groupIndex][monsterIndex])
	DianCang_SetMonsterModel(slotIndex, g_currentPage, groupIndex, monsterIndex)
	
	local attrGroupIndex = groupIndex + attrOffset
	local attrIndex = GetDianCangAttrIndex(attrGroupIndex, monsterIndex)	--获取属性索引
	local attrValue = GetDianCangAttrValue(attrGroupIndex, monsterIndex) --获取属性值
	local attrName = GetDianCangAttrName(attrIndex)	--获取属性名称
	
	if activationLevel > 0 then
		-- 已激活状态
		g_activateButtons[slotIndex]:Hide()
		g_teleportButtons[slotIndex]:Hide()
		g_activatedIcons[slotIndex]:Show()
		g_fakeObjectSlots[slotIndex]:Enable()
		local totalAttrValue = attrValue * activationLevel
		g_fakeObjectSlots[slotIndex]:SetToolTip("#W该典藏已激活#r#G" .. attrName .. "" .. totalAttrValue)
		g_attrDisplayLabels[slotIndex]:Show()
		g_attrDisplayLabels[slotIndex]:SetText("#G" .. attrName .. "" .. totalAttrValue)
		
		-- 70级以上显示升级按钮
		if playerLevel > 69 then
			g_upgradeButtons[slotIndex]:Show()
		end
		
		-- 满级检查 (等级>8为满级)
		if activationLevel > 8 then
			g_upgradeButtons[slotIndex]:Disable()
			g_upgradeButtons[slotIndex]:SetText("已满级")
		end
	else
		-- 未激活状态 - 显示激活条件提示
		if attrName and attrName ~= "" and numProxy[groupIndex][monsterIndex] then
			local tooltipText = "#cff9966激活属性：#r#W" .. attrName .. "" .. attrValue .. "#r#cff9966激活材料：#r#W" .. nameProxy[groupIndex][monsterIndex] .. "*" .. numProxy[groupIndex][monsterIndex] .. "#r#{_EXCHG100000}"
			g_fakeObjectSlots[slotIndex]:SetToolTip(tooltipText)
		end
	end
end

-- ============================================
-- 更新槽位属性显示 (不翻页时使用)
-- ============================================
function DianCang_UpdateSlotAttribute(slotIndex, attrGroupIndex, groupIndex, nameProxy, numProxy,activationLevel, playerLevel)
	local attrIndex = GetDianCangAttrIndex(attrGroupIndex, slotIndex)
	local attrValue = GetDianCangAttrValue(attrGroupIndex, slotIndex)
	local attrName = GetDianCangAttrName(attrIndex)
	
	if not (attrIndex and attrIndex > 0 and attrName and attrName ~= "") then
		return
	end
	
	if activationLevel > 0 then
		-- 已激活状态
		g_activateButtons[slotIndex]:Hide()
		g_teleportButtons[slotIndex]:Hide()
		g_activatedIcons[slotIndex]:Show()
		g_fakeObjectSlots[slotIndex]:Enable()
		local totalAttrValue = attrValue * activationLevel
		g_fakeObjectSlots[slotIndex]:SetToolTip("#W该典藏已激活#r#G" .. attrName .. "" .. totalAttrValue)
		g_attrDisplayLabels[slotIndex]:Show()
		g_attrDisplayLabels[slotIndex]:SetText("#G" .. attrName .. "" .. totalAttrValue)
		
		if playerLevel > 69 then
			g_upgradeButtons[slotIndex]:Show()
		end
		
		if activationLevel > 8 then
			g_upgradeButtons[slotIndex]:Disable()
			g_upgradeButtons[slotIndex]:SetText("已满级")
		end
	else
		-- 未激活状态
		if numProxy[groupIndex] and numProxy[groupIndex][slotIndex] and nameProxy[groupIndex][slotIndex] then
			local tooltipText = "#cff9966激活属性：#r#W" .. attrName .. "" .. attrValue .. "#r#cff9966激活材料：#r#W" .. nameProxy[groupIndex][slotIndex] .. "*" .. numProxy[groupIndex][slotIndex] .. "#r#{_EXCHG100000}"
			g_fakeObjectSlots[slotIndex]:SetToolTip(tooltipText)
		end
	end
end

-- ============================================
-- 解析激活数据 (从任务数据中提取8位激活等级)
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
-- 翻页按钮点击处理
-- ============================================
function DianCang_Pre_Click(direction)
	if direction == 1 then
		-- 上一页
		g_currentSubPage = g_currentSubPage - 1
		if g_currentSubPage < 0 then
			g_currentSubPage = 0
		end
	elseif direction == 2 then
		-- 下一页
		g_currentSubPage = g_currentSubPage + 1
		if g_currentSubPage > 1 then
			g_currentSubPage = 1
		end
	end
	DianCang_OnGroupSelected(g_currentSubPage, nil)
end

-- ============================================
-- 分页标签点击处理
-- ============================================
function DianCang_OnTabClick(tabIndex)
	-- 更新分页按钮选中状态
	for i = 1, 4 do
		g_tabButtons[i]:SetCheck(0)
	end
	g_tabButtons[tabIndex]:SetCheck(1)
	
	-- 清空并重新填充分组列表
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
	-- 更新已激活总属性悬浮提示
	DianCang_UpdateTotalAttrTooltip()
end

-- ============================================
-- 激活按钮点击处理
-- ============================================
function DianCang_JH_Click(slotIndex)
	if g_currentPage == -1 then
		PushDebugMessage("未知错误 请重新打开界面")
		return
	end
	if g_currentGroupIndex < 1 then
		PushDebugMessage("未知错误 请重新打开界面")
		return
	end
	
	-- 发送激活请求到服务器
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("MonsterBookMain")
	Set_XSCRIPT_ScriptID(912217)
	Set_XSCRIPT_Parameter(0, g_currentPage)
	Set_XSCRIPT_Parameter(1, g_currentGroupIndex)
	Set_XSCRIPT_Parameter(2, slotIndex)
	Set_XSCRIPT_Parameter(3, g_currentSubPage)
	Set_XSCRIPT_Parameter(4, 1)  -- 操作类型: 1=激活
	Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
end

-- ============================================
-- 升级按钮点击处理
-- ============================================
function DianCang_SJ_Click(slotIndex)
	if g_currentPage == -1 then
		PushDebugMessage("未知错误 请重新打开界面")
		return
	end
	if g_currentGroupIndex < 1 then
		PushDebugMessage("未知错误 请重新打开界面")
		return
	end
	
	-- 发送升级请求到服务器
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("MonsterBookMain")
	Set_XSCRIPT_ScriptID(912217)
	Set_XSCRIPT_Parameter(0, g_currentPage)
	Set_XSCRIPT_Parameter(1, g_currentGroupIndex)
	Set_XSCRIPT_Parameter(2, slotIndex)
	Set_XSCRIPT_Parameter(3, g_currentSubPage)
	Set_XSCRIPT_Parameter(4, 2)  -- 操作类型: 2=升级
	Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
end


-- ============================================
-- 汇总已激活总属性并更新悬浮提示
-- ============================================
function DianCang_UpdateTotalAttrTooltip()
	-- 属性汇总表 (按属性ID累加)
	local totalAttrs = {}
	
	-- 所有页面的技能ID表
	local allSkillTables = {
		g_attrSkillIds_Page1,
		g_attrSkillIds_Page2,
		g_attrSkillIds_Page3,
		g_attrSkillIds_Page4
	}
	
	-- 属性偏移量 (每个页面的起始GroupID)
	local attrOffsets = { 0, 24, 47, 60 }
	
	-- 遍历所有页面
	for pageIndex = 1, 4 do
		local skillTable = allSkillTables[pageIndex]
		local attrOffset = attrOffsets[pageIndex]
		
		if skillTable then
			-- 遍历该页面的所有分组
			for groupIndex, skillIds in pairs(skillTable) do
				-- 遍历该分组的所有技能ID (处理分页情况)
				for subPageIdx, skillId in ipairs(skillIds) do
					-- 获取激活等级数据
					local activationLevels = DianCang_ParseActivationData(skillId)
					
					-- 计算该分组的怪物数量
					local monsterCount = GetDianCangGroupCount(pageIndex, groupIndex)
					local startMonster = (subPageIdx == 1) and 1 or 9
					local endMonster = (subPageIdx == 1) and math.min(8, monsterCount) or monsterCount
					
					-- 遍历该分组的怪物
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
	
	-- 生成悬浮提示文本
	local tooltipText = "已激活典藏增加总属性:#G"
	local hasAttr = false
	
	-- 按属性ID排序输出
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
		tooltipText = "已激活典藏增加总属性:#r#W暂无已激活属性"
	end
	
	-- 更新悬浮提示
	if DianCang_AttrText then
		DianCang_AttrText:SetToolTip(tooltipText)
	end
end