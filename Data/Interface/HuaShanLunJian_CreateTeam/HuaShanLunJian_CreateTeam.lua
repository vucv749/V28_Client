-- 新6v6 组建战队UI

-- 服务器端回调脚本ID
local HuaShanLunJian_CreateTeam_ServerScriptId = 998497
-- 战队名称最大长度
local HuaShanLunJian_CreateTeam_NameLen_Max = 12
local HuaShanLunJian_CreateTeam_TeamMember_Max = 6
-- 霸剑段位id
local HuaShanLunJian_CreateTeam_BaJianDuanWei = 6
-- 关注NPC
local HuaShanLunJian_CreateTeam_CareObjId = -1
local HuaShanLunJian_CreateTeam_CareObjSvrId = -1
local HuaShanLunJian_CreateTeam_MAX_OBJ_DISTANCE = 5.0
-- 默认位置
local HuaShanLunJian_CreateTeam_UnifiedPosition = nil
-- 控件表
local HuaShanLunJian_CreateTeam_CtrlList = nil

local HuaShanLunJian_CreateTeam_DuanWei1Str =
{
	[1] = "#{HSLJ_190919_145}",
	[2] = "#{HSLJ_190919_146}",
	[3] = "#{HSLJ_190919_147}",
	[4] = "#{HSLJ_190919_148}",
	[5] = "#{HSLJ_190919_149}",
	[6] = "#{HSLJ_190919_157}",
} -- end HuaShanLunJian_CreateTeam_DuanWei1Str

local HuaShanLunJian_CreateTeam_DuanWei2Str =
{
	[1] = "#{HSLJ_190919_154}",
	[2] = "#{HSLJ_190919_153}",
	[3] = "#{HSLJ_190919_152}",
	[4] = "#{HSLJ_190919_151}",
	[5] = "#{HSLJ_190919_150}",
} -- end HuaShanLunJian_CreateTeam_DuanWei2Str

-- 门派
local HuaShanLunJian_CreateTeam_MenPaiName =
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
} -- end HuaShanLunJian_CreateTeam_MenPaiName


function HuaShanLunJian_CreateTeam_PreLoad()
	this:RegisterEvent("XBW_OPENCREATETEAM", true)
	this:RegisterEvent("XBW_CLOSECREATETEAM", true)
	this:RegisterEvent("XBW_CLOSEUI", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func HuaShanLunJian_CreateTeam_PreLoad()

function HuaShanLunJian_CreateTeam_OnEvent(event)
	if (event == "XBW_OPENCREATETEAM") then
		HuaShanLunJian_CreateTeam_BeginCareObject(arg0, arg1)
		HuaShanLunJian_CreateTeam_UpdateTeamInfo()
		HuaShanLunJian_CreateTeam_Show()
	elseif (event == "XBW_CLOSECREATETEAM") then
		HuaShanLunJian_CreateTeam_Hide()
	elseif (event == "XBW_CLOSEUI") then
		HuaShanLunJian_CreateTeam_Hide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HuaShanLunJian_CreateTeam_Hide()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_CreateTeam_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		HuaShanLunJian_CreateTeam_UnifiedPos()
	elseif (event == "OBJECT_CARED_EVENT") then
		if(HuaShanLunJian_CreateTeam_CareObjId < 0 or tonumber(arg0) ~= HuaShanLunJian_CreateTeam_CareObjId) then
			return
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if((arg1 == "distance" and tonumber(arg2) > HuaShanLunJian_CreateTeam_MAX_OBJ_DISTANCE) or arg1=="destroy") then
			--取消关心
			HuaShanLunJian_CreateTeam_Hide()
		end
	end
end -- end func HuaShanLunJian_CreateTeam_OnEvent()

function HuaShanLunJian_CreateTeam_OnLoad()
	HuaShanLunJian_CreateTeam_UnifiedPosition = HuaShanLunJian_CreateTeam_Frame:GetProperty("UnifiedPosition")
	HuaShanLunJian_CreateTeam_InitCtrlList()
end -- end func HuaShanLunJian_CreateTeam_OnLoad()

-- 界面默认位置
function HuaShanLunJian_CreateTeam_UnifiedPos()
	if (HuaShanLunJian_CreateTeam_UnifiedPosition ~= nil) then
		HuaShanLunJian_CreateTeam_Frame:SetProperty("UnifiedPosition", HuaShanLunJian_CreateTeam_UnifiedPosition)
	end
end -- end func HuaShanLunJian_CreateTeam_UnifiedPos()

function HuaShanLunJian_CreateTeam_Show()
	this:Show()

	PushEvent("XBW_CLOSETEAMMANAGE")
end -- end func HuaShanLunJian_CreateTeam_Show()

function HuaShanLunJian_CreateTeam_Hide()
	HuaShanLunJian_CreateTeam_StopCareObject()
	this:Hide()
end -- end func HuaShanLunJian_CreateTeam_Hide()

-- 开启NPC关注
function HuaShanLunJian_CreateTeam_BeginCareObject(objSvrId, objId)
	HuaShanLunJian_CreateTeam_CareObjId = tonumber(objId)
	HuaShanLunJian_CreateTeam_CareObjSvrId = tonumber(objSvrId)
	if (HuaShanLunJian_CreateTeam_CareObjId >= 0) then
		this:CareObject(HuaShanLunJian_CreateTeam_CareObjId, 1, "HuaShanLunJian_CreateTeam")
	end
end -- end func HuaShanLunJian_CreateTeam_BeginCareObject()

-- 取消NPC关注
function HuaShanLunJian_CreateTeam_StopCareObject(objId)
	if (HuaShanLunJian_CreateTeam_CareObjId >= 0) then
		this:CareObject(HuaShanLunJian_CreateTeam_CareObjId, 0, "HuaShanLunJian_CreateTeam")
		HuaShanLunJian_CreateTeam_CareObjId = -1
		HuaShanLunJian_CreateTeam_CareObjSvrId = -1
	end
end -- end func HuaShanLunJian_CreateTeam_StopCareObject()

-- 初始化控件表
function HuaShanLunJian_CreateTeam_InitCtrlList()
	HuaShanLunJian_CreateTeam_CtrlList = {}

	HuaShanLunJian_CreateTeam_CtrlList.member = {}
	HuaShanLunJian_CreateTeam_CtrlList.member[1] = {}
	HuaShanLunJian_CreateTeam_CtrlList.member[1].leaderflag = HuaShanLunJian_CreateTeam_List1_Pic
	HuaShanLunJian_CreateTeam_CtrlList.member[1].name = HuaShanLunJian_CreateTeam_List1_1
	HuaShanLunJian_CreateTeam_CtrlList.member[1].menpai = HuaShanLunJian_CreateTeam_List1_2
	HuaShanLunJian_CreateTeam_CtrlList.member[1].level = HuaShanLunJian_CreateTeam_List1_3
	HuaShanLunJian_CreateTeam_CtrlList.member[1].duanwei = HuaShanLunJian_CreateTeam_List1_4
	HuaShanLunJian_CreateTeam_CtrlList.member[2] = {}
	HuaShanLunJian_CreateTeam_CtrlList.member[2].leaderflag = HuaShanLunJian_CreateTeam_List2_Pic
	HuaShanLunJian_CreateTeam_CtrlList.member[2].name = HuaShanLunJian_CreateTeam_List2_1
	HuaShanLunJian_CreateTeam_CtrlList.member[2].menpai = HuaShanLunJian_CreateTeam_List2_2
	HuaShanLunJian_CreateTeam_CtrlList.member[2].level = HuaShanLunJian_CreateTeam_List2_3
	HuaShanLunJian_CreateTeam_CtrlList.member[2].duanwei = HuaShanLunJian_CreateTeam_List2_4
	HuaShanLunJian_CreateTeam_CtrlList.member[3] = {}
	HuaShanLunJian_CreateTeam_CtrlList.member[3].leaderflag = HuaShanLunJian_CreateTeam_List3_Pic
	HuaShanLunJian_CreateTeam_CtrlList.member[3].name = HuaShanLunJian_CreateTeam_List3_1
	HuaShanLunJian_CreateTeam_CtrlList.member[3].menpai = HuaShanLunJian_CreateTeam_List3_2
	HuaShanLunJian_CreateTeam_CtrlList.member[3].level = HuaShanLunJian_CreateTeam_List3_3
	HuaShanLunJian_CreateTeam_CtrlList.member[3].duanwei = HuaShanLunJian_CreateTeam_List3_4
	HuaShanLunJian_CreateTeam_CtrlList.member[4] = {}
	HuaShanLunJian_CreateTeam_CtrlList.member[4].leaderflag = HuaShanLunJian_CreateTeam_List4_Pic
	HuaShanLunJian_CreateTeam_CtrlList.member[4].name = HuaShanLunJian_CreateTeam_List4_1
	HuaShanLunJian_CreateTeam_CtrlList.member[4].menpai = HuaShanLunJian_CreateTeam_List4_2
	HuaShanLunJian_CreateTeam_CtrlList.member[4].level = HuaShanLunJian_CreateTeam_List4_3
	HuaShanLunJian_CreateTeam_CtrlList.member[4].duanwei = HuaShanLunJian_CreateTeam_List4_4
	HuaShanLunJian_CreateTeam_CtrlList.member[5] = {}
	HuaShanLunJian_CreateTeam_CtrlList.member[5].leaderflag = HuaShanLunJian_CreateTeam_List5_Pic
	HuaShanLunJian_CreateTeam_CtrlList.member[5].name = HuaShanLunJian_CreateTeam_List5_1
	HuaShanLunJian_CreateTeam_CtrlList.member[5].menpai = HuaShanLunJian_CreateTeam_List5_2
	HuaShanLunJian_CreateTeam_CtrlList.member[5].level = HuaShanLunJian_CreateTeam_List5_3
	HuaShanLunJian_CreateTeam_CtrlList.member[5].duanwei = HuaShanLunJian_CreateTeam_List5_4
	HuaShanLunJian_CreateTeam_CtrlList.member[6] = {}
	HuaShanLunJian_CreateTeam_CtrlList.member[6].leaderflag = HuaShanLunJian_CreateTeam_List6_Pic
	HuaShanLunJian_CreateTeam_CtrlList.member[6].name = HuaShanLunJian_CreateTeam_List6_1
	HuaShanLunJian_CreateTeam_CtrlList.member[6].menpai = HuaShanLunJian_CreateTeam_List6_2
	HuaShanLunJian_CreateTeam_CtrlList.member[6].level = HuaShanLunJian_CreateTeam_List6_3
	HuaShanLunJian_CreateTeam_CtrlList.member[6].duanwei = HuaShanLunJian_CreateTeam_List6_4
end -- end func HuaShanLunJian_CreateTeam_InitCtrlList()

-- 关闭按钮事件
function HuaShanLunJian_CreateTeam_CloseClicked()
	HuaShanLunJian_CreateTeam_Hide()
end -- end func HuaShanLunJian_CreateTeam_CloseClicked()

-- 创建战队按钮事件
function HuaShanLunJian_CreateTeam_Accept_Clicked()
	local teamName = HuaShanLunJian_CreateTeam_Top_NameInput:GetText()
	if (teamName == nil or teamName == "") then
		PushDebugMessage("#{JZGN_20230710_37}")
		return
	end
	if (string.len(teamName) > HuaShanLunJian_CreateTeam_NameLen_Max) then
		PushDebugMessage("#{JZGN_20230710_38}")
		return
	end

	NewXBW:CreateTeam(HuaShanLunJian_CreateTeam_CareObjSvrId, teamName)

	HuaShanLunJian_CreateTeam_Hide()
end -- end func HuaShanLunJian_CreateTeam_Accept_Clicked()

function HuaShanLunJian_CreateTeam_Top_NameInputNull_Clicked()
	-- HuaShanLunJian_CreateTeam_Top_NameInputNull:Hide()
	-- HuaShanLunJian_CreateTeam_Top_NameInput:SetText("")

	-- -- 设置焦点
	-- HuaShanLunJian_CreateTeam_Top_NameInput:SetProperty("DefaultEditBox", "True")
end -- end func HuaShanLunJian_CreateTeam_Top_NameInputNull_Clicked()

-- 重置UI显示
function HuaShanLunJian_CreateTeam_ResetUIInfo()
	if (HuaShanLunJian_CreateTeam_CtrlList == nil) then
		HuaShanLunJian_CreateTeam_InitCtrlList()
	end

	-- 战队名称
	HuaShanLunJian_CreateTeam_Top_NameInputNull:Hide()
	HuaShanLunJian_CreateTeam_Top_NameInput:SetText("")

	-- 设置焦点
	HuaShanLunJian_CreateTeam_Top_NameInput:SetProperty("DefaultEditBox", "True")

	-- 战队人数
	local numText = ScriptGlobal_Format("#{JZGN_20230710_29}", 0)
	HuaShanLunJian_CreateTeam_Top_Text3:SetText(numText)
	-- 战队成员
	for i=0, 6, 1 do
		if (HuaShanLunJian_CreateTeam_CtrlList.member[i] ~= nil) then
			HuaShanLunJian_CreateTeam_CtrlList.member[i].leaderflag:Hide()
			HuaShanLunJian_CreateTeam_CtrlList.member[i].name:Hide()
			HuaShanLunJian_CreateTeam_CtrlList.member[i].menpai:Hide()
			HuaShanLunJian_CreateTeam_CtrlList.member[i].level:Hide()
			HuaShanLunJian_CreateTeam_CtrlList.member[i].duanwei:Hide()
		end
	end -- end for
end -- end func HuaShanLunJian_CreateTeam_ResetUIInfo()

-- 刷新战队信息
function HuaShanLunJian_CreateTeam_UpdateTeamInfo()
	HuaShanLunJian_CreateTeam_ResetUIInfo()

	local memCount = 0
	-- 刷新战队成员信息
	for i=1, HuaShanLunJian_CreateTeam_TeamMember_Max, 1 do
		--local memName, memMenPai, memLevel, memDeadFlag, memLinkFlag, memSex, memZoneWorld = DataPool:GetTeamMemInfoByIndex(i-1)
		--local playerName, playerGUID, playerIcon, leaderFlag, isDead = DataPool:GetTeamMemInfoExByIndex(i-1)
		local guid, memMenPai, memLevel, post, consume, duanwei1, duanwei2, dunawei3, memName = NewXBW:GetMyTeamMemberInfo(i-1)
		if (HuaShanLunJian_CreateTeam_CtrlList.member[i] ~= nil) then
			if (memLevel > 0) then
				if (i <= 1) then
					HuaShanLunJian_CreateTeam_CtrlList.member[i].leaderflag:Show()
				else
					HuaShanLunJian_CreateTeam_CtrlList.member[i].leaderflag:Hide()
				end
				HuaShanLunJian_CreateTeam_CtrlList.member[i].name:Show()
				HuaShanLunJian_CreateTeam_CtrlList.member[i].menpai:Show()
				HuaShanLunJian_CreateTeam_CtrlList.member[i].level:Show()
				HuaShanLunJian_CreateTeam_CtrlList.member[i].duanwei:Show()

				HuaShanLunJian_CreateTeam_CtrlList.member[i].name:SetText("#cfff263" .. memName)
				if (HuaShanLunJian_CreateTeam_MenPaiName[memMenPai] ~= nil) then
					HuaShanLunJian_CreateTeam_CtrlList.member[i].menpai:SetText("#cfff263" .. HuaShanLunJian_CreateTeam_MenPaiName[memMenPai])
				else
					HuaShanLunJian_CreateTeam_CtrlList.member[i].menpai:SetText("")
				end
				HuaShanLunJian_CreateTeam_CtrlList.member[i].level:SetText("#cfff263" .. tostring(memLevel))

				HuaShanLunJian_CreateTeam_CtrlList.member[i].duanwei:SetText("")
				if (duanwei1 > 0) then
					if (duanwei1 >= HuaShanLunJian_CreateTeam_BaJianDuanWei) then
						-- 霸剑段位 显示霸剑·星数	
						local duanweiStr = HuaShanLunJian_CreateTeam_DuanWei1Str[duanwei1]
						if (duanweiStr ~= nil) then
							local xingjieStr = ScriptGlobal_Format("#{HSLJ_190919_389}", dunawei3)
							local str = "#cfff263" .. duanweiStr .. xingjieStr
							HuaShanLunJian_CreateTeam_CtrlList.member[i].duanwei:SetText(str)
						end
					else
						-- 非霸剑段位 显示段位·阶数
						local duanweiStr = HuaShanLunJian_CreateTeam_DuanWei1Str[duanwei1]
						local jieshuStr = HuaShanLunJian_CreateTeam_DuanWei2Str[duanwei2]
						if (duanweiStr ~= nil and jieshuStr ~= nil) then
							local dwText = ScriptGlobal_Format("#{HSLJ_190919_23}", duanweiStr, jieshuStr)
							HuaShanLunJian_CreateTeam_CtrlList.member[i].duanwei:SetText(dwText)
						end
					end
				end

				memCount = memCount + 1
			else
				HuaShanLunJian_CreateTeam_CtrlList.member[i].leaderflag:Hide()
				HuaShanLunJian_CreateTeam_CtrlList.member[i].name:Hide()
				HuaShanLunJian_CreateTeam_CtrlList.member[i].menpai:Hide()
				HuaShanLunJian_CreateTeam_CtrlList.member[i].level:Hide()
				HuaShanLunJian_CreateTeam_CtrlList.member[i].duanwei:Hide()
			end
		end
	end -- end for

	-- 战队人数
	local numText = ScriptGlobal_Format("#{JZGN_20230710_29}", memCount)
	HuaShanLunJian_CreateTeam_Top_Text3:SetText(numText)
end -- end func HuaShanLunJian_CreateTeam_UpdateTeamInfo()