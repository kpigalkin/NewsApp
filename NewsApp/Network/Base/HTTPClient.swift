import Foundation

protocol HTTPClient {
    func execute(request: URLRequest) async throws -> Data
}

extension HTTPClient {
    func execute(request: URLRequest) async throws -> Data {
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
