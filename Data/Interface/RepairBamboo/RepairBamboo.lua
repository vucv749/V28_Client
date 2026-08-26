--修复竹简累计奖励领取界面
local g_RepairBamboo_Frame_UnifiedXPosition;
local g_RepairBamboo_Frame_UnifiedYPosition;

local g_RepairBamboo_Button={}
local g_RepairBamboo_ButtonTips={}
local g_RepairBamboo_ButtonOK={}
local g_RepairBamboo_Text={}

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_RepairBamboo_TargetID =-1
local g_RepairBamboo_Point =-1
local g_RepairBamboo_nBounsFlag =-1

local g_RepairBamboo_Max_Point = 50
local g_RepairBamboo_PointNeed ={10,25,50}


function RepairBamboo_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_SHENGWANG_SHOP_INFO")
	this:RegisterEvent("SHOW_SHENGWANG_SHOP_INFO")
	this:RegisterEvent("NEW_MISSION")
	this:RegisterEvent("DELETE_MISSION")
end

function RepairBamboo_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		RepairBamboo_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		RepairBamboo_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		RepairBamboo_Close()
	elseif event == "PLAYER_LEAVE_WORLD" then
		RepairBamboo_Close()
    elseif( event == "UI_COMMAND" and tonumber(arg0) == 99868101  )  then
		g_ShengWang_TargetID = Get_XParam_INT(0);
       -- Lua_TDU_Log("g_ShengWang_TargetID"..g_ShengWang_TargetID);
		objCared = DataPool : GetNPCIDByServerID(g_ShengWang_TargetID)
        this:CareObject(objCared, 1, "RepairBamboo");

        g_RepairBamboo_Point = Get_XParam_INT(1);
		g_RepairBamboo_nBounsFlag = Get_XParam_INT(2);

		RepairBamboo_OnShown()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99868102  )  then
		if (IsWindowShow("RepairBamboo")) then
			g_ShengWang_TargetID = Get_XParam_INT(0);
		   -- Lua_TDU_Log("g_ShengWang_TargetID"..g_ShengWang_TargetID);
			objCared = DataPool : GetNPCIDByServerID(g_ShengWang_TargetID)
			this:CareObject(objCared, 1, "RepairBamboo");

			g_RepairBamboo_Point = Get_XParam_INT(1);
			g_RepairBamboo_nBounsFlag = Get_XParam_INT(2);

			RepairBamboo_OnRefresh(g_RepairBamboo_nBounsFlag,g_RepairBamboo_Point)
		end


    elseif (event == "OBJECT_CARED_EVENT") then
        Lua_TDU_Log("OBJECT_CARED_EVENT");
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		Lua_TDU_Log("OBJECT_CARED_EVENT tonumber(arg2):"..tonumber(arg2));
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			RepairBamboo_Close()
		end

	elseif( event == "UI_COMMAND" and tonumber(arg0) == 99868103  ) then
		RepairBamboo_Close()
	end
end

function RepairBamboo_OnLoad()
	-- 保存界面的默认相对位置
	g_RepairBamboo_Frame_UnifiedXPosition	= RepairBamboo_Frame:GetProperty("UnifiedXPosition");
    g_RepairBamboo_Frame_UnifiedYPosition	= RepairBamboo_Frame:GetProperty("UnifiedYPosition");

	g_RepairBamboo_Button[1]=RepairBamboo_CUM1Btn
	g_RepairBamboo_Button[2]=RepairBamboo_CUM2Btn
	g_RepairBamboo_Button[3]=RepairBamboo_CUM3Btn
--	g_RepairBamboo_Button[4]=RepairBamboo_CUM4Btn


	g_RepairBamboo_ButtonTips[1]=RepairBamboo_CUM1_tips
	g_RepairBamboo_ButtonTips[2]=RepairBamboo_CUM2_tips
	g_RepairBamboo_ButtonTips[3]=RepairBamboo_CUM3_tips
--	g_RepairBamboo_ButtonTips[4]=RepairBamboo_CUM4_tips


	g_RepairBamboo_ButtonOK[1]=RepairBamboo_CUM1BtnOK
	g_RepairBamboo_ButtonOK[2]=RepairBamboo_CUM2BtnOK
	g_RepairBamboo_ButtonOK[3]=RepairBamboo_CUM3BtnOK
--	g_RepairBamboo_ButtonOK[4]=RepairBamboo_CUM4BtnOK

	g_RepairBamboo_Text[1]=RepairBamboo_CUM1Text
	g_RepairBamboo_Text[2]=RepairBamboo_CUM2Text
	g_RepairBamboo_Text[3]=RepairBamboo_CUM3Text

end

--================================================
-- 界面的默认相对位置
--================================================
function RepairBamboo_ResetPos()
	RepairBamboo_Frame:SetProperty("UnifiedXPosition", g_RepairBamboo_Frame_UnifiedXPosition);
	RepairBamboo_Frame:SetProperty("UnifiedYPosition", g_RepairBamboo_Frame_UnifiedYPosition);
end

function RepairBamboo_Close()
	this:Hide();
end

--================================================
--刷新界面
--================================================
function RepairBamboo_OnRefresh(nPoint)
	RepairBamboo_BottomText:SetText( ScriptGlobal_Format("#{TGX_231229_74}",g_RepairBamboo_Point) )
	RepairBamboo_Progress:Show()
	RepairBamboo_Progress:SetProgress(tonumber(g_RepairBamboo_Point), g_RepairBamboo_Max_Point)
	for i=1,3 do
		local nflag = RepairBamboo_GetBounsFlagByIndex(i)

		g_RepairBamboo_Text[i]:SetText(ScriptGlobal_Format("#{TGX_231229_92}",g_RepairBamboo_PointNeed[i]))

		if nflag == 1 then
			g_RepairBamboo_ButtonTips[i]:Hide()
			g_RepairBamboo_ButtonOK[i]:Show()
		else
			g_RepairBamboo_ButtonOK[i]:Hide()
			local curNeedPoint = g_RepairBamboo_PointNeed[i]
			if g_RepairBamboo_Point >= curNeedPoint then
				g_RepairBamboo_ButtonTips[i]:Show()
			else
				g_RepairBamboo_ButtonTips[i]:Hide()
			end

		end
	end

end

--================================================
--显示界面
--================================================
function RepairBamboo_OnShown()
	RepairBamboo_OnRefresh()
	this:Show();
end

--================================================
--领取奖励
--================================================
function RepairBamboo_GetBouns_Clicked(nIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGetBouns")
		Set_XSCRIPT_ScriptID(998681)
		Set_XSCRIPT_Parameter(0, g_ShengWang_TargetID)
		Set_XSCRIPT_Parameter(1, nIndex)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function RepairBamboo_GetBounsFlagByIndex( nIndex )

	local nBounsFlag = g_RepairBamboo_nBounsFlag
	local mm = 1
	for i=1,nIndex do
		mm = mm*10
	end
	local nn = mm/10

	local nflagnIndex= math.floor(math.mod(nBounsFlag,mm)/nn)
	return nflagnIndex

end

