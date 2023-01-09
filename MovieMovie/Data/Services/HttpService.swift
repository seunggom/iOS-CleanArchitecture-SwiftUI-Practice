//
//  NetworkService.swift
//  MovieMovie
//
//  Created by SeungYeon Kim on 2023/01/06.
//

import Foundation

class HttpService {
    let baseUrl: String
    
    init(url: String) {
        self.baseUrl = url
    }
    
    func request<Res>(method: HttpMethod,
                      endpoint: String,
                      parameters: [String : String]? = nil,
                      complete: (Result<Res, HttpError>) -> Void
    ) async throws where Res: Decodable {
        try await request(method: method, endpoint: endpoint, complete: complete)
    }
    
    func request<Req, Res>(method: HttpMethod,
                           endpoint: String,
                           requestBody: Req?,
                           parameters: [String : String]? = nil,
                           complete: (Result<Res, HttpError>) -> Void
    ) async throws where Req: Encodable, Res: Decodable {
        guard var component = URLComponents(string: baseUrl + endpoint) else {
            complete(Result.failure(HttpError(responseCode: 0, errorReason: "urlComponent is nil")))
            return
        }
        if parameters != nil {
            var queryItems = [URLQueryItem]()
            for (name, value) in parameters! {
                if name.isEmpty { continue }
                queryItems.append(URLQueryItem(name: name, value: value))
            }
            component.queryItems = queryItems
        }
        var urlRequest = URLRequest(url: component.url!)
        urlRequest.setValue("PyQ2UaQSPQLHEJ_81EDv", forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.setValue("O89mnYtiex", forHTTPHeaderField: "X-Naver-Client-Secret")
        urlRequest.httpMethod = method.rawValue
        if requestBody != nil {
            let encoder = JSONEncoder()
            let encodedData = try? encoder.encode(requestBody)
            
            guard encodedData != nil else {
                complete(Result.failure(HttpError(responseCode: 0, errorReason: "fail to encode")))
                return
            }
            if let jsonData = encodedData, let jsonString = String(data: jsonData, encoding: .utf8) {
                print("requestBody: \(jsonString)")
            }
            urlRequest.httpBody = encodedData
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard response is HTTPURLResponse else {
            complete(Result.failure(HttpError(responseCode: 0, errorReason: data.description)))
            return
        }
        let resp = response as! HTTPURLResponse
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(Res.self, from: data)
        
        if resp.statusCode == 200, decodedData != nil {
            complete(Result.success(decodedData!))
        } else {
            complete(Result.failure(HttpError(responseCode: resp.statusCode, errorReason: resp.description)))
        }
    }
}


enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class HttpError: Error {
    let responseCode: Int
    let errorReason: String
    
    init(responseCode: Int, errorReason: String) {
        self.responseCode = responseCode
        self.errorReason = errorReason
    }
}
