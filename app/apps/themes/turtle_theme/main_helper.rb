module Themes::TurtleTheme::MainHelper
  def self.included(klass)
    # klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
  end

  def turtle_theme_settings(theme)
    # callback to save custom values of fields added in my_theme/views/admin/settings.html.erb
  end

  # callback called after theme installed
  def turtle_theme_on_install_theme(theme)
    # # Sample Custom Field
    unless theme.get_field_groups.where(slug: "slider").any?
       group = theme.add_field_group({name: "Slider Settings", is_repeat: true, slug: "slider", description: ""})
       group.add_field({"name"=>"Title", "slug"=>"home_slider_title"},{field_key: "text_box", translate: true})
       group.add_field({"name"=>"Description", "slug"=>"home_slider_description"},{field_key: "text_box", translate: true})
       group.add_field({"name"=>"Display Button", "slug"=>"home_slider_display_button"},{field_key: "checkbox"})
       group.add_field({"name"=>"Button Description", "slug"=>"home_slider_button_description"},{field_key: "text_box", translate: true})
       group.add_field({"name"=>"Button URL", "slug"=>"home_slider_button_url"},{field_key: "url"})
       group.add_field({"name"=>"Background image", "slug"=>"home_slider_bg_image"},{field_key: "image"})
    end
    unless theme.get_field_groups.where(slug: "home_main").any?
      group = theme.add_custom_field_group({name: "Home Main", slug: "home_main", description: ""})
      group.add_manual_field({"name"=>"Home Background color", "slug"=>"home_main_bg_color"},{field_key: "colorpicker", required: true})
      group.add_manual_field({"name"=>"Home Links color", "slug"=>"home_main_links_color"},{field_key: "colorpicker", required: true})
      group.add_manual_field({"name"=>"Home Main About", "slug"=>"home_main_about"},{field_key: "editor", translate: true})
      group.add_manual_field({"name"=>"Home Main News Title", "slug"=>"home_main_news_title"},{field_key: "text_box", translate: true})
      group.add_manual_field({"name"=>"Home Main News Description", "slug"=>"home_main_news_description"},{field_key: "editor", translate: true})
      group.add_manual_field({"name"=>"Home Main Donations", "slug"=>"home_main_donation"},{field_key: "text_box", translate: true})
      group.add_manual_field({"name"=>"Home Main Get in Touch", "slug"=>"home_main_get_in_touch"},{field_key: "text_box", translate: true})
      group.add_manual_field({"name"=>"Home Main Map of the Site", "slug"=>"home_main_site_map"},{field_key: "text_box", translate: true})
      group.add_manual_field({"name"=>"Home Main Categories", "slug"=>"home_main_categories"},{field_key: "text_box", translate: true})
      group.add_manual_field({"name"=>"Home Main Contact us", "slug"=>"home_main_contact_us"},{field_key: "text_box", translate: true})
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
      group.add_field({"name"=>"Class", "slug"=>"social_network_class"},{field_key: "text_box"})
      group.add_field({"name"=>"URL", "slug"=>"social_network_url"},{field_key: "url"})
    end
    unless theme.get_field_groups.where(slug: "unomia").any?
      group = theme.add_field_group({name: "Unomia Settings", is_repeat: true, slug: "unomia", description: ""})
      group.add_field({"name"=>"Title", "slug"=>"unomia_title"},{field_key: "text_box", translate: true})
      group.add_field({"name"=>"Description", "slug"=>"unomia_description"},{field_key: "text_box", translate: true})
   end
    # # Sample Meta Value
    # theme.set_meta("installed_at", Time.current.to_s) # save a custom value
  end

  # callback executed after theme uninstalled
  def turtle_theme_on_uninstall_theme(theme)
  end

  def social_networks
    res = []
    if(tw = current_theme.the_field('social_twitter')).present?
      res << '<a href="#{tw}"><i class="fab fa-twitter"></i></a>'
    end

    if(fb = current_theme.the_field('social_facebook')).present?
      res << '<a href="#{fb}"><i class="fab fa-facebook-f"></i></a>'
    end

    if(ins = current_theme.the_field('social_instagram')).present?
      res << '<a href="#{ins}"><i class="fab fa-instagram"></i></a>'
    end
    res.join(' ')
  end
end
