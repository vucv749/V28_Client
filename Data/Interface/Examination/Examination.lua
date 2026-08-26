
local g_Examination_UnifiedPosition;

local g_Examination_Type = -1
local g_Examination_Script = -1
local g_Examination_targetId = -1;

local Current = -1;
local Question = 0;
local Question_Sequence = 0;
local Examination_Buttons = {}
local Button_Answer = {}
local Current_Answer = -1;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;

local HaveClicked = 0

local g_Examination_ResultImage = {
	[0] = "set:New_Keju image:New_Keju_Error",
	[1] = "set:New_Keju image:New_Keju_Yes",
}

function Examination_PreLoad()

	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	
end

function Examination_OnLoad()

	Examination_Buttons[1] = Examination_Button_1;
	Examination_Buttons[2] = Examination_Button_2;
	Examination_Buttons[3] = Examination_Button_3;

	g_Examination_UnifiedPosition = Examination_Frame:GetProperty("UnifiedPosition");
	
end

function Examination_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 28) then
	
			Examination_OnShown();
			
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		
		if(tonumber(arg0) ~= objCared) then
			return
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then			
			--取消关心
			Examination_Cancel_Clicked()
		end

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Examination_Cancel_Clicked()
		
	elseif (event == "ADJEST_UI_POS" ) then
		Examination_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Examination_On_ResetPos()
		
	end
end

function Examination_OnShown()

	local UI_ID = Get_XParam_INT(0)
	if UI_ID == 2 then
		-- 答题
		Question_Sequence = Get_XParam_INT(1)
		Question = Get_XParam_INT(2)
			
		local strquest = Get_XParam_STR(0)
		str = ScriptGlobal_Format("#{KJYH_221013_119}", strquest) -- 题目
		Examination_Text:SetText( str );
		Examination_Text:Show();
			
		local strtype = Get_XParam_STR(7)
		str = ScriptGlobal_Format("#{KJYH_221013_120}", strtype) -- 类型：
		Examination_Type_Text:SetText( str )
		Examination_Type_Text:Show();
			
		str = ScriptGlobal_Format("#{KJYH_221013_121}", Question_Sequence) -- 第X题
		Examination_Number_Text:SetText( str )
		Examination_Number_Text:Show();
					
		for i=1,3 do
			Examination_Buttons[i]:SetText("")
			Button_Answer[i] = -1
		end									
		for i=1,3 do
			local str_temp = Get_XParam_STR(i);
			local answer_position = Get_XParam_INT(2+i)
			if  str_temp~= "#" and str_temp~="" then
				Examination_Buttons[answer_position+1] : Show();
				Examination_Buttons[answer_position+1] : SetText(str_temp)
				Button_Answer[answer_position+1] = i;
			end
		end
			
		g_Examination_Type = Get_XParam_INT(9);
		local NPCName =	Target:GetDialogNpcName();
		local str = ScriptGlobal_Format("#{KJYH_221013_117}", NPCName) -- NPCName..(共5题)  
		if g_Examination_Type == 2 then
			str = ScriptGlobal_Format("#{KJYH_221013_131}", NPCName)
		end
		Examination_NPCName_Text:SetText( str )
		Examination_NPCName_Text:Show()
		
		g_Examination_Script = Get_XParam_INT(10); 
		g_Examination_targetId = Get_XParam_INT(11);
		objCared = DataPool : GetNPCIDByServerID(g_Examination_targetId);
		if objCared == -1 then
			return;
		end
		BeginCareObject_Examination(objCared)
						
		HaveClicked = 0
		Examination_Result:Hide()
		Examination_Button_Next:Hide()
		Current = UI_ID;
		this:Show();
	elseif UI_ID == 11 then
	
		Examination_Result:Show()
		Examination_Button_Next:Show()
		
		Examination_Result:SetProperty("Image", "set:New_Keju image:New_Keju_Error")
		
		for i=1,3 do 
			Examination_Buttons[i]:Disable()
		end
		
		if Examination_Buttons[Current_Answer] ~= nil then
			local str_temp = "#gFF0FA0"..Examination_Buttons[Current_Answer]:GetText()
			Examination_Buttons[Current_Answer]:SetText( str_temp )
			Examination_Buttons[Current_Answer]:SetProperty("DisabledImage", "set:New_Keju image:New_Keju_Btn_Hover")
		end
		
		if Get_XParam_INT(1) == 1 then
			Examination_Button_Next:Hide()
		end
		
		Current = UI_ID;
		
		return
		
	elseif UI_ID == 22 then
	
		Examination_Result:Show()
		Examination_Button_Next:Show()
		
		Examination_Result:SetProperty("Image", "set:New_Keju image:New_Keju_Yes")
				
		for i=1,3 do 
			Examination_Buttons[i]:Disable()
		end
		
		if Examination_Buttons[Current_Answer] ~= nil then
			local str_temp = "#gFF0FA0"..Examination_Buttons[Current_Answer]:GetText()
			Examination_Buttons[Current_Answer]:SetText(str_temp)
			Examination_Buttons[Current_Answer]:SetProperty("DisabledImage", "set:New_Keju image:New_Keju_Btn_Hover")
		end
		
		if Get_XParam_INT(1) == 1 then
			Examination_Button_Next:Hide()
		end
		
		Current = UI_ID;
		
		return
	end
	
	Examination_Time_Text : Show();			
	Examination_Time_Text : SetProperty("Timer","1");
	Examination_Button_1:Disable()
	Examination_Button_1:SetProperty("DisabledImage", "set:New_Keju image:New_Keju_Btn_Normal")
	Examination_Button_2:Disable()
	Examination_Button_2:SetProperty("DisabledImage", "set:New_Keju image:New_Keju_Btn_Normal")
	Examination_Button_3:Disable()
	Examination_Button_3:SetProperty("DisabledImage", "set:New_Keju image:New_Keju_Btn_Normal")
	
end

function Examination_Button_Clicked( nAnswerNumber )
	
	-- 答题
	if Question > 0 then
		if nAnswerNumber > 0 and nAnswerNumber < 4 then
			if HaveClicked == 1 then
				return
			end
			HaveClicked = 1
			
			for i=1,3 do 
				Examination_Buttons[i]:Disable()
			end
			
			Current_Answer = nAnswerNumber 
			
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AnswerQuestion");
				Set_XSCRIPT_ScriptID(890037);
				Set_XSCRIPT_Parameter(0, Question);
				Set_XSCRIPT_Parameter(1, Button_Answer[nAnswerNumber]);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
			return
		end
	end

end

function Examination_Cancel_Clicked()
	
	StopCareObject_Examination(objCared)
	this:Hide();
	
end

function Examination_Next_Clicked()

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AnswerNextQuestion");
		Set_XSCRIPT_ScriptID(890037);
		Set_XSCRIPT_Parameter(0, 1);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
			
end

function Examination_On_ResetPos()

  Examination_Frame:SetProperty("UnifiedPosition", g_Examination_UnifiedPosition);
  
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Examination(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Examination");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Examination(objCaredId)
	this:CareObject(objCaredId, 0, "Examination");
	g_Object = -1;
end

function Examination_OnHiden()

	Current_Answer = -1 	

	if (Current == 22 or Current == 11) and Question > 0 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnOverTime");
			Set_XSCRIPT_ScriptID(890037);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	end		
	
	StopCareObject_Examination(objCared)
	this:Hide();
	
end

--记时到0后
function Examination_TimeOut()

	Examination_Button_1:Enable()
	Examination_Button_1:SetProperty("DisabledImage", "set:New_Keju image:New_Keju_Btn_Disabled")
	Examination_Button_2:Enable()
	Examination_Button_2:SetProperty("DisabledImage", "set:New_Keju image:New_Keju_Btn_Disabled")
	Examination_Button_3:Enable()
	Examination_Button_3:SetProperty("DisabledImage", "set:New_Keju image:New_Keju_Btn_Disabled")
	
end

