//
//  CounterFeature.swift
//  eTagApp
//
//  Created by Macbook on 31/05/24.
//


import ComposableArchitecture

@Reducer
struct CounterFeature {
  @ObservableState
  struct State: Equatable {
    var count = 0
    var isEnabled = true
    var items: [String] = ["agung", "rani"]
  }

  enum Action {
    case decrementButtonTapped
    case incrementButtonTapped
    case toggleEnabled
    case addItem(String)
    case editItem(at: Int, item: String)
    case removeItem(at: Int)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .decrementButtonTapped:
        state.count -= 1
        return .none
      case .incrementButtonTapped:
        state.count += 1
        return .none
      case .toggleEnabled:
        state.isEnabled.toggle()
        return .none
      case .addItem(let item):
        state.items.append(item)
        return .none
      case .editItem(let index, let item):
        guard state.items.indices.contains(index) else { return .none }
        state.items[index] = item
        return .none
      case .removeItem(let index):
        guard state.items.indices.contains(index) else { return .none }
        state.items.remove(at: index)
        return .none
      }
    }
  }
}
