class Message < ApplicationRecord
  def as_json(opts = {})
    attributes.slice *%w{id author body created_at}
  end
end
