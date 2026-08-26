--****************************************
-- 雁门梦境 休息室 常驻界面
-- limengyue 2023-07-21
--****************************************


local g_YanMenMeng_XiuXi_Frame_UnifiedPosition;
--关心NPc
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local g_Object = -1
--当前选择休息室id
local g_YanMenMeng_XiuXiMax = 20 --????20??????
local g_YanMenMeng_XiuXiIdx = -1
local g_YanMenMeng_Object = -1
-- 控件表
local g_YanMenMeng_XiuXi_Self = nil
local g_YanMenMeng_XiuXi_OtherList = {}		--??????
local g_YanMenMeng_XiuXi_TxtList = {}		--??????
--服务器名
local g_YanMenMeng_XiuXi_NameList = 
{
	[1]= {gray="#{YMMJ_230626_351}",green="#{YMMJ_230626_331}",yellow="#{YMMJ_230626_311}",orange="#{YMMJ_230626_291}",red="#{YMMJ_230626_271}",},
	[2]= {gray="#{YMMJ_230626_352}",green="#{YMMJ_230626_332}",yellow="#{YMMJ_230626_312}",orange="#{YMMJ_230626_292}",red="#{YMMJ_230626_272}",},
	[3]= {gray="#{YMMJ_230626_353}",green="#{YMMJ_230626_333}",yellow="#{YMMJ_230626_313}",orange="#{YMMJ_230626_293}",red="#{YMMJ_230626_273}",},
	[4]= {gray="#{YMMJ_230626_354}",green="#{YMMJ_230626_334}",yellow="#{YMMJ_230626_314}",orange="#{YMMJ_230626_294}",red="#{YMMJ_230626_274}",},
	[5]= {gray="#{YMMJ_230626_355}",green="#{YMMJ_230626_335}",yellow="#{YMMJ_230626_315}",orange="#{YMMJ_230626_295}",red="#{YMMJ_230626_275}",},
	[6]= {gray="#{YMMJ_230626_356}",green="#{YMMJ_230626_336}",yellow="#{YMMJ_230626_316}",orange="#{YMMJ_230626_296}",red="#{YMMJ_230626_276}",},
	[7]= {gray="#{YMMJ_230626_357}",green="#{YMMJ_230626_337}",yellow="#{YMMJ_230626_317}",orange="#{YMMJ_230626_297}",red="#{YMMJ_230626_277}",},
	[8]= {gray="#{YMMJ_230626_358}",green="#{YMMJ_230626_338}",yellow="#{YMMJ_230626_318}",orange="#{YMMJ_230626_298}",red="#{YMMJ_230626_278}",},
	[9]= {gray="#{YMMJ_230626_359}",green="#{YMMJ_230626_339}",yellow="#{YMMJ_230626_319}",orange="#{YMMJ_230626_299}",red="#{YMMJ_230626_279}",},
	[10]={gray="#{YMMJ_230626_360}",green="#{YMMJ_230626_340}",yellow="#{YMMJ_230626_320}",orange="#{YMMJ_230626_300}",red="#{YMMJ_230626_280}",},
	[11]={gray="#{YMMJ_230626_361}",green="#{YMMJ_230626_341}",yellow="#{YMMJ_230626_321}",orange="#{YMMJ_230626_301}",red="#{YMMJ_230626_281}",},
	[12]={gray="#{YMMJ_230626_362}",green="#{YMMJ_230626_342}",yellow="#{YMMJ_230626_322}",orange="#{YMMJ_230626_302}",red="#{YMMJ_230626_282}",},
	[13]={gray="#{YMMJ_230626_363}",green="#{YMMJ_230626_343}",yellow="#{YMMJ_230626_323}",orange="#{YMMJ_230626_303}",red="#{YMMJ_230626_283}",},
	[14]={gray="#{YMMJ_230626_364}",green="#{YMMJ_230626_344}",yellow="#{YMMJ_230626_324}",orange="#{YMMJ_230626_304}",red="#{YMMJ_230626_284}",},
	[15]={gray="#{YMMJ_230626_365}",green="#{YMMJ_230626_345}",yellow="#{YMMJ_230626_325}",orange="#{YMMJ_230626_305}",red="#{YMMJ_230626_285}",},
	[16]={gray="#{YMMJ_230626_366}",green="#{YMMJ_230626_346}",yellow="#{YMMJ_230626_326}",orange="#{YMMJ_230626_306}",red="#{YMMJ_230626_286}",},
	[17]={gray="#{YMMJ_230626_367}",green="#{YMMJ_230626_347}",yellow="#{YMMJ_230626_327}",orange="#{YMMJ_230626_307}",red="#{YMMJ_230626_287}",},
	[18]={gray="#{YMMJ_230626_368}",green="#{YMMJ_230626_348}",yellow="#{YMMJ_230626_328}",orange="#{YMMJ_230626_308}",red="#{YMMJ_230626_288}",},
	[19]={gray="#{YMMJ_230626_369}",green="#{YMMJ_230626_349}",yellow="#{YMMJ_230626_329}",orange="#{YMMJ_230626_309}",red="#{YMMJ_230626_289}",},
	[20]={gray="#{YMMJ_230626_370}",green="#{YMMJ_230626_350}",yellow="#{YMMJ_230626_330}",orange="#{YMMJ_230626_310}",red="#{YMMJ_230626_290}",},
	[21]={gray="#{YMMJ_230626_263}",green="#{YMMJ_230626_263}",yellow="#{YMMJ_230626_263}",orange="#{YMMJ_230626_263}",red="#{YMMJ_230626_263}",},
}

--===============================================
-- OnLoad()
--===============================================
function YanMenMeng_XiuXi_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--距离NPC距离
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--切场景事件
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--===============================================
-- OnLoad()
--===============================================
function YanMenMeng_XiuXi_OnLoad()   
	-- 保存界面的默认相对位置
	g_YanMenMeng_XiuXi_Frame_UnifiedPosition = YanMenMeng_XiuXi_Frame:GetProperty("UnifiedPosition");
	--本服
	g_YanMenMeng_XiuXi_Self = YanMenMeng_XiuXi_SelectServerBtn
	--跨服
	g_YanMenMeng_XiuXi_OtherList[1] = YanMenMeng_XiuXi_SelectServerBtn1
	g_YanMenMeng_XiuXi_OtherList[2] = YanMenMeng_XiuXi_SelectServerBtn2
	g_YanMenMeng_XiuXi_OtherList[3] = YanMenMeng_XiuXi_SelectServerBtn3
	g_YanMenMeng_XiuXi_OtherList[4] = YanMenMeng_XiuXi_SelectServerBtn4
	g_YanMenMeng_XiuXi_OtherList[5] = YanMenMeng_XiuXi_SelectServerBtn5
	g_YanMenMeng_XiuXi_OtherList[6] = YanMenMeng_XiuXi_SelectServerBtn6
	g_YanMenMeng_XiuXi_OtherList[7] = YanMenMeng_XiuXi_SelectServerBtn7
	g_YanMenMeng_XiuXi_OtherList[8] = YanMenMeng_XiuXi_SelectServerBtn8
	g_YanMenMeng_XiuXi_OtherList[9] = YanMenMeng_XiuXi_SelectServerBtn9
	g_YanMenMeng_XiuXi_OtherList[10] = YanMenMeng_XiuXi_SelectServerBtn10
	g_YanMenMeng_XiuXi_OtherList[11] = YanMenMeng_XiuXi_SelectServerBtn11
	g_YanMenMeng_XiuXi_OtherList[12] = YanMenMeng_XiuXi_SelectServerBtn12
	g_YanMenMeng_XiuXi_OtherList[13] = YanMenMeng_XiuXi_SelectServerBtn13
	g_YanMenMeng_XiuXi_OtherList[14] = YanMenMeng_XiuXi_SelectServerBtn14
	g_YanMenMeng_XiuXi_OtherList[15] = YanMenMeng_XiuXi_SelectServerBtn15
	g_YanMenMeng_XiuXi_OtherList[16] = YanMenMeng_XiuXi_SelectServerBtn16
	g_YanMenMeng_XiuXi_OtherList[17] = YanMenMeng_XiuXi_SelectServerBtn17
	g_YanMenMeng_XiuXi_OtherList[18] = YanMenMeng_XiuXi_SelectServerBtn18
	g_YanMenMeng_XiuXi_OtherList[19] = YanMenMeng_XiuXi_SelectServerBtn19
	g_YanMenMeng_XiuXi_OtherList[20] = YanMenMeng_XiuXi_SelectServerBtn20
	--名字显示
	g_YanMenMeng_XiuXi_TxtList[1] = YanMenMeng_XiuXi_SelectServerBtn1Text
	g_YanMenMeng_XiuXi_TxtList[2] = YanMenMeng_XiuXi_SelectServerBtn2Text
	g_YanMenMeng_XiuXi_TxtList[3] = YanMenMeng_XiuXi_SelectServerBtn3Text
	g_YanMenMeng_XiuXi_TxtList[4] = YanMenMeng_XiuXi_SelectServerBtn4Text
	g_YanMenMeng_XiuXi_TxtList[5] = YanMenMeng_XiuXi_SelectServerBtn5Text
	g_YanMenMeng_XiuXi_TxtList[6] = YanMenMeng_XiuXi_SelectServerBtn6Text
	g_YanMenMeng_XiuXi_TxtList[7] = YanMenMeng_XiuXi_SelectServerBtn7Text
	g_YanMenMeng_XiuXi_TxtList[8] = YanMenMeng_XiuXi_SelectServerBtn8Text
	g_YanMenMeng_XiuXi_TxtList[9] = YanMenMeng_XiuXi_SelectServerBtn9Text
	g_YanMenMeng_XiuXi_TxtList[10] = YanMenMeng_XiuXi_SelectServerBtn10Text
	g_YanMenMeng_XiuXi_TxtList[11] = YanMenMeng_XiuXi_SelectServerBtn11Text
	g_YanMenMeng_XiuXi_TxtList[12] = YanMenMeng_XiuXi_SelectServerBtn12Text
	g_YanMenMeng_XiuXi_TxtList[13] = YanMenMeng_XiuXi_SelectServerBtn13Text
	g_YanMenMeng_XiuXi_TxtList[14] = YanMenMeng_XiuXi_SelectServerBtn14Text
	g_YanMenMeng_XiuXi_TxtList[15] = YanMenMeng_XiuXi_SelectServerBtn15Text
	g_YanMenMeng_XiuXi_TxtList[16] = YanMenMeng_XiuXi_SelectServerBtn16Text
	g_YanMenMeng_XiuXi_TxtList[17] = YanMenMeng_XiuXi_SelectServerBtn17Text
	g_YanMenMeng_XiuXi_TxtList[18] = YanMenMeng_XiuXi_SelectServerBtn18Text
	g_YanMenMeng_XiuXi_TxtList[19] = YanMenMeng_XiuXi_SelectServerBtn19Text
	g_YanMenMeng_XiuXi_TxtList[20] = YanMenMeng_XiuXi_SelectServerBtn20Text
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function YanMenMeng_XiuXi_Frame_On_ResetPos()
	YanMenMeng_XiuXi_Frame:SetProperty("UnifiedPosition", g_YanMenMeng_XiuXi_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function YanMenMeng_XiuXi_OnEvent(event)

    if(event == "UI_COMMAND" and tonumber(arg0) == 99844301) then
		--打开界面
		if(IsWindowShow("YanMenMeng_XiuXi")) then
			CloseWindow("YanMenMeng_XiuXi", true)
		end
		--添加NPC关心
		if Get_XParam_INT(0) >= 0 then
			g_YanMenMeng_Object = Get_XParam_INT(0)
			objCared = DataPool : GetNPCIDByServerID(Get_XParam_INT(0));
			YanMenMeng_XiuXi_BeginCareObject(objCared)
		end
		YanMenMeng_XiuXi_Open(tonumber(Get_XParam_INT(1)),tonumber(Get_XParam_INT(2)),tonumber(Get_XParam_INT(3)),tonumber(Get_XParam_INT(4)),tonumber(Get_XParam_INT(5)))
	end
	if (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return
		end

		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			YanMenMeng_XiuXi_Close()
		end
	end
    -- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		YanMenMeng_XiuXi_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YanMenMeng_XiuXi_Frame_On_ResetPos()
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       YanMenMeng_XiuXi_Close()
    end
         
end

--===============================================
-- YanMenMeng_XiuXi_Close()
--===============================================
function YanMenMeng_XiuXi_Close()
	YanMenMeng_XiuXi_StopCareObject()
	this:Hide()
end

--=========================================================
--开始关心NPC
--=========================================================
function YanMenMeng_XiuXi_BeginCareObject(objCaredId)
	if g_Object ~= -1 then
		this:CareObject(objCaredId, 0, "YanMenMeng_XiuXi");
	end
	g_Object = objCaredId
	this:CareObject(g_Object, 1, "YanMenMeng_XiuXi")
end


--=========================================================
--停止对某NPC的关心
--=========================================================
function YanMenMeng_XiuXi_StopCareObject()
	if g_Object ~= -1 then
		this:CareObject(g_Object, 0, "YanMenMeng_XiuXi");
		g_Object = -1;
	end
end


--===============================================
-- 打开界面
--===============================================
function YanMenMeng_XiuXi_Open(nState1,nState2,nState3,nState4,nPreIdx)
	--PushDebugMessage("test nState1="..nState1.." nState2="..nState2.." nState3="..nState3.." nState4="..nState4.." nPreIdx="..nPreIdx)
	--初始化数据 0未开放 1畅通 2正常 3拥挤 4爆满 五个服合一个数据
	local nStateList = {}--??????
	--floor 取整 mod取余
	nStateList[1] = math.floor( (math.mod(nState1,100000))/10000 )  
	nStateList[2] = math.floor( (math.mod(nState1,10000))/1000 )  
	nStateList[3] = math.floor( (math.mod(nState1,1000))/100 )  
	nStateList[4] = math.floor( (math.mod(nState1,100))/10 )  
	nStateList[5] = math.mod(nState1,10)  
	nStateList[6] = math.floor( (math.mod(nState2,100000))/10000 )  
	nStateList[7] = math.floor( (math.mod(nState2,10000))/1000 )  
	nStateList[8] = math.floor( (math.mod(nState2,1000))/100 )  
	nStateList[9] = math.floor( (math.mod(nState2,100))/10 )  
	nStateList[10] = math.mod(nState2,10)  
	nStateList[11] = math.floor( (math.mod(nState3,100000))/10000 )  
	nStateList[12] = math.floor( (math.mod(nState3,10000))/1000 )  
	nStateList[13] = math.floor( (math.mod(nState3,1000))/100 )  
	nStateList[14] = math.floor( (math.mod(nState3,100))/10 )  
	nStateList[15] = math.mod(nState3,10)  
	nStateList[16] = math.floor( (math.mod(nState4,100000))/10000 )  
	nStateList[17] = math.floor( (math.mod(nState4,10000))/1000 )  
	nStateList[18] = math.floor( (math.mod(nState4,1000))/100 )  
	nStateList[19] = math.floor( (math.mod(nState4,100))/10 )  
	nStateList[20] = math.mod(nState4,10)  
 
	--每个按钮都设置未选中
	for i = 1, table.getn(g_YanMenMeng_XiuXi_OtherList) do
		if nStateList[i] == 1 then
			g_YanMenMeng_XiuXi_TxtList[i]:SetText(g_YanMenMeng_XiuXi_NameList[i].green)
		elseif nStateList[i] == 2 then
			g_YanMenMeng_XiuXi_TxtList[i]:SetText(g_YanMenMeng_XiuXi_NameList[i].yellow)
		elseif nStateList[i] == 3 then
			g_YanMenMeng_XiuXi_TxtList[i]:SetText(g_YanMenMeng_XiuXi_NameList[i].orange)
		elseif nStateList[i] == 4 then
			g_YanMenMeng_XiuXi_TxtList[i]:SetText(g_YanMenMeng_XiuXi_NameList[i].red)
		else
			--置灰
			g_YanMenMeng_XiuXi_TxtList[i]:SetText(g_YanMenMeng_XiuXi_NameList[i].gray)
			g_YanMenMeng_XiuXi_OtherList[i]:Disable();
		end
	end	
	--上次选择
	if nPreIdx > 0 and nPreIdx <= table.getn(g_YanMenMeng_XiuXi_OtherList) +1  then
		YanMenMeng_XiuXi_SelectText:SetText( ScriptGlobal_Format("#{YMMJ_230626_268}", g_YanMenMeng_XiuXi_NameList[nPreIdx].gray))
	else
		YanMenMeng_XiuXi_SelectText:SetText("#{YMMJ_230626_270}")
	end
	this:Show()
end


--===============================================
-- 选本服休息室
--===============================================
function YanMenMeng_XiuXi_Self()
	--PushDebugMessage("test YanMenMeng_XiuXi_Self")
	g_YanMenMeng_XiuXiIdx = 0
	--本服
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("EnterBreakRoom")
		Set_XSCRIPT_ScriptID(998443)
		Set_XSCRIPT_Parameter( 0, g_YanMenMeng_Object)
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT()
end

--===============================================
-- 选跨服休息室
--===============================================
function YanMenMeng_XiuXi_Other(mIdx)
	--PushDebugMessage("test YanMenMeng_XiuXi_Other")
	if mIdx < 1 or mIdx > g_YanMenMeng_XiuXiMax then
		--PushDebugMessage("test 参数非法")
		return 
	end
	g_YanMenMeng_XiuXiIdx = mIdx
	--跨服
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("EnterOtherBreakRoom")
		Set_XSCRIPT_ScriptID(998443)
		Set_XSCRIPT_Parameter( 0, g_YanMenMeng_Object)
		Set_XSCRIPT_Parameter( 1, g_YanMenMeng_XiuXiIdx)
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()
end
