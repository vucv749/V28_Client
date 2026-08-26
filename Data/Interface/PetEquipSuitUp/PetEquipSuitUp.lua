--*********************************************
--珍兽套装升级界面
--*********************************************

local PetEquipSuitUpName = "PetEquipSuitUp"
local g_PetEquipItemPos  = -1
local g_PetEquipItemID	 = -1
local g_PetEquipProductID= -1
local g_ObjCareID		 = -1
local g_ProductNeedMoney = 0
local g_PetEquipUiIndex	 = 19831204
local MAX_OBJ_DISTANCE 	 = 3.0;
local g_PetEquipFunCtrl  = -1	--功能控制


local g_PetEquipSuitUp_Frame_UnifiedPosition;

--**********************************************
--事件注册
--**********************************************
function PetEquipSuitUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_PETEQUIP_UP") --新建一个这样的事件
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("NEW_DEBUGMESSAGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end


--**********************************************
--
--**********************************************
function PetEquipSuitUp_OnLoad()
	g_PetEquipSuitUp_Frame_UnifiedPosition=PetEquipSuitUp_Frame:GetProperty("UnifiedPosition");
end


--**********************************************
--事件响应
--**********************************************
function PetEquipSuitUp_OnEvent( event )
	if (event == "UI_COMMAND") then
		PetEquipSuitUp_UiCommand(arg0)
	elseif (event == "UNIT_MONEY") then
		PetEquipSuitUp_UnitMoney()
	elseif (event == "MONEYJZ_CHANGE") then
		PetEquipSuitUp_JZMChange()
	elseif (event == "RESUME_ENCHASE_GEM") then
		PetEquipSuitUp_Resume_Equip(1)
	elseif (event == "OBJECT_CARED_EVENT") then
		PetEquipSuitUp_CareEvent(arg0,arg1,arg2)
	elseif (event == "UPDATE_PETEQUIP_UP") then
		PetEquipSuitUp_Update(arg0)
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		PetEquipSuitUp_PackageItemChange(arg0)
		
	elseif (event == "ADJEST_UI_POS" ) then
		PetEquipSuitUp_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetEquipSuitUp_Frame_On_ResetPos()
	end
end


--**********************************************
--确定按钮
--**********************************************
function PetEquipSuitUp_Buttons_Clicked()
	--是否旧宠物装备正常放入
	if (g_PetEquipItemPos == -1 or g_PetEquipProductID == -1) then
		return
	end

	--放入的旧装备的Table中的ID
	if (g_PetEquipItemID == -1) then
		return
	end

	--判断物品是否加锁和足够在服务器端判断

	--判断金钱是不是够
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if (selfMoney < g_ProductNeedMoney) then
		PushDebugMessage( "没有足够的金钱，不能进行珍兽装备升级！" )
		return
	end

	--发送给升级命令给服务器
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnPetEquipSuitUp")
		Set_XSCRIPT_ScriptID(800109)
		Set_XSCRIPT_Parameter(0,g_PetEquipItemPos)
		Set_XSCRIPT_Parameter(1,g_ObjCareID)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	PetEquipSuitUp_Clear()
end


--*************************************************
--重置界面
--*************************************************
function PetEquipSuitUp_Clear()
	if (g_PetEquipItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_PetEquipItemPos,0);
	end

	PetEquipSuitUp_Accept:Disable()
	PetEquipSuitUp_GemItem:SetActionItem(-1)
	PetEquipSuitUp_ProductItem:SetActionItem(-1)
	PetEquipSuitUp_ProductItem:Hide();
	PetEquipSuitUp_Explain2_Info:SetText("#{ZSZBSJ_XML_05}")
	PetEquipSuitUp_Explain4:SetText("#{ZSZBSJ_XML_03}")
	PetEquipSuitUp_Demand_Jiaozi:SetProperty("MoneyNumber", "")
	PetEquipSuitUp_Explain3_Text2:SetText("")
	g_PetEquipItemPos  = -1
	g_PetEquipItemID   = -1
	g_PetEquipProductID= -1
	g_ProductNeedMoney = 0
end

--*************************************************
--处理UI_COMMAND逻辑
--*************************************************
function PetEquipSuitUp_UiCommand(arg0)

	--检查是否呼叫该界面
	local nUiIdx = tonumber(arg0)
	if (nUiIdx ~= g_PetEquipUiIndex) then
		return
	end

	--关心当前对话的NPC
	local targetId = Get_XParam_INT(0)
	g_ObjCareID = DataPool:GetNPCIDByServerID(targetId);
	if (g_ObjCareID == -1) then
		PushDebugMessage("server传过来的数据有问题。");
		return
	end

	--获取是那个分支功能的控制符
	--1 为珍兽装备升星功能
	g_PetEquipFunCtrl = Get_XParam_INT(1)

	PetEquipSuitUp_BeginCareObject()
	PetEquipSuitUp_Clear()
	this:Show();
end

--*************************************************
--处理UNIT_MONEY逻辑
--*************************************************
function PetEquipSuitUp_UnitMoney()
	PetEquipSuitUp_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
end

--*************************************************
--处理MONEYJZ_CHANGE逻辑
--*************************************************
function PetEquipSuitUp_JZMChange()
	PetEquipSuitUp_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

--*************************************************
--处理RESUME_ENCHASE_GEM逻辑
--*************************************************
function PetEquipSuitUp_Resume_Equip(Index)
	if (Index ~= 1) then
		return
	end

	LifeAbility:Lock_Packet_Item(g_PetEquipItemPos, 0)
	PetEquipSuitUp_GemItem:SetActionItem(-1)
	g_PetEquipItemPos=-1
	PetEquipSuitUp_Clear()
	PetEquipSuitUp_ProductItem:SetActionItem(-1)
	g_PetEquipProductID=-1
	PetEquipSuitUp_Demand_Jiaozi:SetProperty("MoneyNumber", "")
	PetEquipSuitUp_Accept:Disable()
end

--*************************************************
--处理OBJECT_CARED_EVENT逻辑
--*************************************************
function PetEquipSuitUp_CareEvent(arg0,arg1,arg2)
	local ObjCaredID = tonumber(arg0)
	if( ObjCaredID ~= g_ObjCareID) then
		return
	end

	local ObjDistance = tonumber(arg2)
	if( (arg1 == "distance" and ObjDistance>MAX_OBJ_DISTANCE) or arg1=="destroy") then
		PetEquipSuitUp_Close()
	end
end

--*************************************************
--处理UPDATE_PETEQUIP_UP逻辑 界面更新
--*************************************************
function PetEquipSuitUp_Update( pos_packet )
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber(pos_packet)

	--deleted by guochenshu for TT:66411
	--是否加锁....
	--if (PlayerPackage:IsLock(BagPos) == 1) then
	--	PushDebugMessage("#{Item_Locked}")
	--	return
	--end

	local ItemID = PlayerPackage:GetItemTableIndex(BagPos)
	--通过表获取生成物品ID、需要金钱数目、升级几率、材料种类
	local nProductID,nPercent,nNeedMoney,nMaterialKind, strImpact= PetEquipSuitUp:GetPetEquipUpProductInfo(ItemID, 0) --debug

	if (-1 == nProductID) then
		PushDebugMessage("#{ZSZBSJ_090706_03}")
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
	PetEquipSuitUp_GemItem:SetActionItem(theAction:GetID())

	g_PetEquipItemPos=BagPos
	--更新生成物品的Action
	g_PetEquipItemID	= ItemID
	g_PetEquipProductID = nProductID
	g_ProductNeedMoney  = nNeedMoney

	PetEquipSuitUp_Explain4:SetText("#{ZSZBSJ_XML_04}")
	local ProductAction = PetEquipSuitUp:UpdateProductAction(nProductID,BagPos) --debug
	if (ProductAction and ProductAction:GetID() ~= 0) then
		PetEquipSuitUp_ProductItem:SetActionItem(ProductAction:GetID());
		PetEquipSuitUp_ProductItem:Show()
	else
		PetEquipSuitUp_ProductItem:SetActionItem(-1);
	end

	--更新需要金钱数目
	PetEquipSuitUp_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(g_ProductNeedMoney))
	PetEquipSuitUp_Explain3_Text2:SetText("#G"..tostring(nPercent).."%")

	--根据Table中的ID获取所需要的材料
	local nMaterial = {
					  [1] = {id=0,num=0,name="",},
					  [2] = {id=0,num=0,name="",},
					  [3] = {id=0,num=0,name="",},
					  }
	local szTipInfo = "#{ZSZBSJ_XML_06}"
	if (nMaterialKind > 0) then
		for i=1,nMaterialKind do
			nMaterial[i].id,nMaterial[i].num,nMaterial[i].name = PetEquipSuitUp:GetPetEquipUpMaterial(g_PetEquipItemID, 0, i) --debug
			if (-1 ~= nMaterial[i].id) then
				szTipInfo = szTipInfo..nMaterial[i].name.."#G"..nMaterial[i].num.."个；"
			end
		end

		if (strImpact ~= nil) then
			szTipInfo = szTipInfo.."\n"..strImpact
		end

		PetEquipSuitUp_Explain2_Info:SetText(szTipInfo)
	end

	PetEquipSuitUp_Accept:Enable()
end


--*************************************************
--处理PACKAGE_ITEM_CHANGED逻辑
--*************************************************
function PetEquipSuitUp_PackageItemChange(arg0)
	if (this:IsVisible() == 0) then
		return
	end

	local NumArg0 = tonumber(arg0)
	if (arg0~= nil and -1 == NumArg0) then
		return
	end


	if (g_PetEquipItemPos == NumArg0) then
		PetEquipSuitUp_Resume_Equip(1)
	end
end

--*************************************************
--开始关心NPC，就是确认玩家当前操作的NPC，如果离NPC
--太远就会关闭窗口在开始关心之前需要先确定这个界面
--是不是已经有“关心”的NPC，如果有的话，先取消已经
--有的“关心”
--*************************************************
function PetEquipSuitUp_BeginCareObject()
	this:CareObject(g_ObjCareID, 1, "PetEquipSuitUp");
end


--*************************************************
--停止对某NPC的关心
--*************************************************
function PetEquipSuitUp_StopCareObject()
	this:CareObject(g_ObjCareID, 0, "PetEquipSuitUp");
end

--*************************************************
--关闭界面
--*************************************************
function PetEquipSuitUp_Close()
	this:Hide()
	PetEquipSuitUp_StopCareObject()
	PetEquipSuitUp_Clear()
end


function PetEquipSuitUp_OnHide()
	PetEquipSuitUp_Close()
end

function PetEquipSuitUp_Frame_On_ResetPos()
  PetEquipSuitUp_Frame:SetProperty("UnifiedPosition", g_PetEquipSuitUp_Frame_UnifiedPosition);
end
