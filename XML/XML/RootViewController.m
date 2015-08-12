//
//  RootViewController.m
//  XML
//
//  Created by 沈家林 on 15/7/23.
//  Copyright (c) 2015年 沈家林. All rights reserved.
//

#import "RootViewController.h"
#import "GDataXMLNode.h"//成熟的第三方xml解析数据的类库(github)

@interface RootViewController ()

@end

@implementation RootViewController

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
    /*xml 可扩展标记语言，主要用于客户端与服务端进行数据交互。
     *xml数据特点:一种自上而下的树形结构,有且只有一个根节点:<root>...</root>
     *解析xml数据的过程，就是获取节点内容的过程
     *xml 与json: xml数据可读性强、扩展性强，但是没有json格式的数据轻巧，冗余的数据较多
     */
    [self basicXml];
//    [self xpath];
	// Do any additional setup after loading the view.
}
- (void)basicXml{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xml" ofType:@"txt"];
    if (path.length == 0) {
        NSLog(@"没有读到资源!");
        return;
    }
    //根据路径，读到字符串
    NSString *xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //解析
    //GDataXMLDocument 相当于一个xml解析的容器,接收xml的数据，后续通过doc来进行解析
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString error:nil];
    //获取根节点
    //在GData中 所有的节点(根节点、父节点、子节点)都是GDataXMLElement的对象
    GDataXMLElement *root = [doc rootElement];
    NSLog(@"root:%@",root);
    //取到root下面标题为books的子节点
    //节点的对象，会放到数组中返回
   NSArray *booksArray =[root elementsForName:@"books"];
    GDataXMLElement *books = booksArray[0];
    //取到books下面的book节点
    NSArray *bookArray = [books elementsForName:@"book"];
    for (GDataXMLElement *book in bookArray) {
        NSArray *names = [book elementsForName:@"name"];
        GDataXMLElement *bookName = names[0];
        //取到name节点的内容,用stringValue属性
        NSLog(@"name:%@",bookName.stringValue);
        //name属性能够获取到节点的标题
        NSLog(@"element name:%@",bookName.name);
        //XMLString 获取整个节点
        NSLog(@"xml:%@",bookName.XMLString);
        /****节点的属性***/
        //attributes 能够获取到book节点的所有属性对象,(属性也是节点的一种)
        NSArray *att = book.attributes;
        GDataXMLElement *idElement = att[0];
        //获取属性的值
        NSLog(@"id:%@",idElement.stringValue);
    }
}
//xpath 是一门查找xml数据的语言
//利用xpath语句，进行xml数据的解析
- (void)xpath{
//  利用节点在xml数据中的绝对路径，来获取该节点: /root/user_list/user
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sns" ofType:@"txt"];
    if (path.length==0) {
        NSLog(@"没有读到资源!");
        return;
    }
    NSString *xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //容器
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString error:nil];
    //利用user节点绝对路径的xpath语句,获取节点
   NSArray *usersArray =[doc nodesForXPath:@"/root/user_list/user" error:nil];
    for (GDataXMLElement *user in usersArray) {
        NSArray *userNames = [user elementsForName:@"username"];
        GDataXMLElement *userName = userNames[0];
        NSLog(@"userName:%@",userName.stringValue);
    }
    //   //+节点的标题，能够获取到xml中所有该节点，不管节点在什么位置
   NSArray *totals =[doc nodesForXPath:@"//totalcount" error:nil];
    GDataXMLElement *total  =totals[0];
    NSLog(@"total:%@",total.stringValue);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
