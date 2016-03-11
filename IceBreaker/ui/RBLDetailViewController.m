//
//  RBLDetailViewController.m
//  Droidalyzer
//
//  Created by toltori on 6/12/14.
//  Copyright (c) 2014 nWorks. All rights reserved.
//

#import "RBLDetailViewController.h"
#import "HomePageViewController.h"

@implementation RBLDetailViewController

@synthesize BLEDevicesRssi;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"BLE devices";
    self.BLEDevicesRssi = [NSMutableArray arrayWithArray:ble.peripheralsRssi];
    //self.BLEDevicesRssi = [NSMutableArray arrayWithObject:@"test_rssi"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize ble;

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.BLEDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"cell_uuid";
    CellUuid *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CellUuid" owner:nil options:nil] objectAtIndex:0];
    }
    
    // Configure the cell...
    UIFont *newFont = [UIFont fontWithName:@"Arial" size:13.5];
    
    cell.LblUUID.font = newFont;
    cell.LblUUID.text = [self.BLEDevices objectAtIndex:indexPath.row];
    
    newFont = [UIFont fontWithName:@"Arial" size:11.0];
    cell.LblRSSI.font = newFont;
    NSMutableString *rssiString = [NSMutableString stringWithFormat:@"RSSI : %@", [self.BLEDevicesRssi objectAtIndex:indexPath.row]];
    cell.LblRSSI.text = rssiString;
    
    newFont = [UIFont fontWithName:@"Arial" size:13.0];
    cell.LblDeviceName.font = newFont;
    cell.LblDeviceName.text = [self.BLEDevicesName objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ble connectPeripheral:[ble.peripherals objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)getUUIDString:(CFUUIDRef)ref
{
    NSString *str = [NSString stringWithFormat:@"%@", ref];
    return [[NSString stringWithFormat:@"%@", str] substringWithRange:NSMakeRange(str.length - 36, 36)];
}

@end

