local GUILD_POSITION_SIZE = 10; --???????

local POSITION_FIRSTMAN = 8;
local g_ListToMember;
local g_ConfraternityFirstMan_Frame_UnifiedPosition;
function ConfraternityFirstMan_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("GUILD_SHOW_FIRSTMAN_RM");
	this:RegisterEvent("GUILD_FORCE_CLOSE");
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function ConfraternityFirstMan_OnLoad()
	g_ConfraternityFirstMan_Frame_UnifiedPosition=ConfraternityFirstMan_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityFirstMan_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 071525) then
		Guild:AskGuildFirstManInfo();
	elseif( event == "GUILD_SHOW_FIRSTMAN_RM") then
		Guild:PrepareMembersInfomation();
		ConfraternityFirstMan_PositionList:ClearListBox();
		local listidx = 0;
		g_ListToMember = {};
		local totalNum = Guild:GetMembersNum(4);
		local i = 0;
		while i < totalNum do
			local guildIdx = Guild:GetShowMembersIdx(i);
			if POSITION_FIRSTMAN == Guild:GetMembersInfo(guildIdx, "Position") then
				szMsg = Guild:GetMembersInfo(guildIdx, "Name");
				ConfraternityFirstMan_PositionList:AddItem("PhÛ Bang Ch¸   "..szMsg, listidx);
				--g_MembersCtl.list:SetItemTooltip(listidx,strTips);
				g_ListToMember[listidx] = guildIdx;
				--g_ListToMember[listidx] = i;
				
				listidx = listidx + 1;
			end
			i = i + 1;
		end
		if(listidx > 0) then
			ConfraternityFirstMan_PositionList:SetItemSelectByItemID(0);
			this:Show();
		else
			PushDebugMessage("#{BHCR_090713_05}");
		end
	elseif(event == "GUILD_FORCE_CLOSE") then
		this:Hide();
	end
	
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityFirstMan_Frame_On_ResetPos()
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityFirstMan_Frame_On_ResetPos()
	end	
end

function Guild_FirstMan_Confirm()
	local selidx = ConfraternityFirstMan_PositionList:GetFirstSelectItem();
	if( -1 == selidx ) then
		return;
	end
	local seIndex = g_ListToMember[selidx];
	local Pos = Guild:GetMembersInfo(seIndex, "Position")

	if POSITION_FIRSTMAN == Pos then
		if(-1 ~= seIndex) then
		--µ˜”√»Œ√¸Ω”ø⁄
		Guild:SetFirstMan(seIndex);
		end
	end
	this:Hide();
end

--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function ConfraternityFirstMan_Frame_On_ResetPos()
  ConfraternityFirstMan_Frame:SetProperty("UnifiedPosition", g_ConfraternityFirstMan_Frame_UnifiedPosition);
end
