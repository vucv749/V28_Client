--

-- 保存UI默认位置
local Makefriends_Activity_UnifiedPosition = nil
local g_CampImage =
{ 
	[1] = "set:NewExterior3 image:NewExterior_jiaobiao_xianshi", --wolf
	[2] = "set:NewExterior3 image:NewExterior_jiaobiao_xianshi", --rabbit
}

local g_CampInfoMsg =
{ 
	[1] = "#{JYHD_230331_88}", --wolf
	[2] = "#{JYHD_230331_89}", --rabbit
}

local g_CampNameMsg =
{ 
	[1] = "#{JYHD_230331_157}", --wolf
	[2] = "#{JYHD_230331_158}", --rabbit
}




function Makefriends_Activity_PreLoad()
   
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
    this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("JIAOYOU_SHOW_BIG")

end -- end func Makefriends_Activity_PreLoad()

function Makefriends_Activity_OnLoad()
    Makefriends_Activity_UnifiedPosition = Makefriends_Activity_Frame:GetProperty("UnifiedPosition")
end -- end func Makefriends_Activity_OnLoad()

function Makefriends_Activity_OnEvent(event)
	if (event == "HIDE_ON_SCENE_TRANSED") then
        Makefriends_Activity_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        Makefriends_Activity_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        Makefriends_Activity_UnifiedPos()
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 998329002) then	--??????
		local nCurRand  = Get_XParam_INT(0) 
		local nCurRoundCampResult  = Get_XParam_INT(1) 
		local nCamp  = Get_XParam_INT(2) 
		local nScore  = Get_XParam_INT(3) 
		local nLeaveRabbitNum  = Get_XParam_INT(4) 
		local nLeaveTime  = Get_XParam_INT(5) 
		local nkillNum  = Get_XParam_INT(6) 
		Makefriends_Activity_Show()
		Makefriends_Activity_Updata(nCurRand, nCurRoundCampResult, nCamp, nScore, nLeaveRabbitNum, nLeaveTime, nkillNum)
    elseif event == "UI_COMMAND" and (tonumber(arg0) == 998329003) then	--????
		this:Hide()
	end
end -- end func Makefriends_Activity_OnEvent()

function Makefriends_Activity_Updata(nCurRand, nCurRoundCampResult, nCamp, nScore, nLeaveRabbitNum, nLeaveTime, nkillNum)
    
	if nCurRoundCampResult == 1 then
		if nCamp == 1 then
			--Makefriends_Activity_Info1:SetProperty("Image", g_CampImage[1])
			Makefriends_Activity_Info2:SetText(g_CampInfoMsg[1])
			Makefriends_Activity_Info8:SetText(g_CampNameMsg[1])
			Makefriends_Activity_Rabbit:Hide()
			Makefriends_Activity_Fox:Show()
			Makefriends_Activity_Info9:SetText( ScriptGlobal_Format("#{JYHD_230331_187}", nkillNum))
		else
			--Makefriends_Activity_Info1:SetProperty("Image", g_CampImage[2])
			Makefriends_Activity_Info2:SetText(g_CampInfoMsg[2])
			Makefriends_Activity_Info8:SetText(g_CampNameMsg[2])
			Makefriends_Activity_Rabbit:Show()
			Makefriends_Activity_Fox:Hide()
			Makefriends_Activity_Info9:SetText( "#{JYHD_230331_188}")
		end
	elseif nCurRoundCampResult == 2 then 
		if nCamp == 1 then
			--Makefriends_Activity_Info1:SetProperty("Image", g_CampImage[2])
			Makefriends_Activity_Info2:SetText(g_CampInfoMsg[2])
			Makefriends_Activity_Info8:SetText(g_CampNameMsg[2])
			Makefriends_Activity_Rabbit:Show()
			Makefriends_Activity_Fox:Hide()
			Makefriends_Activity_Info9:SetText( "#{JYHD_230331_188}")
			
		else
			--Makefriends_Activity_Info1:SetProperty("Image", g_CampImage[1])
			Makefriends_Activity_Info2:SetText(g_CampInfoMsg[1])
			Makefriends_Activity_Info8:SetText(g_CampNameMsg[1])
			Makefriends_Activity_Rabbit:Hide()
			Makefriends_Activity_Fox:Show()
			Makefriends_Activity_Info9:SetText( ScriptGlobal_Format("#{JYHD_230331_187}", nkillNum))
		end
	end
	
	Makefriends_Activity_Info3:SetText( ScriptGlobal_Format("#{JYHD_230331_46}", nCurRand))
	Makefriends_Activity_Info4:SetText( ScriptGlobal_Format("#{JYHD_230331_47}", nLeaveRabbitNum))
	--Makefriends_Activity_Info5:Hide()
	Makefriends_Activity_Info5_TimeWatch:SetProperty("Timer", tostring(nLeaveTime))
	Makefriends_Activity_Info6:SetText( ScriptGlobal_Format("#{JYHD_230331_48}", nScore))
	
	
	
	
end -- end func Makefriends_Activity_Updata()


-- 界面默认位置
function Makefriends_Activity_UnifiedPos()
    if (this:IsVisible()) then
        if (Makefriends_Activity_UnifiedPosition ~= nil) then
            Makefriends_Activity_Frame:SetProperty("UnifiedPosition", Makefriends_Activity_UnifiedPosition)
        end
    end
end -- end func Makefriends_Activity_UnifiedPos()

function Makefriends_Activity_Show()
	if IsWindowShow("Makefriends_Activity_Mini") then
	
	else
		this:Show()
	end
    
end -- end func Makefriends_Activity_Show()

function Makefriends_Activity_Hide()
    this:Hide()
end -- end func Makefriends_Activity_Hide()

-- 关睜按钮点击事件
function Makefriends_Activity_Close_Clicked()
    PushEvent("JIAOYOU_SHOW_MINI")
	Makefriends_Activity_Hide()
end  -- end func Makefriends_Activity_Close_Clicked()

function Makefriends_Activity_Help()
    PushEvent("CCSHOP_HELP", 16)
end -- end func Makefriends_Activity_Help()

function Makefriends_Activity_OnHiden()

end
