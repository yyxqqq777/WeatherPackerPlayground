import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

var city = "Berlin"

let cityToLngAndLatUrl = "https://geocoding-api.open-meteo.com/v1/search?name=\(city)"

var lat: Float = 0.0
var lng: Float = 0.0

// Your structs go here
struct Results: Decodable {
  let citys: [City]

  enum CodingKeys : String, CodingKey {
    case citys = "results"
  }
}

struct City: Decodable {
  let latitude: Float
  let longitude: Float

  enum CodingKeys : String, CodingKey {
    case latitude = "latitude"
    case longitude = "longitude"
  }
}

let searchCityTask = URLSession.shared.dataTask(with: URL(string: cityToLngAndLatUrl)!) { (data, response, error) in
  guard let data = data else {
    print("Error: No data to decode")
    return
  }

  // Decode the JSON here
  guard let result = try? JSONDecoder().decode(Results.self, from: data) else {
    print("Error: Couldn't decode data into a result")
    return
}


  print("Latitude of \(city) is \(result.citys[0].latitude)")
  print("Longitude of \(city) \(result.citys[0].longitude)")
  lat = result.citys[0].latitude
  lng = result.citys[0].longitude

  
  let weatherForcastUrl = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lng)&hourly=temperature_2m&hourly=weathercode"
  

  struct WeatherForecast: Decodable {
    let hourly: Temperature_2m
    
    enum CodingKeys : String, CodingKey {
      case hourly = "hourly"
    }
  }

  struct Temperature_2m: Decodable {
    let temperature_2m: [Float]

    enum CodingKeys : String, CodingKey {
      case temperature_2m
    }
  }

  struct HourlyTemp: Decodable {
    let hourly: Float

    enum CodingKeys : String, CodingKey {
      case hourly = "hourly"
    }
  }

  let searchWeatherTask = URLSession.shared.dataTask(with: URL(string: weatherForcastUrl)!) { (data, response, error) in
    guard let data = data else {
      print("Error: No data to decode")
      return
    }
    
    // Decode the JSON here
    guard let result = try? JSONDecoder().decode(WeatherForecast.self, from: data) else {
      print("Error: Couldn't decode data into a result")
      return
  }
    
    var day1: [Float] = Array(result.hourly.temperature_2m[0...23])
    var day2: [Float] = Array(result.hourly.temperature_2m[24...47])
    var day3: [Float] = Array(result.hourly.temperature_2m[48...71])
    var day4: [Float] = Array(result.hourly.temperature_2m[72...95])
    var day5: [Float] = Array(result.hourly.temperature_2m[96...119])
    var day6: [Float] = Array(result.hourly.temperature_2m[120...143])
    var day7: [Float] = Array(result.hourly.temperature_2m[144...167])
    
    print("Temperature of day1 is\n \(day1)")
    print("Temperature of day2 is\n \(day2)")
    print("Temperature of day3 is\n \(day3)")
    print("Temperature of day4 is\n \(day4)")
    print("Temperature of day5 is\n \(day5)")
    print("Temperature of day6 is\n \(day6)")
    print("Temperature of day7 is\n \(day7)")
  }

  searchWeatherTask.resume()

}

searchCityTask.resume()

