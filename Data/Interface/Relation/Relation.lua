
local Relation_NpcInfo1 ={
						 	{id=1,name="TiÍu Phong",index=99,head="set:CommonNPCHeader12 image:CommonNPCHeader12_2"},
							{id=2,name="–o‡n DÒ",index=95,head="set:CommonNPCHeader12 image:CommonNPCHeader12_3"},
							{id=3,name="Hﬂ Tr˙c",index=102,head="set:CommonNPCHeader12 image:CommonNPCHeader12_1"},
						}
local Relation_NpcInfo2 ={
						 	{id=1,name="Mµc Uy¨n Thanh",index=92,head="set:CommonNPCHeader12 image:CommonNPCHeader12_9"},
							{id=2,name="Chung Linh",index=93,head="set:CommonNPCHeader12 image:CommonNPCHeader12_13"},
							{id=3,name="A Ch‚u",index=96,head="set:CommonNPCHeader12 image:CommonNPCHeader12_11"},
							{id=4,name="VﬂΩng NgÊ YÍn",index=98,head="set:CommonNPCHeader12 image:CommonNPCHeader12_8"},
							{id=5,name="A BÌch",index=97,head="set:CommonNPCHeader12 image:CommonNPCHeader12_12"},
							{id=6,name="A Tÿ",index=100,head="set:CommonNPCHeader12 image:CommonNPCHeader12_10"},
							{id=7,name="Ng‚n XuyÍn CÙng Ch˙a",index=104,head="set:CommonNPCHeader12 image:CommonNPCHeader12_7"},
						}
local Relation_NpcInfo3 ={
						 	{id=1,name="–o‡n DiÍn Kh·nh",index=94,head="set:CommonNPCHeader12 image:CommonNPCHeader12_4"},
							{id=2,name="Cﬂu Ma TrÌ",index=103,head="set:CommonNPCHeader12 image:CommonNPCHeader12_6"},
							{id=3,name="Mµ Dung Ph¯c",index=101,head="set:CommonNPCHeader12 image:CommonNPCHeader12_5"},
						}

local Relation_NpcInfoNumber = { 3, 7, 3, };
local Relation_CurrentPage = 0;
local Relation_NumPerPage = 4;
local Relation_CurType = 0;
local RELATION_NPC_BACK = {};
local RELATION_NPC_NAME = {};
local RELATION_NPC_HEAD = {};
local RELATION_NPC_CURRENT = {};
local RELATION_NPC_PROGRESS1 = {};
local RELATION_NPC_PROGRESS2 = {};
local RELATION_NPC_PROGRESS3 = {};

-- ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
local g_Relation_Frame_UnifiedXPosition;
local g_Relation_Frame_UnifiedYPosition;

--===============================================
-- PreLoad
--===============================================
function Relation_PreLoad()
	this:RegisterEvent("CHANGE_SWEAR_TITLE");
	this:RegisterEvent("OPEN_WINDOW");
	
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")

	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

--===============================================
-- OnLoad
--===============================================
function Relation_OnLoad()
	RELATION_NPC_BACK[1]= Relation_NPC1_Back;
	RELATION_NPC_BACK[2]= Relation_NPC2_Back;
	RELATION_NPC_BACK[3]= Relation_NPC3_Back;
	RELATION_NPC_BACK[4]= Relation_NPC4_Back;

	RELATION_NPC_NAME[1]= Relation_NPC1_Name;
	RELATION_NPC_NAME[2]= Relation_NPC2_Name;
	RELATION_NPC_NAME[3]= Relation_NPC3_Name;
	RELATION_NPC_NAME[4]= Relation_NPC4_Name;

	RELATION_NPC_HEAD[1]= Relation_Head1;
	RELATION_NPC_HEAD[2]= Relation_Head2;
	RELATION_NPC_HEAD[3]= Relation_Head3;
	RELATION_NPC_HEAD[4]= Relation_Head4;

	RELATION_NPC_CURRENT[1]= Relation_NPC1_Current;
	RELATION_NPC_CURRENT[2]= Relation_NPC2_Current;
	RELATION_NPC_CURRENT[3]= Relation_NPC3_Current;
	RELATION_NPC_CURRENT[4]= Relation_NPC4_Current;
	
	RELATION_NPC_PROGRESS1[1]= Relation_NPC1_Pic1;
	RELATION_NPC_PROGRESS1[2]= Relation_NPC2_Pic1;
	RELATION_NPC_PROGRESS1[3]= Relation_NPC3_Pic1;
	RELATION_NPC_PROGRESS1[4]= Relation_NPC4_Pic1;

	RELATION_NPC_PROGRESS2[1]= Relation_NPC1_Pic2;
	RELATION_NPC_PROGRESS2[2]= Relation_NPC2_Pic2;
	RELATION_NPC_PROGRESS2[3]= Relation_NPC3_Pic2;
	RELATION_NPC_PROGRESS2[4]= Relation_NPC4_Pic2;

	RELATION_NPC_PROGRESS3[1]= Relation_NPC1_Pic3;
	RELATION_NPC_PROGRESS3[2]= Relation_NPC2_Pic3;
	RELATION_NPC_PROGRESS3[3]= Relation_NPC3_Pic3;
	RELATION_NPC_PROGRESS3[4]= Relation_NPC4_Pic3;

	-- ±£¥ÊΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
	g_Relation_Frame_UnifiedXPosition	= Relation_Frame : GetProperty("UnifiedXPosition");
	g_Relation_Frame_UnifiedYPosition	= Relation_Frame : GetProperty("UnifiedYPosition");

end

--===============================================
-- OnEvent
--===============================================
function Relation_OnEvent(event)

	if( event =="OPEN_WINDOW" ) then
		AxTrace( 0,0, "OPEN_WINDOW   "..arg0 )	
		if( arg0 == "Relation" ) then
			--AxTrace( 0,0, "Reputation_Update   " );
			Relation_Update();
			this:Show();
		end
	end

	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	if (event == "ADJEST_UI_POS" ) then
		-- ∏¸–¬±≥∞¸ΩÁ√ÊŒª÷√
		Relation_Frame_On_ResetPos()

	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ∏¸–¬±≥∞¸ΩÁ√ÊŒª÷√	
		Relation_Frame_On_ResetPos()
	end

end

function Relation_Update()
	
	AxTrace( 1, 0, "page ="..tostring( Relation_CurType ) );
	local CurrentNpcInfo;
	if( tonumber( Relation_CurType ) == 0 ) then
		CurrentNpcInfo = Relation_NpcInfo1;
	elseif( tonumber( Relation_CurType ) == 1 ) then
		CurrentNpcInfo = Relation_NpcInfo2;
	else
		CurrentNpcInfo = Relation_NpcInfo3;
	end
	
	local maxNumber = tonumber( Relation_NpcInfoNumber[ Relation_CurType + 1 ] );
	
	if( tonumber( Relation_CurrentPage * Relation_NumPerPage ) >= tonumber( maxNumber ) ) then
		Relation_CurrentPage = Relation_CurrentPage - 1;
	end
	for i = 1, Relation_NumPerPage do
		RELATION_NPC_BACK[i]:Hide();
	end
	
	local curPageNumber = maxNumber - Relation_CurrentPage * Relation_NumPerPage;
	local curIndex;
	if( curPageNumber > Relation_NumPerPage ) then
		curPageNumber = Relation_NumPerPage;
		Relation_UPdata2:Enable();
	else
		Relation_UPdata2:Disable();
	end
	if( Relation_CurrentPage > 0 ) then
		Relation_UPdata1:Enable();
	else
		Relation_UPdata1:Disable();
	end
		
	for i = 1, curPageNumber do
		RELATION_NPC_BACK[ i ]:Show();
		curIndex = Relation_CurrentPage * Relation_NumPerPage + i;
		AxTrace( 1, 0, "curIndex ="..tostring( curIndex ) );
		nRelationPoint = DataPool:GetPlayerMission_DataRound(CurrentNpcInfo[ curIndex ].index);
--…Ë÷√»ŒŒÒ√˚◊÷		
		RELATION_NPC_NAME[i]:SetText( CurrentNpcInfo[ curIndex ].name );
--†‚¿Ô…Ë÷√»ŒŒÒÕ∑œÒ
		RELATION_NPC_HEAD[i]:SetProperty("Image",CurrentNpcInfo[ curIndex ].head);
		RELATION_NPC_PROGRESS1[ i ]:Hide();
		RELATION_NPC_PROGRESS2[ i ]:Hide();
		RELATION_NPC_PROGRESS3[ i ]:Hide();
		if nRelationPoint<=999  then
			RELATION_NPC_CURRENT[i]:SetText( "SΩ giao (" .. tostring(nRelationPoint) .. "/999)" );
			RELATION_NPC_PROGRESS1[i]:Show();
			RELATION_NPC_PROGRESS1[i]:SetProgress( nRelationPoint,999 );
		elseif nRelationPoint<=1999  then
			RELATION_NPC_CURRENT[i]:SetText( "Qu‚n tÿ Chi Giao(" .. tostring(nRelationPoint) .. "/1999)" );
			RELATION_NPC_PROGRESS2[i]:Show();
			RELATION_NPC_PROGRESS2[i]:SetProgress( (nRelationPoint - 999 ) , 1000 );
		elseif nRelationPoint<=3999  then
			RELATION_NPC_CURRENT[i]:SetText( "Tri k÷ (" .. tostring(nRelationPoint) .. "/3999)" );
			RELATION_NPC_PROGRESS3[i]:Show();
			RELATION_NPC_PROGRESS3[i]:SetProgress( (nRelationPoint - 1999 ) , 2000 );
		elseif nRelationPoint<=6499  then
			RELATION_NPC_CURRENT[i]:SetText( "Anh em k™t nghÓa(" .. tostring(nRelationPoint) .. "/6499)" );
			RELATION_NPC_PROGRESS3[i]:Show();
			RELATION_NPC_PROGRESS3[i]:SetProgress( (nRelationPoint - 3999 ) , 2500 );
		elseif nRelationPoint<=9999  then
			RELATION_NPC_CURRENT[i]:SetText( "Sinh tÿ (" .. tostring(nRelationPoint) .. "/9999)" );
			RELATION_NPC_PROGRESS3[i]:Show();
			RELATION_NPC_PROGRESS3[i]:SetProgress( (nRelationPoint - 6499 ) , 3500 );
		end
		
	end
end

function Relation_PageUp()
	Relation_CurrentPage = Relation_CurrentPage - 1;
	if( Relation_CurrentPage < 0 ) then
		Relation_CurrentPage = 0;
	end
	Relation_Update();
end

function Relation_PageDown()
	Relation_CurrentPage = Relation_CurrentPage + 1;
	Relation_Update();
end

function Relation_OnPageClick( index )
	Relation_CurType = index;
	Relation_CurrentPage = 0;
	Relation_Update();
end

--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function Relation_Frame_On_ResetPos()

	Relation_Frame : SetProperty("UnifiedXPosition", g_Relation_Frame_UnifiedXPosition);
	Relation_Frame : SetProperty("UnifiedYPosition", g_Relation_Frame_UnifiedYPosition);

end
