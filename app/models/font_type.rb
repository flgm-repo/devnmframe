class FontType < ActiveRecord::Base
# FontType model define the font properties
# Author:  Bernardo Galindo (mailto: bernardo.galindo@crowdint.com)
#
  #font_path method read source font
  def font_path
    File.join("public", "no-margin-fonts", self.file_name)
  end
  #
  # font_image_path get the sample font image
  def font_image_path
    "fonts_images/#{self.name}.gif"
  end
  #
  # font_properties method define font properties. Some one are in database and other one are evaluate in the code for every kind of family font
  # =Database
  #  ==Kerning
  #    This variable specifies the space entry every character of the word. This value is in pixels but the nameframe model convert to inch, when
  #    text is create.
  #  ==letter_width
  #    This variable specifies the size of the letter_width. This value is in pixels but the nameframe model convert to inch, when
  #    text is create.
  #  ==height_factor
  #    This variable is a number factor for modify the height of whole text in nameframe model
  # =Nameframe generator
  # ==pixel_down_movement
  #   This variable specifies "Y" pixels position of whole text rectangle when the nameframe model composite this image with frame image.
  #   Positive value for down movement and Negative for up movement
  # ==pixel_right_movement specifies "X" pixels position. Positive value for right movement and Negative value for left movement
  # =Lightbox vars (Flex application)
  # ==left_border_adjust: Amount of pixels that will be cut from the left of the final image
  # ==right_border_adjust: Amount of pixels that will be cut from the right of the final image
  # ==top_border_adjust: Amount of pixels that will be cut from the top of the final image
  # ==bottom_border_adjust: Amount of pixels that will be cut from the bottom of the final image
  # ==origin_x_adjust: X Point where the bounding boxes should start at
  # ==origin_y_adjust: Y Point where the bounding boxes should start at
  def font_properties(text)
    case self.name
      when "arial"
       properties = case text.length
                     when 0..3
                       {:pixels_down_movement => -9, :pixels_right_movement => 0, :kerning_reduction => 0, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -7, :origin_y_adjust => 25}
                     when 4..6
                       {:pixels_down_movement => -9, :pixels_right_movement => 0, :kerning_reduction => 1.35, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => 3, :bottom_border_adjust => -3, :origin_x_adjust => -3, :origin_y_adjust => 25}
                     else
                       {:pixels_down_movement => -6.75, :pixels_right_movement => -13.5, :kerning_reduction => 2.8125, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -10, :origin_y_adjust => 35}
                  end
      when "louisianne"
        properties = case text.length
                     when 0..3
                       {:pixels_down_movement => 31.5, :pixels_right_movement => 0, :kerning_reduction => 2.25, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => -2.5, :bottom_border_adjust => -2.5, :origin_x_adjust => -7, :origin_y_adjust => 35}
                     when 4..6
                       {:pixels_down_movement => 31.5, :pixels_right_movement => -9, :kerning_reduction => 1.9, :left_border_adjust => -3, :right_border_adjust => 3, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -5, :origin_y_adjust => 45}
                     else
                       {:pixels_down_movement => 31.5, :pixels_right_movement => -9, :kerning_reduction => 3.375, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -15, :origin_y_adjust => 50}
                  end
      when "porkys"
        properties = case text.length
                     when 0..3
                       {:pixels_down_movement => 11.25, :pixels_right_movement => 0, :kerning_reduction => 0, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -7, :origin_y_adjust => 40}
                     when 4..6
                       {:pixels_down_movement => 11.25, :pixels_right_movement => 0, :kerning_reduction => 0, :left_border_adjust => -3, :right_border_adjust => 3, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -5, :origin_y_adjust => 40}
                     else
                       {:pixels_down_movement => 11.25, :pixels_right_movement => -9, :kerning_reduction => 3.375, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -5, :origin_y_adjust => 40}
                  end
      when "serpentine"
        properties = case text.length
                     when 0..3
                       {:pixels_down_movement => 40.5, :pixels_right_movement => 0, :kerning_reduction => 2.25, :left_border_adjust => 3, :right_border_adjust => -3, :top_border_adjust => -3, :bottom_border_adjust => 3, :origin_x_adjust => -2, :origin_y_adjust => 80}
                     when 4..6
                       {:pixels_down_movement => 45, :pixels_right_movement => -4.5, :kerning_reduction => 0.9, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -5, :origin_y_adjust => 80}
                     else
                       {:pixels_down_movement => 45, :pixels_right_movement => -9, :kerning_reduction =>3.15, :left_border_adjust => -3, :right_border_adjust => 1, :top_border_adjust => -1, :bottom_border_adjust => 3, :origin_x_adjust => -10, :origin_y_adjust => 85}
                  end
      when "simple"
        properties = case text.length
                     when 0..3
                       {:pixels_down_movement => 4.5, :pixels_right_movement => 0, :kerning_reduction => 2.25, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -5, :origin_y_adjust => 50}
                     when 4..6
                       {:pixels_down_movement => 4.5, :pixels_right_movement => -4.5, :kerning_reduction => 1.8, :left_border_adjust => -3, :right_border_adjust => 3, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -5, :origin_y_adjust => 50}
                     else
                       {:pixels_down_movement => 4.5, :pixels_right_movement => -18.75, :kerning_reduction => 4.5, :left_border_adjust => 0, :right_border_adjust => 0, :top_border_adjust => 0, :bottom_border_adjust => 0, :origin_x_adjust => -10, :origin_y_adjust => 50}
                  end
    end
    properties
  end
end

