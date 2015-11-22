//
//  ViewSimulationResultsViewController.h
//  
//
//  Created by Sky Arnold on 8/29/15.
//
//

#import <UIKit/UIKit.h>

@interface ViewResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray1;
@property (strong, nonatomic) NSMutableArray *dataArray2;
@property (strong, nonatomic) NSMutableArray *resultsArray;
@property (nonatomic) BOOL calcMode;
@end
