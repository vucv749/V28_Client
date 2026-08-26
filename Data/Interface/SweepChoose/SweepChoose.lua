--sweepchoose
local SweepChoose_Frame_UnifiedPosition;
local SweepChoose_g_dailyFuben =
{
	[1] = {
		[1] = { FName = "#{YBSD_231107_23}", FImage = "set:SweepChoose image:Card_QQSL", FConText = "#{YBSD_231107_28}",FFinText = "#{YBSD_231107_44}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_QQSL", },
		[2] = { FName = "#{YBSD_231107_21}", FImage = "set:SweepChoose image:Card_PMF_J", FConText = "#{YBSD_231107_29}",FFinText = "#{YBSD_231107_45}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_PMF_J", },
	},
	[2] = {
		[1] = { FName = "#{YBSD_231107_24}", FImage = "set:SweepChoose image:Card_PMF_S", FConText = "#{YBSD_231107_29}",FFinText = "#{YBSD_231107_45}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_PMF_S",},
		[2] = { FName = "#{YBSD_231107_22}", FImage = "set:SweepChoose image:Card_SYSZ", FConText = "#{YBSD_231107_27}",FFinText = "#{YBSD_231107_43}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_SYSZ",},
	},
	[3] = {
		[1] = { FName = "#{YBSD_231107_19}", FImage = "set:SweepChoose image:Card_YZW", FConText = "#{YBSD_231107_25}",FFinText = "#{YBSD_231107_41}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_YZW",},
		[2] = { FName = "#{YBSD_231107_20}", FImage = "set:SweepChoose image:Card_WRMJ", FConText = "#{YBSD_231107_26}",FFinText = "#{YBSD_231107_42}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_WRMJ",},
	},
	[4] = {
		[1] = { FName = "#{YBSD_231107_21}", FImage = "set:SweepChoose image:Card_PMF_J", FConText = "#{YBSD_231107_29}",FFinText = "#{YBSD_231107_45}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_PMF_J",},
		[2] = { FName = "#{YBSD_231107_22}", FImage = "set:SweepChoose image:Card_SYSZ", FConText = "#{YBSD_231107_27}",FFinText = "#{YBSD_231107_43}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_SYSZ",},
	},
	[5] = {
		[1] = { FName = "#{YBSD_231107_23}", FImage = "set:SweepChoose image:Card_QQSL", FConText = "#{YBSD_231107_28}",FFinText = "#{YBSD_231107_44}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_QQSL",},
		[2] = { FName = "#{YBSD_231107_19}", FImage = "set:SweepChoose image:Card_YZW", FConText = "#{YBSD_231107_25}",FFinText = "#{YBSD_231107_41}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_YZW",},
	},
	[6] = {
		[1] = { FName = "#{YBSD_231107_24}", FImage = "set:SweepChoose image:Card_PMF_S", FConText = "#{YBSD_231107_29}",FFinText = "#{YBSD_231107_45}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_PMF_S",},
		[2] = { FName = "#{YBSD_231107_20}", FImage = "set:SweepChoose image:Card_WRMJ", FConText = "#{YBSD_231107_26}",FFinText = "#{YBSD_231107_42}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_WRMJ",},
	},
	[0] = {
		[1] = { FName = "#{YBSD_231107_22}", FImage = "set:SweepChoose image:Card_SYSZ", FConText = "#{YBSD_231107_27}",FFinText = "#{YBSD_231107_43}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_SYSZ",},
		[2] = { FName = "#{YBSD_231107_21}", FImage = "set:SweepChoose image:Card_PMF_J", FConText = "#{YBSD_231107_29}",FFinText = "#{YBSD_231107_45}",
			FConNeed = 1, FYinbi = 50, FTitle = "set:SweepChoose image:Title_PMF_J",},
	},
}
local SweepChoose_g_NowDaily = -1
local SweepChoose_g_IsBtn1Disable = 0
local SweepChoose_g_IsBtn2Disable = 0
local SweepChoose_g_UiCommand = 89028901
local SweepChoose_g_UiCommand_Type = {
	openUI = 1,
	UpdateUI = 2,
	disableBtn = 3,
}
local SweepChoose_g_Condition1 = 0
local SweepChoose_g_Condition2 = 0
local SweepChoose_g_QiYuTag = 0--0未拾取 1已拾取
local SweepChoose_g_YinFuDaiBi = 0--显示用的银符数量
local SweepChoose_g_YinFuDaiBiMax = 500 --最大银符数量 增加了个根据银符是否达到上限来决定出不出红点的机制 只能在客户端这里也写死一个500上限了。

function SweepChoose_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false);
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("REFRESH_SECKILL_YINBI",false)
end

function SweepChoose_OnLoad()
	SweepChoose_Frame_UnifiedPosition = SweepChoose_Frame:GetProperty("UnifiedPosition");
end

-- OnEvent
function SweepChoose_OnEvent(event)
	if (event == "UI_COMMAND") then
		if tonumber(arg0) == SweepChoose_g_UiCommand then
			if Get_XParam_INT(0) == SweepChoose_g_UiCommand_Type.openUI then--打开界面
				SweepChoose_Clean() --开启界面要刷新数据
				SweepChoose_g_NowDaily = Get_XParam_INT(1)
				SweepChoose_g_IsBtn1Disable = Get_XParam_INT(2)
				SweepChoose_g_IsBtn2Disable = Get_XParam_INT(3)
				SweepChoose_g_Condition1 = Get_XParam_INT(4)
				SweepChoose_g_Condition2 = Get_XParam_INT(5)
				SweepChoose_g_QiYuTag = Get_XParam_INT(6)
				SweepChoose_g_YinFuDaiBi = Get_XParam_INT(7)
				this:Show()
				SweepChoose_Update()
				SweepChoose_UpdateDaiBiText()
			elseif Get_XParam_INT(0) == SweepChoose_g_UiCommand_Type.UpdateUI then--刷新界面
				if this:IsVisible() then
					SweepChoose_Clean() --刷新界面要刷新数据
					SweepChoose_g_NowDaily = Get_XParam_INT(1)
					SweepChoose_g_IsBtn1Disable = Get_XParam_INT(2)
					SweepChoose_g_IsBtn2Disable = Get_XParam_INT(3)
					SweepChoose_g_Condition1 = Get_XParam_INT(4)
					SweepChoose_g_Condition2 = Get_XParam_INT(5)
					SweepChoose_g_QiYuTag = Get_XParam_INT(6)
					SweepChoose_g_YinFuDaiBi = Get_XParam_INT(7)
					SweepChoose_Update()
					SweepChoose_UpdateDaiBiText()
				end
			elseif Get_XParam_INT(0) == SweepChoose_g_UiCommand_Type.disableBtn then--领取奖励后刷新奖励按钮状态
				if this:IsVisible() then
					local index = Get_XParam_INT(1)
					if index == 1 then
						SweepChoose_LevelItem1_RewardBtn:Disable()
						SweepChoose_LevelItem1_Received:Show()
						SweepChoose_LevelItem1_RewardBtn_Tips:Hide()
						SweepChoose_g_IsBtn1Disable = 1
					elseif index == 2 then
						SweepChoose_LevelItem2_RewardBtn:Disable()
						SweepChoose_LevelItem2_Received:Show()
						SweepChoose_LevelItem2_RewardBtn_Tips:Hide()
						SweepChoose_g_IsBtn2Disable = 1
					end
					SweepChoose_g_YinFuDaiBi = Get_XParam_INT(2)
					SweepChoose_UpdateDaiBiText()
				end
			end
		end
	elseif (event == "ADJEST_UI_POS") then
		SweepChoose_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SweepChoose_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		SweepChoose_OnClosed()
	elseif( event == "REFRESH_SECKILL_YINBI") then--开着界面时进行消耗银符操作，用这里刷新当前银符数量和红点
		if this:IsVisible() then
			SweepChoose_UpdateDaiBiText2()
		end
	end
end

function SweepChoose_UpdateDaiBiText()--用server发回的数量更新
	local uYinbi = SweepChoose_g_YinFuDaiBi
	local strYinbi = ScriptGlobal_Format("#{YBSD_231107_37}",tostring(uYinbi))
	SweepChoose_Explain3_NumText:SetText(strYinbi)
end

function SweepChoose_UpdateDaiBiText2()--用客户端的数量更新
	local _,_,_,_,_,_,_,_,_,uYinbi = GetSecKillData()
	SweepChoose_g_YinFuDaiBi = uYinbi
	local strYinbi = ScriptGlobal_Format("#{YBSD_231107_37}",tostring(uYinbi))
	SweepChoose_Explain3_NumText:SetText(strYinbi)
	--消耗银符时刷新红点
	if SweepChoose_g_NowDaily == -1 or SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily] == nil or
		SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily][1] == nil or
		SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily][2] == nil then
		return 0
	end
	local FubenTbl1 = SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily][1]
	local FubenTbl2 = SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily][2]
	local condition1 = SweepChoose_g_Condition1
	if condition1 >= FubenTbl1.FConNeed and SweepChoose_g_IsBtn1Disable == 0 then
		SweepChoose_LevelItem1_RewardBtn_Tips:Show()
	else
		SweepChoose_LevelItem1_RewardBtn_Tips:Hide()
	end
	local condition2 = SweepChoose_g_Condition2
	if condition2 >= FubenTbl2.FConNeed and SweepChoose_g_IsBtn2Disable == 0 then
		SweepChoose_LevelItem2_RewardBtn_Tips:Show()
	else
		SweepChoose_LevelItem2_RewardBtn_Tips:Hide()
	end
	--新增红点条件：银符达到上限，不显示红点
	if SweepChoose_g_YinFuDaiBi >= SweepChoose_g_YinFuDaiBiMax then
		SweepChoose_LevelItem1_RewardBtn_Tips:Hide()
		SweepChoose_LevelItem2_RewardBtn_Tips:Hide()
	end
end

function SweepChoose_Frame_On_ResetPos()
	SweepChoose_Frame:SetProperty("UnifiedPosition", SweepChoose_Frame_UnifiedPosition);
end

function SweepChoose_OnClosed()
	SweepChoose_Clean()
	this:Hide()
end

function SweepChoose_Clean()
	SweepChoose_g_NowDaily      = -1
	SweepChoose_g_IsBtn1Disable = 0
	SweepChoose_g_IsBtn2Disable = 0
	SweepChoose_g_Condition1    = 0
	SweepChoose_g_Condition2    = 0
	SweepChoose_g_QiYuTag		= 0
	SweepChoose_g_YinFuDaiBi	= 0
end

function SweepChoose_HelpClick()
	PushEvent("QUEST_HELPINFO", "#{YBSD_231107_32}")
end

function SweepChoose_Update()
	if SweepChoose_g_NowDaily == -1 or SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily] == nil or
		SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily][1] == nil or
		SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily][2] == nil then
		return 0
	end
	--获得今天的表
	local FubenTbl1 = SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily][1]
	local FubenTbl2 = SweepChoose_g_dailyFuben[SweepChoose_g_NowDaily][2]
	--名字标题
	SweepChoose_LevelItem1_Title:SetProperty("Image", FubenTbl1.FTitle)
	SweepChoose_LevelItem2_Title:SetProperty("Image", FubenTbl2.FTitle)
	--红点与条件文本
	local condition1 = SweepChoose_g_Condition1
	local conTextStr1 = FubenTbl1.FConText
	local conTextStr2 = FubenTbl2.FConText
	if condition1 >= FubenTbl1.FConNeed then
		condition1 = FubenTbl1.FConNeed
		SweepChoose_LevelItem1_RewardBtn_Tips:Show()
		conTextStr1 = FubenTbl1.FFinText--完成时显示异色
	else
		SweepChoose_LevelItem1_RewardBtn_Tips:Hide()
		conTextStr1 = FubenTbl1.FConText--未完成时显示原色
	end
	local condition2 = SweepChoose_g_Condition2
	if condition2 >= FubenTbl2.FConNeed then
		condition2 = FubenTbl2.FConNeed
		SweepChoose_LevelItem2_RewardBtn_Tips:Show()
		conTextStr2 = FubenTbl2.FFinText
	else
		SweepChoose_LevelItem2_RewardBtn_Tips:Hide()
		conTextStr2 = FubenTbl2.FConText
	end
	local FinishText1 = ScriptGlobal_Format(conTextStr1, tostring(condition1) .. "/" .. tostring(FubenTbl1.FConNeed))
	local FinishText2 = ScriptGlobal_Format(conTextStr2, tostring(condition2) .. "/" .. tostring(FubenTbl2.FConNeed))
	SweepChoose_LevelItem1_FinishText:SetText(FinishText1)
	SweepChoose_LevelItem2_FinishText:SetText(FinishText2)
	--奇遇tag
	SweepChoose_QiyuTag:SetProperty("Image", "set:SweepChoose image:Lucky_Light")--保持亮
	if SweepChoose_g_QiYuTag == 0 then--未拾取
		SweepChoose_QiyuTag:SetToolTip("#{QYFB_20231110_43}")
	else--已拾取	
		SweepChoose_QiyuTag:SetToolTip("#{QYFB_20231110_44}")
	end
	--可获得：
	local NumText1 = ScriptGlobal_Format("#{YBSD_231107_40}", tostring(FubenTbl1.FYinbi))
	local NumText2 = ScriptGlobal_Format("#{YBSD_231107_40}", tostring(FubenTbl2.FYinbi))
	SweepChoose_LevelItem1_Icon_NumText:SetText(NumText1)
	SweepChoose_LevelItem2_Icon_NumText:SetText(NumText2)
	--已领取 领取按钮
	if SweepChoose_g_IsBtn1Disable == 1 then
		SweepChoose_LevelItem1_RewardBtn:Disable()
		SweepChoose_LevelItem1_Received:Show()
		SweepChoose_LevelItem1_RewardBtn_Tips:Hide()
	else
		SweepChoose_LevelItem1_RewardBtn:Enable()
		SweepChoose_LevelItem1_Received:Hide()
	end
	if SweepChoose_g_IsBtn2Disable == 1 then
		SweepChoose_LevelItem2_RewardBtn:Disable()
		SweepChoose_LevelItem2_Received:Show()
		SweepChoose_LevelItem2_RewardBtn_Tips:Hide()
	else
		SweepChoose_LevelItem2_RewardBtn:Enable()
		SweepChoose_LevelItem2_Received:Hide()
	end
	--新增红点条件：银符达到上限，不显示红点
	if SweepChoose_g_YinFuDaiBi >= SweepChoose_g_YinFuDaiBiMax then
		SweepChoose_LevelItem1_RewardBtn_Tips:Hide()
		SweepChoose_LevelItem2_RewardBtn_Tips:Hide()
	end
	--副本图片
	SweepChoose_LevelItem1_Background:SetProperty("Image", FubenTbl1.FImage)
	SweepChoose_LevelItem2_Background:SetProperty("Image", FubenTbl2.FImage)
end

function SweepChoose_LevelItem_RewardClick(index)
	if SweepChoose_g_NowDaily == -1 or (index ~= 1 and index ~= 2) then
		return 0
	end
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("OnGetReward");
	Set_XSCRIPT_ScriptID(890289);
	Set_XSCRIPT_Parameter(0, SweepChoose_g_NowDaily);
	Set_XSCRIPT_Parameter(1, index);
	Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end
