//
//  WebService.swift
//  HotCoffee
//
//  Created by Marshall Kurniawan on 09/02/23.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HTTPMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

class WebService {
    
    //ini func buat secara universal ngejalanin suatu api call
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        //ini buat nge set secara dinamis url callnya ke mana, methodnya apa, etc
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in

            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }

            //nge decode hasil yang di dapet sesuai sama T yang di set waktu manggil funcnya
            //contoh, kalo get, itu dapetnya bakal [Order]. makanya di file order yang var all, return Resourcenya <[Order]>
            //contoh, kalo post, itu dapetnya bakal Order. makanya di file order yang func create, return Resourcenya <Order> tapi di modif dulu jadi POST methodnya
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }

        }.resume()
    }
}
