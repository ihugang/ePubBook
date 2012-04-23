//
//  NSString+Additions.m
//  LFQ Fundation
//
//  Created by yangxh on 11-3-29.
//  Copyright 2011 E0571. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

static char base64EncodingTable[64] = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
	'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
	'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
	'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (NSString_Additions)

+ (NSString *) base64StringFromData: (NSData *)data length: (int)length {
	unsigned long ixtext, lentext;
	long ctremaining;
	unsigned char input[3], output[4];
	short i, charsonline = 0, ctcopy;
	const unsigned char *raw;
	NSMutableString *result;
	
	lentext = [data length]; 
	if (lentext < 1)
		return @"";
	result = [NSMutableString stringWithCapacity: lentext];
	raw = [data bytes];
	ixtext = 0; 
	
	while (true) {
		ctremaining = lentext - ixtext;
		if (ctremaining <= 0) 
			break;        
		for (i = 0; i < 3; i++) { 
			unsigned long ix = ixtext + i;
			if (ix < lentext)
				input[i] = raw[ix];
			else
				input[i] = 0;
		}
		input[0] = (input[0] & 0xFC) >> 2;
		output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
		output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
		output[3] = input[2] & 0x3F;
		ctcopy = 4;
		switch (ctremaining) {
			case 1: 
				ctcopy = 2; 
				break;
			case 2: 
				ctcopy = 3; 
				break;
		}
		
		for (i = 0; i < ctcopy; i++)
			[result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
		
		for (i = ctcopy; i < 4; i++)
			[result appendString: @"="];
		
		ixtext += 3;
		charsonline += 4;
		
		if ((length > 0) && (charsonline >= length))
			charsonline = 0;
	}     
	return result;
}

- (NSString *) base64StringEncode
{
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	return [[self class] base64StringFromData:data length:[data length]];
}


+ (NSData *) base64DataFromString: (NSString *)string {
	unsigned long ixtext, lentext;
	unsigned char ch, input[4], output[3];
	short i, ixinput;
	Boolean flignore, flendtext = false;
	const char *temporary;
	NSMutableData *result;
	
	if (!string)
		return [NSData data];
	
	ixtext = 0;
	temporary = [string UTF8String];
	lentext = [string length];
	result = [NSMutableData dataWithCapacity: lentext];
	ixinput = 0;
	while (true) {
		if (ixtext >= lentext)
			break;
		ch = temporary[ixtext++];
		flignore = false;
		if ((ch >= 'A') && (ch <= 'Z'))
			ch = ch - 'A';
		else if ((ch >= 'a') && (ch <= 'z'))
			ch = ch - 'a' + 26;
		else if ((ch >= '0') && (ch <= '9'))
			ch = ch - '0' + 52;
		else if (ch == '+')
			ch = 62;
		else if (ch == '=')
			flendtext = true;
		else if (ch == '/')
			ch = 63;
		else
			flignore = true; 
		
		if (!flignore) {
			short ctcharsinput = 3;
			Boolean flbreak = false;
			
			if (flendtext) {
				if (ixinput == 0)
					break;                
				if ((ixinput == 1) || (ixinput == 2))
					ctcharsinput = 1;
				else
					ctcharsinput = 2;
                
				ixinput = 3;
				flbreak = true;
			}
            
			input[ixinput++] = ch;
            
			if (ixinput == 4)
				ixinput = 0;
            
			output[0] = (input[0] << 2) | ((input[1] & 0x30) >> 4);
			output[1] = ((input[1] & 0x0F) << 4) | ((input[2] & 0x3C) >> 2);
			output[2] = ((input[2] & 0x03) << 6) | (input[3] & 0x3F);
            
			for (i = 0; i < ctcharsinput; i++)
				[result appendBytes: &output[i] length: 1];
			
			if (flbreak)
				break;
		}
	}	
	return result;
}

- (NSString *) base64StringDecode
{
	NSData *data = [[self class] base64DataFromString:self];
	NSString *ret = [NSString stringWithUTF8String:[data bytes]];
	return ret;
}

- (NSString *) fileName
{
	NSMutableString *mString = [self mutableCopy];
	 [mString replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[mString length]}];  
	NSString* s = [ NSString stringWithString: [ mString autorelease ]]; 
	return s;
	
}

#pragma mark 获取随即uuid
+ (NSString*) stringWithUUID
{
	CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
	NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return [[uuidString autorelease] lowercaseString];
}

- (BOOL)isContainsString:(NSString *)searchKey
{
	NSRange range = [self rangeOfString:searchKey];
	return range.location != NSNotFound;
}

- (BOOL)isNotContainsString:(NSString *)searchKey
{
	return ![self isContainsString:searchKey];
}

- (BOOL)hasSubstring:(NSString *)substring {
	return [self isContainsString:substring];
}

- (NSString *)after:(NSString *)substring {
	NSRange r = [self rangeOfString:substring];
	if (r.location == NSNotFound)
		return @"";
	else
		return [self substringFromIndex:r.location + r.length];
}

// MD5
- (NSString *)MD5
{
	const char *cStr = [self UTF8String];
	
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1],
			result[2], result[3],
			result[4], result[5],
			result[6], result[7],
			result[8], result[9],
			result[10], result[11],
			result[12], result[13],
			result[14], result[15]
			];
}

+ (NSString *)urlWithArgs:(NSString *)firstArg, ...
{

    NSMutableString *str = [NSMutableString string];
    va_list args;
    va_start(args, firstArg);
    for (NSString *arg = firstArg; arg != nil; arg = va_arg(args, NSString*)) 
    {
        [str appendFormat:@"%@/", arg];
    }
    va_end(args);
    
    if ( !str.length ) 
    {
        return nil;
    }
    
    // remove last /
    [str replaceCharactersInRange:NSMakeRange(str.length-1, 1) withString:@""];
    return str;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
