local Current = -1;
local Question = 0;
local Question_Sequence = 0;
local Quiz_Buttons = {}
local Button_Answer = {}
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;

--µ±Ç°½çÃæÊÇÄÄ¸ö½çÃæ....
-- 1 = Ç®ÁúÐÂÊÖÈÎÎñ´ðÌâ½çÃæ....
-- 2 = 2007Ê¥µ®Ôªµ©--ÐÂÊÖ³é½±´ðÌâ½çÃæ....
-- 3 = 2007Ê¥µ®Ôªµ©--µ¹¼ÆÊ±´ðÌâ....
-- 4 = 2007ÔªÏü½Ú--µÆÃ ´ðÌâ½çÃæ....
local g_UIType = 0

local g_UIServerScript = { 311100, 050021, 050029, 050042, 808093, 250042 }

local g_Quiz_Frame_UnifiedPosition;

function Quiz_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Quiz_OnLoad()
	Quiz_Buttons[1] = Quiz_Button_1;
	Quiz_Buttons[2] = Quiz_Button_2;
	Quiz_Buttons[3] = Quiz_Button_3;
	
	g_Quiz_Frame_UnifiedPosition=Quiz_Frame:GetProperty("UnifiedPosition");
end

function Quiz_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 2 then
			g_UIType = 1
		elseif tonumber(arg0) == 20071224 then
			g_UIType = 2
		elseif tonumber(arg0) == 271261215 then
			g_UIType = 3
		elseif tonumber(arg0) == 20080221 then
			g_UIType = 4
		elseif tonumber(arg0) == 20080419 then
			g_UIType = 5
		elseif tonumber(arg0) == 20090627 then
			g_UIType = 6
		else
			return
		end
		Quiz_OnShown();

	elseif (event == "OBJECT_CARED_EVENT") then

		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Quiz_Cancel_Clicked()
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		Quiz_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Quiz_Frame_On_ResetPos()

	end
end

function Quiz_OnShown()

	Quiz_StopWatch : Hide()
	local UI_ID = Get_XParam_INT(0);

	if UI_ID == 1 then

			Quiz_Text : SetText( Get_XParam_STR(1) );
			Quiz_Button_1 : Show();
			Quiz_Button_1 : SetText("Trä l¶i")
			Quiz_Button_2 : Hide();
			Quiz_Button_3 : Hide();
			Quiz_Pageheader : SetText( Get_XParam_STR(0) );
			
			local xx = Get_XParam_INT(1);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if objCared == -1 then
					PushDebugMessage("L²i s¯ li®u!");
					return;
			end
			BeginCareObject_Quiz(objCared)

			Current = UI_ID;
			this:Show();

	elseif UI_ID == 2 then

			Question = Get_XParam_INT(2)
			Question_Sequence = Get_XParam_INT(1)
			if Question_Sequence == 1 then
				str = "";
			else
				str = "Chính xác!#rM¶i tiªp tøc trä l¶i#r";
			end
			if(Variable:GetVariable("System_CodePage") == "1258") then
				Quiz_Text : SetText(str .. ": " .. "Câu " .. Question_Sequence .. Get_XParam_STR(0) .. "#rChï có mµt ðáp án chính xác, nghî kÛ r°i ch÷n");
			else
				Quiz_Text : SetText(str .. "Câu " .. Question_Sequence .."Ð«: #r" .. Get_XParam_STR(0) .. "#rChï có mµt ðáp án chính xác, nghî kÛ r°i ch÷n");
			end
		
			Quiz_StopWatch : SetProperty("Timer","30");
			Quiz_StopWatch : Show();
		
			for i=1,3 do
				local str_temp = Get_XParam_STR(i);
				local answer_position = Get_XParam_INT(2+i)
				if  str_temp~= "#" and str_temp~="" then
					Quiz_Buttons[answer_position+1] : Show();
					Quiz_Buttons[answer_position+1] : SetText(str_temp)
					Button_Answer[answer_position+1] = i;
				else
					Quiz_Buttons[answer_position+1] : Hide();
				end
			end
			Current = UI_ID;
			this:Show();

	elseif UI_ID == 3 then

			Quiz_Text : SetText( Get_XParam_STR(0) );
			Question_Sequence = 0;
			Quiz_Button_1 : Show();
			Quiz_Button_1 : SetText("B¡t ð¥u lÕi");
			Quiz_Button_2 : Hide();
			Quiz_Button_3 : Hide();
			Current = UI_ID;
			this:Show();

	elseif UI_ID == 4 then

			Quiz_Text : SetText( Get_XParam_STR(0) );
			Quiz_Button_2 : SetText("R¶i")
			Quiz_Button_2 : Show();
			Quiz_Button_1 : Hide();
			Quiz_Button_3 : Hide();
			Current = UI_ID;
			this:Show();

	end

end

function Quiz_Button_Clicked(nAnswerNumber)

	if nAnswerNumber == 1 and Current == 1 then
		Question_Sequence = 0
		Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AskQuestion");
				Set_XSCRIPT_ScriptID(g_UIServerScript[g_UIType]);
				Set_XSCRIPT_Parameter(0,Question_Sequence+1);
				Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		return
	end

	if nAnswerNumber == 1 and Current == 3 then
		Question_Sequence = 0
		Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AskQuestion");
				Set_XSCRIPT_ScriptID(g_UIServerScript[g_UIType]);
				Set_XSCRIPT_Parameter(0,Question_Sequence+1);
				Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		return
	end

	if nAnswerNumber == 2 and Current == 4 then
		Quiz_Cancel_Clicked();
		return;
	end

	if nAnswerNumber > 0 and nAnswerNumber < 4 and Question > 0 then
		Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AnswerQuestion");
				Set_XSCRIPT_ScriptID(g_UIServerScript[g_UIType]);
				Set_XSCRIPT_Parameter(0,Question);
				Set_XSCRIPT_Parameter(1,Button_Answer[nAnswerNumber]);
				Set_XSCRIPT_Parameter(2,Question_Sequence);
				Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();
		return
	end
	
end

function Quiz_Cancel_Clicked()
	StopCareObject_Quiz(objCared)
	this:Hide();
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_Quiz(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Quiz");
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_Quiz(objCaredId)
	this:CareObject(objCaredId, 0, "Quiz");
	g_Object = -1;

end

--¼ÇÊ±µ½0ºó
function Quiz_OverTime()
	Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnOverTime");
			Set_XSCRIPT_ScriptID(g_UIServerScript[g_UIType]);
			Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
end

function Quiz_Frame_On_ResetPos()
  Quiz_Frame:SetProperty("UnifiedPosition", g_Quiz_Frame_UnifiedPosition);
end
