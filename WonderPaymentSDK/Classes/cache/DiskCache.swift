//
//  DiskCache.swift
//  Pods
//
//  Created by X on 2024/12/26.
//

import Foundation

class DiskCache {
    static let shared = DiskCache()
    
    private let cacheDirectory: URL
    
    private init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("DataCache")
        
        // Ensure cache directory exists
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating cache directory: \(error)")
            }
        }
    }
    
    func getFileContent(_ fileName: String) -> String? {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        guard let fileData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return String(data: fileData, encoding: .utf8)
    }
    
    func writeFile(_ fileName: String, content: String) {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        let data = content.data(using: .utf8)
        try? data?.write(to: fileURL, options: .atomic)
    }
}

