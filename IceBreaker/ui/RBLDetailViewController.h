//
//  RBLDetailViewController.h
//  Droidalyzer
//
//  Created by toltori on 6/12/14.
//  Copyright (c) 2014 nWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellUuid.h"
#import "BLE.h"

@protocol RBLDetailViewControllerDelegate <NSObject>

- (void) didSelected:(NSInteger)selected;

@end

@interface RBLDetailViewController : UITableViewController
{
}

@property (strong, nonatomic) BLE *ble;
@property (strong, nonatomic) NSMutableArray *BLEDevices;
@property (strong, nonatomic) NSMutableArray *BLEDevicesRssi;
@property (strong, nonatomic) NSMutableArray *BLEDevicesName;

@end
