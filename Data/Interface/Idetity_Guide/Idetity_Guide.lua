-- 新身份系统-引导任务界面
-- !!!reloadscript =Idetity_Guide

local g_UnifiedPosition = nil
local g_CurPage = 0
local g_MaxPage = 4
local g_Ctrl = {}

local g_NpcList = 
{
	[1] = {posx=184,posz=214,sceneid=0,npcname="Ng鋓 Ph呓ng",image="set:Idetity_Guide image:Title_L_LXL",pic="set:Idetity_Guide image:BK_S_LXL",--??NPC
				 title="#{SFYD_231227_332}",desc="#{SFYD_231227_10}",skilldesc="#{SFYD_231227_17}",autotip="#{SFYD_231227_23}",},
	[2] = {posx=201,posz=214,sceneid=0,npcname="M礳 lan",image="set:Idetity_Guide image:Title_L_XHZ",pic="set:Idetity_Guide image:BK_S_XHZ",--??NPC
				 title="#{SFYD_231227_333}",desc="#{SFYD_231227_11}",skilldesc="#{SFYD_231227_18}",autotip="#{SFYD_231227_24}",},
	[3] = {posx=237,posz=214,sceneid=0,npcname="Th譨 膎h",image="set:Idetity_Guide image:Title_L_ZQZ",pic="set:Idetity_Guide image:BK_S_ZQZ",--??NPC
				 title="#{SFYD_231227_335}",desc="#{SFYD_231227_13}",skilldesc="#{SFYD_231227_20}",autotip="#{SFYD_231227_25}",},
	[4] = {posx=230,posz=208,sceneid=0,npcname="C鬾g Th鈛 Tr醕",image="set:Idetity_Guide image:Title_L_QZT",pic="set:Idetity_Guide image:BK_S_ZQT",--??NPC
				 title="#{SFYD_231227_337}",desc="#{SFYD_231227_15}",skilldesc="#{SFYD_231227_22}",autotip="#{SFYD_231227_26}",},
}

--===============================================
-- PreLoad()
--===============================================
function Idetity_Guide_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function Idetity_Guide_OnLoad()
	g_UnifiedPosition = Idetity_Guide_Frame:GetProperty("UnifiedPosition")	
	g_Ctrl = {Idetity_Guide_Page_Btn1,Idetity_Guide_Page_Btn2,Idetity_Guide_Page_Btn4,Idetity_Guide_Page_Btn5}
end

--===============================================
-- OnEvent()
--===============================================
function Idetity_Guide_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 99865501) then
		--打开/关睜/刷新界面
		local flag = Get_XParam_INT(0) 
		if flag ~= nil and flag == 2 then
			--关界面
			if this:IsVisible() then
				Idetity_Guide_CloseClicked()
			end
		else
			-- 开界面or刷新界面
			local bShow = Get_XParam_INT(1)
			local nPage = Get_XParam_INT(2)
			if flag == 1 then--???
					this:Show()
					Idetity_Guide_Open(bShow,nPage)
			else--???
				if( this:IsVisible() ) then
					Idetity_Guide_Open(bShow,nPage)
				end
			end
		end
	elseif (event  == "UI_COMMAND") and (tonumber(arg0) == 99865502) then
		--自动寻路
		local nPage = Get_XParam_INT(0)
		if g_NpcList[nPage] ~= nil then
			AutoRuntoTargetExWithName(g_NpcList[nPage].posx, g_NpcList[nPage].posz, g_NpcList[nPage].sceneid, g_NpcList[nPage].npcname)
			local tip = ScriptGlobal_Format("#{SFYD_231227_08}", g_NpcList[nPage].autotip)
			PushDebugMessage(tip)
		end
	elseif (event == "ADJEST_UI_POS") then
		Idetity_Guide_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Idetity_Guide_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Idetity_Guide_CloseClicked()
	end
end

--===============================================
-- 重置
--===============================================
function Idetity_Guide_ResetPos()
	Idetity_Guide_Frame:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

--===============================================
-- 清数据
--===============================================
function Idetity_Guide_OnHidden()
	g_CurPage = 0
end

--===============================================
-- 关界面
--===============================================
function Idetity_Guide_CloseClicked()
	--数据清繝
	Idetity_Guide_OnHidden()
	--隐藏界面
	this:Hide()
end

--===============================================
-- 开界面
--===============================================
function Idetity_Guide_Open(bShow,nPage)
	if bShow == nil or bShow < 0 or bShow > 1 then
		return
	end
	if nPage == nil or nPage < 0 or nPage > g_MaxPage then
		return
	end	
	if bShow == 0 then--0????
		Idetity_Guide_JoinClient:Show()--????1
		Idetity_Guide_GuideClient:Hide()--????2
	elseif bShow == 1 then--1????
		Idetity_Guide_JoinClient:Hide()--????1
		Idetity_Guide_GuideClient:Show()--????2
		if nPage == 0 then
			g_CurPage = 1
		else
			g_CurPage = nPage
		end
		Idetity_Guide_PageClicked(g_CurPage)
	end
end

--===============================================
-- 点击-加入身份
--===============================================
function Idetity_Guide_JoinClicked()
	Idetity_Guide_JoinClient:Hide()--????1
	Idetity_Guide_GuideClient:Show()--????2
	g_CurPage = 1
	Idetity_Guide_PageClicked(g_CurPage)
end

--===============================================
-- 点击-切换分页
--===============================================
function Idetity_Guide_PageClicked(nIndex)
	if nIndex == nil or nIndex <= 0 or nIndex > g_MaxPage then
		return
	end
	if g_NpcList[nIndex] == nil then
		return
	end
	g_CurPage = nIndex
	g_Ctrl[g_CurPage]:SetCheck(1)
	Idetity_Guide_LargeTitle_Image:SetProperty("Image",g_NpcList[g_CurPage].image)
	Idetity_Guide_S_BK_Image:SetProperty("Image",g_NpcList[g_CurPage].pic)
	Idetity_Guide_Idetity_Text:SetText(g_NpcList[g_CurPage].title)
	Idetity_Guide_Idetity_IntroText:SetText(g_NpcList[g_CurPage].desc)
	Idetity_Guide_Idetity_SkillText:SetText(g_NpcList[g_CurPage].skilldesc)
end

--===============================================
-- 点击-自动前往
--===============================================
function Idetity_Guide_IdetityGet_GotoClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998655)
		Set_XSCRIPT_Function_Name("OnAccept")
		Set_XSCRIPT_Parameter(0, g_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end
