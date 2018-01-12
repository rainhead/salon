class MessagesController < ApplicationController
  def create
    author = params.require(:author)
    body = params.require(:body)
    message = Message.create! author: author, body: body

    render json: message
  end

  def index
    messages = Message.order(:created_at)

    respond_to do |format|
      format.json do
        render json: messages
      end
      format.html do
        render action: 'index', locals: {messages: messages}
      end
    end
  end
end
