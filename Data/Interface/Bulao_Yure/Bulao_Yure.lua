-- 2023Q1不老长春谷
-- 预热任务
-- 领奖界面
-- !!!reloadscript =Bulao_Yure

local g_UnifiedPosition = nil

--奖励
local g_PrizeCtrl = {}
local g_PrizeData =
{
	[1] = { count = 1, itemid = 20501003, itemnum = 1, },
	[2] = { count = 2, itemid = 20502003, itemnum = 1, },
	[3] = { count = 3, itemid = 38002532, itemnum = 1, },
	[4] = { count = 4, itemid = 38002519, itemnum = 1, },
}

--图标
local g_Images = 
{
	[1] = { part = "set:Bulao_Yure image:Bulao_Yure_Part1", name = "set:Bulao_Yure image:Bulao_Yure_P1", },
	[2] = { part = "set:Bulao_Yure image:Bulao_Yure_Part2", name = "set:Bulao_Yure image:Bulao_Yure_P2", },
	[3] = { part = "set:Bulao_Yure image:Bulao_Yure_Part3", name = "set:Bulao_Yure image:Bulao_Yure_P3", },
	[4] = { part = "set:Bulao_Yure image:Bulao_Yure_Part4", name = "set:Bulao_Yure image:Bulao_Yure_P4", },
}

--===============================================
-- PreLoad()
--===============================================
function Bulao_Yure_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function Bulao_Yure_OnLoad()
	g_UnifiedPosition = Bulao_Yure_Frame:GetProperty("UnifiedPosition")	
	g_PrizeCtrl = 
	{
		[1] = {btn = Bulao_Yure_Gift1_Icon, animate = Bulao_Yure_Gift1_Icon_Animate, getflag = Bulao_Yure_Gift1_Icon_Get, },
		[2] = {btn = Bulao_Yure_Gift2_Icon, animate = Bulao_Yure_Gift2_Icon_Animate, getflag = Bulao_Yure_Gift2_Icon_Get, },
		[3] = {btn = Bulao_Yure_Gift3_Icon, animate = Bulao_Yure_Gift3_Icon_Animate, getflag = Bulao_Yure_Gift3_Icon_Get, },
		[4] = {btn = Bulao_Yure_Gift4_Icon, animate = Bulao_Yure_Gift4_Icon_Animate, getflag = Bulao_Yure_Gift4_Icon_Get, },
	}
end

--===============================================
-- OnEvent()
--===============================================
function Bulao_Yure_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 89015201) then
		local flag = Get_XParam_INT(0)
		if flag == nil or flag <= 0 then
			-- 关界面
			if this:IsVisible() then
				Bulao_Yure_OnClose()
			end
		else
			-- 开界面or刷新界面
			local nPoint = Get_XParam_INT(1)
			local nStep = Get_XParam_INT(2)
			local bFlag1 = Get_XParam_INT(3)
			local bFlag2 = Get_XParam_INT(4)
			local bFlag3 = Get_XParam_INT(5)
			local bFlag4 = Get_XParam_INT(6)
			if flag == 1 then--打开+刷新
				this:Show()
				Bulao_Yure_ResetPos()
				Bulao_Yure_Open(nPoint,nStep,bFlag1,bFlag2,bFlag3,bFlag4)
			else--仅刷新
				if this:IsVisible() then
					Bulao_Yure_Open(nPoint,nStep,bFlag1,bFlag2,bFlag3,bFlag4)
				end
			end
		end
	elseif (event == "ADJEST_UI_POS") then
		Bulao_Yure_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Bulao_Yure_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Bulao_Yure_OnClose()
	end
end

--===============================================
-- 重置
--===============================================
function Bulao_Yure_ResetPos()
	Bulao_Yure_Frame:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

--===============================================
-- 清数据
--===============================================
function Bulao_Yure_Clear()
end

--===============================================
-- 关界面
--===============================================
function Bulao_Yure_OnClose()
	--数据清空
	Bulao_Yure_Clear()
	--隐藏界面
	this:Hide()
end

--===============================================
-- 开界面
--===============================================
function Bulao_Yure_Open(nPoint,nStep,bFlag1,bFlag2,bFlag3,bFlag4)
	
	--显示任务信息
	Bulao_Yure_ShowMissionInfo(nStep)

	--当前点数
	Bulao_Yure_Now:SetText(ScriptGlobal_Format("#{CCYR_221220_167}", nPoint))		
	
	--奖励显示
	local bFlag = {bFlag1,bFlag2,bFlag3,bFlag4}
	for i=1,table.getn(g_PrizeData) do
		local theAction = DataPool:CreateBindActionItemForShow(g_PrizeData[i].itemid, g_PrizeData[i].itemnum)
		if theAction:GetID() ~= 0 then
			g_PrizeCtrl[i].btn:SetActionItem(theAction:GetID())
			if nPoint >= g_PrizeData[i].count then--可领奖
				if bFlag[i] == 1 then-- 已领奖
					g_PrizeCtrl[i].getflag:Show()
					-- 动画不播放
					g_PrizeCtrl[i].animate:Hide()
					g_PrizeCtrl[i].animate:Play(false)
				else-- 未领奖
					g_PrizeCtrl[i].getflag:Hide()
					-- 动画播放
					g_PrizeCtrl[i].animate:Show()
					g_PrizeCtrl[i].animate:Play(true)
				end
			else--不可领奖
				-- 动画不播放
				g_PrizeCtrl[i].animate:Hide()
				g_PrizeCtrl[i].animate:Play(false)
				-- 已领奖不显示
				g_PrizeCtrl[i].getflag:Hide()
			end
		end
	end
end

--===============================================
-- 显示任务信息
--===============================================
function Bulao_Yure_ShowMissionInfo(nStep)
	if nStep == nil or nStep <= 0 then
		return
	end
	if nStep == 1 then
		Bulao_Yure_TaskPart:SetProperty("Image", g_Images[1].part)
		Bulao_Yure_TaskName:SetProperty("Image", g_Images[1].name)
		Bulao_Yure_TaskOver:Hide()
		Bulao_Yure_TaskInfo:SetText("#{CCYR_221220_12}")
		Bulao_Yure_TaskInfo2:Hide()
		Bulao_Yure_TaskInfo3:Hide()
	elseif nStep == 2 then
		Bulao_Yure_TaskPart:SetProperty("Image", g_Images[1].part)
		Bulao_Yure_TaskName:SetProperty("Image", g_Images[1].name)
		Bulao_Yure_TaskOver:Show()
		Bulao_Yure_TaskInfo:SetText("#{CCYR_221220_12}")
		Bulao_Yure_TaskInfo2:Show()
		Bulao_Yure_TaskInfo2:SetText("#{CCYR_221220_19}")
		Bulao_Yure_TaskInfo3:Hide()
	elseif nStep == 3 then
		Bulao_Yure_TaskPart:SetProperty("Image", g_Images[2].part)
		Bulao_Yure_TaskName:SetProperty("Image", g_Images[2].name)
		Bulao_Yure_TaskOver:Hide()
		Bulao_Yure_TaskInfo:SetText("#{CCYR_221220_14}")
		Bulao_Yure_TaskInfo2:Hide()
		Bulao_Yure_TaskInfo3:Hide()
	elseif nStep == 4 then
		Bulao_Yure_TaskPart:SetProperty("Image", g_Images[2].part)
		Bulao_Yure_TaskName:SetProperty("Image", g_Images[2].name)
		Bulao_Yure_TaskOver:Show()
		Bulao_Yure_TaskInfo:SetText("#{CCYR_221220_14}")
		Bulao_Yure_TaskInfo2:Show()
		Bulao_Yure_TaskInfo2:SetText("#{CCYR_221220_20}")
		Bulao_Yure_TaskInfo3:Hide()
	elseif nStep == 5 then
		Bulao_Yure_TaskPart:SetProperty("Image", g_Images[3].part)
		Bulao_Yure_TaskName:SetProperty("Image", g_Images[3].name)
		Bulao_Yure_TaskOver:Hide()
		Bulao_Yure_TaskInfo:SetText("#{CCYR_221220_16}")
		Bulao_Yure_TaskInfo2:Hide()
		Bulao_Yure_TaskInfo3:Hide()
	elseif nStep == 6 then
		Bulao_Yure_TaskPart:SetProperty("Image", g_Images[3].part)
		Bulao_Yure_TaskName:SetProperty("Image", g_Images[3].name)
		Bulao_Yure_TaskOver:Show()
		Bulao_Yure_TaskInfo:SetText("#{CCYR_221220_16}")
		Bulao_Yure_TaskInfo2:Hide()
		Bulao_Yure_TaskInfo3:Hide()
	elseif nStep == 7 then
		Bulao_Yure_TaskPart:SetProperty("Image", g_Images[4].part)
		Bulao_Yure_TaskName:SetProperty("Image", g_Images[4].name)
		Bulao_Yure_TaskOver:Hide()
		Bulao_Yure_TaskInfo:SetText("#{CCYR_221220_18}")
		Bulao_Yure_TaskInfo2:Hide()
		Bulao_Yure_TaskInfo3:Hide()
	elseif nStep == 8 then
		Bulao_Yure_TaskPart:SetProperty("Image", g_Images[4].part)
		Bulao_Yure_TaskName:SetProperty("Image", g_Images[4].name)
		Bulao_Yure_TaskOver:Show()
		Bulao_Yure_TaskInfo:SetText("#{CCYR_221220_18}")
		Bulao_Yure_TaskInfo2:Show()
		Bulao_Yure_TaskInfo2:SetText("#{CCYR_221220_21}")
		Bulao_Yure_TaskInfo3:Show()
		Bulao_Yure_TaskInfo3:SetText("#{CCYR_221220_168}")
	end
end

--===============================================
-- 领奖
--===============================================
function Bulao_Yure_PrizeClicked(nIndex)
	if nIndex == nil then
		return
	end
	if g_PrizeCtrl[nIndex] == nil then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(890152)
		Set_XSCRIPT_Function_Name("OnPrize")
		Set_XSCRIPT_Parameter(0, nIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--===============================================
-- 小问号
--===============================================
function Bulao_Yure_Help()
	PushEvent("CCSHOP_HELP", 14)
end
