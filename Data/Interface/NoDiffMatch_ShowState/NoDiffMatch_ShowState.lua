-- 牻况查询

local g_unifiedposistion
local g_TargetId = -1
local g_TragetNpcId = -1
local g_teamcnt = 0
local g_szType = ""
local g_page = 1
local g_pagelist = {}
local g_pagemax = 8
local g_typeName	= {
	["qualify"] = {
		title = "#{WCBZ_180128_180}",
		desc = "#{WCBZ_180128_181}",
		btnshow = 1,
		trans = 0,						-- ??????????
	},

	["promote"] = {
		title = "#{WCBZ_220809_13}",
		desc = "#{WCBZ_220809_14}",
		btnshow = 1,
		trans = 1,
	},
}

local g_zoneid = {
	[1] = 1, [2] = 2, [3] = 3, [4] = 4,
	[5] = 5, [6] = 6, [7] = 7, [8] = 8,
}
local g_zone_max = 8
function NoDiffMatch_ShowState_PreLoad()
	this:RegisterEvent("ZBS_PROMOTE_PROMOTE_INFO_SHOW")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function NoDiffMatch_ShowState_OnLoad()
	g_pagelist.check = {
		NoDiffMatch_ShowState_A,
		NoDiffMatch_ShowState_B,
		NoDiffMatch_ShowState_C,
		NoDiffMatch_ShowState_D,
		NoDiffMatch_ShowState_E,
		NoDiffMatch_ShowState_F,
		NoDiffMatch_ShowState_G,
		NoDiffMatch_ShowState_H,
	}

	g_unifiedposistion	= NoDiffMatch_ShowState_Frame:GetProperty("UnifiedPosition")
end

function NoDiffMatch_ShowState_OnEvent(event)
	if event == "ZBS_PROMOTE_PROMOTE_INFO_SHOW" then
		NoDiffMatch_ShowState_OnShow(arg0, tonumber(arg1),tonumber(arg2), tonumber(arg3))
	elseif event == "ADJEST_UI_POS" then
		NoDiffMatch_ShowState_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		NoDiffMatch_ShowState_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		NoDiffMatch_ShowState_CloseClicked()
	end
end

function NoDiffMatch_ShowState_OnShow(sztype, cnt, targetId, zoneid)
	if zoneid == nil then
		return
	end

	local data = g_zoneid[zoneid]
	if data == nil then
		return
	end

	if targetId > 0 then
		g_TragetNpcId = targetId
		g_TargetId = DataPool : GetNPCIDByServerID( targetId )
		this:CareObject( g_TargetId, 1, "NoDiffMatch_ShowState" )
	end

	g_page = data
	g_teamcnt = cnt
	g_pagemax = table.getn(g_pagelist.check or {})
	
	
	if IsWindowShow("NoDiffMatch_TeamInfo")  then
		CloseWindow("NoDiffMatch_TeamInfo", true)
	end
	
	NoDiffMatch_ShowState_OtherUIShow(sztype)
	NoDiffMatch_ShowState_UpdateList()
	NoDiffMatch_ShowState_CheckBtnShow()

	this:Show()
end

function NoDiffMatch_ShowState_OtherUIShow(sztype)
	g_szType = sztype
	if g_typeName[g_szType] ~= nil then
		NoDiffMatch_ShowState_DragTitle:SetText(g_typeName[g_szType].title)
		NoDiffMatch_ShowState_ExplainText:SetText(g_typeName[g_szType].desc)
	end
end

function NoDiffMatch_ShowState_UpdateList()

    NoDiffMatch_ShowState_ResetControl()
    
	local cnt = 0
	for i = 0, g_teamcnt-1 do
		local teamid, teamname, teamleadername, zoneid = ZBS:GetTeamProtomeInfo(i)
	    if teamid ~= nil  and teamid > 0 then
			NoDiffMatch_ShowState_ListInfo:AddNewItem(tostring(cnt+1), 0, cnt)
    		NoDiffMatch_ShowState_ListInfo:AddNewItem(NoDiffMatch_ShowState_TransformName(teamname,zoneid), 1, cnt)
    		NoDiffMatch_ShowState_ListInfo:AddNewItem(NoDiffMatch_ShowState_TransformName(teamleadername,zoneid), 2, cnt)
    		NoDiffMatch_ShowState_ListInfo:AddNewItem("#{WCBZ_180128_188}", 3, cnt)
			cnt = cnt + 1
        end
	end

end

function NoDiffMatch_ShowState_CheckBtnShow()
	for i=1, g_pagemax do
		if g_page == i then
			g_pagelist.check[i]:Disable()
		else
			g_pagelist.check[i]:Enable()
		end
	end
end

function NoDiffMatch_ShowState_TransformName(name, zoneid)
	if zoneid < 0 then
		return name
	end

	local retname = name
	if g_typeName[g_szType] ~= nil then
		-- 是否需要转换名字
		if g_typeName[g_szType].trans > 0 then
			local selfzoneid = DataPool:GetSelfZoneWorldID()
			if selfzoneid ~= zoneid then
				local serverName = DataPool:GetServerName( zoneid )
				retname = name.."@"..tostring(serverName)
			end
		end
	end

	return retname
end

function NoDiffMatch_ShowState_ResetControl()
	NoDiffMatch_ShowState_ListInfo:RemoveAllItem()

	if g_szType == "" or g_typeName[g_szType] == nil or g_typeName[g_szType].btnshow < 1 then
		NoDiffMatch_ShowState_TeamInfo:Hide()
	else
		NoDiffMatch_ShowState_TeamInfo:Disable()
		NoDiffMatch_ShowState_TeamInfo:Show()
	end
end

function NoDiffMatch_ShowState_ListInfo_On_SelectionChanged()
	if g_szType == "" or g_typeName[g_szType] == nil or g_typeName[g_szType].btnshow < 1 then
		return
	else
		NoDiffMatch_ShowState_TeamInfo:Enable()
	end
end

function NoDiffMatch_ShowState_TeamInfo_Clicked()
	local index = NoDiffMatch_ShowState_ListInfo:GetSelectItem()
	if index < 0 then
		return
	end

	local trans = 0
	if g_typeName[g_szType] ~= nil then
		trans = g_typeName[g_szType].trans
	end
	
	PushEvent("ZBS_VIEWTEAMINFO_SHOW", index, trans)
end

function NoDiffMatch_ShowState_YXSJS_Clicked()
end


function NoDiffMatch_ShowState_CloseClicked()
	if g_TargetId ~= -1 then
		this:CareObject( g_TargetId, 0, "NoDiffMatch_ShowState" )
		g_TargetId = -1
	end
	g_TragetNpcId = -1
	CloseWindow("NoDiffMatch_TeamInfo",true)
    this:Hide()
end

function NoDiffMatch_ShowState_ZoneIDClicked(idx)

	NoDiffMatch_ShowState_CheckBtnShow()
	
	if idx == nil then
		return
	end

	if idx < 1 or idx > g_zone_max then
		return
	end

	local data = g_zoneid[idx]
	if data == nil then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Ask_Promote_Result")
		Set_XSCRIPT_ScriptID(889961)
		Set_XSCRIPT_Parameter(0,tonumber(g_TragetNpcId))
		Set_XSCRIPT_Parameter(1,tonumber(idx))
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

--================================================
-- 恢复界面的默认相对位置
--================================================
function NoDiffMatch_ShowState_ResetPos()
	NoDiffMatch_ShowState_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end
