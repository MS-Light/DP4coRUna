//
//  database.swift
//  DP4coRUna
//
//  Created by User on 8/5/20.
//

import Foundation
import SQLite3

class DB{
    init(){
        db = openDatabase()
        createTable()
    }
    
    let dbPath:String = "myDb.sqlite"
    var db:OpaquePointer?
    
    func openDatabase()->OpaquePointer?{
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false).appendingPathComponent(dbPath)
        
        var db:OpaquePointer?=nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else{
            print("success")
            return db
        }
    }
    
   func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS training_data(id INTEGER PRIMARY KEY,ssid TEXT,strength INTEGER, soundlevel INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("training_data table created.")
            } else {
                print("training_data table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
}


