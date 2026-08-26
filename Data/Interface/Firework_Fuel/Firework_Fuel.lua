--庆典礼馈界面
local g_Firework_Fuel_Frame_UnifiedXPosition;
local g_Firework_Fuel_Frame_UnifiedYPosition;

local g_Firework_Fuel_ButtonMark={}
local g_Firework_Fuel_Text={}
local g_Firework_Fuel_Tips={}

local g_Firework_objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Firework_Fuel_TargetID =-1
local g_Firework_Fuel_Point =-1
local g_Firework_Fuel_nBounsFlag =-1

local g_Firework_Fuel_Max_Point = 75
local g_Firework_Fuel_PointNeed ={15,35,75}


function Firework_Fuel_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OBJECT_CARED_EVENT")
end

function Firework_Fuel_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		Firework_Fuel_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		Firework_Fuel_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Firework_Fuel_Close()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 99941601  )  then
		g_Firework_Fuel_TargetID = Get_XParam_INT(0)
		g_Firework_objCared = DataPool : GetNPCIDByServerID(g_Firework_Fuel_TargetID)
        this:CareObject(g_Firework_objCared, 1, "Firework_Fuel");

		--g_Firework_Fuel_Point = 50
        g_Firework_Fuel_Point = Get_XParam_INT(1);
		g_Firework_Fuel_nBounsFlag = Get_XParam_INT(2);

		Firework_Fuel_OnShown()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99941602  )  then
		if (IsWindowShow("Firework_Fuel")) then
			g_Firework_Fuel_TargetID = Get_XParam_INT(0)
			g_Firework_objCared = DataPool : GetNPCIDByServerID(g_Firework_Fuel_TargetID)
			this:CareObject(g_Firework_objCared, 1, "Firework_Fuel");

			--g_Firework_Fuel_Point = 50
			g_Firework_Fuel_Point = Get_XParam_INT(1);
			g_Firework_Fuel_nBounsFlag = Get_XParam_INT(2);
			Firework_Fuel_OnRefresh()
		end

    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_Firework_objCared) then
			return;
		end

		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			Firework_Fuel_Close()
		end
	end
end

function Firework_Fuel_OnLoad()
	-- 保存界面的默认相对位置
	g_Firework_Fuel_Frame_UnifiedXPosition	= Firework_Fuel_Frame:GetProperty("UnifiedXPosition");
    g_Firework_Fuel_Frame_UnifiedYPosition	= Firework_Fuel_Frame:GetProperty("UnifiedYPosition");

	g_Firework_Fuel_ButtonMark[1]=Firework_Fuel_Icon1Btn
	g_Firework_Fuel_ButtonMark[2]=Firework_Fuel_Icon2Btn
	g_Firework_Fuel_ButtonMark[3]=Firework_Fuel_Icon3Btn


	g_Firework_Fuel_Text[1]=Firework_Fuel_oneText
	g_Firework_Fuel_Text[2]=Firework_Fuel_twoText
	g_Firework_Fuel_Text[3]=Firework_Fuel_threeText


	g_Firework_Fuel_Tips[1]=Firework_Fuel_Icon1_Tips
	g_Firework_Fuel_Tips[2]=Firework_Fuel_Icon2_Tips
	g_Firework_Fuel_Tips[3]=Firework_Fuel_Icon3_Tips

end

--================================================
-- 界面的默认相对位置
--================================================
function Firework_Fuel_ResetPos()
	Firework_Fuel_Frame:SetProperty("UnifiedXPosition", g_Firework_Fuel_Frame_UnifiedXPosition);
	Firework_Fuel_Frame:SetProperty("UnifiedYPosition", g_Firework_Fuel_Frame_UnifiedYPosition);
end

function Firework_Fuel_Close()
	this:Hide()
end

function Firework_Fuel_OnHiden()
	this:Hide()
end
--================================================
--刷新界面
--================================================
function Firework_Fuel_OnRefresh(nPoint)
	Firework_Fuel_BottomText2:SetText( ScriptGlobal_Format("#{YHWH_240614_52}",g_Firework_Fuel_Point) )
	Firework_Fuel_EXP:Show()
	Firework_Fuel_EXP:SetProgress(tonumber(g_Firework_Fuel_Point), g_Firework_Fuel_Max_Point)
	for i=1,3 do
		local nflag = Firework_Fuel_GetBounsFlagByIndex(i)
		g_Firework_Fuel_Text[i]:SetText(g_Firework_Fuel_PointNeed[i])
		g_Firework_Fuel_Tips[i]:Hide()

		if nflag == 1 then
			g_Firework_Fuel_ButtonMark[i]:Disable()
		else 
			if g_Firework_Fuel_Point >= g_Firework_Fuel_PointNeed[i] then
				g_Firework_Fuel_Tips[i]:Show()
			end
		end
	end

end

--================================================
--显示界面
--================================================
function Firework_Fuel_OnShown()
	Firework_Fuel_OnRefresh()
	this:Show();
end

--================================================
--领取奖励
--================================================
function Firework_Fuel_IconBtn(nIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGetBouns")
		Set_XSCRIPT_ScriptID(999416)
		Set_XSCRIPT_Parameter(0, g_Firework_Fuel_TargetID)
		Set_XSCRIPT_Parameter(1, nIndex)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function Firework_Fuel_GetBounsFlagByIndex( nIndex )

	local nBounsFlag = g_Firework_Fuel_nBounsFlag
	local mm = 1
	for i=1,nIndex do
		mm = mm*10
	end
	local nn = mm/10

	local nflagnIndex= math.floor(math.mod(nBounsFlag,mm)/nn)
	return nflagnIndex

end
