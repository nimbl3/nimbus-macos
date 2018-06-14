//
//  ApplicationPaths.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/3/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

struct Paths {
    
    #if RELEASE
    static let baseURL = "https://www.braive.com"
    #else
    static let baseURL = "https://staging.braive.com"
    #endif
    
    static let apiPath = "/api/v1"
    
    struct Authentication {
        
        static var token: String {
            return baseURL + "/api/oauth/token"
        }
        
        static var revoke: String {
            return baseURL + "/api/oauth/revoke"
        }
        
        static var resetPassword: String {
            return baseURL + apiPath + "/passwords"
        }
        
    }
    
    struct UserAccount {
        
        static var me: String { // swiftlint:disable:this identifier_name
            return baseURL + apiPath + "/me"
        }
        
        static var surveyScores: String {
            return baseURL + apiPath + "/k_survey_scores"
        }
        
        static var enrolledCourses: String {
            return baseURL + apiPath + "/courses"
        }
        
    }
    
    struct TreatmentProgram {
        
        static func course(id: String) -> String {
            return baseURL + apiPath + "/courses/\(id)"
        }
        
        static func lesson(id: String) -> String {
            return baseURL + apiPath + "/lessons/\(id)"
        }
        
        static func completeActivity(id: String) -> String {
            return baseURL + apiPath + "/activities/\(id)/complete"
        }
        
    }
    
}
