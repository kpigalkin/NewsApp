import Foundation

protocol HTTPClient {
    func sendRequest(endpoint: Endpoint) async throws -> Data
}

extension HTTPClient {
    func sendRequest(endpoint: Endpoint) async throws -> Data {
        
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.name
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let reponse = response as? HTTPURLResponse else {
                throw RequestError.serviceUnavailable
            }
            
            switch reponse.statusCode {
            case 200...299:
                return data
            default:
                throw RequestError.handleResponseError(statusCode: reponse.statusCode)
            }
        } catch URLError.Code.notConnectedToInternet {
            throw RequestError.offline
        }
    }
}
