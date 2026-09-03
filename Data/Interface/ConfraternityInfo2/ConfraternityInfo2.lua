-------------------------------------------------------
--–¬"∞Ôª·œÍœ∏–≈œ¢"ΩÁ√ÊΩ≈±æ
--create by xindefeng
-------------------------------------------------------

local g_QueryGuildID = -1
local g_ConfraternityInfo2_Frame_UnifiedPosition;
-- ¬º˛◊¢≤·
function ConfraternityInfo2_PreLoad()
	this:RegisterEvent("GUILD_SHOW_DETAILINFO2")
	this:RegisterEvent("GUILD_ID_FORDETAILINFO2")
	this:RegisterEvent("GUILD_FORCE_CLOSE")	

	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function ConfraternityInfo2_OnLoad()
		g_ConfraternityInfo2_Frame_UnifiedPosition=ConfraternityInfo2_Frame:GetProperty("UnifiedPosition");
end

-- ¬º˛œÏ”¶
function ConfraternityInfo2_OnEvent(event)
	if(event == "GUILD_ID_FORDETAILINFO2") then
		g_QueryGuildID = tonumber(arg0)
	elseif(event == "GUILD_SHOW_DETAILINFO2") then
		Guild_Info2_Clear()		
		Guild_Info2_Update()
		Guild_Info2_Close()
		Guild_Info2_Show()
	elseif(event == "GUILD_FORCE_CLOSE") then
		Guild_Info2_Close()	
	end
		-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityInfo2_Frame_On_ResetPos()
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityInfo2_Frame_On_ResetPos()
	end	
end

function Guild_Info2_Clear()
	ConfraternityInfo2_DragTitle:SetText("")
	--ConfraternityInfo2_TitleInfo:SetText("")
end


--…Ë÷√œ‘ æ–≈œ¢
function Guild_Info2_Update()
	--title
	ConfraternityInfo2_DragTitle:SetText("#gFF0FA0ThÙng tin bang")
	
	--Guild Name
	local str = Guild:GetMyGuildDetailInfo("Name")
	ConfraternityInfo2_ConfraternityName:SetText(str)
	
	local leagueName = Guild:GetMyGuildDetailInfo("LeagueName")
	ConfraternityInfo2_GuildLeagueName:SetText(leagueName)
	
	--Main Info
	ConfraternityInfo2_Amount:SetText(tostring(g_QueryGuildID))	--GuildID

	str = Guild:GetMyGuildDetailInfo("FoundedTime")
	ConfraternityInfo2_CreateTime:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Level")
	ConfraternityInfo2_Level:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Creator")
	ConfraternityInfo2_Create:SetText(str)

	str = Guild:GetMyGuildDetailInfo("ChiefName")
	ConfraternityInfo2_Master:SetText(str)

	str = Guild:GetMyGuildDetailInfo("CityName")
	if(str == "-1") then
		str = "KhÙng cÛ th‡nh"
	end
	ConfraternityInfo2_City:SetText(str)
	
	str = Guild:GetMyGuildDetailInfo("CurBuilding")
	ConfraternityInfo2_CityBuilding:SetText(str)
	str = Guild:GetMyGuildDetailInfo("Scene")
	if(str == "-1") then
		str = "KhÙng rı"
	end
	ConfraternityInfo2_Locus:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Comm")
	ConfraternityInfo2_CBD:SetText(str)

	str = Guild:GetMyGuildDetailInfo("CurResearch")
	if(str == "")then
		str = "TrØng"
	end
	ConfraternityInfo2_Specialty:SetText(str)
	
	str = Guild:GetMyGuildDetailInfo("MemNum")
	ConfraternityInfo2_Info1:SetText(str)	
	
	str = Guild:GetMyGuildDetailInfo("Ind")
	ConfraternityInfo2_Info4:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Agr")
	ConfraternityInfo2_Info5:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Com")
	ConfraternityInfo2_Info6:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Def")
	ConfraternityInfo2_Info7:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Tech")
	ConfraternityInfo2_Info8:SetText(str)

	str = Guild:GetMyGuildDetailInfo("Ambi")
	ConfraternityInfo2_Info9:SetText(str)
end

function Guild_Info2_Show()
	this:Show()
end

function Guild_Info2_Close()
	this:Hide()
end


--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function ConfraternityInfo2_Frame_On_ResetPos()
  ConfraternityInfo2_Frame:SetProperty("UnifiedPosition", g_ConfraternityInfo2_Frame_UnifiedPosition);
end
