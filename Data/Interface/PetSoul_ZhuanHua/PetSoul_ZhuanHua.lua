--PetSoul_ZhuanHua

local g_PetSoul_ZhuanHua_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_ZhuanHua_NpcId = -1;
local g_PetSoul_ZhuanHua_targetId = -1;
local g_PetSoul_ZhuanHua_PetSoulPieceCtrl={}
local g_PetSoul_ZhuanHua_PetSoulPieceBagIndex={-1,-1}
local g_PetSoul_ZhuanHua_PetSoulPieceItemIndex={-1,-1}
local g_PetSoul_ZhuanHua_PetSoulPieceQual={-1,-1}
local g_PetSoul_ZhuanHua_PetSoulPieceComboQual=-1

local g_PetSoul_ZhuanHua_CommonPiece ={
	38002741,
	38002742,
}

local g_PetSoul_ZhuanHua_Qual_Dest={
	-- ÁéÊÞ
	[0] = {
		[1] ="Xích Hùng H°n Ng÷c",
		[2] ="BÕch Câu H°n Ng÷c",
		[3] ="Linh Thi«n H°n Ng÷c",
		[4] ="Thß½ng Lang H°n Ng÷c",
		[5] ="Phi Dß½ng H°n Ng÷c",
	},
	-- »ÄÊÞ
	[1] = {
		[1] ="C¦m Lân H°n Ng÷c",
		[2] ="Huy­n Ði®p H°n Ng÷c",
		[3] ="Sß½ng HÕc H°n Ng÷c",
		[4] ="Kim ô H°n Ng÷c",
		[5] ="Lµc Thøc H°n Ng÷c",
	},
	-- ÉñÊÞ
	[2] = {
		[1] ="Thanh Long H°n Ng÷c",
		[2] ="Huy«n Vû H°n Ng÷c",
		[3] ="BÕch H± H°n Ng÷c",
		[4] ="Chu Tß¾c H°n Ng÷c",
		[5] ="CØu vî H°n Ng÷c",
	},
}

--[[
local g_PetSoul_ZhuanHua_Qual_Dest={
	-- ÁéÊÞ
	[0] = {
		[1] ="#{SHXT_20211230_263}",
		[2] ="#{SHXT_20211230_264}",
		[3] ="#{SHXT_20211230_265}",
		[4] ="#{SHXT_20211230_266}",
		[5] ="#{SHXT_20211230_267}",
	},
	-- »ÄÊÞ
	[1] = {
		[1] ="#{SHXT_20211230_259}",
		[2] ="#{SHXT_20211230_260}",
		[3] ="#{SHXT_20211230_261}",
		[4] ="#{SHXT_20211230_262}",
		[5] ="#{SHXT_20211230_263}",
	},
	-- ÉñÊÞ
	[2] = {
		[1] ="#{SHXT_20211230_254}",
		[2] ="#{SHXT_20211230_255}",
		[3] ="#{SHXT_20211230_256}",
		[4] ="#{SHXT_20211230_257}",
		[5] ="#{SHXT_20211230_258}",
	},
}
--]]
function PetSoul_ZhuanHua_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PETSOUL_ZHUANHUA_PUTIN_ITEM");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--???????????
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetSoul_ZhuanHua_OnLoad()
	
	g_PetSoul_ZhuanHua_UnifiedPosition=PetSoul_ZhuanHua_Frame:GetProperty("UnifiedPosition")
	
	g_PetSoul_ZhuanHua_PetSoulPieceCtrl[1] = PetSoul_ZhuanHua_Icon1
	g_PetSoul_ZhuanHua_PetSoulPieceCtrl[2] = PetSoul_ZhuanHua_Icon2
	
end

function PetSoul_ZhuanHua_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012801 ) then
		
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			PetSoul_ZhuanHua_Clear();
			OpenWindow("Packet")
			this:Show()
		end
		
		if this:IsVisible() then
			g_PetSoul_ZhuanHua_targetId = Get_XParam_INT( 1 )
			PetSoul_ZhuanHua_BeginCareObject( g_PetSoul_ZhuanHua_targetId )
		end
		
	elseif event == "PETSOUL_ZHUANHUA_PUTIN_ITEM" and this:IsVisible() then
		if arg0 ~= nil and arg1 ~= nil then
			PetSoul_ZhuanHua_Update( tonumber(arg0), tonumber(arg1), 0 )
		end
		
	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if tonumber(arg0) == 15 then
			PetSoul_ZhuanHua_Resume(1)
		elseif tonumber(arg0) >= 16 then
			PetSoul_ZhuanHua_Resume(2);
		end
								
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		PetSoul_ZhuanHua_Update( 0, g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[1], 1 )
		PetSoul_ZhuanHua_Update( 1, g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[2], 1 )
		
		return
					
	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_ZhuanHua_NpcId) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_ZhuanHua_Close()
		end
		return
		
	elseif event == "ADJEST_UI_POS" then
		PetSoul_ZhuanHua_On_ResetPos()
		return
	
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_ZhuanHua_On_ResetPos()
		return
	end
	
end

function PetSoul_ZhuanHua_IsCommonPiece(nItemTableIndex)
	local nCount=table.getn(g_PetSoul_ZhuanHua_CommonPiece)
	for i=1,nCount do
		if nItemTableIndex == g_PetSoul_ZhuanHua_CommonPiece[i] then
			return 1
		end
	end
	return 0
end

-- uiPos:0~1 ·Åµ½»êÓñ¸ñ; -1 Ñ° Ò¿ ÏÐµÄ»êÓñ¸ñ
function PetSoul_ZhuanHua_Update( uiPos, bagPos, bItemChanged )

	if bItemChanged == nil then
		bItemChanged = 0;
	end
			
	-- Ñ° Ò¿ ÏÐµÄ»êÓñ¸ñ
	if uiPos == -1 then
		if g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[1] < 0 then
			uiPos = 0;
		elseif g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[2] < 0 then
			uiPos = 1
		else
			uiPos = 0;
		end
	end
	uiPos = uiPos + 1;
	
	local uiOtherPos = 1
	if uiPos == 1 then
		uiOtherPos = 2
	end
	
	--PushDebugMessage("PetSoul_ZhuanHua_Update2.."..uiPos.." "..uiOtherPos)
	
	--¼ì²éÊÇ·ñÎª»êÓñ
	local nItemIndex = PlayerPackage:GetItemTableIndex(bagPos);
	local nItemCount = PlayerPackage:GetBagItemNum(bagPos);
	local nPsIndex, nPsQual = Pet:LuaFnGetPetSoulPieceInfo( nItemIndex );
	if nItemIndex == nil or nItemCount == nil or nItemCount<=0 then
		PetSoul_ZhuanHua_Resume( uiPos )
		return
	end
	if PetSoul_ZhuanHua_IsCommonPiece(nItemIndex) > 0 then
		PushDebugMessage("#{SHXT_221104_14}")
		return
	end
	if nPsIndex == nil or nPsQual == nil then
		PushDebugMessage("#{SHXT_20211230_111}")
		return
	end

	--³¬ÉñÊÞ»ê²»ÄÜ±»×ª»¯
	if(nPsQual == 3)then
		PushDebugMessage("#{SHXT_221104_1}")
		return
	end
	
	if bItemChanged > 0 and g_PetSoul_ZhuanHua_PetSoulPieceItemIndex[uiPos] ~= nItemIndex then
		PetSoul_ZhuanHua_Resume( uiPos )
		return
	end
	
	-- ÊÇ·ñÍ¬Æ·ÖÊ
	if g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[uiOtherPos] == nil or g_PetSoul_ZhuanHua_PetSoulPieceQual[uiOtherPos] == nil then
		return
	end
	if g_PetSoul_ZhuanHua_PetSoulPieceQual[uiOtherPos] > -1 and g_PetSoul_ZhuanHua_PetSoulPieceQual[uiOtherPos] ~= nPsQual then
		PushDebugMessage("#{SHXT_20211230_283}")
		return
	end
	
	--¼ì²éÊÇ·ñ¼ÓËø
	if PlayerPackage:IsLock( bagPos ) == 1 then
		PushDebugMessage("#{SHXT_20211230_65}")	--?????
		return
	end
	
	if g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[uiPos] ~= -1 then
		LifeAbility : Lock_Packet_Item(g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[uiPos],0);
	end
		
	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() == 0 then
		return
	end
	g_PetSoul_ZhuanHua_PetSoulPieceCtrl[uiPos]:SetActionItem(theAction:GetID());
	LifeAbility : Lock_Packet_Item(bagPos,1);
	g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[uiPos] = bagPos
	g_PetSoul_ZhuanHua_PetSoulPieceItemIndex[uiPos] = nItemIndex 
	g_PetSoul_ZhuanHua_PetSoulPieceQual[uiPos] = nPsQual; 
		
	PetSoul_ZhuanHua_Refresh_UI()

end

function PetSoul_ZhuanHua_Resume( index )
	if g_PetSoul_ZhuanHua_PetSoulPieceCtrl[index] == nil then
		return
	end
	
	if g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[index] ~= nil and
		g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[index] >= 0 then
		LifeAbility : Lock_Packet_Item(g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[index],0);
		g_PetSoul_ZhuanHua_PetSoulPieceCtrl[index]:SetActionItem(-1);
		g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[index] = -1;
		g_PetSoul_ZhuanHua_PetSoulPieceItemIndex[index] = -1; 
		g_PetSoul_ZhuanHua_PetSoulPieceQual[index] = -1;
	end
	
	PetSoul_ZhuanHua_Refresh_UI()

end

function PetSoul_ZhuanHua_Clear()
	PetSoul_ZhuanHua_Resume(1)
	PetSoul_ZhuanHua_Resume(2)
	
	PetSoul_ZhuanHua_Refresh_UI()
		
end

function PetSoul_ZhuanHua_Refresh_UI()

	PetSoul_ZhuanHua_OK:Disable();
	
	local nPsQual = g_PetSoul_ZhuanHua_PetSoulPieceQual[1];
	if nPsQual == -1 then
		nPsQual = g_PetSoul_ZhuanHua_PetSoulPieceQual[2];
	end

	if g_PetSoul_ZhuanHua_PetSoulPieceComboQual ~= nPsQual then
		PetSoul_ZhuanHua_Bind:SetText("");
		PetSoul_ZhuanHua_Bind:ResetList();
		g_PetSoul_ZhuanHua_PetSoulPieceComboQual = nPsQual;
		
		local PetSoulPieceDest=g_PetSoul_ZhuanHua_Qual_Dest[nPsQual];
		if PetSoulPieceDest == nil then
			return
		end
	
		for i=1, table.getn(PetSoulPieceDest) do
			PetSoul_ZhuanHua_Bind:ComboBoxAddItem(PetSoulPieceDest[i], i);
		end
		
	end
	
	local nSelName, nSelID = PetSoul_ZhuanHua_Bind:GetCurrentSelect();
	if nSelID > 0 then
		PetSoul_ZhuanHua_OK:Enable();
	end
	
end

function PetSoul_ZhuanHua_DstChanged()
	PetSoul_ZhuanHua_Refresh_UI()
end

function PetSoul_ZhuanHua_Buttons_Clicked()

	--¶þ¼¶ÃÜÂë µç»°ÃÜ±£¼ì²é
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	
	local nSelName, nSelID = PetSoul_ZhuanHua_Bind:GetCurrentSelect();
	if nSelID <= 0 then
		return
	end
		
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 800128 )
		Set_XSCRIPT_Function_Name( "OnPetSoulPieceZhuanHua" )
		Set_XSCRIPT_Parameter(0, g_PetSoul_ZhuanHua_targetId)
		Set_XSCRIPT_Parameter(1, g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[1])
		Set_XSCRIPT_Parameter(2, g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[2])
		Set_XSCRIPT_Parameter(3, nSelID)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function PetSoul_ZhuanHua_BeginCareObject( objCaredId )
	g_PetSoul_ZhuanHua_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_ZhuanHua_NpcId == -1 then
		this : Hide()
		return
	end

	this : CareObject( g_PetSoul_ZhuanHua_NpcId, 1, "PetSoul_ZhuanHua" )
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function PetSoul_ZhuanHua_StopCareObject()
	this : CareObject( g_PetSoul_ZhuanHua_NpcId, 0, "PetSoul_ZhuanHua" )
	g_PetSoul_ZhuanHua_NpcId = -1
end

function PetSoul_ZhuanHua_On_ResetPos()
  PetSoul_ZhuanHua_Frame:SetProperty("UnifiedPosition", g_PetSoul_ZhuanHua_UnifiedPosition)
end

function PetSoul_ZhuanHua_OnHiden()
	PetSoul_ZhuanHua_StopCareObject();
	
	PetSoul_ZhuanHua_Clear();	
end

function PetSoul_ZhuanHua_Close()
	this:Hide()
end

