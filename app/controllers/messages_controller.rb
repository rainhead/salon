class MessagesController < ApplicationController
  def create
    author = params.require(:author)
    body = params.require(:body)
    message = Message.create! author: author, body: body

    render json: message
  end

  def index
    render json: Message.order(:created_at)
  end
end
