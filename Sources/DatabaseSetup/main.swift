import Foundation

import SwiftKueryPostgreSQL
import HeliumLogger
import LoggerAPI

import HistoryTable

// Using an implementation for a Logger
HeliumLogger.use(.info)

// Create a connection to use with PostgreSQL
let connection = PostgreSQLConnection(host: "localhost", port: 5432,
                                      options: [.databaseName("postgres")])

connection.connect() { error in
    guard error == nil else {
        Log.error("Failed to connect to the database. Error=\(String(describing: error))")
        return
    }
    
    HistoryTableHelper.createTable(connection: connection) { error in
        guard error == nil else { return }
        
        HistoryTableHelper.createIndex(connection: connection) { error in
        }
    }
}
