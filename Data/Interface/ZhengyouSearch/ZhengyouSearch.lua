--  ÷ÓÑÆ½Ì¨: ²é Ò£¬ cuiyinjie 2008.10.21

-- ´ËÌõ¼þºÍPlayerZhengyouPT.luaÀï¶¨ÒåÒ»ÖÂ£¬ÒªÍ¬Ê±¸ü¸Ä, ×¢ÒâÃÅÅÉÓÐÇø±ð
local g_Conditions = {
	MenPai = {{"Không gi¾i hÕn", 11}, {"Thiªu Lâm", 0}, {"Minh Giáo", 1}, {"Cái Bang", 2}, {"Võ Ðang", 3}, {"Nga Mi", 4}, {"Tinh Túc", 5}, {"Thiên Long", 6}, {"Thiên S½n", 7}, {"Tiêu dao", 8}, {"MÕn Ðà S½n Trang", 10}, {"Tñ do", 9}},
	Level = {"Không gi¾i hÕn", "Dß¾i Lv10", "Lv10 ðªn 20", "Lv20 ðªn 30", "Lv30 ðªn 40", "Lv40 ðªn 50", "Lv50 ðªn 60", "Lv60 ðªn 70", "Lv70 ðªn 80", "Lv80 ðªn 90", "Lv90 ðªn 100", "Trên Lv100"},
	Sexy = {"Không gi¾i hÕn", "Nam", "Næ"},
	Banghui = {"Không gi¾i hÕn", "Có bang phái", "Không bang phái"},
	ADType	= {"Không gi¾i hÕn", "Nam Thanh Næ Tú", "Bang Hµi", "Sß Ð°", "Kªt Nghîa"},   -- ´Ë´¦ÓÃ×Öµä²»ÐÐ£¬ÁÐ±í¿òºÃÏñ²»Ö§³Ö {"È«²¿", "#{ZYPT_081103_008}", "#{ZYPT_081103_009}", "#{ZYPT_081103_010}", "#{ZYPT_081103_011}",},
	HotLevel = {"Không gi¾i hÕn", "0-10", "11-20", "21-30", "31-40", "41-50", "51-60", "61-70", "71-80"},
}


function ZhengyouSearch_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
end

function ZhengyouSearch_OnLoad()
    ZhengyouSearch_SetControls();
	ZhengyouSearch_OnInitDialog();
 	ZhengyouSearch_Frame:SetProperty("AlwaysOnTop","True");
end

function ZhengyouSearch_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		--if( arg0 == "ZhengyouSearch") then
		--	this:Show();
		--end
	    ZhengyouSearch_OnWindowOpen(arg0);
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "ZhengyouSearch") then
			this:Hide();
		end
	end
end

--
function ZhengyouSearch_OnWindowOpen(sWndName)
	local i = 0;
	for i = 0, 6 do
	   if ( "ZhengyouSearch" .. i == sWndName ) then  --??????????
           CloseWindow("ZhengyouInfoFabu");
           CloseWindow("ZhengyouYaoqiu");
           CloseWindow("VotedPlayer");
	   	   this:Show();
	       if ( 5 == i ) then   -- ?????????????
	          g_Ctrls.ADTypeCombo:SetCurrentSelect(0);
	       else
	          g_Ctrls.ADTypeCombo:SetCurrentSelect(i);
	       end
	   end
	end
end

function ZhengyouSearch_SetControls()
    g_Ctrls = {
	    MenpaiCombo 	= ZhengyouSearch_MenPai,
	    LevelCombo 		= ZhengyouSearch_Level,
	    SexyCombo 		= ZhengyouSearch_Sexy,
	    BanghuiCombo 	= ZhengyouSearch_Confraternity,
	    ADTypeCombo		= ZhengyouSearch_Type,
	    HotLevelCombo   = ZhengyouSearch_Renqi,
	};
end

function ZhengyouSearch_OnInitDialog()
     for i = 1, table.getn(g_Conditions.MenPai) do
		g_Ctrls.MenpaiCombo:ComboBoxAddItem(g_Conditions.MenPai[i][1], g_Conditions.MenPai[i][2]);
     end
	 g_Ctrls.MenpaiCombo:SetCurrentSelect(0);

     for i = 1, table.getn(g_Conditions.Level) do
        g_Ctrls.LevelCombo:ComboBoxAddItem(g_Conditions.Level[i], i - 1);
     end
	 g_Ctrls.LevelCombo:SetCurrentSelect(0);

     for i = 1, table.getn(g_Conditions.Sexy) do
        g_Ctrls.SexyCombo:ComboBoxAddItem(g_Conditions.Sexy[i], i - 1);
     end
	 g_Ctrls.SexyCombo:SetCurrentSelect(0);

     for i = 1, table.getn(g_Conditions.Banghui) do
        g_Ctrls.BanghuiCombo:ComboBoxAddItem(g_Conditions.Banghui[i], i - 1);
     end
	 g_Ctrls.BanghuiCombo:SetCurrentSelect(0);

     for i = 1, table.getn(g_Conditions.ADType) do
        g_Ctrls.ADTypeCombo:ComboBoxAddItem(g_Conditions.ADType[i], i - 1);
     end
	 g_Ctrls.ADTypeCombo:SetCurrentSelect(0);

     for i = 1, table.getn(g_Conditions.HotLevel) do
        g_Ctrls.HotLevelCombo:ComboBoxAddItem(g_Conditions.HotLevel[i], i - 1);
     end
	 g_Ctrls.HotLevelCombo:SetCurrentSelect(0);
end

function ZhengyouSearch_Close()
   this:Hide();
end

-- ¿ªÊ¼²é Ò
function ZhengyouSearch_BeginSearch()
	local sMenpai, iMenpai 	=  g_Ctrls.MenpaiCombo:GetCurrentSelect();
	local sLevel, iLevel 	=  g_Ctrls.LevelCombo:GetCurrentSelect();
	local sSexy, iSexy 		=  g_Ctrls.SexyCombo:GetCurrentSelect();
	local sBanghui, iBanghui =  g_Ctrls.BanghuiCombo:GetCurrentSelect();
	local sADType, iADType 	=  g_Ctrls.ADTypeCombo:GetCurrentSelect();
	local sHotLevel, iHotLevel 	=  g_Ctrls.HotLevelCombo:GetCurrentSelect();
	--·¢ËÍ²é ÒÇëÇó
	--×¢Òâ£ºÃÅÅÉµÄÈ«²¿ºÍÆäËü²»Ò»Ñù£¬ÆäËü¶¼ÊÇ0£¬ ¶øÃÅÅÉÎª10²ÅÊÇÈ«²¿£¨Ôö¼ÓÐÂÃÅÅÉºó11ÊÇÈ«²¿£©
	RequestSearchFindFriendInfo(iMenpai, iBanghui, iSexy, iADType, iLevel, iHotLevel);
	this:Hide();
end
