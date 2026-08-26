--Cloud_SelectServer
--
-- È«¾Ö±äÁ¿
--
local g_LastServer = -1;
local g_LastArea   = -1;
local g_LastServerState = -1;
local g_LastServerName = "";
local CriticalSpeed1 =250
local CriticalSpeed2 =500
local CriticalSpeed3 =1000

local CriticalSpeed =200;
local CurPage = 0
local NetSpeed ={"#e010101internet t¯c ðµ: #c4CFA4Ct¯t bøng","#e010101internet t¯c ðµ: #cff0000b§n rµn","#e010101internet t¯c ðµ: Không biªt", "#e010101internet t¯c ðµ: #cff0000œng Ð±" }
local PageSize = 24

-- ÇøÓò°´Å¥µÄ¸öÊý
local LOGIN_SERVER_AREA_COUNT = 20;
--Ä¿Ç°ÓÐÐ§µÄÇøÓò°´Å¥¸öÊý£¬ÓÉÓÚ½çÃæ¸Ä¶¯Ì«´ó£¬ÅÂÒÔºóÓÐÈËÓÖ·´»Ú£¬¼Ó â¸ö±äÁ¿£¬Ö÷ÒªÊÇ²»ÏëÈ¥µô·­Ò³´úÂë¡£
local EFFECT_LOGIN_SERVER_AREA_COUNT = 20;
-- ÇøÓò°´Å¥
local g_CloudBnArea = {};

-- µ±Ç°Ñ¡ÔñµÄÇøÓò
local g_iCurSelArea = 0;
-- login server ¿Í»§¶ËË÷Òý
local g_AreaIndex ={};
-- login server Ãû×Ö
local g_AreaName = {};
-- login server Ãû×Ö
local g_AreaDis = {};
-- µ±Ç°Ñ¡ÔñµÄ·þÎñÆ÷Ãû×Ö
local g_iCurSelLoginServerName;
--ÍÆ¼ö·þÎñÆ÷°´Å¥
local g_RecommandAreaButton=nil;
--´óÇø°´Å¥
local g_AreaButton={};

--ÇøÓòtips
local g_AreaTip = {};

local g_idBackSound = -1;

-- ¼ÇÔØÍÆ¼ö·þÎñÆ÷µÄ¸öÊý
local indexForCommendable = 1;
------------------------------------------------------------------------------
--
-- login server ÐÅÏ¢
--

-- login server µÄ¸öÊý
--local LOGIN_SERVER_COUNT = 55;    -- modify by zchw 45-->55
local LOGIN_SERVER_COUNT = 85;    -- modify by zchw 45-->55
local LOGIN_SERVER_COUNT_PERPAGE = 12;

local CLOUD_COMMENDABLE_LOGIN_SERVER_COUNT = 6;

--µ±Ç°ÏÔÊ¾´óÇøË÷Òý
local g_Cloud_CurShowAreaIndex = -1;
--µ±Ç°ÏÔÊ¾Ò³Âë
local g_Cloud_CurShowPage = -1;
--µ±Ç°ÏÔÊ¾ÇøÓò×ÜServerÊýÁ¿
local g_Cloud_CurLoginServerCount=0;

-- login server °´Å¥
local g_CloudBnLoginServer = {};
-- login server ×´Ì¬
local g_LoginServerStatus = {};
-- login server Ãû×Ö
local g_LoginServerName = {};
-- login server ÍÆ¼öµÈ¼¶
local g_LoginServerCommendableLevel = {};
-- login server ÊÇ·ñÐÂ¿ª
local g_LoginServerIsNew = {};



-- ÍÆ¼ö·þÎñÆ÷°´Å¥
local g_Cloud_CommendableBnLoginServer = {};
-- ÍÆ¼ö·þÎñÆ÷Ãû×Ö
local g_CommendableLoginServerName = {};
-- ÍÆ¼ö·þÎñÆ÷Index
local g_CommendableLoginServerServerIndex = {};
-- ÍÆ¼ö·þÎñÆ÷ÇøÓòIndex
local g_CommendableLoginServerAreaIndex = {};
-- ÍÆ¼ö·þÎñÆ÷ÍÆ¼öµÈ¼¶
local g_CommendableLoginServerCommendableLevel = {};
-- ÍÆ¼ö·þÎñÆ÷ÊÇ·ñÐÂ·þ
local g_CommendableLoginServerIsNew = {};
-- ÍÆ¼ö·þÎñÆ÷ ×´Ì¬
local g_CommendableLoginServerStatus = {};

local SEARCH_LOGIN_SERVER_COUNT_PERPAGE = 12;
--µ±Ç°ÏÔÊ¾´óÇøË÷Òý
local g_Cloud_Search_CurShowAreaIndex = -1;
--µ±Ç°ÏÔÊ¾Ò³Âë
local g_Cloud_Search_CurShowPage = -1;
--µ±Ç°ÏÔÊ¾ÇøÓò×ÜServerÊýÁ¿
local g_Cloud_Search_CurLoginServerCount=0;
--ËÑË÷·þÎñÆ÷°´Å¥
local g_CloudSearchBnLoginServer = {};
-------------------------------------------------------------------------------
--
-- ÆäËûÐÅÏ¢
--

-- µ±Ç°Ñ¡ÔñµÄlogin server
local g_iCurSelLoginServer = -1;
-- µ±Ç°Ñ¡ÔñµÄÍÆ¼ölogin server index
local g_iCurComSelLoginServer = -1;

-- ÇøÓòµÄ¸öÊý
local g_iCurAreaCount = 0;
--¹«²âÇøÓò¸öÊý
local g_iCurTestAreaCount = 0;

local g_FirstLogin = 1;

--·þÎñÆ÷´¦ÓÚÎ¬»¤×´Ì¬
local StateStop = 4;
--²»ÏÔÊ¾×´Ì¬
local StatMax = 10;

-- ËÑË÷ÁÐ±í·þÎñÆ÷Index
local g_SearchServerIndex = {};
-- ËÑË÷ÁÐ±í·þÎñÆ÷´óÇøIndex
local g_SearchServerAreaIndex = {};
-- ËÑË÷ÁÐ±í·þÎñÆ÷Ãû³Æ
local g_SearchServerName = {};
-- ËÑË÷ÁÐ±í·þÎñÆ÷ÊÇ·ñÐÂ·þ
local g_SearchServerIsNew = {};
-- ËÑË÷ÁÐ±í·þÎñÆ÷×´Ì¬
local g_SearchServerStatus = {};

-------------------------------------------------------------------------------------------------------------
--
-- º¯ÊýÇø.
--
--

-- ×¢²áonLoadÊÂ¼þ
function Cloud_SelectServer_PreLoad()

	-- ´ò¿ªÑ¡Ôñ·þÎñÆ÷½çÃæ
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_SERVER");
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_SERVER");
	
	-- Íæ¼Ò½øÈë³¡¾°
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	--ÉÏ´ÎµÇÂ¼µÄ·þÎñÆ÷
	this:RegisterEvent("GAMELOGIN_LASTSELECT_AREA_AND_SERVER");

	--¸üÐÂ·þÎñÆ÷ÁÐ±íÐÅÏ¢
	this:RegisterEvent("GAMELOGIN_UPDATE_SERVERINFO");

end

function Cloud_SelectServer_OnLoad()

	--Æ Í¨·þÎñÆ÷ÁÐ±í
	g_CloudBnLoginServer[1] = Cloud_SelectServer_AreaPage_AllSelect1;
	g_CloudBnLoginServer[2] = Cloud_SelectServer_AreaPage_AllSelect2;
	g_CloudBnLoginServer[3] = Cloud_SelectServer_AreaPage_AllSelect3;
	g_CloudBnLoginServer[4] = Cloud_SelectServer_AreaPage_AllSelect4;
	g_CloudBnLoginServer[5] = Cloud_SelectServer_AreaPage_AllSelect5;
	g_CloudBnLoginServer[6] = Cloud_SelectServer_AreaPage_AllSelect6;
	g_CloudBnLoginServer[7] = Cloud_SelectServer_AreaPage_AllSelect7;
	g_CloudBnLoginServer[8] = Cloud_SelectServer_AreaPage_AllSelect8;
	g_CloudBnLoginServer[9] = Cloud_SelectServer_AreaPage_AllSelect9;
	g_CloudBnLoginServer[10]= Cloud_SelectServer_AreaPage_AllSelect10;
	g_CloudBnLoginServer[11]= Cloud_SelectServer_AreaPage_AllSelect11;
	g_CloudBnLoginServer[12]= Cloud_SelectServer_AreaPage_AllSelect12;
	
	--ËÑË÷·þÎñÆ÷ÁÐ±í
	g_CloudSearchBnLoginServer[1] = Cloud_SelectServer_AreaPage_SearchSelect1;
	g_CloudSearchBnLoginServer[2] = Cloud_SelectServer_AreaPage_SearchSelect2;
	g_CloudSearchBnLoginServer[3] = Cloud_SelectServer_AreaPage_SearchSelect3;
	g_CloudSearchBnLoginServer[4] = Cloud_SelectServer_AreaPage_SearchSelect4;
	g_CloudSearchBnLoginServer[5] = Cloud_SelectServer_AreaPage_SearchSelect5;
	g_CloudSearchBnLoginServer[6] = Cloud_SelectServer_AreaPage_SearchSelect6;
	g_CloudSearchBnLoginServer[7] = Cloud_SelectServer_AreaPage_SearchSelect7;
	g_CloudSearchBnLoginServer[8] = Cloud_SelectServer_AreaPage_SearchSelect8;
	g_CloudSearchBnLoginServer[9] = Cloud_SelectServer_AreaPage_SearchSelect9;
	g_CloudSearchBnLoginServer[10]= Cloud_SelectServer_AreaPage_SearchSelect10;
	g_CloudSearchBnLoginServer[11]= Cloud_SelectServer_AreaPage_SearchSelect11;
	g_CloudSearchBnLoginServer[12]= Cloud_SelectServer_AreaPage_SearchSelect12;

	--ÍÆ¼ö·þÎñÆ÷ÁÐ±í
	g_Cloud_CommendableBnLoginServer[1] = Cloud_SelectServer_AreaPage_RecommendSelect1;
	g_Cloud_CommendableBnLoginServer[2] = Cloud_SelectServer_AreaPage_RecommendSelect2;
	g_Cloud_CommendableBnLoginServer[3] = Cloud_SelectServer_AreaPage_RecommendSelect3;
	g_Cloud_CommendableBnLoginServer[4] = Cloud_SelectServer_AreaPage_RecommendSelect4;
	g_Cloud_CommendableBnLoginServer[5] = Cloud_SelectServer_AreaPage_RecommendSelect5;
	g_Cloud_CommendableBnLoginServer[6] = Cloud_SelectServer_AreaPage_RecommendSelect6;

	local i;
	for i = 1, LOGIN_SERVER_AREA_COUNT do
		g_AreaName[i] = "";
		g_AreaDis[i] = "";
		g_AreaTip[i] = "";
	end
	
	-- µÃµ½·þÎñÆ÷ÐÅÏ¢
	Cloud_SelectServer_GetServerInfo();
end

--===============================================
-- OnEvent()
--===============================================
function Cloud_SelectServer_OnEvent(event)

	if not GameProduceLogin:IsYunGameMobileClient() then 
		return
	end
		
	if(event == "GAMELOGIN_OPEN_SELECT_SERVER") then
		
		if(not this:IsVisible() ) then
			Cloud_SelectServer_Client:Show();
 			Cloud_SelectServer_ImageFrame:Hide();
 			Cloud_SelectServer_Image2Frame:Hide();
 			GameProduceLogin:SetCurrentServerPage(1);
 			
 			Cloud_SelectServer_AddAllAreaButton()
 			
			this:Show()

			-- ²¥·Å±³¾°ÒôÀÖ
			if(g_idBackSound == -1) then
				g_idBackSound = Sound:PlaySound(2108, true);
			end
			
			--ÏÔÊ¾Ä¬ÈÏ·þÎñÆ÷´óÇø
			if g_Cloud_CurShowAreaIndex >= 0 and g_Cloud_CurShowPage >= 0 then
				Cloud_SelectServer_SearchName:SetText("");
				Cloud_SelectServer_ShowNormalAreaPage( g_Cloud_CurShowAreaIndex, g_Cloud_CurShowPage )
			elseif g_Cloud_Search_CurShowPage >= 0 then
				Cloud_SelectServer_ShowSearchPage( g_Cloud_Search_CurShowPage )
			else
				Cloud_SelectServer_SearchName:SetText("");
				Cloud_SelectServer_ShowRecommandPage()
			end
			
		end
	end
	
	-- ¹Ø± ½çÃæ
	if( event == "GAMELOGIN_CLOSE_SELECT_SERVER") then
		this:Hide();
		return;
	end
	
	-- ½øÈë³¡¾°£¬Í£Ö¹±³¾°ÒôÀÖ
	if( event == "PLAYER_ENTERING_WORLD") then
		if(g_idBackSound ~= -1) then
			Sound:StopSound(g_idBackSound);
			g_idBackSound = -1;
		end
	end
	
	--ÉÏ´ÎµÇÂ¼·þÎñÆ÷
	if( event == "GAMELOGIN_LASTSELECT_AREA_AND_SERVER") then

		local numArea =-1;
		local numServer = -1;
		if(arg0~=nil)then
			numArea = tonumber(arg0);
			g_LastArea = numArea;
		end
		if(arg1~=nil)then
			numServer = tonumber(arg1);
			g_LastServer = numServer;
		end
		if(numArea ~= -1 and numServer~=-1)then
			local have = 0;
			for aindex = 1,g_iCurAreaCount do
				if(numArea == g_AreaIndex[aindex]) then
					have = 1;
					break;
				end
			end
			if(have == 1)then
				g_LastServerName, g_LastServerState = GameProduceLogin:GetAreaLoginServerInfo(numArea, numServer);
				Cloud_SelectServer_AreaPage_RecommendSelectLast:SetText(g_LastServerName);
				--ÅÐ¶ÏÉÏ´ÎµÇÂ¼·þÎñÆ÷ÊÇ·ñ´¦ÓÚÎ¬»¤×´Ì¬ tt69698
				if (g_LastServerState == StateStop) then
					--Cloud_SelectServer_AreaPage_RecommendSelectLast:SetCheck(0);
					Cloud_SelectServer_AreaPage_RecommendSelectLast:Disable();
				else
					Cloud_SelectServer_AreaPage_RecommendSelectLast:Enable();
					--if(g_iCurSelArea == g_LastArea and g_LastServer ==g_iCurSelLoginServer)then
					--	SelectServer_Server_Last:SetCheck(1);
					--end
				end
			else
				Cloud_SelectServer_AreaPage_RecommendSelectLast:SetText("Vô");
				--SelectServer_Server_Last:SetCheck(0);
				Cloud_SelectServer_AreaPage_RecommendSelectLast:Disable();
			end
		else
			Cloud_SelectServer_AreaPage_RecommendSelectLast:SetText("Vô");
			--SelectServer_Server_Last:SetCheck(0);
			Cloud_SelectServer_AreaPage_RecommendSelectLast:Disable();
		end
		return;
	end;
	
	if( event == "GAMELOGIN_UPDATE_SERVERINFO") then
		-- µÃµ½·þÎñÆ÷ÐÅÏ¢
		Cloud_SelectServer_GetServerInfo();
		--ÏÔÊ¾ÍÆ¼ö·þÎñÆ÷
		Cloud_SelectServer_ShowRecommandPage()
	end
	
end

function Cloud_SelectServer_AreaSelect_Clicked()
end

function Cloud_SelectServer_AreaSelect1_Click()
end

--ËÑË÷°´Å¥
function Cloud_SelectServer_SearchOK_Clicked()
	local szSearchName = Cloud_SelectServer_SearchName:GetText();
	--È¥³ý×Ö·û´®Ê×Î²µÄ¿ ¸ñ
	szSearchName = string.gsub(szSearchName, "^%s*(.-)%s*$", "%1");
	Cloud_SelectServer_SearchName:SetText(szSearchName)
	if (szSearchName == "") then
		return;
	end
	
	-- µÃµ½login serverµÄÐÅÏ¢
	local iSearchServerCount = GameProduceLogin:SetLoginServerKeyword(szSearchName);
	if (iSearchServerCount > LOGIN_SERVER_COUNT) then
		iSearchServerCount = LOGIN_SERVER_COUNT;
	end
	g_Cloud_Search_CurLoginServerCount = iSearchServerCount;
			
	--ÏÔÊ¾Ö®Ç°½«µ±Ç°Ñ¡ÔñÈ«²¿Çå¿ 
	g_iCurSelArea = -1;
	g_iCurSelLoginServer = -1;
	g_iCurComSelLoginServer = -1;
	
	Cloud_SelectServer_ShowSearchPage( 0 )
end

--Ë¢ÐÂ
function Cloud_SelectServer_SearchReflash_Click()
	GameProduceLogin:LoadLaunch();
end

--ÉêÇë ÊºÅ
function Cloud_SelectServer_AccountReg()
	GameProduceLogin:StartAccountReg()
end

function Cloud_SelectServer_FollowClicked()
 	Cloud_SelectServer_Client:Hide();
 	Cloud_SelectServer_ImageFrame:Hide();
 	Cloud_SelectServer_Image2Frame:Show();
end

function Cloud_SelectServer_DesktopClicked()
 	Cloud_SelectServer_Client:Hide();
	Cloud_SelectServer_ImageFrame:Show();
 	Cloud_SelectServer_Image2Frame:Hide(); 	
end

function Cloud_SelectServer_Image_OnClosed()
	Cloud_SelectServer_Client:Show();
 	Cloud_SelectServer_ImageFrame:Hide();
 	Cloud_SelectServer_Image2Frame:Hide();
end

function Cloud_SelectServer_Image2_OnClosed()
	Cloud_SelectServer_Client:Show();
 	Cloud_SelectServer_ImageFrame:Hide();
 	Cloud_SelectServer_Image2Frame:Hide();
end

function Cloud_SelectServer_ReturnAreaSelect_Click()
end

function Cloud_SelectServer_RequisitionID_MouseEnter()
end

function Cloud_SelectServer_Payment_MouseEnter()
end

function Cloud_SelectServer_MouseLeave()
end

function Cloud_SelectServer_ReturnAreaSelect_MouseEnter()
end

--Ìî³äËùÓÐÇøÓòÐÅÏ¢
function Cloud_SelectServer_AddAllAreaButton()
	Cloud_SelectServer_AreaSelectList:Clear()
	
	local bar1 = Cloud_SelectServer_AreaSelectList:AddChild("Cloud_SelectServer_AreaSelectListItem")
	if not bar1 then
   	return
  end
  	
  bar1:GetSubItem("Cloud_SelectServer_AreaSelect"):SetText( "Ð« cØ phøc vø Khí" );
  bar1:SetEvent( "MouseLClick", string.format("Cloud_SelectServer_ShowRecommandPage()"))
  g_RecommandAreaButton = bar1:GetSubItem("Cloud_SelectServer_AreaSelect");
  	
  for iArea=1, g_iCurAreaCount do
  	local bar1 = Cloud_SelectServer_AreaSelectList:AddChild("Cloud_SelectServer_AreaSelectListItem")
		if not bar1 then
    	return
  	end
  	
  	bar1:GetSubItem("Cloud_SelectServer_AreaSelect"):SetText( g_AreaName[iArea] );
  	bar1:GetSubItem("Cloud_SelectServer_AreaSelect"):SetToolTip( g_AreaTip[iArea] );
  	bar1:SetEvent( "MouseLClick", string.format("Cloud_SelectServer_ShowNormalAreaPage(%d, 0)", iArea))
  	g_AreaButton[iArea] = bar1:GetSubItem("Cloud_SelectServer_AreaSelect");
  end
  	
end

--ÏÔÊ¾Æ Í¨·þÎñÆ÷: iPage(0~)
function Cloud_SelectServer_ShowNormalAreaPage( index, iPage )
	
	Cloud_SelectServer_AreaPage_AllClient:Show();
	Cloud_SelectServer_AreaPage_RecommendClient:Hide();
	Cloud_SelectServer_AreaPage_SearchClient:Hide();
	g_Cloud_Search_CurShowPage = -1;
	
	if g_RecommandAreaButton ~= nil then
		g_RecommandAreaButton:SetCheck(0);
	end
	for iArea=1, g_iCurAreaCount do
		if g_AreaButton[iArea] ~= nil then
			g_AreaButton[iArea]:SetCheck(0);
		end
	end
	if g_AreaButton[index] ~= nil then
		g_AreaButton[index]:SetCheck(1);
	end
	
	-- ¼ÇÂ¼µ±Ç°Ñ¡ÔñµÄÇøÓòË÷Òý.
	g_iCurSelArea = g_AreaIndex[index];
	
	for i=1, LOGIN_SERVER_COUNT_PERPAGE do
		g_CloudBnLoginServer[i]:Hide();
	end
	
	-- µÃµ½login serverµÄÐÅÏ¢
	local iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(g_iCurSelArea);
	if(iLoginServerCount > LOGIN_SERVER_COUNT) then
		iLoginServerCount=LOGIN_SERVER_COUNT;
	end
	
	local iBegin = iPage * LOGIN_SERVER_COUNT_PERPAGE;
	if iLoginServerCount <= iBegin then
		return
	end
	
	g_Cloud_CurShowAreaIndex = index;
	g_Cloud_CurShowPage = iPage;
	g_Cloud_CurLoginServerCount = iLoginServerCount;
	Cloud_SelectServer_UpdatePageStatus()
	
	for i=1, LOGIN_SERVER_COUNT_PERPAGE do
		if iBegin+i > iLoginServerCount then
			break
		end
		
		g_LoginServerName[iBegin+i]
		,g_LoginServerStatus[iBegin+i]
		,g_LoginServerCommendableLevel[iBegin+i]
		,g_LoginServerIsNew[iBegin+i]
		= GameProduceLogin:GetAreaLoginServerInfo(g_iCurSelArea, iBegin+i-1);
		
		if(g_LoginServerStatus[iBegin+i] == StatMax) then
			break;
		end
		
		g_CloudBnLoginServer[i]:Enable();
		g_CloudBnLoginServer[i]:Show();
				
		local strName = g_LoginServerName[iBegin+i];

		if(g_LoginServerIsNew[iBegin+i]==1)then
			strName = strName.."(Tân)";
		end;

		if(0 == g_LoginServerStatus[iBegin+i]) then

			strName = "#cff0000#e010101"..strName.."#cffffff";
		elseif(1 == g_LoginServerStatus[iBegin+i]) then

			strName = "#cff8a00#e010101"..strName.."#cffffff";
		elseif(2 == g_LoginServerStatus[iBegin+i]) then

			strName = "#cECE58D#e010101"..strName.."#cffffff";
		elseif(3 == g_LoginServerStatus[iBegin+i]) then

			strName = "#c4CFA4C#e010101"..strName.."#cffffff";
		else

			strName = "#c959595#e010101"..strName.."#cffffff";
			g_CloudBnLoginServer[i]:Disable();
		end

		g_CloudBnLoginServer[i]:SetText(strName);
	end
			
end

--ÉÏÒ»Ò³
function Cloud_SelectServer_AllSelectUp_Click()
	
	if g_Cloud_CurShowPage >= 1 then
		Cloud_SelectServer_ShowNormalAreaPage( g_Cloud_CurShowAreaIndex, g_Cloud_CurShowPage-1 )
	end
end

--ÏÂÒ»Ò³
function Cloud_SelectServer_AllSelectDown_Click()
	local iPageCount = math.ceil( g_Cloud_CurLoginServerCount / LOGIN_SERVER_COUNT_PERPAGE );
	if g_Cloud_CurShowPage+1 < iPageCount then
		Cloud_SelectServer_ShowNormalAreaPage( g_Cloud_CurShowAreaIndex, g_Cloud_CurShowPage+1 )
	end
end

--Ë¢ÐÂÉÏÒ»Ò³¡¢ÏÂÒ»Ò³×´Ì¬
function Cloud_SelectServer_UpdatePageStatus()
	local iPageCount = math.ceil( g_Cloud_CurLoginServerCount / LOGIN_SERVER_COUNT_PERPAGE );
	if g_Cloud_CurShowPage >= 1 then
		Cloud_SelectServer_AllSelectUpPage:Enable();
	else
		Cloud_SelectServer_AllSelectUpPage:Disable();
	end
	if g_Cloud_CurShowPage+1 < iPageCount then
		Cloud_SelectServer_AllSelectDownPage:Enable();
	else
		Cloud_SelectServer_AllSelectDownPage:Disable();
	end
	local strPage = string.format("%d/%d", (g_Cloud_CurShowPage+1), iPageCount );	
	Cloud_SelectServer_AllSelectCurrentlyPage:SetText( strPage );
end

--ÏÔÊ¾ÍÆ¼ö·þÎñÆ÷
function Cloud_SelectServer_ShowRecommandPage()
	Cloud_SelectServer_AreaPage_AllClient:Hide();
	Cloud_SelectServer_AreaPage_RecommendClient:Show();
	Cloud_SelectServer_AreaPage_SearchClient:Hide();
	g_Cloud_CurShowAreaIndex = -1;
	g_Cloud_Search_CurShowPage = -1;
	
	if g_RecommandAreaButton ~= nil then
		g_RecommandAreaButton:SetCheck(1);
	end
	for iArea=1, g_iCurAreaCount do
		if g_AreaButton[iArea] ~= nil then
			g_AreaButton[iArea]:SetCheck(0);
		end
	end
	
	--ÏÔÊ¾ÍÆ¼ö·þÎñÆ÷
	for i=1, CLOUD_COMMENDABLE_LOGIN_SERVER_COUNT do
		g_Cloud_CommendableBnLoginServer[i]:Hide();
	end
	
	if(indexForCommendable < 1)then
		return
	end
	
	Cloud_SelectServer_SortCommendableLoginServer();
	
	local strName="";
	for i=1, indexForCommendable do
		g_Cloud_CommendableBnLoginServer[i]:Show();
		local tmpAreaName = GameProduceLogin:GetServerAreaName(g_CommendableLoginServerAreaIndex[i]);
		local _i = string.find(tmpAreaName,"-");
		if(_i~=nil and _i<string.len(tmpAreaName)) then
			if(string.sub(tmpAreaName,1,_i-1)=="Công Tr¡c" or string.sub(tmpAreaName,1,_i-1)=="Võng Thông")then
				tmpAreaName = string.sub(tmpAreaName,_i+1);
			end
		end
		
		strName =tmpAreaName.."-"..g_CommendableLoginServerName[i];
		if(g_CommendableLoginServerIsNew[i]~=0)then
			strName =strName.."(Tân)";
		end
		if(0 == g_CommendableLoginServerStatus[i]) then
			strName = "#cff0000#e010101"..strName.."#cffffff";
		elseif(1 == g_CommendableLoginServerStatus[i]) then

			strName = "#cff8a00#e010101"..strName.."#cffffff";
		elseif(2 == g_CommendableLoginServerStatus[i]) then

			strName = "#cECE58D#e010101"..strName.."#cffffff";
		elseif(3 == g_CommendableLoginServerStatus[i]) then

			strName = "#c4CFA4C#e010101"..strName.."#cffffff";
		else

			strName = "#c959595#e010101"..strName.."#cffffff";
			g_Cloud_CommendableBnLoginServer[i]:Disable();
		end

		g_Cloud_CommendableBnLoginServer[i]:SetText(strName);
		
	end
	
end

--ÏÔÊ¾ËÑË÷·þÎñÆ÷
function Cloud_SelectServer_ShowSearchPage( iPage )
	Cloud_SelectServer_AreaPage_AllClient:Hide();
	Cloud_SelectServer_AreaPage_RecommendClient:Hide();
	Cloud_SelectServer_AreaPage_SearchClient:Show();
	g_Cloud_CurShowAreaIndex = -1;
	g_Cloud_Search_CurShowPage = -1;
		
	for i=1, SEARCH_LOGIN_SERVER_COUNT_PERPAGE do
		g_CloudSearchBnLoginServer[i]:Hide();
	end
				
	local iBegin = iPage * SEARCH_LOGIN_SERVER_COUNT_PERPAGE;
	
	g_Cloud_Search_CurShowPage = iPage;
	Cloud_SelectServer_UpdateSearchPageStatus()
	if g_Cloud_Search_CurLoginServerCount <= iBegin then
		return
	end
			
	for i=1, SEARCH_LOGIN_SERVER_COUNT_PERPAGE do
		if iBegin+i > g_Cloud_Search_CurLoginServerCount then
			break
		end
		
		g_SearchServerName[iBegin+i],
		g_SearchServerStatus[iBegin+i],
		_,
		g_SearchServerIsNew[iBegin+i],
		_,
		g_SearchServerAreaIndex[iBegin+i],
		_,
		g_SearchServerIndex[iBegin+i]
		= GameProduceLogin:GetKeywordLoginServerInfo(iBegin+i-1);
		
		g_CloudSearchBnLoginServer[i]:Show();
		if(g_SearchServerStatus[iBegin+i] == StatMax) then
			g_CloudSearchBnLoginServer[i]:Hide();
		end
		
		g_CloudSearchBnLoginServer[i]:Enable();
				
		local strName = g_SearchServerName[iBegin+i];

		if(g_SearchServerIsNew[iBegin+i]==1)then
			strName = strName.."(Tân)";
		end;

		if(0 == g_SearchServerStatus[iBegin+i]) then

			strName = "#cff0000#e010101"..strName.."#cffffff";
		elseif(1 == g_SearchServerStatus[iBegin+i]) then

			strName = "#cff8a00#e010101"..strName.."#cffffff";
		elseif(2 == g_SearchServerStatus[iBegin+i]) then

			strName = "#cECE58D#e010101"..strName.."#cffffff";
		elseif(3 == g_SearchServerStatus[iBegin+i]) then

			strName = "#c4CFA4C#e010101"..strName.."#cffffff";
		else

			strName = "#c959595#e010101"..strName.."#cffffff";
			g_CloudSearchBnLoginServer[i]:Disable();
		end

		g_CloudSearchBnLoginServer[i]:SetText(strName);
	end
	
end

--ÉÏÒ»Ò³
function Cloud_SelectServer_SearchSelectUp_Click()
	
	if g_Cloud_Search_CurShowPage >= 1 then
		Cloud_SelectServer_ShowSearchPage( g_Cloud_Search_CurShowPage-1 )
	end
end

--ÏÂÒ»Ò³
function Cloud_SelectServer_SearchSelectDown_Click()
	local iPageCount = math.ceil( g_Cloud_Search_CurLoginServerCount / LOGIN_SERVER_COUNT_PERPAGE );
	if g_Cloud_Search_CurShowPage+1 < iPageCount then
		Cloud_SelectServer_ShowSearchPage( g_Cloud_Search_CurShowPage+1 )
	end
end

--Ë¢ÐÂÉÏÒ»Ò³¡¢ÏÂÒ»Ò³×´Ì¬
function Cloud_SelectServer_UpdateSearchPageStatus()
	local iPageCount = math.ceil( g_Cloud_Search_CurLoginServerCount / SEARCH_LOGIN_SERVER_COUNT_PERPAGE );
	if g_Cloud_Search_CurShowPage >= 1 then
		Cloud_SelectServer_SearchSelectUp:Enable();
	else
		Cloud_SelectServer_SearchSelectUp:Disable();
	end
	if g_Cloud_Search_CurShowPage+1 < iPageCount then
		Cloud_SelectServer_SearchSelectDown:Enable();
	else
		Cloud_SelectServer_SearchSelectDown:Disable();
	end
	local strPage = string.format("%d/%d", (g_Cloud_Search_CurShowPage+1), iPageCount );	
	if g_Cloud_Search_CurShowPage+1 > iPageCount then
		strPage = string.format("%d/%d", iPageCount, iPageCount );	
	end
	Cloud_SelectServer_SearchSelectCurrently:SetText( strPage );
end

--Æ Í¨·þÎñÆ÷µã»÷ÊÂ¼þ
function Cloud_SelectServer_AllSelect_Click( index )

	if g_Cloud_CurShowAreaIndex == nil or g_AreaIndex[g_Cloud_CurShowAreaIndex] == nil then
		return
	end
	
	local iServerIndex = g_Cloud_CurShowPage * LOGIN_SERVER_COUNT_PERPAGE + index - 1;
	local iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(g_AreaIndex[g_Cloud_CurShowAreaIndex]);
	if(iLoginServerCount > LOGIN_SERVER_COUNT) then
		iLoginServerCount=LOGIN_SERVER_COUNT;
	end
	if iServerIndex >= iLoginServerCount then
		return
	end
	
	if(g_CloudBnLoginServer[index]:GetProperty("Disabled")=="True") then
		return;
	end
	
	-- ¼ÇÂ¼µ±Ç°Ñ¡ÔñµÄlogin server
	g_iCurSelLoginServer = iServerIndex;
	
	GameProduceLogin:SelectLoginServer(g_iCurSelArea, g_iCurSelLoginServer, 3);
	
end

--ËÑË÷·þÎñÆ÷µã»÷ÊÂ¼þ
function Cloud_SelectServer_SearchSelect_Click( index )
	
	if index < 1 or index > SEARCH_LOGIN_SERVER_COUNT_PERPAGE then
		return
	end
	if(g_CloudSearchBnLoginServer[index]:GetProperty("Disabled")=="True") then
		return;
	end
	
	local iServerIndex = g_Cloud_Search_CurShowPage * SEARCH_LOGIN_SERVER_COUNT_PERPAGE + index;	
	
	g_iCurSelArea = g_SearchServerAreaIndex[iServerIndex];
	g_iCurSelLoginServer = 	g_SearchServerIndex[iServerIndex];
		
	GameProduceLogin:SelectLoginServer(g_iCurSelArea, g_iCurSelLoginServer, 3);
		
end

--ÉÏ´ÎµÇÂ¼·þÎñÆ÷µã»÷ÊÂ¼þ
function Cloud_SelectServer_RecommendSelectLast_Click()
		
	GameProduceLogin:SelectLoginServer(g_LastArea, g_LastServer, 3);
	
end
--ÍÆ¼ö·þÎñÆ÷µã»÷ÊÂ¼þ
function Cloud_SelectServer_RecommendSelect1_Click( index )

	if index < 1 or index > CLOUD_COMMENDABLE_LOGIN_SERVER_COUNT then
		return
	end
	
	if(g_Cloud_CommendableBnLoginServer[index]:GetProperty("Disabled")=="True") then
		return;
	end
	
	g_iCurComSelLoginServer = index;
	
	g_iCurSelArea = g_CommendableLoginServerAreaIndex[index];
	g_iCurSelLoginServer = g_CommendableLoginServerServerIndex[index];
	g_iCurSelLoginServerName = GameProduceLogin:GetAreaLoginServerInfo(g_iCurSelArea, g_iCurSelLoginServer);
			
	GameProduceLogin:SelectLoginServer(g_iCurSelArea, g_iCurSelLoginServer, 3);
	
end


function Cloud_SelectServer_GetServerInfo()

	 	local iCurAreaCount = GameProduceLogin:GetServerAreaCount();
	 	local strAreaName = "Không có máy chü";
		local iLoginServerCount = -1;
		local ServerName;
		local ServerStatus;
		--ÍÆ¼öµÈ¼¶
		local RecommendLevel;
		local IsNew;
		indexForCommendable = 0;
		local testindex = 0;
		local nomalindex =0;
		local tuijian=0;
	 	for index = 0, iCurAreaCount - 1 do
			tuijian =0;
			if(nomalindex>=EFFECT_LOGIN_SERVER_AREA_COUNT) then
				break;
			end
			local areaname = GameProduceLogin:GetServerAreaName(index);
	 		-- µÃµ½ÇøÓòÃû×Ö.
			local i = string.find(areaname,"-");
			if(i~=nil and i<string.len(areaname)) then
				if(string.sub(areaname,1,i-1)=="Công Tr¡c" and nomalindex< EFFECT_LOGIN_SERVER_AREA_COUNT) then
					nomalindex = nomalindex +1;
	 				g_AreaName[nomalindex] = string.sub(areaname,i+1);
					g_AreaDis[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
					g_AreaIndex[nomalindex] = index;
					tuijian = 1;
					g_AreaTip[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
				end
			elseif(nomalindex< EFFECT_LOGIN_SERVER_AREA_COUNT) then
				nomalindex = nomalindex +1;
	 			g_AreaName[nomalindex] = GameProduceLogin:GetServerAreaName(index);
				g_AreaDis[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
				g_AreaIndex[nomalindex] = index;
				tuijian = 1;
				g_AreaTip[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
			end;
	 		-- ÉèÖÃÃû×Ö.
			iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(index);
			if(iLoginServerCount > LOGIN_SERVER_COUNT) then
				iLoginServerCount=LOGIN_SERVER_COUNT;
			end

			--µÃµ½ÍÆ¼ö·þÎñÆ÷ÁÐ±í
			if(tuijian==1)then
				for i=0,iLoginServerCount-1 do
					if(indexForCommendable>=CLOUD_COMMENDABLE_LOGIN_SERVER_COUNT) then
							break;
					end;
					ServerName,
					ServerStatus,
					--ServerID,
					--AreaID,
					RecommendLevel,
					IsNew
						= GameProduceLogin:GetAreaLoginServerInfo(index, i);
						-- ÍÆ¼ö·þÎñÆ÷id
					if(RecommendLevel>0 and indexForCommendable <CLOUD_COMMENDABLE_LOGIN_SERVER_COUNT and ServerStatus ~= StatMax) then
						indexForCommendable = indexForCommendable + 1;
						g_CommendableLoginServerName[indexForCommendable] = ServerName;
						g_CommendableLoginServerServerIndex[indexForCommendable] = i;
						g_CommendableLoginServerAreaIndex[indexForCommendable] = index;
						g_CommendableLoginServerCommendableLevel[indexForCommendable] = RecommendLevel;
						g_CommendableLoginServerIsNew[indexForCommendable] = IsNew;
						g_CommendableLoginServerStatus[indexForCommendable] = ServerStatus;

					end;
				end
			end;
	 	end
	 	
		g_iCurAreaCount =nomalindex ;
end

--ÅÅÐòÁÐ£¬´ÓÐ¡µ½´ó
function Cloud_SelectServer_SortCommendableLoginServer()

	local TotalCount = indexForCommendable;
	local tmp ;
	local p=0;
	for j = 1 , TotalCount -1 do
		for i=1, TotalCount-j do
			if(g_CommendableLoginServerCommendableLevel[i]>g_CommendableLoginServerCommendableLevel[i+1]) then
				tmp = g_CommendableLoginServerCommendableLevel[i];
				g_CommendableLoginServerCommendableLevel[i] = g_CommendableLoginServerCommendableLevel[i+1];
				g_CommendableLoginServerCommendableLevel[i+1] = tmp;

				tmp = g_CommendableLoginServerName[i];
				g_CommendableLoginServerName[i] = g_CommendableLoginServerName[i+1];
				g_CommendableLoginServerName[i+1] = tmp;

				tmp = g_CommendableLoginServerServerIndex[i];
				g_CommendableLoginServerServerIndex[i] = g_CommendableLoginServerServerIndex[i+1];
				g_CommendableLoginServerServerIndex[i+1] = tmp;

				tmp = g_CommendableLoginServerAreaIndex[i];
				g_CommendableLoginServerAreaIndex[i] = g_CommendableLoginServerAreaIndex[i+1];
				g_CommendableLoginServerAreaIndex[i+1] = tmp;

				tmp = g_CommendableLoginServerIsNew[i];
				g_CommendableLoginServerIsNew[i] = g_CommendableLoginServerIsNew[i+1];
				g_CommendableLoginServerIsNew[i+1] = tmp;

				tmp = g_CommendableLoginServerStatus[i];
				g_CommendableLoginServerStatus[i] = g_CommendableLoginServerStatus[i+1];
				g_CommendableLoginServerStatus[i+1] = tmp;
			end
		end;
	end;
end;
