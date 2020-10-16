//
//  ImageFetchingErrors.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/13/20.
//

import Foundation

public enum NetworkError: Error {
    case httpError(HTTPError)
    case unknownConnectionError
    case timeOutError
    case incorrectURL
    case incorrectResponse
    case incorrectData
    case requestInitError
    case unknownResponseCode
}
public enum HTTPError: Int, CustomStringConvertible {
    public var description: String {
        switch self {
        case .badRequest:
            return "The error seems to have been caused by the client"
        case .unauthorized:
            return "Server is aware that the server has erred"
        case .paymentRequired:
            return """
            This response code is reserved for future use.
            The initial aim for creating this code was using it for digital payment systems,
            however this status code is used very rarely and no standard convention exists.
            """
        case .forbidden:
            return """
            The client does not have access rights to the content;
            that is, it is unauthorized, so the server is refusing to give the requested resource.
            Unlike 401, the client's identity is known to the server
            """
        case .notFound:
            return """
                The server can not find the requested resource.
                In the browser, this means the URL is not recognized.
                In an API, this can also mean that the endpoint is valid but the resource itself does not exist.
                Servers may also send this response instead of 403
                to hide the existence of a resource from an unauthorized client.
                This response code is probably the most famous one due to its frequent occurrence on the web
                """
        case .methodNotAllowed:
            return """
                The request method is known by the server but has been disabled and cannot be used.
                For example, an API may forbid DELETE-ing a resource.
                The two mandatory methods, GET and HEAD, must never be disabled and should not return this error code
                """
        case .notAcceptable:
            return """
                This response is sent when the web server, after performing server-driven content negotiation,
                doesn't find any content that conforms to the criteria given by the user agent.
                """
        case .proxyAuthenticationRequired:
            return "This is similar to 401 but authentication is needed to be done by a proxy"
        case .requestTimeout:
            return """
                This response is sent on an idle connection by some servers, even without any
                previous request by the client.
                It means that the server would like to shut down this unused connection.
                """
        case .conflict:
            return "This response is sent when a request conflicts with the current state of the server"
        case .gone:
            return """
                This response is sent when the requested content has been permanently deleted from server,
                with no forwarding address.
                Clients are expected to remove their caches and links to the resource.
                APIs should not feel compelled to indicate resources that have been deleted with this status code.
                """
        case .lengthRequired:
            return """
            Server rejected the request because the
            Content-Length header field is not defined and the server requires it.
            """
        case .preconditionFailed:
            return "The client has indicated preconditions in its headers which the server does not meet"
        case .payloadTooLarge:
            return """
            Request entity is larger than limits defined by server;
            the server might close the connection or return an Retry-After header field.
            """
        case .internalServerError:
            return "The server has encountered a situation it doesn't know how to handle."
        case .notImplemented:
            return """
            The request method is not supported by the server and cannot be handled.
            The only methods that servers are required to support
            (and therefore that must not return this code) are GET and HEAD.
            """
        case .badGateway:
            return """
            This error response means that the server,
            while working as a gateway to get a response needed to handle the request,
            got an invalid response.
            """
        case .serviceUnavailable:
            return """
            The server is not ready to handle the request.
            Common causes are a server that is down for maintenance or that is overloaded.
            Note that together with this response, a user-friendly page explaining the problem should be sent.
            This responses should be used for temporary conditions and the Retry-After:
            HTTP header should, if possible, contain the estimated time before the recovery of the service.
            The webmaster must also take care about the caching-related headers that are sent along with this response,
            as these temporary condition responses should usually not be cached.
            """
        case .gatewayTimeout:
            return """
            This error response is given when the server is acting as a gateway and cannot get a response in time.
"""
        case .httpVersionNotSupported:
            return "The HTTP version used in the request is not supported by the server."
        case .variantAlsoNegotiates:
            return """
            The server has an internal configuration error:
            the chosen variant resource is configured to engage in transparent content negotiation itself,
            and is therefore not a proper end point in the negotiation process.
            """
        case .insufficientStorage:
            return """
            The method could not be performed on the resource because the server is unable
            to store the representation needed to successfully complete the request.
            """
        case .loopDetected:
            return "The server detected an infinite loop while processing the request."
        case .notExtended:
            return "Further extensions to the request are required for the server to fulfil it."
        case .networkAuthenticationRequired:
            return "The 511 status code indicates that the client needs to authenticate to gain network access."
        }
    }
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case internalServerError = 501
    case notImplemented = 502
    case badGateway = 503
    case serviceUnavailable = 504
    case gatewayTimeout = 505
    case httpVersionNotSupported = 506
    case variantAlsoNegotiates = 507
    case insufficientStorage = 508
    case loopDetected = 509
    case notExtended = 510
    case networkAuthenticationRequired = 511
}
extension NetworkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .httpError(let statusCode):
            return statusCode.description
        case .unknownConnectionError:
            return "During fetching the image, unknown error was occured"
        case .timeOutError:
            return "Internet connection timeout"
        case .incorrectURL:
            return "The url address is invalid"
        case .incorrectResponse:
            return "Receieved response is invalid"
        case .incorrectData:
            return "Incorrect data"
        case .requestInitError:
            return "Adjusted request parameters are invalid. Check it out"
        case .unknownResponseCode:
            return "Recieved response code isn't corresponding any HTTP status codes"
        }
    }
}
