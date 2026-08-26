--  WuhunSkillUp
local m_UI_NUM = 20090723
local m_ObjCared = -1
local m_Equip_Idx = -1

local Skills = {}
local skillSelected = -1
local Kfs_Skill_ID = {}
--PreLoad
function WuhunSkillUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_SKILLUP")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
end

--OnLoad
function WuhunSkillUp_OnLoad()
	Skills[1] = WuhunSkillUp_Object2
	Skills[2] = WuhunSkillUp_Object3
	Skills[3] = WuhunSkillUp_Object4
end

--OnEvent
function WuhunSkillUp_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		WuhunSkillUp_BeginCareObj( Get_XParam_INT(0) );
		
		WuhunSkillUp_Update(-1)
		this:Show();
	elseif (event == "UPDATE_KFS_SKILLUP" and this:IsVisible() ) then
		
		if arg0 ~= nil then
			WuhunSkillUp_Update( tonumber(arg0) )
		end
	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunSkillUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunSkillUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		WuhunSkillUp_UICheck()
	end
end

--Update UI
function WuhunSkillUp_Update(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then

		if PlayerPackage:IsBagItemKFS( itemIdx ) ~= 1 then
			PushDebugMessage("#{WH_090729_13}")	--此处只能放入武魂。
			return
		end
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end
		
		WuhunSkillUp_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
	else
		WuhunSkillUp_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
	end
	WuhunSkillUp_UICheck()
end
--OnOK
function WuhunSkillUp_OK_Clicked()
	if m_Equip_Idx == -1 then
		return
	end

	if skillSelected == -1 then
		PushDebugMessage("#{WH_090729_26}") --请选择需要升级的技能
		return
	end
	
	local upSkillID = PlayerPackage:GetBagKfsSkillUpSkill(m_Equip_Idx , skillSelected )
	if upSkillID == -1 then
		PushDebugMessage("#{WH_090828_02}")  --该技能已经达到最高等级，不能继续升级！
		return
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	local needMoney = PlayerPackage:GetBagKfsSkillUpMoney(m_Equip_Idx , skillSelected )
	
	if selfMoney < needMoney then
		PushDebugMessage("#{WH_090729_18}")  --对不起，你身上金钱不足，无法继续进行
		return
	end

	PlayerPackage:Kfs_Op_Do(7 , m_Equip_Idx , skillSelected)
end


--select a skill
function WuhunSkillUp_Select_Skill(skill_index)

	Skills[1]:SetPushed(0)
	Skills[2]:SetPushed(0)
	Skills[3]:SetPushed(0)

	Skills[skill_index + 1]:SetPushed(1)
	skillSelected = skill_index

	local needMoney = PlayerPackage:GetBagKfsSkillUpMoney(m_Equip_Idx , skill_index )
	WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", needMoney); 
end

--Right button clicked
function WuhunSkillUp_Resume_Equip()

	WuhunSkillUp_Update(-1)

end


--Care Obj
function WuhunSkillUp_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--handle Hide Event
function WuhunSkillUp_OnHiden()

	WuhunSkillUp_Update(-1)

end


function WuhunSkillUp_UICheck()
	WuhunSkillUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunSkillUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", 0); 
	WuhunSkillUp_OK:Disable()

	Skills[1]:SetActionItem(-1)
	Skills[2]:SetActionItem(-1)
	Skills[3]:SetActionItem(-1)
	Skills[1]:SetPushed(0)
	Skills[2]:SetPushed(0)
	Skills[3]:SetPushed(0)
	Kfs_Skill_ID = {}
	
	if m_Equip_Idx ~= -1 then
		local nSumSkill = PlayerPackage:GetBagKfsSkillNum(m_Equip_Idx)
		if nSumSkill ~= nil and nSumSkill > 0 and nSumSkill < 4 then
			for i=1 ,3 do
				local skillID = PlayerPackage:GetBagKfsSkill(m_Equip_Idx , i - 1)
				if skillID ~= nil and skillID > 0 then
					Kfs_Skill_ID[i] = skillID
				else
					Kfs_Skill_ID[i] = -1
				end
			end
			
			local theAction_kfs = EnumAction(m_Equip_Idx, "packageitem");
			local kfsID = -1
			if theAction_kfs:GetID() ~= 0 then
				kfsID = theAction_kfs:GetItemID();
			end
			
			for i=1, nSumSkill do
				local theAction = EnumAction(kfsID * 3 + i -1 , "kfsskill");
				if theAction:GetID() ~= 0 then
					Skills[i]:SetActionItem(theAction:GetID());
				end
			end
			
			if skillSelected ~= -1  then
				Skills[skillSelected + 1]:SetPushed(1)	
				local needMoney = PlayerPackage:GetBagKfsSkillUpMoney(m_Equip_Idx , skillSelected )
				WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", needMoney); 
			end
		else
			skillSelected = -1	--没有技能
		end
	else
		skillSelected = -1  --武魂栏 空
	end
	
	if m_Equip_Idx ~= -1 then
		WuhunSkillUp_OK:Enable()
	end

end