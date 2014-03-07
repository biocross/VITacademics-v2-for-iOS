//
//  MarksViewController.m
//  VITacademics
//
//  Created by Siddharth Gupta on 19/10/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "MarksViewController.h"
#import "PNChart.h"

@interface MarksViewController ()

@end

@implementation MarksViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float cat1Marks = [self.marksArray[6]  isEqual: @""] ? 0 : [self.marksArray[6] floatValue];
    cat1Marks = (cat1Marks/50)*15;
    float cat2Marks = [self.marksArray[8]  isEqual: @""] ? 0 : [self.marksArray[8] floatValue];
    cat2Marks = (cat2Marks/50)*15;
    float quiz1Marks = [self.marksArray[10]  isEqual: @""] ? 0 : [self.marksArray[10] floatValue];
    float quiz2Marks = [self.marksArray[12]  isEqual: @""] ? 0 : [self.marksArray[12] floatValue];
    float quiz3Marks = [self.marksArray[14]  isEqual: @""] ? 0 : [self.marksArray[12] floatValue];
    float assignmentMarks = [self.marksArray[16]  isEqual: @""] ? 0 : [self.marksArray[16] floatValue];
    
    float totalInternals = cat1Marks + cat2Marks + quiz1Marks + quiz2Marks + quiz3Marks + assignmentMarks;
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150.0)];
    barChart.backgroundColor = [UIColor clearColor];
    [barChart setXLabels:@[@"Quiz 1",@"Quiz 2",@"Quiz 3", @"Assignment"]];
    [barChart setYValues:@[[NSNumber numberWithFloat:quiz1Marks], [NSNumber numberWithFloat:quiz2Marks], [NSNumber numberWithFloat:quiz3Marks], [NSNumber numberWithFloat:assignmentMarks]]];
    [barChart setYValueMax:5];
    //[barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen]];
    [barChart strokeChart];
    
    [self.view addSubview:barChart];
    
    PNBarChart * catBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 150.0, SCREEN_WIDTH, 200.0)];
    catBarChart.backgroundColor = [UIColor clearColor];
    [catBarChart setXLabels:@[@"CAT I",@"CAT II",@"Total"]];
    [catBarChart setYValues:@[[NSNumber numberWithFloat:cat1Marks], [NSNumber numberWithFloat:cat2Marks], [NSNumber numberWithFloat:totalInternals]]];
    [catBarChart setYValueMax:50];
    //[catBarChart setStrokeColors:@[PNGreen,PNGreen,PNRed]];
    [catBarChart strokeChart];
    
    catBarChart.showLabel = NO;
    
    [self.view addSubview:catBarChart];
    
}

-(void)dismissView{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MarksCell"];

    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text = @"CAT I";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 50", self.marksArray[6]];
        }
        if(indexPath.row == 1){
            cell.textLabel.text = @"CAT II";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 50", self.marksArray[8]];
        }
    }
    
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Quiz I";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 5", self.marksArray[10]];
        }
        if(indexPath.row == 1){
            cell.textLabel.text = @"Quiz II";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 5", self.marksArray[12]];
        }
        if(indexPath.row == 2){
            cell.textLabel.text = @"Quiz III";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 5", self.marksArray[14]];
        }
    }
    
    if(indexPath.section == 2){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Assignment";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 5", self.marksArray[16]];
        }
    }
    
    float cat1Marks = [self.marksArray[6]  isEqual: @""] ? 0 : [self.marksArray[6] floatValue];
    cat1Marks = (cat1Marks/50)*15;
    float cat2Marks = [self.marksArray[8]  isEqual: @""] ? 0 : [self.marksArray[8] floatValue];
    cat2Marks = (cat2Marks/50)*15;
    float quiz1Marks = [self.marksArray[10]  isEqual: @""] ? 0 : [self.marksArray[10] floatValue];
    float quiz2Marks = [self.marksArray[12]  isEqual: @""] ? 0 : [self.marksArray[12] floatValue];
    float quiz3Marks = [self.marksArray[14]  isEqual: @""] ? 0 : [self.marksArray[12] floatValue];
    float assignmentMarks = [self.marksArray[16]  isEqual: @""] ? 0 : [self.marksArray[16] floatValue];

    float totalInternals = cat1Marks + cat2Marks + quiz1Marks + quiz2Marks + quiz3Marks + assignmentMarks;
    
    if(indexPath.section == 3){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Total Internal Marks";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.0f / 50", totalInternals];
        }
    }
    
    
    return cell;
}*/




@end
