//
//  CacheManager.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/16/20.
//

import Foundation

class CacheManager {
    private enum Constants {
        static let extendedCacheMamoryCapacity = 100 * 1024 * 1024
        static let cacheDiskCapacity: Int = 200 * 1024 * 1024
    }
    // MARK: Properties
    var memoryCapacity: Int
    var diskCapacity: Int
    var cacheDirectory: String?
    var policyOfCache: URLCache.StoragePolicy
    var cache: URLCache
    // MARK: Inits
    init(directory: String? = nil) {
        self.memoryCapacity = Constants.extendedCacheMamoryCapacity
        self.cacheDirectory = directory
        if diskFreeStorage() > Constants.cacheDiskCapacity {
            self.diskCapacity = Constants.cacheDiskCapacity
            policyOfCache = .allowed
        } else {
            self.diskCapacity = 0
            policyOfCache = .allowedInMemoryOnly
        }
        cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: cacheDirectory )
    }
    // MARK: Functions
    func cachedData(for request: URLRequest) -> Data? {
        if let cachedData = cache.cachedResponse(for: request) {
            return cachedData.data
        } else {
            return nil
        }
    }
    func storeData(data: Data, with response: HTTPURLResponse, for request: URLRequest) {
        let cachedData = CachedURLResponse(response: response,
                                           data: data,
                                           userInfo: nil,
                                           storagePolicy: self.policyOfCache)
        self.cache.storeCachedResponse(cachedData, for: request)
    }
    func removeAllCache() {
        cache.removeAllCachedResponses()
    }
}

private func diskFreeStorage() -> Int64 {
    let fileURL = URL(fileURLWithPath: NSHomeDirectory())
    let value = try? fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
    guard let freeSpace = value?.volumeAvailableCapacityForImportantUsage else {return 0}
    return freeSpace
}
