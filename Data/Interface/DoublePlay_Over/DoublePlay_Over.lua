local g_DoublePlay_Over_Frame_UnifiedPosition
local DoublePlay_TeamStr= 
{
	[1] = "#{SRWF_230329_217}",
	[2] = "#{SRWF_230329_218}",
	[3] = "#{SRWF_230329_219}",
	[4] = "#{SRWF_230329_220}",
	[5] = "#{SRWF_230329_221}",
}
local DoublePlay_YuPei= {150,120,90,75,60}
local DoublePlay_PaiHangBang= {10,8,6,3,1}

local g_DoublePlay_Over_PlayName = {}
local DoublePlay_Over_Name = {}
local DoublePlay_Over_RankText1 = {}
local DoublePlay_Over_RankText2 = {}
local DoublePlay_Over_YUPEI = {}
local DoublePlay_Over_PaiHangBang = {}


function DoublePlay_Over_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)

end


function DoublePlay_Over_OnLoad()

	g_DoublePlay_Over_Frame_UnifiedPosition = DoublePlay_Over_Frame:GetProperty("UnifiedPosition")

	DoublePlay_Over_Name[1]  = DoublePlay_Over_Team1Name
	DoublePlay_Over_Name[2]  = DoublePlay_Over_Team1Name2
	DoublePlay_Over_Name[3]  = DoublePlay_Over_Team2Name
	DoublePlay_Over_Name[4]  = DoublePlay_Over_Team2Name2
	DoublePlay_Over_Name[5]  = DoublePlay_Over_Team3Name
	DoublePlay_Over_Name[6]  = DoublePlay_Over_Team3Name2
	DoublePlay_Over_Name[7]  = DoublePlay_Over_Team4Name
	DoublePlay_Over_Name[8]  = DoublePlay_Over_Team4Name2
	DoublePlay_Over_Name[9]  = DoublePlay_Over_Team5Name
	DoublePlay_Over_Name[10] = DoublePlay_Over_Team5Name2

	DoublePlay_Over_RankText1[1] = DoublePlay_Over_Team1Number
	DoublePlay_Over_RankText1[2] = DoublePlay_Over_Team2Number
	DoublePlay_Over_RankText1[3] = DoublePlay_Over_Team3Number
	DoublePlay_Over_RankText1[4] = DoublePlay_Over_Team4Number
	DoublePlay_Over_RankText1[5] = DoublePlay_Over_Team5Number

	DoublePlay_Over_RankText2[1] = DoublePlay_Over_Team1Team
	DoublePlay_Over_RankText2[2] = DoublePlay_Over_Team2Team
	DoublePlay_Over_RankText2[3] = DoublePlay_Over_Team3Team
	DoublePlay_Over_RankText2[4] = DoublePlay_Over_Team4Team
	DoublePlay_Over_RankText2[5] = DoublePlay_Over_Team5Team

	DoublePlay_Over_YUPEI[1] = DoublePlay_Over_Team1Award
	DoublePlay_Over_YUPEI[2] = DoublePlay_Over_Team2Award
	DoublePlay_Over_YUPEI[3] = DoublePlay_Over_Team3Award
	DoublePlay_Over_YUPEI[4] = DoublePlay_Over_Team4Award
	DoublePlay_Over_YUPEI[5] = DoublePlay_Over_Team5Award

	DoublePlay_Over_PaiHangBang[1] = DoublePlay_Over_Team1Num
	DoublePlay_Over_PaiHangBang[2] = DoublePlay_Over_Team2Num
	DoublePlay_Over_PaiHangBang[3] = DoublePlay_Over_Team3Num
	DoublePlay_Over_PaiHangBang[4] = DoublePlay_Over_Team4Num
	DoublePlay_Over_PaiHangBang[5] = DoublePlay_Over_Team5Num

end


function DoublePlay_Over_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99829706) then		
		-----------界面数据---------------
		local RankData1  = Get_XParam_INT(0) --队伍名字
		local RankData2  = Get_XParam_INT(1) --排名情况

		g_DoublePlay_Over_PlayName[1]  = Get_XParam_STR(0) --玩家名字11
		g_DoublePlay_Over_PlayName[2]  = Get_XParam_STR(1) --玩家名字12
		g_DoublePlay_Over_PlayName[3]  = Get_XParam_STR(2) --玩家名字21
		g_DoublePlay_Over_PlayName[4]  = Get_XParam_STR(3) --玩家名字22
		g_DoublePlay_Over_PlayName[5]  = Get_XParam_STR(4) --玩家名字31
		g_DoublePlay_Over_PlayName[6]  = Get_XParam_STR(5) --玩家名字32
		g_DoublePlay_Over_PlayName[7]  = Get_XParam_STR(6) --玩家名字41
		g_DoublePlay_Over_PlayName[8]  = Get_XParam_STR(7) --玩家名字42
		g_DoublePlay_Over_PlayName[9]  = Get_XParam_STR(8) --玩家名字51
		g_DoublePlay_Over_PlayName[10] = Get_XParam_STR(9) --玩家名字52

		--界面信息
		DoublePlay_Over_SetTeamData(RankData1,RankData2)
		--姓名
		DoublePlay_Over_SetNameData(g_DoublePlay_Over_PlayName)

        this:Show()
	elseif event=="HIDE_ON_SCENE_TRANSED"  then
		this:Hide()
    end
	
	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			DoublePlay_Over_ResetPos()
        end
	end
	
end

function DoublePlay_Over_Clicked_Close()
	this:Hide()
end

function DoublePlay_Over_ResetPos()
    DoublePlay_Over_Frame:SetProperty("UnifiedPosition", g_DoublePlay_Over_Frame_UnifiedPosition)
end

--设置队伍数据 轮次 和 排名
function DoublePlay_Over_SetTeamData(RankData1,RankData2)
	
	--队伍名字 RankData1
	local TeamNum = {}
	TeamNum[1] = math.floor(math.mod(RankData1/10000,10))
	TeamNum[2] = math.floor(math.mod(RankData1/1000,10))
	TeamNum[3] = math.floor(math.mod(RankData1/100,10))
	TeamNum[4] = math.floor(math.mod(RankData1/10,10))
	TeamNum[5] = math.floor(math.mod(RankData1/1,10))

	--排名情况 队伍名字
	local TeamRank = {}
	TeamRank[1] = math.floor(math.mod(RankData2/10000,10))
	TeamRank[2] = math.floor(math.mod(RankData2/1000,10))
	TeamRank[3] = math.floor(math.mod(RankData2/100,10))
	TeamRank[4] = math.floor(math.mod(RankData2/10,10))
	TeamRank[5] = math.floor(math.mod(RankData2/1,10))

	for i=1,5 do
		if TeamRank[i] >=1 and TeamRank[i] <= 5 then
			DoublePlay_Over_RankText1[i]:SetText(TeamRank[i])
			DoublePlay_Over_RankText2[i]:SetText(DoublePlay_TeamStr[TeamNum[i]])
			DoublePlay_Over_YUPEI[i]:SetText(ScriptGlobal_Format("#{SRWF_230329_155}",DoublePlay_YuPei[TeamRank[i]]))
			DoublePlay_Over_PaiHangBang[i]:SetText(ScriptGlobal_Format("#{SRWF_230329_156}",DoublePlay_PaiHangBang[TeamRank[i]]))
		else
			DoublePlay_Over_RankText1[i]:SetText("")
			DoublePlay_Over_RankText2[i]:SetText("")
			DoublePlay_Over_YUPEI[i]:SetText("")
			DoublePlay_Over_PaiHangBang[i]:SetText("")
		end

	end

end

--设置队伍数据 轮次 和 排名
function DoublePlay_Over_SetNameData(OverPlayName)

	for i=1,10 do
		DoublePlay_Over_Name[i]:SetText(OverPlayName[i])
	end

end