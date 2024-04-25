struct DecodableStruct: Decodable {
    let status: Bool
    let statusCode: Int
    let message: String
    let support_whatsapp_number: String
    let extra_income: Double
    let total_links: Int
    let total_clicks: Int
    let today_clicks: Int
    let top_source: String
    let top_location: String
    let startTime: String
    let links_created_today: Int
    let applied_campaign: Int
    let data: InnerData
    
    struct InnerData: Decodable {
        let recent_links: [RecentLink]
        let top_links: [TopLink]
        let favourite_links: [FavouriteLink]
        let overall_url_chart: [String: Int]
    }
    
    struct RecentLink: Decodable {
        let url_id: Int
        let web_link: String
        let smart_link: String
        let title: String
        let total_clicks: Int
        let original_image: String?
        let thumbnail: String?
        let times_ago: String
        let created_at: String
        let domain_id: String
        let url_prefix: String?
        let url_suffix: String
        let app: String
        let is_favourite: Bool
    }
    
    struct TopLink: Decodable {
        let url_id: Int
        let web_link: String
        let smart_link: String
        let title: String
        let total_clicks: Int
        let original_image: String?
        let thumbnail: String?
        let times_ago: String
        let created_at: String
        let domain_id: String
        let url_prefix: String?
        let url_suffix: String
        let app: String
        let is_favourite: Bool
    }
    
    struct FavouriteLink: Decodable {
        // not needed
    }
}

