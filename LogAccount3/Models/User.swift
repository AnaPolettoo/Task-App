import Foundation

struct User: Codable {
    var id = UUID()
    let name: String
    let dateOfBirth: Date
    let email: String
    let password : String
    let terms: Bool
    var userTaskList: [Task] = []
}
    

