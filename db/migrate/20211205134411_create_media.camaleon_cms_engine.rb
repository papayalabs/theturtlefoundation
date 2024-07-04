# This migration comes from camaleon_cms_engine (originally 20180124132318)
class CreateMedia < CamaManager.migration_class
  def change
    create_table "#{PluginRoutes.static_system_info["db_prefix"]}media", :id => false do |t|
      t.string   :id, :limit => 36, :primary => true
      t.string :site_id, index: true
      t.string :name, index: true
      t.boolean :is_folder, index: true, default: false
      t.string :folder_path, index: true
      t.string :file_size
      t.string :dimension, default: ''
      t.string :file_type
      t.string :url
      t.string :thumb
      t.boolean :is_public, default: true
      t.timestamps
    end
  end
end
