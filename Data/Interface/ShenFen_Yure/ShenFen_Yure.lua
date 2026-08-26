-- 2024Q1preheat
-- 预热任务
-- 领奖界面

local g_UnifiedPosition = nil

--奖励
local g_PrizeCtrl = {}
local g_PrizeData =
{
	[1] = { count = 1, itemid = 20600002, itemnum = 1, },
	[2] = { count = 2, itemid = 38002532, itemnum = 8, },
	[3] = { count = 3, itemid = 30900045, itemnum = 1, },
	[4] = { count = 4, itemid = 38002519, itemnum = 1, },
}

local g_MissionText =
{
	[1] = { info = "#{SFYR_240104_50}", unfinished = "#{SFYR_240104_54}", finished = "#{SFYR_240104_55}", },
	[2] = { info = "#{SFYR_240104_51}", unfinished = "#{SFYR_240104_56}", finished = "#{SFYR_240104_57}", },
	[3] = { info = "#{SFYR_240104_52}", unfinished = "#{SFYR_240104_58}", finished = "#{SFYR_240104_59}", },
	[4] = { info = "#{SFYR_240104_53}", unfinished = "#{SFYR_240104_60}", finished = "#{SFYR_240104_61}", },
}

--图标
local g_Images = 
{
	[1] = { part = "set:ShenFen_Yure image:ShenFen_Yure_Stage1", name = "set:ShenFen_Yure image:ShenFen_Yure_Title1", },
	[2] = { part = "set:ShenFen_Yure image:ShenFen_Yure_Stage2", name = "set:ShenFen_Yure image:ShenFen_Yure_Title2", },
	[3] = { part = "set:ShenFen_Yure image:ShenFen_Yure_Stage3", name = "set:ShenFen_Yure image:ShenFen_Yure_Title3", },
	[4] = { part = "set:ShenFen_Yure image:ShenFen_Yure_Stage4", name = "set:ShenFen_Yure image:ShenFen_Yure_Title4", },
}

--===============================================
-- PreLoad()
--===============================================
function ShenFen_Yure_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function ShenFen_Yure_OnLoad()
	g_UnifiedPosition = ShenFen_Yure_Frame:GetProperty("UnifiedPosition")	
	g_PrizeCtrl = 
	{
		[1] = {btn = ShenFen_Yure_Gift1_Icon, animate = ShenFen_Yure_Gift1_Icon_Animate, getflag = ShenFen_Yure_Gift1_Icon_Get, },
		[2] = {btn = ShenFen_Yure_Gift2_Icon, animate = ShenFen_Yure_Gift2_Icon_Animate, getflag = ShenFen_Yure_Gift2_Icon_Get, },
		[3] = {btn = ShenFen_Yure_Gift3_Icon, animate = ShenFen_Yure_Gift3_Icon_Animate, getflag = ShenFen_Yure_Gift3_Icon_Get, },
		[4] = {btn = ShenFen_Yure_Gift4_Icon, animate = ShenFen_Yure_Gift4_Icon_Animate, getflag = ShenFen_Yure_Gift4_Icon_Get, },
	}
end

--===============================================
-- OnEvent()
--===============================================
function ShenFen_Yure_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 99869401) then
		local opt = Get_XParam_INT(0)
		if opt == nil or opt <= 0 then
			-- 关界面
			if this:IsVisible() then
				ShenFen_Yure_OnClose()
			end
		else
			-- 开界面or刷新界面
			local nStage = Get_XParam_INT(1)
			local isFinish = Get_XParam_INT(2)
			local nPoint = Get_XParam_INT(3)
			local bFlag1 = Get_XParam_INT(4)
			local bFlag2 = Get_XParam_INT(5)
			local bFlag3 = Get_XParam_INT(6)
			local bFlag4 = Get_XParam_INT(7)
			if opt == 1 then--??+??
				this:Show()
				ShenFen_Yure_ResetPos()
				ShenFen_Yure_Open(nStage,isFinish,nPoint,bFlag1,bFlag2,bFlag3,bFlag4)
			else--???
				if this:IsVisible() then
					ShenFen_Yure_Open(nStage,isFinish,nPoint,bFlag1,bFlag2,bFlag3,bFlag4)
				end
			end
		end
	elseif (event == "ADJEST_UI_POS") then
		ShenFen_Yure_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenFen_Yure_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShenFen_Yure_OnClose()
	end
end

--===============================================
-- 重置
--===============================================
function ShenFen_Yure_ResetPos()
	ShenFen_Yure_Frame:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

--===============================================
-- 清数据
--===============================================
function ShenFen_Yure_Clear()
end

--===============================================
-- 关界面
--===============================================
function ShenFen_Yure_OnClose()
	--数据清繝
	ShenFen_Yure_Clear()
	--隐藏界面
	this:Hide()
end

--===============================================
-- 开界面
--===============================================
function ShenFen_Yure_Open(nStage,isFinish,nPoint,bFlag1,bFlag2,bFlag3,bFlag4)
	
	--显示任务信息
	if nStage < 0 or nStage > 4 then
		return 
	end

	ShenFen_Yure_TaskInfo:SetText(g_MissionText[nStage].info)
	if isFinish == 1 then
		ShenFen_Yure_TaskInfo2:SetText(g_MissionText[nStage].finished)
		ShenFen_Yure_TaskOver:Show()
	else
		ShenFen_Yure_TaskInfo2:SetText(g_MissionText[nStage].unfinished)
		ShenFen_Yure_TaskOver:Hide()
	end

	--当前点数
	ShenFen_Yure_Now:SetText(ScriptGlobal_Format("#{SFYR_240104_67}", nPoint))		
	ShenFen_Yure_TaskPart:SetProperty("Image", g_Images[nStage].part)
	ShenFen_Yure_TaskName:SetProperty("Image", g_Images[nStage].name)
	--奖励显示
	local bFlag = {bFlag1,bFlag2,bFlag3,bFlag4}
	for i=1,table.getn(g_PrizeData) do
		g_PrizeCtrl[i].animate:Play(false)
		local theAction = DataPool:CreateBindActionItemForShow(g_PrizeData[i].itemid, g_PrizeData[i].itemnum)
		if theAction:GetID() ~= 0 then
			g_PrizeCtrl[i].btn:SetActionItem(theAction:GetID())
			if nPoint >= g_PrizeData[i].count then--???
				if bFlag[i] == 1 then-- ???
					g_PrizeCtrl[i].getflag:Show()
					-- 动画不播放
					g_PrizeCtrl[i].animate:Hide()
					g_PrizeCtrl[i].animate:Play(false)
				else-- ???
					g_PrizeCtrl[i].getflag:Hide()
					-- 动画播放
					g_PrizeCtrl[i].animate:Show()
					g_PrizeCtrl[i].animate:Play(true)
				end
			else--????
				-- 动画不播放
				if bFlag[i] == 1 then
					g_PrizeCtrl[i].getflag:Show()
				else
					g_PrizeCtrl[i].getflag:Hide()
				end
				g_PrizeCtrl[i].animate:Hide()
				g_PrizeCtrl[i].animate:Play(false)
				-- 已领奖不显示
				
			end
		end
	end
end

--===============================================
-- 领奖
--===============================================
function ShenFen_Yure_PrizeClicked(nIndex)
	if nIndex == nil then
		return
	end
	if g_PrizeCtrl[nIndex] == nil then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998694)
		Set_XSCRIPT_Function_Name("GetPrize")
		Set_XSCRIPT_Parameter(0, nIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--===============================================
-- 小问号
--===============================================
function ShenFen_Yure_Help()
	PushEvent("CCSHOP_HELP", 14)
end
