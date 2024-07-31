# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'DailyshotClone' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DailyshotClone
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'NSObject+Rx'
  pod 'RxDataSources'
  pod 'NMapsMap'
  pod 'Cosmos'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseDatabase'
  pod 'FirebaseStorage'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
end