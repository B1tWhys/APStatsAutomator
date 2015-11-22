//
//  linearRegressionViewController.m
//  APStatsSolver
//
//  Created by Skyler Arnold on 11/6/15.
//  Copyright © 2015 Skyler Arnold. All rights reserved.
//

#import "linearRegressionViewController.h"
#import "linearRegressionTVCTableViewCell.h"

@interface linearRegressionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tvc;
@property (nonatomic) int numOfRows;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@end

@implementation linearRegressionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataDictionary = [NSMutableDictionary new];
    
    self.numOfRows = 1;
    
    self.tvc.delegate = self;
    self.tvc.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    linearRegressionTVCTableViewCell *cell = [self.tvc dequeueReusableCellWithIdentifier:@"LinRegresInputCell"];
    
    if (!cell) {
        cell = [[linearRegressionTVCTableViewCell alloc] init];
    }
    
    self.dataDictionary[[NSNumber numberWithInt:indexPath.row]] = @[[NSNumber numberWithFloat:cell.xVal], [NSNumber numberWithFloat:cell.yVal]];
    cell.tag = indexPath.row;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numOfRows;
}

@end
