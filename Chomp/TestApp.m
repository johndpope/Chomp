//
//  main.m
//  Chomp
//
//  Created by Michael Ash on 12/16/04.
//

#import <Foundation/Foundation.h>
#import <Chomp/Chomp.h>


@implementation NSObject (blahblahblah)

- (void)printDescription
{
	NSLog(@"%@", [self description]);
}

@end


int main(int argc, char **argv)
{
	id pool = [NSAutoreleasePool new];
	
	NSArray *array = [NSArray arrayWithObjects:@"yo", @"hi", @"twee", nil];
	[[array do] printDescription];
	
	NSMutableArray *mutArray = [NSMutableArray array];
	[[mutArray doSelf] addObject:[array each]];
	[[mutArray do] printDescription];
	
	id array2 = [[array collect] stringByAppendingString:@" suffix!"];
	[[array2 do] printDescription];
	
	id array3 = [[NSMutableString collectSelf] stringWithString:[array each]];
	[[array3 do] appendString:@" mutable suffix!"];
	[[array3 do] printDescription];
	
	[pool release];
	
	return 0;
}