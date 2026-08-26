-- 跨服爬塔夺宝 龙塔三层奖励（神龙祝福）宝箱信息牴示UI

-- 默认位置
local TowerBox_Award_UnifiedPosition = nil
-- 控件表
local TowerBox_Award_CtrlList = nil

-- 最大开宝箱次数
local TowerBox_Award_AwardMaxCount = 1
-- UI状态
local TowerBox_Award_MiniUIFlag = 0
local TowerBox_Award_OpenFlag = 0



function TowerBox_Award_PreLoad()
	this:RegisterEvent("PTDB_UI_BOXINFO", true)
	this:RegisterEvent("PTDB_UI_CLOSEBOXINFO", true)
	this:RegisterEvent("PTDB_UI_BOXINFORESUME", true)
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end -- end func TowerBox_Award_PreLoad()

function TowerBox_Award_OnEvent(event)
	if (event == "PTDB_UI_BOXINFO") then
		TowerBox_Award_OpenFlag = tonumber(arg0)
		if (TowerBox_Award_MiniUIFlag <= 0) then
			-- MiniUI 未开启
			TowerBox_Award_UpdateBoxInfo()
			TowerBox_Award_Show()
		elseif (TowerBox_Award_OpenFlag > 0) then
			TowerBox_Award_MiniUIFlag = 0
			PushEvent("PTDB_UI_CLOSEBOXINFOMINI")

			TowerBox_Award_UpdateBoxInfo()
			TowerBox_Award_Show()
		end
	elseif (event == "PTDB_UI_CLOSEBOXINFO") then
		-- MiniUI 关睜
		TowerBox_Award_MiniUIFlag = 0
		TowerBox_Award_OpenFlag = 0

		TowerBox_Award_Hide()
	elseif (event == "PTDB_UI_BOXINFORESUME") then
		-- MiniUI 关睜
		TowerBox_Award_MiniUIFlag = 0
		TowerBox_Award_OpenFlag = 0

		TowerBox_Award_UpdateBoxInfo()
		TowerBox_Award_Show()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99857601) then
		-- 寻路
		local targetSceneId = Get_XParam_INT(0)
		local posX = Get_XParam_INT(1)
		local posZ = Get_XParam_INT(2)
		TowerBox_Award_Goto(targetSceneId, posX, posZ)
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		if (TowerBox_Award_OpenFlag <= 0) then
			-- MiniUI 关睜
			TowerBox_Award_MiniUIFlag = 0
			TowerBox_Award_Hide()
		else
			TowerBox_Award_OpenFlag = 0
		end
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TowerBox_Award_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		TowerBox_Award_UnifiedPos()
	end
end -- end func TowerBox_Award_OnEvent()

function TowerBox_Award_OnLoad()
	TowerBox_Award_UnifiedPosition = TowerBox_Award_Frame:GetProperty("UnifiedPosition")
	TowerBox_Award_MiniUIFlag = 0
	TowerBox_Award_OpenFlag = 0
end -- end func TowerBox_Award_OnLoad()

function TowerBox_Award_OnHidden()
end -- end func TowerBox_Award_OnHidden()

function TowerBox_Award_OnClosed()
	-- MiniUI 开启
	TowerBox_Award_MiniUIFlag = 1
	TowerBox_Award_OpenFlag = 0

	PushEvent("PTDB_UI_BOXINFOMINI")
	TowerBox_Award_Hide()
end -- end func TowerBox_Award_OnClosed()

-- 奖励预览按钮点击事件
function TowerBox_Award_PreviewBtn()
	PushEvent("PTDB_UI_AWARDINFO")
end -- end func TowerBox_Award_PreviewBtn()

-- 寻路到宝箱buff光圈按钮
function TowerBox_Award_BoxNumBtn(arg)
	local posType = tonumber(arg)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("CallBack_GotoBuffArea")
		Set_XSCRIPT_ScriptID(998576)
		Set_XSCRIPT_Parameter(0, posType)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end -- end func TowerBox_Award_BoxNumBtn()

-- 界面默认位置
function TowerBox_Award_UnifiedPos()
	if (TowerBox_Award_UnifiedPosition ~= nil) then
		TowerBox_Award_Frame:SetProperty("UnifiedPosition", TowerBox_Award_UnifiedPosition)
	end
end -- end func TowerBox_Award_UnifiedPos()

function TowerBox_Award_Show()
	this:Show()
end -- end func TowerBox_Award_Show()

function TowerBox_Award_Hide()
	this:Hide()
end -- end func TowerBox_Award_Hide()

-- 寻路
function TowerBox_Award_Goto(sceneId, posX, posZ)
	if (sceneId == nil or sceneId < 0) then
		return
	end
	if (posX == nil or posX <= 0) then
		return
	end
	if (posZ == nil or posZ <= 0) then
		return
	end

	AutoRunToTargetEx(posX, posZ, sceneId)
end -- end func TowerBox_Award_Goto()

function TowerBox_Award_UpdateBoxInfo()
	local redNum, yellowNum, blueNum, buffNum, curRound, diffTick, getCount = PTDB:LuaFnGetGuildBoxData()

	-- 红色宝箱数量
	local redNumText = ScriptGlobal_Format("#{PTDB_231225_180}", redNum)
	TowerBox_Award_Box1Num:SetText(redNumText)
	-- 黄色宝箱数量
	local yellowNumText = ScriptGlobal_Format("#{PTDB_231225_181}", yellowNum)
	TowerBox_Award_Box2Num:SetText(yellowNumText)
	-- 蓝色宝箱数量
	local blueNumText = ScriptGlobal_Format("#{PTDB_231225_182}", blueNum)
	TowerBox_Award_Box3Num:SetText(blueNumText)

	-- 祝福buff发放时间倒计时
	if (curRound == 0) then
		-- 预备阶段
		local leftTimeMsg = ""
		if (diffTick >= 0) then
			if (diffTick > 60) then
				local leftTime = math.floor(diffTick / 60)
				leftTimeMsg = ScriptGlobal_Format("#{PTDB_231225_190}", leftTime)
			else
				local leftTime = diffTick
				leftTimeMsg = ScriptGlobal_Format("#{PTDB_231225_183}", leftTime)
			end
			TowerBox_Award_TextInfo:SetText(leftTimeMsg)
		else
			TowerBox_Award_TextInfo:SetText(leftTimeMsg)
		end
	elseif (curRound == 1) then
		-- 第一阶段（第一轮）
		local leftTimeMsg = ""
		if (diffTick >= 0) then
			if (diffTick > 60) then
				local leftTime = math.floor(diffTick / 60)
				leftTimeMsg = ScriptGlobal_Format("#{PTDB_231225_191}", leftTime)
			else
				local leftTime = diffTick
				leftTimeMsg = ScriptGlobal_Format("#{PTDB_231225_184}", leftTime)
			end
			TowerBox_Award_TextInfo:SetText(leftTimeMsg)
		else
			TowerBox_Award_TextInfo:SetText(leftTimeMsg)
		end
	elseif (curRound == 2) then
		-- 第二阶段（第二轮）
		local leftTimeMsg = ""
		if (diffTick >= 0) then
			if (diffTick > 60) then
				local leftTime = math.floor(diffTick / 60)
				leftTimeMsg = ScriptGlobal_Format("#{PTDB_231225_192}", leftTime)
			else
				local leftTime = diffTick
				leftTimeMsg = ScriptGlobal_Format("#{PTDB_231225_185}", leftTime)
			end
			TowerBox_Award_TextInfo:SetText(leftTimeMsg)
		else
			TowerBox_Award_TextInfo:SetText(leftTimeMsg)
		end
	elseif (curRound >= 3) then
		-- 第三阶段（第三轮）
		TowerBox_Award_TextInfo:SetText("#{PTDB_231225_186}")
	end

	-- 剩余次数
	local leftCount = TowerBox_Award_AwardMaxCount - getCount
	if (leftCount < 0) then
		leftCount = 0
	end
	local leftCountMsg = ScriptGlobal_Format("#{PTDB_231225_187}", leftCount)
	TowerBox_Award_NumText:SetText(leftCountMsg)
end -- end func TowerBox_Award_UpdateBoxInfo()
