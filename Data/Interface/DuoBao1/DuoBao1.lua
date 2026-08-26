local m_Frame_UnifiedXPosition
local m_Frame_UnifiedYPosition

-- 界面控件
local g_DuoBao1_TeamName  = {};
local g_DuoBao1_TeamScore = {};
local g_DuoBao_SKillBtn = {};
local g_DuoBao_MyTeam = {};

--字典
local g_DuoBao1_StepStr1 =
{
	[1] = {str = "#{DDDB_20240711_165}"}, --准备阶段
	[2] = {str = "#{DDDB_20240711_166}"}, --第一阶段
	[3] = {str = "#{DDDB_20240711_169}"}, --第二阶段
	[4] = {str = "#{DDDB_20240711_237}"}, --第二阶段
}
local g_DuoBao1_StepStr2 =
{
	[1] = {str = "#{DDDB_20240711_92}"}, --准备阶段
	[2] = {str = "#{DDDB_20240711_167}"}, --第一阶段
	[3] = {str = "#{DDDB_20240711_170}"}, --第二阶段
	[4] = {str = "#{DDDB_20240711_238}"}, --第二阶段
}
local g_DuoBao1_ShenFenStr =
{
	[1] = {str = "#{DDDB_20240711_89}"},--医师
	[2] = {str = "#{DDDB_20240711_88}"},--探秘侠客
	[3] = {str = "#{DDDB_20240711_87}"},--未选择
}

local g_DuoBao1_TeamNameStr =
{
	[1] = {str = "#{DDDB_20240711_80}"},
	[2] = {str = "#{DDDB_20240711_81}"},
	[3] = {str = "#{DDDB_20240711_82}"},
	[4] = {str = "#{DDDB_20240711_83}"},
}

--图片
local g_DuoBao1_BelongPIC = 
{
	[1] = {image = "set:Buff19 image:Buff19_15"},
	[2] = {image = "set:Buff19 image:Buff19_16"},
	[3] = {image = "set:NewExterior image:NewExterior_jiaobiao_suo_di"},
}

local g_DuoBao1_Step1	 = 1
local g_DuoBao1_Step2	 = 3
local g_DuoBao1_Step3	 = 6

--预加载函数，可以而且只能在这里注册脚本关心的事件
function DuoBao1_PreLoad()
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
function DuoBao1_OnLoad()
	-- 保存界面的默认相对位置
	m_Frame_UnifiedXPosition	= DuoBao1_Frame:GetProperty("UnifiedXPosition");
	m_Frame_UnifiedYPosition	= DuoBao1_Frame:GetProperty("UnifiedYPosition");

	-- 阵营名
	g_DuoBao1_TeamName[1] = DuoBao1_ScoreNo1_2;
	g_DuoBao1_TeamName[2] = DuoBao1_ScoreNo2_2;
	g_DuoBao1_TeamName[3] = DuoBao1_ScoreNo3_2;
	g_DuoBao1_TeamName[4] = DuoBao1_ScoreNo4_2;

	-- 阵营 分数
	g_DuoBao1_TeamScore[1] = DuoBao1_ScoreNo1_3;
	g_DuoBao1_TeamScore[2] = DuoBao1_ScoreNo2_3;
	g_DuoBao1_TeamScore[3] = DuoBao1_ScoreNo3_3;
	g_DuoBao1_TeamScore[4] = DuoBao1_ScoreNo4_3;

	--技能
	g_DuoBao_SKillBtn[1] = DuoBao1_Client2_Skill1;
	g_DuoBao_SKillBtn[2] = DuoBao1_Client2_Skill2;

	g_DuoBao_MyTeam[1] = DuoBao1_ScoreNo1_My;
	g_DuoBao_MyTeam[2] = DuoBao1_ScoreNo2_My;
	g_DuoBao_MyTeam[3] = DuoBao1_ScoreNo3_My;
	g_DuoBao_MyTeam[4] = DuoBao1_ScoreNo4_My;
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function DuoBao1_ResetPos()
	DuoBao1_Frame:SetProperty("UnifiedXPosition", m_Frame_UnifiedXPosition);
	DuoBao1_Frame:SetProperty("UnifiedYPosition", m_Frame_UnifiedYPosition);
end


--响应事件的函数，当注册的事件发生时会调用的函数
function DuoBao1_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0) == 99947201) then
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

		--共用数据
		local step = Get_XParam_INT(8) --阶段
		local nFarmTime = Get_XParam_INT(9) --时间
		local nShenFenParam = Get_XParam_INT(10) --身份
		local nBossNum = Get_XParam_INT(11) --剩余BOSS数量
		local nFlag = Get_XParam_INT(12) --剩余BOSS数量
		local nMyTeam = Get_XParam_INT(13)

		DuoBao1_Show(nShenFenParam)
		DuoBao1_Update(nTeam,step,nFarmTime,nShenFenParam,nBossNum,nFlag,nMyTeam)
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99947204) then
		if(this:IsVisible()) then
			local nShenFenParam = Get_XParam_INT(0) --身份
			DuoBao1_ShowSkill(nShenFenParam)
		end
	elseif event=="HIDE_ON_SCENE_TRANSED" or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD" then
		DuoBao1_OnHiden()
	end

	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			DuoBao1_ResetPos()
        end
	end
end

--显示UI
function DuoBao1_Show(nShenFenParam)
	if(not this:IsVisible() ) then
		DuoBao1_ClearData()
		this:Show()

		DuoBao1_ShowSkill(nShenFenParam)
		--PushDebugMessage("DuoBao1_OnEvent")
	end
end

--隐藏UI
function DuoBao1_OnHiden()
	DuoBao1_ClearData()
	this:Hide()
end

--清除数据
function DuoBao1_ClearData()

end

--更新
function DuoBao1_Update(nTeam,step,nFarmTime,nShenFenParam,nBossNum,nFlag,nMyTeam)
	--更新顶部信息
	DuoBao1_ShowTop(step,nFarmTime,nBossNum,nFlag)
	--更新中部信息
	DuoBao1_ShowMid(nShenFenParam)
	--更新底部信息
	DuoBao1_ShowBotton(nTeam,nMyTeam)
	--更新技能信息
	--DuoBao1_ShowSkill(nShenFenParam)
end

--更新顶部信息
function DuoBao1_ShowTop(step,nFarmTime,nBossNum,nFlag)
	local nStepNum = DuoBao1_GetStepNum(step)
	DuoBao1_Client1_Title:SetText(g_DuoBao1_StepStr1[nStepNum].str)
	if nStepNum == 4 and nFlag ~= 0 then
		DuoBao1_Client1_Text1:SetText("#{DDDB_20240711_239}")
	else
		DuoBao1_Client1_Text1:SetText(g_DuoBao1_StepStr2[nStepNum].str)
	end
	

	if nStepNum == 1 then
		DuoBao1_Client1_Text2:Hide() --剩余BOSS数量
		DuoBao1_Client1_Text3:Hide() --00/16
		-- DuoBao1_Client1_Btn:Hide() --僵尸伤害榜

		DuoBao1_Client1_TimeIcon:Show() --时间
		DuoBao1_Client1_Time:Show()
		DuoBao1_FarmTimer(nFarmTime)
	elseif nStepNum == 2 then
		DuoBao1_Client1_Text2:Show() --剩余BOSS数量
		DuoBao1_Client1_Text3:Show() --00/16 DDDB_20240711_93
		DuoBao1_Client1_Text3:SetText(ScriptGlobal_Format("#{DDDB_20240711_93}",nBossNum))
		-- DuoBao1_Client1_Btn:Hide() --僵尸伤害榜

		DuoBao1_Client1_TimeIcon:Show() --时间
		DuoBao1_Client1_Time:Show()
		DuoBao1_FarmTimer(nFarmTime)
	else
		DuoBao1_Client1_Text2:Hide() --剩余BOSS数量
		DuoBao1_Client1_Text3:Hide()
		-- DuoBao1_Client1_Btn:Hide() --僵尸伤害榜

		if nFlag == 1 or nStepNum == 4 then
			DuoBao1_Client1_TimeIcon:Hide() --时间
			DuoBao1_Client1_Time:Hide()
		else
			DuoBao1_Client1_TimeIcon:Show() --时间
			DuoBao1_Client1_Time:Show()
			DuoBao1_FarmTimer(nFarmTime)
		end
	end
end

--更新中部信息
function DuoBao1_ShowMid(nShenFenParam)
	if nShenFenParam == 1 then
		-- DuoBao1_Client3_Buff:SetProperty("Image",g_DuoBao1_BelongPIC[1].image)
		-- DuoBao1_Client3_Text2:SetText(g_DuoBao1_ShenFenStr[1].str)
		DuoBao1_Client2_ZhiLiao:Show()
		DuoBao1_Client2_ZengShang:Hide()
		DuoBao1_Client2_WeiXuanZe:Hide()
	elseif nShenFenParam == 2 then
		-- DuoBao1_Client3_Buff:SetProperty("Image",g_DuoBao1_BelongPIC[2].image)
		-- DuoBao1_Client3_Text2:SetText(g_DuoBao1_ShenFenStr[2].str)
		DuoBao1_Client2_ZhiLiao:Hide()
		DuoBao1_Client2_ZengShang:Show()
		DuoBao1_Client2_WeiXuanZe:Hide()
	else
		-- DuoBao1_Client3_Buff:SetProperty("Image",g_DuoBao1_BelongPIC[3].image)
		-- DuoBao1_Client3_Text2:SetText(g_DuoBao1_ShenFenStr[3].str)
		DuoBao1_Client2_ZhiLiao:Hide()
		DuoBao1_Client2_ZengShang:Hide()
		DuoBao1_Client2_WeiXuanZe:Show()
	end
end

--更新底部信息
function DuoBao1_ShowBotton(nTeam,nMyTeam)
	for i=1,4 do
		g_DuoBao1_TeamName[i]:SetText(g_DuoBao1_TeamNameStr[nTeam[i].nRanking].str)
		g_DuoBao1_TeamScore[i]:SetText(ScriptGlobal_Format("#{DDDB_20240711_85}",nTeam[i].nScore))
		if nMyTeam == nTeam[i].nRanking then
			g_DuoBao_MyTeam[i]:Show()
		else
			g_DuoBao_MyTeam[i]:Hide()
		end
	end
end


function DuoBao1_GetStepNum(step)
	local nNum = 1
	if step <= g_DuoBao1_Step1 then
		nNum = 1
	elseif step > g_DuoBao1_Step1 and step <= g_DuoBao1_Step2 then
		nNum = 2
	elseif step > g_DuoBao1_Step2 and step <= g_DuoBao1_Step3 then
		nNum = 3
	else
		nNum = 4
	end

	return nNum
end

function DuoBao1_FarmTimer(countTime)

	if countTime < 0 then
		countTime = 0
	end

	local minuteTime = math.floor(countTime/60)
	local secTime = math.mod(countTime,60)

	local strMinute = tostring(minuteTime)
	if minuteTime < 10 then
		strMinute = "0"..tostring(minuteTime)
	end
	
	local strSec = tostring(secTime)
	if secTime < 10 then
		strSec = "0"..tostring(secTime)
	end
	
    --#cfff263副本攻略时间：#G%s0：%s1#cfff263
    DuoBao1_Client1_Time:SetText(ScriptGlobal_Format("#{DDDB_20240711_90}",strMinute,strSec))

end

function DuoBao1_Help()

end

function DuoBao1_MiniButton()

end

function DuoBao1_Client1_Btn()

end

--技能
function DuoBao1_Client2_Skill(nIndex)
	local  tmpItem = g_DuoBao_SKillBtn[nIndex]:GetActionItem();
	--PushDebugMessage("nIndex="..nIndex.." tmpItem="..tmpItem)
	g_DuoBao_SKillBtn[nIndex]:DoAction();
end

--更新
function DuoBao1_ShowSkill(nShenFenParam)
	local nSkillList ={-1,-1}
	if nShenFenParam == 1 then
		nSkillList[1] = 4987
		nSkillList[2] = 4990
		DuoBao1_Client2_Skill1_Img:Show()
		DuoBao1_Client2_Skill2_Img:Hide()
	elseif nShenFenParam == 2 then
		nSkillList[1] = 4988
		nSkillList[2] = 4989
		DuoBao1_Client2_Skill1_Img:Hide()
		DuoBao1_Client2_Skill2_Img:Show()
	else
		nSkillList[1] = 4988
		nSkillList[2] = 4990
		DuoBao1_Client2_Skill1_Img:Hide()
		DuoBao1_Client2_Skill2_Img:Hide()
	end

	--技能信息
	--默认没技能
	for index=1,table.getn(g_DuoBao_SKillBtn)  do
		--空技能
		g_DuoBao_SKillBtn[index]:SetActionItem(-1);
	end
	for index=1,2  do
		if nSkillList[index] > 0 then
			local theAction = CreateDuoBaoSkillAction(nSkillList[index]);
			theAction:SetLockStatus(1)
			--PushDebugMessage("theAction:GetID()="..theAction:GetID())
			if theAction:GetID() ~= 0 then
				g_DuoBao_SKillBtn[index]:SetActionItem(theAction:GetID());
			end
		end
	end
end

--Help
function DuoBao1_Client1_ShowHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ShowHelp" )
		Set_XSCRIPT_ScriptID( 999472 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--RankList
function DuoBao1_Client4_ClickBtn()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "RankList" )
		Set_XSCRIPT_ScriptID( 999472 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end