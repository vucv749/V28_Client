local makefriend_lastSendMsgTime = 0
local makefriend_sendMsgCD = 5  --???????? 5?
--Ωª”—–˚—‘
local Makefriends_Activity_Modify_Array = {
	"#{JYHD_230331_52}",
	"#{JYHD_230331_53}",
	"#{JYHD_230331_54}",
	"#{JYHD_230331_55}",
	"#{JYHD_230331_56}",
}
--===============================================
-- PreLoad()
--===============================================
function Makefriends_Activity_Modify_PreLoad()

	this:RegisterEvent("CLOSE_WINDOW")
	this:RegisterEvent("UI_COMMAND");
end
--===============================================
-- OnLoad()
--===============================================
function Makefriends_Activity_Modify_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function Makefriends_Activity_Modify_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 891180 ) then --????
		Makefriends_Activity_Modify_Ensure:SetText("X·c nhßn")
		Makefriends_Activity_Modify_Cancel:SetText("–Ûng cÿa")
		local cnt = table.getn(Makefriends_Activity_Modify_Array)
		local randomIndex = math.random(1,cnt)
		Makefriends_Activity_Modify_Edit:SetText(Makefriends_Activity_Modify_Array[randomIndex])
		Makefriends_Activity_Modify_ChangeMessage()
		
		this:Show()
	end

end


--===============================================
--∑¢ÀÕ¡Ù—‘
--===============================================
function Makefriends_Activity_Modify_SendMessage_Clicked()
	local curTime = FindFriendDataPool:GetTickCount();
	if ( curTime - makefriend_lastSendMsgTime < makefriend_sendMsgCD * 1000) then
		PushDebugMessage("#{ZYPT_081127_2}"); --??????,?????????
	    return;
	else
	    makefriend_lastSendMsgTime = curTime;
	    SocialActivitesDataPool:AddPlayerMsg(Makefriends_Activity_Modify_EditInfoText:GetText())
	    Makefriends_Activity_Modify_EditInfoText:SetText("")
	end


end


--===============================================
-- «Â≥˝¡Ù—‘
--===============================================
function Makefriends_Activity_Modify_ClearMessage_Clicked()

	local nMsgNum = FindFriendDataPool:GetPlayerMsgNum()
	if(nMsgNum <= 0) then
		PushDebugMessage("#{ZYLY_091118_04}")
	   return
	end
	
  Makefriends_Activity_Modify_Desc:ClearAllElement()
  FindFriendDataPool:ClearPlayerMsg()

end


function Makefriends_Activity_Modify_Close()
	Makefriends_Activity_Modify_Info2:SetText("")
	Makefriends_Activity_Modify_ChangeMessage()
	this:Hide()
end

function Makefriends_Activity_Modify_ChangeMessage()
    local text = Makefriends_Activity_Modify:GetText(); 
	local nlen = string.len(text)
	Makefriends_Activity_Modify_Info2:SetText(ScriptGlobal_Format("#{JYHD_230331_58}",nlen)) 
end
