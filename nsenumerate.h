/****************************************************************************************
	nsenumerate.h $Revision: 1.0 $
	
	Copyright (c) 2003 Red Shed Software. All rights reserved.
	by Jonathan 'Wolf' Rentzsch (jon at redshed dot net)
	
	Wed Oct 8 2003 wolf: Created.
	
	************************************************************************************/

#import <Foundation/Foundation.h>

#define nsenumerate_getEnumerator( TYPE, OBJ )				\
	(TYPE)([OBJ isKindOfClass:[NSEnumerator class]]			\
	? OBJ													\
	: [OBJ performSelector:@selector(objectEnumerator)])

#define	nsenumerate( CONTAINER, ITERATOR_TYPE, ITERATOR_SYMBOL )			\
for( ITERATOR_TYPE															\
	 *enumerator = nsenumerate_getEnumerator(ITERATOR_TYPE*, CONTAINER),	\
	 *ITERATOR_SYMBOL = [((NSEnumerator*) enumerator) nextObject];			\
	 ITERATOR_SYMBOL != nil;												\
	 ITERATOR_SYMBOL = [((NSEnumerator*) enumerator) nextObject] )

#define	nsenumerat( CONTAINER, ITERATOR_SYMBOL )					\
for( id																\
	 enumerator = nsenumerate_getEnumerator(id, CONTAINER),			\
	 ITERATOR_SYMBOL = [((NSEnumerator*) enumerator) nextObject];	\
	 ITERATOR_SYMBOL != nil;										\
	 ITERATOR_SYMBOL = [((NSEnumerator*) enumerator) nextObject] )
