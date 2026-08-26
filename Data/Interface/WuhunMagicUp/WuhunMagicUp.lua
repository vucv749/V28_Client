local m_UI_NUM = 20090721
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1

local UI_TYPE_ATTR	= 1
local UI_TYPE_COMPOUND	= 2
local UI_TYPE_LIFE	= 3
local UI_TYPE_SLOT	= 4

local m_UIType = 0

local m_Money_COMPOUND = {}

local INDEX_ATTRBOOK_BEGIN	= 30700214	--御·折冰属性书
local INDEX_ATTRBOOK_END	= 30700229	--暴·拔毒属性书

local INDEX_ADDLIFE = 30700233 --延寿丹

local INDEX_SLOT_ITEM1 = 20310158 --麟木剑
local INDEX_SLOT_ITEM2 = 20310159 --破天剑

local needMoney = 0

local needConfirm = 1
--PreLoad
function WuhunMagicUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_MAGICUP")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

--OnLoad
function WuhunMagicUp_OnLoad()
	--武魂合成消耗Money
	m_Money_COMPOUND[1] = 10000
	m_Money_COMPOUND[2] = 10000
	m_Money_COMPOUND[3] = 15000
	m_Money_COMPOUND[4] = 15000
	m_Money_COMPOUND[5] = 20000
	m_Money_COMPOUND[6] = 20000
	m_Money_COMPOUND[7] = 25000
	m_Money_COMPOUND[8] = 25000
	m_Money_COMPOUND[9] = 30000


end

--OnEvent
function WuhunMagicUp_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		local npcid = Get_XParam_INT(0) 
		if npcid ~= -1 then
			WuhunMagicUp_BeginCareObj(npcid);
		end
		m_UIType = Get_XParam_INT(1)
		
		if m_UIType == UI_TYPE_ATTR then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(22)}")	--扩展属性学习
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(23)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(24)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(25)}")
		
		elseif m_UIType == UI_TYPE_COMPOUND then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(18)}")	--合成
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(19)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(20)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(21)}")
		
		elseif m_UIType == UI_TYPE_LIFE then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(42)}")	--增加寿命
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(43)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(44)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(45)}")
		
		elseif m_UIType == UI_TYPE_SLOT then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(84)}")	--开辟属性栏
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(85)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(86)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(87)}")
		end		

		WuhunMagicUp_Update(-1)
		WuhunMagicUp_Update_Sub(-1)
		this:Show();
	
	elseif (event == "UPDATE_KFS_MAGICUP" and this:IsVisible() ) then
		if m_UIType == UI_TYPE_COMPOUND then
			if arg1 ~= nil and tonumber(arg1) == 2 and arg0 ~= nil then
				if m_Equip_Idx ~= -1 then
					WuhunMagicUp_Update_Sub( tonumber(arg0) )
				else 
					WuhunMagicUp_Update( tonumber(arg0) )
				end
			elseif arg1 ~= nil and tonumber(arg1) == 1 and arg0 ~= nil then
				WuhunMagicUp_Update_Sub( tonumber(arg0) )
			elseif arg1 ~= nil and tonumber(arg1) == 0 and arg0 ~= nil then
				WuhunMagicUp_Update( tonumber(arg0) )
			end
		else
			if arg1 ~= nil and tonumber(arg1) == 0 and arg0 ~= nil then
				WuhunMagicUp_Update( tonumber(arg0) )
		
			elseif arg1 ~= nil and tonumber(arg1) == 2 and arg0 ~= nil then
				WuhunMagicUp_Update( tonumber(arg0) )
			
			elseif arg1 ~= nil and tonumber(arg1) == 1 and arg0 ~= nil then
				WuhunMagicUp_Update_Sub( tonumber(arg0) )
			end
		end
	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunMagicUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunMagicUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunMagicUp_Update(m_Equip_Idx)
		
		elseif  arg0 ~= nil and tonumber(arg0) == m_Equip_Item then
			WuhunMagicUp_Update_Sub(m_Equip_Item)
		
		end
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide()
	end
end

--Update UI
function WuhunMagicUp_Update(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if PlayerPackage:IsBagItemKFS( itemIdx ) ~= 1 then
			PushDebugMessage("#{WH_090729_13}") -- 此处只能放入武魂。
			return
		end
		
		if m_UIType == UI_TYPE_COMPOUND then
			
			local main_lv = PlayerPackage:GetBagKfsData(itemIdx  , "EXTRALEVEL")
			local sub_lv = PlayerPackage:GetBagKfsData(m_Equip_Item  , "EXTRALEVEL")
			
			if  main_lv ~= nil and sub_lv ~= nil and main_lv ~= sub_lv then 
				PushDebugMessage("#{WH_090729_17}")  --参与合成的武魂灵力等级需要等于要提升灵力等级的武魂
				return
			end

			main_lv = PlayerPackage:GetBagKfsData(itemIdx  , "NEEDLEVEL")
			sub_lv = PlayerPackage:GetBagKfsData(m_Equip_Item  , "NEEDLEVEL")
			if  main_lv ~= nil and sub_lv ~= nil and main_lv > sub_lv then 
				PushDebugMessage("#{WH_090729_16}") --参与合成的武魂携带等级不能小于要提升灵力等级的武魂。
				return
			end

			main_lv = PlayerPackage:GetBagKfsData(itemIdx  , "EXTRALEVEL")
			if main_lv ~= nil and main_lv == 10 then
				PushDebugMessage("#{WH_090729_14}")  --10级了
				return
			end
		elseif  m_UIType == UI_TYPE_ATTR then

			local slotNum = PlayerPackage:GetBagKfsData(itemIdx  , "SLOT")
			local attrNum = PlayerPackage:GetBagKfsAttrExNum(itemIdx)
			if attrNum >= slotNum and slotNum >= 0 then
				if m_Equip_Idx == itemIdx then
					WuhunMagicUp_Object1:SetActionItem(-1);			
					LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
					m_Equip_Idx = -1;
					return
				end
				
				PushDebugMessage("#{WH_090729_56}") -- 需要有空余的属性栏，才能学习扩展属性。
				return
			end
		elseif  m_UIType == UI_TYPE_SLOT then
			
			local comLv = PlayerPackage:GetBagKfsData(itemIdx  , "EXTRALEVEL")
			local slotNum = PlayerPackage:GetBagKfsData(itemIdx  , "SLOT")
			if comLv ~=nil and slotNum ~= nil and slotNum >= comLv then
				if m_Equip_Idx == itemIdx then
					WuhunMagicUp_Object1:SetActionItem(-1);			
					LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
					m_Equip_Idx = -1;
					return
				end
				if slotNum == 10 then
					PushDebugMessage("#{WH_090817_13}") -- 武魂的扩展属性栏数已经到达最大值10栏。
				else
					PushDebugMessage("#{WH_090729_50}") -- 该武魂不能开辟新的属性栏。提升灵力等级后，可以开辟新的属性栏。
				end
				return
			end
		end
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end
		
		WuhunMagicUp_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
		
	else
		WuhunMagicUp_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
	end
	WuhunMagicUp_UICheck();

end

function WuhunMagicUp_Update_Sub(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if m_UIType == UI_TYPE_ATTR then
			local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
			if itemID < INDEX_ATTRBOOK_BEGIN or itemID > INDEX_ATTRBOOK_END then
				PushDebugMessage("#{WH_090729_20}")  --此处只能放入武魂属性书。
				return
			end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_07}")	--道具上锁。
				return
			end
	
		elseif m_UIType == UI_TYPE_COMPOUND then
			if PlayerPackage:IsBagItemKFS( itemIdx ) ~= 1 then
				PushDebugMessage("#{WH_090729_13}")	--此处只能放入武魂。
				return
			end
			
			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_15}")	--被上锁的武魂不能作材料武魂。
				return
			end

			
			local gem_count = LifeAbility : GetEquip_GemCount( itemIdx )
			if gem_count ~= nil and gem_count > 0 then
				PushDebugMessage("#{WH_20090904_01}")	--WH_20090904_01 镶嵌有宝石的武魂不能作为合成材料！
				return
			end
			
			local haveDiaowen = LifeAbility : IsEquipHaveDiaowen( itemIdx )
			if haveDiaowen > 0 then
				PushDebugMessage("#{WHDW_210322_01}")	--有雕纹的武魂不能作为材料武魂
				return
			end			

			local main_lv = PlayerPackage:GetBagKfsData(m_Equip_Idx  , "NEEDLEVEL")
			local sub_lv = PlayerPackage:GetBagKfsData(itemIdx  , "NEEDLEVEL")
			if  main_lv ~= nil and sub_lv ~= nil and main_lv > sub_lv then 
				PushDebugMessage("#{WH_090729_16}") --参与合成的武魂携带等级不能小于要提升灵力等级的武魂。
				return
			end

			main_lv = PlayerPackage:GetBagKfsData(m_Equip_Idx  , "EXTRALEVEL")
			sub_lv = PlayerPackage:GetBagKfsData(itemIdx  , "EXTRALEVEL")
			if  main_lv ~= nil and sub_lv ~= nil and main_lv ~= sub_lv then 
				PushDebugMessage("#{WH_090729_17}")  --参与合成的武魂灵力等级需要等于要提升灵力等级的武魂
				return
			end
	
		elseif m_UIType == UI_TYPE_LIFE then
			local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
			if itemID ~=  INDEX_ADDLIFE then
				PushDebugMessage("#{WH_090729_36}") --此处只能放入武魂延寿丹。
				return
			end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_07}")	--道具已上锁
				return
			end
		elseif m_UIType == UI_TYPE_SLOT then
			local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
			if itemID ~=  INDEX_SLOT_ITEM1 and itemID ~= INDEX_SLOT_ITEM2 then
				PushDebugMessage("#{WH_090729_51}") --此处只能放入麟木箭、破天剑
				return
			end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_52}")	--道具已上锁
				return
			end
		end  

		if m_Equip_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		end
		WuhunMagicUp_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Item = itemIdx
	else
		WuhunMagicUp_Object2:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
	end

	WuhunMagicUp_UICheck()
end

--Care Obj
function WuhunMagicUp_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OnOK
function WuhunMagicUp_OK_Clicked()
	if m_Equip_Idx == -1 or m_Equip_Item == -1 then
		return
	end
	
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	
	if selfMoney < needMoney then
		PushDebugMessage("#{WH_090729_18}")  --对不起，你身上金钱不足，无法继续进行。
		return
	end
	
	if m_UIType == UI_TYPE_ATTR then
		PlayerPackage:Kfs_Op_Do(2 , m_Equip_Idx ,m_Equip_Item)

	elseif m_UIType == UI_TYPE_COMPOUND then
		local level = PlayerPackage:GetBagKfsData(m_Equip_Idx  , "EXTRALEVEL")
		if level == nil or level >= 7 then    --拉收 级别控制 客户端
			PushDebugMessage("#{WH_090828_04}")  --5级以上合成暂不开放。
			return
		end

		if CheckPhoneMibaoAndMinorPassword() ~= 1 then
			return
		end
		
		if needConfirm == 1 then
			PopComfirm_Alpha1("#{WH_090825_01}")  --由于材料武魂是绑定的，合成后的武魂也将与您绑定
			needConfirm = 0
			return
		end
		
		PlayerPackage:Kfs_Op_Do(3 , m_Equip_Idx,m_Equip_Item)
		
		WuhunMagicUp_Object1:SetActionItem(-1);	
		WuhunMagicUp_Object2:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		m_Equip_Item = -1
		m_Equip_Idx = -1
	
	elseif m_UIType == UI_TYPE_LIFE then
		PlayerPackage:Kfs_Op_Do(4 , m_Equip_Idx,m_Equip_Item)
	
	elseif m_UIType == UI_TYPE_SLOT then
		PlayerPackage:Kfs_Op_Do(9 , m_Equip_Idx,m_Equip_Item)
	end
end

--Right button clicked
function WuhunMagicUp_Resume_Equip()

	WuhunMagicUp_Update(-1)

end

--Right button clicked
function WuhunMagicUp_Resume_Item()
	
	WuhunMagicUp_Update_Sub(-1)

end

--handle Hide Event
function WuhunMagicUp_OnHiden()

	WuhunMagicUp_Update(-1)
	WuhunMagicUp_Update_Sub(-1)

end

function WuhunMagicUp_UICheck()
	WuhunMagicUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunMagicUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	WuhunMagicUp_DemandMoney : SetProperty("MoneyNumber", 0)
	WuhunMagicUp_OK:Disable()
	needConfirm = 1

	if m_Equip_Idx ~= -1 then
	
		if m_UIType == UI_TYPE_ATTR then
			needMoney = 80000
		
		elseif m_UIType == UI_TYPE_COMPOUND then
			local comLevel = PlayerPackage:GetBagKfsData(m_Equip_Idx  , "EXTRALEVEL")
			if comLevel ~= nil and comLevel > 0 and comLevel < 10 then
				needMoney = m_Money_COMPOUND[comLevel]
			end

		elseif m_UIType == UI_TYPE_LIFE then
			needMoney = 50000
		
		elseif m_UIType == UI_TYPE_SLOT then
			needMoney = PlayerPackage:GetBagKfsSlotMoney(m_Equip_Idx)
		end
		WuhunMagicUp_DemandMoney : SetProperty("MoneyNumber", needMoney)
	end
	
	if m_Equip_Idx ~= -1 and m_Equip_Item ~= -1 then
		WuhunMagicUp_OK:Enable()
	end
end


--Help
function WuhunMagicUp_Help_Clicked()
	if m_UIType == UI_TYPE_ATTR then
		Helper:GotoHelper("*WuhunExtraPropertyUp")
	elseif m_UIType == UI_TYPE_COMPOUND then
		Helper:GotoHelper("*WuhunMagicUp")
	elseif m_UIType == UI_TYPE_LIFE then
		Helper:GotoHelper("*Wuhun")
	elseif m_UIType == UI_TYPE_SLOT then
		Helper:GotoHelper("*WuhunExtraPropertyUp")
	end	

end