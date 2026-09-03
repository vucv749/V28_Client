local g_petNum = 0;
local g_CurSel = -1;
local g_Icon = "";

local Max_BtnNum = 10;
local PetNames = {
	"Trân Thú Trß·ng Thành",
	"Trân Thú Bäo Bäo",
	"Biªn d¸ Lv1",
	"Biªn d¸ Lv2",
	"Biªn d¸ Lv3",
	"Biªn d¸ Lv4",
	"Biªn d¸ Lv5",
	"Biªn d¸ Lv6",
	"Biªn d¸ Lv7",
	"Biªn d¸ Lv8",
};
local PetNames_HH = {
	"Äo Hóa Trân Thú 1",
	"Äo Hóa Trân Thú 2",
	"Äo Hóa Trân Thú 3",
	"Äo Hóa Trân Thú 4",
	"Äo Hóa Trân Thú 5",
	"Äo Hóa Trân Thú 6",
	"Äo Hóa Trân Thú 7",
	"Äo Hóa Trân Thú 8",
	"Äo Hóa Trân Thú 9",
	"Äo Hóa Trân Thú 10",
};

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_PetJian_Frame_UnifiedXPosition;
local g_PetJian_Frame_UnifiedYPosition;

function PetJian_PreLoad()
	this:RegisterEvent("OPEN_PETJIAN_DLG");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetJian_OnLoad()

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_PetJian_Frame_UnifiedXPosition	= PetJian_Frame : GetProperty("UnifiedXPosition");
	g_PetJian_Frame_UnifiedYPosition	= PetJian_Frame : GetProperty("UnifiedYPosition");

end

function PetJian_OnEvent(event)
	if ( event == "OPEN_PETJIAN_DLG" ) then
		
		if(IsWindowShow("SeventhFestival_PetJian")) then
			CloseWindow("SeventhFestival_PetJian", true)
		end
		
		PetJian_Init()
		this:Show();
	end
	if ( event == "PLAYER_LEAVE_WORLD" ) then
		this:Hide();
		g_petNum = 0;
		g_CurSel = -1;
		g_Icon = "";
	end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ
		PetJian_Frame_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ	
		PetJian_Frame_On_ResetPos()
	end

end

function PetJian_Init()
	PetJian_List : ClearListBox();
	g_petNum = DataPool:GetPetsOneTypeNum();
	g_CurSel = -1;
	if(Max_BtnNum <  g_petNum) then
		g_petNum = Max_BtnNum;
	end
	--------------------------------------------------
	--Buttons
	local isHH = DataPool:IsPetsOneType_HH()
	
	for i = 1 , g_petNum do
		if isHH == 1 then 
			PetJian_List : AddItem(PetNames_HH[i], i-1);
		else
			PetJian_List : AddItem(PetNames[i], i-1);
		end
	end
	--Ä¬ÈÏÑ¡ÖĞ×îºóÒ»¸ö
	PetJian_List : SetItemSelectByItemID(g_petNum - 1);
	PetJian_SelectOneType(g_petNum);
end

function PetJian_Onshow()
	---------------------------------------------------------
	--DisableSomeThing
	PetJian_FakeObject : SetFakeObject( "" );
	PetJianFood_Type   : Hide();
	PetJianAttack_Type : Hide();
	PetJian_NeedLevel  : Hide();
	PetJian_Model_TurnLeft : Disable();
	PetJian_Model_TurnRight: Disable();

	if(g_CurSel < 0 or g_petNum <= 0)then
		return;
	end
	PetJian_FakeObject : SetFakeObject( "" );
	DataPool : PetsOneType_SetModel(g_CurSel);
	---------------------------------------------------------------------
	-- fake obj
	PetJian_FakeObject : SetFakeObject("PetOneType_Pet");
	PetJian_Model_TurnLeft : Enable();
	PetJian_Model_TurnRight: Enable();
	PetJian_NeedLevel      : Show();
	---------------------------------------------------
	--get TakeLevel
	local nTakeLevel = DataPool : PetsOneType_GetAttr(g_CurSel,"takelevel");
	local strNeedLevelColor = "";
	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor ="#cFF0000";
	else
		strNeedLevelColor ="#c00FF00";
	end
	local strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).." c¤p#W mang theo";
	PetJian_NeedLevel:SetText( strNeedLevel );
	-----------------------------------------------------
	--get AttackTrait (ÔİÈ±)
	strName,strIcon = DataPool : PetsOneType_GetAttr(g_CurSel,"attacktype");
	if strIcon ~= "" then
		PetJianAttack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		PetJianAttack_Type : SetToolTip(strName)
		PetJianAttack_Type : Show();
	end
	-----------------------------------------------------
	--get FoodType 
	local food = DataPool : PetsOneType_GetAttr(g_CurSel,"food");
	strName = "";
	if(food >= 1000) then
		strName = strName .. "Th¸t";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "Cö";
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
	PetJianFood_Type : Show();
	PetJianFood_Type : SetToolTip( strName );
end

function PetJian_SelectOneType(typeIdx)
	if(g_CurSel + 1 == typeIdx or typeIdx < 1 or typeIdx > g_petNum) then
		return;
	end
	g_CurSel = typeIdx - 1;
	PetJian_Onshow();
end

function PetJian_List_Click()
	local typeIdx =  PetJian_List : GetFirstSelectItem();
	PetJian_SelectOneType(typeIdx + 1);
end

----------------------------------------------------------------------------------
--
-- Ğı×ª äÊŞÄ£ĞÍ£¨Ïò×ó)
--
function PetJian_Modle_TurnLeft(start)
	--Ïò×óĞı×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetJian_FakeObject:RotateBegin(-0.3);
	--Ïò×óĞı×ª½áÊø
	else
		PetJian_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--Ğı×ª äÊŞÄ£ĞÍ£¨ÏòÓÒ)
--
function PetJian_Modle_TurnRight(start)
	--ÏòÓÒĞı×ª¿ªÊ¼
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetJian_FakeObject:RotateBegin(0.3);
	--ÏòÓÒĞı×ª½áÊø
	else
		PetJian_FakeObject:RotateEnd();
	end
end

function PetJian_OnHiden()
	-- do nothing
	this:Hide()
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function PetJian_Frame_On_ResetPos()

	PetJian_Frame : SetProperty("UnifiedXPosition", g_PetJian_Frame_UnifiedXPosition);
	PetJian_Frame : SetProperty("UnifiedYPosition", g_PetJian_Frame_UnifiedYPosition);

end
