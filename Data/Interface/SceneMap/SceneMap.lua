local g_NeedTipID = -1
local g_CurSelectSceneID = -1 --???????
local g_DungeonsTable = {}   --???
local g_DungeonsIndex = -1	 --???????
local g_IsTServerMapSizeSelect = 0 --Tserver??,?????????
local g_OldMapMode = -1 --?????

local g_SceneMapUsage = 0		--UI????? 0???????
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
   -- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ACC_CHANGE_TIPS",false)
	this:RegisterEvent("PLAYER_ENTERING_WORLD",true )	-- ??world
	this:RegisterEvent("RESET_ALLUI",true)				-- ??????, ????UI
end

function SceneMap_OnLoad()


	g_DungeonsTable[1]={maplist={}}
	g_DungeonsTable[1].maplist[1] = {sceneId = 166, name = "Tàng Bäo Ðµng T¥ng 1 "}
	g_DungeonsTable[1].maplist[2] = {sceneId = 169, name = "Tàng Bäo Ðµng T¥ng 2 "}
	g_DungeonsTable[1].maplist[3] = {sceneId = 191, name = "Tàng Bäo Ðµng T¥ng 3 "}
	g_DungeonsTable[1].maplist[4] = {sceneId = 192, name = "Tàng Bäo Ðµng T¥ng 4 "}
	g_DungeonsTable[1].maplist[5] = {sceneId = 193, name = "Tàng Bäo Ðµng t¥ng 5 "}

	g_DungeonsTable[2]={maplist={}}
	g_DungeonsTable[2].maplist[1] = {sceneId = 202, name = "Yªn Vß½ng C± Mµ T¥ng 1"}
	g_DungeonsTable[2].maplist[2] = {sceneId = 203, name = "Yªn Vß½ng C± Mµ T¥ng 2"}
	g_DungeonsTable[2].maplist[3] = {sceneId = 204, name = "Yªn Vß½ng C± Mµ T¥ng 3"}
	g_DungeonsTable[2].maplist[4] = {sceneId = 205, name = "Yªn Vß½ng C± Mµ T¥ng 4"}
	g_DungeonsTable[2].maplist[5] = {sceneId = 206, name = "Yªn Vß½ng C± Mµ T¥ng 5"}
	g_DungeonsTable[2].maplist[6] = {sceneId = 207, name = "Yªn Vß½ng C± Mµ T¥ng 6"}
	g_DungeonsTable[2].maplist[7] = {sceneId = 208, name = "Yªn Vß½ng C± Mµ T¥ng 7"}
	g_DungeonsTable[2].maplist[8] = {sceneId = 209, name = "Yªn Vß½ng C± Mµ T¥ng 8"}
	g_DungeonsTable[2].maplist[9] = {sceneId = 210, name = "Yªn Vß½ng C± Mµ T¥ng 9"}

	g_DungeonsTable[3]={maplist={}}
	g_DungeonsTable[3].maplist[1] = {sceneId = 262, name = "T¥n Hoàng Ð¸a Cung T¥ng 1"}
	g_DungeonsTable[3].maplist[2] = {sceneId = 263, name = "T¥n Hoàng Ð¸a Cung T¥ng 2"}
	g_DungeonsTable[3].maplist[3] = {sceneId = 264, name = "T¥n Hoàng Ð¸a Cung T¥ng 3"}

	g_DungeonsTable[4]={maplist={}}
	g_DungeonsTable[4].maplist[1] = {sceneId = 295, name = "Thông Thiên Tháp Ð¸a Cung"}
	g_DungeonsTable[4].maplist[2] = {sceneId = 296, name = "Thông Thiên Tháp T¥ng 1"}
	g_DungeonsTable[4].maplist[3] = {sceneId = 297, name = "Thông Thiên Tháp T¥ng 2"}
	g_DungeonsTable[4].maplist[4] = {sceneId = 298, name = "Thông Thiên Tháp T¥ng 3"}
	g_DungeonsTable[4].maplist[5] = {sceneId = 299, name = "Ðïnh Thông Thiên Tháp"}
	
	g_DungeonsTable[5]={maplist={}}
	g_DungeonsTable[5].maplist[1] = {sceneId = 112, name = "Huy«n Vû Ðäo"}
	g_DungeonsTable[5].maplist[2] = {sceneId = 579, name = "Huy«n Võ Ðäo·Kính"}

	g_DungeonsTable[6]={maplist={}}
	g_DungeonsTable[6].maplist[1] = {sceneId = 616, name = "Trß¶ng Xuân C¯c·Hoành Nhai"}
	g_DungeonsTable[6].maplist[2] = {sceneId = 617, name = "Trß¶ng Xuân C¯c·Ô Y HÕng"}

	g_DungeonsTable[7]={maplist={}}
	g_DungeonsTable[7].maplist[1] = {sceneId = 650, name = "T¥n Cung Bí Cänh T¥ng 1"}
	g_DungeonsTable[7].maplist[2] = {sceneId = 651, name = "T¥n Cung Bí Cänh T¥ng 2"}
	g_DungeonsTable[7].maplist[3] = {sceneId = 652, name = "T¥n Cung Bí Cänh T¥ng 3"}

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
			--Ôö¼ÓÒ»²ã×ª»»£¬ÓÉÓÚÔ­À´¸Ã³¡¾°IDÖ»ÊÇµ¥´¿¿Í»§¶ËµÄ×ÊÔ´ID£¬ºÍ·þÎñÆ÷µÄ³¡¾°ID¿ÉÄÜ¶Ô²»ÉÏ£¬ËùÒÔ×öÒ»´Î×ª»» modify 2018-06-26 by guopengjie
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
				sceneMap_ComboList:ResetList() 	--???????????
				SceneMap_Show( arg0 )
				ToggleAutoSearch(1)
			end
			return
		end
		if ( arg1 == "1" ) then

			SceneMap_Text3:SetText("#{KCJXL_130417_1}")
			sceneMap_ComboList:ResetList() 		--???????????
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
			sceneMap_ComboList:ResetList() 		--???????????
			SceneMap_Show_OhterScene(tostring(arg0), tonumber(arg2))
			--ÅÐ¶ÏÊÇ·ñÊÇK·þµÄÎå¸ö³¡¾°£¬ÆäËûµÄ²»ÏìÓ¦
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
	sceneX,sceneY = GetSceneSize()		--???????????
	
	SceneMap_Board:SetSceneFileName( sceneX,sceneY,filename,1)
	SceneMap_FixZoom(filename)

	local scenename
	scenename = GetCurrentSceneName()
	SceneMap_SceneName:SetText("#gFF0FA0".. scenename )


	SceneMap_Board:UpdateViewRect();
	ToggleLargeMap(0)




	--ÊÇ·ñÊÇ¶à²ã³¡¾°
	local sceneID = GetSceneID()
	g_CurSelectSceneID = sceneID --??????????ID
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

	if (g_DungeonsIndex ~= -1 and tempIndex ~= nil ) then		--?????
		--sceneMap_ComboList:ResetList()
		sceneMap_ComboList:SetProperty("Visible", "True")
		for i = 1, table.getn(g_DungeonsTable[g_DungeonsIndex].maplist) do
				sceneMap_ComboList:ComboBoxAddItem(g_DungeonsTable[g_DungeonsIndex].maplist[i].name,i)
		end
		sceneMap_ComboList:SetCurrentSelect(tempIndex-1)
	else
		sceneMap_ComboList:ComboBoxAddItem(scenename,1)       --????
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
	
	-- Èç¹û·Ç´ó³¡¾°£¬»¹ÐèÒªÖØÖÃÆäËõ·ÅÄ£Ê½
	local mode = SceneMap_Board:GetSceneZoomMode()
    if mode == 1 then  -- 1???512X512??????
        if sceneX < 512 and sceneY < 512 then
            -- ÖØÖÃÎªÏñËØ±ÈÀýÄ£Ê½
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
	--sceneMap_ComboList:ResetList() --¿´±ðµÄ³¡¾°Ò²ÒªÇåÀíÒ»ÏÂ
	local sceneX, sceneY
	sceneX,sceneY = GetSceneSizeByID(sceneID)		--???????????
	if (sceneID == GetSceneID()) then --?????????
		SceneMap_Board:SetSceneFileName( sceneX,sceneY,filename , 1)
	else
		SceneMap_Board:SetSceneFileName( sceneX,sceneY,filename , 0)
	end
	if sceneID == 242 then  --????- -
		sceneID = 0
	end
	g_DungeonsIndex = -1

	local scenename
	scenename = GetSceneNameByResID(tonumber(sceneID))
	SceneMap_SceneName:SetText("#gFF0FA0".. scenename )
	
	SceneMap_FixZoom(filename)

	g_CurSelectSceneID = sceneID --??????????ID
	-- Èç¹û·Ç´ó³¡¾°£¬»¹ÐèÒªÖØÖÃÆäËõ·ÅÄ£Ê½
	-- local mode = SceneMap_Board:GetSceneZoomMode()
    -- if mode == 1 then  -- 1Ä£Ê½Îª512X512¶ÀÓÐ¡£¡£¡£²Á
        -- local sceneX, sceneY = GetSceneSizeByID(sceneID)
        -- if sceneX < 512 and sceneY < 512 then
            -- -- ÖØÖÃÎªÏñËØ±ÈÀýÄ£Ê½
            -- SceneMap_Board:SetSceneZoomMode(2)
        -- end
    -- end


	--ÊÇ·ñÊÇ¶à²ã³¡¾°
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

function sceneMap_ComboList_Changed()	--????????

	if g_DungeonsIndex == -1 then
		return
	end

	local _, Index = sceneMap_ComboList:GetCurrentSelect()
	local sceneId = g_DungeonsTable[g_DungeonsIndex].maplist[Index].sceneId
	local mapname = GetSceneMapByID(tonumber(sceneId))
	if sceneId == nil then
		return		--??????,????
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
	if DataPool:Lua_IsHaveMission(2019) <= 0 then--?????
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
