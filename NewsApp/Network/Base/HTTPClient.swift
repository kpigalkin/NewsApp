import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T {
        
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else {
            throw RequestError.invalidURL
        }
        
        guard let stringUrl = url.description.removingPercentEncoding else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: URL(string: stringUrl)!)
        request.httpMethod = endpoint.method.rawValue
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let reponse = response as? HTTPURLResponse else {
                throw RequestError.serviceUnavailable
            }
            
            switch reponse.statusCode {
            case 200...299:
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    throw RequestError.decode
                }
                return decodedData
            default:
                throw RequestError.handleResponseError(statusCode:reponse.statusCode)
            }
        } catch URLError.Code.notConnectedToInternet {
            throw RequestError.offline
        }

    }
}
