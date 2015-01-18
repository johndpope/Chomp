//
//  CHOMPSimpleTrampoline.m
//  Chomp
//
//  Created by Michael Ash on 12/16/04.
//

#import "CHOMPSimpleTrampoline.h"


@implementation CHOMPSimpleTrampoline

+ trampolineWithSelector:(SEL)sel target:obj userData:ud
{
	return [[[self alloc] initWithSelector:sel target:obj userData:ud] autorelease];
}

+ trampolineWithTarget:obj performAfterDelay:(NSTimeInterval)delay
{
	return [self trampolineWithSelector:@selector(performAfterDelayWithInvocation:)
								 target:obj
							   userData:[NSNumber numberWithDouble:delay]];
}

- initWithSelector:(SEL)sel target:obj userData:ud
{
	if((self = [super initWithSelector:sel target:obj]))
	{
		userData = [ud retain];
	}
	return self;
}

- (void)dealloc
{
	[userData release];
	[super dealloc];
}

- (void)performAfterDelayWithInvocation:(NSInvocation *)invocation
{
	// need to make it retain its args since we're going beyond the current pool's scope
	[invocation retainArguments];
	[invocation performSelector:@selector(invokeWithTarget:) withObject:target afterDelay:[userData doubleValue]];
	unsigned len = [[invocation methodSignature] methodReturnLength];
	if(len > 0)
	{
		void *retVal = calloc(1, len);
		[invocation setReturnValue:retVal];
		free(retVal);
	}
}

- (void)ignoreExceptionsWithInvocation:(NSInvocation *)invocation
{
	NS_DURING
		[invocation invokeWithTarget:target];
	NS_HANDLER
		unsigned len = [[invocation methodSignature] methodReturnLength];
		if(len > 0)
		{
			void *retVal = calloc(1, len);
			[invocation setReturnValue:retVal];
			free(retVal);
		}
	NS_ENDHANDLER
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
	return [target methodSignatureForSelector:sel];
}

@end
