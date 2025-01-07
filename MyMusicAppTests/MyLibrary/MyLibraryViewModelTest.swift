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
        var playlistManagerMock: PlaylistManagerMock!

        // MARK: Mock Data
        let userProfileSuccessData: UserModel = JSONHelper.readJSON(
            from: "UserModelSuccess",
            type: UserModel.self
        )!
        
        let mockSongNumb: MediaItem = MediaItem(
            trackName: "Numb",
            artistName: "LINKIN PARK",
            collectionName: "Meteora",
            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/dd/7d/72/dd7d7259-d27f-5b3e-ce64-9e304d2cb40f/dj.rxzrauer.jpg/100x100bb.jpg"
        )
        
        let mockSongHelena: MediaItem = MediaItem(
            trackName: "Helena",
            artistName: "My Chemical Romance",
            collectionName: "May Death Never Stop You (Deluxe Version)",
            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/27/86/b2/2786b235-e506-668a-76db-1e10ffe651a5/093624938330.jpg/100x100bb.jpg"
        )
        
        beforeEach {            
            actionMock = MyLibraryViewModelActionMock()
            fetcherMock = UserProfileFetcherMock()
            playlistManagerMock = PlaylistManagerMock()
            
            let dependency: MyLibraryViewModelDependency =
            MyLibraryViewModelDependency(userProfileFetcher: fetcherMock, playlistManager: playlistManagerMock)
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
            
            describe("onViewWillAppear") {
                it("should call all functions") {
                    viewModel.onViewWillAppear()
                    expect(playlistManagerMock.isLoadAllPlaylistsCalled).to(beTrue())
                }
            }
            
            describe("onNeedToSavePlaylist") {
                let playlistName: String = "Red."
                
                it("should call all functions") {
                    let mockPlaylist: PlaylistModel = PlaylistModel(name: playlistName, songs: [mockSongNumb, mockSongHelena])
                    viewModel.onNeedToSavePlaylist(playlist: mockPlaylist)
                    
                    expect(playlistManagerMock.isSavePlaylistCalled).to(beTrue())
                    expect(playlistManagerMock.savedPlaylistData?.name).to(equal(playlistName))
                    
                    expect(playlistManagerMock.savedPlaylistData?.songs[0].trackName).to(equal(mockSongNumb.trackName))
                    expect(playlistManagerMock.savedPlaylistData?.songs[0].artistName).to(equal(mockSongNumb.artistName))
                    expect(playlistManagerMock.savedPlaylistData?.songs[0].collectionName).to(equal(mockSongNumb.collectionName))
                    expect(playlistManagerMock.savedPlaylistData?.songs[0].artworkUrl100).to(equal(mockSongNumb.artworkUrl100))
                    
                    expect(playlistManagerMock.savedPlaylistData?.songs[1].trackName).to(equal(mockSongHelena.trackName))
                    expect(playlistManagerMock.savedPlaylistData?.songs[1].artistName).to(equal(mockSongHelena.artistName))
                    expect(playlistManagerMock.savedPlaylistData?.songs[1].collectionName).to(equal(mockSongHelena.collectionName))
                    expect(playlistManagerMock.savedPlaylistData?.songs[1].artworkUrl100).to(equal(mockSongHelena.artworkUrl100))
                }
            }
        }
    }
}
