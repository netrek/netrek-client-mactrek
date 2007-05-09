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
		
		// enable the buttons
		[updateAllButton setEnabled:YES];
		[resetButton setEnabled:YES];
	} else if ([selectedLabel isEqualToString:@"CLOSE"]) {
		// close UDP channel
		
		// disanable the buttons
		[updateAllButton setEnabled:NO];
		[resetButton setEnabled:NO];
	} else {
		// oh oh 
	}

}

- (void)sequenceChecking:(NSSegmentedControl*)sender {
	
	NSString *selectedLabel = [sender labelForSegment: [sender selectedSegment]];
	
	if ([selectedLabel isEqualToString:@"ON"]) {
		// activate sequence checking
	} else if ([selectedLabel isEqualToString:@"OFF"]) {
		// de-activate sequence checking
	} else {
		// oh oh 
	}
	
}

- (void)sendModeChanged:(NSComboBox*)sender {
	
	NSString *selectedLabel = [[sender selectedCell] stringValue];
	
	if ([selectedLabel isEqualToString:@"ON"]) {
		// activate sequence checking
	} else if ([selectedLabel isEqualToString:@"OFF"]) {
		// de-activate sequence checking
	} else {
		// oh oh 
	}	
}

- (void)receiveModeChanged:(NSComboBox*)sender {
	
	NSString *selectedLabel = [[sender selectedCell] stringValue];
	
	if ([selectedLabel isEqualToString:@"ON"]) {
		// activate sequence checking
	} else if ([selectedLabel isEqualToString:@"OFF"]) {
		// de-activate sequence checking
	} else {
		// oh oh 
	}	
}

- (IBAction)resetToTcp:(id)sender {

}

- (IBAction)updateAll:(id)sender {
	
}

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
 
	public void actionPerformed(ActionEvent e) {
		switch(e.getID()) {
			case 0:
				if(comm.getCommMode() == PacketTypes.COMM_TCP) {
					comm.sendUdpReq(PacketTypes.COMM_UDP);
				}
				else {
					comm.sendUdpReq(PacketTypes.COMM_TCP);
				}
				break;
			case 3:
				Defaults.udp_sequence_check = ((ChoiceMenuItem)menu_items[3]).getSelectedIndex() == 0;
				break;
			case 4:
				Defaults.udp_client_send = ((ChoiceMenuItem)menu_items[4]).getSelectedIndex();
				break;
			case 5:
				Defaults.udp_client_recv = ((ChoiceMenuItem)menu_items[5]).getSelectedIndex();
				comm.sendUdpReq((byte)(PacketTypes.COMM_MODE + Defaults.udp_client_recv));
				break;
			case 6:
				// clobber UDP
				comm.forceResetToTCP();
				refresh();
				break;
			case 7:
				comm.sendUdpReq(PacketTypes.COMM_UPDATE);
				break;
			case 8:
				setVisible(false);
				break;
		}
	}
*/ 

@end
