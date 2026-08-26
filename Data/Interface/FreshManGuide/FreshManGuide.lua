-- 新手指引ui ---只有  
local g_Frame_Width = 0
local g_Frame_Height = 0

local g_Frame_SizeRaw = ""
local g_Lace_SizeRaw = "" 
local g_Ctl_Corner = {}
   
local g_X_Offset = 0  --?????????
local g_Y_Offset = 0  --??
local g_Direct   = "" --?????????
local g_cached_textstr = -1 
local g_Text = {
    [1] = { dict ="#{}", flashtime = 5000},
}
function FreshManGuide_PreLoad()
	this:RegisterEvent("OPEN_FRESHMAN_GUIDE")
	this:RegisterEvent("CLOSE_FRESHMAN_GUIDE")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function FreshManGuide_OnLoad()

	--note：two varibles below will be set to string in fact, so do not compare with number directly.
	g_Frame_Width  = FreshManGuide_Frame:GetProperty("AbsoluteWidth")
	g_Frame_Height = FreshManGuide_Frame:GetProperty("AbsoluteHeight") 
	g_Frame_SizeRaw = FreshManGuide_Frame:GetProperty("UnifiedSize")
	g_Lace_SizeRaw = FreshManGuide_Lace:GetProperty("UnifiedSize")

	g_Ctl_Corner = {  --???,???
        FreshManGuide_UpLeft,
        FreshManGuide_UpRight,
        FreshManGuide_DownRight,
        FreshManGuide_DownLeft,
    }
end

function FreshManGuide_OnEvent(event)
	if event == "OPEN_FRESHMAN_GUIDE" then
	    if 1 ~= FreshManGuide_CheckSize(tonumber(arg4), tonumber(arg5)) then
	        return  -- ????????????,??????
	    end
	    if "" == GetFreshManGuideOwner() or "PlayerQuicklyEnter" ~= GetFreshManGuideOwner() then
			assert("" == GetFreshManGuideOwner())
			assert("PlayerQuicklyEnter" ~= GetFreshManGuideOwner())
			return  -- ????????
	    end
	    if 1 == tonumber(arg0) then
            FreshManGuide_Reset(tonumber(arg0),tonumber(arg1), tonumber(arg2), tonumber(arg3), tonumber(arg4), tonumber(arg5), arg6)
        elseif 2 == tonumber(arg0) then
            FreshManGuide_Reset(tonumber(arg0), tonumber(arg1), tonumber(arg2), tonumber(arg3), tonumber(arg4), tonumber(arg5), arg6)
        elseif 3 == tonumber(arg0) and this:IsVisible() then 
            FreshManGuide_Modify(tonumber(arg1), tonumber(arg2), tonumber(arg3), tonumber(arg4), tonumber(arg5), arg6)
        end
        return
	end

	if event == "ADJEST_UI_POS" or
	    event == "VIEW_RESOLUTION_CHANGED" or
	    event == "CLOSE_FRESHMAN_GUIDE" then
		FreshManGuide_Close()
        return
	end
end

function FreshManGuide_Close()
    if not this:IsVisible() then
        return
    end

    KillTimer("FreshManGuide_Close()")
    this:Hide()
end

function FreshManGuide_Reset(ntype, nTextID, nTipPosX, nTipPosY, nClientWidth, nClientHight, szCorner) 
    if ntype == 1 then
        local ButtonCount 	= GetPlayerQuickEnterCount()
	    local g_Flex		= GetPlayerQuickEnterHide() 

	    if type(g_Flex)  ~= "table" or g_Flex[nTextID] == nil or nTextID > ButtonCount then
	    	return
        end 
        
        g_cached_textstr = g_Flex[nTextID].FreshStr          
        KillTimer("FreshManGuide_Close()")
        FreshManGuide_Modify(nTipPosX, nTipPosY, nClientWidth, nClientHight, szCorner)
        SetTimer("FreshManGuide", "FreshManGuide_Close()", tonumber(g_Flex[nTextID].FreshFlash)) 
    elseif ntype == 2 then
        g_cached_textstr = g_Text[nTextID].dict
        KillTimer("FreshManGuide_Close()")
        FreshManGuide_Modify(nTipPosX, nTipPosY, nClientWidth, nClientHight, szCorner)
        SetTimer("FreshManGuide", "FreshManGuide_Close()", tonumber(g_Text[nTextID].flashtime)) 
    end
	 
	this:Show()
end

--szCorner代表调用犨期望的显示方位
--如期望方位显示不下本窗口,才进入自由选择
function FreshManGuide_Modify(nTipPosX, nTipPosY, nClientWidth, nClientHight, szCorner)  
	 
	if nTipPosX ~= -1 or nTipPosY ~= -1 then             --??-1,?????????
        g_X_Offset = nTipPosX                            --?tip??????????
        g_Y_Offset = nTipPosY
    end
    if szCorner ~= "" then                               --??,??????
        g_Direct = szCorner
	end
	FreshManGuide_CrackSize()
    local OffsetX, OffsetY = GetWindowPos(GetFreshManGuideOwner()) --??????????????
    OffsetX = OffsetX + g_X_Offset                       --?tip?????????????
    OffsetY = OffsetY + g_Y_Offset  
	
	if "northwest" == g_Direct and 
        OffsetX - g_Frame_Width > 0 and OffsetY - g_Frame_Height > 0 then
        FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY - g_Frame_Height)
        FreshManGuide_Show_Corner(3)   --????,show???
    elseif "northeast" == g_Direct and
        OffsetX + g_Frame_Width - nClientWidth < 0 and OffsetY - g_Frame_Height > 0 then
        FreshManGuide_To(OffsetX, OffsetY - g_Frame_Height)
		FreshManGuide_Show_Corner(4)   --????,show???
		Lua_TDU_Log("FreshManGuide_Modify northeast: "..OffsetX )
		Lua_TDU_Log("FreshManGuide_Modify northeast: "..OffsetY - g_Frame_Height )
    elseif "southeast" == g_Direct and
        OffsetX + g_Frame_Width - nClientWidth < 0 and OffsetY + g_Frame_Height - nClientHight < 0 then
        FreshManGuide_To(OffsetX, OffsetY)
        FreshManGuide_Show_Corner(1)   --????,show???
    elseif "southwest" == g_Direct and
        OffsetX - g_Frame_Width > 0 and OffsetY + g_Frame_Height - nClientHight < 0 then
        FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY)
        FreshManGuide_Show_Corner(2)   --????,show???
    else
        if OffsetX - g_Frame_Width < 0 then
            if OffsetY - g_Frame_Height < 0 then
                FreshManGuide_To(OffsetX, OffsetY)
                FreshManGuide_Show_Corner(1)
            else
                FreshManGuide_To(OffsetX, OffsetY - g_Frame_Height)
                FreshManGuide_Show_Corner(4)
            end
        else
            if OffsetY - g_Frame_Height < 0 then
                FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY)
                FreshManGuide_Show_Corner(2)
            else
                FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY - g_Frame_Height)
                FreshManGuide_Show_Corner(3)
            end
        end
    end
    FreshManGuide_GuideInfo:SetText(g_cached_textstr) 
end

function FreshManGuide_To(nXPos, nYPos)
    FreshManGuide_Frame:SetProperty("AbsoluteXPosition", nXPos)
    FreshManGuide_Frame:SetProperty("AbsoluteYPosition", nYPos)
end

function FreshManGuide_Show_Corner(nIdx)
    if nil == g_Ctl_Corner[nIdx] then
        return
    end

    for i = 1, table.getn(g_Ctl_Corner) do
       if nIdx == i then
           g_Ctl_Corner[i]:Show()
       else
           g_Ctl_Corner[i]:Hide()
       end
    end
end

function FreshManGuide_CheckSize(nClientWidth, nClientHight)
    if g_Frame_Width - nClientWidth > 0 or g_Frame_Height - nClientHight > 0 then
        return 0
    end
    return 1
end
 
function FreshManGuide_CrackSize() 
    FreshManGuide_Frame:SetProperty("UnifiedSize", tostring(g_Frame_SizeRaw) )
    FreshManGuide_Lace:SetProperty("UnifiedSize", tostring(g_Lace_SizeRaw) )
	g_Frame_Width  = FreshManGuide_Frame:GetProperty("AbsoluteWidth")
	g_Frame_Heigh = FreshManGuide_Frame:GetProperty("AbsoluteHeight")

end

