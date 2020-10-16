import UIKit

public class ImageDownloader {
    // MARK: Singleton
    static public let shared = ImageDownloader()
    // MARK: Constants
    private enum Constants {
        static let customTimeoutInterval: TimeInterval = 60
    }
    // MARK: Properties
    private let cacheManager = CacheManager()
    private var requestBuilder = RequestBuilder(cachePolicy: .returnCacheDataElseLoad,
                                                timeInterval: Constants.customTimeoutInterval)
    private let datataskManager = DataTaskManager()
    private let imageRenderManager = ImageRenderManager()
    private let urlSessionBuilder = UrlSessionBuilder()
    private let urlSession: URLSession?
    // MARK: Queues
    private var downloaderSerialQueue = DispatchQueue(label: "com.ImageDownoader.serialDownloading",
                                                      qos: .userInteractive,
                                                      attributes: .concurrent)
    // MARK: Inits
    init (urlSessionConfiguration: URLSessionConfiguration = .default) {
        self.urlSession = urlSessionBuilder.urlSession(configuration: urlSessionConfiguration)
    }
    // MARK: Functions
    public func downloadImage(with url: String,
                              scaleTo size: ImageSize = .cellSize,
                              completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        downloaderSerialQueue.async {
            guard let imageURL = URL(string: url) else {
                DispatchQueue.main.async {
                    completion(.failure(.incorrectURL))
                }
                return
            }
            guard let urlRequest = self.requestBuilder.urlRequest(with: imageURL, httpMethod: .get) else {
                DispatchQueue.main.async {
                    completion(.failure(.requestInitError))
                }
                return
            }
            if let imageData = self.cacheManager.cachedData(for: urlRequest) {
                guard let image = self.configureImageFromData(imageData, with: size) else {
                    DispatchQueue.main.async {
                        completion(.failure(.incorrectData))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                guard self.datataskManager.dataTaskNotExists(for: imageURL) else { return }
                guard let configuredUrlSession = self.urlSession else { return }
                let dataTask = configuredUrlSession.dataTask(with: urlRequest) { (data, response, error) in
                    defer {self.datataskManager.removeDataTask(with: imageURL)}
                    guard let httpResponce = response as? HTTPURLResponse else {
                        DispatchQueue.main.async {
                            completion(.failure(.incorrectResponse))
                        }
                        return
                    }
                    guard let data = data else {
                        DispatchQueue.main.async {
                            completion(.failure(.incorrectData))
                        }
                        return
                    }
                    guard error == nil else {
                        DispatchQueue.main.async {
                            completion(.failure(.unknownConnectionError))
                        }
                        return
                    }
                    if let httpResponseError = HTTPError(rawValue: httpResponce.statusCode) {
                        DispatchQueue.main.async {
                            completion(.failure(.httpError(httpResponseError)))
                        }
                        return
                    } else if httpResponce.statusCode > 511 || httpResponce.statusCode < 200 {
                        DispatchQueue.main.async {
                            completion(.failure(.unknownResponseCode))
                        }
                        return
                    }
                    guard let compressedImageData = self.imageRenderManager.compressImage(data) else {
                        DispatchQueue.main.async {
                            completion(.failure(.incorrectData))
                        }
                        return
                    }
                    guard let image = self.configureImageFromData(compressedImageData, with: size) else {
                        DispatchQueue.main.async {
                            completion(.failure(.incorrectData))
                        }
                        return
                    }
                    self.cacheManager.storeData(data: compressedImageData, with: httpResponce, for: urlRequest)
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                }
                dataTask.resume()
                self.datataskManager.addNewDataTask(dataTask, for: imageURL)
            }
        }
    }
    public func clearCache() {
        cacheManager.removeAllCache()
    }
    private func configureImageFromData (_ data: Data, with size: ImageSize) -> UIImage? {
        guard let image = UIImage(data: data) else {
            return nil
        }
        let resizedImage = self.imageRenderManager.resizeImage(image, to: size.value())
        return resizedImage
    }
}
