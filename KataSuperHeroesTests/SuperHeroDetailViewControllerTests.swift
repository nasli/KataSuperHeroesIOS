//
//  SuperHeroDetailViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Noelia Alvarez on 27/07/2017.
//  Copyright © 2017 GoKarumi. All rights reserved.
//

//
//  SuperHeroDetailViewControllerTests.swift
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

class SuperHeroDetailViewControllerTests: AcceptanceTestCase {
    
    fileprivate let repository = MockSuperHeroesRepository()
    
    func testShowsSuperHeroNameAsTitle() {
        let superHeroe = givenASuperHeroWithName()
        
        openSuperHeroDetailViewController(superHeroe.name)
        
        tester().waitForView(withAccessibilityLabel: superHeroe.name)
        
    }
    
    func testShowsSuperHeroName() {
        let superHero = givenASuperHeroWithName()
        
        openSuperHeroDetailViewController(superHero.name)
        
        tester().waitForView(withAccessibilityLabel: "Name: \(superHero.name)")
    }
    
    func testShowsSuperHeroDescription() {
        let superHero = givenASuperHeroWithName()
        
        openSuperHeroDetailViewController(superHero.name)
        
        tester().waitForView(withAccessibilityLabel: "Description: \(superHero.name)")
        
    }
    
    func testDoesNotShowAvengersBadgeIfTheHeroIsNotPartOfTheAvengersTeam() {
        let superHero = givenASuperHeroWithName()
        
        openSuperHeroDetailViewController(superHero.name)
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Avengers Badge")
    }
    
    func testShowsAvengersBadgeIfTheSuperHeroIsPartOfTheAvengersTeam() {
        let superHero = givenASuperHeroWithName(true)
        
        openSuperHeroDetailViewController(superHero.name)
        tester().waitForView(withAccessibilityLabel: "Avengers Badge")
    }
    
    func testDoesNotShowLoadingViewOnceSuperHeroHasBeenLoaded() {
 
        let superHero = givenASuperHeroWithName()
        
        openSuperHeroDetailViewController(superHero.name)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Loading View")
    }
    
    fileprivate func givenASuperHeroWithName(_ isAvenger: Bool = false) -> SuperHero {
        let superHero = SuperHero(name: "Mr. Clean",
                                  photo: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg"),
                                  isAvenger: isAvenger, description: "Description")
        repository.superHeroes = [superHero]
        return superHero
    }
    
    fileprivate func openSuperHeroDetailViewController(_ superHeroName: String) {
        let superHeroDetailViewController = ServiceLocator()
            .provideSuperHeroDetailViewController(superHeroName) as! SuperHeroDetailViewController
        superHeroDetailViewController.presenter = SuperHeroDetailPresenter(ui: superHeroDetailViewController,
                                                                           superHeroName: superHeroName,
                                                                           getSuperHeroByName: GetSuperHeroByName(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroDetailViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
    }
}

