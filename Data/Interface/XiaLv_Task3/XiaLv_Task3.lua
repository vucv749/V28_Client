--ÈÎÎñÈý£ºµãÁéÏ¬
local g_Frame_UnifiedPosition = nil
local g_ExeScript = 998290
local g_UICOMMAND = 99829001
local g_ActionTips = {
    [1] =  "Tï Tâm",
	[2] =  "Khiêu vû",
	[3] =  "Làm nûng",
	[4] =  "Nhäy nhót",
	[5] =  "M¶i",
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
            --¿ªÊ¼Ç°µ¹¼ÆÊ±
            local countDown = Get_XParam_INT(1)
            --Çå¿ ÏÔÊ¾Çø
            XiaLv_Task3_Info2:SetText("Chu¦n b¸ b¡t ð¥u")
            XiaLv_Task3_Info1:SetText("#{FQZC_230331_297}")
            XiaLv_Task3_State:Hide()
            XiaLv_Task3_Info:Show() --??
            XiaLv_Task3_Info:Play(true)
            XiaLv_Task3_Info_2:Hide()

            CloseAllWindow()
            this:Show()
        elseif nOpt == 2 then
           --ÏÔÊ¾ÌâÄ¿
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
            --½áÊø ¹Ø± ½çÃæ
            this:Hide()

        elseif nOpt == 5 then
            --½áÊø ¹Ø± ½çÃæ
            this:Hide()

        end
			

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        XiaLv_Task3_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		XiaLv_Task3_OnClose()


	end

end

--ÓÐÍæ¼ÒÖÐÍ¾²»ÏëÍæÁË
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
