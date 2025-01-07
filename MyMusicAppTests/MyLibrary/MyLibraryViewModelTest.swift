//
//  MyLibraryViewModelTest.swift
//  MyMusicAppTests
//
//  Created by Titus Logo on 20/12/24.
//

import Nimble
import Quick
import Testing
@testable import MyMusicApp

final class MyLibraryViewModelSpec: QuickSpec {
    override class func spec() {
        // MARK: Properties
        var viewModel: MyLibraryViewModelProtocol!
        var actionMock: MyLibraryViewModelActionMock!
        var fetcherMock: UserProfileFetcherMock!
        
//        var mockPlaylistManager: MockPlaylistManager!

        let userProfileSuccessData: UserModel = JSONHelper.readJSON(
            from: "UserModelSuccess",
            type: UserModel.self
        )!
        
        beforeEach {
            // Initialize MockPlaylistManager and ViewModel
//            mockPlaylistManager = MockPlaylistManager()
//            PlaylistManager.shared = mockPlaylistManager
            
            actionMock = MyLibraryViewModelActionMock()
            fetcherMock = UserProfileFetcherMock()
            
            let dependency: MyLibraryViewModelDependency = MyLibraryViewModelDependency(userProfileFetcher: fetcherMock)
            viewModel = MyLibraryViewModel(dependency: dependency)
            viewModel.action = actionMock
        }

        describe("MyLibraryViewModelTest") {
            
            describe("onViewDidLoad") {
                context("API Call Success") {
                    it("should call all functions") {
                        viewModel.onViewDidLoad()
                        
                        expect(viewModel.userProfile).toNot(beNil())
                        expect(viewModel.userProfile?.username).to(equal(userProfileSuccessData.username))
                        expect(viewModel.userProfile?.id).to(equal(userProfileSuccessData.id))
                        expect(viewModel.userProfile?.profilePictureUrl).to(equal(userProfileSuccessData.profilePictureUrl))
                        
                        expect(actionMock.isNotifyToSetupUserProfileCalled).to(beTrue())
                        expect(actionMock.isNotifyToShowErrorCalled).to(beFalse())
                        expect(actionMock.notifyToShowErrorMessage).to(beNil())
                    }
                }
                
                context("API Call Success, response is nil") {
                    it("should hit exception handling") {
                        fetcherMock.serviceState = .successNil
                        viewModel.onViewDidLoad()
                        
                        expect(viewModel.userProfile).to(beNil())
                        expect(viewModel.userProfile?.username).to(beNil())
                        expect(viewModel.userProfile?.id).to(beNil())
                        expect(viewModel.userProfile?.profilePictureUrl).to(beNil())
                        
                        expect(actionMock.isNotifyToSetupUserProfileCalled).to(beFalse())
                        expect(actionMock.isNotifyToShowErrorCalled).to(beTrue())
                        expect(actionMock.notifyToShowErrorMessage).to(equal(ServiceManager.defaultErrorMessage))
                    }
                }
                
                context("API Call Failed") {
                    it("should go to error route") {
                        fetcherMock.serviceState = .failure
                        viewModel.onViewDidLoad()
                        
                        expect(viewModel.userProfile).to(beNil())
                        expect(viewModel.userProfile?.username).to(beNil())
                        expect(viewModel.userProfile?.id).to(beNil())
                        expect(viewModel.userProfile?.profilePictureUrl).to(beNil())
                        
                        expect(actionMock.isNotifyToSetupUserProfileCalled).to(beFalse())
                        expect(actionMock.isNotifyToShowErrorCalled).to(beTrue())
                        expect(actionMock.notifyToShowErrorMessage).to(equal(ServiceManager.defaultErrorMessage))
                    }
                }
                
                context("API Call Failed, errorMessage nil") {
                    it("should go to error route") {
                        fetcherMock.serviceState = .failureNil
                        viewModel.onViewDidLoad()
                        
                        expect(viewModel.userProfile).to(beNil())
                        expect(viewModel.userProfile?.username).to(beNil())
                        expect(viewModel.userProfile?.id).to(beNil())
                        expect(viewModel.userProfile?.profilePictureUrl).to(beNil())
                        
                        expect(actionMock.isNotifyToSetupUserProfileCalled).to(beFalse())
                        expect(actionMock.isNotifyToShowErrorCalled).to(beTrue())
                        expect(actionMock.notifyToShowErrorMessage).to(equal(ServiceManager.defaultErrorMessage))
                    }
                }
            }
        }
    }
}
