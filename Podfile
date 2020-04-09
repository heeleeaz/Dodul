# Uncomment the next line to define a global platform for your project
platform :macos, '10.13'

workspace 'Touchlet'


target 'Touchlet' do
  use_frameworks!
  pod 'HotKey'
end

target 'TouchletPanel' do
  project 'Touchlet/Wrapper/TouchletPanel/TouchletPanel.xcodeproj'
  pod 'HotKey'
end

target 'TouchletCore' do
  project 'TouchletCore/TouchletCore.xcodeproj'
end

target 'UpdateService' do
  project 'Touchlet/Wrapper/UpdateService/UpdateService.xcodeproj'
end

target 'LaunchHelper' do
  project 'Touchlet/Wrapper/LaunchHelper/LaunchHelper.xcodeproj'
end
