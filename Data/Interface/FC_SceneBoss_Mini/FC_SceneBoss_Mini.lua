
function FC_SceneBoss_Mini_PreLoad()
	
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("SHOW_ZJCBOSS_MINI");
	
end

function FC_SceneBoss_Mini_OnLoad()
end

function FC_SceneBoss_Mini_OnEvent(event)

	if (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
		
	elseif (event=="SHOW_ZJCBOSS_MINI") then
		if arg0 == "1" then
			local nSceneType = tonumber(arg1)
			if nSceneType == 1 then
				--不加杀气的内场
				FC_SceneBoss_Mini_PageHeader:SetText("#{SWZJ_250328_31}")
			else
				--加杀气的外场
				FC_SceneBoss_Mini_PageHeader:SetText("#{SWZJ_250328_14}")
			end
			this:Show()
		else
			this:Hide()
		end
		
	elseif (event  == "UI_COMMAND") and (tonumber(arg0) == 99883301) then
	
		if Get_XParam_INT(0) <= 0 then
			this:Hide()
			return
		end
		
	end
end

function FC_SceneBoss_Mini_Open()

	this:Hide()
	PushEvent("SHOW_ZJCBOSS_MAX", 1)

end

