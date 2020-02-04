#
# Be sure to run `pod lib lint USE_Chat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'USE_Chat'
  s.version          = '0.2.7'
  s.summary          = 'USE_Chat.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://git.usemobile.com.br/libs-iOS/chat-controller'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tulio de Oliveira Parreiras' => 'tulio@usemobile.xyz' }
  s.source           = { :git => 'http://git.usemobile.com.br/libs-iOS/chat-controller.git', :tag => s.version.to_s }

  s.swift_version    = '4.2'
  s.ios.deployment_target = '10.0'
  
  s.source_files = 'USE_Chat/Classes/**/*'
  s.resource_bundles = {
      #      'USE_Chat' => ['USE_Chat/Assets/Media.xcassets']
      'USE_Chat' => ['USE_Chat/Assets/*.{png,jpeg,jpg,storyboard,xib,xcassets,pdf}']
  }
  s.static_framework = true
  s.frameworks = 'UIKit'
  # s.resource_bundles = {
  #   'USE_Chat' => ['USE_Chat/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
