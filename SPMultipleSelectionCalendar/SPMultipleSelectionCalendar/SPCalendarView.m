//
//  SPCalendarView.m
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/29/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPCalendarView.h"
#import "SPCalendarMonthViewController.h"

@interface SPCalendarView () <SPCalendarMonthViewControllerDelegate>

@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIButton *previousMonthButton;
@property (strong, nonatomic) UIButton *nextMonthButton;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) SPCalendarMonthViewController *monthViewController;
@property (strong, nonatomic) UIView *headerView;

@property (assign, nonatomic) BOOL monthIsChaging;

@end

@implementation SPCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.monthIsChaging = NO;
        self.selectedDate = [NSDate date];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        //self.dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        self.dateFormatter.dateFormat = @"MMMM yyyy";
        
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 79.0f)];
        self.headerView.backgroundColor = self.backgroundColor;
        [self addSubview:self.headerView];
        
        UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 42.5f, self.headerView.frame.size.width, 0.5f)];
        firstLineView.backgroundColor = [UIColor colorWithWhite:238.0f / 255.0f alpha:1.0f];
        [self.headerView addSubview:firstLineView];
        
        UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 78.5f, self.headerView.frame.size.width, 0.5f)];
        secondLineView.backgroundColor = [UIColor colorWithWhite:238.0f / 255.0f alpha:1.0f];
        [self.headerView addSubview:secondLineView];
        
        self.previousMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.previousMonthButton.frame = CGRectMake(0.0f, 0.0f, CONTROLS_WIDTH, 42.5f);
        [self.previousMonthButton setTitleColor:[UIColor colorWithRed:99 / 255.0f green:87 / 255.0f blue:207 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.previousMonthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.previousMonthButton setTitle:@"<" forState:UIControlStateNormal];
        [self.previousMonthButton addTarget:self action:@selector(changeMonthButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:self.previousMonthButton];
        
        self.nextMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextMonthButton.frame = CGRectMake(self.headerView.frame.size.width - CONTROLS_WIDTH, 0.0f, CONTROLS_WIDTH, 42.5f);
        [self.nextMonthButton setTitleColor:[UIColor colorWithRed:99 / 255.0f green:87 / 255.0f blue:207 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.nextMonthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.nextMonthButton setTitle:@">" forState:UIControlStateNormal];
        [self.nextMonthButton addTarget:self action:@selector(changeMonthButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:self.nextMonthButton];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.previousMonthButton.frame.origin.x + self.previousMonthButton.frame.size.width,
                                                                   self.previousMonthButton.frame.origin.y,
                                                                   self.headerView.frame.size.width - (self.previousMonthButton.frame.origin.x + self.previousMonthButton.frame.size.width) - self.nextMonthButton.frame.size.width,
                                                                   self.previousMonthButton.frame.size.height)];
        self.dateLabel.textColor = [UIColor colorWithRed:99 / 255.0f green:87 / 255.0f blue:207 / 255.0f alpha:1.0f];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.text = [self.dateFormatter stringFromDate:self.selectedDate];
        [self.headerView addSubview:self.dateLabel];
        
        CGFloat dayOfWeekLabelsOriginY = firstLineView.frame.origin.y + firstLineView.frame.size.height;
        CGFloat dayOfWeekLabelsHeight = 35.5f;
        
        UIColor *dayOfWeekLabelsTextColor = [UIColor colorWithRed:126 / 255.0f green:125 / 255.0f blue:140 / 255.0f alpha:1.0f];
        
        UILabel *sundayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, dayOfWeekLabelsOriginY, CONTROLS_WIDTH, dayOfWeekLabelsHeight)];
        sundayLabel.textColor = dayOfWeekLabelsTextColor;
        sundayLabel.text = @"S";
        sundayLabel.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:sundayLabel];
        
        UILabel *mondayLabel = [[UILabel alloc] initWithFrame:CGRectMake(sundayLabel.frame.origin.x + CONTROLS_WIDTH, dayOfWeekLabelsOriginY, CONTROLS_WIDTH, dayOfWeekLabelsHeight)];
        mondayLabel.textColor = dayOfWeekLabelsTextColor;
        mondayLabel.text = @"M";
        mondayLabel.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:mondayLabel];
        
        UILabel *tuesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(mondayLabel.frame.origin.x + CONTROLS_WIDTH, dayOfWeekLabelsOriginY, CONTROLS_WIDTH, dayOfWeekLabelsHeight)];
        tuesdayLabel.textColor = dayOfWeekLabelsTextColor;
        tuesdayLabel.text = @"T";
        tuesdayLabel.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:tuesdayLabel];
        
        UILabel *wednesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(tuesdayLabel.frame.origin.x + CONTROLS_WIDTH, dayOfWeekLabelsOriginY, CONTROLS_WIDTH, dayOfWeekLabelsHeight)];
        wednesdayLabel.textColor = dayOfWeekLabelsTextColor;
        wednesdayLabel.text = @"W";
        wednesdayLabel.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:wednesdayLabel];
        
        UILabel *thursdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(wednesdayLabel.frame.origin.x + CONTROLS_WIDTH, dayOfWeekLabelsOriginY, CONTROLS_WIDTH, dayOfWeekLabelsHeight)];
        thursdayLabel.textColor = dayOfWeekLabelsTextColor;
        thursdayLabel.text = @"T";
        thursdayLabel.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:thursdayLabel];
        
        UILabel *fridayLabel = [[UILabel alloc] initWithFrame:CGRectMake(thursdayLabel.frame.origin.x + CONTROLS_WIDTH, dayOfWeekLabelsOriginY, CONTROLS_WIDTH, dayOfWeekLabelsHeight)];
        fridayLabel.textColor = dayOfWeekLabelsTextColor;
        fridayLabel.text = @"F";
        fridayLabel.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:fridayLabel];
        
        UILabel *saturdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(fridayLabel.frame.origin.x + CONTROLS_WIDTH, dayOfWeekLabelsOriginY, CONTROLS_WIDTH, dayOfWeekLabelsHeight)];
        saturdayLabel.textColor = dayOfWeekLabelsTextColor;
        saturdayLabel.text = @"S";
        saturdayLabel.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:saturdayLabel];
        
        self.monthViewController = [[SPCalendarMonthViewController alloc] initWithViewFrame:CGRectMake(0.0f,
                                                                                                       secondLineView.frame.origin.y + secondLineView.frame.size.height,
                                                                                                       self.frame.size.width,
                                                                                                       self.frame.size.height - (secondLineView.frame.origin.y + secondLineView.frame.size.height))];
        self.monthViewController.monthViewControllerDelegate = self;
        
        [self addSubview:self.monthViewController.view];
    }
    
    return self;
}

#pragma mark - Private methods

- (NSDate *)addToDate:(NSDate *)date monthsCount:(NSInteger)monthsCount
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:monthsCount];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [calendar dateByAddingComponents:dateComponents toDate:date options:0];
}

#pragma mark - Actions

- (void)changeMonthButtonAction:(UIButton *)sender
{
    if (!self.monthIsChaging)
    {
        self.monthIsChaging = YES;
        
        MonthAnimationDirection monthAnimationDirection = MonthAnimationDirectionUp;
        
        if (sender == self.previousMonthButton)
        {
            self.selectedDate = [self addToDate:self.selectedDate monthsCount:-1];
            monthAnimationDirection = MonthAnimationDirectionDown;
        }
        else if (sender == self.nextMonthButton)
        {
            self.selectedDate = [self addToDate:self.selectedDate monthsCount:1];
            monthAnimationDirection = MonthAnimationDirectionUp;
        }
        
        self.dateLabel.text = [self.dateFormatter stringFromDate:self.selectedDate];
        
        [self.monthViewController changeMonthViewInDirection:monthAnimationDirection withDate:self.selectedDate];
    }
}

#pragma mark - SPCalendarMonthViewControllerDelegate

- (void)calendarMonthViewControllerAnimationWillStart:(SPCalendarMonthViewController *)monthViewController
{
    [self bringSubviewToFront:self.headerView];
}

- (void)calendarMonthViewControllerAnimationDidStop:(SPCalendarMonthViewController *)monthViewController
{
    self.monthIsChaging = NO;
}

- (void)calendarMonthViewController:(SPCalendarMonthViewController *)monthViewController needChangeMonthInDirection:(MonthAnimationDirection)animationDirection
{
    UIButton *sender = animationDirection == MonthAnimationDirectionDown ? self.previousMonthButton : self.nextMonthButton;
    
    [self changeMonthButtonAction:sender];
}

@end
