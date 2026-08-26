local g_Equip_JieBang_Frame_UnifiedXPosition
local g_Equip_JieBang_Frame_UnifiedYPosition
local g_Equip_JieBang_nSearch = 0
local g_Equip_JieBang_Item = -1
local g_Equip_JieBang_CaredNpc = -1

function Equip_JieBang_PreLoad()
	this:RegisterEvent("UI_COMMAND")

	this:RegisterEvent("EQUIPJIEBANG_OPT")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Equip_JieBang_OnLoad()
	g_Equip_JieBang_Frame_UnifiedXPosition = Equip_JieBang_Frame:GetProperty("UnifiedXPosition")
	g_Equip_JieBang_Frame_UnifiedYPosition = Equip_JieBang_Frame:GetProperty("UnifiedYPosition")
end

function Equip_JieBang_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 998001069 ) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			return
		end
		Equip_JieBang_BeginCareObject_DWChaiJie()

		if g_Equip_JieBang_Item ~= -1 then
			LifeAbility:Lock_Packet_Item( g_Equip_JieBang_Item, 0 )
			g_Equip_JieBang_Item = -1
		end

		Equip_JieBang_Have:SetText("")
		Equip_JieBang_DemandMoney:SetProperty( "MoneyNumber", tostring(0) )
		Equip_JieBang_SelfJiaozi:SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
		Equip_JieBang_SelfMoney:SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )

		Equip_JieBang_Item:SetActionItem(-1)
		this:Show()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 998001070 ) then
		Equip_JieBang_OnHidden()
	elseif ( event == "EQUIPJIEBANG_OPT" ) then
		if arg0 ~= nil then
			Equip_JieBang_Update(arg0)
		end
	elseif ( event == "PLAYER_LEAVE_WORLD" ) then 
		Equip_JieBang_OnHidden()
	elseif ( event == "ADJEST_UI_POS" ) then
		Equip_JieBang_Frame_On_ResetPos()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		Equip_JieBang_Frame_On_ResetPos()
	end
end

function Equip_JieBang_Frame_On_ResetPos()
	Equip_JieBang_Frame:SetProperty( "UnifiedXPosition", g_Equip_JieBang_Frame_UnifiedXPosition )
	Equip_JieBang_Frame:SetProperty( "UnifiedYPosition", g_Equip_JieBang_Frame_UnifiedYPosition )
end

function Equip_JieBang_Update( itemIndex )
	local index = tonumber(itemIndex)
	local theAction = EnumAction( index, "packageitem" )

	if theAction:GetID() ~= 0 then
		if g_Equip_JieBang_Item ~= -1 then
			LifeAbility:Lock_Packet_Item( g_Equip_JieBang_Item, 0 )
		end

		Equip_JieBang_Item:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item( index, 1 )
		Equip_JieBang_Have:SetText("#{ZBJB_20230526_18}")
		Equip_JieBang_DemandMoney:SetProperty("MoneyNumber", tostring(300000))
		Equip_JieBang_SelfJiaozi:SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
		Equip_JieBang_SelfMoney:SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
		g_Equip_JieBang_Item = index
	end
end

function Equip_JieBang_OnHidden()
	if g_Equip_JieBang_Item ~= -1 then
		LifeAbility:Lock_Packet_Item( g_Equip_JieBang_Item, 0 )
		g_Equip_JieBang_Item = -1
	end

	this:Hide()
end

function Equip_JieBang_OK_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UnBindEquip")
		Set_XSCRIPT_ScriptID(1069)
		Set_XSCRIPT_Parameter( 0, g_Equip_JieBang_Item )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Equip_JieBang_CloseClicked()
	if g_Equip_JieBang_Item ~= -1 then
		LifeAbility:Lock_Packet_Item( g_Equip_JieBang_Item, 0 )
		g_Equip_JieBang_Item = -1
	end

	this:Hide()
end

function Equip_JieBang_LingYu_OnRBClicked()
	if this:IsVisible() then
		if g_Equip_JieBang_Item ~= -1 then
			LifeAbility:Lock_Packet_Item( g_Equip_JieBang_Item, 0 )
			Equip_JieBang_Have:SetText("")
			Equip_JieBang_DemandMoney:SetProperty( "MoneyNumber", tostring(0) )
			Equip_JieBang_SelfJiaozi:SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
			Equip_JieBang_SelfMoney:SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
			g_Equip_JieBang_Item = -1
		end

		Equip_JieBang_Item:SetActionItem(-1)
	end
end

function Equip_JieBang_BeginCareObject_DWChaiJie()
	this:CareObject(g_CaredNpc, 1, "Equip_JieBang")
	return
end

function Equip_JieBang_StopCareObject_DWChaiJie()
	this:CareObject(g_CaredNpc, 0, "Equip_JieBang")
	g_CaredNpc = -1
	return
end

