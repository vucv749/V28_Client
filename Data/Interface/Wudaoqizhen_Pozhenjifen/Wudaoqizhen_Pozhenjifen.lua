------------------------------------
-- 武道二层历练任务
-- 翣琅奇狊
-- 任务3
-- 副本界面
------------------------------------

local g_Frame_UnifiedPosition

local g_IconCtrl = {}

local g_Stage = -1--???
local g_MaxStage = 5--???
local g_LeftTime = 0--????????
local g_MaxIcon = 6--??????

--================================================
-- PreLoad()
--================================================
function Wudaoqizhen_Pozhenjifen_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
end

--================================================
-- OnLoad()
--================================================
function Wudaoqizhen_Pozhenjifen_OnLoad()
	g_Frame_UnifiedPosition = Wudaoqizhen_Pozhenjifen_Frame:GetProperty("UnifiedPosition")		
	g_IconCtrl[1] = Wudaoqizhen_Pozhenjifen_Item1
	g_IconCtrl[2] = Wudaoqizhen_Pozhenjifen_Item2
	g_IconCtrl[3] = Wudaoqizhen_Pozhenjifen_Item3
	g_IconCtrl[4] = Wudaoqizhen_Pozhenjifen_Item4
	g_IconCtrl[5] = Wudaoqizhen_Pozhenjifen_Item5
	g_IconCtrl[6] = Wudaoqizhen_Pozhenjifen_Item6
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Wudaoqizhen_Pozhenjifen_ResetPos()
	Wudaoqizhen_Pozhenjifen_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

--================================================
-- OnEvent()
--================================================
function Wudaoqizhen_Pozhenjifen_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89321201) then
		g_Stage = tonumber(Get_XParam_INT(0))
		local nRest = tonumber(Get_XParam_INT(1))
		local nTime = tonumber(Get_XParam_INT(2))

		if nRest == 1 and g_Stage ~= 0 then
			NGSetInt("LinLangQiZhen", -1)
		else
			NGSetInt("LinLangQiZhen", g_Stage)
		end

		-- 当前进度第几轮
		if g_Stage < 0 or g_Stage > g_MaxStage then
			Wudaoqizhen_Pozhenjifen_OnHiden()
			return
		end
		-- 进度还未开始
		if g_Stage == 0 then
			-- 关睜本轮倒计时
			Wudaoqizhen_Pozhenjifen_Text2:Hide()
			Wudaoqizhen_Pozhenjifen_Time:Hide()
			--关睜10s倒计时
			g_LeftTime = 0
			Wudaoqizhen_Pozhenjifen_Text3:Hide()
			KillTimer("Wudaoqizhen_Pozhenjifen_Proc()")
			-- 开启默认显示
			Wudaoqizhen_Pozhenjifen_Text4:Show()
		-- 是否中场休息
		elseif nRest == 1 then
			-- 关睜默认显示
			Wudaoqizhen_Pozhenjifen_Text4:Hide()
			-- 关睜本轮倒计时
			Wudaoqizhen_Pozhenjifen_Text2:Hide()
			Wudaoqizhen_Pozhenjifen_Time:Hide()
			--开启10s倒计时
			g_LeftTime = 10
			Wudaoqizhen_Pozhenjifen_Text3:Show()
			Wudaoqizhen_Pozhenjifen_Text3:SetText( ScriptGlobal_Format("#{LNQZ_220429_208}", g_Stage, g_LeftTime) )	
			KillTimer("Wudaoqizhen_Pozhenjifen_Proc()")
			SetTimer("Wudaoqizhen_Pozhenjifen","Wudaoqizhen_Pozhenjifen_Proc()", 1000)
		-- 第几轮进行中
		else
			-- 关睜默认显示
			Wudaoqizhen_Pozhenjifen_Text4:Hide()
			--关睜10s倒计时
			g_LeftTime = 0
			Wudaoqizhen_Pozhenjifen_Text3:Hide()
			KillTimer("Wudaoqizhen_Pozhenjifen_Proc()")
			--开启本轮倒计时
			Wudaoqizhen_Pozhenjifen_Text2:Show()
			Wudaoqizhen_Pozhenjifen_Text2:SetText( ScriptGlobal_Format("#{LNQZ_220429_243}", g_Stage) )
			Wudaoqizhen_Pozhenjifen_Time:Show()
			Wudaoqizhen_Pozhenjifen_Time:SetProperty("Timer",tostring(nTime))
		end
		-- 当前分数
		local nScore = tonumber(Get_XParam_INT(3))
		Wudaoqizhen_Pozhenjifen_Text:SetText( ScriptGlobal_Format("#{LNQZ_220429_242}", nScore) )
		-- 击杀图标+名称
		for nIndex = 1, g_MaxIcon do
			local nNpcIndex = tonumber(Get_XParam_INT(3+nIndex))
			if nNpcIndex > 0 then
				local szName,szIconName = DataPool:GetMonsterNameAndIcon(nNpcIndex)
				-- 图标
				g_IconCtrl[nIndex]:SetProperty("Image", szIconName)
				-- tooltip
				local szPlayerName = tostring(Get_XParam_STR(nIndex-1))
				g_IconCtrl[nIndex]:SetToolTip( ScriptGlobal_Format("#{LNQZ_220429_135}", szName, szPlayerName) )
			else
				-- 图标
				g_IconCtrl[nIndex]:SetProperty("Image", "")
				-- tooltip
				g_IconCtrl[nIndex]:SetToolTip("")
			end
		end
		this:Show()
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		Wudaoqizhen_Pozhenjifen_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Wudaoqizhen_Pozhenjifen_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		Wudaoqizhen_Pozhenjifen_OnHiden()
	end
end

--================================================
-- 关睜界面
--================================================
function Wudaoqizhen_Pozhenjifen_OnHiden()
	KillTimer("Wudaoqizhen_Pozhenjifen_Proc()")
	g_Stage = -1
	this:Hide()
end

--================================================
-- 中场休息倒计时更新
--================================================
function Wudaoqizhen_Pozhenjifen_Proc()	
	if g_LeftTime <= 0 then
		KillTimer("Wudaoqizhen_Pozhenjifen_Proc()")
		return
	end
	g_LeftTime = g_LeftTime - 1
	Wudaoqizhen_Pozhenjifen_Text3:SetText( ScriptGlobal_Format("#{LNQZ_220429_208}", g_Stage, g_LeftTime) )	
end

--================================================
-- 本轮倒计时结束
--================================================
function Wudaoqizhen_Pozhenjifen_TimeOut()
	--目前什么都不做
end
