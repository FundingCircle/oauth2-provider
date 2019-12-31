class SongkickOauth2SchemaAddUniqueIndexes < ActiveRecord::Migration[4.2]
  def self.up
    remove_index :oauth2_authorizations, [:client_id, :code]
    add_index :oauth2_authorizations, [:client_id, :code], :unique => true

    remove_index :oauth2_authorizations, name: 'index_oauth2_authorizations_client_id_and_refresh_token_hash'
    add_index :oauth2_authorizations, [:client_id, :refresh_token_hash], :unique => true, name: 'index_oauth2_authorizations_client_id_and_refresh_token_hash'

    remove_index :oauth2_authorizations, [:access_token_hash]
    add_index :oauth2_authorizations, [:access_token_hash], :unique => true

    remove_index :oauth2_clients, [:client_id]
    add_index :oauth2_clients, [:client_id], :unique => true

    add_index :oauth2_clients, [:name], :unique => true
  end

  def self.down
    remove_index :oauth2_authorizations, [:client_id, :code]
    add_index :oauth2_authorizations, [:client_id, :code]

    remove_index :oauth2_authorizations, name: 'index_oauth2_authorizations_client_id_and_refresh_token_hash'
    add_index :oauth2_authorizations, [:client_id, :refresh_token_hash], name: 'index_oauth2_authorizations_client_id_and_refresh_token_hash'

    remove_index :oauth2_authorizations, [:access_token_hash]
    add_index :oauth2_authorizations, [:access_token_hash]

    remove_index :oauth2_clients, [:client_id]
    add_index :oauth2_clients, [:client_id]

    remove_clients :oauth2_clients, [:name]
  end
end
