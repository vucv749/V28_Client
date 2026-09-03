
local ObjCaredIDID = -1
local g_ItemPos = -1
local g_NewId = -1
local g_NeedMoney = -1
local MAX_OBJ_DISTANCE = 3.0
local g_Accept_Clicked_Num = 0
--=========================================================
--³£Á¿¶¨Òå
--=========================================================
--local MIN_MENPAI_IDX = 0
--local MAX_MENPAI_IDX = 8

function SuperWeaponUp_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "OBJECT_CARED_EVENT" )
	this : RegisterEvent( "PACKAGE_ITEM_CHANGED" )
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )
	this : RegisterEvent( "UPDATE_SHENQIUP" )
	this : RegisterEvent( "RESUME_ENCHASE_GEM" )
	this : RegisterEvent( "NEW_DEBUGMESSAGE" )
end

function SuperWeaponUp_OnLoad()

end


--=========================================================
--ÊÂ¼şÏìÓ¦
--=========================================================
function SuperWeaponUp_OnEvent( event )

	if event == "UI_COMMAND" and tonumber(arg0) == 19831114 then
		local targetId = Get_XParam_INT(0)
		ObjCaredID = DataPool : GetNPCIDByServerID( targetId )
		if ObjCaredID == -1 then
			--PushDebugMessage("server´«¹ıÀ´µÄÊı¾İÓĞÎÊÌâ¡£")
			return
		end
		ObjCaredIDID = targetId
		BeginCareObject_SuperWeaponUp()
		SuperWeaponUp_Clear()
		this : Show()

	elseif event == "UNIT_MONEY" then
		SuperWeaponUp_SelfMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )

	elseif event == "MONEYJZ_CHANGE" then
		SuperWeaponUp_DemandJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )

	elseif event == "OBJECT_CARED_EVENT" then
		if( tonumber(arg0) ~= ObjCaredID ) then
			return
		end
		if( arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1=="destroy" ) then
			SuperWeaponUp_Close()
		end

	elseif event == "RESUME_ENCHASE_GEM" then
		SuperWeaponUp_Resume_Equip_Gem()

	elseif event == "PACKAGE_ITEM_CHANGED" then
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if tonumber(arg0) == g_ItemPos then
			SuperWeaponUp_Resume_Equip_Gem()
		end

	elseif event == "UPDATE_SHENQIUP" then
		if arg0 ~= nil then
			SuperWeaponUp_Update( arg0 )
		end
	end

end

--=========================================================
--È·¶¨°´Å¥
--=========================================================
function SuperWeaponUp_Buttons_Clicked()
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
			PushDebugMessage( "#{JKBS_081021_011}" )
			return
		end

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
				Set_XSCRIPT_Function_Name( "OnShenqiUpgrade" )
				Set_XSCRIPT_ScriptID( 500505 )
				Set_XSCRIPT_Parameter( 0, g_ItemPos )
				Set_XSCRIPT_Parameter( 1, ObjCaredIDID )
				Set_XSCRIPT_ParamCount( 2 )
			Send_XSCRIPT()
			SuperWeaponUp_Clear()
		end

	else
		PushDebugMessage( "Hãy ğ£t th¥n khí c¥n tái tÕo!" )
	end
end




--=========================================================
--¸üĞÂ½çÃæ
--=========================================================
function SuperWeaponUp_Update( pos_packet )
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
		PushDebugMessage("Hãy ğ£t th¥n khí có th¬ ğ±i!")
		return
	end


	--¸ü»»ActionButton....
	if g_ItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
	end
	LifeAbility : Lock_Packet_Item( BagIndex, 1 )
	SuperWeaponUp_Object : SetActionItem( theAction : GetID() )
	g_ItemPos = BagIndex
	SuperWeaponUp_DemandMoney : SetProperty( "MoneyNumber", tostring( g_NeedMoney ) )
	g_Accept_Clicked_Num = 0
end



--=========================================================
--ÖØÖÃ½çÃæ
--=========================================================
function SuperWeaponUp_Clear()
	if g_ItemPos ~= -1 then
		SuperWeaponUp_Object : SetActionItem( -1 )
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
		g_ItemPos = -1
		g_NewId = -1
		g_NeedMoney = -1
		SuperWeaponUp_DemandMoney : SetProperty( "MoneyNumber", 0 )
		g_Accept_Clicked_Num = 0
	end
end


--=========================================================
--¹Ø± 
--=========================================================
function SuperWeaponUp_Close()
	this : Hide()
	StopCareObject_SuperWeaponUp()
	SuperWeaponUp_Clear()
end

--=========================================================
--½çÃæÒş²Ø
--=========================================================
function SuperWeaponUp_OnHiden()
	StopCareObject_SuperWeaponUp()
	SuperWeaponUp_Clear()
end

--=========================================================
--¿ªÊ¼¹ØĞÄNPC£¬
--ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
--Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_SuperWeaponUp()
	this : CareObject( ObjCaredID, 1, "SuperWeaponUp" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_SuperWeaponUp()
	this : CareObject( ObjCaredID, 0, "SuperWeaponUp" )
end

--=========================================================
--ÓÒ¼üµã»÷ActionButton
--=========================================================
function SuperWeaponUp_Resume_Equip_Gem()

	if( this:IsVisible() ) then

		SuperWeaponUp_Clear()

	end
end
