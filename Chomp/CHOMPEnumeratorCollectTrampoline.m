//
//  CHOMPIterationCollectEnumerator.m
//  Chomp
//
//  Created by Michael Ash on 12/16/04.
//

#import "CHOMPEnumeratorCollectTrampoline.h"


@implementation CHOMPEnumeratorCollectTrampoline

- (void)prepareWithInvocation:(NSInvocation *)invocation
{
	if([target isKindOfClass:[NSSet class]])
		returnCollection = [[NSMutableSet alloc] init];
	else
		returnCollection = [[NSMutableArray alloc] init];
}

- (void)processReturnValue:retVal
{
	if(!retVal)
		retVal = [NSNull null];
	[returnCollection addObject:retVal];
}

- getReturnValue
{
	return returnCollection;
}

- (void)finalizeWithInvocation:(NSInvocation *)invocation
{
	// autorelease because we're returning it and it can't disappear right away
	[returnCollection autorelease];
	returnCollection = nil;
}

- (void)dealloc
{
	[returnCollection release];
	[super dealloc];
}

@end
