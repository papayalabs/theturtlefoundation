# This migration comes from camaleon_cms_engine (originally 20150611161134)
class PostTableIntoUtf8 < CamaManager.migration_class
  def change
    if table_exists? CamaleonCms::User.table_name
      add_column(CamaleonCms::User.table_name, :email, :string) unless column_exists?(CamaleonCms::User.table_name, :email)
      add_column(CamaleonCms::User.table_name, :username, :string) unless column_exists?(CamaleonCms::User.table_name, :username)
      add_column(CamaleonCms::User.table_name, :role, :string, default: 'client', index: true) unless column_exists?(CamaleonCms::User.table_name, :role)
      add_column(CamaleonCms::User.table_name, :parent_id, :string) unless column_exists?(CamaleonCms::User.table_name, :parent_id)
      add_column(CamaleonCms::User.table_name, :site_id, :string, index: true, default: -1) unless column_exists?(CamaleonCms::User.table_name, :site_id)
      add_column(CamaleonCms::User.table_name, :auth_token, :string) unless column_exists?(CamaleonCms::User.table_name, :auth_token)
    else
      create_table CamaleonCms::User.table_name, :id => false do |t|
        t.string   "id", :limit => 36, :primary => true
        t.string   "username", index: true
        t.string   "role", default: "client", index: true
        t.string   "email", index: true
        t.string   "slug"
        t.string   "password_digest"
        t.string   "auth_token"
        t.string   "password_reset_token"
        t.string  "parent_id"
        t.datetime "password_reset_sent_at"
        t.datetime "last_login_at"

        # t.integer  "site_id",   default: -1, index: true
        t.timestamps null: false
        t.string  "site_id", index: true, default: -1#, foreign_key: true
      end
    end

    create_table "#{PluginRoutes.static_system_info["db_prefix"]}term_taxonomy", :id => false do |t|
      t.string   "id", :limit => 36, :primary => true
      t.string   "taxonomy", index: true
      t.text     "description", limit: 1073741823
      t.string  "parent_id", index: true
      t.integer  "count"
      t.string   "name"
      t.string   "slug", index: true
      t.integer  "term_group"
      t.integer  "term_order", index: true
      t.string   "status"

      t.timestamps null: false
      t.string   "user_id", index: true#, foreign_key: true
    end

    create_table "#{PluginRoutes.static_system_info["db_prefix"]}posts", :id => false do |t|
      t.string   "id", :limit => 36, :primary => true
      t.string   "title"
      t.string   "slug", index: true
      t.text     "content",          limit: 1073741823
      t.text     "content_filtered", limit: 1073741823
      t.string   "status", default: "published", index: true
      t.integer  "comment_count", default: 0
      t.datetime "published_at"
      t.string   "post_parent", index: true
      t.string   "visibility", default: "public"
      t.text     "visibility_value"
      t.string   "post_class", default: "Post", index: true

      t.timestamps null: false
      t.string   "user_id", index: true#, foreign_key: true
    end

    create_table "#{PluginRoutes.static_system_info["db_prefix"]}term_relationships", :id => false do |t|
      t.string   "id", :limit => 36, :primary => true
      t.string "objectid", index: true
      t.integer "term_order", index: true
      t.string  "term_taxonomy_id", index: true
      t.timestamps null: false
    end

    create_table "#{PluginRoutes.static_system_info["db_prefix"]}user_relationships", :id => false do |t|
      t.string   "id", :limit => 36, :primary => true
      t.integer "term_order"
      t.integer "active", default: 1

      t.string  "term_taxonomy_id", index: true
      t.string  "user_id", index: true
      t.timestamps null: false
    end

    create_table "#{PluginRoutes.static_system_info["db_prefix"]}comments", :id => false do |t|
      t.string   "id", :limit => 36, :primary => true
      t.string   "author"
      t.string   "author_email"
      t.string   "author_url"
      t.string   "author_IP"
      t.text     "content"
      t.string   "approved", default: "pending", index: true
      t.string   "agent"
      t.string   "typee"
      t.integer  "comment_parent", index: true
      t.string   "post_id", index: true#, foreign_key: true
      t.string   "user_id", index: true#, foreign_key: true
      t.timestamps null: false
    end

    create_table "#{PluginRoutes.static_system_info["db_prefix"]}custom_fields", :id => false do |t|
      t.string   "id", :limit => 36, :primary => true
      t.string  "object_class", index: true
      t.string  "name"
      t.string  "slug", index: true
      t.string  "objectid", index: true
      t.string "parent_id", index: true
      t.integer "field_order"
      t.integer "count", default: 0
      t.boolean "is_repeat", default: false
      t.text    "description"
      t.string  "status"
      t.timestamps null: false
    end

    create_table "#{PluginRoutes.static_system_info["db_prefix"]}custom_fields_relationships", :id => false do |t|
      t.string   "id", :limit => 36, :primary => true
      t.string "objectid", index: true
      t.string "custom_field_id", index: true
      t.integer "term_order"
      t.string  "object_class", index: true
      t.text    "value", limit: 1073741823
      t.string  "custom_field_slug", index: true
      t.timestamps null: false
    end

    create_table "#{PluginRoutes.static_system_info["db_prefix"]}metas", :id => false do |t|
      t.string   "id", :limit => 36, :primary => true
      t.string  "key", index: true
      t.text    "value", limit: 1073741823
      t.string "objectid", index: true
      t.string  "object_class", index: true
      t.timestamps null: false
    end

    if ActiveRecord::Base.connection.adapter_name.downcase.include?("mysql")
      ActiveRecord::Base.connection.execute "ALTER TABLE #{PluginRoutes.static_system_info["db_prefix"]}posts CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;" rescue nil
      ActiveRecord::Base.connection.execute "ALTER TABLE #{PluginRoutes.static_system_info["db_prefix"]}custom_fields_relationships CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;" rescue nil
    end
  end
end
