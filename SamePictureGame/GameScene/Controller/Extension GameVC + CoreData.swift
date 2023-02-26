//
//  Extension GameVC + CoreData.swift
//  SamePictureGame
//
//  Created by 김지수 on 2022/12/13.
//

import UIKit
import CoreData

extension GameSceneViewController {
    
    //MARK: - 저장하기
    func saveCoreData(name: String, time: Int, life: Int) {
        
        print(name)
        print(time)
        print(life)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
              
        let entity = NSEntityDescription.entity(forEntityName: "RankList", in: context)
                
        if let entity = entity {
            print(entity)
            let person = NSManagedObject(entity: entity, insertInto: context)
            person.setValue(name, forKey: "name")
            person.setValue(time, forKey: "time")
            person.setValue(life, forKey: "life")
          
            do {
              try context.save()
            } catch {
              print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - 읽기
    func readCoreData() throws -> [NSManagedObject]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Entity의 fetchRequest 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Rank")
        
        // 정렬 또는 조건 설정
        //    let sort = NSSortDescriptor(key: "createDate", ascending: false)
        //    fetchRequest.sortDescriptors = [sort]
        //    fetchRequest.predicate = NSPredicate(format: "isFinished = %@", NSNumber(value: isFinished))
        
        do {
            // fetchRequest를 통해 managedContext로부터 결과 배열을 가져오기
            let resultCDArray = try managedContext.fetch(fetchRequest)
            return resultCDArray
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
}
