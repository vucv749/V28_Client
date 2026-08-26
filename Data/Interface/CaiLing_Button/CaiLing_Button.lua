--CaiLing_Button界面
local g_CaiLing_Button_BtnCD = 2000 --2秒cd
--变量
local g_CaiLing_Button_Param_BusObjId = -1
local g_CaiLing_Button_Param_IsEnable = 0--处于不能点击按钮的tick时间
local g_CaiLing_Button_Param_CouldClick = 0
local g_CaiLing_Button_Param_YPos = -40
--控件
local g_CaiLing_Button_Frame_UnifiedXPosition
local g_CaiLing_Button_Frame_UnifiedYPosition
--按钮cd动画
local g_CaiLing_Button_FrameAnimate_Internal = 100 -- 每100ms
local g_CaiLing_Button_FrameAnimate_Step = 4 -- 4像素
local g_CaiLing_Button_FrameAnimate_InitYPos = -40
local g_CaiLing_Button_FrameAnimate_EndYPos = 40
--uicommand
local g_CaiLing_Button_Uicmd = 89036101
local g_CaiLing_Button_Uicmd_Op = { open = 1, close = 2, enableBtn = 3, disableBtn = 4, cdBtn = 5 }

function CaiLing_Button_PreLoad()
	-- uicommand
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS", false) --第二个参数代表界面隐藏时事件是否有效,默认为true
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	-- 切换场景
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
end

function CaiLing_Button_OnLoad()
	-- 保存界面的默认相对位置
	g_CaiLing_Button_Frame_UnifiedXPosition = CaiLing_Button_Frame:GetProperty("UnifiedXPosition")
	g_CaiLing_Button_Frame_UnifiedYPosition = CaiLing_Button_Frame:GetProperty("UnifiedYPosition")
	--隐藏特效控件
	CaiLing_Button_OnEffect:Hide()
	CaiLing_Button_OffEffect:Hide()
end

function CaiLing_Button_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == g_CaiLing_Button_Uicmd then
		local uicmdOp = Get_XParam_INT(0)
		if uicmdOp == g_CaiLing_Button_Uicmd_Op.open then
			local busObjId = Get_XParam_INT(1)
			CaiLing_Button_OnOpen(busObjId)
			CaiLing_Button_Btn:Disable()
			CaiLing_Button_OnEffect:Hide()
			CaiLing_Button_OffEffect:Hide()
			this:Show()
		elseif uicmdOp == g_CaiLing_Button_Uicmd_Op.close then
			CaiLing_Button_OnClose()
			this:Hide()
		elseif uicmdOp == g_CaiLing_Button_Uicmd_Op.enableBtn then
			if this:IsVisible() then
				g_CaiLing_Button_Param_CouldClick = Get_XParam_INT(1)
				CaiLing_Button_Btn:Enable()
				g_CaiLing_Button_Param_IsEnable = 1
				CaiLing_Button_OnEffect:Show()
				CaiLing_Button_KillAllTimer()
				CaiLing_Button_OffEffect:Hide()
				g_CaiLing_Button_Param_YPos = g_CaiLing_Button_FrameAnimate_InitYPos
				CaiLing_Button_OffEffect:SetProperty("UnifiedYPosition", "{0.5,"..g_CaiLing_Button_FrameAnimate_InitYPos.."}")
			end
		elseif uicmdOp == g_CaiLing_Button_Uicmd_Op.disableBtn then
			if this:IsVisible() then
				--按钮状态
				CaiLing_Button_Btn:Disable()
				g_CaiLing_Button_Param_IsEnable = 0
				g_CaiLing_Button_Param_CouldClick = 0
				CaiLing_Button_OnEffect:Hide()
				CaiLing_Button_KillAllTimer()
				CaiLing_Button_OffEffect:Hide()
				g_CaiLing_Button_Param_YPos = g_CaiLing_Button_FrameAnimate_InitYPos
				CaiLing_Button_OffEffect:SetProperty("UnifiedYPosition", "{0.5,"..g_CaiLing_Button_FrameAnimate_InitYPos.."}")
			end
		elseif uicmdOp == g_CaiLing_Button_Uicmd_Op.cdBtn then
			if this:IsVisible() and g_CaiLing_Button_Param_IsEnable == 1 then--成功增加灵气 通知界面按钮置灰2秒
				CaiLing_Button_Btn:Disable()
				CaiLing_Button_OnEffect:Hide()
				g_CaiLing_Button_Param_CouldClick = g_CaiLing_Button_Param_CouldClick - 1
				if g_CaiLing_Button_Param_CouldClick < 0 then
					g_CaiLing_Button_Param_CouldClick = 0
				end
				CaiLing_Button_BeginCdBtn()
			end
		end
	elseif event == "ADJEST_UI_POS" then
		CaiLing_Button_UpdateUIPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		CaiLing_Button_UpdateUIPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		CaiLing_Button_OnClose()
		this:Hide()
	end
	return 1
end

--点击采灵按钮
function CaiLing_Button_Click()
	if g_CaiLing_Button_Param_BusObjId == -1 or g_CaiLing_Button_Param_IsEnable == 0 or g_CaiLing_Button_Param_CouldClick == 0 then
		return 0
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OnClickAddLingQi")
	Set_XSCRIPT_ScriptID(890361)
	Set_XSCRIPT_Parameter(0, g_CaiLing_Button_Param_BusObjId)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--界面onhide触发
function CaiLing_Button_OnHiden()
	CaiLing_Button_OnClose()
	this:Hide()
end

--开启按钮CD动画
function CaiLing_Button_BeginCdBtn()
	g_CaiLing_Button_Param_YPos = g_CaiLing_Button_FrameAnimate_InitYPos
	CaiLing_Button_OffEffect:SetProperty("UnifiedYPosition", "{0.5,"..g_CaiLing_Button_FrameAnimate_InitYPos.."}")
	CaiLing_Button_OffEffect:Show()
	KillTimer("CaiLing_Buttion_OffEffectTimer()")
	SetTimer("CaiLing_Button","CaiLing_Buttion_OffEffectTimer()", g_CaiLing_Button_FrameAnimate_Internal)
end

function CaiLing_Buttion_OffEffectTimer()
	g_CaiLing_Button_Param_YPos = g_CaiLing_Button_Param_YPos + g_CaiLing_Button_FrameAnimate_Step
	CaiLing_Button_OffEffect:SetProperty("UnifiedYPosition", "{0.5,"..g_CaiLing_Button_Param_YPos.."}")
	if g_CaiLing_Button_Param_YPos >= g_CaiLing_Button_FrameAnimate_EndYPos then
		CaiLing_Button_EndCdBtn()
	end
end

function CaiLing_Button_EndCdBtn()
	KillTimer("CaiLing_Buttion_OffEffectTimer()")
	CaiLing_Button_OffEffect:Hide()
	g_CaiLing_Button_Param_YPos = g_CaiLing_Button_FrameAnimate_InitYPos
	CaiLing_Button_OffEffect:SetProperty("UnifiedYPosition", "{0.5,"..g_CaiLing_Button_FrameAnimate_EndYPos.."}")
	if g_CaiLing_Button_Param_IsEnable == 1 and g_CaiLing_Button_Param_CouldClick > 0 then
		CaiLing_Button_Btn:Enable()
		CaiLing_Button_OnEffect:Show()
	end
end

--开启界面设置变量
function CaiLing_Button_OnOpen(busObjId)
	g_CaiLing_Button_Param_BusObjId = busObjId
	g_CaiLing_Button_Param_IsEnable = 0 --刚打开界面都是处于不能点击状态
	g_CaiLing_Button_Param_CouldClick = 0
	g_CaiLing_Button_Param_YPos = g_CaiLing_Button_FrameAnimate_InitYPos
	CaiLing_Button_OffEffect:SetProperty("UnifiedYPosition", "{0.5,"..g_CaiLing_Button_FrameAnimate_InitYPos.."}")
end

--关闭界面初始化变量
function CaiLing_Button_OnClose()
	g_CaiLing_Button_Param_BusObjId = -1
	g_CaiLing_Button_Param_IsEnable = 0
	g_CaiLing_Button_Param_CouldClick = 0
	g_CaiLing_Button_Param_YPos = g_CaiLing_Button_FrameAnimate_InitYPos
	CaiLing_Button_OffEffect:SetProperty("UnifiedYPosition", "{0.5,"..g_CaiLing_Button_FrameAnimate_InitYPos.."}")
end

--关闭所有Timer
function CaiLing_Button_KillAllTimer()
	KillTimer("CaiLing_Buttion_OffEffectTimer()")
end

--适应屏幕变化
function CaiLing_Button_UpdateUIPos()
	CaiLing_Button_Frame:SetProperty("UnifiedXPosition", g_CaiLing_Button_Frame_UnifiedXPosition);
	CaiLing_Button_Frame:SetProperty("UnifiedYPosition", g_CaiLing_Button_Frame_UnifiedYPosition);
end
