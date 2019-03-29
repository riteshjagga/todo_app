require 'rails_helper'

RSpec.describe 'Tag API', type: :request do

  let!(:tags) {create_list(:tag, 10)}
  let!(:tag) {tags.first}
  let(:tag_id) {tags.first.id}

  describe 'GET /tags' do
    context 'when query parameters are NOT provided' do
      it 'returns all tags' do
        get "/tags"
        json = JSON.parse(response.body)
        expect(json['tags'].size).to eq(10)
      end
    end

    context 'when query parameters are provided' do
      it 'returns paginated list of tags' do
        page = 1
        items_per_page = 10
        get "/tags?page=#{page}&items_per_page=#{items_per_page}"
        json = JSON.parse(response.body)
        expect(json['tags'].size).to eq(10)
      end
    end
  end

  describe 'GET /tags/:id' do
    it 'gets a tag' do
      get "/tags/#{tag_id}"
      json = JSON.parse(response.body)
      puts "json = #{json}"
      expect(response).to match_response_schema("tag")
    end
  end

  describe 'GET /tags/:name/todos' do
    it 'gets todos associated with tag name' do
      todo_1 = tag.todos.create({title: "Todo Item 1"})
      todo_2 = tag.todos.create({title: "Todo Item 2"})
      todo_2 = tag.todos.create({title: "Todo Item 3"})
      get "/tags/#{tag.name}/todos"
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
    end
  end

  describe 'POST /tags' do
    let(:valid_attributes) {{tag: {name: 'Flowers'}}}

    context 'when the request is valid' do
      before {post '/tags', valid_attributes}

      it 'creates a tag' do
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Flowers')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when request is NOT valid' do
      before {post '/tags', {tag: {name: ''}}}

      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure messages' do
        expect(response.body).to match(/can't be blank/)
        expect(response.body).to match(/is too short/)
      end
    end
  end

  describe 'PUT /tags/:id' do
    context 'when request is valid' do
      before {put "/tags/#{tag_id}", {tag: {name: 'Florals'}}}

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when request is NOT valid' do
      before {put "/tags/#{tag_id}", {tag: {name: ''}}}

      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure messages' do
        expect(response.body).to match(/can\'t be blank/)
        expect(response.body).to match(/is too short/)
      end
    end
  end

end