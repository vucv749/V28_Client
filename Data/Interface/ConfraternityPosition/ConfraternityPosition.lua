local GUILD_POSITION_SIZE = 10; --???????
local g_ConfraternityPosition_Frame_UnifiedPosition;
function ConfraternityPosition_PreLoad()
	this:RegisterEvent("GUILD_SHOW_APPOINTPOS");
	this:RegisterEvent("GUILD_FORCE_CLOSE");

	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end

function ConfraternityPosition_OnLoad()
		g_ConfraternityPosition_Frame_UnifiedPosition=ConfraternityPosition_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityPosition_OnEvent(event)
	if(event == "GUILD_SHOW_APPOINTPOS") then
		ConfraternityPosition_PositionList:ClearListBox();
		local i = 0;
		while i < GUILD_POSITION_SIZE do
			local szMsg = Guild:GetMyGuildInfo("Appoint", i);
			--AxTrace(0,0,"Guild Position:"..tostring(i).." pos:"..tostring(szMsg));
			if(nil ~= szMsg and "" ~= szMsg) then
				ConfraternityPosition_PositionList:AddItem(szMsg,i);
			else
				break;
			end
			i = i + 1;
		end
		
		if(nil ~= Guild:GetMyGuildInfo("Appoint", 0)) then
			ConfraternityPosition_PositionList:SetItemSelectByItemID(0);
		end
		this:Show();
	elseif(event == "GUILD_FORCE_CLOSE") then
		this:Hide();
	end
		-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityPosition_Frame_On_ResetPos()
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityPosition_Frame_On_ResetPos()
	end
end

function Guild_Position_Confirm()
	local selidx = ConfraternityPosition_PositionList:GetFirstSelectItem();
	-- add by zchw 
	local szMsg = Guild:GetMyGuildInfo("Appoint", selidx);
	if szMsg == " ThﬂΩng Nh‚n" then
		local Num = Guild:GetMemberBak();
		local szLvl = Guild:GetMembersInfo(Num, "Level");	
		if szLvl < 40 then
			PushDebugMessage("Bang Ch˙ng dﬂæi c§p 40 khÙng th¨ ﬂ˛c nhßn ch—c l‡ ThﬂΩng Nh‚n!");
			return;
		end
	-- end
	end	
	if(-1 ~= selidx) then
		--µ˜”√»Œ√¸Ω”ø⁄
		Guild:AdjustMemberAuth(selidx);
	end
	this:Hide();
end


--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function ConfraternityPosition_Frame_On_ResetPos()
  ConfraternityPosition_Frame:SetProperty("UnifiedPosition", g_ConfraternityPosition_Frame_UnifiedPosition);
end
