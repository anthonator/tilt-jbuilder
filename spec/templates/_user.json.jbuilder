json.id user[:id]
json.profile do |json|
  json.partial! 'spec/templates/profile', profile: user[:profile]
end