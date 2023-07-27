//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

struct DetailContent {
    var news: News?
    var blog: Blog?
    
    init(news: News? = nil, blog: Blog? = nil) {
        self.news = news
        self.blog = blog
    }
}
