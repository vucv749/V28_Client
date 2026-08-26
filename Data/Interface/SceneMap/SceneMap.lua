local g_NeedTipID = -1
local g_CurSelectSceneID = -1 --选择的地图场景
local g_DungeonsTable = {}   --地下城
local g_DungeonsIndex = -1	 --记录地下城索引
local g_IsTServerMapSizeSelect = 0 --Tserver场景，默认为最小化的地图
local g_OldMapMode = -1 --原地图大小

local g_SceneMapUsage = 0		--UI当前的用处 0是默认场景地图
local g_initial_size = ""
local g_initial_pos = ""
local g_scene_filename = ""
local g_bieye_last_inhouse = 0
local g_screensize = ""



local g_SameSceneId = {
	[0] = 242,
	[242] = 0,
}
	
function SceneMap_PreLoad()
	this:RegisterEvent("SCENE_TRANSED",false)
	this:RegisterEvent("TOGLE_SCENE_MAP",true)
	this:RegisterEvent("UPDATE_MAP",false)
	this:RegisterEvent("NEW_MISSION",false)
   -- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ACC_CHANGE_TIPS",false)
	this:RegisterEvent("PLAYER_ENTERING_WORLD",true )	-- 进入world
	this:RegisterEvent("RESET_ALLUI",true)				-- 返回登录界面, 重置所有UI
end

function SceneMap_OnLoad()


	g_DungeonsTable[1]={maplist={}}
	g_DungeonsTable[1].maplist[1] = {sceneId = 166, name = "宝藏洞一层"}
	g_DungeonsTable[1].maplist[2] = {sceneId = 169, name = "宝藏洞二层"}
	g_DungeonsTable[1].maplist[3] = {sceneId = 191, name = "宝藏洞三层"}
	g_DungeonsTable[1].maplist[4] = {sceneId = 192, name = "宝藏洞四层"}
	g_DungeonsTable[1].maplist[5] = {sceneId = 193, name = "宝藏洞五层"}

	g_DungeonsTable[2]={maplist={}}
	g_DungeonsTable[2].maplist[1] = {sceneId = 202, name = "燕王古墓一层"}
	g_DungeonsTable[2].maplist[2] = {sceneId = 203, name = "燕王古墓二层"}
	g_DungeonsTable[2].maplist[3] = {sceneId = 204, name = "燕王古墓三层"}
	g_DungeonsTable[2].maplist[4] = {sceneId = 205, name = "燕王古墓四层"}
	g_DungeonsTable[2].maplist[5] = {sceneId = 206, name = "燕王古墓五层"}
	g_DungeonsTable[2].maplist[6] = {sceneId = 207, name = "燕王古墓六层"}
	g_DungeonsTable[2].maplist[7] = {sceneId = 208, name = "燕王古墓七层"}
	g_DungeonsTable[2].maplist[8] = {sceneId = 209, name = "燕王古墓八层"}
	g_DungeonsTable[2].maplist[9] = {sceneId = 210, name = "燕王古墓九层"}

	g_DungeonsTable[3]={maplist={}}
	g_DungeonsTable[3].maplist[1] = {sceneId = 262, name = "秦皇地宫一层"}
	g_DungeonsTable[3].maplist[2] = {sceneId = 263, name = "秦皇地宫二层"}
	g_DungeonsTable[3].maplist[3] = {sceneId = 264, name = "秦皇地宫三层"}

	g_DungeonsTable[4]={maplist={}}
	g_DungeonsTable[4].maplist[1] = {sceneId = 295, name = "通天塔地宫"}
	g_DungeonsTable[4].maplist[2] = {sceneId = 296, name = "通天塔1层"}
	g_DungeonsTable[4].maplist[3] = {sceneId = 297, name = "通天塔2层"}
	g_DungeonsTable[4].maplist[4] = {sceneId = 298, name = "通天塔3层"}
	g_DungeonsTable[4].maplist[5] = {sceneId = 299, name = "通天塔塔顶"}
	
	g_DungeonsTable[5]={maplist={}}
	g_DungeonsTable[5].maplist[1] = {sceneId = 112, name = "玄武岛"}
	g_DungeonsTable[5].maplist[2] = {sceneId = 579, name = "玄武岛·镜"}

	g_DungeonsTable[6]={maplist={}}
	g_DungeonsTable[6].maplist[1] = {sceneId = 616, name = "长春谷·横崖"}
	g_DungeonsTable[6].maplist[2] = {sceneId = 617, name = "长春谷·乌衣巷"}

	g_DungeonsTable[7]={maplist={}}
	g_DungeonsTable[7].maplist[1] = {sceneId = 650, name = "秦宫秘境一层"}
	g_DungeonsTable[7].maplist[2] = {sceneId = 651, name = "秦宫秘境二层"}
	g_DungeonsTable[7].maplist[3] = {sceneId = 652, name = "秦宫秘境三层"}

	g_initial_size = SceneMap_Frame:GetProperty("UnifiedSize")
	g_initial_pos = SceneMap_Frame:GetProperty("UnifiedPosition")
	
end





function SceneMap_GM_GotoPos()
	

		local coordinatex,coordinatey
		coordinatex, coordinatey = SceneMap_Board:GetMouseScenePos()
		local str
		str = "goto ="..tostring( coordinatex )..","..tostring( coordinatey )
		local nSceneID = tonumber(g_CurSelectSceneID)
		local curSceneID = GetSceneID()
		if nSceneID ~= -1 and nSceneID ~= curSceneID then
			--增加一层转换，由于原来该场景ID只是单纯客户端的资源ID，和服务器的场景ID可能对不上，所以做一次转换 modify 2018-06-26 by guopengjie
			nSceneID = Lua_GetSceneIDByResID(nSceneID)
			if nSceneID ~= -1 then
				str = str.."="..tostring(nSceneID)
			end
		end
		SendGMCommand( str )

	
end

function SceneMap_GotoDirectly()
	
		
		local coordinatex,coordinatey,curSceneID
		coordinatex, coordinatey = SceneMap_Board:GetMouseScenePos()
		curSceneID = GetSceneID()
		if	g_CurSelectSceneID ~= -1 and g_CurSelectSceneID ~= curSceneID then
			if g_SameSceneId[ g_CurSelectSceneID ] and g_SameSceneId[ g_CurSelectSceneID ]  == curSceneID then
				AutoRunToTarget(coordinatex, coordinatey)
			else
				AutoRunToTargetEx(coordinatex,coordinatey,tonumber(g_CurSelectSceneID))
			end
		else
			AutoRunToTarget(coordinatex, coordinatey)
		end


	
end

function SceneMap_OnEvent(event)

	if ( event == "TOGLE_SCENE_MAP" ) then
		if ( arg1 == "2" ) then
			if this:IsVisible() then
				SceneMap_Close()
				ToggleAutoSearch(0)
			else
				SceneMap_Text3:SetText("#{KCJXL_130417_1}")
				sceneMap_ComboList:ResetList() 	--显示前重置一下下拉列表
				SceneMap_Show( arg0 )
				ToggleAutoSearch(1)
			end
			return
		end
		if ( arg1 == "1" ) then

			SceneMap_Text3:SetText("#{KCJXL_130417_1}")
			sceneMap_ComboList:ResetList() 		--显示前重置一下下拉列表
			SceneMap_Show( arg0 )
			ToggleAutoSearch(1)
			return
		end
		if ( arg1 == "3" ) then

			if tonumber(arg2) == GetSceneID() then
				SceneMap_Text3:SetText("#{KCJXL_130417_1}")
			else
				SceneMap_Text3:SetText("#{KCJXL_130417_3}")
			end
			sceneMap_ComboList:ResetList() 		--显示前重置一下下拉列表
			SceneMap_Show_OhterScene(tostring(arg0), tonumber(arg2))
			--判断是否是K服的五个场景，其他的不响应
			return
		end

		SceneMap_Close()
		ToggleAutoSearch(0)
		return
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		g_screensize = arg1
		SceneMap_Frame_On_ResetPos()
	elseif ( event == "UPDATE_MAP" ) then
		SceneMap_Update()
	elseif( event == "SCENE_TRANSED" ) then
		SceneMap_Close()
	elseif ( event == "ACC_CHANGE_TIPS" )	then
		SceneMap_ChangeButtonTip()
		return
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		g_IsTServerMapSizeSelect = 0
	elseif ( event == "RESET_ALLUI" ) then
		g_OldMapMode = -1
	end
	

end

function SceneMap_Close()
	SceneMap_Board:CloseSceneMap()
	this:Hide()
	ToggleAutoSearch(0) --likun
end

function SceneMap_Show( filename )

	
	local sceneX, sceneY
	sceneX,sceneY = GetSceneSize()		--这都是当前场景的函数啊
	
	SceneMap_Board:SetSceneFileName( sceneX,sceneY,filename,1)
	SceneMap_FixZoom(filename)

	local scenename
	scenename = GetCurrentSceneName()
	SceneMap_SceneName:SetText("#gFF0FA0".. scenename )


	SceneMap_Board:UpdateViewRect();
	ToggleLargeMap(0)




	--是否是多层场景
	local sceneID = GetSceneID()
	g_CurSelectSceneID = sceneID --记录一下当前选择场景ID
	local tempIndex = nil
	for i = 1, table.getn(g_DungeonsTable) do
		for j = 1, table.getn(g_DungeonsTable[i].maplist) do
			if g_DungeonsTable[i].maplist[j].sceneId == sceneID then
				g_DungeonsIndex = i
				tempIndex = j
				--sceneMap_ComboList:SetProperty("Disabled", "True")
				break
			end
		end
	end

	if (g_DungeonsIndex ~= -1 and tempIndex ~= nil ) then		--是多层场景
		--sceneMap_ComboList:ResetList()
		sceneMap_ComboList:SetProperty("Visible", "True")
		for i = 1, table.getn(g_DungeonsTable[g_DungeonsIndex].maplist) do
				sceneMap_ComboList:ComboBoxAddItem(g_DungeonsTable[g_DungeonsIndex].maplist[i].name,i)
		end
		sceneMap_ComboList:SetCurrentSelect(tempIndex-1)
	else
		sceneMap_ComboList:ComboBoxAddItem(scenename,1)       --普通场景
		sceneMap_ComboList:SetProperty("Visible", "False")
		sceneMap_ComboList:SetCurrentSelect(0)
	end



	this:Show()
	
	sceneMap_LargeMap:Show()
	sceneMap_back:Show()
end

function SceneMap_SbgHumanInfo_Show( nClientResID )
	
	sceneMap_ComboList:ResetList()
	SceneMap_Text3:SetText("#{SBGYH_151123_12}")
	
	local sceneX, sceneY = GetSceneSizeByID(tonumber(nClientResID))
	local mapname = GetSceneMapByID(tonumber(nClientResID))
	SceneMap_Board:SetSceneFileName( sceneX,sceneY,mapname,1)

	local scenename = GetSceneNameByResID(tonumber(nClientResID))
	SceneMap_SceneName:SetText("#gFF0FA0"..scenename)
	
	-- 如果非大场景，还需要重置其缩放模式
	local mode = SceneMap_Board:GetSceneZoomMode()
    if mode == 1 then  -- 1模式为512X512独有。。。擦
        if sceneX < 512 and sceneY < 512 then
            -- 重置为像素比例模式
            SceneMap_Board:SetSceneZoomMode(2)
        end
    end
	
	sceneMap_ComboList:SetProperty("Visible", "False")
	sceneMap_ComboList:ComboBoxAddItem(scenename,1)
	sceneMap_ComboList:SetCurrentSelect(0)
	
	this:Show()
	
	sceneMap_LargeMap:Hide()
	sceneMap_back:Hide()
	
	SceneMap_Board:UpdateSbgHumanFlag()
	
end

function SceneMap_Update()
	if( this:IsVisible() ) then
		SceneMap_Board:UpdateFlag()
	end
end

function SceneMap_UpdateInfo()
	local coordinatex,coordinatey
	coordinatex, coordinatey = SceneMap_Board:GetMouseScenePos()
	SceneMap_Crood:SetText( tostring( coordinatex ).."    "..tostring( coordinatey ) )
end

function SceneMap_ZoomMode( zoom )
	if SceneMap_IsYanMenGuanMap() then
		SceneMap_Board:SetSceneZoomMode( 2 );
	else
		SceneMap_Board:SetSceneZoomMode( zoom );
		SceneMap_Board:UpdateViewRect();
	end

end

function SceneMap_RawZoom( n, sceneId )
	n = math.floor(n)
	if n == nil or n < 0 or n > 4 then
        return
    end

	if n > 2 then
		n = 2
	end
	SceneMap_Board:SetSceneZoomMode(n)
end


function SceneMap_fixYanMenGuan( number )
	local posx, posz, dir = Player:GetPos()
	local nArea = 0
	
	local n = 2
	local myweight = 800
	local myheight = 600

	SceneMap_Frame:SetProperty( "AbsoluteSize", string.format( "w:%.3f h:%.3f", myweight, myheight ) )
	SceneMap_Frame:SetProperty("UnifiedPosition",g_initial_pos)
	
	SceneMap_RawZoom( n )
	if n == 2 then
		SceneMap_Board:SetFixMode(true,-0.31038,-1.7319)
	end
	SceneMap_Text3:SetText("")
end


function SceneMap_FixZoom( filename, sceneId )
	g_scene_filename = filename

	if SceneMap_IsYanMenGuanMap() then
		SceneMap_fixYanMenGuan()
		SceneMap_MoveL:Hide()
		SceneMap_MoveR:Hide()
		SceneMap_MoveUp:Hide()
		SceneMap_MoveDown:Hide()
		ScemeMap_ZoomButtons1:Hide()
		ScemeMap_ZoomButtons2:Hide()
		SceneMap_Text2:Hide()
	elseif SceneMap_IsYanMenGuanSpecMap() then
		SceneMap_ZoomMode( 0 )
		SceneMap_Board:SetFixMode(false,-0.5,-0.5)
		SceneMap_Frame:SetProperty("UnifiedSize",g_initial_size)
		SceneMap_Frame:SetProperty("UnifiedPosition",g_initial_pos)
		SceneMap_MoveL:Show()
		SceneMap_MoveR:Show()
		SceneMap_MoveUp:Show()
		SceneMap_MoveDown:Show()
		ScemeMap_ZoomButtons1:Show()
		ScemeMap_ZoomButtons2:Show()
		SceneMap_Text2:Show()
		
	else
		SceneMap_Board:SetFixMode(false,-0.5,-0.5)
		SceneMap_Frame:SetProperty("UnifiedSize",g_initial_size)
		SceneMap_Frame:SetProperty("UnifiedPosition",g_initial_pos)
		SceneMap_MoveL:Show()
		SceneMap_MoveR:Show()
		SceneMap_MoveUp:Show()
		SceneMap_MoveDown:Show()
		ScemeMap_ZoomButtons1:Show()
		ScemeMap_ZoomButtons2:Show()
		SceneMap_Text2:Show()
	end


end

function sceneMap_LargeMap_Clicked()
	ToggleLargeMap( 1 )
end

function SceneMap_Show_OhterScene( filename, sceneID )
	--sceneMap_ComboList:ResetList() --看别的场景也要清理一下
	local sceneX, sceneY
	sceneX,sceneY = GetSceneSizeByID(sceneID)		--这都是当前场景的函数啊
	if (sceneID == GetSceneID()) then --如果点击的是本场景
		SceneMap_Board:SetSceneFileName( sceneX,sceneY,filename , 1)
	else
		SceneMap_Board:SetSceneFileName( sceneX,sceneY,filename , 0)
	end
	if sceneID == 242 then  --雪景洛阳- -
		sceneID = 0
	end
	g_DungeonsIndex = -1

	local scenename
	scenename = GetSceneNameByResID(tonumber(sceneID))
	SceneMap_SceneName:SetText("#gFF0FA0".. scenename )
	
	SceneMap_FixZoom(filename)

	g_CurSelectSceneID = sceneID --记录一下当前选择场景ID
	-- 如果非大场景，还需要重置其缩放模式
	-- local mode = SceneMap_Board:GetSceneZoomMode()
    -- if mode == 1 then  -- 1模式为512X512独有。。。擦
        -- local sceneX, sceneY = GetSceneSizeByID(sceneID)
        -- if sceneX < 512 and sceneY < 512 then
            -- -- 重置为像素比例模式
            -- SceneMap_Board:SetSceneZoomMode(2)
        -- end
    -- end


	--是否是多层场景
	local tempDungeons = nil
	local tempIndex = nil
	for i = 1, table.getn(g_DungeonsTable) do
		for j = 1, table.getn(g_DungeonsTable[i].maplist) do
			if g_DungeonsTable[i].maplist[j].sceneId == sceneID then
				g_DungeonsIndex  = i
				tempIndex = j
				--sceneMap_ComboList:SetProperty("Disabled", "True")
				break
			end
		end
	end

	--
	if (g_DungeonsIndex ~= -1 and tempIndex ~= nil ) then
		sceneMap_ComboList:SetProperty("Visible", "True")
		sceneMap_ComboList:ResetList()
		for i = 1, table.getn(g_DungeonsTable[g_DungeonsIndex].maplist) do
			sceneMap_ComboList:ComboBoxAddItem(g_DungeonsTable[g_DungeonsIndex].maplist[i].name,i)
		end
		sceneMap_ComboList:SetCurrentSelect(tempIndex-1)
	else
		sceneMap_ComboList:SetProperty("Visible", "False")
		sceneMap_ComboList:ComboBoxAddItem(scenename,1)
		sceneMap_ComboList:SetCurrentSelect(0)
		--sceneMap_ComboList:SetCurrentSelect(tempIndex-1)
	end

	this:Show()
	
	sceneMap_LargeMap:Show()
	sceneMap_back:Show()
end

function SceneMap_Show_CurrentScene()
	local scenename,sceneID
	sceneID = GetSceneID()
	scenename = GetSceneMapByID(tonumber(sceneID))
	SceneMap_Text3:SetText("#{KCJXL_130417_1}")
	sceneMap_ComboList:ResetList()
	SceneMap_Show(tostring(scenename))
end

function sceneMap_ComboList_Changed()	--地图下拉列表改变

	if g_DungeonsIndex == -1 then
		return
	end

	local _, Index = sceneMap_ComboList:GetCurrentSelect()
	local sceneId = g_DungeonsTable[g_DungeonsIndex].maplist[Index].sceneId
	local mapname = GetSceneMapByID(tonumber(sceneId))
	if sceneId == nil then
		return		--不是分层场景，直接返回
	end

	SceneMap_Show_OhterScene( mapname , sceneId)

end

function SceneMap_Frame_On_ResetPos()
	local curResolution = Variable:GetVariable( "View_Resoution" )
	local split = string.sub(curResolution, 4, 4)
	local curResolutionL
	if split == "," then
		curResolutionL = string.sub(curResolution, 1, 3)
	else
		curResolutionL = string.sub(curResolution, 1, 4)
	end
	
	local number = tonumber(curResolutionL)
	
	if SceneMap_IsYanMenGuanMap() then
		SceneMap_fixYanMenGuan(number)
	end


	if number == nil or number <= 960 then
		SceneMap_Text3 : SetProperty("UnifiedXPosition", "{0.500000,-306.500000}")
	else
		SceneMap_Text3 : SetProperty("UnifiedXPosition", "{0.500000,-169.000000}")
	end
end

function SceneMap_ChangeButtonTip()
	if KVKInterface:IsInKVKServer() == 1 then

	else
		local noChatActiveMode = Variable:GetVariable("NonChatActive")
		if noChatActiveMode == "1" then
			sceneMap_LargeMap						:SetToolTip("#{JPYD_130822_17}")
		else
			sceneMap_LargeMap						:SetToolTip("#{DTQH_090305_4}")
		end
	end
end
function SceneMap_Hidden()
	if DataPool:Lua_IsHaveMission(2019) <= 0 then--秦驰道任务
		DataPool:CleanQinChiDaoData()
	end
end



function SceneMap_IsYanMenGuanMap()
	
	if g_scene_filename == "Hjyanmenguan_PVP" then
		return true
	else
		return false
	end
end



function SceneMap_IsYanMenGuanSpecMap()
	
	if g_scene_filename == "Hjyanmenguan_qiu" or g_scene_filename == "Hjyanmenguan_chun" or g_scene_filename == "Hjyanmenguan_xia" then
		return true
	else
		return false
	end
end
