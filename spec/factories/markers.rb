FactoryGirl.define do
  factory :marker do
    title :title
  end

  factory :empty_marker, class: Marker do; end

  factory :filled_marker, class: Marker do
    title { some_name }
  end
end