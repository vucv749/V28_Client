-- Ä¬ÈÏÑ¡Ôñ·½Ê½
local g_SelectType = -1

-- ÅÌ³ö·½Ê½
local SALETYPE_MONEY = 0
local SALETYPE_YUANBAO = 1

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_PS_PanChu_YuanBao_Frame_UnifiedXPosition
local g_PS_PanChu_YuanBao_Frame_UnifiedYPosition

-- npc¹Ø×¢
local objCared = -1
local MAX_OBJ_DISTANCE = 3.0

--===============================================
-- PreLoad()
--===============================================
function PS_PanChu_YuanBao_PreLoad()
	this:RegisterEvent("PLAYERSHOP_PANCHU_INPUT_OPEN")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("PLAYERSHOP_PANCHU_INPUT_CLOSE")
	this:RegisterEvent("PS_CLOSE_SHOP_MAG")
end

--===============================================
-- OnLoad()
--===============================================
function PS_PanChu_YuanBao_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_PS_PanChu_YuanBao_Frame_UnifiedXPosition	= PS_PanChu_YuanBao_Frame : GetProperty("UnifiedXPosition")
	g_PS_PanChu_YuanBao_Frame_UnifiedYPosition	= PS_PanChu_YuanBao_Frame : GetProperty("UnifiedYPosition")
end

--===============================================
-- OnEvent
--===============================================
function PS_PanChu_YuanBao_OnEvent(event)
	-- ´ò¿ª½çÃæ
	if(event == "PLAYERSHOP_PANCHU_INPUT_OPEN") then
		this:Show()			
		-- npc¹Ø×¢
		objCared = PlayerShop:GetNpcId()
		this:CareObject(objCared, 1, "PS_PanChu_YuanBao")
		-- ÉèÖÃ½çÃæ
		PS_PanChu_YuanBao_ChangeMode(SALETYPE_MONEY)--????????
	end
	
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		PS_PanChu_YuanBao_ResetPos()
	end
	
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	if (event == "VIEW_RESOLUTION_CHANGED") then
		PS_PanChu_YuanBao_ResetPos()
	end
	
	-- Àë¿ªnpc¹Ø± ½çÃæ
	if ( event == "OBJECT_CARED_EVENT" )   then
		if(tonumber(arg0) ~= objCared) then
			return
		end		
		-- Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			PS_PanChu_YuanBao_OnHiden()
		end	
	end
	
	-- ¹Ø± ½çÃæ
	if( event == "PLAYERSHOP_PANCHU_INPUT_CLOSE")	 then
		PS_PanChu_YuanBao_OnHiden()
	end
	
	-- ¹Ø± ½çÃæ
	if( event == "PS_CLOSE_SHOP_MAG")	 then
		PS_PanChu_YuanBao_OnHiden()
	end

end

--===============================================
-- Òþ²Ø
--===============================================
function PS_PanChu_YuanBao_OnHiden()
	--±äÁ¿ÖØÖÃ
	g_SelectType = -1
	--¿Ø¼þÇå¿ 
	PS_PanChu_YuanBao_Clear()
	--½çÃæÒþ²Ø
	this:Hide()
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "PS_PanChu_YuanBao")
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function PS_PanChu_YuanBao_ResetPos()
	PS_PanChu_YuanBao_Frame : SetProperty("UnifiedXPosition", g_PS_PanChu_YuanBao_Frame_UnifiedXPosition)
	PS_PanChu_YuanBao_Frame : SetProperty("UnifiedYPosition", g_PS_PanChu_YuanBao_Frame_UnifiedYPosition)
end

--===============================================
-- Çå¿ 
--===============================================
function PS_PanChu_YuanBao_Clear()
	--ÎÄ×ÖÄÚÈÝÇå¿ 
	PS_PanChu_YuanBao_Gold:SetText("")
	PS_PanChu_YuanBao_Silver:SetText("")
	PS_PanChu_YuanBao_CopperCoin:SetText("")
	PS_PanChu_YuanBao_InputYuanBao:SetText("")
	--¹â±êÄ¬ÈÏÎ»ÖÃ
	PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "False")
	PS_PanChu_YuanBao_Silver:SetProperty("DefaultEditBox", "False")	
	PS_PanChu_YuanBao_CopperCoin:SetProperty("DefaultEditBox", "False")
	PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "False")	
	--È·ÈÏ°´Å¥Ä¬ÈÏ½ûÓÃ
	PS_PanChu_YuanBao_Accept:Disable()	
end

--===============================================
-- È·¶¨
--===============================================
function PS_PanChu_YuanBao_Accept_Clicked()
	--²ÎÊý¼ì²â
	if g_SelectType ~= SALETYPE_MONEY and g_SelectType ~= SALETYPE_YUANBAO then
		return
	end

	--½ð±ÒÅÌ³ö
	if g_SelectType == SALETYPE_MONEY then
		local szGold = PS_PanChu_YuanBao_Gold:GetText()
		local szSilver = PS_PanChu_YuanBao_Silver:GetText()
		local szCopperCoin = PS_PanChu_YuanBao_CopperCoin:GetText()
		--ÔÚ³ÌÐòÀïÍ·ÔÙ¼ì²âÊäÈë×Ö·ûµÄÓÐÐ§ÐÔºÍÊýÖµ
		local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin)		
		--Ê²Ã´Çé¿öÏÂÊ§°ÜÐèÒªÔÙ¶¨
		if(bAvailability == true) then
			--ÊäÈë²»ºÏ·¨
			if (tonumber(nMoney) < 1) then
				PS_PanChu_YuanBao_Gold:SetText("")
				PS_PanChu_YuanBao_Silver:SetText("")
				PS_PanChu_YuanBao_CopperCoin:SetText("")
				PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "True")
				PushDebugMessage("Giá sang ti®m Thß½ng ðiªm không ðßþc th¤p h½n 1 ð°ng")
				return
			elseif (tonumber(nMoney) > 100000000) then
				PS_PanChu_YuanBao_Gold:SetText("")
				PS_PanChu_YuanBao_Silver:SetText("")
				PS_PanChu_YuanBao_CopperCoin:SetText("")
				PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "True")
				PushDebugMessage("Bàn Xu¤t cØa hàng giá cä không th¬ vßþt qua 10000Kim, Thïnh mµt l¥n næa ðßa vào")
				return
			end
			--È·ÈÏÅÌ³ö
			PlayerShop:Transfer("info", "sale", nMoney, g_SelectType)
			--¹Ø± ½çÃæ
			PS_PanChu_YuanBao_OnHiden()
		end
	elseif g_SelectType == SALETYPE_YUANBAO then
		local szYuanbao = PS_PanChu_YuanBao_InputYuanBao:GetText()
		--ÊäÈë²»ºÏ·¨
		if (tonumber(szYuanbao) < 1) then
			PS_PanChu_YuanBao_InputYuanBao:SetText("")
			PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True")		
			PushDebugMessage("Giá sang ti®m Thß½ng ðiªm không ðßþc th¤p h½n 1 Kim Nguyên Bäo")
			return
		elseif (tonumber(szYuanbao) > 100000) then
			PS_PanChu_YuanBao_InputYuanBao:SetText("")
			PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True")		
			PushDebugMessage("Bàn Xu¤t cØa hàng giá cä không th¬ vßþt qua 100000nguyên bäo, Thïnh mµt l¥n næa ðßa vào")
			return
		end
		--È·ÈÏÅÌ³ö
		PlayerShop:Transfer("info", "sale", tonumber(szYuanbao), g_SelectType)
		--¹Ø± ½çÃæ
		PS_PanChu_YuanBao_OnHiden()		
	end
end

--===============================================
-- È¡Ïû
--===============================================
function PS_PanChu_YuanBao_Cancel_Clicked()
	PS_PanChu_YuanBao_OnHiden();
end

--===============================================
-- ÊäÈë¸Ä±ä
--===============================================
function PS_PanChu_YuanBao_ChangeMoney()	
	--½ð±ÒÅÌ³ö
	if g_SelectType == SALETYPE_MONEY then
		local szGold = PS_PanChu_YuanBao_Gold:GetText()
		local szSilver = PS_PanChu_YuanBao_Silver:GetText()
		local szCopperCoin = PS_PanChu_YuanBao_CopperCoin:GetText()		
		if szGold == "" and szSilver == "" and szCopperCoin == "" then
			PS_PanChu_YuanBao_Accept:Disable()
		else
			PS_PanChu_YuanBao_Accept:Enable()
		end
	--Ôª±¦ÅÌ³ö
	elseif g_SelectType == SALETYPE_YUANBAO then
		local szYuanbao = PS_PanChu_YuanBao_InputYuanBao:GetText()	
		if szYuanbao == "" then
			PS_PanChu_YuanBao_Accept:Disable()
		else
			PS_PanChu_YuanBao_Accept:Enable()
		end
	end
end

--===============================================
-- Ñ¡Ïî¸Ä±ä
--===============================================
function PS_PanChu_YuanBao_ChangeMode(type)
	--²ÎÊý¼ì²â
	if type ~= SALETYPE_MONEY and type ~= SALETYPE_YUANBAO then
		return
	end
	
	--Ä£Ê½ÉèÖÃ
	if g_SelectType == type then
		return
	end
	g_SelectType = type
	
	--¿Ø¼þÇå¿ 
	PS_PanChu_YuanBao_Clear()
		
	--×´Ì¬ÐÞ¸Ä
	if g_SelectType == SALETYPE_MONEY then
		--µ¥Ñ¡°´Å¥
		PS_PanChu_YuanBao_YuanBao:SetCheck(0)
		PS_PanChu_YuanBao_Money:SetCheck(1)

		PS_PanChu_YuanBao_Gold:SetText("")
		PS_PanChu_YuanBao_Silver:SetText("")
		PS_PanChu_YuanBao_CopperCoin:SetText("")
		PS_PanChu_YuanBao_InputYuanBao:SetText("")
		--¹â±êÄ¬ÈÏÎ»ÖÃ
		PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "True")		
	elseif g_SelectType == SALETYPE_YUANBAO then
		--µ¥Ñ¡°´Å¥
		PS_PanChu_YuanBao_Money:SetCheck(0)
		PS_PanChu_YuanBao_YuanBao:SetCheck(1)

		PS_PanChu_YuanBao_Gold:SetText("")
		PS_PanChu_YuanBao_Silver:SetText("")
		PS_PanChu_YuanBao_CopperCoin:SetText("")
		PS_PanChu_YuanBao_InputYuanBao:SetText("")
		--¹â±êÄ¬ÈÏÎ»ÖÃ
		PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True")
	end
end
