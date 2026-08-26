local g_TongTianTaTime_Frame_UnifiedPosition = nil 
local g_TongTianTaTime_list = {}

function TongTianTaTime_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("TONGTIANTA_MD_SWITCH")
	----------------------
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end 

function TongTianTaTime_OnLoad()
	g_TongTianTaTime_Frame_UnifiedPosition = TongTianTaTime_Frame:GetProperty("UnifiedPosition");

	g_TongTianTaTime_list[1] = TongTianTaTime_BossText1;
	g_TongTianTaTime_list[2] = TongTianTaTime_BossText2;
	g_TongTianTaTime_list[3] = TongTianTaTime_BossText3;
	g_TongTianTaTime_list[4] = TongTianTaTime_BossText4;
	g_TongTianTaTime_list[5] = TongTianTaTime_BossText5;
end

function TongTianTaTime_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		TongTianTaTime_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		TongTianTaTime_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD" then
		if GetSceneID() == 764 or GetSceneID() == 765 or GetSceneID() == 766 
		or GetSceneID() == 767 or GetSceneID() == 768 then
			return
		end
		TongTianTaTime_On_Hide()
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 82006901 ) then
		local count = Get_XParam_INT( 0 )
		local BossState = Get_XParam_INT( 1 )
		local LeftTime = Get_XParam_INT( 2 )
		TongTianTaTime_Init(count, BossState, LeftTime)
		if IsWindowShow("TongTianTaTime_Mini") == false then
			this:Show()
		end
	elseif(event == "TONGTIANTA_MD_SWITCH") then
		local opType = tonumber(arg0)
		if opType == 2 then
			this:Show()
		else
			this:Hide()	
		end
	end
end


function TongTianTaTime_OpenMini()
	PushEvent("TONGTIANTA_MD_SWITCH",1)
end

function TongTianTaTime_Init(count, BossState, LeftTime)

	if count >= 1 then
		TongTianTaTime_NumTitle:SetText("#{TTBT_250715_97}")
		TongTianTaTime_Num:SetText(ScriptGlobal_Format("#{TTBT_250715_95}",count))
	else
		TongTianTaTime_NumTitle:SetText("#{TTBT_250715_96}")
		TongTianTaTime_Num:SetText(ScriptGlobal_Format("#{TTBT_250715_113}",count))
	end

	if LeftTime == -1 then
		TongTianTaTime_BossTimeText:SetText("#{TTBT_250715_100}")
		TongTianTaTime_BossTimeText:Show()
		TongTianTaTime_BossTime:Hide()	
	else
		TongTianTaTime_BossTimeText:Hide()
		TongTianTaTime_BossTime:SetProperty("Timer",tostring(LeftTime));
		TongTianTaTime_BossTime:Show()
	end

	local allBossState = {0, 0, 0, 0, 0}
	allBossState[1] = math.floor(BossState/10000)
	allBossState[2] = math.mod(math.floor(BossState/1000), 10)
	allBossState[3] = math.mod(math.floor(BossState/100), 10)
	allBossState[4] = math.mod(math.floor(BossState/10), 10)
	allBossState[5] = math.mod(BossState, 10)
	for i=1,5 do
		if allBossState[i] == 1 then
			g_TongTianTaTime_list[i]:SetText("#{TTBT_250715_108}")
		else
			g_TongTianTaTime_list[i]:SetText("#{TTBT_250715_109}")
		end
	end

end

function TongTianTaTime_On_ResetPos()
	TongTianTaTime_Frame:SetProperty("UnifiedPosition", g_TongTianTaTime_Frame_UnifiedPosition)
end


function TongTianTaTime_On_Hide()
	this:Hide()
end
