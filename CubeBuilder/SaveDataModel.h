//
//  SaveDataModel.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 04/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sqlite3.h>
#include <iostream>
using namespace std;
@interface SaveDataModel : NSObject
{



 sqlite3 *DB;

}
@property (readwrite,assign) int openSavedIndex;
@property (nonatomic,retain) NSString *databasePath ;
@property (nonatomic,retain) NSMutableArray *savedData;

+ (SaveDataModel *)getInstance;

- (void) saveData : (NSData * ) imageData cubeData :(NSData * ) cubeData ;
-(void )getAllData;
-(void) deleteSaved: (int) key;
-(void)initDB;
@end
