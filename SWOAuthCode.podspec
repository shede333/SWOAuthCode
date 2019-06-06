#
# Be sure to run `pod lib lint SWOAuthCode.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SWOAuthCode'
  s.version          = '0.1.0'
  s.summary          = 'OAuth Code View / 显示验证码的View'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
OAuth Code View / 显示验证码的View
                       DESC

  s.homepage         = 'https://github.com/shede333/SWOAuthCode'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shede333' => '333wshw@163.com' }
  s.source           = { :git => 'git@github.com:shede333/SWOAuthCode.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SWOAuthCode/Classes/**/*'

  s.prefix_header_file = 'SWOAuthCode/Classes/OSWOAuthCode-prefix.pch'
  
  # s.resource_bundles = {
  #   'SWOAuthCode' => ['SWOAuthCode/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry', '~> 1.1.0'
end
