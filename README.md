### 
Project Structre 

The project structure is inspired by a mixture of the CleanRxSwift architecture (https://github.com/sergdort/CleanArchitectureRxSwift) and the open source Kickstarter project (https://github.com/kickstarter/ios-oss). 

The project is split up into 3 targets (excluding testing targets): 

##
1. Domain -
The Domain is the model layer of the application. It does not depend on UIKit or any persistence framework, and it doesn't have implementations apart from entities (i.e. models). 

##
2. Library -
The Libray is a concrete implementation of the Domain. It holds the networking/database layers, business logic for all scenes (i.e. View Models), and utility classes. It hides all implementation details from the application specific layer.

##
3. Application - 
The application (i.e. view layer) is built for a specific platform like iOS. It is responsible for delivering information to the user and handling user input. The develivery pattern follows MVVM, and view controllers know nothing about the details of their respective view models. 

### 
Project Configuration 

The Application target has 3 schemes:
1. Development 
2. Staging 
3. Production 

Each scheme points to a different build configruation file (.xcconfig) that specifies all custom build settings for the specific environment (i.e. Server URL). 

If there were real staging/production servers, then running the staging/production schemes would have the application use the Library/APIService/NetworkService.swift file to fetch data from the server. 

When running the development scheme, the application points to Library/APIService/MockNetworkService.swift for fetching data which uses mocked JSON responses specified in .json files for each endpoint. 

### 
App Architecture 

The archiceture follows MVVM+Coordinator pattern. Coordinators are simplily UIViewController's which typically embed either a UINavgiationController or a UITabBarController. 