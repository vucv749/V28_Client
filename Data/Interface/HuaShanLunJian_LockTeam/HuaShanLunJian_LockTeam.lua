-- 新6v6 战队锁定确认UI
-- 战队成员数量
local HuaShanLunJian_LockTeam_TeamMember_Max = 6
-- 霸剑段位id
local HuaShanLunJian_LockTeam_BaJianDuanWei = 6
-- 脚本id
local HuaShanLunJian_LockTeam_SvrScriptId = 998497
-- 关闭标记
local HuaShanLunJian_LockTeam_CloseFlag = 0
-- 关注NPC
local HuaShanLunJian_LockTeam_CareObjId = -1
local HuaShanLunJian_LockTeam_CareObjSvrId = -1
local HuaShanLunJian_LockTeam_MAX_OBJ_DISTANCE = 5.0
-- 默认位置
local HuaShanLunJian_LockTeam_UnifiedPosition = nil
-- 控件表
local HuaShanLunJian_LockTeam_CtrlList = nil

-- 门派
local HuaShanLunJian_LockTeam_MenPaiName =
{
	[0] = "#{XQ_MP_1}",    	--少林
	[1] = "#{XQ_MP_2}",    	--明教
	[2] = "#{XQ_MP_3}",    	--丐帮
	[3] = "#{XQ_MP_4}",    	--武当
	[4] = "#{XQ_MP_5}",    	--峨眉
	[5] = "#{XQ_MP_6}",    	--星宿
	[6] = "#{XQ_MP_7}",    	--天龙
	[7] = "#{XQ_MP_8}",    	--天山
	[8] = "#{XQ_MP_9}",    	--逍遥
	[9] = "#{JZGN_20230710_138}",	--无门派
	[10] = "#{WCBZ_220809_53}",		--曼陀山庄 
} -- end HuaShanLunJian_LockTeam_MenPaiName

-- 段位1显示
local HuaShanLunJian_LockTeam_DuanWei1Str =
{
	[1] = "#{HSLJ_190919_145}",
	[2] = "#{HSLJ_190919_146}",
	[3] = "#{HSLJ_190919_147}",
	[4] = "#{HSLJ_190919_148}",
	[5] = "#{HSLJ_190919_149}",
	[6] = "#{HSLJ_190919_157}",
} -- end HuaShanLunJian_LockTeam_DuanWei1Str

-- 段位2显示
local HuaShanLunJian_LockTeam_DuanWei2Str =
{
	[1] = "#{HSLJ_190919_154}",
	[2] = "#{HSLJ_190919_153}",
	[3] = "#{HSLJ_190919_152}",
	[4] = "#{HSLJ_190919_151}",
	[5] = "#{HSLJ_190919_150}",
} -- end HuaShanLunJian_LockTeam_DuanWei2Str



function HuaShanLunJian_LockTeam_PreLoad()
	this:RegisterEvent("XBW_OPENLOCKCONFIRM", true)
	this:RegisterEvent("XBW_UPDATELOCKCONFIRM", true)
	this:RegisterEvent("XBW_CLOSELOCKCONFIRM", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func HuaShanLunJian_LockTeam_PreLoad()

function HuaShanLunJian_LockTeam_OnEvent(event)
	if (event == "XBW_OPENLOCKCONFIRM") then
		HuaShanLunJian_LockTeam_Show(tonumber(arg0), tonumber(arg1))
		HuaShanLunJian_LockTeam_UpdateTeamInfo()
	elseif (event == "XBW_UPDATELOCKCONFIRM") then
		HuaShanLunJian_LockTeam_UpdateLockConfirm(tonumber(arg0))
	elseif (event == "XBW_CLOSELOCKCONFIRM") then
		HuaShanLunJian_LockTeam_Hide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HuaShanLunJian_LockTeam_Hide()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_LockTeam_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		HuaShanLunJian_LockTeam_UnifiedPos()
	elseif (event == "OBJECT_CARED_EVENT") then
		-- 这个事件目前已经被干掉了
		-- 要调整关注距离直接去改代码吧 ObjectManager.cpp CObjectManager::Tick(VOID)
		if(HuaShanLunJian_LockTeam_CareObjId < 0 or tonumber(arg0) ~= HuaShanLunJian_LockTeam_CareObjId) then
			return
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if((arg1 == "distance" and tonumber(arg2) > HuaShanLunJian_LockTeam_MAX_OBJ_DISTANCE) or arg1=="destroy") then
			--取消关心
			HuaShanLunJian_LockTeam_Hide()
		end
	end
end -- end func HuaShanLunJian_LockTeam_OnEvent()

function HuaShanLunJian_LockTeam_OnLoad()
	HuaShanLunJian_LockTeam_UnifiedPosition = HuaShanLunJian_LockTeam_Frame:GetProperty("UnifiedPosition")
	HuaShanLunJian_LockTeam_InitCtrlList()
end -- end func HuaShanLunJian_LockTeam_OnLoad()

-- 界面默认位置
function HuaShanLunJian_LockTeam_UnifiedPos()
	if (HuaShanLunJian_LockTeam_UnifiedPosition ~= nil) then
		HuaShanLunJian_LockTeam_Frame:SetProperty("UnifiedPosition", HuaShanLunJian_LockTeam_UnifiedPosition)
	end
end -- end func HuaShanLunJian_LockTeam_UnifiedPos()

function HuaShanLunJian_LockTeam_Show(careObjSvrId, careObjId)
    if (careObjSvrId ~= nil and careObjId ~= nil) then
        if (HuaShanLunJian_LockTeam_CareObjId < 0) then
            HuaShanLunJian_LockTeam_BeginCareObject(careObjSvrId, careObjId)
        end
    end

	HuaShanLunJian_LockTeam_CloseFlag = 0
	this:Show()
end -- end func HuaShanLunJian_LockTeam_Show()

function HuaShanLunJian_LockTeam_Hide()
    HuaShanLunJian_LockTeam_StopCareObject()
	
	HuaShanLunJian_LockTeam_CloseFlag = 1
	this:Hide()
end -- end func HuaShanLunJian_LockTeam_Hide()

-- 开启NPC关注
function HuaShanLunJian_LockTeam_BeginCareObject(objSvrId, objId)
    if (objSvrId >= 0 and objId >= 0) then
        HuaShanLunJian_LockTeam_CareObjId = objId
        HuaShanLunJian_LockTeam_CareObjSvrId = objSvrId
        this:CareObject(HuaShanLunJian_LockTeam_CareObjId, 1, "HuaShanLunJian_LockTeam")
    end
end -- end func HuaShanLunJian_LockTeam_BeginCareObject()

-- 取消NPC关注
function HuaShanLunJian_LockTeam_StopCareObject(objId)
	if (HuaShanLunJian_LockTeam_CareObjId >= 0) then
		this:CareObject(HuaShanLunJian_LockTeam_CareObjId, 0, "HuaShanLunJian_LockTeam")
		HuaShanLunJian_LockTeam_CareObjId = -1
		HuaShanLunJian_LockTeam_CareObjSvrId = -1
	end
end -- end func HuaShanLunJian_LockTeam_StopCareObject()

function HuaShanLunJian_LockTeam_OnHidden()
	if (HuaShanLunJian_LockTeam_CloseFlag <= 0) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CCallBack_LockCancel")
			Set_XSCRIPT_ScriptID(HuaShanLunJian_LockTeam_SvrScriptId)
			Set_XSCRIPT_Parameter(0, HuaShanLunJian_LockTeam_CareObjSvrId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end -- end func HuaShanLunJian_LockTeam_OnHidden()

function HuaShanLunJian_LockTeam_List_BtnOK(arg)
end -- end func HuaShanLunJian_LockTeam_List_BtnOK()

-- 关闭按钮事件
function HuaShanLunJian_LockTeam_CloseClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CCallBack_LockCancel")
		Set_XSCRIPT_ScriptID(HuaShanLunJian_LockTeam_SvrScriptId)
		Set_XSCRIPT_Parameter(0, HuaShanLunJian_LockTeam_CareObjSvrId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	HuaShanLunJian_LockTeam_Hide()
end -- end func HuaShanLunJian_LockTeam_CloseClicked()

-- 我要锁定按钮事件
function HuaShanLunJian_LockTeam_Invite_Clicked(arg)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Team_CCallBack_LockConfirmed")
		Set_XSCRIPT_ScriptID(HuaShanLunJian_LockTeam_SvrScriptId)
		Set_XSCRIPT_Parameter(0, HuaShanLunJian_LockTeam_CareObjSvrId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end -- end func HuaShanLunJian_LockTeam_Invite_Clicked()

function HuaShanLunJian_LockTeam_InitCtrlList()
	HuaShanLunJian_LockTeam_CtrlList = {}

	HuaShanLunJian_LockTeam_CtrlList.member = {}
	HuaShanLunJian_LockTeam_CtrlList.member[1] = {}
	HuaShanLunJian_LockTeam_CtrlList.member[1].leaderflag = HuaShanLunJian_LockTeam_List1_Pic
	HuaShanLunJian_LockTeam_CtrlList.member[1].name = HuaShanLunJian_LockTeam_List1_1
	HuaShanLunJian_LockTeam_CtrlList.member[1].menpai = HuaShanLunJian_LockTeam_List1_2
	HuaShanLunJian_LockTeam_CtrlList.member[1].level = HuaShanLunJian_LockTeam_List1_3
	HuaShanLunJian_LockTeam_CtrlList.member[1].duanwei = HuaShanLunJian_LockTeam_List1_4
	HuaShanLunJian_LockTeam_CtrlList.member[1].confirmflag = HuaShanLunJian_LockTeam_List1_BtnOK
	HuaShanLunJian_LockTeam_CtrlList.member[2] = {}
	HuaShanLunJian_LockTeam_CtrlList.member[2].leaderflag = HuaShanLunJian_LockTeam_List2_Pic
	HuaShanLunJian_LockTeam_CtrlList.member[2].name = HuaShanLunJian_LockTeam_List2_1
	HuaShanLunJian_LockTeam_CtrlList.member[2].menpai = HuaShanLunJian_LockTeam_List2_2
	HuaShanLunJian_LockTeam_CtrlList.member[2].level = HuaShanLunJian_LockTeam_List2_3
	HuaShanLunJian_LockTeam_CtrlList.member[2].duanwei = HuaShanLunJian_LockTeam_List2_4
	HuaShanLunJian_LockTeam_CtrlList.member[2].confirmflag = HuaShanLunJian_LockTeam_List2_BtnOK
	HuaShanLunJian_LockTeam_CtrlList.member[3] = {}
	HuaShanLunJian_LockTeam_CtrlList.member[3].leaderflag = HuaShanLunJian_LockTeam_List3_Pic
	HuaShanLunJian_LockTeam_CtrlList.member[3].name = HuaShanLunJian_LockTeam_List3_1
	HuaShanLunJian_LockTeam_CtrlList.member[3].menpai = HuaShanLunJian_LockTeam_List3_2
	HuaShanLunJian_LockTeam_CtrlList.member[3].level = HuaShanLunJian_LockTeam_List3_3
	HuaShanLunJian_LockTeam_CtrlList.member[3].duanwei = HuaShanLunJian_LockTeam_List3_4
	HuaShanLunJian_LockTeam_CtrlList.member[3].confirmflag = HuaShanLunJian_LockTeam_List3_BtnOK
	HuaShanLunJian_LockTeam_CtrlList.member[4] = {}
	HuaShanLunJian_LockTeam_CtrlList.member[4].leaderflag = HuaShanLunJian_LockTeam_List4_Pic
	HuaShanLunJian_LockTeam_CtrlList.member[4].name = HuaShanLunJian_LockTeam_List4_1
	HuaShanLunJian_LockTeam_CtrlList.member[4].menpai = HuaShanLunJian_LockTeam_List4_2
	HuaShanLunJian_LockTeam_CtrlList.member[4].level = HuaShanLunJian_LockTeam_List4_3
	HuaShanLunJian_LockTeam_CtrlList.member[4].duanwei = HuaShanLunJian_LockTeam_List4_4
	HuaShanLunJian_LockTeam_CtrlList.member[4].confirmflag = HuaShanLunJian_LockTeam_List4_BtnOK
	HuaShanLunJian_LockTeam_CtrlList.member[5] = {}
	HuaShanLunJian_LockTeam_CtrlList.member[5].leaderflag = HuaShanLunJian_LockTeam_List5_Pic
	HuaShanLunJian_LockTeam_CtrlList.member[5].name = HuaShanLunJian_LockTeam_List5_1
	HuaShanLunJian_LockTeam_CtrlList.member[5].menpai = HuaShanLunJian_LockTeam_List5_2
	HuaShanLunJian_LockTeam_CtrlList.member[5].level = HuaShanLunJian_LockTeam_List5_3
	HuaShanLunJian_LockTeam_CtrlList.member[5].duanwei = HuaShanLunJian_LockTeam_List5_4
	HuaShanLunJian_LockTeam_CtrlList.member[5].confirmflag = HuaShanLunJian_LockTeam_List5_BtnOK
	HuaShanLunJian_LockTeam_CtrlList.member[6] = {}
	HuaShanLunJian_LockTeam_CtrlList.member[6].leaderflag = HuaShanLunJian_LockTeam_List6_Pic
	HuaShanLunJian_LockTeam_CtrlList.member[6].name = HuaShanLunJian_LockTeam_List6_1
	HuaShanLunJian_LockTeam_CtrlList.member[6].menpai = HuaShanLunJian_LockTeam_List6_2
	HuaShanLunJian_LockTeam_CtrlList.member[6].level = HuaShanLunJian_LockTeam_List6_3
	HuaShanLunJian_LockTeam_CtrlList.member[6].duanwei = HuaShanLunJian_LockTeam_List6_4
	HuaShanLunJian_LockTeam_CtrlList.member[6].confirmflag = HuaShanLunJian_LockTeam_List6_BtnOK
end -- end func HuaShanLunJian_LockTeam_InitCtrlList()

-- 重置UI显示
function HuaShanLunJian_LockTeam_ResetUITeamInfo()
	if (HuaShanLunJian_LockTeam_CtrlList == nil) then
		HuaShanLunJian_LockTeam_InitCtrlList()
	end

	-- 战队成员
	for i=1, 6, 1 do
		if (HuaShanLunJian_LockTeam_CtrlList.member[i] ~= nil) then
			HuaShanLunJian_LockTeam_CtrlList.member[i].leaderflag:Hide()
			HuaShanLunJian_LockTeam_CtrlList.member[i].name:Hide()
			HuaShanLunJian_LockTeam_CtrlList.member[i].menpai:Hide()
			HuaShanLunJian_LockTeam_CtrlList.member[i].level:Hide()
			HuaShanLunJian_LockTeam_CtrlList.member[i].duanwei:Hide()
			HuaShanLunJian_LockTeam_CtrlList.member[i].confirmflag:Hide()
		end
	end -- end for
end -- end func HuaShanLunJian_LockTeam_ResetUITeamInfo()

function HuaShanLunJian_LockTeam_GetYMDByDate(timeDate)
	local timeYear = 0
    local timeMon = 0
    local timeDay = 0
    if (timeDate > 0) then
        timeYear = math.floor(timeDate / 10000)
        timeMon = math.floor((timeDate - timeYear*10000) / 100)
        timeDay = math.mod(timeDate, 100)
    end

    return timeYear, timeMon, timeDay
end -- end func HuaShanLunJian_LockTeam_GetYMDByDate

function HuaShanLunJian_LockTeam_UpdateTeamInfo()
	HuaShanLunJian_LockTeam_ResetUITeamInfo()

	local curDay = tonumber(DataPool:GetServerDayTime())
	local seasonIndex, lockBegin, lockEnd = XBW:GetXbwGetCurSeasonLockInfo(curDay)
	local beginYear, beginMonth, beginDay = HuaShanLunJian_LockTeam_GetYMDByDate(lockBegin)
	local endYear, endMonth, endDay = HuaShanLunJian_LockTeam_GetYMDByDate(lockEnd)
	local msg = ScriptGlobal_Format("#{HSLJ_190919_410}", beginYear, beginMonth, beginDay, endMonth, endDay)
	HuaShanLunJian_LockTeam_TopText:SetText(msg)

	-- 刷新战队成员信息
	for i=1, HuaShanLunJian_LockTeam_TeamMember_Max, 1 do
		local guid, memMenPai, memLevel, pos, consume, duanwei1, duanwei2, dunawei3, memName = NewXBW:GetMyTeamMemberInfo(i-1)
		if (HuaShanLunJian_LockTeam_CtrlList.member[i] ~= nil) then
			if (memLevel > 0) then
				if (pos == 2) then
					HuaShanLunJian_LockTeam_CtrlList.member[i].leaderflag:Show()
				else
					HuaShanLunJian_LockTeam_CtrlList.member[i].leaderflag:Hide()
				end
				HuaShanLunJian_LockTeam_CtrlList.member[i].name:Show()
				HuaShanLunJian_LockTeam_CtrlList.member[i].menpai:Show()
				HuaShanLunJian_LockTeam_CtrlList.member[i].level:Show()
				HuaShanLunJian_LockTeam_CtrlList.member[i].duanwei:Show()
				HuaShanLunJian_LockTeam_CtrlList.member[i].confirmflag:Show()
				HuaShanLunJian_LockTeam_CtrlList.member[i].confirmflag:SetCheck(0)
				HuaShanLunJian_LockTeam_CtrlList.member[i].confirmflag:Disable()

				-- 角色名
				HuaShanLunJian_LockTeam_CtrlList.member[i].name:SetText("#cfff263" .. memName)
				-- 门派
				if (HuaShanLunJian_LockTeam_MenPaiName[memMenPai] ~= nil) then
					HuaShanLunJian_LockTeam_CtrlList.member[i].menpai:SetText("#cfff263" .. HuaShanLunJian_LockTeam_MenPaiName[memMenPai])
				else
					HuaShanLunJian_LockTeam_CtrlList.member[i].menpai:SetText("")
				end
				-- 等级
				HuaShanLunJian_LockTeam_CtrlList.member[i].level:SetText("#cfff263" .. tostring(memLevel))
				-- 段位
				HuaShanLunJian_LockTeam_CtrlList.member[i].duanwei:SetText("")
				if (duanwei1 > 0) then
					if (duanwei1 >= HuaShanLunJian_LockTeam_BaJianDuanWei) then
						-- 霸剑段位 显示霸剑·星数	
						local duanweiStr = HuaShanLunJian_LockTeam_DuanWei1Str[duanwei1]
						if (duanweiStr ~= nil) then
							local xingjieStr = ScriptGlobal_Format("#{HSLJ_190919_389}", dunawei3)
							local str = "#cfff263" .. duanweiStr .. xingjieStr
							HuaShanLunJian_LockTeam_CtrlList.member[i].duanwei:SetText(str)
						end
					else
						-- 非霸剑段位 显示段位·阶数
						local duanweiStr = HuaShanLunJian_LockTeam_DuanWei1Str[duanwei1]
						local jieshuStr = HuaShanLunJian_LockTeam_DuanWei2Str[duanwei2]
						if (duanweiStr ~= nil and jieshuStr ~= nil) then
							local dwText = ScriptGlobal_Format("#{HSLJ_190919_23}", duanweiStr, jieshuStr)
							HuaShanLunJian_LockTeam_CtrlList.member[i].duanwei:SetText(dwText)
						end
					end
				end
				-- 确认状态
				-- 这里应该都是默认未确认状态 所以不需要处理
			end
		end
	end -- end for
end -- end func HuaShanLunJian_LockTeam_UpdateTeamInfo()

function HuaShanLunJian_LockTeam_UpdateLockConfirm(playerGUID)
	if (HuaShanLunJian_LockTeam_CtrlList == nil) then
		return
	end

	for i=1, HuaShanLunJian_LockTeam_TeamMember_Max, 1 do
		local guid, memMenPai, memLevel, pos, consume, duanwei1, duanwei2, dunawei3, memName = NewXBW:GetMyTeamMemberInfo(i-1)
		if (guid == playerGUID) then
			if (HuaShanLunJian_LockTeam_CtrlList.member[i] ~= nil) then
				HuaShanLunJian_LockTeam_CtrlList.member[i].confirmflag:Show()
				HuaShanLunJian_LockTeam_CtrlList.member[i].confirmflag:SetCheck(1)
				HuaShanLunJian_LockTeam_CtrlList.member[i].confirmflag:Disable()

				break
			end
		end
	end -- end for
end -- end func HuaShanLunJian_LockTeam_UpdateLockConfirm()