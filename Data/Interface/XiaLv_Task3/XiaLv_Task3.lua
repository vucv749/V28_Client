--任务三：点灵犀
local g_Frame_UnifiedPosition = nil
local g_ExeScript = 998290
local g_UICOMMAND = 99829001
local g_ActionTips = {
    [1] =  "比心",
	[2] =  "跳舞",
	[3] =  "撒娇",
	[4] =  "雀跃",
	[5] =  "邀请",
}


function XiaLv_Task3_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function XiaLv_Task3_OnLoad()
    g_Frame_UnifiedPosition = XiaLv_Task3_Blank:GetProperty("UnifiedPosition")
   

end



function XiaLv_Task3_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
		local nOpt = Get_XParam_INT(0)
        if nOpt == 1 then
            --开始前倒计时
            local countDown = Get_XParam_INT(1)
            --清空显示区
            XiaLv_Task3_Info2:SetText("准备开局")
            XiaLv_Task3_Info1:SetText("#{FQZC_230331_297}")
            XiaLv_Task3_State:Hide()
            XiaLv_Task3_Info:Show() --开始
            XiaLv_Task3_Info:Play(true)
            XiaLv_Task3_Info_2:Hide()

            CloseAllWindow()
            this:Show()
        elseif nOpt == 2 then
           --显示题目
           local countDown = Get_XParam_INT(1)
           local actionIndex = Get_XParam_INT(2)
           if actionIndex < 1 or actionIndex > 5 then
               return 
           end
           XiaLv_Task3_Info:Hide()
            XiaLv_Task3_Info_2:Show()
            XiaLv_Task3_Info_2:Play(true)

           XiaLv_Task3_State:Hide()
           XiaLv_Task3_Info2:SetText(g_ActionTips[actionIndex])
          -- XiaLv_Task3_Info1:SetText("")
           this:Show()

        elseif nOpt == 3 then
            local countDown = Get_XParam_INT(1)
            local result = Get_XParam_INT(2)
            if result == 1 then
                XiaLv_Task3_State:SetProperty("Image","set:Xialv04 image:Xialv_dui" )
                XiaLv_Task3_State:Show();
            else
                XiaLv_Task3_State:SetProperty("Image","set:Xialv04 image:Xialv_cuo" )
                XiaLv_Task3_State:Show();
            end
            this:Show()
        
        elseif nOpt == 4 then
            --结束 关闭界面
            this:Hide()

        elseif nOpt == 5 then
            --结束 关闭界面
            this:Hide()

        end
			

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        XiaLv_Task3_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		XiaLv_Task3_OnClose()


	end

end

--有玩家中途不想玩了
function XiaLv_Task3_Stop()
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OnPlayerStop")
    Set_XSCRIPT_ScriptID(g_ExeScript) 
    Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()
end


function XiaLv_Task3_On_ResetPos()
    if (this:IsVisible()) then
        if (g_Frame_UnifiedPosition ~= nil) then
            XiaLv_Task3_Blank:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
        end
    end
end



function XiaLv_Task3_OnClose()

    this:Hide()
end