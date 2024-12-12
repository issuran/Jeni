# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Jeni' do
  use_frameworks!

  # Firebase pods
  pod 'Firebase/CoreOnly'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'

  # Exclude arm64 architecture for iOS simulators
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        # Set default architectures to prevent unbound ARCHS variable errors
        config.build_settings['ARCHS'] ||= '$(ARCHS_STANDARD)'
      end
    end
  end
end
