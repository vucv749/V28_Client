-- Ê±×°ÅäÊÎÏâÇ¶½çÃæ

local Dress_Enchase_CoseArray = {5000,6000,7000,8000}
local g_objCared = -1
local Dress_Gem_Buttons={}
local Dress_GEM_QUALITY = {}
local Dress_GEM_EFFECT ={}
local MAX_OBJ_DISTANCE =3.0
local Dress_Gem_Cost = {5000,6000,7000,8000}
local lastDress =-1
local lastDress_Peishi =-1
local lastDress_Xiangqianfu =-1

local g_Dress_Enchase_Frame_UnifiedPosition;

function Dress_Enchase_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_DRESS_ENCHASE")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");	
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("ENABLE_DRESS_ENCHASE_PREVIEW");
	this:RegisterEvent("DISABLE_DRESS_ENCHASE_PREVIEW");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("PROGRESSBAR_SHOW");
	this:RegisterEvent("CLOSE_DRESS_ENCHASE");	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("OPEN_DRESSPREVIEW")
end

function Dress_Enchase_OnLoad()
	--Dress_Gem_Buttons±íÊ¾xmlÀïÅäÖÃµÄ¶ÔÓ¦¿Ø¼þ
	Dress_Gem_Buttons[1] = Dress_Enchase_Item
	Dress_Gem_Buttons[2] = Dress_Enchase_Gem1;
	Dress_Gem_Buttons[3] = Dress_Enchase_Gem2;

	--Dress_GEM_QUALITY±íÊ¾buttonÀï·ÅÈëµÄÎïÆ·
	Dress_GEM_QUALITY[1] = -1;		-- ??
	Dress_GEM_QUALITY[2] = -1;		-- ??
	Dress_GEM_QUALITY[3] = -1;		-- ???
	
	Dress_GEM_EFFECT[1] = Dress_Enchase_Effect1;
	Dress_GEM_EFFECT[2] = Dress_Enchase_Effect2;
	Dress_GEM_EFFECT[3] = Dress_Enchase_Effect3;
	
	g_Dress_Enchase_Frame_UnifiedPosition=Dress_Enchase_Frame:GetProperty("UnifiedPosition");
end

function Dress_Enchase_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0)==20091029) then
		this:Show()
		
		-- ¹Ø± ¡°ÏâÇ¶Ô¤ÀÀ¡±ÊÔÒÂ¼ä
		if (IsWindowShow("DressEnchase_Fitting")) then
			DressEnchasing:RestoreDressEnchaseFitting()
			CloseWindow("DressEnchase_Fitting", true)
		end

		PushEvent( "CLOSE_DRESSPREVIEW") 	
		PushEvent( "CLOSE_GEMEFFECTPREVIEW")
		-- ½ûÓÃ¡°ÏâÇ¶Ô¤ÀÀ¡±°´Å¥
		Dress_Enchase_Preview:Disable()		
		
		Dress_Enchase_Effect1:Hide()
		Dress_Enchase_Effect2:Hide()
		Dress_Enchase_Effect3:Hide()
		
		g_objCared = -1;
		local xx = Get_XParam_INT(0);
		g_objCared = DataPool : GetNPCIDByServerID(xx);
		if g_objCared == -1 then				
				return;
		end
		BeginCareObject_Dress_Enchase(g_objCared)
		return

	-- ¿ªÊ¼°ÚÌ¯£¬²»ÄÜ½øÐÐÏâÇ¶
	elseif ( event == "OPEN_STALL_SALE" ) then
		if this:IsVisible() then
			Dress_Enchase_OnHiden();
		end
		return
	
	-- ¶Á½ø¶ÈÌõÖÐ£¬²»ÄÜ½øÐÐÏâÇ¶
	elseif ( event == "PROGRESSBAR_SHOW" ) then
		if this:IsVisible() then
			Dress_Enchase_OnHiden();
		end
		return
		
	-- Ä³Ð©¹¦ÄÜ»¥³â£¬ÐèÒª¹Ø± ¸Ã½çÃæ
	elseif ( event == "CLOSE_DRESS_ENCHASE" ) then
		if this:IsVisible() then
			Dress_Enchase_OnHiden();
		end
		return

	elseif(event == "UPDATE_DRESS_ENCHASE") then
		Dress_Enchase_Update(arg0,arg1)

		-- ¸ü»»ÁËÊ±×°»ò ßÅäÊÎ£¬¹Ø± ¡°ÏâÇ¶Ô¤ÀÀ¡±ÊÔÒÂ¼ä
		if (IsWindowShow("DressEnchase_Fitting")) and ( (tonumber(arg0) == 1) or (tonumber(arg0) == 2) ) then
			DressEnchasing : RestoreDressEnchaseFitting()
			CloseWindow("DressEnchase_Fitting", true)
		end	
		return

	elseif(event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= g_objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Dress_Enchase_OnHiden()
		end
		return

	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 3) then---xml?????D3
			Dress_Enchase_Resume_Gem(25);									-- ????
		elseif(arg0~=nil and tonumber(arg0) == 5) then
			Dress_Enchase_Resume_Gem(26)									-- ????
		elseif(arg0~=nil and tonumber(arg0) == 7) then
			Dress_Enchase_Resume_Gem(27)									-- ?????
		end
		return

	elseif( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		lastDress = -1
		lastDress_Peishi =	-1
		lastDress_Xiangqianfu = -1

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Dress_Enchase_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))

	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Dress_Enchase_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	-- ÏâÇ¶³É¹¦£¬½ûÓÃ¡°ÏâÇ¶Ô¤ÀÀ¡±°´Å¥	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 09111601 then
		if this:IsVisible() then
			Dress_Enchase_Preview:Disable()
		end

	-- ÏâÇ¶Ô¤ÀÀ½çÃæÒÑ´ò¿ª£¬½ûÓÃ¡°ÏâÇ¶Ô¤ÀÀ¡±°´Å¥	
	elseif event == "DISABLE_DRESS_ENCHASE_PREVIEW" then
		if this:IsVisible() then
			Dress_Enchase_Preview:Disable()
		end
	
	-- ÆôÓÃ¡°ÏâÇ¶Ô¤ÀÀ¡±°´Å¥	
	elseif event == "ENABLE_DRESS_ENCHASE_PREVIEW" then
		if this:IsVisible() then
			Dress_Enchase_Preview:Enable()
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		Dress_Enchase_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Dress_Enchase_Frame_On_ResetPos()
	
	end
	
	-- Ê±×°Ô¤ÀÀ
	if  ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then
		if (this:IsVisible()) then
			Dress_Enchase_OnHiden();
		end
	end
	
	
end
		
function Dress_Enchase_OnShown()
	Dress_Enchase_Clear()
	Dress_Enchase_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	Dress_Enchase_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

function Dress_Enchase_Update(ItemIndex, ItemPos)		
	local IIndex = tonumber(ItemIndex)
	local IPos = tonumber(ItemPos)
	local theActionItem = EnumAction(IPos, "packageitem")
	local needMoney = 0
	local Dress_Bore_Count = 0
	local Dress_Gem_Enchased = 0

	if theActionItem:GetID() ~= 0 then
		if IIndex == 1 then---???,????
			local equipPoint = LifeAbility:Get_Equip_Point(IPos)
			if equipPoint ~= 16 then
				PushDebugMessage("#{SZPR_091023_45}")
				return
			end

			Dress_Bore_Count = LifeAbility : GetEquip_HoleCount(IPos)		-- ???????????
			Dress_Gem_Enchased = LifeAbility : GetEquip_GemCount(IPos)	-- ?????????????
			
			if Dress_Gem_Enchased == 3 then 
				PushDebugMessage("#{SZPR_091023_47}")				-- "Cai trang phøc m¯t không th¬ Tái ðßþc khäm nhi«u h½n Ðích Ph¯i SÑc"
				return
			end

			if Dress_Bore_Count == Dress_Gem_Enchased then
				PushDebugMessage("#{SZPR_091023_87}")				-- "Cai trang phøc m¯t c¥n TÕi LÕc Dß½ng(246, 129) Y Thiên Thái XØ gia tång Kh±ng V¸ H§u m¾i có th¬ tiªp tøc ðßþc khäm"
				return
			end

			if Dress_GEM_QUALITY[IIndex] ~= -1 then
				LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[IIndex],0);
			end
			Dress_Gem_Buttons[IIndex]:SetActionItem(theActionItem:GetID());
			LifeAbility : Lock_Packet_Item(IPos,1);
			Dress_GEM_QUALITY[IIndex] = IPos	
			
			if Dress_GEM_QUALITY[2] ~=-1 and Dress_GEM_QUALITY[2] ~=0 then ---???????,??????????
				local dress_gem_count = LifeAbility : GetEquip_GemCount( Dress_GEM_QUALITY[1]);
				local Dress_Gem_Level = LifeAbility : Get_Gem_Level(Dress_GEM_QUALITY[2],1)
				needMoney = Dress_Gem_Cost[Dress_Gem_Level]*(dress_gem_count+1)
				Dress_Enchase_DemandMoney : SetProperty("MoneyNumber",needMoney);
			end
			
			--½«Ê±×°UIÏÂÃæµÄÐ¡Í¼±ê¼¤»î
				for i=1,3 do
					local szIconName = LifeAbility : GetEquip_Gem(Dress_GEM_QUALITY[1], i-1);
					if szIconName~=nil and szIconName ~= "" then
						Dress_GEM_EFFECT[i] : SetProperty("ShortImage", szIconName);
						Dress_GEM_EFFECT[i] : Show();
					else
						Dress_GEM_EFFECT[i] : Hide();
					end
				end

		elseif IIndex == 2 then---???
			local Dress_GemType = LifeAbility : Get_Gem_Level(IPos,2);
			if(Dress_GemType ~= 31 and Dress_GemType ~= 32 and Dress_GemType ~= 33) then
				PushDebugMessage("#{SZPR_091023_48}")
				return
			end
			--Èç¹ûÔ­À´ÓÐÅäÊÎ£¬¾Í½«Æä½âËø
			if Dress_GEM_QUALITY[IIndex] ~= -1 then
				LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[IIndex],0);
			end
			if Dress_GEM_QUALITY[1]== -1 then
				PushDebugMessage("#{SZPR_091023_89}")
				return
			end
			local dress_gem_count = LifeAbility : GetEquip_GemCount( Dress_GEM_QUALITY[1]);
			local Dress_Gem_Level = LifeAbility : Get_Gem_Level(IPos,1)
			needMoney = Dress_Gem_Cost[Dress_Gem_Level]*(dress_gem_count+1)
			Dress_Enchase_DemandMoney : SetProperty("MoneyNumber",needMoney);
			Dress_Gem_Buttons[IIndex]:SetActionItem(theActionItem:GetID());
			LifeAbility : Lock_Packet_Item(IPos,1);
			Dress_GEM_QUALITY[IIndex] = IPos

		elseif IIndex == 3 then---?????
			if PlayerPackage : GetItemTableIndex( IPos ) ~= 30503135 then
				PushDebugMessage("#{SZPR_091023_49}")
				return
			end
			if Dress_GEM_QUALITY[IIndex] ~= -1 then
				LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[IIndex],0);
			end
			Dress_Gem_Buttons[IIndex]:SetActionItem(theActionItem:GetID());
			LifeAbility : Lock_Packet_Item(IPos,1);
			Dress_GEM_QUALITY[IIndex] = IPos
		end
	end

	-- Ê±×°ºÍÅäÊÎ¶¼Ìá½»ºó£¬¼¤»î¡°ÏâÇ¶Ô¤ÀÀ¡±°´Å¥
	if Dress_GEM_QUALITY[1] ~= -1 and Dress_GEM_QUALITY[2] ~= -1 then
		Dress_Enchase_Preview: Enable()
	end
	
	--°ÑÈ·¶¨°´Å¥ ý³£»¯
	if Dress_GEM_QUALITY[1] ~= -1 and Dress_GEM_QUALITY[2] ~= -1 and Dress_GEM_QUALITY[3] ~= -1  then
		local userMoney = Player:GetData("MONEY_JZ")+Player:GetData("MONEY")
		local Dress_Gem_Level = LifeAbility : Get_Gem_Level(Dress_GEM_QUALITY[2],1)
		local dress_gem_count = LifeAbility : GetEquip_GemCount( Dress_GEM_QUALITY[1]);
		needMoney = Dress_Gem_Cost[Dress_Gem_Level]*(dress_gem_count+1)
		if Dress_Gem_Level < 5 and Dress_Gem_Level > 0 and needMoney~=0 and userMoney>=needMoney then
			Dress_Enchase_OK:Enable()
		end
	end
	
end

------------------------------------------------------
--
--	xmlÖÐÐèÒªµ÷ÓÃµÄº¯Êý,ÔÚÓÒ¼üµã»÷UIÖÐµÄ×°±¸Ê±È¡ÏÂ×°±¸
--
function Dress_Enchase_Resume_Gem(nIndex)

	if nIndex<25 or nIndex>27 then 
		return
	end
	
	-- Ê±×°»òÅäÊÎÓÐÒ»Ïî±»È¡ÏÂ
	if nIndex == 25 or nIndex == 26 then		
		if (IsWindowShow("DressEnchase_Fitting")) then
			DressEnchasing:RestoreDressEnchaseFitting()
			CloseWindow("DressEnchase_Fitting", true)		-- ??“????”???
		end		
		Dress_Enchase_Preview: Disable()							-- ??“????”??
	end

	local nIndex = nIndex - 24
	if( this:IsVisible() ) then
		if Dress_GEM_QUALITY[nIndex]~=nil and Dress_GEM_QUALITY[nIndex] ~= -1 then
			Dress_Gem_Buttons[nIndex]:SetActionItem(-1)			
			LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[nIndex],0);
			Dress_GEM_QUALITY[nIndex] = -1
			if nIndex == 1 then
				for i = 1,3 do
					Dress_GEM_EFFECT[i] : Hide()
				end
			end
			if nIndex == 2 or nIndex == 1 then
				Dress_Enchase_DemandMoney : SetProperty("MoneyNumber", 0);
			end
		end
	end
	
	Dress_Enchase_OK:Disable()
end

function Dress_Enchase_Clear()
	for i=1,3 do 
		if Dress_GEM_QUALITY[i] ~= -1 then
			Dress_Gem_Buttons[i]:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[i],0);
			Dress_GEM_QUALITY[i] = -1
		end
	end

	for i = 1,3 do
		Dress_GEM_EFFECT[i] : Hide();
	end
	Dress_Enchase_DemandMoney : SetProperty("MoneyNumber", 0);

	Dress_Enchase_OK:Disable()								-- ??“??”??
	Dress_Enchase_Preview:Disable()						-- ??“????”??

	lastDress = -1
	lastDress_Peishi =	-1
	lastDress_Xiangqianfu = -1
end

function Dress_Enchase_OnHiden()
	StopCareObject_Dress_Enchase(g_objCared)
	Dress_Enchase_Clear()
	
	-- ¹Ø± ¡°ÏâÇ¶Ô¤ÀÀ¡±ÊÔÒÂ¼ä
	if (IsWindowShow("DressEnchase_Fitting")) then
		DressEnchasing:RestoreDressEnchaseFitting()
		CloseWindow("DressEnchase_Fitting", true)
	end

	this:Hide()
end

------------------------------------------------------
--
--	´ò¿ª¡°ÏâÇ¶Ô¤ÀÀ¡±ÊÔÒÂ¼ä
--
function DressEnchase_Preview_Clicked()
	
	if (IsWindowShow("DressEnchase_Fitting")) then
		-- ÏÈÇå¿ µ±Ç°ÊÔÒÂ¼äµÄÊý¾Ý
		DressEnchasing:RestoreDressEnchaseFitting();
	end
	
	-- ´ò¿ªÊÔÒÂ¼ä£¬ÏÔÊ¾ÊÔÒÂÐ§¹û
	DressEnchasing:OpenDressEnchaseFitting( Dress_GEM_QUALITY[1], Dress_GEM_QUALITY[2], Dress_Gem_Enchased )

end

------------------------------------------------------
--
--	¹ØÐÄNPC
--
function BeginCareObject_Dress_Enchase(objCaredId)
	g_objCared = objCaredId;
	this:CareObject(objCaredId, 1, "Dress_Enchase");
end

function StopCareObject_Dress_Enchase(objCaredId)
	this:CareObject(objCaredId, 0, "Dress_Enchase")
	g_objCared = -1
end

function Dress_Enchase_Buttons_Clicked()
	
	--Ìõ¼þ¼ì²éÒÑ¾­¼ì²é¹ý£¬°´Å¥¿Éµã»÷
	local Notify = 0	
	if (lastDress ~= Dress_GEM_QUALITY[1]
		or lastDress_Peishi ~=	Dress_GEM_QUALITY[2]
		or lastDress_Xiangqianfu ~= Dress_GEM_QUALITY[3]) then
		lastDress = Dress_GEM_QUALITY[1]
		lastDress_Peishi =	Dress_GEM_QUALITY[2]
		lastDress_Xiangqianfu = Dress_GEM_QUALITY[3]
		Notify = 1;		
	end
	
	if( Notify == 1) then
		--ÅÐ¶Ï°ó¶¨
		local Dress_Bind = 0
		local Dress_Gem_Bind = 0
		local Dress_Xiangqianfu_Bind = 0
		if Dress_GEM_QUALITY[1] ~=-1 then
			Dress_Bind = Dress_Enchase_IsBind(Dress_GEM_QUALITY[1])
		end
		if Dress_GEM_QUALITY[2] ~=-1 then
			Dress_Gem_Bind = Dress_Enchase_IsBind(Dress_GEM_QUALITY[2])
		end
		if Dress_GEM_QUALITY[3] ~=-1 then
			Dress_Xiangqianfu_Bind = Dress_Enchase_IsBind(Dress_GEM_QUALITY[3])
		end
		
		local nItemId = PlayerPackage : GetItemTableIndex( Dress_GEM_QUALITY[1] )
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nItemId, "Number")
		if(Dress_Bind == 1 or Dress_Gem_Bind == 1 or Dress_Xiangqianfu_Bind == 1) and (PlayerPackage : GetItemTableIndex( Dress_GEM_QUALITY[1] ) ~= 10124391) and (nFashionNumber <= 0) then
			DressEnchasing:Dress_EnchaseShowInfo("SZPR_XML_51")
			return
		-- else
		-- 	DressEnchasing:Dress_EnchaseShowInfo("SZPR_XML_50")
		-- 	return
		end
	end
	
	-- ¹Ø± ¡°ÏâÇ¶Ô¤ÀÀ¡±ÊÔÒÂ¼ä
	if (IsWindowShow("DressEnchase_Fitting")) then
		DressEnchasing:RestoreDressEnchaseFitting()
		CloseWindow("DressEnchase_Fitting", true)
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnDress_Enchase");
		Set_XSCRIPT_ScriptID(830013);
		Set_XSCRIPT_Parameter(0,Dress_GEM_QUALITY[1]);
		Set_XSCRIPT_Parameter(1,Dress_GEM_QUALITY[2]);
		Set_XSCRIPT_Parameter(2,Dress_GEM_QUALITY[3]);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();

	--Çå¿ ½çÃæºÍÖÃÒ»Ð©¶¯Ì¬ÖµÎª¿ 
	for i=1,3 do
		if(Dress_Gem_Buttons[i] ~=-1) then
			Dress_Gem_Buttons[i]:SetActionItem(-1)			
			LifeAbility : Lock_Packet_Item(Dress_GEM_QUALITY[i],0);
			Dress_GEM_QUALITY[i] = -1
			Dress_GEM_EFFECT[i] : Hide()
		end
	end
	Dress_Enchase_DemandMoney : SetProperty("MoneyNumber", 0);
	Dress_Enchase_OK:Disable()

end

function Dress_Enchase_IsBind(ItemID)
	if(GetItemBindStatus(ItemID) == 1) then
		return 1;
	else
		return 0;
	end
end

function Dress_Enchase_Cancel_Clicked()
	Dress_Enchase_Close();
	return;
end


function Dress_Enchase_Frame_On_ResetPos()
  Dress_Enchase_Frame:SetProperty("UnifiedPosition", g_Dress_Enchase_Frame_UnifiedPosition);
end
