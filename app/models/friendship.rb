class Friendship < ApplicationRecord
  belongs_to :person
  belongs_to :friend, class_name: 'Person'
end
