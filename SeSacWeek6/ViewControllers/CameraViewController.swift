//
//  CameraViewController.swift
//  SeSacWeek6
//
//  Created by 신동희 on 2022/08/12.
//

import UIKit

import YPImagePicker

// PHPicker 1.
import PhotosUI


class CameraViewController: UIViewController {

    @IBOutlet weak var resultImageView: UIImageView!
    
    // UIImagePickerController1. 컨트롤러 인스턴스 생성
    let picker = UIImagePickerController()
    
    // PHPicker2. 인스턴스 선언
    var phpicker: PHPickerViewController!
    
    // YPImagePicker 인스턴스
    let ypPicker = YPImagePicker()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIImagePickerController2. Delegate 설정
        picker.delegate = self
        
        
        // PHPicker4. 인스턴스 생성 및 Delegate 설정
        phpicker = makePHPickerInstance()
        phpicker?.delegate = self
        
        setYPPicker()
    }
    
    
    // MARK: - Method
    
    func setYPPicker() {
        ypPicker.didFinishPicking { [unowned ypPicker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImageView.image = photo.image
            }
            ypPicker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // OpenSource
    // 권한은 다 허용 (일단)
    // 권한 문구 등도 내부적으로 구현되어 있음 => 실제로 카메라를 쓸 때 권한을 요청 (정책적인.. 그런거.. 권한이 필요한 상황에서 요청해야 함)
    @IBAction func ypimagePickerButtonTapped(_ sender: UIButton) {
        present(ypPicker, animated: true, completion: nil)
    }
    
    
    // UIImagePickerController
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        // 기기에서 해당 기능이 사용 가능한지 여부를 파악
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용자에게 사용불가하다고 알려주기 : 얼럿, 토스트")
            return
        }
        
        // 어떤 기능을 사용할건지 (picker에서)
        picker.sourceType = .camera
        
        // 편집 가능 여부 (Default : false)
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    
    // PHPickerViewController Test
    @IBAction func photoLibraryButtonTapped(_ sender: UIButton) {
        present(phpicker, animated: true)
    }
    
    
    // 이미지 저장
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        if let image = resultImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    
    // 네이버 클로바 Face API Button
    // 이미지뷰 이미지 -> 네이버 -> 얼굴 분석 해줘 요청 -> 응답
    // 문자열이 아닌 파일, 이미지, PDF 파일 자체가 그대로 전송 되지 않음. => 텍스트 형태로 인코딩하여 보내야 함
    // 어떤 종류의 파일이 서버에게 전달되는지 명시하는 코드가 필요함 -> Content-Type
    @IBAction func clovaFaceButtonTapped(_ sender: UIButton) {
        
        if let image = resultImageView.image {
            ClovaFaceAPIManager.shared.requestCFR(image: image)
        }
        
    }
    
    
    
    
    // MARK: - PHPickerViewController
    func makePHPickerInstance() -> PHPickerViewController {
        // PHPicker3. PHPickerViewController를 구성하는 정보를 포함한 구조체 인스턴스를 생성 (PHPickerConfiguration)
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3            // 최대 선택 가능 개수 (다중 선택 지원)
        configuration.filter = .images              // 표시하는 데이터 유형 (4가지 종류가 있다.)

        let phpickerVC = PHPickerViewController(configuration: configuration)
        
        return phpickerVC
    }
}




// MARK: - UIImagePickerController Protocol 채택
// UIImagePickerController3.
// 내부적으로 네비게이션 컨트롤러를 상속받고 있음
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerController4.
    // 사진 선택하거나, 카메라 촬영 직후에 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        // 이미지에는 다양한 정보가 있음 (원본, 편집본, 메타데이터 등.. => infoKey 매개변수로 옴)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.resultImageView.image = image
            dismiss(animated: true)
        }
    }
    
    // 취소 버튼 클릭했을 때 호출
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    }
}



// PHPicker5. Delegate 채택
extension CameraViewController: PHPickerViewControllerDelegate {
    
    // PHPicker6. 필수 메서드 구현 (선택이 완료되면 호출)
    // 다중 선택을 지원하므로, 매개변수로 들어온 선택값이 배열 형태
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let selectedImage = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self?.resultImageView.image = selectedImage
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    
}
