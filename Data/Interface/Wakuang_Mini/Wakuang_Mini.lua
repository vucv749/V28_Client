

local g_Wakuang_Mini_SceneId;

function Wakuang_Mini_PreLoad()

	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	this:RegisterEvent("WAKUANG_SWITCH")
	this:RegisterEvent("UI_COMMAND")
end

function Wakuang_Mini_OnLoad()	

end

function Wakuang_Mini_OnEvent(event)

	if event == "WAKUANG_SWITCH" then
		local opType = tonumber(arg0)
		if opType == 1 then
			this:Show()
		else
			this:Hide()
		end
	elseif event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20230315 then
		local opType =  Get_XParam_INT( 0 );
		g_Wakuang_count = Get_XParam_INT( 1 );
		g_Wakuang_Midcount = Get_XParam_INT( 2 );
		g_Wakuang_Highcount = Get_XParam_INT(3);
		g_Wakuang_strInfo = Get_XParam_STR(0)
		if opType == 4 then
			this:Hide()
		end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 202303151 then
		local opType =  Get_XParam_INT( 0 )
		--g_Wakuang2_count = Get_XParam_INT( 1 )
		--g_Wakuang2_lowcount = Get_XParam_INT( 2 )
		--g_Wakuang2_strInfo = Get_XParam_STR(0)
		if opType == 4 then
			this:Hide()
		end		
	end
end


function Wakuang_Mini_Open()
		PushEvent("WAKUANG_SWITCH", 2)
end