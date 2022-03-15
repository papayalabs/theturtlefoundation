module Themes::HomeoTheme::MainHelper
  def self.included(klass)
    # klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
  end

  def homeo_theme_settings(theme)
    # callback to save custom values of fields added in my_theme/views/admin/settings.html.erb
  end

  # callback called after theme installed
  def homeo_theme_on_install_theme(theme)
    # unless current_site.the_post_types.first.get_field_groups.where(slug: "section").any?
    #   group = current_site.the_post_types.first.add_field_group({name: "Sections", slug: "section"}, 'Post')
    #   group.add_field({"name"=>"Sections", "slug"=>"home_sections"},{field_key: "select", multiple_options: [
    #     {title: "Normal", value: "normal", default: true},
    #     {title: "Mustread", value: "mustread"},
    #     {title: "Highlight", value: "highlight"},
    #     {title: "Popular", value: "popular"},
    #     {title: "Editor Pick", value: "editor_pick"},
    #   ]})
    # end
    unless current_site.the_post_types.first.get_field_groups.where(slug: "_group-post-date").any?
      group = current_site.the_post_types.first.add_field_group({name: "Post Date", slug: "_group-post-date"}, 'Post')
      group.add_field({"name"=>"Post Date", "slug"=>"post-date"},{field_key: "date", required: true})
    end
    unless theme.get_field_groups.where(slug: "sections").any?
      group = theme.add_field_group({name: "Sections", is_repeat: true, slug: "sections", description: ""})
      group.add_field({"name"=>"Name", "slug"=>"section_name"},{field_key: "text_box", translate: true})
      group.add_field({"name"=>"Tag Slug", "slug"=>"section_tag_slug"},{field_key: "text_box", translate: false})
      group.add_field({"name"=>"Position", "slug"=>"section_position"},{field_key: "numeric", translate: false})
   end
   unless theme.get_field_groups.where(slug: "slider").any?
    group = theme.add_field_group({name: "Slider Settings", is_repeat: true, slug: "slider", description: ""})
    group.add_field({"name"=>"Title", "slug"=>"home_slider_title"},{field_key: "text_box", translate: true})
    group.add_field({"name"=>"Description", "slug"=>"home_slider_description"},{field_key: "text_box", translate: true})
    group.add_field({"name"=>"Display Button", "slug"=>"home_slider_display_button"},{field_key: "checkbox"})
    group.add_field({"name"=>"Button Description", "slug"=>"home_slider_button_description"},{field_key: "text_box", translate: true})
    group.add_field({"name"=>"Button URL", "slug"=>"home_slider_button_url"},{field_key: "url"})
    group.add_field({"name"=>"Background image", "slug"=>"home_slider_bg_image"},{field_key: "image"})
 end
 unless theme.get_field_groups.where(slug: "common_words").any?
   group = theme.add_custom_field_group({name: "Common Words", slug: "common_words", description: ""})
   group.add_manual_field({"name"=>"Categories", "slug"=>"common_word_categories"},{field_key: "text_box", translate: true})
   group.add_manual_field({"name"=>"News", "slug"=>"common_word_news"},{field_key: "text_box", translate: true})
   group.add_manual_field({"name"=>"Tags", "slug"=>"common_word_tags"},{field_key: "text_box", translate: true})
   group.add_manual_field({"name"=>"Recents", "slug"=>"common_word_recents"},{field_key: "text_box", translate: true})
   group.add_manual_field({"name"=>"Home", "slug"=>"common_word_home"},{field_key: "text_box", translate: true})              
   group.add_manual_field({"name"=>"Details", "slug"=>"common_word_details"},{field_key: "text_box", translate: true})
   group.add_manual_field({"name"=>"Projects", "slug"=>"common_word_projects"},{field_key: "text_box", translate: true})
 end  
 unless theme.get_field_groups.where(slug: "social_networks").any?
   group = theme.add_field_group({name: "Social Networks", is_repeat: true, slug: "social_networks", description: ""})
   group.add_field({"name"=>"Name", "slug"=>"social_network_name"},{field_key: "text_box"})
   group.add_field({"name"=>"Class", "slug"=>"social_network_class"},{field_key: "text_box"})
   group.add_field({"name"=>"URL", "slug"=>"social_network_url"},{field_key: "url"})
 end
     
    # # Sample Custom Field
    # unless theme.get_field_groups.where(slug: "fields").any?
    #   group = theme.add_field_group({name: "Main Settings", slug: "fields", description: ""})
    #   group.add_field({"name"=>"Background color", "slug"=>"bg_color"},{field_key: "colorpicker"})
    #   group.add_field({"name"=>"Links color", "slug"=>"links_color"},{field_key: "colorpicker"})
    #   group.add_field({"name"=>"Background image", "slug"=>"bg"},{field_key: "image"})
    # end

    # # Sample Meta Value
    # theme.set_meta("installed_at", Time.current.to_s) # save a custom value
  end

  # callback executed after theme uninstalled
  def homeo_theme_on_uninstall_theme(theme)
  end
end
