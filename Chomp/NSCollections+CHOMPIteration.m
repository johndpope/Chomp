//
//  NSCollections+CHOMPIteration.m
//  Chomp
//
//  Created by Michael Ash on 12/16/04.
//

#import "NSCollections+CHOMPIteration.h"

#import "CHOMPEnumeratorTrampoline.h"
#import "CHOMPEnumeratorCollectTrampoline.h"


@implementation NSArray (CHOMPIteration)

- collect
{
	return [CHOMPEnumeratorCollectTrampoline trampolineWithSelector:@selector(iterateWithInvocation:) collection:self iterate:YES];
}

- do
{
	return [CHOMPEnumeratorTrampoline trampolineWithSelector:@selector(iterateWithInvocation:) collection:self iterate:YES];
}

- each
{
	return [self objectEnumerator];
}

@end

@implementation NSSet (CHOMPIteration)

- collect
{
	return [CHOMPEnumeratorCollectTrampoline trampolineWithSelector:@selector(iterateWithInvocation:) collection:self iterate:YES];
}

- do
{
	return [CHOMPEnumeratorTrampoline trampolineWithSelector:@selector(iterateWithInvocation:) collection:self iterate:YES];
}

- each
{
	return [self objectEnumerator];
}

@end

@implementation NSDictionary (CHOMPIteration)

- collect
{
	return [CHOMPEnumeratorCollectTrampoline trampolineWithSelector:@selector(iterateWithInvocation:) collection:self iterate:YES];
}

- do
{
	return [CHOMPEnumeratorTrampoline trampolineWithSelector:@selector(iterateWithInvocation:) collection:self iterate:YES];
}

- each
{
	return [self objectEnumerator];
}

@end

