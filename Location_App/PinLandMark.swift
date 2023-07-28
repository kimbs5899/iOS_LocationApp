//
//  PinLandMark.swift
//  Location_App
//
//  Created by Designer on 2023/07/11.
//

import Foundation
import MapKit

enum PinLandmark: Int, CaseIterable {
    case Deoksugung = 100
    case Gyeongbokgung = 200
    case SeoulCityHall = 300
}

extension PinLandmark {
    var title: String {
        // \(값) -> 값을 String으로 바꿔준다는 표시
        return "\(self)"
    }
    var id: Int {
        self.rawValue
    }
    // 좌표계
    var cordinate: CLLocationCoordinate2D {
        switch self {
        case .Deoksugung:
            return .init(latitude: 37.5658049, longitude: 126.9751461)
        case .Gyeongbokgung:
            return .init(latitude: 37.5662952, longitude: 126.9779451)
        case .SeoulCityHall:
            return .init(latitude: 37.5785635, longitude: 126.9769535)
        }
    }
    
    var url: URL? {
        switch self {
        case .Deoksugung:
            return URL(string: "http://www.deoksugung.go.kr")
        case .Gyeongbokgung:
            return URL(string: "https://www.royalpalace.go.kr")
        case .SeoulCityHall:
            return URL(string: "https://www.seoul.go.kr/")
        }
    }
    
}
