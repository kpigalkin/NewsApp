struct DetailContent {
    var news: News?
    var blog: Blog?
    
    init(news: News? = nil, blog: Blog? = nil) {
        self.news = news
        self.blog = blog
    }
}
