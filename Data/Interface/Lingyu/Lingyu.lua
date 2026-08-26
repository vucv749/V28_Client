--!!!reloadscript =Lingyu

local g_Lingyu_Frame_UnifiedXPosition
local g_Lingyu_Frame_UnifiedYPosition

local g_LingYuAction = {}

--统一化下页签显示隐藏 目前固定顺序 新增改序号 每个页签都需要添加
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

function Lingyu_PreLoad()
	--open or close this window
	this:RegisterEvent("TOGGLE_LINGYU_PAGE")
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	--update equip
	this:RegisterEvent("REFRESH_EQUIP", false)
	this:RegisterEvent("UNIT_LEVEL", false)

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("UPDATE_EXTERIOR_TIP")
	
	this:RegisterEvent("UPDATE_CURRENT_LINGYU_PLAN")
end

function Lingyu_OnLoad()

	-- 保存界面的默认相对位置
	g_Lingyu_Frame_UnifiedXPosition	= Lingyu_Frame:GetProperty("UnifiedXPosition")
	g_Lingyu_Frame_UnifiedYPosition	= Lingyu_Frame:GetProperty("UnifiedYPosition")
	
	g_PageButton[1] = Lingyu_SelfEquip
	g_PageButton[2] = Lingyu_SelfData
	g_PageButton[3] = Lingyu_Pet
	g_PageButton[4] = Lingyu_Lingyu
	g_PageButton[5] = Lingyu_Xiulian
	g_PageButton[6] = Lingyu_Talent	
	g_PageButton[7] = Lingyu_Lingyu
	g_PageButton[8] = Lingyu_Weapon2
	g_PageButton[9] = Lingyu_DWJinJie
	g_PageButton[10] = Lingyu_Peak
	g_PageButton[11] = Lingyu_Profile
	g_PageButton[12] = Lingyu_OtherInfo
	
	g_PageMask[1] = Lingyu_SelfEquip_Mask
	g_PageMask[2] = Lingyu_SelfData_Mask
	g_PageMask[3] = Lingyu_Pet_Mask
	g_PageMask[4] = Lingyu_Lingyu_Mask
	g_PageMask[5] = Lingyu_Xiulian_Mask
	g_PageMask[6] = Lingyu_Talent_Mask
	g_PageMask[7] = Lingyu_Lingyu_Mask
	g_PageMask[8] = Lingyu_Weapon2_Mask
	g_PageMask[9] = Lingyu_DWJinJie_Mask
	g_PageMask[10] = Lingyu_Peak_Mask
	g_PageMask[11] = Lingyu_Profile_Mask
	g_PageMask[12] = Lingyu_OtherInfo_Mask
	

	g_PageTip[1] = Lingyu_SelfEquip_tips
	g_PageTip[2] = Lingyu_SelfData_tips
	g_PageTip[3] = Lingyu_Pet_tips
	g_PageTip[4] = Lingyu_Wuhun_tips
	g_PageTip[5] = Lingyu_Xiulian_tips
	g_PageTip[6] = Lingyu_Talent_tips	
	g_PageTip[7] = Lingyu_Lingyu_tips
	g_PageTip[8] = Lingyu_Weapon2_tips
	g_PageTip[9] = Lingyu_DWJinJie_tips
	g_PageTip[10] = Lingyu_Peak_tips
	g_PageTip[11] = Lingyu_Profile_tips
	g_PageTip[12] = Lingyu_OtherInfo_tips
	

	g_LingYuAction[1] = Lingyu_Plan_Item1
	g_LingYuAction[2] = Lingyu_Plan_Item2
	g_LingYuAction[3] = Lingyu_Plan_Item3
	g_LingYuAction[4] = Lingyu_Plan_Item4
	g_LingYuAction[5] = Lingyu_Plan_Item5
	g_LingYuAction[6] = Lingyu_Plan_Item6	
end

function Lingyu_OnEvent(event)

	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end
	
	if event == "TOGGLE_LINGYU_PAGE" then
		
		if this:IsVisible() then
			this:Hide()
			return
		end
		Lingyu_ShowPage()
		Lingyu_Update()
		this:Show()
		Lingyu_UpdateRedPoint()
		return
	end
	
	if event == "REFRESH_EQUIP" and this:IsVisible() then
		Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
		Lingyu_Update()
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		-- 更新背包界面位置
		Lingyu_Frame_On_ResetPos()
	end

	if event == "UNIT_LEVEL" and this:IsVisible() then
		Lingyu_Update()	
	end
	
	if event == "UPDATE_CURRENT_LINGYU_PLAN" and this:IsVisible() then
		Lingyu_Update()	
	end
	
	if event == "UPDATE_EXTERIOR_TIP" and this:IsVisible() then
		Lingyu_UpdateRedPoint()
	end	
end

--Update
function Lingyu_Update()
	--Tab
	Lingyu_Lingyu:SetCheck(1)
	
	for i = 1, 6 do
		g_LingYuAction[i]:SetActionItem(-1)
		g_LingYuAction[i]:SetProperty("DragAcceptName", "Z"..tonumber(20 + i))
		local ActionLY = EnumAction(18 + i, "equip")
		g_LingYuAction[i]:SetActionItem(ActionLY:GetID())
	end

	DataPool:LuaFnUpdateLingYuAttrList(1)

	Lingyu_SetItemsSkill:SetActionItem(-1)
	Lingyu_SetItemsSkill:SetProperty("DraggingEnabled", "False")
	Lingyu_SetItemsSkill:Hide()

	local skill_id = DataPool:LuaFnGetLingYuSetSkillForUI(1)
	if skill_id > 0 then
		local nSumSkill = GetActionNum("skill")
		for i = 1, nSumSkill do
			local theAction = EnumAction(i - 1, "skill")
			if theAction:GetDefineID() == skill_id then
				Lingyu_SetItemsSkill:SetProperty("UseDefaultTooltip", "False")
				Lingyu_SetItemsSkill:SetActionItem(theAction:GetID())
				Lingyu_SetItemsSkill:SetProperty("DraggingEnabled", "True")
				Lingyu_SetItemsSkill:Show()
				break
			end
		end
	end
	
	Lingyu_ListContent:Clear()
	local attr_list_count = DataPool:LuaFnGetLingYuAttrCount()
	for i = 1, attr_list_count do	
		local bar = Lingyu_ListContent:AddChild("Lingyu_ListContent_CoinAItem")
		local strAttrName = DataPool:LuaFnGetLingYuAttrName(i - 1)
		local strAttrValue = DataPool:LuaFnGetLingYuAttrValueString(i - 1)
		bar:GetSubItem("Lingyu_PropertiesText"):SetText(strAttrName)
		bar:GetSubItem("Lingyu_Properties"):SetText(strAttrValue)
	end
	
	local effect_count = DataPool:LuaFnGetLingYuSetEffectCount()	
	
	if effect_count < 1 then
		Lingyu_SetItemsInfo:SetText("#{SZXT_221216_202}")
	else
		Lingyu_SetItemsInfo:SetText("")
	end
	
	if effect_count >= 1 then
		Lingyu_SetItemsInfo1:Show()
		local effect_title = DataPool:LuaFnGetLingYuSetAttrDesc(1, 0)
		Lingyu_SetItemsInfo1_1:SetText(effect_title)
		
		local effect_name = DataPool:LuaFnGetLingYuSetAttrDesc(2, 0)
		Lingyu_SetItemsInfo1_Text:SetText(effect_name)
		
		local effect_num = DataPool:LuaFnGetLingYuSetAttrDesc(3, 0)
		Lingyu_SetItemsInfo1_Text2:SetText("#cFFF263+"..effect_num)
	else
		Lingyu_SetItemsInfo1:Hide()
	end
	
	if effect_count >= 2 then
		if DataPool:LuaFnGetLingYuSetSkillForUI(1) > 0 then		
			Lingyu_SetItemsInfo2:Show()
			Lingyu_SetItemsInfo3:Hide()
			local effect_title = DataPool:LuaFnGetLingYuSetAttrDesc(1, 1)
			Lingyu_SetItemsInfo2_1:SetText(effect_title)
			
			local effect_name = DataPool:LuaFnGetLingYuSetAttrDesc(2, 1)
			Lingyu_SetItemsInfo2_Text:SetText(effect_name)
			
			local effect_num = DataPool:LuaFnGetLingYuSetAttrDesc(3, 1)
			Lingyu_SetItemsInfo2_Text2:SetText("#cFFF263"..effect_num)
		else
			Lingyu_SetItemsInfo2:Hide()
			Lingyu_SetItemsInfo3:Show()
			local effect_title = DataPool:LuaFnGetLingYuSetAttrDesc(1, 1)
			Lingyu_SetItemsInfo3_1:SetText(effect_title)
			
			local effect_name = DataPool:LuaFnGetLingYuSetAttrDesc(2, 1)
			Lingyu_SetItemsInfo3_Text:SetText(effect_name)
			
			local effect_num = DataPool:LuaFnGetLingYuSetAttrDesc(3, 1)
			Lingyu_SetItemsInfo3_Text2:SetText("#cFFF263+"..effect_num)
		end
	else
		Lingyu_SetItemsInfo2:Hide()
		Lingyu_SetItemsInfo3:Hide()
	end

end

function Lingyu_Equip_Clicked(pos, buttonIn)
	if g_LingYuAction[pos] == nil then
		return
	end
	
	local button = tonumber(buttonIn)
	if button == 1 then
		g_LingYuAction[pos]:DoAction()	
	else
		g_LingYuAction[pos]:DoSubAction()
	end

end

function Lingyu_OnShown()
	local selfUnionPos = Variable:GetVariable("SelfUnionPos")
	if selfUnionPos ~= nil then
		Lingyu_Frame:SetProperty("UnifiedPosition", selfUnionPos)
	end
end

function Lingyu_OnHiden()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
	
	Lingyu_ListContent:Clear()
end

--player's equip
function Lingyu_Page_SelfEquip()
	Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
	OpenEquip(1)
end

--player's info
function Lingyu_Page_SelfData()
	Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPrivatePage("self")
end

--player's pet
function Lingyu_Page_Pet()
	Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePetPage()
end

function Lingyu_Page_Wuhun()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		SelfEquip_Wuhun : SetCheck(0)
		SelfEquip_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1);	
	ToggleWuhunPage();
end

--xiu lian
function Lingyu_Page_Xiulian()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		return
	end
	
    local nLevel = Player:GetData("LEVEL")
	if nLevel >= 70 then
		Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
		XiuLianPage()
	else
	    Lingyu_Xiulian:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    Lingyu_ClearPage()
	end
end

function Lingyu_Page_Talent()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
		ToggleTalentPage()
	else
		Lingyu_Talent:SetCheck(0)
		Lingyu_ClearPage()
	end
end

--切换个人展示界面
function Lingyu_Page_Profile()
	Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1);
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
end

--player's other info
function Lingyu_Page_OtherInfo()
	Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
	OtherInfoPage()
end

function Lingyu_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		Lingyu_Weapon2:SetCheck(0)
		Lingyu_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function Lingyu_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		Lingyu_DWJinJie:SetCheck(0)
		Lingyu_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Lingyu_Frame_On_ResetPos()
	Lingyu_Frame:SetProperty("UnifiedXPosition", g_Lingyu_Frame_UnifiedXPosition)
	Lingyu_Frame:SetProperty("UnifiedYPosition", g_Lingyu_Frame_UnifiedYPosition)
end

function Lingyu_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"))
	Lingyu_ClearPage()
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
		if Lingyu_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if Lingyu_IsPageEnable(i) == 1 then
				g_PageButton[g_PageCount]:Enable()
				g_PageMask[g_PageCount]:Hide()
			else
				g_PageButton[g_PageCount]:Disable()
				g_PageMask[g_PageCount]:Show()
				g_PageMask[g_PageCount]:SetToolTip(g_Page[i].Tip)
			end
		end
	end
end

function Lingyu_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1)
	idx = g_PageOrder[idx]
	if idx == 1 then--装备
		Lingyu_Page_SelfEquip()
	elseif idx == 2 then--资料
		Lingyu_Page_SelfData()
	elseif idx == 3 then--珍兽
		Lingyu_Page_Pet()
	elseif idx == 4 then--武魂
		Lingyu_Page_Wuhun()
	elseif idx == 5 then--修炼
		Lingyu_Page_Xiulian()
	elseif idx == 6 then--武道
		Lingyu_Page_Talent()
	elseif idx == 7 then--灵玉
		Lingyu_ClearPage()
	elseif idx == 8 then--神兵
		Lingyu_Page_ShenBing()
	elseif idx == 9 then--雕文进阶
		Lingyu_Page_DWJinJie()
	elseif idx == 10 then--巅峰 
		Lingyu_Page_Peak()
	elseif idx == 11 then--个人
		Lingyu_Page_Profile()
	elseif idx == 12 then--其他
		Lingyu_Page_OtherInfo()
	end
end

function Lingyu_CheckPage(idx)
	if idx == 1 then--装备
		return 1
	elseif idx == 2 then--资料
		return 1
	elseif idx == 3 then--珍兽
		return 1
	elseif idx == 4 then--武魂
		return 1
	elseif idx == 5 then--修炼
		return 1
	elseif idx == 6 then--武道
		return DataPool:Lua_CheckIsShowTalent()
	elseif idx == 7 then--灵玉
		return 1
	elseif idx == 8 then--神兵
		return 1
	elseif idx == 9 then--雕文进阶
		return 1
	elseif idx == 10 then--巅峰
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--个人
		local my_level = Player:GetData("LEVEL")
		if my_level >= 15 then
			return 1
		end
	elseif idx == 12 then--其他
		return 1
	end
	return 0
end

function Lingyu_IsPageEnable(idx)
	if idx == 1 then--装备
		return 1
	elseif idx == 2 then--资料
		return 1
	elseif idx == 3 then--珍兽
		return 1
	elseif idx == 4 then--武魂
		return 1
	elseif idx == 5 then--修炼
		return 1
	elseif idx == 6 then--武道
		return 1
	elseif idx == 7 then--灵玉
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 8 then--神兵
		local my_level = Player:GetData("LEVEL")
		if my_level >= 65 then
			return 1
		end
	elseif idx == 9 then--雕文进阶
		return 1
	elseif idx == 10 then--巅峰	
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--个人
		return 1
	elseif idx == 12 then--其他
		return 1
	end
	return 0
end

function Lingyu_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--更新分页红点
function Lingyu_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end
function Lingyu_Page_Peak()
	Variable:SetVariable("SelfUnionPos", Lingyu_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	this:Hide()
end