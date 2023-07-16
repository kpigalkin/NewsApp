struct SpaceFlightNewsAPI {
    static var scheme: String {
        "https"
    }

    static var host: String {
        "api.spaceflightnewsapi.net"
    }
    
    static var path: String {
        "/v4/articles"
    }
    
    static var dateFormats: [String] {
        [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ"
        ]
    }
}
enum CustomError: Error {
    case URLError
}
