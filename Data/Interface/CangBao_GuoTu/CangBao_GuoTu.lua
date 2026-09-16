--******************************************
--◊È∂”≤ÿ±¶Õº∏±±æ «–ÕÊ∑®Ãÿ–ßΩÁ√Ê
--create by  limengyue 
--2024-08-12
--******************************************
local g_CangBao_GuoTu_Frame_UnifiedPosition;

--∂Øª≠ ±≥§ µ•Œª√Î
local g_CangBao_AnimationTime = 5


--=========================================================
--PreLoad
--=========================================================
function CangBao_GuoTu_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--æ‡¿ÎNPCæ‡¿Î
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--«–≥°æ∞ ¬º˛
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--=========================================================
--OnLoad
--=========================================================
function CangBao_GuoTu_OnLoad()
	g_CangBao_GuoTu_Frame_UnifiedPosition = CangBao_GuoTu:GetProperty("UnifiedPosition");
end

--=========================================================
--ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--=========================================================
function CangBao_GuoTu_On_ResetPos()

	CangBao_GuoTu:SetProperty("UnifiedPosition", g_CangBao_GuoTu_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function CangBao_GuoTu_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340330 ) then
		--¥Úø™ΩÁ√Ê
		if(IsWindowShow("CangBao_GuoTu")) then
			CloseWindow("CangBao_GuoTu", true)
		end
		CangBao_GuoTu_Open(Get_XParam_INT(0))
	end
	-- ¥∞ø⁄±‰ªØ
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_GuoTu_On_ResetPos();
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		CangBao_GuoTu_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       CangBao_GuoTu_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--¥Úø™ΩÁ√Ê
--=========================================================
function CangBao_GuoTu_Open(nType)
	if nType < 0 then
		--πÿ±†ΩÁ√Ê
		CangBao_GuoTu_Close()
	else
		--¥Úø™ΩÁ√Ê
		--PushDebugMessage("Chuy¨n sang giao diÆn hi¨n th∏")
		--≤•∑≈∂Øª≠
		CangBao_GuoTu_Eff:Show();
		--µπº∆ ±
		SetTimer("CangBao_GuoTu","CangBao_GuoTu_Close()", g_CangBao_AnimationTime*1000);		--?????5?????
		this:Show()
	end

end
--=========================================================
--πÿ±†ΩÁ√Ê
--=========================================================
function CangBao_GuoTu_Close()
	KillTimer("CangBao_GuoTu_Close()")
	this:Hide()
end
