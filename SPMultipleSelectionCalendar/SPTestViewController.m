//
//  SPTestViewController.m
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/29/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPTestViewController.h"
#import "SPCalendarView.h"

@interface SPTestViewController ()

@property (weak, nonatomic) IBOutlet UITextField *calendarTextField;

@end

@implementation SPTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SPCalendarView *calendarView = [[SPCalendarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 255.0f)];
    
    self.calendarTextField.inputView = calendarView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
