//
//  CSMapAnnotation.h
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	NSString*              title;
	NSString*			   subtitle;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *subtitle;

@end
