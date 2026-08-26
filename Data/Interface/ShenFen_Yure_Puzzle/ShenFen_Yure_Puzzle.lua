-- 2023Q1Éí·ÝÔ¤ÈÈÆ´Í¼

local g_UnifiedPosition = nil
local objCared = -1;
local g_TargetId = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Select = 0
local g_ButtonState = {}
local g_Clean = 0
--Í¼±ê
local g_Images = 
{
	[1] = { part = "set:ShenFen_Yure image:ShenFen_Yure_Puzzle_Piece3_Normal",},
	[2] = { part = "set:ShenFen_Yure image:ShenFen_Yure_Puzzle_Piece2_Normal",},
	[3] = { part = "set:ShenFen_Yure image:ShenFen_Yure_Puzzle_Piece1_Normal",},
	[4] = { part = "set:ShenFen_Yure image:ShenFen_Yure_Puzzle_Piece4_Normal",},
	[5] = { part = "set:ShenFen_Yure image:ShenFen_Yure_Puzzle_Piece5_Normal",},
}

local g_PuzzleImage = {}
local g_Button = {}
local g_Answer = {0,0,0}
local g_ButtonCheck = {}
--===============================================
-- PreLoad()
--===============================================
function ShenFen_Yure_Puzzle_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function ShenFen_Yure_Puzzle_OnLoad()
	g_UnifiedPosition = ShenFen_Yure_Puzzle_Frame:GetProperty("UnifiedPosition")	

	g_PuzzleImage[1] = ShenFen_Yure_Puzzle_Block1_Image
	g_PuzzleImage[2] = ShenFen_Yure_Puzzle_Block2_Image
	g_PuzzleImage[3] = ShenFen_Yure_Puzzle_Block3_Image

	g_ButtonCheck[1] = ShenFen_Yure_Puzzle_Block1_Action
	g_ButtonCheck[2] = ShenFen_Yure_Puzzle_Block2_Action
	g_ButtonCheck[3] = ShenFen_Yure_Puzzle_Block3_Action

	g_Button[1] = ShenFen_Yure_Puzzle_BottonBlock1_Action
	g_Button[2] = ShenFen_Yure_Puzzle_BottonBlock2_Action
	g_Button[3] = ShenFen_Yure_Puzzle_BottonBlock3_Action
	g_Button[4] = ShenFen_Yure_Puzzle_BottonBlock4_Action
	g_Button[5] = ShenFen_Yure_Puzzle_BottonBlock5_Action
end

--===============================================
-- OnEvent()
--===============================================
function ShenFen_Yure_Puzzle_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 99869601) then
		local opt = Get_XParam_INT(0);
		if opt == 1 then
			ShenFen_Yure_Puzzle_Clear()
			objCared = -1;
			g_TargetId = Get_XParam_INT(1);
			objCared = DataPool : GetNPCIDByServerID(g_TargetId);
			AxTrace(0,0,"g_TargetId="..g_TargetId .. " objCared="..objCared)
			if objCared == -1 then
				PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
				return
			end
			ShenFen_Yure_Puzzle_BeginCareObject()
			this:Show()
			ShenFen_Yure_Puzzle_Open()
		end
		if opt == 2 then
			ShenFen_Yure_Puzzle_OnHiden()
		end
	elseif (event == "ADJEST_UI_POS") then
		ShenFen_Yure_Puzzle_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenFen_Yure_Puzzle_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShenFen_Yure_Puzzle_OnHiden()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			ShenFen_Yure_Puzzle_OnHiden()
		end
	end
end

--===============================================
-- ÖØÖÃ
--===============================================
function ShenFen_Yure_Puzzle_ResetPos()
	ShenFen_Yure_Puzzle_Frame:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

--===============================================
-- ÇåÊý¾Ý
--===============================================
function ShenFen_Yure_Puzzle_Clear()
	for i = 1, table.getn(g_Button) do
		g_Button[i]:Show()
		g_Button[i]:SetCheck(0)
	end
	for i = 1, table.getn(g_PuzzleImage) do
		g_PuzzleImage[i]:SetProperty("Image","")
	end
	g_Answer = {0,0,0}
	g_ButtonState = {0,0,0,0,0}
	g_Select = 0
	g_TargetId = -1
	g_Clean = 0
end

--===============================================
-- ¹Ø½çÃæ
--===============================================
function ShenFen_Yure_Puzzle_OnHiden()
	ShenFen_Yure_Puzzle_StopCareObject()
	--Êý¾ÝÇå¿ 
	ShenFen_Yure_Puzzle_Clear()

	--Òþ²Ø½çÃæ
	this:Hide()
end

--===============================================
-- ¿ª½çÃæ
--===============================================
function ShenFen_Yure_Puzzle_Open()

	--ShenFen_Yure_Puzzle_TaskPart:SetProperty("Image", g_Images[1].part)
end


--===============================================
-- Ð¡ÎÊºÅ
--===============================================
function ShenFen_Yure_Puzzle_Help()
	PushEvent("CCSHOP_HELP", 14)
end

function ShenFen_Yure_Puzzle_Block_Clicked(idx)
	if idx < 1 or idx > 3 then
		PushDebugMessage("error")
		return
	end
	g_ButtonCheck[idx]:SetCheck(0)
	if g_Select <= 0 then
		return
	end

	g_Button[g_Select]:SetCheck(0)
	g_Button[g_Select]:Hide()
	g_PuzzleImage[idx]:SetProperty("Image", g_Images[g_Select].part)
	if g_Answer[idx] > 0 then
		g_Button[g_Answer[idx]]:Show()
	end
	g_Answer[idx] = g_Select
	g_Select = 0

end

function ShenFen_Yure_Puzzle_BottonBlock_Clicked(idx)

	if idx < 1 or idx > 5 then
		PushDebugMessage("error")
		return
	end
	if g_Select > 0 then
		g_Button[g_Select]:SetCheck(0)
	end

	g_Button[idx]:SetCheck(1)
	g_Select = idx
end

function ShenFen_Yure_Puzzle_SubmitClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998696)
		Set_XSCRIPT_Function_Name("FinishPuzzle")
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_Parameter(1, g_Answer[1])
		Set_XSCRIPT_Parameter(2, g_Answer[2])
		Set_XSCRIPT_Parameter(3, g_Answer[3])
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function ShenFen_Yure_Puzzle_CleanClicked()
	if g_Clean >= 3 then
		return
	end
	g_Clean = g_Clean + 1
end

function ShenFen_Yure_Puzzle_QuashClicked()
	for i = 1, table.getn(g_Button) do
		g_Button[i]:Show()
		g_Button[i]:SetCheck(0)
	end
	for i = 1, table.getn(g_PuzzleImage) do
		g_PuzzleImage[i]:SetProperty("Image","")
	end
	g_Answer = {0,0,0}
	g_ButtonState = {0,0,0,0,0}
	g_Select = 0
end


--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function ShenFen_Yure_Puzzle_BeginCareObject()

	AxTrace(0,0,"LUA___CareObject objCared =" .. objCared );
	this:CareObject(objCared, 1, "ShenFen_Yure_Puzzle");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function ShenFen_Yure_Puzzle_StopCareObject()
	this:CareObject(objCared, 0, "ShenFen_Yure_Puzzle");
	objCared = -1;
end
