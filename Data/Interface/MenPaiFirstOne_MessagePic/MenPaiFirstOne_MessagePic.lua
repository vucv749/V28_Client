
function MenPaiFirstOne_MessagePic_PreLoad()
	this:RegisterEvent("SHOW_DDZWAR_RESULT");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function MenPaiFirstOne_MessagePic_OnLoad()
end

function MenPaiFirstOne_MessagePic_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		KillTimer("MenPaiFirstOne_MessagePic_Timer()")
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			KillTimer("MenPaiFirstOne_MessagePic_Timer()")
			CMenPaiDiYiData:LuaSetShowResultFlag(0)
			this:Hide()
		end
	elseif (event=="SHOW_DDZWAR_RESULT") then
		SetTimer("MenPaiFirstOne_MessagePic", "MenPaiFirstOne_MessagePic_Timer()", 10000)
		this:Show()
		local myRet, myName, myCamp, myHp, myMaxHp, myMenpai, mylevel = CMenPaiDiYiData:GetMyScore()
		local unitId= CMenPaiDiYiData:GetUnitId() --unitId=0代表16�? unitId=1代表8�? unitId=2代表4�? unitId=3代表决赛
		local result = CMenPaiDiYiData:GetResult()
		if (myCamp == 156 and result == 1) or (myCamp == 157 and result == 2)  then
			if unitId == 0 then
				local tips = ScriptGlobal_Format("#{DYRCN_220427_32}","8")
				MenPaiFirstOne_MessagePic_Text:SetText(tips)
			elseif unitId == 1 then
				local tips = ScriptGlobal_Format("#{DYRCN_220427_32}","4")
				MenPaiFirstOne_MessagePic_Text:SetText(tips)
			elseif unitId == 2 then
				local tips = ScriptGlobal_Format("#{DYRCN_220427_32}","2")
				MenPaiFirstOne_MessagePic_Text:SetText(tips)
			elseif unitId == 3 then
				MenPaiFirstOne_MessagePic_Text:SetText("#{DYRCN_220427_31}")
			end
			MenPaiFirstOne_MessagePic_ImageBK:SetImage("MenPaiFirstOne01","MenPaiFirstOne_Win")
		else
			if unitId == 0 then
				local tips = ScriptGlobal_Format("#{DYRCN_220427_33}","16")
				MenPaiFirstOne_MessagePic_Text:SetText(tips)
			elseif unitId == 1 then
				local tips = ScriptGlobal_Format("#{DYRCN_220427_33}","8")
				MenPaiFirstOne_MessagePic_Text:SetText(tips)
			elseif unitId == 2 then
				local tips = ScriptGlobal_Format("#{DYRCN_220427_33}","4")
				MenPaiFirstOne_MessagePic_Text:SetText(tips)
			elseif unitId == 3 then
				MenPaiFirstOne_MessagePic_Text:SetText("#{DYRCN_220427_40}")
			end

			MenPaiFirstOne_MessagePic_ImageBK:SetImage("MenPaiFirstOne01","MenPaiFirstOne_Shibai")
		end
	end
end

function MenPaiFirstOne_MessagePic_Timer()
	KillTimer("MenPaiFirstOne_MessagePic_Timer()")
	this:Hide()
end

