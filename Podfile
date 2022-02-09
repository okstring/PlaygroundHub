# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PlaygroundHub' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PlaygroundHub

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxViewController'
  pod 'Alamofire'
  pod 'NSObject+Rx'
  pod 'SnapKit'
  pod 'RxSwiftExt'
  pod 'KeychainAccess'
  pod 'lottie-ios'
  pod 'Action'
  pod 'Carte'
  
  
  post_install do |installer|
    pods_dir = File.dirname(installer.pods_project.path)
    at_exit { `ruby #{pods_dir}/Carte/Sources/Carte/carte.rb configure` }
  end

end
