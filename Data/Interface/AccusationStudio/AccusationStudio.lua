--AccusationStudio.lua

local g_AccusationStudio_WaiguaName = "";
local g_AccusationStudio_Check = {};
local g_AccusationStudio_CurCheck = 0;
local g_AccusationStudio_Frame_UnifiedPosition = nil

function AccusationStudio_PreLoad()
	this:RegisterEvent("OPEN_REPORTWAIGUA_UI");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function AccusationStudio_OnLoad()
	g_AccusationStudio_Frame_UnifiedPosition = AccusationStudio_Frame:GetProperty("UnifiedPosition")
	
	g_AccusationStudio_Check[1] = AccusationStudio_Dailian_Bind;	--????
	g_AccusationStudio_Check[2] = AccusationStudio_Pianzi_Bind;		--?????????
	g_AccusationStudio_Check[3] = AccusationStudio_Datu_Bind;			--???????
	g_AccusationStudio_Check[4] = AccusationStudio_Dacailiao_Bind;--??????????
	g_AccusationStudio_Check[5] = AccusationStudio_Shuama_Bind;		--?????
	g_AccusationStudio_Check[6] = AccusationStudio_Qiangzhan_Bind;--??????
	g_AccusationStudio_Check[7] = AccusationStudio_Weigui_Bind;		--???????????????
	g_AccusationStudio_Check[8] = AccusationStudio_Qita_Bind;			--??
end

function AccusationStudio_OnEvent(event)
	if ( event == "OPEN_REPORTWAIGUA_UI" ) then
		g_AccusationStudio_WaiguaName = tostring(arg0);
		local nLevel = tonumber(arg2);
		local nMenpai = tonumber(arg3);		
		local bHaveMaskBuff = tonumber(arg4);		
		local szMenpai = AccusationStudio_GetMenPai(nMenpai);		
		if bHaveMaskBuff == 1 then
			AccusationStudio_Text:SetText( "#{ZDJB_170517_13}#G"..g_AccusationStudio_WaiguaName.."#cfff263(c¤p b§c: #G".."?".."#cfff263, môn phái: #G"..szMenpai.."#cfff263)")		--?????
		else
			AccusationStudio_Text:SetText( "#{ZDJB_170517_13}#G"..g_AccusationStudio_WaiguaName.."#cfff263(c¤p b§c: #G"..nLevel.."#cfff263, môn phái: #G"..szMenpai.."#cfff263)")		--?????
		end
		for i=1,8 do
			g_AccusationStudio_Check[i]:SetCheck(0);
		end
		g_AccusationStudio_CurCheck = 0;

		this:Show()
	elseif (event == "ADJEST_UI_POS") then
		AccusationStudio_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		AccusationStudio_ResetPos()
	end
	
end

function AccusationStudio_SetCheck( index )
	if g_AccusationStudio_Check[g_AccusationStudio_CurCheck] ~= nil then
		g_AccusationStudio_Check[g_AccusationStudio_CurCheck]:SetCheck(0);
		g_AccusationStudio_CurCheck = 0; 
	end
	
	if g_AccusationStudio_Check[index] ~= nil then
		g_AccusationStudio_Check[index]:SetCheck(1);
		g_AccusationStudio_CurCheck = index;
	end	
	
end

function AccusationStudio_Submit()
	
	if g_AccusationStudio_WaiguaName == "" then
		PushDebugMessage( "#{ZDJB_170517_26}" )
		return
	end
	
	if g_AccusationStudio_CurCheck < 1 or g_AccusationStudio_CurCheck > 8 then
		PushDebugMessage( "#{ZDJB_170517_28}" )
		return
	end

	Lua_ReportWaigua(g_AccusationStudio_WaiguaName, g_AccusationStudio_CurCheck, AccusationStudio_EditInfo:GetText() );
		
	PushDebugMessage( "#{ZDJB_170517_29}" )
	AccusationStudio_Close()
end

function AccusationStudio_Close()
	this:Hide()
end

function AccusationStudio_ResetPos()
	AccusationStudio_Frame:SetProperty("UnifiedPosition",g_AccusationStudio_Frame_UnifiedPosition)
end

function AccusationStudio_GetMenPai( menpai )
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
		strName = "Tiêu Dao";

	elseif(9 == menpai) then
		strName = "Tñ do";

	elseif(10== menpai) then
		strName = "MÕn Ðà S½n Trang";
		
	end
		
	return strName
end
