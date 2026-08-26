-- !!!reloadscript =DuoBao_Rank
local m_Frame_UnifiedXPosition
local m_Frame_UnifiedYPosition

-- 界面控件
local g_DuoBao_Rank_TeamName  = {};
local g_DuoBao_Rank_TeamScore1 = {};
local g_DuoBao_Rank_TeamScore2 = {};
local g_DuoBao_Rank_TeamScore3 = {};
local g_DuoBao_Rank_TeamScore4 = {};
local g_DuoBao_Rank_TeamPrize = {};
local g_DuoBao_Rank_PaiMing = {};

local g_DuoBao_Rank_ItemList = 
{
	[1] = { itemid = 38003303, itemnum = 1, str = "#{DDDB_20240711_284}"},
	[2] = { itemid = 38003304, itemnum = 1, str = "#{DDDB_20240711_285}"},
	[3] = { itemid = 38003308, itemnum = 1, str = "#{DDDB_20240711_286}"},
	[4] = { itemid = 38003309, itemnum = 1, str = "#{DDDB_20240711_287}"},
}

--字典
local g_DuoBao_Rank_TeamNameStr =
{
	[1] = {str = "#{DDDB_20240711_80}"}, --红
	[2] = {str = "#{DDDB_20240711_81}"}, --蓝
	[3] = {str = "#{DDDB_20240711_82}"}, --黄
	[4] = {str = "#{DDDB_20240711_83}"}, --绿
}
local g_DuoBao_Rank_PaiMingStr =
{
	[1] = {str = "#{DDDB_20240711_226}"}, --
	[2] = {str = "#{DDDB_20240711_227}"}, --
	[3] = {str = "#{DDDB_20240711_228}"}, --
	[4] = {str = "#{DDDB_20240711_229}"}, --
}

--预加载函数，可以而且只能在这里注册脚本关心的事件
function DuoBao_Rank_PreLoad()
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
function DuoBao_Rank_OnLoad()
	-- 保存界面的默认相对位置
	m_Frame_UnifiedXPosition	= DuoBao_Rank_Frame:GetProperty("UnifiedXPosition");
	m_Frame_UnifiedYPosition	= DuoBao_Rank_Frame:GetProperty("UnifiedYPosition");

	-- 阵营名
	g_DuoBao_Rank_TeamName[1] = DuoBao_Rank1_List1_2;
	g_DuoBao_Rank_TeamName[2] = DuoBao_Rank1_List2_2;
	g_DuoBao_Rank_TeamName[3] = DuoBao_Rank1_List3_2;
	g_DuoBao_Rank_TeamName[4] = DuoBao_Rank1_List4_2;

	-- BOSS 分数
	g_DuoBao_Rank_TeamScore1[1] = DuoBao_Rank1_List1_3;
	g_DuoBao_Rank_TeamScore1[2] = DuoBao_Rank1_List2_3;
	g_DuoBao_Rank_TeamScore1[3] = DuoBao_Rank1_List3_3;
	g_DuoBao_Rank_TeamScore1[4] = DuoBao_Rank1_List4_3;

	-- 复活 分数
	g_DuoBao_Rank_TeamScore2[1] = DuoBao_Rank1_List1_4;
	g_DuoBao_Rank_TeamScore2[2] = DuoBao_Rank1_List2_4;
	g_DuoBao_Rank_TeamScore2[3] = DuoBao_Rank1_List3_4;
	g_DuoBao_Rank_TeamScore2[4] = DuoBao_Rank1_List4_4;

	-- 最终BOSS 分数
	g_DuoBao_Rank_TeamScore3[1] = DuoBao_Rank1_List1_5;
	g_DuoBao_Rank_TeamScore3[2] = DuoBao_Rank1_List2_5;
	g_DuoBao_Rank_TeamScore3[3] = DuoBao_Rank1_List3_5;
	g_DuoBao_Rank_TeamScore3[4] = DuoBao_Rank1_List4_5;

	-- 总分数
	g_DuoBao_Rank_TeamScore4[1] = DuoBao_Rank1_List1_6;
	g_DuoBao_Rank_TeamScore4[2] = DuoBao_Rank1_List2_6;
	g_DuoBao_Rank_TeamScore4[3] = DuoBao_Rank1_List3_6;
	g_DuoBao_Rank_TeamScore4[4] = DuoBao_Rank1_List4_6;

	-- 奖励
	g_DuoBao_Rank_TeamPrize[1] = DuoBao_Rank1_List1_7;
	g_DuoBao_Rank_TeamPrize[2] = DuoBao_Rank1_List2_7;
	g_DuoBao_Rank_TeamPrize[3] = DuoBao_Rank1_List3_7;
	g_DuoBao_Rank_TeamPrize[4] = DuoBao_Rank1_List4_7;

	--名次
	g_DuoBao_Rank_PaiMing[1] = DuoBao_Rank1_List1_1;
	g_DuoBao_Rank_PaiMing[2] = DuoBao_Rank1_List2_1;
	g_DuoBao_Rank_PaiMing[3] = DuoBao_Rank1_List3_1;
	g_DuoBao_Rank_PaiMing[4] = DuoBao_Rank1_List4_1;
	
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function DuoBao_Rank_ResetPos()
	DuoBao_Rank_Frame:SetProperty("UnifiedXPosition", m_Frame_UnifiedXPosition);
	DuoBao_Rank_Frame:SetProperty("UnifiedYPosition", m_Frame_UnifiedYPosition);
end


--响应事件的函数，当注册的事件发生时会调用的函数
function DuoBao_Rank_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0) == 99947203) then
		local nTeam = 
		{
			[1] = {nRanking=0,nScore1=0,nScore2=0,nScore3=0},
			[2] = {nRanking=0,nScore1=0,nScore2=0,nScore3=0},
			[3] = {nRanking=0,nScore1=0,nScore2=0,nScore3=0},
			[4] = {nRanking=0,nScore1=0,nScore2=0,nScore3=0},
		}
		for i=0,3 do --0,4,8,12
			nTeam[i+1].nRanking = Get_XParam_INT(4*i)
			nTeam[i+1].nScore1 = Get_XParam_INT(4*i+1)
			nTeam[i+1].nScore2 = Get_XParam_INT(4*i+2)
			nTeam[i+1].nScore3 = Get_XParam_INT(4*i+3)
		end
		local nParamSTR0 = Get_XParam_STR(0)
		local nClean = 0
		if nParamSTR0 == "Clean" then
			nClean = 1
		end

		DuoBao_Rank_Show()
		DuoBao_Rank_Update(nTeam,nClean)
	elseif event=="HIDE_ON_SCENE_TRANSED" or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD" then
		DuoBao_Rank_OnHiden()
	end

	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			DuoBao_Rank_ResetPos()
        end
	end
end

--显示UI
function DuoBao_Rank_Show()
	DuoBao_Rank_ClearData()
	this:Show()
end

--隐藏UI
function DuoBao_Rank_OnHiden()
	DuoBao_Rank_ClearData()
	this:Hide()
end

--清除数据
function DuoBao_Rank_ClearData()

end

--更新
function DuoBao_Rank_Update(nTeam,nClean)
	for i=1,4 do
		g_DuoBao_Rank_TeamName[i]:SetText(g_DuoBao_Rank_TeamNameStr[nTeam[i].nRanking].str)
		g_DuoBao_Rank_TeamScore1[i]:SetText(ScriptGlobal_Format("#{DDDB_20240711_85}",nTeam[i].nScore1))
		g_DuoBao_Rank_TeamScore2[i]:SetText(ScriptGlobal_Format("#{DDDB_20240711_85}",nTeam[i].nScore2))
		g_DuoBao_Rank_TeamScore3[i]:SetText(ScriptGlobal_Format("#{DDDB_20240711_85}",nTeam[i].nScore3))
		local nTotalScore = nTeam[i].nScore1 + nTeam[i].nScore2 + nTeam[i].nScore3
		g_DuoBao_Rank_TeamScore4[i]:SetText(ScriptGlobal_Format("#{DDDB_20240711_85}",nTotalScore))
		g_DuoBao_Rank_PaiMing[i]:SetText(g_DuoBao_Rank_PaiMingStr[i].str)
		-- Prize
		-- info
		--local GiftItemID = g_DuoBao_Rank_ItemList[i].itemid
		--local GiftCount = g_DuoBao_Rank_ItemList[i].itemnum
		local GiftStr = g_DuoBao_Rank_ItemList[i].str
		if nTotalScore == 0 then
			--GiftItemID = g_DuoBao_Rank_ItemList[4].itemid
			--GiftCount = g_DuoBao_Rank_ItemList[4].itemnum
			GiftStr = g_DuoBao_Rank_ItemList[4].str
			g_DuoBao_Rank_PaiMing[i]:SetText(g_DuoBao_Rank_PaiMingStr[4].str)
		end

		if nClean == 1 then
			--GiftItemID = g_DuoBao_Rank_ItemList[4].itemid
			--GiftCount = g_DuoBao_Rank_ItemList[4].itemnum
			GiftStr = g_DuoBao_Rank_ItemList[4].str
			g_DuoBao_Rank_PaiMing[i]:SetText("#{DDDB_20240711_242}")
		end

		-- -- icon
		-- local theAction = DataPool:CreateActionItemForShow(GiftItemID, GiftCount)
		-- if theAction:GetID() ~= 0 then
		-- 	g_DuoBao_Rank_TeamPrize[i]:SetActionItem( theAction:GetID() );
		-- end
		g_DuoBao_Rank_TeamPrize[i]:SetText(GiftStr);
	end
end

function DuoBao_Rank_Help()

end

function DuoBao_Rank_Close()
	DuoBao_Rank_OnHiden()
end

function DuoBao_Rank_Exit()

end