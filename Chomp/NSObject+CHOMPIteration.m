//
//  NSObject+CHOMPIteration.m
//  Chomp
//
//  Created by Michael Ash on 12/16/04.
//

#import "NSObject+CHOMPIteration.h"

#import "CHOMPEnumeratorTrampoline.h"
#import "CHOMPEnumeratorCollectTrampoline.h"


@implementation NSObject (CHOMPIteration)

- collectSelf
{
	return [CHOMPEnumeratorCollectTrampoline trampolineWithSelector:@selector(iterateWithInvocation:) collection:self iterate:NO];
}

- doSelf
{
	return [CHOMPEnumeratorTrampoline trampolineWithSelector:@selector(iterateWithInvocation:) collection:self iterate:NO];
}

@end
