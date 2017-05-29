import LoggerAPI
import SwiftKuery
import SwiftKueryPostgreSQL

import HistoryTable

import Foundation

class ChatHistory {
    
    let historyTable = HistoryTable()
    let pool: ConnectionPool
    var connected = false
    
    init() {
        let envVars = ProcessInfo.processInfo.environment
        let postgresHost = envVars["POSTGRES_HOST"] ?? "localhost"
        
        let poolOptions = ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 30, timeout: 10000)
        pool = PostgreSQLConnection.createPool(url: URL(string: "Postgres://postgres:kitura@" + postgresHost + ":5432")!, poolOptions: poolOptions)
    }
    
    func getChatHistory(callback: @escaping([[String:Any?]]?)->()) {
        if let connection = pool.getConnection() {
            let s = Select(from: historyTable).order(by: .ASC(historyTable.time))
            s.execute(connection) { result in
                if let rows = result.asRows {
                    callback(rows)
                }
                else {
                    callback(nil)
                }
            }
        }
        else {
            Log.error("Failed to connect to the database")
            callback(nil)
        }
    }
    
    func save(message: String, user: String, time: Date) {
        if let connection = pool.getConnection() {
            let i = Insert(into: historyTable, values: Parameter(), time, Parameter())
            i.execute(connection, parameters: [user, message]) { result in
                if let error = result.asError {
                    Log.error("Failed to save the message to the database: \(error)")
                }
            }
        }
        else {
            Log.error("Failed to connect to the database")
        }
    }
    
    func getTopChatter(callback: @escaping(String?)->()) {
        if let connection = pool.getConnection() {
            let s = Select(historyTable.user, from: historyTable)
                .group(by: historyTable.user)
                .order(by: .DESC(count(historyTable.message)))
                .limit(to: 1)
                .offset(0)
            s.execute(connection) { result in
                if let rows = result.asRows, rows.count == 1 {
                    callback(rows[0]["user"] as? String)
                }
                else {
                    callback(nil)
                }
            }
        }
        else {
            Log.error("Failed to connect to the database")
            callback(nil)
        }
    }
    
    func getUsers(callback: @escaping([String]?)->()) {
        if let connection = pool.getConnection() {
            let s = Select.distinct(historyTable.user, from: historyTable)
            s.execute(connection) { result in
                if let rows = result.asRows {
                    var users = [String]()
                    for row in rows {
                        users.append(row["user"]! as! String)
                    }
                    callback(users)
                }
                else {
                    callback(nil)
                }
            }
        }
        else {
            Log.error("Failed to connect to the database")
            callback(nil)
        }
    }
}
