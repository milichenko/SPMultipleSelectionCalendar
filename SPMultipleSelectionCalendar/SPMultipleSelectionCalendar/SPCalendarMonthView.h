//
//  SPCalendarMonthView.h
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/30/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CONTROLS_WIDTH 320.0f / 7.0f

@interface SPCalendarMonthView : UIView

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date;

@end
