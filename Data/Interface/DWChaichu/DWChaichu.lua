
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWCHAICHU_Item = {}
local g_DWCHAICHU_Object = {}
local g_DWCHAICHU_GRID_SKIP = 100	-- G101 -> G102
local g_DWCHAICHU_DemandMoney = 50000

local g_DWCHAICHU_Action_Type = 3
local g_DWCHAICHU_RScript_ID = 809272
local g_DWCHAICHU_RScript_Name = "DoDiaowenAction"

local g_DWChaichu_Frame_UnifiedPosition;

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWChaichu_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWCHAICHU")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- 载入初始化
--=========================================================
function DWChaichu_OnLoad()
	g_DWCHAICHU_Item[1] = -1
	g_DWCHAICHU_Item[2] = -1
	g_DWCHAICHU_Object[1] = DWChaichu_Object
	g_DWCHAICHU_Object[2] = DWChaichu_Object2
	
	g_DWChaichu_Frame_UnifiedPosition=DWChaichu_Frame:GetProperty("UnifiedPosition");
	    
end

--=========================================================
-- 事件处理
--=========================================================
function DWChaichu_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 4000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server传过来的数据有问题。")
			return
		end
		BeginCareObject_DWChaichu()
		DWChaichu_Clear()
		DWChaichu_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWChaichu_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0 == nil or -1 == tonumber(arg0)) then
			return
		end
		for i = 1, 2 do
			if g_DWCHAICHU_Item[i] == tonumber(arg0) then
				DWChaichu_Resume_Equip(i + g_DWCHAICHU_GRID_SKIP)
				DWChaichu_UpdateBasic()
				break
			end
		end
	elseif (event == "UPDATE_DWCHAICHU") then
		DWChaichu_UpdateBasic()
		if arg0 ~= nil and arg1 ~= nil then
			DWChaichu_Update(arg0, arg1)
			DWChaichu_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWChaichu_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil then
			DWChaichu_Resume_Equip(tonumber(arg0))
			DWChaichu_UpdateBasic()
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		DWChaichu_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWChaichu_Frame_On_ResetPos()
	end
end

--=========================================================
-- 更新基本显示信息
--=========================================================
function DWChaichu_UpdateBasic()
	DWChaichu_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWChaichu_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- 计算所需金钱
	if g_DWCHAICHU_Item[1] == -1 then
		g_DWCHAICHU_DemandMoney = 0
	else
		g_DWCHAICHU_DemandMoney = 50000
	end
	DWChaichu_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWCHAICHU_DemandMoney))
end

--=========================================================
-- 重置界面
--=========================================================
function DWChaichu_Clear()
	for i = 1, 2 do
		if g_DWCHAICHU_Item[i] ~= -1 then
			g_DWCHAICHU_Object[i]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWCHAICHU_Item[i], 0)
			g_DWCHAICHU_Item[i] = -1
		end
	end

	DWChaichu_UpdateBasic()
end

--=========================================================
-- 更新界面
--=========================================================
function DWChaichu_Update(uiIndex, itemIndex)
	local u_index = tonumber(uiIndex)
	local i_index = tonumber(itemIndex)
	local theAction = EnumAction(i_index, "packageitem")

	if theAction:GetID() ~= 0 then
		-- 判断是否为安全时间
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end

		if u_index == 1 then
			-- 判断物品是否为已经蚀刻了雕纹的装备, 如果不是, 直接return
			-- 直接用强化那个接口, 根据返回值来确定
			local ret = LifeAbility:CanEquipDiaowen_Enchase(i_index)
			if ret == -1 or ret == -2 then
				-- 不是一个已经蚀刻了雕纹的装备
				PushDebugMessage("#{ZBDW_091105_19}")
				return
			end
			local jinjieLevel =  LifeAbility:GetDiaowenJinJieLevel(i_index)
			if jinjieLevel > 0 then
				PushDebugMessage("#{DWJJ_240329_149}")
				return
			end

		elseif u_index == 2 then
			-- 判断物品是否为雕纹拆除符, 如果不是, 直接return
			if PlayerPackage:GetItemTableIndex(i_index) ~= 30503150 then
				PushDebugMessage("#{ZBDW_091105_20}")
				return
			end
		else
			-- 异常情况
			DWChaichu_Clear()
			return
		end
		
		-- 判断物品是否加锁(执行到这里之前, 已经被判断了)
		if PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{ZBDW_091105_3}")
			return
		end

		-- 如果空格内已经有对应物品了, 替换之
		if g_DWCHAICHU_Item[u_index] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWCHAICHU_Item[u_index], 0)
		end
		g_DWCHAICHU_Object[u_index]:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(i_index, 1)
		g_DWCHAICHU_Item[u_index] = i_index
	else
		DWChaichu_Clear()
	end
end

--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function DWChaichu_Resume_Equip(nIndex)
	if nIndex <= g_DWCHAICHU_GRID_SKIP or nIndex > g_DWCHAICHU_GRID_SKIP + 2 then
		return
	end

	nIndex = nIndex - g_DWCHAICHU_GRID_SKIP
	if this:IsVisible() then
		if g_DWCHAICHU_Item[nIndex] ~= -1 then
			g_DWCHAICHU_Object[nIndex]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWCHAICHU_Item[nIndex], 0)
			g_DWCHAICHU_Item[nIndex] = -1
		end
	end
	DWChaichu_Check_AllItem()
end

--=========================================================
-- 判断是否所有物品都已放好
-- 只在点击 OK 按钮的时候调用这个函数
--=========================================================
function DWChaichu_Check_AllItem()
	DWChaichu_UpdateBasic()

	for i = 1, 2 do
		if g_DWCHAICHU_Item[i] == -1 then
			return i
		end
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWCHAICHU_DemandMoney then
		return 44
	end

	return 0
end

--=========================================================
-- 确定执行功能
--=========================================================
function DWChaichu_OK_Clicked()
	local ret = DWChaichu_Check_AllItem()
	if ret == 1 then
		PushDebugMessage("#{ZBDW_091105_12}")
		return
	elseif ret == 2 then
		PushDebugMessage("#{ZBDW_091105_20}")
		return
	elseif ret == 44 then
		PushDebugMessage("#{GMGameInterface_Script_PlayerMySelf_Info_Money_Not_Enough}")
	end

	if ret == 0 then
		-- 执行雕纹拆除功能
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name(g_DWCHAICHU_RScript_Name)
			Set_XSCRIPT_ScriptID(g_DWCHAICHU_RScript_ID)
			Set_XSCRIPT_Parameter(0, g_DWCHAICHU_Action_Type)
			for i = 1, 2 do
				Set_XSCRIPT_Parameter(i, g_DWCHAICHU_Item[i])
			end
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	end
end

--=========================================================
-- 关闭界面
--=========================================================
function DWChaichu_Close()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWChaichu_OnHiden()
	StopCareObject_DWChaichu()
	DWChaichu_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWChaichu()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWChaichu")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWChaichu()
	this:CareObject(g_CaredNpc, 0, "DWChaichu")
	g_CaredNpc = -1
	return
end

--=========================================================
-- 玩家金钱变化
--=========================================================
function DWChaichu_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWCHAICHU_DemandMoney then
		return -1
	end
	return 1
end


function DWChaichu_Frame_On_ResetPos()
  DWChaichu_Frame:SetProperty("UnifiedPosition", g_DWChaichu_Frame_UnifiedPosition);
end