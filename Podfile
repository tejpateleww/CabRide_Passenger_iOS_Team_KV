# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'Chick Pick' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Peppea
pod 'SkyFloatingLabelTextField'
pod 'IQKeyboardManagerSwift'
pod 'Alamofire'
#pod 'Fabric'
#pod 'Crashlytics'
pod 'IQDropDownTextField'
pod 'MultiSlider'
pod 'SideMenuSwift'
pod 'lottie-ios'
pod 'SwiftMessages'
pod 'GoogleMaps', '= 3.0.3'
pod 'GooglePlaces', '= 3.0.3'
pod 'Cosmos'
pod 'QRCodeReader.swift'
pod 'CardIO'
pod 'FormTextField'
pod 'Firebase/Crashlytics'
#pod 'Firebase/Analytics'
pod 'Firebase/Messaging'
pod 'SDWebImage'
pod 'SwiftyJSON'
pod 'MarqueeLabel/Swift'
pod 'Socket.IO-Client-Swift'
pod 'lottie-ios'
pod 'ActionSheetPicker-3.0'
pod 'SwipeCellKit', '2.5.4'

  # Pods for Peppea Rental
  pod 'FSCalendar'
  pod 'RKMultiUnitRuler'
  pod 'TTSegmentedControl'
  # pod "CRRulerControl"

pod 'SwiftyAttributes'
pod 'DropDown', '2.3.2'
pod 'NVActivityIndicatorView'

  
  
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end
end
