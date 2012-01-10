//
//  SaveDataModel.m
//  CubeBuilder
//
//  Created by Kris Temmerman on 04/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveDataModel.h"

@implementation SaveDataModel




@synthesize savedData;
@synthesize databasePath ;
@synthesize openSavedIndex;

//static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *deleteStmt = nil;

-(void)initDB
{
    
    savedData  =[[NSMutableArray alloc]init];
  
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"datab.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &DB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS data_tb(pk INTEGER PRIMARY KEY, name VARCHAR(25),data BLOB)";
            
            if (sqlite3_exec(DB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog ( @"Failed to create table");
            }
            
            sqlite3_close(DB);
            
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
    NSLog(@"DB ok");
    [filemgr release];
    
}
-(void )getAllData
{
    [savedData removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &DB) == SQLITE_OK)
    {
        
        
        const char *stmt = "SELECT pk, name FROM data_tb";
        
        if (sqlite3_prepare_v2(DB, stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while  (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSInteger primaryKey = sqlite3_column_int(statement, 0);
               // NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSNumber* n =  [NSNumber numberWithInt:primaryKey];
                cout << n.intValue <<"\n";
               /* const void *ptr = sqlite3_column_blob(statement, 2);
                int size = sqlite3_column_bytes(statement, 2);
                NSData * data = [[NSData alloc] initWithBytes:ptr length:size];
                NSArray *dataCubes =(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data ];
                
                const void *ptr2 = sqlite3_column_blob(statement, 3);
                int size2 = sqlite3_column_bytes(statement, 3);
                NSData * dataImage = [[NSData alloc] initWithBytes:ptr2 length:size2];
*/
               // NSLog(@"found stuff");
                [savedData addObject:n ];
                /*
                
                const void *ptr2 = sqlite3_column_blob(statement, 3);
                int size2 = sqlite3_column_bytes(statement, 3);
                NSData * data2 = [[NSData alloc] initWithBytes:ptr2 length:size2];
                NSArray *songs_arr =(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data2 ];*/
              
            } 
            
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(DB);
    }
    
    
    
}

-(void )getCubeData:(int )key
{
    NSLog(@"okedoke");
    //[savedData removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &DB) == SQLITE_OK)
    {
        
        
        const char *stmt = "SELECT data FROM data_tb where pk = ?";
        
        if (sqlite3_prepare_v2(DB, stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(statement, 1, key);

            if     (sqlite3_step(statement) == SQLITE_ROW)
            {
               const void *ptr = sqlite3_column_blob(statement, 0);
                 int size = sqlite3_column_bytes(statement, 0);
                 NSData * data = [[NSData alloc] initWithBytes:ptr length:size];
                
                cout <<"bytes " <<data.length;
                 NSArray *dataCubes =(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data ];
                
                //[dataCubes objectAtIndex:0];
                    cout <<"  bytes cc  " <<dataCubes.count;
                int  * dataCube =new int[[dataCubes count]];
               for (int i=0; i< [dataCubes count];i++)
                {
                    NSNumber *a  =(NSNumber *)[dataCubes objectAtIndex:i ] ;
                   dataCube [i]= [a intValue];
                }
                Model::getInstance()->setLoadData(dataCube,[dataCubes count]);
               //delete [] dataCube;
                //[data release];
                //[dataCubes release];
                
            } 
            
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(DB);
    }
    
     Model::getInstance()->currentLoadID = key ;
    
}
- (void) saveData : (NSData * ) imageData cubeData :(NSData * ) cubeData 
{
    
    
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *addStmt = nil;
    if (sqlite3_open(dbpath, &DB) == SQLITE_OK)
    {
        
        
        
        
        NSString *name =@"test";
        
        
        
        if(addStmt == nil) {
            const char *sql = "insert into data_tb(name, data) Values(?, ?)";
            if(sqlite3_prepare_v2(DB, sql, -1, &addStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(DB));
        }
        
        sqlite3_bind_text(addStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob (addStmt, 2, [cubeData bytes], [cubeData length], SQLITE_TRANSIENT);
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(DB));
        else
            
            
            
            
            sqlite3_reset(addStmt);
        
        cout << "savedOK";
    }
    
    
    int currentFileID =   sqlite3_last_insert_rowid(DB);
    sqlite3_close(DB);
    Model::getInstance()->currentLoadID = currentFileID ;
    
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];  
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%i.png", documentsDirectory,currentFileID];
    
    
    bool r = [imageData  writeToFile:filePath atomically:YES];
    NSLog(@"%@",filePath);
    cout << "\n saved"<< r<<" "<< currentFileID <<"\n";
    if (!r )NSLog(@"image not saved");
    
    
}

- (void) saveDataCurrent: (NSData * ) imageData cubeData :(NSData * ) cubeData 
{
    

  int currentFileID =   Model::getInstance()->currentLoadID;
    const char *dbpath = [databasePath UTF8String];
   sqlite3_stmt *addStmt = nil;
    if (sqlite3_open(dbpath, &DB) == SQLITE_OK)
    {
        
        
        
      
        NSString *name =@"test";
        
        
        
        if(addStmt == nil) {
            const char *sql = "UPDATE data_tb SET name = ?, data =? WHERE pk=?";
            if(sqlite3_prepare_v2(DB, sql, -1, &addStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(DB));
        }
        
        sqlite3_bind_text(addStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob (addStmt, 2, [cubeData bytes], [cubeData length], SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt,3, currentFileID);
        if(SQLITE_DONE != sqlite3_step(addStmt))
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(DB));
        else
            
            
            
            
        sqlite3_reset(addStmt);
        
        cout << "savedOK";
    }
    
  
  
    sqlite3_close(DB);
   // Model::getInstance()->currentLoadID = currentFileID ;
    
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];  
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%i.png", documentsDirectory,currentFileID];
    
   
    bool r = [imageData  writeToFile:filePath atomically:YES];
    NSLog(@"%@",filePath);
    cout << "\n saved"<< r<<" "<< currentFileID <<"\n";
    if (!r )NSLog(@"image not saved");
    
    
}


-(void) deleteSaved: (int) key
{
    
     if( Model::getInstance()->currentLoadID == key)  Model::getInstance()->currentLoadID =-1;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &DB) == SQLITE_OK)
    {
        
        if(deleteStmt == nil) {
            const char *sql = "delete from data_tb where pk = ?";
            if(sqlite3_prepare_v2(DB, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
                NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(DB));
        }
        
        //When binding parameters, index starts from 1 and not zero.
        sqlite3_bind_int(deleteStmt, 1, key);
        
        if (SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(DB));
        
        sqlite3_reset(deleteStmt);
        
        
        //delete image
        //cout << "\ndeleted:" <<key;
        
    }
    
    
    sqlite3_close(DB);
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];  
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%i.png", documentsDirectory,key];
    
    
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error;
    if ([fileMgr removeItemAtPath:filePath error:&error] != YES){
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }else
    {
    
        NSLog(@"file deleted");
    }
}



static SaveDataModel *sharedSingleton =nil;
+ (SaveDataModel *)getInstance
{
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[super allocWithZone:NULL] init];
        
        return sharedSingleton;
    }
}
@end
