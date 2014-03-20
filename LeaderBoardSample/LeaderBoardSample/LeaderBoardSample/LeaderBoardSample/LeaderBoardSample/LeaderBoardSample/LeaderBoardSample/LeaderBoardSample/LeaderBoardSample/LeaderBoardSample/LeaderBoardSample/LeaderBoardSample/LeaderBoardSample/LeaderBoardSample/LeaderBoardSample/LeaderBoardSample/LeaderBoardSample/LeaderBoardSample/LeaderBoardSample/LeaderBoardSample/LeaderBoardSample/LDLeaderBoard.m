//
//  LDLeaderBoard.m
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 18/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "LDLeaderBoard.h"
#import "AppWarpHelper.h"

@implementation LDLeaderBoard


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || !nibNameOrNil)
    {
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    else
    {
        self = [super initWithNibName:[NSString stringWithFormat:@"%@_iPhone",nibNameOrNil] bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (scoreList) {
        [scoreList removeAllObjects];
        scoreList = nil;
    }
    
    scoreList=[NSMutableArray arrayWithCapacity:0];
    
    [self showAcitvityIndicator];

    [self getGlobalScore];
}

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)dealloc {
    scoreList = nil;

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)showAcitvityIndicator
{
    [indicatorView setHidden:NO];
    [activityIndicatorView startAnimating];
}

-(void)removeAcitvityIndicator
{
    [activityIndicatorView stopAnimating];
    [indicatorView setHidden:YES];
}

-(void)getGlobalScore
{
    [scoreList removeAllObjects];
    [scoreList addObjectsFromArray:[[AppWarpHelper sharedAppWarpHelper] getScores]];
    [userRecordsTableView reloadData];
    [self performSelectorOnMainThread:@selector(removeAcitvityIndicator) withObject:nil waitUntilDone:NO];
}

- (void) getFBScore {
    NSLog(@"%s",__func__);
    [scoreList removeAllObjects];
    [scoreList addObjectsFromArray:[[AppWarpHelper sharedAppWarpHelper] getFBFriendScores]];
    [userRecordsTableView reloadData];
    [self performSelectorOnMainThread:@selector(removeAcitvityIndicator) withObject:nil waitUntilDone:NO];
}

- (IBAction)segmentValuechanged:(id)sender {
    NSInteger index = [(UISegmentedControl *)sender selectedSegmentIndex];
    switch (index) {
        case 0: {
            [self getGlobalScore];
        } break;
        case 1: {
            [self getFBScore];
        } break;
            
        default:
            break;
    }
}


#pragma mark - UITableViewDatasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows =0;
    if (scoreList)
    {
        numberOfRows =[scoreList count]+1;
    }
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LD_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        CGSize viewSize = self.view.frame.size;
        float labelWidth = viewSize.width/3;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 30)];
        rankLabel.backgroundColor = [UIColor clearColor];
        rankLabel.tag =1;
        rankLabel.textAlignment = NSTextAlignmentCenter;
        [rankLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:rankLabel];
        
        UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0, 1, tableView.rowHeight)];
        lineLabel1.backgroundColor = [UIColor blackColor];
        [cell addSubview:lineLabel1];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0, labelWidth, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.tag =2;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [nameLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:nameLabel];
        
        UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(2*labelWidth, 0, 1, tableView.rowHeight)];
        lineLabel2.backgroundColor = [UIColor blackColor];
        [cell addSubview:lineLabel2];
        
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*labelWidth, 0, labelWidth, 30)];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.tag =3;
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        [scoreLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:scoreLabel];
    }
    
    if (indexPath.row==0)
    {
        UILabel *rankLabel=(UILabel *)[cell viewWithTag:1];
        [rankLabel setText:@"Rank"];
        
        UILabel *nameLabel=(UILabel *)[cell viewWithTag:2];
        [nameLabel setText:@"Name"];
        
        UILabel *scoreLabel =(UILabel *)[cell viewWithTag:3];
        [scoreLabel setText:@"Score"];
    }
    else
    {
        NSString *userName = nil;
        Score *l_score = [scoreList objectAtIndex:indexPath.row-1];
        for (JSONDocument *_doc in [l_score jsonDocArray]) {
            NSLog(@"%@",_doc.jsonDoc);
            NSError *error = nil;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[_doc.jsonDoc dataUsingEncoding:NSASCIIStringEncoding] options:0 error:&error];
            userName = [jsonDict objectForKey:@"Name"];
        }
        if (![userName length]) {
            userName = l_score.userName;
        }
        [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"%d",indexPath.row]];
        [(UILabel *)[cell viewWithTag:2] setText:userName];
        [(UILabel *)[cell viewWithTag:3] setText:[NSString stringWithFormat:@"%0.0f",l_score.value]];
    }
	
    if (indexPath.row >= [scoreList count]) {
        [self removeAcitvityIndicator];
    }
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
