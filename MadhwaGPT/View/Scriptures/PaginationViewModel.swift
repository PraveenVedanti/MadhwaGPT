//
//  PaginationViewModel.swift
//  MadhwaGPT
//
//  Created by Praveen Kumar Vedanti on 1/31/26.
//

import Foundation

final class PaginationViewModel<T>: ObservableObject {
    
    var items: [T]
    let pageSize: Int
    
    @Published var currentPage: Int = 0
    
    init(items: [T], pageSize: Int = 10) {
        self.items = items
        self.pageSize = pageSize
    }
    
    var totalPages: Int {
        Int(ceil(Double(items.count) / Double(pageSize)))
    }
    
    var currentItems: [T] {
        let start = currentPage * pageSize
        let end = min(start + pageSize, items.count)
        return Array(items[start..<end])
    }
    
    func nextPage() {
        guard currentPage < totalPages - 1 else { return }
        currentPage += 1
    }
    
    func previousPage() {
        guard currentPage > 0 else { return }
        currentPage -= 1
    }
}
