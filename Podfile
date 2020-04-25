# Uncomment the next line to define a global platform for your project
platform :macos, '10.13'

workspace 'Touchlet'


target 'Touchlet' do
  use_frameworks!
  pod 'FavIcon'
end

target 'UpdateService' do
  project 'Meta/Wrapper/UpdateService/UpdateService.xcodeproj'
end

target 'LaunchHelper' do
  project 'Meta/Wrapper/MetaLaunchAgent/MetaLaunchAgent.xcodeproj'
end

target 'TouchletPanel' do
  project 'Meta/Wrapper/TouchletPanel/TouchletPanel.xcodeproj'
end
