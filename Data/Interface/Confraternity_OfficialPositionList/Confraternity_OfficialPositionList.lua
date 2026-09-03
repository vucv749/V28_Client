-------------------------------------------------------
--"¹ÙÔ±ÁÐ±í"½çÃæ½Å±¾
--create by xindefeng
-------------------------------------------------------

local g_OfficialCtls = nil		--??????????
local g_ListIdx2IDTbl = nil		--List?????????ID????

local g_positionInfo = {
	"Ðþi phê chu¦n",
	"Bang Chúng ",
	"Tinh Anh ",
	"Thß½ng Nhân ",
	"Hoang Hoa SÑ ",
	"Công Vø SÑ ",
	"Nµi Vø SÑ ",
	"Bang Phó ",
	"Bang Chü ",
};

local g_menpaiInfo = {
	"Thiªu Lâm",
	"Minh Giáo",
	"Cái Bang",
	"Võ Ðang",
	"Nga Mi",
	"Tinh Túc",
	"Thiên Long",
	"Thiên S½n",
	"Tiêu Dao",
	"Tñ do",
	"MÕn Ðà S½n Trang",
}

local g_Confraternity_OfficialPositionList_Frame_UnifiedPosition;

--ÊÂ¼þ×¢²á
function Confraternity_OfficialPositionList_PreLoad()
	this:RegisterEvent("GUILD_SHOW_OFFICIALLIST")
	this:RegisterEvent("GUILD_ANY_SORTDATE")
	this:RegisterEvent("GUILD_FORCE_CLOSE")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function Confraternity_OfficialPositionList_OnLoad()
		g_Confraternity_OfficialPositionList_Frame_UnifiedPosition=Confraternity_OfficialPositionList_Frame:GetProperty("UnifiedPosition");
end

--ÊÂ¼þÏìÓ¦
function Confraternity_OfficialPositionList_OnEvent(event)
	Confraternity_OfficialPositionList_SetCtl()--???????

	if(event == "GUILD_SHOW_OFFICIALLIST") then
		Confraternity_OfficialPositionList_Close()
		Confraternity_OfficialPositionList_Clear()
		Confraternity_OfficialPositionList_Update()
		Confraternity_OfficialPositionList_Show()
	elseif(event == "GUILD_ANY_SORTDATE") then	--??????????C??????
		Guild:SortAnyGuildMembersByPosition()
	elseif(event == "GUILD_FORCE_CLOSE") then
		Confraternity_OfficialPositionList_Close()
	end
	
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		Confraternity_OfficialPositionList_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Confraternity_OfficialPositionList_Frame_On_ResetPos()
	end
	
end

--½«ËùÓÐµÄÏÔÊ¾ÐÅÏ¢µÄ¿Ø¼þ·ÅÈë½á¹¹ÖÐ,±ãÓÚ²Ù×Ý
function Confraternity_OfficialPositionList_SetCtl()
	g_OfficialCtls = {
										list = Confraternity_OfficialPositionList_MemberList,	--????
										officalname = Confraternity_OfficialPositionList_Info1_Text,--????
										info_menpai = {txt = Confraternity_OfficialPositionList_Info2_Text, msg = Confraternity_OfficialPositionList_Info2},--??
										info_level = {txt = Confraternity_OfficialPositionList_Info3_Text, msg = Confraternity_OfficialPositionList_Info3},	--??
										info_gongxiandu = {txt = Confraternity_OfficialPositionList_Info4_Text, msg = Confraternity_OfficialPositionList_Info4},--???
										info_benzhougongxiandu = {txt = Confraternity_OfficialPositionList_Info7_Text, msg = Confraternity_OfficialPositionList_Info7},--?????
										info_rubangdate =	{txt = Confraternity_OfficialPositionList_Info5_Text, msg = Confraternity_OfficialPositionList_Info5},--????
										info_lixiandate =	{txt = Confraternity_OfficialPositionList_Info6_Text, msg = Confraternity_OfficialPositionList_Info6},--????
										desc = Confraternity_OfficialPositionList_Tenet,			--????
										edit = Confraternity_OfficialPositionList_EditTenet		--???????
								 	 }
end

--Çå¿ ½çÃæ
function Confraternity_OfficialPositionList_Clear()
	--Çå¿ ¹ÙÔ±ÁÐ±í
	g_OfficialCtls.list:ClearListBox()

	--Çå¿ ¹ÙÔ±Ãû×Ö
	g_OfficialCtls.officalname:SetText("")

	--Çå¿ ËùÓÐinfo¿Ø¼þ
	g_OfficialCtls.info_menpai.txt:SetText("")
	g_OfficialCtls.info_level.txt:SetText("")
	g_OfficialCtls.info_gongxiandu.txt:SetText("")
	g_OfficialCtls.info_benzhougongxiandu.txt:SetText("")
	g_OfficialCtls.info_rubangdate.txt:SetText("")
	g_OfficialCtls.info_lixiandate.txt:SetText("")

	g_OfficialCtls.info_menpai.msg:SetText("")
	g_OfficialCtls.info_level.msg:SetText("")
	g_OfficialCtls.info_gongxiandu.msg:SetText("")
	g_OfficialCtls.info_benzhougongxiandu.msg:SetText("")
	g_OfficialCtls.info_rubangdate.msg:SetText("")
	g_OfficialCtls.info_lixiandate.msg:SetText("")

	--Çå¿ °ï»á×ÚÖ¼
	g_OfficialCtls.desc:SetText("")
	g_OfficialCtls.desc:Show()

	g_OfficialCtls.edit:SetText("")
	g_OfficialCtls.edit:SetProperty("CaratIndex", 1024)
	g_OfficialCtls.edit:Hide()

	--Çå¿ Ë÷ÒýID¶ÔÓ¦±í
	g_ListIdx2IDTbl = nil
end

--Ë¢ÐÂÏÔÊ¾ÆäËûÊý¾Ý
function Confraternity_OfficialPositionList_Flush(selected)
	local str = nil
	local selectedID = g_ListIdx2IDTbl[selected]

	if  selectedID == nil then
		return
	end

	--¹ÙÔ±Ãû³Æ
	str = Guild:GetAnyGuildMembersInfo(selectedID, "Name")--????????????
	local guid = ""
	_, guid = Guild:GetAnyGuildMembersInfo(selectedID, "GUID")--??guid???????
	g_OfficialCtls.officalname:SetText(str.."("..guid..")")

	--ÃÅÅÉ
	str = Guild:GetAnyGuildMembersInfo(selectedID, "MenPai")
	g_OfficialCtls.info_menpai.txt:SetText("Phái: ")
	g_OfficialCtls.info_menpai.msg:SetText(g_menpaiInfo[str+1])

	--µÈ¼¶
	str = Guild:GetAnyGuildMembersInfo(selectedID, "Level")
	g_OfficialCtls.info_level.txt:SetText("C¤p: ")
	g_OfficialCtls.info_level.msg:SetText(str)

	--¹±Ï×¶È
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "CurCon").."/"..Guild:GetAnyGuildMembersInfo(selectedID, "MaxCon")
	g_OfficialCtls.info_gongxiandu.txt:SetText("Ðµ c¯ng hiªn: ")
	g_OfficialCtls.info_gongxiandu.msg:SetText(szMsg)

	--±¾ÖÜ¹±Ï×¶È
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "ContriPerWeek")
	g_OfficialCtls.info_benzhougongxiandu.txt:SetText("CH tu¥n này:")
	g_OfficialCtls.info_benzhougongxiandu.msg:SetText(szMsg)

	--Èë°ïÊ±¼ä
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "JoinTime");
	g_OfficialCtls.info_rubangdate.txt:SetText("Vào bang: ")
	g_OfficialCtls.info_rubangdate.msg:SetText(szMsg)

	--ÀëÏßÊ±¼ä
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "LogOutTime")
	g_OfficialCtls.info_lixiandate.txt:SetText("R¶i mÕng: ")
	g_OfficialCtls.info_lixiandate.msg:SetText(szMsg)
end

--Ë¢ÐÂÏÔÊ¾"¹ÙÔ±ÁÐ±í"List
function Confraternity_OfficialPositionList_ShowList()
	--List Ctl
	local OfficialsCount = 0			--????
	local UnSortIdx = 0						--???????
	local Color = nil							--????
	local Position = nil					--??(?)
	local Name = nil							--??

	local listidx = 0	--list??????
	local i = 0

	g_ListIdx2IDTbl = nil	--???

	OfficialsCount = Guild:GetAnyGuildMembersInfo(0, "OfficialsNum")	--??????(????)
	while i < OfficialsCount do
		--»ñÈ¡Î´ÅÅÐòÇ°Ë÷ÒýºÅ
		UnSortIdx = Guild:Sort2UnSortIndex(i)

		--»ñÈ¡Êý¾Ý
		Color = Guild:GetAnyGuildMembersInfo(UnSortIdx, "ShowColor") 	--??????
		Position = Guild:GetAnyGuildMembersInfo(UnSortIdx, "Position")--??
		Name = Guild:GetAnyGuildMembersInfo(UnSortIdx, "Name")				--??????

		--¸ø¿Ø¼þ¼ÓÒ»Ïî
		g_OfficialCtls.list:AddItem(Color..g_positionInfo[Position]..Name, listidx);

		--Î¬»¤±í
		g_ListIdx2IDTbl[listidx] = UnSortIdx

		listidx = listidx + 1

		i = i + 1
	end

	g_OfficialCtls.list:SetItemSelectByItemID(0)	--????????????


end

--ÏÔÊ¾Êý¾Ý
function Confraternity_OfficialPositionList_Update()
	--title
	Confraternity_OfficialPositionList_DragTitle:SetText("#gFF0FA0Danh sánh thành viên")

	--Ë¢ÐÂÏÔÊ¾"¹ÙÔ±ÁÐ±í"List
	Confraternity_OfficialPositionList_ShowList()

	--Ë¢ÐÂÏÔÊ¾ÆäËûÊý¾Ý
	Confraternity_OfficialPositionList_Selected()

	--°ï»á×ÚÖ¼
	local str = Guild:GetAnyGuildMembersInfo(0, "Desc")--????
	g_OfficialCtls.desc:SetText(str)
end

--ÓÃ»§Ñ¡Ôñ·¢Éú¸Ä±ä,Ë¢ÐÂÒ»ÏÂ
function Confraternity_OfficialPositionList_Selected()
	local idx = g_OfficialCtls.list:GetFirstSelectItem()	--????????
	if (idx == -1) then
		return
	end

	Confraternity_OfficialPositionList_Flush(idx)--??
end

--ÏÔÊ¾ÓÒ¼ü²Ëµ¥
function Confraternity_OfficialPositionList_PopMenu()
	local idx = g_OfficialCtls.list:GetFirstSelectItem()	--????????
	if( idx == -1 ) then
		return
	end

	Guild:Show_OfficialPopMenu(tonumber(g_ListIdx2IDTbl[idx])) --??C?????????
end

--ÏÔÊ¾½çÃæ
function Confraternity_OfficialPositionList_Show()
	this:Show()
end

--¹Ø± ½çÃæ
function Confraternity_OfficialPositionList_Close()
	this:Hide()
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function Confraternity_OfficialPositionList_Frame_On_ResetPos()
  Confraternity_OfficialPositionList_Frame:SetProperty("UnifiedPosition", g_Confraternity_OfficialPositionList_Frame_UnifiedPosition);
end
