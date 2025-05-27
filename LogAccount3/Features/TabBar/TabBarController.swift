import UIKit

class TabBarController: UITabBarController {

    // MARK: Components
    lazy var taskTabBar: UINavigationController = {
        // setup tabItem
        let title = "Task"
        let image = UIImage(systemName: "list.bullet.rectangle.portrait.fill")
        let tabItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        // setup rootViewController
        let rootViewController = TaskViewController()
        rootViewController.tabBarItem = tabItem
        rootViewController.tableView.reloadData()
        
        // setup navigationController
        let navController = UINavigationController(rootViewController: rootViewController)
        return navController
    }()
    
    lazy var profileTabBar: UINavigationController = {
        // setup tabItem
        let title = "Profile"
        let image = UIImage(systemName: "person.fill")
        let tabItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        // setup rootViewController
        let rootViewController = ProfileViewController()
        rootViewController.tabBarItem = tabItem
//        rootViewController.title = title
        
        // setup navigationController
        let navController = UINavigationController(rootViewController: rootViewController)
        return navController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .backgroundSecondary
        viewControllers = [taskTabBar, profileTabBar]
    }
    
}

