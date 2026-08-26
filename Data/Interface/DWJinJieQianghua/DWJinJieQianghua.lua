--进阶后的雕纹升级
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_ServerObj = -1

local g_DWJinJieQianghua_Item = -1--可有雕纹的装备，在背包中的位置
local g_DWJinJieQianghua_GRID_SKIP = 183 --	G184 
local g_DWJinJieQianghua_Frame_UnifiedPosition;

local g_UICOMMAND = 89030502

local g_DemandMoney = 0
local g_NeedMoney = 0 

local g_LCS2JCS = 5


-- 金蚕丝, 强化用的道具, 按照 绑定 -> 元宝交易 -> 随便交易 顺序使用
local g_DWJinJieQianghua_ToolItem = {20310168, 20310166, 20310167}
local g_DWJinJieQianghua_ToolItem2 = 20310174 
local g_DWJinJieQianghua_ToolItemNum1 = 0
local g_DWJinJieQianghua_ToolItemNum2 = 0
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWJinJieQianghua_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWJinJieQianghua")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
	this:RegisterEvent("RESUME_ENCHASE_GEM",false)
	this:RegisterEvent("DWJINJIESHENGJI_UI_CHANGE")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	--元宝
	this:RegisterEvent("UPDATE_YUANBAO",false);
	this:RegisterEvent("UPDATE_BIND_YUANBAO",false);
	--绑定确认
end

--=========================================================
-- 载入初始化
--=========================================================
function DWJinJieQianghua_OnLoad()
	g_DWJinJieQianghua_Item = -1
	g_DWJinJieQianghua_Frame_UnifiedPosition=DWJinJieQianghua_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- 事件处理
--=========================================================
function DWJinJieQianghua_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND) then
		local xx = Get_XParam_INT(0)
		g_ServerObj = xx
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			return
		end
		BeginCareObject_DWJinJieQianghua()
		DWJinJieQianghua_Clear()
		DWJinJieQianghua_UpdateBasic()
		this:Show()
	elseif (event == "DWJINJIESHENGJI_UI_CHANGE" and tonumber(arg0) == 1) then
		local xx = tonumber(arg1)
		g_ServerObj = xx
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			return
		end
		BeginCareObject_DWJinJieQianghua()
		DWJinJieQianghua_Clear()
		DWJinJieQianghua_UpdateBasic()
		--调整界面位置
		if tostring(arg2) ~= nil then
			DWJinJieQianghua_Frame:SetProperty("UnifiedPosition", tostring(arg2));
		end
		this:Show()
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_DWJinJieQianghua_Item == tonumber(arg0)) then
			--DWJinJieQianghua_Resume_Equip()
			DWJinJieQianghua_Update(tonumber(arg0))
		end
		DWJinJieQianghua_UpdateBasic()
	elseif (event == "UPDATE_DWJinJieQianghua") then
		if arg0 ~= nil then
			DWJinJieQianghua_Update(tonumber(arg0))
			DWJinJieQianghua_UpdateBasic()
		end
	elseif (event == "RESUME_ENCHASE_GEM") then
		if (arg0 ~= nil) then
			DWJinJieQianghua_Resume_Equip()
			DWJinJieQianghua_UpdateBasic()
		end
	--挪拽
	elseif (event == "ADJEST_UI_POS" ) then
		DWJinJieQianghua_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWJinJieQianghua_Frame_On_ResetPos()
	--元宝
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		DWJinJieQianghua_UpdateBasic()
	elseif (event == "UPDATE_BIND_YUANBAO" and this:IsVisible()) then
		DWJinJieQianghua_UpdateBasic()

	end
end

--=========================================================
-- 更新基本显示信息
--=========================================================
function DWJinJieQianghua_UpdateBasic(toolnum1,toolnum2)
	DWJinJieQianghua_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWJinJieQianghua_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	if g_DWJinJieQianghua_Item < 0 then
		g_DemandMoney = 0
	else
		g_DemandMoney = g_NeedMoney
	end
	DWJinJieQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DemandMoney))
	if toolnum1 ~= nil then
		DWJinJieQianghua_SetToolNumAndText1(toolnum1)
	end
	if toolnum2 ~= nil then
		DWJinJieQianghua_SetToolNumAndText2(toolnum2)
	end
	
end

--=========================================================
-- 重置界面
--=========================================================
function DWJinJieQianghua_Clear()
	if g_DWJinJieQianghua_Item ~= -1 then
		DWJinJieQianghua_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWJinJieQianghua_Item, 0)
		g_DWJinJieQianghua_Item = -1
	end
	--需要的金蚕丝数量
	DWJinJieQianghua_OK:Disable()
	DWJinJieQianghua_NumericalValue:SetProperty("DefaultEditBox", "True")
	DWJinJieQianghua_NumericalValue:SetSelected(0, -1)
	DWJinJieQianghua_NumericalValue2:SetSelected(0, -1)
	DWJinJieQianghua_NumericalValue:SetProperty("Text", tostring(0))
	DWJinJieQianghua_NumericalValue2:SetProperty("Text", tostring(0))
	g_DWJinJieQianghua_ToolItemNum1 = 0
	g_DWJinJieQianghua_ToolItemNum1 = 0
	DWJinJieQianghua_JCSneed_Text:SetText("")
	DWJinJieQianghua_JCSneed:SetText(ScriptGlobal_Format("#{DWJJ_240329_259}",0))
	DWJinJieQianghua_JCSneed2_Text:SetText("")
	DWJinJieQianghua_JCSneed2:SetText(ScriptGlobal_Format("#{DWJJ_240329_317}",0))
end

--=========================================================
-- 更新界面
--=========================================================
function DWJinJieQianghua_Update(itemIndex) 
	local index = tonumber(itemIndex)--背包位置
	local theAction = EnumAction(index, "packageitem")
	if theAction:GetID() ~= 0 then
		--是否为蚀刻了雕纹的装备
		local ret = LifeAbility:CanEquipDiaowen_JinJieShengJi(index)
		if ret == -1 then
			-- 非装备
			PushDebugMessage("#{DWJJ_240329_41}")
			return
		end
		if ret == -2 then
			-- 不是一个已经蚀刻了雕纹的装备
			PushDebugMessage("#{DWJJ_240329_41}")
			return
		end
		if ret == -3 then
			--未开启进阶
			PushDebugMessage("#{DWJJ_240329_42}")
			return
		end
		-- if ret == -4 then
		-- 	--满级
		-- 	return
		-- end
		--不检测加锁

		-- 如果空格内已经有图样了, 替换之
		if g_DWJinJieQianghua_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWJinJieQianghua_Item, 0)
		end

		DWJinJieQianghua_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWJinJieQianghua_Item = index

		local curJinJieLevel =  LifeAbility:GetDiaowenJinJieLevel(index)
		if curJinJieLevel < 1 then
			--未开启进阶
			PushDebugMessage("#{DWJJ_240329_42}")
			return
		end
		local maxjinjieLevel =  LifeAbility:GetDiaowenJinJieShengJiMaxLevel()
		if curJinJieLevel >= maxjinjieLevel then
			DWJinJieQianghua_JCSneed2:SetText(ScriptGlobal_Format("#{DWJJ_240329_317}","#{DWJJ_240329_322}"))
		else
			local totalNeedJCS,curLvExp = LifeAbility:GetDiaowenJinJieShengJiNeedJCSNum(g_DWJinJieQianghua_Item,curJinJieLevel+1)
			local requireJCS = totalNeedJCS - curLvExp
			DWJinJieQianghua_JCSneed2:SetText(ScriptGlobal_Format("#{DWJJ_240329_317}",curLvExp.."/"..totalNeedJCS))
		end
		DWJinJieQianghua_OK:Enable()

	else
		DWJinJieQianghua_Clear()
	end
end

--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function DWJinJieQianghua_Resume_Equip()
	if this:IsVisible() then
		DWJinJieQianghua_Clear()
	end
end

--=========================================================
-- 确定执行功能
--=========================================================
function DWJinJieQianghua_OK_Clicked()
	-- 安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{DWSJ_141202_20}")
		return
	end
--	--- 角色当前未处于全沉迷或半沉迷状态；
--	if IsInFatigueState() <= 0 then
--		PushDebugMessage( "#{GY_120202_33}" )
--		return
--	end
	-- 二级密码 电话密保检查
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	if g_DWJinJieQianghua_Item==-1 then
		PushDebugMessage("#{DWJJ_240329_57}")
		return
	end

	local ret = LifeAbility:CanEquipDiaowen_JinJieShengJi(g_DWJinJieQianghua_Item)
	if ret == -1 then
		-- 非装备
		PushDebugMessage("#{DWJJ_240329_57}")
		return
	end
	if ret == -2 then
		-- 不是一个已经蚀刻了雕纹的装备
		PushDebugMessage("#{DWJJ_240329_57}")
		return
	end
	if ret == -3 then
		--未开启进阶
		PushDebugMessage("#{DWJJ_240329_42}")
		return
	end
	if ret == -4 then
		--满级
		PushDebugMessage("#{DWJJ_240329_58}")
		return
	end
	local curJinJieLevel =  LifeAbility:GetDiaowenJinJieLevel(g_DWJinJieQianghua_Item)
	if curJinJieLevel < 1 then
		--未开启进阶
		--PushDebugMessage("#{DWJJ_240329_42}")
		return
	end
	local diaowenID,dianwenLevel = LifeAbility:GetEquitDiaowenID(g_DWJinJieQianghua_Item)
	if curJinJieLevel >= dianwenLevel*5+4 then
		PushDebugMessage("#{DWJJ_240329_60}")
		return
	end
	--计算输入的够不够
	local toolNumInBag1 = 0		-- 背包里强化材料的个数
	local toolNumInBag2 = 0		-- 背包里强化材料的个数
	for i, tbIndex in ipairs(g_DWJinJieQianghua_ToolItem) do
		toolNumInBag1 = toolNumInBag1 + PlayerPackage:CountAvailableItemByIDTable(tonumber(tbIndex))
	end
	toolNumInBag2 =  PlayerPackage:CountAvailableItemByIDTable(tonumber(g_DWJinJieQianghua_ToolItem2))

	-- PushDebugMessage(
	-- 	"g_DWJinJieQianghua_ToolItemNum1:"..g_DWJinJieQianghua_ToolItemNum1..
	-- 	"g_DWJinJieQianghua_ToolItemNum2:"..g_DWJinJieQianghua_ToolItemNum2..
	-- 	"toolNumInBag1:"..toolNumInBag1..
	-- 	"toolNumInBag2:"..toolNumInBag2
	-- )
	if g_DWJinJieQianghua_ToolItemNum1 < 1 and g_DWJinJieQianghua_ToolItemNum2 < 1 then
		PushDebugMessage("#{DWJJ_240329_198}")
		return
	end
	if toolNumInBag1 < g_DWJinJieQianghua_ToolItemNum1  then
		PushDebugMessage("#{DWJJ_240329_61}")
		return
	end
	if toolNumInBag2 < g_DWJinJieQianghua_ToolItemNum2  then
		PushDebugMessage("#{DWJJ_240329_160}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DoDiaowenJinJieQiangHua")
		Set_XSCRIPT_ScriptID(809272)
		Set_XSCRIPT_Parameter(0, g_ServerObj)
		Set_XSCRIPT_Parameter(1, g_DWJinJieQianghua_Item)
		Set_XSCRIPT_Parameter(2, g_DWJinJieQianghua_ToolItemNum1) 
		Set_XSCRIPT_Parameter(3, g_DWJinJieQianghua_ToolItemNum2) 
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()

end

--=========================================================
-- 关闭界面
--=========================================================
function DWJinJieQianghua_Close()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWJinJieQianghua_OnHiden()
	StopCareObject_DWJinJieQianghua()
	DWJinJieQianghua_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWJinJieQianghua()
	this:CareObject(g_CaredNpc, 1, "DWJinJieQianghua")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWJinJieQianghua()
	this:CareObject(g_CaredNpc, 0, "DWJinJieQianghua")
	g_CaredNpc = -1
	return
end


function DWJinJieQianghua_Frame_On_ResetPos()
  DWJinJieQianghua_Frame:SetProperty("UnifiedPosition", g_DWJinJieQianghua_Frame_UnifiedPosition);
end

function DWJinJieQianghua_ItemBtnRBClicked()
	DWJinJieQianghua_Resume_Equip()
end



--=========================================================
-- 增加金蚕丝的数量
--=========================================================
function DWJinJieQianghua_Addition1_Click()
	DWJinJieQianghua_UpdateBasic(g_DWJinJieQianghua_ToolItemNum1 + 1,g_DWJinJieQianghua_ToolItemNum2)
end

--=========================================================
-- 减少至尊金蚕丝的数量
--=========================================================
function DWJinJieQianghua_Decrease1_Click()
	DWJinJieQianghua_UpdateBasic(g_DWJinJieQianghua_ToolItemNum1 - 1,g_DWJinJieQianghua_ToolItemNum2)
end

--=========================================================
-- 增加至尊金蚕丝的数量
--=========================================================
function DWJinJieQianghua_Addition2_Click()
	DWJinJieQianghua_UpdateBasic(g_DWJinJieQianghua_ToolItemNum1,g_DWJinJieQianghua_ToolItemNum2 + 1)
end

--=========================================================
-- 减少金蚕丝的数量
--=========================================================
function DWJinJieQianghua_Decrease2_Click()
	DWJinJieQianghua_UpdateBasic(g_DWJinJieQianghua_ToolItemNum1,g_DWJinJieQianghua_ToolItemNum2 - 1)
end

--=========================================================
-- 金蚕丝数量改变
--=========================================================
function DWJinJieQianghua_ToolNumChange1()
	local num = DWJinJieQianghua_NumericalValue:GetProperty("Text")
	-- 输入框改变了, 不要再改变输入框的内容, 不然用户就没法再输入框输入数字了
	-- 代码主动修改的文本
	if num == nil or (not num) or num == "" or tonumber(num) < 0 then
		g_DWJinJieQianghua_ToolItemNum1 = 0
		DWJinJieQianghua_NumericalValue:SetProperty("Text", tostring(0))
		return
	end
	-- 如果用户删除输入框的所有内容, tonumber 的结果比较诡异, 无法自动设置为某个值
	num = tonumber(num)
	if num == g_DWJinJieQianghua_ToolItemNum1 then
		return
	end
	-- 玩家输入文本: 首先对有效 num 进行保存, 不然可能影响玩家输入
	if tonumber(num) >= 0 and tonumber(num) <= 100000 then
		g_DWJinJieQianghua_ToolItemNum1 = tonumber(num)
	elseif tonumber(num) > 100000 then
		g_DWJinJieQianghua_ToolItemNum1 = 100000
		DWJinJieQianghua_NumericalValue:SetProperty("Text", tostring(g_DWJinJieQianghua_ToolItemNum1))
	else
		g_DWJinJieQianghua_ToolItemNum1 = 0
		DWJinJieQianghua_NumericalValue:SetProperty("Text", tostring(g_DWJinJieQianghua_ToolItemNum1))
	end
	DWJinJieQianghua_JCSneed:SetText(ScriptGlobal_Format("#{DWJJ_240329_259}",g_DWJinJieQianghua_ToolItemNum1+g_DWJinJieQianghua_ToolItemNum2*g_LCS2JCS))
end
--=========================================================
-- 至尊金蚕丝数量改变
--=========================================================
function DWJinJieQianghua_ToolNumChange2()
	local num = DWJinJieQianghua_NumericalValue2:GetProperty("Text")
	-- 输入框改变了, 不要再改变输入框的内容, 不然用户就没法再输入框输入数字了
	-- 代码主动修改的文本
	if num == nil or (not num) or num == "" or tonumber(num) < 0 then
		g_DWJinJieQianghua_ToolItemNum2 = 0
		DWJinJieQianghua_NumericalValue2:SetProperty("Text", tostring(0))
		return
	end
	-- 如果用户删除输入框的所有内容, tonumber 的结果比较诡异, 无法自动设置为某个值
	num = tonumber(num)
	if num == g_DWJinJieQianghua_ToolItemNum2 then
		return
	end
	-- 玩家输入文本: 首先对有效 num 进行保存, 不然可能影响玩家输入
	if tonumber(num) >= 0 and tonumber(num) <= 100000 then
		g_DWJinJieQianghua_ToolItemNum2 = tonumber(num)
	elseif tonumber(num) > 100000 then
		g_DWJinJieQianghua_ToolItemNum2 = 100000
		DWJinJieQianghua_NumericalValue2:SetProperty("Text", tostring(g_DWJinJieQianghua_ToolItemNum2))
	else
		g_DWJinJieQianghua_ToolItemNum2 = 0
		DWJinJieQianghua_NumericalValue2:SetProperty("Text", tostring(g_DWJinJieQianghua_ToolItemNum2))
	end
	DWJinJieQianghua_JCSneed:SetText(ScriptGlobal_Format("#{DWJJ_240329_259}",g_DWJinJieQianghua_ToolItemNum1+g_DWJinJieQianghua_ToolItemNum2*g_LCS2JCS))
end

function DWJinJieQianghua_TextLost1()
	DWJinJieQianghua_ToolNumChange1()
end
function DWJinJieQianghua_TextLost2()
	DWJinJieQianghua_ToolNumChange2()
end
--=========================================================
-- 更改金蚕丝数量并设置变量
-- 为了保证这两个操作始终统一
--=========================================================
function DWJinJieQianghua_SetToolNumAndText1(count)
	local num = tonumber(count)
	-- 注意这里不要和 DWJinJieQianghua_ToolNumChange() 产生死循环了
	if count == nil or count == "" or num < 0 then
		-- 输入太小的数
		g_DWJinJieQianghua_ToolItemNum1 = 0
	elseif num > 100000 then
		g_DWJinJieQianghua_ToolItemNum1 = 100000
	elseif num == g_DWJinJieQianghua_ToolItemNum1 then
		return
	else
		g_DWJinJieQianghua_ToolItemNum1 = num
	end

	DWJinJieQianghua_NumericalValue:SetProperty("Text", tostring(g_DWJinJieQianghua_ToolItemNum1))
	DWJinJieQianghua_JCSneed:SetText(ScriptGlobal_Format("#{DWJJ_240329_259}",g_DWJinJieQianghua_ToolItemNum1+g_DWJinJieQianghua_ToolItemNum2*g_LCS2JCS))
end
function DWJinJieQianghua_SetToolNumAndText2(count)
	local num = tonumber(count)
	-- 注意这里不要和 DWJinJieQianghua_ToolNumChange() 产生死循环了
	if count == nil or count == "" or num < 0 then
		-- 输入太小的数
		g_DWJinJieQianghua_ToolItemNum2 = 0
	elseif num > 100000 then
		g_DWJinJieQianghua_ToolItemNum2 = 100000
	elseif num == g_DWJinJieQianghua_ToolItemNum2 then
		return
	else
		g_DWJinJieQianghua_ToolItemNum2 = num
	end

	DWJinJieQianghua_NumericalValue2:SetProperty("Text", tostring(g_DWJinJieQianghua_ToolItemNum2))
	DWJinJieQianghua_JCSneed:SetText(ScriptGlobal_Format("#{DWJJ_240329_259}",g_DWJinJieQianghua_ToolItemNum1+g_DWJinJieQianghua_ToolItemNum2*g_LCS2JCS))
end

function DWJinJieQianghua_ChangeTabIndex()
	--参数2:1-强化、2-升级
	PushEvent("DWJINJIESHENGJI_UI_CHANGE", 2,g_ServerObj,DWJinJieQianghua_Frame:GetProperty("UnifiedPosition"))
	DWJinJieQianghua_Close()
end