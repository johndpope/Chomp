//
//  CHOMPTrampoline.m
//  Chomp
//
//  Created by Michael Ash on 12/15/04.
//

#import "CHOMPTrampoline.h"


@implementation CHOMPTrampoline

+ trampolineWithSelector:(SEL)sel target:obj
{
	return [[[self alloc] initWithSelector:sel target:obj] autorelease];
}

- initWithSelector:(SEL)sel target:obj
{
	selector = sel;
	target = obj;
	return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
	[self performSelector:selector withObject:invocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
	NSLog(@"ERROR: %@ must provide an implementation for %@", [self class], NSStringFromSelector(_cmd));
	return nil;
}

@end
