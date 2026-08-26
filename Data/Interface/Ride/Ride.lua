--!!!reloadscript =Ride
local g_Ride_Frame_UnifiedXPosition
local g_Ride_Frame_UnifiedYPosition

-------------------------------------------
--统一化下页签显示隐藏 目前固定顺序 新增改序号 每个页签都需要添加
local g_Page = {
	[1] = { Text = "#{INTERFACE_XML_877}",    NeedCheck = 0,},
	[2] = { Text = "#{INTERFACE_XML_882}",    NeedCheck = 0,},
	[3] = { Text = "#{INTERFACE_XML_854}",    NeedCheck = 0,},
	[4] = { Text = "#{WH_xml_XX(95)}", 	      NeedCheck = 0,},
	[5] = { Text = "#{XL_XML_35}",            NeedCheck = 0,},
	[6] = { Text = "#{TalentMP_20210804_57}", NeedCheck = 1,},
	[7] = { Text = "#{INTERFACE_XML_497}",    NeedCheck = 0,},
	[8] = { Text = "#{INTERFACE_XML_496}",    NeedCheck = 0,},
}
local g_PageButton = {}
local g_PageTip = {}
local g_MaxPage = 8
local g_PageCount = 8
local g_PageOrder = {}

local g_ExteriorType = 3
local g_InitList = 0
local g_BarList = {}

local g_MaxBarNum = 0

local g_TargetExteriorIndex = 0		--???????,?1??
local g_TargetExteriorID = 0		--?????ID

local g_CurSelExteriorID = 0			--???????ID,?1??

local g_ViewMode = 0

local g_CameraHeight = 1     --?????
local g_CameraDistance = 2   --?????
local g_CameraPitch = 3      --?????

local g_OriMountId = -1

function Ride_PreLoad()
	
	-- 打开界面
	this:RegisterEvent("OPEN_EXTERIOR")
	
	this:RegisterEvent("ADD_EXTERIOR")
	this:RegisterEvent("UPDATE_EXTERIOR")
	this:RegisterEvent("EXTERIOR_OUTTIME")	
	this:RegisterEvent("EXTERIOR_ID_CHANGED")
	this:RegisterEvent("REMOVE_EXTERIOR")
	this:RegisterEvent("PLAYER_MOUNT_ID")
	this:RegisterEvent("STOP_FITTING_EXTERIOR_RIDE")
	
	--离开场景，自动关睜
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	--玩家更换骑乘
	this:RegisterEvent("PLAYER_UPDATE_RIDE")
	
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function Ride_OnLoad()
	
	-- 保存界面的默认相对位置
	g_Ride_Frame_UnifiedXPosition	= Ride_Frame : GetProperty("UnifiedXPosition");
	g_Ride_Frame_UnifiedYPosition	= Ride_Frame : GetProperty("UnifiedYPosition");

	g_PageButton[1] = Ride_SelfEquip
	g_PageButton[2] = Ride_SelfData
	g_PageButton[3] = Ride_Pet
	g_PageButton[4] = Ride_Wuhun
	g_PageButton[5] = Ride_Xiulian
	g_PageButton[6] = Ride_Talent
	g_PageButton[7] = Ride_Ride
	g_PageButton[8] = Ride_OtherInfo
	
	g_PageTip[1] = Ride_SelfEquip_tips
	g_PageTip[2] = Ride_SelfData_tips
	g_PageTip[3] = Ride_Pet_tips
	g_PageTip[4] = Ride_Wuhun_tips
	g_PageTip[5] = Ride_Xiulian_tips
	g_PageTip[6] = Ride_Talent_tips
	g_PageTip[7] = Ride_Ride_tips
	g_PageTip[8] = Ride_OtherInfo_tips
end

-- OnEvent
function Ride_OnEvent(event)
	if event == "OPEN_EXTERIOR" and tonumber(arg0) == g_ExteriorType then
		if this:IsVisible() then			
			this:Hide()
			return
		end

		g_OriMountId = GetMountID()
		this:Show()
		Ride_Update()
		Ride_ShowPage()
			
		local isopen6 = T300Func:IsNoDifOpen(6)
		local isopen5 = T300Func:IsNoDifOpen(5)
		
		if isopen5 == 1 then
			--Ride_Wuhun:Disable()
		else
			Ride_Wuhun:Enable()
		end
		
		if isopen6 == 1 then
			--Ride_Xiulian:Disable()
		else
			Ride_Xiulian:Enable()
		end
	end
	
	if event == "PLAYER_MOUNT_ID" then
		g_OriMountId = GetMountID()
		return
	end
	
	if event == "STOP_FITTING_EXTERIOR_RIDE" and this:IsVisible() then
		Exterior:LuaFnSetMountId(g_OriMountId)
		Ride_Update()
		return
	end
			
	if event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if tonumber(arg0) == g_ExteriorType then
			Ride_UpdateList()
			Ride_UpdateObj()
			Ride_UpdateRedPoint()
			local max_speed = Exterior:LuaFnGetExteriorRideMaxSpeed()
			local strTemp = ScriptGlobal_Format("#{ZJGN_211105_02}", tostring(max_speed))
			Ride_Speed_Text:SetText(strTemp)
		end
		return
	end
	
	if event == "REMOVE_EXTERIOR" then
		if tonumber(arg0) == g_ExteriorType then
			Ride_UpdateList()
			Ride_UpdateObj()
			
			local max_speed = Exterior:LuaFnGetExteriorRideMaxSpeed()
			local strTemp = ScriptGlobal_Format("#{ZJGN_211105_02}", tostring(max_speed))
			Ride_Speed_Text:SetText(strTemp)
		end
		return
	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end
	
	if "REFRESH_EQUIP" == event then 
		if this:IsVisible() then
			Ride_Update()
			return
		end
	end
	
	if "PLAYER_UPDATE_RIDE" == event then
		if this:IsVisible() then
			Ride_Update()
		end
	end
	
	if "REFRESH_EQUIP" == event then 
		if this:IsVisible() then
		--	Ride_Object_Update()
		end
	end
	
	-- 游戏窗口尺寸发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Ride_Frame_On_ResetPos()
	end

	end

function Ride_Frame_On_ResetPos()
	Ride_Frame:SetProperty("UnifiedXPosition", g_Ride_Frame_UnifiedXPosition)
	Ride_Frame:SetProperty("UnifiedYPosition", g_Ride_Frame_UnifiedYPosition)
end

function Ride_InitList()
	
	if g_InitList == 0 then		
		g_MaxBarNum = Exterior:LuaFnGetExteriorMaxCount(g_ExteriorType)
		
		for i = 1, g_MaxBarNum do
			local bar = Ride_SuperList:AddChild("Ride_SuperListItem")
			bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("Ride_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("Ride_List_ItemClicked(%d)", i))
			bar:GetSubItem("Ride_SuperListItemAction"):SetEvent("MouseMove", string.format("Ride_List_ItemMouseMove(%d)", i))
			bar:GetSubItem("Ride_SuperListItemAction"):SetProperty("Empty", "False")
			bar:GetSubItem("Ride_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
			bar:GetSubItem("Ride_SuperListItemAction"):SetEvent("MouseRClick", string.format("Ride_List_ItemRClicked(%d)", i))
		end
		g_InitList = 1
	end
end

function Ride_PrepareForShow()
	
	Ride_CleanUp()
	Ride_InitList()
	
	local selfUnionPos = Variable:GetVariable("SelfUnionPos")
	if selfUnionPos ~= nil then
		Ride_Frame:SetProperty("UnifiedPosition", selfUnionPos)
	end

end

function Ride_Update()
	
	Ride_InitList()	
	
	g_CurSelExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
	
	Ride_UpdateList()
	
	Ride_UpdateObj()
	
	Ride_RemoveTip(g_CurSelExteriorID)
	
	Ride_UpdateRedPoint()
	
	local max_speed = Exterior:LuaFnGetExteriorRideMaxSpeed()
	local strTemp = ScriptGlobal_Format("#{ZJGN_211105_02}", tostring(max_speed))
	Ride_Speed_Text:SetText(strTemp)

end
	
--列表
function Ride_UpdateList()
	
	Exterior:LuaFnInitExteriorList(g_ExteriorType)
	local count = Exterior:LuaFnGetExteriorListCount(g_ExteriorType, 0)

	for i = 1, g_MaxBarNum do	
		Ride_SetItem(i, count)
	end

	if g_NeedChangeScrollSize == 1 then
		Ride_SuperList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end
	
	if g_TargetExteriorIndex ~= 0 then
		Ride_SuperList:SetScrollPosition4Index(g_TargetExteriorIndex - 1)
		g_TargetExteriorID = 0
		g_TargetExteriorIndex = 0
	else
		Ride_SuperList:SetScrollPosition4Index(0)
	end

end

function Ride_SetItem(index, max_count)
	
	if g_BarList[index] == nil then
		return
	end

	if index > max_count then
		g_BarList[index]:Hide()
		return
		end
	
	local bar = g_BarList[index]
	bar:Show()
	
	local nMyMenpai = Player:GetData("MEMPAI")
	local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, index - 1)
	local strIcon = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Icon")
	local strName = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Name")
	local nQuality = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Quality")
	local strImage = GetIconFullName(strIcon)
	local nLuxury = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Luxury")
	local nMenpai = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Menpai")
	
	local ctrlAction = bar:GetSubItem("Ride_SuperListItemAction")
	if ctrlAction ~= nil then
	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		
		local strTemp = Exterior:LuaFnGetRideToolTip(nExteriorID)
		ctrlAction:SetToolTip(strTemp)
		
		if g_CurSelExteriorID == nExteriorID then
			ctrlAction:SetPushed(1)
			bar:GetSubItem("Ride_SuperListItemActionTry"):Show()
			if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
				bar:GetSubItem("Ride_SuperListItemActionTry"):Hide()
	end
		else
			ctrlAction:SetPushed(0)
			bar:GetSubItem("Ride_SuperListItemActionTry"):Hide()
		end

		if g_TargetExteriorID == nExteriorID then
			g_TargetExteriorIndex = index
		end

	end

	--非本门派蒙红 
	if nMyMenpai == nMenpai or nMenpai == -1 then			
		bar:GetSubItem("Ride_SuperListItemActionMark"):Hide()
	else
		bar:GetSubItem("Ride_SuperListItemActionMark"):Show()
	end	

	--解锁&限时标志
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) == 1 then
		bar:GetSubItem("Ride_SuperListItemActionLock"):Hide()
		local nLeftTime = Exterior:LuaFnGetExteriorLeftTime(g_ExteriorType, nExteriorID)
		if nLeftTime and nLeftTime < 0 then
			bar:GetSubItem("Ride_SuperListItemActionTime"):Hide()
		elseif nLeftTime and nLeftTime == 0 then
			bar:GetSubItem("Ride_SuperListItemActionTime"):Show()
		elseif nLeftTime and nLeftTime > 0 then
			bar:GetSubItem("Ride_SuperListItemActionTime"):Show()
		end
	else
		bar:GetSubItem("Ride_SuperListItemActionTime"):Hide()
		bar:GetSubItem("Ride_SuperListItemActionLock"):Show()
	end

	--使用中
	if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == nExteriorID then
		bar:GetSubItem("Ride_SuperListItemActionDef"):Show()
	else
		bar:GetSubItem("Ride_SuperListItemActionDef"):Hide()
	end

	--红点
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		bar:GetSubItem("Ride_SuperListItemActionTip"):Show()
	else
		bar:GetSubItem("Ride_SuperListItemActionTip"):Hide()
	end

	--奢侈品
	if nLuxury == 1 or nLuxury == 2 then
		bar:GetSubItem("Ride_SuperListItemActionLuxury"):Show()
	else
		bar:GetSubItem("Ride_SuperListItemActionLuxury"):Hide()
	end

end

function Ride_UpdateObj()
	
	Ride_FakeObject:SetFakeObject("")
	if g_CurSelExteriorID ~= nil and g_CurSelExteriorID > 0 then				

		local nMountId = Exterior:LuaFnGetExteriorRideInfo(g_CurSelExteriorID, "MountId")
		Exterior:LuaFnUpdateExteriorRideAvatarMount(nMountId)

		if g_ViewMode == 0 then
			Ride_FakeObject:SetFakeObject("My_Horse")
			local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId, 1)
			FakeObj_SetCamera("My_Horse", g_CameraHeight, fHeight)
			FakeObj_SetCamera("My_Horse", g_CameraDistance, fDistance)
		else
			Ride_FakeObject:SetFakeObject("ExteriorRideAvatar")
			local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId, 0)
			FakeObj_SetCamera("ExteriorRideAvatar", g_CameraHeight, fHeight)
			FakeObj_SetCamera("ExteriorRideAvatar", g_CameraDistance, fDistance)
		end
	end
end

function Ride_SwithViewMode()
	if g_ViewMode == 0 then
		g_ViewMode = 1
	else
		g_ViewMode = 0
	end	
	Ride_UpdateObj()
end

function Ride_OnHidden()
	Exterior:LuaFnSetMountId(g_OriMountId)
	Ride_CleanUp()
end

function Ride_CleanUp()
	Ride_FakeObject:SetFakeObject("")
	g_CurSelExteriorID = 0
	g_ViewMode = 0
	SetDefaultMouse()
	
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function Ride_MakeHyperlink(nExteriorID)
	local ret = Exterior:LuaFnExteriorRideItemClick(nExteriorID)
	if ret == 2 then
		PushDebugMessage("#{ZJGN_211105_41}")
	end
	return ret
end

function Ride_List_ItemClicked(nIndex)

	local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	
	if Exterior:LuaFnFittingExteriorRide(nExteriorID) == 1 then
	
	else
		local ret = Ride_MakeHyperlink(nExteriorID)
		if ret == 1 or ret == 2 then
			return
		end
	end

	if g_CurSelExteriorID ~= nExteriorID then
	
		g_CurSelExteriorID = nExteriorID		
		
		Ride_SetItemSelected(nIndex)
		
		Ride_UpdateObj()

		Ride_RemoveTip(g_CurSelExteriorID)
		Ride_UpdateRedPoint()
	else
	--	local defExteriorID = Exterior:LuaFnGetExteriorInUse(g_ExteriorType)
	--	Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", defExteriorID)
	--	NewExterior_Ride_Show()
	end
end

function Ride_List_ItemRClicked(nIndex)

	local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	

	local iReverseItem = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "ReverseItem")
	
	if iReverseItem == nil or iReverseItem == 0 then
		Ride_Wuhun : SetCheck(0)
		Ride_ClearPage()
		return
	end
	
	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, nExteriorID) ~= 1 then
		PushDebugMessage("#{ZJGN_211105_64}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ReverseExteriorRideToItem")
		Set_XSCRIPT_ScriptID(999900)
		Set_XSCRIPT_Parameter(0, nExteriorID)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Ride_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("Ride_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("Ride_SuperListItemActionTry"):Show()
					if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("Ride_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("Ride_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function Ride_List_ItemMouseMove(nIndex)

end

-- 选装玩家模型（向左)
function Ride_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if mouse_button == "LeftButton" then
		--向左旋转开始
		if start == 1 then
			Ride_FakeObject:RotateBegin(-0.3)
		--向左旋转结束
		else
			Ride_FakeObject:RotateEnd()
		end
	end
end

-- 选装玩家模型（向右)
function Ride_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if mouse_button == "LeftButton" then
		--向右旋转开始
		if start == 1 then
			Ride_FakeObject:RotateBegin(0.3)
		--向右旋转结束
		else
			Ride_FakeObject:RotateEnd()
		end
	end
end

function Ride_ChangeExterior()
	
	if g_CurSelExteriorID == 0 then
		Ride_Xiulian : SetCheck(0)
		Ride_ClearPage()
		return
	end
	
	local iLevel = Exterior:LuaFnGetExteriorRideInfo(g_CurSelExteriorID, "Level")
	local iMenpai = Exterior:LuaFnGetExteriorRideInfo(g_CurSelExteriorID, "Menpai")
	local iPlayerLevel = Player:GetData("LEVEL")
	local iPlayerMenpai = Player:GetData("MEMPAI")
	
	if iPlayerLevel < iLevel then
		PushDebugMessage("#{ZJGN_211105_10}")
		return
	end
	
	if iMenpai ~= -1 and iPlayerMenpai ~= iMenpai then
		PushDebugMessage("#{ZJGN_211105_11}")
		return
	end

	if Exterior:LuaFnIsHaveExterior(g_ExteriorType, g_CurSelExteriorID) ~= 1 then
		PushDebugMessage("#{ZJGN_211105_12}")
		return
	end
	
	if Exterior:LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
		PushDebugMessage("#{ZJGN_211105_13}")
		return
	end
	
	Exterior:LuaFnSetExteriorInUse(g_ExteriorType, g_CurSelExteriorID, 0)
	
end

function Ride_FittingClick()

	if Lua_IsInBianShen() == 1 then
		PushDebugMessage("#{ZJGN_211105_06}")
		return
	end

	if IsInStall() == 1 then
		PushDebugMessage("#{ZJGN_211105_07}")
		return
	end	

	if IsIdleLogic() ~= 1 and IsMoveLogic() ~= 1 then
		SetNotifyTip("#{ZJGN_211105_08}")
		return
	end

	MouseCmd_ShopFittingSet()
	PushDebugMessage("#{ZJGN_211105_09}")
end

function Ride_RemoveTip(nExteriorID)
	local nTip = Exterior:LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		Exterior:LuaFnRemoveExteriorTip(g_ExteriorType, nExteriorID)
		for i = 1, g_MaxBarNum do
			if g_BarList[i] then
				local nID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, i - 1)
				if Exterior:LuaFnGetExteriorTip(g_ExteriorType, nID) == 1 then
					g_BarList[i]:GetSubItem("Ride_SuperListItemActionTip"):Show()
				else
					g_BarList[i]:GetSubItem("Ride_SuperListItemActionTip"):Hide()
				end
			end
		end
	--	NewExterior_Ride_UpdateCheckButton()
	end
end

--更新分页红点
function Ride_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end

	for i = 1, g_PageCount do
		if g_PageOrder[i] == 7 then
			if Exterior:LuaFnIsHaveExteriorShowTip(g_ExteriorType) == 1 then
				g_PageTip[i]:Show()
			else
				g_PageTip[i]:Hide()
			end
		end
	end
end

function Ride_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"))
	Ride_ClearPage()
	
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
		if Ride_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
		end
	end
end

function Ride_CheckPage(idx)
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
	end
	return 0
end

function Ride_OnPageClicked(btn_index)
	Variable:SetVariable("PageNumber", tostring(btn_index), 1)
	local page_index = g_PageOrder[btn_index]
	if page_index == 1 then--??
		Ride_SelfEquip_Page_Switch()
	elseif page_index == 2 then--??
		Ride_SelfData_Switch()
	elseif page_index == 3 then--??
		Ride_Pet_Switch()
	elseif page_index == 4 then--??
		Ride_Wuhun_Switch()
	elseif page_index == 5 then--??
		Ride_Xiulian_Switch()
	elseif page_index == 6 then--??
		Ride_Talent_Switch()
	elseif page_index == 7 then--??
		Ride_Ride_Page_Switch(btn_index)
	elseif page_index == 8 then--??
		Ride_Other_Info_Page_Switch()
	end
end
--页签：装备
function Ride_SelfEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Ride_Frame:GetProperty("UnifiedPosition"), 1)
	OpenEquip(1)
end

--页签：资料
function Ride_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", Ride_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPrivatePage("self")
end

--页签：犱兽
function Ride_Pet_Switch()
	Variable:SetVariable("SelfUnionPos", Ride_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePetPage()
end

--页签：武魂
function Ride_Wuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		return
	end
	Variable:SetVariable("SelfUnionPos", Ride_Frame:GetProperty("UnifiedPosition"), 1)
	ToggleWuhunPage()
end

--页签：修炼
function Ride_Xiulian_Switch()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		return
	end
	
    local nLevel = Player:GetData("LEVEL")
	if nLevel >= 70 then
		Variable:SetVariable("SelfUnionPos", Ride_Frame:GetProperty("UnifiedPosition"), 1)
		XiuLianPage()
	else
	    Ride_Xiulian:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    Ride_ClearPage()
	end
end

--页签：武道
function Ride_Talent_Switch()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", Ride_Frame:GetProperty("UnifiedPosition"), 1)
		ToggleTalentPage()
	else
		Ride_Talent:SetCheck(0)
		Ride_ClearPage()
	end

end

--页签：骑乘
function Ride_Ride_Page_Switch(btn_index)
	Ride_ClearPage()
	if g_PageButton[btn_index] ~= nil then
		g_PageButton[btn_index]:SetCheck(1)
	end
end

--页签：其他
function Ride_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Ride_Frame:GetProperty("UnifiedPosition"), 1)
	OtherInfoPage()
end

function Ride_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end





