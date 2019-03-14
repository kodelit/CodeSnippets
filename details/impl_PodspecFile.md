# Impl: Podspec
- **shortcut**: `impl_PodspecFile`
- **language**: Ruby
- **platform**: 

## Summary
.podspec file implementation template

## Code:
```ruby
# For details see: https://guides.cocoapods.org/syntax/podspec.html

Pod::Spec.new do |s|
    s.name         = "<#FrameworkName#>"
    s.version      = "0.0.1"
    s.summary      = "<#Short summary#>"
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    s.description  = <<-DESC
    <#Detailed description#>
    DESC

    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "kodelit" => "kodel.company@gmail.com" }
    s.homepage     = "https://github.com/#{s.authors.keys[0]}/#{s.name}"
    s.social_media_url = "https://www.facebook.com/#{s.authors.keys[0]}"
    s.platform     = :ios, "9.0"
    s.source       = { :git => "https://github.com/#{s.authors.keys[0]}/#{s.name}.git", :tag => "#{s.version}" }

    s.subspec 'Core' do |ss|
        subspecName = ss.name.split(File::SEPARATOR).last
        ss.source_files  = "Source/#{subspecName}/**/*.swift"
    end

    s.subspec 'FirebaseMessaging' do |ss|
        ss.dependency '<#PodName#>', '~> <#version#>'
        ss.dependency "#{s.name}/<#Core#>" # other subspec
        subspecName = ss.name.split(File::SEPARATOR).last
        ss.source_files  = "Source/#{subspecName}/**/*.swift"
    end

    s.default_subspec = 'Core'
end

```