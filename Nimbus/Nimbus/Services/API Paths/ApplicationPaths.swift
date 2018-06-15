//
//  ApplicationPaths.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/3/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

struct Paths {
    
    struct PivotalTracker {
        
        static var me: String {
            return pivotalTracker(path: "me")
        }
        
        static func stories(ofProjectId projectId: Int) -> String {
            return pivotalTracker(path: "projects/\(projectId)/stories")
        }
        
        // MARK: - private helper
        
        static var baseUrl: String {
            return "https://www.pivotaltracker.com"
        }
        
        private static func pivotalTracker(path: String) -> String {
            return "\(baseUrl)/services/v5/\(path)"
        }
        
    }
    
}
