//
//  CHOMPSingleObjectEnumerator.m
//  Chomp
//
//  Created by Michael Ash on 12/15/04.
//

#import "CHOMPSingleObjectEnumerator.h"


@implementation CHOMPSingleObjectEnumerator

+ enumeratorWithObject:obj repeat:(BOOL)yorn
{
	return [[[self alloc] initWithObject:obj repeat:yorn] autorelease];
}

- initWithObject:obj repeat:(BOOL)yorn
{
	if((self = [super init]))
	{
		object = obj;
		repeat = yorn;
	}
	return self;
}

- nextObject
{
	id temp = object;
	if(!repeat)
		object = nil; // only return the object once if it doesn't repeat
	return temp;
}

@end
