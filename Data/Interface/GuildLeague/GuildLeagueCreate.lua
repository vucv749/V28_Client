--ÓëNPCµÄ¾àÀë
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;
--===============================================
-- OnLoad()
--===============================================
function GuildLeagueCreate_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_LEAGUE_CREATE")
	this:RegisterEvent("OBJECT_CARED_EVENT");
end

function GuildLeagueCreate_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function GuildLeagueCreate_OnEvent( event )
	if event == "GUILD_LEAGUE_CREATE" or 
		(event == "UI_COMMAND" and tonumber(arg0)==1207) then
		GuildLeagueCreate_InputName:SetText("Dài nh¤t 12 kí tñ")
		GuildLeagueCreate_InputName:SetProperty("DefaultEditBox", "True");
		GuildLeagueCreate_InputName:SetSelected(0,-1)
		GuildLeagueCreate_InputDesc:SetText("Huynh ð® mµt nhà, cùng nhau phát tri¬n!")
		this:Show()
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
		this:CareObject(g_clientNpcId, 1, "GuildLeagueCreate");
	elseif ( event == "OBJECT_CARED_EVENT") then
		GuildLeagueCreate_CareEventHandle(arg0,arg1,arg2)
	end
end

function GuildLeagueCreate_InputName_OnMouseClick()
		GuildLeagueCreate_InputName:SetSelected(0,-1)	
end

function GuildLeagueCreate_DoCreate()
	local name=GuildLeagueCreate_InputName:GetText()
	local desc=GuildLeagueCreate_InputDesc:GetText()
	if name==nil or name=="" then
		PushDebugMessage("#{TM_20080311_04}")
		return
	end
	
	if desc==nil or desc=="" then
		PushDebugMessage("BÕn vçn chßa nh§p l¶i tuyên ngôn liên minh.")
		return
	end
	
	--PushDebugMessage(name.." --- "..desc)
	
	local r=GuildLeague:ShowCreateConfirmWindow(name,desc)
	if r==-1 then
		PushDebugMessage("#{TM_20080311_05}")
	elseif r==-2 then
		PushDebugMessage("#{TM_20080311_07}")
	end
	if r==1 then
		this:Hide()
	end
end

function GuildLeagueCreate_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end
