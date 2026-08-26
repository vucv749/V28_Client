--FriendSet

local g_FriendSet_Frame_UnifiedXPosition
local g_FriendSet_Frame_UnifiedYPosition
local g_FriendSet_CheckButton = {}
local g_FriendSet_Channel = -1
local g_FriendSet_nIndex = -1

function FriendSet_PreLoad()
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OPEN_FRIENDSET")
end

function FriendSet_OnLoad()
	g_FriendSet_CheckButton = {
		Friend_Set1,
		Friend_Set2
	}
	
	g_FriendSet_Channel = -1
	g_FriendSet_nIndex = -1
end

function FriendSet_OnEvent(event)
	if( event == "OPEN_FRIENDSET") then
		FriendSet_OnShow()
	end
	
end

function FriendSet_ResetPos()
	FriendSet:SetProperty("UnifiedXPosition", g_FriendSet_Frame_UnifiedXPosition)
	FriendSet:SetProperty("UnifiedYPosition", g_FriendSet_Frame_UnifiedYPosition)
end

function FriendSet_OnHidden()
	g_FriendSet_Channel = -1
	g_FriendSet_nIndex = -1
	this:Hide()
end

function FriendSet_OnShow()
	g_FriendSet_nIndex = tonumber(arg0)
	g_FriendSet_Channel = tonumber(arg1)
	local name = DataPool:GetFriend(g_FriendSet_Channel, g_FriendSet_nIndex, "NAME")
	local dragTitle = ScriptGlobal_Format("#{HYYHE_230339_02}", name )
	FriendSet_DragTitle:SetText( "#{HYYHE_230339_02}" )
	
	local onlineNotice = DataPool:GetFriend(g_FriendSet_Channel, g_FriendSet_nIndex, "ONLINE_NOTICE")
	local istop = DataPool:GetFriend(g_FriendSet_Channel, g_FriendSet_nIndex, "IS_TOP")
	
	if istop==1 then
		g_FriendSet_CheckButton[1]:SetCheck(1)
	else
		g_FriendSet_CheckButton[1]:SetCheck(0)
	end
	
	if onlineNotice==1 then
		g_FriendSet_CheckButton[2]:SetCheck(1)
	else
		g_FriendSet_CheckButton[2]:SetCheck(0)
	end
	
	this:Show()
end

function Friend_Set_Clicked(idx)
	if idx ~= 1 and idx ~= 2 then
		return
	end
	
	--PushDebugMessage(idx.."x"..g_FriendSet_CheckButton[idx]:GetCheck())
	local bCheck = g_FriendSet_CheckButton[idx]:GetCheck()
	local setCheck = math.mod(bCheck+1,2)
	--local guid = DataPool:GetFriend(g_FriendSet_Channel, g_FriendSet_nIndex, "ID")
	local ret = DataPool:FriendSetClicked(g_FriendSet_Channel, g_FriendSet_nIndex, idx, bCheck) 
	if ret == -1 then
		return
	elseif ret == 0 then
		g_FriendSet_CheckButton[idx]:SetCheck(setCheck)
	end
end

