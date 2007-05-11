#import "MTUDPWindowController.h"

@implementation MTUDPWindowController

- (void)awakeFromNib {
    [channelState setTarget:self];
    [channelState setAction:@selector(channelStateChanged:)];
    [sequenceChecking setTarget:self];
    [sequenceChecking setAction:@selector(sequenceCheckingChanged:)];
	[sendModeBox setTarget:self];
	[sendModeBox setAction:@selector(sendModeChanged:)];
	[receiveModeBox setTarget:self];
	[receiveModeBox setAction:@selector(receiveModeChanged:)];
}

- (void)channelStateChanged:(NSSegmentedControl*)sender {
	
	NSString *selectedLabel = [sender labelForSegment: [sender selectedSegment]];
	
	if ([selectedLabel isEqualToString:@"OPEN"]) {
		// open UDP channel
		[notificationCenter postNotificationName:@"COMM_SEND_UDP_REQ" userInfo:[NSNumber numberWithChar:COMM_UDP]];
		// enable the buttons
		[updateAllButton setEnabled:YES];
		[resetButton setEnabled:YES];
	} else if ([selectedLabel isEqualToString:@"CLOSE"]) {
		// close UDP channel
		[notificationCenter postNotificationName:@"COMM_SEND_UDP_REQ" userInfo:[NSNumber numberWithChar:COMM_TCP]];
		// disanable the buttons
		[updateAllButton setEnabled:NO];
		[resetButton setEnabled:NO];
	} else {
		// oh oh
		LLLog(@"MTUDPWindowController.channelStateChanged illigal setting");
	}

}

- (void)sequenceChecking:(NSSegmentedControl*)sender {
	
	NSString *selectedLabel = [sender labelForSegment: [sender selectedSegment]];
	
	if ([selectedLabel isEqualToString:@"ON"]) {
		// activate sequence checking
		[notificationCenter postNotificationName:@"UC_UDP_SEQUENCE_CHECK" userInfo:[NSNumber numberWithBool:YES]];
	} else if ([selectedLabel isEqualToString:@"OFF"]) {
		// de-activate sequence checking
		[notificationCenter postNotificationName:@"UC_UDP_SEQUENCE_CHECK" userInfo:[NSNumber numberWithBool:NO]];
	} else {
		// oh oh 
		LLLog(@"MTUDPWindowController.sequenceChecking illigal setting");
	}
	
}

- (void)sendModeChanged:(NSComboBox*)sender {
	
	int choice = [sender indexOfSelectedItem];
	
	if ((choice < MODE_TCP) || (choice > MODE_DOUBLE)) {
		LLLog(@"MTUDPWindowController.sendModeChanged illigal setting");
	} else {
		[notificationCenter postNotificationName:@"UC_UDP_SEND_MODE" userInfo:[NSNumber numberWithChar:(choice & 0xFF)]];
	}

}

- (void)receiveModeChanged:(NSComboBox*)sender {
	
	int choice = [sender indexOfSelectedItem];
	
	if ((choice < MODE_TCP) || (choice > MODE_FAT)) {
		LLLog(@"MTUDPWindowController.sendModeChanged illigal setting");
	} else {
		[notificationCenter postNotificationName:@"UC_UDP_RECEIVE_MODE" userInfo:[NSNumber numberWithChar:(choice & 0xFF)]];
		[notificationCenter postNotificationName:@"COMM_SEND_UDP_REQ" userInfo:[NSNumber numberWithChar:COMM_MODE + (choice & 0xFF) ]];
	}
	
	
}

- (IBAction)resetToTcp:(id)sender {
	LLLog(@"MTUDPWindowController.resetToTcp called");
	[notificationCenter postNotificationName:@"COMM_FORCE_RESET_TO_TCP" userInfo:self];
	[self refresh];
}

- (IBAction)updateAll:(id)sender {
	LLLog(@"MTUDPWindowController.updateAll called");
	[notificationCenter postNotificationName:@"COMM_SEND_UDP_REQ" userInfo:[NSNumber numberWithChar:COMM_UPDATE]];
}


- (void)refresh {
	/*
	 public void refresh() {
		 String s = null;
		 switch(comm.getCommMode()) {
			 case PacketTypes.COMM_TCP:
				 s = "UDP Channel is CLOSED";
				 break;
			 case PacketTypes.COMM_UDP:
				 s = "UDP Channel is OPEN";
				 break;
		 }
		 ((ButtonMenuItem)menu_items[0]).setLabel(s);
		 s = "> Status: ";
		 switch(comm.getCommStatus()) {
			 case PacketTypes.STAT_CONNECTED:
				 s = s.concat("Connected, yay us!");
				 break;
			 case PacketTypes.STAT_SWITCH_UDP:
				 s = s.concat("Requesting switch to UDP");
				 break;
			 case PacketTypes.STAT_SWITCH_TCP:
				 s = s.concat("Requesting switch to TCP");
				 break;
			 case PacketTypes.STAT_VERIFY_UDP:
				 s = s.concat("Verifying UDP connection");
				 break;
			 default:
				 System.err.println("jtrek: UDP error: bad commStatus (" + comm.getCommStatus() + ')');
				 break;
		 }
		 ((ButtonMenuItem)menu_items[1]).setLabel(s);
		 
		 int dropped = comm.getUDPDropped();
		 int total = Math.max(comm.getUDPTotal(), 1);
		 int recent = comm.getUDPRecentDropped();
		 s = "> UDP trans dropped: " + dropped + " (" + (dropped * 100 / total) + "% | " + (recent * 100 / PacketTypes.UDP_RECENT_INTR) + "%)";
		 ((ButtonMenuItem)menu_items[2]).setLabel(s);
		 
		 ((ChoiceMenuItem)menu_items[3]).setSelectedIndex(Defaults.udp_sequence_check ? 0 : 1);
		 ((ChoiceMenuItem)menu_items[4]).setSelectedIndex(Defaults.udp_client_send);
		 ((ChoiceMenuItem)menu_items[5]).setSelectedIndex(Defaults.udp_client_recv);
		 
	 }
	 
	 */
}


@end
