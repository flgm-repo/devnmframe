class Nameframe < ActiveRecord::Base
#This model define the font properties
#Author:  Bernardo Galindo (mailto: bernardo.galindo@crowdint.com)
#
  require 'rubygems'
  require 'uuidtools'
  require 'RMagick'
  include Magick
  belongs_to :user
  has_one :checkout
  belongs_to :frame
  belongs_to :font, :class_name => "FontType"
  belongs_to :top_matt, :class_name => "Matt"
  belongs_to :bottom_matt, :class_name => "Matt"
  belongs_to :top_left_ornament, :class_name => "Ornament"
  belongs_to :top_right_ornament, :class_name => "Ornament"
  belongs_to :bottom_left_ornament, :class_name => "Ornament"
  belongs_to :bottom_right_ornament, :class_name => "Ornament"
  has_many :uploaded_images, :class_name => "Photo"


  validates_format_of :selected_text, :with => /^([\w\s&]{1,9})$/n, :on =>	:save
  validates_presence_of :font
  validates_presence_of :top_matt

  named_scope :limit, lambda{|limit| {:limit => limit }}
  named_scope :order, lambda{|order| {:order => order }}

  before_validation :format_select_text
  before_save :update_frame_and_matt_by_permissions
  before_save :delete_flex_image
  before_destroy :delete_image
  Font_ppi = 96 # Font_ppi value is multiply factor for convert from pixels to inchs. Just for the font
  Ppi = 72 # Ppi value is multiply factor for convert from pixels to inchs. This is for all images


  def update_frame_and_matt_by_permissions
    if self.frame
      # Update frame permissions
      exists = FrameMattPermissions.find(:first, :conditions =>["allowed IS true && frame_id = ? && top_matt_id = ?", self.frame_id, self.top_matt_id])
      if exists
        # Update matts permissions
        exists = FrameMattPermissions.find(:first, :conditions =>["allowed IS true && frame_id = ? && top_matt_id = ? && bottom_matt_id = ?", self.frame_id, self.top_matt_id, self.bottom_matt_id])
        if exists.nil?
          self.bottom_matt = nil
        end
      else
        self.top_matt = Matt.find_by_name("white")
        self.bottom_matt = nil
      end
    else
      # Update frame permissions
      exists = FrameMattPermissions.find(:first, :conditions =>["allowed IS true && top_matt_id = ?", self.top_matt_id])
      if exists
        # Update matts permissions
        exists = FrameMattPermissions.find(:first, :conditions =>["allowed IS true && top_matt_id = ? && bottom_matt_id = ?", self.top_matt_id, self.bottom_matt_id])
        if exists.nil?
          self.bottom_matt = nil
        end
      else
        self.top_matt = Matt.find_by_name("white")
        self.bottom_matt = nil
      end
    end
  end

  def delete_uploaded_images
    self.uploaded_images.each{ |image| image.destroy }
  end

  def delete_flex_image
    File.delete("#{self.get_public_path}#{self.flex_address_path}") if self.flex_address.nil? && File::exists?("#{self.get_public_path}#{self.flex_address_path}")
  end

  def delete_image
    File.delete("#{self.get_public_path}#{self.flex_address_path}") if  File::exists?("#{self.get_public_path}#{self.flex_address_path}")
    File.delete("#{self.get_public_path}#{self.get_image_path}") if File::exists?("#{self.get_public_path}#{self.get_image_path}")
  end

  def get_public_path
    "#{RAILS_ROOT}/public"
  end

  def get_image_path
    "/preview/#{self.uuid}.png"
  end
  def flex_address_path
    "/printables/#{self.uuid}.jpg"
  end

  def save_flex_image(fileData)
    image = Magick::Image.from_blob(fileData.read).first
    image.write("#{RAILS_ROOT}/public/printables/#{self.uuid}.jpg")
  end

  def format_select_text
    self.selected_text = self.selected_text.gsub(/ +/,' ')
  end

  def create_text_sample
    font_path = self.font.font_path
    name = self.selected_text
    draw = Magick::Draw.new
    draw.font = font_path
    draw.interword_spacing = 1 * Ppi
    draw.kerning = 0.5 * Ppi
    draw.gravity = Magick::CenterGravity
    draw.pointsize = 3.75 * Ppi
    draw.rotation = 0
    draw.text_antialias = true
    draw.fill = "black"

    name_metrics = draw.get_type_metrics(name)
    puts name_metrics.width
    letters_count = name.length
    puts name_metrics.width
    total_width = name_metrics.width + (letters_count -1) * 0.5 * Ppi
    image = Magick::Image.new(total_width, name_metrics.height){self.background_color = "white"}
    draw.annotate(image,0,0, 0, 0, name)
    image.resize!(image.columns, image.rows)
    image.write("sample_text.png")
    new_image = Magick::Image.read("sample_text.png").first
    new_image.resample(300)
    new_image.write("sample_text.png")
  end
  # get_text_information method send all image (text,frame, color, position. etc) properties to flex application (lightbox), this method is called in the controller for get_text_descriptions method
  def get_text_information
    flex_scale = 0.42
    stroke_width = 7
    ppi_scaled = Ppi * flex_scale
    font_ppi_scaled = Font_ppi * flex_scale

    name = self.selected_text
    font = self.font
    font_path = self.font.font_path
    font_properties = self.font.font_properties(name)
    img_size = get_frame_size(name,flex_scale)
    dimension = img_size[:size]
#**********************************Get Values **********************************
    frame = self.frame.frame_address_path(dimension) unless self.frame_id.nil?

    i = 0
    name.each_char { |chr|
      i += 1
    }

    text_mask = Magick::Image.new(img_size[:width],img_size[:height]) {self.background_color = "black"}
    letters_count = i
    ret = []
    text = Magick::Draw.new
    text.font = font_path
    text.kerning = font.kerning * ppi_scaled - font_properties[:kerning_reduction] * flex_scale
    text.gravity = Magick::CenterGravity
    text.pointsize = font.letter_width * font_ppi_scaled #+ 2 * stroke_width * flex_scale
    text.fill = "white"
    text.text_antialias = true

    name_metrics = text.get_type_metrics(name)
    total_width = name_metrics.width
    text.annotate(text_mask,0,0, 0, 0, name)
    name_properties = {
      :width => total_width,
      :height => name_metrics.height,
      :frame_width => img_size[:width],
      :frame_heigth => img_size[:height],
      :character =>name,
      :metrics => name_metrics,
      :fontFamily => font_path,
      :kerning => font.kerning * ppi_scaled,
      :pixels_down_movement => font_properties[:pixels_down_movement],
      :pixels_right_movement => font_properties[:pixels_right_movement],
      :kerning_reduction => font_properties[:kerning_reduction] * flex_scale,
      :left_border_adjust => font_properties[:left_border_adjust] * flex_scale,
      :right_border_adjust => font_properties[:right_border_adjust] * flex_scale,
      :top_border_adjust => font_properties[:top_border_adjust] * flex_scale,
      :bottom_border_adjust => font_properties[:bottom_border_adjust] * flex_scale,
      :origin_x_adjust => font_properties[:origin_x_adjust],
      :origin_y_adjust => font_properties[:origin_y_adjust]
    }
    unless frame.nil?
      name_properties.merge!({
        :top_border_size => frame[:top_border_size] * flex_scale,
        :right_border_size => frame[:right_border_size] * flex_scale,
        :bottom_border_size => frame[:bottom_border_size] * flex_scale,
        :left_border_size => frame[:left_border_size] * flex_scale
      })
    end
    puts name_properties
    ret<< name_properties
    name.each_char { |chr|
      text = Magick::Draw.new
      text.font = font_path
      text.kerning = font.kerning * ppi_scaled - font_properties[:kerning_reduction] * flex_scale
      text.gravity = Magick::CenterGravity
      text.pointsize = font.letter_width * font_ppi_scaled
#       text.pointsize = font.letter_width * font_ppi_scaled + 2 * stroke_width * flex_scale
      text.text_antialias = true

      name_metrics = text.get_type_metrics(chr)
      char_width = name_metrics.width

      ret << {
        :width => char_width,
        :height => name_metrics.height * font.height_factor,
        :character => chr,
        :metrics => name_metrics,
        :fontFamily => font_path,
        :kerning => font.kerning * ppi_scaled
      }
    }
    ret
  end

  def get_text_length(text)
    name = text.mb_chars.length
    if name <= 3
       factor_scale = 0.36
    elsif name <= 6 && name > 3
       factor_scale = 0.32
    else
       factor_scale = 0.32
    end
    factor_scale
  end
  # builder method create the nameframe. Builder method have been called with out param for rails application and with params for flex.
  def builder(action = nil)
#**********************************Standard Values******************************
    action ||= ""
    name = self.selected_text
    if action == "flex"
     scale = 0.42
     text_background_color = "white"
    else
      scale = get_text_length(name)
      text_background_color = "black"
      flex = self.get_public_path + self.flex_address_path unless self.flex_address.nil?
    end
    stroke_width = 3
    ppi_scaled = Ppi * scale
    font_ppi_scaled = Font_ppi * scale
    font = self.font
    font_path = self.font.font_path
    font_properties = self.font.font_properties(name)
    img_size = get_frame_size(name,scale)
    dimension = img_size[:size]
#**********************************Get Values **********************************
    frame = self.frame.frame_address_path(dimension) unless self.frame_id.nil?

#    bottom = Magick::Image.read(self.bottom_matt.matt_address_path).first
#    bottom_core = Magick::Image.read(self.bottom_matt.matt_address_path_core).first
    top = Magick::Image.read(self.top_matt.matt_address_path).first
    top_core = Magick::Image.read(self.top_matt.matt_address_path_core).first

    unless self.bottom_matt_id.nil?
      bottom = Magick::Image.read(self.bottom_matt.matt_address_path).first
      bottom_core = Magick::Image.read(self.bottom_matt.matt_address_path_core).first
    end

    if !bottom.nil? && self.bottom_matt.core_image == "white.png"
      ornament_top_left = Magick::Image.read(self.top_left_ornament.ornament_path).first unless self.top_left_ornament_id.nil?
      ornament_top_right = Magick::Image.read(self.top_right_ornament.ornament_path).first unless self.top_right_ornament_id.nil?
      ornament_bottom_left = Magick::Image.read(self.bottom_left_ornament.ornament_path).first unless
  self.bottom_left_ornament_id.nil?
      ornament_bottom_right = Magick::Image.read(self.bottom_right_ornament.ornament_path).first unless
  self.bottom_right_ornament_id.nil?
    else

     ornament_top_left = Magick::Image.read(self.top_left_ornament.ornament_outline_path).first unless self.top_left_ornament_id.nil?
      ornament_top_right = Magick::Image.read(self.top_right_ornament.ornament_outline_path).first unless self.top_right_ornament_id.nil?
      ornament_bottom_left = Magick::Image.read(self.bottom_left_ornament.ornament_outline_path).first unless
  self.bottom_left_ornament_id.nil?
      ornament_bottom_right = Magick::Image.read(self.bottom_right_ornament.ornament_outline_path).first unless
  self.bottom_right_ornament_id.nil?
    end
#*****************************SET SIZE OF MAIN RECTANGLE************************
    preview = Magick::Image.new(img_size[:width],img_size[:height]){ self.background_color=  "white"}
#*******************************************************************************
#******************************text background**********************************
    text_background = Magick::Image.new(img_size[:width]/scale,  img_size[:height]/scale)
    text_background_draw = Magick::Draw.new

    if !flex.nil?

      text_background_draw.fill_pattern = Magick::Image.read(flex).first
    else
      text_background_draw.fill = text_background_color
    end

    text_background_draw.rectangle(0,0, text_background.columns, text_background.rows)
    text_background_draw.draw(text_background)
    text_background.resize!(img_size[:width],img_size[:height])
#******************************************text mask****************************
    text_mask = Magick::Image.new(img_size[:width]/scale, img_size[:height]/scale) {self.background_color = "black"}
    i = 0
    name.each_char { |chr|
      i += 1
    }
    letters_count = i

    text = Magick::Draw.new
    text.font = font_path
    text.kerning = 0
    text.interword_spacing = 0 * Ppi
    text.gravity = Magick::CenterGravity
    text.pointsize = font.letter_width * Font_ppi
    text.text_antialias = true
    text.fill = "white"
    text.stroke = "none"
    name_metrics = text.get_type_metrics(text_mask,name)
    total_width = name_metrics.width + (letters_count -1) * font.kerning * Font_ppi

    text_mask_resize = Magick::Image.new(total_width+0.5*Font_ppi,name_metrics.height) {self.background_color = "black"}
     text.kerning = font.kerning * Ppi - font_properties[:kerning_reduction]
    text.annotate(text_mask_resize,0,0,0, 0, name)
    text_mask = text_mask.composite(text_mask_resize.resize(text_mask_resize.columns * 1, text_mask_resize.rows * font.height_factor), Magick::CenterGravity,font_properties[:pixels_right_movement],font_properties[:pixels_down_movement], Magick::OverCompositeOp)
    text_mask.resize!(img_size[:width],img_size[:height])
#**********************************END TEXT*************************************
#********************************MATTS******************************************
#******************************bottom_matt**************************************
    top_matt = Magick::Draw.new
    top_matt.fill_pattern = top
    top_matt.rectangle(0,0, preview.columns, preview.rows)
    top_matt.draw(preview)
#*****************************bottom_matt and top_matt**************************
    unless bottom.nil?
      top_matt = Magick::Draw.new
      top_matt.fill_pattern = top
      top_matt.rectangle(0,0, preview.columns, preview.rows)

      bottom_matt_width =  total_width * scale
      bottom_matt_height =  (name_metrics.height)* font.height_factor * scale
      bottom_matt = Magick::Draw.new
      bottom_matt.fill_pattern = bottom
      movement_x = (preview.columns-bottom_matt_width)/2 + font_properties[:pixels_right_movement]/2
      movement_y = (preview.rows-bottom_matt_height)/2

      bottom_matt.stroke_pattern = top_core
      bottom_matt.stroke_width = stroke_width

      bottom_matt.rectangle(movement_x-0.5 * font_ppi_scaled,movement_y,bottom_matt_width+movement_x+0.5 * font_ppi_scaled,bottom_matt_height+movement_y)
      top_matt.draw(preview)
      bottom_matt.draw(preview)
    end

#********************************bottom core************************************
    text_border_background = Magick::Image.new(img_size[:width]/scale, img_size[:height]/scale)
    text_border_background_draw = Magick::Draw.new
    unless bottom.nil?
      text_border_background_draw.fill_pattern = bottom_core
    else
      text_border_background_draw.fill_pattern = top_core
    end
    text_border_background_draw.rectangle(0,0,text_border_background.columns, text_border_background.rows)
    text_border_background_draw.draw(text_border_background)
    text_border_background.resize!(img_size[:width],img_size[:height])
#******************************text core**********************************
    text_border = Magick::Image.new(img_size[:width]/scale, img_size[:height]/scale){self.background_color = "black"}

    i = 0
    name.each_char { |chr|
      i += 1
    }
    letters_count = i

    text_with_border = Magick::Draw.new
    text_with_border.font = font_path
    text_with_border.kerning = 0
    text_with_border.interword_spacing = 0 * Ppi
    text_with_border.gravity = Magick::CenterGravity
    text_with_border.fill = "white"
    text_with_border.pointsize = font.letter_width * Font_ppi
    text_with_border.text_antialias = true

    total_width = name_metrics.width + (letters_count -1) * font.kerning * Font_ppi

    text_border_mask_resize = Magick::Image.new(total_width+0.5*Font_ppi,name_metrics.height) {self.background_color = "black"}

    text_with_border.kerning = font.kerning  * Ppi  - font_properties[:kerning_reduction]
    text_with_border.annotate(text_border_mask_resize,0,0, 0, 0, name)
    text_border = text_border.composite(text_border_mask_resize.resize(text_border_mask_resize.columns * 1, text_border_mask_resize.rows * font.height_factor),Magick::CenterGravity,font_properties[:pixels_right_movement],font_properties[:pixels_down_movement], Magick::OverCompositeOp)
     text_border = text_border.negate
     text_border = text_border.charcoal(4.5,1.0)
     text_border = text_border.negate
     text_border.resize!(img_size[:width],img_size[:height])
#*******************************END MATTS****************************************************************
#*******************************ORNAMENTS***************************************
    ornaments_mask = Magick::Image.new(preview.columns,preview.rows){
      self.background_color = "black"
    }
    unless ornament_top_left.nil?
      ornament_top_left = ornament_top_left.scale(scale*1.7)
      ornaments_mask = ornaments_mask.composite(ornament_top_left, 5,5,Magick::OverCompositeOp)
    end
    unless ornament_top_right.nil?
      ornament_top_right = ornament_top_right.scale(scale*1.7)
      ornaments_mask = ornaments_mask.composite(ornament_top_right, preview.columns-(ornament_top_right.columns+5),5,Magick::OverCompositeOp)
    end
    unless ornament_bottom_left.nil?
      ornament_bottom_left = ornament_bottom_left.scale(scale*1.7)
      ornaments_mask = ornaments_mask.composite(ornament_bottom_left, 5,preview.rows-(ornament_bottom_left.rows+5),Magick::OverCompositeOp)
    end
    unless ornament_bottom_right.nil?
      ornament_bottom_right = ornament_bottom_right.scale(scale*1.7)
      ornaments_mask = ornaments_mask.composite(ornament_bottom_right,preview.columns-(ornament_bottom_right.columns),preview.rows-(ornament_bottom_right.rows+5), Magick::OverCompositeOp)
    end
#**************************************ornament background***************************
      hole_background = Magick::Image.new(preview.columns, preview.rows)
      hole_background_draw = Magick::Draw.new
      if !top.nil? && !bottom.nil?
        if self.bottom_matt.core_image != "white.png"
          hole_background_draw.fill_pattern = top_core
        else
          hole_background_draw.fill_pattern = bottom
        end
      elsif !top.nil? && bottom.nil?
        hole_background_draw.fill_pattern = top_core
      elsif self.bottom_matt.name == "White"
        hole_background_draw.fill = "black"
      end
      hole_background_draw.rectangle(0,0,preview.columns, preview.rows)
      hole_background_draw.draw(hole_background)
      preview.add_compose_mask(ornaments_mask)
      result_with_ornaments = preview.composite(hole_background, Magick::CenterGravity, Magick::OverCompositeOp)
#***************************************END ORNAMENTS***************************
#**************************************WRITE RESULTS AND ADD FRAME**************
    result_with_ornaments.add_compose_mask(text_mask)
    result_text_background = result_with_ornaments.composite(text_background, Magick::CenterGravity, Magick::OverCompositeOp)
    result_text_background.add_compose_mask(text_border)
    result_mattings = result_text_background.composite(text_border_background,Magick::CenterGravity, Magick::OverCompositeOp)
#*************************************ADD FRAME*********************************
      if !frame_id.nil?
        frame_list = Magick::ImageList.new
        frame_list[0] = Magick::Image.read(frame[:path]).first
        frame_list[0] = frame_list[0].resize(preview.columns+(frame[:margin]* scale), preview.rows+(frame[:margin] * scale))
        frame_list[1] = frame_list[0].composite(result_mattings,Magick::CenterGravity,Magick::OverCompositeOp)
        result_with_frame = frame_list.flatten_images
      else
        result_with_frame = result_mattings
      end

#*************************************WRITE NAMEFRAME***************************
    if action != "flex"
      result = result_with_frame
      path = self.get_public_path + self.get_image_path
      result.write(path)
    else
#*****************************************LAST TEXT*****************************
    text_mask = Magick::Image.new(result_with_frame.columns/scale, result_with_frame.rows/scale) {self.background_color = "black"}

    i = 0
    name.each_char { |chr|
      i += 1
    }
    letters_count = i

    text = Magick::Draw.new
    text.font = font_path
    text.kerning = 0
    text.interword_spacing = 0 * Ppi
    text.gravity = Magick::CenterGravity
    text.pointsize = font.letter_width * Font_ppi
    text.fill = "white"
    text.stroke = "none"
    text.text_antialias = true
#    name_metrics = text.get_type_metrics(name)
    total_width = name_metrics.width + (letters_count -1) * font.kerning * Font_ppi

    text_mask_resize = Magick::Image.new(total_width+0.5*Font_ppi,name_metrics.height) {self.background_color = "black"}

    text.kerning = font.kerning * Ppi - font_properties[:kerning_reduction]

    text.annotate(text_mask_resize,0,0, 0, 0, name)

    text_mask = text_mask.composite(text_mask_resize.resize(text_mask_resize.columns * 1, text_mask_resize.rows * font.height_factor), Magick::CenterGravity,font_properties[:pixels_right_movement],font_properties[:pixels_down_movement], Magick::OverCompositeOp)
    text_mask.resize!(result_with_frame.columns, result_with_frame.rows)
  #*******************************************************************************
      result_with_frame.add_compose_mask(text_mask)
      result = result_with_frame.composite(text_background, Magick::CenterGravity, Magick::OverCompositeOp)
      result.fuzz = 100
      result    = result.transparent('white', Magick::TransparentOpacity)
      result.format = "PNG"
      result
    end

  end

  def get_frame_size(text,flex_scale)
    rect = {}
    size = text.mb_chars.length
    if size <= 3
      rect = {:width => (Settings.small_frame_width * (Ppi * flex_scale)), :height => (Settings.frame_heigth * (Ppi * flex_scale)), :size => "small"}
    elsif size <= 6 && size > 3
      rect = {:width => (Settings.medium_frame_width * (Ppi * flex_scale)), :height => (Settings.frame_heigth * (Ppi * flex_scale)), :size => "medium"}
    else
      rect = {:width => (Settings.large_frame_width * (Ppi * flex_scale)), :height => (Settings.frame_heigth * (Ppi * flex_scale)), :size => "large"}
    end
    return rect
  end

  def get_size
    size = self.selected_text.mb_chars.length
    if size <= 3
      rect = {:frame_size => Settings.small_nameframe, :size => "small"}
    elsif size <= 6 && size > 3
      rect = {:frame_size => Settings.medium_nameframe, :size => "medium"}
    else
      rect = {:frame_size => Settings.large_nameframe, :size => "large"}
    end
  end

  def get_max_uploaded_images
    self.selected_text.mb_chars.length + 1
  end

  def calculate_cost
    if self.frame.nil?
      cost = Settings.base_price_without_frame
    else
      cost = Settings.base_price_with_frame
    end
      if self.bottom_matt
        cost += Settings.bottom_matt_price
      end
      if self.top_left_ornament || self.top_right_ornament || self.bottom_left_ornament ||  self.bottom_right_ornament
        cost += Settings.ornamet_price
      end
      if self.flex_address.nil? && self.without_images == true
        cost -= Settings.photos_price
      end
      cost
  end

  def has_owner?
    !user_id.nil?
  end

  def set_images_customizations(customizations_session)
    customizations_session.each do |image|
      photo = Photo.find(image[:id].to_i)
      photo.photo_customizations << PhotoCustomization.new(:x => image[:x], :y => image[:y], :rotation => image[:rotation], :width => image[:width], :height => image[:height], :letter_position => image[:letter_position], :is_mask_stretchable => image[:is_mask_stretchable], :stretched_image_height => image[:stretched_image_height], :stretched_image_width => image[:stretched_image_width])
      photo.save
    end
  end

  def get_images_customizations
    customizations = []
    self.uploaded_images.each do |photo|
      photo.photo_customizations.each do |customization|
        customizations << {:id => photo.id , :x => customization.x, :y => customization.y, :rotation => customization.rotation, :width => customization.width, :height => customization.height, :large_filename => photo.public_filename, :letter_position => customization.letter_position, :is_mask_stretchable => customization.is_mask_stretchable, :stretched_image_height => customization.stretched_image_height, :stretched_image_width => customization.stretched_image_width}
      end
    end
    customizations
  end

  def has_checkout?
    !self.checkout.nil??true : false
  end

  def self.new_with_default_values(params = {})
    defaults = {:font => FontType.find_by_name("arial"),
              :frame => Frame.find_by_name("Wood"),
              :top_matt => Matt.find_by_name("white")
              }
    params.merge! defaults
    nameframe = Nameframe.new(params)
  end

  #This  will remove the old nameframes withouth checkout and user id  RUN  WITH CRON
  def self.remove_old_saved_jobs
    date_fin= Time.now-30.days
    date_ini= Time.now-45.days
    namesframes=Nameframe.find(:all,:select=>:id,:conditions=>["created_at BETWEEN ? AND ? ",date_ini,date_fin])
    namesframes.each  do |nameframe|
       nameframe.destroy unless nameframe.has_owner? || nameframe.has_checkout?
    end
  end

end

