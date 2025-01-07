//
//  JSONHelper.swift
//  MyMusicApp
//
//  Created by Titus Logo on 07/01/25.
//

import Foundation

public final class JSONHelper {
    static func readJSON<T: Decodable>(from fileName: String, type: T.Type) -> T? {
        // Get the URL for the file in the main bundle
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("File not found")
            return nil
        }
        
        do {
            // Read the data from the file
            let data = try Data(contentsOf: fileURL)
            
            // Decode the data into the specified type
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Error decoding JSON file: \(error)")
            return nil
        }
    }
}
