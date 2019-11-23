//
//  AssemblyTests.swift
//  ImageDownloaderTests
//
//  Created by Вика on 23/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest

class AssemblyTests: XCTestCase {
    
    var assembly: Assembly!
    
    override func setUp() {
        assembly = Assembly()
    }
    
    override func tearDown() {
        assembly = nil
    }
    
    func testThatAssemblyCreatesScreen() {
        // act
        let view = assembly.createScreen() as! ViewController
        
        // assert
        let presenter = view.presenter as! Presenter
        let router = presenter.router as! Router
        let interactor = presenter.interactor as! Interactor
        let networkService = interactor.networkService as! NetworkService
        let dataValidator = interactor.validator as! DataValidator
        let cacheService = interactor.cacheService as! DiskCache
        let urlProvider = interactor.urlProvider as! URLProvider
        
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(router)
        XCTAssertNotNil(interactor)
        XCTAssertNotNil(networkService)
        XCTAssertNotNil(dataValidator)
        XCTAssertNotNil(cacheService)
        XCTAssertNotNil(urlProvider)
        
        XCTAssertTrue(presenter.view === view)
        XCTAssertTrue(interactor.presenter === presenter)
        XCTAssertTrue(networkService.delegate === interactor)
        XCTAssertTrue(cacheService.delegate === interactor)
        XCTAssertTrue(router.viewController === view)
    }
}
