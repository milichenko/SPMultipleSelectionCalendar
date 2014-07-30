//
//  SPCalendarMonthView.m
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/30/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPCalendarMonthView.h"

@interface SPCalendarMonthView ()

@property (strong, nonatomic) NSMutableArray *dateOfMonthButtons;

@end

@implementation SPCalendarMonthView

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame date:[NSDate date]];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat dayOfMonthButtonsHeight = self.frame.size.height / 5.0f;
        
        CGFloat btnY = 0.0f;
        
        self.dateOfMonthButtons = [NSMutableArray array];
        
        for (int i = 0; i < 5; i++)
        {
            self.dateOfMonthButtons[i] = [NSMutableArray array];
            
            CGFloat btnX = 0.0f;
            
            for (int j = 0; j < 7; j++)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(btnX, btnY, CONTROLS_WIDTH, dayOfMonthButtonsHeight);
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(dayButtonAction:) forControlEvents:UIControlEventTouchDown];
                
                [self addSubview:btn];
                
                self.dateOfMonthButtons[i][j] = btn;
                
                btnX += CONTROLS_WIDTH;
            }
            
            btnY += dayOfMonthButtonsHeight;
        }
        
        [self arrangeMonthDaysInDate:date];
    }
    
    return self;
}

#pragma mark - Private methods

- (void)arrangeMonthDaysInDate:(NSDate *)date
{
    for (int i = 0; i < 5; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            UIButton *btn = self.dateOfMonthButtons[i][j];
            [btn setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    NSRange monthRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[calendar dateFromComponents:dateComponents]];
    
    dateComponents.day = 1;
    
    NSDate *firstWeekDayDate = [calendar dateFromComponents:dateComponents];
    
    NSDateComponents *firstWeekDayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:firstWeekDayDate];
    
    int currentTitleValue = 1;
    
    BOOL endOfCycle = NO;
    
    for (int i = 0; i < 5; i++)
    {
        if (endOfCycle)
        {
            break;
        }
        
        for (int j = 0; j < 7; j++)
        {
            if (currentTitleValue > monthRange.length)
            {
                endOfCycle = YES;
                
                break;
            }
            else if (i == 0 && j < [firstWeekDayComponents weekday] - 1)
            {
                continue;
            }
            else
            {
                UIButton *btn = self.dateOfMonthButtons[i][j];
                [btn setTitle:[NSString stringWithFormat:@"%d",currentTitleValue] forState:UIControlStateNormal];
                
                currentTitleValue++;
            }
        }
    }
}

#pragma mark - Action

- (void)dayButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;

    [sender setTitleColor:sender.selected ? [UIColor lightGrayColor] : [UIColor blackColor] forState:UIControlStateNormal];
}

@end
