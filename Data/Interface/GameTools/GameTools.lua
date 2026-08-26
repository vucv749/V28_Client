--³¬¼¶¹ÜÀíÔ±¹¤¾ßV1
--ÐÂÔöGM×é¶ÓÍæ¼Ò ¿ÉÃæ¶ÔÃæµÀ¾ß·¢·Å Ñ©Îè¶þ¸Ä 2021-9-4 19:04:08 

local g_GameTools_Frame_UnifiedPosition;
local MenPaiId = -1
local TargetID = nil
local g_GameTools_ItemSearchResults = {}
local GameTools_ItemTypeId = 1
local gameToolsItemTypeList = {"Trang b¸", "Tài li®u", "Bäo thÕch"}
local menpaiNameList = {"Thiªu Lâm","Minh Giáo","Cái Bang","Võ Ðang","Nga Mi","Tinh Túc","Thiên Long","Thiên S½n","Tiêu dao","Tñ do","MÕn Ðà","Ác Nhân C¯c","Mµ Dung","Ðß¶ng Môn","QuÖ C¯c","Ðào Hoa Ðäo","Tuy®t Tình C¯c"}--,"Mµ Dung","Ðß¶ng Môn","QuÖ C¯c","Ðào Hoa Ðäo"
function GameTools_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_NOTIFY");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" ); -- ????
	this:RegisterEvent("MAINTARGET_CHANGED")
end

function GameTools_OnLoad()
	g_GameTools_Frame_UnifiedPosition=GameTools_Frame:GetProperty("UnifiedPosition");
end

function GameTools_OnEvent(event)
	if(event == "UI_COMMAND" and arg0 == "20200427") then
		GameTools_Init()
		GameTools_FenYe1:SetCheck(1)
		this:Show();
	elseif ( event == "MAINTARGET_CHANGED" ) then
		TargetID = tonumber(arg0)
	elseif (event == "ADJEST_UI_POS" ) then
		GameTools_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GameTools_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
        this:Hide()	
	end
end

function GameTools_ListBox_Selected()
	local str
	str,MenPaiId = GameTools_menpaiEdix:GetCurrentSelect()
end

function GameTools_Init()
	GameTools_menpaiEdix:ResetList()
	for i = 1, table.getn(menpaiNameList) do
		GameTools_menpaiEdix:AddTextItem(menpaiNameList[i], i)
	end
	-- ³õÊ¼»¯ÎïÆ·ÀàÐÍÁÐ±í
	GameTools_ItemTypeList:ResetList()
	for i = 1, table.getn(gameToolsItemTypeList) do
		GameTools_ItemTypeList:AddTextItem(gameToolsItemTypeList[i], i)
	end
	GameTools_ItemTypeId = 1
end

--Ôª±¦
function GameTools_yuanbao(index)--1?? 2??
    local nNum = GameTools_yuanbaoEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--ÎïÆ·×°±¸
function GameTools_item(index)--1?? 2??
    local nNum = GameTools_itemEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,2);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--½ð±Ò
function GameTools_money(index)--1?? 2??
    local nNum = GameTools_moneyEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,3);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--°ó¶¨Ôª±¦
function GameTools_bindyuanbao(index)--1?? 2??
    local nNum = GameTools_bindyuanbaoEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,4);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--ÐÄ·¨
function GameTools_xiongba(index)--1?? 2??
    local nNum = GameTools_xiongbaEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,5);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--Ôùµã
function GameTools_hongli(index)--1?? 2??
    local nNum = GameTools_hongliEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,6);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--½ÇÉ«µÈ¼¶
function GameTools_level(index)--1?? 2??
    local nNum = GameTools_levelEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,7);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--ÇÐ»»ÃÅÅÉ
function GameTools_menpai(index) 
    if MenPaiId == - 1 then
	   PushDebugMessage("Thïnh lña ch÷n gia nh§p Ðích môn phái")
	   TargetID = 0
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,8);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(MenPaiId));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	   
end

--¸øÍæ¼Ò·¢·ÅµÀ¾ß×°±¸ BYÑ©Îè[BUG-319] 2021-9-4 21:45:55 
function GameTools_FaFang(index)
	if TargetID == nil then
		PushDebugMessage("Thïnh lña ch÷n cho vay trang b¸ Ðích ngß¶i ch½i, nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	--ÎïÆ·ID
    local nItem = GameTools_FaFang1Edix:GetText()
	--·¢·ÅÊýÁ¿
	local nNum = GameTools_FaFang2Edix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if nItem == nil then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,9); 				--nType 
		Set_XSCRIPT_Parameter(1,tonumber(nItem));	--arg2  ??ID
		Set_XSCRIPT_Parameter(2,tonumber(nNum));	--arg3  ????
		Set_XSCRIPT_Parameter(3,TargetID);		--isWho ??Guid
		Set_XSCRIPT_ParamCount(4);					--????
    Send_XSCRIPT();
end

--¸øÍæ¼Ò½»×Ó
function GameTools_JiaoZi(index)
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
    local nNum = GameTools_JiaoZiEdix:GetText()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,10);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--¸øÍæ¼ÒÉÆ¶ñ
function GameTools_JKL(index)
    local nNum = GameTools_JKLEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,11);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--¸øÍæ¼ÒÃÅ¹±
function GameTools_MenGong(index)
    local nNum = GameTools_MenGongEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,12);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--¸øÍæ¼Ò°ï¹±
function GameTools_BangGong(index)
    local nNum = GameTools_BangGongEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,13);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--¸øÍæ¼ÒÐÞÁ¶¹¦Á¦
function GameTools_GongLi(index)
    local nNum = GameTools_GongLiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,14);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--¸øÍæ¼ÒÉ±Æø
function GameTools_TiWu(index)
    local nNum = GameTools_TiWuEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,15);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--³ÆºÅ
function GameTools_JingCui(index)
    local nNum = GameTools_JingCuiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,16);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--¸øbuff
function GameTools_ZhuangTai(index)
    local nNum = GameTools_ZhuangTaiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,17);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();
end

--¸ø±¦±¦
function GameTools_BaoBao(index)
    local nNum = GameTools_BaoBaoEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,18);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--¾­Ñé
function GameTools_JingYan(index)
    local nNum = GameTools_JingYanEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,19);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--»îÁ¦
function GameTools_HuoLi(index)
    local nNum = GameTools_HuoLiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,20);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--¾«Á¦
function GameTools_JingLi(index)
    local nNum = GameTools_JingLiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,21);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();
end

--´«ËÍµ½Ö¸¶¨µØÍ¼ID
function GameTools_DiTu(index)
    local nMap = GameTools_DiTu1Edix:GetText()
	local xPos = GameTools_DiTu2Edix:GetText()
	local yPos = GameTools_DiTu3Edix:GetText()
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	if nMap == nil then
		nMap = 99999
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,22);
		Set_XSCRIPT_Parameter(1,tonumber(nMap)); --??ID
		Set_XSCRIPT_Parameter(2,tonumber(xPos)); --X
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(yPos)); --Y
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();
end

--¸ø»áÔ±µã
function GameTools_VIP(index)--1?? 2??
    local nNum = GameTools_VIPEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,23);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--¸ø¼¼ÄÜ
function GameTools_NeiXi(index)--1?? 2??
    local nNum = GameTools_NeiXiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeOne");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,24);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

function GameTools_ItemSelectChanged()
end

function GameTools_Frame_On_ResetPos()
	GameTools_Frame:SetProperty("UnifiedPosition", g_GameTools_Frame_UnifiedPosition);
end

--TAB½çÃæÇÐ»»
function GameTools_ChangeTabIndex( nIndex )
 local nUI = 0
	if 1 == nIndex then
		-- nUI = 20200427
		return
	elseif 2 == nIndex then
		nUI = 202004272
	elseif 3 == nIndex then
		nUI = 202004273
	elseif 4 == nIndex then
		nUI = 202004274
	elseif 5 == nIndex then
		nUI = 202004275
	elseif 6 == nIndex then
		nUI = 202004276
	elseif 7 == nIndex then
		nUI = 316022021
	end
	if nUI ~= 0 then
		PushEvent("UI_COMMAND", nUI)
		this:Hide();
	end
end


-- ========== ÎïÆ·ËÑË÷¹¦ÄÜ ==========

function GameTools_ItemType_Selected()
	local str
	str, GameTools_ItemTypeId = GameTools_ItemTypeList:GetCurrentSelect()
end

function GameTools_FormatItemDisplay(itemName, itemId)
	local idStr = tostring(itemId)
	local padding = 8 - string.len(idStr)
	if padding < 1 then padding = 1 end
	local spaces = ""
	for i = 1, padding do spaces = spaces .. " " end
	return idStr .. spaces .. itemName
end

function GameTools_DoSearch()
	local searchText = GameTools_SearchEdit:GetText()
	if searchText == nil or searchText == "" then
		GameTools_SearchStatus:SetText("")
		PushDebugMessage("Thïnh ðßa vào tìm tòi nµi dung")
		return
	end
	GameTools_SearchItems(searchText)
end

function GameTools_SearchItems(searchText)
	g_GameTools_ItemSearchResults = {}
	GameTools_ItemList:ClearListBox()
	GameTools_ItemIcon:SetActionItem(-1)
	GameTools_ItemIdEdit:SetText("")
	GameTools_ItemCountEdit:SetText("1")
	GameTools_SearchStatus:SetText("Ðang · tìm tòi [" .. searchText .. "]...")

	local results = GameTools_SearchItemsInMemory(searchText, GameTools_ItemTypeId, 100)
	local resultCount = 0

	for i = 1, table.getn(results) do
		local item = results[i]
		table.insert(g_GameTools_ItemSearchResults, {id = item.id, name = item.name})
		local displayText = GameTools_FormatItemDisplay(item.name, item.id)
		GameTools_ItemList:AddItem(displayText, resultCount)
		resultCount = resultCount + 1
	end

	if resultCount == 0 then
		GameTools_ItemList:AddItem("Không tìm ðßþc xÑng ðôi Ðích ðÕo cø", 0)
		GameTools_SearchStatus:SetText("Không tìm ðßþc xÑng ðôi Ðích ðÕo cø")
	else
		GameTools_SearchStatus:SetText("Tìm ðßþc" .. resultCount .. "Cá xÑng ðôi Ðích ðÕo cø")
	end
	return resultCount
end

function GameTools_ItemList_Selected()
	local itemIndex = GameTools_ItemList:GetFirstSelectItem()
	if itemIndex ~= nil and itemIndex >= 0 and itemIndex < table.getn(g_GameTools_ItemSearchResults) then
		local itemData = g_GameTools_ItemSearchResults[itemIndex + 1]
		if itemData ~= nil then
			local theAction = DataPool:CreateActionItemForShow(itemData.id, 1)
			if theAction:GetID() ~= 0 then
				GameTools_ItemIcon:SetActionItem(theAction:GetID())
			end
			GameTools_ItemIdEdit:SetText(tostring(itemData.id))
			GameTools_ItemCountEdit:SetText("1")
		end
	end
end

function GameTools_SendSelectedItem()
	local itemIdText = GameTools_ItemIdEdit:GetText()
	if itemIdText == nil or itemIdText == "" then
		PushDebugMessage("Thïnh Tiên lña ch÷n mµt cái v§t ph¦m")
		return
	end
	local itemId = tonumber(itemIdText)
	if itemId == nil or itemId <= 0 then
		PushDebugMessage("V§t ph¦m IDkhông có hi®u quä")
		return
	end
	local countText = GameTools_ItemCountEdit:GetText()
	if countText == nil or countText == "" then
		PushDebugMessage("Thïnh ðßa vào v§t ph¦m s¯ lßþng")
		return
	end
	local itemCount = tonumber(countText)
	if itemCount == nil or itemCount <= 0 then
		PushDebugMessage("Thïnh ðßa vào hæu hi®u Ðích s¯ lßþng")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu ngß¶i ch½i")
		TargetID = 0
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("GMToolTypeOne")
	Set_XSCRIPT_ScriptID(666666)
	Set_XSCRIPT_Parameter(0, 9)
	Set_XSCRIPT_Parameter(1, tonumber(itemId))
	Set_XSCRIPT_Parameter(2, tonumber(itemCount))
	Set_XSCRIPT_Parameter(3, TargetID)
	Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function GameTools_RecallLastItem()
	local itemIdText = GameTools_ItemIdEdit:GetText()
	if itemIdText == nil or itemIdText == "" then
		PushDebugMessage("Thïnh Tiên lña ch÷n mµt cái v§t ph¦m")
		return
	end
	local itemId = tonumber(itemIdText)
	if itemId == nil or itemId <= 0 then
		PushDebugMessage("V§t ph¦m IDkhông có hi®u quä")
		return
	end
	local countText = GameTools_ItemCountEdit:GetText()
	if countText == nil or countText == "" then
		PushDebugMessage("Thïnh ðßa vào v§t ph¦m s¯ lßþng")
		return
	end
	local itemCount = tonumber(countText)
	if itemCount == nil or itemCount <= 0 then
		PushDebugMessage("Thïnh ðßa vào hæu hi®u Ðích s¯ lßþng")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu ngß¶i ch½i")
		TargetID = 0
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("GMToolTypeOne")
	Set_XSCRIPT_ScriptID(666666)
	Set_XSCRIPT_Parameter(0, 25)
	Set_XSCRIPT_Parameter(1, tonumber(itemId))
	Set_XSCRIPT_Parameter(2, tonumber(itemCount))
	Set_XSCRIPT_Parameter(3, TargetID)
	Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end
