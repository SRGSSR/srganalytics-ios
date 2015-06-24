source 'ssh://git@bitbucket.org/rtsmb/srgpodspecs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'
workspace 'SRGAnalytics.xcworkspace'

pod 'comScore-iOS-SDK-RTS', '3.1504.30'
pod 'SRGMediaPlayer', '~> 0.5.2'

target :'SRGAnalyticsTests', :exclusive => true do
    pod 'OCMock', '~> 3.1.2'
end

### Demo project

target 'SRGAnalytics Demo', :exclusive => true do
	xcodeproj 'RTSAnalytics Demo/SRGAnalytics Demo'
	pod 'SRGAnalytics',               { :path => '.' }
	pod 'SRGAnalytics/MediaPlayer',   { :path => '.' }
	pod 'SRGMediaPlayer',             '~> 0.5.2'
end

target 'SRGAnalytics DemoTests', :exclusive => true do
	xcodeproj 'RTSAnalytics Demo/SRGAnalytics Demo'
    pod 'SRGAnalytics',               { :path => '.' }
    pod 'SRGAnalytics/MediaPlayer',   { :path => '.' }
	pod 'KIF', '3.2.1'
end

post_install do |installer|
    
    installer.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2' # iPhone, iPad
#            config.build_settings['TARGETED_DEVICE_FAMILY'] = '2'
        end
    end
    
end

