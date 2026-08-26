
function SweepPageQuest_PreLoad()
	this:RegisterEvent("OPEN_SWEEPPAGE_QUEST")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OPEN_QUEST_HELP_MSG")
end

function SweepPageQuest_OnLoad()
end

function SweepPageQuest_OnEvent(event)
	if event == "OPEN_SWEEPPAGE_QUEST" then
		SweepPageQuest_Open(arg0, arg1)
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	elseif event == "OPEN_QUEST_HELP_MSG" then
		SweepPageQuest_Open_Help_Msg( arg0, arg1 )
	end
end

function SweepPageQuest_Open(arg0, arg1)
	if arg0 == nil then
		return
	end
	
	if arg0 == "SweepAll_ExplainHelp" then
		SweepPageQuestGreeting_Desc:Hide()
		SweepPageQuestGreeting_Desc1:Show()
		SweepPageQuest_Title:SetText("")
		SweepPageQuestGreeting_Desc1:ClearAllElement()
		SweepPageQuestGreeting_Desc1:AddTextElement("#{FBSD_150126_04}")
	end
	
	if arg0 == "TopList_ExplainHelp" then
		if arg1 == nil then
			return
		end
		SweepPageQuestGreeting_Desc:Hide()
		SweepPageQuestGreeting_Desc1:Show()
		SweepPageQuest_Title:SetText("")
		SweepPageQuestGreeting_Desc1:ClearAllElement()
		if tonumber(arg1) == 1 then
			SweepPageQuestGreeting_Desc1:AddTextElement("#{QXHB_20210701_215}")
		elseif tonumber(arg1) == 2 then
			SweepPageQuestGreeting_Desc1:AddTextElement("#{QXHB_20210701_215}")
		elseif tonumber(arg1) == 3 then
			SweepPageQuestGreeting_Desc1:AddTextElement("#{QXHB_20210701_215}")
		elseif tonumber(arg1) == 4 then
			SweepPageQuestGreeting_Desc1:AddTextElement("#{QXHB_20210701_215}")
		else
			return
		end
	end
		
	if arg0 == "TopList_LoverTimeHelp" then
		if arg1 == nil then
			return
		end
		SweepPageQuestGreeting_Desc:Hide()
		SweepPageQuestGreeting_Desc1:Show()
		SweepPageQuest_Title:SetText("")
		SweepPageQuestGreeting_Desc1:ClearAllElement()
		if tonumber(arg1) == 1 then
			SweepPageQuestGreeting_Desc1:AddTextElement("#{QRZM_211119_215}")
		elseif tonumber(arg1) == 2 then
			SweepPageQuestGreeting_Desc1:AddTextElement("#{QRZM_211119_215}")
		elseif tonumber(arg1) == 3 then
			SweepPageQuestGreeting_Desc1:AddTextElement("#{QRZM_211119_215}")
		elseif tonumber(arg1) == 4 then
			SweepPageQuestGreeting_Desc1:AddTextElement("#{QRZM_211119_215}")
		else
			return
		end
	end
	
	if arg0 == "Fashion_Auction_Help" then
		SweepPageQuestGreeting_Desc:Hide()
		SweepPageQuestGreeting_Desc1:Show()
		SweepPageQuest_Title:SetText("")
		SweepPageQuestGreeting_Desc1:ClearAllElement()
		SweepPageQuestGreeting_Desc1:AddTextElement("#{ZQPM_240402_07}")
	end
	
	if arg0 == "NewExterior_Ride_Collection_Help" then
		SweepPageQuestGreeting_Desc:Hide()
		SweepPageQuestGreeting_Desc1:Show()
		SweepPageQuest_Title:SetText("")
		SweepPageQuestGreeting_Desc1:ClearAllElement()
		SweepPageQuestGreeting_Desc1:AddTextElement("#{ZJYK_231019_37}")
	end
	
	if arg0 == "DWJinJie_Help" then
		SweepPageQuestGreeting_Desc:Hide()
		SweepPageQuestGreeting_Desc1:Show()
		SweepPageQuest_Title:SetText("")
		SweepPageQuestGreeting_Desc1:ClearAllElement()
		SweepPageQuestGreeting_Desc1:AddTextElement("#{DWJJ_240329_194}")
	end

	this:Show()
end

function SweepPageQuest_Open_Help_Msg( szTitle, szMsg )
	if szTitle == nil or szMsg == nil then
		return
	end
	
	SweepPageQuestGreeting_Desc:Hide()
	SweepPageQuestGreeting_Desc1:Show()
	SweepPageQuest_Title:SetText( tostring(szTitle) )
	SweepPageQuestGreeting_Desc1:ClearAllElement()
	SweepPageQuestGreeting_Desc1:AddTextElement( tostring(szMsg) )

	this:Show()
end

function SweepPageQuest_Closed()
	this:Hide()
end

function SweepPageQuest_OnHidden()

end
