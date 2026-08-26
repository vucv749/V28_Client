--******************************
--ÆÁÄ»ÉÁË¸ÌØÐ§
--******************************

--local g_Biwuzhaoqin_Tips_Image={
--"set:ShaXing6 image:Tips_Chang1",
--"set:ShaXing6 image:Tips_Chang2",
--}

function Biwuzhaoqin_Tips_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--Íæ¼ÒÇÐ³¡¾°
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

function Biwuzhaoqin_Tips_OnLoad()
end


function Biwuzhaoqin_Tips_OnEvent(event)

	if( event == "UI_COMMAND" and tonumber(arg0) == 79210802) then
--		local nIdx = Get_XParam_INT(0)
--		if nIdx<1 or nIdx>table.getn(g_Biwuzhaoqin_Tips_Image) then
--			return
--		end

--		Biwuzhaoqin_Tips:SetProperty("Image", g_Biwuzhaoqin_Tips_Image[nIdx]);
		SetTimer("Biwuzhaoqin_Tips","Biwuzhaoqin_Tips_TimerProc()", 5000)
		this:Show()

	elseif event=="HIDE_ON_SCENE_TRANSED"  then
		Biwuzhaoqin_Tips_CloseUI()
	end

end

function Biwuzhaoqin_Tips_CloseUI()
	KillTimer("Biwuzhaoqin_Tips_TimerProc")
	this:Hide()
end

function Biwuzhaoqin_Tips_TimerProc()
--PushDebugMessage("Biwuzhaoqin_Tips_TimerProc")
	KillTimer("Biwuzhaoqin_Tips_TimerProc()")
	this:Hide()
end

