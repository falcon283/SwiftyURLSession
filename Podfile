# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

target 'SwiftyNetwork' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxSwift'

  # Pods for SwiftyNetwork

  target 'SwiftyNetworkTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'

  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == "RxSwift"
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end