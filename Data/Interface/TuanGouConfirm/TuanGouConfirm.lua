--***********************************************************************************************************************************************
--2022Q3时装团购
--确认界面
--***********************************************************************************************************************************************
local g_UnifiedPosition

local objCared = -1
local targetId = -1

local g_CloseTick = 5--5秒倒计时
local g_guidLeaveMem = 0
local g_bReceiveCloseUIMsg = 0

local g_CtrlList = {}
local g_memberlist={}

local g_StateImage=
{
	[0] = "set:TuanGou image:Waiting",--等待
	[1] = "set:TuanGou image:OK",--同意
	[2] = "set:TuanGou image:Cancel",--拒绝
}

--***********************************************************************************************************************************************
-- PreLoad
--************************************************************************************************************************************************
function TuanGouConfirm_PreLoad()
	this:RegisterEvent("OPEN_TUANGOUCONFIRM")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

--***********************************************************************************************************************************************
-- OnLoad
--************************************************************************************************************************************************
function TuanGouConfirm_OnLoad()
	g_UnifiedPosition=TuanGouConfirm_Frame:GetProperty("UnifiedPosition")
	g_CtrlList = 
	{
		{ frame=TuanGouConfirm_Captain, name=TuanGouConfirm_Captain_name, stat=TuanGouConfirm_Captain_ConfirmIcon, },
		{ frame=TuanGouConfirm_1, name=TuanGouConfirm_1_name, stat=TuanGouConfirm_1_ConfirmIcon, },
		{ frame=TuanGouConfirm_2, name=TuanGouConfirm_2_name, stat=TuanGouConfirm_2_ConfirmIcon, },
		{ frame=TuanGouConfirm_3, name=TuanGouConfirm_3_name, stat=TuanGouConfirm_3_ConfirmIcon, },
		{ frame=TuanGouConfirm_4, name=TuanGouConfirm_4_name, stat=TuanGouConfirm_4_ConfirmIcon, },
		{ rame=TuanGouConfirm_5, name=TuanGouConfirm_5_name, stat=TuanGouConfirm_5_ConfirmIcon, },
	}
end

--***********************************************************************************************************************************************
-- 事件响应函数
--************************************************************************************************************************************************
function TuanGouConfirm_OnEvent(event)

	if ( event == "OPEN_TUANGOUCONFIRM" ) then
		local uiflag = tonumber(arg0)
		--打开界面
		if uiflag>0 then
			targetId = uiflag
			objCared = DataPool : GetNPCIDByServerID(tonumber(targetId))
			if objCared == nil or objCared == -1 then
				return
			end
			this:CareObject(objCared, 1, "TuanGouConfirm")
			g_bReceiveCloseUIMsg = 0
			TuanGouConfirm_Update()
			this:Show()
		--拼团成功关界面
		elseif uiflag==-1 then
			g_bReceiveCloseUIMsg = 1
			this:Hide()
			return
		--有玩家参与拼团
		elseif uiflag==-2 and this:IsVisible() then
			TuanGouConfirm_EnterUpdate(tonumber(arg1))
		--有玩家取消拼团
		elseif uiflag==-3 and this:IsVisible() then
			g_bReceiveCloseUIMsg = 1
			g_CloseTick = 5
			g_guidLeaveMem = tonumber(arg1)
			TuanGouConfirm_LeaveUpdate()
			KillTimer("TuanGouConfirmCloseTick()")
			SetTimer("TuanGouConfirm","TuanGouConfirmCloseTick()", 1000)
		--异常立即关界面
		elseif uiflag==-4 and this:IsVisible() then
			g_bReceiveCloseUIMsg = 1
			this:Hide()
		end
	elseif (event == "ADJEST_UI_POS" ) then
		TuanGouConfirm_ResetPos()		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TuanGouConfirm_ResetPos()
	end
end

--***********************************************************************************************************************************************
-- 刷新界面
--************************************************************************************************************************************************
function TuanGouConfirm_Update()
	--成员清空
	g_memberlist={}
	-- 得到队员的个数
	local iMemCount = DataPool:GetTeamMemberCount()
	for i=1,iMemCount do
		-- 得到队员的详细信息
		local charname,charguid,strIconIndex,isLeader,_ = DataPool:GetTeamMemInfoExByIndex( i-1 )
		--名字
		g_CtrlList[i].name:SetText(ScriptGlobal_Format("#{SZTG_230825_19}", charname))
		--状态
		local state = 0
		if isLeader==1 then
			state = 1--已确认
		else
			state = 0--等待中
		end
		g_CtrlList[i].stat:SetProperty("Image",g_StateImage[state])
		--插入数据
		TuanGouConfirm_InserMember(charguid,charname,state)
	end
	--按钮
	if( tonumber( Player:IsLeader() ) == 1 ) then
		--队长
		TuanGouConfirm_Text:Show()
		TuanGouConfirm_Text:SetText("#{SZTG_230825_22}")
		TuanGouConfirm_QuerenPintuan:Hide()--参与拼团
		TuanGouConfirm_FaqiPintuan:Hide()--队长确认拼团
	else
		--队员
		TuanGouConfirm_QuerenPintuan:Show()--参与拼团
		TuanGouConfirm_FaqiPintuan:Hide()--队长确认拼团
		TuanGouConfirm_Text:SetText("")
		TuanGouConfirm_Text:Hide()
	end
end

--***********************************************************************************************************************************************
-- 记录队伍成员
--************************************************************************************************************************************************
function TuanGouConfirm_InserMember(guid,name,state)
	local nItem = {}
	nItem.charguid = guid
	nItem.charname = name
	nItem.state = state
	table.insert(g_memberlist,nItem)
end

--***********************************************************************************************************************************************
-- 有成员参与拼团
--************************************************************************************************************************************************
function TuanGouConfirm_EnterUpdate(memguid)
	local iMemCount = table.getn(g_memberlist)
	for i=1,iMemCount do
		--得到队员的详细信息
		if memguid==g_memberlist[i].charguid then
			--状态更新
			g_memberlist[i].state = 1--已确认
			g_CtrlList[i].stat:SetProperty("Image",g_StateImage[1])--已确认
			break
		end
	end
	--按钮
	if( tonumber( Player:IsLeader() ) == 1 ) then
		--队长根据是否全部拼团显隐按钮和文本
		local nCount = 0
		for i=1,iMemCount do
			if g_memberlist[i].state == 1 then
				nCount = nCount+1
			end
		end
		--全部参与拼团
		if nCount == iMemCount then
			TuanGouConfirm_FaqiPintuan:Show()--队长确认拼团
			TuanGouConfirm_QuerenPintuan:Hide()--参与拼团
			TuanGouConfirm_Text:SetText("")
			TuanGouConfirm_Text:Hide()
		end
	elseif memguid == GetSelfGUID() then
		--参与拼团的队员显隐按钮和文本
		TuanGouConfirm_Text:Show()
		TuanGouConfirm_Text:SetText("#{SZTG_230825_21}")
		TuanGouConfirm_QuerenPintuan:Hide()--参与拼团
		TuanGouConfirm_FaqiPintuan:Hide()--队长确认拼团
	end
end

--***********************************************************************************************************************************************
-- 有成员取消拼团
--************************************************************************************************************************************************
function TuanGouConfirm_LeaveUpdate()
	local iMemCount = table.getn(g_memberlist)
	for i=1,iMemCount do
		--得到队员的详细信息
		if g_guidLeaveMem==g_memberlist[i].charguid then
			--状态更新
			g_memberlist[i].state = 2--已确认
			g_CtrlList[i].stat:SetProperty("Image",g_StateImage[2])--已确认
			return
		end
	end
end

--***********************************************************************************************************************************************
-- 关界面倒计时
--************************************************************************************************************************************************
function TuanGouConfirmCloseTick()
	--关界面
	if g_CloseTick<=0 then
		this:Hide()
		return
	end
	--显示倒计时
	TuanGouConfirm_Text:Show()
	local szText = ScriptGlobal_Format("#{SZTG_230825_24}", g_CloseTick)
	TuanGouConfirm_Text:SetText(szText)
	TuanGouConfirm_QuerenPintuan:Hide()--参与拼团
	TuanGouConfirm_FaqiPintuan:Hide()--队长确认拼团
	--更新倒计时
	g_CloseTick = g_CloseTick-1
end

--***********************************************************************************************************************************************
-- 重置位置
--************************************************************************************************************************************************
function TuanGouConfirm_ResetPos()
  TuanGouConfirm_Frame:SetProperty("UnifiedPosition", g_UnifiedPosition)
end

--***********************************************************************************************************************************************
-- 清数据
--***********************************************************************************************************************************************
function TuanGouConfirm_OnHiden()
	--关闭计时器
	KillTimer("TuanGouConfirmCloseTick()")
	--取消关心
	this:CareObject(objCared, 0, "TuanGouConfirm")
	if g_bReceiveCloseUIMsg == 0 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnMemberLeaveClk")
			Set_XSCRIPT_ScriptID(998518)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
		g_bReceiveCloseUIMsg = 1
	end
end

--***********************************************************************************************************************************************
--发起拼团
--***********************************************************************************************************************************************
function TuanGouConfirm_StartClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnLeaderStartClk")
		Set_XSCRIPT_ScriptID(998518)
		Set_XSCRIPT_Parameter(0,targetId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--***********************************************************************************************************************************************
--加入拼团
--***********************************************************************************************************************************************
function TuanGouConfirm_EnterClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnMemberEnterClk")
		Set_XSCRIPT_ScriptID(998518)
		Set_XSCRIPT_Parameter(0,targetId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end
