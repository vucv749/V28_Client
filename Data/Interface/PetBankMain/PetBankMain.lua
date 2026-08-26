local PETBANK_CURRENT_SELECT = 0; --????
local PETBANK_MAX_COUNT  =10 ;--???????
local PETBANK_CURRENT_NUM =0; --???????
local PETBANKMAX_CURRNET_SIZE =0 ;--?????????size
local MAX_OBJ_DISTANCE = 3.0;
local objCared = -1;

local PETBANK_AITYPE = {};

function PetBankMain_PreLoad()
	this:RegisterEvent("TOGLE_PETBANK"); --??????????
	this:RegisterEvent("TOGLE_PETLIST_PETNUM_CHNAGE");
	this:RegisterEvent("TOGLE_PET_PAGE"); --??????
	--this:RegisterEvent("TOGLE_GETBANKSIZE_PETBANK"); --¸üÐÂÑ¡ÖÐÊÂ¼þ 
	this:RegisterEvent("OBJECT_CARED_EVENT",false); --??????
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("PLAYER_LEAVE_WORLD")	--????????
end


function PetBankMain_OnLoad()

	PETBANK_AITYPE[0] = "Nhát gan";
	PETBANK_AITYPE[1] = "C¦n th§n";
	PETBANK_AITYPE[2] = "Trung thñc";
	PETBANK_AITYPE[3] = "Nhanh nh©n";
	PETBANK_AITYPE[4] = "Dûng mãnh";

end

function PetBankMain_OnEvent(event)
     -- PushDebugMessage("event".. "  "..event) 
        if ( event == "TOGLE_PETBANK" ) then--??????????
		local nMaxbanksize = tonumber(arg2)
  	 	if nMaxbanksize ~= nil and 0 < nMaxbanksize and nMaxbanksize <= 10 then
  	 	  PETBANKMAX_CURRNET_SIZE = nMaxbanksize
  	 	end
		local openpetbank = tonumber(arg3)
		if openpetbank ~= nil and openpetbank < 1 then
		return ;
		end
		 if(IsWindowShow("PetBankMain")) then
		  CloseWindow("PetBankMain", true);
		 end
		 if(IsWindowShow("VIP_Shop")) then
		  CloseWindow("VIP_Shop", true);
		 end
		 if(IsWindowShow("YouLongKa2")) then
		  CloseWindow("YouLongKa2", true);
		 end
			--¹Ø± ÒÑ´ò¿ª½çÃæ
			if(IsWindowShow("TargetPet")) then
				CloseWindow("TargetPet", true);
			end	
			if(IsWindowShow("TargetPet2")) then
				CloseWindow("TargetPet2", true);
			end
			if(IsWindowShow("Pet")) then
				CloseWindow("Pet", true);
			end	

			if IsWindowShow("PetLianHua") then
			  CloseWindow("PetLianHua", true)
			end

			if IsWindowShow("YueKa") then
				CloseWindow("YueKa", true)
			end
			 
		 objCared = Bank:GetNpcId(); --??bank???
		 this:CareObject(objCared, 1, "PetBankMain");
		 this:Show()
		 PetBankMain_UpDataPetList()
		 
		 	--¹ØÐÄÉÌÈËObj
		--if( 0 > objCared ) then
			--Shop_Text:SetText("#{VIPTQ_110908_11}");	--ÏÈ âÑù°É£¬ÓÐÎÊÌâÔÙÐÞ
			
			--PetBankMain_Watch_Text:SetText("#{VIPTQ3_120517_29}")
			--PetBankMain_StopWatch:SetProperty("Timer", tostring(5*60))
			--PetBankMain_StopWatch:SetProperty("TextColor", "FF00FF00")
			--PetBankMain_Watch_Text:Show()
			--PetBankMain_StopWatch:Show()
		--else
			--PetBankMain_Watch_Text:Hide()
			--PetBankMain_StopWatch:Hide()
		--end
	elseif( event == "TOGLE_PETLIST_PETNUM_CHNAGE" ) then--??????????
	 	PetBankMain_UpDataPetList();
	elseif( event == "UPDATE_PET_PAGE" ) then
	 	PetBankMain_UpDataPetList();
	elseif( event == "TOGLE_PET_PAGE" ) then--??????????
	 	local nSelectArg0 = tonumber(arg0)
	 	local nPetCount = Pet:GetPet_Count_PetBank()
	 	if 0<=nSelectArg0  and nSelectArg0 < nPetCount then
	 	   PETBANK_CURRENT_SELECT = nSelectArg0
	 	end
	 	--elseif( event == "TOGLE_GETBANKSIZE_PETBANK" ) then--¸üÐÂÒøÐÐµÄ´óÐ¡
	 	--  local nPetBankSizeArg1 = tonumber(arg1)
  		--if nPetBankSizeArg1~=nil and 0< nPetBankSizeArg1 then
  		 -- PETBANKMAX_CURRNET_SIZE = nPetBankSizeArg1
  		--end
        elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			CloseWindow("PetBankMain", true);
			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "PetBankMain");
		end
		-------------------------------------------------------
	elseif (event == "PLAYER_LEAVE_WORLD") then
		PetBankMain_Close_Click()
	end
end



function PetBankMain_OnShown()

end

function PetBankMain_OnHidden()

end

--!!!reloadscript =PetBankMain
function PetBankMain_UpDataPetList()

	PetBankMain_List : ClearListBox();
	local nPetCount = Pet:GetPet_Count_PetBank()
	PetBankMain_TheHaveList:SetText("#{ZSYH_120503_18}"..nPetCount.."/"..PETBANKMAX_CURRNET_SIZE) --ZSYH_120503_18 ????
	if nPetCount < 1 then
		PETBANK_CURRENT_SELECT = -1;
		PetBankMain_NeedLevel:SetText(" ") --???
		PetBankMain_Level:SetText(" ") --??
		PetBankMain_FakeObject : SetFakeObject( "" );
		return;
	else 
	   local szCharName = Pet:GetPetList_Appoint_PetBank(PETBANK_CURRENT_SELECT);
	   if szCharName ==" " or szCharName ==nil then
		PETBANK_CURRENT_SELECT = Pet :GetFirstPetPosInBank_PetBank();
		--°ÑÒøÐÐ±³°üÊý¾Ý¸üÐÂÁËµÄ²Ù×÷¸æËß äÊÞ±³°ülist
		Pet : PetBank_PetListSelectChange( tonumber(PETBANK_CURRENT_SELECT),0);
	   end
	    
	end
	--if PETBANK_CURRENT_SELECT < 0 then
	--  return;
--	end
	local num =0
	local bSelect =0
	local bHasPet =0;
	 local strToolTips = "";
	for i=1, PETBANK_MAX_COUNT do
			if 1==Pet:IsPresent_PetBank(i-1) then
				local	szPetName, xiedaiLevl,CurrentLevel,szOn = Pet:GetPetList_Appoint_PetBank(i-1);
				if(szPetName~= "")then
				  	--  äÊÞ²»ÔÚ±³°üÀï
					if ( szOn == "on_packa" ) then 
						if (PlayerPackage:IsPetLock(i-1,1) == 1)  then
							local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(i-1 ,1);
							if( nUnlockElapsedTime == 0 ) then
								szPetName = szPetName.. "#-05";
								strToolTips =  "Ðã khóa" ;
							else
								szPetName = szPetName.. "#-10";
								local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime);			
								strToolTips = strLeftTime ;
							end	
							PetBankMain_List:AddItem(szPetName, i-1);
							PetBankMain_List:SetItemTooltip( num, strToolTips );
							num = num +1
						else
							PetBankMain_List : AddItem(szPetName, i-1);
							num = num +1
						end
						bHasPet =1
						if(i-1 ==  PETBANK_CURRENT_SELECT)then
						  bSelect =1
						end
					end
				 end
		         end
	end
	
	-- PushDebugMessage("num " .." " ..num ) --ÇëÑ¡ÔñÒªÈ¡³öµÄ äÊÞ
	if  -1<PETBANK_CURRENT_SELECT  and PETBANK_CURRENT_SELECT < PETBANK_MAX_COUNT and 1== bSelect then
	  local PetName , xiedaiLevel ,PetLevel = Pet:GetPetList_Appoint_PetBank(PETBANK_CURRENT_SELECT)
	  local strNeedLevelColor = "#c00FF00"
	  if(PetName~= "")then
	  	PetBankMain_UpdateType()
			PetBankMain_NeedLevel:SetText(strNeedLevelColor..xiedaiLevel.."#{ZSYH_120503_47}") --ZSYH_120503_18  ???
			PetBankMain_Level:SetText("#{ZSYH_120503_48}"..PetLevel) --??
			PetBankMain_List : SetItemSelectByItemID(PETBANK_CURRENT_SELECT);
			PetBankMain_FakeObject : SetFakeObject( "" );
			Pet : SetModel_PetBank(PETBANK_CURRENT_SELECT);
			PetBankMain_FakeObject :SetFakeObject( "My_PetBank" );
		else	
			PetBankMain_List : SetItemSelectByItemID(-1);
			PetBankMain_NeedLevel:SetText("#c00FF00".."0".."#{ZSYH_120503_47}") --???
			PetBankMain_Level:SetText("#{ZSYH_120503_48}".."0") --??
			PetBankMain_FakeObject : SetFakeObject( "" );
	   end
	 else
		PETBANK_CURRENT_SELECT = Pet :GetFirstPetPosInBank_PetBank();
		--°ÑÒøÐÐ±³°üÊý¾Ý¸üÐÂÁËµÄ²Ù×÷¸æËß äÊÞ±³°ülist
		Pet : PetBank_PetListSelectChange( tonumber(PETBANK_CURRENT_SELECT),0);
		local  PetName1 , xiedaiLevel1 ,PetLevel1 = Pet:GetPetList_Appoint_PetBank(PETBANK_CURRENT_SELECT)
		local strNeedLevelColor1 = "#c00FF00"
		
		if bHasPet ==1 and PetName1~= "" then
			PetBankMain_UpdateType()
			PetBankMain_NeedLevel:SetText(strNeedLevelColor1..xiedaiLevel1.."#{ZSYH_120503_47}") --ZSYH_120503_18  ???
			PetBankMain_Level:SetText("#{ZSYH_120503_48}"..PetLevel1) --??
			PetBankMain_List : SetItemSelectByItemID(PETBANK_CURRENT_SELECT);
			PetBankMain_FakeObject : SetFakeObject( "" );
			Pet : SetModel_PetBank(0); 
			PetBankMain_FakeObject :SetFakeObject( "My_PetBank" );
		else    
			PetBankMain_List : SetItemSelectByItemID(-1);
			PetBankMain_NeedLevel:SetText("#c00FF00".."0".."#{ZSYH_120503_47}") --???
			PetBankMain_Level:SetText("#{ZSYH_120503_48}".."0") --??
			PetBankMain_FakeObject : SetFakeObject( "" );
		end
	 end 	
	  --
end

--
-- Ðý×ª äÊÞÄ£ÐÍ£¨Ïò×ó)
--
function PetBankMain_TurnLeft(start)
	--Ïò×óÐý×ª¿ªÊ¼
	if(start==1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetBankMain_FakeObject:RotateBegin(-0.3);
	--Ïò×óÐý×ª½áÊø
	else
		PetBankMain_FakeObject:RotateEnd();
	end
end

------------------------------------------------------------------------------------
----
--Ðý×ª äÊÞÄ£ÐÍ£¨ÏòÓÒ)
--
function PetBankMain_TurnRight(start)
	--ÏòÓÒÐý×ª¿ªÊ¼
	if( start==1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetBankMain_FakeObject:RotateBegin(0.3);
	--ÏòÓÒÐý×ª½áÊø
	else
		PetBankMain_FakeObject:RotateEnd();
	end
end

--
--´ÓÊÞÀ¸µ½ÒøÐÐ²Ù×÷ ´ÓÒøÐÐµ½±³°ü²Ù×÷
function PetBankMain_Refuse_Click()
	if PETBANK_CURRENT_SELECT < 0 or PETBANK_CURRENT_SELECT >= PETBANK_MAX_COUNT then
		PushDebugMessage("Thïnh Tiên lña ch÷n Nh¤t Chích Trân Thú")
		return
	end
	
	if(IsWindowShow("TargetPet2")) then
	 	CloseWindow("TargetPet2", true);
	end		
	
	Pet:SavePetIntoBank_PetBank(PETBANK_CURRENT_SELECT,0); --?????
	PETBANK_CURRENT_SELECT = Pet :GetFirstPetPosInBank_PetBank();
	--°ÑÒøÐÐ±³°üÊý¾Ý¸üÐÂÁËµÄ²Ù×÷¸æËß äÊÞ±³°ülist
	Pet : PetBank_PetListSelectChange( tonumber(PETBANK_CURRENT_SELECT),0);
	
end

--
--
--²é¿´ äÊÞÏêÏ¸ÐÅÏ¢
function  PetBankMain_Choose_Click()
	if  -1<PETBANK_CURRENT_SELECT  and PETBANK_CURRENT_SELECT < PETBANK_MAX_COUNT then
		if(IsWindowShow("TargetPet")) then
			CloseWindow("TargetPet", true);
		-- return;
		end
		if(IsWindowShow("TargetPet2")) then
		   CloseWindow("TargetPet2", true);
		end
		Pet:ShowTargetPet_PetBank(tonumber(PETBANK_CURRENT_SELECT))
	end
end


--¹Ø±  äÊÞÒøÐÐ½çÃæ
function PetBankMain_Close_Click()
	 this:Hide()
	 if(IsWindowShow("PetBankList")) then
		CloseWindow("PetBankList", true);
		--return;
	 end
	 if(IsWindowShow("TargetPet")) then
			CloseWindow("TargetPet", true);
		--return;
	end
	
	if(IsWindowShow("TargetPet2")) then
			CloseWindow("TargetPet2", true);
	--	return;
	end
	
	 --È¡Ïû¹ØÐÄ
		this:CareObject(objCared, 0, "PetBankMain");
end



--listÑ¡ÖÐºóµÄ±ä»¯
function PetBankMain_List_Selected()
 local PETNUM = 0;
	PETNUM = PetBankMain_List :GetFirstSelectItem();
	local nPetCount = Pet : GetPet_Count_PetBank();
	if(PETNUM == PETBANK_CURRENT_SELECT) then
		return;
	end
	if(PETNUM < 0 and nPetCount > 0) then
		PETNUM = PETBANK_CURRENT_SELECT;
		return;
	end
	PETBANK_CURRENT_SELECT = PETNUM;
	local PetName ,TakeLevel,Level =Pet:GetPetList_Appoint_PetBank(PETBANK_CURRENT_SELECT);
	local strNeedLevelColor = "#c00FF00"

	 if(PetName~= "")then
	 	PetBankMain_UpdateType()
		PetBankMain_List : SetItemSelectByItemID(PETBANK_CURRENT_SELECT);
		PetBankMain_FakeObject : SetFakeObject( "" );
		Pet : SetModel_PetBank(PETNUM);
		PetBankMain_FakeObject : SetFakeObject( "My_PetBank" );
		--PetBankMain_NeedLevel:SetText(TakeLevel .."#{ZSYH_120503_47}") --Ð¯´øµÈ¼¶
		PetBankMain_NeedLevel:SetText(strNeedLevelColor..TakeLevel.."#{ZSYH_120503_47}") --ZSYH_120503_18  ???
		PetBankMain_Level:SetText("#{ZSYH_120503_48}"..Level)   --??
	end
	--	°ÑÒøÐÐ±³°üÊý¾Ý¸üÐÂÁËµÄ²Ù×÷¸æËß äÊÞ±³°ülist
	Pet : PetBank_PetListSelectChange( tonumber(PETBANK_CURRENT_SELECT),0);

end



--listÓÒ¼ü²é¿´
function PetBankMain_ShowTargetPet()
if  -1<PETBANK_CURRENT_SELECT  and PETBANK_CURRENT_SELECT < PETBANK_MAX_COUNT then
		if(IsWindowShow("TargetPet")) then
			CloseWindow("TargetPet", true);
		return ;
	end
	local	PETNUM = PetBankMain_List:GetFirstSelectItem();
	if(PETNUM == PETBANK_CURRENT_SELECT) then
		   if(IsWindowShow("TargetPet2")) then
			CloseWindow("TargetPet2", true);
		   end	
		   Pet:ShowTargetPet_PetBank(PETBANK_CURRENT_SELECT)
		   return;
	 end

	if(PETNUM < 0 and nPetCount > 0) then
		PETNUM = PETBANK_CURRENT_SELECT;
		return;
	end
	PETBANK_CURRENT_SELECT = PETNUM;
	if(IsWindowShow("TargetPet2")) then
	   CloseWindow("TargetPet2", true);
	end
	  Pet:ShowTargetPet_PetBank(PETBANK_CURRENT_SELECT)
	end
end



--´ò¿ª äÊÞÁÐ±í
function PetBankMain_OpenBagList_Click()

	if(IsWindowShow("PetBankList")) then
	  CloseWindow("PetBankList", true);
	   return;
	end
	OpenWindow( "PetBankList" );
end


function PetBank_StopWatch_TimeOut()
	--PetBankMain_Close_Click()
end

function PetBankMain_CloseUI()
	if(IsWindowShow("PetBankList")) then
	  CloseWindow("PetBankList", true);
	   return;
	end
end

function PetBankMain_UpdateType()
	if PETBANK_CURRENT_SELECT < 0 or PETBANK_CURRENT_SELECT >= PETBANK_MAX_COUNT then
		return
	end
	
	local nAI = Pet:GetAIType_PetBank(PETBANK_CURRENT_SELECT)
	if nAI ~= nil and nAI >= 0 and nAI <= 4 then
		local strAI =	PETBANK_AITYPE[nAI]
	 	PetBankMain_Type:SetText("#gFF8E92"..strAI)
		PetBankMain_Type:SetToolTip("#{INTERFACE_XML_857}")
	end
end

