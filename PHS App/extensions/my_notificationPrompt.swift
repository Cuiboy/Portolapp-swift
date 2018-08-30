//
//  my_notificationPrompt.swift
//  PHS App
//
//  Created by Patrick Cui on 8/29/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

func my_notificationPrompt(type: Int) -> String {
    
    switch type {
    case 0:
        return "nothing"
    case 1:
        //pep assembly odd
        return "There is a pep assembly tomorrow. School starts at 8:00 and ends at 3:30."
    case 2:
        //pep assembly even
        return "There is a pep assembly tomorrow. School starts at 8:00 and ends at 3:30."
    case 3:
        //extended lunch odd
        return "There is an extended lunch tomorrow, lunch will be 49 minutes long from 11:33 to 12:22."
    case 4:
        //extended lunch even
        return "There is an extended lunch tomorrow, lunch will be 49 minutes long from 11:33 to 12:22."
        
    case 5:
        //finals type 1
        return "Tomorrow is Finals, you will have 1st, 3rd and 7th period. School will start at 8:00 and end at 12:29."
    case 6:
        //finals type 2
        return "Tomorrow is Finals, you will have 2st, 4th and 8th period. School will start at 8:00 and end at 12:29."
    case 7:
        //finals two periods
        return "Tomorrow is Finals, you will have 5th and 6th period. School will start at 8:00 and end at 11:00."
    case 8:
        //minimum 1-8
        return "Tomorrow is minimum day, you will have period 1-8. School will start at 8:00 and end at 12:28."
    case 9:
        //conferences odd
        return "Tomorrow is minimum day, you will have odd periods. School will start at 8:00 and end at 12:28."
    case 10:
        //conferences even
        return "Tomorrow is minimum day, you will have even periods. School will start at 8:00 and end at 12:28."
    case 11:
        //PSAT 9
        return "Tomorrow is freshmen PSAT. Freshmen will start testing at 8:00and office hours will start at 10:54 for all students followed by even periods."
    case 12:
        //PE testing
        return "Tomorrow is freshmen PSAT. Freshmen will start testing at 8:30 and office hours will start at 10:54 for all students followed by odd periods."
        
    case 13:
        //first 2 days of school
        return "passed"
        
    case 14:
        // hour of code
        return "Tomorrow is hour of code. You will have advisement instead of office hours."
    case 15:
        //Passion Day
        return "Tomorrow is passion day. School will start at 8:00and end at 2:31."
    case 16:
        //Pre Testing
        return "Tomorrow is pre-testing schedule. School will start at 8:30, you will have period 1, 2, 3, 5 and 7."
    case 17:
        //Testing
        return "Tomorrow is sophomores and juniors testing. School will start at 8:00 for sophomores and juniors, and office hours will start at 10:54 for all students."
    case 18:
        //CAASPP odd
        return "Tomorrow is juniors CAASPP testing. School will start at 8:00 for juniors. Office hours start at 10:54 for all students followed by odd periods."
    case 19:
        //CAASPP even
        return "Tomorrow is juniors CAASPP testing. School will start at 8:00 for juniors. Office hours start at 10:54 for all students followed by even periods."
    case 20:
        //NO SCHOOL
        return "No school tomorrow! Enjoy your day off!"
    case 21:
        //fine arts assembly
        return "Tomorrow is fine arts assembly. School will start at 8:00 and end at 3:30."
    case 22:
        //monday schedule
        return "Tomorrow we will have Monday schedule."
    case 23:
        //tuesday schedule
        return "Tomorrow we will have Tuesday schedule."
    case 24:
        //wednesday schedule
        return "Tomorrow we will have Wednesday schedule."
    case 25:
        //thursday schedule
        return "Tomorrow we will have Thursday schedule."
    case 26:
        //friday schedule
        return "Tomorrow we will have Friday schedule."
    default:
        return "nothing"
    }
}



