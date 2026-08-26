-- 狔霸赛上狊界面

local g_ObjCareID = 0
local m_targetId = 0
local MAX_OBJ_DISTANCE = 3.0
local g_unifiedposistion
local g_uicommand_open = 99882501
local m_round = 0
local m_remainTime = 0
local m_upDataNameList = {}
local m_upDataHeadImageList = {}
local m_upDataMenPeiList = {}

local m_MenPaiNameList =
{
	[0]  ={name="#{WCBZ_180128_59}",color="#cff6600"},	--??
	[1]  ={name="#{WCBZ_180128_65}",color="#cffcc00"},	--??
	[2]  ={name="#{WCBZ_180128_67}",color="#c00ff00"},	--??
	[3]  ={name="#{WCBZ_180128_61}",color="#c0000ff"},	--??
	[4]  ={name="#{WCBZ_180128_68}",color="#cff99cc"},	--??
	[5]  ={name="#{WCBZ_180128_66}",color="#c007700"},	--??
	[6]  ={name="#{WCBZ_180128_60}",color="#cffff00"},	--??
	[7]  ={name="#{WCBZ_180128_63}",color="#cffffff"},	--??
	[8]  ={name="#{WCBZ_180128_64}",color="#c7700ff"},	--??
	[9]  ={name="#{WCBZ_180128_57}",color="#c999999"},	--???
	[10] ={name="#{WCBZ_180128_62}",color="#cffffb3"},	--??
}

--预加载函数，可以而且只能在犫里注册脚本关心的事件
function NoDiffMatch_Attend_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function NoDiffMatch_Attend_ResetPos()
	NoDiffMatch_Attend_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function NoDiffMatch_Attend_OnLoad()
	g_unifiedposistion	= NoDiffMatch_Attend_Frame:GetProperty("UnifiedPosition")
end


--响应事件的函数，当注册的事件发生时会调用的函数
function NoDiffMatch_Attend_OnEvent(event)
	-- PushDebugMessage(event)
	if( event == "UI_COMMAND" and tonumber(arg0) == g_uicommand_open) then
		NoDiffMatch_Attend_CommandEvent()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		NoDiffMatch_Attend_Hide()
	elseif event == "ADJEST_UI_POS" then
		NoDiffMatch_Attend_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		NoDiffMatch_Attend_ResetPos()
	elseif event == "OBJECT_CARED_EVENT" then
		NoDiffMatch_Attend_CareEvent(arg0,arg1,arg2)
	end
end

--显示UI
function NoDiffMatch_Attend_Show()
	NoDiffMatch_Attend_ClearData()
	this:CareObject(g_ObjCareID, 1, "NoDiffMatch_Attend");
	SetTimer("NoDiffMatch_Attend", "NoDiffMatch_Attend_AutoClick_Timer()", 1000)
	this:Show()
end

function NoDiffMatch_Attend_CommandEvent()
	local nType = Get_XParam_INT(0)
	if nType == 1 then --??????
		local targetId = Get_XParam_INT(1)
		m_targetId = targetId
		m_round = Get_XParam_INT(2)
		m_remainTime = Get_XParam_INT(3)
		local dataLength = Get_XParam_INT(4)
		m_upDataNameList = {}
		m_upDataHeadImageList = {}
		m_upDataMenPeiList = {}
		local addIntIndex = 5
		local addStrIndex = 0
		for index = 1, dataLength do
			local name = Get_XParam_STR(addStrIndex)
			addStrIndex = addStrIndex + 1
			local headImage = Get_XParam_INT(addIntIndex)
			addIntIndex = addIntIndex + 1
			local menPai = Get_XParam_INT(addIntIndex)
			addIntIndex = addIntIndex + 1
			m_upDataNameList[index] = name
			m_upDataHeadImageList[index] = headImage
			m_upDataMenPeiList[index] = menPai
		end
		if (this:IsVisible()) then
			NoDiffMatch_Attend_Update()
			return
		end
		g_ObjCareID = DataPool:GetNPCIDByServerID(targetId)
		NoDiffMatch_Attend_Show()
		NoDiffMatch_Attend_Update()
	elseif nType == 2 or --????????
		nType == 3 or --??????????
		nType == 4 then  --????????
		if (this:IsVisible()) then
			m_round = Get_XParam_INT(1)
			m_remainTime = Get_XParam_INT(2)
			local dataLength = Get_XParam_INT(3)
			m_upDataNameList = {}
			m_upDataHeadImageList = {}
			m_upDataMenPeiList = {}
			local addIntIndex = 4
			local addStrIndex = 0
			for index = 1, dataLength do
				local name = Get_XParam_STR(addStrIndex)
				addStrIndex = addStrIndex + 1
				local headImage = Get_XParam_INT(addIntIndex)
				addIntIndex = addIntIndex + 1
				local menPai = Get_XParam_INT(addIntIndex)
				addIntIndex = addIntIndex + 1
				m_upDataNameList[index] = name
				m_upDataHeadImageList[index] = headImage
				m_upDataMenPeiList[index] = menPai
			end
			NoDiffMatch_Attend_Update()
			return
		end
	end
end

function NoDiffMatch_Attend_AutoClick_Timer()
	if m_remainTime <= 0 then
		NoDiffMatch_Attend_Hide()
		PushEvent("UI_COMMAND", 1000)
		return
	end
	m_remainTime = m_remainTime - 1
	NoDiffMatch_Attend_UpdateTime()
end

--隐藏UI
function NoDiffMatch_Attend_Hide()
	NoDiffMatch_Attend_ClearData()

	this:Hide()
end

--清除数据
function NoDiffMatch_Attend_ClearData()
	KillTimer("NoDiffMatch_Attend_AutoClick_Timer()")
end

--更新
function NoDiffMatch_Attend_Update()
	if m_round == 3 then
		NoDiffMatch_Attend_Hide()
		return
	end
	NoDiffMatch_Attend_2:SetProperty("Image", "")
	if m_round == 1 then
		NoDiffMatch_Attend_2:SetProperty("Image", "set:OB image:TwoVsTwo")
	elseif m_round == 2 then
		NoDiffMatch_Attend_2:SetProperty("Image", "set:OB image:ThreeVsThree")
	elseif m_round == 4 then
		NoDiffMatch_Attend_2:SetProperty("Image", "set:OB image:OneVsOne")
	end
	NoDiffMatch_Attend_HeadBK1:Hide()
	NoDiffMatch_Attend_XingMing_Text1:Hide()
	NoDiffMatch_Attend_MenPai_Text1:Hide()
	NoDiffMatch_Attend_KongQue_Text1:Hide()
	NoDiffMatch_Attend_HeadBK2:Hide()
	NoDiffMatch_Attend_XingMing_Text2:Hide()
	NoDiffMatch_Attend_MenPai_Text2:Hide()
	NoDiffMatch_Attend_KongQue_Text2:Hide()
	NoDiffMatch_Attend_HeadBK3:Hide()
	NoDiffMatch_Attend_XingMing_Text3:Hide()
	NoDiffMatch_Attend_MenPai_Text3:Hide()
	NoDiffMatch_Attend_KongQue_Text3:Hide()
	
	local lixianText = ScriptGlobal_Format("#{WCBZ_230605_33}", "Li Tuy猲")
	local fillIndex = 0
	if m_round == 1 or m_round == 2 then
		NoDiffMatch_Attend_HeadBK1:Show()
		fillIndex = fillIndex + 1
		if m_upDataNameList[fillIndex] == nil then
			NoDiffMatch_Attend_KongQue_Text1:Show()
			NoDiffMatch_Attend_Head1:SetProperty("Image", "")
		else
			NoDiffMatch_Attend_XingMing_Text1:Show()
			NoDiffMatch_Attend_MenPai_Text1:Show()
			if m_upDataNameList[fillIndex] == "" then
				NoDiffMatch_Attend_XingMing_Text1:SetText(lixianText)
				NoDiffMatch_Attend_MenPai_Text1:SetText(lixianText)
				NoDiffMatch_Attend_Head1:SetProperty("Image", "")
			else
				local portrait = DataPool:GetPortraitByID(m_upDataHeadImageList[fillIndex])
				NoDiffMatch_Attend_Head1:SetProperty("Image", portrait)
				local name = ScriptGlobal_Format("#{WCBZ_230605_33}", m_upDataNameList[fillIndex])
				local menpai = ScriptGlobal_Format("#{WCBZ_230605_34}", m_MenPaiNameList[m_upDataMenPeiList[fillIndex]].name)
				NoDiffMatch_Attend_XingMing_Text1:SetText(name)
				NoDiffMatch_Attend_MenPai_Text1:SetText(menpai)
			end
		end
	end
	if m_round == 2 or m_round == 4 then
		NoDiffMatch_Attend_HeadBK2:Show()
		fillIndex = fillIndex + 1
		if m_upDataNameList[fillIndex] == nil then
			NoDiffMatch_Attend_KongQue_Text2:Show()
			NoDiffMatch_Attend_Head2:SetProperty("Image", "")
		else
			NoDiffMatch_Attend_XingMing_Text2:Show()
			NoDiffMatch_Attend_MenPai_Text2:Show()
			if m_upDataNameList[fillIndex] == "" then
				NoDiffMatch_Attend_XingMing_Text2:SetText(lixianText)
				NoDiffMatch_Attend_MenPai_Text2:SetText(lixianText)
				NoDiffMatch_Attend_Head2:SetProperty("Image", "")
			else
				local portrait = DataPool:GetPortraitByID(m_upDataHeadImageList[fillIndex])
				NoDiffMatch_Attend_Head2:SetProperty("Image", portrait)
				local name = ScriptGlobal_Format("#{WCBZ_230605_33}", m_upDataNameList[fillIndex])
				local menpai = ScriptGlobal_Format("#{WCBZ_230605_34}", m_MenPaiNameList[m_upDataMenPeiList[fillIndex]].name)
				NoDiffMatch_Attend_XingMing_Text2:SetText(name)
				NoDiffMatch_Attend_MenPai_Text2:SetText(menpai)
			end
		end
	end
	if m_round == 1 or m_round == 2 then
		NoDiffMatch_Attend_HeadBK3:Show()
		fillIndex = fillIndex + 1
		if m_upDataNameList[fillIndex] == nil then
			NoDiffMatch_Attend_KongQue_Text3:Show()
			NoDiffMatch_Attend_Head3:SetProperty("Image", "")
		else
			NoDiffMatch_Attend_XingMing_Text3:Show()
			NoDiffMatch_Attend_MenPai_Text3:Show()
			if m_upDataNameList[fillIndex] == "" then
				NoDiffMatch_Attend_XingMing_Text3:SetText(lixianText)
				NoDiffMatch_Attend_MenPai_Text3:SetText(lixianText)
				NoDiffMatch_Attend_Head3:SetProperty("Image", "")
			else
				local portrait = DataPool:GetPortraitByID(m_upDataHeadImageList[fillIndex])
				local name = ScriptGlobal_Format("#{WCBZ_230605_33}", m_upDataNameList[fillIndex])
				local menpai = ScriptGlobal_Format("#{WCBZ_230605_34}", m_MenPaiNameList[m_upDataMenPeiList[fillIndex]].name)
				
				NoDiffMatch_Attend_Head3:SetProperty("Image", portrait)
				NoDiffMatch_Attend_XingMing_Text3:SetText(name)
				NoDiffMatch_Attend_MenPai_Text3:SetText(menpai)
			end
		end
	end
	NoDiffMatch_Attend_UpdateTime()
end

--更新
function NoDiffMatch_Attend_UpdateTime()
	NoDiffMatch_Attend_StageBK_Text:SetText(ScriptGlobal_Format("#{WCBZ_230605_37}", m_remainTime))
end

--##############点击事件##############
function NoDiffMatch_Attend_ClickClose()
	NoDiffMatch_Attend_Hide()
end

--我要上狊
function NoDiffMatch_Attend_ClickOk()
	-- PushDebugMessage("NoDiffMatch_Attend_ClickOk")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ClientJoinUpMatch")
		Set_XSCRIPT_ScriptID( 998825 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end
--取消上狊
function NoDiffMatch_Attend_ClickCancel()
	-- PushDebugMessage("NoDiffMatch_Attend_ClickCancel")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ClientLeaveUpMatch")
		Set_XSCRIPT_ScriptID( 998825 )
		Set_XSCRIPT_Parameter(0, 1)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end
--####################################

--以下是用户自定义的函数
function NoDiffMatch_Attend_CareEvent(arg0,arg1,arg2)
	local ObjCaredID = tonumber(arg0)
	if( ObjCaredID ~= g_ObjCareID) then
		return
	end
	local ObjDistance = tonumber(arg2)
	if( (arg1 == "distance" and ObjDistance>MAX_OBJ_DISTANCE) or arg1=="destroy") then
		NoDiffMatch_Attend_Hide()
	end
end
