-- !!!reloadscript =AnqiShuxingNEW
-- 10155001	·É»ÈÊ¯
-- 10155002	±ùÆÇÉñ ë
-- 10155003	Ã·»¨ïÚ
-- !!createitem = 10155002 = 1=1
-- !!createitem = 30503118 = 1=100

--°µÆ÷ ÊôÐÔµ÷ ûÒ³Ãæ
local MAX_OBJ_DISTANCE = 3.0;
local objCared = -1;
local g_Object = -1;
local AnqiShuxingNEW_g_CommandType = 1
local Dark_Bag_Index = -1
local Dark_Attr_Name = {[1] = "#{equip_attr_str}",[2] = "#{equip_attr_spr}",[3] = "#{equip_attr_con}",[4] = "#{equip_attr_int}",[5] = "#{equip_attr_dex}",}

-- 0±íÊ¾Ã»ÓÐ½øÐÐ¹ýÖØÏ´ 1 ±íÊ¾ÖØÏ´Íê³É
local Dark_chongxi_state =0

function AnqiShuxingNEW_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RESUME_ENCHASE_GEM");           --??\ClientLib\Ui_cegui\UISystem.cpp,line:1018
	--½ðÇ®¸Ä±äµÄ´¦Àí
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");

	-- new

	this:RegisterEvent("UI_REGEN_DARKITEM");
	-- this:RegisterEvent("CLEAN_ANQI_DATA");
	this:RegisterEvent("DARK_SKILL_UPDATE_RECOIN");
	this:RegisterEvent("DARK_SKILL_RECOIN_CONFIRM_OK");


end

function AnqiShuxingNEW_OnLoad()
	--Dark_Button = AnqiShuxingNEW_BeforeIcon;
	--Dark_New_Button = AnqiShuxingNEW_AfterIcon;
	Dark_chongxi_state =0;
end

function AnqiShuxingNEW_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 800034) then
		if this : IsVisible() then									-- ??????,????
			AnqiShuxingNEW_Close();
		end

		objCared = -1;
		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);

		if objCared == -1 then
				PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
				return;
		end
		AnqiShuxingNEW_BeginCareObject(objCared);

		AnqiShuxingNEW_g_CommandType = Get_XParam_INT(0);
		if AnqiShuxingNEW_g_CommandType ==6 then
			AnqiShuxingNEW_InitDlg();
		end
	elseif (event == "UI_COMMAND" ) and tonumber(arg0) == 8000341 then
		AnqiShuxingNEW_Reset(0)
		AnqiShuxingNEW_Update(Dark_Bag_Index)

	elseif (event == "UI_REGEN_DARKITEM" and this:IsVisible()) then

			AnqiShuxingNEW_Update(arg0);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

	--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then

			--È¡Ïû¹ØÐÄ
			AnqiShuxingNEW_Close()
		end
	elseif(event == "RESUME_ENCHASE_GEM" and this:IsVisible())then
		if(tonumber(arg0) == 140) then
			AnqiShuxingNEW_Clear();
		end
	elseif( (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and this:IsVisible()) then
		AnqiShuxingNEW_UpdateMoneyDisp();

	-- elseif(event == "CLEAN_ANQI_DATA" and this:IsVisible()) then
		-- AnqiShuxingNEW_Update(arg0);
	--ÖØÏ´°µÆ÷¼¼ÄÜÉú³ÉÐÂµÄÊý¾Ý
	elseif (event == "DARK_SKILL_UPDATE_RECOIN" and this:IsVisible()) then
			AnqiShuxingNEW_UpDateRecoin();

	elseif (event == "DARK_SKILL_RECOIN_CONFIRM_OK") then
		if tonumber(arg1) == 1 then
			AnqiShuxingNEW_Reset(1) --????????
			AnqiShuxingNEW_Update(arg0) --?????~
		elseif tonumber(arg1) == 0 then
			AnqiShuxingNEW_Reset(1)
			this:Hide()
		elseif tonumber(arg1) == 2 then
			AnqiShuxingNEW_Reset(1) --????????
		end
	end
end

function AnqiShuxingNEW_UpdateMoneyDisp()
		local playerMoney = Player:GetData("MONEY");
		local playerMoneyJZ = Player:GetData("MONEY_JZ");
		AnqiShuxingNEW_WantNum:SetProperty("MoneyMaxNumber", playerMoney + playerMoneyJZ);
		--AnqiShuxing_NeedMoney:SetProperty("MoneyNumber", nNeed);
		AnqiShuxingNEW_HaveNum:SetProperty("MoneyNumber", playerMoneyJZ);
		AnqiShuxingNEW_HaveGoldNum:SetProperty("MoneyNumber", playerMoney);
end

function AnqiShuxingNEW_InitDlg( )
--	if (AnqiShuxingNEW_g_CommandType == 6) then   --ÖØÏ´°µÆ÷¼¼ÄÜ
	--ÖØÏ´°µÆ÷¼¼ÄÜ
		AnqiShuxingNEW_Reset(1)
		AnqiShuxingNEW_DragTitle:SetText("#{FBSJ_081209_80}");
		--Èç¹û¶Ô°µÆ÷ÁìÎòµÄ¼¼ÄÜ²»ÂúÒâ£¬¿ÉÒÔÊ¹ÓÃÍüÎÞÊ¯½«¼¼ÄÜÖØÏ´¡£ÖØÏ´ºó¿ÉÑ¡ÔñÊ¹ÓÃÐÂµÄ¼¼ÄÜ»ò±£ÁôÔ­ÓÐ¼¼ÄÜ¡£
--×¢Òâ£ºÖØÏ´Ê±°µÆ÷µÄËùÓÐ¼¼ÄÜ¶¼½«±»ÖØÖÃ¡£ÖØÏ´Íê³ÉºóÈç¹ûÄú½øÐÐ¹Ø± ÖØÏ´¼¼ÄÜ½çÃæ¡¢È¡Ïû°µÆ÷·ÅÈë×´Ì¬¡¢¸ü»»ÒÑ·ÅÈëµÄ°µÆ÷µÈ²Ù×÷£¬¾ùÊÓÎª±£ÁôÔ­ÓÐ¼¼ÄÜ²Ù×÷¡£

		AnqiShuxingNEW_Info:SetText("#{FBSJ_081209_56}");
		--Çë·ÅÈë°µÆ÷
		AnqiShuxingNEW_BeforeText:SetText("#{CXYH_140813_1}");
		--
		AnqiShuxingNEW_UpdateMoneyDisp();
		AnqiShuxingNEW_WantNum:SetProperty("MoneyNumber", 50000);
		this:Show();
		AnqiShuxingNEW_OK:Disable();

--	end
end

function AnqiShuxingNEW_OK_Clicked()

	--Ò»¹²ÈýÏîÐèÒª°²È«¼ì²é: ÖØÏ´°µÆ÷Ô­Ê¼ÊôÐÔ;ÖØÏ´°µÆ÷¼¼ÄÜ;ÖØÖÃ°µÆ÷ÐÞÁ¶µÈ¼¶

	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
		-- ÅÐ¶ÏÊÇ·ñÎª°²È«Ê±¼ä ÔÚ°²È«Ê±¼äÄÚÎÞ·¨½øÐÐ´Ë²Ù×÷¡£´ò¿ª°ü¹üÀ¸£¬µã»÷·ÀµÁºÅ°´Å¥¿ÉÒÔ×ÔÐÐÉèÖÃ°²È«Ê±¼ä¡£
	-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	-- 	PushDebugMessage("#{CXYH_140813_11}")
	-- 	return
	-- end

	--Ó²¼þÃÜ±£
	--³©ÓÎ+
	--µç»°ÃÜ±£
	--¶þ¼¶ÃÜÂë

	--ÅÐ¶Ï¸ß¼¶ÃÜ±£ ¶Ô²»Æð£¬ÄúÐèÒª½âËøÓ²¼þÃÜ±£ÔÙ½øÐÐÒÔÏÂ²Ù×÷¡£
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		PushDebugMessage("#{CXYH_140813_12}")
		return
	end

	--ÇëÏÈ·ÅÈë°µÆ÷¡£
	if (Dark_Bag_Index == -1) then
		PushDebugMessage("#{CXYH_140813_16}")
	end

	--ÊÇ·ñÓÐÎïÆ· È±ÉÙµÀ¾ßÍüÎÞÊ¯»ò ß±³°üÖÐµÄÍüÎÞÊ¯ÒÑ¼ÓËø£¡

	local EquipPoint = LifeAbility : Get_Equip_Point(Dark_Bag_Index)
	if (EquipPoint ~= 17) then
		PushDebugMessage("#{FBSJ_081209_37}")
	end
	--¿Í»§¶ËÔ¤ÏÈÅÐ¶Ï½ðÇ®£¬¼õÇá·þÎñÆ÷Ñ¹Á¦
	local nHave = AnqiShuxingNEW_WantNum:GetProperty("MoneyMaxNumber");
	local nNeed = AnqiShuxingNEW_WantNum:GetProperty("MoneyNumber");
	if (tonumber(nNeed) > tonumber(nHave)) then
		PushDebugMessage("#{CXYH_140813_19}");
		return;
	end
	--Ï´¼¼ÄÜ

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("DarkSkillAdjustForBagItem");
		Set_XSCRIPT_ScriptID(332207);
		Set_XSCRIPT_Parameter(0,Dark_Bag_Index);
		Set_XSCRIPT_Parameter(1,0);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();

		--ÉèÖÃÖØÏ´×´Ì¬
--	Dark_chongxi_state =1

end


function AnqiShuxingNEW_Cancel_Clicked()
	AnqiShuxingNEW_Close();
end

function AnqiShuxingNEW_Clear()
	if Dark_Bag_Index ~= -1 and Dark_chongxi_state == 1  then
		AnqiShuxingNEW_SendDarkSkillConfirm(Dark_Bag_Index,2)
		return
	end
	AnqiShuxingNEW_Reset(1)
end


function AnqiShuxingNEW_Update(Item_index)

	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");

	if theAction:GetID() ~= 0 then

		if Dark_Bag_Index ~= -1 and i_index ~= Dark_Bag_Index and  Dark_chongxi_state == 1  then

		--¶þ´ÎÈ·ÈÏ¿ò
			AnqiShuxingNEW_SendDarkSkillConfirm(i_index,1)
		-- Èç¹û¿ ¸ñÄÚÒÑ¾­ÓÐ¶ÔÓ¦ÎïÆ·ÁË,ÐèÒªµ¯Ò»¸ö¶þ´ÎÈ·ÈÏ¡­¡­
			return
		end

		--ÏÈ°Ñ¶ÔÏó¸øÇåÁË
		AnqiShuxingNEW_Reset(1);

		AnqiShuxingNEW_BeforeIcon:SetActionItem(theAction:GetID());
		Dark_Bag_Index = i_index;
		LifeAbility : Lock_Packet_Item(i_index,1);
		AnqiShuxingNEW_OK:Enable();

		local icon =  tostring(LifeAbility : Get_Item_Icon_Name(i_index))

		AnqiShuxingNEW_AfterIcon:SetProperty("Image",icon)

		--ÏÔÊ¾¼¼ÄÜ
		local desc0,desc1,desc2 = DataPool:GetDarkSkillDesc(i_index)
		AnqiShuxingNEW_BeforeAttrFirst:SetText("#c009933#{FBSJ_081209_71}"..desc0)
		AnqiShuxingNEW_BeforeAttrSecond:SetText("#c009933#{FBSJ_081209_72}"..desc1)
		AnqiShuxingNEW_BeforeAttrThird:SetText("#c009933#{FBSJ_081209_73}"..desc2)
	end

end
--¸üÐÂ¼¼ÄÜÖØÐÂºóÊôÐÔ
function AnqiShuxingNEW_UpDateRecoin()

	local desc0,desc1,desc2 = DataPool:GetDarkSkillNewDesc()
	AnqiShuxingNEW_AfterAttrFirst:SetText("#c009933#{FBSJ_081209_71}"..desc0)
	AnqiShuxingNEW_AfterAttrSecond:SetText("#c009933#{FBSJ_081209_72}"..desc1)
	AnqiShuxingNEW_AfterAttrThird:SetText("#c009933#{FBSJ_081209_73}"..desc2)

--	AnqiShuxingNEW_YUANSHI:Enable()
	AnqiShuxingNEW_TIHUAN:Enable()
	Dark_chongxi_state =1
end


function AnqiShuxingNEW_Reset(cleanaction)
	Dark_chongxi_state =0
	AnqiShuxingNEW_BeforeIcon:SetActionItem(-1);
	AnqiShuxingNEW_OK:Disable();
--	AnqiShuxingNEW_YUANSHI:Disable();
	AnqiShuxingNEW_TIHUAN:Disable();


	AnqiShuxingNEW_AfterIcon:SetProperty("Image","")

	AnqiShuxingNEW_BeforeAttrFirst:SetText("")
	AnqiShuxingNEW_BeforeAttrSecond:SetText("")
	AnqiShuxingNEW_BeforeAttrThird:SetText("")

	AnqiShuxingNEW_AfterAttrFirst:SetText("")
	AnqiShuxingNEW_AfterAttrSecond:SetText("")
	AnqiShuxingNEW_AfterAttrThird:SetText("")
	if cleanaction == 1 then
		if (Dark_Bag_Index ~= -1) then
			LifeAbility : Lock_Packet_Item(Dark_Bag_Index,0);
			Dark_Bag_Index = -1;
		end
	end


end

function AnqiShuxingNEW_Close()
	--¹Ø± Ç°Ò²ÒªÀ´¸ö¶þ´ÎÈ·ÈÏ
	if Dark_Bag_Index ~= -1 and  Dark_chongxi_state == 1 then
		AnqiShuxingNEW_SendDarkSkillConfirm(Dark_Bag_Index,0)
		return
	end
	AnqiShuxingNEW_Reset(1);
	this:Hide()
	AnqiShuxingNEW_StopCareObject(objCared)
end

function AnqiShuxingNEW_SaveChange_Clicked(nGiveUp)

	if Dark_chongxi_state ==1 then

 		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("DoRefreshDarkSkill");
			Set_XSCRIPT_ScriptID(332207);
			Set_XSCRIPT_Parameter(0,Dark_Bag_Index);
			Set_XSCRIPT_Parameter(1,nGiveUp);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end

		--ÉèÖÃÖØÏ´×´Ì¬
	Dark_chongxi_state =0

	AnqiShuxingNEW_Reset(0)
	AnqiShuxingNEW_Update(Dark_Bag_Index)

end

--·¢ËÍÌæ»»°µÆ÷¼¼ÄÜµÄ¶þ´ÎÈ·ÈÏ
function AnqiShuxingNEW_SendDarkSkillConfirm(nIndex,keepopen)
	PushEvent("DARK_SKILL_RECOIN_CONFIRM",tostring(nIndex),tostring(keepopen))
end


--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function AnqiShuxingNEW_BeginCareObject(objCaredId)

	g_Object = objCaredId;

	this:CareObject(g_Object, 1, "AnqiShuxingNEW");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function AnqiShuxingNEW_StopCareObject(objCaredId)
	this:CareObject(objCaredId, 0, "AnqiShuxingNEW");
	g_Object = -1;


end
