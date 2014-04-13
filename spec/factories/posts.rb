FactoryGirl.define do
  factory :post do
    title   :title
    content :content
  end

  factory :empty_post, class: Post do; end

  factory :filled_post, class: Post do
    title   { some_string }
    content { some_text   }
  end

  factory :filled_post_marked_with_2_markers_on_2_contexts, class: Post do
    title   { some_string }
    content { some_text   }

    after(:create) do |post, evaluator|
      post.set_marker "Bruce Willis", on: :actors
      post.set_marker "Demi Moore",   on: :stars
    end
  end
end