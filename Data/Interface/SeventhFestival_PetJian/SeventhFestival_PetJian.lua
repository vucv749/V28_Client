local g_SeventhFestival_PetJian_petNum = 0;
local g_SeventhFestival_PetJian_CurSel = -1;
local g_SeventhFestival_PetJian_Icon = "";

local Max_BtnNum = 10;
local g_SeventhFestival_PetJian_PetNames = {
	"Trân Thú trß·ng thành",
	"Trân Thú Bäo Bäo",
	"Biªn d¸ c¤p 1",
	"Biªn d¸ c¤p 2",
	"Biªn d¸ c¤p 3",
	"Biªn d¸ c¤p 4",
	"Biªn d¸ c¤p 5",
	"Biªn d¸ c¤p 6",
	"Biªn d¸ c¤p 7",
	"Biªn d¸ c¤p 8",
};
local g_SeventhFestival_PetJian_PetNames_HH = {
	"Biªn äo Trân Thú 1",
	"Biªn äo Trân Thú 2",
	"Biªn äo Trân Thú 3",
	"Biªn äo Trân Thú 4",
	"Biªn äo Trân Thú 5",
	"Biªn äo Trân Thú 6",
	"Biªn äo Trân Thú 7",
	"Biªn äo Trân Thú 8",
	"Biªn äo Trân Thú 9",
	"Biªn äo Trân Thú 10",
};

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_SeventhFestival_PetJian_Frame_UnifiedXPosition;
local g_SeventhFestival_PetJian_Frame_UnifiedYPosition;

function SeventhFestival_PetJian_PreLoad()
	this:RegisterEvent("OPEN_PETJIAN_DLG_FOR77");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function SeventhFestival_PetJian_OnLoad()

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_SeventhFestival_PetJian_Frame_UnifiedXPosition	= SeventhFestival_PetJian_Frame : GetProperty("UnifiedXPosition");
	g_SeventhFestival_PetJian_Frame_UnifiedYPosition	= SeventhFestival_PetJian_Frame : GetProperty("UnifiedYPosition");

end

function SeventhFestival_PetJian_OnEvent(event)

	if ( event == "OPEN_PETJIAN_DLG_FOR77" ) then
		
		if(IsWindowShow("PetJian")) then
			CloseWindow("PetJian", true)
		end
		
		SeventhFestival_PetJian_Init()
		this:Show();
	end
	
	if ( event == "PLAYER_LEAVE_WORLD" ) then
		this:Hide();
		g_SeventhFestival_PetJian_petNum = 0;
		g_SeventhFestival_PetJian_CurSel = -1;
		g_SeventhFestival_PetJian_Icon = "";
	end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ
		SeventhFestival_PetJian_Frame_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ	
		SeventhFestival_PetJian_Frame_On_ResetPos()
	end

end

function SeventhFestival_PetJian_Init()
	SeventhFestival_PetJian_List : ClearListBox();
	g_SeventhFestival_PetJian_petNum = DataPool:GetPetsOneTypeNum();
	g_SeventhFestival_PetJian_CurSel = -1;
	if(Max_BtnNum <  g_SeventhFestival_PetJian_petNum) then
		g_SeventhFestival_PetJian_petNum = Max_BtnNum;
	end
	--------------------------------------------------
	--Buttons
	local isHH = DataPool:IsPetsOneType_HH()
	
	for i = 1 , g_SeventhFestival_PetJian_petNum do
		if isHH == 1 then 
			SeventhFestival_PetJian_List : AddItem(g_SeventhFestival_PetJian_PetNames_HH[i], i-1);
		else
			SeventhFestival_PetJian_List : AddItem(g_SeventhFestival_PetJian_PetNames[i], i-1);
		end
	end
	--Ä¬ÈÏÑ¡ÖĞ×îºóÒ»¸ö
	SeventhFestival_PetJian_List : SetItemSelectByItemID(g_SeventhFestival_PetJian_petNum - 1);
	SeventhFestival_PetJian_SelectOneType(g_SeventhFestival_PetJian_petNum);
end

function SeventhFestival_PetJian_Onshow()
	---------------------------------------------------------
	--DisableSomeThing
	SeventhFestival_PetJian_FakeObject : SetFakeObject( "" );
	SeventhFestival_PetJian_Food_Type   : Hide();
	SeventhFestival_PetJian_Attack_Type : Hide();
	SeventhFestival_PetJian_NeedLevel  : Hide();
	SeventhFestival_PetJian_Model_TurnLeft : Disable();
	SeventhFestival_PetJian_Model_TurnRight: Disable();

	if(g_SeventhFestival_PetJian_CurSel < 0 or g_SeventhFestival_PetJian_petNum <= 0)then
		return;
	end
	SeventhFestival_PetJian_FakeObject : SetFakeObject( "" );
	DataPool : PetsOneType_SetModel77(g_SeventhFestival_PetJian_CurSel);
	---------------------------------------------------------------------
	-- fake obj
	SeventhFestival_PetJian_FakeObject : SetFakeObject("PetOneType_Pet77");
	SeventhFestival_PetJian_Model_TurnLeft : Enable();
	SeventhFestival_PetJian_Model_TurnRight: Enable();
	SeventhFestival_PetJian_NeedLevel      : Show();
	---------------------------------------------------
	--get TakeLevel
	local nTakeLevel = DataPool : PetsOneType_GetAttr(g_SeventhFestival_PetJian_CurSel,"takelevel");
	local strNeedLevelColor = "";
	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor ="#cFF0000";
	else
		strNeedLevelColor ="#c00FF00";
	end
	local strNeedLevel = strNeedLevelColor.."C¤p 65 C§p ğã ngoài#WKHä mang theo" --tostring( nTakeLevel ).."C¤p#W Mang theo";
	SeventhFestival_PetJian_NeedLevel:SetText( strNeedLevel );
	-----------------------------------------------------
	--get AttackTrait (ÔİÈ±)
	strName,strIcon = DataPool : PetsOneType_GetAttr(g_SeventhFestival_PetJian_CurSel,"attacktype");
	if strIcon ~= "" then
		SeventhFestival_PetJian_Attack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		SeventhFestival_PetJian_Attack_Type : SetToolTip(strName)
		SeventhFestival_PetJian_Attack_Type : Show();
	end
	-----------------------------------------------------
	--get FoodType 
	local food = DataPool : PetsOneType_GetAttr(g_SeventhFestival_PetJian_CurSel,"food");
	strName = "";
	if(food >= 1000) then
		strName = strName .. "Th¸t";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "Thäo";
		food = food - 100;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 10) then
		strName = strName .. "Sâu";
		food = food - 10;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	
	if(food >= 1) then
		strName = strName .. "Ngû c¯c";
	end
	SeventhFestival_PetJian_Food_Type : Show();
	SeventhFestival_PetJian_Food_Type : SetToolTip( strName );
end

function SeventhFestival_PetJian_SelectOneType(typeIdx)
	if(g_SeventhFestival_PetJian_CurSel + 1 == typeIdx or typeIdx < 1 or typeIdx > g_SeventhFestival_PetJian_petNum) then
		return;
	end
	g_SeventhFestival_PetJian_CurSel = typeIdx - 1;
	SeventhFestival_PetJian_Onshow();
end

function SeventhFestival_PetJian_List_Click()
	local typeIdx =  SeventhFestival_PetJian_List : GetFirstSelectItem();
	SeventhFestival_PetJian_SelectOneType(typeIdx + 1);
end

----------------------------------------------------------------------------------
--
-- Ğı×ª äÊŞÄ£ĞÍ£¨Ïò×ó)
--
function SeventhFestival_PetJian_Modle_TurnLeft(start)
	--Ïò×óĞı×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SeventhFestival_PetJian_FakeObject:RotateBegin(-0.3);
	--Ïò×óĞı×ª½áÊø
	else
		SeventhFestival_PetJian_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--Ğı×ª äÊŞÄ£ĞÍ£¨ÏòÓÒ)
--
function SeventhFestival_PetJian_Modle_TurnRight(start)
	--ÏòÓÒĞı×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SeventhFestival_PetJian_FakeObject:RotateBegin(0.3);
	--ÏòÓÒĞı×ª½áÊø
	else
		SeventhFestival_PetJian_FakeObject:RotateEnd();
	end
end

function SeventhFestival_PetJian_OnHiden()
	-- do nothing
	this:Hide()
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function SeventhFestival_PetJian_Frame_On_ResetPos()

	SeventhFestival_PetJian_Frame : SetProperty("UnifiedXPosition", g_SeventhFestival_PetJian_Frame_UnifiedXPosition);
	SeventhFestival_PetJian_Frame : SetProperty("UnifiedYPosition", g_SeventhFestival_PetJian_Frame_UnifiedYPosition);

end
