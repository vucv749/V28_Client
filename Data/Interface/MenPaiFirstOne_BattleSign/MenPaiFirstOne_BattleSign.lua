-------±¨Ãû
-------!!!reloadscript =MenPaiFirstOne_BattleSign

local g_MenPaiFirstOne_BattleSign_Frame_UnifiedXPosition;
local g_MenPaiFirstOne_BattleSign_Frame_UnifiedYPosition;

local g_TargetId = -1
local g_CurMenPai = 9

local g_MaxPlayer = 16
local g_NeedLevel = 60

local g_LastBaoMingTime = 0
local g_LastRefreshTime = 0
local g_CDTime = 2

local g_MenPaiFirstOne_BattleSign_MenPai = {}
local g_MenPaiName = {
		[0] = "#{XQ_MP_1}",    --??
		[1] = "#{XQ_MP_2}",    --??
		[2] = "#{XQ_MP_3}",    --??
		[3] = "#{XQ_MP_4}",    --??
		[4] = "#{XQ_MP_5}",    --??
		[5] = "#{XQ_MP_6}",    --??
		[6] = "#{XQ_MP_7}",    --??
		[7] = "#{XQ_MP_8}",    --??
		[8] = "#{XQ_MP_9}",    --??
		[9] = "",         --???
		[10] = "#{MPDYR_20220427_190}",    --??
}

function MenPaiFirstOne_BattleSign_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	--
	this:RegisterEvent("DDZ_OPEN_BAOMING");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function MenPaiFirstOne_BattleSign_OnLoad()
	--
	g_MenPaiFirstOne_BattleSign_Frame_UnifiedXPosition	= MenPaiFirstOne_BattleSign_Frame : GetProperty("UnifiedXPosition");
	g_MenPaiFirstOne_BattleSign_Frame_UnifiedYPosition	= MenPaiFirstOne_BattleSign_Frame : GetProperty("UnifiedYPosition");
	
	g_MenPaiFirstOne_BattleSign_MenPai[1] = MenPaiFirstOne_BattleSign_MenPai1
	g_MenPaiFirstOne_BattleSign_MenPai[2] = MenPaiFirstOne_BattleSign_MenPai2
	g_MenPaiFirstOne_BattleSign_MenPai[3] = MenPaiFirstOne_BattleSign_MenPai3
	g_MenPaiFirstOne_BattleSign_MenPai[4] = MenPaiFirstOne_BattleSign_MenPai4
	g_MenPaiFirstOne_BattleSign_MenPai[5] = MenPaiFirstOne_BattleSign_MenPai5
	g_MenPaiFirstOne_BattleSign_MenPai[6] = MenPaiFirstOne_BattleSign_MenPai6
	g_MenPaiFirstOne_BattleSign_MenPai[7] = MenPaiFirstOne_BattleSign_MenPai7
	g_MenPaiFirstOne_BattleSign_MenPai[8] = MenPaiFirstOne_BattleSign_MenPai8
	g_MenPaiFirstOne_BattleSign_MenPai[9] = MenPaiFirstOne_BattleSign_MenPai9
	g_MenPaiFirstOne_BattleSign_MenPai[11] = MenPaiFirstOne_BattleSign_MenPai10
	
end

function MenPaiFirstOne_BattleSign_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 89316601 ) then
        local targetId = Get_XParam_INT(0)
		if targetId == -1 then
			MenPaiFirstOne_BattleSign_Close()
			return
		end

		local objId = DataPool : GetNPCIDByServerID(targetId)
		if objId == -1 then
			return
		end
		
		g_TargetId = targetId
		this : CareObject( objId, 1, "MenPaiFirstOne_BattleSign" )
		
	elseif event == "DDZ_OPEN_BAOMING" then
		if g_CurMenPai == 9 then
			g_CurMenPai = Player : GetData("MEMPAI");		--??????ID
		end
	
		if g_CurMenPai == 9 then
			g_CurMenPai = 0
		end
		
		MenPaiFirstOne_BattleSign_Update()
		this : Show()

	elseif (event=="PLAYER_LEAVE_WORLD") then 
		MenPaiFirstOne_BattleSign_Close()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		MenPaiFirstOne_BattleSign_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		MenPaiFirstOne_BattleSign_Frame_On_ResetPos()
		
	end
end


function MenPaiFirstOne_BattleSign_Update()	

	MenPaiFirstOne_BattleSign_SignMemberInfo(g_CurMenPai)	
	
end


function MenPaiFirstOne_BattleSign_MenPai_Click( menpai )
	
	g_CurMenPai = menpai
	MenPaiFirstOne_BattleSign_SignMemberInfo(g_CurMenPai)
end


function MenPaiFirstOne_BattleSign_Init( menpai )
	
	for index=1, table.getn(g_MenPaiFirstOne_BattleSign_MenPai) do
		if g_MenPaiFirstOne_BattleSign_MenPai[index] ~= nil then
			g_MenPaiFirstOne_BattleSign_MenPai[index] : SetCheck(0)
		end
	end
	g_MenPaiFirstOne_BattleSign_MenPai[menpai + 1] : SetCheck(1)
	
	MenPaiFirstOne_BattleSign_ListTitle:RemoveAllItem()
end


function MenPaiFirstOne_BattleSign_SignMemberInfo( menpai )
		
	MenPaiFirstOne_BattleSign_Init( menpai )
	
	DataPool:Lua_SortDDZRankInfo(1) --?????????
	
	for index=0, g_MaxPlayer-1 do
		local name, guid, level, menpai, fubentime = DataPool:Lua_GetDDZBaoMingInfo(menpai, index)
		if name == nil or name == "" then
			break
		end
		
		MenPaiFirstOne_BattleSign_ListTitle:AddNewItem(index + 1, 0, index);
		MenPaiFirstOne_BattleSign_ListTitle:AddNewItem(name, 1, index);
		
		MenPaiFirstOne_BattleSign_ListTitle:AddNewItem(level, 2, index);
		MenPaiFirstOne_BattleSign_ListTitle:AddNewItem(g_MenPaiName[menpai], 3, index);
		
		local timestr = MenPaiFirstOne_BattleSign_FormatTime(fubentime)
		MenPaiFirstOne_BattleSign_ListTitle:AddNewItem(timestr, 4, index);
	end
	
end


function MenPaiFirstOne_BattleSign_Sign_Click( )

	local curTime = OSAPI:GetTickCount()
	if ( curTime - g_LastBaoMingTime < g_CDTime * 1000) then 
		PushDebugMessage("#{MPDYR_20220427_49}")
		return
	end
	g_LastBaoMingTime = curTime
	
	local myLevel = Player:GetData("LEVEL")
	if myLevel < g_NeedLevel then
		PushDebugMessage("#{MPDYR_20220427_57}")
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnBaoMing")
		Set_XSCRIPT_ScriptID(893166);
		Set_XSCRIPT_Parameter(0, g_TargetId);
		Set_XSCRIPT_Parameter(1, 0);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
	
end


--Ë¢ÐÂ
function MenPaiFirstOne_BattleSign_Refresh_Click( )

	local curTime = OSAPI:GetTickCount()
	if ( curTime - g_LastRefreshTime < g_CDTime * 1000) then 
		PushDebugMessage("#{MPDYR_20220427_49}")
		return
	end
	g_LastRefreshTime = curTime
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnRefreshBaoMingList")
		Set_XSCRIPT_ScriptID(893166);
		Set_XSCRIPT_Parameter(0, g_TargetId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
end


function MenPaiFirstOne_BattleSign_Frame_On_ResetPos()

	MenPaiFirstOne_BattleSign_Frame : SetProperty("UnifiedXPosition", g_MenPaiFirstOne_BattleSign_Frame_UnifiedXPosition);
	MenPaiFirstOne_BattleSign_Frame : SetProperty("UnifiedYPosition", g_MenPaiFirstOne_BattleSign_Frame_UnifiedYPosition);

end


function MenPaiFirstOne_BattleSign_Help_Click()
	PushEvent("QUEST_HELPINFO", "#{MPDYR_20220427_26}")
end

function MenPaiFirstOne_BattleSign_Close()
	if( this:IsVisible() == true ) then
		this:Hide()
	end
end

function MenPaiFirstOne_BattleSign_FormatTime(nSec)
	local min = math.floor(nSec/60)
	local sec = math.mod(nSec,60)
	
	local str = ScriptGlobal_Format("#{MPDYR_20220427_169}", min, sec)
	return str
end

