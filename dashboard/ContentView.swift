import SwiftUI
import Combine
import Charts

class GlobalData: ObservableObject {
    @Published var data: DecodableStruct? = nil
}

struct ContentView: View {
    @ObservedObject var globalData = GlobalData()
    @State public var selectedTabIndex = 0
    
    var body: some View {
        ZStack{
            ScrollView {
                VStack() {
                    ComponentLibrary.Header()
                    ComponentLibrary.GreetingView().padding(.leading, 20)
                    VStack {
                        HStack{
                            Text("Overview")
                                .padding(.trailing, 60)
                                .foregroundColor(.gray)
                            HStack{
                                Text("22 Aug - 22 Sept").frame(width:130)
                                Image(systemName: "clock")
                            }
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                        if let overallURLChartData = globalData.data?.data.overall_url_chart {
                            ComponentLibrary.ChartsView(data: overallURLChartData)
                        } else {
                            Text("Loading...")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    ScrollView(.horizontal){
                        HStack{
                            ComponentLibrary.CardView(systemIconName: "cursorarrow.click.2", boldText: "123", normalText: "Today's clicks", iconColor: Color.indigo)
                            ComponentLibrary.CardView(systemIconName: "location", boldText: "Bangalore", normalText: "Location", iconColor: Color.blue)
                            ComponentLibrary.CardView(systemIconName: "network", boldText: "Instagram", normalText: "Top sources", iconColor: Color.red)
                            ComponentLibrary.CardView(systemIconName: "clock", boldText: "11:00 - 12:00", normalText: "Best Time", iconColor: Color.yellow)
                        }
                    }
                    ComponentLibrary.customButton(text: "View Analytics", icon: "chart.line.uptrend.xyaxis")
                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            TabBarButton(title: "Top Links", isSelected: selectedTabIndex == 0) {
                                selectedTabIndex = 0
                            }
                            TabBarButton(title: "Recent Links", isSelected: selectedTabIndex == 1) {
                                selectedTabIndex = 1
                            }
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .frame(width: 40, height: 40)
                                .padding(4)
                                .foregroundColor(.gray)
                                .font(.title)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding(.trailing, 40)
                            
                        }
                        .padding(.vertical, 10)
                    }
                    
                    if (selectedTabIndex == 0) {
                        if let topLinksData = globalData.data?.data.top_links {
                            // Map DecodableStruct.TopLink to ComponentLibrary.TopLink
                            let convertedTopLinks = topLinksData.map { decodableTopLink in
                                return ComponentLibrary.TopLink(
                                    url_id: decodableTopLink.url_id,
                                    web_link: decodableTopLink.web_link,
                                    smart_link: decodableTopLink.smart_link,
                                    title: decodableTopLink.title,
                                    total_clicks: decodableTopLink.total_clicks,
                                    original_image: decodableTopLink.original_image,
                                    thumbnail: decodableTopLink.thumbnail,
                                    times_ago: decodableTopLink.times_ago,
                                    created_at: decodableTopLink.created_at,
                                    domain_id: decodableTopLink.domain_id,
                                    url_prefix: decodableTopLink.url_prefix,
                                    url_suffix: decodableTopLink.url_suffix,
                                    app: decodableTopLink.app,
                                    is_favourite: decodableTopLink.is_favourite
                                )
                            }                            // Pass the converted topLinks to the view
                            ComponentLibrary.TopLinksListView(topLinks: convertedTopLinks)
                        } else {
                            Text("Loading...")
                        }
                    }
                    if (selectedTabIndex == 1){
                        if let recentLinksData = globalData.data?.data.recent_links {
                            // Map DecodableStruct.TopLink to ComponentLibrary.TopLink
                            let convertedRecentLinks = recentLinksData.map { decodableRecentLink in
                                return ComponentLibrary.RecentLink(
                                    url_id: decodableRecentLink.url_id,
                                    web_link: decodableRecentLink.web_link,
                                    smart_link: decodableRecentLink.smart_link,
                                    title: decodableRecentLink.title,
                                    total_clicks: decodableRecentLink.total_clicks,
                                    original_image: decodableRecentLink.original_image,
                                    thumbnail: decodableRecentLink.thumbnail,
                                    times_ago: decodableRecentLink.times_ago,
                                    created_at: decodableRecentLink.created_at,
                                    domain_id: decodableRecentLink.domain_id,
                                    url_prefix: decodableRecentLink.url_prefix,
                                    url_suffix: decodableRecentLink.url_suffix,
                                    app: decodableRecentLink.app,
                                    is_favourite: decodableRecentLink.is_favourite
                                )
                            }                            // Pass the converted topLinks to the view
                            ComponentLibrary.RecentLinksListView(recentLinks: convertedRecentLinks)
                        }
                    }
                    
                    ComponentLibrary.customButton(text: "View all links", icon: "links")
                    ComponentLibrary.helpButton(text: "Talk with us", icon: "phone", color: Color.green)
                    ComponentLibrary.helpButton(text: "Frequently asked questions", icon: "questionmark.circle", color: Color.blue)
                    Spacer().padding(.bottom, 100)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            ComponentLibrary.Footer()
                .padding(.bottom, -75)
        }
        .background(Color.gray.opacity(0.2))
        .ignoresSafeArea()
        .onAppear {
            fetchData()
//            handleJSONDataError()
        }
    }
    
    
    func fetchData() {
        guard let url = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Update authorization header if needed
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                // Handle error if needed
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                print("Error with the response, unexpected status code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                // Handle error if needed
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(DecodableStruct.self, from: jsonData)
                DispatchQueue.main.async {
                    // Save data directly to a global variable
                    globalData.data = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error)")
                // Handle error if needed
            }
        }.resume()
    }

    func handleJSONDataError() {
        let jsonData = """
        {
          "status": true,
          "statusCode": 200,
          "message": "success",
          "support_whatsapp_number": "6360481897",
          "extra_income": 94.76,
          "total_links": 178,
          "total_clicks": 1805,
          "today_clicks": 26,
          "top_source": "Direct",
          "top_location": "Mumbai",
          "startTime": "09:00",
          "links_created_today": 0,
          "applied_campaign": 0,
          "data": {
            "recent_links": [
              {
                "url_id": 146150,
                "web_link": "https://inopenapp.com/4o5qk",
                "smart_link": "inopenapp.com/4o5qk",
                "title": "651   Flats for Rent in Kormangla Bangalore, Bangalore Karnataka Without Brokerage - NoBroker Rental Properties in Kormangla Bangalore Karnataka Without Brokerage",
                "total_clicks": 248,
                "original_image": "https://assets.nobroker.in/nb-new/public/List-Page/ogImage.png",
                "thumbnail": null,
                "times_ago": "1 yr ago",
                "created_at": "2023-03-15T07:33:50.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": null,
                "url_suffix": "4o5qk",
                "app": "nobroker",
                "is_favourite": false
              },
              {
                "url_id": 146110,
                "web_link": "https://inopenapp.com/estt3",
                "smart_link": "inopenapp.com/estt3",
                "title": "Dailyhunt",
                "total_clicks": 119,
                "original_image": "https://m.dailyhunt.in/assets/img/apple-touch-icon-72x72.png?mode=pwa&ver=2.0.76",
                "thumbnail": null,
                "times_ago": "1 yr ago",
                "created_at": "2023-03-09T08:00:05.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": null,
                "url_suffix": "estt3",
                "app": "dailyhunt",
                "is_favourite": false
              },
              {
                "url_id": 146061,
                "web_link": "https://inopenapp.com/7113t",
                "smart_link": "inopenapp.com/7113t",
                "title": "MSI Katana GF66 Thin, Intel 12th Gen. i5-12450H, 40CM FHD 144Hz Gaming Laptop (16GB/512GB NVMe SSD/Windows 11 Home/Nvidia RTX3050Ti 4GB GDDR6/Black/2.25Kg), 12UD-640IN : Amazon.in: Computers & Accessories",
                "total_clicks": 80,
                "original_image": "https://m.media-amazon.com/images/I/81c+XOq0b+L._SY450_.jpg",
                "thumbnail": null,
                "times_ago": "1 yr ago",
                "created_at": "2023-02-23T11:45:54.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": null,
                "url_suffix": "7113t",
                "app": "amazon",
                "is_favourite": false
              },
              {
                "url_id": 145873,
                "web_link": "https://inopenapp.com/juixo",
                "smart_link": "inopenapp.com/juixo",
                "title": "Online Shopping Site for Mobiles, Electronics, Furniture, Grocery, Lifestyle, Books & More. Best Offers!",
                "total_clicks": 64,
                "original_image": "https://www.flipkart.com/apple-touch-icon-57x57.png",
                "thumbnail": null,
                "times_ago": "1 yr ago",
                "created_at": "2023-02-20T04:59:00.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": null,
                "url_suffix": "juixo",
                "app": "flipkart",
                "is_favourite": false
              },
              {
                "url_id": 144236,
                "web_link": "https://inopenapp.com/h2hok",
                "smart_link": "inopenapp.com/h2hok",
                "title": "Programming Jokes & MeMes | The gods have spoken",
                "total_clicks": 65,
                "original_image": "https://scontent-iad3-2.xx.fbcdn.net/v/t39.30808-6/325385014_1393046418172272_8557035725717444936_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=7fc0be&_nc_ohc=YYNdHpdCbiAAX9iHO5V&_nc_ht=scontent-iad3-2.xx&oh=00_AfCk2FYoD4WCCp3bqnjBxcxhQ8MEAxCw9xyInnM5sBO0VA&oe=63CD146D",
                "thumbnail": null,
                "times_ago": "1 yr ago",
                "created_at": "2023-01-18T05:40:39.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": null,
                "url_suffix": "h2hok",
                "app": "facebook",
                "is_favourite": false
              }
            ],
            "top_links": [
              {
                "url_id": 98953,
                "web_link": "https://boyceavenue.inopenapp.com/boyce-avenue",
                "smart_link": "boyceavenue.inopenapp.com/boyce-avenue",
                "title": "Can't Help Falling In Love - Elvis Presley (Boyce Avenue acoustic cover) on Spotify & Apple",
                "total_clicks": 424,
                "original_image": "https://i.ytimg.com/vi/G0WTFfZqjz0/maxresdefault.jpg",
                "thumbnail": null,
                "times_ago": "2 yr ago",
                "created_at": "2022-01-12T13:57:49.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": "boyceavenue",
                "url_suffix": "boyce-avenue",
                "app": "youtube",
                "is_favourite": false
              },
              {
                "url_id": 146150,
                "web_link": "https://inopenapp.com/4o5qk",
                "smart_link": "inopenapp.com/4o5qk",
                "title": "651   Flats for Rent in Kormangla Bangalore, Bangalore Karnataka Without Brokerage - NoBroker Rental Properties in Kormangla Bangalore Karnataka Without Brokerage",
                "total_clicks": 248,
                "original_image": "https://assets.nobroker.in/nb-new/public/List-Page/ogImage.png",
                "thumbnail": null,
                "times_ago": "1 yr ago",
                "created_at": "2023-03-15T07:33:50.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": null,
                "url_suffix": "4o5qk",
                "app": "nobroker",
                "is_favourite": false
              },
              {
                "url_id": 140627,
                "web_link": "https://amazon.inopenapp.com/b01n5qh183",
                "smart_link": "amazon.inopenapp.com/b01n5qh183",
                "title": "Match Women's Long Sleeve Flannel Plaid Shirt at Amazon Women’s Clothing store",
                "total_clicks": 178,
                "original_image": "https://m.media-amazon.com/images/I/51rE6aQt2fL._AC_.jpg",
                "thumbnail": null,
                "times_ago": "1 yr ago",
                "created_at": "2022-09-23T19:59:49.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": "amazon",
                "url_suffix": "b01n5qh183",
                "app": "amazon",
                "is_favourite": false
              },
              {
                "url_id": 81169,
                "web_link": "https://dream.inopenapp.com/vid",
                "smart_link": "dream.inopenapp.com/vid",
                "title": "YouTube",
                "total_clicks": 134,
                "original_image": "https://www.youtube.com/img/desktop/yt_1200.png",
                "thumbnail": null,
                "times_ago": "2 yr ago",
                "created_at": "2021-12-17T10:36:05.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": "dream",
                "url_suffix": "vid",
                "app": "youtube",
                "is_favourite": false
              },
              {
                "url_id": 146110,
                "web_link": "https://inopenapp.com/estt3",
                "smart_link": "inopenapp.com/estt3",
                "title": "Dailyhunt",
                "total_clicks": 119,
                "original_image": "https://m.dailyhunt.in/assets/img/apple-touch-icon-72x72.png?mode=pwa&ver=2.0.76",
                "thumbnail": null,
                "times_ago": "1 yr ago",
                "created_at": "2023-03-09T08:00:05.000Z",
                "domain_id": "inopenapp.com/",
                "url_prefix": null,
                "url_suffix": "estt3",
                "app": "dailyhunt",
                "is_favourite": false
              }
            ],
            "favourite_links": [],
            "overall_url_chart": {
              "00:00": 0,
              "01:00": 0,
              "02:00": 0,
              "03:00": 0,
              "04:00": 0,
              "05:00": 0,
              "06:00": 0,
              "07:00": 4,
              "08:00": 7,
              "09:00": 14,
              "10:00": 0,
              "11:00": 0,
              "12:00": 0,
              "13:00": 0,
              "14:00": 0,
              "15:00": 0,
              "16:00": 0,
              "17:00": 0,
              "18:00": 1,
              "19:00": 0,
              "20:00": 0,
              "21:00": 0,
              "22:00": 0,
              "23:00": 0
            }
          }
        }
        """.data(using: .utf8)!
        
        do {
            let decodedData = try JSONDecoder().decode(DecodableStruct.self, from: jsonData)
            DispatchQueue.main.async {
                self.globalData.data = decodedData
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

struct Click:Identifiable {
    var id = UUID()
    let time: String
    let click: Int
}

struct TabBarButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .foregroundColor(isSelected ? .white : .gray)
                .background(isSelected ? .blue : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: isSelected ? 10 : 0)
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

