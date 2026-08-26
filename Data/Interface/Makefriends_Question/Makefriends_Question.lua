local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;


function Makefriends_Question_PreLoad()

	--this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("UI_COMMAND")
end

function Makefriends_Question_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Makefriends_Question_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Makefriends_Question_Frame:GetProperty("UnifiedYPosition");
end

function Makefriends_Question_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		Makefriends_Question_ResetPos()
	 elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Makefriends_Question_ResetPos()
	--elseif( event == "HIDE_ON_SCENE_TRANSED" ) then
	--	this:Hide();
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 998329001) then	--显示问题
		local nQuestionIndex = Get_XParam_INT(0) 
		local nLeaveTime = Get_XParam_INT(1) 
		local nQuestion, nAnswerA, nAnswerB = GetJYQuestion(nQuestionIndex)
		Makefriends_Question_Text:SetText(nQuestion)
		Makefriends_Question_Time:SetText("#{JYHD_230331_167}")
		Makefriends_Question_WatchText:SetProperty("Timer", tostring(nLeaveTime))
		this:Show()
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 998329004) then	--关闭问题
		this:Hide()
	end
	
end

function Makefriends_Question_ResetPos()

	Makefriends_Question_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Makefriends_Question_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);

end


function Makefriends_Question_OnHiden()
	
end

function Makefriends_Question_Close()

	this:Hide()
end

function Makefriends_Question_Button_Clicked()

	AutoRuntoTargetExWithName(98, 94, 633, "钟灵")

end