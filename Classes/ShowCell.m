//
//  ShowCell.m
//  VenueConnect
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ShowCell.h"


@implementation ShowCell

@synthesize day,date,show,showtime,doorsLabel,doors;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
