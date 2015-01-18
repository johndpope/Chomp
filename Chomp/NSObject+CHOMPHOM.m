//
//  NSObject+CHOMPHOM.m
//  Chomp
//
//  Created by Michael Ash on 12/16/04.
//

#import "NSObject+CHOMPHOM.h"

#import "CHOMPSimpleTrampoline.h"


@implementation NSObject (CHOMPHOM)

- performAfterDelay:(NSTimeInterval)delay
{
	return [CHOMPSimpleTrampoline trampolineWithTarget:self performAfterDelay:delay];
}

- ignoreExceptions
{
	return [CHOMPSimpleTrampoline trampolineWithSelector:@selector(ignoreExceptionsWithInvocation:) target:self];
}

@end
