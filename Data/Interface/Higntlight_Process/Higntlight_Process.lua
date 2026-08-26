--Higntlight_Process.lua
--参数
local g_HigntlightProcess_Frame_UnifiedPosition;
local g_NuHuoLianZhan = 1;
local g_XiShanXingLv = 2;
--后续若有其他技能要添加 需要在这里做补充

function Higntlight_Process_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	--打开技能高光
	this:RegisterEvent("SHOW_HIGHLIGHT_SKILL");
	--场景切换
	this:RegisterEvent("ON_SCENE_TRANS");
	--玩家离开世界
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS");
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");	
end

function Higntlight_Process_OnLoad()
	this:Hide();
	Higntlight_Process_HideAllSkillTitle();--默认情况关闭两个技能的title 只有在取队列时 按照获取到的信息 开启对应的技能title
	g_HigntlightProcess_Frame_UnifiedPosition = Higntlight_Process_Frame:GetProperty("UnifiedPosition");
	SetTimer("Higntlight_Process", "HigntlightProcess_GetMsgTimer()", 6000);--6秒取一次队列
end


function Higntlight_Process_OnEvent(event)
	if event == "UI_COMMAND" then
	elseif event == "SHOW_HIGHLIGHT_SKILL" then
		--收到消息包进队列触发的事件 
		if(this:IsVisible()) then
			--处于某玩家高光 这里就什么都不做 让timer走原来的顺序
			return;
		else
			--当前没有处于某个玩家高光显示时间 则在收到消息的时候 关闭所有timer 显示队列中第一个玩家高光 并且开启新的timer
			KillTimer("HigntlightProcess_GetMsgTimer()");
			KillTimer("HigntlightProcess_CloseUITimer()");
			HigntlightProcess_GetMsgTimer();
			SetTimer("Higntlight_Process", "HigntlightProcess_GetMsgTimer()", 6000);
		end
	elseif event == "ON_SCENE_TRANS" then
		HigntlightProcess_ClearQueue();
	elseif event == "PLAYER_LEAVE_WORLD" then
		HigntlightProcess_ClearQueue();

	elseif (event == "ADJEST_UI_POS" ) then
        HigntlightProcess_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
        HigntlightProcess_On_ResetPos()
	end	
end

--游戏窗口尺寸变化
--游戏分辨率变化
function HigntlightProcess_On_ResetPos()
    Higntlight_Process_Frame:SetProperty("UnifiedPosition", g_HigntlightProcess_Frame_UnifiedPosition);
end

--获取队列信息并且设置UI 定时器 定时调用client中接口 以及HigntlightProcess_UpdateUI()
function HigntlightProcess_GetMsgTimer()
    local ret,name,guid,menpai,skillType = HighLight:Lua_GetHLSkillQueFront();
	if ret == 0 then--高光技能队列空
		return;
	end
	HigntlightProcess_UpdateUI(name,skillType);
	--判断guid 是自己的 就生成超链
	if (guid == Player:GetGUID()) then
		HighLight:Lua_ShareHLSkill(guid,name,menpai,skillType);
		--醒目提示 只给触发高光的玩家出醒目提示
		if skillType ==  g_NuHuoLianZhan then
			PushDebugMessage("#{GGSK_221221_62}");
		elseif skillType ==  g_XiShanXingLv then
			PushDebugMessage("#{GGSK_221221_63}");
		end
	end
	SetTimer("Higntlight_Process", "HigntlightProcess_CloseUITimer()", 5000);--5秒后自动关闭
	this:Show();
end
--每次显示一段时间 （时间待定）就关闭UI 定时器 
function HigntlightProcess_CloseUITimer()
	KillTimer("HigntlightProcess_CloseUITimer()");
	--关闭动画与界面
	Higntlight_Process_HideAllSkillTitle();
	this:Hide()
end
--清空队列 调用client中接口
function HigntlightProcess_ClearQueue()
	KillTimer("HigntlightProcess_CloseUITimer()"); --无论当前是否有高光在显示 既然清空队列了 那肯定是要关闭整个高光 所以不用再走关闭UI的Timer 也手动关闭
	Higntlight_Process_HideAllSkillTitle();
	this:Hide();
	HighLight:Lua_ClearHLSkillQue();
end
--设置UI
function HigntlightProcess_UpdateUI(tname,tskillType)
	--后续若有其他技能要添加 需要在这里做补充
	--显示出现动画
	Higntlight_Process_HideAllSkillTitle();
    if tskillType == g_NuHuoLianZhan then
		Higntlight_Process_AnimateNuhuo:Show();
		Higntlight_Process_AnimateNuhuo:Play(true);
		Higntlight_Process_TitleNuhuo:Show();
	elseif tskillType == g_XiShanXingLv then
		Higntlight_Process_AnimateXishan:Show();
		Higntlight_Process_AnimateXishan:Play(true);
		Higntlight_Process_TitleXishan:Show();
	end
	Higntlight_Process_Name:SetText(tname);
end
--隐藏所有技能title
function Higntlight_Process_HideAllSkillTitle()
	--后续若有其他技能要添加 需要在这里做补充
	Higntlight_Process_TitleNuhuo:Hide();
	Higntlight_Process_TitleXishan:Hide();

	Higntlight_Process_AnimateNuhuo:Hide();
	Higntlight_Process_AnimateXishan:Hide();
end
--隐藏
function Higntlight_Process_OnHiden()
	this:Hide();
end