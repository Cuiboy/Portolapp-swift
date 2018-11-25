# Uncomment the next line to define a global platform for your project

platform :ios, '10.0'

target 'PHS App' do

  use_frameworks!

  # Pods for PHS App
pod 'RSBarcodes_Swift' , '~> 4.2.0'
pod 'Segmentio', '~> 3.0'
pod 'ExpandableCell'
pod 'TextFieldEffects'
pod 'JTAppleCalendar', '~> 7.0'
pod 'XLActionController'
pod 'XLActionController/Periscope'
pod 'XLActionController/Skype'
pod 'XLActionController/Spotify'
pod 'XLActionController/Tweetbot'
pod 'XLActionController/Twitter'
pod 'XLActionController/Youtube'
pod "SwiftyXMLParser"
pod "SDWebImage", '~> 4.0'
pod "PickerView"

pod 'OneSignal', '>= 2.6.2', '< 3.0'





pod 'Firebase/Core'
pod 'Fabric', '~> 1.7.11'
pod 'Crashlytics', '~> 3.10.7'
pod 'Firebase/Messaging'


  target 'PHS AppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PHS AppUITests' do
    inherit! :search_paths
    # Pods for testing

  end

 

  
end

   target 'OneSignalNotificationServiceExtension' do
	use_frameworks!
     pod 'OneSignal', '>= 2.6.2', '< 3.0'
  end


post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
