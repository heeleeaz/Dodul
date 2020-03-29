# Uncomment the next line to define a global platform for your project
 platform :osx, '10.13'
# use_frameworks!

workspace 'Touchlet'

project 'TouchletCore/TouchletCore.xcodeproj'
project 'TouchletMenu/TouchletMenu.xcodeproj'
project 'TouchletMenu/UpdateService/UpdateService.xcodeproj'
project 'TouchletPanel/TouchletPanel.xcodeproj'



def global_pod
  pod 'HotKey'
end

target 'TouchletCore' do
  project 'TouchletCore/TouchletCore.xcodeproj'
end

target 'TouchletMenu' do
  project 'TouchletMenu/TouchletMenu.xcodeproj'
  global_pod
end

target 'TouchletPanel' do
  project 'TouchletPanel/TouchletPanel.xcodeproj'
  global_pod
end

target 'UpdateService' do
  project 'TouchletMenu/UpdateService/UpdateService.xcodeproj'
  global_pod
end



