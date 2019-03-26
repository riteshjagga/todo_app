object @tags_response
node(:count) { @tags_response["count"]}
node(:tags) do
collection @tags_response["tags"], :object_root => false
attributes :id, :name, :created_at, :updated_at
# node(:todo_items_count) { |tag| tag.todo_ids.length }
end