--MissionObjDel.lua
--Ïú»ÙÈÎÎñÎïÆ·¶Ô»°¿ò

local	g_btnItem				--???
local	g_txtItem				--????
local	g_posItem	= -1	--?????????

local	MAX_OBJ_DISTANCE	= 3.0
local	g_objCared 				= -1

local	g_SpecialItemTable = 
{
	30900076,	--?????
}

function MissionObjDel_PreLoad()
	this:RegisterEvent( "UI_COMMAND" )
	this:RegisterEvent( "UPDATE_MISOBJDEL" )
	
	this:RegisterEvent( "OBJECT_CARED_EVENT" )
	this:RegisterEvent( "PACKAGE_ITEM_CHANGED" )
end

function MissionObjDel_OnLoad()
	g_btnItem	= MissionObjDel_Item
	g_txtItem	= MissionObjDel_Item_Explain
end

function MissionObjDel_OnEvent( event )
	--´ò¿ª½çÃæ
	if( event == "UI_COMMAND" and tonumber(arg0) == 42 ) then
		MissionObjDel_OnOpen()
		
		local	xx		= Get_XParam_INT( 0 )
		g_objCared	= DataPool : GetNPCIDByServerID( xx )
		AxTrace( 0, 1, "xx="..xx .. " objCared="..g_objCared )
		if g_objCared == -1 then
				PushDebugMessage( "Servertruy®n t¾i Ðích s¯ li®u có v¤n ð«." )
				return
		end

		BeginCareObject_MisObjDel( g_objCared )
		return
	end

	--ÎïÆ·ÍÏ×§µ½À¸ÄÚ
	if( event == "UPDATE_MISOBJDEL" ) then
		AxTrace( 0, 1, "arg0="..arg0 )
		if arg0 ~= nil then
			MissionObjDel_Clear()
			MissionObjDel_Update( tonumber(arg0) )
		end
		return
	end
	
	--¹ØÐÄNPC
	if( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if( tonumber(arg0) ~= g_objCared ) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if( arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy" ) then
			MissionObjDel_OnClose()
		end
		return
	end
	
	--±³°üÀïµÄÎïÆ··¢Éú±ä»¯
	if( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		if( arg0 ~= nil and -1 == tonumber(arg0) ) then
			return
		end

		if( arg0 ~= nil and g_posItem == tonumber(arg0) ) then
				MissionObjDel_Clear()
				MissionObjDel_Update( tonumber(arg0) )
		end
		return
	end
end

--´ò¿ª½çÃæ
function MissionObjDel_OnOpen()
	this:Show()
end

--¹Ø± ½çÃæ
function MissionObjDel_OnClose()
	this:Hide()
	
	StopCareObject_MisObjDel( g_objCared )
	g_objCared	= -1
end

--Ïú»Ù°´Å¥
function MissionObjDel_OnDestroy()
	if g_posItem ~= -1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID( 124 )
			Set_XSCRIPT_Function_Name( "OnDestroy" )
			Set_XSCRIPT_Parameter( 0, g_posItem )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	else
		PushDebugMessage( "Thïnh Bä Yêu tiêu hüy Ðích nhi®m vø v§t ph¦m Ðà Ðµng Ðáo v§t ph¦m Khuông Trung" )
	end
end

--È¡Ïû°´Å¥
function MissionObjDel_OnCancel()
	MissionObjDel_OnClose()
end

--ÇåÀíÎïÆ·
function MissionObjDel_Clear()
	g_btnItem : SetActionItem( -1 );
	g_txtItem : SetText( "C¥n tiêu hüy Ðích nhi®m vø v§t ph¦m" )
	LifeAbility : Lock_Packet_Item( g_posItem, 0 )
	g_posItem	= -1
end

--Ë¢ÐÂÎïÆ·
function MissionObjDel_Update( pos_taskitem )
	local	pos	= tonumber( pos_taskitem )
	local	theAction	= EnumAction( pos, "packageitem" )
	
	if theAction:GetID() ~= 0 then
		local bExclude = 0
		local nDefId = theAction:GetDefineID()
		--ÌØÊâµÄÎïÆ·Ò²ÄÜÏú»Ù
		for _, iid in g_SpecialItemTable do
			if iid == nDefId then
				bExclude = 1
			end
		end

		if bExclude ~= 1 and LifeAbility : GetItem_Class( pos ) ~= 4 then
			PushDebugMessage( "Chï có th¬ tiêu hüy nhi®m vø v§t ph¦m" )
			return
		end

		g_btnItem : SetActionItem( theAction:GetID() )
		g_txtItem : SetText( theAction:GetName() )
		if g_posItem ~= -1 then
			LifeAbility : Lock_Packet_Item( g_posItem, 0 )
		end

		--ÔÚ±³°üÖÐËø×¡ â¸öÎïÆ·
		g_posItem	= pos
		LifeAbility : Lock_Packet_Item( g_posItem, 1 )

	else
		MissionObjDel_Clear()
		return
	end

end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_MisObjDel( objCaredId )
	this:CareObject( objCaredId, 1, "MissionObjDel" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_MisObjDel( objCaredId )
	this:CareObject( objCaredId, 0, "MissionObjDel" )
end

function MissionObjDel_OnHide()
	MissionObjDel_Clear();
end
