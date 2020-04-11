# Uncomment the next line to define a global platform for your project
platform :macos, '10.13'

workspace 'Touchlet'


target 'Touchlet' do
  use_frameworks!
  pod 'FavIcon'
end

target 'UpdateService' do
  project 'Touchlet/Wrapper/UpdateService/UpdateService.xcodeproj'
end

target 'LaunchHelper' do
  project 'Touchlet/Wrapper/LaunchHelper/LaunchHelper.xcodeproj'
end

target 'TouchletPanel' do
  project 'Touchlet/Wrapper/TouchletPanel/TouchletPanel.xcodeproj'
end
