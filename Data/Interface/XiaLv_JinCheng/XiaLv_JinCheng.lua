local XiaLv_JinCheng_Frame_UnifiedPosition;

local ManStr;
local WomanStr;
--GUID
local ManGuid;
local WomanGuid;
--进度
local Progress;
local CountDownTime;



function XiaLv_JinCheng_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ON_SCENE_TRANS");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function XiaLv_JinCheng_OnLoad()
	XiaLv_JinCheng_Frame_UnifiedPosition = XiaLv_JinCheng_Frame:GetProperty("UnifiedPosition");
    
    XiaLv_JinCheng_Help:SetEvent("Clicked", "XiaLv_JinCheng_help()")

    XiaLv_JinCheng_Get:SetEvent("Clicked", "XiaLv_JinCheng_GetFlower()")
    XiaLv_JinCheng_Get2:SetEvent("Clicked", "XiaLv_JinCheng_GetFlower()")
    XiaLv_JinCheng_OK:SetEvent("Clicked", "XiaLv_JinCheng_Skip()")
end

function XiaLv_JinCheng_OnEvent(event)


    --更新结婚状态
	if event == "UI_COMMAND"and tonumber(arg0) == 40103001 then

        --双方名字
        ManStr =  Get_XParam_STR( 0 )
        WomanStr =  Get_XParam_STR( 1 )
        --GUID
        ManGuid =  Get_XParam_STR( 2 )
        WomanGuid =  Get_XParam_STR( 3 )

        --进度
        local progressTemp =  Get_XParam_INT( 0 )
        --时间
        CountDownTime =  Get_XParam_INT( 1 )

        if progressTemp == Progress and this:IsVisible() then
            XiaLv_JinCheng_UpdateTime(Progress)
            return
        else
            Progress = progressTemp
        end

        XiaLv_JinCheng_UpdateUI(Progress)

	elseif (event == "ADJEST_UI_POS" ) then
        XiaLv_JinCheng_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
        XiaLv_JinCheng_Frame_On_ResetPos()
    elseif (event == "ON_SCENE_TRANS") or (event == "PLAYER_LEAVE_WORLD") then
        this:Hide()
	end

end


function XiaLv_JinCheng_UpdateUI(progress)

    XiaLv_JinCheng_Get:Hide()
    XiaLv_JinCheng_Get2:Hide()
    XiaLv_JinCheng_OK:Hide()
    XiaLv_JinCheng_NowTime2:Show()
    XiaLv_JinCheng_XinNiangInfo:Hide()
    XiaLv_JinCheng_BingKeInfo:Hide()

    if ManStr ~= "" or WomanStr ~= "" then
        XiaLv_JinCheng_Man:SetText(ManStr)
        XiaLv_JinCheng_Woman:SetText(WomanStr)
    end

    if progress == 1 or progress == 2 then
        XiaLv_JinCheng_Man:SetText(ManStr)
        XiaLv_JinCheng_Woman:SetText(WomanStr)

        XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage1");


    elseif progress == 4 then
        --交换信物
        XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage2");

        if tostring(Player:GetGUID()) ==  ManGuid  or tostring(Player:GetGUID()) ==  WomanGuid then

            XiaLv_JinCheng_XinNiangInfo:SetText("#{JHYH_230330_323}")
            XiaLv_JinCheng_XinNiangInfo:Show()
        else
            XiaLv_JinCheng_BingKeInfo:SetText("#{JHYH_230330_324}")
            XiaLv_JinCheng_BingKeInfo:Show()
        end

    elseif progress == 51 then

        if tostring(Player:GetGUID()) ==  ManGuid then

            XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage3");

            local str = ScriptGlobal_Format("#{JHYH_230330_273}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()


        elseif tostring(Player:GetGUID()) ==  WomanGuid then

            XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage3");

            local str = ScriptGlobal_Format("#{JHYH_230330_156}",CountDownTime)
            XiaLv_JinCheng_BingKeInfo:SetText(str)
            XiaLv_JinCheng_BingKeInfo:Show()


            XiaLv_JinCheng_Get:SetText("#{JHYH_230330_154}")
            XiaLv_JinCheng_Get:Show()

            XiaLv_JinCheng_OK:Show()
        else

            XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage3");
            XiaLv_JinCheng_XinNiangInfo:SetText("#{JHYH_230330_328}")
            XiaLv_JinCheng_XinNiangInfo:Show()
        end

    elseif progress == 52 then

        if tostring(Player:GetGUID()) ==  ManGuid then

            XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage3");

            local str = ScriptGlobal_Format("#{JHYH_230330_158}",CountDownTime)
            XiaLv_JinCheng_BingKeInfo:SetText(str)
            XiaLv_JinCheng_BingKeInfo:Show()

            XiaLv_JinCheng_Get2:SetText("#{JHYH_230330_154}")
            XiaLv_JinCheng_Get2:Show()

        elseif tostring(Player:GetGUID()) ==  WomanGuid then

            XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage3");
            XiaLv_JinCheng_NowTime2:Show()
            local str = ScriptGlobal_Format("#{JHYH_230330_270}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()

        else

            XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage3");

            XiaLv_JinCheng_XinNiangInfo:SetText("#{JHYH_230330_328}")
            XiaLv_JinCheng_XinNiangInfo:Show()
        end
    elseif progress == 54 then

        XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage3");

        if tostring(Player:GetGUID()) ==  ManGuid then

            local str = ScriptGlobal_Format("#{JHYH_230330_327}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()

        elseif tostring(Player:GetGUID()) ==  WomanGuid then
            local str = ScriptGlobal_Format("#{JHYH_230330_327}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()
        else
            local str = ScriptGlobal_Format("#{JHYH_230330_272}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()
        end

    elseif progress == 6 then
        XiaLv_JinCheng_NowTime2:SetProperty("Image","set:Xialv02 image:XiaLv_MarryStatus_Stage4");
        XiaLv_JinCheng_XinNiangInfo:SetText("#{JHYH_230330_275}")
        XiaLv_JinCheng_XinNiangInfo:Show()


    end

    if not this:IsVisible() then
        this:Show()
    end
end


function XiaLv_JinCheng_UpdateTime(progress)

    if progress == 51 then

        if tostring(Player:GetGUID()) ==  ManGuid then

            local str = ScriptGlobal_Format("#{JHYH_230330_273}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()


        elseif tostring(Player:GetGUID()) ==  WomanGuid then

            local str = ScriptGlobal_Format("#{JHYH_230330_156}",CountDownTime)
            XiaLv_JinCheng_BingKeInfo:SetText(str)
            XiaLv_JinCheng_BingKeInfo:Show()

        end

    elseif progress == 52 then

        if tostring(Player:GetGUID()) ==  ManGuid then

            local str = ScriptGlobal_Format("#{JHYH_230330_158}",CountDownTime)
            XiaLv_JinCheng_BingKeInfo:SetText(str)
            XiaLv_JinCheng_BingKeInfo:Show()

        elseif tostring(Player:GetGUID()) ==  WomanGuid then

            local str = ScriptGlobal_Format("#{JHYH_230330_270}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()

        end

    elseif progress == 54 then

        if tostring(Player:GetGUID()) ==  ManGuid then

            local str = ScriptGlobal_Format("#{JHYH_230330_327}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()

        elseif tostring(Player:GetGUID()) ==  WomanGuid then
            local str = ScriptGlobal_Format("#{JHYH_230330_327}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()
        else
            local str = ScriptGlobal_Format("#{JHYH_230330_272}",CountDownTime)
            XiaLv_JinCheng_XinNiangInfo:SetText(str)
            XiaLv_JinCheng_XinNiangInfo:Show()
        end

    end
end


function XiaLv_JinCheng_Skip()
    Clear_XSCRIPT();
        Set_XSCRIPT_Function_Name("JinChengUIOperate");
        Set_XSCRIPT_ScriptID(401030);
        Set_XSCRIPT_Parameter(0,1);
        Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();
end

function XiaLv_JinCheng_help()
    Clear_XSCRIPT();
        Set_XSCRIPT_Function_Name("JinChengUIOperate");
        Set_XSCRIPT_ScriptID(401030);
        Set_XSCRIPT_Parameter(0,2);
        Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();
end

function XiaLv_JinCheng_GetFlower()
    Clear_XSCRIPT();
        Set_XSCRIPT_Function_Name("JinChengUIOperate");
        Set_XSCRIPT_ScriptID(401030);
        Set_XSCRIPT_Parameter(0,3);
        Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();
end

function XiaLv_JinCheng_Frame_On_ResetPos()
    XiaLv_JinCheng_Frame:SetProperty("UnifiedPosition", XiaLv_JinCheng_Frame_UnifiedPosition);
end
