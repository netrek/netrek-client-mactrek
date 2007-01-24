//
//  GuiManager.h
//  MacTrek
//
//  Created by Aqua on 27/05/2006.
//  Copyright 2006 Luky Soft. See Licence.txt for licence details.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "Gui.h"
#import "ClientController.h"
#import "BaseClass.h"
#import "OutfitMenuController.h"
#import "GameController.h"
#import "SoundPlayer.h"
#import "SoundPlayerForNetrek.h"
#import "SoundPlayerForMacTrek.h"
#import "SoundPlayerForTac.h"
#import "PainterFactoryForNetrek.h"
#import "PainterFactoryForMacTrek.h"
#import "PainterFactoryForTac.h"
#import "ServerControllerNew.h"
#import "GameView.h"

// wait for:
//  PF_IMAGES_CACHED (3xgal + 1xmap) 
//  SP_SOUNDS_CACHED (3x)
#define NR_OF_EVENTS_BEFORE_SHOWING_MENU 7

enum GAME_STATE {
    GS_NO_SERVER_SELECTED=0,
    GS_SERVER_SELECTED=1,
    GS_SERVER_CONNECTED=2,
    GS_SERVER_SLOT_FOUND=3,
    GS_LOGIN_ACCEPTED=4,
    GS_OUTFIT_ACCEPTED=7,
    GS_GAME_ACTIVE=8,
    GS_MAX_STATE=9
};

@interface GuiManager : BaseClass {
    
    IBOutlet MenuController         *menuCntrl;
    IBOutlet SettingsController     *settingsCntrl;
    IBOutlet SelectServerController *selectServerCntrl;
    IBOutlet LocalServerController  *localServerCntrl;
    IBOutlet LoginController        *loginCntrl;
    IBOutlet OutfitMenuController   *outfitCntrl;
    IBOutlet GameController         *gameCntrl;
    IBOutlet NSWindow               *mainWindow;
    IBOutlet NSLevelIndicator       *startUpProgress;
    IBOutlet QCView                 *splashView;
    IBOutlet NSButton               *menuButton;
	IBOutlet NSPanel			    *keyMapPanel;
	IBOutlet NSTextView             *keyMapList;
    //IBOutlet DemoClientController   *jtrekCntrl;
	IBOutlet NSTextField            *versionString;
    
    ClientController                *client;
    enum GAME_STATE                 gameState;
    
    // theming
    SoundPlayer                     *soundPlayerTheme1;
    SoundPlayer                     *soundPlayerTheme2;
    SoundPlayer                     *soundPlayerTheme3;
    PainterFactory                  *painterTheme1;
    PainterFactory                  *painterTheme2;
    PainterFactory                  *painterTheme3;
    
    SoundPlayer                     *soundPlayerActiveTheme;
    PainterFactory                  *painterActiveTheme;
    int                             activeTheme;
	
	ServerControllerNew				*server;

	bool multiThreaded; 
	MetaServerEntry *currentServer;
	NSTimer *timer;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;
- (void) serverDeSelected;
- (void) serverConnected;
- (void) gameEntered;
- (void) loginComplete;
- (void) setTheme;
- (void) showKeyMapPanel;
- (void) fillKeyMapPanel;
- (void)setSyncScreenUpdateWithRead:(bool)enable;

@end
