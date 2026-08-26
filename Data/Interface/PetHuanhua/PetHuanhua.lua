local m_UI_NUM = 20090804	--珍兽幻化

local m_PetIndex = -1
local m_ObjCared = -1
local m_needMoney = 0
local m_Comfirmed = 0

local m_KeepModel = -1

local g_PetHuanhua_Frame_UnifiedPosition;

function PetHuanhua_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- 玩家从列表选定一只珍兽
	this : RegisterEvent( "UPDATE_PET_PAGE" )						-- 玩家身上的珍兽数据发生变化，包括增加一只珍兽
	this : RegisterEvent( "DELETE_PET" )							-- 玩家身上减少一只珍兽
	this : RegisterEvent("UNIT_MONEY");
	this : RegisterEvent("MONEYJZ_CHANGE")	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end



function PetHuanhua_OnLoad()
	

	g_PetHuanhua_Frame_UnifiedPosition=PetHuanhua_Frame:GetProperty("UnifiedPosition");
end



function PetHuanhua_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber( arg0 ) == m_UI_NUM then
		
		if this : IsVisible() then
			return
		end

		PetHuanhua_BeginCareObj( Get_XParam_INT(0) );
		PetHuanhua_CleanUp()
		this:Show()
		m_Comfirmed = 0
		Pet : ShowPetList( 1 )
		PetHuanhua_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetHuanhua_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));

	elseif (event == "UNIT_MONEY" and this : IsVisible()) then
		PetHuanhua_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetHuanhua_UICheck()
	elseif (event == "MONEYJZ_CHANGE" and this : IsVisible()) then
		PetHuanhua_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		PetHuanhua_UICheck()
	elseif event == "REPLY_MISSION_PET" and this : IsVisible() then
		
		PetHuanhua_OnSelectPet( tonumber( arg0 ) )
	elseif event == "UPDATE_PET_PAGE"  and this:IsVisible() then
		PetHuanhua_CleanUp()
	elseif event == "DELETE_PET"  and this:IsVisible() then
		this:Hide()
	elseif (event == "ADJEST_UI_POS" ) then
		PetHuanhua_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetHuanhua_Frame_On_ResetPos()
	end

end


--Close
function PetHuanhua_Close_Window()
	this:Hide();
end

--OK
function PetHuanhua_OK_Clicked()
	if m_PetIndex == -1  then
		return
	end
	
	if m_KeepModel ~= 1 and m_KeepModel ~= 0 then
		PushDebugMessage("#{RXZS_090804_32}")      --您还没有选择幻化珍兽的外观！
		return
	end
	
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	
	if selfMoney < m_needMoney then
		PushDebugMessage("#{WH_090729_18}")  --对不起，你身上金钱不足，无法继续进行。
		return
	end

	local isExist = IsItemExist(30502005)
	if isExist == 0 then
		isExist = IsItemExist(30502006)
		if isExist == 0 then
			PushDebugMessage("#{RXZS_090804_6}")  --您身上缺少幻化材料：珍兽幻化丹。
			return
		end
	end

	local nChangeExteriorId = Pet:Lua_GetPetExteriorChangeDataByPetIdx(m_PetIndex)
	if nChangeExteriorId >= 0 then
		PushDebugMessage("#{ZSHF_20230705_92}")    --换肤珍兽不能幻化
		return
	end

	
	local hid,lid = Pet:GetGUID(m_PetIndex);
	if m_Comfirmed == 0 then
		Pet:PetHHComfirm(m_PetIndex ,m_KeepModel )
		m_Comfirmed = 1
	else
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "Pet_HH" )
			Set_XSCRIPT_ScriptID( 800124 )
			Set_XSCRIPT_Parameter( 0, hid )
			Set_XSCRIPT_Parameter( 1, lid )
			Set_XSCRIPT_Parameter( 2, m_KeepModel )
			Set_XSCRIPT_ParamCount( 3 )
		Send_XSCRIPT()
		m_Comfirmed = 0
	end
end

--Select Pet
function PetHuanhua_SelectPet_Clicked()
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end

--珍兽图鉴
function PetHuanhua_Pet_Show()
	if(not (Pet:IsPresent(m_PetIndex)) ) then
		return;
	end
	local transfomerID = Pet:GetHHChangeModel(m_PetIndex)
	if transfomerID ~= nil and transfomerID > 0 then
		Pet:HuanhuaOpenPetJian(m_PetIndex,0);
	end
end


--Change Model
function PetHuanhua_ChangeModel(mode)
	if  m_PetIndex == -1 then
		return
	end
	if IsWindowShow("PetJian") then
		CloseWindow("PetJian" ,true)
	end
	if m_KeepModel ~= mode then
		m_Comfirmed = 0
	end

	m_KeepModel = mode
	
	PetHuanhua_UICheck()
end


function PetHuanhua_Pet_Modle_TurnLeft( start )
	--向左旋转开始
	if(start == 1) then
		PetHuanhua_FakeObject:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetHuanhua_FakeObject:RotateEnd();
	end

end


function PetHuanhua_Pet_Modle_TurnRight( start )
	--向右旋转开始
	if(start == 1) then
		PetHuanhua_FakeObject:RotateBegin(0.3);
	--向右旋转结束
	else
		PetHuanhua_FakeObject:RotateEnd();
	end
end


function PetHuanhua_OnHidden()
	PetHuanhua_CleanUp()
	Pet : ShowPetList( 0 )
end


function PetHuanhua_OnSelectPet(petIndex)
	
	if( -1 == petIndex ) then
		return;
	end
	
	--珍兽已被其它界面选中
	if (Pet:GetPetLocation(petIndex) ~= -1) then
		return;
	end

	m_Comfirmed = 0


	--已幻化
	local gen = Pet:GetType(petIndex)
	if gen ~= nil and gen >= 100 then	--100以上为幻化珍兽
		PushDebugMessage("#{RXZS_090804_3}")    --你选择的珍兽已经完成幻化，不能再次幻化。
		return
	end
	
	--类型不符	
	local isCan = Pet:EnableHuanhua(petIndex)
	if isCan ~= 1 then 
		PushDebugMessage("#{RXZS_090804_5}")   --你选择的珍兽不符合幻化要求。
		return
	end
	
	--跟骨不足
	local savvy = Pet:GetSavvy(petIndex)
	if savvy ~= nil and savvy < 5 then
		PushDebugMessage("#{RXZS_090804_4}")    --你的珍兽悟性等级不足5级，不能进行幻化。
		return
	end
	
	--珍兽身上有装备	
	if Pet:IsPetHaveEquip(petIndex) == 1 then
		PushDebugMessage("#{RXZS_090804_2}")	--请先将珍兽装备卸下
		return
	end

	local nChangeExteriorId = Pet:Lua_GetPetExteriorChangeDataByPetIdx(petIndex)
	if nChangeExteriorId >= 0 then
		PushDebugMessage("#{ZSHF_20230705_92}")    --换肤珍兽不能幻化
		return
	end
	

	PetHuanhua_FakeObject:SetFakeObject("");
	Pet:SetSkillStudyModel(petIndex);

	PetHuanhua_FakeObject:SetFakeObject( "My_PetStudySkill" );
	
	
	--切换珍兽的时候，释放上一个珍兽
	if(m_PetIndex ~= -1) then
		Pet:SetPetLocation(m_PetIndex,-1);
	end

	m_PetIndex = petIndex;	--已经选好了珍兽
	Pet:SetPetLocation(m_PetIndex,5);
--	Pet:ClosePetSkillStudyMsgBox()
	PetHuanhua_ModeSelect:SetCheck(0)
	PetHuanhua_ModeSelect2:SetCheck(0)
	m_KeepModel = -1
	PetHuanhua_UICheck()
end
	

function PetHuanhua_CleanUp()
	
	Pet:SetPetLocation(m_PetIndex,-1);
	m_PetIndex = -1;
	
	PetHuanhua_FakeObject:SetFakeObject("");
	
	PetHuanhua_Money:SetProperty("MoneyNumber", 0 );
	PetHuanhua_Pet_Text:SetText("")
	PetHuanhua_OK:Disable()
	PetHuanhua_Jian:Disable()

	PetHuanhua_ModeSelect:SetCheck(0)
	PetHuanhua_ModeSelect:Disable()
	PetHuanhua_ModeSelect2:SetCheck(0)
	PetHuanhua_ModeSelect2:Disable()
	
	m_Comfirmed = 0
	m_KeepModel = -1
end

function PetHuanhua_UICheck()
	
	if  m_PetIndex ~= -1 then
		local isMoneyEnough = 0
		
		local szPetName,szOn = Pet:GetPetList_Appoint(m_PetIndex);
		if  szOn ~= "on_packa"  then 
			PetHuanhua_CleanUp()
			return
		end
		PetHuanhua_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY") );
		PetHuanhua_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")  );
		
		local strName , strName2 = Pet:GetName(m_PetIndex)
		PetHuanhua_Pet_Text:SetText(strName)	
		PetHuanhua_Jian:Enable()
		m_needMoney = Pet:GetHuanhuaMoney(m_PetIndex)
		if m_needMoney ~= nil then
			PetHuanhua_Money:SetProperty("MoneyNumber", m_needMoney );
			local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") 
			if selfMoney >= m_needMoney then
				isMoneyEnough = 1
			end
		end
		
		PetHuanhua_ModeSelect:Enable()
		local transfomerID = Pet:GetHHChangeModel(m_PetIndex)
		if transfomerID ~= nil and transfomerID > 0 then
			PetHuanhua_ModeSelect2:Enable()
			PetHuanhua_Jian:Enable()
		else
			PetHuanhua_ModeSelect2:SetCheck(0)
			PetHuanhua_ModeSelect2:Disable()
			PetHuanhua_Jian:Disable()
		end

		if isMoneyEnough == 1 then
			PetHuanhua_OK:Enable()
		else
			PetHuanhua_OK:Disable()
		end
	else
		PetHuanhua_Money:SetProperty("MoneyNumber", 0 );
		PetHuanhua_Pet_Text:SetText("")
		PetHuanhua_OK:Disable()
		PetHuanhua_Jian:Disable()

		PetHuanhua_ModeSelect:SetCheck(0)
		PetHuanhua_ModeSelect:Disable()
		PetHuanhua_ModeSelect2:SetCheck(0)
		PetHuanhua_ModeSelect2:Disable()
	end
end

--Care Obj
function PetHuanhua_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

function PetHuanhua_Frame_On_ResetPos()
  PetHuanhua_Frame:SetProperty("UnifiedPosition", g_PetHuanhua_Frame_UnifiedPosition);
end