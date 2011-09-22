class Image < ActiveRecord::Base

belongs_to :fig
acts_as_fleximage :image_directory => 'public/images/uploaded_photos'

end
