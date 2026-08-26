-- äÊÞÐÞ¸ÄÆ÷ V7
--ÊÊÅä²ÔÉ½Ñ©¸´¹Å Ñ©Îè @WAYLEE 2024-2-16 14:25:21

local g_GameTools7_Frame_UnifiedPosition;
local g_nSelect_Index = -1; --?????
local XingGeList = {"Nhát gan","C¦n th§n","Trung thñc","Nhanh nh©n","Dûng cäm","Dñ Lßu 1","Dñ Lßu 2","Dñ Lßu 3","Dñ Lßu 4","Dñ Lßu 5"}
local StarId = -1
local PETSKILL_SKILL_EDIX = {}
local ETSKILL_SKILL_NAME = {}

function GameTools7_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_NOTIFY");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED" ); -- ????
end

function GameTools7_OnLoad()
	XueWuHuChi_GMV7Pet = GameTools7_Pet_FakeObject
	g_GameTools7_Frame_UnifiedPosition=GameTools7_Frame:GetProperty("UnifiedPosition");
	
	PETSKILL_SKILL_EDIX[1] = GameTools7_SkillEdix1
	PETSKILL_SKILL_EDIX[2] = GameTools7_SkillEdix2
	PETSKILL_SKILL_EDIX[3] = GameTools7_SkillEdix3
	PETSKILL_SKILL_EDIX[4] = GameTools7_SkillEdix4
	PETSKILL_SKILL_EDIX[5] = GameTools7_SkillEdix5
	PETSKILL_SKILL_EDIX[6] = GameTools7_SkillEdix6
	PETSKILL_SKILL_EDIX[7] = GameTools7_SkillEdix7
	PETSKILL_SKILL_EDIX[8] = GameTools7_SkillEdix8
	PETSKILL_SKILL_EDIX[9] = GameTools7_SkillEdix9
	PETSKILL_SKILL_EDIX[10] = GameTools7_SkillEdix10
	PETSKILL_SKILL_EDIX[11] = GameTools7_SkillEdix11
	PETSKILL_SKILL_EDIX[12] = GameTools7_SkillEdix12
	
	PETSKILL_SKILL_NAME[1] = GameTools7_SkillTxtName1
	PETSKILL_SKILL_NAME[2] = GameTools7_SkillTxtName2
	PETSKILL_SKILL_NAME[3] = GameTools7_SkillTxtName3
	PETSKILL_SKILL_NAME[4] = GameTools7_SkillTxtName4
	PETSKILL_SKILL_NAME[5] = GameTools7_SkillTxtName5
	PETSKILL_SKILL_NAME[6] = GameTools7_SkillTxtName6
	PETSKILL_SKILL_NAME[7] = GameTools7_SkillTxtName7
	PETSKILL_SKILL_NAME[8] = GameTools7_SkillTxtName8
	PETSKILL_SKILL_NAME[9] = GameTools7_SkillTxtName9
	PETSKILL_SKILL_NAME[10] = GameTools7_SkillTxtName10
	PETSKILL_SKILL_NAME[11] = GameTools7_SkillTxtName11
	PETSKILL_SKILL_NAME[12] = GameTools7_SkillTxtName12
	
	
end

function GameTools7_Init()
	--ÏÈÇå¿ µ±Ç°ÁÐ±í
	GameTools7_XingGeList:ResetList()
	for i = 1, table.getn(XingGeList) do
		GameTools7_XingGeList:AddTextItem(XingGeList[i], i)
	end	
end

function GameTools7_XingGe_ListBox_Selected()
	local str
	str,StarId = GameTools7_XingGeList:GetCurrentSelect()
	StarId = StarId - 1
	Pet_AskExtraData(StarId) --???????????
end

function GameTools7_OnEvent(event)
	if(event == "UI_COMMAND" and arg0 == "202004276" ) then
		GameTools7_HuChi(1) 
		GameTools7_FenYe6:SetCheck(1)
		this:Show();
		GameTools7_Init()
		GameTools7_UpdatePetList()	
		GameTools7_Pet_lock : Hide();
		GameTools7_PetAttack_Type : Hide();
		
	elseif ( event=="UI_COMMAND" and tonumber(arg0) == 202402161 ) and this : IsVisible() then
		GameTools7_HuChi(2)
		--¹Ø±  äÊÞ´°¿Ú
		if(IsWindowShow("Pet")) then
			CloseWindow("Pet", true)
		end
	
		-- äÊÞID
		local ID = Get_XParam_INT(0)
		GameTools7_PETIDEdix:SetText(ID)
		--µÈ¼¶
		local petLevel = Pet:GetLevel(g_nSelect_Index)
		GameTools7_LevelEdix:SetText(petLevel)
		--ÊÙÃü
		local strName = Pet : GetNaturalLife(g_nSelect_Index);
		GameTools7_lifeEdix:SetText(strName)
		--¿ìÀÖ
		strName = Pet:GetHappy(g_nSelect_Index);
		GameTools7_happyEdix:SetText( strName );		
		--ÎòÐÔ
		strName = Pet:GetSavvy(g_nSelect_Index);
		GameTools7_WuXingEdix:SetText(strName );
		
		--»ù´¡×ÊÖÊ
		strName = Pet:GetStrAptitude(g_nSelect_Index) --??
		GameTools7_LiLiangEdix:SetText(strName );
		strName = Pet:GetIntAptitude(g_nSelect_Index) --??
		GameTools7_LingQiEdix:SetText(strName );
		strName = Pet:GetPFAptitude(g_nSelect_Index)  --??
		GameTools7_TiLiEdix:SetText(strName );
		strName = Pet:GetStaAptitude(g_nSelect_Index) --??
		GameTools7_DingLiEdix:SetText(strName );
		strName = Pet:GetDexAptitude(g_nSelect_Index) --??
		GameTools7_ShenFaEdix:SetText(strName );
		
		--¸ù¹Ç
		strName = Pet:GetBasic(g_nSelect_Index);
		GameTools7_GenGuEdix:SetText(strName);
		--Ç±ÄÜ
		strName = Pet : GetPotential(g_nSelect_Index);
		GameTools7_RemainPointsEdix:SetText(strName);
		
		--ÊÇ·ñ²éÑ¯¹ý³É³¤ÂÊ
		local isState = Get_XParam_INT(1)
		if isState == 0 then
			GameTools7_ChengZhangLvButton:SetCheck(0)
			GameTools7_SuoDingButton2:SetCheck(0)
		elseif isState == 1 then
			GameTools7_ChengZhangLvButton:SetCheck(0)
			GameTools7_SuoDingButton2:SetCheck(1)
		elseif isState == 2 then
			GameTools7_ChengZhangLvButton:SetCheck(1)
			GameTools7_SuoDingButton2:SetCheck(0)
		elseif isState == 3 then
			GameTools7_ChengZhangLvButton:SetCheck(1)
			GameTools7_SuoDingButton2:SetCheck(1)
		end

		-- äÊÞÎåÎ¬ÊôÐÔ
		strName = Pet:GetStr(g_nSelect_Index)
		GameTools7_LiLiangAttrEdix:SetText(strName );
		strName = Pet:GetInt(g_nSelect_Index)
		GameTools7_LingQiAttrEdix:SetText(strName );
		strName = Pet:GetPF(g_nSelect_Index)
		GameTools7_TiLiAttrEdix:SetText(strName );
		strName = Pet:GetDex(g_nSelect_Index)
		GameTools7_DingLiAttrEdix:SetText(strName );
		strName = Pet:GetSta(g_nSelect_Index)
		GameTools7_ShenFaAttrEdix:SetText(strName );
		
		-- äÊÞÐÔ¸ñÀàÐÍ
		strName = Pet:GetAIType(g_nSelect_Index)
		StarId = strName
		GameTools7_XingGeList:SetCurrentSelect(strName);
		
		local g_petNum = DataPool:GetPetsOneTypeNum();

		--ÏÔÊ¾×Ô¶¨ÒåÃû×Ö
		local strName2 = ""
		strName,strName2 = Pet:GetName(g_nSelect_Index);
		GameTools7_PetNameEdix:SetText(strName);
		--Æ·ÖÖ
		GameTools7_XinXiTxt2:SetText("#YgI¯ng: #G"..strName2);
		
		-- äÊÞGUIDÏÔÊ¾
		local petGUID_H,petGUID_L,sex = Pet:GetID(g_nSelect_Index);
		
		GameTools7_XinXiTxt3:SetText("#YGUIDð¸a v¸ cao: #G"..petGUID_H);
		GameTools7_XinXiTxt4:SetText("#YGUIDÐê V¸: #G"..petGUID_L);
		if(sex == 1) then
			strName = "Gi¯ng ðñc";
		else
			strName = "Gi¯ng cái";
		end
		GameTools7_XinXiTxt1:SetText("#YTRân thú tính Bi®t: #G"..strName);
		--ÉÏ´Î·±Ö³µÈ¼¶
		local ProcreateLevel = Get_XParam_INT(2)
		GameTools7_LastProcreateEdix:SetText(ProcreateLevel);

		--³É³¤ÂÊ
		-- strName = Pet:GetGrowRate(g_nSelect_Index)
		strName = Get_XParam_INT(3)
		GameTools7_PetGrowEdix:SetText(strName);
		
		--ÓµÓÐ¾­Ñé
		strName,strName2 = Pet:GetExp(g_nSelect_Index);
		GameTools7_ExpEdix:SetText(strName);
		GameTools7_ExpTxt2:SetText("Kinh nghi®m hÕn mÑc cao nh¤t:"..strName2);
		
		--¹¥»÷ÌØÐÔ
		local strIcon = ""
		strName,strIcon = Pet:GetAttackTrait(g_nSelect_Index);
		if strIcon ~= "" then
			GameTools7_PetAttack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
			GameTools7_PetAttack_Type : SetToolTip(strName)
			GameTools7_PetAttack_Type : Show();
		end
		
		--Ëø¶¨
		if PlayerPackage:IsPetLock(g_nSelect_Index) == 1 then
			GameTools7_Pet_lock : Show();
			GameTools7_XinXiTxt8: Hide();
			local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(g_nSelect_Index);
			if( nUnlockElapsedTime ==0) then
				GameTools7_Pet_lock : SetProperty("Image","set:UIIcons image:Icon_Lock");
				GameTools7_Pet_lock : SetToolTip ("Ðã khóa");
			else
				local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime);
				GameTools7_Pet_lock : SetProperty("Image","set:CommonFrame6 image:NewLock");
				GameTools7_Pet_lock : SetToolTip (strLeftTime);
			end
		else
			GameTools7_Pet_lock : Hide();
			GameTools7_XinXiTxt8: Show();
		end
		
		--ÁéÐÔ
		local nLingXing = Pet:GetLixing(g_nSelect_Index);
		GameTools7_LingXingEdix:SetText(nLingXing);
	
		--ÅäÅ¼GUID¸ßÎ»
		strName = Get_XParam_STR(0)	
		GameTools7_PetPeiOuEdix1:SetText(strName);
		
		--ÅäÅ¼GUIDµÍÎ»
		local strLoverGUID = Pet:GetConsort(g_nSelect_Index)
		GameTools7_PetPeiOuEdix2:SetText(strLoverGUID)

		--¶ÁÈ¡¼¼ÄÜÐÅÏ¢
		for i=1,12 do
			local theSkillAction = Pet:EnumPetSkill(g_nSelect_Index, i - 1, "petskill")
			PETSKILL_SKILL_EDIX[i]:SetText(theSkillAction:GetDefineID()) 	--????ID
			PETSKILL_SKILL_NAME[i]:SetText(theSkillAction:GetName())		--??????
		end

	end
	if (event == "ADJEST_UI_POS" ) then
		GameTools7_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GameTools7_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
        this:Hide()	
	end
end

--»¥³â´¦Àí
function GameTools7_HuChi(index)
	if( this:IsVisible() and index == 1) then
		return
	else
		GameTools7_HuChi()	
	end
end

--¸üÐÂ äÊÞÁÐ±í
function GameTools7_UpdatePetList()
	-- ÏÈÇå¿ µ±Ç°ÁÐ±í
	GameTools7_PetList_List:ClearListBox();
	-- Ë¢ÐÂÁÐ±í
	local PetInListIndex = 0;
	for	i=0,9 do
		local szPetName,szOn = Pet:GetPetList_Appoint(i);
		if(szPetName ~= "") then
			GameTools7_PetList_List:AddItem(szPetName, PetInListIndex);
			GameTools7_PetList_List:SetItemTooltip( PetInListIndex, strToolTips );
			PetInListIndex = PetInListIndex + 1 ;	
		end
	end
end
--===============================================
-- Ñ¡ÖÐÁÐ±íÖÐµÄ äÊÞ
--===============================================
function GameTools7_PetList_List_Selected()
	g_nSelect_Index = GameTools7_PetList_List:GetFirstSelectItem();
end
--===============================================
-- Ñ¡Ôñ
--===============================================
function GameTools7_PetList_Choose_Click()
	g_nSelect_Index = GameTools7_PetList_List:GetFirstSelectItem();
	if( g_nSelect_Index == -1 )  then
		return;
	end
end
--===============================================
--¸ù¾ÝÑ¡ÔñµÄ äÊÞ£¬ÏÔÊ¾ÏàÓ¦µÄÏêÏ¸ÐÅÏ¢
--===============================================
function GameTools7_PetList_ShowTargetPet()
	g_nSelect_Index = GameTools7_PetList_List:GetFirstSelectItem();

	if( -1 == g_nSelect_Index ) then
		return;
	end
	Pet:ShowTargetPet(g_nSelect_Index);
end

function GameTools7_Frame_On_ResetPos()
	GameTools7_Frame:SetProperty("UnifiedPosition", g_GameTools7_Frame_UnifiedPosition);
end

function GameTools7_Close()
	this:Hide()
end
--¶ÁÈ¡Êý¾Ý
function GameTools7_DuQu_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n Ð§u thü tín TÑc Ðích cøc cßng")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ReadiPetInfo")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,g_nSelect_Index)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

-- äÊÞID
function GameTools7_PETID_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_PETIDEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,1) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end
--µÈ¼¶
function GameTools7_Level_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_LevelEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,2) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end
--ÊÙÃü
function GameTools7_life_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_lifeEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,3) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end
--¿ìÀÖ
function GameTools7_happy_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_happyEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,4) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end
--ÎòÐÔ
function GameTools7_WuXing_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_WuXingEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,5) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end
--ÊôÐÔ:Á¦ÁéÌå¶¨Éí
function GameTools7_ShuXing_Clicked(nIndex)
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = -1
	if nIndex == 1 then
		nNum = tonumber(GameTools7_LiLiangEdix:GetText())
	elseif nIndex == 2 then
		nNum = tonumber(GameTools7_LingQiEdix:GetText())
	elseif nIndex == 3 then
		nNum = tonumber(GameTools7_TiLiEdix:GetText())
	elseif nIndex == 4 then
		nNum = tonumber(GameTools7_DingLiEdix:GetText())
	elseif nIndex == 5 then
		nNum = tonumber(GameTools7_ShenFaEdix:GetText())
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,5+nIndex) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--¸ù¹Ç
function GameTools7_GenGu_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_GenGuEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,11) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end
--³É³¤ÂÊ
function GameTools7_PetGrow_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_PetGrowEdix:GetText())
	--ÓÃÓÚÐ§ÑéÊýÖµ£¬²ð·ÖÊ®Áù½øÖÆ
	local Hex = LuaFnFloatToHex(nNum/1000)  --IEEE754??
	local part1 = string.sub(Hex, 1, 4) -- ???4???
	local part2 = string.sub(Hex, 5)    -- ??5??????????????
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,12) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_Parameter(3,tonumber(part1,16))
		Set_XSCRIPT_Parameter(4,tonumber(part2,16))
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
end

--Ê£ÓàÇ±ÄÜ
function GameTools7_RemainPoints_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_RemainPointsEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,13) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end
--ÊÇ·ñ²éÑ¯¹ý³É³¤ÂÊ
function GameTools7_ChengZhangLv_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum1 = tonumber(GameTools7_ChengZhangLvButton:GetCheck())  -- 0 ?? 1
	local nNum2 = tonumber(GameTools7_SuoDingButton2:GetCheck())  -- 0 ?? 1
	local nNum = 0
	if nNum1 == 1 and nNum2 == 1 then
		nNum = 3
	elseif nNum1 == 1 and nNum2 == 0 then
		nNum = 2
	elseif nNum1 == 0 and nNum2 == 0 then
		nNum = 0
	elseif nNum1 == 0 and nNum2 == 1 then
		nNum = 1
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,14) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end
--ÉèÖÃÎåÎ¬ÊôÐÔÖµ
function GameTools7_ShuXingAttr_Clicked(nIndex)
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = -1
	if nIndex == 1 then
		nNum = tonumber(GameTools7_LiLiangAttrEdix:GetText())
	elseif nIndex == 2 then
		nNum = tonumber(GameTools7_LingQiAttrEdix:GetText())
	elseif nIndex == 3 then
		nNum = tonumber(GameTools7_TiLiAttrEdix:GetText())
	elseif nIndex == 4 then
		nNum = tonumber(GameTools7_DingLiAttrEdix:GetText())
	elseif nIndex == 5 then
		nNum = tonumber(GameTools7_ShenFaAttrEdix:GetText())
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,14+nIndex) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--ÐÔ¸ñ
function GameTools7_XingGe_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,20) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,StarId)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--ÐÞ¸Ä äÊÞÃû×Ö
function GameTools7_PetName_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local text = GameTools7_PetNameEdix:GetText()
	Talk:SendChatMessage("near", 
	string.format("&SYSDATA&,%s,%s,%s,%s,%s",
		("666661"),
		("ModifyPet"),
		("21"),
		(g_nSelect_Index),
		(text)
		)
	);
end

--ÅäÅ¼IDÐÞ¸Ä
function  GameTools7_PeiOu_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local Hex_H = GameTools7_PetPeiOuEdix1:GetText()
	local Hex_L = GameTools7_PetPeiOuEdix2:GetText()
	Hex_H = tonumber(Hex_H,16)
	Hex_L = tonumber(Hex_L,16)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,22) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,Hex_H)
		Set_XSCRIPT_Parameter(3,Hex_L)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--ÉÏ´Î·±Ö³Ê±¼ä
function GameTools7_LastProcreate_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_LastProcreateEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,23) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--µ±Ç°¾­ÑéÐÞ¸Ä
function GameTools7_Exp_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_ExpEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,24) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--´ò¿ªÍ¼¼ø
function GameTools7_Pet_Jian_Clicked()
	if(not (Pet:IsPresent(g_nSelect_Index)) ) then
		return;
	end
	Pet:PetOpenPetJian(g_nSelect_Index,"self");
end

--ÁéÐÔ
function GameTools7_LingXing_Clicked()
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_ExpEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,25) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--ÈÚºÏ¶È
function GameTools7_Si_Shu_Xing_Clicked(nIndex)
	if g_nSelect_Index == -1 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n thao tác Ðích cøc cßng")
		return -1
	end
	local nNum = tonumber(GameTools7_RongHeEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,26) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end


--²éÑ¯¼¼ÄÜ
function GameTools7_SkillCha_Clicked(index)

end

--ÐÞ¸Ä¼¼ÄÜ
function GameTools7_Skill_Clicked(index)
	local nNum1 = -1
	if index == 1 then
		nNum1 = tonumber(GameTools7_SkillEdix1:GetText())
	elseif index == 2 then
		nNum1 = tonumber(GameTools7_SkillEdix2:GetText())
	elseif index == 3 then
		nNum1 = tonumber(GameTools7_SkillEdix3:GetText())
	elseif index == 4 then
		nNum1 = tonumber(GameTools7_SkillEdix4:GetText())
	elseif index == 5 then
		nNum1 = tonumber(GameTools7_SkillEdix5:GetText())
	elseif index == 6 then
		nNum1 = tonumber(GameTools7_SkillEdix6:GetText())
	elseif index == 7 then
		nNum1 = tonumber(GameTools7_SkillEdix7:GetText())
	elseif index == 8 then
		nNum1 = tonumber(GameTools7_SkillEdix8:GetText())
	elseif index == 9 then
		nNum1 = tonumber(GameTools7_SkillEdix9:GetText())
	elseif index == 10 then
		nNum1 = tonumber(GameTools7_SkillEdix10:GetText())
	elseif index == 11 then
		nNum1 = tonumber(GameTools7_SkillEdix11:GetText())
	elseif index == 12 then
		nNum1 = tonumber(GameTools7_SkillEdix12:GetText())
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyPet")
		Set_XSCRIPT_ScriptID(666661)
		Set_XSCRIPT_Parameter(0,27 + index) 
		Set_XSCRIPT_Parameter(1,g_nSelect_Index)
		Set_XSCRIPT_Parameter(2,nNum1)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()	
	
end

--TAB½çÃæÇÐ»»
function GameTools7_ChangeTabIndex( nIndex )
 local nUI = 0
	if 1 == nIndex then
		nUI = 20200427
	elseif 2 == nIndex then
		nUI = 202004272
	elseif 3 == nIndex then
		nUI = 202004273
	elseif 4 == nIndex then
		nUI = 202004274
	elseif 5 == nIndex then
		nUI = 202004275
	elseif 6 == nIndex then
		---nUI = 202004276
		return
	elseif 7 == nIndex then
		nUI = 316022021
	end
	if nUI ~= 0 then
		PushEvent("UI_COMMAND", nUI)
		this:Hide();
	end
end

function GameTools7_HuChi()
    -- ÐèÒªÉèÖÃÎª¿ µÄ¶ÔÏóÁÐ±í
    local objectsToClear = {
        XueWuHuChi_Wuhun,
        XueWuHuChi_SnsGame,
        XueWuHuChi_Infant,
        XueWuHuChi_ShengWang,
        XueWuHuChi_DecorateWeapon,
        XueWuHuChi_SelfEquip,
        XueWuHuChi_PetPossJian,
        XueWuHuChi_PlayerFrame,
        XueWuHuChi_Weapon,
        XueWuHuChi_DressPaint,
        XueWuHuChi_HuanLing,
        XueWuHuChi_Pet,
        XueWuHuChi_InfantDressWash,
        XueWuHuChi_InfantDressPaint,
        XueWuHuChi_InfantDressCut
    }

    -- ÉèÖÃÐèÒªÇå¿ µÄ¶ÔÏóÎª¿ 
    for i=1,15 do
        if objectsToClear[i] then
            objectsToClear[i]:SetFakeObject("")
        end
    end

    -- ¹Ø± ´°¿Ú
    local windowsToClose = {
        "VIP_Shop",
        "YuanbaoShop",
        "ShowShop",
        "XuanShop",
        "NewExterior_PlayerFrame",
        "NewExterior_Weapon",
        "NewExterior_PetPossJian",
        "Shop_Fitting",
        "NewExterior_DressBox",
        "NewExterior_HairStyle",
        "NewExterior_Facestyle",
        "NewExterior_HuanHun",
        "SelfEquip"
    }

    for i=1,13 do
        if IsWindowShow(windowsToClose[i]) then
            CloseWindow(windowsToClose[i], true)
        end
    end
end
