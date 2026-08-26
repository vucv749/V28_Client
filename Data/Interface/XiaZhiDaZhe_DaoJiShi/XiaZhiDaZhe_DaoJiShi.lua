------------------------------------
-- 武道二层历练任务
-- 侠之大犨
-- 任务3
-- 倒计时界面
------------------------------------

local g_Frame_UnifiedPosition
local g_LeftTime = 0

--================================================
-- PreLoad()
--================================================
function XiaZhiDaZhe_DaoJiShi_PreLoad()
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
function XiaZhiDaZhe_DaoJiShi_OnLoad()
	g_Frame_UnifiedPosition = XiaZhiDaZhe_DaoJiShiFrame:GetProperty("UnifiedPosition")
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function XiaZhiDaZhe_DaoJiShi_ResetPos()
	XiaZhiDaZhe_DaoJiShiFrame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

--================================================
-- OnEvent()
--================================================
function XiaZhiDaZhe_DaoJiShi_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89320301) then
		local bOpen = tonumber(Get_XParam_INT(0))
		g_LeftTime = tonumber(Get_XParam_INT(1))
		--关界面
		if bOpen == nil or bOpen == 0 then
			if( this:IsVisible() ) then
	      XiaZhiDaZhe_DaoJiShi_OnHiden()
			end
			return
		end
		--开界面
		if bOpen == 1 then
			this:Show()
			-- 隐藏加时图片
			XiaZhiDaZhe_DaoJiShiMiniTitle_SJ:Hide()
			-- 显示倒计时
			local min = math.floor(g_LeftTime/60)
			local sec = math.mod(g_LeftTime,60)
			XiaZhiDaZhe_DaoJiShiMiniTitle:SetText( ScriptGlobal_Format("#{XZDZ_220428_115}", min, sec) )
			KillTimer("XiaZhiDaZhe_DaoJiShi_Proc()")
			SetTimer("XiaZhiDaZhe_DaoJiShi","XiaZhiDaZhe_DaoJiShi_Proc()", 1000)
			return
		end
		--刷界面
		if bOpen == 2 then
			if( this:IsVisible() ) then
				-- 显示倒计时
				local min = math.floor(g_LeftTime/60)
				local sec = math.mod(g_LeftTime,60)
				XiaZhiDaZhe_DaoJiShiMiniTitle:SetText( ScriptGlobal_Format("#{XZDZ_220428_115}", min, sec) )
				KillTimer("XiaZhiDaZhe_DaoJiShi_Proc()")
				SetTimer("XiaZhiDaZhe_DaoJiShi","XiaZhiDaZhe_DaoJiShi_Proc()", 1000)
				-- 显示加时图片
				local bAdd = tonumber(Get_XParam_INT(2))
				if bAdd ~= nil and bAdd == 1 then
					XiaZhiDaZhe_DaoJiShiMiniTitle_SJ:Show()
					KillTimer("XiaZhiDaZhe_AddTime_Proc()")
					SetTimer("XiaZhiDaZhe_DaoJiShi","XiaZhiDaZhe_AddTime_Proc()", 2000)
				end
			end
			return
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		XiaZhiDaZhe_DaoJiShi_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XiaZhiDaZhe_DaoJiShi_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		XiaZhiDaZhe_DaoJiShi_OnHiden()
	end
end

--================================================
-- 关睜界面
--================================================
function XiaZhiDaZhe_DaoJiShi_OnHiden()
	KillTimer("XiaZhiDaZhe_DaoJiShi_Proc()")
	KillTimer("XiaZhiDaZhe_AddTime_Proc()")
	this:Hide()
end

--================================================
-- 重新挑牻
--================================================
function XiaZhiDaZhe_DaoJiShi_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ConfirmOpen")
		Set_XSCRIPT_ScriptID(893202)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--================================================
-- 倒计时更新
--================================================
function XiaZhiDaZhe_DaoJiShi_Proc()	
	if g_LeftTime <= 0 then
		XiaZhiDaZhe_DaoJiShi_Close()
		return
	end	
	g_LeftTime = g_LeftTime -1
	local min = math.floor(g_LeftTime/60)
	local sec = math.mod(g_LeftTime,60)
	XiaZhiDaZhe_DaoJiShiMiniTitle:SetText( ScriptGlobal_Format("#{XZDZ_220428_115}", min, sec) )	
end

--================================================
-- 倒计时结束
--================================================
function XiaZhiDaZhe_DaoJiShi_Close()
	KillTimer("XiaZhiDaZhe_DaoJiShi_Proc()")
	--XiaZhiDaZhe_DaoJiShi_OnHiden()	
end

--================================================
-- 加时更新
--================================================
function XiaZhiDaZhe_AddTime_Proc()
	XiaZhiDaZhe_DaoJiShiMiniTitle_SJ:Hide()
	KillTimer("XiaZhiDaZhe_AddTime_Proc()")
end

function XiaZhiDazhe_GetTimeLeft()
	return g_LeftTime
end
