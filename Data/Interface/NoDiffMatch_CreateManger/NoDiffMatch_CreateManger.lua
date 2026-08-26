-- 狔霸赛 牻队管理UI

-- 服务器端回调脚本ID
local NoDiffMatch_CreateManger_ServerScriptId = 889961
-- 牻队最大人数
local NoDiffMatch_CreateManger_TeamMember_Max = 8
-- 目标NPCID
local NoDiffMatch_CreateManger_TargetNPC = -1
-- 当前选中的队员列表索引
local NoDiffMatch_CreateManger_SelectedIndex = -1
-- 默认位置
local NoDiffMatch_CreateManger_UnifiedPosition = nil
-- 控件表
local NoDiffMatch_CreateManger_CtrlList = nil
-- 关注NPC
local NoDiffMatch_CreateManger_CareObjId = -1
local NoDiffMatch_CreateManger_CareObjSvrId = -1
local NoDiffMatch_CreateManger_MAX_OBJ_DISTANCE = 5.0

-- 职位
local NoDiffMatch_CreateManger_Post =
{
	Member = 0,		-- ??
	Deputy = 1,		-- ???
	Leader = 2,		-- ??
} -- end NoDiffMatch_CreateManger_Post

-- 门派
local NoDiffMatch_CreateManger_MenPaiName =
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
} -- end NoDiffMatch_CreateManger_MenPaiName


function NoDiffMatch_CreateManger_PreLoad()
	this:RegisterEvent("ZBS_OPENTEAMMANAGER", true)
	this:RegisterEvent("ZBS_CLOSEUI", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func NoDiffMatch_CreateManger_PreLoad()

function NoDiffMatch_CreateManger_OnEvent(event)
	if (event == "ZBS_OPENTEAMMANAGER") then
		NoDiffMatch_CreateManger_BeginCareObject(arg0, arg1)
		
		NoDiffMatch_CreateManger_Show()
		NoDiffMatch_CreateManger_UpdateTeamInfo()

		NoDiffMatch_CreateManger_TargetNPC = tonumber(arg0)
	elseif (event == "ZBS_CLOSEUI") then
		NoDiffMatch_CreateManger_Hide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		NoDiffMatch_CreateManger_Hide()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		NoDiffMatch_CreateManger_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		NoDiffMatch_CreateManger_UnifiedPos()
	elseif (event == "OBJECT_CARED_EVENT") then
		if(NoDiffMatch_CreateManger_CareObjId < 0 or tonumber(arg0) ~= NoDiffMatch_CreateManger_CareObjId) then
			return
		end

		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if((arg1 == "distance" and tonumber(arg2) > NoDiffMatch_CreateManger_MAX_OBJ_DISTANCE) or arg1=="destroy") then
			--取消关心
			NoDiffMatch_CreateManger_Hide()
		end
	end
end -- end func NoDiffMatch_CreateManger_OnEvent()

function NoDiffMatch_CreateManger_OnLoad()
	NoDiffMatch_CreateManger_UnifiedPosition = NoDiffMatch_CreateManger_Frame:GetProperty("UnifiedPosition")
	NoDiffMatch_CreateManger_InitCtrlList()
end -- end func NoDiffMatch_CreateManger_OnLoad()

-- 界面默认位置
function NoDiffMatch_CreateManger_UnifiedPos()
	if (NoDiffMatch_CreateManger_UnifiedPosition ~= nil) then
		NoDiffMatch_CreateManger_Frame:SetProperty("UnifiedPosition", NoDiffMatch_CreateManger_UnifiedPosition)
	end
end -- end func NoDiffMatch_CreateManger_UnifiedPos()

function NoDiffMatch_CreateManger_Show()
	this:Show()
end -- end func NoDiffMatch_CreateManger_Show()

function NoDiffMatch_CreateManger_Hide()
	NoDiffMatch_CreateManger_StopCareObject()
	this:Hide()
end -- end func NoDiffMatch_CreateManger_Hide()

-- 开启NPC关注
function NoDiffMatch_CreateManger_BeginCareObject(objSvrId, objId)
	NoDiffMatch_CreateManger_CareObjId = tonumber(objId)
	NoDiffMatch_CreateManger_CareObjSvrId = tonumber(objSvrId)
	if (NoDiffMatch_CreateManger_CareObjId >= 0) then
		this:CareObject(NoDiffMatch_CreateManger_CareObjId, 1, "NoDiffMatch_CreateManger")
	end
end -- end func NoDiffMatch_CreateManger_BeginCareObject()

-- 取消NPC关注
function NoDiffMatch_CreateManger_StopCareObject()
	if (NoDiffMatch_CreateManger_CareObjId >= 0) then
		this:CareObject(NoDiffMatch_CreateManger_CareObjId, 0, "NoDiffMatch_CreateManger")
		NoDiffMatch_CreateManger_CareObjId = -1
		NoDiffMatch_CreateManger_CareObjSvrId = -1
	end
end -- end func NoDiffMatch_CreateManger_StopCareObject()

-- 关睜按钮事件
function NoDiffMatch_CreateManger_CloseClicked()
	NoDiffMatch_CreateManger_Hide()
end -- end func NoDiffMatch_CreateManger_CloseClicked()

-- 邀请加入按钮事件
function NoDiffMatch_CreateManger_Invite_Clicked()
	-- 判断自己是不是队长或副队长
	local guid, menpai, level, post, consume, name = ZBS:GetMyTeamInfo()
	if (post ~= NoDiffMatch_CreateManger_Post.Leader and post ~= NoDiffMatch_CreateManger_Post.Deputy) then
		-- 自己不是队长或副队长
		PushDebugMessage("#{WCBZ_180128_115}")
		return -1
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CallBack_TryInvite")
		Set_XSCRIPT_ScriptID(NoDiffMatch_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, NoDiffMatch_CreateManger_TargetNPC)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	NoDiffMatch_CreateManger_Hide()
end -- end func NoDiffMatch_CreateManger_Invite_Clicked()

-- 任命副队长按钮事件
function NoDiffMatch_CreateManger_Leader_Clicked()
	-- 判断自己是不是队长
	if (ZBS:IsLeader() <= 0) then
		-- 自己不是队长
		PushDebugMessage("#{WCBZ_180128_148}")
		return -1
	end

	-- if (ZBS:IsHasDeputy() > 0) then
	-- 	-- 牻队中已有副队长
	-- 	PushDebugMessage("#{WCBZ_180128_149}")
	-- 	return -2
	-- end

	if (NoDiffMatch_CreateManger_SelectedIndex <= 0 or NoDiffMatch_CreateManger_SelectedIndex > NoDiffMatch_CreateManger_TeamMember_Max) then
		PushDebugMessage("#{WCBZ_180128_150}")
		return -3
	end

	-- 获取选中的队员信息
	local memberName = NoDiffMatch_CreateManger_CtrlList[NoDiffMatch_CreateManger_SelectedIndex].name:GetText()
	local guid, menpai, level, post, consume, name = ZBS:GetTeamMemberInfoByName(memberName)
	if (guid <= 0) then
		PushDebugMessage("#{WCBZ_180128_150}")
		return -4
	end
	if (post == NoDiffMatch_CreateManger_Post.Leader) then
		PushDebugMessage("#{WCBZ_180128_151}")
		return -5
	end
	if (post == NoDiffMatch_CreateManger_Post.Deputy) then
		PushDebugMessage("#{WCBZ_180128_149}")
		return -6
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CallBack_TryAppointToDeputy")
		Set_XSCRIPT_ScriptID(NoDiffMatch_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, NoDiffMatch_CreateManger_TargetNPC)
		Set_XSCRIPT_Parameter(1, guid)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

	NoDiffMatch_CreateManger_Hide()
	return 1
end -- end func NoDiffMatch_CreateManger_Leader_Clicked()

-- 解除副队长职务按钮事件
function NoDiffMatch_CreateManger_NoLeader_Clicked()
	-- 判断自己是不是队长
	if (ZBS:IsLeader() <= 0) then
		-- 自己不是队长
		PushDebugMessage("#{WCBZ_180128_148}")
		return -1
	end

	if (ZBS:IsHasDeputy() <= 0) then
		-- 牻队中没有副队长
		PushDebugMessage("#{WCBZ_180128_153}")
		return -2
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CallBack_TryRemovalDeputy")
		Set_XSCRIPT_ScriptID(NoDiffMatch_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, NoDiffMatch_CreateManger_TargetNPC)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	NoDiffMatch_CreateManger_Hide()
	return 1
end -- end func NoDiffMatch_CreateManger_NoLeader_Clicked()

-- 解散牻队按钮事件
function NoDiffMatch_CreateManger_Dismiss_Clicked()
	-- 判断自己是不是队长
	if (ZBS:IsLeader() <= 0) then
		-- 自己不是队长
		PushDebugMessage("#{WCBZ_180128_148}")
		return -1
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CallBack_TryDismiss")
		Set_XSCRIPT_ScriptID(NoDiffMatch_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, NoDiffMatch_CreateManger_TargetNPC)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	NoDiffMatch_CreateManger_Hide()
end -- end func NoDiffMatch_CreateManger_Dismiss_Clicked()

-- 请离牻队按钮事件
function NoDiffMatch_CreateManger_PickOut_Clicked()
	-- 判断自己是不是队长
	if (ZBS:IsLeader() <= 0) then
		-- 自己不是队长
		PushDebugMessage("#{WCBZ_180128_148}")
		return -1
	end

	if (NoDiffMatch_CreateManger_SelectedIndex <= 0 or NoDiffMatch_CreateManger_SelectedIndex > NoDiffMatch_CreateManger_TeamMember_Max) then
		PushDebugMessage("#{WCBZ_180128_150}")
		return -2
	end

	-- 获取选中的队员信息
	local memberName = NoDiffMatch_CreateManger_CtrlList[NoDiffMatch_CreateManger_SelectedIndex].name:GetText()
	local guid, menpai, level, post, consume, name = ZBS:GetTeamMemberInfoByName(memberName)
	if (guid <= 0) then
		PushDebugMessage("#{WCBZ_180128_150}")
		return -3
	end
	if (post == NoDiffMatch_CreateManger_Post.Leader) then
		PushDebugMessage("#{WCBZ_180128_156}")
		return -4
	end
	if (post == NoDiffMatch_CreateManger_Post.Deputy) then
		PushDebugMessage("#{WCBZ_180128_160}")
		return -5
	end

	-- 通知server删除队员
	ZBS:DeleteMember(NoDiffMatch_CreateManger_TargetNPC, guid, name)

	NoDiffMatch_CreateManger_Hide()
	return 1
end -- end func NoDiffMatch_CreateManger_PickOut_Clicked()

-- 退出牻队按钮事件
function NoDiffMatch_CreateManger_OutTeam_Clicked()
	-- 判断自己是不是队长
	if (ZBS:IsLeader() > 0) then
		-- 自己是队长
		PushDebugMessage("#{WCBZ_180128_169}")
		return -1
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CallBack_TryQuit")
		Set_XSCRIPT_ScriptID(NoDiffMatch_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, NoDiffMatch_CreateManger_TargetNPC)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	NoDiffMatch_CreateManger_Hide()
end -- end func NoDiffMatch_CreateManger_OutTeam_Clicked()

-- 牻队成员列表点击事件
function NoDiffMatch_CreateManger_ToggleMemberMenu(arg)
end -- end func NoDiffMatch_CreateManger_ToggleMemberMenu()

-- 牻队成员列表点击事件
function NoDiffMatch_CreateManger_Clicked(arg)
	local index = tonumber(arg)
	if (index <= 0 or index > NoDiffMatch_CreateManger_TeamMember_Max) then
		return -1
	end

	NoDiffMatch_CreateManger_SelectedIndex = index

	NoDiffMatch_CreateManger_UpdateSelect(NoDiffMatch_CreateManger_SelectedIndex)

	return index
end -- end func NoDiffMatch_CreateManger_Clicked()

-- 牻队成员列表点击事件
function NoDiffMatch_CreateManger_DragStarted()
end -- end func NoDiffMatch_CreateManger_DragStarted()

-- 初始化控件表
function NoDiffMatch_CreateManger_InitCtrlList()
	NoDiffMatch_CreateManger_CtrlList = {}
	NoDiffMatch_CreateManger_CtrlList[1] = {}
	NoDiffMatch_CreateManger_CtrlList[1].leaderflag = NoDiffMatch_CreateManger_List1_Pic
	NoDiffMatch_CreateManger_CtrlList[1].name = NoDiffMatch_CreateManger_List1_1
	NoDiffMatch_CreateManger_CtrlList[1].menpai = NoDiffMatch_CreateManger_List1_2
	NoDiffMatch_CreateManger_CtrlList[1].level = NoDiffMatch_CreateManger_List1_3
	NoDiffMatch_CreateManger_CtrlList[1].gaoliang = NoDiffMatch_CreateManger_List1_Bk_Gaoliang
	NoDiffMatch_CreateManger_CtrlList[2] = {}
	NoDiffMatch_CreateManger_CtrlList[2].leaderflag = NoDiffMatch_CreateManger_List2_Pic
	NoDiffMatch_CreateManger_CtrlList[2].name = NoDiffMatch_CreateManger_List2_1
	NoDiffMatch_CreateManger_CtrlList[2].menpai = NoDiffMatch_CreateManger_List2_2
	NoDiffMatch_CreateManger_CtrlList[2].level = NoDiffMatch_CreateManger_List2_3
	NoDiffMatch_CreateManger_CtrlList[2].gaoliang = NoDiffMatch_CreateManger_List2_Bk_Gaoliang
	NoDiffMatch_CreateManger_CtrlList[3] = {}
	NoDiffMatch_CreateManger_CtrlList[3].leaderflag = NoDiffMatch_CreateManger_List3_Pic
	NoDiffMatch_CreateManger_CtrlList[3].name = NoDiffMatch_CreateManger_List3_1
	NoDiffMatch_CreateManger_CtrlList[3].menpai = NoDiffMatch_CreateManger_List3_2
	NoDiffMatch_CreateManger_CtrlList[3].level = NoDiffMatch_CreateManger_List3_3
	NoDiffMatch_CreateManger_CtrlList[3].gaoliang = NoDiffMatch_CreateManger_List3_Bk_Gaoliang
	NoDiffMatch_CreateManger_CtrlList[4] = {}
	NoDiffMatch_CreateManger_CtrlList[4].leaderflag = NoDiffMatch_CreateManger_List4_Pic
	NoDiffMatch_CreateManger_CtrlList[4].name = NoDiffMatch_CreateManger_List4_1
	NoDiffMatch_CreateManger_CtrlList[4].menpai = NoDiffMatch_CreateManger_List4_2
	NoDiffMatch_CreateManger_CtrlList[4].level = NoDiffMatch_CreateManger_List4_3
	NoDiffMatch_CreateManger_CtrlList[4].gaoliang = NoDiffMatch_CreateManger_List4_Bk_Gaoliang
	NoDiffMatch_CreateManger_CtrlList[5] = {}
	NoDiffMatch_CreateManger_CtrlList[5].leaderflag = NoDiffMatch_CreateManger_List5_Pic
	NoDiffMatch_CreateManger_CtrlList[5].name = NoDiffMatch_CreateManger_List5_1
	NoDiffMatch_CreateManger_CtrlList[5].menpai = NoDiffMatch_CreateManger_List5_2
	NoDiffMatch_CreateManger_CtrlList[5].level = NoDiffMatch_CreateManger_List5_3
	NoDiffMatch_CreateManger_CtrlList[5].gaoliang = NoDiffMatch_CreateManger_List5_Bk_Gaoliang
	NoDiffMatch_CreateManger_CtrlList[6] = {}
	NoDiffMatch_CreateManger_CtrlList[6].leaderflag = NoDiffMatch_CreateManger_List6_Pic
	NoDiffMatch_CreateManger_CtrlList[6].name = NoDiffMatch_CreateManger_List6_1
	NoDiffMatch_CreateManger_CtrlList[6].menpai = NoDiffMatch_CreateManger_List6_2
	NoDiffMatch_CreateManger_CtrlList[6].level = NoDiffMatch_CreateManger_List6_3
	NoDiffMatch_CreateManger_CtrlList[6].gaoliang = NoDiffMatch_CreateManger_List6_Bk_Gaoliang
	NoDiffMatch_CreateManger_CtrlList[7] = {}
	NoDiffMatch_CreateManger_CtrlList[7].leaderflag = NoDiffMatch_CreateManger_List7_Pic
	NoDiffMatch_CreateManger_CtrlList[7].name = NoDiffMatch_CreateManger_List7_1
	NoDiffMatch_CreateManger_CtrlList[7].menpai = NoDiffMatch_CreateManger_List7_2
	NoDiffMatch_CreateManger_CtrlList[7].level = NoDiffMatch_CreateManger_List7_3
	NoDiffMatch_CreateManger_CtrlList[7].gaoliang = NoDiffMatch_CreateManger_List7_Bk_Gaoliang
	NoDiffMatch_CreateManger_CtrlList[8] = {}
	NoDiffMatch_CreateManger_CtrlList[8].leaderflag = NoDiffMatch_CreateManger_List8_Pic
	NoDiffMatch_CreateManger_CtrlList[8].name = NoDiffMatch_CreateManger_List8_1
	NoDiffMatch_CreateManger_CtrlList[8].menpai = NoDiffMatch_CreateManger_List8_2
	NoDiffMatch_CreateManger_CtrlList[8].level = NoDiffMatch_CreateManger_List8_3
	NoDiffMatch_CreateManger_CtrlList[8].gaoliang = NoDiffMatch_CreateManger_List8_Bk_Gaoliang
end -- end func NoDiffMatch_CreateManger_InitCtrlList()

-- 刷新选择高亮显示
function NoDiffMatch_CreateManger_UpdateSelect(selectIndex)
	for i=1, NoDiffMatch_CreateManger_TeamMember_Max, 1 do
		local memberCtrl = NoDiffMatch_CreateManger_CtrlList[i]
		if (memberCtrl ~= nil) then
			memberCtrl.gaoliang:Hide()
		end
	end -- end for

	if (selectIndex > 0) then
		local ctrl = NoDiffMatch_CreateManger_CtrlList[selectIndex]
		if (ctrl ~= nil) then
			ctrl.gaoliang:Show()
		end
	end
end -- end func NoDiffMatch_CreateManger_UpdateSelect()

-- 刷新牻队数据
function NoDiffMatch_CreateManger_UpdateTeamInfo()
	if (NoDiffMatch_CreateManger_CtrlList == nil) then
		NoDiffMatch_CreateManger_InitCtrlList()
	end

	NoDiffMatch_CreateManger_UpdateSelect(-1)

	NoDiffMatch_CreateManger_SelectedIndex = -1

	if (ZBS:IsLeader() > 0) then
		-- 自己是队长
		NoDiffMatch_CreateManger_AddMember:Enable()			-- ????
		if (ZBS:IsHasDeputy() > 0) then
			-- 已有副队长 屏蔽任命副队长按钮
			--NoDiffMatch_CreateManger_ViceLeader:Disable()	-- 任命副队长按钮
			NoDiffMatch_CreateManger_ViceLeader:Enable()
			NoDiffMatch_CreateManger_NoLeader:Enable()		-- ?????????
		else
			-- 没有副队长 屏蔽解除副队长按钮
			NoDiffMatch_CreateManger_NoLeader:Disable()		-- ?????????
			NoDiffMatch_CreateManger_ViceLeader:Enable()	-- ???????
		end
		NoDiffMatch_CreateManger_Dissolve:Enable()			-- ??????
		NoDiffMatch_CreateManger_Fire:Enable()				-- ??????
		NoDiffMatch_CreateManger_Leave:Enable()				-- ??????
	elseif (ZBS:IsDeputy() > 0) then
		-- 自己是副队长
		NoDiffMatch_CreateManger_AddMember:Enable()			-- ????
		NoDiffMatch_CreateManger_ViceLeader:Disable()		-- ???????
		NoDiffMatch_CreateManger_NoLeader:Disable()			-- ?????????
		NoDiffMatch_CreateManger_Dissolve:Disable()			-- ??????
		NoDiffMatch_CreateManger_Fire:Disable()				-- ??????
		NoDiffMatch_CreateManger_Leave:Enable()				-- ??????
	else
		-- 自己是队员
		NoDiffMatch_CreateManger_AddMember:Disable()		-- ????
		NoDiffMatch_CreateManger_ViceLeader:Disable()		-- ???????
		NoDiffMatch_CreateManger_NoLeader:Disable()			-- ?????????
		NoDiffMatch_CreateManger_Dissolve:Disable()			-- ??????
		NoDiffMatch_CreateManger_Fire:Disable()				-- ??????
		NoDiffMatch_CreateManger_Leave:Enable()				-- ??????
	end

	for i=1, NoDiffMatch_CreateManger_TeamMember_Max, 1 do
		local memberCtrl = NoDiffMatch_CreateManger_CtrlList[i]
		memberCtrl.leaderflag:Hide()
		memberCtrl.name:Hide()
		memberCtrl.menpai:Hide()
		memberCtrl.level:Hide()
	end -- end for

	local totalConsume = 0
	local ctrlIndex = 1
	for i=1, NoDiffMatch_CreateManger_TeamMember_Max, 1 do
		local memberCtrl = NoDiffMatch_CreateManger_CtrlList[ctrlIndex]
		local guid, menpai, level, post, consume, name = ZBS:GetTeamMemberInfo(i-1)
		if (guid > 0) then
			ctrlIndex = ctrlIndex + 1
			local menpaiName = NoDiffMatch_CreateManger_MenPaiName[menpai]
			if (post == NoDiffMatch_CreateManger_Post.Leader) then
				memberCtrl.leaderflag:Show()
			elseif (post == NoDiffMatch_CreateManger_Post.Deputy) then
				memberCtrl.leaderflag:Show()
			else
				memberCtrl.leaderflag:Hide()
			end

			memberCtrl.name:Show()
			memberCtrl.name:SetText(name)

			memberCtrl.menpai:Show()
			memberCtrl.menpai:SetText(menpaiName)
			
			memberCtrl.level:Show()
			memberCtrl.level:SetText(tostring(level))

			totalConsume = totalConsume + consume
		end
	end -- end for

	--local totalScore = ScriptGlobal_Format("#{WCBZ_180128_616}", totalConsume)
	--NoDiffMatch_CreateManger_TeamScore:SetText(totalScore)

	local teamName = ZBS:GetTeamName()
	local teamNameStr = ScriptGlobal_Format("#{WCBZ_180128_87}", teamName)
	NoDiffMatch_CreateManger_PageHeader_Name:SetText(teamNameStr)
end -- end func NoDiffMatch_CreateManger_UpdateTeamInfo()
