-- 【2024Q2】新版本预热-山重水复 求签
local g_JianJue_Yure_Zhanbu_Frame_UnifiedPosition

local g_nUICommandID		    = 99878601

--=========================================================
-- PreLoad
--=========================================================
function JianJue_Yure_Zhanbu_PreLoad()
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("OBJECT_CARED_EVENT")
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
    this:RegisterEvent("ADJEST_UI_POS")
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function JianJue_Yure_Zhanbu_OnLoad()
    g_JianJue_Yure_Zhanbu_Frame_UnifiedPosition = JianJue_Yure_Zhanbu_Frame:GetProperty("UnifiedPosition")
end

--=========================================================
-- OnEvent
--=========================================================
function JianJue_Yure_Zhanbu_OnEvent(event)
    if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
        -- 0 关闭, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

        -- 关闭界面
		if 0 == nOpType then	
			if this:IsVisible() then
				JianJue_Yure_Zhanbu_OnClose()
			end
		end

        -- 打开界面
		if 1 == nOpType then
            JianJue_Yure_Zhanbu_Reset()
			JianJue_Yure_Zhanbu_Frame_On_ResetPos()
			this:Show()
			JianJue_Yure_Zhanbu_ParamInit()
			JianJue_Yure_Zhanbu_Update(1)
        end

        -- 刷新界面
        if 2 == nOpType then
            if this:IsVisible() then
				JianJue_Yure_Zhanbu_ParamInit()
				JianJue_Yure_Zhanbu_Update(2)
			end
        end

        -- 二次确认框
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			MessageBoxSelf3("JianJue_Yure_Zhanbu_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		JianJue_Yure_Zhanbu_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		JianJue_Yure_Zhanbu_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		JianJue_Yure_Zhanbu_Frame_On_ResetPos()
	end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function JianJue_Yure_Zhanbu_ParamInit()
end

--=========================================================
-- 二次确认框回调 ["Type"] "Ok"的返回值有"Ok"； ["Type"] "YesNo"的返回值有 "Yes" "No"
--=========================================================
function JianJue_Yure_Zhanbu_OnComfirmedBack(strRet)
	if nil == strRet then
		return
	end

	if "Yes" == strRet or "Ok" == strRet then

	end

	if "No" == strRet then
		
	end
end

--=========================================================
-- 界面更新
-- bOpen 1 打开 2 刷新界面
--=========================================================
function JianJue_Yure_Zhanbu_Update(bOpen)
end

--=========================================================
-- 重置界面
--=========================================================
function JianJue_Yure_Zhanbu_Reset()

end

--=========================================================
-- 关闭界面
--=========================================================
function JianJue_Yure_Zhanbu_OnClose()
    this:Hide()
	-- 重置
	JianJue_Yure_Zhanbu_Reset()
end

--=========================================================
-- 界面隐藏
--=========================================================
function JianJue_Yure_Zhanbu_OnHidden()
	-- 重置
	JianJue_Yure_Zhanbu_Reset()
end

--=========================================================
-- 界面位置
--=========================================================
function JianJue_Yure_Zhanbu_Frame_On_ResetPos()
	JianJue_Yure_Zhanbu_Frame:SetProperty("UnifiedPosition", g_JianJue_Yure_Zhanbu_Frame_UnifiedPosition)
end