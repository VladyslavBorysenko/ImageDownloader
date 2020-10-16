//
//  DataTaskManager.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/21/20.
//

import UIKit

class DataTaskManager {
    // MARK: Properies
    private var instantiatedDataTasks: [URL: URLSessionDataTask] = [: ]
    // MARK: Functions
    func dataTaskNotExists(for url: URL) -> Bool {
        if instantiatedDataTasks[url] == nil {
            return true
        } else { return false }
    }
    func addNewDataTask( _ dataTask: URLSessionDataTask, for url: URL ) {
        instantiatedDataTasks[url] = dataTask
    }
    func cancelDataTask(for url: URL) {
        if let dataTask = instantiatedDataTasks[url] {
            dataTask.cancel()
        }
    }
    func removeDataTask(with url: URL) {
        instantiatedDataTasks.removeValue(forKey: url)
    }
}
