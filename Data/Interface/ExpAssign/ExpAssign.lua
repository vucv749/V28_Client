local	gOpType						= 0; --????
local	gExp							= 0; --????
local	gAssExp						= 0; --?????????
local	gGBValue					= 0; --?????
local	gAssGBValue				= 0; --????????
local	gGPValue					= 0; --???????
local	gAssGPValue				= 0; --??????????
local	gMasterLevel			= 0; --????
local	gBasePoint				= 0;
local	objCared					= -1;
local	MAX_OBJ_DISTANCE	= 3.0;

--===============================================
-- OnLoad()
--===============================================
function ExpAssign_PreLoad()
	this:RegisterEvent("OPEN_EXP_ASSIGN");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UI_COMMAND");
end

function ExpAssign_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function ExpAssign_OnEvent(event)
	if( event == "OPEN_EXP_ASSIGN" )then
		ExpAssign_Update();
		this:Show();
		objCared = DataPool:GetCurDialogNpcId();
		if objCared == -1 then
				PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
				return;
		end
		this:CareObject(objCared, 1, "ExpAssign");
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "ExpAssign");
			this:Hide();
			objCared = -1
		end
	end
end

function ExpAssign_Update()

	AxTrace(0,0,tostring(arg0));
	local	str0, str1
	_, _, gExp, gGBValue, gGPValue, gMasterLevel, gOpType	= string.find( arg0, "(%d+),(%d+),(%d+),(%d+),(%d+)" );
	gExp					= tonumber( gExp )
	gGBValue			= tonumber( gGBValue )
	gGPValue			= tonumber( gGPValue )
	gMasterLevel	= tonumber( gMasterLevel )
	gOpType				= tonumber( gOpType )

	AxTrace(0,0,"gExp="..tostring(gExp));
	AxTrace(0,0,"gGBValue="..tostring(gGBValue));
	AxTrace(0,0,"gGPValue="..tostring(gGPValue));
	AxTrace(0,0,"gMasterLevel="..tostring(gMasterLevel));
	AxTrace(0,0,"gOpType="..tostring(gOpType));
	
	--ÉÆ¶ñÖµ¶Ò»»
	if gOpType == 1 then
		ExpAssign_Info2:SetText("M²i l¥n l¾n nh¤t Nång ð±i Ðích thi®n ác Tr¸ Vi 5000Ði¬m.");
		if gMasterLevel == 1 then
			gBasePoint = 30; 		--1?????
		elseif gMasterLevel == 2 then
			gBasePoint = 35;		--2?????
		elseif gMasterLevel == 3 then
			gBasePoint = 50;		--3?????
		elseif gMasterLevel == 4 then
			gBasePoint = 70;		--4?????
		end
		
		if(gBasePoint ==0)then
			gAssGBValue = 0;
			gAssExp = 0;
		else
			if(gGBValue * gBasePoint>gExp)then
				--Íæ¼ÒÉÆ¶ñµã*a´óÓÚ¿É¶Ò»»¾­Ñé
				if(gExp >5000 * gBasePoint)then
					gAssGBValue = 5000;
					gAssExp = 5000 * gBasePoint;	
				else
					gAssGBValue = math.ceil( gExp / gBasePoint )	
					gAssExp = gExp;
				end
			else
				if(gGBValue>5000)then
					gAssGBValue = 5000;
					gAssExp = 5000 * gBasePoint;	
				else
					gAssGBValue = gGBValue;
					gAssExp = gGBValue*gBasePoint;
				end
			end
		end
		str0	= "Nhçm hi®n tÕi có th¬ l¤y ra Ðích kinh nghi®m Vi"..tostring( gExp )..", Nhçm có ðßþc Ðích thi®n ác Tr¸ Vi"..tostring( gGBValue )
		str1	= "C¥n thi®n ác Ði¬m: 0"

	--°ïÅÉ¹±Ï×¶È¶Ò»»
	elseif gOpType == 2 then
		ExpAssign_Info2:SetText("M²i ngày Døng Bang C¯ng nhi«u nh¤t Khä lînh Ðích kinh nghi®m Vi 12M£c Ði¬m.");
		if gMasterLevel == 1 then
			gBasePoint = 250;		--1?????
		elseif gMasterLevel == 2 then
			gBasePoint = 300;		--2?????
		elseif gMasterLevel == 3 then
			gBasePoint = 400;		--3?????
		elseif gMasterLevel == 4 then
			gBasePoint = 600;		--4?????
		end
		gAssGPValue		= gGPValue
		gAssExp				= gGPValue * gBasePoint
		if gAssExp > gExp and gBasePoint ~= 0 then
			gAssExp			= gExp
			gAssGBValue	= math.ceil( gAssExp / gBasePoint )
		end
		str0	= "Nhçm hi®n tÕi có th¬ l¤y ra Ðích kinh nghi®m Vi"..tostring( gExp )..", Nhçm có ðßþc Ðích bang phái c¯ng hiªn Ðµ Vi"..tostring( gGPValue )
		str1	= "C¥n bang phái c¯ng hiªn Ðµ: 0"

	else
		return
	end

	ExpAssign_Cur_Info:SetText( str0 )
	ExpAssign_Moral_Need:SetText( str1 );
	--ÎÄ±¾ÊäÈë¿ò
	ExpAssign_Moral_Value:SetText( "0" );

end

function ExpAssign_Button_Max_Click()

	AxTrace(0,0,"gBasePoint="..tostring(gBasePoint));
	if gBasePoint == 0 then
		return
	end
	
	local	str
	--ÉÆ¶ñÖµ¶Ò»»
	if gOpType == 1 then
		str	= "C¥n thi®n ác Ði¬m:"..tostring(gAssGBValue)
	--°ïÅÉ¹±Ï×¶È¶Ò»»
	elseif gOpType == 2 then
		str	= "C¥n bang phái c¯ng hiªn Ðµ:"..tostring(gAssGPValue)
	else
		return
	end
	ExpAssign_Moral_Need:SetText( str );
	--ÎÄ±¾ÊäÈë¿ò
	ExpAssign_Moral_Value:SetText( tostring(gAssExp) );

end

function ExpAssign_Value_Change()

	if gBasePoint == 0 then
		return
	end
	
	local nCurExp
	local	str
	nCurExp		= tonumber( ExpAssign_Moral_Value:GetText() );
	if nCurExp == nil then
		nCurExp	= 0
	end
	if nCurExp > gAssExp then
		nCurExp	= gAssExp
		ExpAssign_Moral_Value:SetText( nCurExp );
	end
	--ÉÆ¶ñÖµ¶Ò»»
	if gOpType == 1 then
		str	= "C¥n thi®n ác Ði¬m:"..tostring( math.ceil( nCurExp / gBasePoint ) )
	--°ïÅÉ¹±Ï×¶È¶Ò»»
	elseif gOpType == 2 then
		str	= "C¥n bang phái c¯ng hiªn Ðµ:"..tostring( math.ceil( nCurExp / gBasePoint ) )
	else
		return
	end
	ExpAssign_Moral_Need:SetText( str );

end

function ExpAssign_Button_Get_Click()
	local nCurExp = tonumber( ExpAssign_Moral_Value:GetText() );
	if nCurExp == nil then
		nCurExp = 0
	end
	if nCurExp > 0 then
		Player:SetExpAssgin( nCurExp, gOpType );
	end
	
	this:Hide();
end

function ExpAssign_Button_Close_Click()
	this:Hide();
end
