local TBL_TextFrame = {}
local TBL_NotChat_Button = {}
local TBL_Chat_Button = {}

local AcceArryEx = 10   --??????????11???????????

local ControlMaxNum = 54

local PageStart = 0
local PageEnd = 0

local AcceSeting = 0   --??????
--===============================================
-- OnLoad()
--===============================================
function AcceSetup_PreLoad()

	this:RegisterEvent("TOGLE_INPUTSETUP");

	this:RegisterEvent("TOGLE_SYSTEMFRAME");
	this:RegisterEvent("TOGLE_SOUNDSETUP");
	this:RegisterEvent("TOGLE_VIEWSETUP");
	this:RegisterEvent("TOGLE_GAMESETUP");

end

function AcceSetup_OnLoad()
--	GameSetup_ChatBkg_Slider:SetProperty( "DocumentSize","1" );
--	GameSetup_ChatBkg_Slider:SetProperty( "PageSize","0.1" );
--	GameSetup_ChatBkg_Slider:SetProperty( "StepSize","0.1" );

--³õÊ¼»¯Í¼Æ¬±í
TBL_TextFrame[1] = ZiDingYi_List_Name1;
TBL_TextFrame[2] = ZiDingYi_List_Name2;
TBL_TextFrame[3] = ZiDingYi_List_Name3;
TBL_TextFrame[4] = ZiDingYi_List_Name4;
TBL_TextFrame[5] = ZiDingYi_List_Name5;
TBL_TextFrame[6] = ZiDingYi_List_Name6;
TBL_TextFrame[7] = ZiDingYi_List_Name7;
TBL_TextFrame[8] = ZiDingYi_List_Name8;
TBL_TextFrame[9] = ZiDingYi_List_Name9;
TBL_TextFrame[10] = ZiDingYi_List_Name10;
TBL_TextFrame[11] = ZiDingYi_List_Name11;
TBL_TextFrame[12] = ZiDingYi_List_Name12;
TBL_TextFrame[13] = ZiDingYi_List_Name13;
TBL_TextFrame[14] = ZiDingYi_List_Name14;
TBL_TextFrame[15] = ZiDingYi_List_Name15;
TBL_TextFrame[16] = ZiDingYi_List_Name16;
TBL_TextFrame[17] = ZiDingYi_List_Name17;
TBL_TextFrame[18] = ZiDingYi_List_Name18;
TBL_TextFrame[19] = ZiDingYi_List_Name19;
TBL_TextFrame[20] = ZiDingYi_List_Name20;
TBL_TextFrame[21] = ZiDingYi_List_Name21;
TBL_TextFrame[22] = ZiDingYi_List_Name22;
TBL_TextFrame[23] = ZiDingYi_List_Name23;
TBL_TextFrame[24] = ZiDingYi_List_Name24;
TBL_TextFrame[25] = ZiDingYi_List_Name25;
TBL_TextFrame[26] = ZiDingYi_List_Name26;
TBL_TextFrame[27] = ZiDingYi_List_Name27;
TBL_TextFrame[28] = ZiDingYi_List_Name28;
TBL_TextFrame[29] = ZiDingYi_List_Name29;
TBL_TextFrame[30] = ZiDingYi_List_Name30;
TBL_TextFrame[31] = ZiDingYi_List_Name31;
TBL_TextFrame[32] = ZiDingYi_List_Name32;
TBL_TextFrame[33] = ZiDingYi_List_Name33;
TBL_TextFrame[34] = ZiDingYi_List_Name34;
TBL_TextFrame[35] = ZiDingYi_List_Name35;
TBL_TextFrame[36] = ZiDingYi_List_Name36;
TBL_TextFrame[37] = ZiDingYi_List_Name37;
TBL_TextFrame[38] = ZiDingYi_List_Name38;
TBL_TextFrame[39] = ZiDingYi_List_Name39;
TBL_TextFrame[40] = ZiDingYi_List_Name40;
TBL_TextFrame[41] = ZiDingYi_List_Name41;
TBL_TextFrame[42] = ZiDingYi_List_Name42;
TBL_TextFrame[43] = ZiDingYi_List_Name43;
TBL_TextFrame[44] = ZiDingYi_List_Name44;
TBL_TextFrame[45] = nil--ZiDingYi_List_Name45;
TBL_TextFrame[46] = nil--ZiDingYi_List_Name46;
TBL_TextFrame[47] = ZiDingYi_List_Name47;
TBL_TextFrame[48] = ZiDingYi_List_Name48;
TBL_TextFrame[49] = ZiDingYi_List_Name49;
TBL_TextFrame[50] = ZiDingYi_List_Name50;
TBL_TextFrame[51] = ZiDingYi_List_Name51;
TBL_TextFrame[52] = ZiDingYi_List_Name52;
TBL_TextFrame[53] = ZiDingYi_List_Name53;
TBL_TextFrame[54] = ZiDingYi_List_Name54;


--³õÊ¼NotChat_Button±í
TBL_NotChat_Button[1] = ZiDingYi_NotChat_Button1;
TBL_NotChat_Button[2] = ZiDingYi_NotChat_Button2;
TBL_NotChat_Button[3] = ZiDingYi_NotChat_Button3;
TBL_NotChat_Button[4] = ZiDingYi_NotChat_Button4;
TBL_NotChat_Button[5] = ZiDingYi_NotChat_Button5;
TBL_NotChat_Button[6] = ZiDingYi_NotChat_Button6;
TBL_NotChat_Button[7] = ZiDingYi_NotChat_Button7;
TBL_NotChat_Button[8] = ZiDingYi_NotChat_Button8;
TBL_NotChat_Button[9] = ZiDingYi_NotChat_Button9;
TBL_NotChat_Button[10] = ZiDingYi_NotChat_Button10;
TBL_NotChat_Button[11] = ZiDingYi_NotChat_Button11;
TBL_NotChat_Button[12] = ZiDingYi_NotChat_Button12;
TBL_NotChat_Button[13] = ZiDingYi_NotChat_Button13;
TBL_NotChat_Button[14] = ZiDingYi_NotChat_Button14;
TBL_NotChat_Button[15] = ZiDingYi_NotChat_Button15;
TBL_NotChat_Button[16] = ZiDingYi_NotChat_Button16;
TBL_NotChat_Button[17] = ZiDingYi_NotChat_Button17;
TBL_NotChat_Button[18] = ZiDingYi_NotChat_Button18;
TBL_NotChat_Button[19] = ZiDingYi_NotChat_Button19;
TBL_NotChat_Button[20] = ZiDingYi_NotChat_Button20;
TBL_NotChat_Button[21] = ZiDingYi_NotChat_Button21;
TBL_NotChat_Button[22] = ZiDingYi_NotChat_Button22;
TBL_NotChat_Button[23] = ZiDingYi_NotChat_Button23;
TBL_NotChat_Button[24] = ZiDingYi_NotChat_Button24;
TBL_NotChat_Button[25] = ZiDingYi_NotChat_Button25;
TBL_NotChat_Button[26] = ZiDingYi_NotChat_Button26;
TBL_NotChat_Button[27] = ZiDingYi_NotChat_Button27;
TBL_NotChat_Button[28] = ZiDingYi_NotChat_Button28;
TBL_NotChat_Button[29] = ZiDingYi_NotChat_Button29;
TBL_NotChat_Button[30] = ZiDingYi_NotChat_Button30;
TBL_NotChat_Button[31] = ZiDingYi_NotChat_Button31;
TBL_NotChat_Button[32] = ZiDingYi_NotChat_Button32;
TBL_NotChat_Button[33] = ZiDingYi_NotChat_Button33;
TBL_NotChat_Button[34] = ZiDingYi_NotChat_Button34;
TBL_NotChat_Button[35] = ZiDingYi_NotChat_Button35;
TBL_NotChat_Button[36] = ZiDingYi_NotChat_Button36;
TBL_NotChat_Button[37] = ZiDingYi_NotChat_Button37;
TBL_NotChat_Button[38] = ZiDingYi_NotChat_Button38;
TBL_NotChat_Button[39] = ZiDingYi_NotChat_Button39;
TBL_NotChat_Button[40] = ZiDingYi_NotChat_Button40;
TBL_NotChat_Button[41] = ZiDingYi_NotChat_Button41;
TBL_NotChat_Button[42] = ZiDingYi_NotChat_Button42;
TBL_NotChat_Button[43] = ZiDingYi_NotChat_Button43;
TBL_NotChat_Button[44] = ZiDingYi_NotChat_Button44;
TBL_NotChat_Button[45] = nil--ZiDingYi_NotChat_Button45;
TBL_NotChat_Button[46] = nil--ZiDingYi_NotChat_Button46;
TBL_NotChat_Button[47] = ZiDingYi_NotChat_Button47;
TBL_NotChat_Button[48] = ZiDingYi_NotChat_Button48;
TBL_NotChat_Button[49] = ZiDingYi_NotChat_Button49;
TBL_NotChat_Button[50] = ZiDingYi_NotChat_Button50;
TBL_NotChat_Button[51] = ZiDingYi_NotChat_Button51;
TBL_NotChat_Button[52] = ZiDingYi_NotChat_Button52;
TBL_NotChat_Button[53] = ZiDingYi_NotChat_Button53;
TBL_NotChat_Button[54] = ZiDingYi_NotChat_Button54;

--³õÊ¼TBL_Chat_Button±í
TBL_Chat_Button[1] = ZiDingYi_Chat_Button1;
TBL_Chat_Button[2] = ZiDingYi_Chat_Button2;
TBL_Chat_Button[3] = ZiDingYi_Chat_Button3;
TBL_Chat_Button[4] = ZiDingYi_Chat_Button4;
TBL_Chat_Button[5] = ZiDingYi_Chat_Button5;
TBL_Chat_Button[6] = ZiDingYi_Chat_Button6;
TBL_Chat_Button[7] = ZiDingYi_Chat_Button7;
TBL_Chat_Button[8] = ZiDingYi_Chat_Button8;
TBL_Chat_Button[9] = ZiDingYi_Chat_Button9;
TBL_Chat_Button[10] = ZiDingYi_Chat_Button10;
TBL_Chat_Button[11] = ZiDingYi_Chat_Button11;
TBL_Chat_Button[12] = ZiDingYi_Chat_Button12;
TBL_Chat_Button[13] = ZiDingYi_Chat_Button13;
TBL_Chat_Button[14] = ZiDingYi_Chat_Button14;
TBL_Chat_Button[15] = ZiDingYi_Chat_Button15;
TBL_Chat_Button[16] = ZiDingYi_Chat_Button16;
TBL_Chat_Button[17] = ZiDingYi_Chat_Button17;
TBL_Chat_Button[18] = ZiDingYi_Chat_Button18;
TBL_Chat_Button[19] = ZiDingYi_Chat_Button19;
TBL_Chat_Button[20] = ZiDingYi_Chat_Button20;
TBL_Chat_Button[21] = ZiDingYi_Chat_Button21;
TBL_Chat_Button[22] = ZiDingYi_Chat_Button22;
TBL_Chat_Button[23] = ZiDingYi_Chat_Button23;
TBL_Chat_Button[24] = ZiDingYi_Chat_Button24;
TBL_Chat_Button[25] = ZiDingYi_Chat_Button25;
TBL_Chat_Button[26] = ZiDingYi_Chat_Button26;
TBL_Chat_Button[27] = ZiDingYi_Chat_Button27;
TBL_Chat_Button[28] = ZiDingYi_Chat_Button28;
TBL_Chat_Button[29] = ZiDingYi_Chat_Button29;
TBL_Chat_Button[30] = ZiDingYi_Chat_Button30;
TBL_Chat_Button[31] = ZiDingYi_Chat_Button31;
TBL_Chat_Button[32] = ZiDingYi_Chat_Button32;
TBL_Chat_Button[33] = ZiDingYi_Chat_Button33;
TBL_Chat_Button[34] = ZiDingYi_Chat_Button34;
TBL_Chat_Button[35] = ZiDingYi_Chat_Button35;
TBL_Chat_Button[36] = ZiDingYi_Chat_Button36;
TBL_Chat_Button[37] = ZiDingYi_Chat_Button37;
TBL_Chat_Button[38] = ZiDingYi_Chat_Button38;
TBL_Chat_Button[39] = ZiDingYi_Chat_Button39;
TBL_Chat_Button[40] = ZiDingYi_Chat_Button40;
TBL_Chat_Button[41] = ZiDingYi_Chat_Button41;
TBL_Chat_Button[42] = ZiDingYi_Chat_Button42;
TBL_Chat_Button[43] = ZiDingYi_Chat_Button43;
TBL_Chat_Button[44] = ZiDingYi_Chat_Button44;
TBL_Chat_Button[45] = nil--ZiDingYi_Chat_Button45;
TBL_Chat_Button[46] = nil--ZiDingYi_Chat_Button46;
TBL_Chat_Button[47] = ZiDingYi_Chat_Button47;
TBL_Chat_Button[48] = ZiDingYi_Chat_Button48;
TBL_Chat_Button[49] = ZiDingYi_Chat_Button49;
TBL_Chat_Button[50] = ZiDingYi_Chat_Button50;
TBL_Chat_Button[51] = ZiDingYi_Chat_Button51;
TBL_Chat_Button[52] = ZiDingYi_Chat_Button52;
TBL_Chat_Button[53] = ZiDingYi_Chat_Button53;
TBL_Chat_Button[54] = ZiDingYi_Chat_Button54;

--Òþ²Ø²»ÐèÒªµÄ²¿·Ö
for i = 11,ControlMaxNum do
  if(TBL_TextFrame[i] ~= nil and TBL_NotChat_Button[i] ~= nil and TBL_Chat_Button[i] ~= nil) then
    TBL_TextFrame[i]:Hide()
    TBL_NotChat_Button[i]:Hide()
    TBL_Chat_Button[i]:Hide()
  end
end

PageStart = 1;
PageEnd = PageStart + 10
end

--===============================================
-- OnEvent()
--===============================================
function AcceSetup_OnEvent(event)

	if ( event == "TOGLE_INPUTSETUP" ) then
    if(arg0 == "show") then -- ????
	    --PushDebugMessage("´ò¿ªÏûÏ¢");
		  this:Show();		
		  AcceSetup_UpdateFrame();
		else -- ????
			if(tonumber(arg2) > 54) then--????
				return
			end 
			if (tostring( arg0 ) == "") then
				TBL_NotChat_Button[tonumber(arg2)]:SetProperty("Text", "Không");
			else
				TBL_NotChat_Button[tonumber(arg2)]:SetProperty("Text", tostring( arg0 ));
			end
	    
			if (tostring( arg1 ) == "") then
				TBL_Chat_Button[tonumber(arg2)]:SetProperty("Text", "Không");
			else
				TBL_Chat_Button[tonumber(arg2)]:SetProperty("Text", tostring( arg1 ));
			end
			AcceSeting = 0;
		--SystemSetup:InputSetup_OnOff(false,false,0);
		end
	elseif(event == "TOGLE_GAMESETUP" ) then
		this:Hide();
	elseif(event == "TOGLE_SYSTEMFRAME" ) then
		this:Hide();
	elseif(event == "TOGLE_SOUNDSETUP" ) then
		this:Hide();
	elseif(event == "TOGLE_VIEWSETUP" ) then
		this:Hide();
	end

end


--===============================================
-- UpdateFrame()
--===============================================
function AcceSetup_UpdateFrame()

   local key1,key2

   for i = 1,ControlMaxNum do
     if(TBL_TextFrame[i] ~= nil and TBL_NotChat_Button[i] ~= nil and TBL_Chat_Button[i] ~= nil) then
        key1,key2 = SystemSetup:GetInputSetup(i + AcceArryEx);
        if(key1 == "") then
          TBL_NotChat_Button[i]:SetProperty("Text", "Không");
        else
          TBL_NotChat_Button[i]:SetProperty("Text", key1);
        end
      
        if(key2 == "") then
          TBL_Chat_Button[i]:SetProperty("Text", "Không");
        else
          TBL_Chat_Button[i]:SetProperty("Text", key2);   
        end
      end
   end
end

--===============================================
-- IDOK()
--===============================================
function AcceSetup_Accept_Clicked()
  if(AcceSeting == 1) then
     PushDebugMessage("Thao tác th¤t bÕi, sau khi hoàn thành mã kích hoÕt r°i hãy tiªn hành thao tác khác");
     return;
  end
  --Ó¦ÓÃÐÂµÄ¿ì½Ý¼üÉèÖÃ
	SystemSetup:UseAcceCustomKey();
	this:Hide();
end

--===============================================
-- IDCONCLE
--===============================================
function AcceSetup_Cancel_Clicked()

  SystemSetup:InputSetupSwitch(false)
	this:Hide();
	AcceSeting = 0;

end


function ZiDingYi_shangyiye_Clicked()
    if(AcceSeting == 1) then
     PushDebugMessage("Thao tác th¤t bÕi, sau khi hoàn thành mã kích hoÕt r°i hãy tiªn hành thao tác khác");
     return;
    end
    
    PageChange(0)
end

function ZiDingYi_xiayiye_Clicked()
    if(AcceSeting == 1) then
     PushDebugMessage("Thao tác th¤t bÕi, sau khi hoàn thành mã kích hoÕt r°i hãy tiªn hành thao tác khác");
     return;
    end
    
    PageChange(1)
end

function PageChange(type)

    if(type == 0) then  --??? 
      if((PageStart - 10) < 1) then--??????
         return
      elseif((PageStart - 10) < 11) then
         ZiDingYi_shangyiye:SetProperty("Disabled", "True");
      end
      PageStart = PageStart - 10;  
      --»Ö¸´ÏÂÒ»Ò³°´Å¥µÄ¿ÉÓÃÐÔ 
      ZiDingYi_xiayiye:SetProperty("Disabled", "False");
    elseif(type == 1) then  --???
      if((PageStart + 10) > 51) then--??????
         return
      elseif((PageStart + 10) > 41) then
         ZiDingYi_xiayiye:SetProperty("Disabled", "True");
      end
      PageStart = PageStart + 10; 
      --»Ö¸´ÉÏÒ»Ò³°´Å¥µÄ¿ÉÓÃÐÔ 
      ZiDingYi_shangyiye:SetProperty("Disabled", "False");     
    end
    
    PageEnd = PageStart + 10
    
	local RealPageStart = PageStart
	local RealPageEnd = PageEnd
	if PageStart >= 50 then
		RealPageStart = PageStart +2
	end
	if PageEnd >= 50 then
    	RealPageEnd = PageEnd +2
    end
    
    for i = 1,ControlMaxNum do
      if(i >= RealPageStart and i < RealPageEnd) then   --???????????????
         if(TBL_TextFrame[i] ~= nil and TBL_NotChat_Button[i] ~= nil and TBL_Chat_Button[i] ~= nil) then
          TBL_TextFrame[i]:Show()
          TBL_NotChat_Button[i]:Show()
          TBL_Chat_Button[i]:Show()
         end
      else
          if(TBL_TextFrame[i] ~= nil and TBL_NotChat_Button[i] ~= nil and TBL_Chat_Button[i] ~= nil) then
            TBL_TextFrame[i]:Hide()
            TBL_NotChat_Button[i]:Hide()
            TBL_Chat_Button[i]:Hide()
          end
      end
    end
end

function Chat_Button_Clicked(ButtonId)
    if(AcceSeting == 1) then
     PushDebugMessage("Thao tác th¤t bÕi, sau khi hoàn thành mã kích hoÕt r°i hãy tiªn hành thao tác khác");
     return;
    end
    --½øÈëÉèÖÃ¿ì½Ý¼ü×´Ì¬
    SystemSetup:InputSetup_OnOff(true,true,ButtonId);
    TBL_Chat_Button[ButtonId]:SetText("#GXin nh§p");
   	
    AcceSeting = 1;
end

function NoChat_Button_Clicked(ButtonId)

   if(AcceSeting == 1) then
     PushDebugMessage("Thao tác th¤t bÕi, sau khi hoàn thành mã kích hoÕt r°i hãy tiªn hành thao tác khác");
     return;
   end
   --½øÈëÉèÖÃ¿ì½Ý¼ü×´Ì¬
   SystemSetup:InputSetup_OnOff(true,false,ButtonId);
   TBL_NotChat_Button[ButtonId]:SetText("#GXin nh§p");
   	
   AcceSeting = 1;
end

--»Ö¸´¿ì½Ý¼üÄ¬ÈÏÉèÖÃ
function ComeBackAcce_Clicked()

   if(AcceSeting == 1) then
     PushDebugMessage("Thao tác th¤t bÕi, sau khi hoàn thành mã kích hoÕt r°i hãy tiªn hành thao tác khác");
     return;
   end
   --½øÈëÉèÖÃ¿ì½Ý¼ü×´Ì¬
   SystemSetup:ComeBackAcce();
   AcceSetup_UpdateFrame();
   
   PushDebugMessage("H°i phøc thành công! Hi®n ðã tr· v« trÕng thái m£c ð¸nh.");
   	
end
