class FriendshipSerializer < ActiveModel::Serializer
  attributes :id, :person_id, :friend_id
end
