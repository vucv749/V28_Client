--ShenbingGuide界面
local g_ShenbingGuide_Frame_UnifiedXPosition;
local g_ShenbingGuide_Frame_UnifiedYPosition;
local ShenbingGuide_g_OnpenUI = 89027401
local g_ShenbingGuide_CurYe = 1 --???
local g_ShenbingGuide_CurIntro = 1 --????
local g_ShenbingGuide_IntroduceInfo = {
	[1] = {
		[1] = { text = "#{SQYD_230802_80}", MaxImg = 1, img = 1, },
		[2] = { text = "#{SQYD_230802_81}", MaxImg = 2, img = 2, },
	},
	[2] = {
		[1] = { text = "#{SQYD_230802_104}", MaxImg = 2, img = 3, },
		[2] = { text = "#{SQYD_230802_86}", MaxImg = 2, img = 4, },
		[3] = { text = "#{SQYD_230802_88}", MaxImg = 1, img = 5, },
	},
	[3] = {
		[1] = { text = "#{SQYD_230802_89}", MaxImg = 1, img = 6, },
		[2] = { text = "#{SQYD_230802_90}", MaxImg = 1, img = 7, },
	},
}
--每个部分的右侧图片 有多犈并且有翻页功能
local g_ShenbingGuide_CurImage = 1
local g_ShenbingGuide_MaxImage = 1
local g_ShenbingGuide_CurImageTableIndex = 1
local g_ShenbingGuide_ImageTabl = {
	--七情刃
	[1] = {[1] = "set:ShenbingGuide2 image:ShenbingGuide_js",},
	[2] = 
	{
		[1] = "set:ShenbingGuide4 image:ShenbingGuide_sx",
		[2] = "set:ShenbingGuide4 image:ShenbingGuide_sbsj",
		--[3] = "set:ShenbingGuide4 image:ShenbingGuide_sbsx",
		--[4] = "set:ShenbingGuide4 image:ShenbingGuide_sbjj",
		--[5] = "set:ShenbingGuide4 image:ShenbingGuide_xl",
	},
	--技能
	[3] = 
	{
		[1] = "set:ShenbingGuide2 image:ShenbingGuide_jnjs_befo",
		[2] = "set:ShenbingGuide2 image:ShenbingGuide_jnjs_after",
	},
	[4] = 
	{
		[1] = "set:ShenbingGuide2 image:ShenbingGuide_jnxz",
		[2] = "set:ShenbingGuide2 image:ShenbingGuide_jnjs",
	},
	[5] = {[1] = "set:ShenbingGuide2 image:ShenbingGuide_jnsj",},
	--副本
	[6] = {[1] = "set:ShenbingGuide4 image:WRMJ",},
	[7] = {[1] = "set:ShenbingGuide3 image:WJDE",},
}
local g_ShenbingGuide_BindButtonTabl = {}
--===============================================
-- PreLoad()
--===============================================
function ShenbingGuide_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

--===============================================
-- OnLoad()
--===============================================
function ShenbingGuide_OnLoad()
	-- 保存界面的默认相对位置
	g_ShenbingGuide_Frame_UnifiedXPosition = ShenbingGuide_Frame:GetProperty("UnifiedXPosition");
	g_ShenbingGuide_Frame_UnifiedYPosition = ShenbingGuide_Frame:GetProperty("UnifiedYPosition");
	g_ShenbingGuide_BindButtonTabl[1] = ShenbingGuide_Bind
	g_ShenbingGuide_BindButtonTabl[2] = ShenbingGuide_Bind2
	g_ShenbingGuide_BindButtonTabl[3] = ShenbingGuide_Bind3
	g_ShenbingGuide_BindButtonTabl[4] = ShenbingGuide_Bind4
	g_ShenbingGuide_BindButtonTabl[5] = ShenbingGuide_Bind5
	g_ShenbingGuide_BindButtonTabl[6] = ShenbingGuide_Bind6
	g_ShenbingGuide_BindButtonTabl[7] = ShenbingGuide_Bind7
end

--===============================================
-- OnEvent()
--===============================================
function ShenbingGuide_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == ShenbingGuide_g_OnpenUI) then
		ShenbingGuide_UpdateUi()
		this:Show();
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShenbingGuide_OnClose()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenbingGuide_UpdateUIPos()
	elseif (event == "ADJEST_UI_POS") then
		ShenbingGuide_UpdateUIPos()
	end
end

--关睜界面
function ShenbingGuide_OnClose()
	g_ShenbingGuide_CurYe = 1 --???
	g_ShenbingGuide_CurIntro = 1 --????
	g_ShenbingGuide_CurImage = 1
	g_ShenbingGuide_MaxImage = 1
	g_ShenbingGuide_CurImageTableIndex = 1
	this:Hide()
end

--分页按钮
function ShenbingGuide_FenyeClicked(index)
	if index <1 or index >3 then
		return
	end
	g_ShenbingGuide_CurYe = index
	g_ShenbingGuide_CurIntro = 1
	ShenbingGuide_UpdateUi()
end

--小按钮
function ShenbingGuide_ModeClicked(index)
	if index <1 or index >7 then
		return
	end
	g_ShenbingGuide_CurIntro = index
	ShenbingGuide_UpdateUi()
end

--图片翻页按钮
function ShenbingGuide_PageUp()
	g_ShenbingGuide_CurImage = g_ShenbingGuide_CurImage - 1
	if g_ShenbingGuide_CurImage < 1  then--??
		g_ShenbingGuide_CurImage = 1
	elseif g_ShenbingGuide_CurImage > g_ShenbingGuide_MaxImage  then
		g_ShenbingGuide_CurImage = g_ShenbingGuide_MaxImage
	end
	ShenbingGuide_Right2_PageUp:Enable()
	ShenbingGuide_Right2_PageDown:Enable()
	if g_ShenbingGuide_CurImage == 1 then
		ShenbingGuide_Right2_PageUp:Disable()
	end
	if g_ShenbingGuide_CurImage == g_ShenbingGuide_MaxImage then
		ShenbingGuide_Right2_PageDown:Disable()
	end
	if g_ShenbingGuide_CurImage >= 1 and g_ShenbingGuide_CurImage <= g_ShenbingGuide_MaxImage then
		ShenbingGuide_Right2_Image:SetProperty("Image",g_ShenbingGuide_ImageTabl[g_ShenbingGuide_CurImageTableIndex][g_ShenbingGuide_CurImage]);
	end
	local yeStr = ScriptGlobal_Format("#{SQYD_230802_113}",tostring(g_ShenbingGuide_CurImage),tostring(g_ShenbingGuide_MaxImage) )
	ShenbingGuide_Right2_Info2:SetText(yeStr)
end
function ShenbingGuide_PageDown()
	g_ShenbingGuide_CurImage = g_ShenbingGuide_CurImage + 1

	if g_ShenbingGuide_CurImage < 1  then--??
		g_ShenbingGuide_CurImage = 1
	end
	if g_ShenbingGuide_CurImage > g_ShenbingGuide_MaxImage  then
		g_ShenbingGuide_CurImage = g_ShenbingGuide_MaxImage
	end
	ShenbingGuide_Right2_PageUp:Enable()
	ShenbingGuide_Right2_PageDown:Enable()
	if g_ShenbingGuide_CurImage == 1 then
		ShenbingGuide_Right2_PageUp:Disable()
	end
	if g_ShenbingGuide_CurImage == g_ShenbingGuide_MaxImage then
		ShenbingGuide_Right2_PageDown:Disable()
	end
	if g_ShenbingGuide_CurImage >= 1 and g_ShenbingGuide_CurImage <= g_ShenbingGuide_MaxImage then
		ShenbingGuide_Right2_Image:SetProperty("Image",g_ShenbingGuide_ImageTabl[g_ShenbingGuide_CurImageTableIndex][g_ShenbingGuide_CurImage]);
	end
	local yeStr = ScriptGlobal_Format("#{SQYD_230802_113}",tostring(g_ShenbingGuide_CurImage),tostring(g_ShenbingGuide_MaxImage) )
	ShenbingGuide_Right2_Info2:SetText(yeStr)
end

--更新界面
function ShenbingGuide_UpdateUi()
	if g_ShenbingGuide_CurYe == 1 then
		ShenbingGuide_Bind:Show()
		ShenbingGuide_Bind:SetText("#{SQYD_230802_46}")
		ShenbingGuide_Bind2:Show()
		ShenbingGuide_Bind2:SetText("#{SQYD_230802_47}")
		ShenbingGuide_Bind3:Hide()
		ShenbingGuide_Bind3:SetText("")
		ShenbingGuide_Bind4:Hide()
		ShenbingGuide_Bind4:SetText("")
		ShenbingGuide_Bind5:Hide()
		ShenbingGuide_Bind5:SetText("")
		ShenbingGuide_Bind6:Hide()
		ShenbingGuide_Bind6:SetText("")
		ShenbingGuide_Bind7:Hide()
		ShenbingGuide_Bind7:SetText("")
		ShenbingGuide_Choice_1:SetCheck(1)
		ShenbingGuide_Choice_2:SetCheck(0)
		ShenbingGuide_Choice_3:SetCheck(0)
	elseif g_ShenbingGuide_CurYe == 2 then
		ShenbingGuide_Bind:Show()
		ShenbingGuide_Bind:SetText("#{SQYD_230802_17}")
		ShenbingGuide_Bind2:Show()
		ShenbingGuide_Bind2:SetText("#{SQYD_230802_52}")
		ShenbingGuide_Bind3:Show()
		ShenbingGuide_Bind3:SetText("#{SQYD_230802_54}")
		ShenbingGuide_Bind4:Hide()
		ShenbingGuide_Bind4:SetText("")
		ShenbingGuide_Bind5:Hide()
		ShenbingGuide_Bind5:SetText("")
		ShenbingGuide_Bind6:Hide()
		ShenbingGuide_Bind6:SetText("")
		ShenbingGuide_Bind7:Hide()
		ShenbingGuide_Bind7:SetText("")
		ShenbingGuide_Choice_1:SetCheck(0)
		ShenbingGuide_Choice_2:SetCheck(1)
		ShenbingGuide_Choice_3:SetCheck(0)
	elseif g_ShenbingGuide_CurYe == 3 then
		ShenbingGuide_Bind:Show()
		ShenbingGuide_Bind:SetText("#{SQYD_230802_56}")
		ShenbingGuide_Bind2:Show()
		ShenbingGuide_Bind2:SetText("#{SQYD_230802_57}")
		ShenbingGuide_Bind3:Hide()
		ShenbingGuide_Bind3:SetText("")
		ShenbingGuide_Bind4:Hide()
		ShenbingGuide_Bind4:SetText("")
		ShenbingGuide_Bind5:Hide()
		ShenbingGuide_Bind5:SetText("")
		ShenbingGuide_Bind6:Hide()
		ShenbingGuide_Bind6:SetText("")
		ShenbingGuide_Bind7:Hide()
		ShenbingGuide_Bind7:SetText("")
		ShenbingGuide_Choice_1:SetCheck(0)
		ShenbingGuide_Choice_2:SetCheck(0)
		ShenbingGuide_Choice_3:SetCheck(1)
	end
	ShenbingGuide_Right1_Text:SetText(g_ShenbingGuide_IntroduceInfo[g_ShenbingGuide_CurYe][g_ShenbingGuide_CurIntro].text)
	--ShenbingGuide_Right2_Image:SetProperty("Image",g_ShenbingGuide_IntroduceInfo[g_ShenbingGuide_CurYe][g_ShenbingGuide_CurIntro].img);
	--初始化右侧图片部分
	g_ShenbingGuide_CurImage = 1
	g_ShenbingGuide_MaxImage = g_ShenbingGuide_IntroduceInfo[g_ShenbingGuide_CurYe][g_ShenbingGuide_CurIntro].MaxImg
	g_ShenbingGuide_CurImageTableIndex = g_ShenbingGuide_IntroduceInfo[g_ShenbingGuide_CurYe][g_ShenbingGuide_CurIntro].img
	ShenbingGuide_Right2_Image:SetProperty("Image",g_ShenbingGuide_ImageTabl[g_ShenbingGuide_CurImageTableIndex][g_ShenbingGuide_CurImage]);
	ShenbingGuide_Right2_PageUp:Disable()
	ShenbingGuide_Right2_PageDown:Enable()
	if g_ShenbingGuide_MaxImage == 1 then --????? ?????????????disable
		ShenbingGuide_Right2_PageDown:Disable()
	end
	g_ShenbingGuide_BindButtonTabl[g_ShenbingGuide_CurIntro]:SetCheck(1)
	local yeStr = ScriptGlobal_Format("#{SQYD_230802_113}",tostring(g_ShenbingGuide_CurImage),tostring(g_ShenbingGuide_MaxImage) )
	ShenbingGuide_Right2_Info2:SetText(yeStr)
end
--调狖位置
function ShenbingGuide_UpdateUIPos()
	ShenbingGuide_Frame:SetProperty("UnifiedXPosition", g_ShenbingGuide_Frame_UnifiedXPosition);
	ShenbingGuide_Frame:SetProperty("UnifiedYPosition", g_ShenbingGuide_Frame_UnifiedYPosition);
end
