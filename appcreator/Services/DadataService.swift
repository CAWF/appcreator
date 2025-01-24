import Foundation
import Combine

struct DadataService {
    private static let apiKey = "ed9537e77879bac23b4ff9f030c70da804627d3b"
    private static let apiUrl = "http://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/party"
    
    static func searchParty(query: String) -> AnyPublisher<DadataResponse, Error> {
        guard let url = URL(string: apiUrl) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["query": query]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: DadataResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct DadataResponse: Codable {
    let suggestions: [PartySuggestion]
}

struct PartySuggestion: Codable, Identifiable, Equatable {
    let id = UUID()
    let value: String
    let unrestricted_value: String
    let data: PartyData
    
    static func == (lhs: PartySuggestion, rhs: PartySuggestion) -> Bool {
        lhs.id == rhs.id
    }
}

struct PartyData: Codable, Equatable {
    let kpp: String?
    let management: Management?
    let branch_type: String?
    let branch_count: Int?
    let type: String?
    let state: CompanyState?
    let opf: OPF?
    let name: Name
    let inn: String
    let ogrn: String?
    let okpo: String?
    let okved: String?
    let ogrn_date: Int64?
    let address: Address?
    
    static func == (lhs: PartyData, rhs: PartyData) -> Bool {
        lhs.kpp == rhs.kpp &&
        lhs.management == rhs.management &&
        lhs.branch_type == rhs.branch_type &&
        lhs.branch_count == rhs.branch_count &&
        lhs.type == rhs.type &&
        lhs.state == rhs.state &&
        lhs.opf == rhs.opf &&
        lhs.name == rhs.name &&
        lhs.inn == rhs.inn &&
        lhs.ogrn == rhs.ogrn &&
        lhs.okpo == rhs.okpo &&
        lhs.okved == rhs.okved &&
        lhs.ogrn_date == rhs.ogrn_date &&
        lhs.address == rhs.address
    }
}

struct Management: Codable, Equatable {
    let name: String?
    let post: String?
    
    static func == (lhs: Management, rhs: Management) -> Bool {
        lhs.name == rhs.name && lhs.post == rhs.post
    }
}

struct CompanyState: Codable, Equatable {
    let status: String?
    let actuality_date: Int64?
    let registration_date: Int64?
    
    static func == (lhs: CompanyState, rhs: CompanyState) -> Bool {
        lhs.status == rhs.status && lhs.actuality_date == rhs.actuality_date && lhs.registration_date == rhs.registration_date
    }
}

struct OPF: Codable, Equatable {
    let type: String?
    let code: String?
    let full: String?
    let short: String?
    
    static func == (lhs: OPF, rhs: OPF) -> Bool {
        lhs.type == rhs.type && lhs.code == rhs.code && lhs.full == rhs.full && lhs.short == rhs.short
    }
}

struct Name: Codable, Equatable {
    let full_with_opf: String
    let short_with_opf: String?
    let full: String?
    let short: String?
    
    static func == (lhs: Name, rhs: Name) -> Bool {
        lhs.full_with_opf == rhs.full_with_opf && lhs.short_with_opf == rhs.short_with_opf && lhs.full == rhs.full && lhs.short == rhs.short
    }
}

struct Address: Codable, Equatable {
    let value: String?
    let unrestricted_value: String?
    let data: AddressData?
    
    static func == (lhs: Address, rhs: Address) -> Bool {
        lhs.value == rhs.value && lhs.unrestricted_value == rhs.unrestricted_value && lhs.data == rhs.data
    }
}

struct AddressData: Codable, Equatable {
    let postal_code: String?
    let country: String?
    let region_with_type: String?
    let city_with_type: String?
    let street_with_type: String?
    let house: String?
    let block: String?
    let flat: String?
    
    static func == (lhs: AddressData, rhs: AddressData) -> Bool {
        lhs.postal_code == rhs.postal_code && lhs.country == rhs.country && lhs.region_with_type == rhs.region_with_type && lhs.city_with_type == rhs.city_with_type && lhs.street_with_type == rhs.street_with_type && lhs.house == rhs.house && lhs.block == rhs.block && lhs.flat == rhs.flat
    }
}


