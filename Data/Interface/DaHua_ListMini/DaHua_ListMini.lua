
local g_unifiedposistion
local g_DaHua_ListMini_SceneId = 0
local g_DaHua_ListMini_opType = {
	close = 1000,					-- ¹Ø±ÕUI
}

local g_scene_res_ids={[709]=1,[710]=2,[711]=3}

local g_Title = {
	[1] = "#{QXPVE_240522_7}",
	[2] = "#{QXPVE_240522_133}",
	[3] = "#{QXPVE_240522_134}",
}

local g_Stage = 0
local g_EndTime = 0
local g_NextStateTime = 0
local g_curState = 0


local g_FubenState = 
{
    CREATED = 0,
    ENTERFUBEN = 1,
    MONSTERROUND1 = 2,
	ENDMONSTERROUND1 = 3,
    BOSSROUND1 = 4,
    ENDROUND1 = 5,
    MONSTERROUND2 = 6,
    ENDMONSTERROUND2 = 7,
    BOSSROUND2 = 8,
    ENDROUND2 = 9,
	GIVEAWARD = 10,
    LEAVEFUBEN = 11
}

local g_StateUIInfo = 
{
	[g_FubenState.ENTERFUBEN] = {
		[1] = {line1 = "#{QXPVE_240522_190}",line2 = "#{QXPVE_240522_191}"},
		[2] = {line1 = "#{QXPVE_240522_203}",line2 = "#{QXPVE_240522_192}"},
		[3] = {line1 = "#{QXPVE_240522_204}",line2 = "#{QXPVE_240522_193}"},
	},
	[g_FubenState.MONSTERROUND1] = {
		[1] = {line1 = "#{QXPVE_240522_190}",line2 = "#{QXPVE_240522_191}"},
		[2] = {line1 = "#{QXPVE_240522_203}",line2 = "#{QXPVE_240522_192}"},
		[3] = {line1 = "#{QXPVE_240522_204}",line2 = "#{QXPVE_240522_193}"},
	},
	[g_FubenState.ENDMONSTERROUND1] = {
		[1] = {line1 = "#{QXPVE_240522_194}",line2 = "#{QXPVE_240522_197}"},
		[2] = {line1 = "#{QXPVE_240522_195}",line2 = "#{QXPVE_240522_205}"},
		[3] = {line1 = "#{QXPVE_240522_196}",line2 = "#{QXPVE_240522_206}"},
	},
	[g_FubenState.BOSSROUND1] = {
		[1] = {line1 = "#{QXPVE_240522_194}",line2 = "#{QXPVE_240522_197}"},
		[2] = {line1 = "#{QXPVE_240522_195}",line2 = "#{QXPVE_240522_205}"},
		[3] = {line1 = "#{QXPVE_240522_196}",line2 = "#{QXPVE_240522_206}"},
	},
	[g_FubenState.ENDROUND1] = {
		[1] = {line1 = "#{QXPVE_240522_190}",line2 = "#{QXPVE_240522_191}"},
		[2] = {line1 = "#{QXPVE_240522_203}",line2 = "#{QXPVE_240522_192}"},
		[3] = {line1 = "#{QXPVE_240522_204}",line2 = "#{QXPVE_240522_193}"},
	},
	[g_FubenState.MONSTERROUND2] = {
		[1] = {line1 = "#{QXPVE_240522_190}",line2 = "#{QXPVE_240522_191}"},
		[2] = {line1 = "#{QXPVE_240522_203}",line2 = "#{QXPVE_240522_192}"},
		[3] = {line1 = "#{QXPVE_240522_204}",line2 = "#{QXPVE_240522_193}"},
	},
	[g_FubenState.ENDMONSTERROUND2] = {
		[1] = {line1 = "#{QXPVE_240522_194}",line2 = "#{QXPVE_240522_198}"},
		[2] = {line1 = "#{QXPVE_240522_195}",line2 = "#{QXPVE_240522_198}"},
		[3] = {line1 = "#{QXPVE_240522_196}",line2 = "#{QXPVE_240522_198}"},
	},
	[g_FubenState.BOSSROUND2] = {
		[1] = {line1 = "#{QXPVE_240522_194}",line2 = "#{QXPVE_240522_198}"},
		[2] = {line1 = "#{QXPVE_240522_195}",line2 = "#{QXPVE_240522_198}"},
		[3] = {line1 = "#{QXPVE_240522_196}",line2 = "#{QXPVE_240522_198}"},
	},
	[g_FubenState.ENDROUND2] = {
		[1] = {line1 = "#{QXPVE_240522_199}",line2 = ""},
		[2] = {line1 = "#{QXPVE_240522_200}",line2 = ""},
		[3] = {line1 = "#{QXPVE_240522_201}",line2 = ""},
	},
	[g_FubenState.GIVEAWARD] = {
		[1] = {line1 = "#{QXPVE_240522_199}",line2 = ""},
		[2] = {line1 = "#{QXPVE_240522_200}",line2 = ""},
		[3] = {line1 = "#{QXPVE_240522_201}",line2 = ""},
	},
}

function DaHua_ListMini_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("SCENE_TRANSED",false);
end

function DaHua_ListMini_OnLoad()	
	g_unifiedposistion = DaHua_ListMini_Frame:GetProperty("UnifiedPosition")
end

function DaHua_ListMini_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 05112801 then
		local opType =  Get_XParam_INT( 0 )
		if opType == g_DaHua_ListMini_opType.close then
			this:Hide()
		elseif opType == 1 then
			g_Stage =  Get_XParam_INT( 1 )
			g_NextStateTime = Get_XParam_INT( 2 )
			g_EndTime = Get_XParam_INT( 3 )
			g_curState = Get_XParam_INT( 4 )
			DaHua_ListMini_Show()
		end
	elseif event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
	elseif event == "ADJEST_UI_POS" then
		DaHua_ListMini_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		DaHua_ListMini_ResetPos()
	elseif event == "SCENE_TRANSED" then
		if not g_scene_res_ids[GetSceneID()] then
			this:Hide()
		end
	end
end

function DaHua_ListMini_ResetPos()
	DaHua_ListMini_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

function DaHua_ListMini_Open()
	PushEvent("REFRESH_QIXIPVEWAR_SCORE",1,g_Stage)
end

function DaHua_ListMini_Leave()
	-- PushEvent("REFRESH_QIXIPVEWAR_SCORE",1000)
	if  not g_scene_res_ids[GetSceneID()] then 
		PushDebugMessage("#{QXPVE_240522_25}")
		return 
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name( "ClientAskLeave" )
	Set_XSCRIPT_ScriptID(051128)
	Set_XSCRIPT_Parameter(0,0)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function DaHua_ListMini_Show()
	this:Show()
	if g_Stage<1 or g_Stage >3 then
		return 
	end
	DaHua_ListMini_DragTitle:SetText(g_Title[g_Stage])
	if g_EndTime > 0 then
		DaHua_ListMini_Time3:SetProperty("Timer", g_EndTime)
	else
		DaHua_ListMini_Time3:SetProperty("Timer", 0)
	end
	if g_StateUIInfo[g_curState] then
		local info = g_StateUIInfo[g_curState][g_Stage]
		DaHua_ListMini_TimeTitle:Show()
		DaHua_ListMini_TimeTitle2:Show()

		DaHua_ListMini_TimeTitle:SetText(info.line1)
		DaHua_ListMini_TimeTitle2:SetText(info.line2)
		DaHua_ListMini_Time2:Show()
		if g_NextStateTime > 0 then
			DaHua_ListMini_Time2:SetProperty("Timer", g_NextStateTime)
		else
			if g_FubenState.ENDROUND2 == g_curState then
				local castTime = 0-g_NextStateTime
				if castTime <20 then
					DaHua_ListMini_Time2:SetProperty("Timer", 20-castTime)
					DaHua_ListMini_TimeTitle2:SetText("#{QXPVE_240628_42}")
				elseif castTime <35 then
					DaHua_ListMini_Time2:SetProperty("Timer", 35-castTime)
					DaHua_ListMini_TimeTitle2:SetText("#{QXPVE_240628_43}")
				else
					DaHua_ListMini_Time2:SetProperty("Timer", g_EndTime)
					DaHua_ListMini_TimeTitle2:SetText("#{QXPVE_240628_44}")
				end
			else
				DaHua_ListMini_Time2:SetProperty("Timer", 0)
			end
		end
	else
		DaHua_ListMini_TimeTitle:Hide()
		DaHua_ListMini_TimeTitle2:Hide()
		DaHua_ListMini_Time2:Hide()
	end
	DaHua_ListMini_btn2:SetToolTip("#{QXPVE_240628_35}")
	DaHua_ListMini_btn1:SetToolTip("#{QXPVE_240522_187}")

	if GetSceneID() == 710 then
		if g_FubenState.GIVEAWARD == g_curState or g_FubenState.ENDROUND2 == g_curState then
			DaHua_ListMini_Time2:SetProperty("Timer", g_EndTime)
			DaHua_ListMini_TimeTitle2:SetText("#{QXPVE_240628_44}")
		end
		DaHua_ListMini_btn1:Hide()
	else
		DaHua_ListMini_btn1:Show()
	end
end
