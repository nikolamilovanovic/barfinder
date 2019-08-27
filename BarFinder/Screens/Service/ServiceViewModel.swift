//
//  ServiceViewModel.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift

protocol ServiceViewModelInputs {
  func buttonPressed()
}

protocol ServiceViewModelOutputs {
  var infolabelText: Observable<String> { get }
  var buttonTitle: Observable<String> { get }
  var title: String { get }
}

protocol ServiceViewModelProtocol {
  var inputs: ServiceViewModelInputs { get }
  var outputs: ServiceViewModelOutputs { get }
}

final class ServiceViewModel: ServiceViewModelProtocol, ServiceViewModelInputs, ServiceViewModelOutputs {
  
  private let disposeBag: DisposeBag
  
  private let infoLabelTextSubject: BehaviorSubject<String>
  private let buttonTitleSubject: BehaviorSubject<String>
  private let userDataSubject: BehaviorSubject<UserData?>
  private let buttonPressedSubject: PublishSubject<Void>
  
  let title: String
  
  var inputs: ServiceViewModelInputs {
    return self
  }
  
  var outputs: ServiceViewModelOutputs {
    return self
  }
  
  init() {
    self.title = App.current.service.type.localizedName

    self.disposeBag = DisposeBag()
    self.infoLabelTextSubject = BehaviorSubject(value: "")
    self.buttonTitleSubject = BehaviorSubject(value: "")
    self.userDataSubject = BehaviorSubject(value: nil)
    self.buttonPressedSubject = PublishSubject()
    
    bindToObservables()
  }
  
  var infolabelText: Observable<String> {
    return infoLabelTextSubject
  }
  
  var buttonTitle: Observable<String> {
    return buttonTitleSubject
  }
  
  private func bindToObservables() {
//    App.current.service.currentUser!
//      .distinctUntilChanged()
//      .bind(to: userDataSubject)
//      .disposed(by: disposeBag)
    
    userDataSubject.map {
      var labelText: String
      
      if let userData = $0 {
        labelText = String(format: LocalizedStrings.ServiceScreen.userLoggedFormat,
                           arguments: [App.current.service.type.localizedName, userData.name ?? "", userData.id])
      } else {
        labelText = String(format: LocalizedStrings.ServiceScreen.userNotLoggedFormat,
                           arguments: [App.current.service.type.localizedName])
      }
      
      return labelText
      }.bind(to: infoLabelTextSubject)
      .disposed(by: disposeBag)
    
    userDataSubject.map {
      return $0 == nil ? LocalizedStrings.ServiceScreen.buttonTitleLogIn : LocalizedStrings.ServiceScreen.buttonTitleLogOut;
      }.bind(to: buttonTitleSubject)
      .disposed(by: disposeBag)
    
    buttonPressedSubject.withLatestFrom(userDataSubject).subscribeOnNext { [unowned self] (userData) in
      if userData == nil {
        App.current.service.logIn().subscribe(
          onSuccess: {
            self.userDataSubject.onNext($0)
        },
          onError: { _ in
            self.userDataSubject.onNext(nil)
        }).disposed(by: self.disposeBag)
      } else {
        App.current.service.logOut()
      }
    }.disposed(by: disposeBag)
  }
  
  func buttonPressed() {
    buttonPressedSubject.onNext(())
  }
}
