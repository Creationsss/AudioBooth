import Foundation

public struct FilterData: Codable, Sendable {
  public struct Author: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
      self.id = id
      self.name = name
    }
  }

  public struct Series: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
      self.id = id
      self.name = name
    }
  }

  public let authors: [Author]
  public let genres: [String]
  public let tags: [String]
  public let series: [Series]
  public let narrators: [String]
  public let languages: [String]
  public let publishers: [String]
  public let publishedDecades: [String]

}
