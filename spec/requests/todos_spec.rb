require 'rails_helper'

RSpec.describe 'Todo API', type: :request do

  let!(:todos) {create_list(:todo, 10)}
  let(:todo_id) {todos.first.id}
  let(:page) {1}
  let(:items_per_page) {10}

  describe 'GET /todos' do
    context 'when query parameters are NOT provided' do
      it 'returns first page of 5 todo items' do
        get "/todos"
        json = JSON.parse(response.body)
        expect(json['todos'].size).to eq(5)
      end
    end

    context 'when query parameters are provided'  do
      it 'returns paginated todo items' do
        get "/todos?page=#{page}&items_per_page=#{items_per_page}"
        json = JSON.parse(response.body)
        expect(json['todos'].size).to eq(10)
      end
    end
  end

  describe 'GET /todos/:id' do
    it 'gets todo item' do
      get "/todos/#{todo_id}"
      json = JSON.parse(response.body)
      expect(response).to match_response_schema("todo")
    end
  end

  describe 'POST /todos' do
    let(:valid_attributes) {{todo: {title: 'Listen Romantic Songs'}}}

    context 'when the request is valid' do
      before {post '/todos', valid_attributes}

      it 'creates a todo' do
        json = JSON.parse(response.body)
        expect(json['title']).to eq('Listen Romantic Songs')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when request is NOT valid' do
      before {post '/todos', {todo: {title: ''}}}

      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure messages' do
        expect(response.body).to match(/can't be blank/)
        expect(response.body).to match(/is too short/)
      end
    end
  end

  describe 'PUT /todos/:id' do
    context 'when request is valid' do
      before {put "/todos/#{todo_id}", {todo: {title: 'Go home and relax'}}}

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when request is NOT valid' do
      before {put "/todos/#{todo_id}", {todo: {title: ''}}}

      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure messages' do
        expect(response.body).to match(/can\'t be blank/)
        expect(response.body).to match(/is too short/)
      end
    end
  end

  describe 'PATCH /todos/:id/update_status' do
    context 'when request is valid' do
      before {patch "/todos/#{todo_id}/update_status", {status: 'started'}}

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns updated status' do
        json = JSON.parse(response.body)
        expect(json['_status']).to eq('started')
      end
    end

    context 'when request is NOT valid' do
      before {patch "/todos/#{todo_id}/update_status", {status: 'invalid_status'}}

      it 'returns a status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure messages' do
        expect(response.body).to match(/is not included in the list/)
      end
    end
  end

  describe 'PATCH /todos/:id/undo_delete' do
    context 'when request is valid' do
      before {patch "/todos/#{todo_id}/undo_delete"}

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns updated is_deleted property' do
        json = JSON.parse(response.body)
        expect(json['is_deleted']).to eq(false)
      end
    end
  end

  describe 'DELETE /todos/:id' do
    context 'when request is valid' do
      before {delete "/todos/#{todo_id}"}

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns updated is_deleted property' do
        json = JSON.parse(response.body)
        expect(json['is_deleted']).to eq(true)
      end
    end
  end

end