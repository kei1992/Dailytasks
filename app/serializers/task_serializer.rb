class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_done, :created_at, :updated_at
end

# JSONで下記のような情報が渡るようになる
# {"id":"XXX","name":"XXX","is_done":"XXX","created_at":"XXX","updated_at":"XXX"}
