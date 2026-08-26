--武境功能 @XUEWU
local g_Peak_Learn_Frame_UnifiedPosition
local g_Peak_Learn_menpai_list = {}

local g_PeakLearn_targetId = -1
local g_Object = -1

local g_AutoClickTimer_Step = 100		-- 多少时间(毫秒)模拟一次 Click 操作
local g_AutoClick_FunList = {}			-- 将公用一个 Timer 的回调功能函数放到一个数组
local g_AutoClick_BtnFlag = -1			-- 记录当前鼠标左键是在哪个按钮按下
local g_AutoClick_Going = -1			-- 标志是否开始自动点击操作(第一次LButton后经过X个Timer才算开始, 也就是说是 g_AutoClickTimer_Step * X 的时候开始进行自动加, 这样为了防止本来要点击一下的结果点了好多下)

local g_CurRemain_Attack_Point = 0 --进攻门派对应的心得点
local g_CurRemain_Defence_Point = 0 --防御门派对应的心得点
local g_RemainPoint_Attack_Point = 0
local g_RemainPoint_Defence_Point = 0

local g_Attack_1_Point = 0 --进攻门派1对应的心得点
local g_Attack_2_Point = 0 --进攻门派2对应的心得点
local g_Attack_3_Point = 0 --进攻门派3对应的心得点

local g_Defence_1_Point = 0 --防御门派1对应的心得点
local g_Defence_2_Point = 0 --防御门派2对应的心得点
local g_Defence_3_Point = 0 --防御门派3对应的心得点

local g_DeFengLv = 0
local Peak_Learn_Red_Icon =
{
	"set:Peak image:Peak_Learn_Red0",
	"set:Peak image:Peak_Learn_Red1",
	"set:Peak image:Peak_Learn_Red2",
	"set:Peak image:Peak_Learn_Red3",
	"set:Peak image:Peak_Learn_Red4",
	"set:Peak image:Peak_Learn_Red5",
	"set:Peak image:Peak_Learn_Red6",
	"set:Peak image:Peak_Learn_Red7",
	"set:Peak image:Peak_Learn_Red8",
	"set:Peak image:Peak_Learn_Red9",
}

local Peak_Learn_Blue_Icon =
{
	"set:Peak image:Peak_Learn_Blue0",
	"set:Peak image:Peak_Learn_Blue1",
	"set:Peak image:Peak_Learn_Blue2",
	"set:Peak image:Peak_Learn_Blue3",
	"set:Peak image:Peak_Learn_Blue4",
	"set:Peak image:Peak_Learn_Blue5",
	"set:Peak image:Peak_Learn_Blue6",
	"set:Peak image:Peak_Learn_Blue7",
	"set:Peak image:Peak_Learn_Blue8",
	"set:Peak image:Peak_Learn_Blue9",
}

--OnLoad
function Peak_Learn_PreLoad()
	this:RegisterEvent("SHOW_CONTEXMENU");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("HIDE_CONTEXMENU_SPEAKER");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("OPEN_Peak_Learn");
	this:RegisterEvent("TOGLE_PET_PAGE");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_LEVEL")
end
local g_menpai = {
	[1] = {Text = "少林",}, --少林
	[2] = {Text = "明教",}, --明教
	[3] = {Text = "丐帮",}, --丐帮
	[4] = {Text = "武当",}, --武当
	[5] = {Text = "峨嵋",}, --峨眉
	[6] = {Text = "星宿",}, --星宿
	[7] = {Text = "天龙",}, --天龙
	[8] = {Text = "天山",}, --天山
	[9] = {Text = "逍遥",}, --逍遥
	[10] = {Text = "曼陀山庄",}, --曼陀山庄
	[11] = {Text = "恶人谷",}, --恶人谷
}
function Peak_Learn_OnLoad()
	g_Peak_Learn_Frame_UnifiedPosition=Peak_Learn_Frame:GetProperty("UnifiedPosition")

	g_AutoClick_FunList[1] = Peak_Learn_Add_Attack_XDD_1_Click
	g_AutoClick_FunList[2] = Peak_Learn_Add_Attack_XDD_2_Click
	g_AutoClick_FunList[3] = Peak_Learn_Add_Attack_XDD_3_Click
	g_AutoClick_FunList[4] = Peak_Learn_Dec1_Attack_XDD_1_Click
	g_AutoClick_FunList[5] = Peak_Learn_Dec2_Attack_XDD_2_Click
	g_AutoClick_FunList[6] = Peak_Learn_Dec3_Attack_XDD_3_Click
	g_AutoClick_FunList[7] = Peak_Learn_Add_Defence_XDD_1_Click
	g_AutoClick_FunList[8] = Peak_Learn_Add_Defence_XDD_2_Click
	g_AutoClick_FunList[9] = Peak_Learn_Add_Defence_XDD_3_Click
	g_AutoClick_FunList[10] = Peak_Learn_Dec1_Defence_XDD_1_Click
	g_AutoClick_FunList[11] = Peak_Learn_Dec2_Defence_XDD_2_Click
	g_AutoClick_FunList[12] = Peak_Learn_Dec3_Defence_XDD_3_Click

end

function Peak_Learn_OnEvent(event)

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Peak_Learn_ResetPos()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20250806 then
		g_PeakLearn_targetId = Get_XParam_INT(0)
		Get_XParam_INT(1)
		if tonumber(g_PeakLearn_targetId) == -1 then
			return
		end
		local objCared = DataPool : GetNPCIDByServerID(g_PeakLearn_targetId);
		if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
			return
		end
		Peak_Learn_BeginCareObject(objCared)
		Peak_Learn_Update()
		this:Show()

	elseif event == "UI_COMMAND" and tonumber(arg0) == 20250813 then

		Peak_Learn_UpdateBagLine()
		this:Show()
	end
end
function Peak_Learn_BeginCareObject(objCared)
	g_Object = objCared;
	this:CareObject(tonumber(g_Object), 1, "Peak_Learn");
end

function Peak_Learn_Update()
	Peak_Learn_UpdateBagLine()
	--SetTimer("Peak_Learn", "Peak_Learn_AutoClick_Timer()", g_AutoClickTimer_Step)
end

function Peak_Learn_UpdateBagLine()
	
	local DFLevel = GetDFengLevel()
	if tonumber(DFLevel) < 10 then
		Peak_Learn_AllocationPoint_AttackMenpaiBK1:Hide()
		Peak_Learn_AllocationPoint_AttackMenpaiBK_Locked:Show()
		
		Peak_Learn_AllocationPoint_DefenceMenpaiBK1:Hide()
		Peak_Learn_AllocationPoint_DefenceMenpaiBK_Locked:Show()
	-- elseif tonumber(DFLevel) >= 10 and tonumber(DFLevel) < 20 then
	else
		-- DFLevel >= 10: 显示槽位1，隐藏锁定
		Peak_Learn_AllocationPoint_AttackMenpaiBK1:Show()
		Peak_Learn_AllocationPoint_AttackMenpaiBK_Locked:Hide()

		Peak_Learn_AllocationPoint_DefenceMenpaiBK1:Show()
		Peak_Learn_AllocationPoint_DefenceMenpaiBK_Locked:Hide()
	end
	if tonumber(DFLevel) < 50 then
		Peak_Learn_AllocationPoint_AttackMenpaiBK_Locked1:Show()
		Peak_Learn_AllocationPoint_AttackMenpaiBK2:Hide()

		Peak_Learn_AllocationPoint_DefenceMenpaiBK_Locked1:Show()
		Peak_Learn_AllocationPoint_DefenceMenpaiBK2:Hide()
	else
		Peak_Learn_AllocationPoint_AttackMenpaiBK_Locked1:Hide()
		Peak_Learn_AllocationPoint_AttackMenpaiBK2:Show()

		Peak_Learn_AllocationPoint_DefenceMenpaiBK_Locked1:Hide()
		Peak_Learn_AllocationPoint_DefenceMenpaiBK2:Show()
	end
	if tonumber(DFLevel) < 100 then
		Peak_Learn_AllocationPoint_AttackMenpaiBK_Locked2:Show()
		Peak_Learn_AllocationPoint_AttackMenpaiBK3:Hide()

		Peak_Learn_AllocationPoint_DefenceMenpaiBK_Locked2:Show()
		Peak_Learn_AllocationPoint_DefenceMenpaiBK3:Hide()
	else
		Peak_Learn_AllocationPoint_AttackMenpaiBK3:Show()
		Peak_Learn_AllocationPoint_AttackMenpaiBK_Locked2:Hide()

		Peak_Learn_AllocationPoint_DefenceMenpaiBK_Locked2:Hide()
		Peak_Learn_AllocationPoint_DefenceMenpaiBK3:Show()
	end

	local attackmenpai_kj = {}
	local defencemenpai_kj = {}
	for i=1,3 do
		attackmenpai_kj[i] = _G["Peak_Learn_AllocationPoint_AttackMenpai"..i]
		defencemenpai_kj[i] = _G["Peak_Learn_AllocationPoint_DefenceMenpai"..i]		

		attackmenpai_kj[i]:SetText("")
		attackmenpai_kj[i]:ResetList()
		attackmenpai_kj[i]:Enable()

		defencemenpai_kj[i]:SetText("")
		defencemenpai_kj[i]:ResetList()
		defencemenpai_kj[i]:Enable()
	end


	local nAttackMenPai1 = GetAttackMenPai1()
	local nDefenceMenPai1 = GetDefenceMenPai1()
	local nAttackMenPai2 = GetAttackMenPai2()
	local nDefenceMenPai2 = GetDefenceMenPai2()
	local nAttackMenPai3 = GetAttackMenPai3()
	local nDefenceMenPai3 = GetDefenceMenPai3()

	local nAttackMenPaiArray = {nAttackMenPai1,nAttackMenPai2,nAttackMenPai3}
	local nDefenceMenPaiArray = {nDefenceMenPai1,nDefenceMenPai2,nDefenceMenPai3}
	local nDfenceMenPaiXDD1 = GetDefenceMenPaiXDD1()
	local nAttackMenPaiXDD1 = GetAttackMenPaiXDD1()
	local nDfenceMenPaiXDD2 = GetDefenceMenPaiXDD2()
	local nAttackMenPaiXDD2 = GetAttackMenPaiXDD2()
	local nDfenceMenPaiXDD3 = GetDefenceMenPaiXDD3()
	local nAttackMenPaiXDD3 = GetAttackMenPaiXDD3()

	local nattack_PeakAllocation_atkmp = {}
	local ndefence_PeakAllocation_atkmp = {}
	for i = 1, 3, 1 do
		nattack_PeakAllocation_atkmp[i] = _G["Peak_Learn_AllocationPoint_AttackMenpai"..i]:GetText()
		ndefence_PeakAllocation_atkmp[i] = _G["Peak_Learn_AllocationPoint_DefenceMenpai"..i]:GetText()
	end
	local nattack_PeakAllocation_atkmp = {Peak_Learn_AllocationPoint_AttackMenpai1,Peak_Learn_AllocationPoint_AttackMenpai2,Peak_Learn_AllocationPoint_AttackMenpai3}
	local ndefence_PeakAllocation_atkmp = {Peak_Learn_AllocationPoint_DefenceMenpai1,Peak_Learn_AllocationPoint_DefenceMenpai2,Peak_Learn_AllocationPoint_DefenceMenpai3}
	for i=1, table.getn(g_menpai) do
		
		local bHaveAttack =false
		local bHaveDefence =false
		--这个门派已经点选过了
		for j = 1, 3, 1 do
			if nAttackMenPaiArray[j] == i then
				bHaveAttack = true
			end

			if nDefenceMenPaiArray[j] == i then
				bHaveDefence = true
			end
		end

		if bHaveAttack == false then
			for j = 1, 3, 1 do
				attackmenpai_kj[j]:ComboBoxAddItem(g_menpai[i].Text, i)
			end		
		end

		if bHaveDefence == false then
			for j = 1, 3, 1 do
				defencemenpai_kj[j]:ComboBoxAddItem(g_menpai[i].Text, i)
			end		
		end
	end
		
	g_CurRemain_Attack_Point = 0 
	g_CurRemain_Defence_Point = 0 
	g_Attack_1_Point = 0
	g_Attack_2_Point = 0
	g_Attack_3_Point = 0

	g_Defence_1_Point = 0
	g_Defence_2_Point = 0
	g_Defence_3_Point = 0


	for i = 1, 3, 1 do
		_G["Peak_Learn_AllocationPoint_Attack_Addition"..i]:Disable();
		_G["Peak_Learn_AllocationPoint_Attack_Decrease"..i]:Disable();

		_G["Peak_Learn_AllocationPoint_Defence_Addition"..i]:Disable();
		_G["Peak_Learn_AllocationPoint_Defence_Decrease"..i]:Disable();
	end


	-- 剩余点数
	g_RemainPoint_Attack_Point = GetDFengAttackXDD();
	g_RemainPoint_Attack_Point = 	g_RemainPoint_Attack_Point - nAttackMenPaiXDD1 - nAttackMenPaiXDD2 - nAttackMenPaiXDD3
	if g_RemainPoint_Attack_Point < 0 then
		g_RemainPoint_Attack_Point = 0
	end
	Peak_Learn_DealLevel(g_RemainPoint_Attack_Point,1)
	g_CurRemain_Attack_Point = 	g_RemainPoint_Attack_Point
	if  g_CurRemain_Attack_Point < 0 then
		g_CurRemain_Attack_Point = 0
	end

	g_RemainPoint_Defence_Point = GetDFengDefenceXDD();

	g_RemainPoint_Defence_Point = g_RemainPoint_Defence_Point - nDfenceMenPaiXDD1 - nDfenceMenPaiXDD2 - nDfenceMenPaiXDD3
	
	Peak_Learn_DealLevel(g_RemainPoint_Defence_Point,0)
	g_CurRemain_Defence_Point = g_RemainPoint_Defence_Point 	
	if  g_CurRemain_Defence_Point < 0 then
		g_CurRemain_Defence_Point = 0
	end

	for i = 1, 3, 1 do
		if nAttackMenPaiArray[i] >0 and nAttackMenPaiArray[i] <= table.getn(g_menpai) then
			attackmenpai_kj[i]:SetText(g_menpai[nAttackMenPaiArray[i]].Text)	
			attackmenpai_kj[i]:Disable()
		end
	end
	for i = 1, 3, 1 do
		if nDefenceMenPaiArray[i] >0 and nDefenceMenPaiArray[i] <= table.getn(g_menpai) then
			defencemenpai_kj[i]:SetText(g_menpai[nDefenceMenPaiArray[i]].Text)	
			defencemenpai_kj[i]:Disable()
		end
	end


	if( g_CurRemain_Attack_Point > 0) then
		local strAttackMenPai1 = Peak_Learn_AllocationPoint_AttackMenpai1:GetText();
		local strAttackMenPai2 = Peak_Learn_AllocationPoint_AttackMenpai2:GetText();
		local strAttackMenPai3 = Peak_Learn_AllocationPoint_AttackMenpai3:GetText();

		local nAttackMenPai1_linshi = {}
		nAttackMenPai1_linshi[1] = Peak_Learn_getMenPaiID(strAttackMenPai1)
		nAttackMenPai1_linshi[2] = Peak_Learn_getMenPaiID(strAttackMenPai2)
		nAttackMenPai1_linshi[3] = Peak_Learn_getMenPaiID(strAttackMenPai3)

		for i = 1, 3, 1 do
			if nAttackMenPai1_linshi[i] ~= -1 then
				_G["Peak_Learn_AllocationPoint_Attack_Addition"..i]:Enable();
			end
		end	
	end

	if(g_CurRemain_Defence_Point > 0) then
		local strDefenceMenPai1 = Peak_Learn_AllocationPoint_DefenceMenpai1:GetText();
		local strDefenceMenPai2 = Peak_Learn_AllocationPoint_DefenceMenpai2:GetText();
		local strDefenceMenPai3 = Peak_Learn_AllocationPoint_DefenceMenpai3:GetText();

		local nDefenceMenPai1_linshi = {}
		nDefenceMenPai1_linshi[1] = Peak_Learn_getMenPaiID(strDefenceMenPai1)
		nDefenceMenPai1_linshi[2] = Peak_Learn_getMenPaiID(strDefenceMenPai2)
		nDefenceMenPai1_linshi[3] = Peak_Learn_getMenPaiID(strDefenceMenPai3)
		for i = 1, 3, 1 do
			if nDefenceMenPai1_linshi[i] ~= -1 then
				_G["Peak_Learn_AllocationPoint_Defence_Addition"..i]:Enable();
			end
		end		
	end


	Peak_Learn_AllocationPoint_Attack1:SetText( tostring( nAttackMenPaiXDD1 ) );
	Peak_Learn_AllocationPoint_Attack2:SetText( tostring( nAttackMenPaiXDD2  ) );
	Peak_Learn_AllocationPoint_Attack3:SetText( tostring( nAttackMenPaiXDD3  ) );
	Peak_Learn_AllocationPoint_Defence1:SetText( tostring( nDfenceMenPaiXDD1 ) );
	Peak_Learn_AllocationPoint_Defence2:SetText( tostring( nDfenceMenPaiXDD2 ) );
	Peak_Learn_AllocationPoint_Defence3:SetText( tostring( nDfenceMenPaiXDD3 ) );

	Peak_Learn_SetAcceptButtonState()


end

function Peak_Learn_ResetPos()
	Peak_Learn_Frame:SetProperty("UnifiedPosition", g_Peak_Learn_Frame_UnifiedPosition)
end

function Peak_Learn_OnHiden()
	Peak_Learn_Close()
end

function Peak_Learn_AllocationPoint_AttackMenpaiChanged(index)

	index = index + 1
	local nSelName_single1, nSelID_single1 = Peak_Learn_AllocationPoint_AttackMenpai1:GetCurrentSelect();
	local nSelName_single2, nSelID_single2 = Peak_Learn_AllocationPoint_AttackMenpai2:GetCurrentSelect();
	local nSelName_single3, nSelID_single3 = Peak_Learn_AllocationPoint_AttackMenpai3:GetCurrentSelect();

	local nSelName = {nSelName_single1,nSelName_single2,nSelName_single3}
	local nSelID = {nSelID_single1,nSelID_single2,nSelID_single3}

	if index < 1 or index > 3 then
		return 
	end

	if nSelID[index] <= 0 then
		PushDebugMessage("请先选择门派")
		return
	end

	local attackmenpai = _G["Peak_Learn_AllocationPoint_AttackMenpai"..index]

	local nAttackMenPai1 = GetAttackMenPai1()
	local nAttackMenPai2 = GetAttackMenPai2()
	local nAttackMenPai3 = GetAttackMenPai3()
	
	local nmenpai = {nAttackMenPai1,nAttackMenPai2,nAttackMenPai3}

	local textAttackMenpai1 = Peak_Learn_AllocationPoint_AttackMenpai1:GetText()
	local textAttackMenpai2 = Peak_Learn_AllocationPoint_AttackMenpai2:GetText()
	local textAttackMenpai3 = Peak_Learn_AllocationPoint_AttackMenpai3:GetText()
    local text = {textAttackMenpai1,textAttackMenpai2,textAttackMenpai3}

	--恢复成以前的或者设置成""
	for i = 1, 3, 1 do
		for j = 1, 3, 1 do
			local setid_i = text[i]
			local setid_j = text[j]
			if i ~= j then
				if setid_i ~= "" and setid_j ~= "" and setid_i == setid_j then
					PushDebugMessage("您已经选择此门派，不可重复选择。")
					if nmenpai[index] > 0 then
						attackmenpai:SetText(g_menpai[nmenpai[index]].Text)
					else
						attackmenpai:SetText("")
					end
					return 
				end			
			end
		end
	end

	attackmenpai:SetText(g_menpai[nSelID[index]].Text)	

	local attack_Addition = _G["Peak_Learn_AllocationPoint_Attack_Addition"..index]

	if g_CurRemain_Attack_Point > 0 then
		attack_Addition:Enable();
	end		
	
	Peak_Learn_SetAcceptButtonState();

end

function Peak_Learn_AllocationPoint_DefenceMenpaiChanged(index)

	index = index + 1

	local nSelName_single1, nSelID_single1 = Peak_Learn_AllocationPoint_DefenceMenpai1:GetCurrentSelect();
	local nSelName_single2, nSelID_single2 = Peak_Learn_AllocationPoint_DefenceMenpai2:GetCurrentSelect();
	local nSelName_single3, nSelID_single3 = Peak_Learn_AllocationPoint_DefenceMenpai3:GetCurrentSelect();

	local nSelName = {nSelName_single1,nSelName_single2,nSelName_single3}
	local nSelID = {nSelID_single1,nSelID_single2,nSelID_single3}

	if index < 1 or index > 3 then
		return 
	end

	local Defencemenpai = _G["Peak_Learn_AllocationPoint_DefenceMenpai"..index]
	if nSelID[index] <= 0 then
		PushDebugMessage("请先选择门派")
		return
	end

	local text = {}
	local nDefenceMenPai1 = GetDefenceMenPai1()
	local nDefenceMenPai2 = GetDefenceMenPai2()
	local nDefenceMenPai3 = GetDefenceMenPai3()
	
	local nmenpai = {nDefenceMenPai1,nDefenceMenPai2,nDefenceMenPai3}
	local textDefenceMenpai1 = Peak_Learn_AllocationPoint_DefenceMenpai1:GetText()
	local textDefenceMenpai2 = Peak_Learn_AllocationPoint_DefenceMenpai2:GetText()
	local textDefenceMenpai3 = Peak_Learn_AllocationPoint_DefenceMenpai3:GetText()
    local text = {textDefenceMenpai1,textDefenceMenpai2,textDefenceMenpai3}

	for i = 1, 3, 1 do
		for j = 1, 3, 1 do
			local setid_i = text[i]
			local setid_j = text[j]
			if i ~= j then
				if setid_i ~= "" and setid_j ~= "" and setid_i == setid_j then
					PushDebugMessage("您已经选择此门派，不可重复选择。")
					if nmenpai[index] > 0 then
						Defencemenpai:SetText(g_menpai[nmenpai[index]].Text)
					else
						Defencemenpai:SetText("")
					end
					return 
				end			
			end
		end
	end
	
	Defencemenpai:SetText(g_menpai[nSelID[index]].Text)	
	local defence_Addition = _G["Peak_Learn_AllocationPoint_Defence_Addition"..index]

	if g_CurRemain_Defence_Point > 0 then
		defence_Addition:Enable();
	end

	Peak_Learn_SetAcceptButtonState();

end
--***************************************************
-- 清空鼠标长按标记
--***************************************************
function Peak_Learn_AutoClick_Clear(id)
	id = tonumber(id)
	if (id == g_AutoClick_BtnFlag) then
		g_AutoClick_BtnFlag = -1
	end
end
--***************************************************
-- 设置定时器
--    设置标记说明鼠标已经按下
--***************************************************
function Peak_Learn_AutoClick_SetTimer(id)
	id = tonumber(id)
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = id
end
--***************************************************
-- 鼠标左键松开操作
--    注意这里其实是代替 Click, 所以需要执行一次 Click 操作
--***************************************************
function Peak_Learn_AutoClick_LButtonUp(id)
	id = tonumber(id)
	Peak_Learn_AutoClick_Clear(id)
	g_AutoClick_FunList[id]()
end
-- 显示当前的潜能
function Peak_Learn_ShowCurAttackXDDRemainPoint()
	Peak_Learn_DealLevel(g_CurRemain_Attack_Point,1)
end

-- 显示当前的防御点
function Peak_Learn_ShowCurDefenceXDDRemainPoint()
	Peak_Learn_DealLevel(g_CurRemain_Defence_Point,0)
end
---------------------------------------------------------------------------------
--
-- 禁止, 打开申请 心得点的按钮状态
--
function Peak_Learn_SetAcceptButtonState()

	g_RemainPoint_Attack_Point = GetDFengAttackXDD();
	g_RemainPoint_Defence_Point = GetDFengDefenceXDD();

	local nOld_AttackMenPai1 = GetAttackMenPai1()
	local nOld_DefenceMenPai1 = GetDefenceMenPai1()
	local nOld_AttackMenPai2 = GetAttackMenPai2()
	local nOld_DefenceMenPai2 = GetDefenceMenPai2()
	local nOld_AttackMenPai3 = GetAttackMenPai3()
	local nOld_DefenceMenPai3 = GetDefenceMenPai3()

	local nOld_DfenceMenPaiXDD1 = GetDefenceMenPaiXDD1()
	local nOld_AttackMenPaiXDD1 = GetAttackMenPaiXDD1()
	local nOld_DfenceMenPaiXDD2 = GetDefenceMenPaiXDD2()
	local nOld_AttackMenPaiXDD2 = GetAttackMenPaiXDD2()
	local nOld_DfenceMenPaiXDD3 = GetDefenceMenPaiXDD3()
	local nOld_AttackMenPaiXDD3 = GetAttackMenPaiXDD3()

	local strAttackMenPai1 = Peak_Learn_AllocationPoint_AttackMenpai1:GetText();
	local strDefenceMenPai1 = Peak_Learn_AllocationPoint_DefenceMenpai1:GetText();
	local strAttackMenPai2 = Peak_Learn_AllocationPoint_AttackMenpai2:GetText();
	local strDefenceMenPai2 = Peak_Learn_AllocationPoint_DefenceMenpai2:GetText();
	local strAttackMenPai3 = Peak_Learn_AllocationPoint_AttackMenpai3:GetText();
	local strDefenceMenPai3 = Peak_Learn_AllocationPoint_DefenceMenpai3:GetText();

	local nAttackMenPai1 = Peak_Learn_getMenPaiID(strAttackMenPai1)
	local nDefenceMenPai1 = Peak_Learn_getMenPaiID(strDefenceMenPai1)
	local nAttackMenPai2 = Peak_Learn_getMenPaiID(strAttackMenPai2)
	local nDefenceMenPai2 = Peak_Learn_getMenPaiID(strDefenceMenPai2)
	local nAttackMenPai3 = Peak_Learn_getMenPaiID(strAttackMenPai3)
	local nDefenceMenPai3 = Peak_Learn_getMenPaiID(strDefenceMenPai3)

	local nAttackMenPaiXDD1 = Peak_Learn_AllocationPoint_Attack1:GetText()
	local nDefenceMenPaiXDD1 = Peak_Learn_AllocationPoint_Defence1:GetText()
	local nAttackMenPaiXDD2 = Peak_Learn_AllocationPoint_Attack2:GetText()
	local nDefenceMenPaiXDD2 = Peak_Learn_AllocationPoint_Defence2:GetText()
	local nAttackMenPaiXDD3 = Peak_Learn_AllocationPoint_Attack3:GetText()
	local nDefenceMenPaiXDD3 = Peak_Learn_AllocationPoint_Defence3:GetText()

    local bcheck = 0


	if tonumber(nOld_AttackMenPaiXDD1) == tonumber(nAttackMenPaiXDD1) and tonumber(nOld_DfenceMenPaiXDD1) == tonumber(nDefenceMenPaiXDD1) and
	tonumber(nOld_AttackMenPaiXDD2) == tonumber(nAttackMenPaiXDD2) and tonumber(nOld_DfenceMenPaiXDD2) == tonumber(nDefenceMenPaiXDD2) and 
	tonumber(nOld_AttackMenPaiXDD3) == tonumber(nAttackMenPaiXDD3) and tonumber(nOld_DfenceMenPaiXDD3) == tonumber(nDefenceMenPaiXDD3) then
		bcheck = 0  --没什么变化
	else
        bcheck = 1 --变化了
	end 

	if bcheck == 0  then
		if  nOld_AttackMenPai1 == 0 and  nAttackMenPai1 == -1 then
			bcheck = 0 --没什么变化
		else
			if nOld_AttackMenPai1 == nAttackMenPai1 then
				bcheck = 0 --没什么变化
			else
				bcheck = 1 --变化了
			end
		end		
	end

	if bcheck == 0 then
		if  nOld_DefenceMenPai1 == 0 and  nDefenceMenPai1 == -1 then
			bcheck = 0 --没什么变化
		else
			if nOld_DefenceMenPai1 == nDefenceMenPai1 then
				bcheck = 0 --没什么变化
			else
				bcheck = 1 --变化了
			end
		end
			
	end

	if bcheck == 0 then
		if nOld_AttackMenPai2 == 0 and  nAttackMenPai2 == -1 then
			bcheck = 0 --没什么变化
		else
			if nOld_AttackMenPai2 == nAttackMenPai2 then
				bcheck = 0 --没什么变化
			else
				bcheck = 1 --变化了
			end
		end
	end

	if bcheck == 0 then
		if nOld_DefenceMenPai2 == 0 and  nDefenceMenPai2 == -1 then
			bcheck = 0 --没什么变化
		else
			if nOld_DefenceMenPai2 == nDefenceMenPai2 then
				bcheck = 0 --没什么变化
			else
				bcheck = 1 --变化了
			end
		end		
	end

	if bcheck == 0 then
		if nOld_AttackMenPai3 == 0 and  nAttackMenPai3 == -1 then
			bcheck = 0 --没什么变化
		else
			if nOld_AttackMenPai3 == nAttackMenPai3 then
				bcheck = 0 --没什么变化
			else
				bcheck = 1 --变化了
			end
		end
	end

	if bcheck == 0 then
		if  nOld_DefenceMenPai3 == 0 and  nDefenceMenPai3 == -1 then
			bcheck = 0 --没什么变化
		else
			if nOld_DefenceMenPai3 == nDefenceMenPai3 then
				bcheck = 0 --没什么变化
			else
				bcheck = 1 --变化了
			end
		end
	end

	if (bcheck == 0) then
		Peak_Learn_OK:Disable();
	else
		Peak_Learn_OK:Enable();
	end;

end
---------------------------------------------------------------------------------
--
-- 显示进攻武学心得点1 text
--
function Peak_Learn_ShowAttackXDD_1()
	Peak_Learn_AllocationPoint_Attack1:SetText( tostring( g_Attack_1_Point + GetAttackMenPaiXDD1() ) );
end
---------------------------------------------------------------------------------
--
-- 显示进攻武学心得点2 text
--
function Peak_Learn_ShowAttackXDD_2()
	Peak_Learn_AllocationPoint_Attack2:SetText( tostring( g_Attack_2_Point + GetAttackMenPaiXDD2() ) );
end
---------------------------------------------------------------------------------
--
-- 显示进攻武学心得点3 text
--
function Peak_Learn_ShowAttackXDD_3()
	Peak_Learn_AllocationPoint_Attack3:SetText( tostring( g_Attack_3_Point +  GetAttackMenPaiXDD3() ) );
end
---------------------------------------------------------------------------------
--
-- 显示防御武学心得点1 text
--
function Peak_Learn_ShowDefenceXDD_1()
	Peak_Learn_AllocationPoint_Defence1:SetText( tostring( g_Defence_1_Point +  GetDefenceMenPaiXDD1()) );
end
---------------------------------------------------------------------------------
--
-- 显示防御武学心得点2 text
--
function Peak_Learn_ShowDefenceXDD_2()
	Peak_Learn_AllocationPoint_Defence2:SetText( tostring( g_Defence_2_Point + GetDefenceMenPaiXDD2()) );
end
---------------------------------------------------------------------------------
--
-- 显示防御武学心得点3 text
--
function Peak_Learn_ShowDefenceXDD_3()
	Peak_Learn_AllocationPoint_Defence3:SetText( tostring( g_Defence_3_Point + GetDefenceMenPaiXDD3()) );
end

function Peak_Learn_Dec1_Attack_XDD_1_Click()

	if (g_Attack_1_Point > 0) then
		g_CurRemain_Attack_Point = g_CurRemain_Attack_Point + 1;
		if(g_CurRemain_Attack_Point > 0) then
			Peak_Learn_EanblePointAddButtionAttack();
		end;

		g_Attack_1_Point = g_Attack_1_Point - 1;
	end

	if(g_Attack_1_Point <= 0) then
		g_Attack_1_Point = 0;
		Peak_Learn_AllocationPoint_Attack_Decrease1:Disable();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurAttackXDDRemainPoint();

	-- 显示 进攻 武学心得点 
	Peak_Learn_ShowAttackXDD_1();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end

function Peak_Learn_Dec2_Attack_XDD_2_Click()

	if (g_Attack_2_Point > 0) then
		g_CurRemain_Attack_Point = g_CurRemain_Attack_Point + 1;
		if (g_CurRemain_Attack_Point > 0) then
			Peak_Learn_EanblePointAddButtionAttack();
		end

		g_Attack_2_Point = g_Attack_2_Point - 1;
	end

	if(g_Attack_2_Point <= 0) then
		g_Attack_2_Point = 0;
		Peak_Learn_AllocationPoint_Attack_Decrease2:Disable();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurAttackXDDRemainPoint();

	-- 显示进攻武学心得点2
	Peak_Learn_ShowAttackXDD_2();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end

function Peak_Learn_Dec3_Attack_XDD_3_Click()

	if (g_Attack_3_Point > 0) then
		g_CurRemain_Attack_Point = g_CurRemain_Attack_Point + 1;
		if(g_CurRemain_Attack_Point > 0) then
			Peak_Learn_EanblePointAddButtionAttack();
		end;

		g_Attack_3_Point = g_Attack_3_Point - 1;
	end

	if(g_Attack_3_Point <= 0) then
		g_Attack_3_Point = 0;
		Peak_Learn_AllocationPoint_Attack_Decrease3:Disable();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurAttackXDDRemainPoint();

	-- 显示进攻武学心得点3
	Peak_Learn_ShowAttackXDD_3();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end
-- 增加进攻心得点点数按钮 1
function Peak_Learn_Add_Attack_XDD_1_Click()

	if (g_CurRemain_Attack_Point > 0) then
		g_Attack_1_Point = g_Attack_1_Point + 1;
		if(g_Attack_1_Point > 0) then
			Peak_Learn_AllocationPoint_Attack_Decrease1:Enable();
		end

		g_CurRemain_Attack_Point = g_CurRemain_Attack_Point - 1;
	end

	if(g_CurRemain_Attack_Point <= 0) then
		g_CurRemain_Attack_Point = 0;
		Peak_Learn_DisablePointAddButtionAttack();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurAttackXDDRemainPoint();

	-- 显示进攻武学1心得点
	Peak_Learn_ShowAttackXDD_1();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();


end
-- 增加进攻心得点点数按钮 2
function Peak_Learn_Add_Attack_XDD_2_Click()

	if (g_CurRemain_Attack_Point > 0) then
		g_Attack_2_Point = g_Attack_2_Point + 1;
		if(g_Attack_2_Point > 0) then
			Peak_Learn_AllocationPoint_Attack_Decrease2:Enable();
		end

		g_CurRemain_Attack_Point = g_CurRemain_Attack_Point - 1;
	end

	if(g_CurRemain_Attack_Point <= 0) then
		g_CurRemain_Attack_Point = 0;
		Peak_Learn_DisablePointAddButtionAttack();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurAttackXDDRemainPoint();

	-- 显示进攻武学2心得点
	Peak_Learn_ShowAttackXDD_2();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end
-- 增加进攻心得点点数按钮 3
function Peak_Learn_Add_Attack_XDD_3_Click()

	if (g_CurRemain_Attack_Point > 0) then
		g_Attack_3_Point = g_Attack_3_Point + 1;
		if(g_Attack_3_Point > 0) then
			Peak_Learn_AllocationPoint_Attack_Decrease3:Enable();
		end

		g_CurRemain_Attack_Point = g_CurRemain_Attack_Point - 1;
	end

	if(g_CurRemain_Attack_Point <= 0) then
		g_CurRemain_Attack_Point = 0;
		Peak_Learn_DisablePointAddButtionAttack();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurAttackXDDRemainPoint();

	-- 显示进攻武学3心得点
	Peak_Learn_ShowAttackXDD_3();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end
--------------------------------------------------------------------------------
--
-- 禁止所有的进攻点数增加按钮
--
function Peak_Learn_DisablePointAddButtionAttack()
	Peak_Learn_AllocationPoint_Attack_Addition1:Disable();
	Peak_Learn_AllocationPoint_Attack_Addition2:Disable();
	Peak_Learn_AllocationPoint_Attack_Addition3:Disable();
end
--------------------------------------------------------------------------------
--
-- 打开所有的进攻点数增加按钮
--
function Peak_Learn_EanblePointAddButtionAttack()

	local strAttackMenPai1 = Peak_Learn_AllocationPoint_AttackMenpai1:GetText();
	local strAttackMenPai2 = Peak_Learn_AllocationPoint_AttackMenpai2:GetText();
	local strAttackMenPai3 = Peak_Learn_AllocationPoint_AttackMenpai3:GetText();

	local nAttackMenPai1 = Peak_Learn_getMenPaiID(strAttackMenPai1)
	local nAttackMenPai2 = Peak_Learn_getMenPaiID(strAttackMenPai2)
	local nAttackMenPai3 = Peak_Learn_getMenPaiID(strAttackMenPai3)
	if nAttackMenPai1 ~= -1 then
		Peak_Learn_AllocationPoint_Attack_Addition1:Enable();
	end
	if nAttackMenPai2 ~= -1 then
		Peak_Learn_AllocationPoint_Attack_Addition2:Enable();
	end
	if nAttackMenPai3 ~= -1 then
		Peak_Learn_AllocationPoint_Attack_Addition3:Enable();
	end		
end
--------------------------------------------------------------------------------
--
-- 禁止所有的进攻点数增加按钮
--
function Peak_Learn_DisablePointAddButtionDefence()
	Peak_Learn_AllocationPoint_Defence_Addition1:Disable();
	Peak_Learn_AllocationPoint_Defence_Addition2:Disable();
	Peak_Learn_AllocationPoint_Defence_Addition3:Disable();
end
--------------------------------------------------------------------------------
--
-- 打开所有的进攻点数增加按钮
--
function Peak_Learn_EanblePointAddButtionDefence()

	local strDefenceMenPai1 = Peak_Learn_AllocationPoint_DefenceMenpai1:GetText();
	local strDefenceMenPai2 = Peak_Learn_AllocationPoint_DefenceMenpai2:GetText();
	local strDefenceMenPai3 = Peak_Learn_AllocationPoint_DefenceMenpai3:GetText();

	local nDefenceMenPai1 = Peak_Learn_getMenPaiID(strDefenceMenPai1)
	local nDefenceMenPai2 = Peak_Learn_getMenPaiID(strDefenceMenPai2)
	local nDefenceMenPai3 = Peak_Learn_getMenPaiID(strDefenceMenPai3)

	if nDefenceMenPai1 ~= -1 then
		Peak_Learn_AllocationPoint_Defence_Addition1:Enable();
	end
	if nDefenceMenPai2 ~= -1 then
		Peak_Learn_AllocationPoint_Defence_Addition2:Enable();
	end	
	if nDefenceMenPai3 ~= -1 then
		Peak_Learn_AllocationPoint_Defence_Addition3:Enable();
	end	
end

function Peak_Learn_Dec1_Defence_XDD_1_Click()

	if (g_Defence_1_Point > 0) then
		g_CurRemain_Defence_Point = g_CurRemain_Defence_Point + 1;
		if(g_CurRemain_Defence_Point > 0) then
			Peak_Learn_EanblePointAddButtionDefence();
		end;

		g_Defence_1_Point = g_Defence_1_Point - 1;
	end

	if(g_Defence_1_Point <= 0) then
		g_Defence_1_Point = 0;
		Peak_Learn_AllocationPoint_Defence_Decrease1:Disable();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurDefenceXDDRemainPoint();

	-- 显示防御心得点1
	Peak_Learn_ShowDefenceXDD_1();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end

function Peak_Learn_Dec2_Defence_XDD_2_Click()

	if (g_Defence_2_Point > 0) then
		g_CurRemain_Defence_Point = g_CurRemain_Defence_Point + 1;
		if (g_CurRemain_Defence_Point > 0) then
			Peak_Learn_EanblePointAddButtionDefence();
		end

		g_Defence_2_Point = g_Defence_2_Point - 1;
	end

	if(g_Defence_2_Point <= 0) then
		g_Defence_2_Point = 0;
		Peak_Learn_AllocationPoint_Defence_Decrease2:Disable();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurDefenceXDDRemainPoint();

	-- 显示防御心得点2
	Peak_Learn_ShowDefenceXDD_2();


	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end

function Peak_Learn_Dec3_Defence_XDD_3_Click()

	if (g_Defence_3_Point > 0) then
		g_CurRemain_Defence_Point = g_CurRemain_Defence_Point + 1;
		if ( g_CurRemain_Defence_Point > 0 ) then
			Peak_Learn_EanblePointAddButtionDefence();
		end;

		g_Defence_3_Point = g_Defence_3_Point - 1;
	end

	if(g_Defence_3_Point <= 0) then
		g_Defence_3_Point = 0;
		Peak_Learn_AllocationPoint_Defence_Decrease3:Disable();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurDefenceXDDRemainPoint();

	-- 显示防御心得点3
	Peak_Learn_ShowDefenceXDD_3();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end
-- 增加进攻心得点点数按钮 1
function Peak_Learn_Add_Defence_XDD_1_Click()

	if (g_CurRemain_Defence_Point > 0) then
		g_Defence_1_Point = g_Defence_1_Point + 1;
		if(g_Defence_1_Point > 0) then
			Peak_Learn_AllocationPoint_Defence_Decrease1:Enable();
		end

		g_CurRemain_Defence_Point = g_CurRemain_Defence_Point - 1;
	end

	if(g_CurRemain_Defence_Point <= 0) then
		g_CurRemain_Defence_Point = 0;
		Peak_Learn_DisablePointAddButtionDefence();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurDefenceXDDRemainPoint();

	-- 显示防御武学1心得点
	Peak_Learn_ShowDefenceXDD_1();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end
-- 增加进攻心得点点数按钮 2
function Peak_Learn_Add_Defence_XDD_2_Click()

	if (g_CurRemain_Defence_Point > 0) then
		g_Defence_2_Point = g_Defence_2_Point + 1;
		if(g_Defence_2_Point > 0) then
			Peak_Learn_AllocationPoint_Defence_Decrease2:Enable();
		end

		g_CurRemain_Defence_Point = g_CurRemain_Defence_Point - 1;
	end

	if(g_CurRemain_Defence_Point <= 0) then
		g_CurRemain_Defence_Point = 0;
		Peak_Learn_DisablePointAddButtionDefence();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurDefenceXDDRemainPoint();

	-- 显示防御武学2心得点
	Peak_Learn_ShowDefenceXDD_2();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end
-- 增加进攻心得点点数按钮 3
function Peak_Learn_Add_Defence_XDD_3_Click()

	if (g_CurRemain_Defence_Point > 0) then
		g_Defence_3_Point = g_Defence_3_Point + 1;
		if(g_Defence_3_Point > 0) then
			Peak_Learn_AllocationPoint_Defence_Decrease3:Enable();
		end

		g_CurRemain_Defence_Point = g_CurRemain_Defence_Point - 1;
	end

	if(g_CurRemain_Defence_Point <= 0) then
		g_CurRemain_Defence_Point = 0;
		Peak_Learn_DisablePointAddButtionDefence();
	end

	-- 显示当前剩余的点数
	Peak_Learn_ShowCurDefenceXDDRemainPoint();

	-- 显示防御武学3心得点
	Peak_Learn_ShowDefenceXDD_3();

	-- 设置剩余点数按钮状态 更新剩余武学心得点
	Peak_Learn_SetAcceptButtonState();

end


local nDFAttrName = {"外功攻击","外功防御","内功攻击","内功防御","体力","力量","灵气","定力","身法","攻击武决点","外功攻击","外功防御","内功攻击","内功防御","体力","力量","灵气","定力","身法","守御武决点"}
local nDFType = {19,22,26,29,44,42,43,45,46,104,19,22,26,29,44,42,43,45,46,105}
local nDFAttr = {36,36,36,36,2,2,2,2,1,2,36,36,36,36,2,2,2,2,1,2}
function GetDFengLevel()		--武境等级
	return DataPool:GetPlayerMission_DataRound(1020)
end

function GetDFengAttackXDD()	--剩余攻击点数
	local DFLv = GetDFengLevel()
	local LvList = {10,30,50,70,90,110,130,150,170,190}
	local Out = 0
	for i=1,10 do
		if  DFLv >= LvList[i] then
			Out = Out + 2
		end
	end
	return Out
end

function GetDFengDefenceXDD()	--剩余防御点数
	local DFLv = GetDFengLevel()
	local LvList = {20,40,60,80,100,120,140,160,180,200}
	local Out = 0
	for i=1,10 do
		if  DFLv >= LvList[i] then
			Out = Out + 2
		end
	end
	return Out
end

function GetAttackMenPai1()		--攻击门派类别1
	return GetAttackDefenceType(1,1)
end

function GetDefenceMenPai1()	--防御门派类别1
	return GetAttackDefenceType(1,2)
end

function GetAttackMenPaiXDD1()	--攻击门派点数1
	return GetAttackDefenceType(1,3)
end

function GetDefenceMenPaiXDD1()	--防御门派点数1
	return GetAttackDefenceType(1,4)
end

function GetAttackMenPai2()		--攻击门派类别2
	return GetAttackDefenceType(2,1)
end

function GetDefenceMenPai2()	--防御门派类别2
	return GetAttackDefenceType(2,2)
end

function GetAttackMenPaiXDD2()	--攻击门派点数2
	return GetAttackDefenceType(2,3)
end

function GetDefenceMenPaiXDD2()	--防御门派点数2
	return GetAttackDefenceType(2,4)
end

function GetAttackMenPai3()		--攻击门派类别3
	return GetAttackDefenceType(3,1)
end

function GetDefenceMenPai3()	--防御门派类别3
	return GetAttackDefenceType(3,2)
end

function GetAttackMenPaiXDD3()	--攻击门派点数3
	return GetAttackDefenceType(3,3)
end

function GetDefenceMenPaiXDD3()	--防御门派点数3
	return GetAttackDefenceType(3,4)
end

function GetAttackDefenceType(nType,nIndex)
	if nType < 1 or nType > 3 then
		return 0
	end
	if nIndex < 1 or nIndex > 4 then
		return 0
	end
	local MDInfo = {1021,1022,1023}
	local nData = DataPool:GetPlayerMission_DataRound(MDInfo[nType])
	local nMPID = {0,0,0,0}
	nMPID[1] = math.mod( nData, 100)
	nMPID[2] = math.mod( math.floor( nData /100 ) , 100)
	nMPID[3] = math.mod( math.floor( nData /10000 ) , 100)
	nMPID[4] = math.floor(nData / 1000000)
	return nMPID[nIndex]
end

function GetDFengLevelupTimes()	--本周剩余次数
	return math.mod(DataPool:GetPlayerMission_DataRound(1025),10)
end

function GetDFengZhuiGanInfo()	--追赶次数
	return 1,1
end

function GetDFengExtraLevelupTimes()--额外次数
	return 0
end

function GetDFengDFengAttrValueType(nLevle)
	if nLevle > 200 then
		return 0,0
	end
	if math.mod(nLevle,20) == 0 then
		return 1,105
	elseif math.mod(nLevle,10) == 0 then
		return 1,104
	end
	return 0,0
end

function GetDFengDFengAttrValueStr(nLevle)
	if nLevle > 200 then
		return 0,""
	end
	if nLevle >= 10 and math.mod(nLevle,10) == 0 then
		return 0,""
	end
	return 1,""
end

function GetDFengDFengAttrStr(nLevle)
	if nLevle < 1 or nLevle > 200 then
		return 0,""
	end
	if nLevle >= 10 and math.mod(nLevle,10) == 0 then
		return 0,""
	end
	return 1,nDFAttrName[math.mod(nLevle,20)]
end

function GetDFengDFengAttrValueINT(nLevle)
	return nDFAttr[math.mod(nLevle,20)]
end

function GetDFengDFengAttrEquipSpecialAttName(nLevle)
	return "",""
end

function GetDFengDFengAttrNextLevelStr()
	local DFLv = GetDFengLevel() + 1
	if DFLv == 0 or DFLv > 200 then
		return 0,""
	end

	if DFLv >= 10 and math.mod(DFLv,10) == 0 then
		return 0,""
	end
	return 1,nDFAttrName[math.mod(DFLv,20)].." +"..nDFAttr[math.mod(DFLv,20)]
end

function GetDFengDFengQNDValueINT(nLevle)
	if nLevle < 1 or nLevle > 200 then
		return 0
	end
	if nLevle >= 10 and math.mod(nLevle,10) == 0 then
		return 2
	end
	return nDFAttr[math.mod(nLevle,20)]
end

function GetDFengExp()			--当前经验
	return DataPool:GetPlayerMission_DataRound(1024)
end

function GetDFengNeedExp()		--所需经验
	local DFLv = GetDFengLevel()
	local nExpList = {20000000,40000000,70000000,100000000,150000000,200000000,250000000,250000000,250000000,250000000}
	if DFLv == 200 then
		return nExpList[math.floor(DFLv/20)]
	end
	return nExpList[math.floor(DFLv/20) + 1]
end
--***************************************************
-- 定时器回调函数
--    实现慢启动, 以后可以考虑加速(必要性不大)
--***************************************************
function Peak_Learn_AutoClick_Timer()
	if (g_AutoClick_BtnFlag ~= -1) then
		-- 第一次LButton后经过X个Timer才算开始, 也就是说是 g_AutoClickTimer_Step * X 的时候开始进行自动加, 这样为了防止本来要点击一下的结果点了好多下
		if (g_AutoClick_Going < 4) then
			g_AutoClick_Going = g_AutoClick_Going + 1

		else
			g_AutoClick_FunList[g_AutoClick_BtnFlag]()
		end
	end
end

function Peak_Learn_OK_Clicked()

	local strAttackMenPai1 = Peak_Learn_AllocationPoint_AttackMenpai1:GetText();
	local strDefenceMenPai1 = Peak_Learn_AllocationPoint_DefenceMenpai1:GetText();
	local strAttackMenPai2 = Peak_Learn_AllocationPoint_AttackMenpai2:GetText();
	local strDefenceMenPai2 = Peak_Learn_AllocationPoint_DefenceMenpai2:GetText();
	local strAttackMenPai3 = Peak_Learn_AllocationPoint_AttackMenpai3:GetText();
	local strDefenceMenPai3 = Peak_Learn_AllocationPoint_DefenceMenpai3:GetText();

	local nAttackMenPai1 = Peak_Learn_getMenPaiID(strAttackMenPai1)
	local nDefenceMenPai1 = Peak_Learn_getMenPaiID(strDefenceMenPai1)
	local nAttackMenPai2 = Peak_Learn_getMenPaiID(strAttackMenPai2)
	local nDefenceMenPai2 = Peak_Learn_getMenPaiID(strDefenceMenPai2)
	local nAttackMenPai3 = Peak_Learn_getMenPaiID(strAttackMenPai3)
	local nDefenceMenPai3 = Peak_Learn_getMenPaiID(strDefenceMenPai3)



	local nAttackMenPaiXDD1 = Peak_Learn_AllocationPoint_Attack1:GetText()
	local nDefenceMenPaiXDD1 = Peak_Learn_AllocationPoint_Defence1:GetText()
	local nAttackMenPaiXDD2 = Peak_Learn_AllocationPoint_Attack2:GetText()
	local nDefenceMenPaiXDD2 = Peak_Learn_AllocationPoint_Defence2:GetText()
	local nAttackMenPaiXDD3 = Peak_Learn_AllocationPoint_Attack3:GetText()
	local nDefenceMenPaiXDD3 = Peak_Learn_AllocationPoint_Defence3:GetText()

	nAttackMenPai1 = tonumber(nAttackMenPai1)
	nDefenceMenPai1 = tonumber(nDefenceMenPai1)
	nAttackMenPai2 = tonumber(nAttackMenPai2)
	nDefenceMenPai2 = tonumber(nDefenceMenPai2)
	nAttackMenPai3 = tonumber(nAttackMenPai3)
	nDefenceMenPai3 = tonumber(nDefenceMenPai3)

	nAttackMenPaiXDD1 = tonumber(nAttackMenPaiXDD1)
	if nAttackMenPaiXDD1 and tonumber(nAttackMenPaiXDD1) < 0  then
		nAttackMenPaiXDD1 = 0
	end
	nDefenceMenPaiXDD1 = tonumber(nDefenceMenPaiXDD1)
	if nDefenceMenPaiXDD1 and tonumber(nDefenceMenPaiXDD1) < 0  then
		nDefenceMenPaiXDD1 = 0
	end
	nAttackMenPaiXDD2 = tonumber(nAttackMenPaiXDD2)
	if nAttackMenPaiXDD2 and tonumber(nAttackMenPaiXDD2) < 0  then
		nAttackMenPaiXDD2 = 0
	end
	nDefenceMenPaiXDD2 = tonumber(nDefenceMenPaiXDD2)
	if nDefenceMenPaiXDD2 and tonumber(nDefenceMenPaiXDD2) < 0  then
		nDefenceMenPaiXDD2 = 0
	end
	nAttackMenPaiXDD3 = tonumber(nAttackMenPaiXDD3)
	if nAttackMenPaiXDD3 and tonumber(nAttackMenPaiXDD3) < 0  then
		nAttackMenPaiXDD3 = 0
	end
	nDefenceMenPaiXDD3 = tonumber(nDefenceMenPaiXDD3)
	if nDefenceMenPaiXDD3 and tonumber(nDefenceMenPaiXDD3) < 0  then
		nDefenceMenPaiXDD3 = 0
	end

	if nAttackMenPai1 == nil or nAttackMenPai1 == "" then
		nAttackMenPai1 = 0
	end
	if nDefenceMenPai1 == nil or nDefenceMenPai1 == "" then
		nDefenceMenPai1 = 0
	end
	if nAttackMenPai2 == nil or nAttackMenPai2 == "" then
		nAttackMenPai2 = 0
	end
	if nDefenceMenPai2 == nil or nDefenceMenPai2 == "" then
		nDefenceMenPai2 = 0
	end
	if nAttackMenPai3 == nil or nAttackMenPai3 == "" then
		nAttackMenPai3 = 0
	end
	if nDefenceMenPai3 == nil or nDefenceMenPai3 == "" then
		nDefenceMenPai3 = 0
	end

	if nAttackMenPaiXDD1 == nil or nAttackMenPaiXDD1 == "" then
		nAttackMenPaiXDD1 = 0
	end
	if nDefenceMenPaiXDD1 == nil or nDefenceMenPaiXDD1 == "" then
		nDefenceMenPaiXDD1 = 0
	end
	if nAttackMenPaiXDD2 == nil or nAttackMenPaiXDD2 == "" then
		nAttackMenPaiXDD2 = 0
	end
	if nDefenceMenPaiXDD2 == nil or nDefenceMenPaiXDD2 == "" then
		nDefenceMenPaiXDD2 = 0
	end
	if nAttackMenPaiXDD3 == nil or nAttackMenPaiXDD3 == "" then
		nAttackMenPaiXDD3 = 0
	end
	if nDefenceMenPaiXDD3 == nil or nDefenceMenPaiXDD3 == "" then
		nDefenceMenPaiXDD3 = 0
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SetDfengAttackDefence")
		Set_XSCRIPT_ScriptID(502161)
		Set_XSCRIPT_Parameter(0,g_PeakLearn_targetId)
		Set_XSCRIPT_Parameter(1,nDefenceMenPaiXDD1 * 1000000 + nAttackMenPaiXDD1 * 10000 + nDefenceMenPai1 * 100 + nAttackMenPai1)
		Set_XSCRIPT_Parameter(2,nDefenceMenPaiXDD2 * 1000000 + nAttackMenPaiXDD2 * 10000 + nDefenceMenPai2 * 100 + nAttackMenPai2)
		Set_XSCRIPT_Parameter(3,nDefenceMenPaiXDD3 * 1000000 + nAttackMenPaiXDD3 * 10000 + nDefenceMenPai3 * 100 + nAttackMenPai3)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()

end

function Peak_Learn_Close()	
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1
	KillTimer("Peak_Learn_AutoClick_Timer()")
	this:Hide();
end

function Peak_Learn_getMenPaiID(menpai)

	for i=1, table.getn(g_menpai) do
		if g_menpai[i].Text == menpai then
			return i
		end
	end
	return 0
end

function Peak_Learn_Recharge_Clicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("CleanDfengAttackDefence")
		Set_XSCRIPT_ScriptID(502161)
		Set_XSCRIPT_Parameter(0,g_PeakLearn_targetId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	
end

function Peak_Learn_getDigits(param1)
	local n = math.abs(param1)
	local ones = math.mod( param1, 10)
	local tens = math.floor( n /10 ) 
	tens =  math.mod( tens, 10)
	local hundreds = math.floor(n / 100) 
	hundreds =  math.mod( hundreds, 10)
	local thousands = math.floor(n / 1000) 
	thousands =  math.mod( thousands, 10)
	return ones,tens,hundreds,thousands
end
	
function Peak_Learn_getDigitLevel(param1)
	local n = math.abs(param1)
	if n < 10 then
		return 1
	elseif n < 100 then
		return 2
	elseif n < 1000 then
		return 3		
	elseif n < 10000 then
		return 4		
	end
	return -1
end

function Peak_Learn_DealLevel(param1,red)
	local num = Peak_Learn_getDigitLevel(param1)
	local Digits = {0,0,0,0}
	Digits[1],Digits[2],Digits[3],Digits[4] = Peak_Learn_getDigits(param1)
	local Peak_Learn_AllocationPoint_A = {}
	local Peak_Learn_AllocationPoint_D = {}
	local Peak_Learn_AllocationPoint_AttackMenpai_Point = {}
	local Peak_Learn_AllocationPoint_DefenceMenpai_Point = {}
	if num == -1 then
		num = 1 
		Digits[1] = 0
	end
	
	for i=1,4 do
		Peak_Learn_AllocationPoint_A[i] = _G[string.format("Peak_Learn_AllocationPoint_AttackMenpai_Point_%d",i)]
		Peak_Learn_AllocationPoint_D[i] = _G[string.format("Peak_Learn_AllocationPoint_DefenceMenpai_Point_%d",i)]
		Peak_Learn_AllocationPoint_A[i]:Hide()
		Peak_Learn_AllocationPoint_D[i]:Hide()
		if num == i then
			Peak_Learn_AllocationPoint_A[i]:Show()
			Peak_Learn_AllocationPoint_D[i]:Show()
		end
	end

	for i=1,num do
		Peak_Learn_AllocationPoint_AttackMenpai_Point[i] = _G[string.format("Peak_Learn_AllocationPoint_AttackMenpai_Point_%d_%d",num,i)]
		Peak_Learn_AllocationPoint_DefenceMenpai_Point[i] = _G[string.format("Peak_Learn_AllocationPoint_DefenceMenpai_Point_%d_%d",num,i)]
	end

	for i=0,num-1 do
		if red == 1 then
			Peak_Learn_AllocationPoint_AttackMenpai_Point[i+1]:SetProperty("Image",Peak_Learn_Red_Icon[Digits[num-i]+1]);
		else
			Peak_Learn_AllocationPoint_DefenceMenpai_Point[i+1]:SetProperty("Image",Peak_Learn_Blue_Icon[Digits[num-i]+1]);
		end
	end

end