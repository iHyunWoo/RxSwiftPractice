//
//  FruitReactor.swift
//  ReactorKitTutorial
//
//  Created by 정현우 on 2023/01/26.
//

import ReactorKit

class FruitReactor: Reactor {
	// MARK: Actions
	enum Action {
		case apple
		case banana
		case grape
	}
	
	// MARK: State
	struct State {
		var fruitName: String
		var isLoading: Bool
	}
	
	// MARK: Mutations
	enum Mutation {
		case changeLabelApple
		case changeLabelBanana
		case changeLabelGrape
		case setLoading(Bool)
	}
	
	let initialState: State
	
	init() {
		self.initialState = State(fruitName: "선택되어진 과일 없음", isLoading: false)
	}
	
	// MARK: Action -> Mutation
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
		case .apple:  // apple action을 이러한 Mutation으로 바꿈
			return Observable.concat([  // concat은 합치는데 순서를 보장함
				Observable.just(Mutation.setLoading(true)),
				Observable.just(Mutation.changeLabelApple).delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance),  // 500 ms 임의 delay
				Observable.just(Mutation.setLoading(false))
			])
		case .banana:
			return Observable.concat([
				Observable.just(Mutation.setLoading(true)),
				Observable.just(Mutation.changeLabelBanana).delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance),
				Observable.just(Mutation.setLoading(false))
			])
		case .grape:
			return Observable.concat([
				Observable.just(Mutation.setLoading(true)),
				Observable.just(Mutation.changeLabelGrape).delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance),
				Observable.just(Mutation.setLoading(false))
			])
		}
	}
	
	// MARK: Mutation -> State
	func reduce(state: State, mutation: Mutation) -> State {
		var state = state
		switch mutation {
		case .changeLabelApple:
			state.fruitName = "사과"
		case .changeLabelBanana:
			state.fruitName = "바나나"
		case .changeLabelGrape:
			state.fruitName = "포도"
		case .setLoading(let val):
			state.isLoading = val
		}
		
		return state
	}
	
}
