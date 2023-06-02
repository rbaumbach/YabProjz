# Weatherz

This project serves as a practice project with various "controls," patterns and iOS usage.

## Motivation

There have been various times during interviews where you will be either creating a "toy" project, or expected to append/change a current project to evaluate knowledge.  The motiviation for this particular project is to exhaust a list of concepts as well as usage of various iOS items.

I would like to mention that the purpose of this project is to remind myself of certain APIs or patterns that I use (or normally used) to stay fresh mentially.  This means that this project won't follow too many best practices or necessarily won't represent how I'd write production quality code.

## Item/Concept Checklist

- [x] Initial project creation
- [x] Storyboards
  - [x] Changing "Main" Storyboard to something else
  - [x] Using basic "controls"
  - [x] Using basic constraints
  - [x] "Wiring Up" `IBOutlets` and `IBActions`
  - [x] Programmatically present/dismiss (Modal) a Storyboard
  - [x] Present/dismiss a Storyboard (Modal) via Interface Builder
  - [x] Programmatically "push/pop" (Navigation Controller) a Storyboard
  - [x] "Push/Pop" (Navigation Controller) a Storyboard via Interface Builder
  - [x] Use a `UITableViewController` (static content)
  - [x] Use prepareForSegue
- [x] Use MVC
- [x] Use a child view controller
- [x] Use a ViewModel (MVVM)
- [x] Use a `UITableView`
- [ ] Use a `UICollectionView`
- [x] Use delegate pattern
- [x] Create delegate pattern for custom structure
- [x] Create an async method/function/manager
- [x] Use an activity monitor with async functionality
- [x] Create pattern for handling constants
- [x] Deal with a http (not https) using domain exception with `NSAppTransportSecurity`
- [x] Create generic function
- [x] Use `NotificationCenter`
- [x] Use a random number generator
- [x] Create a custom `UIView`
- [x] API
  - [x] Use `URLSession`
  - [x] Create response models
  - [x] Manually serialize a request
  - [x] Manually deserialize a response
  - [x] Use Codable with mismatching response data to model data
  - [x] Create a request with some headers
  - [x] Create error handling
  - [x] Create network service
- [ ] Dependency Injection
  - [x] Use "constructor" injection
  - [x] Use property injection
  - [ ] Use method injection
- [ ] Persistence
  - [x] Use `UserDefaults`
  - [x] Persist custom structure in `UserDefaults` (`Codable`)
  - [x] Persist custom structure using Data type and `Codable`
  - [ ] Persist data in Keychain
- [x] Higher Order Functions
  - [x] Use `map`
  - [x] Use `reduce`
  - [x] Use `forEach`
  - [x] Use `filter`
  - [x] Use `compactMap`
  - [x] Use `sort` or `sorted`
- [x] Unit Testing
  - [x] Test a model
  - [x] Test a view controller
  - [x] Test a view
  - [x] Test a view model
  - [x] Test an async method
  - [x] Test usage of a `DispatchQueue`
  - [x] Mock out AppDelegate
  - [x] Mock out a Foundation API using extensions
  - [x] Mock out a Foundation API creating a wrapper