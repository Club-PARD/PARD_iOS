//
//  ScheduleController.swift
//  PARD
//
//  Created by 김하람 on 7/3/24.
//

import UIKit

func getSchedule(for viewController: CalendarViewController) {
    if let urlLink = URL(string: url + "/schedule") {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlLink) { data, response, error in
            if let error = error {
                print("🚨 Error:", error)
                return
            }
            if let JSONdata = data {
                // 응답 데이터를 문자열로 변환하여 출력
                if let dataString = String(data: JSONdata, encoding: .utf8) {
                    print("✅ Get Schedule Response Data String: \(dataString)")
                }
                
                let decoder = JSONDecoder()
                do {
                    let schedules = try decoder.decode([ScheduleModel].self, from: JSONdata)
                    print("✅ Success: \(schedules)")
                    
                    DispatchQueue.main.async {
                        viewController.schedules = schedules
                        viewController.updateEvents()
                    }
                } catch {
                    print("🚨 Decoding Error:", error)
                }
            }
        }
        task.resume()
    }
}

class ScheduleDataList {
    static let shared = ScheduleDataList()
    var error: Error? = nil
    var scheduleDataList: [ScheduleModel] = []
    
    func getSchedule(completion: @escaping (Result<[ScheduleModel], ScheduleFetchError>) -> Void) {
        guard let urlLink = URL(string: url + "/schedule") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlLink) { data, response, error in
            if let error = error {
                print("🚨 Error:", error)
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Logging the response data as string (optional)
            if let dataString = String(data: data, encoding: .utf8) {
                print("✅ Get Schedule Response Data String: \(dataString)")
            }
            
            let decoder = JSONDecoder()
            do {
                let schedules = try decoder.decode([ScheduleModel].self, from: data)
                print("✅ Success: \(schedules)")
                completion(.success(schedules))
            } catch let decodingError {
                print("🚨 Decoding Error:", decodingError)
                completion(.failure(.decodingError(decodingError)))
            }
        }
        
        task.resume()
    }
//    func getData() {
//
//    }
}

enum ScheduleFetchError: Error {
    case invalidURL
    case requestFailed
    case noData
    case decodingError(Error)
}


