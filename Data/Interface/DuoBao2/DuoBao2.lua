-- !!!reloadscript =DuoBao2
local m_Frame_UnifiedXPosition
local m_Frame_UnifiedYPosition

-- 界面控件
local g_DuoBao2_TeamName  = {};
local g_DuoBao2_TeamScore = {};

--字典
local g_DuoBao2_TeamNameStr =
{
	[1] = {str = "#{DDDB_20240711_80}"},
	[2] = {str = "#{DDDB_20240711_81}"},
	[3] = {str = "#{DDDB_20240711_82}"},
	[4] = {str = "#{DDDB_20240711_83}"},
}

--预加载函数，可以而且只能在这里注册脚本关心的事件
function DuoBao2_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function DuoBao2_OnLoad()
	-- 保存界面的默认相对位置
	m_Frame_UnifiedXPosition	= DuoBao2_Frame:GetProperty("UnifiedXPosition");
	m_Frame_UnifiedYPosition	= DuoBao2_Frame:GetProperty("UnifiedYPosition");

	-- 阵营名
	g_DuoBao2_TeamName[1] = DuoBao2_ScoreNo1_Text1;
	g_DuoBao2_TeamName[2] = DuoBao2_ScoreNo2_Text1;
	g_DuoBao2_TeamName[3] = DuoBao2_ScoreNo3_Text1;
	g_DuoBao2_TeamName[4] = DuoBao2_ScoreNo4_Text1;

	-- 阵营 分数
	g_DuoBao2_TeamScore[1] = DuoBao2_ScoreNo1_Text2;
	g_DuoBao2_TeamScore[2] = DuoBao2_ScoreNo2_Text2;
	g_DuoBao2_TeamScore[3] = DuoBao2_ScoreNo3_Text2;
	g_DuoBao2_TeamScore[4] = DuoBao2_ScoreNo4_Text2;
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function DuoBao2_ResetPos()
	DuoBao2_Frame:SetProperty("UnifiedXPosition", m_Frame_UnifiedXPosition);
	DuoBao2_Frame:SetProperty("UnifiedYPosition", m_Frame_UnifiedYPosition);
end


--响应事件的函数，当注册的事件发生时会调用的函数
function DuoBao2_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0) == 99947202) then
		local nTeam = 
		{
			[1] = {nRanking=0,nScore=0},
			[2] = {nRanking=0,nScore=0},
			[3] = {nRanking=0,nScore=0},
			[4] = {nRanking=0,nScore=0},
		}
		for i=0,3 do --0,1,6,7
			nTeam[i+1].nRanking = Get_XParam_INT(2*i)
			nTeam[i+1].nScore = Get_XParam_INT(2*i+1)
		end

		DuoBao2_Show()
		DuoBao2_Update(nTeam)
	elseif event=="HIDE_ON_SCENE_TRANSED" or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD" then
		DuoBao2_OnHiden()
	end

	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			DuoBao2_ResetPos()
        end
	end
end

--显示UI
function DuoBao2_Show()
	DuoBao2_ClearData()
	this:Show()
end

--隐藏UI
function DuoBao2_OnHiden()
	DuoBao2_ClearData()
	this:Hide()
end

--清除数据
function DuoBao2_ClearData()

end

--更新
function DuoBao2_Update(nTeam)
	for i=1,4 do
		g_DuoBao2_TeamName[i]:SetText(g_DuoBao2_TeamNameStr[nTeam[i].nRanking].str)
		local nDamage = 5*nTeam[i].nScore
		g_DuoBao2_TeamScore[i]:SetText(nDamage)
	end
end

function DuoBao2_Help()

end

function DuoBao2_Close()
	DuoBao2_OnHiden()
end