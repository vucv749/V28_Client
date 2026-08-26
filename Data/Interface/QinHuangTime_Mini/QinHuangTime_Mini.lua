

local g_QinHuangTime_Mini_SceneId;

function QinHuangTime_Mini_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	this:RegisterEvent("QIHUANTIME_SWITCH")
end

function QinHuangTime_Mini_OnLoad()	

end

function QinHuangTime_Mini_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 20210510 then
		local opType =  Get_XParam_INT( 0 );
		if opType == 1 then
			if (this:IsVisible()) then
				this:Hide()
			end
		elseif opType == 2 then
			if (this:IsVisible()) then
				QinHuangTime_Mini_Update()
			end
		elseif opType == 1000 then
			if (this:IsVisible()) then
				this:Hide()
			end
		else
			if (this:IsVisible()) then
				this:Hide()
			end
		end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20210519 then
		local opType =  Get_XParam_INT( 0 );
		-- PushDebugMessage(opType)
		if opType == 1 then
			if (this:IsVisible()) then
				this:Hide()
			end
		elseif opType == 2 then
			if (this:IsVisible()) then
				QinHuangTime_Mini_Update()
			end
		elseif opType == 1000 then
			if (this:IsVisible()) then
				this:Hide()
			end
		else
			if (this:IsVisible()) then
				this:Hide()
			end
		end
	elseif event == "QIHUANTIME_SWITCH" then
		local opType = tonumber(arg0)
		if opType == 1 then
			g_QinHuangTime_Mini_SceneId = tonumber(arg1)
			this:Show()
			QinHuangTime_Mini_Update()
		else
			this:Hide()
		end
	elseif event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
	end
end
function QinHuangTime_Mini_Update()
	
	if g_QinHuangTime_Mini_SceneId == 1286 then
		QinHuangTime_Mini_PageHeader:SetText("#{MJXZ_210510_09}")
	elseif g_QinHuangTime_Mini_SceneId == 1287 then
		QinHuangTime_Mini_PageHeader:SetText("#{MJXZ_210510_18}")
	elseif g_QinHuangTime_Mini_SceneId == 1288 then
		QinHuangTime_Mini_PageHeader:SetText("#{MJXZ_210510_21}")
	elseif LuaFnIsActDiGong4Scene(g_QinHuangTime_Mini_SceneId) == 1 then
		QinHuangTime_Mini_PageHeader:SetText("#{MJXZ_210510_26}")
	end	
end

function QinHuangTime_Mini_Open()
	if g_QinHuangTime_Mini_SceneId == 1286 or g_QinHuangTime_Mini_SceneId == 1287 or g_QinHuangTime_Mini_SceneId == 1288 then
		PushEvent("QIHUANTIME_SWITCH", 2, g_QinHuangTime_Mini_SceneId)
	elseif LuaFnIsActDiGong4Scene(g_QinHuangTime_Mini_SceneId) == 1 then
		PushEvent("QIHUANTIME_SWITCH", 3, g_QinHuangTime_Mini_SceneId)
	end
end