
local MAX_OBJ_DISTANCE = 3.0;

local g_GemItemPos = -1;
local g_GemItemID = -1;
local g_NeedItemPos = -1;
local g_NeedItemID = -1;
local g_NeedMoney = 0;
local g_RightGem = 0;
local EB_BINDED = 1;				-- ????

local g_LastGemItemID = -1;
local g_LastNeedItemID = -1;

local ObjCaredIDID = -1;


local g_GemCarve_Frame_UnifiedPosition;

function GemCarve_PreLoad()

	this:RegisterEvent("UPDATE_GEMCARVE");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("MONEYJZ_CHANGE")		--???? Vega
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function GemCarve_OnLoad()
    g_GemCarve_Frame_UnifiedPosition=GemCarve_Frame:GetProperty("UnifiedPosition");
end

function GemCarve_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 112236) then

			local xx = Get_XParam_INT(0);
			ObjCaredID = DataPool : GetNPCIDByServerID(xx);
			if ObjCaredID == -1 then
					PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
					return;
			end
			ObjCaredIDID = xx
			BeginCareObject_GemCarve()
			GemCarve_Clear()
			this:Show();

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			GemCarve_Close()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if ( g_GemItemPos == tonumber(arg0) ) then
			GemCarve_RefreshItem()
		end

		if ( g_NeedItemPos == tonumber(arg0) ) then
			GemCarve_RefreshItem()
		end

	elseif( event == "UPDATE_GEMCARVE") then

		if arg0 == nil or arg1 == nil then
			return
		end

		GemCarve_Update(tonumber(arg0),tonumber(arg1));

	elseif( event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then

		GemCarve_UserMoneyChanged();

	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then

		if tonumber(arg0) == 41 then
			Resume_Equip_GemCarve(1)
		elseif tonumber(arg0) == 42 then
			Resume_Equip_GemCarve(2)
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		GemCarve_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GemCarve_Frame_On_ResetPos()

	end

end

--=========================================================
--ÖØÖÃ½çÃæ
--=========================================================
function GemCarve_Clear()

	if(g_GemItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
	end
	if(g_NeedItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
	end

	GemCarve_GemItem : SetActionItem(-1);
	GemCarve_NeedItem : SetActionItem(-1);
	GemCarve_ProductItem:SetActionItem(-1);

	GemCarve_NeedItem : SetToolTip("")
	GemCarve_Money : SetProperty("MoneyNumber", "")
	GemCarve_State: SetText("")
	
	g_GemItemPos = -1;
	g_GemItemID = -1;
	g_NeedItemPos = -1;
	g_NeedItemID = -1;
	g_NeedMoney = 0;
	g_RightGem = 0;
	g_LastGemItemID = -1;
    g_LastNeedItemID = -1;

	GemCarve_ProductItem:Hide();
	GemCarve_Accept:Disable();

end

--=========================================================
--¸üÐÂ½çÃæ
--=========================================================
function GemCarve_Update( pos_ui, pos_packet )

	local theAction = EnumAction(pos_packet, "packageitem");

	if pos_ui == 1 then

		if theAction:GetID() == 0 then
			return
		end

		--±ØÐëÊÇ±¦Ê¯....
		local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
		if Item_Class ~= 5 then
			PushDebugMessage("Chï có bäo thÕch tài khä B¸ tÕo hình")
			return
		end

		--¼ÇÂ¼Ë¢ÐÂÇ°....Íæ¼Ò·Åµ½ËùÐèÎïÆ·À¸ÖÐµÄËùÐèÎïÆ·µÄÐÅÏ¢....
		local lastNeedItemPos = g_NeedItemPos
		local lastNeedItemID = g_NeedItemID

		--ÖØÖÃ½çÃæ....
		GemCarve_Clear();

		--¸ü»»ActionButton....
		if g_GemItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
		end
		g_GemItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_GemItemPos,1);
		GemCarve_GemItem:SetActionItem(theAction:GetID());

		--»ñÈ¡µñ×ÁµÄÐÅÏ¢....
		local GemItemID = PlayerPackage : GetItemTableIndex( pos_packet )
		g_GemItemID = GemItemID;
		local ProductID
		ProductID, g_NeedItemID, g_NeedMoney = GemCarve:GetGemCarveInfo( GemItemID )
		if -1 == ProductID then
			g_RightGem = 0
			GemCarve_State : SetText("ThØ bäo thÕch không th¬ B¸ tÕo hình.")
			return
		else
			g_RightGem = 1
		end

		--ÉèÖÃ²úÆ·ActionButton....
		GemCarve_State : SetText("TÕo hình H§u Ðích kªt quä:")
		GemCarve_ProductItem:Show()
		local ProductAction = GemCarve:UpdateProductAction( ProductID )
		if ProductAction and ProductAction:GetID() ~= 0 then
			GemCarve_ProductItem:SetActionItem(ProductAction:GetID());
		else
			GemCarve_ProductItem:SetActionItem(-1);
		end

		--ÉèÖÃËùÐèÎïÆ·Tooltips....
		GemCarve_NeedItem : SetToolTip("C¥n ð¬ vào#{_ITEM"..g_NeedItemID.."}")

		--ÉèÖÃËùÐèÇ®Êý....
		GemCarve_Money : SetProperty("MoneyNumber", tostring(g_NeedMoney));
		
		--Èç¹û â´ÎµÄËùÐèÎïÆ·ÓëÉÏ´ÎµÄÏàÍ¬....ÔòÖ±½Ó°ÑÉÏ´ÎµÄËùÐèÎïÆ··Åµ½ËùÐèÎïÆ·À¸ÄÚ....
		if lastNeedItemID ~= -1 and lastNeedItemID == g_NeedItemID then
			GemCarve_Update( 2, lastNeedItemPos )
		end

	elseif pos_ui == 2 then

		if theAction:GetID() == 0 then
			return
		end

		if -1 == g_GemItemPos or g_RightGem == 0 then
			PushDebugMessage("Thïnh Tiên ð¬ vào c¥n tÕo hình Ðích bäo thÕch")
			return
		end

		--²»ÊÇÐèÇóµÄÎïÆ·....
		if PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID then
			PushDebugMessage("N½i này chï có th¬ ð¬ vào#{_ITEM"..g_NeedItemID.."}")
			return
		end

		--¸ü»»ActionButton....
		if g_NeedItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
		end
		g_NeedItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,1);
		GemCarve_NeedItem:SetActionItem(theAction:GetID());

		--Èç¹ûÎïÆ·¶¼ ýÈ·ÁË²¢ÇÒÇ®Ò²¹»¾ÍEnableµñ×Á°´Å¥....
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")  --???? Vega
		if selfMoney >= g_NeedMoney then
			GemCarve_Accept:Enable();
		end

	end

end

--=========================================================
--Çå³ýActionButton
--=========================================================
function Resume_Equip_GemCarve(nIndex)

	if(nIndex == 1) then
		GemCarve_Clear()
	else
		if(g_NeedItemPos ~= -1) then
			LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
			GemCarve_NeedItem : SetActionItem(-1);
			g_NeedItemPos	= -1;
		end
		GemCarve_Accept:Disable();
	end

end

--=========================================================
--È·¶¨
--=========================================================
function GemCarve_Buttons_Clicked()

	if g_GemItemPos == -1 or g_RightGem == 0 then
		return
	end

	if g_NeedItemPos == -1 then
		return
	end
	
	if(g_LastGemItemID ~= g_GemItemID or g_LastNeedItemID ~= g_NeedItemID) then
	  g_LastGemItemID = g_GemItemID
	  g_LastNeedItemID = g_NeedItemID
	  --¸ù¾Ý±¦Ê¯ÊÇ·ñ°ó¶¨ºÍ±¦Ê¯µñ×Á·ûÊÇ·ñ°ó¶¨£¬¾ö¶¨ ª³ýºóµÄ±¦Ê¯ÊÇ·ñ°ó¶¨
	  if (GetItemBindStatus(g_GemItemPos) == EB_BINDED or GetItemBindStatus(g_NeedItemPos) == EB_BINDED) then
	    ShowSystemInfo("INTERFACE_XML_GemCarve_7");
	    --LifeAbility:Carve_Confirm("OnGemCarve",800117,g_GemItemPos,g_NeedItemPos,2);
	  return
	  end
	end


	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnGemCarve");
		Set_XSCRIPT_ScriptID(800117);
		Set_XSCRIPT_Parameter(0,g_GemItemPos);
		Set_XSCRIPT_Parameter(1,g_NeedItemPos);
		Set_XSCRIPT_Parameter(2,ObjCaredIDID);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	
	--GemCarve_Close()

end

function GemCarve_RefreshItem()
			
	GemCarve_GemItem : SetActionItem(-1);
	GemCarve_NeedItem : SetActionItem(-1);
	GemCarve_ProductItem:SetActionItem(-1);

	GemCarve_NeedItem : SetToolTip("")
	GemCarve_Money : SetProperty("MoneyNumber", "")
	GemCarve_State: SetText("")

	GemCarve_ProductItem:Hide();
	GemCarve_Accept:Disable();

	if(g_GemItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
	end
	if(g_NeedItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
	end
	
		if g_GemItemPos ~= -1 then
			local theAction = EnumAction(g_GemItemPos, "packageitem");
			if theAction:GetID() == 0 then
				g_GemItemPos = -1
				return
			end

			local GemItemID = PlayerPackage : GetItemTableIndex( g_GemItemPos )
			if GemItemID ~= g_GemItemID then
				g_GemItemPos = -1
				return
			end
			
			local ProductID, g_NeedItemID, g_NeedMoney = GemCarve:GetGemCarveInfo( GemItemID )
			if -1 == ProductID then
				g_GemItemPos = -1
				return
			end
			
			LifeAbility : Lock_Packet_Item(g_GemItemPos,1);
			GemCarve_GemItem:SetActionItem(theAction:GetID());
			
			if -1 ~= ProductID then
				GemCarve_State : SetText("TÕo hình H§u Ðích kªt quä:")
				GemCarve_ProductItem:Show()
				local ProductAction = GemCarve:UpdateProductAction( ProductID )
				if ProductAction and ProductAction:GetID() ~= 0 then
					GemCarve_ProductItem:SetActionItem(ProductAction:GetID());
				else
					GemCarve_ProductItem:SetActionItem(-1);
				end
			end
			
			--ÉèÖÃËùÐèÎïÆ·Tooltips....
			GemCarve_NeedItem : SetToolTip("C¥n ð¬ vào#{_ITEM"..g_NeedItemID.."}")

			--ÉèÖÃËùÐèÇ®Êý....
			GemCarve_Money : SetProperty("MoneyNumber", tostring(g_NeedMoney));
			
			if g_NeedItemPos ~= -1 then
				local theAction = EnumAction(g_NeedItemPos, "packageitem");
				if theAction:GetID() ~= 0 then
					if PlayerPackage : GetItemTableIndex( g_NeedItemPos ) == g_NeedItemID then
						GemCarve_NeedItem:SetActionItem(theAction:GetID());
						LifeAbility : Lock_Packet_Item(g_NeedItemPos,1);
					end
				else
					g_NeedItemPos = -1
					return
				end
			end

			local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
			if selfMoney >= g_NeedMoney then
				GemCarve_Accept:Enable();
			end
		end
		
end
--=========================================================
--¹Ø± 
--=========================================================
function GemCarve_Close()
	this:Hide();
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--½çÃæÒþ²Ø
--=========================================================
function GemCarve_OnHide()
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_GemCarve()
	this:CareObject(ObjCaredID, 1, "GemCarve");
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_GemCarve()
	this:CareObject(ObjCaredID, 0, "GemCarve");
end

--=========================================================
--Íæ¼Ò½ðÇ®±ä»¯
--=========================================================
function GemCarve_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") --???? Vega
	if selfMoney < g_NeedMoney then
		GemCarve_Accept:Disable();
	else
		if g_GemItemPos ~= -1 and g_NeedItemPos ~= -1 then
			GemCarve_Accept:Enable();
		end
	end

end

function GemCarve_Frame_On_ResetPos()
  GemCarve_Frame:SetProperty("UnifiedPosition", g_GemCarve_Frame_UnifiedPosition);
end
