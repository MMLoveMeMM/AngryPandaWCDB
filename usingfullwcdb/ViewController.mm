//
//  ViewController.m
//  usingfullwcdb
//
//  Created by liuzhibao on 7/29/17.
//  Copyright © 2017 HelloOS. All rights reserved.
//

#import "ViewController.h"
#import <WCDB/WCDB.h>
#import "Message.h"
#import "WCDB.h"
#import "Message+WCTTableCoding.h"
@interface ViewController ()

@end

@implementation ViewController

WCTDatabase *database;
int CNT=0;
NSString* path=NSHomeDirectory();
NSString* databasename=@"messagedb";
NSString* tablename=databasename;
int pageSize=0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton* crtdb=[self.view viewWithTag:10];
    [crtdb setTitle:@"create db" forState:UIControlStateNormal];
    [crtdb addTarget:self action:@selector(createdb) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* insertdb=[self.view viewWithTag:20];
    [insertdb setTitle:@"insert" forState:UIControlStateNormal];
    [insertdb addTarget:self action:@selector(insertdb) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* querydb=[self.view viewWithTag:30];
    [querydb setTitle:@"query" forState:UIControlStateNormal];
    [querydb addTarget:self action:@selector(querydb) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* createtable=[self.view viewWithTag:40];
    [createtable setTitle:@"create table" forState:UIControlStateNormal];
    [createtable addTarget:self action:@selector(createtable) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* opendb=[self.view viewWithTag:50];
    [opendb setTitle:@"opendb" forState:UIControlStateNormal];
    [opendb addTarget:self action:@selector(opendatabase) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* tinsertdb=[self.view viewWithTag:100];
    [tinsertdb setTitle:@"tran insert" forState:UIControlStateNormal];
    tinsertdb.tag=1;
    [tinsertdb addTarget:self action:@selector(inserttransactiondb:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* muinsertdb=[self.view viewWithTag:200];
    [muinsertdb setTitle:@"mudb" forState:UIControlStateNormal];
    [muinsertdb addTarget:self action:@selector(mutableinsertdb) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* bkdb=[self.view viewWithTag:300];
    [bkdb setTitle:@"backup" forState:UIControlStateNormal];
    [bkdb addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* crupdb=[self.view viewWithTag:301];
    [crupdb setTitle:@"crupt db" forState:UIControlStateNormal];
    [crupdb addTarget:self action:@selector(cruptdb) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* repairdb=[self.view viewWithTag:302];
    [repairdb setTitle:@"repair" forState:UIControlStateNormal];
    [repairdb addTarget:self action:@selector(repairdb) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)repairdb
{
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:databasename];
    NSString *recoverpath=[databaseFilePath stringByAppendingString:@"_recover"];

    NSData* backchiper=[@"liu123456" dataUsingEncoding:NSASCIIStringEncoding];
    
    WCTDatabase *recover=[[WCTDatabase alloc] initWithPath:recoverpath];
    [recover close:^{
        [recover removeFilesWithError:nil];
    }];
    
    [database close:^{
        [recover recoverFromPath:path withPageSize: pageSize backupCipher:backchiper databaseCipher:backchiper];
    }];
    
}

-(void)cruptdb
{

    [database close:^{
        
        NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                    , NSUserDomainMask
                                                                    , YES);
        NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:databasename];
        FILE *file=fopen(databaseFilePath.UTF8String,"+rb");
        unsigned char *zeroPage = new unsigned char[100];
        memset(zeroPage, 0, 100);
        fwrite(zeroPage, 100, 1, file);
        fclose(file);
        
    }];
    
}

-(void)backup
{
    NSData* backchiper=[@"liu123456" dataUsingEncoding:NSASCIIStringEncoding];
    BOOL ret=[database backupWithCipher:backchiper];
    if(!ret){
        abort();
    }

    {
    
        @autoreleasepool {
            WCTStatement* statement=[database prepare:WCDB::StatementPragma().pragma(WCDB::Pragma::PageSize)];
            [statement step];
            NSNumber* value=(NSNumber *)[statement getValueAtIndex:0];
            pageSize = value.intValue;
            NSLog(@"page size is : %d",pageSize);
            statement=nil;
        }
    }

}

-(void)mutableinsertdb
{

    NSMutableArray *objects=[[NSMutableArray alloc]init];
    
    Message *message=[[Message alloc]init];
    message.localID=++CNT;
    message.content=[@"usa" stringByAppendingString:[NSString stringWithFormat:@"%d",CNT]];
    message.createtime=[NSDate date];
    message.modifiedtime=[NSDate date];
    
    [objects addObject:message];
    
    Message *msg=[[Message alloc]init];
    msg.localID=++CNT;
    msg.content=[@"austrial" stringByAppendingString:[NSString stringWithFormat:@"%d",CNT]];
    msg.createtime=[NSDate date];
    msg.modifiedtime=[NSDate date];
    
    [objects addObject:msg];
    
    BOOL ret=[database insertObjects:objects into:tablename];
    
}

-(void)opendatabase
{
    NSLog(@"open wcdb database !");
    
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:databasename];
    
    NSLog(@"database path : %@",databaseFilePath);
    database = [[WCTDatabase alloc] initWithPath:databaseFilePath];
    
    //WCDB::Config
    //[database setConfig:(WCDB::Config) forName:<#(NSString *)#>
    [database canOpen];
}

-(void)createtable
{
    
    /*
     CREATE TABLE messsage (localID INTEGER PRIMARY KEY,
     content TEXT,
     createTime BLOB,
     modifiedTime BLOB)
     */
    BOOL ret=[database createTableAndIndexesOfName:tablename withClass:Message.class];
    assert(ret);
    
}

-(void)createdb
{
    NSLog(@"create wcdb database !");
    
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:databasename];
    
    NSLog(@"database path : %@",databaseFilePath);
    database = [[WCTDatabase alloc] initWithPath:databaseFilePath];
    NSData* password=[@"liu123456" dataUsingEncoding:NSASCIIStringEncoding];
    [database setCipherKey:password];
     [database close:^{
        [database removeFilesWithError:nil];//remove db when close database
    }];
    
    NSArray *schemas = [database getAllObjectsOnResults:{WCTMaster.name, WCTMaster.sql} fromTable:WCTMaster.TableName];
    for (WCTMaster *table : schemas) {
        NSLog(@"SQL Of %@: %@", table.name, table.sql);
    }
    
}

-(void)inserttransactiondb:(NSInteger*)type
{

    //run blocked transaction
    if(FALSE){
        BOOL commited = [database runTransaction:^BOOL{
            
            Message *message=[[Message alloc]init];
            message.localID=++CNT;
            message.content=[@"usa" stringByAppendingString:[NSString stringWithFormat:@"%d",CNT]];
            message.createtime=[NSDate date];
            message.modifiedtime=[NSDate date];
            
            BOOL result=[database insertObject:(WCTObject*)message into:tablename];
            
            return result;
            
        }];
    }else if(TRUE){
        WCTTransaction *transaction = [database getTransaction];
        BOOL ret=[transaction begin];
        dispatch_async(dispatch_queue_create("other thread", DISPATCH_QUEUE_SERIAL), ^{
        
            Message *message=[[Message alloc]init];
            message.localID=++CNT;
            message.content=[@"Canada" stringByAppendingString:[NSString stringWithFormat:@"%d",CNT]];
            message.createtime=[NSDate date];
            message.modifiedtime=[NSDate date];
            BOOL ret=[transaction insertObject:message into:tablename];
            if(ret){
                [transaction commit];
            }else{
                [transaction rollback];
            }
            
        });
    }

}

-(void)insertdb
{

    Message* message=[[Message alloc]init];
    message.localID=++CNT;
    message.content=[@"liuzhibao" stringByAppendingString:[NSString stringWithFormat:@"%d",CNT]];
    message.createtime=[NSDate date];
    message.modifiedtime=[NSDate date];
    message.unused=0;
    
    BOOL result=[database insertObject:(WCTObject*)message into:tablename];
    
    [self deletedb];
}

-(void)deletedb
{
    BOOL result=[database deleteObjectsFromTable:tablename where:Message.localID>0];
}

-(void)querydb
{
//    NSArray<Message*> *message=[database getObjectsOfClass:Message.class
//                                                 fromTable:@"messagedb"
//                                                   orderBy:Message.localID.order()];
    NSArray<Message*> *allmessage=[database getAllObjectsOfClass:Message.class fromTable:tablename];
    NSLog(@"message count : %lld",allmessage.count);
    for(int i=0;i<allmessage.count;i++){
        Message* msg=[allmessage objectAtIndex:i];
        NSLog(@"elements 0: %@",msg.content);
        NSLog(@"elements 1: %@",msg.createtime);
    }
}


-(void)closedb
{
    [database close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
