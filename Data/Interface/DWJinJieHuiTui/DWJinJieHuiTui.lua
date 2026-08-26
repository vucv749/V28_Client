--雕纹进阶回退
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_ServerObj = -1
local g_DWJinJieHuiTui_Item = -1
local g_DWJinJieHuiTui_DemandYuanbao = 0
local g_DWJinJieHuiTui_GRID_SKIP = 184 --	G185 todo
local g_UICOMMAND = 89030504
local g_Comfirmed = 0
local g_LCS_Yuanbao = 98
local g_LCS2JCS = 5

local g_DWJinJieHuiTui_Frame_UnifiedPosition;

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWJinJieHuiTui_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWJinJieHuiTui")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("DWJINJIEHUITUI_CONFIRMED",false)
		--元宝
		this:RegisterEvent("UPDATE_YUANBAO",false);
		this:RegisterEvent("UPDATE_BIND_YUANBAO",false);

end

--=========================================================
-- 载入初始化
--=========================================================
function DWJinJieHuiTui_OnLoad()
	g_DWJinJieHuiTui_Item = -1
	g_DWJinJieHuiTui_DemandYuanbao = 0
	-- 始终可以点击 OK 按钮, 为了方便提示玩家信息
	DWJinJieHuiTui_OK:Enable()
	g_DWJinJieHuiTui_Frame_UnifiedPosition=DWJinJieHuiTui_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- 事件处理
--=========================================================
function DWJinJieHuiTui_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND) then
		local xx = Get_XParam_INT(0)  --targetid
		g_ServerObj = xx
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server data error")
			return
		end
		BeginCareObject_DWJinJieHuiTui()
		DWJinJieHuiTui_Clear()
		DWJinJieHuiTui_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWJinJieHuiTui_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		-- 可以改成允许接着强化, 那就不要在这里移除物品
		if tonumber(arg0) == g_DWJinJieHuiTui_Item then --todo 背包进阶道具发生变化
			-- 强化后不将装备返还到包裹, 支持持续强化 - 2009-12-07
			--DWJinJieHuiTui_Resume_Equip()
			DWJinJieHuiTui_UpdateBasic()
		end
	elseif (event == "UPDATE_DWJinJieHuiTui") then
		--加载这里很容易导致界面处理不过来, 这个事件特别多
		--DWJinJieHuiTui_UpdateBasic()
		if arg0 ~= nil then
			DWJinJieHuiTui_Update(arg0)
			DWJinJieHuiTui_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWJinJieHuiTui_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == (g_DWJinJieHuiTui_GRID_SKIP + 1) then
			DWJinJieHuiTui_Resume_Equip()
			DWJinJieHuiTui_UpdateBasic()
		end
	elseif (event == "DWJINJIEHUITUI_CONFIRMED") then
		g_Comfirmed = 1
		
	elseif (event == "ADJEST_UI_POS" ) then
		DWJinJieHuiTui_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWJinJieHuiTui_Frame_On_ResetPos()
	--元宝
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		DWJinJieHuiTui_UpdateBasic()
	elseif (event == "UPDATE_BIND_YUANBAO" and this:IsVisible()) then
		DWJinJieHuiTui_UpdateBasic()
	end
end

--=========================================================
-- 更新基本显示信息
-- 在这里计算金钱并显示
--=========================================================
function DWJinJieHuiTui_UpdateBasic()
	DWJinJieHuiTui_SelfYuanBao:SetText(tostring(Player:GetData("YUANBAO")));
	local jinjinItemNum,JCSNum,tupoItemNum = 0,0,0
	local getLCS = 0
	if g_DWJinJieHuiTui_Item < 0 then
		g_DWJinJieHuiTui_DemandYuanbao = 0
	else
		jinjinItemNum,JCSNum = LifeAbility:GetDiaowenJinJieHuiTuiGotInfo(g_DWJinJieHuiTui_Item)
		getLCS = math.ceil(JCSNum/g_LCS2JCS)
		local needYB = math.ceil(getLCS*g_LCS_Yuanbao*0.4)
		g_DWJinJieHuiTui_DemandYuanbao =  needYB
	end
	DWJinJieHuiTui_NeedYuanBao:SetText(g_DWJinJieHuiTui_DemandYuanbao)
	--计算回退获得的材料
	DWJinJieHuiTui_Quantity:SetText(getLCS)--回退后获得的金蚕丝数量
end

--=========================================================
-- 重置界面
--=========================================================
function DWJinJieHuiTui_Clear()
	if g_DWJinJieHuiTui_Item ~= -1 then
		DWJinJieHuiTui_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWJinJieHuiTui_Item, 0)
		g_DWJinJieHuiTui_Item = -1
	end
	g_Comfirmed = 0
	DWJinJieHuiTui_NeedYuanBao:SetText("")
	DWJinJieHuiTui_Quantity:SetText("")--回退后获得的金蚕丝数量
	DWJinJieHuiTui_UpdateBasic()
end

--=========================================================
-- 更新界面
--=========================================================
function DWJinJieHuiTui_Update(itemIndex)
	local index = tonumber(itemIndex)
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		-- 判断是否为安全时间
		-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		-- 	PushDebugMessage("#{JJTZ_090826_26}")
		-- 	return
		-- end

		if PlayerPackage:IsLock(index) == 1 then
			PushDebugMessage("#{DWJJ_240329_101}")
			return
		end
		local dwId,_ = LifeAbility:GetEquitDiaowenID(index)
		if dwId < 1 then
			PushDebugMessage("#{DWJJ_240329_99}")
			return 
		end

		local jinjieLevel = LifeAbility:GetDiaowenJinJieLevel(index) 
		if jinjieLevel == -1 then
			PushDebugMessage("#{DWJJ_240329_99}")
			return
		end
		if jinjieLevel < 1 then
			PushDebugMessage("#{DWJJ_240329_100}")
			return
		end

		-- 如果空格内已经有对应物品了, 替换之
		if g_DWJinJieHuiTui_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWJinJieHuiTui_Item, 0)
		end

		DWJinJieHuiTui_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWJinJieHuiTui_Item = index

		-- 设定 OK 为总是可以点击, 这样方便检验
		-- 判断物品是否满足要求来设定功能button
		-- DWJinJieHuiTui_Check_AllItem()
	else
		DWJinJieHuiTui_Clear()
	end
end

--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function DWJinJieHuiTui_Resume_Equip()
	if this:IsVisible() then
		if g_DWJinJieHuiTui_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWJinJieHuiTui_Item, 0)
			DWJinJieHuiTui_Object:SetActionItem(-1)
			g_DWJinJieHuiTui_Item = -1
		end
	end

	DWJinJieHuiTui_UpdateBasic()
end


--=========================================================
-- 确定执行功能
--=========================================================
function DWJinJieHuiTui_OK_Clicked(okFlag)
	if g_DWJinJieHuiTui_Item < 0 then
		PushDebugMessage("#{DWJJ_240329_109}")
		return
	end

	local jinjieLevel = LifeAbility:GetDiaowenJinJieLevel(g_DWJinJieHuiTui_Item) 
	if jinjieLevel == -1 then
		PushDebugMessage("#{DWJJ_240329_109}")
		return
	end
	if jinjieLevel < 1 then
		PushDebugMessage("#{DWJJ_240329_111}")
		return
	end
	local  YuanBaoHave = Player:GetData("BIND_YUANBAO") + Player:GetData("YUANBAO")
	if YuanBaoHave < g_DWJinJieHuiTui_DemandYuanbao then
		PushDebugMessage("#{DWJJ_240329_112}")
		return
	end

	if PlayerPackage:IsLock(g_DWJinJieHuiTui_Item) == 1 then
		PushDebugMessage("#{DWJJ_240329_101}")
		return
	end

	Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("DoDiaowenJinJieHuiTui")
				Set_XSCRIPT_ScriptID(809272)
				Set_XSCRIPT_Parameter(0, g_ServerObj)
				Set_XSCRIPT_Parameter(1, g_DWJinJieHuiTui_Item)
				Set_XSCRIPT_Parameter(2, g_Comfirmed)
				Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()

	DWJinJieHuiTui_UpdateBasic()
end

--=========================================================
-- 关闭界面
--=========================================================
function DWJinJieHuiTui_Close()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWJinJieHuiTui_OnHiden()
	StopCareObject_DWJinJieHuiTui()
	DWJinJieHuiTui_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWJinJieHuiTui()
	AxTrace(0, 0, "LUA___CareObject g_CaredNpc =" .. g_CaredNpc)
	this:CareObject(g_CaredNpc, 1, "DWJinJieHuiTui")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWJinJieHuiTui()
	this:CareObject(g_CaredNpc, 0, "DWJinJieHuiTui")
	g_CaredNpc = -1
	return
end

--=========================================================
-- 玩家金钱变化
--=========================================================
function DWJinJieHuiTui_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- 判断金钱够不够

	return 1
end

function DWJinJieHuiTui_Frame_On_ResetPos()
  DWJinJieHuiTui_Frame:SetProperty("UnifiedPosition", g_DWJinJieHuiTui_Frame_UnifiedPosition);
end
