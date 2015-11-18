//
//  ViewSimulationResultsViewController.h
//  
//
//  Created by Sky Arnold on 8/29/15.
//
//

#import <UIKit/UIKit.h>

@interface ViewResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *resultsArray;
@property (nonatomic) BOOL calcMode;
@end
