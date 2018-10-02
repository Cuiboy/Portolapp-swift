# Uncomment the next line to define a global platform for your project

platform :ios, '10.0'

target 'PHS App' do

  use_frameworks!

  # Pods for PHS App
pod 'RSBarcodes_Swift'
pod 'Segmentio'
pod 'ExpandableCell'
pod 'TextFieldEffects'
pod 'JTAppleCalendar'
pod 'XLActionController'
pod 'XLActionController/Periscope'
pod 'XLActionController/Skype'
pod 'XLActionController/Spotify'
pod 'XLActionController/Tweetbot'
pod 'XLActionController/Twitter'
pod 'XLActionController/Youtube'
pod "SwiftyXMLParser"
pod "SDWebImage"
pod "PickerView"

pod 'Firebase/Core'
pod 'Fabric', '~> 1.7.11'
pod 'Crashlytics', '~> 3.10.7'

  target 'PHS AppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PHS AppUITests' do
    inherit! :search_paths
    # Pods for testing

  end

  
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
