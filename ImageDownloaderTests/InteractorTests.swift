//
//  InteractorTests.swift
//  ImageDownloaderTests
//
//  Created by Вика on 23/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import XCTest
@testable import ImageDownloader

class NetworkServiceMock: NetworkServiceProtocol {
    
    private(set) var downloads = [URL]()
    
    func downloadData(from url: URL) {
        downloads.append(url)
    }
}

class URLProviderMock: URLProviderProtocol {
    var imageURL: URL?
}

class CacheServiceMock: CacheServiceProtocol {
    
    var clearCounter = 0
    func clear() {
        clearCounter += 1
    }
    
    private(set) var savedData = [Data]()
    func save(data: Data) {
        savedData.append(data)
    }
    
    var retrieveDataCounter = 0
    func retrieveData() {
        retrieveDataCounter += 1
    }
}

class DataValidatorMock: DataValidatorProtocol {
    var validData: Data?
    var validateCounter = 0
    func validate(data: Data) -> Bool {
        validateCounter += 1
        return data == validData
    }
}

class PresenterMock: InteractorOutput {
    var didDownloadCorrectDataCounter = 0
    func didDownloadCorrectData() {
        didDownloadCorrectDataCounter += 1
    }
    
    private(set) var handledError = [Error]()
    
    func handle(error: Error) {
        handledError.append(error)
    }
    
    private(set) var handledData = [Data]()
    
    func handle(data: Data) {
        handledData.append(data)
    }
    
    var hideImageCounter = 0
    func hideImage() {
        hideImageCounter += 1
    }
}

class InteractorTests: XCTestCase {
    
    var interactor: Interactor!
    
    var networkService: NetworkServiceMock!
    var urlProvider: URLProviderMock!
    var cacheService: CacheServiceMock!
    var dataValidator: DataValidatorMock!
    var presenter: PresenterMock!

    override func setUp() {
        networkService = NetworkServiceMock()
        urlProvider = URLProviderMock()
        cacheService = CacheServiceMock()
        dataValidator = DataValidatorMock()
        presenter = PresenterMock()
        
        interactor = Interactor(networkService: networkService,
                                urlProvider: urlProvider,
                                cacheService: cacheService,
                                validator: dataValidator)
        interactor.presenter = presenter
    }

    override func tearDown() {
        networkService = nil
        urlProvider = nil
        cacheService = nil
        dataValidator = nil
        presenter = nil
        
        interactor = nil
    }
    
    func testThatInteractorDownloadsImageFromCorrectURL() {
        // arrange
        let url = URL(string: "https://google.com/img.jpeg")!
        urlProvider.imageURL = url
        
        // act
        interactor.downloadImage()
        
        // assert
        XCTAssertEqual(networkService.downloads, [url])
    }
    
    func testThatInteractorDoesntDownloadImageFromIncorrectURL() {
        // arrange
        urlProvider.imageURL = nil
        
        // act
        interactor.downloadImage()
        
        // assert
        XCTAssertEqual(networkService.downloads, [])
    }
    
    func testThatInteractorClearsCacheAndHidesImage() {
        // act
        interactor.clearCache()
        
        // assert
        XCTAssertEqual(cacheService.clearCounter, 1)
        XCTAssertEqual(presenter.hideImageCounter, 1)
    }
    
    func testThatInteractorRetrievesImageFromCache() {
        // act
        interactor.retrieveImageFromCache()
        
        // assert
        XCTAssertEqual(cacheService.retrieveDataCounter, 1)
    }
    
    func testThatInteractorPassesDataFromCacheToPresenter() {
        // arrange
        let data = Data()
        
        // act
        interactor.cacheService(service: cacheService, didRetrieve: data)
        
        // assert
        XCTAssertEqual(presenter.handledData, [data])
        XCTAssertTrue(presenter.handledError.isEmpty)
    }
    
    func testThatInteractorPassesErrorForEmptyDataFromCache() {
        // act
        interactor.cacheService(service: cacheService, didRetrieve: nil)
        
        // assert
        XCTAssertEqual(presenter.handledError as? [Interactor.CustomError], [Interactor.CustomError.emptyCache])
        XCTAssertTrue(presenter.handledData.isEmpty)
    }
    
    func testThatInteractorSavesDataInCache() {
        // arrange
        let data = "data".data(using: .utf8)!
        dataValidator.validData = data
        
        // act
        interactor.networkService(service: networkService, didLoad: data)
        
        // assert
        XCTAssertEqual(dataValidator.validateCounter, 1)
        XCTAssertEqual(cacheService.savedData, [data])
        XCTAssertEqual(presenter.didDownloadCorrectDataCounter, 1)
        XCTAssertTrue(presenter.handledError.isEmpty)
    }
    
    func testThatInteractorPassesErrorForInvalidData() {
        // arrange
        let data = "data".data(using: .utf8)!
        dataValidator.validData = nil
        
        // act
        interactor.networkService(service: networkService, didLoad: data)
        
        // assert
        XCTAssertEqual(dataValidator.validateCounter, 1)
        XCTAssertEqual(presenter.handledError as? [Interactor.CustomError], [Interactor.CustomError.downloadedWrongData])
        XCTAssertTrue(cacheService.savedData.isEmpty)
        XCTAssertEqual(presenter.didDownloadCorrectDataCounter, 0)
    }
    
    func testThatInteractorPassesError() {
        // arrange
        enum CustomError: Error {
            case error
        }
        
        // act
        interactor.networkService(service: networkService, didFailWith: CustomError.error)
        
        // assert
        XCTAssertEqual(presenter.handledError.count, 1)
        XCTAssertTrue(presenter.handledError.first as? CustomError == CustomError.error)
    }
    
    func testThatAllCustomErrorsHasDescription() {
        // arrange
        let errors =  [
            Interactor.CustomError.downloadedWrongData,
            Interactor.CustomError.emptyCache
        ]
        
        // act
        let descriptions = errors.map { $0.errorDescription }
        
        // assert
        XCTAssertFalse(descriptions.contains(nil))
    }
}
