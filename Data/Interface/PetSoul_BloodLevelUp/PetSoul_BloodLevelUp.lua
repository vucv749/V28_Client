--PetSoul_BloodLevelUp

local g_PetSoul_BloodLevelUp_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_BloodLevelUp_NpcId = -1;
local g_PetSoul_BloodLevelUp_targetId = -1;
local g_PetSoul_BloodLevelUp_PetSoulBagIndex = -1
local g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex=-1
local g_PetSoul_BloodLevelUp_PetSoulPieceBagCount=0
local g_PetSoul_BloodLevelUp_ConfirmWaste = 0;
local g_PetSoul_BloodLevelUp_ConfirmBind = 0;
	
local g_PetSoul_BloodLevelUp_PieceCtrl = {};	

local g_PetSoul_BloodLevelUp_CommonPiece = {
	[38002741] = 10,
	[38002742] = 100,
}

function PetSoul_BloodLevelUp_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PETSOUL_BLOODLEVELUP_PUTIN_ITEM");
	this:RegisterEvent("PETSOUL_BLOODLEVELUP_CONFIRM");
	this:RegisterEvent("PETSOUL_BLOODLEVELUP_BINDCONFIRM");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--背包中物品改变需要判断
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetSoul_BloodLevelUp_OnLoad()
	
	g_PetSoul_BloodLevelUp_UnifiedPosition=PetSoul_BloodLevelUp_Frame:GetProperty("UnifiedPosition")
	
	g_PetSoul_BloodLevelUp_ConfirmWaste = 0;
	g_PetSoul_BloodLevelUp_ConfirmBind = 0;
end

function PetSoul_BloodLevelUp_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012702 ) then
		
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			PetSoul_BloodLevelUp_Clear();
			OpenWindow("Packet")
			g_PetSoul_BloodLevelUp_ConfirmWaste = 0;
			g_PetSoul_BloodLevelUp_ConfirmBind = 0;
			this:Show()
		end
		
		if this:IsVisible() then
			g_PetSoul_BloodLevelUp_targetId = Get_XParam_INT( 1 )
			PetSoul_BloodLevelUp_BeginCareObject( g_PetSoul_BloodLevelUp_targetId )
		end
		
	elseif event == "PETSOUL_BLOODLEVELUP_PUTIN_ITEM" and this:IsVisible() then
		if arg0 ~= nil and arg1 ~= nil then
			PetSoul_BloodLevelUp_Update( tonumber(arg0), tonumber(arg1), 0 )
		end
		
	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if tonumber(arg0) == 13 then
			PetSoul_BloodLevelUp_Resume_PetSoul()
		elseif tonumber(arg0) >= 14 then
			PetSoul_BloodLevelUp_Resume_Piece();
		end
								
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
						
		if tonumber(arg0) == g_PetSoul_BloodLevelUp_PetSoulBagIndex then
			PetSoul_BloodLevelUp_Update( 0, g_PetSoul_BloodLevelUp_PetSoulBagIndex, 1)
		end 
		
		if g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex >= 0 then
			PetSoul_BloodLevelUp_Resume_Piece();
		end
		
		return
		
	elseif event == "PETSOUL_BLOODLEVELUP_CONFIRM" and this:IsVisible() then
		g_PetSoul_BloodLevelUp_ConfirmWaste = 1;
		return
	
	elseif event == "PETSOUL_BLOODLEVELUP_BINDCONFIRM" and this:IsVisible() then
		g_PetSoul_BloodLevelUp_ConfirmBind = 1;
		return	
			
	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_BloodLevelUp_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_BloodLevelUp_Close()
		end
		return
		
	elseif event == "ADJEST_UI_POS" then
		PetSoul_BloodLevelUp_On_ResetPos()
		return
	
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_BloodLevelUp_On_ResetPos()
		return
	end
	
end

-- uiPos:0放到兽魂格; 1~4 放到魂玉格; -1 寻找空闲的魂玉格
function PetSoul_BloodLevelUp_Update( uiPos, bagPos, bItemChanged )

	if bItemChanged == nil then
		bItemChanged = 0;
	end
	
	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() == 0 then
		return
	end
			
	-- 寻找空闲的魂玉格
	if uiPos == -1 then
		if g_PetSoul_BloodLevelUp_PetSoulBagIndex >= 0 then
			uiPos = 1;
		else
			uiPos = 0
		end
	end
	
	if uiPos == 0 then
		--检查是否为兽魂
		local nLevel=PlayerPackage:LuaFnGetPetSoulDataInBag( bagPos, "LEVEL")
		local nBloodRank =PlayerPackage:LuaFnGetPetSoulDataInBag( bagPos, "BR")
		local nBloodConcentrate =PlayerPackage:LuaFnGetPetSoulDataInBag( bagPos, "BC")
		local nMaxBloodConcentrate =PlayerPackage:LuaFnGetPetSoulDataInBag( bagPos, "MAXBC")
		if nLevel == nil or nBloodRank == nil or nBloodConcentrate == nil or nMaxBloodConcentrate == nil then
			PushDebugMessage("#{SHXT_20211230_79}")
			return
		end
						
		--检查兽魂魂境等级是否满级
		if nBloodRank >= 5 then
			if bItemChanged == 0 then
				PushDebugMessage("#{SHXT_20211230_80}" )
			end
			return
		end
		
		--当前拥有的魂意值是否大于该兽魂当前等级升级所需魂意值
		if nBloodConcentrate >= nMaxBloodConcentrate then
			PushDebugMessage("#{SHXT_20211230_81}" )
			return
		end
		
		if g_PetSoul_BloodLevelUp_PetSoulBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_BloodLevelUp_PetSoulBagIndex,0);
		end
		
		if g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex ~= nil and
			g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex >= 0 then
			PetSoul_BloodLevelUp_Resume_Piece()
		end
		
		PetSoul_BloodLevelUp_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);
		g_PetSoul_BloodLevelUp_PetSoulBagIndex = bagPos
		
	elseif( uiPos == 1 ) then

		local nItemIndex = PlayerPackage:GetItemTableIndex(bagPos);
		local nItemCount = PlayerPackage:GetBagItemNum(bagPos);

		--通用魂玉特写 每个通用魂玉统一加一样的值
		if(g_PetSoul_BloodLevelUp_CommonPiece[nItemIndex] ~= nil)then

			--检查是否加锁
			if PlayerPackage:IsLock( bagPos ) == 1 then
				PushDebugMessage("#{SHXT_20211230_65}")	--道具已上锁
				return
			end
			
			--是否已放入被提升兽魂
			if g_PetSoul_BloodLevelUp_PetSoulBagIndex < 0 then
				PushDebugMessage("#{SHXT_20211230_83}" )
				return
			end
			local nPetSoulQual =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "QUAL")
			local nBloodConcentrate =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "BC")
			local nMaxBloodConcentrate =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "MAXBC")
			if nPetSoulQual == nil or nBloodConcentrate == nil or nMaxBloodConcentrate == nil then
				PushDebugMessage("#{SHXT_20211230_83}")
				return
			end
			
			if(nPetSoulQual ~= 3 and nPetSoulQual ~= 2)then
				PushDebugMessage("#{SHXT_20211230_84}" )
				return
			end

			--兽魂的魂意值是否已满
			if nBloodConcentrate >= nMaxBloodConcentrate then
				PushDebugMessage("#{SHXT_20211230_85}" )
				return
			end
		
			if g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex ~= -1 then
				LifeAbility : Lock_Packet_Item(g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex,0);
			end
		
			PetSoul_BloodLevelUp_Piece1:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(bagPos,1);
			g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex = bagPos
			g_PetSoul_BloodLevelUp_PetSoulPieceBagCount = nItemCount;


			PetSoul_BloodLevelUp_Refresh_UI()
			return
		end
	
		--检查是否为魂玉
		local nPsIndex, nPsQual = Pet:LuaFnGetPetSoulPieceInfo( nItemIndex );
		if nItemIndex == nil or nItemCount == nil or nItemCount<=0 or nPsIndex == nil or nPsQual == nil then
			PushDebugMessage("#{SHXT_20211230_82}")
			return
		end
		
		--检查是否加锁
		if PlayerPackage:IsLock( bagPos ) == 1 then
			PushDebugMessage("#{SHXT_20211230_65}")	--道具已上锁
			return
		end
				
		--是否已放入被提升兽魂
		if g_PetSoul_BloodLevelUp_PetSoulBagIndex < 0 then
			PushDebugMessage("#{SHXT_20211230_83}" )
			return
		end
		local nPetSoulIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_BloodLevelUp_PetSoulBagIndex);
		local nPetSoulQual =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "QUAL")
		local nBloodConcentrate =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "BC")
		local nMaxBloodConcentrate =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "MAXBC")
		if nPetSoulIndex == nil or nPetSoulQual == nil or nBloodConcentrate == nil or nMaxBloodConcentrate == nil then
			PushDebugMessage("#{SHXT_20211230_83}")
			return
		end

		--检查是否是超神兽魂魂玉，超神兽魂魂玉不能被育魂吞噬
		if(nPsQual == 3)then
			PushDebugMessage("#{SHXT_221104_1}" )
			return
		end
		
		--检查兽魂和魂玉是否匹配
		if(nPetSoulQual == 3 and nPsQual ~= 2)then
			PushDebugMessage("#{SHXT_20211230_84}" )
			return
		elseif(nPetSoulQual < 3 and nPsQual ~= nPetSoulQual)then
			PushDebugMessage("#{SHXT_20211230_84}" )
			return
		end
				
		--兽魂的魂意值是否已满
		if nBloodConcentrate >= nMaxBloodConcentrate then
			PushDebugMessage("#{SHXT_20211230_85}" )
			return
		end
		
		if g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex,0);
		end
		
		PetSoul_BloodLevelUp_Piece1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);
		g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex = bagPos
		g_PetSoul_BloodLevelUp_PetSoulPieceBagCount = nItemCount; 
		
	end
		
	PetSoul_BloodLevelUp_Refresh_UI()
	
end

function PetSoul_BloodLevelUp_Resume_PetSoul()
	if g_PetSoul_BloodLevelUp_PetSoulBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(g_PetSoul_BloodLevelUp_PetSoulBagIndex,0);
		PetSoul_BloodLevelUp_Object:SetActionItem(-1);
		g_PetSoul_BloodLevelUp_PetSoulBagIndex = -1;
	end
		
	PetSoul_BloodLevelUp_Resume_Piece()
end

function PetSoul_BloodLevelUp_Resume_Piece()
	
	if g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex ~= nil and
		g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex >= 0 then
		LifeAbility : Lock_Packet_Item(g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex,0);
		PetSoul_BloodLevelUp_Piece1:SetActionItem(-1);
		g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex = -1;
		g_PetSoul_BloodLevelUp_PetSoulPieceBagCount = 0;
	end
	
	PetSoul_BloodLevelUp_Refresh_UI()
	
end

function PetSoul_BloodLevelUp_Clear()
	PetSoul_BloodLevelUp_Resume_PetSoul()
	PetSoul_BloodLevelUp_Resume_Piece()
	
	PetSoul_BloodLevelUp_Refresh_UI()
		
end

function PetSoul_BloodLevelUp_Refresh_UI()

	--魂意值显示区域
	local szText = "#{SHXT_20211230_76}";
	local nAddConValue = 0;
	if g_PetSoul_BloodLevelUp_PetSoulBagIndex >= 0  then
		local nBloodConcentrate =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "BC")
		local nMaxBloodConcentrate =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "MAXBC")
		if nBloodConcentrate == nil or nMaxBloodConcentrate == nil or nMaxBloodConcentrate <= 0 then
			return
		end
		
		if g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex >= 0 then
			local nPetSoulIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_BloodLevelUp_PetSoulBagIndex);
			local nPetSoulQual =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "QUAL")
			local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex);
			local nItemCount = PlayerPackage:GetBagItemNum(g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex);
			if nPetSoulIndex == nil or nPetSoulQual == nil or nItemIndex == nil or nItemCount == nil then
				return
			end
			
			local nPsIndex, nPsQual = Pet:LuaFnGetPetSoulPieceInfo( nItemIndex );
			if (nPsIndex == nil or nPsQual == nil) and  g_PetSoul_BloodLevelUp_CommonPiece[nItemIndex] == nil then
				return
			end
			
			--计算到顶级时需要的魂意值
			local nMaxNeedCon = PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_BloodLevelUp_PetSoulBagIndex, "MAXNEED")
			if nMaxNeedCon == nil or nMaxNeedCon < 0 then
				return
			end
			
			local nAddConPerPiece = 10;
			if(nPsQual ~= nil)then --这里分成两种道具 放入的是通常的魂玉还是通用魂玉（通用魂玉实际是个普通道具不在兽魂表里所以查不到魂玉信息）
				if(nPetSoulQual == 3 and nPsQual == 2)then
					nAddConPerPiece = 10;
					nAddConValue = 10 * nItemCount;
				elseif(nPetSoulQual == nPsQual)then
					if nPsIndex == nPetSoulIndex then
						nAddConPerPiece = 20;
						nAddConValue = 20 * nItemCount;
					else
						nAddConPerPiece = 10;
						nAddConValue = 10 * nItemCount;
					end	
				end
			elseif(g_PetSoul_BloodLevelUp_CommonPiece[nItemIndex] ~= nil)then
				nAddConPerPiece = g_PetSoul_BloodLevelUp_CommonPiece[nItemIndex] 
				nAddConValue = g_PetSoul_BloodLevelUp_CommonPiece[nItemIndex]  * nItemCount
			end
			
			if nAddConValue > nMaxNeedCon then
				nAddConValue = nAddConValue - math.floor((nAddConValue - nMaxNeedCon) / nAddConPerPiece) * nAddConPerPiece;
			end
		end
				
		if nAddConValue > 0 then
			szText = ScriptGlobal_Format("#{SHXT_20211230_78}", nBloodConcentrate, nAddConValue, nMaxBloodConcentrate )
			
		else
			szText = ScriptGlobal_Format("#{SHXT_20211230_77}", nBloodConcentrate, nMaxBloodConcentrate )
		end
		
	end
	PetSoul_BloodLevelUp_Explain_Text1:SetText(szText);
	
	--确认按钮
	if g_PetSoul_BloodLevelUp_PetSoulBagIndex >= 0 and 
		g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex >= 0 and
		nAddConValue > 0 then
		PetSoul_BloodLevelUp_OK:Enable()
	else
		PetSoul_BloodLevelUp_OK:Disable();
	end
end

function PetSoul_BloodLevelUp_Buttons_Clicked()

	--二级密码 电话密保检查
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	
	--兽魂输入框中是否已放入兽魂
	if g_PetSoul_BloodLevelUp_PetSoulBagIndex < 0 then
		PushDebugMessage("#{SHXT_20211230_83}")
		return
	end
		
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 800127 )
		Set_XSCRIPT_Function_Name( "OnPetSoulBloodLevelUp" )
		Set_XSCRIPT_Parameter(0, g_PetSoul_BloodLevelUp_targetId)
		Set_XSCRIPT_Parameter(1, g_PetSoul_BloodLevelUp_PetSoulBagIndex)
		Set_XSCRIPT_Parameter(2, g_PetSoul_BloodLevelUp_PetSoulPieceBagIndex)
		Set_XSCRIPT_Parameter(3, g_PetSoul_BloodLevelUp_ConfirmWaste)
		Set_XSCRIPT_Parameter(4, g_PetSoul_BloodLevelUp_ConfirmBind)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function PetSoul_BloodLevelUp_BeginCareObject( objCaredId )
	g_PetSoul_BloodLevelUp_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_BloodLevelUp_NpcId == -1 then
		this : Hide()
		return
	end

	this : CareObject( g_PetSoul_BloodLevelUp_NpcId, 1, "PetSoul_BloodLevelUp" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function PetSoul_BloodLevelUp_StopCareObject()
	this : CareObject( g_PetSoul_BloodLevelUp_NpcId, 0, "PetSoul_BloodLevelUp" )
	g_PetSoul_BloodLevelUp_NpcId = -1
end

function PetSoul_BloodLevelUp_On_ResetPos()
  PetSoul_BloodLevelUp_Frame:SetProperty("UnifiedPosition", g_PetSoul_BloodLevelUp_UnifiedPosition)
end

function PetSoul_BloodLevelUp_OnHiden()
	PetSoul_BloodLevelUp_StopCareObject();
	
	PetSoul_BloodLevelUp_Clear();	
end

function PetSoul_BloodLevelUp_Close()
	this:Hide()
end

