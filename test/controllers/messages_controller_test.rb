require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test 'create' do
    post '/messages', params: {author: 'Peter', body: 'Hello, World'}

    assert_response :success
    assert_not_nil response.parsed_body['id']
    assert_equal 'Peter', response.parsed_body['author']
    assert_equal 'Hello, World', response.parsed_body['body']
  end

  test 'list' do
    Message.create! author: 'Peter', body: 'Message one'
    Message.create! author: 'Peter', body: 'Message two'

    get '/messages'

    assert_response :success
    assert_equal 2, response.parsed_body.length
    assert_equal 'Message one', response.parsed_body.first['body']
  end
end
