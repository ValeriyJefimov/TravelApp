//
//  NetworkRequest.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/19/21.
//

import Alamofire
import Foundation

public protocol NetworkRequest {
  var method: HTTPMethod { get }
  var apiURL: URLConvertible { get }
  var params: Parameters? { get }
  var encoding: ParameterEncoding { get }
  var token: Token { get }
  var headers: HTTPHeaders? { get }
  func url(relativeTo baseUrl: URLConvertible) throws -> URLConvertible
  func urlRequest(relativeTo baseUrl: URLConvertible) throws -> URLRequestConvertible
}

public struct Token {
    let clientId: String
    let clientSecret: String
}

public let liveToken: Token = .init(
    clientId: "5JF2GQ1PLUA54EUFXSMW0KNIU3JCHOY0HN31CF1I2NGDN2U1",
    clientSecret: "CH54TRNZXYCLDLR1GPGANFEMUB0VQLRX1AWUDG02REFPBNA5"
)


fileprivate let vDateFormatter = DateFormatter()

extension NetworkRequest {
    public var baseParametrs: Parameters {
        vDateFormatter.dateFormat = "YYYYMMdd"
        return [
            "client_id" : token.clientId,
            "client_secret" : token.clientSecret,
            "v": vDateFormatter.string(from: Date())
        ]
    }
    
    public func url(relativeTo baseUrl: URLConvertible) throws -> URLConvertible {
        return try baseUrl.asURL().absoluteString + apiURL.asURL().absoluteString
    }
    
    public func urlRequest(relativeTo baseUrl: URLConvertible) throws -> URLRequestConvertible {
        let urlConvertable = try self.url(relativeTo: baseUrl)
        let originalRequest = try URLRequest(url: urlConvertable, method: method, headers: headers)
        return try encoding.encode(originalRequest, with: params)
    }
}


