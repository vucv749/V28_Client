
-- 犱兽外观拓印界面

local g_PetExterior_Gain_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0
local g_serverNpcId = -1
local g_clientNpcId = -1

local g_PetExterior_Gain_ScriptId 	= 998478
local g_PetExterior_Gain_ItemPos	= -1
local g_PetExterior_Gain_NeedMoney	= -1
local g_PetExterior_Gain_NeedItem	= -1
local g_PetExterior_Gain_PetIdx		= -1
local g_PetExterior_Gain_ExteriorId		= -1

local g_PetExterior_Gain_YuanbaoPayType = 3

--****************************************
--注册消息
--****************************************
function PetExterior_Gain_PreLoad()

	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "OBJECT_CARED_EVENT" )	
	this : RegisterEvent( "PET_EXTERIOR_ADD_COLLECTION" )
	
	this : RegisterEvent( "BUY_ITEM" )
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )
	this : RegisterEvent( "PACKAGE_ITEM_CHANGED" )
	this : RegisterEvent( "UPDATE_PETEXTERIOR_GAIN_ITEM" )
	
	this : RegisterEvent( "UPDATE_PET_PAGE" )
	this : RegisterEvent( "ADD_PET" )
	this : RegisterEvent( "DELETE_PET" )
	this : RegisterEvent( "REPLY_MISSION_PET" )	
		
	this : RegisterEvent( "ADJEST_UI_POS" )
	this : RegisterEvent( "VIEW_RESOLUTION_CHANGED" )
	this : RegisterEvent( "HIDE_ON_SCENE_TRANSED" )
	
end

function PetExterior_Gain_OnLoad()

    g_PetExterior_Gain_UnifiedPosition = PetExterior_Gain_Frame:GetProperty("UnifiedPosition");
	
end

--****************************************
--触发事件消息
--****************************************
function PetExterior_Gain_OnEvent(event)
	if	   ( event == "UI_COMMAND" and tonumber(arg0) == 998478001) then
		if Get_XParam_INT(0) ~= 1 then
			PetExterior_Gain_OnHidden()
			return
		end
		
		g_serverNpcId = Get_XParam_INT(1)
		g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId)
		if (g_clientNpcId == -1) then
			return
		end
		this:CareObject(g_clientNpcId, 1, "PetExterior_Gain")
			
		g_PetExterior_Gain_NeedItem = Get_XParam_INT(2)
		g_PetExterior_Gain_NeedMoney = Get_XParam_INT(3)
		
		PetExterior_Gain_Open()
			
		local check = tonumber(Pet:GetYuanbaoBuyState(g_PetExterior_Gain_YuanbaoPayType));		
		if(check>=1)then
			PetExterior_Gain_PetList_Check:SetCheck(0);
		else
			PetExterior_Gain_PetList_Check:SetCheck(1);
		end	
		
		if(IsWindowShow("PetExterior_Change")) then
			CloseWindow("PetExterior_Change", true)
		end

	elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		PetExterior_Gain_CareObj(arg0,arg1,arg2)
		
	elseif ( event == "PET_EXTERIOR_ADD_COLLECTION" )  then
		
		local PetExteriorId = tonumber(arg0)
		local PetGuidH = tonumber(arg1)
		local PetGuidL = tonumber(arg2)
		if this:IsVisible() then
			PetExterior_Gain_UpdatePet(PetGuidH, PetGuidL)
			return
		end
	
	elseif ( event == "UPDATE_PETEXTERIOR_GAIN_ITEM" and this:IsVisible() ) then
		PetExterior_Gain_UpdateItem(arg0)

	elseif ( event == "UPDATE_PET_PAGE" and this:IsVisible() ) then
		PetExterior_Gain_Open()

	elseif ( event == "ADD_PET" or event == "DELETE_PET" ) then
	
		if this:IsVisible() then
			PetExterior_Gain_Hide()
		end

	elseif ( event == "REPLY_MISSION_PET" and this:IsVisible() ) then
		PetExterior_Gain_Selected(arg0)

	elseif ( event == "UNIT_MONEY" and this:IsVisible() ) then
		PetExterior_Gain_UpdateMoney()

	elseif ( event == "MONEYJZ_CHANGE" and this:IsVisible() ) then
		PetExterior_Gain_UpdateJZ()

	elseif ( event == "BUY_ITEM" and this:IsVisible() ) then		
		local g_ItemID = tonumber(arg1)	
		if (g_ItemID ~= -1) then
			local nextPos = PlayerPackage:GetBagPosByItemIndex(g_ItemID)
			if nextPos >=0 then
				PetExterior_Gain_UpdateItem(nextPos)
			else
				PetExterior_Gain_Item_Resume()
			end
		end
		
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		if ( arg0 ~= nil and -1 == tonumber(arg0)) then
			return
		end

		if tonumber(arg0) == g_PetExterior_Gain_ItemPos then
			if (g_PetExterior_Gain_NeedItem ~= -1) then
				local nextPos = PlayerPackage:GetBagPosByItemIndex(g_PetExterior_Gain_NeedItem)
				if nextPos >=0 then
					PetExterior_Gain_UpdateItem(nextPos)
				else
					PetExterior_Gain_Item_Resume()
				end
			else
				PetExterior_Gain_Item_Resume()
			end
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
	
		PetExterior_Gain_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		
		PetExterior_Gain_Frame_On_ResetPos()
	
	elseif event == "HIDE_ON_SCENE_TRANSED" then
	
		PetExterior_Gain_Hide()

	end
	
end

--*************************************************
--显示犱兽拓印界面
--*************************************************
function PetExterior_Gain_Open()

	PetExterior_Gain_ClearItem()

	PetExterior_Gain_Clear()

	Pet:ShowPetList(0)
	Pet:ShowPetList(1)
	
	this:Show()
	
	--OpenWindow("Packet")--打开背包
	
	PetExterior_Gain_UpdateMoney()	
	PetExterior_Gain_UpdateJZ()
	
end

--*************************************************
--显示交子
--*************************************************
function PetExterior_Gain_UpdateJZ()

	PetExterior_Gain_SelfJiaozi:SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	
end

--*************************************************
--显示金钱
--*************************************************
function PetExterior_Gain_UpdateMoney()

	PetExterior_Gain_SelfMoney:SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
	
end

--*************************************************
--关心NPC
--*************************************************
function PetExterior_Gain_CareObj(careId, op, distance)
	
	if(nil == careId or nil == op or nil == distance) then
		return
	end

	if(tonumber(careId) ~= g_clientNpcId) then
		return
	end

	if (op == "distance" and tonumber(distance) > MAX_OBJ_DISTANCE or op == "destroy") then
		PetExterior_Gain_Hide()
	end
	
end

--*************************************************
--打开选择犱兽界面
--*************************************************
function PetExterior_Gain_SelectPet_Clicked()

	Pet:ShowPetList(0)
	Pet:ShowPetList(1)
	
end

--*************************************************
--选择不同犱兽时，设置不同的犱兽模型
--*************************************************
function PetExterior_Gain_Selected(selidx)
	
	local nSeletedIndex = tonumber(selidx)

	if (-1 == nSeletedIndex) then
		return
	end
	
	--犱兽已被其它界面选中
	if (Pet:GetPetLocation(nSeletedIndex) ~= -1) then
		return
	end

	PetExterior_Gain_Clear()
	
	g_PetExterior_Gain_PetIdx = tonumber(nSeletedIndex)
	
	local strName, strName2 = Pet:GetName(g_PetExterior_Gain_PetIdx)
	PetExterior_Gain_Pet_Text:SetText(strName)
	
	PetExterior_Gain_FakeObject:SetFakeObject("")
	Pet:Lua_UpdatePetExteriorGainModel(g_PetExterior_Gain_PetIdx)
	PetExterior_Gain_FakeObject:SetFakeObject("Pet_ExteriorGain")
	Pet:SetPetLocation(g_PetExterior_Gain_PetIdx, 17)
	Pet:UpdatePetList()

	PetExterior_Gain_Money:SetProperty("MoneyNumber", tostring(g_PetExterior_Gain_NeedMoney))
	
end

--*************************************************
--刷新犱兽
--*************************************************
function PetExterior_Gain_UpdatePet(PetGuidH, PetGuidL)

	if PetGuidH > 0 and PetGuidL > 0 then
		local newIdx = Pet:GetPetIndexByGUID( PetGuidH, PetGuidL )
		if newIdx ~= nil and newIdx ~= -1 then
			if g_PetExterior_Gain_PetIdx ~= -1 then
				Pet:SetPetLocation(g_PetExterior_Gain_PetIdx,-1)	
			end		
			PetExterior_Gain_Selected(newIdx)
		end
	end
	
end

--*************************************************
--更新界面道具信息
--*************************************************
function PetExterior_Gain_UpdateItem( pos_packet )
	
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber( pos_packet )
	--是否加锁....
	if (PlayerPackage:IsLock(BagPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--更新犱兽拓印材料界面
	local ItemID = PlayerPackage:GetItemTableIndex( BagPos )
	if ( ItemID <= 0) then
		PushDebugMessage("#{ZSHF_20230705_16}")
		return
	end
	
	if ItemID ~= g_PetExterior_Gain_NeedItem then
		PushDebugMessage("#{ZSHF_20230705_16}")
		return
	end

	if (g_PetExterior_Gain_ItemPos ~= -1) then
		LifeAbility:Lock_Packet_Item( g_PetExterior_Gain_ItemPos, 0 )
	end

	LifeAbility:Lock_Packet_Item( BagPos, 1 )
	g_PetExterior_Gain_ItemPos = BagPos

	local theAction = EnumAction( BagPos, "packageitem" )
	if (theAction:GetID() == 0) then
		return
	end
	PetExterior_Gain_Item:SetActionItem( theAction : GetID() )
	
end

--*************************************************
--右键点击ActionButton
--*************************************************
function PetExterior_Gain_Item_Resume()

	PetExterior_Gain_ClearItem()
	
end

--*************************************************
--清除道具
--*************************************************
function PetExterior_Gain_ClearItem()
	
	if g_PetExterior_Gain_ItemPos ~= -1 then
		LifeAbility:Lock_Packet_Item( g_PetExterior_Gain_ItemPos, 0 )
		PetExterior_Gain_Item:SetActionItem( -1 )
		g_PetExterior_Gain_ItemPos = -1
	end
	
end

--*************************************************
--清除界面
--*************************************************
function PetExterior_Gain_Clear()
	
	PetExterior_Gain_FakeObject:SetFakeObject("")
	
	if (-1 ~= g_PetExterior_Gain_PetIdx) then
		Pet:SetPetLocation(g_PetExterior_Gain_PetIdx, -1)
		Pet:UpdatePetList()
	end
	g_PetExterior_Gain_PetIdx = -1
	
	g_PetExterior_Gain_ExteriorId = -1
	
	PetExterior_Gain_FakeObject_TimesText:SetText("")
	
	PetExterior_Gain_Pet_Text:SetText("")
	
	PetExterior_Gain_Money:SetProperty( "MoneyNumber", 0 )
	
end

--*************************************************
--关睜犱兽拓印界面
--*************************************************
function PetExterior_Gain_Hide()

	if (g_clientNpcId ~= -1) then
		this:CareObject(g_clientNpcId, 0, "PetExterior_Gain")
	end

	this:Hide()

end

--*************************************************
--关睜界面
--*************************************************
function PetExterior_Gain_OnHidden()

	PetExterior_Gain_Hide()

	PetExterior_Gain_ClearItem()
	
	PetExterior_Gain_Clear()
	
	Pet:ShowPetList(0)
	
end

--*************************************************
--确定按钮
--*************************************************
function PetExterior_Gain_OK_Clicked()

	--增加15级判断
	local mylevel = Player:GetData("LEVEL");
	if mylevel < 15 then
		PushDebugMessage("#{ZSHF_20230705_24}")
		return 0
	end
	
	--判断电话密保和二级密码保护2012.6.12-LIUBO
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return 0
	end
	
	--是否选择犱兽
	if (-1 == g_PetExterior_Gain_PetIdx) then
		PushDebugMessage("#{ZSHF_20230705_20}")
		return 0
	end
	
	local nExteriorId = Pet:Lua_GetPetExteriorIdByPetIdx(g_PetExterior_Gain_PetIdx)
	if nExteriorId == nil or nExteriorId == -1 then
		PushDebugMessage("#{ZSHF_20230705_111}")
		return 0
	end

	--是否在出牻
	local petname,status = Pet:GetPetList_Appoint(g_PetExterior_Gain_PetIdx)
	if (status == "on_fight") then
		PushDebugMessage("#{ZSHF_20230705_27}")
		return 0
	end

	--是否在附体
	local petname,status = Pet:GetPetList_Appoint(g_PetExterior_Gain_PetIdx)
	if (status == "on_possession") then
		PushDebugMessage("#{ZSHF_20230705_28}")
		return 0
	end
	
	--判断是否为犱兽宝宝
	if (Pet:GetPetType(g_PetExterior_Gain_PetIdx) == 0) then
		PushDebugMessage("#{ZSHF_20230705_141}")
		return 0
	end

	--是否幻化
	--local gen = Pet:GetType(g_PetExterior_Gain_PetIdx)
	--if gen == nil or gen >= 100 then	--100以上为幻化犱兽
	--	PushDebugMessage("#{ZSHF_20230705_76}")
	--	return 0
	--end

	--道具
	if (-1 == g_PetExterior_Gain_ItemPos) then 
		PetExterior_Gain_YuanbaoBuyAsk()
		return 0
	end

	--是否金钱足够
	local nHaveMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if (nHaveMoney < g_PetExterior_Gain_NeedMoney) then
		PushDebugMessage("#{ZSHF_20230705_78}")
		return 0
	end

	local nItemID = PlayerPackage : GetItemTableIndex( g_PetExterior_Gain_ItemPos )
	
	local hid,lid = Pet:GetGUID(g_PetExterior_Gain_PetIdx)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGainPetExterior")
		Set_XSCRIPT_ScriptID(g_PetExterior_Gain_ScriptId)
		Set_XSCRIPT_Parameter(0, g_serverNpcId)
		Set_XSCRIPT_Parameter(1, hid)
		Set_XSCRIPT_Parameter(2, lid)
		Set_XSCRIPT_Parameter(3, g_PetExterior_Gain_ItemPos)
		Set_XSCRIPT_Parameter(4, 1)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT();
	
	return 1
end

--*************************************************
--元宝购买确认
--*************************************************
function PetExterior_Gain_Check_Clicked()
	
	local check = tonumber(Pet:GetYuanbaoBuyState(g_PetExterior_Gain_YuanbaoPayType));
	
	if(check>=1)then
		PetExterior_Gain_PetList_Check:SetCheck(1);
		Pet:SetYuanbaoBuyState(g_PetExterior_Gain_YuanbaoPayType, 0);
	else
		PetExterior_Gain_PetList_Check:SetCheck(0);
		Pet:SetYuanbaoBuyState(g_PetExterior_Gain_YuanbaoPayType, 1);
	end	
	
end
function PetExterior_Gain_YuanbaoBuyAsk()
	
	local check = tonumber(Pet:GetYuanbaoBuyState(g_PetExterior_Gain_YuanbaoPayType));
	
	if check == 1 then
		--不提示 自动购买		
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("PetExterior_Gain_Yuanbao_Pay")
			Set_XSCRIPT_ScriptID(g_PetExterior_Gain_ScriptId)
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		return 
	elseif check == 0 then			
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("PetExterior_Gain_Yuanbao_Pay")
			Set_XSCRIPT_ScriptID(g_PetExterior_Gain_ScriptId)
			Set_XSCRIPT_Parameter(0,1)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		return
	else 
		return 
	end

end

--*************************************************
--向左旋转犱兽
--*************************************************
function PetExterior_Gain_Pet_Modle_TurnLeft(start)

	--向左旋转开始
	if(start == 1) then
		PetExterior_Gain_FakeObject:RotateBegin(-0.3)
	--向左旋转结束
	else
		PetExterior_Gain_FakeObject:RotateEnd()
	end
	
end

--*************************************************
--向右旋转犱兽
--*************************************************
function PetExterior_Gain_Pet_Modle_TurnRight(start)

	--向右旋转开始
	if(start == 1) then
		PetExterior_Gain_FakeObject:RotateBegin(0.3)
	--向右旋转结束
	else
		PetExterior_Gain_FakeObject:RotateEnd()
	end
	
end

function PetExterior_Gain_Frame_On_ResetPos()

	PetExterior_Gain_Frame:SetProperty("UnifiedPosition", g_PetExterior_Gain_UnifiedPosition);
	
end

