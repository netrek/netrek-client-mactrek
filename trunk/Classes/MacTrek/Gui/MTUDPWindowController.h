/* MTUDPWindowController */

#import <Cocoa/Cocoa.h>
#import "BaseClass.h"
#import "PacketTypes.h"

@interface MTUDPWindowController : BaseClass {
	
    IBOutlet NSSegmentedControl *channelState;
    IBOutlet NSComboBox *receiveModeBox;
    IBOutlet NSButton *resetButton;
    IBOutlet NSComboBox *sendModeBox;
    IBOutlet NSSegmentedControl *sequenceChecking;
    IBOutlet NSTextField *statisticsField;
    IBOutlet NSTextField *statusField;
    IBOutlet NSPanel *udpPanel;
    IBOutlet NSButton *updateAllButton;
}
- (IBAction)resetToTcp:(id)sender;
- (IBAction)updateAll:(id)sender;

- (void)channelStateChanged:(NSSegmentedControl*)sender;
- (void)sequenceChecking:(NSSegmentedControl*)sender;
- (void)sendModeChanged:(NSComboBox*)sender;
- (void)receiveModeChanged:(NSComboBox*)sender;
- (void)refresh;

@end
