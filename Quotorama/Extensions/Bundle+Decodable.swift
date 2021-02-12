//
//  Bundle-Decodable.swift
//  SnowSeeker
//
//  Created by Marko Kramar on 27.12.2020..
//

import SwiftUI

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        let decoder = JSONDecoder()
        var loaded: T?
        do {
            loaded = try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Error while trying to decode to JSON: \(error)")
        }

        return loaded!
    }
}
