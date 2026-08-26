
local g_Phoenix_RankSmall_UnifiedPosition = nil 

local g_Phoenix_RankSmall_CampName = 
{
	[1] = "#{FHKF_20240315_89}",
	[2] = "#{FHKF_20240315_90}",
	[3] = "#{FHKF_20240315_91}",
	[4] = "#{FHKF_20240315_92}",
}

local g_Phoenix_RankSmall_UI = 
{

}

local g_Phoenix_RankSmall_state = 0

function Phoenix_RankSmall_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("TSPHOENIX_CAMP")
	this:RegisterEvent("TSPHOENIX_CAMP_SWITCH")

end 




-- Phoenix_RankSmall_RankSmall_BK03 => TLBB_Frame2
-- Phoenix_RankSmall_RankSmall_Bang => TLBB_StaticImageNULL
-- Phoenix_RankSmall_RankSmall_BK => TLBB_Frame2
-- Phoenix_RankSmall_RankSmall_BK04 => TLBB_Frame2
-- Phoenix_RankSmall_RankSmall_BK02 => TLBB_Frame2
-- Phoenix_RankSmall_RankSmall_BK01 => TLBB_Frame2
-- Phoenix_RankSmall_RankSmall_Help_Bk => TLBB_StaticImageNULL
function Phoenix_RankSmall_OnLoad()
	g_Phoenix_RankSmall_UnifiedPosition = Phoenix_RankSmall:GetProperty("UnifiedPosition");

	g_Phoenix_RankSmall_UI[1] = 
	{
		rank = Phoenix_RankSmall_Position01,
		name = Phoenix_RankSmall_GuildText01,
		score = Phoenix_RankSmall_ScoreText01,
	}

	g_Phoenix_RankSmall_UI[2] = 
	{
		rank = Phoenix_RankSmall_Position02,
		name = Phoenix_RankSmall_GuildText02,
		score = Phoenix_RankSmall_ScoreText02,
	}

	g_Phoenix_RankSmall_UI[3] = 
	{
		rank = Phoenix_RankSmall_Position03,
		name = Phoenix_RankSmall_GuildText03,
		score = Phoenix_RankSmall_ScoreText03,
	}


	g_Phoenix_RankSmall_UI[4] = 
	{
		rank = Phoenix_RankSmall_Position04,
		name = Phoenix_RankSmall_GuildText04,
		score = Phoenix_RankSmall_ScoreText04,
	}
end

function Phoenix_RankSmall_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Phoenix_RankSmall_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Phoenix_RankSmall_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Phoenix_RankSmall_On_Hide()
	elseif(event == "TSPHOENIX_CAMP") then
		local time = tonumber(arg0)
		local stage = tonumber(arg1)
		g_Phoenix_RankSmall_state = stage
		if time == 5000 then
			
			Phoenix_RankSmall_WatchText:SetProperty("Timer", 0)
			Phoenix_RankSmall_Init()
			Phoenix_RankSmall_Open()
			return
		end
		if stage == 0 then
			Phoenix_RankSmall_WatchInfo:SetText("#{FHKF_20240315_149}")
		else
			Phoenix_RankSmall_WatchInfo:SetText("#{FHKF_20240315_164}")
		end
		--PushDebugMessage("time="..time)
		Phoenix_RankSmall_WatchText:SetProperty("TextColor","FF00FF00")
		Phoenix_RankSmall_WatchText:SetProperty("Timer", 1800 - time)
		Phoenix_RankSmall_Init()
		if IsWindowShow("Phoenix_Rank") == false then
			Phoenix_RankSmallClose:Hide()
			Phoenix_RankSmallOpen:Show()			
			this:Show()
		end
	elseif(event == "TSPHOENIX_CAMP_SWITCH") then
		-- Phoenix_RankSmall_Init()
		 local opType = tonumber(arg0)
		 if opType == 2 then
			Phoenix_RankSmallClose:Hide()
			Phoenix_RankSmallOpen:Show()
		-- else
		-- 	this:Hide()
		 end		

	end
end

function Phoenix_RankSmall_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Phoenix_RankSmall");
end

function Phoenix_RankSmall_On_ResetPos()
	Phoenix_RankSmall:SetProperty("UnifiedPosition", g_Phoenix_RankSmall_UnifiedPosition)
end

function Phoenix_RankSmall_On_Hide()
	this:Hide()
end

function Phoenix_RankSmall_Init()
	local data = DataPool:Lua_GetTSPhoenixCamp()
	for i,v in ipairs(data) do
		if v.m_nRank <= 0 then
			Phoenix_RankSmall_format(i,g_Phoenix_RankSmall_CampName[i],0)
		else
			Phoenix_RankSmall_format(v.m_nRank,g_Phoenix_RankSmall_CampName[i],v.m_nCScore+v.m_nFScore);		
		end
	end

end

function Phoenix_RankSmall_format(index,name,score)
	--PushDebugMessage("index="..index)
	g_Phoenix_RankSmall_UI[index].rank:SetText(index)
	g_Phoenix_RankSmall_UI[index].name:SetText(name)
	g_Phoenix_RankSmall_UI[index].score:SetText(Phoenix_RankSmall_formatcolor(score).."#W/5000")
end

function Phoenix_RankSmall_formatcolor(score)
	if score >= 0 and score <= 1000 then
		return "#G"..score
	elseif score >= 1001 and score <= 2000 then
		return "#Y"..score
	elseif score >= 2001 and score <= 4000 then
		return "#cff9900"..score
	else
		return "#cFF0000"..score
	end
end
function Phoenix_RankSmall_Open()
	Phoenix_RankSmallClose:Show()
	Phoenix_RankSmallOpen:Hide()
	PushEvent("TSPHOENIX_CAMP_SWITCH",1,g_Phoenix_RankSmall_state)
end

function Phoenix_RankSmall_Close()

	PushEvent("TSPHOENIX_CAMP_SWITCH",2,g_Phoenix_RankSmall_state)

end