//
//  DatabaseManager.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 25/07/21.
//

import Foundation
import SQLite

protocol Salvavel {
    static func criaTabela()
//    static func listaDoBanco() -> [Salvavel]
    static func countNoBanco() throws -> Int
    func insereNoBanco() throws
    func atualizaNoBanco() throws
    func apagaNoBanco() throws
    
}

class DatabaseManager: NSObject {
    
    static let applicationDocumentsDirectory = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("db.sqlite3").absoluteString;
    }()
    
//    static func applicationDataDirectory() -> URL {
//        let fileManager = FileManager.default
//        let possibleURLs = fileManager.urls(for: .applicationDirectory, in: .userDomainMask)
//
//        var appSupportDir: URL?
//        var appDirectory = URL(fileURLWithPath: "\(applicationDocumentsDirectory!.absoluteString)/db.sqlite3")
//        if possibleURLs.count >= 1 {
//            appSupportDir = possibleURLs.first
//        }
//        if let appSupportDir = appSupportDir {
//            let appBundleID = Bundle.main.bundleIdentifier
//            appDirectory = appSupportDir.appendingPathComponent(appBundleID!).appendingPathComponent("db.sqlite3")
//        }
//
//        return appDirectory
//    }
    
//    - (NSURL*)applicationDataDirectory {
//        NSFileManager* sharedFM = [NSFileManager defaultManager];
//        NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory
//                                     inDomains:NSUserDomainMask];
//        NSURL* appSupportDir = nil;
//        NSURL* appDirectory = nil;
//
//        if ([possibleURLs count] >= 1) {
//            // Use the first directory (if multiple are returned)
//            appSupportDir = [possibleURLs objectAtIndex:0];
//        }
//
//        // If a valid app support directory exists, add the
//        // app's bundle ID to it to specify the final directory.
//        if (appSupportDir) {
//            NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
//            appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
//        }
//
//        return appDirectory;
//    }
    
    
    static let db: Connection = {
        let connection = try! Connection(applicationDocumentsDirectory)
        return connection
    }()
}
