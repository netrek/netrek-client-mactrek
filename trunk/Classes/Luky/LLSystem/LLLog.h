//
//  LLLog.h
//  MacTrek
//
//  Created by Chris & Judith Lukassen on 24/01/2007.
//  Copyright 2006 Luky Soft. LGPL Licence.
//

#import <Cocoa/Cocoa.h>

bool LLLogEnabled=YES;

#define LLLog(format, ...) if(LLLogEnabled) { NSLog(format, ## __VA_ARGS__); } 