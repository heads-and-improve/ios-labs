//
//  FlickrNetworkingManager.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import UIKit
import Combine

final class FlickrNetworkingClient {

    private let tagEvent = PassthroughSubject<String, Error>()
    private var cancellables = Set<AnyCancellable>()

    private var isBusy = false

    var onStart: (() -> Void)?
    var onSuccess: (([UIImage]) -> Void)?
    var onError: ((String) -> Void)?

    init() {
        let getPhotos = GetPhotosUseCase()

        tagEvent
            .filter { [weak self] _ in !(self?.isBusy ?? true) }
            .do { [weak self] _ in self?.isBusy = true }
            .do { [weak self] _ in self?.onStart?() }
            .flatMap { getPhotos($0) }
            .receive(on: RunLoop.main)
            .do { [weak self] _ in self?.isBusy = false }
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.onError?("Произошла ошибка!")
                    }
                },
                receiveValue: { [weak self] images in
                    self?.onSuccess?(images)
                }
            )
            .store(in: &cancellables)
    }
    
    func callAsFunction(_ tag: String) {
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
