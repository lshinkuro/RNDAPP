//
//  FetchDataFeature.swift
//  eTagApp
//
//  Created by Macbook on 04/06/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FetchDataFeature {


  @ObservableState
  struct State: Equatable {
    static func == (lhs: FetchDataFeature.State, rhs: FetchDataFeature.State) -> Bool {
      return false
    }
    
    var data: [PlaceHolderElement] = []
    var isLoading: Bool = false
    var errorMessage: String?
  }

  enum Action {
    case fetchStories
    case fetchStoriesResponse(Result<[PlaceHolderElement], Error>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchStories:
        state.isLoading = true
        return .run { send in
          let result = await withCheckedContinuation { continuation in
            APIManager.shared.fetchRequest(endpoint: .news, expecting: [PlaceHolderElement].self) { result in
              continuation.resume(returning: result)
            }
          }
          return await send(.fetchStoriesResponse(result))
        }

      case let .fetchStoriesResponse(result):
        state.isLoading = false
        switch result {
        case let .success(stories):
          state.data = stories
        case let .failure(error):
          // Handle error (e.g., keep existing data or display error message)
          print("Error fetching stories: \(error.localizedDescription)")
        }
        return .none
      }
    }
  }

}
