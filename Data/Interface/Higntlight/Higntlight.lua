-- UI_COMMAND_INDEX ÔÝ¶¨22122701
--²ÎÊý
local g_Higntlight_Frame_UnifiedPosition;
local g_TotalMVPCount = 0;		--MVP??  ?????? ???? ???? ??????3???getdata ??ui???3?? TODO:?????????
local g_TreatmentIndex = 0;		--???????? ????? UI????????,?? ???? ??MVP?MVP????? 0???????MVP  ??UI??2 
local g_DamageIndex_1 =0;		--?????????MVP?????? ????UpdateUI ??UI??1
local g_DamageIndex_2 =0;		--??UI??3

local g_MVPType_Damage = 1; --????
local g_MVPType_Treatment = 2; --????

local isTOOLTIP = 0;--1???????????? ????????? ?????

local g_TotalMVPTable =
{	--????? ???? 2?? 1??
	--½ÇÉ«GUID	½ÇÉ«Ãû×Ö	½ÇÉ«ÃÅÅÉ	½ÇÉ«MVPÀàÐÍ(ÓÃÀ´ÅÐ¶ÏÊÇ·ñÓÐÐ§)		½ÇÉ«µÄ ¼±È
	--ÓÖ¸Ä³ÉÖ»ÓÐÁ½¸öMVPÁË  âÀïÃæ ÓÐÒ»¸öÓÃ²»ÉÏÁË		
	[1]	={guid = 0,name = 0, menpai = 0, MVPType = 0, MVPRate = 0},
	[2]	={guid = 0,name = 0, menpai = 0, MVPType = 0, MVPRate = 0},
	[3]	={guid = 0,name = 0, menpai = 0, MVPType = 0, MVPRate = 0},
};

--µãÔÞ â¿éµ¥¶À ª³öÀ´
local g_ZanTable =
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
};

--[[ local g_ZanRandTitle_Treatment =
{
	[1]="#{GGSK_221221_22}",
	[2]="#{GGSK_221221_23}",
	[3]="#{GGSK_221221_24}",
	[4]="#{GGSK_221221_25}",
	[5]="#{GGSK_221221_55}",
	[6]="#{GGSK_221221_56}",
	[7]="#{GGSK_221221_57}",
} ]]

local g_ZanRandTitle_Damage =
{
	[1]="#{GGSK_221221_19}",
	[2]="#{GGSK_221221_20}",
	[3]="#{GGSK_221221_21}",
	[4]="#{GGSK_221221_52}",
	[5]="#{GGSK_221221_53}",
	[6]="#{GGSK_221221_54}",
}
local g_IsZan =  --???? ????????????? 0??????????MVP???????
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
}

--UI±í
local g_UI_menpai={};--item1????
--local g_UI_menpai2={};--item2µÄÃÅÅÉ±í
--local g_UI_menpai3={};--item3µÄÃÅÅÉ±í
local g_UI_charName={};--????
local g_UI_rate={};--??
local g_UI_title={};--?? ??DPS?????? ?????
local g_UI_likesDetail={};--????

function Higntlight_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	--´ò¿ª¸ß¹âÊ±¿Ì½áËã½çÃæ
	this:RegisterEvent("SHOW_HIGHLIGHT_MVP");
	--³¡¾°ÇÐ»»
	this:RegisterEvent("ON_SCENE_TRANS");
	--Íæ¼ÒÀë¿ªÊÀ½ç
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--³¬Á´
	--this:RegisterEvent("HIGHLIGHT_MVP_TOOLTIP");--»á´«Èë ½ÇÉ«Ãû×Ö ÃÅÅÉ mvpÀàÐÍ mvp ¼±È
	--Ìí¼ÓºÃÓÑ³É¹¦
	this:RegisterEvent("HIGHLIGHT_ADDFRIEND_OK"); 
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Higntlight_OnLoad()
	this:Hide();
    g_Higntlight_Frame_UnifiedPosition = Higntlight_Frame:GetProperty("UnifiedPosition");

	--Higntlight_InitMenPaiTable()
	g_UI_menpai[1] = Higntlight_ImageMenpai
	g_UI_menpai[2] = Higntlight_ImageMenpai
	g_UI_menpai[3] = Higntlight_ImageMenpai3

	g_UI_charName[1] = Higntlight_RoleName_Text2;
	g_UI_charName[2] = Higntlight_RoleName_Text2;--Higntlight_RoleName2_Text2;
	g_UI_charName[3] = Higntlight_RoleName3_Text2;

	g_UI_rate[1] = Higntlight_DamageCount_Text2;
	g_UI_rate[2] = Higntlight_DamageCount_Text2;--Higntlight_TreatmentPercent2_Text2;	--?? ?UI????????item?? ??????
	g_UI_rate[3] = Higntlight_DamageCount3_Text2;

	g_UI_title[1] = Higntlight_Title;
	g_UI_title[2] = Higntlight_Title;--Higntlight_Title2;
	g_UI_title[3] = Higntlight_Title3;

	--×ÊÔ´ÄÇ±ß °Ñ item1¡¢3µÄÖÎÁÆ°Ù·Ö±ÈÉ¾³ý£¬item2µÄÉËº¦°Ù·Ö±ÈÉ¾³ýÁË
	--Higntlight_TreatmentPercent:Hide();
	--Higntlight_DamageCount2:Hide(); --ÖÎÁÆ ÔÚUIÖÐ¹Ì¶¨·ÅÔÚµÚ¶þ¸öitemÄÇÀï  âÀïÌØÊâ´¦Àí µÚ¶þ¸öitemµÄÉËº¦×Ö¶Î
	--Higntlight_TreatmentPercent3:Hide();
	--this:Show();

	g_UI_likesDetail[1] = Higntlight_LikesDetail_PAOPAO;
	g_UI_likesDetail[2] = Higntlight_LikesDetail_PAOPAO--?item1????? Higntlight_LikesDetail_PAOPAO2;
	g_UI_likesDetail[3] = Higntlight_LikesDetail_PAOPAO3;
	g_UI_likesDetail[1]:SetText(" ");--??????
	g_UI_likesDetail[2]:SetText(" ");
	g_UI_likesDetail[3]:SetText(" ");

	isTOOLTIP=0;

	g_IsZan[1] = 0;
	g_IsZan[2] = 0;
	g_IsZan[3] = 0;

	--ÖÎÁÆµÄ×é¼þÏÈÒþ²Ø
	--Higntlight_Treatment:Hide() -- ÖÎÁÆ ±êÌâ
	--Higntlight_Item2:Hide() --ÓÒÉÏ½Ç ÖÎÁÆ item
end


function Higntlight_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 22122701) then
        --·þÎñÆ÷¶Ëµ÷ÓÃ  âÀï»ñµÃ²ÎÊý²¢´¦Àí
		local t_index = Get_XParam_INT(0);
		local t_name = Get_XParam_STR(0);--?????????????
		g_ZanTable[t_index] = g_ZanTable[t_index]+1;--?????
		--ÅÐ¶Ï±»µãÔÞµÄÊÇ·ñÊÇ×Ô¼º
		local targetGUID
		if t_index == 1 then
			targetGUID = g_TotalMVPTable[g_DamageIndex_1].guid
		elseif t_index == 3 then
			targetGUID = g_TotalMVPTable[g_DamageIndex_2].guid
		end
		if targetGUID ~= 0 and targetGUID == Player:GetGUID() then --????? ? ?
			local rtxt = ScriptGlobal_Format("#{GGSK_221221_64}", tostring(t_name))
			PushDebugMessage(rtxt);
		end
	elseif (event == "SHOW_HIGHLIGHT_MVP") then
		this:Hide();
		--»ñÈ¡Êý¾Ý ´ò¿ª½çÃæ
		Higntlight_GetData();
		Higntlight_UpdateUI();
		this:Show();
		SetTimer("Higntlight", "Higntlight_ZanTimer()", 2000);--???? ?????2?????
		isTOOLTIP = 0;--????????? ?? ?0
		--¸ ÏÔÊ¾½çÃæ ¿Ï¶¨ÊÇÃ»ÓÐÈË°´¹ýµãÔÞµÄ
		g_IsZan[1] = 0;
		g_IsZan[2] = 0;
		g_IsZan[3] = 0;
	elseif event == "ON_SCENE_TRANS" then
		--³¡¾°ÇÐ»» Çå¿ 
		Higntlight_OnClose()
	elseif event == "PLAYER_LEAVE_WORLD" then
		--Íæ¼ÒÀë¿ªÊÀ½ç Çå¿ 
		Higntlight_OnClose()
	elseif (event == "HIGHLIGHT_ADDFRIEND_OK" ) then
		--Ìí¼ÓºÃÓÑ³É¹¦
		local friendName = tostring(arg0)
		if (this:IsVisible()) then
			Higntlight_AddFriendOK(friendName)
		end
	elseif (event == "ADJEST_UI_POS" ) then
        Higntlight_Frame_On_ResetPos();
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
        Higntlight_Frame_On_ResetPos();
	end	
end

--Ìí¼ÓºÃÓÑ°´Å¥	
function Higntlight_AddFriend1(index)
	--uiµÄindexÒª×ª»»³Émvp±íµÄindex
	local tempIndex = index --?????????
	if (index == 1) then
		index = g_DamageIndex_1
	--elseif (index == 2) then
		--index = g_TreatmentIndex
	elseif (index == 3) then
		index = g_DamageIndex_2
	end
	if (g_TotalMVPTable[index].guid == Player:GetGUID()) then  
		PushDebugMessage("#{GGSK_221221_49}");--????
		return;
	end
	if (g_TotalMVPTable[index].name == 0) then
		return;
	end
	--ÒÑÊÇºÃÓÑ ÔòÒþ²Ø
	if (Friend:IsPlayerIsFriendNotTemp(g_TotalMVPTable[index].name) == 1) then
		if tempIndex == 1 then
			Higntlight_AddFriend:Hide();
		--elseif tempIndex == 2 then
			--Higntlight_AddFriend2:Hide();
		elseif tempIndex == 3 then
			Higntlight_AddFriend3:Hide();
		end
		return
	end
	local strName = g_TotalMVPTable[index].name;
    DataPool:AddFriendAndGrouping(strName);
	--ÒÑ³É¹¦Ìí¼ÓºÃÓÑ ÔòÒþ²Ø
end
--µãÔÞ°´Å¥	
function Higntlight_Like(index)
	if (isTOOLTIP ~= 0) then
		return;
	end
	if (g_IsZan[index] == 1) then
		PushDebugMessage("#{GGSK_221221_07}");
		return;
	end
    HighLight:Lua_UpdateLikeCount(index,Player:GetName());
	g_IsZan[index] = 1;--1???????????? ????

	--µãÔÞ³É¹¦ ¸ø×Ô¼º·¢Ò»¸öÐÑÄ¿ÌáÊ¾ ¸øÄ³ÈËµãÔÞ
	local tipName
	if index == 1 then
		tipName = g_TotalMVPTable[g_DamageIndex_1].name
	elseif index == 3 then
		tipName = g_TotalMVPTable[g_DamageIndex_2].name
	end
	local rtxt = ScriptGlobal_Format("#{GGSK_221221_08}", tostring(tipName))
	PushDebugMessage(rtxt);

	--°´ÍêµãÔÞ ÖÃ»Ò¶ÔÓ¦°´Å¥
	if index == 1 then
		Higntlight_Like1:Disable();

	--elseif index == 2 then
		--Higntlight_Like2:Disable();
		
	elseif index == 3 then
		Higntlight_Like3:Disable();
		
	end
end
--·ÖÏí°´Å¥	
function Higntlight_Share(index)
	if (isTOOLTIP ~= 0) then
		return;
	end
    --uiµÄindexÒª×ª»»³Émvp±íµÄindex
	if (index == 1) then
		index = g_DamageIndex_1
	--elseif (index == 2) then
		--index = g_TreatmentIndex
	elseif (index == 3) then
		index = g_DamageIndex_2
	end

	--guid ½ÇÉ«Ãû×Ö ½ÇÉ«ÃÅÅÉ ½ÇÉ«MVPÀàÐÍ ½ÇÉ«MVP ¼±È
	HighLight:Lua_ShareHLMVP(g_TotalMVPTable[index].guid,
							g_TotalMVPTable[index].name,
							g_TotalMVPTable[index].menpai,
							g_TotalMVPTable[index].MVPType,
							g_TotalMVPTable[index].MVPRate)
end
--¹Ø± °´Å¥
function Higntlight_OnClose()
    this:Hide();
	KillTimer("Higntlight_ZanTimer()");
	--Íæ¼Ò²»ÄÜÊÖ¶¯´ò¿ª´Ë½çÃæ ËùÒÔÍæ¼ÒÊÖ¶¯¹Ø± Ö®ºó ¿Ï¶¨ÒªÇå¿ ±íÊý¾Ý
	Higntlight_ClearData();
	isTOOLTIP=0;
end
--»ñÈ¡MVPÊý¾Ý
function Higntlight_GetData()
	--Ö»Çå¿ lua±í ²»ÒªÇå¿ ¿Í»§¶ËÖÐµÄ±í
	Higntlight_ClearLocalData();
	for i = 1, 3, 1 do
		local mRet,mName,mGuid,mMenpai,mMVPType,mMVPRate = HighLight:Lua_GetHLMVPDataByIndex(i);
		--PushDebugMessage("test mRet:"..mRet);
		if mRet == 0 then
			return;
		end
		if (mMVPType == g_MVPType_Treatment) then
			g_TreatmentIndex = 0 --????? ???? ?? ???????0 ?g_TreatmentIndex?0? ??????????????item
			--g_TreatmentIndex = i;--¼ÇÂ¼ÖÎÁÆµÄÐòºÅ UpdateUIÊ± Ê¹ÓÃ
			--PushDebugMessage("test type:"..mMVPType);
		elseif (mMVPType == g_MVPType_Damage) then
			if (g_DamageIndex_1 == 0) then --???MVP ?? g_DamageIndex_1??????? ???g_DamageIndex_1 ??
				g_DamageIndex_1 = i;
			elseif (g_DamageIndex_1 ~= 0) then --???MVP ?? g_DamageIndex_1?????? ????g_DamageIndex_2???????MVP
				g_DamageIndex_2 = i;
			end
			--PushDebugMessage("test type:"..mMVPType);
		end
		g_TotalMVPTable[i].guid=mGuid;
		g_TotalMVPTable[i].name=mName;
		g_TotalMVPTable[i].menpai=mMenpai;
		g_TotalMVPTable[i].MVPType=mMVPType;
		g_TotalMVPTable[i].MVPRate=mMVPRate;
	end
end
--¸üÐÂ½çÃæ
function Higntlight_UpdateUI()
	--ÓÃ¼ÇÂ¼µÄ MVPË÷Òý À´Ë¢ÐÂUI
	--Higntlight_HideAllMenPaiTable()
	Higntlight_Like1:Enable()
	--Higntlight_Like2:Enable()
	Higntlight_Like3:Enable()
	--[[ --ÓÒÉÏ½Çitem
	if (g_TreatmentIndex ~= 0) then
		Higntlight_Item2:Show();
		g_UI_charName[2]:SetText(g_TotalMVPTable[g_TreatmentIndex].name);
		--g_UI_menpai[2]:SetText(Higntlight_GetMenPai(g_TotalMVPTable[g_TreatmentIndex].menpai));
		if g_TotalMVPTable[g_TreatmentIndex].menpai ~= 9 then
			g_UI_menpai2[g_TotalMVPTable[g_TreatmentIndex].menpai + 1]:Show()
		end
		g_UI_rate[2]:SetText(g_TotalMVPTable[g_TreatmentIndex].MVPRate);
		--²»Ëæ»úÁË ¹Ì¶¨ÏÔÊ¾
		g_UI_title[2]:SetText("#{GGSK_221221_22}");

		--ÊÇ±¾ÈË Ôò²»ÏÔÊ¾ Ìí¼Ó ºÍ µãÔÞ°´Å¥
		if (g_TotalMVPTable[g_TreatmentIndex].guid == Player:GetGUID()) then
			Higntlight_AddFriend2:Hide();
			Higntlight_Like2:Hide();
		else
			Higntlight_AddFriend2:Show();
			Higntlight_Like2:Show();
			--´ËMVPÒÑ¾­ÊÇºÃÓÑ ÔòÌí¼Ó°´Å¥Òþ²Ø
			if (Friend:IsPlayerIsFriendNotTemp(g_TotalMVPTable[g_TreatmentIndex].name) == 1) then
				Higntlight_AddFriend2:Hide();
			else
				Higntlight_AddFriend2:Show()
			end
		end

	else
		Higntlight_Item2:Hide();
	end ]]
	--ÉËº¦1
	if (g_DamageIndex_1 ~= 0) then
		Higntlight_Item:Show();
		g_UI_charName[1]:SetText(g_TotalMVPTable[g_DamageIndex_1].name);
		g_UI_menpai[1]:SetText(Higntlight_GetMenPai(g_TotalMVPTable[g_DamageIndex_1].menpai));
		--if g_TotalMVPTable[g_DamageIndex_1].menpai ~= 9 then
		--	g_UI_menpai[g_TotalMVPTable[g_DamageIndex_1].menpai + 1]:Show()
		--end
		g_UI_rate[1]:SetText(g_TotalMVPTable[g_DamageIndex_1].MVPRate);

		--²»Ëæ»úÁË ¹Ì¶¨ÏÔÊ¾
		g_UI_title[1]:SetText("#{GGSK_221221_18}");
		
		--ÊÇ±¾ÈË Ôò²»ÏÔÊ¾ Ìí¼Ó ºÍ µãÔÞ°´Å¥
		if (g_TotalMVPTable[g_DamageIndex_1].guid == Player:GetGUID()) then
			Higntlight_AddFriend:Hide();
			Higntlight_Like1:Hide();
		else
			Higntlight_AddFriend:Show();
			Higntlight_Like1:Show();
			--´ËMVPÒÑ¾­ÊÇºÃÓÑ ÔòÌí¼Ó°´Å¥Òþ²Ø
			if (Friend:IsPlayerIsFriendNotTemp(g_TotalMVPTable[g_DamageIndex_1].name) == 1) then
				Higntlight_AddFriend:Hide();
			else
				Higntlight_AddFriend:Show()
			end
		end

	else
		Higntlight_Item:Hide();
	end
	--ÉËº¦2
	if (g_DamageIndex_2 ~= 0) then
		Higntlight_Item3:Show();
		g_UI_charName[3]:SetText(g_TotalMVPTable[g_DamageIndex_2].name);
		g_UI_menpai[3]:SetText(Higntlight_GetMenPai(g_TotalMVPTable[g_DamageIndex_2].menpai));
		--if g_TotalMVPTable[g_DamageIndex_2].menpai ~= 9 then
		--	g_UI_menpai3[g_TotalMVPTable[g_DamageIndex_2].menpai + 1]:Show()
		--end
		g_UI_rate[3]:SetText(g_TotalMVPTable[g_DamageIndex_2].MVPRate);
		
		--²»Ëæ»úÁË ¹Ì¶¨ÏÔÊ¾
		g_UI_title[3]:SetText("#{GGSK_221221_18}");

		--ÊÇ±¾ÈË Ôò²»ÏÔÊ¾ Ìí¼Ó ºÍ µãÔÞ°´Å¥
		if (g_TotalMVPTable[g_DamageIndex_2].guid == Player:GetGUID()) then
			Higntlight_AddFriend3:Hide();
			Higntlight_Like3:Hide();
		else
			Higntlight_AddFriend3:Show();
			Higntlight_Like3:Show();
			--´ËMVPÒÑ¾­ÊÇºÃÓÑ ÔòÌí¼Ó°´Å¥Òþ²Ø
			if (Friend:IsPlayerIsFriendNotTemp(g_TotalMVPTable[g_DamageIndex_2].name) == 1) then
				Higntlight_AddFriend3:Hide();
			else
				Higntlight_AddFriend3:Show()
			end
		end

	else
		Higntlight_Item3:Hide();
	end
	
	this:Show();
end
--µãÔÞ¶¨Ê±Æ÷ ÔÚUI½çÃæ¿ªÆôÊ± ´ò¿ª´Ëtimer
function Higntlight_ZanTimer()
	for i = 1, 3, 1 do
		if i ~= 2 then
			--µãÔÞÊýÒÑ¾­Îª0 Ôò²»ÏÔÊ¾µãÔÞ±êÓï
			if (g_ZanTable[i] == 0) then
				g_UI_likesDetail[i]:SetText(" ");
			end
			--¶¨Ê±¸üÐÂµãÔÞ±êÓï
			if (g_ZanTable[i] > 0) then
				Higntlight_UpdateZan(i);
			end
			--¸üÐÂµãÔÞ±êÓïÖ®ºó µãÔÞÊý×Ô¼õ
			if (g_ZanTable[i] > 0) then
				g_ZanTable[i] = g_ZanTable[i] - 1;
			end
		end
	end
end

function Higntlight_UpdateZan(t_index)
	if (t_index == 1 or t_index == 3) then --????1 ??MVP??? g_DamageIndex_1
		local rand = math.random(0, 6);
		if (rand < 1 or rand > 6) then
			rand = 1; --?????? ???????
		end
		g_UI_likesDetail[t_index]:SetText(g_ZanRandTitle_Damage[rand]); --??????
	elseif (t_index == 2) then
		--[[ local rand = math.random(0, 7);
		if (rand < 1 or rand > 7) then
			rand = 1; --?????? ???????
		end
		g_UI_likesDetail[t_index]:SetText(g_ZanRandTitle_Treatment[rand]); --?????? ]]
	end
end

--Çå¿ lua½Å±¾ ÒÔ¼° ¿Í»§¶ËÖÐ MVP±í
function Higntlight_ClearData()
	g_TotalMVPCount = 0;
	g_TreatmentIndex = 0;
	g_DamageIndex_1 = 0;
	g_DamageIndex_2 = 0;
	for i = 1, 3, 1 do
		g_TotalMVPTable[i].guid=0;
		g_TotalMVPTable[i].name=0;
		g_TotalMVPTable[i].menpai=0;
		g_TotalMVPTable[i].MVPType=0;
		g_TotalMVPTable[i].MVPRate=0;
	end
	for j = 1, 3, 1 do
		g_ZanTable[j]=0;
	end

	HighLight:Lua_ClearHLMVPData();
end
--Çå¿ lua½Å±¾ÖÐMVP±í
function Higntlight_ClearLocalData()
	g_TotalMVPCount = 0;
	g_TreatmentIndex = 0;
	g_DamageIndex_1 = 0;
	g_DamageIndex_2 = 0;
	for i = 1, 3, 1 do
		g_TotalMVPTable[i].guid=0;
		g_TotalMVPTable[i].name=0;
		g_TotalMVPTable[i].menpai=0;
		g_TotalMVPTable[i].MVPType=0;
		g_TotalMVPTable[i].MVPRate=0;
	end
	for j = 1, 3, 1 do
		g_ZanTable[j]=0;
	end
end
--Òþ²ØËùÓÐitem
function Higntlight_HideAllItem()
	Higntlight_Item:Hide();
	--Higntlight_Item2:Hide();
	Higntlight_Item3:Hide();
end
--Ìí¼ÓºÃÓÑ³É¹¦ Òþ²ØÌí¼ÓºÃÓÑ°´Å¥
function Higntlight_AddFriendOK(name)
	--PushDebugMessage("Khoänh kh¡c n±i b§t - Khi hi¬n th¸: ðã thêm bÕn thành công, tên bÕn bè:"..name);
	--[[ if g_TreatmentIndex ~= 0 then --ÓÐÖÎÁÆmvp
		if g_TotalMVPTable[g_TreatmentIndex].name == name then
			Higntlight_AddFriend2:Hide()
			
		end
	end ]]
	if g_DamageIndex_1 ~= 0 then --???1mvp
		if g_TotalMVPTable[g_DamageIndex_1].name == name then
			Higntlight_AddFriend:Hide()
			
		end
	end
	if g_DamageIndex_2 ~= 0 then --???2mvp
		if g_TotalMVPTable[g_DamageIndex_2].name == name then
			Higntlight_AddFriend3:Hide()
			
		end
	end
end

--»ñÈ¡ÃÅÅÉÃû³Æ
function Higntlight_GetMenPai( menpai )
	local strName = "";
	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == menpai) then
		strName = "Thiªu Lâm";
	elseif(1 == menpai) then
		strName = "Minh Giáo";
	elseif(2 == menpai) then
		strName = "Cái Bang";
	elseif(3 == menpai) then
		strName = "Võ Ðang";
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
		strName = "MÕn Ðà S½n Trang";
	end
	return strName
end


--ÓÎÏ·´°¿Ú³ß´ç±ä»¯
--ÓÎÏ··Ö±æÂÊ±ä»¯
function Higntlight_Frame_On_ResetPos()
    Higntlight_Frame:SetProperty("UnifiedPosition", g_Higntlight_Frame_UnifiedPosition);
end
