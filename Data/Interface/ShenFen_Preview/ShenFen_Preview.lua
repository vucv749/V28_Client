
--!!!reloadscript =ShenFen_Preview

local g_ShenFen_Prescr_Ability = -1
local g_ShenFen_CurSelect = -1
local g_ShenFen_CurIdentity = -1 
local g_ShenFen_CurAbility = -1 

local g_ShenFen_Material_Icon = {};
local g_ShenFen_Material_Name = {};
local g_ShenFen_Material_Frame = {};
local g_ShenFen_Material_Num  = {};
local g_ShenFen_Material_Mask  = {};

local ShenFen_SynthesizePucker = {};
local ShenFen_Preview_Title = {
[1] = "#{YCGZ_231225_76}",
[2] = "#{YCGZ_231225_77}", 
[3] = "#{YCGZ_231225_78}",
[4] = "#{YCGZ_231225_79}", 
}

local objCared = -1;
local g_ServerCareID = -1;
local MAX_OBJ_DISTANCE = 3.0;

-- 界面的默认相对位置
local g_ShenFen_Preview_Frame_UnifiedXPosition;
local g_ShenFen_Preview_Frame_UnifiedYPosition;

function ShenFen_Preview_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	
	this:RegisterEvent("SWITCHSHENFEN",true)
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE");

	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function ShenFen_Preview_OnLoad()

	g_ShenFen_Material_Icon[1] = ShenFen_Preview_MaterialIcon1;
	g_ShenFen_Material_Icon[2] = ShenFen_Preview_MaterialIcon2;
	g_ShenFen_Material_Icon[3] = ShenFen_Preview_MaterialIcon3;
	g_ShenFen_Material_Icon[4] = ShenFen_Preview_MaterialIcon4;
	g_ShenFen_Material_Icon[5] = ShenFen_Preview_MaterialIcon5;

	g_ShenFen_Material_Name[1] = ShenFen_Preview_Material1_Name_Text;
	g_ShenFen_Material_Name[2] = ShenFen_Preview_Material2_Name_Text;
	g_ShenFen_Material_Name[3] = ShenFen_Preview_Material3_Name_Text;
	g_ShenFen_Material_Name[4] = ShenFen_Preview_Material4_Name_Text;
	g_ShenFen_Material_Name[5] = ShenFen_Preview_Material5_Name_Text;

	g_ShenFen_Material_Frame[1] = ShenFen_Preview_MaterialIcon1_Frame;
	g_ShenFen_Material_Frame[2] = ShenFen_Preview_MaterialIcon2_Frame;
	g_ShenFen_Material_Frame[3] = ShenFen_Preview_MaterialIcon3_Frame;
	g_ShenFen_Material_Frame[4] = ShenFen_Preview_MaterialIcon4_Frame;
	g_ShenFen_Material_Frame[5] = ShenFen_Preview_MaterialIcon5_Frame;

	g_ShenFen_Material_Num[1] =	ShenFen_Preview_MaterialIcon1_Amount;
	g_ShenFen_Material_Num[2] =	ShenFen_Preview_MaterialIcon2_Amount;
	g_ShenFen_Material_Num[3] =	ShenFen_Preview_MaterialIcon3_Amount;
	g_ShenFen_Material_Num[4] =	ShenFen_Preview_MaterialIcon4_Amount;
	g_ShenFen_Material_Num[5] =	ShenFen_Preview_MaterialIcon5_Amount;

	g_ShenFen_Material_Mask[1] =	ShenFen_Preview_MaterialIcon1_Mask;
	g_ShenFen_Material_Mask[2] =	ShenFen_Preview_MaterialIcon2_Mask;
	g_ShenFen_Material_Mask[3] =	ShenFen_Preview_MaterialIcon3_Mask;
	g_ShenFen_Material_Mask[4] =	ShenFen_Preview_MaterialIcon4_Mask;

	-- 保存界面的默认相对位置
	g_ShenFen_Preview_Frame_UnifiedXPosition	= ShenFen_Preview_Frame : GetProperty("UnifiedXPosition");
	g_ShenFen_Preview_Frame_UnifiedYPosition	= ShenFen_Preview_Frame : GetProperty("UnifiedYPosition");

end

function ShenFen_Preview_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99858301 ) then	
	
		if Get_XParam_INT( 0 ) <= 0 then
			ShenFen_Preview_OnHidden()
			return
		end
		
		--关心商人Obj
		g_ServerCareID = Get_XParam_INT(1)
		objCared = DataPool:GetNPCIDByServerID(g_ServerCareID);
		if( 0 > objCared ) then
			PushDebugMessage("server传过来的数据有问题。");
			return
		end
		this:CareObject(objCared, 1, "ShenFen_Preview");
			
		g_ShenFen_CurIdentity = Get_XParam_INT(2)
		g_ShenFen_CurAbility = Get_XParam_INT(3)
		
		-- 当前身份与技能是否符合
		if g_ShenFen_Prescr_Ability ~= g_ShenFen_CurAbility then
			g_ShenFen_CurSelect = -1;
			g_ShenFen_Prescr_Ability = g_ShenFen_CurAbility
			if this:IsVisible() then
				ShenFen_Preview_OnHidden()
			end
			this:Show()
			ShenFen_Preview_Update()
		else
			g_ShenFen_Prescr_Ability = -1
			this:Hide()
		end
		return;
		
	elseif ( event == "SWITCHSHENFEN" ) then
	
		g_ShenFen_CurSelect = -1
		ShenFen_Preview_List:ClearListBox()
		
	elseif ( event == "CLOSE_SYNTHESIZE_ENCHASE" ) then
		ShenFen_Preview_OnHidden()	
		return;
	
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ShenFen_Preview_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenFen_Preview_Frame_On_ResetPos()
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			this:CareObject(objCared, 0, "ShenFen_Preview");
			ShenFen_Preview_OnHidden()	
		end

	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		ShenFen_Preview_OnHidden()	
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShenFen_Preview_OnHidden()	
	end

end

function ShenFen_Preview_OnShown()
	ShenFen_Preview_Update();
end

function ShenFen_Preview_Update()

	local strName = "#{YCGZ_231225_53}";	
	if ShenFen_Preview_Title[g_ShenFen_CurIdentity] ~= nil then
		strName = ShenFen_Preview_Title[g_ShenFen_CurIdentity]
	end
	ShenFen_Preview_DragTitle:SetText( tostring(strName) )	
	
	ShenFen_Preview_UpdateList()

end

function ShenFen_Preview_UpdateList()

	local tabSortGroup = {}
	local tabPrescr = LifeAbility : LuaFnGetAbilityPrescrID(g_ShenFen_Prescr_Ability);
	for _, nPrescr in pairs(tabPrescr) do 
		local abLevel =  LifeAbility:LuaFnGetPrescrDetailInfo(nPrescr, "LifeAbility_Level");
		local nTypeGroup = LifeAbility:LuaFnGetPrescrDetailInfo(nPrescr, "TypeGroup");
		local nSubTypeGroup = LifeAbility:LuaFnGetPrescrDetailInfo(nPrescr, "SubTypeGroup") or 0;
		local nSelectIndex = nTypeGroup
		if not ShenFen_SynthesizePucker[nSelectIndex] then 
			ShenFen_SynthesizePucker[nSelectIndex] = 1
		end
		nSelectIndex = nTypeGroup*100 + nSubTypeGroup
		if not ShenFen_SynthesizePucker[nSelectIndex] then 
			ShenFen_SynthesizePucker[nSelectIndex] = 1
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

	ShenFen_Preview_List:ClearListBox();
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
			if ( ShenFen_SynthesizePucker[nSelectIndex] > 0 ) then
				strName= "- #gFE7E82" .. strName;
				isShow1 = 1
			else
				strName= "+ #gFE7E82" .. strName;
				isShow1 = 0
			end
			ShenFen_Preview_List:AddItem(strName,10000+nSelectIndex);
		end

		-- 二级页签
		nSelectIndex = nTypeGroup*100 + nSubTypeGroup
		if nSubTypeGroup > 0 and nGroup2 ~= nSubTypeGroup then 
			nGroup2 = nSubTypeGroup
			if isShow1 == 1 then
				strName= LifeAbility :GetPrescription_Kind(nSubTypeGroup)
				if ( ShenFen_SynthesizePucker[nSelectIndex] > 0 ) then
					strName= " - #gFE7E82" .. strName;
					isShow2 = 1
				else
					strName= " + #gFE7E82" .. strName;
					isShow2 = 0
				end
				ShenFen_Preview_List:AddItem(strName,10000+nSelectIndex);
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

			local nMaxAmount = LifeAbility : GetPrescr_Item_Maximum(nPrescr);
			if nMaxAmount > 0 then
			--	szPrescrName = szPrescrName .. "    [" .. nMaxAmount .. "]";
			elseif nMaxAmount < 0 then 
			--	szPrescrName = szPrescrName .. "    [N/A]";
			end

			ShenFen_Preview_List:AddItem("  "..szPrescrName, nPrescr);
			if(g_ShenFen_CurSelect == -1 ) then
				g_ShenFen_CurSelect = nPrescr
			end
			if(g_ShenFen_CurSelect == nPrescr) then
				ShenFen_Preview_List : SetItemSelectByItemID(g_ShenFen_CurSelect);
			end
		end
	end

	for i=1, 4 do
		g_ShenFen_Material_Num[i]	: SetText("");
		g_ShenFen_Material_Num[i]	: Hide();
		g_ShenFen_Material_Icon[i]	: Hide();
		g_ShenFen_Material_Name[i]	: SetText("");
	end
	ShenFen_Preview_Item_Frame : Hide();
	ShenFen_Preview_Amount : SetText("");
	ShenFen_Preview_Item_Name_Text : SetText("");
	ShenFen_Preview_LianYao:SetText("")

	ShenFen_Preview_ListBox_Selected()
end

function ShenFen_Preview_ListBox_Selected()

	local nSelIndex = ShenFen_Preview_List:GetFirstSelectItem();
	local nPrescrNum = DataPool:GetPrescrList_Num();

	if nSelIndex > 10000 then
		local nIndex = nSelIndex - 10000
		if ShenFen_SynthesizePucker[nIndex] == 1 then
			ShenFen_SynthesizePucker[nIndex] = 0;
		else
			ShenFen_SynthesizePucker[nIndex] = 1;
		end
		ShenFen_Preview_Update();
		return
	end

	if nSelIndex == -1 then
		if g_ShenFen_CurSelect == -1 then
			return;
		else
			nSelIndex = g_ShenFen_CurSelect;
		end
	end

	g_ShenFen_CurSelect = nSelIndex;

	for i=1, 4 do
		g_ShenFen_Material_Num[i]	: SetText("");
		g_ShenFen_Material_Num[i]	: Hide();
		g_ShenFen_Material_Icon[i]	: Hide();
		g_ShenFen_Material_Name[i]	: SetText("");
	end

	ShenFen_Preview_Item_Frame : Hide();
	ShenFen_Preview_Item : Hide();
	ShenFen_Preview_Item_Name_Text : SetText("");
	ShenFen_Preview_Amount : SetText("");
	ShenFen_Preview_LianYao:SetText("")

	if( nSelIndex < 0 ) then
		return;
	end
	
	local resultid,resultnum = LifeAbility : Get_Test_Prescr_Item(nSelIndex, 0);
	local tabMaterials = LifeAbility : GetPrescr_HelpMaterialIds(nSelIndex, 0);
	local haveSpecialMaterial = 0
	local item_index = -1
	if table.getn(tabMaterials) > 0 then 
		haveSpecialMaterial = 1
		if g_ShenFen_Prescr_Ability == 61 then 
			-- 产出Id显示成ItemCompoundHelper.txt配的产出Id
			item_index = tabMaterials[1]
		end
	end
	
	local myMenpai = Player : GetData("MEMPAI")	
	local nHelperNum = LifeAbility : GetPrescr_HelpPrescrCount(nSelIndex);
	local helperId = LifeAbility : GetPrescr_HelpResultId(nSelIndex, item_index, myMenpai);
	if helperId ~= -1 then 
		resultid = helperId 
	end
	if nHelperNum > 0 then 
		resultnum = 1
	end

	if resultid == -1 then 
		ShenFen_Preview_Item_Frame : Show();
		ShenFen_Preview_Item : SetProperty("ShortImage","");
		ShenFen_Preview_Item : Show();

		ShenFen_Preview_Amount : Hide();
		ShenFen_Preview_Item_Name_Text : SetText("");
		ShenFen_Preview_Item_Name_Text : Show();
	else
		ShenFen_Preview_Item_Frame : Show();
		local name,icon = LifeAbility : GetPrescr_Material(resultid);
		ShenFen_Preview_Item : SetProperty("ShortImage", icon);
		ShenFen_Preview_Item : Show();

		ShenFen_Preview_Amount : SetText("#e010101" .. resultnum);
		ShenFen_Preview_Amount : Show();
		if g_ShenFen_Prescr_Ability == 60 then 
			-- 特写：身份制药产出数量是概率随机的，故隐藏
			ShenFen_Preview_Amount : Hide();
		end

		ShenFen_Preview_Item_Name_Text : SetText(name);
		ShenFen_Preview_Item_Name_Text : Show();
	end
	
	if g_ShenFen_Prescr_Ability == 61 and haveSpecialMaterial == 1 then		
		ShenFen_Preview_LianYao:Show()
		ShenFen_Preview_LianYao:SetText("#{SFYD_231227_14}")
	elseif g_ShenFen_Prescr_Ability == 60 then 
		ShenFen_Preview_LianYao:Show()
		ShenFen_Preview_LianYao:SetText("#{SFJN_231225_87}")
	else
		ShenFen_Preview_LianYao:Hide()
		ShenFen_Preview_LianYao:SetText("")
	end

	local tip_name,tip_type, tip_level = LifeAbility : GetPrescr_Material_Tooltip(resultid);
	local Consume_Vigor, Consume_Energy = LifeAbility : GetPrescr_Consume_Vigor_Energy(nSelIndex);
	local Consume_Attr = LifeAbility : GetPrescr_Consume_ContriAttr(nSelIndex);
	local strName = ""
	if Consume_Vigor >= 0 then
		strName = strName .. "#r基础活力消耗：".. tostring(Consume_Vigor);
	end

	if Consume_Energy >= 0 then
		strName = strName .. "#r消耗精力：".. tostring(Consume_Energy);
	end

	if Consume_Attr >= 0 then
		strName = strName .. "#r消耗门派贡献度：".. tostring(Consume_Attr);
	end

	--if resultnum == -1 or resultid == -1 then
	--	ShenFen_Preview_Item : SetToolTip(tip_name.."#r类型："..tip_type..strName);
	--	ShenFen_Preview_Amount:SetToolTip(tip_name.."#r类型："..tip_type..strName);
	--end

	for	i=1, 4 do
	  local stuffid,stuffnum = LifeAbility : Get_Test_Prescr_Item(nSelIndex,i);

		if(stuffid == -1) then
			g_ShenFen_Material_Num[i]	: SetText("");
			g_ShenFen_Material_Icon[i]	: Hide();
		else
			name,icon = LifeAbility : GetPrescr_Material(stuffid);
			local holdnum = LifeAbility : GetPrescr_Material_Hold_Count(nSelIndex,i);
			g_ShenFen_Material_Icon[i] : SetProperty("ShortImage",icon);
			g_ShenFen_Material_Icon[i] : Show();
			g_ShenFen_Material_Name[i] : SetText(name);
			if holdnum > 99 then
				g_ShenFen_Material_Num[i]  : SetText("#e010101∞/" .. stuffnum);
			else
				g_ShenFen_Material_Num[i]  : SetText("#e010101" .. holdnum .. "/" .."#e010101" .. stuffnum);
			end
			if( holdnum < stuffnum ) then
				g_ShenFen_Material_Mask[ i ]:Show();
			else
				g_ShenFen_Material_Mask[ i ]:Hide();
			end
			g_ShenFen_Material_Num[i]  : Show();
			g_ShenFen_Material_Frame[i]: Show();
			tip_name,tip_type,tip_level = LifeAbility : GetPrescr_Material_Tooltip(stuffid);
		end
	end
	
	if ( ShenFen_Preview_List:GetFirstSelectItem() < 0 ) then
		ShenFen_Preview_HideCtrlOnNoSelect();
	end
end

function ShenFen_Preview_HideCtrlOnNoSelect()
	local i = 1;
	for i=1, 4 do
		g_ShenFen_Material_Num[i]	 : SetText("");
		g_ShenFen_Material_Num[i]  : Hide();
		g_ShenFen_Material_Icon[i] : Hide();
		g_ShenFen_Material_Name[i] : SetText("");
	end

	ShenFen_Preview_Item : SetProperty("ShortImage","");   --设置为无图标
	ShenFen_Preview_Item_Name_Text : SetText("");
	ShenFen_Preview_Amount : SetText("");
	ShenFen_Preview_LianYao:SetText("")
end

--显示道具的ToolTips
function ShenFen_Preview_OnShowToolTip(who)
	local nSelIndex = ShenFen_Preview_List:GetFirstSelectItem();
	local left, right, top, bottom;
	local itemID = 0;
	local stuffnum = 0;

	if ( nSelIndex < 0 ) then
	   return;
	end

	if who == 0 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex, 0);
		left, right, top, bottom = ShenFen_Preview_Item :GetPixelRect();
		local item_index = -1
		local myMenpai = Player : GetData("MEMPAI")
		local tabMaterials = LifeAbility : GetPrescr_HelpMaterialIds(nSelIndex, 0);
		if table.getn(tabMaterials) > 0 and g_ShenFen_Prescr_Ability == 61 then 
			-- 产出Id显示成ItemCompoundHelper.txt配的产出Id
			item_index = tabMaterials[1]
		end
		local helperId = LifeAbility : GetPrescr_HelpResultId(nSelIndex, item_index, myMenpai);
		if helperId ~= -1 then 
			itemID = helperId 
		end
	elseif who == 1 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex,1);
		left, right, top, bottom = ShenFen_Preview_MaterialIcon1_Mask :GetPixelRect();
	elseif who == 2 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex,2);
		left, right, top, bottom = ShenFen_Preview_MaterialIcon2_Mask :GetPixelRect();
	elseif who == 3 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex,3);
		left, right, top, bottom = ShenFen_Preview_MaterialIcon3_Mask :GetPixelRect();
	elseif who == 4 then
		itemID,stuffnum = LifeAbility:Get_Test_Prescr_Item(nSelIndex,4);
		left, right, top, bottom = ShenFen_Preview_MaterialIcon4_Mask :GetPixelRect();
	end

	LifeAbility:ShowSuperToolTip(itemID, true,left,top,right,bottom);
end

--隐藏道具的ToolTips
function ShenFen_Preview_OnHideToolTip()

	LifeAbility:ShowSuperToolTip(1, false);
	
end

function ShenFen_Preview_Close()

	ShenFen_Preview_Cancel_Clicked()
	
end

function ShenFen_Preview_OnHidden()

	ShenFen_Preview_Cancel_Clicked()
	
end

function ShenFen_Preview_Cancel_Clicked()
	
	--取消关心
	this:CareObject(objCared, 0, "ShenFen_Preview");
		
	g_ShenFen_CurIdentity = -1 
	g_ShenFen_CurAbility = -1 
	g_ShenFen_CurSelect = -1
	g_ShenFen_Prescr_Ability = -1
	this:Hide();
	return;
	
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ShenFen_Preview_Frame_On_ResetPos()

	ShenFen_Preview_Frame : SetProperty("UnifiedXPosition", g_ShenFen_Preview_Frame_UnifiedXPosition);
	ShenFen_Preview_Frame : SetProperty("UnifiedYPosition", g_ShenFen_Preview_Frame_UnifiedYPosition);
	
end

