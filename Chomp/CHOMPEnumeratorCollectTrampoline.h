//
//  CHOMPIterationCollectEnumerator.h
//  Chomp
//
//  Created by Michael Ash on 12/16/04.
//

#import <Foundation/Foundation.h>

#import "CHOMPEnumeratorTrampoline.h"


// this class customizes CHOMPEnumeratorTrampoline to implement the -collect HOM

@interface CHOMPEnumeratorCollectTrampoline : CHOMPEnumeratorTrampoline {
	id returnCollection;
}

@end
