///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Control types and styles
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_HITZONES         17
#define CT_CONTROLS_TABLE   19
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_MENU             46
#define CT_MENU_STRIP       47
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102
#define CT_ITEMSLOT         103
#define CT_CHECKBOX         77

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0
#define ST_UPPERCASE      0xC0
#define ST_LOWERCASE      0xD0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4
#define MB_ERROR_DIALOG   8

// Xbox buttons
#define KEY_XINPUT                0x00050000

#define KEY_XBOX_A                KEY_XINPUT + 0
#define KEY_XBOX_B                KEY_XINPUT + 1
#define KEY_XBOX_X                KEY_XINPUT + 2
#define KEY_XBOX_Y                KEY_XINPUT + 3
#define KEY_XBOX_Up               KEY_XINPUT + 4
#define KEY_XBOX_Down             KEY_XINPUT + 5
#define KEY_XBOX_Left             KEY_XINPUT + 6
#define KEY_XBOX_Right            KEY_XINPUT + 7
#define KEY_XBOX_Start            KEY_XINPUT + 8
#define KEY_XBOX_Back             KEY_XINPUT + 9
#define KEY_XBOX_LeftBumper       KEY_XINPUT + 10
#define KEY_XBOX_RightBumper      KEY_XINPUT + 11
#define KEY_XBOX_LeftTrigger      KEY_XINPUT + 12
#define KEY_XBOX_RightTrigger     KEY_XINPUT + 13
#define KEY_XBOX_LeftThumb        KEY_XINPUT + 14
#define KEY_XBOX_RightThumb       KEY_XINPUT + 15
#define KEY_XBOX_LeftThumbXRight  KEY_XINPUT + 16
#define KEY_XBOX_LeftThumbYUp     KEY_XINPUT + 17
#define KEY_XBOX_RightThumbXRight KEY_XINPUT + 18
#define KEY_XBOX_RightThumbYUp    KEY_XINPUT + 19
#define KEY_XBOX_LeftThumbXLeft   KEY_XINPUT + 20
#define KEY_XBOX_LeftThumbYDown   KEY_XINPUT + 21
#define KEY_XBOX_RightThumbXLeft  KEY_XINPUT + 22
#define KEY_XBOX_RightThumbYDown  KEY_XINPUT + 23

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Display IDDs and IDCs
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Predefined controls
#define IDC_OK            1
#define IDC_CANCEL        2
#define IDC_AUTOCANCEL    3
#define IDC_ABORT         4
#define IDC_RESTART       5
#define IDC_USER_BUTTON   6

//--- RscDisplayPhoneCallIncoming
#define IDC_RSCDISPLAYPHONECALLINCOMING_BACKGROUND	36825
#define IDC_RSCDISPLAYPHONECALLINCOMING_TITLE		36826
#define IDC_RSCDISPLAYPHONECALLINCOMING_NAME		36827
#define IDC_RSCDISPLAYPHONECALLINCOMING_LOGO		37025
#define IDC_RSCDISPLAYPHONECALLINCOMING_AVATAR		37026
#define IDC_RSCDISPLAYPHONECALLINCOMING_BACKGROUNDOK	37027
#define IDC_RSCDISPLAYPHONECALLINCOMING_BACKGROUNDCANCEL	37028
#define IDC_RSCDISPLAYPHONECALLINCOMING_ICONOK		37029
#define IDC_RSCDISPLAYPHONECALLINCOMING_ICONCANCEL	37030
#define IDC_RSCDISPLAYPHONECALLINCOMING_CALL		38125

//--- RscPhoneCall
#define IDC_RSCPHONECALL_BACKGROUND	7568
#define IDC_RSCPHONECALL_TITLE		7569
#define IDC_RSCPHONECALL_NAME		7570
#define IDC_RSCPHONECALL_TIMESTAMP	7571
#define IDC_RSCPHONECALL_LOGO		7768
#define IDC_RSCPHONECALL_AVATAR		7769
#define IDC_RSCPHONECALL_BACKGROUNDMUTE	7770
#define IDC_RSCPHONECALL_BACKGROUNDCANCEL	7771
#define IDC_RSCPHONECALL_ICONMUTE		7772
#define IDC_RSCPHONECALL_ICONCANCEL	7773
#define IDC_RSCPHONECALL_CALL		8868

//--- RscDisplayOrangeChoice
#define IDC_RSCDISPLAYORANGECHOICE_TITLE			24334
#define IDC_RSCDISPLAYORANGECHOICE_DESCRIPTIONBACKGROUND	24335
#define IDC_RSCDISPLAYORANGECHOICE_DESCRIPTION		24434
#define IDC_RSCDISPLAYORANGECHOICE_NATO			24534
#define IDC_RSCDISPLAYORANGECHOICE_FIA			24535
#define IDC_RSCDISPLAYORANGECHOICE_CSAT			24536
#define IDC_RSCDISPLAYORANGECHOICE_AAF			24537
#define IDC_RSCDISPLAYORANGECHOICE_NONE			24538
#define IDC_RSCDISPLAYORANGECHOICE_HOVER			24539
#define IDC_RSCDISPLAYORANGECHOICE_OPTIONS		25634
#define IDC_RSCDISPLAYORANGECHOICE_DESCRIPTIONGROUP	25635

//--- RscDisplayAANArticle
#define IDC_RSCDISPLAYAANARTICLE_BACKGROUNDTOP	19513
#define IDC_RSCDISPLAYAANARTICLE_BACKGROUNDMENU	19514
#define IDC_RSCDISPLAYAANARTICLE_BACKGROUNDSUBMENU	19515
#define IDC_RSCDISPLAYAANARTICLE_BACKGROUNDBOTTOM	19516
#define IDC_RSCDISPLAYAANARTICLE_BACKGROUNDMENUFOOTER	19517
#define IDC_RSCDISPLAYAANARTICLE_BACKGROUNDCOPYRIGHT	19518
#define IDC_RSCDISPLAYAANARTICLE_COPYRIGHT		19519
#define IDC_RSCDISPLAYAANARTICLE_MENU			19613
#define IDC_RSCDISPLAYAANARTICLE_SUBMENU		19614
#define IDC_RSCDISPLAYAANARTICLE_MENUFOOTER		19615
#define IDC_RSCDISPLAYAANARTICLE_WEBMENU		19616
#define IDC_RSCDISPLAYAANARTICLE_LOGOFOOTER		19713
#define IDC_RSCDISPLAYAANARTICLE_LOGO			19714
#define IDC_RSCDISPLAYAANARTICLE_GROUPMENU		20813
#define IDC_RSCDISPLAYAANARTICLE_GROUPBODY		20814
#define IDC_RSCDISPLAYAANARTICLE_GROUPFOOTER		20815
#define IDC_RSCDISPLAYAANARTICLE_GROUPCOPYRIGHT	20816
#define IDC_RSCDISPLAYAANARTICLE_BUTTONCLOSE		21213

#define IDC_RSCDISPLAYAANARTICLE_DISPLAY	12345

_mode = _this select 0;
_params = _this select 1;
_class = _this select 2;

switch _mode do {
	case "onLoad": {
		(missionnamespace getvariable ["RscPrigozhinCalls_data",[]]) params [
			["_name","",[""]],
			["_avatar","",[""]],
			["_ringtoneLength",0,[0]]
		];

		_display = _params select 0;
		_ctrlAvatar = _display displayctrl IDC_RSCPHONECALL_AVATAR;
		_ctrlName = _display displayctrl IDC_RSCPHONECALL_NAME;
		_ctrlTimestamp = _display displayctrl IDC_RSCPHONECALL_TIMESTAMP;

		_ctrlName ctrlsettext _name;
		_ctrlAvatar ctrlsettext _avatar;
		
		_ctrlTimestamp ctrlsettext "";
		
		[_ctrlTimestamp,_ringtoneLength] spawn {
			disableserialization;
			_ctrlTimestamp = _this select 0;
			_sleep = _this select 1;
			
			sleep _sleep;
			
			_callStart = time;
			
			while {!isnull _ctrlTimestamp} do {
				_ctrlTimestamp ctrlsettext (((time - _callStart) / 3600) call bis_fnc_timetostring);
				
			};
		};
	};
};