
--add:2015
local g_Huantong_YBConfirm = 1
local g_IsHuantongForCZLConfirm = 0

local g_uitype = 1
local g_serverScriptId = 311111
local g_serverNpcId = -1
local g_clientNpcId = -1
local g_ItemPos		= -1
local g_NeedMoney	= -1
local g_selidx		= -1
local g_ItemID		= -1
local g_Contrl		= false
local MAX_OBJ_DISTANCE = 3.0
local g_DefaultTxt = "–ﬂa ’o c¯ c•n d˘ng v‡o Ù ’o c¯."
local g_Model1IsEnabel = 0
local g_Model2IsEnabel = 0
--≥¨º∂†‰ ﬁªπÕØÃÏ È
local g_HuanTongCJTS = {30503016,30503017,30503018,30503019,30503020}
--ƒ‹πª∑≈»ÎΩÁ√Ê÷–µƒŒÔ∆∑ ø™ º
local g_HuanTongMin1 = 30503011
local g_HuanTongMax1 = 30503020
local g_HuanTongMin2 = 30309100
local g_HuanTongMax2 = 30309500
local g_HuanTongCD = 1000
local g_HuanTongLastTime = 0
--ƒ‹πª∑≈»ÎΩÁ√Ê÷–µƒŒÔ∆∑ Ω· ¯
--∏˜∏ˆµ»º∂ªπÕØµƒ†‰ ﬁÀ˘–Ë“™µƒΩ«Æ
local g_tbabaymoney  = {
							[5]		= 5000,
							[15]	= 6000,
							[20]	= 7000,
							[25]	= 7000,
							[35]	= 10000,
							[45]	= 15000,
							[55]	= 25000,
							[65]	= 40000,
							[75]	= 55000,
							[85]	= 70000,
							[95]	= 85000,
							[105]	= 100000,
						}

-- ŒÚ–‘µ»º∂∂‘”¶‘™±¶
local g_YuanBaoCosts = {
	[1] = 2280,
	[5] = 2300,
	[15] = 2320,
	[20] = 2340,
	[30] = 2380,
	[45] = 3320,
	[55] = 3420,
	[65] = 3580,
	[75] = 4700,
	[85] = 4860,
	[95] = 18200,
}
local g_Pethuantong_Frame_UnifiedPosition;

local WuXingTbl = {
			{level =1,	per = "1.0%" ,	maxlevel=1,	color = "#c00D000"},
			{level =2,	per = "1.5%" ,	maxlevel=1,	color = "#c00D000"},
			{level =3,	per = "2.1%" ,	maxlevel=2,	color = "#c00D000"},
			{level =4,	per = "3.0%" ,	maxlevel=2,	color = "#c00D000"},
			{level =5,	per = "8.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =6,	per = "11.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =7,	per = "14.5%" ,	maxlevel=4,	color = "#c43DBFF"},
			{level =8,	per = "23.5%" ,	maxlevel=4,	color = "#cFF8001"},
			{level =9,	per = "30.0%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =10,	per = "39.3%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =11,	per = "42.3%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =12,	per = "46.0%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =13,	per = "50.2%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =14,	per = "54.7%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =15,	per = "59.5%", maxlevel=5,	color = "#cFF8001"},
}

local ShowColor = "#H";
--****************************************
--◊¢≤·œ˚œ¢
--****************************************
function Pethuantong_PreLoad()
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "DELETE_PET" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )
	this : RegisterEvent( "UPDATE_PET_PAGE" )
	this : RegisterEvent( "REPLY_MISSION_PET" )
	this : RegisterEvent( "OBJECT_CARED_EVENT" )
	this : RegisterEvent( "PACKAGE_ITEM_CHANGED" )
	this : RegisterEvent( "UPDATE_PET_HUANTONG" )
	this : RegisterEvent( "NEW_DEBUGMESSAGE" )
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this : RegisterEvent("QUICKUP_PET_SENDMSG")				--????
	this:RegisterEvent("BUY_ITEM")				--add:lby????????,??????
end

--****************************************
--
--****************************************
function Pethuantong_OnLoad()
    g_Pethuantong_Frame_UnifiedPosition=Pethuantong_Frame:GetProperty("UnifiedPosition");
end

--****************************************
--¥•∑¢ ¬º˛œ˚œ¢
--****************************************
function Pethuantong_OnEvent(event)
	if	   ( event == "UI_COMMAND" ) 		then
		Pethuantong_UiCommand(arg0)

	elseif ( event == "UNIT_MONEY" )		then
		Pethuantong_ShowMoney()

	elseif ( event == "DELETE_PET" and this:IsVisible() ) 		then
		Pethuantong_Hide()

	elseif ( event == "MONEYJZ_CHANGE")		then
		Pethuantong_ShowJZ()

	elseif ( event == "UPDATE_PET_PAGE") 	then
		Pethuantong_Show()

	elseif ( event == "REPLY_MISSION_PET") 	then
		Pethuantong_Selected(arg0)

	elseif ( event == "OBJECT_CARED_EVENT") then
		Pethuantong_CareObj(arg0,arg1,arg2)

	elseif ( event == "UPDATE_PET_HUANTONG") then
		Pethuantong_Update(arg0)

	elseif ( event == "PACKAGE_ITEM_CHANGED") then
		if ( arg0 ~= nil and -1 == tonumber(arg0)) then
			return
		end

		if tonumber(arg0) == g_ItemPos then
			if (g_ItemID ~= -1) then
				local nextPos = PlayerPackage : GetBagPosByItemIndex(g_ItemID)
				if nextPos >=0 then
					Pethuantong_Update(nextPos)
				else
					Pethuantong_Resume_Equip_Gem()
				end
			else
				Pethuantong_Resume_Equip_Gem()
			end
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		Pethuantong_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Pethuantong_Frame_On_ResetPos()

	elseif event == "BUY_ITEM" and this:IsVisible() then	--add:lby2015
	
		local item = tonumber(arg1)
		if(g_selidx == -1) then
			return
		end
		
		local takelevel = Pet : GetTakeLevel( g_selidx )
		local _material =-1
		
		if takelevel <= 35 then
			_material = 30503017
		elseif takelevel <= 65 then
			_material = 30503018
		elseif takelevel <= 85 then
			_material = 30503019
		elseif takelevel <= 95 then
			_material = 30503020
		end
		
		if _material ~= item then 
			return
		end
		
		Pethuantong_Update(PlayerPackage:GetBagPosByItemIndex(item))
	end

	if (event == "QUICKUP_PET_SENDMSG") and (tonumber(arg0) == 4) then
		Pethuantong_ExeScript()
	end
	
	if (event == "QUICKUP_PET_SENDMSG") and (tonumber(arg0) == 5) then --add:lby 2015
		g_IsHuantongForCZLConfirm = 1
	end
end

--*************************************************
-- π”√UICOMMAND
--*************************************************
function Pethuantong_UiCommand(Param)
	local nOp = tonumber(Param)
	if (nOp == 20090929) then
		local check  = tonumber(Pet:GetYuanbaoBuyState(0));--add:lby 2015
			if(check>=1)then
			Pethuantong_Yuanbao_Bind:SetCheck(0);
		else
			Pethuantong_Yuanbao_Bind:SetCheck(1);
		
		end	
		
		Pethuantong_Open()
		--Pethuantong_Yuanbao_Bind:SetCheck(g_Huantong_YBConfirm)--add:lby
	elseif (nOp == 20091130) then
		if (g_selidx ~= -1) then
			Pethuantong_PetModel : SetFakeObject("")
			Pet : SethuantongModel(g_selidx)
			Pethuantong_PetModel : SetFakeObject("My_Pethuantong")
			Pet : SetPetLocation(g_selidx,9)
		else

		end
	end
end

--*************************************************
--œ‘ æ†‰ ﬁªπÕØΩÁ√Ê
--*************************************************
function Pethuantong_Open()
	g_HuanTongLastTime = 0
	g_IsHuantongForCZLConfirm = 0 --add:lby 2015
	Pethuantong_Clear(0)
	g_serverNpcId = Get_XParam_INT(0)
	g_clientNpcId = Target : GetServerId2ClientId(g_serverNpcId)
	if (g_clientNpcId == -1) then
		return
	end

	this : CareObject(g_clientNpcId, 1, "Pethuantong")

	Pethuantong_PetModel : SetFakeObject("")
	--Pethuantong_Mode1 : SetCheck(0)
	--Pethuantong_Mode2 : SetCheck(0)
	g_uitype = Get_XParam_INT(1)
	if ( g_selidx ~= -1 ) then
		Pet : SetPetLocation(g_selidx, -1)
	end
	g_selidx = -1

	Pet : ShowPetList(0)
	Pet : ShowPetList(1)
	this : Show()
	Pethuantong_Pet_Attr_Update()
	Pethuantong_ShowMoney()
	Pethuantong_ShowJZ()
end

--*************************************************
--πÿ±††‰ ﬁªπÕØΩÁ√Ê
--*************************************************
function Pethuantong_Hide()
	if (this : IsVisible() == false) then
		return
	end

	if (g_clientNpcId ~= -1) then
		this : CareObject(g_clientNpcId, 0, "Pethuantong")
	end

	this: Hide()
	Pet : ShowPetList(-1)
	Pethuantong_PetModel : SetFakeObject("")
	if (-1 ~= g_selidx) then
		Pet : SetPetLocation(g_selidx, -1)
	end
	g_selidx = -1

	--πÿ±†∂˛¥Œ»∑»œΩÁ√Ê
	PushEvent("CONVENIENT_BUY_CONFIRM_CLOSE");
end

--*************************************************
--»∑∂®∞¥≈•
--*************************************************
function Pethuantong_Do()

	--‘ˆº”15º∂≈–∂œ
	local mylevel = Player:GetData("LEVEL");
	if mylevel < 15 then
		PushDebugMessage("#{ZSKJT_130717_01}")
		return 0
	end
	--≈–∂œµÁª∞√‹±£∫Õ∂˛º∂√‹¬Î±£ª§2012.6.12-LIUBO
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return 0
	end
	
	-- «∑Ò—°‘Ò†‰ ﬁ
	if (-1 == g_selidx) then
		PushDebugMessage("#{HTQR_091010_5}")
		return 0
	end

	-- «∑ÒÀ¯∂®
	if (Pet:IsProtect(g_selidx) == 1) then
		PushDebugMessage("#{ZSKSSJ_081113_06}")
		return 0
	end

	-- «∑Ò‘⁄≥ˆ†Ω
	local petname,status = Pet:GetPetList_Appoint(g_selidx)
	if (status == "on_fight") then
		PushDebugMessage("#{ZSKJT_130428_23}")
		return 0
	end

	-- «∑Òª√ªØ
	local gen = Pet:GetType(g_selidx)
	if gen == nil or gen >= 100 then	--100???????
		PushDebugMessage("#{RXZS_090804_29}")
		return 0
	end

	-- «∑Ò±‰“Ï
	local nPetType = Pet : GetPetType(g_selidx);
	if nPetType == 1 then
		PushDebugMessage("#{ZSKJT_130428_24}")
		return 0
	end

	-- «∑Ò”–†‰ ﬁ◊∞±∏
	if Pet:IsPetHaveEquip(g_selidx) == 1 then
		PushDebugMessage("#{ZSZB_090211_18}")
		return 0
	end
	
	--”–Œﬁ≈‰≈º
	local strName = Pet : GetConsort(g_selidx)
	if tonumber(strName) ~= 0 then
		PushDebugMessage("#{ResultText_73}")
		return 0
	end
	
	--2020.02.21‘ˆº”∞¥≈•CD
	local curTime = OSAPI:GetTickCount()
	if ( curTime - g_HuanTongLastTime < g_HuanTongCD) then
		PushDebugMessage("#{ZQGZ_110512_23}")
		return 0
	end

--≥…≥§¬ …œœﬁ
	local growlimit = Pet:GetGrowRate4( g_selidx ); --add:lby 2015
	local growrate = Pet:GetGrowRate( g_selidx );
	if	growrate >= growlimit then		
		local bSelected2 = Pethuantong_Mode2:GetCheck() 		
		if g_IsHuantongForCZLConfirm == 0 and bSelected2 == 0 and nPetType == 0 then
			Pethuantong_CZL_Confirm()
			return 0
		end
	end

	if (-1 == g_ItemPos) then --??????????????add:lby2015
--		PushDebugMessage("–Ë“™ªπÕØæÌ÷·°£")
		PetHuantong_PetYuanbaoBuyTSAsk()
		return 0
	end

	-- «∑ÒΩ«Æ◊„πª
	local nHaveMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if (nHaveMoney < g_NeedMoney) then
		PushDebugMessage("#{ZSYB_160113_27}")
		return 0
	end

	--
	local nItemID = PlayerPackage : GetItemTableIndex( g_ItemPos )
	g_ItemID = nItemID
	local bRet = 0
	for i=1,table.getn(g_HuanTongCJTS) do
		if (g_HuanTongCJTS[i] == nItemID) then
			bRet = 1
		end
	end

	if (bRet ~= 1) then
		Pet : SkillStudy_Do(2, g_selidx, g_ItemPos)
	else
		local bSelected1 = 0
		if (g_Model1IsEnabel == 1) then
			bSelected1 = Pethuantong_Mode1:GetCheck()
		end

		local bSelected2 = 0
		if (g_Model2IsEnabel == 1) then
			bSelected2 = Pethuantong_Mode2:GetCheck()
		end

		local hid,lid = Pet:GetGUID(g_selidx)
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnPropagate")
			Set_XSCRIPT_ScriptID(311111)
			Set_XSCRIPT_Parameter(0,g_serverNpcId)
			Set_XSCRIPT_Parameter(1,hid)
			Set_XSCRIPT_Parameter(2,lid)
			Set_XSCRIPT_Parameter(3,bSelected1)
			Set_XSCRIPT_Parameter(4,bSelected2)
			Set_XSCRIPT_Parameter(5,g_ItemPos)
			Set_XSCRIPT_Parameter(6,g_IsHuantongForCZLConfirm)
			Set_XSCRIPT_ParamCount(7)
		Send_XSCRIPT();
		g_IsHuantongForCZLConfirm = 0
		g_HuanTongLastTime =  OSAPI:GetTickCount()
		--Pethuantong_Clear()
		--PetPropagateCheck_Accept:Disable()
	end
	g_Contrl = true
end

function Pethuantong_Quick_check()
	--‘ˆº”15º∂≈–∂œ
	local mylevel = Player:GetData("LEVEL");
	if mylevel < 15 then
		PushDebugMessage("#{ZSKJT_130717_01}")
		return 0
	end
	--≈–∂œµÁª∞√‹±£∫Õ∂˛º∂√‹¬Î±£ª§2012.6.12-LIUBO
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return 0
	end

	-- «∑Ò—°‘Ò†‰ ﬁ
	if (-1 == g_selidx) then
		PushDebugMessage("#{HTQR_091010_5}")
		return 0
	end

	-- «∑ÒÀ¯∂®
	if (Pet:IsProtect(g_selidx) == 1) then
		PushDebugMessage("#{ZSKSSJ_081113_06}")
		return 0
	end

	-- «∑Ò‘⁄≥ˆ†Ω
	local petname,status = Pet:GetPetList_Appoint(g_selidx)
	if (status == "on_fight") then
		PushDebugMessage("#{ZSKJT_130428_23}")
		return 0
	end

	-- «∑Òª√ªØ
	local gen = Pet:GetType(g_selidx)
	if gen == nil or gen >= 100 then	--100???????
		PushDebugMessage("#{RXZS_090804_29}")
		return 0
	end

	-- «∑Ò±‰“Ï
	local nPetType = Pet : GetPetType(g_selidx);
	if nPetType == 1 then
		PushDebugMessage("#{ZSKJT_130428_24}")
		return 0
	end

	-- «∑Ò”–†‰ ﬁ◊∞±∏
	if Pet:IsPetHaveEquip(g_selidx) == 1 then
		PushDebugMessage("#{ZSZB_090211_18}")
		return 0
	end

	--”–Œﬁ≈‰≈º
	local strName = Pet : GetConsort(g_selidx)
	if tonumber(strName) ~= 0 then
		PushDebugMessage("#{ResultText_73}")
		return 0
	end

	--≥…≥§¬ …œœﬁ
	local growlimit = Pet:GetGrowRate4( g_selidx );
	local growrate = Pet:GetGrowRate( g_selidx );
	if	growrate >= growlimit then
		PushDebugMessage("#{ZSKJT_130428_25}")
		return 0
	end

	return 1
end

function Pethuantong_Quick_Do()
	if Pethuantong_Quick_check() == 1 then
	
		local growrate = Pet : GetGrowRate(g_selidx);
		local nGrowLevel = Pet : GetPetGrowLevel(g_selidx,tonumber(growrate));
		local strTbl = {"#{ZSKJT_130513_1}","#{ZSKJT_130513_2}","#{ZSKJT_130513_3}","#{ZSKJT_130513_4}","#{ZSKJT_130513_5}"}
		 --{"∆†Õ®","”≈–„","Ω‹≥ˆ","◊ø‘Ω","ÕÍ√¿"};
		local strgrow
		if(nGrowLevel >= 0) then
			nGrowLevel = nGrowLevel + 1;	--c???0?????
			if(strTbl[nGrowLevel]) then
				strgrow = strTbl[nGrowLevel]..growrate
			end
		end

		if strgrow == nil then
			strgrow = "#{ZSKJT_130513_6}"
		end

		local petName = Pet : GetPetList_Appoint( g_selidx )
		local takelevel = Pet : GetTakeLevel( g_selidx )
		if g_YuanBaoCosts[takelevel] == nil then
			return
		end
		local cost = g_YuanBaoCosts[takelevel]

		-- –Ø¥¯µ»º∂∂‘”¶µƒ≥…≥§¬ …œœﬂ
		local growlimit = Pet : GetGrowRate4( g_selidx )

		--µØ≥ˆ»∑»œøÚ
		PushEvent("QUICKUP_PET_CONFIRM", 4, tostring(strgrow), tonumber(cost),tonumber(growlimit), tostring(petName))
	end
end

function Pethuantong_CZL_Confirm()
	
	local strText = "#{ZSYB_160105_21}";
	--µØ≥ˆ»∑»œøÚ
	PushEvent("GAMELOGIN_SYSTEM_INFO_OK", strText, "-1")
	g_IsHuantongForCZLConfirm = 1

end

function Pethuantong_ExeScript()
	if Pethuantong_Quick_check() == 1 then
		local hid,lid = Pet:GetGUID(g_selidx)
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnQuickPropagate")
			Set_XSCRIPT_ScriptID(311111)
			Set_XSCRIPT_Parameter(0,g_serverNpcId)
			Set_XSCRIPT_Parameter(1,hid)
			Set_XSCRIPT_Parameter(2,lid)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT();
	end
	g_Contrl = true
end

--*************************************************
--πÿ–ƒNPC
--*************************************************
function Pethuantong_CareObj(careId, op, distance)
	if(nil == careId or nil == op or nil == distance) then
		return
	end

	if(tonumber(careId) ~= g_clientNpcId) then
		return
	end

	if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
		Pethuantong_Hide()
	end
end


--*************************************************
--—°‘Ò≤ªÕ¨†‰ ﬁ ±£¨…Ë÷√≤ªÕ¨µƒ†‰ ﬁƒ£–Õ
--*************************************************
function Pethuantong_Selected(selidx)
	local nSeletedIndex = tonumber(selidx)
	if (this : IsVisible() == false) then
		return
	end

	if (-1 == nSeletedIndex) then
		return
	end
	
	--†‰ ﬁ“—±ª∆‰À¸ΩÁ√Ê—°÷–
	if (Pet:GetPetLocation(nSeletedIndex) ~= -1) then
		return
	end

	if Pet:IsPetHaveEquip(nSeletedIndex) == 1 then
		PushDebugMessage("#{ZSZB_090211_18}")
		return
	end

	if (g_selidx ~= -1) then
		Pet : SetPetLocation(g_selidx,-1)
	end

	--Pethuantong_Mode1 : SetCheck(0)
	--Pethuantong_Mode2 : SetCheck(0)
	Pethuantong_Clear(0)
	g_selidx = tonumber(nSeletedIndex)
	
	g_IsHuantongForCZLConfirm = 0  --add:lby 2015
	g_HuanTongLastTime = 0
	Pethuantong_PetModel : SetFakeObject("")
	Pet : SethuantongModel(g_selidx)
	Pethuantong_PetModel : SetFakeObject("My_Pethuantong")
	Pet : SetPetLocation(g_selidx,9)

	if (g_ItemPos ~= -1) then
		local ItemID = PlayerPackage : GetItemTableIndex( g_ItemPos )
		local petlevel = Pet : GetTakeLevel(selidx)
		local nCostMoney = Pethuantong_GetHuanTongCostMoney(petlevel, ItemID)
		g_NeedMoney = nCostMoney
		Pethuantong_Money : SetProperty("MoneyNumber", tostring(g_NeedMoney))
		Pethuantong_DisableModel()
	else
		Pethuantong_Money : SetProperty("MoneyNumber", "")
	end

	Pethuantong_Pet_Attr_Update()

end

--*************************************************
--†‰ ﬁªπÕØª®∑—µƒΩ«Æ
--*************************************************
function Pethuantong_GetHuanTongCostMoney(petlevel, itemId)

	if(nil == petlevel or nil == itemId or -1 == itemId) then
		return 0
	end

	if(nil == g_tbabaymoney[petlevel]) then
		return 0
	end

	local costMoney = g_tbabaymoney[petlevel]
	--÷†º∂ªπÕØæÌ÷· †∑—Ωµ÷¡90%
	if 	   (itemId == 30503011 or
			itemId == 30503012) then
	--†‰ ﬁªπÕØæÌ÷·/∏ﬂº∂†‰ ﬁªπÕØæÌ÷·
	elseif (itemId == 30503016 or
			itemId == 30503017 or
			itemId == 30503018 or
			itemId == 30503019 or
			itemId == 30503020) then

			costMoney = (costMoney * 90)/100
			if (costMoney <= 0) then
				costMoney = 1
			end
			Pethuantong_Mode1 : Enable()
			Pethuantong_Mode2 : Enable()
	else
	--¿‡À∆ ªπÕØµ§£∫Õ√◊”
			costMoney = costMoney/100
			if (costMoney <= 0) then
				costMoney = 1
			end
	end
	return costMoney
end


--*************************************************
--
--*************************************************
function Pethuantong_Show()
	if (this : IsVisible() == true) then
		Pethuantong_Pet_Attr_Update()	
		return
	end

	if (g_Contrl == false) then
		if(g_selidx ~= -1) then
			--if (Pet : GetIsFighting(g_selidx))then
			Pet : SetPetLocation(g_selidx,-1)
			--end
		end
		Pethuantong_PetModel : SetFakeObject( "" )
		g_selidx = -1
	end

	g_Contrl = false
end

--*************************************************
--œ‘ æΩª◊”
--*************************************************
function Pethuantong_ShowJZ()
	Pethuantong_SelfJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
end

--*************************************************
--œ‘ æΩ«Æ
--*************************************************
function Pethuantong_ShowMoney()
	Pethuantong_SelfMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--*************************************************
--”“º¸µ„ª˜ActionButton
--*************************************************
function Pethuantong_Resume_Equip_Gem()
	Pethuantong_Clear(1)
end

--*************************************************
--«Â≥˝ΩÁ√Ê
--*************************************************
function Pethuantong_Clear( IsSaveState )
	if g_ItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
		Pethuantong_Object : SetActionItem( -1 )
		g_ItemPos = -1
		g_NeedMoney = -1
		Pethuantong_Money : SetProperty( "MoneyNumber", 0 )
	end
	local nState = tonumber(IsSaveState)
	if nState == 0 then
		Pethuantong_Mode1 : SetCheck(0)
	end
	
	--Pethuantong_Mode1 : Disable()
	Pethuantong_Mode1 : Enable()
	
	if nState == 0 then
		Pethuantong_Mode2 : SetCheck(0)
	end
	
	--Pethuantong_Mode2 : Disable()
	Pethuantong_Mode2 : Enable()
	g_ItemID = -1
end


--*************************************************
--∏¸–¬ΩÁ√Ê
--*************************************************
function Pethuantong_Update( pos_packet )
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber( pos_packet )
	-- «∑Òº”À¯....
	if (PlayerPackage:IsLock(BagPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--∏¸–¬†‰ ﬁªπÕØ≤ƒ¡œΩÁ√Ê
	local ItemID = PlayerPackage : GetItemTableIndex( BagPos )
	if ( ItemID <= 0) then
		PushDebugMessage("#{GMActionSystem_Item_CantUseInPetSkillStudy}")
		return
	end

	if ( (ItemID < g_HuanTongMin1 or ItemID > g_HuanTongMax1) and
		 (ItemID < g_HuanTongMin2 or ItemID > g_HuanTongMax2)) then
		PushDebugMessage("#{GMActionSystem_Item_CantUseInPetSkillStudy}")
		return
	end

	if (g_ItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
	end

	LifeAbility : Lock_Packet_Item( BagPos, 1 )
	g_ItemPos = BagPos

	--∏¸–¬†‰ ﬁªπÕØµƒ†‰ ﬁΩÁ√Ê
	local theAction = EnumAction( BagPos, "packageitem" )
	if (theAction : GetID() == 0) then
		return
	end

	Pethuantong_Object : SetActionItem( theAction : GetID() )

	--∏¸–¬†‰ ﬁªπÕØ–Ë“™ª®∑—µƒΩ«Æ
	if (-1 ~= g_selidx) then
		local petlevel = Pet : GetTakeLevel(g_selidx)
		local nCostMoney = Pethuantong_GetHuanTongCostMoney(petlevel, ItemID)
		g_NeedMoney = nCostMoney
		Pethuantong_Money : SetProperty( "MoneyNumber", tostring(g_NeedMoney) )
		Pethuantong_DisableModel()
	end
end

--*************************************************
--πÿ±†ΩÁ√Ê
--*************************************************
function Pethuantong_Frame_OnHiden()

	--πÿ±†∂˛¥Œ»∑»œΩÁ√Ê
	PushEvent("CONVENIENT_BUY_CONFIRM_CLOSE");
	Pethuantong_Hide()
	Pethuantong_Clear(0)
	--Pethuantong_Pet_Attr_Update()
end

--*************************************************
--œÚ◊Û–˝◊™†‰ ﬁ
--*************************************************
function Pethuantong_Modle_TurnLeft(start)
	--œÚ◊Û–˝◊™ø™ º
	if(start == 1) then
		Pethuantong_PetModel : RotateBegin(-0.3)
	--œÚ◊Û–˝◊™Ω· ¯
	else
		Pethuantong_PetModel : RotateEnd()
	end
end

--*************************************************
--œÚ”“–˝◊™†‰ ﬁ
--*************************************************
function Pethuantong_Modle_TurnRight(start)
	--œÚ”“–˝◊™ø™ º
	if(start == 1) then
		Pethuantong_PetModel : RotateBegin(0.3)
	--œÚ”“–˝◊™Ω· ¯
	else
		Pethuantong_PetModel : RotateEnd()
	end
end


--*************************************************
--—°œÓ À¯∂®◊ ÷  À¯∂®≥…≥§¬ 
--*************************************************
function Pethuantong_Mode_Clicked(Index)

	if (Index ~= 1 and Index ~= 2) then
		return
	end

end

function Pethuantong_DisableModel()
	if (nil ~= g_selidx and g_selidx ~= -1 and nil ~= g_ItemPos and g_ItemPos ~= -1) then
		--»Áπ˚≤ƒ¡œ «≥¨º∂†‰ ﬁªπÕØÃÏ È
		local ItemID = PlayerPackage : GetItemTableIndex( g_ItemPos )
		if (ItemID == 30503017 or ItemID == 30503018 or
			ItemID == 30503019 or ItemID == 30503020) then
			local pettype = Pet : GetPetType(g_selidx)
			local petgene = Pet : GetGeneration(g_selidx)
			if (pettype == 0 and petgene == 0) then
				Pethuantong_Mode1 : Enable()
				Pethuantong_Mode2 : Enable()
				g_Model1IsEnabel = 1
				g_Model2IsEnabel = 1
			else
				Pethuantong_Mode1 : SetCheck( 0 )
				Pethuantong_Mode2 : SetCheck( 0 )
				Pethuantong_Mode1 : Disable()
				Pethuantong_Mode2 : Disable()
				g_Model1IsEnabel = 0
				g_Model2IsEnabel = 0
			end
		else
			Pethuantong_Mode1 : SetCheck( 0 )
			Pethuantong_Mode2 : SetCheck( 0 )
			Pethuantong_Mode1 : Disable()
			Pethuantong_Mode2 : Disable()
			g_Model1IsEnabel = 0
			g_Model2IsEnabel = 0
		end
	else
		Pethuantong_Mode1 : Enable()
		Pethuantong_Mode2 : Enable()
	end
end

function Pethuantong_Frame_On_ResetPos()
  Pethuantong_Frame:SetProperty("UnifiedPosition", g_Pethuantong_Frame_UnifiedPosition);
end

function Pethuantong_Pet_Attr_Update()
	Pethuantong_Zizhi_Text1:SetText("#{ZSHTYH_150615_1}")--???
	Pethuantong_Zizhi_Text2:SetText("#{ZSHTYH_150615_8}")--????
	Pethuantong_Zizhi_Text3:SetText("#{ZSHTYH_150615_9}")--????
	Pethuantong_Zizhi_Text4:SetText("#{ZSHTYH_150615_10}")--????
	Pethuantong_Zizhi_Text5:SetText("#{ZSHTYH_150615_11}")--????
	Pethuantong_Zizhi_Text6:SetText("#{ZSHTYH_150615_12}")--????
	if g_selidx == -1 then
		Pethuantong_Zizhi_Text1_1:SetText("")
		Pethuantong_Zizhi_Text1_1:SetToolTip("#{INTERFACE_XML_986}")
		Pethuantong_Zizhi_Text2_1:SetText("")
		Pethuantong_Zizhi_Text3_1:SetText("")
		Pethuantong_Zizhi_Text4_1:SetText("")
		Pethuantong_Zizhi_Text5_1:SetText("")
		Pethuantong_Zizhi_Text6_1:SetText("")
	elseif g_selidx >=0 then
		strName = Pet : GetGrowRate(g_selidx);
		Pethuantong_Zizhi_Text1_1 : SetToolTip("#{INTERFACE_XML_986}")

		Pethuantong_Zizhi_Text1_1 : SetText("#{ZSHTYH_150615_2}")
		local nGrowLevel = Pet : GetPetGrowLevel(g_selidx,tonumber(strName));
		local strTbl = {"#{ZSHTYH_150615_3}","#{ZSHTYH_150615_4}","#{ZSHTYH_150615_5}","#{ZSHTYH_150615_6}","#{ZSHTYH_150615_7}"};
		if(nGrowLevel >= 0) then
			nGrowLevel = nGrowLevel + 1;	--c???0?????
			local nGrowRate = Pet : GetGrowRate(g_selidx);
			if(strTbl[nGrowLevel]) then
				Pethuantong_Zizhi_Text1_1 : SetText("#G"..strTbl[nGrowLevel]..nGrowRate)
			end
		end

		local 	nIndex = g_selidx
		local strName = Pet : GetSavvy(nIndex);

		local WuXingVal = tonumber(strName);
		strName = Pet : GetStrAptitude(nIndex);
		if(WuXingTbl[WuXingVal])then
			strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
		end

		--if (Pet:GetIsPossession(nIndex)) and Player:IsPetMasterEffectActive(1) == 1 then
		--	effectStr = Pet:GetPetMasterTotalEffectValue(nIndex,9)
		--	Pethuantong_Zizhi_Text2_1:SetText( strName.."#G(+"..tostring(effectStr)..")" )
		--	if(WuXingTbl[WuXingVal])then
		--		Pethuantong_Zizhi_Text2_1:SetToolTip("#{YSSJ_140818_59}")
		--		Pethuantong_Zizhi_Text2:SetToolTip("#{YSSJ_140818_59}")
		--	else
		--		Pethuantong_Zizhi_Text2_1:SetToolTip("#{YSSJ_140818_103}")
		--		Pethuantong_Zizhi_Text2:SetToolTip("#{YSSJ_140818_103}")
		--	end
		--else
			Pethuantong_Zizhi_Text2_1:SetText( "#cFAFFA4"..strName )
			Pethuantong_Zizhi_Text2_1:SetToolTip("")
			Pethuantong_Zizhi_Text2:SetToolTip("")
		--end

		strName = Pet : GetIntAptitude(nIndex);
		if(WuXingTbl[WuXingVal])then
			strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
		end

		--if (Pet:GetIsPossession(nIndex)) and Player:IsPetMasterEffectActive(1) == 1 then
		--	effectStr = Pet:GetPetMasterTotalEffectValue(nIndex,10)
		--	Pethuantong_Zizhi_Text3_1:SetText( strName.."#G(+"..tostring(effectStr)..")"  )
		--	if(WuXingTbl[WuXingVal])then
		--		Pethuantong_Zizhi_Text3_1:SetToolTip("#{YSSJ_140818_60}")
		--		Pethuantong_Zizhi_Text3:SetToolTip("#{YSSJ_140818_60}")
		--	else
		--		Pethuantong_Zizhi_Text3_1:SetToolTip("#{YSSJ_140818_104}")
		--		Pethuantong_Zizhi_Text3:SetToolTip("#{YSSJ_140818_104}")
		--	end
		--else
			Pethuantong_Zizhi_Text3_1:SetText( "#cFAFFA4"..strName )
			Pethuantong_Zizhi_Text3_1:SetToolTip("")
			Pethuantong_Zizhi_Text3:SetToolTip("")
		--end


		strName = Pet : GetPFAptitude(nIndex);
		if(WuXingTbl[WuXingVal])then
			strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
		end

		--if (Pet:GetIsPossession(nIndex)) and Player:IsPetMasterEffectActive(1) == 1 then
		--	effectStr = Pet:GetPetMasterTotalEffectValue(nIndex,11)
		--	Pethuantong_Zizhi_Text4_1:SetText( strName.."#G(+"..tostring(effectStr)..")" )
		--	if(WuXingTbl[WuXingVal])then
		--		Pethuantong_Zizhi_Text4_1:SetToolTip("#{YSSJ_140818_61}")
		--		Pethuantong_Zizhi_Text4:SetToolTip("#{YSSJ_140818_61}")
		--	else
		--		Pethuantong_Zizhi_Text4_1:SetToolTip("#{YSSJ_140818_105}")
		--		Pethuantong_Zizhi_Text4:SetToolTip("#{YSSJ_140818_105}")
		--	end
		--else
			Pethuantong_Zizhi_Text4_1:SetText( "#cFAFFA4"..strName )
			Pethuantong_Zizhi_Text4_1:SetToolTip("")
			Pethuantong_Zizhi_Text4:SetToolTip("")
		--end

		strName = Pet : GetStaAptitude(nIndex);
		if(WuXingTbl[WuXingVal])then
			strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
		end

		--if (Pet:GetIsPossession(nIndex)) and Player:IsPetMasterEffectActive(1) == 1 then
		--	effectStr = Pet:GetPetMasterTotalEffectValue(nIndex,12)
		--	Pethuantong_Zizhi_Text5_1:SetText( strName.."#G(+"..tostring(effectStr)..")" )
		--	if(WuXingTbl[WuXingVal])then
		--		Pethuantong_Zizhi_Text5_1:SetToolTip("#{YSSJ_140818_62}")
		--		Pethuantong_Zizhi_Text5:SetToolTip("#{YSSJ_140818_62}")
		--	else
		--		Pethuantong_Zizhi_Text5_1:SetToolTip("#{YSSJ_140818_106}")
		--		Pethuantong_Zizhi_Text5:SetToolTip("#{YSSJ_140818_106}")
		--	end
		--else
			Pethuantong_Zizhi_Text5_1:SetText( "#cFAFFA4"..strName )
			Pethuantong_Zizhi_Text5_1:SetToolTip("")
			Pethuantong_Zizhi_Text5:SetToolTip("")
		--end

		strName = Pet : GetDexAptitude(nIndex);
		if(WuXingTbl[WuXingVal])then
			strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
		end

		--if (Pet:GetIsPossession(nIndex)) and Player:IsPetMasterEffectActive(1) == 1 then
		--	effectStr = Pet:GetPetMasterTotalEffectValue(nIndex,13)
		--	Pethuantong_Zizhi_Text6_1:SetText( strName.."#G(+"..tostring(effectStr)..")" )
		--	if(WuXingTbl[WuXingVal])then
		--		Pethuantong_Zizhi_Text6_1:SetToolTip("#{YSSJ_140818_63}")
		--		Pethuantong_Zizhi_Text6:SetToolTip("#{YSSJ_140818_63}")
		--	else
		--		Pethuantong_Zizhi_Text6_1:SetToolTip("#{YSSJ_140818_107}")
		--		Pethuantong_Zizhi_Text6:SetToolTip("#{YSSJ_140818_107}")
		--	end
		--else
			Pethuantong_Zizhi_Text6_1:SetText( "#cFAFFA4"..strName )
			Pethuantong_Zizhi_Text6_1:SetToolTip("")
			Pethuantong_Zizhi_Text6:SetToolTip("")
		--end
	end
end

function PetHuantong_YBPay_Clicked() --add:lby2015????????

	local check  = tonumber(Pet:GetYuanbaoBuyState(0));
	
	if(check>=1)then
		Pethuantong_Yuanbao_Bind:SetCheck(1);
		Pet:SetYuanbaoBuyState(0, 0);
	else
		Pethuantong_Yuanbao_Bind:SetCheck(0);
		Pet:SetYuanbaoBuyState(0, 1);
	end	
	
end

--add:lby2015
function PetHuantong_PetYuanbaoBuyTSAsk()

	local _material = -1

	local takelevel = Pet : GetTakeLevel( g_selidx )
	
	if takelevel <= 35 then
		_material = 30503017
	elseif takelevel <= 65 then
		_material = 30503018
	elseif takelevel <= 85 then
		_material = 30503019
	elseif takelevel <= 95 then
		_material = 30503020
	else
		return
	end
	
	local check  = tonumber(Pet:GetYuanbaoBuyState(0));
	
	if check == 1 then
		--≤ªÃ· æ ◊‘∂Øπ∫¬Ú
		
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("PetHuantong_Yuanbao_Pay")
			Set_XSCRIPT_ScriptID(311111)
			Set_XSCRIPT_Parameter(0,_material)
			Set_XSCRIPT_Parameter(1,0)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		return 
	elseif check == 0 then
			
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("PetHuantong_Yuanbao_Pay")
			Set_XSCRIPT_ScriptID(311111)
			Set_XSCRIPT_Parameter(0,_material)
			Set_XSCRIPT_Parameter(1,1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		return
	else 
		return 
	end

end
