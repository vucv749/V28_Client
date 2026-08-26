--******************************
--圣诞应景-圣诞树倒计时
--******************************
local ShengdanYingjing_Timing_Frame_UnifiedPosition;

function ShengdanYingjing_Timing_PreLoad()
    this:RegisterEvent("UI_COMMAND",true)
    --玩家切场景
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

function ShengdanYingjing_Timing_OnLoad()
    ShengdanYingjing_Timing_Frame_UnifiedPosition = ShengdanYingjing_Timing_Frame:GetProperty("UnifiedPosition");
end

function ShengdanYingjing_Timing_OnEvent(event)

    --圣诞应景 : 5秒倒计时	
    if ( event == "UI_COMMAND" and tonumber(arg0) == 89004902) then
        if Get_XParam_INT(0) == 1 then
            ShengdanYingjing_Timing_Animate:Show()
            ShengdanYingjing_Timing_Animate:Play(true)
            SetTimer("ShengdanYingjing_Timing","ShengdanYingjing_Timing_Animate_Close()", 5*1000)
            this:Show()	
        end
    elseif event== "HIDE_ON_SCENE_TRANSED"  then
        ShengdanYingjing_Timing_CloseUI()

    -- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ShengdanYingjing_Timing_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShengdanYingjing_Timing_Frame_On_ResetPos()
    end

end

function ShengdanYingjing_Timing_Animate_Close()
     KillTimer("ShengdanYingjing_Timing_Animate_Close()")
    --停止倒计时动画
    ShengdanYingjing_Timing_Animate:Play(false)
end

function ShengdanYingjing_Timing_CloseUI()
    this:Hide()
end
--=========================================================
--界面隐藏
--=========================================================
function ShengdanYingjing_Timing_OnHiden()
    this:Hide()
end

function ShengdanYingjing_Timing_Frame_On_ResetPos()
    ShengdanYingjing_Timing_Frame:SetProperty("UnifiedPosition", ShengdanYingjing_Timing_Frame_UnifiedPosition);
end