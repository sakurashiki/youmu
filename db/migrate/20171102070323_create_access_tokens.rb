# frozen_string_literal: true

class CreateAccessTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :access_tokens do |t|
      t.string :access_token
      t.string :access_token_secret
    end
  end
end
