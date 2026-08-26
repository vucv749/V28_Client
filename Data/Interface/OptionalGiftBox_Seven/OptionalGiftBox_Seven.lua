--OptionalGiftBox_Seven界面
--uicommandindex
local OptionalGiftBox_Seven_g_OpenUi = 89027601
local OptionalGiftBox_Seven_g_CloseUi = 89027602
--变量
local g_OptionalGiftBox_Seven_Frame_UnifiedXPosition;
local g_OptionalGiftBox_Seven_Frame_UnifiedYPosition;
local g_OptionalGiftBox_Seven_CurBagPos = -1 --神兵自选匣在玩家背包中的位置
local g_OptionalGiftBox_Seven_CurSelIndex = -1 --当前选中几个item
local g_OptionalGiftBox_Seven_CurLiBaoItemIndex = -1 --使用的礼包

local g_OptionalGiftBox_Seven_MainScript = 890276
local g_OptionalGiftBox_Seven_CurNeedNum = 1 --需要选择一个神兵
local g_OptionalGiftBox_Seven_TotalNum = 7
--控件表
local g_OptionalGiftBox_Seven_UI_ActionItem = {}
local g_OptionalGiftBox_Seven_UI_ActionChosenMask = {}
local g_OptionalGiftBox_Seven_UI_ItemName = {}
--字典 以及 物品id
local g_OptionalGiftBox_Seven_Text = {
	[1] = "#{SQYD_230802_68}",
	[2] = "#{SQYD_230802_69}",
	[3] = "#{SQYD_230802_70}",
	[4] = "#{SQYD_230802_71}",
	[5] = "#{SQYD_230802_72}",
	[6] = "#{SQYD_230802_73}",
	[7] = "#{SQYD_230802_74}",
}
local g_OptionalGiftBox_Seven_ItemId ={
	38002987,
	38002985,
	38002986,
}
local g_OptionalGiftBox_Seven_ItemIdNum = 3
local g_OptionalGiftBox_Seven_ItemIdAndWeapon = {
	--4
	[38002987] = {
		[1] = { id = 10158007, num = 1, }, --箭
		[2] = { id = 10158008, num = 1, }, --弓
		[3] = { id = 10158009, num = 1, }, --枪
		[4] = { id = 10158010, num = 1, }, --剑
		[5] = { id = 10158011, num = 1, }, --刀
		[6] = { id = 10158012, num = 1, }, --锤
		[7] = { id = 10158013, num = 1, }, --匕
	},
	--5星
	[38002985] = {
		[1] = { id = 10158014, num = 1, }, --箭
		[2] = { id = 10158015, num = 1, }, --弓
		[3] = { id = 10158016, num = 1, }, --枪
		[4] = { id = 10158017, num = 1, }, --剑
		[5] = { id = 10158018, num = 1, }, --刀
		[6] = { id = 10158019, num = 1, }, --锤
		[7] = { id = 10158020, num = 1, }, --匕
	},
	--6星
	[38002986] = {
		[1] = { id = 10158021, num = 1, }, --箭
		[2] = { id = 10158022, num = 1, }, --弓
		[3] = { id = 10158023, num = 1, }, --枪
		[4] = { id = 10158024, num = 1, }, --剑
		[5] = { id = 10158025, num = 1, }, --刀
		[6] = { id = 10158026, num = 1, }, --锤
		[7] = { id = 10158027, num = 1, }, --匕
	},
}
local g_OptionalGiftBox_Seven_ItemIdAndTitle = {
	[38002987] = "#{SQYD_230802_66}",
	--4星
	[38002985] = "#{SQYD_230802_134}",
	--5星
	[38002986] = "#{SQYD_230802_135}",
}
local g_OptionalGiftBox_Seven_ItemIdAndInfo = {
	[38002987] = "#{SQYD_230802_67}",
	--4星
	[38002985] = "#{SQYD_230802_136}",
	--5星
	[38002986] = "#{SQYD_230802_137}",
}

--===============================================
-- PreLoad()
--===============================================
function OptionalGiftBox_Seven_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

--===============================================
-- OnLoad()
--===============================================
function OptionalGiftBox_Seven_OnLoad()
	-- 保存界面的默认相对位置
	g_OptionalGiftBox_Seven_Frame_UnifiedXPosition = OptionalGiftBox_Seven_Frame_BK:GetProperty("UnifiedXPosition");
	g_OptionalGiftBox_Seven_Frame_UnifiedYPosition = OptionalGiftBox_Seven_Frame_BK:GetProperty("UnifiedYPosition");
	--脚本变量关联界面控件 actionItem部分
	g_OptionalGiftBox_Seven_UI_ActionItem[1] = OptionalGiftBox_Seven_Item1
	g_OptionalGiftBox_Seven_UI_ActionItem[2] = OptionalGiftBox_Seven_Item2
	g_OptionalGiftBox_Seven_UI_ActionItem[3] = OptionalGiftBox_Seven_Item3
	g_OptionalGiftBox_Seven_UI_ActionItem[4] = OptionalGiftBox_Seven_Item4
	g_OptionalGiftBox_Seven_UI_ActionItem[5] = OptionalGiftBox_Seven_Item5
	g_OptionalGiftBox_Seven_UI_ActionItem[6] = OptionalGiftBox_Seven_Item6
	g_OptionalGiftBox_Seven_UI_ActionItem[7] = OptionalGiftBox_Seven_Item7
	--ActionChosenMask部分
	g_OptionalGiftBox_Seven_UI_ActionChosenMask[1] = OptionalGiftBox_Seven_Item1_Mask
	g_OptionalGiftBox_Seven_UI_ActionChosenMask[2] = OptionalGiftBox_Seven_Item2_Mask
	g_OptionalGiftBox_Seven_UI_ActionChosenMask[3] = OptionalGiftBox_Seven_Item3_Mask
	g_OptionalGiftBox_Seven_UI_ActionChosenMask[4] = OptionalGiftBox_Seven_Item4_Mask
	g_OptionalGiftBox_Seven_UI_ActionChosenMask[5] = OptionalGiftBox_Seven_Item5_Mask
	g_OptionalGiftBox_Seven_UI_ActionChosenMask[6] = OptionalGiftBox_Seven_Item6_Mask
	g_OptionalGiftBox_Seven_UI_ActionChosenMask[7] = OptionalGiftBox_Seven_Item7_Mask
	--ItemName部分
	g_OptionalGiftBox_Seven_UI_ItemName[1] = OptionalGiftBox_Seven_Item1_Name
	g_OptionalGiftBox_Seven_UI_ItemName[2] = OptionalGiftBox_Seven_Item2_Name
	g_OptionalGiftBox_Seven_UI_ItemName[3] = OptionalGiftBox_Seven_Item3_Name
	g_OptionalGiftBox_Seven_UI_ItemName[4] = OptionalGiftBox_Seven_Item4_Name
	g_OptionalGiftBox_Seven_UI_ItemName[5] = OptionalGiftBox_Seven_Item5_Name
	g_OptionalGiftBox_Seven_UI_ItemName[6] = OptionalGiftBox_Seven_Item6_Name
	g_OptionalGiftBox_Seven_UI_ItemName[7] = OptionalGiftBox_Seven_Item7_Name
end

--===============================================
-- OnEvent()
--===============================================
function OptionalGiftBox_Seven_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == OptionalGiftBox_Seven_g_OpenUi) then
		OptionalGiftBox_Seven_CleanUp()
		g_OptionalGiftBox_Seven_CurBagPos = Get_XParam_INT(0)
		g_OptionalGiftBox_Seven_CurLiBaoItemIndex = Get_XParam_INT(1)
		LifeAbility:Lock_Packet_Item(g_OptionalGiftBox_Seven_CurBagPos, 1)
		OptionalGiftBox_Seven_Show();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == OptionalGiftBox_Seven_g_CloseUi) then
		OptionalGiftBox_Seven_OnHidden();
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		OptionalGiftBox_Seven_OnHidden()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		OptionalGiftBox_Seven_UpdateUIPos()
	elseif (event == "ADJEST_UI_POS") then
		OptionalGiftBox_Seven_UpdateUIPos()
	end
end

--开启界面
function OptionalGiftBox_Seven_Show()
	--打开界面前做一些安全检查
	local isSafe = 0
	for i = 1, g_OptionalGiftBox_Seven_ItemIdNum do
		if g_OptionalGiftBox_Seven_ItemId[i] == g_OptionalGiftBox_Seven_CurLiBaoItemIndex then
			isSafe = 1
			break
		end
	end
	if isSafe == 0 then
		OptionalGiftBox_Seven_OnHidden()--安全检查不通过就关界面了
		return 0
	end
	OptionalGiftBox_Seven_Update()
	this:Show()
end
--界面信息填充
function OptionalGiftBox_Seven_Update()
	for i = 1, g_OptionalGiftBox_Seven_TotalNum do
		local itemAction = DataPool:CreateBindActionItemForShow(
		g_OptionalGiftBox_Seven_ItemIdAndWeapon[g_OptionalGiftBox_Seven_CurLiBaoItemIndex][i].id,
		g_OptionalGiftBox_Seven_ItemIdAndWeapon[g_OptionalGiftBox_Seven_CurLiBaoItemIndex][i].num
		)--不绑定 CreateActionItemForShow
		if itemAction:GetID() ~= 0 then
			g_OptionalGiftBox_Seven_UI_ActionItem[i]:SetActionItem(itemAction:GetID())
		end
		g_OptionalGiftBox_Seven_UI_ActionItem[i]:SetPushed(0)
		g_OptionalGiftBox_Seven_UI_ItemName[i]:SetText(g_OptionalGiftBox_Seven_Text[i])
		g_OptionalGiftBox_Seven_UI_ActionChosenMask[i]:Hide()
	end
	OptionalGiftBox_Seven_DragTitle:SetText(g_OptionalGiftBox_Seven_ItemIdAndTitle[g_OptionalGiftBox_Seven_CurLiBaoItemIndex]);
	OptionalGiftBox_Seven_Info:SetText(g_OptionalGiftBox_Seven_ItemIdAndInfo[g_OptionalGiftBox_Seven_CurLiBaoItemIndex])
end
--关闭界面
function OptionalGiftBox_Seven_OnHidden()
	OptionalGiftBox_Seven_CleanUp()
	this:Hide()
end

--清空数据
function OptionalGiftBox_Seven_CleanUp()
	for i = 1, g_OptionalGiftBox_Seven_TotalNum do	
		g_OptionalGiftBox_Seven_UI_ActionItem[i]:SetActionItem(-1)
		g_OptionalGiftBox_Seven_UI_ItemName[i]:SetText("")
		g_OptionalGiftBox_Seven_UI_ActionChosenMask[i]:Hide()
	end
	OptionalGiftBox_Seven_DragTitle:SetText(" ");
	--开界面的时候会锁住物品 所以关闭界面和初始化的时候要解锁
	if g_OptionalGiftBox_Seven_CurBagPos ~= -1 then
		LifeAbility:Lock_Packet_Item(g_OptionalGiftBox_Seven_CurBagPos, 0)
	end
	--其他变量初始化
	g_OptionalGiftBox_Seven_CurBagPos = -1 --神兵自选匣在玩家背包中的位置
	g_OptionalGiftBox_Seven_CurSelIndex = -1 --当前选中几个item
	g_OptionalGiftBox_Seven_CurLiBaoItemIndex = -1 --使用的礼包id
end

--领取
function OptionalGiftBox_Seven_OnGetClicked()
	if g_OptionalGiftBox_Seven_CurBagPos < 0 then
		return
	end
	if g_OptionalGiftBox_Seven_CurLiBaoItemIndex < 0 then
		return
	end
	if g_OptionalGiftBox_Seven_CurSelIndex < 0 then
		PushDebugMessage("#{SQYD_230802_76}")
		return
	end
	local item_table_index = PlayerPackage:GetItemTableIndex(g_OptionalGiftBox_Seven_CurBagPos)
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("PickUpItem")
	Set_XSCRIPT_ScriptID(g_OptionalGiftBox_Seven_MainScript)
	Set_XSCRIPT_Parameter(0, item_table_index) --防刷用
	Set_XSCRIPT_Parameter(1, g_OptionalGiftBox_Seven_CurBagPos)
	Set_XSCRIPT_Parameter(2, g_OptionalGiftBox_Seven_CurSelIndex)
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	--this:Hide()
end

--选中物品
function OptionalGiftBox_Seven_OnItemClicked(index)
	g_OptionalGiftBox_Seven_CurSelIndex = -1
	for i = 1, g_OptionalGiftBox_Seven_TotalNum do
		g_OptionalGiftBox_Seven_UI_ActionItem[i]:SetPushed(0)
		g_OptionalGiftBox_Seven_UI_ActionChosenMask[i]:Hide()
	end
	g_OptionalGiftBox_Seven_UI_ActionItem[index]:SetPushed(1)
	g_OptionalGiftBox_Seven_UI_ActionChosenMask[index]:Show()
	g_OptionalGiftBox_Seven_CurSelIndex = index
end

--调整位置
function OptionalGiftBox_Seven_UpdateUIPos()
	OptionalGiftBox_Seven_Frame_BK:SetProperty("UnifiedXPosition", g_OptionalGiftBox_Seven_Frame_UnifiedXPosition);
	OptionalGiftBox_Seven_Frame_BK:SetProperty("UnifiedYPosition", g_OptionalGiftBox_Seven_Frame_UnifiedYPosition);
end
