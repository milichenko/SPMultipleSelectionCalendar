//
//  SPMonthViewController.h
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/31/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CONTROLS_WIDTH 320.0f / 7.0f

typedef NS_ENUM(NSUInteger, MonthAnimationDirection)
{
    MonthAnimationDirectionNone,
    MonthAnimationDirectionUp,
    MonthAnimationDirectionDown,
};

@class SPCalendarMonthViewController;

@protocol SPCalendarMonthViewControllerDelegate <NSObject>

@optional
- (void)calendarMonthViewControllerAnimationWillStart:(SPCalendarMonthViewController *)monthViewController;
- (void)calendarMonthViewControllerAnimationDidStop:(SPCalendarMonthViewController *)monthViewController;
- (void)calendarMonthViewController:(SPCalendarMonthViewController *)monthViewController needChangeMonthInDirection:(MonthAnimationDirection)animationDirection;
- (void)calendarMonthViewController:(SPCalendarMonthViewController *)monthViewController didChangeDateSelection:(NSArray *)dateSelectionArray;

@end

@interface SPCalendarMonthViewController : UIViewController

@property (weak, nonatomic) id<SPCalendarMonthViewControllerDelegate> monthViewControllerDelegate;

- (id)initWithViewFrame:(CGRect)frame;

- (void)changeMonthViewInDirection:(MonthAnimationDirection)animationDirection withDate:(NSDate *)date;

@end
