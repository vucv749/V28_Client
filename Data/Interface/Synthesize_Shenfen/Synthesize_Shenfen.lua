--!!!reloadscript =Synthesize_Shenfen

local Prescr_Ability = -1;
local cur_count = 1;
local Current_Select = -1;
local Material_Icon = {};
local Material_Name = {};
local Material_Frame = {};
local Material_Num  = {};
local Material_Mask  = {};
local SynthesizePucker = {};
local SynthesizeSubPucker = {};
local Synthesize_Shenfen_Special_Item = -1
local ShowBindWin	=	-1
local g_Current_Ability = -1 
local ShowBindByPrescr	= {}
local SpecialItemAcceptID = {
	[21000024] = 1,--冰属性打造素材
	[21000025] = 1,--火属性打造素材
	[21000026] = 1,--玄属性打造素材
	[21000027] = 1,--毒属性打造素材

	-- [21000027] = 1,--定位符打造素材
}

-- 界面的默认相对位置
local g_Synthesize_Shenfen_Frame_UnifiedXPosition;
local g_Synthesize_Shenfen_Frame_UnifiedYPosition;

function Synthesize_Shenfen_PreLoad()
	this:RegisterEvent("OPEN_COMPOSE_SHENFEN");
	-- this:RegisterEvent("OPEN_COMPOSE_ITEM");
	-- this:RegisterEvent("OPEN_COMPOSE_GEM");
	-- this:RegisterEvent("UPDATE_COMPOSE_ITEM");
	-- this:RegisterEvent("TOGLE_SKILL_BOOK");
	-- this:RegisterEvent("TOGLE_COMMONSKILL_PAGE");
	this:RegisterEvent("UPDATE_SHENFEN");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_VIGOR");
	this:RegisterEvent("UINT_IBPOWER");
	this:RegisterEvent("UNIT_ABILITYEXP");
	this:RegisterEvent("UPDATE_LIFESKILL_PAGE");
	this:RegisterEvent("UPDATE_SYNTHESIZE_ITEM");
	this:RegisterEvent("CHANGE_MAKE_COUNT");

	this:RegisterEvent("UI_COMMAND")

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SWITCHMENPAI",true)
end

function Synthesize_Shenfen_OnLoad()

	Material_Icon[1] = Synthesize_Shenfen_MaterialIcon1;
	Material_Icon[2] = Synthesize_Shenfen_MaterialIcon2;
	Material_Icon[3] = Synthesize_Shenfen_MaterialIcon3;
	Material_Icon[4] = Synthesize_Shenfen_MaterialIcon4;
	Material_Icon[5] = Synthesize_Shenfen_MaterialIcon5;

	Material_Name[1] = Synthesize_Shenfen_Material1_Name_Text;
	Material_Name[2] = Synthesize_Shenfen_Material2_Name_Text;
	Material_Name[3] = Synthesize_Shenfen_Material3_Name_Text;
	Material_Name[4] = Synthesize_Shenfen_Material4_Name_Text;
	Material_Name[5] = Synthesize_Shenfen_Material5_Name_Text;

	Material_Frame[1] = Synthesize_Shenfen_MaterialIcon1_Frame;
	Material_Frame[2] = Synthesize_Shenfen_MaterialIcon2_Frame;
	Material_Frame[3] = Synthesize_Shenfen_MaterialIcon3_Frame;
	Material_Frame[4] = Synthesize_Shenfen_MaterialIcon4_Frame;
	Material_Frame[5] = Synthesize_Shenfen_MaterialIcon5_Frame;

	Material_Num[1] =	Synthesize_Shenfen_MaterialIcon1_Amount;
	Material_Num[2] =	Synthesize_Shenfen_MaterialIcon2_Amount;
	Material_Num[3] =	Synthesize_Shenfen_MaterialIcon3_Amount;
	Material_Num[4] =	Synthesize_Shenfen_MaterialIcon4_Amount;
	Material_Num[5] =	Synthesize_Shenfen_MaterialIcon5_Amount;

	Material_Mask[1] =	Synthesize_Shenfen_MaterialIcon1_Mask;
	Material_Mask[2] =	Synthesize_Shenfen_MaterialIcon2_Mask;
	Material_Mask[3] =	Synthesize_Shenfen_MaterialIcon3_Mask;
	Material_Mask[4] =	Synthesize_Shenfen_MaterialIcon4_Mask;

	ShowBindWin = 1

	-- 保存界面的默认相对位置
	g_Synthesize_Shenfen_Frame_UnifiedXPosition	= Synthesize_Shenfen_Frame : GetProperty("UnifiedXPosition");
	g_Synthesize_Shenfen_Frame_UnifiedYPosition	= Synthesize_Shenfen_Frame : GetProperty("UnifiedYPosition");

	Synthesize_Shenfen_Material_Text:Hide()
	Synthesize_Shenfen_SpecialMaterialNum:SetText("")
	Synthesize_Shenfen_SpecialMaterial : SetDrawCorner(3, false);
	Synthesize_Shenfen_CurrentlyEnergy1 : SetToolTip("#{SFJN_231225_83}")
end

function Synthesize_Shenfen_OnEvent(event)

	-- if ( event == "OPEN_COMPOSE_ITEM" ) then
	if ( event == "OPEN_COMPOSE_SHENFEN" ) then
		if(Prescr_Ability ~= tonumber(arg0)) then
			Current_Select = -1;
		end
		g_Current_Ability = tonumber(arg0);
		
		if g_Current_Ability == 65 then
			g_Current_Ability = Player:GetData("IBIDENTITYSKILLID")
			if g_Current_Ability == -1 or g_Current_Ability == nil then
				return
			end
		end
		
		ShowBindWin = 1
		ShowBindByPrescr = {}
		-- 当前身份与技能是否符合
		-- todo
		if Prescr_Ability ~= g_Current_Ability then
			if this:IsVisible() then
				Synthesize_Shenfen_OnHidden()
			end
			Prescr_Ability = g_Current_Ability
			this:Show()
			Synthesize_Shenfen_Update()
		else
			Prescr_Ability = -1
			this:Hide()
		end

		cur_count=1;
		-- this:TogleShow();
		return;
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		Synthesize_Shenfen_UpdateItem();
		return;
	elseif ( event == "UPDATE_SHENFEN" and this:IsVisible() ) then
		this:Hide();
		return;
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 79109901 ) then
		Synthesize_Shenfen_UpdateItem();
		return;
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99859501 ) then
		Synthesize_Shenfen_OnHidden();
		return;
	elseif ( event == "UPDATE_SYNTHESIZE_ITEM" and this:IsVisible() ) then
		if tonumber(arg0)==nil then
			return
		end

		if(Synthesize_Shenfen_SpecialMaterialIcon_Frame:IsVisible())then
			Update_Synthesize_Shenfen_Item(tonumber(arg0));
		end
		return
	elseif ( event == "SWITCHMENPAI" ) then
		Current_Select = -1
		Synthesize_Shenfen_Item_List:ClearListBox()
	elseif ( event == "CLOSE_SYNTHESIZE_ENCHASE" ) then
		this:Hide();
		return;
	-- elseif ( event == "UNIT_VIGOR" and tostring(arg0) == "player" and this:IsVisible()) then
	-- 	strName = Player : GetData("VIGOR");
	-- 	Synthesize_Shenfen_CurrentlyEnergy2 : SetText("当前活力："..strName)
	-- 	return;
	-- elseif ( event == "UNIT_ENERGY" and tostring(arg0) == "player" and this:IsVisible()) then
	-- 	strName = Player : GetData("ENERGY");
	-- 	Synthesize_Shenfen_CurrentlyEnergy2 : SetText("当前精力："..strName)
	-- 	return;
	elseif ( event == "UINT_IBPOWER" and tostring(arg0) == "player" and this:IsVisible()) then
		strName = Player : GetData("IBPOWER");
		Synthesize_Shenfen_CurrentlyEnergy1 : SetText("#{SFJN_231225_22}"..strName)--特殊体力值
		return;
	elseif ( event == "UNIT_ABILITYEXP" and this:IsVisible()) then
		strName = Player : GetAbilityInfo(Prescr_Ability,"skillexp");
		local level= Player:GetAbilityInfo(Prescr_Ability,"level");
		local max_exp
		if level > 12 or level < 1 then
			max_exp = "∞"
		else
			max_exp = LifeAbility : GetLifeAbility_LimitExp(Prescr_Ability,level);
		end

		strName = Player : GetAbilityInfo(Prescr_Ability,"skillexp");
		Synthesize_Shenfen_SkilledGrade:SetText("技能熟练度："..strName.."/"..max_exp);
		return;
	elseif ( event == "UPDATE_LIFESKILL_PAGE" and this:IsVisible()) then
		local szLevel = Player : GetAbilityInfo(Prescr_Ability,"level");
		Synthesize_Shenfen_Level:SetText("技能等级："..szLevel);
		return;
	elseif ( event == "CHANGE_MAKE_COUNT" ) then
		Synthesize_Shenfen_MadeAmount : SetText( tonumber(arg0) );
		cur_count = tonumber(arg0)
		return;

	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		Synthesize_Shenfen_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		Synthesize_Shenfen_Frame_On_ResetPos()
	end

end

function Synthesize_Shenfen_OnShown()
	Synthesize_Shenfen_Update();
end

function Synthesize_Shenfen_UpdateItem()

	local nItemCount = Synthesize_Shenfen_Item_List:GetItemNumber();
	local i;

	for i=1, nItemCount do
		local szItemText, nItemID = Synthesize_Shenfen_Item_List:GetItem(i);

		if nItemID >= 10000 then
			continue;
		end

		local szPrescrName = LifeAbility:LuaFnGetPrescrDetailInfo(nItemID, "Name");
		local nLevel =  LifeAbility:LuaFnGetPrescrDetailInfo(nItemID, "LifeAbility_Level");

		if(nLevel >0) then
			szPrescrName = szPrescrName .. "（等级"..nLevel.."） "
		end

		if 0 == LifeAbility:GetPrescr_IsStudy(nItemID) then
			szPrescrName = szPrescrName .. " #cFF0000[未学会]";
		else
			local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(nItemID);
			if nMaxAmount > 0 then
				szPrescrName = szPrescrName .. "    [" .. nMaxAmount .. "]";
			elseif nMaxAmount < 0 then 
				szPrescrName = szPrescrName .. "    [N/A]";
			end
		end

		Synthesize_Shenfen_Item_List:SetListItemText(i-1, "  "..szPrescrName);
		if(Current_Select == -1 ) then
			Current_Select = i-1
		end

	end
	if Synthesize_Shenfen_Special_Item ~= -1 then
		local theAction = EnumAction(Synthesize_Shenfen_Special_Item, "packageitem");
		local Item_ID = PlayerPackage : GetItemTableIndex(Synthesize_Shenfen_Special_Item);
		if theAction:GetID() == 0 or not SpecialItemAcceptID[Item_ID] then
			LifeAbility : Lock_Packet_Item(Synthesize_Shenfen_Special_Item,0);
			Synthesize_Shenfen_SpecialMaterial : SetActionItem(-1);
			Synthesize_Shenfen_Special_Item = -1
			Synthesize_Shenfen_SpecialMaterialNum:SetText("")
		else
			LifeAbility : Lock_Packet_Item(Synthesize_Shenfen_Special_Item,1);
			Synthesize_Shenfen_SpecialMaterial : SetActionItem(theAction:GetID());
			local holdnum = PlayerPackage : GetBagItemNum(Synthesize_Shenfen_Special_Item);
			if Prescr_Ability ~= 61 then 
				Synthesize_Shenfen_SpecialMaterialNum:SetText("" )
			elseif holdnum > 99 then 
				Synthesize_Shenfen_SpecialMaterialNum:SetText("#cFFF263#e010101∞/3" )
			elseif holdnum >= 3 then 
				Synthesize_Shenfen_SpecialMaterialNum:SetText("#cFFF263#e010101"..holdnum.."/3")
			else
				Synthesize_Shenfen_SpecialMaterialNum:SetText("#cFF0000#e010101"..holdnum.."#cFFF263/3")
			end
		end
	end
	Synthesize_Shenfen_ListBox_Selected();
end

function Synthesize_Shenfen_UpdateList()
	local tabSortGroup = {}
	local tabPrescr = LifeAbility : LuaFnGetAbilityPrescrID(Prescr_Ability);
	for _, nPrescr in pairs(tabPrescr) do 
		local abLevel =  LifeAbility:LuaFnGetPrescrDetailInfo(nPrescr, "LifeAbility_Level");
		local nTypeGroup = LifeAbility:LuaFnGetPrescrDetailInfo(nPrescr, "TypeGroup");
		local nSubTypeGroup = LifeAbility:LuaFnGetPrescrDetailInfo(nPrescr, "SubTypeGroup") or 0;
		local nSelectIndex = nTypeGroup
		if not SynthesizePucker[nSelectIndex] then 
			SynthesizePucker[nSelectIndex] = 1
		end
		nSelectIndex = nTypeGroup*100 + nSubTypeGroup
		if not SynthesizePucker[nSelectIndex] then 
			SynthesizePucker[nSelectIndex] = 1
		end
		table.insert(tabSortGroup, {nId = nPrescr, nLevel=abLevel, nFirst=nTypeGroup, nSecond=nSubTypeGroup, nSortIdx = nSelectIndex})
	end
	table.sort(tabSortGroup, function(a, b)
			if a.nSortIdx ~= b.nSortIdx then 
				return a.nSortIdx < b.nSortIdx
			elseif a.nLevel ~= b.nLevel then 
				return a.nLevel < b.nLevel
			end
			return a.nId < b.nId
		end)

	Synthesize_Shenfen_Item_List:ClearListBox();
	local nGroup1, nGroup2 = -1, -1
	local isShow1, isShow2 = 1, 1
	for i, v in pairs(tabSortGroup) do 
		local nPrescr = v.nId
		local nTypeGroup = v.nFirst
		local nSubTypeGroup = v.nSecond

		local nSelectIndex = 0
		local isItemShow = 1
		local strName = ""
		-- 一级页签
		nSelectIndex = nTypeGroup
		if nTypeGroup <= 0 then 
			isShow1 = 0
		elseif nGroup1 ~= nTypeGroup then 
			nGroup1 = nTypeGroup
			nGroup2 = -1
			strName= LifeAbility :GetPrescription_Kind(nTypeGroup)
			if ( SynthesizePucker[nSelectIndex] > 0 ) then
				strName= "- #gFE7E82" .. strName;
				isShow1 = 1
			else
				strName= "+ #gFE7E82" .. strName;
				isShow1 = 0
			end
			Synthesize_Shenfen_Item_List:AddItem(strName,10000+nSelectIndex);
		end

		-- 二级页签
		nSelectIndex = nTypeGroup*100 + nSubTypeGroup
		if nSubTypeGroup > 0 and nGroup2 ~= nSubTypeGroup then 
			nGroup2 = nSubTypeGroup
			if isShow1 == 1 then
				strName= LifeAbility :GetPrescription_Kind(nSubTypeGroup)
				if ( SynthesizePucker[nSelectIndex] > 0 ) then
					strName= " - #gFE7E82" .. strName;
					isShow2 = 1
				else
					strName= " + #gFE7E82" .. strName;
					isShow2 = 0
				end
				Synthesize_Shenfen_Item_List:AddItem(strName,10000+nSelectIndex);
			end
		end
		-- 配方目录
		if isShow1==1 and isShow2==1 then
			local szPrescrName = LifeAbility:LuaFnGetPrescrDetailInfo(nPrescr, "Name");
			local nLevel =  LifeAbility:LuaFnGetPrescrDetailInfo(nPrescr, "LifeAbility_Level");
			local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(nPrescr);

			if(nLevel >0) then
				szPrescrName = szPrescrName .. "（等级"..nLevel.."） "
			end

			if 0 == LifeAbility:GetPrescr_IsStudy(nPrescr) then
				szPrescrName = szPrescrName .. " #cFF0000[未学会]";
			else
				local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(nPrescr);
				if nMaxAmount > 0 then
					szPrescrName = szPrescrName .. "    [" .. nMaxAmount .. "]";
				elseif nMaxAmount < 0 then 
					szPrescrName = szPrescrName .. "    [N/A]";
				end
			end

			Synthesize_Shenfen_Item_List:AddItem("  "..szPrescrName, nPrescr);
			if(Current_Select == -1 ) then
				Current_Select = nPrescr
			end
			if(Current_Select == nPrescr) then
				Synthesize_Shenfen_Item_List : SetItemSelectByItemID(Current_Select);
			end
		end
	end

	for i=1, 4 do
		Material_Num[i]	 : SetText("");
		Material_Num[i]  : Hide();
		Material_Icon[i] : Hide();
		Material_Name[i] : SetText("");
	end
	Synthesize_Shenfen_Item_Frame : Hide();
	Synthesize_Shenfen_Amount : SetText("");
	Synthesize_Shenfen_Item_Name_Text : SetText("");

	Synthesize_Shenfen_AllMake:Show();
	Synthesize_Shenfen_SpecialMaterial_Text : Show();
	Synthesize_Shenfen_SpecialMaterialIcon_Frame : Show()

	Synthesize_Shenfen_AllMake : Disable();
	Synthesize_Shenfen_Make : Disable();

	Synthesize_Shenfen_Explain:SetText("");
	Synthesize_Shenfen_Explain:Show();

	Synthesize_Shenfen_Resume()
	Synthesize_Shenfen_ListBox_Selected()
end

function Synthesize_Shenfen_Update()
	local strName;

	strName = Player : GetAbilityInfo(Prescr_Ability,"name");
	Synthesize_Shenfen_PageHeader_Name:SetText("#gFF0FA0"..strName);

	strName = Player : GetAbilityInfo(Prescr_Ability,"level");
	local level = tonumber(strName);
	Synthesize_Shenfen_Level:SetText("技能等级："..strName);

	local max_exp;
	if level > 11 or level < 1 then
		max_exp = "∞"
	else
		max_exp = LifeAbility : GetLifeAbility_LimitExp(Prescr_Ability,level);
	end

	strName = Player : GetAbilityInfo(Prescr_Ability,"skillexp");
	Synthesize_Shenfen_SkilledGrade:SetText("技能熟练度："..strName.."/"..max_exp);

	-- strName = Player : GetData("VIGOR");
	-- Synthesize_Shenfen_CurrentlyEnergy2 : SetText("当前活力："..strName)

	-- strName = Player : GetData("ENERGY");
	-- Synthesize_Shenfen_CurrentlyEnergy2 : SetText("当前精力："..strName)
	Synthesize_Shenfen_CurrentlyEnergy2 : SetText("")

	strName = Player : GetData("IBPOWER");
	Synthesize_Shenfen_CurrentlyEnergy1 : SetText("#{SFJN_231225_22}"..strName)--特殊体力值

	Synthesize_Shenfen_MadeAmount : SetText( tonumber(cur_count));

	if Prescr_Ability == 60 then 
		Synthesize_Shenfen_LianYao:Show()
	else
		Synthesize_Shenfen_LianYao:Hide()
	end

	Synthesize_Shenfen_UpdateList()

end

function Synthesize_Shenfen_Add_Clicked()
	if(cur_count < 20) then
		cur_count = cur_count + 1;
		Synthesize_Shenfen_MadeAmount : SetText( tonumber(cur_count));
	end
end

function Synthesize_Shenfen_Minus_Clicked()
	if(cur_count > 1) then
		cur_count = cur_count - 1;
		Synthesize_Shenfen_MadeAmount : SetText( tonumber(cur_count));
	end
end

-- add by cuiyinjie 2008-10-25 在未选中配方时清除配方所需材料
function Synthesize_Shenfen_HideCtrlOnNoSelect()
	local i = 1;
	for i=1, 4 do
		Material_Num[i]	 : SetText("");
		Material_Num[i]  : Hide();
		Material_Icon[i] : Hide();
		Material_Name[i] : SetText("");
	end

	Synthesize_Shenfen_Item : SetProperty("ShortImage","");   --设置为无图标
	Synthesize_Shenfen_Item_Name_Text : SetText("");
	Synthesize_Shenfen_Amount : SetText("");
end

-- 整体隐藏手工装备保星信息
function Synthesize_Shenfen_HideEquipMakeNewLuckyInfo()
	-- PushDebugMessage("Synthesize_Shenfen_HideEquipMakeNewLuckyInfo")
	Synthesize_Shenfen_SpecialMaterial_SkilledAllNum : Hide()
end

-- 手工装备保星相关帮助
function Synthesize_Shenfen_ClickEquipMakeNewHelp(nHelpIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ShowHelp" )
		Set_XSCRIPT_ScriptID(791099)
		Set_XSCRIPT_Parameter(0, nHelpIndex)			
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Synthesize_Shenfen_ListBox_Selected()

	-- 整体隐藏手工装备保星信息
	Synthesize_Shenfen_HideEquipMakeNewLuckyInfo()

	local nSelIndex = Synthesize_Shenfen_Item_List:GetFirstSelectItem();
	local nPrescrNum = DataPool:GetPrescrList_Num();

	-- PushDebugMessage("todo:0000 nSelIndex:"..nSelIndex.." Current_Select:"..Current_Select)
	if nSelIndex > 10000 then
		local nIndex= nSelIndex-10000
		if SynthesizePucker[nIndex] == 1 then
			SynthesizePucker[nIndex] = 0;
		else
			SynthesizePucker[nIndex] = 1;
		end
		Synthesize_Shenfen_Update();
		return
	end
	if nSelIndex == -1 then
		if Current_Select == -1 then
			--Begin Modify By Ma Liang TT 69445
			Synthesize_Shenfen_MadeAmount_Bk : Show()
			Synthesize_Shenfen_Decrease : Show()
			Synthesize_Shenfen_More : Show()
			--End
			return;
		else
			nSelIndex = Current_Select;
		end
	elseif nSelIndex ~= Current_Select then
		cur_count = 1
		Synthesize_Shenfen_MadeAmount : SetText( tonumber(cur_count));
	end

	Current_Select = nSelIndex;

	for i=1, 4 do
		Material_Num[i]	 : SetText("");
		Material_Num[i]  : Hide();
		Material_Icon[i] : Hide();
		Material_Name[i] : SetText("");
	end

	Synthesize_Shenfen_Item_Frame : Hide();
	Synthesize_Shenfen_Item : Hide();
	Synthesize_Shenfen_Item_Name_Text : SetText("");
	Synthesize_Shenfen_Amount : SetText("");

	-- PushDebugMessage("todo:000 nSelIndex:"..nSelIndex)
	if( nSelIndex < 0 ) then
		return;
	end

	local resultid,resultnum = LifeAbility : Get_Test_Prescr_Item(nSelIndex, 0);
	-- PushDebugMessage("todo:111 nSelIndex:"..nSelIndex.." resultid:"..resultid)
	-- local nLevel =  LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "LifeAbility_Level");
	local tabMaterials = LifeAbility : GetPrescr_HelpMaterialIds(nSelIndex, 0);
	local haveSpecialMaterial = 0
	SpecialItemAcceptID = {}
	local item_index = -1
	if table.getn(tabMaterials) > 0 then 
		haveSpecialMaterial = 1
		if Prescr_Ability == 61 then 
			-- 产出Id显示成ItemCompoundHelper.txt配的产出Id
			item_index = tabMaterials[1]
		end
		for i, v in pairs(tabMaterials) do 
			SpecialItemAcceptID[v] = 1
			-- PushDebugMessage("tabMaterials nSelIndex:"..nSelIndex.." i:"..i.." v:"..v)
		end
	end
	local myMenpai = Player : GetData("MEMPAI")
	if Synthesize_Shenfen_Special_Item ~= -1 then 
		item_index = PlayerPackage : GetItemTableIndex(Synthesize_Shenfen_Special_Item);
	end
	local nHelperNum = LifeAbility : GetPrescr_HelpPrescrCount(nSelIndex);
	local helperId = LifeAbility : GetPrescr_HelpResultId(nSelIndex, item_index, myMenpai);
	if helperId ~= -1 then 
		resultid = helperId 
	end
	if nHelperNum > 0 then 
		resultnum = 1
	end

	if(resultid == -1 and nHelperNum == 0) then
		Synthesize_Shenfen_Explain:SetText(LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "Explain"));
		Synthesize_Shenfen_Explain:Show();
		Synthesize_Shenfen_AllMake : Enable();
		Synthesize_Shenfen_Make : Enable();
		--Begin Modify By MaLiang TT 69445
		Synthesize_Shenfen_AllMake : Show()
		Synthesize_Shenfen_MadeAmount_Bk : Show()
		Synthesize_Shenfen_Decrease : Show()
		Synthesize_Shenfen_More : Show()
		--End
		return;
	else
		Synthesize_Shenfen_Explain:Hide();
	end

	if resultid == -1 then 
		Synthesize_Shenfen_Item_Frame : Show();
		Synthesize_Shenfen_Item : SetProperty("ShortImage","");
		Synthesize_Shenfen_Item : Show();

		Synthesize_Shenfen_Amount : Hide();
		Synthesize_Shenfen_Item_Name_Text : SetText("");
		Synthesize_Shenfen_Item_Name_Text : Show();
	else
		Synthesize_Shenfen_Item_Frame : Show();
		local name,icon = LifeAbility : GetPrescr_Material(resultid);
		Synthesize_Shenfen_Item : SetProperty("ShortImage",icon);
		Synthesize_Shenfen_Item : Show();

		Synthesize_Shenfen_Amount : SetText("#e010101" .. resultnum);
		Synthesize_Shenfen_Amount : Show();
		if Prescr_Ability == 60 then 
			-- 特写：身份制药产出数量是概率随机的，故隐藏
			Synthesize_Shenfen_Amount : Hide();
		end

		Synthesize_Shenfen_Item_Name_Text : SetText(name);
		Synthesize_Shenfen_Item_Name_Text : Show();
	end

	local NeedSpecial = LifeAbility : GetPrescr_Item_IsNeedSpecial( nSelIndex )
	Synthesize_Shenfen_SpecialMaterialIcon_Frame : Show();
	Synthesize_Shenfen_SpecialMaterial_Text : Show();
	if Prescr_Ability == 61 and haveSpecialMaterial == 1 then
		Synthesize_Shenfen_SpecialMaterial_WarningText : SetText("#cE6BA00请在右边放入打造材料#cFFFF00属性材料#cE6BA00，这类特殊材料可以提升装备的品质")
		if NeedSpecial == 6 then 
			Synthesize_Shenfen_SpecialMaterial : SetToolTip("#{SFJN_231225_73}")--特殊属性材料:凡品
		elseif NeedSpecial == 7 then 
			Synthesize_Shenfen_SpecialMaterial : SetToolTip("#{SFJN_231225_84}")--特殊属性材料:凡品
		elseif NeedSpecial == 8 then 
			Synthesize_Shenfen_SpecialMaterial : SetToolTip("#{SFJN_231225_85}")--特殊属性材料:凡品
		elseif NeedSpecial == 9 then 
			Synthesize_Shenfen_SpecialMaterial : SetToolTip("#{SFJN_231225_86}")--特殊属性材料:凡品
		else
			Synthesize_Shenfen_SpecialMaterial : SetToolTip("找程序特写:"..NeedSpecial)--特殊属性材料:凡品
		end
		Synthesize_Shenfen_SpecialMaterial:SetProperty( "DragAcceptName", "N4" );
		-- Synthesize_Shenfen_SpecialMaterial:SetProperty("BackImage", "")
	elseif Prescr_Ability == 62 and haveSpecialMaterial == 1 then
		Synthesize_Shenfen_SpecialMaterial_WarningText : SetText("#cE6BA00请在右边放入打造材料#cFFFF00属性材料#cE6BA00，这类特殊材料可以提升装备的品质")
		if nSelIndex == 1358 then 
			Synthesize_Shenfen_SpecialMaterial : SetToolTip("#{SFDJ_240117_108}")--定位符材料
			Synthesize_Shenfen_SpecialMaterial:SetProperty( "DragAcceptName", "N5" );
			-- Synthesize_Shenfen_SpecialMaterial:SetProperty("BackImage", "set:SongLiao02 image:SL_BH_Big2_Dis")
		elseif nSelIndex == 1367 then 
			Synthesize_Shenfen_SpecialMaterial : SetToolTip("请放入小喇叭")--奇闻小喇叭材料
			Synthesize_Shenfen_SpecialMaterial:SetProperty( "DragAcceptName", "N6" );
			-- Synthesize_Shenfen_SpecialMaterial:SetProperty("BackImage", "set:SongLiao02 image:SL_BH_Big2_Dis")
		else
			Synthesize_Shenfen_SpecialMaterial : SetToolTip("ItemCompoundHelper有配特殊材料,找程序特写")
		end
	elseif haveSpecialMaterial == 1 then 
		Synthesize_Shenfen_SpecialMaterial : SetToolTip("ItemCompoundHelper有配特殊材料,找程序特写")
	elseif NeedSpecial > 0 then 
		Synthesize_Shenfen_SpecialMaterial : SetToolTip("ItemCompound.txt有配特殊材料,找程序要特写")
	else
		Synthesize_Shenfen_SpecialMaterial_Text : Hide();
		Synthesize_Shenfen_SpecialMaterialIcon_Frame : Hide()
		Synthesize_Shenfen_SpecialMaterial:SetProperty( "DragAcceptName", "N" );
	end
	if(Synthesize_Shenfen_Special_Item ~= -1 and not SpecialItemAcceptID[item_index])then
		LifeAbility : Lock_Packet_Item(Synthesize_Shenfen_Special_Item,0);
		Synthesize_Shenfen_SpecialMaterial : SetActionItem(-1);
		Synthesize_Shenfen_Special_Item	= -1;
		Synthesize_Shenfen_SpecialMaterialNum:SetText("")
	end

	local tip_name,tip_type,tip_level = LifeAbility : GetPrescr_Material_Tooltip(resultid);
	-- local Consume_Vigor,Consume_Energy = LifeAbility : GetPrescr_Consume_Vigor_Energy(nSelIndex);
	-- local Consume_Attr = LifeAbility : GetPrescr_Consume_ContriAttr(nSelIndex);
	local Consume_Shengong = LifeAbility : GetPrescr_Consume_ShengongAttr(nSelIndex);
	Synthesize_Shenfen_CurrentlyEnergy2 : SetText("#{SFJN_231225_82}"..Consume_Shengong)--神工值消耗
	-- local strName = ""
	-- if Consume_Vigor >= 0 then
	-- 	strName = strName .. "#r基础活力消耗：".. tostring(Consume_Vigor);
	-- end

	-- if Consume_Energy >= 0 then
	-- 	strName = strName .. "#r消耗精力：".. tostring(Consume_Energy);
	-- end

	-- if Consume_Attr >= 0 then
	-- 	strName = strName .. "#r消耗门派贡献度：".. tostring(Consume_Attr);
	-- end

	-- if resultnum == -1 or resultid == -1 then
	-- 	Synthesize_Shenfen_Item : SetToolTip(tip_name.."#r类型："..tip_type..strName);
	-- 	Synthesize_Shenfen_Amount:SetToolTip(tip_name.."#r类型："..tip_type..strName);
	-- end

	local Material_number = LifeAbility : GetPrescr_Material_Number(nSelIndex);
	if(Material_number < 1) then
		--Begin Modify By Ma Liang TT 69445
		Synthesize_Shenfen_MadeAmount_Bk : Show()
		Synthesize_Shenfen_Decrease : Show()
		Synthesize_Shenfen_More : Show()
		--End
		Synthesize_Shenfen_AllMake : Enable();
		Synthesize_Shenfen_Make : Enable();
		-- PushDebugMessage("todo:344 nSelIndex:"..nSelIndex)
		return;
	end

	-- PushDebugMessage("todo:444 nSelIndex:"..nSelIndex)
	for	i=1, 4 do
	  local stuffid,stuffnum = LifeAbility : Get_Test_Prescr_Item(nSelIndex,i);

		if(stuffid == -1) then
			Material_Num[i]	 : SetText("");
			Material_Icon[i] : Hide();
		else
			name,icon = LifeAbility : GetPrescr_Material(stuffid);
			local holdnum = LifeAbility : GetPrescr_Material_Hold_Count(nSelIndex,i);
			Material_Icon[i] : SetProperty("ShortImage",icon);
			Material_Icon[i] : Show();
			Material_Name[i] : SetText(name);
			if holdnum > 99 then
				Material_Num[i]  : SetText("#e010101∞/" .. stuffnum);
			else
				Material_Num[i]  : SetText("#e010101" .. holdnum .. "/" .."#e010101" .. stuffnum);
			end
			if( holdnum < stuffnum ) then
				Material_Mask[ i ]:Show();
			else
				Material_Mask[ i ]:Hide();
			end
			Material_Num[i]  : Show();
			Material_Frame[i]: Show();
			tip_name,tip_type,tip_level = LifeAbility : GetPrescr_Material_Tooltip(stuffid);
		end
	end

	local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(nSelIndex);
	if(nMaxAmount == 0) then
		Synthesize_Shenfen_AllMake : Disable();
		Synthesize_Shenfen_Make : Disable();
	elseif LifeAbility:GetPrescr_IsStudy(nSelIndex) == 0 then 
		Synthesize_Shenfen_AllMake : Disable();
		Synthesize_Shenfen_Make : Disable();
	elseif Synthesize_Shenfen_SpecialMaterialIcon_Frame:IsVisible() and Synthesize_Shenfen_Special_Item == -1 then 
		Synthesize_Shenfen_AllMake : Disable();
		Synthesize_Shenfen_Make : Disable();
	else
		Synthesize_Shenfen_AllMake : Enable();
		Synthesize_Shenfen_Make : Enable();
	end

	if Prescr_Ability == 46 or Prescr_Ability == 47 or Prescr_Ability == 48 or Prescr_Ability == 61
		or (Prescr_Ability == 62 and haveSpecialMaterial == 1) then
	--当精炼精制精工时，隐藏“全部制作”按钮
		Synthesize_Shenfen_AllMake : Hide()
		Synthesize_Shenfen_MadeAmount_Bk : Hide()
		Synthesize_Shenfen_Decrease : Hide()
		Synthesize_Shenfen_More : Hide()
	else
		Synthesize_Shenfen_AllMake : Show()
		Synthesize_Shenfen_MadeAmount_Bk : Show()
		Synthesize_Shenfen_Decrease : Show()
		Synthesize_Shenfen_More : Show()
	end

	-- “特殊材料”的处理
	-- 由于现在config.txt表中的数据已经变的不可信任（很多东西都是因为在已经定好的规则上，策划添错表），这里写死特例
	-- 只有“精炼”、“精制”、“精工”时候，才从表里判断是否需要特殊材料，不再单纯依靠表来判断
	if Prescr_Ability == 46 or Prescr_Ability == 47 or Prescr_Ability == 48 then
		local NeedSpecial = LifeAbility : GetPrescr_Item_IsNeedSpecial( nSelIndex ) --取得是否需要特殊材料
		-- 0：精铁
		-- 1：棉布
		-- 2：秘银
		if NeedSpecial >= 0 then
			local SItem = Synthesize_Shenfen_SpecialMaterial:GetActionItem() --检测框里有没有放入特殊材料
			if SItem > 0 and nMaxAmount > 0 then
				Synthesize_Shenfen_Make : Enable();
			else
				Synthesize_Shenfen_Make : Disable();
			end
		else
			Synthesize_Shenfen_SpecialMaterial_Text : Hide();
			Synthesize_Shenfen_SpecialMaterialIcon_Frame : Hide()
			if(Synthesize_Shenfen_Special_Item ~= -1)then
				LifeAbility : Lock_Packet_Item(Synthesize_Shenfen_Special_Item,0);
				Synthesize_Shenfen_SpecialMaterial : SetActionItem(-1);
				Synthesize_Shenfen_Special_Item	= -1;
				Synthesize_Shenfen_SpecialMaterialNum:SetText("")
			end
		end
	end

	-- ++++begin  add by cuiyinjie 2008-10-25 在未选中配方时清除配方所需材料
	if ( Synthesize_Shenfen_Item_List:GetFirstSelectItem() < 0 ) then
		-- PushDebugMessage("todo:555 nSelIndex:"..nSelIndex)
		Synthesize_Shenfen_HideCtrlOnNoSelect();
	end
	-- +++++end

end

--显示道具的ToolTips
function Synthesize_Shenfen_OnShowToolTip(who)
	local nSelIndex = Synthesize_Shenfen_Item_List:GetFirstSelectItem();
	local left, right, top, bottom;
	local itemID = 0;
	local stuffnum = 0;

	-- begin +++++++++++ add by cuiyinjie 2008-10-25 for bug TT40225, 没选中配方时显示tip客户端报错
	if ( nSelIndex < 0 ) then
	   return;
	end
	-- end +++++++++++

	if who == 0 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex, 0);
		left, right, top, bottom = Synthesize_Shenfen_Item :GetPixelRect();
		local item_index = -1
		local myMenpai = Player : GetData("MEMPAI")
		local tabMaterials = LifeAbility : GetPrescr_HelpMaterialIds(nSelIndex, 0);
		if table.getn(tabMaterials) > 0 and Prescr_Ability == 61 then 
			-- 产出Id显示成ItemCompoundHelper.txt配的产出Id
			item_index = tabMaterials[1]
		end
		if Synthesize_Shenfen_Special_Item ~= -1 then 
			item_index = PlayerPackage : GetItemTableIndex(Synthesize_Shenfen_Special_Item);
		end
		local helperId = LifeAbility : GetPrescr_HelpResultId(nSelIndex, item_index, myMenpai);
		if helperId ~= -1 then 
			itemID = helperId 
		end
	elseif who == 1 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex,1);
		left, right, top, bottom = Synthesize_Shenfen_MaterialIcon1_Mask :GetPixelRect();
	elseif who == 2 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex,2);
		left, right, top, bottom = Synthesize_Shenfen_MaterialIcon2_Mask :GetPixelRect();
	elseif who == 3 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex,3);
		left, right, top, bottom = Synthesize_Shenfen_MaterialIcon3_Mask :GetPixelRect();
	elseif who == 4 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex,4);
		left, right, top, bottom = Synthesize_Shenfen_MaterialIcon4_Mask :GetPixelRect();
	end



	LifeAbility:ShowSuperToolTip(itemID, true,left,top,right,bottom);
end

--隐藏道具的ToolTips
function Synthesize_Shenfen_OnHideToolTip()
	LifeAbility:ShowSuperToolTip(1, false);
end

function Synthesize_Shenfen_Do_Clicked()

	local Notify = 0;
	local Is_Special_Item_Bind = 0
	if Synthesize_Shenfen_Special_Item ~= -1 then
		local Item_ID = PlayerPackage : GetItemTableIndex(Synthesize_Shenfen_Special_Item);
		if not SpecialItemAcceptID[Item_ID] then 
			PushDebugMessage("#{_ITEM".. Item_ID .."}不能用于合成。")
			return;
		end
		Is_Special_Item_Bind = PlayerPackage : GetItemBindStatusByIndex(Synthesize_Shenfen_Special_Item);
	end

	local nSelIndex = Synthesize_Shenfen_Item_List:GetFirstSelectItem();
	local nPrescrNum = DataPool:GetPrescrList_Num();
	local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(Current_Select);
	local nMake_Count = tonumber(Synthesize_Shenfen_MadeAmount:GetText());
	if( nMaxAmount == -1 ) then
		nMaxAmount = 99;
	end

	--判断绑定
	if Prescr_Ability >= 59 or Prescr_Ability <= 62 then
		if not ShowBindByPrescr[nSelIndex] then
			if (Prescr_Ability == 59 and LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "LifeAbility_Level")>=10)
				or (Prescr_Ability == 60 and LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "LifeAbility_Level")>=10)
				or (Prescr_Ability == 61 and LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "LifeAbility_Level")>=10)
				or (Prescr_Ability == 62 and LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "LifeAbility_Level")>=10)
				or nSelIndex == 1210 --30007030龙隐丹
				or nSelIndex == 1365 --38003060高级烟花喷射器
				or nSelIndex == 1373 --38003082雷珠
				or nSelIndex == 1374 --38003083替身纸人
				or nSelIndex == 1375 then --38003084三才战旗
				PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{SFJN_231225_154}")
				ShowBindByPrescr[nSelIndex] = 1
				return
			else
				for	i=1, 4 do
		  			local stuffid,stuffnum = DataPool:GetPrescrList_Item_Requirement(nSelIndex,i);
					if(stuffid ~= -1) then
						local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(stuffid));
						if(BindState == 1)then
							PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{SFJN_231225_48}")
							ShowBindByPrescr[nSelIndex] = 1
							return
						end
					end
				end
				if Is_Special_Item_Bind == 1 then
					PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{SFJN_231225_48}")
					ShowBindByPrescr[nSelIndex] = 1
					return
				end
			end
		end
	end

	if(Current_Select <= 0 ) then
		return;
	end

	if nMake_Count > nMaxAmount then
		PushDebugMessage("材料不足！")
		return;
	end

	ComposeItem_Begin(Current_Select,nMake_Count,Synthesize_Shenfen_Special_Item);
end

function Synthesize_Shenfen_Do_All_Clicked()

	local Is_Special_Item_Bind = 0
	if Synthesize_Shenfen_Special_Item ~= -1 then
		local Item_ID = PlayerPackage : GetItemTableIndex(Synthesize_Shenfen_Special_Item);
		if not SpecialItemAcceptID[Item_ID] then 
			PushDebugMessage("#{_ITEM".. Item_ID .."}不能用于合成。")
			return
		end
		Is_Special_Item_Bind = PlayerPackage : GetItemBindStatusByIndex(Synthesize_Shenfen_Special_Item);
	end

	local nSelIndex = Synthesize_Shenfen_Item_List:GetFirstSelectItem();
	local nPrescrNum = DataPool:GetPrescrList_Num();
	local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(Current_Select);

	if(Current_Select <= 0 ) then
		return;
	end

	if( nMaxAmount == -1 ) then
		nMaxAmount = 99;
	end

	if Prescr_Ability >= 59 or Prescr_Ability <= 62 then
		if not ShowBindByPrescr[nSelIndex] then
			if (Prescr_Ability == 59 and LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "LifeAbility_Level")>=10)
				or (Prescr_Ability == 60 and LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "LifeAbility_Level")>=10)
				or (Prescr_Ability == 61 and LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "LifeAbility_Level")>=10)
				or (Prescr_Ability == 62 and LifeAbility:LuaFnGetPrescrDetailInfo(nSelIndex, "LifeAbility_Level")>=10)
				or nSelIndex == 1210 --30007030龙隐丹
				or nSelIndex == 1365 --38003060高级烟花喷射器
				or nSelIndex == 1373 --38003082雷珠
				or nSelIndex == 1374 --38003083替身纸人
				or nSelIndex == 1375 then --38003084三才战旗
				PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{SFJN_231225_154}")
				ShowBindByPrescr[nSelIndex] = 1
				return
			else
				for	i=1, 4 do
		  			local stuffid,stuffnum = DataPool:GetPrescrList_Item_Requirement(nSelIndex,i);
					if(stuffid ~= -1) then
						local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(stuffid));
						if(BindState == 1)then
							PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{SFJN_231225_48}")
							ShowBindByPrescr[nSelIndex] = 1
							return;
						end
					end
				end
				if Is_Special_Item_Bind == 1 then
					PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{SFJN_231225_48}")
					ShowBindByPrescr[nSelIndex] = 1
					return
				end
			end
		end
	end

	ComposeItem_Begin(Current_Select,nMaxAmount,Synthesize_Shenfen_Special_Item);
end

function Synthesize_Shenfen_Cancel_Clicked()
	if( Synthesize_Shenfen_Special_Item ~= -1 ) then
		LifeAbility : Lock_Packet_Item(Synthesize_Shenfen_Special_Item,0);
		Synthesize_Shenfen_SpecialMaterial : SetActionItem(-1);
		Synthesize_Shenfen_Special_Item	= -1;
		Synthesize_Shenfen_SpecialMaterialNum:SetText("")
	end
	Current_Select = -1;
	this:Hide();
	return;
end

function Update_Synthesize_Shenfen_Item(Item_index)

	local index = tonumber(Item_index)
	local theAction = EnumAction(index, "packageitem");

	if theAction:GetID() ~= 0 then
		local Item_Quality = PlayerPackage : GetItemSubTableIndex(index,1)
		local Item_Class = PlayerPackage : GetItemSubTableIndex(index,0)
		local Item_ID = PlayerPackage : GetItemTableIndex(index)

		if not SpecialItemAcceptID[Item_ID] then 
			local Item_ID = PlayerPackage : GetItemTableIndex(index)
			local szName = LifeAbility:GetPrescr_Material(Item_ID)
			PushDebugMessage("#B"..szName.."#W不能用于此配方#W。")
			return
		end

		if Synthesize_Shenfen_Special_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(Synthesize_Shenfen_Special_Item,0);
		end

		Synthesize_Shenfen_SpecialMaterial:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(index,1);
		Synthesize_Shenfen_Special_Item = index
		local holdnum = PlayerPackage : GetBagItemNum(Synthesize_Shenfen_Special_Item);
		if Prescr_Ability ~= 61 then 
			Synthesize_Shenfen_SpecialMaterialNum:SetText("" )
		elseif holdnum > 99 then 
			Synthesize_Shenfen_SpecialMaterialNum:SetText("#cFFF263#e010101∞/3" )
		elseif holdnum >= 3 then 
			Synthesize_Shenfen_SpecialMaterialNum:SetText("#cFFF263#e010101"..holdnum.."/3")
		else
			Synthesize_Shenfen_SpecialMaterialNum:SetText("#cFF0000#e010101"..holdnum.."#cFFF263/3")
		end
	else
		Synthesize_Shenfen_SpecialMaterial:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Synthesize_Shenfen_Special_Item,0);
		Synthesize_Shenfen_Special_Item = -1;
		Synthesize_Shenfen_SpecialMaterialNum:SetText("")
	end

end

function Synthesize_Shenfen_Resume()
	if(Synthesize_Shenfen_Special_Item ~= -1) then
		LifeAbility : Lock_Packet_Item(Synthesize_Shenfen_Special_Item,0);
		Synthesize_Shenfen_SpecialMaterial : SetActionItem(-1);
		Synthesize_Shenfen_Special_Item	= -1;
		Synthesize_Shenfen_SpecialMaterialNum:SetText("")
	end
end

function Synthesize_Shenfen_OnHidden()
	ShowBindWin = 1
	ShowBindByPrescr = {}
	Prescr_Ability = -1
	cur_count=1
	Synthesize_Shenfen_Cancel_Clicked()
end

function Synthesize_Shenfen_IsBind( ItemID )
	if(GetItemBindStatus(ItemID) == 1) then
		return 1;
	else
		return 0;
	end
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Synthesize_Shenfen_Frame_On_ResetPos()
	Synthesize_Shenfen_Frame : SetProperty("UnifiedXPosition", g_Synthesize_Shenfen_Frame_UnifiedXPosition);
	Synthesize_Shenfen_Frame : SetProperty("UnifiedYPosition", g_Synthesize_Shenfen_Frame_UnifiedYPosition);
end
