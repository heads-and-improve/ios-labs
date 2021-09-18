//
//  FlickrNetworkingManager.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import UIKit
import Combine

final class CombineErrorsViewModel {

    private let tagEvent = PassthroughSubject<String, Error>()
    private var cancellables = Set<AnyCancellable>()

    private var isBusy = false

    var onStart: ((Bool) -> Void)?
    var onSuccess: (([UIImage]) -> Void)?
    var onError: ((String) -> Void)?

    init() {
        let getPhotos = GetPhotosUseCase()

        tagEvent
            .filter { [weak self] _ in !(self?.isBusy ?? true) }
            .do { [weak self] _ in self?.isBusy = true }
            .do { [weak self] _ in self?.onStart?(true) }
            .flatMap { getPhotos($0) }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isBusy = false
                    self?.onStart?(false)
                    
                    if case let .failure(error) = completion {
                        self?.onError?(error.localizedDescription)
                    }
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                    }
                },
                receiveValue: { [weak self] result in
                    self?.isBusy = false
                    self?.onStart?(false)

                    switch result {
                    case .success(let images):
                        self?.onSuccess?(images)

                    case .failure(let nwError):
                        switch nwError {
                        case .url(let urlError):
                            self?.onError?(urlError.localizedDescription)
                        case .some(let description):
                            self?.onError?(description)
                        }

                    }
                }
            ).store(in: &cancellables)
    }
    
}
 
extension CombineErrorsViewModel {

    func load(_ tag: String) {
        tagEvent.send(tag)
    }

}

fileprivate extension Publisher {

    func `do`(_ sideEffect: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        map { output in
            sideEffect(output)
            return output
        }
        .eraseToAnyPublisher()
    }
}
