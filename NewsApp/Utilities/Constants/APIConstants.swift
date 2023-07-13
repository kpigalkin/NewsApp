

protocol APIConstantsType {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
}

struct SpaceFlightNewsAPI: APIConstantsType {
    var scheme: String {
        "https"
    }

    var host: String {
        "api.spaceflightnewsapi.net"
    }
    
    var path: String {
        "/v4/articles"
    }
}
