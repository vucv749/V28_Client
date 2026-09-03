-- !!!reloadscript =SuperWeaponUpNEW
-- 30505816	Éñ±ø·û1¼¶
-- 30505817	Éñ±ø·û2¼¶
-- !!createitem = 30505816 = 1=100
-- !!createitem = 30505817 = 1=100

local ObjCaredIDID = -1
local g_ItemPos = -1
local g_NewId = -1
local g_NeedMoney = -1
local MAX_OBJ_DISTANCE = 3.0
local g_Accept_Clicked_Num = 0
-- local g_Is92ShenQi = 0
local g_SuperIsWashed =0
--=========================================================
--³£Á¿¶¨Òå
--=========================================================
--local MIN_MENPAI_IDX = 0
--local MAX_MENPAI_IDX = 8

function SuperWeaponUpNEW_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "OBJECT_CARED_EVENT" )
	this : RegisterEvent( "PACKAGE_ITEM_CHANGED" )
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )
	this : RegisterEvent( "UPDATE_SHENQIUP" )
	this : RegisterEvent( "RESUME_ENCHASE_GEM" )

	-- new
	this : RegisterEvent( "SUPERATTR_UPDATE_RECOIN" )
	this : RegisterEvent( "SUPER_ATTR_RECOIN_CONFIRM_OK" )

end

function SuperWeaponUpNEW_OnLoad()
	SuperWeaponUpNEW_Hide_RadioText();
	g_SuperIsWashed =0
end


--=========================================================
--ÊÂ¼şÏìÓ¦
--=========================================================
function SuperWeaponUpNEW_OnEvent( event )

	if event == "UI_COMMAND" and tonumber(arg0) == 19831114 then
		local targetId = Get_XParam_INT(0)
		ObjCaredID = DataPool : GetNPCIDByServerID( targetId )
		if ObjCaredID == -1 then
			--PushDebugMessage("server´«¹ıÀ´µÄÊı¾İÓĞÎÊÌâ¡£")
			return
		end
		ObjCaredIDID = targetId
		BeginCareObject_SuperWeaponUpNEW()
		SuperWeaponUpNEW_Clear(1)
		SuperWeaponUpNEW_MoneyUpdate()
		this : Show()
--	elseif (event == "UI_COMMAND" ) and tonumber(arg0) == 198311141 then

--		AnqiShuxingNEW_Update(g_ItemPos)

	elseif event == "UNIT_MONEY" then
		SuperWeaponUpNEW_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )

	elseif event == "MONEYJZ_CHANGE" then
		SuperWeaponUpNEW_HaveNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )

	elseif event == "OBJECT_CARED_EVENT" then
		if( tonumber(arg0) ~= ObjCaredID ) then
			return
		end
		if( arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1=="destroy" ) then
			SuperWeaponUpNEW_Close()
		end

	elseif event == "RESUME_ENCHASE_GEM" then
		SuperWeaponUpNEW_Resume_Equip_Gem()

	elseif event == "PACKAGE_ITEM_CHANGED" then
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if tonumber(arg0) == g_ItemPos then
			SuperWeaponUpNEW_Resume_Equip_Gem()
		end

	elseif event == "UPDATE_SHENQIUP" then
		if arg0 ~= nil then
			SuperWeaponUpNEW_Update( arg0 )
		end
	--ÏÔÊ¾ÉñÆ÷Á¶»êºóµÄĞÂÊôĞÔ
	elseif event == "SUPERATTR_UPDATE_RECOIN" then
		--¸üĞÂÖØÆôµÄÊôĞÔ
	--	PushDebugMessage(tonumber(arg0))
		if arg0 ~= nil then
			SuperWeaponUpNEW_UpDateRecoin(arg0)
		end

	elseif event == "SUPER_ATTR_RECOIN_CONFIRM_OK" then
		if tonumber(arg1) == 1 then
			SuperWeaponUpNEW_Clear(1) --????????
			SuperWeaponUpNEW_Update(tonumber(arg0)) --?????~
		elseif tonumber(arg1) == 0 then
			SuperWeaponUpNEW_Clear(1)
			this:Hide()
		elseif tonumber(arg1) == 2 then
			SuperWeaponUpNEW_Clear(1) --????????
		end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 198311141 then
		local bagpos = Get_XParam_INT(0)
		if bagpos ~= nil then
			SuperWeaponUpNEW_Clear(1)
			SuperWeaponUpNEW_Update( tonumber(bagpos) )
		end

	end

end

--=========================================================
--È·¶¨°´Å¥
--=========================================================
function SuperWeaponUpNEW_Buttons_Clicked()

	--ÅĞ¶Ïµç»°ÃÜ±£ºÍ¶ş¼¶ÃÜÂë±£»¤2012.6.11-LIUBO
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	-- ÅĞ¶ÏÊÇ·ñÎª°²È«Ê±¼ä2012.6.11-LIUBO
	-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	-- 	PushDebugMessage("#{CXYH_140813_11}")
	-- 	return
	-- end

	if g_ItemPos ~= -1 and PlayerPackage : GetItemTableIndex( g_ItemPos ) > 0 then


    --Deleted By ChangHua 2010-03-01 TT:66410
    --ÉñÆ÷±»¼ÓËøÊ±Ò²¿ÉÒÔ½øĞĞÉı¼¶²Ù×÷
	--	if PlayerPackage : IsLock( g_ItemPos ) == 1 then
	--		PushDebugMessage( "ÎïÆ·²»´æÔÚ»ò ßÒÑ¼ÓËø£¡" )
	--		return
	--	end

		--Ç®ÊÇ·ñ¹»....
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") --???? Vega
		if selfMoney < g_NeedMoney then
			PushDebugMessage( "#{CXYH_140813_40}" )
			return
		end

	-- local eqLevel = LifeAbility : Get_Equip_Level(g_ItemPos)--»ñÈ¡×°±¸µÈ¼¶

	-- --PushDebugMessage(g_ItemPos)
	-- if eqLevel == nil then
	-- 	return
	-- end

	--PushDebugMessage("333"..eqLevel)
	-- if(eqLevel == 92) then
	-- 	if(SuperWeaponUpNEW_ModeSelect:GetCheck()==0 and SuperWeaponUpNEW_ModeSelect2:GetCheck() ==0) then
	-- 		PushDebugMessage("#{SXLH_101026_01}")-- â¸öÒª²»ÒªÅä×Öµä
	-- 		return
	-- 	end
	-- end

	if (g_ItemPos ~= -1) then
		local ItemID = PlayerPackage : GetItemTableIndex( g_ItemPos )
		local MatID,MatNum = ShenqiUpgrade : GetShenqiUpMaterial( ItemID, 0 )
		local nHaveNum = Player : IsHaveItem( MatID, MatNum)
		if (nHaveNum < MatNum) then
			PushDebugMessage( "#{SQSJ_0708_04}" )
			return
		end
	end

		if (g_Accept_Clicked_Num == 0) then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "ShenQiConfirm" )
				Set_XSCRIPT_ScriptID( 500505 )
				Set_XSCRIPT_Parameter( 0, g_ItemPos )
				Set_XSCRIPT_Parameter( 1, ObjCaredIDID )

				Set_XSCRIPT_ParamCount( 2 )
			Send_XSCRIPT()
			g_Accept_Clicked_Num = 1
		else
			Clear_XSCRIPT()
			-- 	Set_XSCRIPT_Function_Name( "OnShenqiUpgrade" )
			-- 	Set_XSCRIPT_ScriptID( 500505 )
			-- 	Set_XSCRIPT_Parameter( 0, g_ItemPos )
			-- 	Set_XSCRIPT_Parameter( 1, ObjCaredIDID )
			-- 	--ÉÏÃæµÄifÓï¾äÖĞ£¬²ÎÊı²»ÓÃÔö¼Ó
			-- 	if( SuperWeaponUpNEW_ModeSelect:GetCheck() == 1) then
			-- 		g_Is92ShenQi = 1
			-- 	else
			-- 		g_Is92ShenQi = 0
			-- 	end
			-- --	PushDebugMessage(g_Is92ShenQi)
			-- 	Set_XSCRIPT_Parameter( 2, g_Is92ShenQi )
			-- 	Set_XSCRIPT_ParamCount( 3 )

				Set_XSCRIPT_Function_Name( "OnShenqiUpgrade" )
				Set_XSCRIPT_ScriptID( 500505 )
				Set_XSCRIPT_Parameter( 0, g_ItemPos )
				Set_XSCRIPT_Parameter( 1, ObjCaredIDID )
				Set_XSCRIPT_ParamCount( 2 )
			Send_XSCRIPT()
			--SuperWeaponUpNEW_Clear(1)
		--	SuperWeaponUpNEW_Hide_RadioText()
		end

	else
		PushDebugMessage( "#{CXYH_140813_38}" )
	end
end


--±£ÁôĞÂÊôĞÔ
function SuperWeaponUpNEW_Tihuan_Clicked()

	if g_SuperIsWashed ==1 then

 		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("DoRefreshSuperAttr");
			Set_XSCRIPT_ScriptID(500505);
			Set_XSCRIPT_Parameter(0,g_ItemPos);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end

		--ÉèÖÃÖØÏ´×´Ì¬
	g_SuperIsWashed =0

--	SuperWeaponUpNEW_Clear(0)
--	SuperWeaponUpNEW_Update(g_ItemPos)
end



--=========================================================
--¸üĞÂ½çÃæ
--=========================================================
function SuperWeaponUpNEW_Update( pos_packet )
	local BagIndex = tonumber( pos_packet )
	local theAction = EnumAction( BagIndex, "packageitem" )

	if theAction : GetID() == 0 then
		return
	end

	--±ØĞëÊÇ¿É¶Ò»»µÄÉñÆ÷....
	local MenpaiID = Player : GetData( "MEMPAI" )
	local ItemID = PlayerPackage : GetItemTableIndex( BagIndex )
	if ItemID <= 0 then
		PushDebugMessage("V§t ph¦m này không phäi là th¥n khí có th¬ ğ±i!")
		return
	end

	g_NewId, g_NeedMoney = ShenqiUpgrade : GetShenqiUpgradeInfo( ItemID, MenpaiID )
	if g_NewId == -1 then
		PushDebugMessage("#{CXYH_140813_37}")
		return
	end

		-- Èç¹û¿ ¸ñÄÚÒÑ¾­ÓĞ¶ÔÓ¦ÎïÆ·ÁË,ĞèÒªµ¯Ò»¸ö¶ş´ÎÈ·ÈÏ¡­¡­
	if g_ItemPos ~= -1 and BagIndex ~= g_ItemPos and  g_SuperIsWashed == 1  then
		SuperWeaponUpNEW_SendSuper_AttrConfirm(BagIndex,1)
		return
	end

	--¸ü»»ActionButton....
	if g_ItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
	end
	LifeAbility : Lock_Packet_Item( BagIndex, 1 )
	SuperWeaponUpNEW_BeforeIcon : SetActionItem( theAction : GetID() )
	g_ItemPos = BagIndex
	SuperWeaponUpNEW_WantNum : SetProperty( "MoneyNumber", tostring( g_NeedMoney ) )
	g_Accept_Clicked_Num = 0

	local eqLevel = LifeAbility : Get_Equip_Level(BagIndex)--??????
	--PushDebugMessage(eqLevel)
	if(eqLevel == 92) then
		SuperWeaponUpNEW_Show_RadioText()
		--SuperWeaponUp_ModeSelect:SetCheck(1)
		--PushDebugMessage(SuperWeaponUp_ModeSelect:GetCheck())
	else
	  SuperWeaponUpNEW_Hide_RadioText()
	end

	local icon =  tostring(LifeAbility : Get_Item_Icon_Name(g_ItemPos))
	--PushDebugMessage("before="..icon)
	SuperWeaponUpNEW_AfterIcon:SetProperty("Image",icon)

	local num = theAction:GetEquipAttrCount()
	local str = ""
	for i = 0, num-1 do
		local tempstr = theAction:EnumEquipExtAttr(i)
		--	g_BeforeTextList[i]:SetText(tempstr)
		str = str..tempstr
		--	PushDebugMessage("tempstr="..tempstr.."/str="..str)
	end
	SuperWeaponUpNEW_BeforeAttrFirst:SetText(str)

	SuperWeaponUpNEW_OK:Enable();
end



--=========================================================
--ÖØÖÃ½çÃæ
--=========================================================
function SuperWeaponUpNEW_Clear(cleanaction)
	--g_ItemPos = -1
	g_NewId = -1
	g_NeedMoney = -1
	g_SuperIsWashed =0
	g_Accept_Clicked_Num =0
	g_LongwenPropertyReset_Confirm = -1
	SuperWeaponUpNEW_OK:Disable()



	SuperWeaponUpNEW_BeforeAttrFirst:SetText("")
	SuperWeaponUpNEW_AfterAttrFirst:SetText("")
--	SuperWeaponUpNEW_OK:Disable()
	SuperWeaponUpNEW_AfterIcon:SetProperty("Image","")
	SuperWeaponUpNEW_Tihuan:Disable()
	if cleanaction == 1 then
		if g_ItemPos ~= -1 then
			SuperWeaponUpNEW_BeforeIcon:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_ItemPos, 0)
			g_ItemPos = -1
		end
	end
end


--=========================================================
--¹Ø± 
--=========================================================
function SuperWeaponUpNEW_Close()
	--¹Ø± Ç°Ò²ÒªÀ´¸ö¶ş´ÎÈ·ÈÏ
	if g_ItemPos ~= -1 and g_SuperIsWashed == 1  then
		SuperWeaponUpNEW_SendSuper_AttrConfirm(g_ItemPos,0)
		return
	end
	this : Hide()
	StopCareObject_SuperWeaponUpNEW()
	SuperWeaponUpNEW_Clear(1)
end

--=========================================================
--½çÃæÒş²Ø
--=========================================================
function SuperWeaponUpNEW_OnHiden()
	StopCareObject_SuperWeaponUpNEW()
	SuperWeaponUpNEW_Clear(1)
end

--=========================================================
--¿ªÊ¼¹ØĞÄNPC£¬
--ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
--Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_SuperWeaponUpNEW()
	this : CareObject( ObjCaredID, 1, "SuperWeaponUpNEW" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_SuperWeaponUpNEW()
	this : CareObject( ObjCaredID, 0, "SuperWeaponUpNEW" )
	SuperWeaponUpNEW_Hide_RadioText()
end

--=========================================================
--ÓÒ¼üµã»÷ActionButton
--=========================================================
function SuperWeaponUpNEW_Resume_Equip_Gem()

	if g_ItemPos ~= -1 and g_SuperIsWashed == 1  then
		SuperWeaponUpNEW_SendSuper_AttrConfirm(g_ItemPos,2)
		return
	end

	if( this:IsVisible() ) then

		SuperWeaponUpNEW_Clear(1)
		SuperWeaponUpNEW_Hide_RadioText()

	end


end
function SuperWeaponUpNEW_Hide_RadioText()

			-- SuperWeaponUpNEW_ModeSelect:SetProperty("Visible","False");
			-- SuperWeaponUpNEW_ModelText:SetProperty("Visible","False");
			-- SuperWeaponUpNEW_ModeSelect2:SetProperty("Visible","False");
			-- SuperWeaponUpNEW_ModelText2:SetProperty("Visible","False");
			-- SuperWeaponUpNEW_ModeSelect:SetCheck(0)
			-- SuperWeaponUpNEW_ModeSelect2:SetCheck(0)
			-- SuperWeaponUpNEW_ModeSelect:Disable()
			-- SuperWeaponUpNEW_ModeSelect2:Disable()
end

function SuperWeaponUpNEW_Show_RadioText()

			-- SuperWeaponUpNEW_ModeSelect:SetProperty("Visible","true");
			-- SuperWeaponUpNEW_ModelText:SetProperty("Visible","true");
			-- SuperWeaponUpNEW_ModeSelect2:SetProperty("Visible","true");
			-- SuperWeaponUpNEW_ModelText2:SetProperty("Visible","true");
			-- SuperWeaponUpNEW_ModeSelect:SetCheck(0)
			-- SuperWeaponUpNEW_ModeSelect2:SetCheck(0)
			-- SuperWeaponUpNEW_ModeSelect:Enable()
			-- SuperWeaponUpNEW_ModeSelect2:Enable()
end

--ÏÔÊ¾Á¶»êºóµÄĞÂÊôĞÔ
function SuperWeaponUpNEW_UpDateRecoin(dataindex)
	local num =  DataPool : Lua_GetSuperRecoinNum();

	local str = ""
	for i = 0, num-1 do
		local tempstr = DataPool :Lua_GetSuperRecoinEnumAttr(i)
		str = str..tempstr
	end

	SuperWeaponUpNEW_AfterAttrFirst:SetText(str)
--	LongwenPropertyResetNEW_Baoliu:Enable()
	SuperWeaponUpNEW_Tihuan:Enable()

	local icon =  tostring(LifeAbility : Get_Item_Icon_NameByDataIndex(tonumber(dataindex)))

--	PushDebugMessage(icon)
		SuperWeaponUpNEW_AfterIcon:SetProperty("Image",icon)
	g_SuperIsWashed =1
end

--·¢ËÍÌæ»»Á¶»êºóÊôĞÔµÄ¶ş´ÎÈ·ÈÏ
function SuperWeaponUpNEW_SendSuper_AttrConfirm(nIndex,keepopen)
	PushEvent("SUPER_ATTR_RECOIN_CONFIRM",tostring(nIndex),tostring(keepopen))
end


function SuperWeaponUpNEW_TryClear()
	if g_ItemPos ~= -1 and g_SuperIsWashed == 1  then
		SuperWeaponUpNEW_SendSuper_AttrConfirm(g_ItemPos,2)
		return
	end

	SuperWeaponUpNEW_Clear(1) --????????

end
--ÓÒ¼üµã»÷È¡Ïû
function SuperWeaponUpNEW_Item_cancel()
	if( this:IsVisible() ) then

	--¹Ø± Ç°Ò²ÒªÀ´¸ö¶ş´ÎÈ·ÈÏ
		if g_ItemPos ~= -1 and g_SuperIsWashed == 1  then
			SuperWeaponUpNEW_SendSuper_AttrConfirm(g_ItemPos,2)
			return
		end
	--	this : Hide()
			SuperWeaponUpNEW_Clear(1)
			SuperWeaponUpNEW_Hide_RadioText()

	end
end

function SuperWeaponUpNEW_MoneyUpdate()
		SuperWeaponUpNEW_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
		SuperWeaponUpNEW_HaveNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
end
