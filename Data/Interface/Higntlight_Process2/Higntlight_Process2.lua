local g_HigntlightProcess_Frame_UnifiedPosition;
local g_NuHuoLianZhan = 1;
local g_XiShanXingLv = 2;
--ºóĞøÈôÓĞÆäËû¼¼ÄÜÒªÌí¼Ó ĞèÒªÔÚ âÀï×ö²¹³ä

function Higntlight_Process2_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	--³¡¾°ÇĞ»»
	this:RegisterEvent("ON_SCENE_TRANS");
	--Íæ¼ÒÀë¿ªÊÀ½ç
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--³¬Á´
	this:RegisterEvent("HIGHLIGHT_SKILL_TOOLTIP");
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS");
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");	
end

function Higntlight_Process2_OnLoad()
	this:Hide();
	Higntlight_Process2_HideAllSkillTitle()
    g_HigntlightProcess_Frame_UnifiedPosition = Higntlight_Process2_Frame:GetProperty("UnifiedPosition");
end


function Higntlight_Process2_OnEvent(event)
	if event == "UI_COMMAND" then
        --·şÎñÆ÷¶Ëlua½Å±¾µ÷ÓÃ  âÀï»ñµÃ²ÎÊı²¢´¦Àí
	elseif event == "ON_SCENE_TRANS" then
		--³¡¾°ÇĞ»»
		Higntlight_Process2_Close();
	elseif event == "PLAYER_LEAVE_WORLD" then
		--Íæ¼ÒÀë¿ªÊÀ½ç
		Higntlight_Process2_Close();
	elseif (event == "HIGHLIGHT_SKILL_TOOLTIP" ) then
		Higntlight_Process2_Close();
		local lost = tonumber(arg0);
		local skillType = tonumber(arg1);
        local Tname = tostring(arg2);
		--PushDebugMessage("Phân tích liên kªt kÛ nång:"..Tname..skillType);
		Higntlight_Process2_UpdateUI(Tname,skillType);
		this:Show();
	elseif (event == "ADJEST_UI_POS" ) then
        HigntlightProcess2_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
        HigntlightProcess2_On_ResetPos()
	end	
end

--ÓÎÏ·´°¿Ú³ß´ç±ä»¯
--ÓÎÏ··Ö±æÂÊ±ä»¯
function HigntlightProcess2_On_ResetPos()
    Higntlight_Process2_Frame:SetProperty("UnifiedPosition", g_HigntlightProcess_Frame_UnifiedPosition);
end

--ÉèÖÃUI
function Higntlight_Process2_UpdateUI(tname,tskillType)
	Higntlight_Process2_HideAllSkillTitle();
	--ºóĞøÈôÓĞÆäËû¼¼ÄÜÒªÌí¼Ó ĞèÒªÔÚ âÀï×ö²¹³ä
    if tskillType == g_NuHuoLianZhan then
		Higntlight_Process2_AnimateNuhuo:Show();
		Higntlight_Process2_AnimateNuhuo:Play(true);
		Higntlight_Process2_TitleNuhuo:Show();
	elseif tskillType == g_XiShanXingLv then
		Higntlight_Process2_AnimateXishan:Show();
		Higntlight_Process2_AnimateXishan:Play(true);
		Higntlight_Process2_TitleXishan:Show();
	end
	Higntlight_Process2_Name:SetText(tname);
end
--Òş²ØËùÓĞ¼¼ÄÜtitle
function Higntlight_Process2_HideAllSkillTitle()
	--ºóĞøÈôÓĞÆäËû¼¼ÄÜÒªÌí¼Ó ĞèÒªÔÚ âÀï×ö²¹³ä
	Higntlight_Process2_TitleNuhuo:Hide();
	Higntlight_Process2_TitleXishan:Hide();
	
	Higntlight_Process2_AnimateNuhuo:Hide();
	Higntlight_Process2_AnimateXishan:Hide();
end
--Òş²Ø
function Higntlight_Process2_OnHiden()
	this:Hide()
	Higntlight_Process2_HideAllSkillTitle();
end
--¹Ø± °´Å¥
function Higntlight_Process2_Close()
	this:Hide();
	Higntlight_Process2_HideAllSkillTitle();
end
