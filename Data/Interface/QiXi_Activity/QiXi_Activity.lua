
local g_QiXi_Activity_Frame_UnifiedPosition;
local g_QiXi_Activity_ActivityTime = 
{
	[1] = {20230824,20230906,},
	[2] = {20230828,20230903,},
	[3] = {20230904,20230910,},
}
local g_QiXi_Activity_StartTime = 20230824
local g_QiXi_Activity_EndTime = 20230910

function QiXi_Activity_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")

end

function QiXi_Activity_OnLoad()

	g_QiXi_Activity_Frame_UnifiedPosition = QiXi_Activity_Frame:GetProperty("UnifiedPosition");
end

function QiXi_Activity_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0)== 2023072501  ) then
		this:Show()
		QiXi_Activity_Open()
		local isShowRedPoint = Get_XParam_INT( 0 )
		if isShowRedPoint == 1 then 
			QiXi_Activity_Go2_Tips:Show()
		else
			QiXi_Activity_Go2_Tips:Hide()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 2023072502  ) then
		--Âà∑Êñ∞Â∞èÁ∫¢ÁÇπ
		if not this:IsVisible() then
			return
		end
		local isShowRedPoint = Get_XParam_INT( 0 )
		if isShowRedPoint == 1 then 
			QiXi_Activity_Go2_Tips:Show()
		else
			QiXi_Activity_Go2_Tips:Hide()
		end
	elseif (event == "ADJEST_UI_POS" ) then
		QiXi_Activity_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		QiXi_Activity_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		QiXi_Activity_Close()
	end
end

function QiXi_Activity_Open()
	local curDay = DataPool:GetServerDayTime() 
	if curDay < g_QiXi_Activity_ActivityTime[1][1] then
		QiXi_Activity_Disable1:Show()
		QiXi_Activity_Go1:Hide()
		QiXi_Activity_TaskOver1:Hide()
	elseif curDay >= g_QiXi_Activity_ActivityTime[1][1] and curDay <= g_QiXi_Activity_ActivityTime[1][2] then
		QiXi_Activity_Disable1:Hide()
		QiXi_Activity_Go1:Show()
		QiXi_Activity_TaskOver1:Hide()
	else
		QiXi_Activity_Disable1:Hide()
		QiXi_Activity_Go1:Hide()
		QiXi_Activity_TaskOver1:Show()
	end

	if curDay < g_QiXi_Activity_ActivityTime[2][1] then
		QiXi_Activity_Disable2:Show()
		QiXi_Activity_Go2:Hide()
		QiXi_Activity_TaskOver2:Hide()
	elseif curDay >= g_QiXi_Activity_ActivityTime[2][1] and curDay <= g_QiXi_Activity_ActivityTime[2][2] then
		QiXi_Activity_Disable2:Hide()
		QiXi_Activity_Go2:Show()
		QiXi_Activity_TaskOver2:Hide()
	else
		QiXi_Activity_Disable2:Hide()
		QiXi_Activity_Go2:Hide()
		QiXi_Activity_TaskOver2:Show()
	end

	if curDay < g_QiXi_Activity_ActivityTime[3][1] then
		QiXi_Activity_Disable3:Show()
		QiXi_Activity_Go3:Hide()
		QiXi_Activity_TaskOver3:Hide()
	elseif curDay >= g_QiXi_Activity_ActivityTime[3][1] and curDay <= g_QiXi_Activity_ActivityTime[3][2] then
		
		QiXi_Activity_Disable3:Hide()
		QiXi_Activity_Go3:Show()
		QiXi_Activity_TaskOver3:Hide()
	else
		QiXi_Activity_Disable3:Hide()
		QiXi_Activity_Go3:Hide()
		QiXi_Activity_TaskOver3:Show()
	end


end

function QiXi_Activity_HelpInfo_Click(nIndex)
	--PushEvent("QIXI_ACTIVITY_CONFIRM",nIndex)
	if nIndex == 1 then
		PushEvent("CCSHOP_HELP", 17)
	elseif nIndex == 2 then
		PushEvent("CCSHOP_HELP", 18)
	elseif nIndex == 3 then
		PushEvent("CCSHOP_HELP", 19)
	end
end

function QiXi_Activity_Click(nIndex)
	if nIndex<1 or nIndex>3 then
		return
	end
	local curDay = DataPool:GetServerDayTime() 
	if curDay < g_QiXi_Activity_StartTime or curDay > g_QiXi_Activity_EndTime then
		PushDebugMessage( "#{QXFL_20230721_14}" )
		return
	end
	if curDay < g_QiXi_Activity_ActivityTime[nIndex][1] or curDay > g_QiXi_Activity_ActivityTime[nIndex][2] then
		PushDebugMessage( "#{QXFL_20230721_15}" )
		return
	end

	if nIndex == 1 then
		AutoRuntoTargetExWithName(163,111,2,"N∏nh ? L∏ch VÓ C‰o ?")
	end
	if nIndex == 2 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("RequestOpenUI");
			Set_XSCRIPT_ScriptID(998263);
			Set_XSCRIPT_Parameter(0,1);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	if nIndex == 3 then
		local nPlayerLevel = Player:GetData("LEVEL")
		if nPlayerLevel < 15 then
			if ( IsWindowShow( "SweepAll" ) ) then
				CloseWindow( "SweepAll", true );
				return
			end
		end	
		OpenSecKillList();
	end
end


function QiXi_Activity_Close()
	this:Hide()
end


function QiXi_Activity_Frame_On_ResetPos()
	QiXi_Activity_Frame:SetProperty("UnifiedPosition", g_QiXi_Activity_Frame_UnifiedPosition);
end
