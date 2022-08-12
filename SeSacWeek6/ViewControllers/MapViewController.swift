//
//  MapViewController.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/11.
//

import UIKit
import MapKit
// Location1. 임포트
import CoreLocation

/*
 MapView
 - 지도와 위치 권한은 상관 X
 - 만약 지도에 현재 위치 등을 표현하고 싶다면 위치 권한을 등록해주어야 함
 - 중심, 범위 지정
 - 핀 (어노테이션)
 */

/*
 권한 :
 - 어느정도 데이터가 캐싱되어 저장되어 있음, 그래서 권한 거부하면 다시 안나오는거
 - 반영이 조금 느릴 수 있음, 지웠다가 다시 설치한다고 바로 반영되는게 아닐 수 있다.
 
 설정 :
 - 앱이 바로 안 뜨는 경우도 있을 수 있음.
 */


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // Location2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location3. 프로토콜 연결
        locationManager.delegate = self
        
        //  => 앱 실행될 때, 호출됨 => 권한 상태가 변경되거나 인스턴스가 생성되면 호출하도록 설정해놨슴 (제거 가능한 이유 명확하게 알기!)
//        checkUserDeviceLocationServiceAuthorization()
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegionAndAnnotation(center: center)
    }
    
    
    // Alert 테스트
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //showRequestLocationServiceAlert()
    }
    
    
    
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
//        // 지도 중심 설정 : 애플맵 활용하여 좌표 복사 37.517829, 126.886270
//        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        
        // 지도 중심 기반으로 보여질 범위를 알려줌
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        
        // 지도에 핀 추가
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "SeSac!"
        
        mapView.addAnnotation(annotation)
    }
}




// 위치 관련된  User Defined 메서드
extension MapViewController {
    
    // Location7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
    // 실질적으로 가장 먼저 동작할 메서드
    // 위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져 있다면 커스텀 얼럿으로 상황 알려주기
    
    // CLAuthorizationStatus
    // denined: 허용 안함 / 설정에서 추후에 거부된 / 위치 서비스 중지 / 비행기 모드
    // restricted : 앱에 권한 자체가 없는 경우 / 자녀 보호 기능 같은걸로 아예 제한된 상황
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            // 인스턴스 프로퍼티를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        }else {
            // CLLocationManager의 타입 메서드로 가져옴 (구조만 변경된..)
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 체크 : locationServicesEnabled() -> Bool
        if CLLocationManager.locationServicesEnabled() {
            // 위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능해서 위치 권한 요청을 함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        }else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    
    // Location8. 사용자의 위치 권한 상태 확인 (앱에 대한)
    // 사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인 (단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest  // Best : 알아서 적당하게..
            locationManager.requestWhenInUseAuthorization()            // 앱을 사용하는 동안에 대한 위치 권한 요청
            // info plist에 등록이 되어있어야 request가 성공적으로 됨
            
            // 결국 When In Use 상태가 되면 startUpdatingLocation 호출되도록 해뒀음
            //locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:       // 항상 사용하는 case도 사용하려면 info.plist에 해당 내용 추가해야 함.
            print("WHEN IN USE")
            // 사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
            // Location5의 프로토콜 메서드가 실행됨(?)
            locationManager.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
    
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          // Apple이 만들어둠 (형식)
          // 설정까지 이동하거나 설정 세부화면까지 이동하거나 => 랜덤..
          // 한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 .. 
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}



// MARK: - CLLocationManager Protocol
// Location4. 프로토콜 채택
extension MapViewController: CLLocationManagerDelegate {
    
    // Location5. 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            // 타입이 맞아서 이건 생략 가능
//            let latitude = coordinate.latitude
//            let longitude = coordinate.longitude
//            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            setRegionAndAnnotation(center: coordinate)
        }
        
        // ex. 위도 경도 기반으로 날씨 정보를 조회
        // ex. 지도를 다시 세팅 (내 위치를 기반으로)
        
        // 위치 업데이트 멈춰!! => 무한 업데이트하는거 방지 => 실제 위치가 변경되면 위에 best 저게 바뀐거 적용 알아서 해줌..(?)
        // 적당한 시점에 멈춰주지 않으면 배터리를 많이 잡아먹는 문제가 될지도..
        //locationManager.stopUpdatingLocation()
    }
    
    
    // Location6. 사용자의 위치를 못 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    
    // Location9. 사용자의 권한 상태가 바뀔 때 알려줌
    // ex) 거부했다가 설정에서 변경했거나, 혹은 notDetermined에서 허용을 했거나 등
    // 허용했어서 위치를 가져오는 중에, 설정에서 거부하고 돌아온다면?? 흔하지 않지만 혹시 모름..
    // iOS 14 이상 : 사용자의 권한 상태가 변경이 될 때, 위치 관리자를 생성할 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()  // 상태가 변경되면 ,,, 다시 처음부터 권환 확인이 필요,,
    }
    
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
    }
}




// MARK: - MapView Protocol
extension MapViewController: MKMapViewDelegate {
    
    // 지도에 커스텀 핀 추가하기
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
    
    
    // regionDidChangeAnimated : 지도를 움직이는게 끝나면 호출
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        // 위치를 다시 가져오도록 (지도 움지였으면)
//        locationManager.startUpdatingLocation()
//    }
}
