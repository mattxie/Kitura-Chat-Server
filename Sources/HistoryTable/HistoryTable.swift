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

public class HistoryTable_v0: Table {
    let tableName = "ChatHistory"
        
    public let user = Column("\"user\"", Varchar.self, length: 50)
    public let time = Column("time", Timestamp.self)
    public let message = Column("message", Varchar.self, length: 1500)
}

public typealias HistoryTable = HistoryTable_v0
