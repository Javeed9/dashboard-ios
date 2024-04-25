import SwiftUI
import Charts

struct ComponentLibrary {
    struct Header: View {
        var body: some View {
            HStack{
                Text("Dashboard")
                    .foregroundStyle(.white)
                    .bold()
                    .font(.system(size: 32))
                    .padding(10)
                Spacer()
                Button(action: {}){
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(5)
                        .background(Color.white.opacity(0.3))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(10)
                }
            }
            .padding(.top, 50)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(Color.blue)
            
        }
    }
    
    struct CardView: View {
        let systemIconName: String
        let boldText: String
        let normalText: String
        let iconColor: Color
        
        var body: some View {
            Button(action:{
                print("Card is clicked!")
            }){
                VStack {
                    Image(systemName: systemIconName)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(iconColor)
                        .padding(10)
                        .background(iconColor.opacity(0.3))
                        .clipShape(Circle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(boldText)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(normalText)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(minWidth: 75, minHeight: 75)
                .padding(25)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.leading, 10)
            }
        }
    }
    
    struct customButton: View {
        let text: String
        let icon: String
        
        var body: some View {
            VStack{
                Button(action: {
                    print("Button Clicked")
                }) {
                    Label(text, systemImage: icon)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.horizontal, 20)
                .foregroundColor(.black)
                .padding()
                .bold()
                .font(.system(size: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                )
            }.padding(.vertical, 10)
                .padding(.horizontal)
        }
    }
    
    struct LinkCard: View {
        @State private var copied = false
        let image: String
        let linkName: String
        let date: String
        let clicks: Int
        let link: String
        
        var body: some View {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: image))
                    //                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 10)
                    VStack(alignment: .leading) {
                        Text(linkName).lineLimit(1)
                        Text(date).lineLimit(1).foregroundColor(.gray)
                    }
                    .padding(.trailing, 60)
                    VStack(alignment: .leading) {
                        Text(String(clicks))
                        Text("clicks")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 20)
                }.padding(.vertical, 25)
                HStack {
                    Text(link)
                        .padding(.trailing, 100)
                        .frame(width: 250)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Button(action: {
                        UIPasteboard.general.string = link
                        copied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            copied = false
                        }
                    }) {
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                            .cornerRadius(5)
                    }
                }
                .frame(width: 350, height: 30)
                .background(Color(red: 217/255, green: 231/255, blue: 255/255))
            }
            .frame(width: 350, height: 125)
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            .overlay(
                copied ?
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color.black.opacity(0.6))
                    .overlay(
                        Text("Copied")
                            .foregroundColor(.white)
                    )
                : nil
            )
        }
    }
    
    struct helpButton: View {
        let text: String
        let icon: String
        let color: Color
        var body: some View {
            VStack{
                Button(action: {
                    print("Button Clicked")
                }) {
                    Label(text, systemImage: icon)
                        .frame(width: 350)
                }
                .frame(width: 350)
                .padding()
                .background(color.opacity(0.2))
                .foregroundColor(.black)
                .bold()
                .font(.system(size: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
            }.padding(.vertical, 10)
                .padding(.horizontal)
        }
    }
    struct GreetingView: View {
        @State private var greeting = ""
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(greeting)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
                Text("Syed Javeed 👋🏻")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .font(.system(size: 24))
            }
            .padding()
            .onAppear {
                fetchGreeting()
            }
        }
        
        private func fetchGreeting() {
            let hour = Calendar.current.component(.hour, from: Date())
            if hour < 12 {
                greeting = "Good morning"
            } else if hour < 17 {
                greeting = "Good afternoon"
            } else {
                greeting = "Good evening"
            }
        }
    }
    
    struct Footer: View {
        @State private var selectedTab = 0
            
            var body: some View {
                VStack {
                    Spacer()
                    HStack() {
                        TabBarButton(systemName: "link", title: "Links", isSelected: selectedTab == 0) {
                            selectedTab = 0
                        }
                        .frame(maxWidth: .infinity)
                        
                        TabBarButton(systemName: "book", title: "Courses", isSelected: selectedTab == 1) {
                            selectedTab = 1
                        }
                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                            .frame(width: 60) // Spacer for the middle tab
                        
                        TabBarButton(systemName: "megaphone", title: "Campaigns", isSelected: selectedTab == 3) {
                            selectedTab = 3
                        }
                        .frame(maxWidth: .infinity)
                        
                        TabBarButton(systemName: "person", title: "Profile", isSelected: selectedTab == 4) {
                            selectedTab = 4
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color.white.shadow(radius: 2))
                    
                    ZStack {
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    
                    .offset(y: -80)
                }.padding(.top, 20)
                .padding(.bottom, 10)
                .padding(.horizontal, 10)
                    
            }
        }

        struct TabBarButton: View {
            let systemName: String
            let title: String
            let isSelected: Bool
            let action: () -> Void
            
            var body: some View {
                Button(action: action) {
                    VStack(spacing: 4) {
                        Image(systemName: systemName)
                            .font(.title)
                            .frame(width: 15, height: 15)
                            .padding(10)
                        Text(title)
                            .font(.caption)
                    }
                    .foregroundColor(isSelected ? .blue : .gray)
                }
            }
        }
    
    struct ChartsView: View {
        let data: [String: Int]
        let formattedData: [Click]

        init(data: [String: Int]) {
            self.data = data
            self.formattedData = ChartsView.convertToClickData(data)
        }

        var body: some View {
            Chart(formattedData) { item in
                LineMark(x: .value("time", item.time),
                         y: .value("click", item.click))
            }
        }

        static func convertToClickData(_ data: [String: Int]) -> [Click] {
            var clickData: [Click] = []
            for (time, click) in data {
                clickData.append(Click(time: time, click: click))
            }
            return clickData
        }
    }
    
    struct TopLinksListView: View {
        let topLinks: [TopLink]

        var body: some View {
            VStack {
                ForEach(topLinks.indices, id: \.self) { index in
                    LinkCard(
                        image: topLinks[index].original_image ?? "",
                        linkName: topLinks[index].title ?? "",
                        date: topLinks[index].created_at ?? "",
                        clicks: topLinks[index].total_clicks ?? 0,
                        link: topLinks[index].web_link ?? ""
                    )
                }
            }
        }
    }

    struct RecentLinksListView: View {
        let recentLinks: [RecentLink]

        var body: some View {
            VStack {
                ForEach(recentLinks.indices, id: \.self) { index in
                    LinkCard(
                        image: recentLinks[index].original_image ?? "",
                        linkName: recentLinks[index].title ?? "",
                        date: recentLinks[index].created_at ?? "",
                        clicks: recentLinks[index].total_clicks ?? 0,
                        link: recentLinks[index].web_link ?? ""
                    )
                }
            }
        }
    }
    
    struct Click:Identifiable {
        var id = UUID()
        let time: String
        let click: Int
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
}
