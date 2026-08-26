
local ValentinesDay_GrandTotal_MainFrame_UnifiedPosition
local ValentinesDay_GrandTotal_NPC_ObjId
local ValentinesDay_GrandTotal_FinishTimes

local ValentinesDay_GrandTotal_ActionItems = {}
local ValentinesDay_GrandTotal_Animates = {}
local ValentinesDay_GrandTotal_Marks = {}

local ValentinesDay_GrandTotal_Reward = {
	[1] = {itemid = 20310168, itemcount=8, times = 8},--金蚕丝*8
	[2] = {itemid = 50313004, itemcount=1, times = 15},--红宝石3级
	[3] = {itemid = 20501003, itemcount=1, times = 25},--3级棉布
	[4] = {itemid = 20502003, itemcount=1, times = 40}	--3级秘银
}

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function ValentinesDay_GrandTotal_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
end

--=========================================================
-- 载入初始化
--=========================================================
function ValentinesDay_GrandTotal_OnLoad()

	ValentinesDay_GrandTotal_ActionItems[1] = ValentinesDay_GrandTotal_Page1_one
	ValentinesDay_GrandTotal_ActionItems[2] = ValentinesDay_GrandTotal_Page1_two
	ValentinesDay_GrandTotal_ActionItems[3] = ValentinesDay_GrandTotal_Page1_three
	ValentinesDay_GrandTotal_ActionItems[4] = ValentinesDay_GrandTotal_Page1_four

	ValentinesDay_GrandTotal_Animates[1] = ValentinesDay_GrandTotal_Page1_one_ButtonAnimate
	ValentinesDay_GrandTotal_Animates[2] = ValentinesDay_GrandTotal_Page1_two_ButtonAnimate
	ValentinesDay_GrandTotal_Animates[3] = ValentinesDay_GrandTotal_Page1_three_ButtonAnimate
	ValentinesDay_GrandTotal_Animates[4] = ValentinesDay_GrandTotal_Page1_four_ButtonAnimate

	ValentinesDay_GrandTotal_Marks[1] = ValentinesDay_GrandTotal_Page1_oneMark
	ValentinesDay_GrandTotal_Marks[2] = ValentinesDay_GrandTotal_Page1_twoMark
	ValentinesDay_GrandTotal_Marks[3] = ValentinesDay_GrandTotal_Page1_threeMark
	ValentinesDay_GrandTotal_Marks[4] = ValentinesDay_GrandTotal_Page1_fourMark

	ValentinesDay_GrandTotal_MainFrame_UnifiedPosition = ValentinesDay_GrandTotal_MainFrame:GetProperty("UnifiedPosition")
end

--=========================================================
-- 事件处理
--=========================================================
function ValentinesDay_GrandTotal_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 81012501 then
		local nParam0 = Get_XParam_INT(0)
		if nParam0 >= 0 then
			ValentinesDay_GrandTotal_NPC_ObjId = nParam0
			local objCared = DataPool:GetNPCIDByServerID(ValentinesDay_GrandTotal_NPC_ObjId)
			if objCared ~= -1 then
				this:CareObject(objCared, 1, "ValentinesDay_GrandTotal")
			end
			ValentinesDay_GrandTotal_Refresh(Get_XParam_INT(1))
			if not this:IsVisible() then
				for i = 1, 4 do
					local theAction = DataPool:CreateBindActionItemForShow(ValentinesDay_GrandTotal_Reward[i].itemid, 1)
					if theAction:GetID() ~= 0 then
						ValentinesDay_GrandTotal_ActionItems[i]:SetActionItem(theAction:GetID())
					end
				end
				this:Show()
			end
		elseif nParam0 == -1 then
			this:Hide()
		elseif nParam0 == -2 then
			if this:IsVisible() then
				ValentinesDay_GrandTotal_Refresh(Get_XParam_INT(1))
			end
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		ValentinesDay_GrandTotal_Frame:SetProperty("UnifiedPosition", ValentinesDay_GrandTotal_MainFrame_UnifiedPosition)

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ValentinesDay_GrandTotal_OnHiden()
	end
end

--=========================================================
-- 界面刷新
--=========================================================
function ValentinesDay_GrandTotal_Refresh(nCountFlag)
	ValentinesDay_GrandTotal_FinishTimes = math.floor(nCountFlag/10000)
	local nLeft = math.mod(nCountFlag,10000)
	local nFlag={0,0,0,0}
	for i=1,4 do
		nFlag[i]=math.mod(nLeft,10)
		nLeft = math.floor(nLeft/10)
	end
	for i=1,4 do
		if nFlag[i] == 1 then
			--已领取
			ValentinesDay_GrandTotal_Marks[i]:Show()
			ValentinesDay_GrandTotal_Animates[i]:Hide()
		else
			--未领取
			ValentinesDay_GrandTotal_Marks[i]:Hide()
			if ValentinesDay_GrandTotal_FinishTimes>= ValentinesDay_GrandTotal_Reward[i].times then
				--可以领取
				ValentinesDay_GrandTotal_Animates[i]:Show()
			else
				ValentinesDay_GrandTotal_Animates[i]:Hide()
			end
		end
	end

	-- 进度条
	local strMsg = ScriptGlobal_Format("#{QRWH_221115_59}",ValentinesDay_GrandTotal_FinishTimes)
	ValentinesDay_GrandTotal_Text2:SetText(strMsg)
end

--=========================================================
-- 控件事件 - 领取奖励
--=========================================================
function ValentinesDay_GrandTotal_Page1_OnClick(idx)
	if type(idx) ~= "number" then
		return
	end

	if idx > 4 or idx < 1 then
		return
	end
	if ValentinesDay_GrandTotal_FinishTimes < ValentinesDay_GrandTotal_Reward[idx].times then
		PushDebugMessage("#{QRWH_221115_61}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGetLeiJiPrize")
		Set_XSCRIPT_ScriptID(810125)
		Set_XSCRIPT_Parameter(0, ValentinesDay_GrandTotal_NPC_ObjId)
		Set_XSCRIPT_Parameter(1, idx)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- 控件事件 - 关闭
--=========================================================
function ValentinesDay_GrandTotal_Close()
	ValentinesDay_GrandTotal_OnHiden()
end

--=========================================================
-- 界面关闭事件
--=========================================================
function ValentinesDay_GrandTotal_OnHiden()
	this:Hide()
end