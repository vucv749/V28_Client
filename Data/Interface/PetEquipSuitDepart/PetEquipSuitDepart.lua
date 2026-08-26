--*********************************************
--珍兽套装拆解界面
--*********************************************
local PetEquipSuitDepartName = "PetEquipSuitDepart"
local g_PetEquipItemPos  = -1
local g_PetEquipItemID	 = -1
local g_ObjCareID		 = -1
local g_ServerCareID	 = -1
local g_ProductNeedMoney =  0
local MAX_OBJ_DISTANCE 	 = 3.0;
local g_PetEquipDepartiIndex = 19831205
local g_PetEquipFunCtrl  = -1	--功能控制

local g_PetEquipSuitDepart_Frame_UnifiedPosition;

--**********************************************
--事件注册
--**********************************************
function PetEquipSuitDepart_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_PETEQUIP_DEPART") --新建一个这样的事件
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("NEW_DEBUGMESSAGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end


--**********************************************
--
--**********************************************
function PetEquipSuitDepart_OnLoad()
	g_PetEquipSuitDepart_Frame_UnifiedPosition=PetEquipSuitDepart_Frame:GetProperty("UnifiedPosition");
end


--**********************************************
--事件响应
--**********************************************
function PetEquipSuitDepart_OnEvent( event )
	if (event == "UI_COMMAND") then
		PetEquipSuitDepart_UiCommand(arg0)
	elseif (event == "RESUME_ENCHASE_GEM") then
		PetEquipSuitDepart_Resume_Equip(1)
	elseif (event == "OBJECT_CARED_EVENT") then
		PetEquipSuitDepart_CareEvent(arg0,arg1,arg2)
	elseif (event == "UPDATE_PETEQUIP_DEPART") then
		PetEquipSuitDepart_Update(arg0)
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		PetEquipSuitDepart_PackageItemChange(arg0)
	elseif (event == "MONEYJZ_CHANGE") then
		PetEquipSuitDepart_JZMChange()
	elseif (event == "UNIT_MONEY") then
		PetEquipSuitDepart_UnitMoney()
	elseif (event == "ADJEST_UI_POS" ) then
		PetEquipSuitDepart_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetEquipSuitDepart_Frame_On_ResetPos()
	end
end


--**********************************************
--确定按钮
--**********************************************
function PetEquipSuitDepart_Buttons_Clicked()
	--是否旧宠物装备正常放入
	if (g_PetEquipItemPos == -1) then
		return
	end

	--放入的旧装备的Table中的ID
	if (g_PetEquipItemID == -1) then
		return
	end

	--判断物品是否加锁和足够在服务器端判断
	if (PlayerPackage:IsLock(g_PetEquipItemPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--发送给升级命令给服务器
	PetEquipSuitDepart:SetPetEquipDepartFunc("OnPetEquipSuitDepart", 800122, g_PetEquipItemPos, g_ServerCareID, 2)
	PetEquipSuitDepart:ShowConfirm(g_PetEquipItemPos, 17)
end


--*************************************************
--重置界面
--*************************************************
function PetEquipSuitDepart_Clear()
	if (g_PetEquipItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_PetEquipItemPos,0);
	end

	PetEquipSuitDepart_OK:Disable()
	PetEquipSuitDepart_Object:SetActionItem(-1)
	PetEquipSuitDepart_Explain_Text1:SetText("#G0%")
	PetEquipSuitDepart_Explain_Text3:SetText("#G0")
	PetEquipSuitDepart_Demand_Jiaozi:SetProperty("MoneyNumber", "")

	g_PetEquipItemPos  = -1
	g_PetEquipItemID   = -1
	g_ProductNeedMoney = 0
end


--*************************************************
--处理UI_COMMAND逻辑
--*************************************************
function PetEquipSuitDepart_UiCommand(arg0)
	PetEquipSuitDepart_Clear()
	--检查是否呼叫该界面
	local nUiIdx = tonumber(arg0)
	if (nUiIdx ~= g_PetEquipDepartiIndex) then
		return
	end

	--是否过了安全时间....
	if( tonumber(DataPool:GetLeftProtectTime()) >0 ) then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end

	--关心当前对话的NPC
	local targetId = Get_XParam_INT(0)
	g_ServerCareID = targetId
	g_ObjCareID = DataPool:GetNPCIDByServerID(targetId);
	if (g_ObjCareID == -1) then
		PushDebugMessage("server传过来的数据有问题。");
		return
	end

	--获取是那个分支功能的控制符
	--1 为珍兽装备升星功能
	g_PetEquipFunCtrl = Get_XParam_INT(1)
	PetEquipSuitDepart_BeginCareObject()
	PetEquipSuitDepart_Clear()
	this:Show();
end


--*************************************************
--处理RESUME_ENCHASE_GEM逻辑
--*************************************************
function PetEquipSuitDepart_Resume_Equip(Index)
	if (Index ~= 1) then
		return
	end

	LifeAbility:Lock_Packet_Item(g_PetEquipItemPos, 0)
	PetEquipSuitDepart_Object:SetActionItem(-1)
	g_PetEquipItemPos=-1
	PetEquipSuitDepart_Clear()
	PetEquipSuitDepart_Demand_Jiaozi:SetProperty("MoneyNumber", "")
	PetEquipSuitDepart_OK:Disable()
end

--*************************************************
--处理OBJECT_CARED_EVENT逻辑
--*************************************************
function PetEquipSuitDepart_CareEvent(arg0,arg1,arg2)
	local ObjCaredID = tonumber(arg0)
	if( ObjCaredID ~= g_ObjCareID) then
		return
	end

	local ObjDistance = tonumber(arg2)
	if( (arg1 == "distance" and ObjDistance>MAX_OBJ_DISTANCE) or arg1=="destroy") then
		PetEquipSuitDepart_Close()
	end
end

--*************************************************
--处理UPDATE_PETEQUIP_UP逻辑 界面更新
--*************************************************
function PetEquipSuitDepart_Update(pos_packet)
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber(pos_packet)
	--是否加锁....
	if (PlayerPackage:IsLock(BagPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--更新生成物品的Action
	local ItemID = PlayerPackage:GetItemTableIndex(BagPos)
	--通过表获取生成材料ID、材料数目、材料名称、升级几率、需要金钱数目、
	local nMaterialID,nMaterialNum,nPercent = PetEquipSuitDepart:GetPetEquipDepartInfo(ItemID) --debug
	if (-1 == nMaterialID) then
		PushDebugMessage("#{ZSZBSJ_090706_08}")
		return
	end

	--更新需求物品格的Action....
	local theAction = EnumAction(BagPos, "packageitem");
	if (theAction:GetID() == 0) then
		return
	end

	if (g_PetEquipItemPos ~= -1) then
		LifeAbility:Lock_Packet_Item(g_PetEquipItemPos, 0)
	end

	LifeAbility:Lock_Packet_Item(BagPos, 1)
	PetEquipSuitDepart_Object:SetActionItem(theAction:GetID())

	g_PetEquipItemPos=BagPos


	g_PetEquipItemID	= ItemID
	g_ProductNeedMoney  = 0
	PetEquipSuitDepart_Explain_Text1:SetText("#G"..tostring(nPercent).."%")
	PetEquipSuitDepart_Explain_Text3:SetText("#G"..tostring(nMaterialNum))

	PetEquipSuitDepart_OK:Enable()
	PetEquipSuitDepart:SetPetEquipDepartFunc("OnPetEquipSuitDepart", 800122, -1, -1, 0)
end


--*************************************************
--处理PACKAGE_ITEM_CHANGED逻辑
--*************************************************
function PetEquipSuitDepart_PackageItemChange(arg0)
	if (this:IsVisible() == 0) then
		return
	end

	local NumArg0 = tonumber(arg0)
	if (arg0~= nil and -1 == NumArg0) then
		return
	end


	if (g_PetEquipItemPos == NumArg0) then
		PetEquipSuitDepart_Resume_Equip(1)
	end
end

--*************************************************
--处理UNIT_MONEY逻辑
--*************************************************
function PetEquipSuitDepart_UnitMoney()
	PetEquipSuitDepart_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
end

--*************************************************
--处理MONEYJZ_CHANGE逻辑
--*************************************************
function PetEquipSuitDepart_JZMChange()
	PetEquipSuitDepart_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

--*************************************************
--开始关心NPC，就是确认玩家当前操作的NPC，如果离NPC
--太远就会关闭窗口在开始关心之前需要先确定这个界面
--是不是已经有“关心”的NPC，如果有的话，先取消已经
--有的“关心”
--*************************************************
function PetEquipSuitDepart_BeginCareObject()
	this:CareObject(g_ObjCareID, 1, "PetEquipSuitDepart");
end


--*************************************************
--停止对某NPC的关心
--*************************************************
function PetEquipSuitDepart_StopCareObject()
	this:CareObject(g_ObjCareID, 0, "PetEquipSuitDepart");
end

--*************************************************
--关闭界面
--*************************************************
function PetEquipSuitDepart_Close()
	this:Hide()
	PetEquipSuitDepart_StopCareObject()
	PetEquipSuitDepart_Clear()
end


function PetEquipSuitDepart_OnHiden()
	PetEquipSuitDepart_Close()
end


function PetEquipSuitDepart_Frame_On_ResetPos()
  PetEquipSuitDepart_Frame:SetProperty("UnifiedPosition", g_PetEquipSuitDepart_Frame_UnifiedPosition);
end