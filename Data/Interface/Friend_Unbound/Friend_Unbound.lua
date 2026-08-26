--Friend_Unbound

local g_Friend_Unbound_Frame_UnifiedXPosition
local g_Friend_Unbound_Frame_UnifiedYPosition

local g_SelectIdx = -1
local g_FU_CheckButton = {}
local g_Checktext = {}
local g_targetId = -1

function Friend_Unbound_PreLoad()
	--this:RegisterEvent("UPDATE_FRIEND")
	this:RegisterEvent("UI_COMMAND")

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function Friend_Unbound_OnLoad()

end

function Friend_Unbound_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0)==50501001) then
		g_targetId = Get_XParam_INT(0)
		Friend_Unbound_OnShow()
	end
end

function Friend_Unbound_Re_UnboundPos()
	Friend_Unbound:_UnboundProperty("UnifiedXPosition", g_Friend_Unbound_Frame_UnifiedXPosition)
	Friend_Unbound:_UnboundProperty("UnifiedYPosition", g_Friend_Unbound_Frame_UnifiedYPosition)
end

function Friend_Unbound_Hide()
	g_SelectIdx = -1
	this:Hide()
end


function Friend_Unbound_OnShow()
	g_SelectIdx = -1
	local nCount,guid1,name1,guid2,name2,guid3,name3 = DataPool:GetRomanInfo()
	if nCount <= 0 then
		return
	end
	local guidArr = {guid1,guid2,guid3}
	local nameArr = {name1,name2,name3}
	Friend_Unbound_Select:ResetList()
	Friend_Unbound_Select:ComboBoxAddItem("-",0);
	for x=1,3 do
		Friend_Unbound_Select:ComboBoxAddItem(nameArr[x],x)
	end	
	Friend_Unbound_Select:SetCurrentSelect(0)
	Friend_Unbound_Text:Show()
	this:Show()
end


function Friend_Unbound_CheckClick(idx)
	g_SelectIdx = idx
end

function Friend_Unbound_OK_Clicked()
	local szSex,nSex = Friend_Unbound_Select:GetCurrentSelect();
	
	if nSex <= 0 then
		PushDebugMessage("#{QYHY_230330_88}")
		Friend_Unbound_Hide()
		return
	end
	local nCount,guid1,name1,guid2,name2,guid3,name3 = DataPool:GetRomanInfo()
	local guid = -1
	if nSex == 1 then
		guid = guid1
	elseif nSex == 2 then
		guid = guid2
	elseif nSex == 3 then
		guid = guid3
	end
	
	if guid == nil or guid <= 0 then
		Friend_Unbound_Hide()
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ConfirmForceDismissRoman" )
		Set_XSCRIPT_ScriptID( 505010 )
		Set_XSCRIPT_Parameter( 0, guid )
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT()
	
	Friend_Unbound_Hide()
end
