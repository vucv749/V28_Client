
local g_unifiedposistion

local g_ui_list = {}

local g_camp_info = 
{
	{name="#{ZSYC_241211_146}",image="set:Kunwu_PVP image:Kunwu_PVPTW",},
	{name="#{ZSYC_241211_147}",image="set:Kunwu_PVP image:Kunwu_PVPMQ",},
	{name="#{ZSYC_241211_148}",image="set:Kunwu_PVP image:Kunwu_PVPTH",},
	{name="#{ZSYC_241211_146}",image="set:Kunwu_PVP image:Kunwu_PVPTW",},
}

local g_reward_info = 
{
	level = 
	{
		[1] = { item=nil, num=nil, item2=nil, num2=nil, },
		[2] = { item=nil, num=nil, item2=nil, num2=nil, },
		[3] = { item=nil, num=nil, item2=nil, num2=nil, },
		[4] = { item=nil, num=nil, item2=nil, num2=nil, },
		[5] = { item=nil, num=nil, item2=nil, num2=nil, },
		[6] = { item=nil, num=nil, item2=nil, num2=nil, },
		[7] = { item=nil, num=nil, item2=nil, num2=nil, },
		[8] = { item=39920187, num=1, item2=nil, num2=nil, },
		[9] = { item=39920187, num=1, item2=nil, num2=nil, },
		[10] = { item=39920187, num=1, item2=nil, num2=nil, },
		[11] = { item=39920187, num=1, item2=nil, num2=nil, },
		[12] = { item=39920186, num=1, item2=nil, num2=nil, },
		[13] = { item=39920186, num=1, item2=nil, num2=nil, },
		[14] = { item=39920186, num=1, item2=nil, num2=nil, },

		[15] = { item=39920185, num=1, item2=nil, num2=nil, },
	},
	rank = 
	{
		[1] = { item=38003435, num=8, item2=nil, num2=nil, },
		[2] = { item=38003435, num=5, item2=nil, num2=nil, },
		[3] = { item=38003435, num=3, item2=nil, num2=nil, },
		[4] = { item=nil, num=nil, item2=nil, num2=nil, },
		[5] = { item=nil, num=nil, item2=nil, num2=nil, },
	},
}

local g_camp_max = 3
function Kunwu_PVPResult_PreLoad()
	this:RegisterEvent("PETPVP_UI_BATTLERESULT_SHOW")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function Kunwu_PVPResult_OnLoad()

	-- 保存界面的默认相对位置
	g_ui_list = {
		{mine=Kunwu_PVPResult_Camp2_My,image=Kunwu_PVPResult_Camp2_Title,txt=Kunwu_PVPResult_Camp2_Text1,},
		{mine=Kunwu_PVPResult_Camp1_My,image=Kunwu_PVPResult_Camp1_Title,txt=Kunwu_PVPResult_Camp1_Text1,},
		{mine=Kunwu_PVPResult_Camp3_My,image=Kunwu_PVPResult_Camp3_Title,txt=Kunwu_PVPResult_Camp3_Text1,},
	}

	g_unifiedposistion = Kunwu_PVPResult_Frame:GetProperty("UnifiedPosition")
end

function Kunwu_PVPResult_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		Kunwu_PVPResult_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		Kunwu_PVPResult_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED")	 then
		Kunwu_PVPResult_CloseClicked()
	elseif(event == "PETPVP_UI_BATTLERESULT_SHOW") then
		Kunwu_PVPResult_OnShow()
	end
end

function Kunwu_PVPResult_OnShow()
	local ret = Kunwu_PVPResult_InitUIData()
	if ret > 0 then
		this:Show()
	else
		this:Hide()
	end
end

-- 初始化控件数据
function Kunwu_PVPResult_InitUIData(lastTime)
	for _, ui in (g_ui_list or {}) do
		ui.mine:Hide()
		ui.image:SetProperty("Image", "")
		ui.txt:SetText()
	end
	Kunwu_PVPResult_Award1_1:SetActionItem(-1)
	Kunwu_PVPResult_Award1_2:SetActionItem(-1)
	Kunwu_PVPResult_Award2_1:SetActionItem(-1)
	Kunwu_PVPResult_Award2_2:SetActionItem(-1)

	local level = PETPVP:GetBattleData("LEVEL")
	-- 显示剩余时间
	local leftTime = PETPVP:GetBattleTeamInfo("lefttime")
	if leftTime ~= nil and leftTime > 0 then
		Kunwu_PVPResult_TopList_Time:SetProperty("Timer", leftTime)
	else
		Kunwu_PVPResult_TopList_Time:SetProperty("Timer", 0)
	end
	Kunwu_PVPResult_TopList_Time:SetProperty("TextColor", "FF00FF00")

	-- 显示队伍信息
	local playerCamp = PETPVP:GetBattleTeamInfo("myteam")
	local teamCount = PETPVP:GetBattleTeamInfo("count")
	if (teamCount > 0) then
		for i=1, teamCount, 1 do
			local data = PETPVP:GetBattleTeamInfo("info", i-1)
			if data ~= nil and type(data) == "table" then
				local child = g_ui_list[i]
				if (child ~= nil) then
					-- 是否是自己的狊营					
					
					local campinfo = g_camp_info[data.pos+1]
					if campinfo ~= nil then
						child.image:SetProperty("Image", campinfo.image)
					end

					local strScore = ScriptGlobal_Format("#{ZSYC_241211_161}", data.score)
					child.txt:SetText(strScore)
					
					if playerCamp == data.pos then
						child.mine:Show()

						if level ~= nil then
							local levelReward = g_reward_info.level[level]
							if levelReward ~= nil then
								if levelReward.item ~= nil then
									local action = DataPool:CreateActionItemForShow(levelReward.item, levelReward.num)
									if action:GetID() ~= 0 then
										Kunwu_PVPResult_Award2_1:SetActionItem(action:GetID())
									end
								end
								if levelReward.item2 ~= nil then
									local action = DataPool:CreateActionItemForShow(levelReward.item2, levelReward.num2)
									if action:GetID() ~= 0 then
										Kunwu_PVPResult_Award2_2:SetActionItem(action:GetID())
									end
								end
							end
						end
						
						if data.score > 0 then
							local groupRank = data.rank + 1
							local rankReward = g_reward_info.rank[groupRank]
							if rankReward ~= nil then
								if rankReward.item ~= nil then
									local action = DataPool:CreateActionItemForShow(rankReward.item, rankReward.num)
									if action:GetID() ~= 0 then
										Kunwu_PVPResult_Award1_1:SetActionItem(action:GetID())
									end
								end
								if rankReward.item2 ~= nil then
									local action = DataPool:CreateActionItemForShow(rankReward.item2, rankReward.num2)
									if action:GetID() ~= 0 then
										Kunwu_PVPResult_Award1_2:SetActionItem(action:GetID())
									end
								end
							end

						end
					end
				end
			end
		end
	end


	return 1
end

function Kunwu_PVPResult_OK()
	
end

function Kunwu_PVPResult_TransformName(name, zoneid)
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
function Kunwu_PVPResult_TopList()
	PushEvent("PETPVP_UI_BATTLERANK_SHOW")
end

--================================================
-- 最小化
--================================================
function Kunwu_PVPResult_Mini()
	
end

--================================================
-- 关睜
--================================================
function Kunwu_PVPResult_CloseClicked()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Kunwu_PVPResult_ResetPos()
	Kunwu_PVPResult_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

