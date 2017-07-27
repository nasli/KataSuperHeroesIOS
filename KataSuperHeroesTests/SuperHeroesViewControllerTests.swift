//
//  SuperHeroesViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 13/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroesViewControllerTests: AcceptanceTestCase {

    fileprivate let repository = MockSuperHeroesRepository()
 
    func testShowsEmptyCaseIfThereAreNoSuperHeroes() {
        givenThereAreNoSuperHeroes()

        openSuperHeroesViewController()

        tester().waitForView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    func testNoShowsEmptyCaseIfThereAreSuperHeroes() {
        givenThereAreSomeSuperHeroes(6, avengers: false)
        
        openSuperHeroesViewController()
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    func testShowsExactSuperHeroesGivenSomeSuperHeroes() {
        givenThereAreSomeSuperHeroes(6, avengers: false)
        
        openSuperHeroesViewController()
        
        let tableView = tester().waitForView(withAccessibilityLabel: "SuperHeroesTableView") as! UITableView
        
        expect(tableView.numberOfRows(inSection: 0)).to(equal(6))
    }
    
    func testNoShowsLoadingWhenWeHaveData() {
        givenThereAreSomeSuperHeroes(6, avengers: false)
        
        openSuperHeroesViewController()
        
        let tableView = tester().waitForView(withAccessibilityLabel: "SuperHeroesTableView") as! UITableView
        if tableView.numberOfRows(inSection: 0) == 0 {
            tester().waitForView(withAccessibilityLabel: "loading")
        } else {
            tester().waitForAbsenceOfView(withAccessibilityLabel: "loading")
        }
    }
    
    func testShowsThatTheHeroesInTheListHasTheCorrectName () {
        let superHeros = givenThereAreSomeSuperHeroes()
        
        openSuperHeroesViewController()
        
        for superHero in superHeros {
            tester().waitForView(withAccessibilityLabel: superHero.name)
        }
    }
    
    func testShowsThatTheHeroesInTheListAreAvengers () {
        let superHeroes = givenThereAreSomeSuperHeroes(10, avengers: true)
        
        openSuperHeroesViewController()
        
        for superHero in superHeroes {
            
            tester().waitForView(withAccessibilityLabel:"\(superHero.name) - Avengers Badge")
        }
    }
    
    func testShowsThatTheHeroesInTheListAreNotAvengers () {
        let superHeroes = givenThereAreSomeSuperHeroes(10, avengers: false)
        
        openSuperHeroesViewController()
        
        for superHero in superHeroes {
            
            tester().waitForAbsenceOfView(withAccessibilityLabel:"\(superHero.name) - Avengers Badge")
        }
    }
    
    func testShowsThatTheEvenHeroesInTheListAreNotAvengers () {
        let superHeroes = givenThereAreSomeSuperHeroes(10, avengers: true)
        
        openSuperHeroesViewController()
        
        var evens: [SuperHero] = []
        for i in 0...superHeroes.count-1 where i % 2 == 0 {
            evens.append(superHeroes[i])
        }
        
        for superHero in evens {
            tester().waitForView(withAccessibilityLabel: "\(superHero.name) - Avengers Badge")
        }
    }
    
    func testShowsThatTheOddHeroesInTheListAreNotAvengers () {
        let superHeroes = givenThereAreSomeSuperHeroes(10, avengers: true)
        
        openSuperHeroesViewController()
        
        var odds: [SuperHero] = []
        for i in 0...superHeroes.count-1 where i % 2 == 1 {
            odds.append(superHeroes[i])
        }
        
        for superHero in odds {
            tester().waitForView(withAccessibilityLabel: "\(superHero.name) - Avengers Badge")
        }
    }

    func testNavigateToDetailSuperHeroes() {
        let superheroes = givenThereAreSomeSuperHeroes(10, avengers: true)
        
        openSuperHeroesViewController()

        let tableView = tester().waitForView(withAccessibilityLabel: "SuperHeroesTableView") as! UITableView
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        tester().tapRow(at: indexPath, in: tableView)
        tester().waitForView(withAccessibilityLabel: superheroes[0].name)
    }
    
    fileprivate func givenThereAreNoSuperHeroes() {
        _ = givenThereAreSomeSuperHeroes(0)
    }

    fileprivate func givenThereAreSomeSuperHeroes(_ numberOfSuperHeroes: Int = 10,
        avengers: Bool = false) -> [SuperHero] {
        var superHeroes = [SuperHero]()
        for i in 0..<numberOfSuperHeroes {
            let superHero = SuperHero(name: "SuperHero - \(i)",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg") as URL?,
                isAvenger: avengers, description: "Description - \(i)")
            superHeroes.append(superHero)
        }
        repository.superHeroes = superHeroes
        return superHeroes
    }

    fileprivate func openSuperHeroesViewController() {
        let superHeroesViewController = ServiceLocator()
            .provideSuperHeroesViewController() as! SuperHeroesViewController
        superHeroesViewController.presenter = SuperHeroesPresenter(ui: superHeroesViewController,
                getSuperHeroes: GetSuperHeroes(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroesViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
    }
}
