-- UI_COMMAND_INDEX ÎŞ
--²ÎÊı
local g_Higntlight_Link_Frame_UnifiedPosition;
local g_MVPname;
local g_menpai;
local g_type;
local g_rate;
local g_MVPType_Damage = 1;--??MVP
local g_MVPType_Treatment =2;--??MVP



function Higntlight_Link_PreLoad()
	--this:RegisterEvent("UI_COMMAND");
	--³¡¾°ÇĞ»»
	this:RegisterEvent("ON_SCENE_TRANS");
	--Íæ¼ÒÀë¿ªÊÀ½ç
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--³¬Á´
	this:RegisterEvent("HIGHLIGHT_MVP_TOOLTIP");--??? ???? ?? mvp?? mvp??
	--Ìí¼ÓºÃÓÑ³É¹¦
	this:RegisterEvent("HIGHLIGHT_ADDFRIEND_OK"); 
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Higntlight_Link_OnLoad()
	this:Hide();
    g_Higntlight_Link_Frame_UnifiedPosition = Higntlight_Link_Frame:GetProperty("UnifiedPosition");
end

function Higntlight_Link_OnEvent(event)
	if event == "ON_SCENE_TRANS" then
		Higntlight_Link_OnClose()
	elseif event == "PLAYER_LEAVE_WORLD" then
		Higntlight_Link_OnClose()
	elseif event == "HIGHLIGHT_MVP_TOOLTIP" then
		--µã»÷³¬Á´¿ªÆôµÄ½çÃæ
		local name = tostring(arg0);
		local menpai = tonumber(arg1);
		local type = tonumber(arg2);
		local rate = tonumber(arg3);
		g_MVPname = name;
		g_menpai = menpai;
		g_type = type;
		g_rate = rate;
		Higntlight_Link_ShowHYPERLINK(name,menpai,type,rate);
	elseif (event == "HIGHLIGHT_ADDFRIEND_OK" ) then
		--Ìí¼ÓºÃÓÑ³É¹¦
		local friendName = tostring(arg0)
		if (this:IsVisible()) then
			Higntlight_Link_AddFriendOK(friendName)
		end
	elseif (event == "ADJEST_UI_POS" ) then
        Higntlight_Link_Frame_On_ResetPos();
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
        Higntlight_Link_Frame_On_ResetPos();
	end	
end

--Ìí¼ÓºÃÓÑ°´Å¥	
function Higntlight_Link_AddFriend1()
	if (g_MVPname == Player:GetName()) then  --?????????? ??? ??????? ??????guid ?????
		PushDebugMessage("#{GGSK_221221_49}");
		return;
	end
	--ÒÑ¾­ÊÇºÃÓÑÁË
	if (Friend:IsPlayerIsFriendNotTemp(g_MVPname) == 1) then
		Higntlight_Link_AddFriend:Hide()
		return;
	end
    DataPool:AddFriendAndGrouping(g_MVPname);
	--ÒÑ³É¹¦Ìí¼ÓºÃÓÑ ÔòÒş²Ø
end

--·ÖÏí×Ô¼º°´Å¥	
function Higntlight_Link_Share_Clicked()
	--guid ½ÇÉ«Ãû×Ö ½ÇÉ«ÃÅÅÉ ½ÇÉ«MVPÀàĞÍ ½ÇÉ«MVP ¼±È
	HighLight:Lua_ShareHLMVP(Player:GetGUID(),
							g_MVPname,
							g_menpai,
							g_type,
							g_rate)
end

--¹Ø± °´Å¥
function Higntlight_Link_OnClose()
    this:Hide();
end

--ÏÔÊ¾³¬Á´ĞÅÏ¢
function Higntlight_Link_ShowHYPERLINK(name,menpai,mvpType,mvpRate)
	this:Hide();
	if (mvpType == g_MVPType_Damage) then--??mvp??
		-- ÉèÖÃÃû×Ö ÃÅÅÉ  ¼±È ÒÔ¼° ×óÏÂ½Ç±êÓï
		--:SetText("#{GGSK_221221_18}");
		--Higntlight_Link_TreatmentPercent:Hide();--¹Ø± ÖÎÁÆ ¼±ÈÏÔÊ¾
		--Higntlight_Link_Title_Treatment:Hide();--¹Ø± ÖÎÁÆ±êÓï

		Higntlight_Link_DamageCount:Show();
		Higntlight_Link_DamageCount_Text2:SetText(mvpRate);

		Higntlight_Link_Title_Damage:Show();
		Higntlight_Link_ImageMenpai:SetText(Higntlight_Link_GetMenPai(menpai));--??
		Higntlight_Link_RoleName_Text2:SetText(name);
		
	end

	if (mvpType == g_MVPType_Treatment) then--??mvp??
		-- ÉèÖÃÃû×Ö ÃÅÅÉ  ¼±È ÒÔ¼° ×óÏÂ½Ç±êÓï
		--:SetText("#{GGSK_221221_22}");
		--Higntlight_Link_DamageCount:Hide();
		--Higntlight_Link_Title_Damage:Hide();

		--Higntlight_Link_TreatmentPercent:Show();
		--Higntlight_Link_TreatmentPercent_Text2:SetText(mvpRate);

		--Higntlight_Link_Title_Treatment:Show();
		--Higntlight_Link_ImageMenpai:SetText(Higntlight_Link_GetMenPai(menpai));--ÃÅÅÉ
		--Higntlight_Link_RoleName_Text2:SetText(name);
		--ÖÎÁÆ¾ÍÒş²Ø
		this:Hide()
		return	
	end
	--Ä¬ÈÏ¿ªÆô Ìí¼ÓºÃÓÑ ÒÔ¼° Òş²Ø ·ÖÏí°´Å¥
	Higntlight_Link_AddFriend:Show()
	Higntlight_Link_Share:Hide()
	--´ò¿ª½çÃæµÄÎª±¾ÈË Ôò Òş²ØÌí¼Ó°´Å¥ ÏÔÊ¾·ÖÏí°´Å¥
	if (name == Player:GetName()) then --?????????? ??? ??????? ??????guid ?????
		Higntlight_Link_AddFriend:Hide()
		--´ò¿ª·ÖÏí°´Å¥
		Higntlight_Link_Share:Show()
	else
		Higntlight_Link_Share:Hide()
		--ÒÑºÃÓÑ ÔòÒş²Ø
		if (Friend:IsPlayerIsFriendNotTemp(g_MVPname) == 1) then
			Higntlight_Link_AddFriend:Hide()
		end
	end

	
	this:Show();
end
--Ìí¼ÓºÃÓÑ³É¹¦ Òş²ØÌí¼ÓºÃÓÑ°´Å¥
function Higntlight_Link_AddFriendOK(name)
	--PushDebugMessage("¸ß¹âÊ±¿Ì ÏÔÊ¾Ê± Ìí¼ÓºÃÓÑ³É¹¦ ºÃÓÑÃû×Ö:"..name);
	if g_MVPname == name then
		Higntlight_Link_AddFriend:Hide()
		return
	end
end
--»ñÈ¡ÃÅÅÉÃû³Æ
function Higntlight_Link_GetMenPai( menpai )
	local strName = "";
	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == menpai) then
		strName = "Thiªu Lâm";
	elseif(1 == menpai) then
		strName = "Minh Giáo";
	elseif(2 == menpai) then
		strName = "Cái Bang";
	elseif(3 == menpai) then
		strName = "Võ Ğang";
	elseif(4 == menpai) then
		strName = "Nga Mi";
	elseif(5 == menpai) then
		strName = "Tinh Túc";
	elseif(6 == menpai) then
		strName = "Thiên Long";
	elseif(7 == menpai) then
		strName = "Thiên S½n";
	elseif(8 == menpai) then
		strName = "Tiêu dao";
	elseif(9 == menpai) then
		strName = "Tñ do";
	elseif(10== menpai) then
		strName = "MÕn Ğà S½n Trang";
	end
	return strName
end
--ÓÎÏ·´°¿Ú³ß´ç±ä»¯
--ÓÎÏ··Ö±æÂÊ±ä»¯
function Higntlight_Link_Frame_On_ResetPos()
    Higntlight_Link_Frame:SetProperty("UnifiedPosition", g_Higntlight_Link_Frame_UnifiedPosition);
end
