

local g_Peak_LuckyTips_text = {}

function Peak_LuckyTips_PreLoad()

	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	this:RegisterEvent("UI_COMMAND")
end

function Peak_LuckyTips_OnLoad()	
    g_Peak_LuckyTips_text[1] = "#{JYMJ_250711_74}"
    g_Peak_LuckyTips_text[2] = "#{JYMJ_250711_75}"
    g_Peak_LuckyTips_text[3] = "#{JYMJ_250711_76}"
    g_Peak_LuckyTips_text[4] = "#{JYMJ_250711_77}"
    g_Peak_LuckyTips_text[5] = "#{JYMJ_250711_78}"
end

function Peak_LuckyTips_OnEvent(event)

	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()	
    elseif event == "UI_COMMAND" and tonumber(arg0) == 20250829 then	
        local type = Get_XParam_INT( 0 )
        if g_Peak_LuckyTips_text[type] ~= nil then

            Peak_LuckyTips_Text:SetText(g_Peak_LuckyTips_text[type])
            KillTimer("Peak_LuckyTips_Timer()")
            SetTimer("Peak_LuckyTips","Peak_LuckyTips_Timer()", 5000);--???
            this:Show()	
        end
		
	end
end


function Peak_LuckyTips_Timer()

    this:Hide()
end

function Peak_LuckyTips_Open()

end
