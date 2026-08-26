-- 狔霸赛 组建牻队UI

-- 服务器端回调脚本ID
local NoDiffMatch_CreateTeam_ServerScriptId = 889961
-- 牻队名称最大长度
local NoDiffMatch_CreateTeam_NameLen_Max = 12
-- NPC id（缓存一下）
local NoDiffMatch_CreateTeam_TargetId = -1
-- 默认位置
local NoDiffMatch_CreateTeam_UnifiedPosition = nil
-- 控件表
local NoDiffMatch_CreateTeam_CtrlList = nil
-- 关注NPC
local NoDiffMatch_CreateTeam_CareObjId = -1
local NoDiffMatch_CreateTeam_CareObjSvrId = -1
local NoDiffMatch_CreateTeam_MAX_OBJ_DISTANCE = 5.0

-- 门派
local NoDiffMatch_CreateTeam_MenPaiName =
{
	[0] = "#{XQ_MP_1}",    	--??
	[1] = "#{XQ_MP_2}",    	--??
	[2] = "#{XQ_MP_3}",    	--??
	[3] = "#{XQ_MP_4}",    	--??
	[4] = "#{XQ_MP_5}",    	--??
	[5] = "#{XQ_MP_6}",    	--??
	[6] = "#{XQ_MP_7}",    	--??
	[7] = "#{XQ_MP_8}",    	--??
	[8] = "#{XQ_MP_9}",    	--??
	[9] = "",         		--???
	[10] = "#{WCBZ_220809_53}",--???? 
} -- end NoDiffMatch_CreateTeam_MenPaiName


function NoDiffMatch_CreateTeam_PreLoad()
	this:RegisterEvent("ZBS_OPENCREATETEAM", true)
	this:RegisterEvent("ZBS_CLOSEUI", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func NoDiffMatch_CreateTeam_PreLoad()

function NoDiffMatch_CreateTeam_OnEvent(event)
	if (event == "ZBS_OPENCREATETEAM") then
		NoDiffMatch_CreateTeam_TargetId = tonumber(arg0)
		NoDiffMatch_CreateTeam_BeginCareObject(arg0, arg1)
		NoDiffMatch_CreateTeam_Show()
		NoDiffMatch_CreateTeam_UpdateTeamInfo()
	elseif (event == "ZBS_CLOSEUI") then
		NoDiffMatch_CreateTeam_Hide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		NoDiffMatch_CreateTeam_Hide()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		NoDiffMatch_CreateTeam_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		NoDiffMatch_CreateTeam_UnifiedPos()
	elseif (event == "OBJECT_CARED_EVENT") then
		if(NoDiffMatch_CreateTeam_CareObjId < 0 or tonumber(arg0) ~= NoDiffMatch_CreateTeam_CareObjId) then
			return
		end

		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if((arg1 == "distance" and tonumber(arg2) > NoDiffMatch_CreateTeam_MAX_OBJ_DISTANCE) or arg1=="destroy") then
			--取消关心
			NoDiffMatch_CreateTeam_Hide()
		end
	end
end -- end func NoDiffMatch_CreateTeam_OnEvent()

function NoDiffMatch_CreateTeam_OnLoad()
	NoDiffMatch_CreateTeam_UnifiedPosition = NoDiffMatch_CreateTeam_Frame:GetProperty("UnifiedPosition")
	NoDiffMatch_CreateTeam_InitCtrlList()
end -- end func NoDiffMatch_CreateTeam_OnLoad()

-- 界面默认位置
function NoDiffMatch_CreateTeam_UnifiedPos()
	if (NoDiffMatch_CreateTeam_UnifiedPosition ~= nil) then
		NoDiffMatch_CreateTeam_Frame:SetProperty("UnifiedPosition", NoDiffMatch_CreateTeam_UnifiedPosition)
	end
end -- end func NoDiffMatch_CreateTeam_UnifiedPos()

function NoDiffMatch_CreateTeam_Show()
	this:Show()
end -- end func NoDiffMatch_CreateTeam_Show()

function NoDiffMatch_CreateTeam_Hide()
	NoDiffMatch_CreateTeam_StopCareObject()
	this:Hide()
end -- end func NoDiffMatch_CreateTeam_Hide()

-- 开启NPC关注
function NoDiffMatch_CreateTeam_BeginCareObject(objSvrId, objId)
	NoDiffMatch_CreateTeam_CareObjId = tonumber(objId)
	NoDiffMatch_CreateTeam_CareObjSvrId = tonumber(objSvrId)
	if (NoDiffMatch_CreateTeam_CareObjId >= 0) then
		this:CareObject(NoDiffMatch_CreateTeam_CareObjId, 1, "NoDiffMatch_CreateTeam")
	end
end -- end func NoDiffMatch_CreateTeam_BeginCareObject()

-- 取消NPC关注
function NoDiffMatch_CreateTeam_StopCareObject(objId)
	if (NoDiffMatch_CreateTeam_CareObjId >= 0) then
		this:CareObject(NoDiffMatch_CreateTeam_CareObjId, 0, "NoDiffMatch_CreateTeam")
		NoDiffMatch_CreateTeam_CareObjId = -1
		NoDiffMatch_CreateTeam_CareObjSvrId = -1
	end
end -- end func NoDiffMatch_CreateTeam_StopCareObject()

-- 初始化控件表
function NoDiffMatch_CreateTeam_InitCtrlList()
	NoDiffMatch_CreateTeam_CtrlList = {}

	NoDiffMatch_CreateTeam_CtrlList.member = {}
	NoDiffMatch_CreateTeam_CtrlList.member[1] = {}
	NoDiffMatch_CreateTeam_CtrlList.member[1].leaderflag = NoDiffMatch_CreateTeam_List1_Pic
	NoDiffMatch_CreateTeam_CtrlList.member[1].name = NoDiffMatch_CreateTeam_List1_1
	NoDiffMatch_CreateTeam_CtrlList.member[1].menpai = NoDiffMatch_CreateTeam_List1_2
	NoDiffMatch_CreateTeam_CtrlList.member[1].level = NoDiffMatch_CreateTeam_List1_3
	NoDiffMatch_CreateTeam_CtrlList.member[1].viceleader = nil
	NoDiffMatch_CreateTeam_CtrlList.member[1].viceleadertxt = nil
	NoDiffMatch_CreateTeam_CtrlList.member[2] = {}
	NoDiffMatch_CreateTeam_CtrlList.member[2].leaderflag = NoDiffMatch_CreateTeam_List2_Pic
	NoDiffMatch_CreateTeam_CtrlList.member[2].name = NoDiffMatch_CreateTeam_List2_1
	NoDiffMatch_CreateTeam_CtrlList.member[2].menpai = NoDiffMatch_CreateTeam_List2_2
	NoDiffMatch_CreateTeam_CtrlList.member[2].level = NoDiffMatch_CreateTeam_List2_3
	NoDiffMatch_CreateTeam_CtrlList.member[2].viceleader = NoDiffMatch_CreateTeam_List2_ViceLeaderBtn
	NoDiffMatch_CreateTeam_CtrlList.member[2].viceleadertxt = NoDiffMatch_CreateTeam_List2_ViceLeaderText
	NoDiffMatch_CreateTeam_CtrlList.member[3] = {}
	NoDiffMatch_CreateTeam_CtrlList.member[3].leaderflag = NoDiffMatch_CreateTeam_List3_Pic
	NoDiffMatch_CreateTeam_CtrlList.member[3].name = NoDiffMatch_CreateTeam_List3_1
	NoDiffMatch_CreateTeam_CtrlList.member[3].menpai = NoDiffMatch_CreateTeam_List3_2
	NoDiffMatch_CreateTeam_CtrlList.member[3].level = NoDiffMatch_CreateTeam_List3_3
	NoDiffMatch_CreateTeam_CtrlList.member[3].viceleader = NoDiffMatch_CreateTeam_List3_ViceLeaderBtn
	NoDiffMatch_CreateTeam_CtrlList.member[3].viceleadertxt = NoDiffMatch_CreateTeam_List3_ViceLeaderText
	NoDiffMatch_CreateTeam_CtrlList.member[4] = {}
	NoDiffMatch_CreateTeam_CtrlList.member[4].leaderflag = NoDiffMatch_CreateTeam_List4_Pic
	NoDiffMatch_CreateTeam_CtrlList.member[4].name = NoDiffMatch_CreateTeam_List4_1
	NoDiffMatch_CreateTeam_CtrlList.member[4].menpai = NoDiffMatch_CreateTeam_List4_2
	NoDiffMatch_CreateTeam_CtrlList.member[4].level = NoDiffMatch_CreateTeam_List4_3
	NoDiffMatch_CreateTeam_CtrlList.member[4].viceleader = NoDiffMatch_CreateTeam_List4_ViceLeaderBtn
	NoDiffMatch_CreateTeam_CtrlList.member[4].viceleadertxt = NoDiffMatch_CreateTeam_List4_ViceLeaderText
	NoDiffMatch_CreateTeam_CtrlList.member[5] = {}
	NoDiffMatch_CreateTeam_CtrlList.member[5].leaderflag = NoDiffMatch_CreateTeam_List5_Pic
	NoDiffMatch_CreateTeam_CtrlList.member[5].name = NoDiffMatch_CreateTeam_List5_1
	NoDiffMatch_CreateTeam_CtrlList.member[5].menpai = NoDiffMatch_CreateTeam_List5_2
	NoDiffMatch_CreateTeam_CtrlList.member[5].level = NoDiffMatch_CreateTeam_List5_3
	NoDiffMatch_CreateTeam_CtrlList.member[5].viceleader = NoDiffMatch_CreateTeam_List5_ViceLeaderBtn
	NoDiffMatch_CreateTeam_CtrlList.member[5].viceleadertxt = NoDiffMatch_CreateTeam_List5_ViceLeaderText
	NoDiffMatch_CreateTeam_CtrlList.member[6] = {}
	NoDiffMatch_CreateTeam_CtrlList.member[6].leaderflag = NoDiffMatch_CreateTeam_List6_Pic
	NoDiffMatch_CreateTeam_CtrlList.member[6].name = NoDiffMatch_CreateTeam_List6_1
	NoDiffMatch_CreateTeam_CtrlList.member[6].menpai = NoDiffMatch_CreateTeam_List6_2
	NoDiffMatch_CreateTeam_CtrlList.member[6].level = NoDiffMatch_CreateTeam_List6_3
	NoDiffMatch_CreateTeam_CtrlList.member[6].viceleader = NoDiffMatch_CreateTeam_List6_ViceLeaderBtn
	NoDiffMatch_CreateTeam_CtrlList.member[6].viceleadertxt = NoDiffMatch_CreateTeam_List6_ViceLeaderText
end -- end func NoDiffMatch_CreateTeam_InitCtrlList()

-- 关睜按钮事件
function NoDiffMatch_CreateTeam_CloseClicked()
	NoDiffMatch_CreateTeam_Hide()
end -- end func NoDiffMatch_CreateTeam_CloseClicked()

-- 副队长选择按钮事件
function NoDiffMatch_CreateTeam_ViceLeaderBtn(arg)
	local btnIndex = tonumber(arg)
	if (btnIndex < 2 or btnIndex > 6) then
		return
	end

	for i=2, 6, 1 do
		if (NoDiffMatch_CreateTeam_CtrlList.member[i] ~= nil) then
			if (i == btnIndex) then
				NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:SetCheck(1)
			else
				NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:SetCheck(0)
			end
		end
	end -- end for
end -- end func NoDiffMatch_CreateTeam_ViceLeaderBtn()

-- 创建牻队按钮事件
function NoDiffMatch_CreateTeam_Accept_Clicked()
	local teamName = NoDiffMatch_CreateTeam_Top_NameInput:GetText()
	if (teamName == nil or teamName == "") then
		PushDebugMessage("#{WCBZ_180128_73}")
		return
	end
	if (string.len(teamName) > NoDiffMatch_CreateTeam_NameLen_Max) then
		PushDebugMessage("#{WCBZ_180128_74}")
		return
	end
	-- 是否选中副队长
	local viceLeader = 0
	for i=1, 6, 1 do
		if (NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader ~= nil) then
			local checkVal = NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:GetCheck()
			if (checkVal > 0) then
				local playerName, playerGUID, playerIcon, leaderFlag, isDead = DataPool:GetTeamMemInfoExByIndex(i-1)
				viceLeader = playerGUID
				break
			end
		end
	end -- end for
	if (viceLeader == 0) then
		-- 没有选择副队长
		PushDebugMessage("#{WCBZ_240314_3}")
		return
	end

	ZBS:CreateTeam(NoDiffMatch_CreateTeam_TargetId, viceLeader, teamName)

	NoDiffMatch_CreateTeam_Hide()
end -- end func NoDiffMatch_CreateTeam_Accept_Clicked()

function NoDiffMatch_CreateTeam_Top_NameInputNull_Clicked()
	-- NoDiffMatch_CreateTeam_Top_NameInputNull:Hide()
	-- NoDiffMatch_CreateTeam_Top_NameInput:SetText("")

	-- -- 设置焦点
	-- NoDiffMatch_CreateTeam_Top_NameInput:SetProperty("DefaultEditBox", "True")
end -- end func NoDiffMatch_CreateTeam_Top_NameInputNull_Clicked()

-- 重置UI显示
function NoDiffMatch_CreateTeam_ResetUIInfo()
	if (NoDiffMatch_CreateTeam_CtrlList == nil) then
		NoDiffMatch_CreateTeam_InitCtrlList()
	end

	-- 牻队名称
	NoDiffMatch_CreateTeam_Top_NameInput:SetText("")
	-- 牻队人数
	local numText = ScriptGlobal_Format("#{WCBZ_180128_50}", 0)
	NoDiffMatch_CreateTeam_Top_Text3:SetText(numText)
	-- 牻队成员
	for i=1, 6, 1 do
		if (NoDiffMatch_CreateTeam_CtrlList.member[i] ~= nil) then
			NoDiffMatch_CreateTeam_CtrlList.member[i].leaderflag:Hide()
			NoDiffMatch_CreateTeam_CtrlList.member[i].name:Hide()
			NoDiffMatch_CreateTeam_CtrlList.member[i].menpai:Hide()
			NoDiffMatch_CreateTeam_CtrlList.member[i].level:Hide()
			if (NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader ~= nil) then
				NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:Enable()
				NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:SetCheck(0)
				NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:Hide()
				NoDiffMatch_CreateTeam_CtrlList.member[i].viceleadertxt:Hide()
			end
		end
	end -- end for
end -- end func NoDiffMatch_CreateTeam_ResetUIInfo()

-- 刷新牻队信息
function NoDiffMatch_CreateTeam_UpdateTeamInfo()
	NoDiffMatch_CreateTeam_ResetUIInfo()

	NoDiffMatch_CreateTeam_Top_NameInput:SetText("")
	NoDiffMatch_CreateTeam_Top_NameInputNull:Hide()

	local defaultViceLeader = -1
	local memCount = 0
	-- 刷新牻队成员信息
	for i=1, 6, 1 do
		local memName, memMenPai, memLevel, memDeadFlag, memLinkFlag, memSex, memZoneWorld = DataPool:GetTeamMemInfoByIndex(i-1)
		local playerName, playerGUID, playerIcon, leaderFlag, isDead = DataPool:GetTeamMemInfoExByIndex(i-1)
		if (NoDiffMatch_CreateTeam_CtrlList.member[i] ~= nil) then
			if (memLevel > 0) then
				if (leaderFlag > 0) then
					NoDiffMatch_CreateTeam_CtrlList.member[i].leaderflag:Show()
				else
					NoDiffMatch_CreateTeam_CtrlList.member[i].leaderflag:Hide()
				end
				NoDiffMatch_CreateTeam_CtrlList.member[i].name:Show()
				NoDiffMatch_CreateTeam_CtrlList.member[i].menpai:Show()
				NoDiffMatch_CreateTeam_CtrlList.member[i].level:Show()
				if (NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader ~= nil) then
					NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:Show()
					NoDiffMatch_CreateTeam_CtrlList.member[i].viceleadertxt:Show()
					-- if (defaultViceLeader <= 0 and leaderFlag <= 0) then
					-- 	defaultViceLeader = i
					-- 	NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:SetCheck(1)
					-- else
					-- 	NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:SetCheck(0)
					-- end
					NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:SetCheck(0)
				end

				NoDiffMatch_CreateTeam_CtrlList.member[i].name:SetText(memName)
				if (NoDiffMatch_CreateTeam_MenPaiName[memMenPai] ~= nil) then
					NoDiffMatch_CreateTeam_CtrlList.member[i].menpai:SetText(NoDiffMatch_CreateTeam_MenPaiName[memMenPai])
				else
					NoDiffMatch_CreateTeam_CtrlList.member[i].menpai:SetText(NoDiffMatch_CreateTeam_MenPaiName[9])
				end
				NoDiffMatch_CreateTeam_CtrlList.member[i].level:SetText(tostring(memLevel))

				memCount = memCount + 1
			else
				NoDiffMatch_CreateTeam_CtrlList.member[i].leaderflag:Hide()
				NoDiffMatch_CreateTeam_CtrlList.member[i].name:Hide()
				NoDiffMatch_CreateTeam_CtrlList.member[i].menpai:Hide()
				NoDiffMatch_CreateTeam_CtrlList.member[i].level:Hide()
				if (NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader ~= nil) then
					NoDiffMatch_CreateTeam_CtrlList.member[i].viceleader:Hide()
					NoDiffMatch_CreateTeam_CtrlList.member[i].viceleadertxt:Hide()
				end
			end
		end
	end -- end for

	-- 牻队人数
	local numText = ScriptGlobal_Format("#{WCBZ_180128_50}", memCount)
	NoDiffMatch_CreateTeam_Top_Text3:SetText(numText)

	-- 设置焦点
	NoDiffMatch_CreateTeam_Top_NameInput:SetProperty("DefaultEditBox", "True")
end -- end func NoDiffMatch_CreateTeam_UpdateTeamInfo()
