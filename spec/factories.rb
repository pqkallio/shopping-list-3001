FactoryGirl.define do
  factory :user do
    firstname "Pete"
    lastname "Kallio"
    username "petekallio"
    email "petekallio@kallio.fi"
    password "S4l4s4n4"
    password_confirmation "S4l4s4n4"
  end

  factory :list do
    name "Kauppalista"
    user
  end

  factory :product do
    name "kurkku"
  end

  factory :product2, class: Product do
    name "nakki"
  end

  factory :purchase do
    product
    list
  end

  factory :purchase2, class: Purchase do
    product2
    list
  end
end