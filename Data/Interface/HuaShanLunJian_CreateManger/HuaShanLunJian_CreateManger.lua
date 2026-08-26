-- 新6v6 牻队管理UI

-- 服务器端回调脚本ID
local HuaShanLunJian_CreateManger_ServerScriptId = 998497
-- 牻队最大人数
local HuaShanLunJian_CreateManger_TeamMember_Max = 6
-- 当前选中的队员列表索引
local HuaShanLunJian_CreateManger_SelectedIndex = -1
-- 霸剑段位id
local HuaShanLunJian_CreateManger_BaJianDuanWei = 6
-- 关注NPC
local HuaShanLunJian_CreateManger_CareObjId = -1
local HuaShanLunJian_CreateManger_CareObjSvrId = -1
local HuaShanLunJian_CreateManger_MAX_OBJ_DISTANCE = 5.0
-- 默认位置
local HuaShanLunJian_CreateManger_UnifiedPosition = nil
-- 控件表
local HuaShanLunJian_CreateManger_CtrlList = nil

-- 职位
local HuaShanLunJian_CreateManger_Post =
{
	Member = 0,		-- ??
	Deputy = 1,		-- ???
	Leader = 2,		-- ??
} -- end HuaShanLunJian_CreateManger_Post

local HuaShanLunJian_CreateManger_DuanWei1Str =
{
	[1] = "#{HSLJ_190919_145}",
	[2] = "#{HSLJ_190919_146}",
	[3] = "#{HSLJ_190919_147}",
	[4] = "#{HSLJ_190919_148}",
	[5] = "#{HSLJ_190919_149}",
	[6] = "#{HSLJ_190919_157}",
} -- end HuaShanLunJian_CreateManger_DuanWei1Str

local HuaShanLunJian_CreateManger_DuanWei2Str =
{
	[1] = "#{HSLJ_190919_154}",
	[2] = "#{HSLJ_190919_153}",
	[3] = "#{HSLJ_190919_152}",
	[4] = "#{HSLJ_190919_151}",
	[5] = "#{HSLJ_190919_150}",
} -- end HuaShanLunJian_CreateManger_DuanWei2Str

-- 门派
local HuaShanLunJian_CreateManger_MenPaiName =
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
	[9] = "#{JZGN_20230710_138}",	--???
	[10] = "#{WCBZ_220809_53}",		--???? 
} -- end HuaShanLunJian_CreateManger_MenPaiName


function HuaShanLunJian_CreateManger_PreLoad()
	this:RegisterEvent("XBW_OPENTEAMMANAGE", true)
	this:RegisterEvent("XBW_CLOSETEAMMANAGE", true)
	this:RegisterEvent("XBW_CLOSEUI", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func HuaShanLunJian_CreateManger_PreLoad()

function HuaShanLunJian_CreateManger_OnEvent(event)
	if (event == "XBW_OPENTEAMMANAGE") then
		HuaShanLunJian_CreateManger_BeginCareObject(arg0, arg1)
		
		HuaShanLunJian_CreateManger_Show()
		HuaShanLunJian_CreateManger_UpdateTeamInfo()
	elseif (event == "XBW_CLOSETEAMMANAGE") then
		HuaShanLunJian_CreateManger_Hide()
	elseif (event == "XBW_CLOSEUI") then
		HuaShanLunJian_CreateManger_Hide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HuaShanLunJian_CreateManger_Hide()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_CreateManger_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		HuaShanLunJian_CreateManger_UnifiedPos()
	elseif (event == "OBJECT_CARED_EVENT") then
		if(HuaShanLunJian_CreateManger_CareObjId < 0 or tonumber(arg0) ~= HuaShanLunJian_CreateManger_CareObjId) then
			return
		end

		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if((arg1 == "distance" and tonumber(arg2) > HuaShanLunJian_CreateManger_MAX_OBJ_DISTANCE) or arg1=="destroy") then
			--取消关心
			HuaShanLunJian_CreateManger_Hide()
		end
	end
end -- end func HuaShanLunJian_CreateManger_OnEvent()

function HuaShanLunJian_CreateManger_OnLoad()
	HuaShanLunJian_CreateManger_UnifiedPosition = HuaShanLunJian_CreateManger_Frame:GetProperty("UnifiedPosition")
	HuaShanLunJian_CreateManger_InitCtrlList()
end -- end func HuaShanLunJian_CreateManger_OnLoad()

-- 界面默认位置
function HuaShanLunJian_CreateManger_UnifiedPos()
	if (HuaShanLunJian_CreateManger_UnifiedPosition ~= nil) then
		HuaShanLunJian_CreateManger_Frame:SetProperty("UnifiedPosition", HuaShanLunJian_CreateManger_UnifiedPosition)
	end
end -- end func HuaShanLunJian_CreateManger_UnifiedPos()

function HuaShanLunJian_CreateManger_Show()
	this:Show()

	PushEvent("XBW_CLOSECREATETEAM")
end -- end func HuaShanLunJian_CreateManger_Show()

function HuaShanLunJian_CreateManger_Hide()
	HuaShanLunJian_CreateManger_StopCareObject()
	this:Hide()
end -- end func HuaShanLunJian_CreateManger_Hide()

-- 开启NPC关注
function HuaShanLunJian_CreateManger_BeginCareObject(objSvrId, objId)
	HuaShanLunJian_CreateManger_CareObjId = tonumber(objId)
	HuaShanLunJian_CreateManger_CareObjSvrId = tonumber(objSvrId)
	if (HuaShanLunJian_CreateManger_CareObjId >= 0) then
		this:CareObject(HuaShanLunJian_CreateManger_CareObjId, 1, "HuaShanLunJian_CreateManger")
	end
end -- end func HuaShanLunJian_CreateManger_BeginCareObject()

-- 取消NPC关注
function HuaShanLunJian_CreateManger_StopCareObject()
	if (HuaShanLunJian_CreateManger_CareObjId >= 0) then
		this:CareObject(HuaShanLunJian_CreateManger_CareObjId, 0, "HuaShanLunJian_CreateManger")
		HuaShanLunJian_CreateManger_CareObjId = -1
		HuaShanLunJian_CreateManger_CareObjSvrId = -1
	end
end -- end func HuaShanLunJian_CreateManger_StopCareObject()

-- 关睜按钮事件
function HuaShanLunJian_CreateManger_CloseClicked()
	HuaShanLunJian_CreateManger_Hide()
end -- end func HuaShanLunJian_CreateManger_CloseClicked()

-- 邀请加入按钮事件
function HuaShanLunJian_CreateManger_Invite_Clicked()
	-- 判断自己是不是队长或副队长
	local guid, menpai, level, post, consume, name = NewXBW:GetMyTeamInfo()
	if (post ~= HuaShanLunJian_CreateManger_Post.Leader and post ~= HuaShanLunJian_CreateManger_Post.Deputy) then
		-- 自己不是队长或副队长
		PushDebugMessage("#{JZGN_20230710_65}")
		return -1
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CCallBack_TryInvite")
		Set_XSCRIPT_ScriptID(HuaShanLunJian_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, HuaShanLunJian_CreateManger_CareObjSvrId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	HuaShanLunJian_CreateManger_Hide()
end -- end func HuaShanLunJian_CreateManger_Invite_Clicked()

-- 任命副队长按钮事件
function HuaShanLunJian_CreateManger_Leader_Clicked()
	-- 判断自己是不是队长
	if (NewXBW:IsLeader() <= 0) then
		-- 自己不是队长
		PushDebugMessage("#{JZGN_20230710_88}")
		return -1
	end

	if (NewXBW:IsHasDeputy() > 0) then
		-- 牻队中已有副队长
		PushDebugMessage("#{JZGN_20230710_89}")
		return -2
	end

	if (HuaShanLunJian_CreateManger_SelectedIndex <= 0 or HuaShanLunJian_CreateManger_SelectedIndex > HuaShanLunJian_CreateManger_TeamMember_Max) then
		PushDebugMessage("#{JZGN_20230710_90}")
		return -3
	end

	-- 获取选中的队员信息
	-- local memberName = HuaShanLunJian_CreateManger_CtrlList[HuaShanLunJian_CreateManger_SelectedIndex].name:GetText()
	-- local guid, menpai, level, post, consume, duanwei1, duanwei2, dunawei3, name = NewXBW:GetMyTeamMemberInfoByName(memberName)
	local guid, menpai, level, post, consume, duanwei1, duanwei2, dunawei3, name = NewXBW:GetMyTeamMemberInfo(HuaShanLunJian_CreateManger_SelectedIndex-1)
	if (guid <= 0) then
		PushDebugMessage("#{JZGN_20230710_90}")
		return -4
	end
	if (post == HuaShanLunJian_CreateManger_Post.Leader or post == HuaShanLunJian_CreateManger_Post.Deputy) then
		PushDebugMessage("#{JZGN_20230710_91}")
		return -5
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CCallBack_TryAppointToDeputy")
		Set_XSCRIPT_ScriptID(HuaShanLunJian_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, HuaShanLunJian_CreateManger_CareObjSvrId)
		Set_XSCRIPT_Parameter(1, guid)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

	HuaShanLunJian_CreateManger_Hide()
	return 1
end -- end func HuaShanLunJian_CreateManger_Leader_Clicked()

-- 解除副队长职务按钮事件
function HuaShanLunJian_CreateManger_NoLeader_Clicked()
	-- 判断自己是不是队长
	if (NewXBW:IsLeader() <= 0) then
		-- 自己不是队长
		PushDebugMessage("#{JZGN_20230710_88}")
		return -1
	end

	if (NewXBW:IsHasDeputy() <= 0) then
		-- 牻队中没有副队长
		PushDebugMessage("#{JZGN_20230710_94}")
		return -2
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CCallBack_TryRemovalDeputy")
		Set_XSCRIPT_ScriptID(HuaShanLunJian_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, HuaShanLunJian_CreateManger_CareObjSvrId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	HuaShanLunJian_CreateManger_Hide()
	return 1
end -- end func HuaShanLunJian_CreateManger_NoLeader_Clicked()

-- 解散牻队按钮事件
function HuaShanLunJian_CreateManger_Dismiss_Clicked()
	-- 判断自己是不是队长
	if (NewXBW:IsLeader() <= 0) then
		-- 自己不是队长
		PushDebugMessage("#{JZGN_20230710_88}")
		return -1
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CCallBack_TryDismiss")
		Set_XSCRIPT_ScriptID(HuaShanLunJian_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, HuaShanLunJian_CreateManger_CareObjSvrId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	HuaShanLunJian_CreateManger_Hide()
end -- end func HuaShanLunJian_CreateManger_Dismiss_Clicked()

-- 请离牻队按钮事件
function HuaShanLunJian_CreateManger_PickOut_Clicked()
	-- 判断自己是不是队长
	if (NewXBW:IsLeader() <= 0) then
		-- 自己不是队长
		PushDebugMessage("#{JZGN_20230710_88}")
		return -1
	end

	if (HuaShanLunJian_CreateManger_SelectedIndex <= 0 or HuaShanLunJian_CreateManger_SelectedIndex > HuaShanLunJian_CreateManger_TeamMember_Max) then
		PushDebugMessage("#{JZGN_20230710_90}")
		return -2
	end

	-- 获取选中的队员信息
	-- local memberName = HuaShanLunJian_CreateManger_CtrlList[HuaShanLunJian_CreateManger_SelectedIndex].name:GetText()
	-- local guid, menpai, level, post, consume, duanwei1, duanwei2, dunawei3, name = NewXBW:GetMyTeamMemberInfoByName(memberName)
	local guid, menpai, level, post, consume, duanwei1, duanwei2, dunawei3, name = NewXBW:GetMyTeamMemberInfo(HuaShanLunJian_CreateManger_SelectedIndex-1)
	if (guid <= 0) then
		PushDebugMessage("#{JZGN_20230710_90}")
		return -3
	end
	if (post == HuaShanLunJian_CreateManger_Post.Leader) then
		PushDebugMessage("#{JZGN_20230710_103}")
		return -4
	end
	if (post == HuaShanLunJian_CreateManger_Post.Deputy) then
		PushDebugMessage("#{JZGN_20230710_97}")
		return -5
	end

	-- 通知server删除队员
	NewXBW:DeleteMember(HuaShanLunJian_CreateManger_CareObjSvrId, guid, name)

	HuaShanLunJian_CreateManger_Hide()
	return 1
end -- end func HuaShanLunJian_CreateManger_PickOut_Clicked()

-- 退出牻队按钮事件
function HuaShanLunJian_CreateManger_OutTeam_Clicked()
	-- 判断自己是不是队长
	if (NewXBW:IsLeader() > 0) then
		-- 自己是队长
		PushDebugMessage("#{JZGN_20230710_111}")
		return -1
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CCallBack_TryQuit")
		Set_XSCRIPT_ScriptID(HuaShanLunJian_CreateManger_ServerScriptId)
		Set_XSCRIPT_Parameter(0, HuaShanLunJian_CreateManger_CareObjSvrId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	HuaShanLunJian_CreateManger_Hide()
end -- end func HuaShanLunJian_CreateManger_OutTeam_Clicked()

-- 牻队成员列表点击事件
function HuaShanLunJian_CreateManger_ToggleMemberMenu(arg)
end -- end func HuaShanLunJian_CreateManger_ToggleMemberMenu()

-- 牻队成员列表点击事件
function HuaShanLunJian_CreateManger_Clicked(arg)
	local index = tonumber(arg)
	if (index <= 0 or index > HuaShanLunJian_CreateManger_TeamMember_Max) then
		return -1
	end

	HuaShanLunJian_CreateManger_SelectedIndex = index

	HuaShanLunJian_CreateManger_UpdateSelect(HuaShanLunJian_CreateManger_SelectedIndex)

	return index
end -- end func HuaShanLunJian_CreateManger_Clicked()

-- 牻队成员列表点击事件
function HuaShanLunJian_CreateManger_DragStarted()
end -- end func HuaShanLunJian_CreateManger_DragStarted()

-- 初始化控件表
function HuaShanLunJian_CreateManger_InitCtrlList()
	HuaShanLunJian_CreateManger_CtrlList = {}
	HuaShanLunJian_CreateManger_CtrlList[1] = {}
	HuaShanLunJian_CreateManger_CtrlList[1].leaderflag = HuaShanLunJian_CreateManger_List1_Pic
	HuaShanLunJian_CreateManger_CtrlList[1].name = HuaShanLunJian_CreateManger_List1_1
	HuaShanLunJian_CreateManger_CtrlList[1].menpai = HuaShanLunJian_CreateManger_List1_2
	HuaShanLunJian_CreateManger_CtrlList[1].level = HuaShanLunJian_CreateManger_List1_3
	HuaShanLunJian_CreateManger_CtrlList[1].duanwei = HuaShanLunJian_CreateManger_List1_4
	HuaShanLunJian_CreateManger_CtrlList[1].gaoliang = HuaShanLunJian_CreateManger_List1_Bk_Gaoliang
	HuaShanLunJian_CreateManger_CtrlList[2] = {}
	HuaShanLunJian_CreateManger_CtrlList[2].leaderflag = HuaShanLunJian_CreateManger_List2_Pic
	HuaShanLunJian_CreateManger_CtrlList[2].name = HuaShanLunJian_CreateManger_List2_1
	HuaShanLunJian_CreateManger_CtrlList[2].menpai = HuaShanLunJian_CreateManger_List2_2
	HuaShanLunJian_CreateManger_CtrlList[2].level = HuaShanLunJian_CreateManger_List2_3
	HuaShanLunJian_CreateManger_CtrlList[2].duanwei = HuaShanLunJian_CreateManger_List2_4
	HuaShanLunJian_CreateManger_CtrlList[2].gaoliang = HuaShanLunJian_CreateManger_List2_Bk_Gaoliang
	HuaShanLunJian_CreateManger_CtrlList[3] = {}
	HuaShanLunJian_CreateManger_CtrlList[3].leaderflag = HuaShanLunJian_CreateManger_List3_Pic
	HuaShanLunJian_CreateManger_CtrlList[3].name = HuaShanLunJian_CreateManger_List3_1
	HuaShanLunJian_CreateManger_CtrlList[3].menpai = HuaShanLunJian_CreateManger_List3_2
	HuaShanLunJian_CreateManger_CtrlList[3].level = HuaShanLunJian_CreateManger_List3_3
	HuaShanLunJian_CreateManger_CtrlList[3].duanwei = HuaShanLunJian_CreateManger_List3_4
	HuaShanLunJian_CreateManger_CtrlList[3].gaoliang = HuaShanLunJian_CreateManger_List3_Bk_Gaoliang
	HuaShanLunJian_CreateManger_CtrlList[4] = {}
	HuaShanLunJian_CreateManger_CtrlList[4].leaderflag = HuaShanLunJian_CreateManger_List4_Pic
	HuaShanLunJian_CreateManger_CtrlList[4].name = HuaShanLunJian_CreateManger_List4_1
	HuaShanLunJian_CreateManger_CtrlList[4].menpai = HuaShanLunJian_CreateManger_List4_2
	HuaShanLunJian_CreateManger_CtrlList[4].level = HuaShanLunJian_CreateManger_List4_3
	HuaShanLunJian_CreateManger_CtrlList[4].duanwei = HuaShanLunJian_CreateManger_List4_4
	HuaShanLunJian_CreateManger_CtrlList[4].gaoliang = HuaShanLunJian_CreateManger_List4_Bk_Gaoliang
	HuaShanLunJian_CreateManger_CtrlList[5] = {}
	HuaShanLunJian_CreateManger_CtrlList[5].leaderflag = HuaShanLunJian_CreateManger_List5_Pic
	HuaShanLunJian_CreateManger_CtrlList[5].name = HuaShanLunJian_CreateManger_List5_1
	HuaShanLunJian_CreateManger_CtrlList[5].menpai = HuaShanLunJian_CreateManger_List5_2
	HuaShanLunJian_CreateManger_CtrlList[5].level = HuaShanLunJian_CreateManger_List5_3
	HuaShanLunJian_CreateManger_CtrlList[5].duanwei = HuaShanLunJian_CreateManger_List5_4
	HuaShanLunJian_CreateManger_CtrlList[5].gaoliang = HuaShanLunJian_CreateManger_List5_Bk_Gaoliang
	HuaShanLunJian_CreateManger_CtrlList[6] = {}
	HuaShanLunJian_CreateManger_CtrlList[6].leaderflag = HuaShanLunJian_CreateManger_List6_Pic
	HuaShanLunJian_CreateManger_CtrlList[6].name = HuaShanLunJian_CreateManger_List6_1
	HuaShanLunJian_CreateManger_CtrlList[6].menpai = HuaShanLunJian_CreateManger_List6_2
	HuaShanLunJian_CreateManger_CtrlList[6].level = HuaShanLunJian_CreateManger_List6_3
	HuaShanLunJian_CreateManger_CtrlList[6].duanwei = HuaShanLunJian_CreateManger_List6_4
	HuaShanLunJian_CreateManger_CtrlList[6].gaoliang = HuaShanLunJian_CreateManger_List6_Bk_Gaoliang
end -- end func HuaShanLunJian_CreateManger_InitCtrlList()

-- 刷新选择高亮显示
function HuaShanLunJian_CreateManger_UpdateSelect(selectIndex)
	for i=1, HuaShanLunJian_CreateManger_TeamMember_Max, 1 do
		local memberCtrl = HuaShanLunJian_CreateManger_CtrlList[i]
		if (memberCtrl ~= nil) then
			memberCtrl.gaoliang:Hide()
		end
	end -- end for

	if (selectIndex > 0) then
		local ctrl = HuaShanLunJian_CreateManger_CtrlList[selectIndex]
		if (ctrl ~= nil) then
			ctrl.gaoliang:Show()
		end
	end
end -- end func HuaShanLunJian_CreateManger_UpdateSelect()

-- 刷新牻队数据
function HuaShanLunJian_CreateManger_UpdateTeamInfo()
	if (HuaShanLunJian_CreateManger_CtrlList == nil) then
		HuaShanLunJian_CreateManger_InitCtrlList()
	end

	HuaShanLunJian_CreateManger_UpdateSelect(-1)

	HuaShanLunJian_CreateManger_SelectedIndex = -1

	if (NewXBW:IsLeader() > 0) then
		-- 自己是队长
		HuaShanLunJian_CreateManger_AddMember:Enable()			-- ????
		if (NewXBW:IsHasDeputy() > 0) then
			-- 已有副队长 屏蔽任命副队长按钮
			HuaShanLunJian_CreateManger_ViceLeader:Disable()	-- ???????
			HuaShanLunJian_CreateManger_NoLeader:Enable()		-- ?????????
		else
			-- 没有副队长 屏蔽解除副队长按钮
			HuaShanLunJian_CreateManger_NoLeader:Disable()		-- ?????????
			HuaShanLunJian_CreateManger_ViceLeader:Enable()		-- ???????
		end
		HuaShanLunJian_CreateManger_Dissolve:Enable()			-- ??????
		HuaShanLunJian_CreateManger_Fire:Enable()				-- ??????
		HuaShanLunJian_CreateManger_Leave:Enable()				-- ??????
	elseif (NewXBW:IsDeputy() > 0) then
		-- 自己是副队长
		HuaShanLunJian_CreateManger_AddMember:Enable()			-- ????
		HuaShanLunJian_CreateManger_ViceLeader:Disable()		-- ???????
		HuaShanLunJian_CreateManger_NoLeader:Disable()			-- ?????????
		HuaShanLunJian_CreateManger_Dissolve:Disable()			-- ??????
		HuaShanLunJian_CreateManger_Fire:Disable()				-- ??????
		HuaShanLunJian_CreateManger_Leave:Enable()				-- ??????
	else
		-- 自己是队员
		HuaShanLunJian_CreateManger_AddMember:Disable()			-- ????
		HuaShanLunJian_CreateManger_ViceLeader:Disable()		-- ???????
		HuaShanLunJian_CreateManger_NoLeader:Disable()			-- ?????????
		HuaShanLunJian_CreateManger_Dissolve:Disable()			-- ??????
		HuaShanLunJian_CreateManger_Fire:Disable()				-- ??????
		HuaShanLunJian_CreateManger_Leave:Enable()				-- ??????
	end

	for i=1, HuaShanLunJian_CreateManger_TeamMember_Max, 1 do
		local memberCtrl = HuaShanLunJian_CreateManger_CtrlList[i]
		memberCtrl.leaderflag:Hide()
		memberCtrl.name:Hide()
		memberCtrl.menpai:Hide()
		memberCtrl.level:Hide()
		memberCtrl.duanwei:Hide()
	end -- end for

	-- 是否显示牻队锁定标记
	local teamlockedFlag = NewXBW:GetMyTeamLockedFlag()
	if (teamlockedFlag > 0) then
		HuaShanLunJian_CreateManger_lock:Show()
	else
		HuaShanLunJian_CreateManger_lock:Hide()
	end

	local totalConsume = 0
	local ctrlIndex = 1
	for i=1, HuaShanLunJian_CreateManger_TeamMember_Max, 1 do
		local memberCtrl = HuaShanLunJian_CreateManger_CtrlList[ctrlIndex]
		local guid, menpai, level, post, consume, duanwei1, duanwei2, dunawei3, name = NewXBW:GetMyTeamMemberInfo(i-1)
		if (guid > 0) then
			ctrlIndex = ctrlIndex + 1
			if (post == HuaShanLunJian_CreateManger_Post.Leader) then
				memberCtrl.leaderflag:Show()
			elseif (post == HuaShanLunJian_CreateManger_Post.Deputy) then
				memberCtrl.leaderflag:Show()
			else
				memberCtrl.leaderflag:Hide()
			end

			memberCtrl.name:Show()
			memberCtrl.name:SetText("#cfff263" .. name)

			local menpaiName = HuaShanLunJian_CreateManger_MenPaiName[menpai]
			memberCtrl.menpai:Show()
			if (menpaiName ~= nil) then
				memberCtrl.menpai:SetText("#cfff263" .. menpaiName)
			else
				memberCtrl.menpai:SetText("")
			end
			
			memberCtrl.level:Show()
			memberCtrl.level:SetText("#cfff263" .. tostring(level))

			memberCtrl.duanwei:Show()
			memberCtrl.duanwei:SetText("")
			if (duanwei1 > 0) then
				if (duanwei1 >= HuaShanLunJian_CreateManger_BaJianDuanWei) then
					-- 霸剑段位 显示霸剑·星数	
					local duanweiStr = HuaShanLunJian_CreateManger_DuanWei1Str[duanwei1]
					if (duanweiStr ~= nil) then
						local xingjieStr = ScriptGlobal_Format("#{HSLJ_190919_389}", dunawei3)
						local str = "#cfff263" .. duanweiStr .. xingjieStr
						memberCtrl.duanwei:SetText(str)
					end
				else
					-- 非霸剑段位 显示段位·阶数
					local duanweiStr = HuaShanLunJian_CreateManger_DuanWei1Str[duanwei1]
					local jieshuStr = HuaShanLunJian_CreateManger_DuanWei2Str[duanwei2]
					if (duanweiStr ~= nil and jieshuStr ~= nil) then
						local dwText = ScriptGlobal_Format("#{HSLJ_190919_23}", duanweiStr, jieshuStr)
						memberCtrl.duanwei:SetText(dwText)
					end
				end
			end

			totalConsume = totalConsume + consume
		end
	end -- end for

	--local totalScore = ScriptGlobal_Format("#{JZGN_20230710_50}", totalConsume)
	--HuaShanLunJian_CreateManger_TeamScore:SetText(totalScore)

	local teamName = NewXBW:GetMyTeamName()
	local teamNameStr = ScriptGlobal_Format("#{JZGN_20230710_49}", teamName)
	HuaShanLunJian_CreateManger_PageHeader_Name:SetText(teamNameStr)
end -- end func HuaShanLunJian_CreateManger_UpdateTeamInfo()
