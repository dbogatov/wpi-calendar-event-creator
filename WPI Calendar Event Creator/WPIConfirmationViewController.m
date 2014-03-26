//
//  WPIConfirmationViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIConfirmationViewController.h"
#import "WPIModel.h"
#import "NSString+Screening.h"

@interface WPIConfirmationViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *confiramationWebView;
- (IBAction)createButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation WPIConfirmationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"preview" ofType:@"html"];
    [self.confiramationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:indexPath]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    WPIModel *model = [WPIModel sharedDataModel];
    NSString *jsString = [NSString stringWithFormat:@"update('%@','%@','%@','%@','%@')", [[model getTitleForPurpose:1] stringByReplacingOccurrencesOfString:@"'" withString:@"&#39;"], [model getLocation], [model getDateForPurpose:1], [model getAlertForPurpose:0], [[model getNotes] screen]];
    [self.confiramationWebView stringByEvaluatingJavaScriptFromString:jsString];
}

- (IBAction)createButtonPressed:(UIBarButtonItem *)sender {
    [[WPIModel sharedDataModel] createEvent];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
