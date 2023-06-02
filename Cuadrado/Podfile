source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "13.0"
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod "Capsule", "0.1.2"
  pod "Utensils", "0.0.9"

  pod "SDWebImage", "5.3.2"
end

target "Cuadrado" do
  shared_pods
end

target "Specs" do
  shared_pods

  pod "Quick", "2.2.0"
  pod "Nimble", "8.0.4"
end
