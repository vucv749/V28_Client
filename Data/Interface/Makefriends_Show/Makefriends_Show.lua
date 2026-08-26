
local Makefriends_Show_SourceName
local Makefriends_Show_TargetName
local Makefriends_Show_SourceGuid
local Makefriends_Show_TargetGuid

function Makefriends_Show_PreLoad()
	this:RegisterEvent("MAKEFRIENDS_EXPRESSING_EMOTIONS_CONFIRM");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ON_SCENE_TRANS");
	this:RegisterEvent("JIAOYOU_EXPRESSING_QUICKLY");
end

function Makefriends_Show_OnLoad()
	SetTimer("Makefriends_Show", "Makefriends_Show_GetMsgTimer()", 8000);--5秒取一次队列
end

function Makefriends_Show_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		Makefriends_Show_OnClose()

	elseif event == "ON_SCENE_TRANS" then
		--场景切换 清空
		Makefriends_Show_OnClose()
	elseif event == "PLAYER_LEAVE_WORLD" then
		--玩家离开世界 清空
		Makefriends_Show_OnClose()
	elseif event == "JIAOYOU_EXPRESSING_QUICKLY" then
		--收到消息包进队列触发的事件 
		if(this:IsVisible()) then
			return;
		else
		--玩家离开世界 清空
		KillTimer("Makefriends_Show_GetMsgTimer()");
		Makefriends_Show_OnClose()
		Makefriends_Show_GetMsgTimer()
		SetTimer("Makefriends_Show", "Makefriends_Show_GetMsgTimer()", 8000);--5秒取一次队列
		end
	end
end

function Makefriends_Show_Open()
	this:Hide()
	PushEvent("SOCIALACTIVITYES_REST_XXS_MINI",1)
end
function Makefriends_Show_Close()
	this:Hide()
end


function Makefriends_Show_GetMsgTimer()
	local ret,sourcename,targetname,SourceCharGuid,TargetCharGuid = SocialActivitesDataPool:GetMakeFriendsQueFront();

	if ret == 0 then
		return;
	end
	Makefriends_Show_SourceName = sourcename
	Makefriends_Show_TargetGuid = TargetCharGuid
	Makefriends_Show_TargetName = targetname
	Makefriends_Show_SourceGuid = SourceCharGuid

	local text = ScriptGlobal_Format("#{JYHD_230331_139}",sourcename)
	Makefriends_Show_Text:SetText(text)
	SetTimer("Makefriends_Show", "Makefriends_Show_CloseUITimer()", 8000);--5秒后自动关闭
	this:Show();
end

function Makefriends_Show_Btn_Clicked()
	if Makefriends_Show_SourceGuid == -1 or Makefriends_Show_SourceGuid == 0 then
        return 
	end
	if (Makefriends_Show_SourceGuid == Player:GetGUID()) then  
		PushDebugMessage("#{GGSK_221221_49}");--修改字典
		return;
	end
	--已是好友 则隐藏
	if (Friend:IsPlayerIsFriendNotTemp(Makefriends_Show_SourceName) == 1) then
		PushDebugMessage("#{JYHD_230331_138}");--修改字典
		return
	end
	
	DataPool:AddFriendAndGrouping(Makefriends_Show_SourceName);
end

--每次显示一段时间 （时间待定）就关闭UI 定时器 
function Makefriends_Show_CloseUITimer()
	KillTimer("Makefriends_Show_CloseUITimer()");
	--关闭界面
	this:Hide()
end

function Makefriends_Show_OnClose()
    this:Hide();
	KillTimer("Makefriends_Show_CloseUITimer()");
	
	Makefriends_Show_SourceName = ""
    Makefriends_Show_TargetName = ""
    Makefriends_Show_SourceGuid = 0
    Makefriends_Show_TargetGuid = 0
end
