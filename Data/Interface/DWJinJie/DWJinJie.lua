--雕纹进阶
--  30503149 雕纹蚀刻
-- 10100010 狆天斧
-- 30110111 力量雕文
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_ServerObj = -1
local g_DWJinJie_Item = {}
local g_DWJinJie_Object = {}
local g_DWJinJie_DemandMoney = 0
local g_DWJinJieNeedMoney = 500000
local g_DWJinJie_GRID_SKIP = 180 --	G181 G182 
local g_DWJinJie_Tool_Num = 0
local g_EquipPoint2DWJinJie_Tool_ItemID = {
	[0] = 30900200,--??
	[1] = 30900206,--??
	[2] = 30900205,--??
	[3] = 30900209,--??
	[4] = 30900211,--?
	[5] = 30900210,--??
	[6] = 30900212,--??
	[7] = 30900204,--??
	[11] = 30900212,--??2
	[12] = 30900213,--??
	[13] = 30900213,--??2
	[14] = 30900208,--??
	[15] = 30900207,--??
	[17] = 30900201,--??
	[18] = 30900202,--??
	[37] = 30900203,--???
}
local g_UICOMMAND = 89030501

local g_DWJinJie_Frame_UnifiedPosition;

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWJinJie_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWJinJie")
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
function DWJinJie_OnLoad()
	g_DWJinJie_Item[1] = -1
	g_DWJinJie_Item[2] = -1
	g_DWJinJie_Object[1] = DWJinJie_Object
	g_DWJinJie_Object[2] = DWJinJie_Object2
	g_DWJinJie_DemandMoney = 0
	DWJinJie_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWJinJie_DemandMoney))
	-- 始譅可以点击 OK 按钮, 为了方便提示玩家信息
	DWJinJie_OK:Enable()
	g_DWJinJie_Frame_UnifiedPosition=DWJinJie_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- 事件处理
--=========================================================
function DWJinJie_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND) then
		local xx = Get_XParam_INT(0)  --targetid
		g_ServerObj = xx
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server data error")
			return
		end
		BeginCareObject_DWJinJie()
		DWJinJie_Clear()
		DWJinJie_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWJinJie_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		-- 可以改成允许接着强化, 那就不要在犫里移除物品
		if tonumber(arg0) == g_DWJinJie_Item[1]  then 
			DWJinJie_Resume_Equip(1)
		elseif  tonumber(arg0) == g_DWJinJie_Item[2] then
			DWJinJie_Resume_Equip(2)	
		end

	elseif (event == "UPDATE_DWJinJie") then
		if arg0 ~= nil and arg1 ~= nil then
			DWJinJie_Update(tonumber(arg0),tonumber(arg1))
			DWJinJie_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWJinJie_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == (g_DWJinJie_GRID_SKIP + 1) then
			DWJinJie_Resume_Equip(1)
		elseif arg0 ~= nil and tonumber(arg0) == (g_DWJinJie_GRID_SKIP + 2) then
			DWJinJie_Resume_Equip(2)
		end
	elseif (event == "ADJEST_UI_POS" ) then
		DWJinJie_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWJinJie_Frame_On_ResetPos()

	end
end

--=========================================================
-- 更新基本显示信息
-- 在犫里计算金钱并显示
--=========================================================
function DWJinJie_UpdateBasic()
	DWJinJie_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWJinJie_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	if g_DWJinJie_Item[1] < 0 then
		g_DWJinJie_DemandMoney = 0
	else
		g_DWJinJie_DemandMoney = g_DWJinJieNeedMoney
	end
	DWJinJie_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWJinJie_DemandMoney))

end

--=========================================================
-- 重置界面
--=========================================================
function DWJinJie_Clear()
	if g_DWJinJie_Item[1] ~= -1 then
		g_DWJinJie_Object[1]:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWJinJie_Item[1], 0)
		g_DWJinJie_Item[1] = -1
	end
	if g_DWJinJie_Item[2] ~= -1 then
		g_DWJinJie_Object[2]:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWJinJie_Item[2], 0)
		g_DWJinJie_Item[2] = -1
	end
	g_DWJinJie_DemandMoney = 0

	DWJinJie_UpdateBasic()
end

--=========================================================
-- 更新界面
--=========================================================
function DWJinJie_Update(uiActionIndex,index)
	local theAction = EnumAction(index, "packageitem")
	if theAction:GetID() ~= 0 then
		-- 判断是否为安全时间
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end
		if uiActionIndex == 1 then
			--向界面装备栏放道具
			local EquipPoint = LifeAbility:Can_Diaowen(index, -1)
			if EquipPoint == -2 then
				PushDebugMessage("#{DWJJ_240329_16}")
				return
			end
			local ret = LifeAbility:CanEquipDiaowen_JinJie(index)
			if ret == -1 or ret == -2 then
				-- 不是一个已经蚀刻了雕纹的装备
				PushDebugMessage("#{DWJJ_240329_16}")
				return
			elseif ret == -3 then
				PushDebugMessage("#{DWJJ_240329_17}")
				return
			end
		elseif uiActionIndex == 2 then
			--向界面进阶道具栏放道具
			if  g_DWJinJie_Item[1] == -1 then
				PushDebugMessage("#{DWJJ_240329_29}")
				return 
			end
			if PlayerPackage:IsLock(index) == 1 then
				PushDebugMessage("#{DWJJ_240329_124}")
				return
			end
			local epoint =PlayerPackage:LuaFnGetBagItemEquipPoint(g_DWJinJie_Item[1])
			local toolID = g_EquipPoint2DWJinJie_Tool_ItemID[epoint]
			if PlayerPackage:GetItemTableIndex(index) ~= toolID then
				PushDebugMessage("#{DWJJ_240329_151}")
				return
			end
		else
			--异常情况
			DWJinJie_Clear()
			return 
		end


		-- 雕纹强化不判断装备是否加锁了 - 2009-12-07
		-- 判断物品是否加锁(在犫个逻辑之前程序已经判断了)
		-- if PlayerPackage:IsLock(index) == 1 then
		-- 	PushDebugMessage("#{DWJJ_240329_124}")
		-- 	return
		-- end

		-- 如果繝格内已经有对应物品了, 替换之
		if g_DWJinJie_Item[uiActionIndex] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWJinJie_Item[uiActionIndex], 0)
		end

		g_DWJinJie_Object[uiActionIndex]:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWJinJie_Item[uiActionIndex] = index
		


		-- 设定 OK 为总是可以点击, 犫样方便检验
		-- 判断物品是否满足要求来设定功能button
		-- DWJinJie_Check_AllItem()
	else
		DWJinJie_Clear()
	end
end



--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function DWJinJie_Resume_Equip(index)
	if this:IsVisible() then
		if g_DWJinJie_Item[index] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWJinJie_Item[index], 0)
			g_DWJinJie_Object[index]:SetActionItem(-1)
			g_DWJinJie_Item[index] = -1
		end
	end
	DWJinJie_UpdateBasic()
end

--=========================================================
-- 判断是否所有物品都已放好
-- 只在点击 OK 按钮的时候调用犫个函数
--=========================================================
function DWJinJie_Check_AllItem()
	DWJinJie_UpdateBasic()

	if g_DWJinJie_Item[1] == -1  then
		g_DWJinJie_DemandMoney = 0
		DWJinJie_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWJinJie_DemandMoney))
		return 1
	end
	if g_DWJinJie_Item[2] == -1  then
		return 2
	end

	-- 判断装备是否能够强化(没有蚀刻雕纹或犨强化到顶级了返回 < 0)
	local ret = LifeAbility:CanEquipDiaowen_JinJie(g_DWJinJie_Item[1]) 
	if ret == -1 or ret == -2 then
		return 3
	elseif ret == -3 then
		return 4
	end

	-- 判断进阶道具
	local epoint =PlayerPackage:LuaFnGetBagItemEquipPoint(g_DWJinJie_Item[1])
	local toolID = g_EquipPoint2DWJinJie_Tool_ItemID[epoint]

	if PlayerPackage:GetItemTableIndex(g_DWJinJie_Item[2]) ~= toolID then
		return 2
	end

	local diaowenID,dianwenLevel = LifeAbility:GetEquitDiaowenID(g_DWJinJie_Item[1])
	if dianwenLevel < 4 then
		return 5
	end

	-- 判断金钱是否足够
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWJinJie_DemandMoney then
		return 44
	end

	DWJinJie_OK:Enable()
	return 0
end

--=========================================================
-- 确定执行功能
--=========================================================
function DWJinJie_OK_Clicked()
	local ret = DWJinJie_Check_AllItem()
	if ret == 1 or ret == 3 then
		PushDebugMessage("#{DWJJ_240329_29}")
		return
	elseif ret == 2 then
		PushDebugMessage("#{DWJJ_240329_36}")
		return
	elseif ret == 4 then
		PushDebugMessage("#{DWJJ_240329_30}")
		return
	elseif ret == 5 then
		PushDebugMessage("#{DWJJ_240329_192}")
		return
	elseif ret == 44 then
		PushDebugMessage("#{DWJJ_240329_32}")
		return
	end


	if ret == 0 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoDiaowenJinJie")
			Set_XSCRIPT_ScriptID(809272)
			Set_XSCRIPT_Parameter(0, g_ServerObj)
			Set_XSCRIPT_Parameter(1, tonumber(g_DWJinJie_Item[1]))
			Set_XSCRIPT_Parameter(2, tonumber(g_DWJinJie_Item[2]))
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	end

	DWJinJie_UpdateBasic()
end

--=========================================================
-- 关睜界面
--=========================================================
function DWJinJie_Close()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWJinJie_OnHiden()
	StopCareObject_DWJinJie()
	DWJinJie_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定犫个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWJinJie()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWJinJie")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWJinJie()
	this:CareObject(g_CaredNpc, 0, "DWJinJie")
	g_CaredNpc = -1
	return
end

--=========================================================
-- 玩家金钱变化
--=========================================================
function DWJinJie_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- 判断金钱够不够
	if selfMoney < g_DWJinJie_DemandMoney then
		--DWJinJie_OK:Disable()
		return -1
	end
	return 1
end

function DWJinJie_Frame_On_ResetPos()
  DWJinJie_Frame:SetProperty("UnifiedPosition", g_DWJinJie_Frame_UnifiedPosition);
end
