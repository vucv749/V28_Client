local g_ShenBingFB_Frame_UnifiedPosition
local ShenBingFB_Str= 
{
	[0] = "#{SBRC_20230627_182}",
	[1] = "#{SBRC_20230627_161}",
	[2] = "#{SBRC_20230627_162}",
	[3] = "#{SBRC_20230627_163}",
	[4] = "#{SBRC_20230627_164}",
	[5] = "#{SBRC_20230627_165}",
	[6] = "#{SBRC_20230627_166}",
}

-- --´Ê×ºÖ÷Ìâ
-- x998510_g_CiZhui_aiparam_Nu			= 1  	--´Ê×º1 Å­
-- x998510_g_CiZhui_aiparam_You			= 2  	--´Ê×º2 ÓÇ
-- x998510_g_CiZhui_aiparam_Ai			= 3  	--´Ê×º3 °®
-- x998510_g_CiZhui_aiparam_Yu			= 4  	--´Ê×º4 Óû
-- x998510_g_CiZhui_aiparam_Ju			= 5  	--´Ê×º5 ¾å
-- x998510_g_CiZhui_aiparam_Zeng		= 6  	--´Ê×º6 Ô÷
-- x998510_g_CiZhui_aiparam_Xi			= 0  	--´Ê×º7 Ï²

function ShenBingFB_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)

end


function ShenBingFB_OnLoad()

	g_ShenBingFB_Frame_UnifiedPosition = ShenBingFB_Frame:GetProperty("UnifiedPosition")

end


function ShenBingFB_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99848001) then		
		local nParam = Get_XParam_INT(0) --Right
		ShenBingFB_OpenUI(nParam)
	elseif event=="HIDE_ON_SCENE_TRANSED"  then
		this:Hide()
    end
	
	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			ShenBingFB_ResetPos()
        end
	end
	
end

function ShenBingFB_OnHiden()
	this:Hide()
end

function ShenBingFB_Close()

end

function ShenBingFB_ResetPos()
	ShenBingFB_Frame:SetProperty("UnifiedPosition", g_ShenBingFB_Frame_UnifiedPosition)
end

function ShenBingFB_OpenMini()
	if this:IsVisible() then
		ShenBingFB:Hide();
		ShenBingFB_Mini_Frame:Show()
	end
end

function ShenBingFB_Mini_Small()
	if this:IsVisible() then
		ShenBingFB:Show();
		ShenBingFB_Mini_Frame:Hide()
	end
end

function ShenBingFB_OpenUI(nParam)
	if this:IsVisible() then
		return
	end

	ShenBingFB:Show();
	if nParam < 0 or nParam > 6 then
		nParam = 0
	end
	ShenBingFB_Text:SetText( ShenBingFB_Str[nParam] )
	ShenBingFB_Mini_Frame:Hide()
	this:Show();	
end