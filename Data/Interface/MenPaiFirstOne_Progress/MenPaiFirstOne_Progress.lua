
local MenPaiFirstOne_Progress_Battle_OneTimeBegin = 10090  --MenPaiFirstOne_Progress.lua ???????
local MenPaiFirstOne_Progress_Battle_OneTimeEnd = 10390
local MenPaiFirstOne_Progress_Battle_TwoTimeBegin = 10450
local MenPaiFirstOne_Progress_Battle_TwoTimeEnd = 10750
local MenPaiFirstOne_Progress_Battle_ThreeTimeBegin = 10810
local MenPaiFirstOne_Progress_Battle_ThreeTimeEnd = 11110
local MenPaiFirstOne_Progress_Battle_FourTimeBegin = 11170
local MenPaiFirstOne_Progress_Battle_FourTimeEnd = 11470--MenPaiFirstOne_Progress.lua ???????

local MenPaiFirstOne_Progress_Lost = "set:HSLJ_01 image:HSLJ_Lost"
local MenPaiFirstOne_Progress_Winer = "set:HSLJ_01 image:HSLJ_Winer"

local g_MenPaiFirstOne_Progress_Frame_UnifiedXPosition;
local g_MenPaiFirstOne_Progress_Frame_UnifiedYPosition;
function MenPaiFirstOne_Progress_PreLoad()
	this:RegisterEvent("REFRESH_DDZ_MULTI_SCORE");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SHOW_DDZWAR_MINI");
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

local g_enPaiFirstOne_Progress_menpaiInfo = {
	"Thiªu Lâm",
	"Minh Giáo",
	"Cái Bang",
	"Võ Ðang",
	"Nga Mi",
	"Tinh Túc",
	"Thiên Long",
	"Thiên S½n",
	"Tiêu dao",
	"Tñ do",
	"MÕn Ðà"
};

function MenPaiFirstOne_Progress_OnLoad()
	g_MenPaiFirstOne_Progress_Frame_UnifiedXPosition	= MenPaiFirstOne_Progress_Frame : GetProperty("UnifiedXPosition");
	g_MenPaiFirstOne_Progress_Frame_UnifiedYPosition	= MenPaiFirstOne_Progress_Frame : GetProperty("UnifiedYPosition");
		
end

function MenPaiFirstOne_Progress_OnEvent(event)

	if (event=="SCENE_TRANSED") then
        if (584 ~= GetSceneID()) then
			CMenPaiDiYiData:ClearDDZData()
			this:Hide()
			return
		end
		
		if arg0=="Hjyanmenguan_PVP" then --?????????
			local myRet, myName, myCamp, myHp, myMaxHp = CMenPaiDiYiData:GetMyScore()
	        if myRet == 1 then
				MenPaiFirstOne_Progress_Left1PlayerHP:SetProgress(myHp, myMaxHp)
				this:Show()
			end
			local targetRet, targetName, targetCamp, targetHp, targetMaxHp = CMenPaiDiYiData:GetTargetScore()
			if targetRet == 1 then
				MenPaiFirstOne_Progress_Right1PlayerHP:SetProgress(targetHp, targetMaxHp)
				this:Show()
			end
			MenPaiFirstOne_Progress_Battle_Fresh()
		else
			this:Hide()
		end
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event=="SHOW_DDZWAR_MINI") then
		if (584 ~= GetSceneID()) then  
			return
		end
		
		if arg0~="0" then
			return
		end

		MenPaiFirstOne_Progress_Battle_Fresh()
		this:Show()
		
	elseif (event=="REFRESH_DDZ_MULTI_SCORE") then
		MenPaiFirstOne_Progress_Battle_Fresh()
	elseif (event == "ADJEST_UI_POS" ) then
		MenPaiFirstOne_Progress_Frame_On_ResetPos();
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		MenPaiFirstOne_Progress_Frame_On_ResetPos();
	end
end

function MenPaiFirstOne_Progress_Open()
        CMenPaiDiYiData:OpenRedBlueWarMulti()
        this:Hide()
end

function MenPaiFirstOne_Progress_Help1()
	local str = "#{XSLDZ_180521_238}"
end

function MenPaiFirstOne_Progress_Help2()
end


function MenPaiFirstOne_Progress_Battle_Fresh()	

	local myRet, myName, myCamp, myHp, myMaxHp, myMenpai, mylevel = CMenPaiDiYiData:GetMyScore()
	local targetRet, targetName, targetCamp, targetHp, targetMaxHp, targetMenpai, targetlevel = CMenPaiDiYiData:GetTargetScore()

	local nTick = CMenPaiDiYiData:GetTick()
	local szMsg = g_enPaiFirstOne_Progress_menpaiInfo[myMenpai+1];
	local unitId= CMenPaiDiYiData:GetUnitId() --unitId=0??16? unitId=1??8? unitId=2??4? unitId=3????
	local tips
	if unitId == 0 then
		tips = ScriptGlobal_Format("#{DYRCN_220427_10}",szMsg,"16","8")
	elseif  unitId == 1 then
		tips = ScriptGlobal_Format("#{DYRCN_220427_10}",szMsg,"8","4")
	elseif  unitId == 2 then
		tips = ScriptGlobal_Format("#{DYRCN_220427_10}",szMsg,"4","2")
	elseif  unitId == 3 then
		tips = ScriptGlobal_Format("#{DYRCN_220427_10}",szMsg,"2","1")
	end
	MenPaiFirstOne_Progress_DragTitle:SetText(tips)
	MenPaiFirstOne_Progress_Left1Name:SetText(myName)
	MenPaiFirstOne_Progress_Left1Score:SetText(mylevel)
	MenPaiFirstOne_Progress_Right1Name:SetText(targetName)
	MenPaiFirstOne_Progress_Right1Score:SetText(targetlevel)

	MenPaiFirstOne_Progress_Left1PlayerHP:SetProgress(myHp, myMaxHp)
	MenPaiFirstOne_Progress_Right1PlayerHP:SetProgress(targetHp, targetMaxHp)
	if nTick > 10000 and nTick < 20000 then
		nTick = 120 - nTick + 10020 
	else
		nTick = -1
	end
	if  nTick >= 0 then
		MenPaiFirstOne_Progress_WatchText:Hide()
		MenPaiFirstOne_Progress_TimeWatch:Show()
		MenPaiFirstOne_Progress_TimeWatch:SetProperty("Timer", tonumber(nTick));
	else
		MenPaiFirstOne_Progress_WatchText:Show()
		MenPaiFirstOne_Progress_TimeWatch:Hide()
		--MenPaiFirstOne_Progress_TimeWatch:SetProperty("Timer", tonumber(0));
	end

	local nResult = CMenPaiDiYiData:GetResult()
	if nResult == 1 then
		if myCamp == 156 then
			MenPaiFirstOne_Progress_Team1Win:Show()
			MenPaiFirstOne_Progress_Team2Win:Hide()
			MenPaiFirstOne_Progress_Team1Draw:Hide()
			MenPaiFirstOne_Progress_Team2Draw:Hide()
			MenPaiFirstOne_Progress_Team1Fail:Hide()
			MenPaiFirstOne_Progress_Team2Fail:Show()
		else
			MenPaiFirstOne_Progress_Team1Win:Hide()
			MenPaiFirstOne_Progress_Team2Win:Show()
			MenPaiFirstOne_Progress_Team1Draw:Hide()
			MenPaiFirstOne_Progress_Team2Draw:Hide()
			MenPaiFirstOne_Progress_Team1Fail:Show()
			MenPaiFirstOne_Progress_Team2Fail:Hide()
		end
	elseif nResult == 2 then
		if myCamp == 157 then
			MenPaiFirstOne_Progress_Team1Win:Show()
			MenPaiFirstOne_Progress_Team2Win:Hide()
			MenPaiFirstOne_Progress_Team1Draw:Hide()
			MenPaiFirstOne_Progress_Team2Draw:Hide()
			MenPaiFirstOne_Progress_Team1Fail:Hide()
			MenPaiFirstOne_Progress_Team2Fail:Show()
		else
			MenPaiFirstOne_Progress_Team1Win:Hide()
			MenPaiFirstOne_Progress_Team2Win:Show()
			MenPaiFirstOne_Progress_Team1Draw:Hide()
			MenPaiFirstOne_Progress_Team2Draw:Hide()
			MenPaiFirstOne_Progress_Team1Fail:Show()
			MenPaiFirstOne_Progress_Team2Fail:Hide()
		end
	else
		MenPaiFirstOne_Progress_Team1Win:Hide()
		MenPaiFirstOne_Progress_Team2Win:Hide()
		MenPaiFirstOne_Progress_Team1Draw:Hide()
		MenPaiFirstOne_Progress_Team2Draw:Hide()
		MenPaiFirstOne_Progress_Team1Fail:Hide()
		MenPaiFirstOne_Progress_Team2Fail:Hide()
	end
end


function MenPaiFirstOne_Progress_Frame_On_ResetPos()

	MenPaiFirstOne_Progress_Frame : SetProperty("UnifiedXPosition", g_MenPaiFirstOne_Progress_Frame_UnifiedXPosition);
	MenPaiFirstOne_Progress_Frame : SetProperty("UnifiedYPosition", g_MenPaiFirstOne_Progress_Frame_UnifiedYPosition);

end


function MenPaiFirstOne_Progress_Help1_Click()
	PushEvent("CCSHOP_HELP", 2)
end

function MenPaiFirstOne_Progress_Help2_Click()
	PushEvent("CCSHOP_HELP", 3)
end

function MenPaiFirstOne_Progress_CloseWindow()
	PushEvent("SHOW_DDZWAR_MINI", 1)
	this:Hide()
end
