//
//  SPCalendarView.m
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/29/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPCalendarView.h"

#define CONTROLS_WIDTH 320 / 7.0f

@interface SPCalendarView ()

@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIButton *previousMonthButton;
@property (strong, nonatomic) UIButton *nextMonthButton;
@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation SPCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.selectedDate = [NSDate date];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"MMMM yyyy"];
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 42.5f, self.frame.size.width, 0.5f)];
        firstLineView.backgroundColor = [UIColor colorWithWhite:238.0f / 255.0f alpha:1.0f];
        [self addSubview:firstLineView];
        
        UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 78.5f, self.frame.size.width, 0.5f)];
        secondLineView.backgroundColor = [UIColor colorWithWhite:238.0f / 255.0f alpha:1.0f];
        [self addSubview:secondLineView];
        
        self.previousMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.previousMonthButton.frame = CGRectMake(0.0f, 0.0f, CONTROLS_WIDTH, 42.5f);
        [self.previousMonthButton setTitleColor:[UIColor colorWithRed:99 / 255.0f green:87 / 255.0f blue:207 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.previousMonthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.previousMonthButton setTitle:@"<" forState:UIControlStateNormal];
        [self.previousMonthButton addTarget:self action:@selector(previousMonthButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.previousMonthButton];
        
        self.nextMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextMonthButton.frame = CGRectMake(self.frame.size.width - CONTROLS_WIDTH, 0.0f, CONTROLS_WIDTH, 42.5f);
        [self.nextMonthButton setTitleColor:[UIColor colorWithRed:99 / 255.0f green:87 / 255.0f blue:207 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.nextMonthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.nextMonthButton setTitle:@">" forState:UIControlStateNormal];
        [self.nextMonthButton addTarget:self action:@selector(nextMonthButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextMonthButton];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.previousMonthButton.frame.origin.x + self.previousMonthButton.frame.size.width,
                                                                   self.previousMonthButton.frame.origin.y,
                                                                   self.frame.size.width - (self.previousMonthButton.frame.origin.x + self.previousMonthButton.frame.size.width) - self.nextMonthButton.frame.size.width,
                                                                   self.previousMonthButton.frame.size.height)];
        self.dateLabel.textColor = [UIColor colorWithRed:99 / 255.0f green:87 / 255.0f blue:207 / 255.0f alpha:1.0f];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.text = [self.dateFormatter stringFromDate:self.selectedDate];
        [self addSubview:self.dateLabel];
    }
    
    return self;
}

#pragma mark - Button handlers

- (void)addMonthCountToDateLabel:(NSInteger)monthCount
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:monthCount];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    self.selectedDate = [calendar dateByAddingComponents:dateComponents toDate:self.selectedDate options:0];
    
    self.dateLabel.text = [self.dateFormatter stringFromDate:self.selectedDate];
}

#pragma mark - Button handlers

- (void)previousMonthButtonHandler
{
    [self addMonthCountToDateLabel:-1];
}

- (void)nextMonthButtonHandler
{
    [self addMonthCountToDateLabel:1];
}

@end
