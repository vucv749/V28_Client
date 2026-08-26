-- 分数界面
local g_unifiedposistion

local g_ui_list = {}

local g_camp_info = 
{
	{name="#{ZSYC_241211_146}",},
	{name="#{ZSYC_241211_147}",},
	{name="#{ZSYC_241211_148}",},
	{name="#{ZSYC_241211_146}",},
}

local g_rank_info = {
	{image="set:DaHua_PVP image:DaHua_PVP_No1",},
	{image="set:DaHua_PVP image:DaHua_PVP_No2",},
	{image="set:DaHua_PVP image:DaHua_PVP_No3",},
}

local g_battle_fightState = {
    hand_noactive = 1,                  -- 上交点未激活
    hand_active = 2,                    -- 上交点激活
    hand_sec_active = 3,                -- 第二轮上交点
    hand_final_active = 4,              -- 第二轮上交点
}

function Kunwu_PVPScore_PreLoad()
	this:RegisterEvent("PETPVP_UI_BATTLESCORE_SHOW")
	this:RegisterEvent("PETPVP_UI_FRESHATTR", false)
	this:RegisterEvent("PETPVP_UI_BATTLERESULT_SHOW", false)
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
end

function Kunwu_PVPScore_OnLoad()

	g_ui_list = {}
	-- 保存界面的默认相对位置
	g_unifiedposistion = Kunwu_PVPScore_Frame:GetProperty("UnifiedPosition")
end

function Kunwu_PVPScore_OnEvent(event)
	if(event == "PETPVP_UI_BATTLESCORE_SHOW") then
		Kunwu_PVPScore_OnShow()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		Kunwu_PVPScore_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		Kunwu_PVPScore_CloseClicked()
	elseif (event == "PETPVP_UI_BATTLERESULT_SHOW") then
		Kunwu_PVPScore_CloseClicked()
	elseif ( event == "ADJEST_UI_POS" ) then
		Kunwu_PVPScore_ResetPos()
	elseif (event == "PETPVP_UI_FRESHATTR") then
		Kunwu_PVPScoreTask_AttrUIRefresh()
	end
end

function Kunwu_PVPScore_OnShow()
	local ret = Kunwu_PVPScore_InitUIData()
	if ret > 0 then
		if IsWindowShow("Kunwu_PVPScoreMini") then
			this:Hide()
		else
			this:Show()
		end
	else
		this:Hide()
	end
end

-- 初始化控件数据
function Kunwu_PVPScore_InitUIData(lastTime)

	-- 获取一些基础信息
	local level = PETPVP:GetBattleData("LEVEL")
	local exp = PETPVP:GetBattleData("EXP")
	local expmax = PETPVP:GetBattleData("NEEDEXP")
	if expmax <= 0 then
		expmax = 1
	end

	local levelmax = PETPVP:GetBattleTeamInfo("levelmax")
	-- 等级
	local strLevel = ScriptGlobal_Format("#{ZSYC_241211_139}", level)
	Kunwu_PVPScore_Num:SetText(strLevel)
	-- 经验
	if level >= levelmax then
		Kunwu_PVPScore_Level:SetText("#{ZSYC_241211_244}")
	else
		local strExp = ScriptGlobal_Format("#{ZSYC_241211_140}", exp, expmax)
		Kunwu_PVPScore_Level:SetText(strExp)
	end

	-- 显示剩余时间
	local leftTime = PETPVP:GetBattleTeamInfo("lefttime")
	if leftTime ~= nil and leftTime > 0 then
		Kunwu_PVPScore_Text_Time:SetProperty("Timer", leftTime)
	else
		Kunwu_PVPScore_Text_Time:SetProperty("Timer", 0)
	end
	Kunwu_PVPScore_Text_Time:SetProperty("TextColor", "FF00FF00")

	local finalState = PETPVP:GetBattleTeamInfo("finalstate")
	
	if finalState == g_battle_fightState.hand_noactive then
		Kunwu_PVPScore_Text2:SetText("#{ZSYC_241211_253}")
		Kunwu_PVPScore_Text:SetText("#{ZSYC_241211_254}")
	elseif finalState == g_battle_fightState.hand_active then
		Kunwu_PVPScore_Text2:SetText("#{ZSYC_241211_255}")
		Kunwu_PVPScore_Text:SetText("#{ZSYC_241211_256}")
	elseif finalState == g_battle_fightState.hand_sec_active then
		Kunwu_PVPScore_Text2:SetText("#{ZSYC_241211_257}")
		Kunwu_PVPScore_Text:SetText("#{ZSYC_241211_141}")
	else
		Kunwu_PVPScore_Text2:SetText("#{ZSYC_241211_258}")
		Kunwu_PVPScore_Text:SetText("#{ZSYC_241211_243}")
	end

	-- 显示队伍信息
	local playerCamp = PETPVP:GetBattleTeamInfo("myteam")
	local teamCount = PETPVP:GetBattleTeamInfo("count")
	Kunwu_PVPScore_TopList_ListFrame:Clear()
	if (teamCount > 0) then
		for i=1, teamCount, 1 do
			local data = PETPVP:GetBattleTeamInfo("info", i-1)
			if data ~= nil and type(data) == "table" then
				local child = Kunwu_PVPScore_TopList_ListFrame:AddChild("Kunwu_PVPScore_TopList_List_Item")
				if (child ~= nil) then
					-- 是否是自己的阵营					
					--local strRank = "#cfff263"..tostring(i)
					local strCampName = g_camp_info[i].name
					if g_camp_info[data.pos+1] ~= nil then
						strCampName = g_camp_info[data.pos+1].name
					end
					local strScore = ScriptGlobal_Format("#{ZSYC_241211_149}", data.score)
					--child:GetSubItem("Kunwu_PVPScore_TopList_List_Rank"):SetText(strRank)
					child:GetSubItem("Kunwu_PVPScore_TopList_List_Name"):SetText(strCampName)
					child:GetSubItem("Kunwu_PVPScore_TopList_List_Score"):SetText(strScore)

					local rankImage = g_rank_info[i]
					if rankImage ~= nil then
						child:GetSubItem("Kunwu_PVPScore_TopList_List_Rank"):SetProperty("Image", rankImage.image)
					else
						child:GetSubItem("Kunwu_PVPScore_TopList_List_Rank"):SetProperty("Image", "")
					end

					if playerCamp == data.pos then
						child:GetSubItem("Kunwu_PVPScore_TopList_List_ItemBK"):Show()
					else
						child:GetSubItem("Kunwu_PVPScore_TopList_List_ItemBK"):Hide()
					end
				end
			end
		end
	end

	return 1
end


function Kunwu_PVPScore_OK()
	
end

function Kunwu_PVPScore_TransformName(name, zoneid)
	if zoneid < 0 then
		return name
	end

	local retname = name
	if g_trasname > 0 then
		local selfzoneid = DataPool:GetSelfZoneWorldID()
		if selfzoneid ~= zoneid then
			local serverName = DataPool:GetServerName( zoneid )
			retname = name.."@"..tostring(serverName)
		end
	end

	return retname
end

--================================================
-- 开启个人榜
--================================================
function Kunwu_PVPScore_TopListClick()
	PushEvent("PETPVP_UI_BATTLERANK_SHOW")
end

--================================================
-- 最小化
--================================================
function Kunwu_PVPScore_MiniClick()
	PushEvent("PETPVP_UI_BATTLEMINI_SHOW")
end

--================================================
-- 关闭
--================================================
function Kunwu_PVPScore_CloseClicked()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Kunwu_PVPScore_ResetPos()
	Kunwu_PVPScore_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

function Kunwu_PVPScoreTask_AttrUIRefresh()
	Kunwu_PVPScore_InitUIData()
end