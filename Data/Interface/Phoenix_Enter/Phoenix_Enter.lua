local g_Phoenix_Enter_Frame_UnifiedPosition = nil 
local g_Phoenix_InitList = 0
local g_Phoenix_Enter_select = -1
local g_Phoenix_Buttons = {}






function Phoenix_Enter_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("TSPHOENIX_HIGH_ROOM")


end 

-- Phoenix_Enter_Client => DefaultWindow
-- Phoenix_Enter_Help => TLBB_ButtonHelp
-- Phoenix_Enter_Close => TLBB_ButtonClose
-- Phoenix_Enter_DragTitle => TLBB_DragTitle
function Phoenix_Enter_OnLoad()
	g_Phoenix_Enter_Frame_UnifiedPosition = Phoenix_Enter_Frame:GetProperty("UnifiedPosition");


end

function Phoenix_Enter_OnEvent(event)

	if(event == "ADJEST_UI_POS") then
		Phoenix_Enter_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Phoenix_Enter_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Phoenix_Enter_On_Hide()
	elseif(event == "TSPHOENIX_HIGH_ROOM") then

		local objCared = -1;
		local xx = tonumber(arg0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		this:CareObject(objCared, 1, "Phoenix_Enter");
		Phoenix_Enter_InitFream()
		Phoenix_Enter_Init()
		this:Show()
	end
end


function Phoenix_Enter_InitFream()


	if g_Phoenix_InitList == 0 then
		Phoenix_Enter_List:Clear()
		for i = 1,80 do
			local bar = Phoenix_Enter_List:AddChild("Phoenix_Enter_Client_Line1Btn_Bk")
			if bar then
				--bar:GetSubItem("Phoenix_Enter_Client_Line1Btn")
				bar:GetSubItem("Phoenix_Enter_Client_Line1Btn"):SetText(ScriptGlobal_Format("#{FHKF_20240315_36}",i))
				bar:GetSubItem("Phoenix_Enter_Client_Line1Btn"):SetEvent( "MouseLClick", "Phoenix_Enter_seleClicked("..i..")" )
				table.insert(g_Phoenix_Buttons,i,bar)
			end
		end


		g_Phoenix_InitList = 1
	end
end



function Phoenix_Enter_seleClicked(index)

	g_Phoenix_Enter_select = index
	for i=1,80 do
		if g_Phoenix_Buttons[i] ~= nil then
			if index == i then
				g_Phoenix_Buttons[i]:GetSubItem("Phoenix_Enter_Client_Line1Btn"):SetCheck(1)
			else
				g_Phoenix_Buttons[i]:GetSubItem("Phoenix_Enter_Client_Line1Btn"):SetCheck(0)
			end
			
		else


		end
		
	end	
end

function Phoenix_Enter_FormatColor(i,playernumber)


	--PushDebugMessage("button="..type(button))
	local color = ""
	if playernumber > 200 then
		color = "#cff0000"
	elseif playernumber >=151 and playernumber <= 200 then

		color = "#cff8a00"
	elseif playernumber >= 101 and playernumber <= 150 then

		color = "#cece58d"
	elseif playernumber <= 100 then
		color = "#c4cfa4c"
	end

	if g_Phoenix_Buttons[i] then
		g_Phoenix_Buttons[i]:GetSubItem("Phoenix_Enter_Client_Line1Btn"):SetText(color..ScriptGlobal_Format("#{FHKF_20240315_36}",i))
	end

end
function Phoenix_Enter_Init()

	
	local mydata = DataPool:Lua_GetTSPhoenixData()


	g_Phoenix_Enter_select = -1
	--PushDebugMessage("type="..type(mydata[1]))

	for i,v in ipairs(mydata) do
		if g_Phoenix_Buttons[i] ~= nil then
			if mydata[i] >= 0 then
				g_Phoenix_Buttons[i]:Enable()
			else

				g_Phoenix_Buttons[i]:Disable()
			end
			g_Phoenix_Buttons[i]:GetSubItem("Phoenix_Enter_Client_Line1Btn"):SetCheck(0)

			Phoenix_Enter_FormatColor(i,mydata[i])
			--PushDebugMessage("i="..i..",count="..v.m_uPlayerCount)
		end
		
	end
end



function Phoenix_Enter_Goto()
	 if g_Phoenix_Enter_select <= 0 then

	 	PushDebugMessage("#{FHKF_20240315_161}")
	 end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Client_GoTo")
		Set_XSCRIPT_ScriptID(403020)
		Set_XSCRIPT_Parameter(0, g_Phoenix_Enter_select)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end


function Phoenix_Enter_DClick(nIndex)

	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("Client_GoTo")
	Set_XSCRIPT_ScriptID(403020)
	Set_XSCRIPT_Parameter(0, nIndex)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Phoenix_Enter_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Phoenix_Enter");
end

function Phoenix_Enter_On_ResetPos()
	Phoenix_Enter_Frame:SetProperty("UnifiedPosition", g_Phoenix_Enter_Frame_UnifiedPosition)
end


function Phoenix_Enter_Frame_OnHiden()

end



function Phoenix_Enter_On_Hide()
	this:Hide()
end

function Phoenix_Enter_Help_Click()
end

function Phoenix_Enter_Close_Click()
end

