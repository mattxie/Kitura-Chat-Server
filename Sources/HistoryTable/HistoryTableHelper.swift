/**
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import SwiftKuery
import LoggerAPI

public class HistoryTableHelper_v0 {
    public static func createTable(connection: Connection, onCompletion: @escaping (Error?) -> Void) {
        let chatHistory = HistoryTable_v0()
        _ = chatHistory.primaryKey(chatHistory.user, chatHistory.time)
        
        do {
            let description = try chatHistory.description(connection: connection)
            print("About to execute the SQL statement:\n    ", description)
            
            chatHistory.create(connection: connection) { result in
                if let error = result.asError {
                    Log.error("Failed to create the ChatHistory table. Error=\(error)")
                }
                onCompletion(result.asError)
            }
        }
        catch {
            onCompletion(error)
        }
    }
    
    public static func createIndex(connection: Connection, onCompletion: @escaping (Error?) -> Void) {
        let chatHistory = HistoryTable_v0()
        let index = Index("ChatHistoryIndex", on: chatHistory, columns: [asc(chatHistory.time)])
        
        do {
            let description = try index.description(connection: connection)
            print("About to execute the SQL statement:\n    ", description)
            
            index.create(connection: connection) { result in
                if let error = result.asError {
                    Log.error("Failed to create the ChatHistory index. Error=\(error)")
                }
                onCompletion(result.asError)
            }
        }
        catch {
            onCompletion(error)
        }
    }
}

public typealias HistoryTableHelper = HistoryTableHelper_v0
