//
//  SPCalendarView.m
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/29/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPCalendarView.h"

#define CONTROLS_WIDTH 320 / 7.0f

@implementation SPCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 42.5f, self.frame.size.width, 0.5f)];
        firstLineView.backgroundColor = [UIColor colorWithWhite:238.0f / 255.0f alpha:1.0f];
        [self addSubview:firstLineView];
        
        UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 78.5f, self.frame.size.width, 0.5f)];
        secondLineView.backgroundColor = [UIColor colorWithWhite:238.0f / 255.0f alpha:1.0f];
        [self addSubview:secondLineView];
        
        UIButton *previousMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        previousMonthButton.frame = CGRectMake(0.0f, 0.0f, CONTROLS_WIDTH, 42.5f);
        [previousMonthButton setTitleColor:[UIColor colorWithRed:99 / 255.0f green:87 / 255.0f blue:207 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [previousMonthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [previousMonthButton setTitle:@"<" forState:UIControlStateNormal];
        [self addSubview:previousMonthButton];
        
        UIButton *nextMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextMonthButton.frame = CGRectMake(self.frame.size.width - CONTROLS_WIDTH, 0.0f, CONTROLS_WIDTH, 42.5f);
        [nextMonthButton setTitleColor:[UIColor colorWithRed:99 / 255.0f green:87 / 255.0f blue:207 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [nextMonthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [nextMonthButton setTitle:@">" forState:UIControlStateNormal];
        [self addSubview:nextMonthButton];
    }
    
    return self;
}

@end
