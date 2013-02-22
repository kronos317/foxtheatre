//
//  CSMapAnnotation.m
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate,title,subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord {
	self = [super init];
	
	coordinate = coord;
	
	return self;
}

-(void) dealloc {
	[super dealloc];
	[title release];
	[subtitle release];
}

@end
