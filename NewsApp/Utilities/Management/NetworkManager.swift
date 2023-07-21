import Foundation

protocol NetworkManagingLogic {
    func request<T: Decodable>(endPoint: EndPoint, model: T.Type) async throws -> T
}

final class NetworkManager {}

extension NetworkManager: NetworkManagingLogic {
    func request<T: Decodable>(endPoint: EndPoint, model: T.Type) async throws -> T {
        var components = URLComponents()
        components.scheme = endPoint.scheme
        components.host = endPoint.host
        components.path = endPoint.path
        components.queryItems = endPoint.parameters

        guard let url = components.url else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    throw RequestError.decode
                }
                return decodedData
            default:
                throw RequestError.unknown
            }
        } catch URLError.Code.notConnectedToInternet {
            throw RequestError.offline
        }
    }
}
