# coding: utf-8
#
# Be sure to run `pod lib lint ECacheProgress.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ECacheProgress'
  s.version          = '0.2.3'
  s.summary          = '带有两层进度的进度条，用于视频音频缓冲的展示'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lazyjean/ECacheProgress'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lazyjean' => 'lazyjean@foxmail.com' }
  s.source           = { :git => 'https://github.com/lazyjean/ECacheProgress.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'ECacheProgress/**/*'
  s.frameworks = 'UIKit'
end
