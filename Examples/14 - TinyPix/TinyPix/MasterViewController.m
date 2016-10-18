//
//  MasterViewController.m
//  TinyPix
//
//  Created by Kim Topley on 8/14/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "TinyPixDocument.h"
#import "TinyPixUtils.h"

@interface MasterViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *colorControl;
@property (strong, nonatomic) NSArray *documentFilenames;
@property (strong, nonatomic) TinyPixDocument *chosenDocument;
@property (strong, nonatomic) NSMetadataQuery *query;
@property (strong, nonatomic) NSMutableArray *documentURLs;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger selectedColorIndex = [prefs integerForKey:@"selectedColorIndex"];
    [self setTintColorForIndex:selectedColorIndex];
    [self.colorControl setSelectedSegmentIndex:selectedColorIndex];

    [self reloadFiles];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSettingsChanged:)
              name:NSUserDefaultsDidChangeNotification object:nil];
}

- (NSURL *)urlForFilename:(NSString *)filename {
    // be sure to insert "Documents" into the path
    NSURL *baseURL = [[NSFileManager defaultManager]
                      URLForUbiquityContainerIdentifier:nil];
    NSURL *pathURL = [baseURL URLByAppendingPathComponent:@"Documents"];
    NSURL *destinationURL = [pathURL URLByAppendingPathComponent:filename];
    return destinationURL;
}

- (void)reloadFiles {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // passing nil is OK here, matches first entitlement
    NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
    NSLog(@"got cloudURL %@", cloudURL);  // returns nil in simulator
    if (cloudURL != nil) {
        self.query = [[NSMetadataQuery alloc] init];
        _query.predicate = [NSPredicate predicateWithFormat:@"%K like '*.tinypix'",
                            NSMetadataItemFSNameKey];
        _query.searchScopes = [NSArray arrayWithObject:
                               NSMetadataQueryUbiquitousDocumentsScope];
        [[NSNotificationCenter defaultCenter]
                addObserver:self
                selector:@selector(updateUbiquitousDocuments:)
                name:NSMetadataQueryDidFinishGatheringNotification
                object:nil];
        [[NSNotificationCenter defaultCenter]
                addObserver:self
                selector:@selector(updateUbiquitousDocuments:)
                name:NSMetadataQueryDidUpdateNotification
                object:nil];
        [_query startQuery];
    }
}

- (void)updateUbiquitousDocuments:(NSNotification *)notification {
    self.documentURLs = [NSMutableArray array];
    self.documentFilenames = [NSMutableArray array];
    
    NSLog(@"updateUbiquitousDocuments, results = %@", self.query.results);
    NSArray *results = [self.query.results sortedArrayUsingComparator:
                        ^NSComparisonResult(id obj1, id obj2) {
                            NSMetadataItem *item1 = obj1;
                            NSMetadataItem *item2 = obj2;
                            return [[item2 valueForAttribute:NSMetadataItemFSCreationDateKey]
                                    compare:
                                    [item1 valueForAttribute:NSMetadataItemFSCreationDateKey]];
                        }];
    
    for (NSMetadataItem *item in results) {
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        [self.documentURLs addObject:url];
        [(NSMutableArray *)_documentFilenames addObject:[url lastPathComponent]];
    }
    
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
            numberOfRowsInSection:(NSInteger)section {
    return [self.documentFilenames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"FileCell"];
    
    NSString *path = self.documentFilenames[indexPath.row];
    cell.textLabel.text = path.lastPathComponent.stringByDeletingPathExtension;
    return cell;
}

- (IBAction)chooseColor:(id)sender {
    NSInteger selectedColorIndex = [(UISegmentedControl *)sender
                                    selectedSegmentIndex];
    [self setTintColorForIndex:selectedColorIndex];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:selectedColorIndex forKey:@"selectedColorIndex"];
    [prefs synchronize];
    [[NSUbiquitousKeyValueStore defaultStore] setLongLong:selectedColorIndex forKey:@"selectedColorIndex"];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)setTintColorForIndex:(NSInteger)selectedColorIndex {
    self.colorControl.tintColor = [TinyPixUtils getTintColorForIndex:selectedColorIndex];
}

- (void)insertNewObject {
    UIAlertController *alert =
         [UIAlertController alertControllerWithTitle:@"Choose File Name"
                     message: @"Enter a name for your new TinyPix document."
                     preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                       style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *createAction = [UIAlertAction actionWithTitle:@"Create"
           style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
               UITextField *textField = (UITextField *)alert.textFields[0];
               [self createFileNamed:textField.text];
           }];
    [alert addAction:cancelAction];
    [alert addAction:createAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createFileNamed:(NSString *)fileName {
    NSString *trimmedFileName = [fileName
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedFileName.length > 0) {
        NSString *targetName = [NSString stringWithFormat:@"%@.tinypix",
                                 trimmedFileName];
        NSURL *saveUrl = [self urlForFilename:targetName];
        self.chosenDocument =
             [[TinyPixDocument alloc] initWithFileURL:saveUrl];
        [self.chosenDocument saveToURL:saveUrl
                     forSaveOperation:UIDocumentSaveForCreating
                     completionHandler:^(BOOL success) {
                         if (success) {
                             NSLog(@"save OK");
                             [self reloadFiles];
                             [self performSegueWithIdentifier:@"masterToDetail"
                                                       sender:self];
                         } else {
                             NSLog(@"failed to save!");
                         }
                     }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destination = (UINavigationController *)segue.destinationViewController;
    DetailViewController *detailVC = (DetailViewController *)destination.topViewController;
    if (sender == self) {
        // if sender == self, a new document has just been created,
        // and chosenDocument is already set.
        detailVC.detailItem = self.chosenDocument;
    } else {
        // find the chosen document from the tableview
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *filename = self.documentFilenames[indexPath.row];
        NSURL *docUrl = [self urlForFilename:filename];
        self.chosenDocument = [[TinyPixDocument alloc]
                               initWithFileURL:docUrl];
        [self.chosenDocument openWithCompletionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"load OK");
                detailVC.detailItem = self.chosenDocument;
            } else {
                NSLog(@"failed to load!");
            }
        }];
    }
}

- (void)onSettingsChanged:(NSNotification *)notification {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger selectedColorIndex = [prefs integerForKey:@"selectedColorIndex"];
    [self setTintColorForIndex:selectedColorIndex];
    self.colorControl.selectedSegmentIndex = selectedColorIndex;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

@end
