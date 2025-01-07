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
            }
            
            
//            describe("onViewWillAppear") {
//                
//            }
//            
//            // Sample
//            it("has the correct default profile picture URL") {
//                expect(viewModel.profilePictureUrl).to(equal("https://picsum.photos/50/50"))
//            }
//
//            context("when loading playlists") {
//                it("should set myPlaylist to the playlists returned by PlaylistManager") {
//                    // Prepare mock data
//                    let mockPlaylists = MyPlaylistsModel(playlists: [PlaylistModel(name: "Test Playlist", songs: [])])
//                    mockPlaylistManager.mockPlaylists = mockPlaylists
//
//                    // Call method
//                    viewModel.loadMyPlaylists()
//
//                    // Verify
//                    expect(viewModel.myPlaylist).to(equal(mockPlaylists))
//                }
//            }
//
//            context("when saving a playlist") {
//                it("should call savePlaylist on PlaylistManager") {
//                    // Prepare mock playlist
//                    let testPlaylist = PlaylistModel(name: "Saved Playlist", songs: [])
//
//                    // Call method
//                    viewModel.onNeedToSavePlaylist(playlist: testPlaylist)
//
//                    // Verify
//                    expect(mockPlaylistManager.savedPlaylist).to(equal(testPlaylist))
//                }
//            }
        }
    }
}
