--´ºÖ®¼Æ»®-ÀÛ¼Æ×ªÅÌ

--¿Ø¼þÁÐ±í			
local g_targetID = -1
local g_objCared = -1
local MAX_OBJ_DISTANCE = 3.0

--×ªÅÌ¿ØÖÆ
local g_GiftBox = {}
local g_ItemID = {}
local g_ActionItemID = {}
local g_Frame_UnifiedPosition = 0
function ChunfenItemGet_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("SPRINTPLAN_TICKET_UPDATE")
	this:RegisterEvent("ADJEST_UI_POS",false)
end

function ChunfenItemGet_OnLoad()
	g_GiftBox = {
		ChunfenItemGet_4_1,
		ChunfenItemGet_8_1,
		ChunfenItemGet_12_1,
	}
	
	g_ItemID =
	{
		[1] = {itemid = 30900045, count = 1, name = "Thiên Canh Cß¶ng Hóa Lµ"},
		[2] = {itemid = 50313004, count = 1, name = "H°ng Bäo ThÕch Lv3"},
		[3] = {itemid = 38002221, count = 1, name = "Hµp Quà Pha Lê Tinh Khiªt Lv3"},
	}	
	g_Frame_UnifiedPosition = ChunfenItemGet_Frame:GetProperty("UnifiedPosition")
end

local useCount_grandtotal = 0 --??????????(???)
local gettotal_1 = 0 --???????
local gettotal_2 = 0 --???????
local gettotal_3 = 0 --???????


function ChunfenItemGet_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89267601 ) then
		useCount_grandtotal = Get_XParam_INT(0)		--??????????(???)
		gettotal_1 = Get_XParam_INT(1) --???????
		gettotal_2 = Get_XParam_INT(2) --???????
		gettotal_3 = Get_XParam_INT(3) --???????
		g_targetID = Get_XParam_INT(4)
		local str = ScriptGlobal_Format("#{YNZJ_210127_06}", useCount_grandtotal)
		ChunfenItemGet_InfoText:SetText(str);

		g_objCared = DataPool : GetNPCIDByServerID(g_targetID)
			
		if g_objCared == -1 then
			PushDebugMessage("Dæ li®u máy chü có v¤n ð«")
			return
		end

		-- local msg = tostring(g_objCared)
		-- PushDebugMessage(msg)
		ChunfenItemGet_OpenFateRoll(gettotal_1,gettotal_2,gettotal_3)
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= g_objCared) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			ChunfenItemGet_CloseRoll()
		end	
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ChunfenItemGet_ResetPos()
	elseif (event == "ADJEST_UI_POS") then
		ChunfenItemGet_ResetPos()
	end
end

function ChunfenItemGet_ResetPos()
	ChunfenItemGet_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

function ChunfenItemGet_OpenFateRoll(gettotal_1,gettotal_2,gettotal_3)
	if g_objCared ~= -1 then
		this:CareObject(g_objCared, 0, "ChunfenItemGet")
		this:CareObject(g_objCared, 1, "ChunfenItemGet")
	else
		return
	end

	--Ò»µÈ½±ÀøÈë¿Ú
	ChunfenItemGet_Mark4_1:Hide();
	ChunfenItemGet_Get:Show();
	ChunfenItemGet_Getted:Hide();
	--¶þµÈ½±ÀøÈë¿Ú
	ChunfenItemGet_Mark8_1:Hide();
	ChunfenItemGet_Get1:Show();
	ChunfenItemGet_Getted1:Hide();

	--ÈýµÈ½±ÀøÈë¿Ú
	ChunfenItemGet_Mark12_1:Hide();
	ChunfenItemGet_Get2:Show();
	ChunfenItemGet_Getted2:Hide();

	--ÁìÁËÒ»µÈ½±Àø
	if gettotal_1 > 0 then 
		ChunfenItemGet_Mark4_1:Show();
		ChunfenItemGet_Get:Hide();
		ChunfenItemGet_Getted:Show();
	end
	--ÁìÁË¶þµÈ½±Àø
	if gettotal_2 > 0 then
		ChunfenItemGet_Mark8_1:Show();
		ChunfenItemGet_Get1:Hide();
		ChunfenItemGet_Getted1:Show();
	end
	--ÁìÁËÈýµÈ½±Àø
	if gettotal_3 > 0 then
		ChunfenItemGet_Mark12_1:Show();
		ChunfenItemGet_Get2:Hide();
		ChunfenItemGet_Getted2:Show();
	end


	local theAction1 = DataPool:CreateBindActionItemForShow(g_ItemID[1].itemid, g_ItemID[1].count)
	local theAction2 = DataPool:CreateBindActionItemForShow(g_ItemID[2].itemid, g_ItemID[2].count)
	local theAction3 = DataPool:CreateBindActionItemForShow(g_ItemID[3].itemid, g_ItemID[3].count)

	
	g_ActionItemID[1] = theAction1:GetID()
	g_ActionItemID[2] = theAction2:GetID()
	g_ActionItemID[3] = theAction3:GetID()


	g_GiftBox[1]:SetActionItem(g_ActionItemID[1])
	g_GiftBox[2]:SetActionItem(g_ActionItemID[2])
	g_GiftBox[3]:SetActionItem(g_ActionItemID[3])


	this:Show()
end

function ChunfenItemGet_CloseRoll()
	if g_objCared ~= -1 then
		this:CareObject(g_objCared, 0, "ChunfenItemGet")
		g_objCared = -1
	end
	
	this:Hide()
end

--»Øµ÷º¯Êý-¹Ø± 
function ChunfenItemGet_OnClosed()
	ChunfenItemGet_CloseRoll()
end

--<Event Name="Clicked" Function="FunChunfenItemGet_Get()"/>
function FunChunfenItemGet_Get()
	local isInHell = IsInHell()
	if isInHell == 1 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GiveGrandTotalPrize" )
		Set_XSCRIPT_ScriptID( 892676 )
		Set_XSCRIPT_Parameter( 0, g_targetID )
		Set_XSCRIPT_Parameter( 1, 1 )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function FunChunfenItemGet_Get1()
	local isInHell = IsInHell()
	if isInHell == 1 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GiveGrandTotalPrize" )
		Set_XSCRIPT_ScriptID( 892676 )
		Set_XSCRIPT_Parameter( 0, g_targetID )
		Set_XSCRIPT_Parameter( 1, 2 )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function FunChunfenItemGet_Get2()
	local isInHell = IsInHell()
	if isInHell == 1 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GiveGrandTotalPrize" )
		Set_XSCRIPT_ScriptID( 892676 )
		Set_XSCRIPT_Parameter( 0, g_targetID )
		Set_XSCRIPT_Parameter( 1, 3 )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end
