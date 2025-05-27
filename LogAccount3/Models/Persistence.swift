//
//  Persistence.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 06/05/25.
//
import Foundation

struct Persistence {
    
    private static let usersKey = "usersList"
    public static let userLog = "loggedUserEmail"
    
    static func getUsersList() -> [User]? {
        
        if let data = UserDefaults.standard.value(forKey: usersKey) as? Data {
            
            do {
                let usersList = try JSONDecoder().decode([User].self, from: data)
                return usersList
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    

    static func getLoggedUser() -> User? {
        
        if let data = UserDefaults.standard.value(forKey: userLog) as? Data {
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
                
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func saveLoggedUser(_ user: User?) {
        
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.setValue(data, forKey: userLog)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    static func saveUser(newUser: User) {
        
        var usersList = getUsersList() ?? []
        let user = getLoggedUser()
        
        if let loggedUser = user {
            usersList.removeAll(where: { $0.email == loggedUser.email })
        }
        
        usersList.append(newUser)
        
        do {
            let data = try JSONEncoder().encode(usersList)
            UserDefaults.standard.setValue(data, forKey: usersKey)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    static func loginUser(email: String, password: String) -> Bool {
        
        guard let usersList = getUsersList() else { return false }
        
        if usersList.contains(where: { $0.email == email && $0.password == password }) {
            return true
        }
        return false
    }
    
    static func deleteUser() {
        guard let user = getLoggedUser() else { return }
        guard var usersList = getUsersList() else { return  }
        
        usersList.removeAll(where: { $0.id == user.id })
        
        do {
            let data = try JSONEncoder().encode(usersList)
            UserDefaults.standard.setValue(data, forKey: usersKey)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    static func deleteTask(by id: UUID) {
        if var user = getLoggedUser(){
            user.userTaskList.removeAll(where: { $0.id == id })
            saveLoggedUser(user)
        }
    }
    

    
    static func toggleTaskStatus(by id: UUID) {
        guard var user = getLoggedUser() else { return }
        
        guard let taskIndex = user.userTaskList.firstIndex(where: { $0.id == id }) else { return }
        
        user.userTaskList[taskIndex].isDone.toggle()
        saveLoggedUser(user)
        
//        let _ = user.userTaskList[taskIndex]
        
    }
}

