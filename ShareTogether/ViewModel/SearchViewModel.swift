//
//  SearchViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/23.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import MapKit

class SearchViewModel {
    var expenses = [Expense]()
    
    var annotations = [MKPointAnnotation](){
        didSet {
            reloadMapHandler?(annotations)
        }
    }
    
    var reloadMapHandler: (([MKPointAnnotation]) -> Void)?
    
    func fectchData() {
        
        FirestoreManager.shared.getExpenses { [weak self] result in
            switch result {
                
            case .success(let expenses):
                
                if expenses.isEmpty {
                    self?.expenses = [Expense]()
                } else {
                    self?.expenses = expenses
                    self?.processData()
                }

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func processData() {
        var annotations = [MKPointAnnotation]()
        
        for expense in expenses {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: expense.position.latitude, longitude: expense.position.longitude)
            annotations.append(annotation)
        }
    
        self.annotations = annotations
    }

}
