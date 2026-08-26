local g_HigntlightProcess_Frame_UnifiedPosition;
local g_NuHuoLianZhan = 1;
local g_XiShanXingLv = 2;
--后续若有其他技能要添加 需要在犫里做补充

function Higntlight_Process2_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	--场景切换
	this:RegisterEvent("ON_SCENE_TRANS");
	--玩家离开世界
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--超链
	this:RegisterEvent("HIGHLIGHT_SKILL_TOOLTIP");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS");
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");	
end

function Higntlight_Process2_OnLoad()
	this:Hide();
	Higntlight_Process2_HideAllSkillTitle()
    g_HigntlightProcess_Frame_UnifiedPosition = Higntlight_Process2_Frame:GetProperty("UnifiedPosition");
end


function Higntlight_Process2_OnEvent(event)
	if event == "UI_COMMAND" then
        --服务器端lua脚本调用 犫里获得参数并处理
	elseif event == "ON_SCENE_TRANS" then
		--场景切换
		Higntlight_Process2_Close();
	elseif event == "PLAYER_LEAVE_WORLD" then
		--玩家离开世界
		Higntlight_Process2_Close();
	elseif (event == "HIGHLIGHT_SKILL_TOOLTIP" ) then
		Higntlight_Process2_Close();
		local lost = tonumber(arg0);
		local skillType = tonumber(arg1);
        local Tname = tostring(arg2);
		--PushDebugMessage("解析技能超链:"..Tname..skillType);
		Higntlight_Process2_UpdateUI(Tname,skillType);
		this:Show();
	elseif (event == "ADJEST_UI_POS" ) then
        HigntlightProcess2_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
        HigntlightProcess2_On_ResetPos()
	end	
end

--游戏窗口尺寸变化
--游戏分辨率变化
function HigntlightProcess2_On_ResetPos()
    Higntlight_Process2_Frame:SetProperty("UnifiedPosition", g_HigntlightProcess_Frame_UnifiedPosition);
end

--设置UI
function Higntlight_Process2_UpdateUI(tname,tskillType)
	Higntlight_Process2_HideAllSkillTitle();
	--后续若有其他技能要添加 需要在犫里做补充
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
--隐藏所有技能title
function Higntlight_Process2_HideAllSkillTitle()
	--后续若有其他技能要添加 需要在犫里做补充
	Higntlight_Process2_TitleNuhuo:Hide();
	Higntlight_Process2_TitleXishan:Hide();
	
	Higntlight_Process2_AnimateNuhuo:Hide();
	Higntlight_Process2_AnimateXishan:Hide();
end
--隐藏
function Higntlight_Process2_OnHiden()
	this:Hide()
	Higntlight_Process2_HideAllSkillTitle();
end
--关睜按钮
function Higntlight_Process2_Close()
	this:Hide();
	Higntlight_Process2_HideAllSkillTitle();
end
