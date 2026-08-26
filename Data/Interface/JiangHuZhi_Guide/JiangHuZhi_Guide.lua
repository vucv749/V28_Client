local g_Frame_UnifiedPosition
local g_FenYe = 1
local g_MD = 0
local g_MDList = {}
local g_FenYe_Button = {}

local g_Gudie_Content = {
	[1] = {str = "#{QEYD_240402_138}",str2 = "#{QEYD_240402_131}",image = "set:JiangHuZhi_02 image:Mission_1"},
	[2] = {str = "#{QEYD_240402_141}",str2 = "#{QEYD_240402_132}",image = "set:JiangHuZhi_02 image:Mission_2"},
	[3] = {str = "#{QEYD_240402_143}",str2 = "#{QEYD_240402_133}",image = "set:JiangHuZhi_03 image:Mission_3"},
	[4] = {str = "#{QEYD_240402_146}",str2 = "#{QEYD_240402_134}",image = "set:JiangHuZhi_03 image:Mission_4"},
}

local g_Item_List = {
	30008115,
	20600003,
	38002498,
	30503154
}

--=========
-- PreLoad()
--=========
function JiangHuZhi_Guide_PreLoad()

	this:RegisterEvent("UI_COMMAND")--??or????
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--???????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function JiangHuZhi_Guide_OnLoad()

	g_Frame_UnifiedPosition = JiangHuZhi_Frame:GetProperty("UnifiedPosition")

	g_FenYe_Button[1] = JiangHuZhi_Fenye1
	g_FenYe_Button[2] = JiangHuZhi_Fenye2
	g_FenYe_Button[3] = JiangHuZhi_Fenye3
	g_FenYe_Button[4] = JiangHuZhi_Fenye4
end

--=========
-- Event
--=========
function JiangHuZhi_Guide_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99879701 ) then

		--∑÷“≥
		g_FenYe = Get_XParam_INT( 0 )
		g_MD = Get_XParam_INT( 1 )
		JiangHuZhi_ModeClicked(g_FenYe)
		JiangHuZhi_Guide_SetFrame(g_FenYe)

	elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		JiangHuZhi_Guide_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		JiangHuZhi_Guide_On_ResetPos()
    end

end


function JiangHuZhi_Guide_SetFrame(fenYe)
	local temp = 0
	temp = math.floor(g_MD/1000)
	g_MDList[1] = math.mod(temp,10)

	temp = math.floor(g_MD/100)
	g_MDList[2] = math.mod(temp,10)

	temp = math.floor(g_MD/10)
	g_MDList[3] = math.mod(temp,10)

	g_MDList[4] = math.mod(g_MD,10)


	for i=1, 4 do
		if g_MDList[i] == 0 then
			--g_FenYe_Button[i]:SetText("#{QEYD_240402_135}")
			g_FenYe_Button[i]:Disable()
		else
			g_FenYe_Button[i]:Enable()
			--g_FenYe_Button[i]:SetText( g_Gudie_Content[i].str2 )
		end
	end

	g_FenYe_Button[fenYe]:SetCheck(1)

	this:Show()
end


function JiangHuZhi_ModeClicked(nIndex)
	g_FenYe = nIndex
	JiangHuZhi_Intro_Text:SetText( g_Gudie_Content[g_FenYe].str )
	JiangHuZhi_Right2_Image:SetProperty("Image",g_Gudie_Content[g_FenYe].image);
end


--=========
--÷ÿ÷√
--=========
function JiangHuZhi_Guide_On_ResetPos()
	JiangHuZhi_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

--=========
--πÿ±†
--=========
function  JiangHuZhi_OnClose()

	g_FenYe = 1
	g_MD = 0

	JiangHuZhi_Intro_Text:SetText( g_Gudie_Content[g_FenYe].str )
	JiangHuZhi_Right2_Image:SetProperty("Image",g_Gudie_Content[g_FenYe].image);

	this:Hide()
end
