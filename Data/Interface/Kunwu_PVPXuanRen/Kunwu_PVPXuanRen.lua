-- 界面最小化
-- 1058
local g_unifiedposistion = nil
local g_uicommand = 99961502
local g_uicommandclose = 99961503
local g_uicommandtime = 99961504
local g_select = 1
local g_group = {}
local g_count = 3
local g_lasttime = 0
local g_targetId = -1

local g_ui_list = {}
local g_ui_skill_list = {}

local g_image_push = "set:Frozen_PVP image:Frozen_PVPImagePush"

local g_IdentityInfo = {
    [0] = {name="#{ZSYC_241211_197}",image="set:Kunwu_PVP image:Kunwu_PVPWSSN",push="set:Kunwu_PVP2 image:Kunwu_PVPWSSN1",},
    [1] = {name="#{ZSYC_241211_197}",image="set:Kunwu_PVP image:Kunwu_PVPWSSN",push="set:Kunwu_PVP2 image:Kunwu_PVPWSSN1",},
    [2] = {name="#{ZSYC_241211_198}",image="set:Kunwu_PVP image:Kunwu_PVPXHX",push="set:Kunwu_PVP2 image:Kunwu_PVPXHX1",},
    [3] = {name="#{ZSYC_241211_199}",image="set:Kunwu_PVP image:Kunwu_PVPMBZ",push="set:Kunwu_PVP image:Kunwu_PVPMBZ",},
	[4] = {name="#{ZSYC_241211_200}",image="set:Kunwu_PVP image:Kunwu_PVPDDN",push="set:Kunwu_PVP2 image:Kunwu_PVPDDN1",},
    [5] = {name="#{ZSYC_241211_201}",image="set:Kunwu_PVP image:Kunwu_PVPTBYH",push="set:Kunwu_PVP2 image:Kunwu_PVPTBYH1",},
    [6] = {name="#{ZSYC_241211_202}",image="set:Kunwu_PVP image:Kunwu_PVPXLYY",push="set:Kunwu_PVP image:Kunwu_PVPXLYY",},
    [7] = {name="#{ZSYC_241211_203}",image="set:Kunwu_PVP image:Kunwu_PVPMF",push="set:Kunwu_PVP2 image:Kunwu_PVPMF1",},
    [8] = {name="#{ZSYC_241211_204}",image="set:Kunwu_PVP image:Kunwu_PVPJLYH",push="set:Kunwu_PVP2 image:Kunwu_PVPJLYH1",},
}

local g_SkillInfo = {
	[0] = {
		[1] = {name="#{ZSYC_241211_208}",image="set:HuoDongSkill11 image:HuoDongSkill11_10",},
		[2] = {name="#{ZSYC_241211_209}",image="set:HuoDongSkill10 image:HuoDongSkill10_16",},
		[3] = {name="#{ZSYC_241211_210}",image="set:HuoDongSkill11 image:HuoDongSkill11_8",},
		[4] = {name="#{ZSYC_241211_211}",image="set:HuoDongSkill11 image:HuoDongSkill11_6",},
	},
	[1] = {
		[1] = {name="#{ZSYC_241211_208}",image="set:HuoDongSkill11 image:HuoDongSkill11_10",},
		[2] = {name="#{ZSYC_241211_209}",image="set:HuoDongSkill10 image:HuoDongSkill10_16",},
		[3] = {name="#{ZSYC_241211_210}",image="set:HuoDongSkill11 image:HuoDongSkill11_8",},
		[4] = {name="#{ZSYC_241211_211}",image="set:HuoDongSkill11 image:HuoDongSkill11_6",},
	},
	[2] = {
		[1] = {name="#{ZSYC_241211_212}",image="set:HuoDongSkill11 image:HuoDongSkill11_14",},
		[2] = {name="#{ZSYC_241211_213}",image="set:HuoDongSkill11 image:HuoDongSkill11_5",},
		[3] = {name="#{ZSYC_241211_214}",image="set:HuoDongSkill10 image:HuoDongSkill10_13",},
		[4] = {name="#{ZSYC_241211_215}",image="set:HuoDongSkill11 image:HuoDongSkill11_2",},
	},
	[3] = {
		[1] = {name="#{ZSYC_241211_216}",image="set:HuoDongSkill10 image:HuoDongSkill10_3",},
		[2] = {name="#{ZSYC_241211_217}",image="set:HuoDongSkill10 image:HuoDongSkill10_4",},
		[3] = {name="#{ZSYC_241211_218}",image="set:HuoDongSkill10 image:HuoDongSkill10_5",},
		[4] = {name="#{ZSYC_241211_219}",image="set:HuoDongSkill10 image:HuoDongSkill10_6",},
	},
	[4] = {
		[1] = {name="#{ZSYC_241211_220}",image="set:HuoDongSkill10 image:HuoDongSkill10_14",},
		[2] = {name="#{ZSYC_241211_221}",image="set:HuoDongSkill11 image:HuoDongSkill11_4",},
		[3] = {name="#{ZSYC_241211_222}",image="set:HuoDongSkill12 image:HuoDongSkill12_1",},
		[4] = {name="#{ZSYC_241211_223}",image="set:HuoDongSkill11 image:HuoDongSkill11_13",},
	},
	[5] = {
		[1] = {name="#{ZSYC_241211_224}",image="set:HuoDongSkill11 image:HuoDongSkill11_11",},
		[2] = {name="#{ZSYC_241211_225}",image="set:HuoDongSkill11 image:HuoDongSkill11_9",},
		[3] = {name="#{ZSYC_241211_226}",image="set:HuoDongSkill10 image:HuoDongSkill10_15",},
		[4] = {name="#{ZSYC_241211_227}",image="set:HuoDongSkill10 image:HuoDongSkill10_12",},
	},
	[6] = {
		[1] = {name="#{ZSYC_241211_228}",image="set:HuoDongSkill9 image:HuoDongSkill9_15",},
		[2] = {name="#{ZSYC_241211_229}",image="set:HuoDongSkill9 image:HuoDongSkill9_16",},
		[3] = {name="#{ZSYC_241211_230}",image="set:HuoDongSkill10 image:HuoDongSkill10_1",},
		[4] = {name="#{ZSYC_241211_231}",image="set:HuoDongSkill10 image:HuoDongSkill10_2",},
	},
	[7] = {
		[1] = {name="#{ZSYC_241211_232}",image="set:HuoDongSkill10 image:HuoDongSkill10_8",},
		[2] = {name="#{ZSYC_241211_233}",image="set:HuoDongSkill10 image:HuoDongSkill10_9",},
		[3] = {name="#{ZSYC_241211_234}",image="set:HuoDongSkill10 image:HuoDongSkill10_7",},
		[4] = {name="#{ZSYC_241211_235}",image="set:HuoDongSkill10 image:HuoDongSkill10_10",},
	},
	[8] = {
		[1] = {name="#{ZSYC_241211_236}",image="set:HuoDongSkill11 image:HuoDongSkill11_7",},
		[2] = {name="#{ZSYC_241211_237}",image="set:HuoDongSkill11 image:HuoDongSkill11_12",},
		[3] = {name="#{ZSYC_241211_238}",image="set:HuoDongSkill11 image:HuoDongSkill11_1",},
		[4] = {name="#{ZSYC_241211_239}",image="set:HuoDongSkill10 image:HuoDongSkill10_11",},
	},
}


function Kunwu_PVPXuanRen_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function Kunwu_PVPXuanRen_OnLoad()
	g_ui_list = {
		{button=Kunwu_PVPXuanRen_Img_1Btn,title=Kunwu_PVPXuanRen_ContentTitle_Info_1,bg=Kunwu_PVPXuanRen_Img_1,},
		{button=Kunwu_PVPXuanRen_Img_2Btn,title=Kunwu_PVPXuanRen_ContentTitle_Info_2,bg=Kunwu_PVPXuanRen_Img_2,},
		{button=Kunwu_PVPXuanRen_Img_3Btn,title=Kunwu_PVPXuanRen_ContentTitle_Info_3,bg=Kunwu_PVPXuanRen_Img_3,},
	}
	g_ui_skill_list = {
		[1] = {
			Kunwu_PVPXuanRen_Img_1_SkillActionBtn_1,
			Kunwu_PVPXuanRen_Img_1_SkillActionBtn_2,
			Kunwu_PVPXuanRen_Img_1_SkillActionBtn_3,
			Kunwu_PVPXuanRen_Img_1_SkillActionBtn_4,
		},
		[2] = {
			Kunwu_PVPXuanRen_Img_2_SkillActionBtn_1,
			Kunwu_PVPXuanRen_Img_2_SkillActionBtn_2,
			Kunwu_PVPXuanRen_Img_2_SkillActionBtn_3,
			Kunwu_PVPXuanRen_Img_2_SkillActionBtn_4,
		},
		[3] = {
			Kunwu_PVPXuanRen_Img_3_SkillActionBtn_1,
			Kunwu_PVPXuanRen_Img_3_SkillActionBtn_2,
			Kunwu_PVPXuanRen_Img_3_SkillActionBtn_3,
			Kunwu_PVPXuanRen_Img_3_SkillActionBtn_4,
		},
	}
	g_unifiedposistion = Kunwu_PVPXuanRen_Frame:GetProperty("UnifiedPosition")
end

function Kunwu_PVPXuanRen_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == g_uicommand ) then
		Kunwu_PVPXuanRen_OnShow()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_uicommandtime ) then
		Kunwu_PVPXuanRen_RefreshTimeUI()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_uicommandclose ) then
		Kunwu_PVPXuanRen_CloseClicked()
	elseif ( event == "ADJEST_UI_POS" ) then
		Kunwu_PVPXuanRen_ResetPos()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		Kunwu_PVPXuanRen_ResetPos()
	elseif(event == "PLAYER_LEAVE_WORLD") then
		Kunwu_PVPXuanRen_CloseClicked()
	end
end

function Kunwu_PVPXuanRen_OnShow()

	g_select = Get_XParam_INT(0)
	g_count = Get_XParam_INT(1)

	for i=1, g_count do
		g_group[i] = Get_XParam_INT(1+i)
	end

	g_lasttime = Get_XParam_INT(2+g_count)
	g_targetId = Get_XParam_INT(3+g_count)
	
	Kunwu_PVPXuanRen_RefreshUI()

	this:Show()
end

--================================================
-- 刷新界面
--================================================
function Kunwu_PVPXuanRen_RefreshUI()
	
	-- 显示内容
	for i=1, g_count do
		local ui = g_ui_list[i]
		if ui ~= nil then
			-- 选中效果
			local petType = g_group[i]
			if g_select == petType then
				ui.button:SetCheck(1)
			else
				ui.button:SetProperty("PushedImage", g_image_push)
				ui.button:SetCheck(0)
			end
			-- 信息显示
			local info = g_IdentityInfo[petType]
			if info ~= nil then
				ui.title:SetText(info.name)
				ui.bg:SetProperty("Image",info.image)

				if g_select == petType then
					ui.button:SetProperty("PushedImage", info.push)
				end
			end

			-- 处理技能
			local skilllist = g_ui_skill_list[i]
			if skilllist ~= nil then
				local skillinfo = g_SkillInfo[petType]
				for index, skillui in (skilllist or {}) do
					if skillinfo ~= nil and skillinfo[index] ~= nil then
						skillui:SetToolTip(skillinfo[index].name)
						skillui:SetProperty("Empty", "False")
						skillui:SetProperty("UseDefaultTooltip", "True")
						skillui:SetProperty("NormalImage", skillinfo[index].image)
						skillui:SetProperty("HoverImage", skillinfo[index].image)
					else
						skillui:SetToolTip("")
						skillui:SetProperty("Empty", "False")
						skillui:SetProperty("UseDefaultTooltip", "True")
						skillui:SetProperty("NormalImage", "")
						skillui:SetProperty("HoverImage", "")
					end
				end
			end
		end
	end

	-- 倒计时
	Kunwu_PVPXuanRen_StopWatch:SetProperty("Timer", g_lasttime)
	Kunwu_PVPXuanRen_StopWatch:SetProperty("TextColor", "FF00FF00")
end

--================================================
-- 刷新界面
--================================================
function Kunwu_PVPXuanRen_RefreshTimeUI()
	g_lasttime = Get_XParam_INT(0)

	-- 倒计时
	Kunwu_PVPXuanRen_StopWatch:SetProperty("Timer", g_lasttime)
	Kunwu_PVPXuanRen_StopWatch:SetProperty("TextColor", "FF00FF00")
end

--================================================
-- 关闭
--================================================
function Kunwu_PVPXuanRen_OnClose()
	this:Hide()
end



function Kunwu_PVPXuanRen_Close()
	this:Hide()
end

--================================================
-- 关闭
--================================================
function Kunwu_PVPXuanRen_CloseClicked()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Kunwu_PVPXuanRen_ResetPos()
	if g_unifiedposistion ~= nil then
		Kunwu_PVPXuanRen_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
	end
end

function Kunwu_PVPXuanRen_Img_1Btn_Click(index)

	if index < 0 or index >= g_count then
		return
	end

	local groupIndex = index + 1
	local data = g_group[groupIndex]
	if data ~= nil then
		g_select = data
	end

	for i=1, g_count do
		local ui = g_ui_list[i]
		if ui ~= nil then
			if i == groupIndex then
				ui.button:SetCheck(1)
				local info = g_IdentityInfo[g_select]
				if info ~= nil then
					ui.button:SetProperty("PushedImage", info.push)
				end
			else
				ui.button:SetProperty("PushedImage", g_image_push)
				ui.button:SetCheck(0)
			end
		end
	end
end

function Kunwu_PVPXuanRen_OK()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnSelectPetMode")
		Set_XSCRIPT_ScriptID(999615)
		Set_XSCRIPT_Parameter(0, g_targetId)
		Set_XSCRIPT_Parameter(1, g_select)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

	this:Hide()
end
