local g_SeventhFestival_PetJian_petNum = 0;
local g_SeventhFestival_PetJian_CurSel = -1;
local g_SeventhFestival_PetJian_Icon = "";

local Max_BtnNum = 10;
local g_SeventhFestival_PetJian_PetNames = {
	"成年珍兽",
	"珍兽宝宝",
	"1级变异",
	"2级变异",
	"3级变异",
	"4级变异",
	"5级变异",
	"6级变异",
	"7级变异",
	"8级变异",
};
local g_SeventhFestival_PetJian_PetNames_HH = {
	"幻化珍兽1",
	"幻化珍兽2",
	"幻化珍兽3",
	"幻化珍兽4",
	"幻化珍兽5",
	"幻化珍兽6",
	"幻化珍兽7",
	"幻化珍兽8",
	"幻化珍兽9",
	"幻化珍兽10",
};

-- 界面的默认相对位置
local g_SeventhFestival_PetJian_Frame_UnifiedXPosition;
local g_SeventhFestival_PetJian_Frame_UnifiedYPosition;

function SeventhFestival_PetJian_PreLoad()
	this:RegisterEvent("OPEN_PETJIAN_DLG_FOR77");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function SeventhFestival_PetJian_OnLoad()

	-- 保存界面的默认相对位置
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

	-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		SeventhFestival_PetJian_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置	
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
	--默认选中最后一个
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
	local strNeedLevel = strNeedLevelColor.."65级及以上#W可携带" --tostring( nTakeLevel ).."级#W可携带";
	SeventhFestival_PetJian_NeedLevel:SetText( strNeedLevel );
	-----------------------------------------------------
	--get AttackTrait (暂缺)
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
		strName = strName .. "肉";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "草";
		food = food - 100;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 10) then
		strName = strName .. "虫";
		food = food - 10;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	
	if(food >= 1) then
		strName = strName .. "谷";
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
-- 旋转珍兽模型（向左)
--
function SeventhFestival_PetJian_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SeventhFestival_PetJian_FakeObject:RotateBegin(-0.3);
	--向左旋转结束
	else
		SeventhFestival_PetJian_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function SeventhFestival_PetJian_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SeventhFestival_PetJian_FakeObject:RotateBegin(0.3);
	--向右旋转结束
	else
		SeventhFestival_PetJian_FakeObject:RotateEnd();
	end
end

function SeventhFestival_PetJian_OnHiden()
	-- do nothing
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function SeventhFestival_PetJian_Frame_On_ResetPos()

	SeventhFestival_PetJian_Frame : SetProperty("UnifiedXPosition", g_SeventhFestival_PetJian_Frame_UnifiedXPosition);
	SeventhFestival_PetJian_Frame : SetProperty("UnifiedYPosition", g_SeventhFestival_PetJian_Frame_UnifiedYPosition);

end
