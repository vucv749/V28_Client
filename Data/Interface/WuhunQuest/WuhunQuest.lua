--Create By Vega
local g_FrameInfo = -1				--?????????
local FrameInfoList = {
	YBMARKET_UP_ITEM_COMFIRM 			= 1,			--????????
	YBMARKET_UP_PET_COMFIRM 			= 2,			--????????
	YBMARKET_BUY_COMFIRM 				= 3,			--???????
	YBMARKET_TAKE_BACK_COMFIRM 			= 4,			--????
	SELL_ITEM_CONFIRM					= 5,			--zhanglei ????????
	QUICKUP_PET_CONFIRM					= 6,			--??????????
	PET_HUANTONT_CONFIRM				= 7,			--???????? add:lby2015
	PET_LINGXING_CONFIRM 				= 8,	--???????? add:lby2015 
	CONVENIENT_BUY_CONFIRM				= 9, 	--????,????
	BILLINGAWARD_CONFIRM = 10,		--Billing????????
	MATERIALCOMPOUND_CONFIRM = 11,		--????????
	WHWG_GRADEUP_CONFIRM = 12,			--??????
	DRESSPAINT_BINDITEM_CONFIRM = 13,	--????????????
	XIARIDAKA_CONFIRM = 14, --????
	NEW_DAKONG_CONFIRM						= 19,			--???
	NEW_XIANGQIAN_CONFIRM					= 20,			--???
	NEW_ZHAICHU_CONFIRM						= 21,			--???
	DARK_SKILL_RECOIN_CONFIRM = 38, 	-- ??????????
	SUPER_ATTR_RECOIN_CONFIRM =40,		-- ????????
	WUHUN_SKILL_RECOIN_CONFIRM = 44, 	-- ???????????
	DOUBLE_SECKILL_CONFIRM	= 48,
	YBMARKET_CONFIRM_MULTIBUY	= 49,			--????????????
	SECKILL_GIVEUP_CONFIRM = 79, --??????
	DRESS_TRANSFER_BIND_CONFIRM = 90,
	DRESS_TRANSFER_BUYITEM_CONFIRM = 91,
	CONFIRM_IMMIGRATION  = 94,				 -- ??
	CONFIRM_CANCEL_IMMIGRATION  = 95,				 -- ????
	PETSOUL_EXCHANGE_CONFIRM = 96,
	PETSOUL_XISHUXING_CONFIRM = 97,
	PETSOUL_FUSION_CONFIRMBIND = 98, --???? ????
	PETSOUL_BLOODLEVELUP_CONFIRM = 99, --???? ??
	PETSOUL_XISHUXING_CONFIRMPERFECT = 100,
	PETSOUL_XISHUXING_CHANGECONFIRM = 101,
	PETSOUL_XISHUXING_CONFIRMBIND = 102,
	PETSOUL_LEVELUP_CONFIRM = 103,
	PETSOUL_BLOODLEVELUP_BINDCONFIRM = 104,
	APPLY_SNAKING_NUM_SECOND_CONFIRM = 153, --????????
	LILIANMISSION23_CONFIRM = 154, --???????? ??3 ??????
	DWLEVELUP_BINDCONFIRM = 155,
	DW_CONSUMESURE_EQUIPDWLEVELUP = 156,
	PRIZE_WAITING = 158,
	QINGQIU_BUYCONFIRM = 159, 
	WEEKLYSHOP_BUYCONFIRM = 163,
	XUYUANCHI_ITEM = 164,--2022??? ??? ????
	GONGCANJIAWEI_CONFIRM = 165,--????
	GONGCANJIAWEI_CONFIRMSUBMIT = 166,
	LINGYU_WASH_CONFIRM = 167,
	LINGYU_SWITCH_CONFIRM = 168,
	LINGYU_MAKE_CONFIRM = 169,
	LINGYU_COMPOUND_CONFIRM = 170,
	LINGYU_RECYCLE_CONFIRM = 171,
	FASHION_LOTTERY_SIGNUP_CONFIRM = 172,
	BWZQ_SPONSOR_VOTE_CONFIRM = 174,
	DOUBLEGAME_GAMEDESC = 176,
	LINGYU_TRANSITION_CONFIRM = 177, 
	FANCHANG_SHOP_CONFIRM = 178,
	LINGYU_UNBIND_CONFIRM = 179,
	BWZQ_GOTOBHGAREA_CONFIRM = 180,
	BWZQ_GOTOBHGAREA_WAITCONFIRM = 181,
	DELETE_COUPLE_DIARY_CONFIRM = 182,
	MARRY_PLANE_NOTICE  = 183,				 -- ????????
	PETTAYIN_CONFIRM = 184,			--????????
	
	PETTAYIN_YBbuy_CONFIRM		= 186,			--???? ????????
	
	QIXITOPLIST_CONFIRM		= 187,			--????????
	PETSOUL_RANSE_CONFIRM = 188,
	PETSOUL_RANSE_ZIDONG_CONFIRM = 189,
	SECKILL_TESE = 190,
	LILIANMISSION2_CONFIRM = 191, --???????? ??2 ??????
	QIONGQI_SWALLOW_CONFIRM = 192,--????
	QIONGQI_RESTORE_CONFIRM = 193,--????
	
	QINGRENJIETOPLIST_CONFIRM		= 194,			--?????????
	YULONGZAITIAN_CONFIRM			=195,			--??????-????????
	
	QRJTOPLIST_EXCHANGE_CONFIRM		= 196,			--???????????
	
	REPUTATIONSHOP_BUY_CONFIRM		= 197,			--??????????
	
	EQUIP_REFRESH_EQUIP_CHANGE_CONFIRM		= 198,
	EQUIP_REFRESH_CLOSE_CONFIRM		= 199,
	EQUIP_REFRESH_BIND_CONFIRM		= 200,
	CONFIRM_CANCEL_ODER_IMMIGRATION = 224, -- ??????
	SHENFENYURE_RESELECT = 225,
	
	ZIDIAN_PICKONE_CONFIRM = 226, -- ???????
	DUANWUDAKA_CONFIRM = 227,

	CONFIRM_DWJINJIE = 228,
	CONFIRM_DWJINJIESHENGJI = 229,
	CONFIRM_DWJINJIEHUITUI = 230,
	CONFIRM_ORNAMENTS_CONFIRM = 231,	--???
	DAHUA_DAIBI_CONFIRM = 232,
	CONFIRM_QIXIPVE_LEAVE = 233,
	DAHUA_DAIBI_SHOP_CONFIRM = 234,

	QIXIRANK_EXCHANGE_CONFIRM = 235, --2015?????????

}
--È·ÈÏ¿ò»º´æ±äÁ¿£¬ÓÃÓÚµã»÷È·¶¨ºÍÈ¡ÏûÊ±×ö´¦Àí, Ã¿¸ö±äÁ¿µÄÒâÒå£¬¸ù¾Ý½çÃæ²»Í¬¸÷²»ÏàÍ¬£¬ÇëÊ¹ÓÃ ßÓÃµ½Ê±×Ô¼º×¢ÊÍ
local g_FrameVar = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[7] = 0,
	[8] = 0,
}
function WuhunQuest_PreLoad()
	this:RegisterEvent("GAME_NOTIFY_INFO_OK");
	this:RegisterEvent("GAME_NOTIFY_INFO_CLOSE");
	this:RegisterEvent("GAME_NOTIFY_INFO_YESNO");
	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("DARK_SKILL_RECOIN_CONFIRM")
	this:RegisterEvent("SUPER_ATTR_RECOIN_CONFIRM")
	this:RegisterEvent("WUHUN_SKILL_RECOIN_CONFIRM")
	this:RegisterEvent("DELETE_COUPLE_DIARY_CONFIRM")
	this:RegisterEvent("YBMARKET_UP_ITEM_COMFIRM")
	this:RegisterEvent("YBMARKET_UP_PET_COMFIRM")
	this:RegisterEvent("YBMARKET_BUY_COMFIRM")
	this:RegisterEvent("YBMARKET_TAKE_BACK_COMFIRM")
	this:RegisterEvent("YBMARKET_CONFIRM_MULTIBUY")
		
	this:RegisterEvent("PLAYER_LEAVE_WORLD")

	this:RegisterEvent("ZHOUCHANG_BUY_ITEM_CONFIRM") 
	this:RegisterEvent("SELL_ITEM_CONFIRM") 
	this:RegisterEvent("QUICKUP_PET_CONFIRM")
	this:RegisterEvent("BILLINGAWARD_CONFIRM");
	this:RegisterEvent("SECKILL_GIVEUP_CONFIRM")
	this:RegisterEvent("DOUBLE_SECKILL_CONFIRM")
	this:RegisterEvent("WHWG_GRADEUP_CONFIRM")
	this:RegisterEvent("PETSOUL_EXCHANGE_CONFIRM")
	this:RegisterEvent("PETSOUL_XISHUXING_CONFIRM")
	this:RegisterEvent("PETSOUL_XISHUXING_CHANGECONFIRM")
	this:RegisterEvent("PETSOUL_RANSE_CONFIRM")
	this:RegisterEvent("PETSOUL_RANSE_ZIDONG_CONFIRM")
	this:RegisterEvent("DRESS_TRANSFER_BIND_CONFIRM")
	this:RegisterEvent("DRESS_TRANSFER_BUYITEM_CONFIRM")
	this:RegisterEvent("APPLY_SNAKING_NUM_SECOND_CONFIRM")
	this:RegisterEvent("BINDSURE_EQUIPDWLEVELUP")
	this:RegisterEvent("CONSUMESURE_EQUIPDWLEVELUP")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	
	this:RegisterEvent("QINGQIU_BUY_ITEM_CONFIRM") 
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
	this:RegisterEvent("CLOSE_COMFIRM_QQSKILL")
	
	this:RegisterEvent("EQUIP_REFRESH_EQUIP_CHANGE_CONFIRM")
	this:RegisterEvent("EQUIP_REFRESH_CLOSE_CONFIRM")
	
	this:RegisterEvent("QIXIRANK_EXCHANGE_CONFIRM");
end

function WuhunQuest_OnLoad()
	WuhunQuest_Frame_sub:SetProperty("AlwaysOnTop", "True");
end

function WuhunQuestUpdateRect()
	local nWidth, nHeight = WuhunQuest_InfoWindow:GetWindowSize();
	local nTitleHeight = 23;
	local nBottomHeight = 25;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	WuhunQuest_Frame_sub:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end

-- OnEvent
function WuhunQuest_OnEvent(event)
	-- Ä¬ÈÏÒþ²Ø×é¼þ
	if  WuhunQuest_CheckClient:IsVisible() then
		WuhunQuest_CheckClient:Show()
		WuhunQuest_CheckBtn:Show()
		WuhunQuest_CheckText:Show()
	else
		WuhunQuest_CheckClient:Hide()
		WuhunQuest_CheckBtn:Hide()
		WuhunQuest_CheckText:Hide()
	end

	if event == "PLAYER_LEAVE_WORLD" then	
		if g_FrameInfo == FrameInfoList.LILIANMISSION23_CONFIRM --???????? ??3 ??????
			or g_FrameInfo == FrameInfoList.LILIANMISSION2_CONFIRM then--???????? ??2 ??????
			if this:IsVisible() then
				this:Hide()
			end
		end
		return
	end
	
	if event == "PLAYER_ENTERING_WORLD" then
		if g_FrameInfo == FrameInfoList.FASHION_LOTTERY_SIGNUP_CONFIRM then
			if this:IsVisible() then
				this:Hide()
			end
		end
		return
	end
	
	if event == "CLOSE_COMFIRM_QQSKILL" then
		if this:IsVisible() then
			this:Hide()
		end
		return
	end

	--******************************
	--½¨Òé£º´¦Àí²»Í¬µÄevent£¬ÇëÔÚ¶Á³ö²ÎÊýºó£¬½«Âß¼­×Ô¼ºÐ´ÔÚÒ»¸öº¯ÊýÄÚ
	-- âÑù¿ÉÒÔ¾¡¿ÉÄÜµÄÊ¹OnEventº¯ÊýÄÜ¼ò½àÒ»Ð©²»ÖÁÓÚÏñMessageBox½çÃæÒ»Ñù
	--×¢Òâ£ºÒ»¶¨ÒªÏÈ½«²ÎÊý¶Á³öÀ´ÔÙ´«¸ø×Ô¼ºÐ´µÄº¯Êý
	--²Î¿¼£ºevent == "YBMARKET_UP_ITEM_COMFIRM"
	--*******************************
	if ( event == "GAME_NOTIFY_INFO_OK" ) then
		local str = arg0
		WuhunQuest_Open_Window_OK(str)		--?????????????,????????,?????????
	elseif ( event == "GAME_NOTIFY_INFO_CLOSE") then
		local str = arg0
		WuhunQuest_Open_Window_CLOSE(str)
	elseif ( event == "GAME_NOTIFY_INFO_YESNO") then
		local str = arg0
		WuhunQuest_Open_Window_YESNO(str)
	elseif ( event == "YBMARKET_UP_ITEM_COMFIRM" ) then
		local nIndex = tonumber(arg0)
		local nPrice = tonumber(arg1)
		WuhunQuest_Open_Window_YBM_UpItem(nIndex , nPrice)
	elseif ( event == "YBMARKET_UP_PET_COMFIRM" ) then
		local nIndex = tonumber(arg0)
		local nPrice = tonumber(arg1)
		WuhunQuest_Open_Window_YBM_UpPet(nIndex , nPrice)
	elseif ( event == "YBMARKET_BUY_COMFIRM" ) then
		local nType = tonumber(arg0)
		local nIndex =tonumber(arg1)
		local nPrice = tonumber(arg2)
		WuhunQuest_Open_Window_YBM_Buy(nType ,nIndex ,nPrice)
	elseif ( event == "YBMARKET_CONFIRM_MULTIBUY" ) then
		WuhunQuest_Open_Window_YBM_MultiBuy(arg0, arg1, arg2, arg3)
	elseif ( event == "YBMARKET_TAKE_BACK_COMFIRM" ) then
		local nType = tonumber(arg0)
		local nIndex = tonumber(arg1)
		WuhunQuest_Open_Window_YBM_TakeBack(nType , nIndex)
	elseif ( event == "SELL_ITEM_CONFIRM" ) then
		local nItemPos = tonumber(arg0)
		local opType = tonumber(arg1)
		if opType == 1 then
			WuhunQuest_Open_Window_SellItemConfirm(nItemPos);
		elseif opType == 2 or opType == 3 then
			local equipQual = tonumber(arg2)
			if nil ~= equipQual then
				WuhunQuest_Open_Window_SellItemConfirmQ8(nItemPos,equipQual,opType);
			end
		end
	elseif event == "DARK_SKILL_RECOIN_CONFIRM" then
		local npocketIndex = tonumber(arg0);
		local keepopen = tonumber(arg1);
		WuhunQuest_DarkSkill_confirm(npocketIndex,keepopen)
	elseif event == "SUPER_ATTR_RECOIN_CONFIRM" then
		local npocketIndex = tonumber(arg0);
		local keepopen = tonumber(arg1);
		WuhunQuest_Super_ATTR_confirm(npocketIndex,keepopen)
	elseif event == "WUHUN_SKILL_RECOIN_CONFIRM" then
		local npocketIndex = tonumber(arg0);
		local keepopen = tonumber(arg1);
		WuhunQuest_WuhunSkill_confirm(npocketIndex,keepopen)
	elseif event == "DELETE_COUPLE_DIARY_CONFIRM" then
		local realId = tonumber(arg0);
		WuhunQuest_DeleteCoupleDiary_Confirm(realId)
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 998478003 ) then
		local strMsg = Get_XParam_STR(0);
		local notify = Get_XParam_INT(0);
		local nType = Get_XParam_INT(1);
		local nCurrencyUnit = Get_XParam_INT(2);
		local nPrice = Get_XParam_INT(3);
		local nItemIndex = Get_XParam_INT(4);
		local nSerialNum = Get_XParam_INT(5);
		local nUniqueID = Get_XParam_INT(6);
		if notify == 1 then
			WuhunQuest_Open_Window_PetTaYinConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID );
		else
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID );
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2015101414 ) then  --add:lby2015??
		local strMsg = Get_XParam_STR(0);
		local notify = Get_XParam_INT(0);
		local nType = Get_XParam_INT(1);
		local nCurrencyUnit = Get_XParam_INT(2);
		local nPrice = Get_XParam_INT(3);
		local nItemIndex = Get_XParam_INT(4);
		local nSerialNum = Get_XParam_INT(5);
		local nUniqueID = Get_XParam_INT(6);
		if notify == 1 then
			WuhunQuest_Open_Window_HuantongConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID );
		else
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID );
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2015101514 ) then  --add:lby2015??
		local strMsg = Get_XParam_STR(0);
		local notify = Get_XParam_INT(0);
		local nType = Get_XParam_INT(1);
		local nCurrencyUnit = Get_XParam_INT(2);
		local nPrice = Get_XParam_INT(3);
		local nItemIndex = Get_XParam_INT(4);
		local nSerialNum = Get_XParam_INT(5);
		local nUniqueID = Get_XParam_INT(6);
		if notify == 1 then
			WuhunQuest_Open_Window_LingxingConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID );
		else
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID );
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20120222 ) then
		local strMsg = Get_XParam_STR(0);
		local nType = Get_XParam_INT(0);
		local nCurrencyUnit = Get_XParam_INT(1);
		local nPrice = Get_XParam_INT(2);
		local nItemIndex = Get_XParam_INT(3);
		local nSerialNum = Get_XParam_INT(4);
		local nScriptID = Get_XParam_INT(5);
		local nYuanbaoPay = Get_XParam_INT(6);
		local nUniqueID = Get_XParam_INT(7);
		local nBuyCount = Get_XParam_INT(8);
		
		if nBuyCount == nil or nBuyCount < 1 then
			nBuyCount = 1
		end
		if nYuanbaoPay == nil or nYuanbaoPay ~= 1 then
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID, nBuyCount )
		else
			WuhunQuest_Open_Window_ConvenintBuyConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID, nScriptID, nBuyCount );
		end

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2013060604 ) then
		local strMsg = Get_XParam_STR(0);
		local notify = Get_XParam_INT(0);
		local nType = Get_XParam_INT(1);
		local nCurrencyUnit = Get_XParam_INT(2);
		local nPrice = Get_XParam_INT(3);
		local nItemIndex = Get_XParam_INT(4);
		local nSerialNum = Get_XParam_INT(5);
		local nUniqueID = Get_XParam_INT(6);

		-- !!!reloadscript =WuhunQuest
		-- PushDebugMessage("WuhunQuest:"..tonumber(arg0))

		if notify == 1 then
			WuhunQuest_Open_Window_DakongConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID );
		else
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID );
			g_StilettoEx_Material_Buy = 1
		end

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2013060605 ) then

		local strMsg = Get_XParam_STR(0);
		local notify = Get_XParam_INT(0);
		local nType = Get_XParam_INT(1);
		local nCurrencyUnit = Get_XParam_INT(2);
		local nPrice = Get_XParam_INT(3);
		local nItemIndex = Get_XParam_INT(4);
		local nSerialNum = Get_XParam_INT(5);
		local nUniqueID = Get_XParam_INT(6);
		if notify == 1 then
			WuhunQuest_Open_Window_XiangqianConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID );
		else
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID );
			g_EnchaseEx_Material_Buy = 1
		end

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2013060606 ) then
		local strMsg = Get_XParam_STR(0);
		local notify = Get_XParam_INT(0);
		local nType = Get_XParam_INT(1);
		local nCurrencyUnit = Get_XParam_INT(2);
		local nPrice = Get_XParam_INT(3);
		local nItemIndex = Get_XParam_INT(4);
		local nSerialNum = Get_XParam_INT(5);
		local nUniqueID = Get_XParam_INT(6);
		if notify == 1 then
			WuhunQuest_Open_Window_ZhaichuConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID );
		else
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID );
			g_SplitGemEx_Material_Buy = 1
		end

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20140917 ) then  
		local strMsg = Get_XParam_STR(0);
		local targetId = Get_XParam_INT(0);
		local standardStuff = Get_XParam_INT(1);

		WuhunQuest_MaterialCompound_Confirm( strMsg, targetId, standardStuff  )
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 79210703 ) then
		local guid = Get_XParam_INT(0);
		local sponsorname = Get_XParam_STR(0);

		WuhunQuest_BWZQSponsor_Vote_Confirm( guid, sponsorname )
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 79210803 ) then

		WuhunQuest_BWZQ_GotoBHGArea_Confirm()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 79210804 ) then
		if Get_XParam_INT(0) == 1 then
			WuhunQuest_BWZQ_GotoBHGArea_WaitConfirm()
		else
			this:Hide()
		end
	elseif ( event == "QUICKUP_PET_CONFIRM") then
		 local nType = tonumber(arg0); 			--1???,2???,3????,4????
		 local nCurData --= tonumber(arg1); 	--???????????????
		 if nType == 4 then
		 	 nCurData = tostring(arg1);
		 else
		 	 nCurData = tonumber(arg1);
		 end
		 local nPrice = tonumber(arg2);			--???
		 local nUplimit = tonumber(arg3);		--?????
		 local strMsg = tostring(arg4); 		--????
		 WuhunQuest_QuickUpPet_Confirm(nType,nCurData,nPrice,nUplimit,strMsg);
	elseif (event == "BILLINGAWARD_CONFIRM") then
		local nIndex = tonumber(arg0);
		if nIndex == -1 then
			this:Hide();
		else
			local strText = tostring(arg1)
			WuhunQuest_BillingAward_Confirm( strText, nIndex )
		end
		return
	elseif event == "SECKILL_GIVEUP_CONFIRM" then
		WuhunQuest_SeckillGiveUp_confirm()
	elseif event == "DOUBLE_SECKILL_CONFIRM" then
		local BossIndex = tonumber(arg0)
		local isYuanBao = tonumber(arg1)
		local needYuanBao = tonumber(arg2)
		local needItemID = tonumber(arg3)
		local needItemNum = tonumber(arg4)
		local isMoneySweep = tonumber(arg5)
		WuhunQuest_DoubleSeckill_confirm(BossIndex, isYuanBao, needYuanBao, needItemID, needItemNum,isMoneySweep)
	elseif (event == "WHWG_GRADEUP_CONFIRM") then
		WuhunQuest_WHWGGradeUp_confirm(tonumber(arg0),tostring(arg1))
	elseif (event == "APPLY_SNAKING_NUM_SECOND_CONFIRM") then
		local targetId = tonumber(arg0)
		g_FrameVar[1] = targetId
		--local strMsg = tostring(arg0)
		Apply_Snaking_Num_Second_Confirm()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20210315 ) then
		-- Ê±×°È¾É«
		local strMsg = Get_XParam_STR(0)
		local nType = Get_XParam_INT(0)
		local nCurrencyUnit = Get_XParam_INT(1)
		local nPrice = Get_XParam_INT(2)
		local nItemIndex = Get_XParam_INT(3)
		local nSerialNum = Get_XParam_INT(4)
		local nScriptID = Get_XParam_INT(5)
		local nYuanbaoPay = Get_XParam_INT(6)
		local nUniqueID = Get_XParam_INT(7)
		if nYuanbaoPay == nil or nYuanbaoPay ~= 1 then
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID )
		else
			-- WuhunQuest_Open_Window_ConvenintBuyConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID, nScriptID, nBuyCount );

			--  âÀïÃ»ÓÐÊýÁ¿ÉèÖÃ£¬°ïÐÞ³ÉÄ¬ÈÏ1
			WuhunQuest_Open_Window_ConvenintBuyConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID, nScriptID, 1 );
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99850605 ) then
		-- ÊÞ»êÈ¾É«
		local strMsg = Get_XParam_STR(0)
		local nType = Get_XParam_INT(0)
		local nCurrencyUnit = Get_XParam_INT(1)
		local nPrice = Get_XParam_INT(2)
		local nItemIndex = Get_XParam_INT(3)
		local nSerialNum = Get_XParam_INT(4)
		local nScriptID = Get_XParam_INT(5)
		local nYuanbaoPay = Get_XParam_INT(6)
		local nUniqueID = Get_XParam_INT(7)
		
		if nYuanbaoPay == nil or nYuanbaoPay ~= 1 then
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID )
		else
			-- WuhunQuest_Open_Window_ConvenintBuyConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID, nScriptID, nBuyCount );

			--  âÀïÃ»ÓÐÊýÁ¿ÉèÖÃ£¬°ïÐÞ³ÉÄ¬ÈÏ1
			WuhunQuest_Open_Window_ConvenintBuyConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID, nScriptID, 1 );
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89106201 ) then
		-- É¨µ´¿ì½Ý¹ºÂòÔÂ¿¨
		local strMsg = Get_XParam_STR(0)
		local nType = Get_XParam_INT(0)
		local nCurrencyUnit = Get_XParam_INT(1)
		local nPrice = Get_XParam_INT(2)
		local nItemIndex = Get_XParam_INT(3)
		local nSerialNum = Get_XParam_INT(4)
		local nScriptID = Get_XParam_INT(5)
		local nYuanbaoPay = Get_XParam_INT(6)
		local nUniqueID = Get_XParam_INT(7)

		if nYuanbaoPay == nil or nYuanbaoPay ~= 1 then
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID )
		else
			--  âÀïÃ»ÓÐÊýÁ¿ÉèÖÃ£¬°ïÐÞ³ÉÄ¬ÈÏ1
			WuhunQuest_Open_Window_ConvenintBuyConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID, nScriptID, 1 );
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89021506 ) then
		-- É¨µ´¿ì½Ý¹ºÂòÔÂ¿¨
		local strMsg = Get_XParam_STR(0)
		local nType = Get_XParam_INT(0)
		local nCurrencyUnit = Get_XParam_INT(1)
		local nPrice = Get_XParam_INT(2)
		local nItemIndex = Get_XParam_INT(3)
		local nSerialNum = Get_XParam_INT(4)
		local nScriptID = Get_XParam_INT(5)
		local nYuanbaoPay = Get_XParam_INT(6)
		local nUniqueID = Get_XParam_INT(7)

		if nYuanbaoPay == nil or nYuanbaoPay ~= 1 then
			ConvenientBuyItem(nType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID )
		else
			--  âÀïÃ»ÓÐÊýÁ¿ÉèÖÃ£¬°ïÐÞ³ÉÄ¬ÈÏ1
			WuhunQuest_Open_Window_ConvenintBuyConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID, nScriptID, 1 );
		end
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 83000121  then
		local nType = Get_XParam_INT(0)
		local nDressPos = Get_XParam_INT(1)
		local nParam = Get_XParam_INT(2)
		WuhunQuest_DressPaintBind_confirm(nType,nDressPos,nParam)
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 807012 ) then
		WuhunQuest_Clear_Var()
		
		g_FrameVar[1]  = Get_XParam_INT(0)
		g_FrameVar[2]  = Get_XParam_INT(1)
		g_FrameVar[3]  = Get_XParam_INT(2)
		local targetName = Get_XParam_STR(0);
		local targetServerName = Get_XParam_STR(1)	;		
		local msg =ScriptGlobal_Format( "#{FWQYM_160531_240}", targetName,targetServerName)
		WuhunQuest_InfoWindow:SetText( msg );	-- ????
		g_FrameInfo = FrameInfoList.CONFIRM_IMMIGRATION ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif (tonumber(arg0) == 99850602 ) then--????
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0)
		g_FrameVar[2] = Get_XParam_INT(1)
		g_FrameVar[3] = Get_XParam_INT(2)
		g_FrameVar[4] = Get_XParam_INT(3)
		g_FrameVar[5] = Get_XParam_INT(4)

		local nColor = Exterior:LuaFnGetRanSeColorItem(g_FrameVar[3], g_FrameVar[2])
		local planstr = Exterior:LuaFnGetRanSePlanName(g_FrameVar[3], nColor)

		local msg = ScriptGlobal_Format( "#{SHRS_230621_42}", planstr)
		WuhunQuest_InfoWindow:SetText( msg );	-- ????
		g_FrameInfo = FrameInfoList.PETSOUL_RANSE_CONFIRM ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "PETSOUL_RANSE_CONFIRM") then--ranse
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = tonumber(arg0);
		g_FrameVar[2] = tonumber(arg1);
		g_FrameVar[3] = tonumber(arg2);
		g_FrameVar[4] = tonumber(arg3);
		g_FrameVar[5] = tonumber(arg4);

		WuhunQuest_InfoWindow:SetText( "#{SHRS_230621_141}" );	-- ????
		g_FrameInfo = FrameInfoList.PETSOUL_RANSE_CONFIRM ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "QIXIRANK_EXCHANGE_CONFIRM" ) then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = tonumber( arg0 );
		g_FrameVar[2] = tonumber( arg1 );
		g_FrameVar[3] = tostring( arg2 );
		WuhunQuest_InfoWindow:SetText( g_FrameVar[3] );
		g_FrameInfo = FrameInfoList.QIXIRANK_EXCHANGE_CONFIRM;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)															-- ???????????
		this:Show();
	elseif ( event == "PETSOUL_RANSE_ZIDONG_CONFIRM") then--ranse zidong

		WuhunQuest_Clear_Var()
		g_FrameVar[1] = tonumber(arg0);
		g_FrameVar[2] = tonumber(arg1);
		g_FrameVar[3] = tonumber(arg2);
		if g_FrameVar[1] == 1 then
			WuhunQuest_InfoWindow:SetText( "#{SHRS_230621_141}" );	-- ????
		else
			local nColor = Exterior:LuaFnGetRanSeColorItem(g_FrameVar[3], g_FrameVar[2])
			local planstr = Exterior:LuaFnGetRanSePlanName(g_FrameVar[3], nColor)
			local str = ScriptGlobal_Format( "#{SHRS_230621_163}", planstr)
			WuhunQuest_InfoWindow:SetText( str );	-- ????
		end
		
		g_FrameInfo = FrameInfoList.PETSOUL_RANSE_ZIDONG_CONFIRM ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99852202 ) then --???? 
		WuhunQuest_Clear_Var()
		
		g_FrameVar[1]  = Get_XParam_INT(0)
		g_FrameVar[2]  = Get_XParam_INT(1)
		g_FrameVar[3]  = Get_XParam_INT(2)
		g_FrameVar[4]  = Get_XParam_INT(3)
		WuhunQuest_InfoWindow:SetText( "#{QQJG_20230815_21}" );	-- ????
		g_FrameInfo = FrameInfoList.QIONGQI_SWALLOW_CONFIRM ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{QQJG_20230815_22}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{QQJG_20230815_23}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99852204 ) then --???? 
		WuhunQuest_Clear_Var()
		
		g_FrameVar[1]  = Get_XParam_INT(0)
		g_FrameVar[2]  = Get_XParam_INT(1)

		WuhunQuest_InfoWindow:SetText( "#{QQJG_20230815_27}" );	-- ????
		g_FrameInfo = FrameInfoList.QIONGQI_RESTORE_CONFIRM ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{QQJG_20230815_22}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{QQJG_20230815_23}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20160601 ) then
		WuhunQuest_Clear_Var()
		
		g_FrameVar[1]  = Get_XParam_INT(0)
		g_FrameVar[2]  = Get_XParam_INT(1)
		g_FrameVar[3]  = Get_XParam_INT(2)
		g_FrameVar[4]  = Get_XParam_INT(3)
		local targetName = Get_XParam_STR(0);
		local targetServerName = Get_XParam_STR(1)	;		
		local msg =ScriptGlobal_Format( "#{FWQYM_160601_252}", targetName,targetServerName)
		WuhunQuest_InfoWindow:SetText( msg );	-- ????
		g_FrameInfo = FrameInfoList.CONFIRM_CANCEL_IMMIGRATION ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2023031401 ) then
		WuhunQuest_Clear_Var()
		
		g_FrameVar[1]  = Get_XParam_INT(0)
		g_FrameVar[2]  = Get_XParam_INT(1)
		g_FrameVar[3]  = Get_XParam_INT(2)
		g_FrameVar[4]  = Get_XParam_INT(3)
		local targetName = Get_XParam_STR(0);
		local targetServerName = Get_XParam_STR(1)	;		
		local msg =ScriptGlobal_Format( "#{DZYM_230907_120}", targetName,targetServerName)
		WuhunQuest_InfoWindow:SetText( msg );	-- ????
		g_FrameInfo = FrameInfoList.CONFIRM_CANCEL_ODER_IMMIGRATION ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2022913 ) then
		WuhunQuest_Clear_Var()
		
		g_FrameVar[1]  = Get_XParam_INT(0)
		g_FrameVar[2]  = Get_XParam_INT(1)
		g_FrameVar[3]  = Get_XParam_INT(2)
		g_FrameVar[4]  = Get_XParam_INT(3)
		local targetName = Get_XParam_STR(0);
		local targetServerName = Get_XParam_STR(1)	;		
		local msg =ScriptGlobal_Format( "#{FWQYM_160601_252}", targetName,targetServerName)
		WuhunQuest_InfoWindow:SetText( msg );	-- ????
		g_FrameInfo = FrameInfoList.CONFIRM_CANCEL_IMMIGRATION ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 80702702  then
		local targetId = Get_XParam_INT(0)
		local curCount = Get_XParam_INT(1)
		WuhunQuest_XiaRiDaKa_confirm(targetId,curCount)
	elseif event == "PETSOUL_EXCHANGE_CONFIRM" then
		WuhunQuest_PetSoul_Exchange_confirm(tonumber(arg0),tonumber(arg1),tonumber(arg2))
	elseif event == "PETSOUL_XISHUXING_CONFIRM" then
		WuhunQuest_PetSoul_Xishuxing_confirm(tonumber(arg0),tonumber(arg1))
	elseif event == "PETSOUL_XISHUXING_CHANGECONFIRM" then
		WuhunQuest_PetSoul_Xishuxing_change_confirm(tonumber(arg0))
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 80012707 ) then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] =Get_XParam_INT(0);
		g_FrameVar[2]= Get_XParam_INT(1);
		g_FrameVar[3]= Get_XParam_INT(2);
		g_FrameVar[4]= Get_XParam_INT(3);
		WuhunQuest_InfoWindow:SetText( "#{SHCX_20211229_48}" );	-- ????
		g_FrameInfo = FrameInfoList.PETSOUL_XISHUXING_CONFIRMPERFECT ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{SHCX_20211229_05}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{SHCX_20211229_06}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99869801 ) then--2024Q1??????
		WuhunQuest_Clear_Var()
		g_FrameVar[1] =Get_XParam_INT(0);
		WuhunQuest_InfoWindow:SetText( "#{SFYR_240104_204}" );	-- ????
		g_FrameInfo = FrameInfoList.SHENFENYURE_RESELECT ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{SFYR_240104_205}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{SFYR_240104_206}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99859602 ) then--???????
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0);
		WuhunQuest_InfoWindow:SetText( "#{WYCJ_20240320_35}" );	-- ????
		g_FrameInfo = FrameInfoList.ZIDIAN_PICKONE_CONFIRM ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{WYCJ_20240320_36}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{WYCJ_20240320_37}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99881901 ) then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0);
		g_FrameVar[2] = Get_XParam_INT(1);
		local str = ScriptGlobal_Format("#{HZLH_20240415_118}", g_FrameVar[2])
		WuhunQuest_InfoWindow:SetText( str );	-- ????
		g_FrameInfo = FrameInfoList.DUANWUDAKA_CONFIRM ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{HZLH_20240415_111}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{HZLH_20240415_112}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 80012709 ) then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] =Get_XParam_INT(0);
		g_FrameVar[2]= Get_XParam_INT(1);
		g_FrameVar[3]= Get_XParam_INT(2);
		g_FrameVar[4]= Get_XParam_INT(3);
		WuhunQuest_InfoWindow:SetText( "#{SHCX_20211229_51}" );	-- ????
		g_FrameInfo = FrameInfoList.PETSOUL_XISHUXING_CONFIRMBIND ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{SHCX_20211229_05}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{SHCX_20211229_06}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 80012714  then
		WuhunQuest_PetSoul_Fusion_ConfirmBind()
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 80012711  then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --targetId
		g_FrameVar[2] = Get_XParam_INT(1) --BagIndex
		WuhunQuest_PetSoulLevelUp_Confirm()
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 80012712  then
		WuhunQuest_Clear_Var()
		local szText = Get_XParam_STR(0);
		WuhunQuest_PetSoul_BloodLevelUp_Confirm( szText )
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 80012722  then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --targetId
		g_FrameVar[2] = Get_XParam_INT(1) --BagIndex
		g_FrameVar[3] = Get_XParam_INT(2) --nMatBagPos
		g_FrameVar[4] = Get_XParam_INT(3) --bConfirm
		WuhunQuest_PetSoulBloodLevelUp_BindConfirm()		
	--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ3 ÖØÐÂÌô ½È·ÈÏ
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 89320302  then
		WuhunQuest_LiLianMission23_Confirm()		
	--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ2 »¨·Ñ½ð±ÒÈ·ÈÏ
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 89318701  then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = 1
		g_FrameVar[2] = Get_XParam_INT(0) --targetId
		WuhunQuest_LiLianMission2_Confirm()		
	--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ2 »¨·Ñ½ð±ÒÈ·ÈÏ
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 89319701  then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = 2
		g_FrameVar[2] = Get_XParam_INT(0) --targetId
		WuhunQuest_LiLianMission2_Confirm()		
	--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ2 »¨·Ñ½ð±ÒÈ·ÈÏ
	elseif   event == "UI_COMMAND" and tonumber(arg0) == 89320701  then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = 3
		g_FrameVar[2] = Get_XParam_INT(0) --targetId
		WuhunQuest_LiLianMission2_Confirm()		
	elseif event == "UI_COMMAND" and tonumber(arg0) == 88889901 then
		local bShow = Get_XParam_INT(0)
		if bShow == 1 then --??
			WuhunQuest_PrizeWaiting()
			this:Show();
		else
			this:Hide();
		end
	elseif event == "ZHOUCHANG_BUY_ITEM_CONFIRM" then 
		WuhunQuest_WeeklyShopConfirm()
	elseif event == "DRESS_TRANSFER_BIND_CONFIRM" then
		WuhunQuest_Dress_Transfer_Bind_Confirm()
		return		
	elseif event == "QINGQIU_BUY_ITEM_CONFIRM" then 
		WuhunQuest_QingQiuShopConfirm()
	elseif event == "DRESS_TRANSFER_BUYITEM_CONFIRM" then
		local nUniqueID = tonumber(arg0)
		local nNeedItemNum = tonumber(arg1)
		local nBuyNum = tonumber(arg2)
		local nPrice = tonumber(arg3)
		local nBuyType = tonumber(arg4)
		local nCurrencyUnit = tonumber(arg5)
		local nItemIndex = tonumber(arg6)
		local nSerialNum = tonumber(arg7)
		local bBuyConfirm = tonumber(arg8)
				
		if bBuyConfirm == 1 then
			WuhunQuest_Dress_Transfer_BuyItem_Confirm(nUniqueID,nNeedItemNum,nBuyNum,nPrice,nBuyType,nCurrencyUnit,nItemIndex,nSerialNum)
		else
			ConvenientBulkBuyItem(nBuyType,nCurrencyUnit,nPrice,nItemIndex,nSerialNum,nUniqueID,nBuyNum)
		end
		
		return
	elseif (event=="HIDE_ON_SCENE_TRANSED") then
		if g_FrameInfo == FrameInfoList.DWLEVELUP_BINDCONFIRM 
			or g_FrameInfo == FrameInfoList.DW_CONSUMESURE_EQUIPDWLEVELUP 
			or g_FrameInfo == FrameInfoList.FASHION_LOTTERY_SIGNUP_CONFIRM 
			or g_FrameInfo == FrameInfoList.PETTAYIN_CONFIRM  
			or g_FrameInfo == FrameInfoList.BWZQ_GOTOBHGAREA_CONFIRM
			or g_FrameInfo == FrameInfoList.QIXITOPLIST_CONFIRM
			or g_FrameInfo == FrameInfoList.QIXIRANK_EXCHANGE_CONFIRM
			or g_FrameInfo == FrameInfoList.QINGRENJIETOPLIST_CONFIRM
			or g_FrameInfo == FrameInfoList.QRJTOPLIST_EXCHANGE_CONFIRM
			or g_FrameInfo == FrameInfoList.REPUTATIONSHOP_BUY_CONFIRM
			or g_FrameInfo == FrameInfoList.BWZQ_GOTOBHGAREA_WAITCONFIRM
			or g_FrameInfo == FrameInfoList.BWZQ_SPONSOR_VOTE_CONFIRM  then
			this:Hide()
		end
	elseif (event=="BINDSURE_EQUIPDWLEVELUP" and tonumber(arg0)==0) then
		WuhunQuest_DWLevelUp_BindSure_Confirm()
		return
	elseif (event=="CONSUMESURE_EQUIPDWLEVELUP") then
		WuhunQuest_ConsumeSure_EquipDWLevelup(tonumber(arg0),tonumber(arg1),tonumber(arg2),tonumber(arg3),tonumber(arg4),tonumber(arg5))
		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89330301 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.XUYUANCHI_ITEM
		g_FrameVar[1] = Get_XParam_INT(0)
		local msg =ScriptGlobal_Format( "#{ZNSC_220624_100}", Get_XParam_INT(1))
		WuhunQuest_InfoWindow:SetText( msg )--Get_XParam_INT(1)
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{ZNSC_220624_101}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{ZNSC_220624_102}");
		WuhunQuestUpdateRect()
		this:Show()
		
		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89005401 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.GONGCANJIAWEI_CONFIRM
		g_FrameVar[1] = Get_XParam_INT(0)
		WuhunQuest_InfoWindow:SetText( "#{GCJW_221017_48}" )
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{GCJW_221017_49}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{GCJW_221017_50}");
		WuhunQuestUpdateRect()
		this:Show()
		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89004601 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.GONGCANJIAWEI_CONFIRMSUBMIT
		g_FrameVar[1] = Get_XParam_INT(0)
		WuhunQuest_InfoWindow:SetText( "#{GCJW_221017_79}" )
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{GCJW_221017_91}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{GCJW_221017_92}");
		WuhunQuestUpdateRect()
		this:Show()
		return	
	elseif tonumber(arg0) == 88880802 then
		WuhunQuest_Clear_Var()		
		g_FrameVar[1]  = Get_XParam_INT(0)  --targetId
		g_FrameVar[2]  = Get_XParam_INT(1)  --bagIndex_lingyu
		g_FrameVar[3]  = Get_XParam_INT(2)  --bagIndex_item
		WuhunQuest_LingYu_Wash_Confirm()
	elseif tonumber(arg0) == 88880803 then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --targetId
		g_FrameVar[2] = Get_XParam_INT(1) --bagIndex_lingyu
		WuhunQuest_LingYu_Switch_Confirm()
	elseif tonumber(arg0) == 88880806 then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --recipe
		g_FrameVar[2] = Get_XParam_INT(1) --bagIndex
		WuhunQuest_LingYu_Make_Confirm()
	elseif tonumber(arg0) == 88880808 then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --target
		g_FrameVar[2] = Get_XParam_INT(1) --src_item
		g_FrameVar[3] = Get_XParam_INT(2) --tar_item
		WuhunQuest_LingYu_Compound_Confirm()
	elseif tonumber(arg0) == 88880809 then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --target
		g_FrameVar[2] = Get_XParam_INT(1) --bagIndex
		WuhunQuest_LingYu_Recycle_Confirm()
	elseif tonumber(arg0) == 88880811 then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --target
		g_FrameVar[2] = Get_XParam_INT(1) --fromBagIndex
		g_FrameVar[3] = Get_XParam_INT(2) --toBagIndex
		WuhunQuest_LingYu_Transition_Confirm()
	elseif tonumber(arg0) == 88880812 then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --target
		g_FrameVar[2] = Get_XParam_INT(1) --bagIndex
		WuhunQuest_LingYu_Unbind_Confirm()
	elseif tonumber(arg0) == 88882002 then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --bagIndex
		WuhunQuest_Equip_Refresh_Bind_Confirm()
	elseif tonumber(arg0) == 88881101 then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --target
		g_FrameVar[2] = Get_XParam_INT(1) --lottery_index
		g_FrameVar[3] = Get_XParam_INT(2) --yuanbao
		g_FrameVar[4] = Get_XParam_INT(3) --itemtableindex
		WuhunQuest_FashionLotterySignUp_Confirm()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 80602105 ) then
		WuhunQuest_Clear_Var()
		
		local planeLevel = Get_XParam_INT(0)
		if planeLevel == 3 then
			WuhunQuest_InfoWindow:SetText( "#{JHYH_230330_333}" );	-- ????
		else
			WuhunQuest_InfoWindow:SetText( "#{JHYH_230330_142}" );	-- ????
		end

		g_FrameInfo = FrameInfoList.MARRY_PLANE_NOTICE ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{JHYH_230330_332}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99838703 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.FANCHANG_SHOP_CONFIRM
		g_FrameVar[1] = Get_XParam_INT(0)
		WuhunQuest_InfoWindow:SetText( Get_XParam_STR(0) )
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{GCJW_221017_49}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{GCJW_221017_50}");
		WuhunQuestUpdateRect()
		DataPool:SetCanUseHotKey(0)
		this:Show()
		return
	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 891396005 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.QIXITOPLIST_CONFIRM
		g_FrameVar[1] = Get_XParam_INT(0)
		
		local str = ScriptGlobal_Format("#{QXHB_20230711_35}", g_FrameVar[1], g_FrameVar[1]*10000)
		WuhunQuest_InfoWindow:SetText( str )
		
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{QXHB_20230711_36}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{QXHB_20230711_37}");
		WuhunQuestUpdateRect()
		DataPool:SetCanUseHotKey(0)
		this:Show()
		return
	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 892974005 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.QINGRENJIETOPLIST_CONFIRM
		g_FrameVar[1] = Get_XParam_INT(0)
		
		local str = ScriptGlobal_Format("#{QRZM_231017_12}", g_FrameVar[1], g_FrameVar[1]*10000)
		WuhunQuest_InfoWindow:SetText( str )
		
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{QRZM_231017_13}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{QRZM_231017_14}");
		WuhunQuestUpdateRect()
		DataPool:SetCanUseHotKey(0)
		this:Show()
		return
	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89297406 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.QRJTOPLIST_EXCHANGE_CONFIRM
		g_FrameVar[1] = Get_XParam_INT(0)
		
		local str = Get_XParam_STR(0);
		WuhunQuest_InfoWindow:SetText( str )
		
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{QRZM_231017_13}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{QRZM_231017_14}");
		WuhunQuestUpdateRect()
		DataPool:SetCanUseHotKey(0)
		this:Show()
		return
	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99858502 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.REPUTATIONSHOP_BUY_CONFIRM
		g_FrameVar[1] = Get_XParam_INT(0)
		g_FrameVar[2] = Get_XParam_INT(1)
		g_FrameVar[3] = Get_XParam_INT(2)
		g_FrameVar[4] = Get_XParam_INT(3)
		
		local str = Get_XParam_STR(0);
		WuhunQuest_InfoWindow:SetText( str )
		
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{QRZM_231017_13}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{QRZM_231017_14}");
		WuhunQuestUpdateRect()
		DataPool:SetCanUseHotKey(0)
		this:Show()
		return
		
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 998478002 ) then
		WuhunQuest_Clear_Var()
		
		if Get_XParam_INT(0) == 1 then
			g_FrameVar[1] = Get_XParam_INT(0)
			g_FrameVar[2] = Get_XParam_INT(1)
			g_FrameVar[3] = Get_XParam_INT(2)
			g_FrameVar[4] = Get_XParam_INT(3)
			g_FrameVar[5] = Get_XParam_INT(4)
		
			local str = ScriptGlobal_Format("#{ZSHF_20230705_34}", Pet:Lua_GetPetExteriorNameByPetGuid(g_FrameVar[3], g_FrameVar[4]))
			WuhunQuest_InfoWindow:SetText( str );	-- ????		
		elseif Get_XParam_INT(0) == 2 then
			g_FrameVar[1] = Get_XParam_INT(0)
			g_FrameVar[2] = Get_XParam_INT(1)
			
			local str = ScriptGlobal_Format("#{ZSHF_20230705_87}", Pet:Lua_GetPetExteriorInfo(g_FrameVar[2], "Name"))
			WuhunQuest_InfoWindow:SetText( str );	-- ????		
		else
			return
		end

		g_FrameInfo = FrameInfoList.PETTAYIN_CONFIRM ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{ZSHF_20230705_35}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{ZSHF_20230705_36}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif event == "UI_COMMAND" and tonumber(arg0) == 88990902 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.DAHUA_DAIBI_CONFIRM
		g_FrameVar[1] = Get_XParam_INT(0)
		WuhunQuest_InfoWindow:SetText( Get_XParam_STR(0) )
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{GCJW_221017_49}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{GCJW_221017_50}");
		WuhunQuestUpdateRect()
		DataPool:SetCanUseHotKey(0)
		this:Show()
		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 88991001 then
		WuhunQuest_Clear_Var()
		g_FrameInfo = FrameInfoList.DAHUA_DAIBI_SHOP_CONFIRM
		g_FrameVar[1] = Get_XParam_INT(0)
		WuhunQuest_InfoWindow:SetText( Get_XParam_STR(0) )
		WuhunQuest_Button1:Show();
		WuhunQuest_Button1:SetText("#{GCJW_221017_49}");
		WuhunQuest_Button2:Show();
		WuhunQuest_Button2:SetText("#{GCJW_221017_50}");
		WuhunQuestUpdateRect()
		DataPool:SetCanUseHotKey(0)
		this:Show()
		return
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89106203 ) then
		WuhunQuest_Clear_Var()
		local str = Get_XParam_STR(0);
		g_FrameVar[1] = Get_XParam_INT(0)  
		WuhunQuest_InfoWindow:SetText( str );	-- ????		 
		g_FrameInfo = FrameInfoList.SECKILL_TESE ;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{ZSHF_20230705_35}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{ZSHF_20230705_36}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99854002 ) then
		WuhunQuest_YuLongZaiTian_Gift_Confirm()
	elseif event == "EQUIP_REFRESH_EQUIP_CHANGE_CONFIRM" then
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = tonumber(arg0)
		g_FrameVar[2] = tonumber(arg1)
		WuhunQuest_Equip_Refresh_Equip_Change_Confirm()
	elseif event == "EQUIP_REFRESH_CLOSE_CONFIRM" then
		WuhunQuest_Clear_Var()
		WuhunQuest_Equip_Refresh_Close_Confirm()

	elseif event == "UI_COMMAND" and tonumber(arg0) == 89030511 then --DWJINJIE
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0) --targetId
		g_FrameVar[2] = Get_XParam_INT(1) --itEquip
		g_FrameVar[3] = Get_XParam_INT(2) --itJinJie
		g_FrameInfo = FrameInfoList.CONFIRM_DWJINJIE
		WuhunQuest_InfoWindow:SetText("#{DWJJ_240329_33}")
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{ZSHF_20230705_35}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{ZSHF_20230705_36}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89030512 then --DWJINJIESHENGJI
		WuhunQuest_Clear_Var()
		g_FrameVar[1] = Get_XParam_INT(0)
		if g_FrameVar[1] == 1 then
			g_FrameVar[2] = Get_XParam_INT(1) --targetId
			g_FrameVar[3] = Get_XParam_INT(2) --itEquip
			g_FrameVar[4] = Get_XParam_INT(3) --bUseYuanbao
			g_FrameVar[5] = Get_XParam_INT(4) --reqZZJCS
			g_FrameVar[6] = Get_XParam_INT(5) --zzjcsCount
			g_FrameVar[7] = Get_XParam_INT(6) --yuanbaoCost
			g_FrameVar[8] = Get_XParam_INT(7) --nTargetLevel
			local str =  ScriptGlobal_Format("#{DWJJ_240329_65}",g_FrameVar[7])
			--local itemID = PlayerPackage:GetItemTableIndex(g_FrameVar[3])
			WuhunQuest_InfoWindow:SetText(ScriptGlobal_Format("#{DWJJ_240329_64}",
			g_FrameVar[5],
			g_FrameVar[6],
			str,
			g_FrameVar[5] - g_FrameVar[6]
			))
		end
		g_FrameInfo = FrameInfoList.CONFIRM_DWJINJIESHENGJI
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{ZSHF_20230705_35}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{ZSHF_20230705_36}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89030513 then --DWJINJIEHUITUI
		WuhunQuest_Clear_Var()
			g_FrameVar[1] = Get_XParam_INT(0) --targetId
			g_FrameVar[2] = Get_XParam_INT(1) --itEquip
			g_FrameVar[3] = Get_XParam_INT(2) --needYB
			g_FrameVar[4] = Get_XParam_INT(3) --getJCS
			g_FrameVar[5] = Get_XParam_INT(4) --??
			--local itemID = PlayerPackage:GetItemTableIndex(g_FrameVar[3])
			WuhunQuest_InfoWindow:SetText(ScriptGlobal_Format("#{DWJJ_240329_115}",
			g_FrameVar[3],
			g_FrameVar[4],
			g_FrameVar[5]
			))
		g_FrameInfo = FrameInfoList.CONFIRM_DWJINJIEHUITUI
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{ZSHF_20230705_35}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{ZSHF_20230705_36}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99936110 then
		WuhunQuest_Clear_Var()
		WuhunQuest_Ornaments_Confirm(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2))
	elseif event == "UI_COMMAND" and tonumber(arg0) == 5112805 then 
		WuhunQuest_Clear_Var()
		WuhunQuest_InfoWindow:SetText("#{QXPVE_240628_32}")
		g_FrameInfo = FrameInfoList.CONFIRM_QIXIPVE_LEAVE
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{ZSHF_20230705_35}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{ZSHF_20230705_36}");  --??
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
		return
	end
end

-- °´Å¥1 µã»÷ÊÂ¼þ
function WuhunQuest_Bn1Click()

	if (g_FrameInfo == FrameInfoList.YBMARKET_UP_ITEM_COMFIRM ) then
		Auction:PacketSend_SellItem(g_FrameVar[1] , tonumber(g_FrameVar[2]) , 1)
	elseif (g_FrameInfo == FrameInfoList.YBMARKET_UP_PET_COMFIRM  ) then
		Auction:PacketSend_SellPet(g_FrameVar[1] , tonumber(g_FrameVar[2]) ,1)
	elseif (g_FrameInfo == FrameInfoList.YBMARKET_BUY_COMFIRM  ) then
		Auction:PacketSend_Buy(g_FrameVar[1] , g_FrameVar[2] , 1)
	elseif (g_FrameInfo == FrameInfoList.YBMARKET_CONFIRM_MULTIBUY  ) then
		Auction:PacketSend_MultiBuy(1)
	elseif (g_FrameInfo == FrameInfoList.YBMARKET_TAKE_BACK_COMFIRM  ) then
		Auction:GetBackWhatOnSale(g_FrameVar[1] , g_FrameVar[2] ,1 )
	elseif (g_FrameInfo == FrameInfoList.SELL_ITEM_CONFIRM) then
		local nNeedQueRen = WuhunQuest_CheckBtn:GetCheck()
		-- ÉèÖÃ±ê¼Ç£¬Ö®ºó²»ÔÙµ¯¶þ´ÎÈ·ÈÏ´°
		if nNeedQueRen > 0 then
			DataPool:SetSellErciQueRen()
		end
		PlayerPackage:SellCurrItem(tonumber(g_FrameVar[1]) )
	elseif (g_FrameInfo == FrameInfoList.PETTAYIN_YBbuy_CONFIRM) then
		ConvenientBuyItem(g_FrameVar[1],g_FrameVar[2],g_FrameVar[3],g_FrameVar[4],g_FrameVar[5],g_FrameVar[6] );
	elseif (g_FrameInfo == FrameInfoList.PET_HUANTONT_CONFIRM) then--add:lby
		ConvenientBuyItem(g_FrameVar[1],g_FrameVar[2],g_FrameVar[3],g_FrameVar[4],g_FrameVar[5],g_FrameVar[6] );
	elseif (g_FrameInfo == FrameInfoList.PET_LINGXING_CONFIRM) then--add:lby
		ConvenientBuyItem(g_FrameVar[1],g_FrameVar[2],g_FrameVar[3],g_FrameVar[4],g_FrameVar[5],g_FrameVar[6] );
	elseif (g_FrameInfo == FrameInfoList.QUICKUP_PET_CONFIRM) then
		PushEvent("QUICKUP_PET_SENDMSG",g_FrameVar[1])
	elseif (g_FrameInfo == FrameInfoList.CONVENIENT_BUY_CONFIRM) then
		ConvenientBuyItem(g_FrameVar[1],g_FrameVar[2],g_FrameVar[3],g_FrameVar[4],g_FrameVar[5],g_FrameVar[6],g_FrameVar[8] );
	elseif g_FrameInfo == FrameInfoList.DARK_SKILL_RECOIN_CONFIRM then
		PushEvent("DARK_SKILL_RECOIN_CONFIRM_OK",g_FrameVar[1],g_FrameVar[2])
	elseif g_FrameInfo == FrameInfoList.SUPER_ATTR_RECOIN_CONFIRM then
		PushEvent("SUPER_ATTR_RECOIN_CONFIRM_OK",g_FrameVar[1],g_FrameVar[2])
	elseif g_FrameInfo == FrameInfoList.WUHUN_SKILL_RECOIN_CONFIRM then
		PushEvent("WUHUN_SKILL_RECOIN_CONFIRM_OK",g_FrameVar[1],g_FrameVar[2])
	elseif g_FrameInfo == FrameInfoList.DELETE_COUPLE_DIARY_CONFIRM then
		CoupleZone:LuaFnDeleteDiaryByRealId(g_FrameVar[1])
	elseif (g_FrameInfo == FrameInfoList.BILLINGAWARD_CONFIRM) then
		PushEvent("BILLINGAWARD_CONFIRM_OK", g_FrameVar[1]);
	elseif (g_FrameInfo == FrameInfoList.MATERIALCOMPOUND_CONFIRM) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("MaterialCompound");
			Set_XSCRIPT_ScriptID(701602);
			Set_XSCRIPT_Parameter(0,g_FrameVar[1]);
			Set_XSCRIPT_Parameter(1,g_FrameVar[2]);
			Set_XSCRIPT_Parameter(2,1);
			Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();
	elseif (g_FrameInfo==FrameInfoList.WHWG_GRADEUP_CONFIRM) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GradeUpWg")
			Set_XSCRIPT_ScriptID(888800)
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (g_FrameInfo == FrameInfoList.APPLY_SNAKING_NUM_SECOND_CONFIRM) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OkApplySnakingNum" )
			Set_XSCRIPT_ScriptID( 250558 )
			Set_XSCRIPT_Parameter(0,g_FrameVar[1]) 
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.SECKILL_GIVEUP_CONFIRM then
		SecKillGiveUpItem()
	elseif g_FrameInfo == FrameInfoList.DOUBLE_SECKILL_CONFIRM then
		PushEvent("SEND_SECKILL", 0, g_FrameVar[1], g_FrameVar[2], g_FrameVar[3])
	elseif g_FrameInfo == FrameInfoList.DRESSPAINT_BINDITEM_CONFIRM then
		if g_FrameVar[1] ~= nil then
			if g_FrameVar[1] == 1 then
				Clear_XSCRIPT()
					Set_XSCRIPT_Function_Name("OnDressPaint")
					Set_XSCRIPT_ScriptID(830001)
					Set_XSCRIPT_Parameter(0, g_FrameVar[2])
					Set_XSCRIPT_Parameter(1, g_FrameVar[3])
					Set_XSCRIPT_ParamCount(2)
				Send_XSCRIPT()
			elseif g_FrameVar[1] == 2 then
				Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("OnAutoDressPaint")
					Set_XSCRIPT_ScriptID(830001)
					Set_XSCRIPT_Parameter(0, g_FrameVar[2])
					Set_XSCRIPT_Parameter(1, g_FrameVar[3])
					Set_XSCRIPT_ParamCount(2)
				Send_XSCRIPT() 
			end
		end
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_IMMIGRATION) then
	
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SpouseImmigrationCallBack")
		Set_XSCRIPT_ScriptID(807012)
		Set_XSCRIPT_Parameter(0,g_FrameVar[2])
		Set_XSCRIPT_Parameter(1,g_FrameVar[3])
		Set_XSCRIPT_Parameter(2,1)
		Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif(g_FrameInfo == FrameInfoList.PETSOUL_RANSE_CONFIRM) then--????
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnPossPaint")
			Set_XSCRIPT_ScriptID(998506)
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, g_FrameVar[3])
			Set_XSCRIPT_Parameter(3, 1)
			Set_XSCRIPT_Parameter(4, g_FrameVar[5])
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT() 
	elseif ( g_FrameInfo == FrameInfoList.QIXIRANK_EXCHANGE_CONFIRM ) then
		--2015ÆßÏ¦ÇéÈË½ÚÅÅÐÐ°ñ¶Ò»»¶þ´ÎÈ·ÈÏ
		if g_FrameVar[1] == 1 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "Qingrenjie_Exchange" )
				Set_XSCRIPT_ScriptID( 891396 )
				Set_XSCRIPT_Parameter(0,g_FrameVar[2])
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
		end
	elseif(g_FrameInfo == FrameInfoList.PETSOUL_RANSE_ZIDONG_CONFIRM) then--???? zidong
		PushEvent("PETSOUL_RANSE_ZIDONG_CONFIRM_BACK")

	elseif (g_FrameInfo == FrameInfoList.QIONGQI_SWALLOW_CONFIRM) then--????
	
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Swallow")
			Set_XSCRIPT_ScriptID(998522)
			Set_XSCRIPT_Parameter(0,g_FrameVar[1])
			Set_XSCRIPT_Parameter(1,g_FrameVar[2])
			Set_XSCRIPT_Parameter(2,g_FrameVar[3])
			Set_XSCRIPT_Parameter(3,g_FrameVar[4])
			Set_XSCRIPT_Parameter(4,1)
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()	

	elseif (g_FrameInfo == FrameInfoList.QIONGQI_RESTORE_CONFIRM) then--????
	
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Restore")
			Set_XSCRIPT_ScriptID(998522)
			Set_XSCRIPT_Parameter(0,g_FrameVar[1])
			Set_XSCRIPT_Parameter(1,g_FrameVar[2])
			Set_XSCRIPT_Parameter(2,1)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()	

	elseif (g_FrameInfo == FrameInfoList.CONFIRM_CANCEL_IMMIGRATION) then
	
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SpuoseCancelImmg_confirm")
		Set_XSCRIPT_ScriptID(807012)
		Set_XSCRIPT_Parameter(0,g_FrameVar[2])
		Set_XSCRIPT_Parameter(1,g_FrameVar[3])
		Set_XSCRIPT_Parameter(2,1)
		Set_XSCRIPT_Parameter(3,g_FrameVar[4])
		Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()	
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_CANCEL_ODER_IMMIGRATION) then
	
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SpuoseCancelImmg_confirm")
		Set_XSCRIPT_ScriptID(807014)
		Set_XSCRIPT_Parameter(0,g_FrameVar[2])
		Set_XSCRIPT_Parameter(1,g_FrameVar[3])
		Set_XSCRIPT_Parameter(2,1)
		Set_XSCRIPT_Parameter(3,g_FrameVar[4])
		Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()		
	elseif g_FrameInfo == FrameInfoList.XIARIDAKA_CONFIRM then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnFinishClk")
			Set_XSCRIPT_ScriptID(807027);
			Set_XSCRIPT_Parameter(0,g_FrameVar[1]);
			Set_XSCRIPT_Parameter(1,0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif g_FrameInfo == FrameInfoList.PETSOUL_EXCHANGE_CONFIRM then
		PushEvent("PETSOUL_EXCHANGE_CONFIRMOK",g_FrameVar[1],g_FrameVar[2])

	elseif g_FrameInfo == FrameInfoList.PETSOUL_XISHUXING_CONFIRM then
		PushEvent("PETSOUL_XISHUXING_CONFIRMOK",g_FrameVar[1],g_FrameVar[2])
	elseif g_FrameInfo == FrameInfoList.PETSOUL_XISHUXING_CHANGECONFIRM then
		Pet:LuaFnSavePetSoulExValue(g_FrameVar[1])
	elseif g_FrameInfo == FrameInfoList.PETSOUL_XISHUXING_CONFIRMPERFECT then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnPetSoulXiShuXing")
			Set_XSCRIPT_ScriptID(800127);
			Set_XSCRIPT_Parameter(0,g_FrameVar[1]);
			Set_XSCRIPT_Parameter(1,g_FrameVar[2]);
			Set_XSCRIPT_Parameter(2,g_FrameVar[3]);
			Set_XSCRIPT_Parameter(3,g_FrameVar[4]);
			Set_XSCRIPT_Parameter(4,2);
			Set_XSCRIPT_ParamCount(5);
		Send_XSCRIPT();
	elseif g_FrameInfo == FrameInfoList.SHENFENYURE_RESELECT then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("Reselect")
			Set_XSCRIPT_ScriptID(998698);
			Set_XSCRIPT_Parameter(0,g_FrameVar[1]);
			Set_XSCRIPT_Parameter(1,1);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif g_FrameInfo == FrameInfoList.ZIDIAN_PICKONE_CONFIRM then
		Clear_XSCRIPT();
			if g_FrameVar[1] == 2 then
				Set_XSCRIPT_Function_Name("OnChooseRight")
			else
				Set_XSCRIPT_Function_Name("OnChooseLeft")
			end
			Set_XSCRIPT_ScriptID(998596);
			Set_XSCRIPT_Parameter(0, 0);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	elseif g_FrameInfo == FrameInfoList.DUANWUDAKA_CONFIRM then
		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnSubmitTimeOut")
			Set_XSCRIPT_ScriptID(998819);
			Set_XSCRIPT_Parameter(0, g_FrameVar[1]);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		
		
	elseif g_FrameInfo == FrameInfoList.PETSOUL_XISHUXING_CONFIRMBIND then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnPetSoulXiShuXing")
			Set_XSCRIPT_ScriptID(800127);
			Set_XSCRIPT_Parameter(0,g_FrameVar[1]);
			Set_XSCRIPT_Parameter(1,g_FrameVar[2]);
			Set_XSCRIPT_Parameter(2,g_FrameVar[3]);
			Set_XSCRIPT_Parameter(3,g_FrameVar[4]);
			Set_XSCRIPT_Parameter(4,1);
			Set_XSCRIPT_ParamCount(5);
		Send_XSCRIPT();
	elseif (g_FrameInfo == FrameInfoList.NEW_DAKONG_CONFIRM) then
		ConvenientBuyItem(g_FrameVar[1],g_FrameVar[2],g_FrameVar[3],g_FrameVar[4],g_FrameVar[5],g_FrameVar[6] );
		g_StilettoEx_Material_Buy = 1
	elseif (g_FrameInfo == FrameInfoList.NEW_XIANGQIAN_CONFIRM) then
		ConvenientBuyItem(g_FrameVar[1],g_FrameVar[2],g_FrameVar[3],g_FrameVar[4],g_FrameVar[5],g_FrameVar[6] );
		g_EnchaseEx_Material_Buy = 1
	elseif (g_FrameInfo == FrameInfoList.NEW_ZHAICHU_CONFIRM) then
		ConvenientBuyItem(g_FrameVar[1],g_FrameVar[2],g_FrameVar[3],g_FrameVar[4],g_FrameVar[5],g_FrameVar[6] );
		g_SplitGemEx_Material_Buy = 1
	elseif g_FrameInfo == FrameInfoList.PETSOUL_FUSION_CONFIRMBIND then
		PushEvent("UI_COMMAND", 80012724)
	elseif g_FrameInfo == FrameInfoList.PETSOUL_LEVELUP_CONFIRM then
		PushEvent("PETSOUL_LEVELUP_CONFIRM")
	elseif g_FrameInfo == FrameInfoList.PETSOUL_BLOODLEVELUP_CONFIRM then
		PushEvent("PETSOUL_BLOODLEVELUP_CONFIRM")
	elseif g_FrameInfo == FrameInfoList.PETSOUL_BLOODLEVELUP_BINDCONFIRM then
		PushEvent("PETSOUL_BLOODLEVELUP_BINDCONFIRM")
	elseif g_FrameInfo == FrameInfoList.DRESS_TRANSFER_BUYITEM_CONFIRM then
		ConvenientBulkBuyItem(g_FrameVar[1],g_FrameVar[2],g_FrameVar[3],g_FrameVar[4],g_FrameVar[5],g_FrameVar[7],g_FrameVar[6])
	--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ3 ÖØÐÂÌô ½È·ÈÏ
	elseif g_FrameInfo == FrameInfoList.LILIANMISSION23_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ConfirmOK")
			Set_XSCRIPT_ScriptID(893202)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ2 »¨·Ñ½ð±ÒÈ·ÈÏ
	elseif g_FrameInfo == FrameInfoList.LILIANMISSION2_CONFIRM then
		if g_FrameVar[1] == 1 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("SubmitMoney")
				Set_XSCRIPT_ScriptID(893187)
				Set_XSCRIPT_Parameter(0, g_FrameVar[2])
				Set_XSCRIPT_Parameter(1, 1)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		elseif g_FrameVar[1] == 2 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("SubmitMoney")
				Set_XSCRIPT_ScriptID(893197)
				Set_XSCRIPT_Parameter(0, g_FrameVar[2])
				Set_XSCRIPT_Parameter(1, 1)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT() 
		elseif g_FrameVar[1] == 3 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("SubmitMoney")
				Set_XSCRIPT_ScriptID(893207)
				Set_XSCRIPT_Parameter(0, g_FrameVar[2])
				Set_XSCRIPT_Parameter(1, 1)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT() 
		end
	elseif g_FrameInfo == FrameInfoList.DWLEVELUP_BINDCONFIRM then
		PushEvent("BINDSURE_EQUIPDWLEVELUP",1)
	elseif g_FrameInfo == FrameInfoList.QINGQIU_BUYCONFIRM then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("buyitem")
		Set_XSCRIPT_ScriptID( 893060 )
		Set_XSCRIPT_Parameter( 0, g_FrameVar[3] ); 
		Set_XSCRIPT_Parameter( 1, g_FrameVar[4]  ); 
		Set_XSCRIPT_Parameter( 2, g_FrameVar[5]  ); 
		Set_XSCRIPT_ParamCount( 3 ); 
		Send_XSCRIPT()	
	elseif g_FrameInfo == FrameInfoList.JIYUAN_BUYCONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("buyitem")
			Set_XSCRIPT_ScriptID( 893113 )
			Set_XSCRIPT_Parameter( 0, g_FrameVar[3] ); 
			Set_XSCRIPT_Parameter( 1, g_FrameVar[1]  );  
			Set_XSCRIPT_ParamCount( 2 ); 
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.DW_CONSUMESURE_EQUIPDWLEVELUP then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoEquipDWLevelUp")
			Set_XSCRIPT_ScriptID(809272)
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT() 
	elseif g_FrameInfo == FrameInfoList.WEEKLYSHOP_BUYCONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("buyitem")
			Set_XSCRIPT_ScriptID( 893129 )
			Set_XSCRIPT_Parameter( 0, g_FrameVar[3] ); 
			Set_XSCRIPT_Parameter( 1, g_FrameVar[4] ); 
			Set_XSCRIPT_Parameter( 2, g_FrameVar[1]  );  
			Set_XSCRIPT_Parameter( 3, Lua_GetWeeklyShopCurWeek() );  
			Set_XSCRIPT_ParamCount( 4 ); 
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.XUYUANCHI_ITEM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("UseItem")
			Set_XSCRIPT_ScriptID( 893303 )
			Set_XSCRIPT_Parameter( 0, g_FrameVar[1] ); 
			Set_XSCRIPT_ParamCount( 1 ); 
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.GONGCANJIAWEI_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("UseItem")
			Set_XSCRIPT_ScriptID( 890054 )
			Set_XSCRIPT_Parameter( 0, g_FrameVar[1] ); 
			Set_XSCRIPT_ParamCount( 1 ); 
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.GONGCANJIAWEI_CONFIRMSUBMIT then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnSubmit")
			Set_XSCRIPT_ScriptID( 890046 )
			Set_XSCRIPT_Parameter( 0, g_FrameVar[1] ); 
			Set_XSCRIPT_Parameter( 1, 1 ); 
			Set_XSCRIPT_ParamCount( 2 ); 
		Send_XSCRIPT()	
	elseif g_FrameInfo == FrameInfoList.LINGYU_WASH_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888808)
			Set_XSCRIPT_Function_Name("LingYu_Wash")
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, g_FrameVar[3])
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.LINGYU_SWITCH_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888808)
			Set_XSCRIPT_Function_Name("LingYu_Switch")
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.LINGYU_MAKE_CONFIRM then
		LuaFnComposeLingYu(g_FrameVar[1], g_FrameVar[2], 0)
	elseif g_FrameInfo == FrameInfoList.LINGYU_COMPOUND_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888808)
			Set_XSCRIPT_Function_Name("LingYuWashItemCompound")
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, g_FrameVar[3])
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.LINGYU_TRANSITION_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888808)
			Set_XSCRIPT_Function_Name("LingYuTransition")
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, g_FrameVar[3])
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.LINGYU_RECYCLE_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888808)
			Set_XSCRIPT_Function_Name("LingYuRecycle")
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.LINGYU_UNBIND_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888808)
			Set_XSCRIPT_Function_Name("LingYuUnbind")
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.FASHION_LOTTERY_SIGNUP_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888811)
			Set_XSCRIPT_Function_Name("FashionLotterySignUp")
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.BWZQ_SPONSOR_VOTE_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(792107)
			Set_XSCRIPT_Function_Name("OnVote")
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.BWZQ_GOTOBHGAREA_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GotoBHGSure" )
			Set_XSCRIPT_ScriptID( 792108 )
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.MARRY_PLANE_NOTICE then
		AutoRuntoTargetExWithName(177, 94, 0, "HÖ Lai LÕc")
	elseif g_FrameInfo == FrameInfoList.FANCHANG_SHOP_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "BuyItem" )
			Set_XSCRIPT_ScriptID( 998387 )
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()	
	elseif g_FrameInfo == FrameInfoList.QIXITOPLIST_CONFIRM then	
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SeventhFestivalDoDuiHuan");
			Set_XSCRIPT_ScriptID(891396);
			Set_XSCRIPT_Parameter(0, g_FrameVar[1]);
			Set_XSCRIPT_Parameter(1, 0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT(); 
	elseif g_FrameInfo == FrameInfoList.REPUTATIONSHOP_BUY_CONFIRM then			
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ReputationShopBuyItem")
			Set_XSCRIPT_ScriptID(998585)
			Set_XSCRIPT_Parameter( 0, g_FrameVar[1] )
			Set_XSCRIPT_Parameter( 1, g_FrameVar[2] )
			Set_XSCRIPT_Parameter( 2, g_FrameVar[3] )
			Set_XSCRIPT_Parameter( 3, g_FrameVar[4] )
			Set_XSCRIPT_Parameter( 4, 0 )
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.DAHUA_DAIBI_CONFIRM then			
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("BuyDaiBi")
			Set_XSCRIPT_ScriptID(889909)
			Set_XSCRIPT_Parameter( 0, g_FrameVar[1] )
			Set_XSCRIPT_Parameter( 1, 1 ) 
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.DAHUA_DAIBI_SHOP_CONFIRM then			
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("BuyItem")
			Set_XSCRIPT_ScriptID(889910)
			Set_XSCRIPT_Parameter( 0, g_FrameVar[1] )
			Set_XSCRIPT_Parameter( 1, 1 ) 
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.QINGRENJIETOPLIST_CONFIRM then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("QingRenJieDoDuiHuan");
			Set_XSCRIPT_ScriptID(892974);
			Set_XSCRIPT_Parameter(0, g_FrameVar[1]);
			Set_XSCRIPT_Parameter(1, 0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif g_FrameInfo == FrameInfoList.QRJTOPLIST_EXCHANGE_CONFIRM then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name( "Qingrenjie_Exchange" )
			Set_XSCRIPT_ScriptID( 892974 )
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, 0)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();
	elseif g_FrameInfo == FrameInfoList.SECKILL_TESE then		 
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenTeQuan")
		Set_XSCRIPT_ScriptID(891062)
		Set_XSCRIPT_Parameter(0,g_FrameVar[1]);  --open
		Set_XSCRIPT_Parameter(1,1);  --open
		Set_XSCRIPT_ParamCount(2)
    	Send_XSCRIPT()	
	elseif g_FrameInfo == FrameInfoList.PETTAYIN_CONFIRM then
		if g_FrameVar[1] == 1 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("OnGainPetExterior")
				Set_XSCRIPT_ScriptID(998478)
				Set_XSCRIPT_Parameter(0, g_FrameVar[2])
				Set_XSCRIPT_Parameter(1, g_FrameVar[3])
				Set_XSCRIPT_Parameter(2, g_FrameVar[4])
				Set_XSCRIPT_Parameter(3, g_FrameVar[5])
				Set_XSCRIPT_Parameter(4, 0)
				Set_XSCRIPT_ParamCount(5)
			Send_XSCRIPT();
		elseif g_FrameVar[1] == 2 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("OnDeletePetExterior")
				Set_XSCRIPT_ScriptID(998478)
				Set_XSCRIPT_Parameter(0, g_FrameVar[2])
				Set_XSCRIPT_Parameter(1, 0)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT();
		else
			-- error
		end
	elseif g_FrameInfo == FrameInfoList.YULONGZAITIAN_CONFIRM then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnUIClickCallBack")
		Set_XSCRIPT_ScriptID(998540)
		Set_XSCRIPT_Parameter(0, g_FrameVar[1])
		Set_XSCRIPT_Parameter(1, g_FrameVar[2])
		Set_XSCRIPT_Parameter(2, 1)

		Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT();
	elseif g_FrameInfo == FrameInfoList.EQUIP_REFRESH_EQUIP_CHANGE_CONFIRM then
		DataPool:LuaFnEquipRefreshEquipChangeConfirmed(g_FrameVar[1], g_FrameVar[2])
	elseif g_FrameInfo == FrameInfoList.EQUIP_REFRESH_CLOSE_CONFIRM then
		DataPool:LuaFnEquipRefreshCloseConfirmed()
	elseif g_FrameInfo == FrameInfoList.EQUIP_REFRESH_BIND_CONFIRM then
		DataPool:LuaFnEquipRefreshBindConfirmed()
	elseif g_FrameInfo == FrameInfoList.CONFIRM_DWJINJIE then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoDiaowenJinJie")
			Set_XSCRIPT_ScriptID(809272)
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, g_FrameVar[3])
			Set_XSCRIPT_Parameter(3, 1)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.CONFIRM_DWJINJIESHENGJI then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoDiaowenJinJieShengJi")
			Set_XSCRIPT_ScriptID(809272)
			Set_XSCRIPT_Parameter(0, g_FrameVar[2])
			Set_XSCRIPT_Parameter(1, g_FrameVar[3])
			Set_XSCRIPT_Parameter(2, 1)
			Set_XSCRIPT_Parameter(3, g_FrameVar[4])
			Set_XSCRIPT_Parameter(4, g_FrameVar[8])
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.CONFIRM_DWJINJIEHUITUI then
		-- Clear_XSCRIPT()
		-- 	Set_XSCRIPT_Function_Name("DoDiaowenJinJieHuiTui")
		-- 	Set_XSCRIPT_ScriptID(809272)
		-- 	Set_XSCRIPT_Parameter(0, g_FrameVar[1])
		-- 	Set_XSCRIPT_Parameter(1, g_FrameVar[2])
		-- 	Set_XSCRIPT_Parameter(2, 1)
		-- 	Set_XSCRIPT_ParamCount(3)
		-- Send_XSCRIPT()
		PushEvent("DWJINJIEHUITUI_CONFIRMED")
	elseif g_FrameInfo == FrameInfoList.CONFIRM_ORNAMENTS_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UnlockOrnaments" )
			Set_XSCRIPT_ScriptID( 999361 )
			Set_XSCRIPT_Parameter(0, g_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_FrameVar[2])
			Set_XSCRIPT_Parameter(2, g_FrameVar[3])
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_ParamCount( 4 )
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.CONFIRM_QIXIPVE_LEAVE then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientAskLeave" )
		Set_XSCRIPT_ScriptID(051128)
		Set_XSCRIPT_Parameter(0, 1);	
		Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()	
	end
	this:Hide()

end
-- °´Å¥2 µã»÷ÊÂ¼þ
function WuhunQuest_Bn2Click()
	if (g_FrameInfo == FrameInfoList.CONFIRM_IMMIGRATION) then
		--ÒÆÃñÈ¡Ïû
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("SpouseImmigrationCallBack")
			Set_XSCRIPT_ScriptID(807012)
			Set_XSCRIPT_Parameter(0,g_FrameVar[2] )
			Set_XSCRIPT_Parameter(1,g_FrameVar[3] )
			Set_XSCRIPT_Parameter(2,0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_CANCEL_IMMIGRATION) then
		--ÒÆÃñÈ¡Ïû
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("SpuoseCancelImmg_confirm")
			Set_XSCRIPT_ScriptID(807012)
			Set_XSCRIPT_Parameter(0,g_FrameVar[2] )
			Set_XSCRIPT_Parameter(1,g_FrameVar[3] )
			Set_XSCRIPT_Parameter(2,0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_CANCEL_ODER_IMMIGRATION) then
		--ÒÆÃñÈ¡Ïû
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("SpuoseCancelImmg_confirm")
			Set_XSCRIPT_ScriptID(807014)
			Set_XSCRIPT_Parameter(0,g_FrameVar[2])
			Set_XSCRIPT_Parameter(1,g_FrameVar[3])
			Set_XSCRIPT_Parameter(2,0)
			Set_XSCRIPT_Parameter(3,g_FrameVar[4])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.DRESS_TRANSFER_BIND_CONFIRM then
		DressEnchasing:Lua_DressTransferBindConfirmed()
	--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ3 ÖØÐÂÌô ½È¡Ïû
	elseif g_FrameInfo == FrameInfoList.LILIANMISSION23_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ConfirmCancel")
			Set_XSCRIPT_ScriptID(893202)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.BWZQ_GOTOBHGAREA_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GotoBHGSure" )
			Set_XSCRIPT_ScriptID( 792108 )
			Set_XSCRIPT_Parameter(0, 0)
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
	this:Hide()
end

function WuhunQuest_Frame_OnHiden()
	if(IsWindowShow("AntiJDY")) then    --??????????,?????? for 69994
	else
		DataPool:SetCanUseHotKey(1);
	end
	WuhunQuest_Clear_Var()
end

function WuhunQuest_CleanUp()
	WuhunQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.500000,-118.000000}}" )
	WuhunQuest_Button2:Hide();
	WuhunQuest_Button1:Hide();
end

function WuhunQuest_Clear_Var()
	for i = 1,8 do
		g_FrameVar[i] = 0
	end
	g_FrameInfo = -1
end
-- event == "GAME_NOTIFY_INFO_OK"
function WuhunQuest_Open_Window_OK(str)
	WuhunQuest_Clear_Var()
	WuhunQuest_InfoWindow:SetText(str);
	WuhunQuestUpdateRect();
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557)");  --??
	WuhunQuest_Button2:Hide()
	DataPool:SetCanUseHotKey(0)
	this:Show();
end
-- event == "GAME_NOTIFY_INFO_CLOSE"
function WuhunQuest_Open_Window_CLOSE(str)
	WuhunQuest_Clear_Var()
	WuhunQuest_InfoWindow:SetText(arg0);
	WuhunQuestUpdateRect();
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_1173}");  --??
	WuhunQuest_Button2:Hide()
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_DarkSkill_confirm(nIndex,keepopen)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nIndex)
	g_FrameVar[2] = tonumber(keepopen)
	local strInfo = "#{CXYH_140813_4}"
	if keepopen == 0 then
		strInfo = "#{CXYH_140813_3}"
	elseif keepopen == 1 then
		strInfo = "#{CXYH_140813_4}"
	elseif  keepopen == 2 then
		strInfo = "#{CXYH_140813_2}"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.DARK_SKILL_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_Super_ATTR_confirm(nIndex,keepopen)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nIndex)
	g_FrameVar[2] = tonumber(keepopen)
	local strInfo = "#{CXYH_140813_31}"
	if keepopen == 0 then
		strInfo = "#{CXYH_140813_30}"
	elseif keepopen == 1 then
		strInfo = "#{CXYH_140813_31}"
	elseif  keepopen == 2 then
		strInfo = "#{CXYH_140813_29}"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.SUPER_ATTR_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_WuhunSkill_confirm(nIndex,keepopen)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nIndex)
	g_FrameVar[2] = tonumber(keepopen)
	local strInfo = "#{WHZN_141216_17}"
	-- PushDebugMessage(keepopen)
	if keepopen == 0 then --??
		strInfo = "#{WHZN_141216_5}"
	elseif keepopen == 1 then  --??
		strInfo = "#{WHZN_141216_17}"
	elseif  keepopen == 2 then  --????
		strInfo = "#{WHZN_141216_2}"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.WUHUN_SKILL_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_DeleteCoupleDiary_Confirm(realId)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(realId)
	local strInfo = "#{QLKJ_230331_57}"

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.DELETE_COUPLE_DIARY_CONFIRM
	this:Show();
end

-- event == "GAME_NOTIFY_INFO_YESNO"
function WuhunQuest_Open_Window_YESNO(str)
	WuhunQuest_Clear_Var()
	WuhunQuest_InfoWindow:SetText(arg0);
	WuhunQuestUpdateRect();
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	DataPool:SetCanUseHotKey(0)
	this:Show();
end
-- event == "YBMARKET_UP_ITEM_COMFIRM"
function WuhunQuest_Open_Window_YBM_UpItem(nIndex , nPrice)
	WuhunQuest_Clear_Var()
	g_FrameVar[1]  = tonumber(nIndex)
	g_FrameVar[2]  = tonumber(nPrice)
	local itemName = PlayerPackage:GetBagItemName(g_FrameVar[1])
--	local nNum 	= PlayerPackage:GetBagItemNum(g_FrameVar[1])
	local needMoney = Auction:GetNeedMoneyForSell(g_FrameVar[2])
--	local totalPrice = g_FrameVar[2] * nNum
--	local totalNeedMoney = needMoney * nNum
	WuhunQuest_InfoWindow:SetText( "#{YBSC_XML_65}"..itemName.."#{YBSC_XML_66}"..tostring(g_FrameVar[2]).."#{YBSC_XML_67}".."#{_EXCHG"..tostring(needMoney).."}".."#{YBSC_XML_68}");	-- ????
	g_FrameInfo = FrameInfoList.YBMARKET_UP_ITEM_COMFIRM ;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end
-- event == "YBMARKET_CONFIRM_MULTIBUY"
function WuhunQuest_Open_Window_YBM_MultiBuy(arg0, arg1, arg2, arg3)
	local msg = ScriptGlobal_Format( "#{SHPLGM_150428_27}", arg0, arg1, arg2, arg3)
	WuhunQuest_InfoWindow:SetText(msg)
	g_FrameInfo = FrameInfoList.YBMARKET_CONFIRM_MULTIBUY;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end
-- event == "YBMARKET_UP_PET_COMFIRM"
function WuhunQuest_Open_Window_YBM_UpPet(nIndex , nPrice)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nIndex)
	g_FrameVar[2] = tonumber(nPrice)
	local petName,szOn = Pet:GetPetList_Appoint(g_FrameVar[1]);
	local needMoney = Auction:GetNeedMoneyForSell(g_FrameVar[2])
	WuhunQuest_InfoWindow:SetText( "#{YBSC_XML_69}"..petName.."#{YBSC_XML_70}"..g_FrameVar[2].."#{YBSC_XML_71}".."#{_EXCHG"..tostring(needMoney).."}".."#{YBSC_XML_72}");	-- ????
	g_FrameInfo = FrameInfoList.YBMARKET_UP_PET_COMFIRM ;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end
-- event == "YBMARKET_BUY_COMFIRM"
function WuhunQuest_Open_Window_YBM_Buy(nType ,nIndex ,nPrice)
	g_FrameVar[1] = tonumber(nType)
	g_FrameVar[2] = tonumber(nIndex)
	g_FrameVar[3] = tonumber(nPrice)
	local unitName = ""
	if g_FrameVar[1] == 2 or g_FrameVar[1] == 3 then
		local pName , pSeller ,pCount ,pYB = Auction:GetItemAuctionInfo( g_FrameVar[2] )
		unitName =  pName
		WuhunQuest_InfoWindow:SetText( "#{YBSC_XML_73}"..tostring(pYB).."#{YBSC_XML_74}"..tostring(pCount).."#{YBSC_XML_79}"..unitName.."#{YBSC_XML_75}");	-- ????
	elseif g_FrameVar[1] == 1 then
		local pName , pSeller ,pYB = Auction:GetPetAuctionInfo( g_FrameVar[2] )
		unitName = pName
		WuhunQuest_InfoWindow:SetText( "#{YBSC_XML_73}"..g_FrameVar[3].."#{YBSC_XML_74}"..unitName.."#{YBSC_XML_75}");	-- ????
	end
	g_FrameInfo = FrameInfoList.YBMARKET_BUY_COMFIRM  ;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_WeeklyShopConfirm()
	g_FrameVar[1] = tonumber(arg0);	
	g_FrameVar[2] = tonumber(arg1);	
	g_FrameVar[3] = tonumber(arg2);	
	g_FrameVar[4] = tonumber(arg3);	   
	CancelLastOp(FrameInfoList.WEEKLYSHOP_BUYCONFIRM);
	g_FrameInfo = FrameInfoList.WEEKLYSHOP_BUYCONFIRM
	local item_name = DataPool:LuaFnGetItemNameByTableIndex(g_FrameVar[1])
	if g_FrameVar[4] == 1 then		
		local str = ScriptGlobal_Format("#{ZCSD_220802_07}", item_name, g_FrameVar[2])
		WuhunQuest_InfoWindow:SetText(str)
	else
		local str = ScriptGlobal_Format("#{ZCSD_220802_31}", item_name, g_FrameVar[2])
		WuhunQuest_InfoWindow:SetText(str)
	end
 
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZCSD_220802_08}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZCSD_220802_09}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
	
end
-- event == "YBMARKET_TAKE_BACK_COMFIRM"
function WuhunQuest_Open_Window_YBM_TakeBack(nType , nIndex)
	g_FrameVar[1] = tonumber(nType)
	g_FrameVar[2] = tonumber(nIndex)
	local pName = Auction:GetMySellBoxItemName(g_FrameVar[1] , g_FrameVar[2])
	WuhunQuest_InfoWindow:SetText( "#{YBSC_XML_76}"..pName.."#{YBSC_XML_77}");	-- ????
	g_FrameInfo = FrameInfoList.YBMARKET_TAKE_BACK_COMFIRM
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_QingQiuShopConfirm()
	g_FrameVar[1] = tonumber(arg0);	
	g_FrameVar[2] = tonumber(arg1);	
	g_FrameVar[3] = tonumber(arg2);	
	g_FrameVar[4] = tonumber(arg3);	
	g_FrameVar[5] = tonumber(arg4);	 
	CancelLastOp(FrameInfoList.QINGQIU_BUY_ITEM);
	g_FrameInfo = FrameInfoList.QINGQIU_BUY_ITEM
	local item_name = DataPool:LuaFnGetItemNameByTableIndex(g_FrameVar[1])
	if g_FrameVar[4] == 1 then		
		local str = ScriptGlobal_Format("#{QQSD_220801_6}", item_name, g_FrameVar[2])
		WuhunQuest_InfoWindow:SetText(str)
	else
		local str = ScriptGlobal_Format("#{QQSD_220801_30}", item_name, g_FrameVar[2])
		WuhunQuest_InfoWindow:SetText(str)
	end

	g_FrameInfo = FrameInfoList.QINGQIU_BUYCONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{QQSD_220801_7}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{QQSD_220801_8}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
	
end
 


function WuhunQuest_Open_Window_SellItemConfirm(nItemPos)
	g_FrameVar[1] = tonumber(nItemPos)
	WuhunQuest_InfoWindow:SetText("#{ZBBH_100505_1}");	-- ????
	g_FrameInfo = FrameInfoList.SELL_ITEM_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_Open_Window_SellItemConfirmQ8(nItemPos,equipQual,opType)
	local equipStar = equipQual

	local nNeedQueRen = DataPool:GetSellErciQueRen()
	if equipStar >= 7 and nNeedQueRen ~= 0 then
		local strMsg = "#{YZZBMD_220627_02}"
		if opType == 2 then
			strMsg = "#{YZZBMD_220627_01}"
		end
		g_FrameVar[1] = tonumber(nItemPos)
		WuhunQuest_InfoWindow:SetText(ScriptGlobal_Format(strMsg,equipStar));	-- ????
		g_FrameInfo = FrameInfoList.SELL_ITEM_CONFIRM;
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText("#{YZZBMD_220627_05}");  --??
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText("#{YZZBMD_220627_06}");  --??
		WuhunQuest_CheckClient:Show()
		WuhunQuest_CheckBtn:Show()
		WuhunQuest_CheckText:Show()
		WuhunQuest_CheckText:SetText("#{YZZBMD_240419_1}")
		WuhunQuest_CheckBtn:SetCheck(0)	
		WuhunQuestUpdateRect();
		DataPool:SetCanUseHotKey(0)
		this:Show();
	else
		--Èç¹û²»Îª8ÐÇÒÔÉÏ »¹ÊÇÖ±½ÓÂôÁË
		PlayerPackage:SellCurrItem( tonumber(nItemPos))
	end
end
function WuhunQuest_Open_Window_HuantongConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID )--add:lby2015??
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nType);
	g_FrameVar[2] = tonumber(nCurrencyUnit);
	g_FrameVar[3] = tonumber(nPrice);
	g_FrameVar[4] = tonumber(nItemIndex);
	g_FrameVar[5] = tonumber(nSerialNum);
	g_FrameVar[6] = nUniqueID;

	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.PET_HUANTONT_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_Open_Window_PetTaYinConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID )
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nType);
	g_FrameVar[2] = tonumber(nCurrencyUnit);
	g_FrameVar[3] = tonumber(nPrice);
	g_FrameVar[4] = tonumber(nItemIndex);
	g_FrameVar[5] = tonumber(nSerialNum);
	g_FrameVar[6] = nUniqueID;

	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.PETTAYIN_YBbuy_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_QuickUpPet_Confirm(nType,nCurData,nPrice,nUplimit,strMsg)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nType);

	local strText

	if nType == 1 then
		-- ÎòÐÔ
		strText = ScriptGlobal_Format("#{ZSKJT_130428_5}",strMsg,nCurData,nPrice)
	elseif nType == 2 then
		-- ÁéÐÔ
		strText = ScriptGlobal_Format("#{ZSKJT_130428_10}",strMsg,nCurData,nPrice);
	elseif nType == 3 then
		-- ÈÚºÏ¶È
		strText = ScriptGlobal_Format("#{ZSKJT_130428_17}",strMsg,nCurData,nPrice);
	elseif nType == 4 then
		-- ³É³¤ÂÊ
		strText = ScriptGlobal_Format("#{ZSKJT_130428_26}",strMsg,nCurData,nUplimit,nPrice);
	end

	g_FrameInfo = FrameInfoList.QUICKUP_PET_CONFIRM
	WuhunQuest_InfoWindow:SetText( strText );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_Open_Window_LingxingConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID )--add:lby2015??
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nType);
	g_FrameVar[2] = tonumber(nCurrencyUnit);
	g_FrameVar[3] = tonumber(nPrice);
	g_FrameVar[4] = tonumber(nItemIndex);
	g_FrameVar[5] = tonumber(nSerialNum);
	g_FrameVar[6] = nUniqueID;

	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.PET_LINGXING_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_Open_Window_ConvenintBuyConfirm( strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID, nScriptID, nBuyCount )
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nType);
	g_FrameVar[2] = tonumber(nCurrencyUnit);
	g_FrameVar[3] = tonumber(nPrice);
	g_FrameVar[4] = tonumber(nItemIndex);
	g_FrameVar[5] = tonumber(nSerialNum);
	g_FrameVar[6] = nUniqueID;
	g_FrameVar[7] = tonumber(nScriptID);
	g_FrameVar[8] = tonumber(nBuyCount);

	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.CONVENIENT_BUY_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_Open_Window_DakongConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID )
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nType);
	g_FrameVar[2] = tonumber(nCurrencyUnit);
	g_FrameVar[3] = tonumber(nPrice);
	g_FrameVar[4] = tonumber(nItemIndex);
	g_FrameVar[5] = tonumber(nSerialNum);
	g_FrameVar[6] = tonumber(nUniqueID);

	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.NEW_DAKONG_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_Open_Window_XiangqianConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID )
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nType);
	g_FrameVar[2] = tonumber(nCurrencyUnit);
	g_FrameVar[3] = tonumber(nPrice);
	g_FrameVar[4] = tonumber(nItemIndex);
	g_FrameVar[5] = tonumber(nSerialNum);
	g_FrameVar[6] = tonumber(nUniqueID);

	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.NEW_XIANGQIAN_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_Open_Window_ZhaichuConfirm(strMsg, nType, nCurrencyUnit, nPrice, nItemIndex, nSerialNum, nUniqueID )
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nType);
	g_FrameVar[2] = tonumber(nCurrencyUnit);
	g_FrameVar[3] = tonumber(nPrice);
	g_FrameVar[4] = tonumber(nItemIndex);
	g_FrameVar[5] = tonumber(nSerialNum);
	g_FrameVar[6] = tonumber(nUniqueID);

	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.NEW_ZHAICHU_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_BillingAward_Confirm( strText, nIndex )
	WuhunQuest_Clear_Var()
	g_FrameVar[1]  = tonumber(nIndex)

	WuhunQuest_InfoWindow:SetText( strText )
	WuhunQuestUpdateRect();
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LJSJ_160308_10}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LJSJ_160308_11}");  --??
	g_FrameInfo = FrameInfoList.BILLINGAWARD_CONFIRM
	this:Show();
end

function WuhunQuest_MaterialCompound_Confirm( strMsg, targetId, standardStuff  )
	WuhunQuest_Clear_Var()
	g_FrameVar[1]  = tonumber(targetId)
	g_FrameVar[2]  = tonumber(standardStuff)
	
	WuhunQuest_InfoWindow:SetText( strMsg )
	WuhunQuestUpdateRect();
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LJSJ_160308_10}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LJSJ_160308_11}");  --??
	g_FrameInfo = FrameInfoList.MATERIALCOMPOUND_CONFIRM
	this:Show();
end

function WuhunQuest_BWZQSponsor_Vote_Confirm( guid, sponsorname )
	WuhunQuest_Clear_Var()
	g_FrameVar[1]  = tonumber(guid)
	
	WuhunQuest_InfoWindow:SetText( ScriptGlobal_Format("#{BWZQ_20230329_111}",sponsorname) )
	WuhunQuestUpdateRect();
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LJSJ_160308_10}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LJSJ_160308_11}");  --??
	g_FrameInfo = FrameInfoList.BWZQ_SPONSOR_VOTE_CONFIRM
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_BWZQ_GotoBHGArea_Confirm()
	WuhunQuest_InfoWindow:SetText( "#{BWZQ_20230329_251}" )
	WuhunQuestUpdateRect();
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LJSJ_160308_10}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LJSJ_160308_11}");  --??
	g_FrameInfo = FrameInfoList.BWZQ_GOTOBHGAREA_CONFIRM
	DataPool:SetCanUseHotKey(0)
	this:Show();
end
function WuhunQuest_BWZQ_GotoBHGArea_WaitConfirm()
	WuhunQuest_InfoWindow:SetText( "#{BWZQ_20230329_339}" )
	WuhunQuestUpdateRect();
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{BWZQ_20230329_340}");
	WuhunQuest_Button2:Hide()

	g_FrameInfo = FrameInfoList.BWZQ_GOTOBHGAREA_WAITCONFIRM
	DataPool:SetCanUseHotKey(0)
	this:Show();
end


function WuhunQuest_SeckillGiveUp_confirm()
	WuhunQuest_Clear_Var()

	WuhunQuest_InfoWindow:SetText("#{FBSD_151123_07}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LS78_140819_55}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LS78_140819_56}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.SECKILL_GIVEUP_CONFIRM
	this:Show()
end

function WuhunQuest_DoubleSeckill_confirm(BossIndex, isYuanBao, needYuanBao, needItemID, needItemNum,isMoneySweep)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = BossIndex
	g_FrameVar[2] = isYuanBao
	g_FrameVar[3] = isMoneySweep

	local strInfo = ""
	if isYuanBao == 1 then
		strInfo = ScriptGlobal_Format("#{FMCS_180705_21}", needYuanBao )
	else
		strInfo = ScriptGlobal_Format("#{FBSD_201119_01}", needItemNum )
	end
	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LS78_140819_55}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LS78_140819_56}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.DOUBLE_SECKILL_CONFIRM
	this:Show()
end

function WuhunQuest_PetSoul_Exchange_confirm(nIdx, destPos,bagPos)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = destPos
	g_FrameVar[2] = bagPos

	if nIdx == 2 then
		WuhunQuest_InfoWindow:SetText("#{ZSPVP_211231_37}")
	elseif nIdx == 3 then
		WuhunQuest_InfoWindow:SetText("#{ZSPVP_211231_34}")
	end
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LS78_140819_55}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LS78_140819_56}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.PETSOUL_EXCHANGE_CONFIRM
	this:Show()
end

function WuhunQuest_PetSoul_Xishuxing_confirm(nIdx, bagPos)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = nIdx
	g_FrameVar[2] = bagPos
	if nIdx == 1 then
		WuhunQuest_InfoWindow:SetText("#{SHCX_20211229_04}")
	elseif nIdx == 2 then
		WuhunQuest_InfoWindow:SetText("#{SHCX_20211229_07}")
	elseif nIdx == 3 then
		WuhunQuest_InfoWindow:SetText("#{SHCX_20211229_08}")
	end
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{SHCX_20211229_05}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{SHCX_20211229_06}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.PETSOUL_XISHUXING_CONFIRM
	this:Show()
end

function WuhunQuest_PetSoul_Xishuxing_change_confirm(bagPos)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = bagPos
	
	WuhunQuest_InfoWindow:SetText("#{SHCX_20211229_49}")

	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{SHCX_20211229_05}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{SHCX_20211229_06}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.PETSOUL_XISHUXING_CHANGECONFIRM
	this:Show()
end


function WuhunQuest_WHWGGradeUp_confirm(nCurrentSelWG,strInfo)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = nCurrentSelWG

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LS78_140819_55}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LS78_140819_56}");  --??
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.WHWG_GRADEUP_CONFIRM
	this:Show()
end

function Apply_Snaking_Num_Second_Confirm()
	--WuhunQuest_Clear_Var()

	WuhunQuest_InfoWindow:SetText( "#{RCYH_180522_53}" );

	g_FrameInfo = FrameInfoList.APPLY_SNAKING_NUM_SECOND_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{RCYH_180522_54}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{RCYH_180522_55}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_DressPaintBind_confirm(nType,nDressPos,nParam)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = nType
	g_FrameVar[2] = nDressPos
	g_FrameVar[3] = nParam

	WuhunQuest_InfoWindow:SetText("#{YJRS_140613_19}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{SZRSYH_210315_04}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{SZRSYH_210315_05}");  --??
	WuhunQuestUpdateRect()
	g_FrameInfo = FrameInfoList.DRESSPAINT_BINDITEM_CONFIRM
	this:Show()
end

function WuhunQuest_XiaRiDaKa_confirm(targetId,curNum)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = targetId
	g_FrameVar[2] = curCount

	local std_GanZePai_Count = {1,2,3}
	local strTemp = ""
	if curNum >= std_GanZePai_Count[2] then
		--ÖÐµµ
		strTemp = ScriptGlobal_Format("#{SBP_210623_62}", curNum, std_GanZePai_Count[3])
	else
		--µÍµµ
		strTemp = ScriptGlobal_Format("#{SBP_210623_61}", curNum, std_GanZePai_Count[2], std_GanZePai_Count[3])	
	end

	WuhunQuest_InfoWindow:SetText(strTemp)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{SZRSYH_210315_04}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{SZRSYH_210315_05}");  --??
	WuhunQuestUpdateRect()
	g_FrameInfo = FrameInfoList.XIARIDAKA_CONFIRM
	this:Show()
end

function WuhunQuest_PetSoul_Fusion_ConfirmBind()
	WuhunQuest_Clear_Var()	

	WuhunQuest_InfoWindow:SetText("#{SHXT_20211230_215}")
	WuhunQuest_Button1:Show();
	WuhunQuest_Button2:Hide();
	WuhunQuest_Button1:SetText("#{SHXT_20211230_216}");
	WuhunQuestUpdateRect()
	g_FrameInfo = FrameInfoList.PETSOUL_FUSION_CONFIRMBIND
	this:Show()
end

function WuhunQuest_Dress_Transfer_Bind_Confirm()
	
	g_FrameInfo = FrameInfoList.DRESS_TRANSFER_BIND_CONFIRM
	
	WuhunQuest_InfoWindow:SetText("#{SZPSZY_160314_30}")
	WuhunQuest_Button1:Hide()
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_1173}")  --??
	WuhunQuestUpdateRect()
	this:Show()
end

--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ3 ÖØÐÂÌô ½È·ÈÏ
function WuhunQuest_LiLianMission23_Confirm()
	
	g_FrameInfo = FrameInfoList.LILIANMISSION23_CONFIRM
	
	WuhunQuest_InfoWindow:SetText("#{XZDZ_220428_123}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{XZDZ_220428_124}")  --????
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{XZDZ_220428_125}")  --????
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

--ÎäµÀ¶þ²ãÀúÁ·ÈÎÎñ ÈÎÎñ2 »¨·Ñ½ð±ÒÈ·ÈÏ
function WuhunQuest_LiLianMission2_Confirm()
	
	g_FrameInfo = FrameInfoList.LILIANMISSION2_CONFIRM
	
	WuhunQuest_InfoWindow:SetText("#{LLRW_230309_52}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LLRW_230309_53}")
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LLRW_230309_54}")
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

function WuhunQuest_Dress_Transfer_BuyItem_Confirm(nUniqueID, nNeedItemCount, nItemCount, nYB, nBuyType, nCurrencyUnit, nItemIndex, nSerialNum)
	
	g_FrameInfo = FrameInfoList.DRESS_TRANSFER_BUYITEM_CONFIRM
	g_FrameVar[1] = tonumber(nBuyType)
	g_FrameVar[2] = tonumber(nCurrencyUnit)
	g_FrameVar[3] = tonumber(nYB)
	g_FrameVar[4] = tonumber(nItemIndex)
	g_FrameVar[5] = tonumber(nSerialNum)
	g_FrameVar[6] = tonumber(nItemCount)
	g_FrameVar[7] = tonumber(nUniqueID)
	
	local strTemp = ScriptGlobal_Format("#{SZPSZY_160314_19}" ,tostring(nNeedItemCount),tostring(nNeedItemCount-nItemCount),tostring(nItemCount),tostring(nYB))

	WuhunQuest_InfoWindow:SetText(strTemp)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	this:Show()
end
function WuhunQuest_ConsumeSure_EquipDWLevelup(nBagPos, nLevelUpTo, requireJCS, UserjcsCnt, UserBYBCnt, UserYBCnt)
	
	g_FrameInfo = FrameInfoList.DW_CONSUMESURE_EQUIPDWLEVELUP
	g_FrameVar[1] = tonumber(nBagPos)
	g_FrameVar[2] = tonumber(nLevelUpTo)

	--°ó¶¨Ôª±¦
	if UserBYBCnt>0 and UserYBCnt==0 then
		--±¾´ÎµñÎÆÉý¼¶ÐèÒªÏûºÄA¸ö½ð²ÏË¿£¬Äú±³°üÖÐÏÖÓÐB¸öÎ´Ëø¶¨µÄ½ð²ÏË¿¡£µã»÷È·¶¨°´Å¥ºó£¬½«¿Û³ý±³°üÄÚÈ«²¿Î´Ëø¶¨µÄ½ð²ÏË¿ºÍC°ó¶¨Ôª±¦£¨ÓÃÀ´²¹×ãÊ£ÓàµÄ½ð²ÏË¿£©¡£µã»÷È¡ÏûÊ±£¬½«·ÅÆú±¾´ÎÉý¼¶¡£
		local tips = ScriptGlobal_Format("#{DWSJ_141202_37}",requireJCS,UserjcsCnt,UserBYBCnt,UserBYBCnt/35)
		WuhunQuest_InfoWindow:SetText(tips)
	--Ôª±¦
	elseif UserBYBCnt==0 and UserYBCnt>0 then
		--±¾´ÎµñÎÆÉý¼¶¹²ÐèA¸ö½ð²ÏË¿£¬Äú±³°üÖÐÓÐB¸öÎ´Ëø¶¨µÄ½ð²ÏË¿¡£µã»÷È·¶¨°´Å¥ºó£¬½«¿Û³ý±³°üÄÚÈ«²¿Î´Ëø¶¨µÄ½ð²ÏË¿ºÍCÔª±¦£¨µÈÍ¬ÓÚXX¸ö½ð²ÏË¿£©Íê³ÉÉý¼¶¡£µã»÷È¡ÏûÊ±£¬½«·ÅÆú±¾´ÎÉý¼¶²Ù×÷¡£
		local tips = ScriptGlobal_Format("#{DWSJ_141202_60}",requireJCS,UserjcsCnt,UserYBCnt,UserYBCnt/35)
		WuhunQuest_InfoWindow:SetText(tips)
	--°ó¶¨Ôª±¦+Ôª±¦
	else
		local tips = ScriptGlobal_Format("#{DWSJ_141202_38}",requireJCS,UserjcsCnt,UserBYBCnt,UserYBCnt,(UserBYBCnt+UserYBCnt)/35)
		WuhunQuest_InfoWindow:SetText(tips)
	end

	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	this:Show()
end
function WuhunQuest_DWLevelUp_BindSure_Confirm()
	WuhunQuest_Clear_Var()
	g_FrameInfo = FrameInfoList.DWLEVELUP_BINDCONFIRM
	WuhunQuest_InfoWindow:SetText( "#{DWSJ_141202_28}" )
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	this:Show()

end
function WuhunQuest_PetSoulLevelUp_Confirm()
	WuhunQuest_Clear_Var()
	WuhunQuest_InfoWindow:SetText( "#{SHXT_20211230_235}" )
	WuhunQuest_Button1:Show();
	WuhunQuest_Button2:Hide();
	WuhunQuest_Button1:SetText("#{SHXT_20211230_216}");
	WuhunQuestUpdateRect()
	g_FrameInfo = FrameInfoList.PETSOUL_LEVELUP_CONFIRM
	this:Show()
end

function WuhunQuest_PetSoul_BloodLevelUp_Confirm( szText )
	WuhunQuest_Clear_Var()
	WuhunQuest_InfoWindow:SetText( szText )
	WuhunQuest_Button1:Show();
	WuhunQuest_Button2:Hide();
	WuhunQuest_Button1:SetText("#{SHXT_20211230_216}");
	WuhunQuestUpdateRect()
	g_FrameInfo = FrameInfoList.PETSOUL_BLOODLEVELUP_CONFIRM
	this:Show()
end

function WuhunQuest_PetSoulBloodLevelUp_BindConfirm()
	WuhunQuest_Clear_Var()
	WuhunQuest_InfoWindow:SetText( "#{SHXT_20211230_234}" )
	WuhunQuest_Button1:Show();
	WuhunQuest_Button2:Hide();
	WuhunQuest_Button1:SetText("#{SHXT_20211230_216}");
	WuhunQuestUpdateRect()
	g_FrameInfo = FrameInfoList.PETSOUL_BLOODLEVELUP_BINDCONFIRM
	this:Show()
end

function WuhunQuest_PrizeWaiting()
	g_FrameInfo = FrameInfoList.PRIZE_WAITING
	WuhunQuest_InfoWindow:SetText( "#{LJSJ_160308_13}" )
	WuhunQuest_Button1:Hide()
	WuhunQuest_Button2:Hide()
	WuhunQuestUpdateRect()
			
	SetTimer("WuhunQuest", "WuhunQuest_ClosePrizeWaitingDownTick()", 10000)
end

function WuhunQuest_ClosePrizeWaitingDownTick()
	if g_FrameInfo == FrameInfoList.PRIZE_WAITING then
		KillTimer("WuhunQuest_ClosePrizeWaitingDownTick()");
		this:Hide();
	end
end

function WuhunQuest_LingYu_Wash_Confirm()
	
	g_FrameInfo = FrameInfoList.LINGYU_WASH_CONFIRM
	
	WuhunQuest_InfoWindow:SetText("#{SZXT_221216_130}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

function WuhunQuest_LingYu_Switch_Confirm()

	g_FrameInfo = FrameInfoList.LINGYU_SWITCH_CONFIRM
	
	WuhunQuest_InfoWindow:SetText("#{SZXT_221216_138}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

function WuhunQuest_LingYu_Make_Confirm()

	g_FrameInfo = FrameInfoList.LINGYU_MAKE_CONFIRM

	WuhunQuest_InfoWindow:SetText("#{SZXT_221216_99}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()

end

function WuhunQuest_LingYu_Compound_Confirm()

	g_FrameInfo = FrameInfoList.LINGYU_COMPOUND_CONFIRM

	WuhunQuest_InfoWindow:SetText("#{SZXT_221216_250}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()

end

function WuhunQuest_LingYu_Recycle_Confirm()
	g_FrameInfo = FrameInfoList.LINGYU_RECYCLE_CONFIRM

	WuhunQuest_InfoWindow:SetText("#{SZXT_221216_253}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

function WuhunQuest_LingYu_Transition_Confirm()
	g_FrameInfo = FrameInfoList.LINGYU_TRANSITION_CONFIRM

	WuhunQuest_InfoWindow:SetText("#{SZXT_230410_15}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

function WuhunQuest_LingYu_Unbind_Confirm()
	g_FrameInfo = FrameInfoList.LINGYU_UNBIND_CONFIRM

	WuhunQuest_InfoWindow:SetText("#{SZXT_230410_19}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

function WuhunQuest_Equip_Refresh_Equip_Change_Confirm()

	g_FrameInfo = FrameInfoList.EQUIP_REFRESH_EQUIP_CHANGE_CONFIRM
	
	if g_FrameVar[2] >= 0 then
		WuhunQuest_InfoWindow:SetText("#{SGCX_20231227_49}")
	else
		WuhunQuest_InfoWindow:SetText("#{SGCX_20231227_45}")
	end
	
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

function WuhunQuest_Equip_Refresh_Close_Confirm()

	g_FrameInfo = FrameInfoList.EQUIP_REFRESH_CLOSE_CONFIRM
	
	WuhunQuest_InfoWindow:SetText("#{SGCX_20231227_48}")
	
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

function WuhunQuest_Equip_Refresh_Bind_Confirm()
	g_FrameInfo = FrameInfoList.EQUIP_REFRESH_BIND_CONFIRM
	
	WuhunQuest_InfoWindow:SetText("#{SGCX_20231227_58}")
	
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()
end

function WuhunQuest_FashionLotterySignUp_Confirm()

	g_FrameInfo = FrameInfoList.FASHION_LOTTERY_SIGNUP_CONFIRM
	local strLotteryDateString = {"#{JLTJ_230320_35}", "#{JLTJ_230320_36}", "#{JLTJ_230320_37}", "#{JLTJ_230320_38}",	"#{JLTJ_230320_39}", "#{JLTJ_230320_40}", "#{JLTJ_230320_41}"}
	
	local lottery_index = g_FrameVar[2]
	if lottery_index >= 0 and lottery_index < 7 then
		local item_name = DataPool:LuaFnGetItemNameByTableIndex(g_FrameVar[4])
		local strTemp = ScriptGlobal_Format("#{JLTJ_230320_34}", tostring(g_FrameVar[3]), item_name, strLotteryDateString[lottery_index + 1])
		WuhunQuest_InfoWindow:SetText(strTemp)
	else
		WuhunQuest_InfoWindow:SetText("")
	end	
	
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--?? 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--??
	WuhunQuestUpdateRect()
	DataPool:SetCanUseHotKey(0)
	this:Show()

end

function WuhunQuest_YuLongZaiTian_Gift_Confirm()
	WuhunQuest_Clear_Var()
	g_FrameInfo = FrameInfoList.YULONGZAITIAN_CONFIRM
	g_FrameVar[1] = Get_XParam_INT(0)	--BagPos
	g_FrameVar[2] = Get_XParam_INT(1)	--SelectedIndex
	local strMsgForComfirm = Get_XParam_STR(0)
	
	WuhunQuest_InfoWindow:SetText(strMsgForComfirm);  -- ????	
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZYJX_211124_47}");  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZYJX_211124_48}");  --??
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end


function WuhunQuest_Check_Clicked(nIndex)

end

function WuhunQuest_Ornaments_Confirm(optype,bagIndex,tableIndex)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = bagIndex
	g_FrameVar[2] = tableIndex
	g_FrameVar[3] = optype

	local szname = DataPool:Lua_GetItemNameByIndex(tableIndex)
	local itemtype, idx, lifetime = OrnamentsScript:GetOrnamentsItemInfo(tableIndex)
	local szornamentsame = OrnamentsScript:GetOrnamentsInfo(itemtype, idx, "Name")
	WuhunQuest_InfoWindow:SetText( ScriptGlobal_Format("#{BGTS_220125_25}",szname,szornamentsame) )

	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{BGTS_220125_26}")  --??
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{BGTS_220125_27}")  --??
	WuhunQuestUpdateRect()
	g_FrameInfo = FrameInfoList.CONFIRM_ORNAMENTS_CONFIRM
	this:Show()
end 
