--******************************
--特效
--******************************

local MainMenuBar_Animate_param = -1
local MainMenuBar_Animate_Ctrl = {}


function MainMenuBar_Animate_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	--玩家切场景
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

function MainMenuBar_Animate_OnLoad()
	MainMenuBar_Animate_Ctrl = {
		Button_Animate_Action1, Button_Animate_Action2, Button_Animate_Action3, Button_Animate_Action4
	}
end

function MainMenuBar_Animate_OnEvent(event)

  --5秒倒计时	
  if ( event == "UI_COMMAND" and tonumber(arg0) == 81011101) then
  	local param0 = Get_XParam_INT(0)
		if param0 == 2 then
			if MainMenuBar_Animate_param == -1 then
				this:Show()
			end
			MainMenuBar_Animate_param = Get_XParam_INT(1)
			if MainMenuBar_Animate_param > 4 then
				MainMenuBar_Animate_param = MainMenuBar_Animate_param - 4
			end
			for i=1,4 do
				MainMenuBar_Animate_Ctrl[i]:Hide()
			end
			MainMenuBar_Animate_Ctrl[MainMenuBar_Animate_param]:Show()
			MainMenuBar_Animate_Ctrl[MainMenuBar_Animate_param]:Play(true)
		else
			MainMenuBar_Animate_CloseUI()
    end
  elseif event=="HIDE_ON_SCENE_TRANSED"  then
		MainMenuBar_Animate_CloseUI()

  end

end

function MainMenuBar_Animate_Image_Close()
	MainMenuBar_Animate_CloseUI()
end
function MainMenuBar_Animate_CloseUI()
	MainMenuBar_Animate_param = -1
	this:Hide()
end
