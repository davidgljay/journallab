require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
#app.configure_with(:heroku, 'j.lab-images') if Rails.env.production?
app.datastore = Dragonfly::DataStorage::S3DataStore.new(
    :bucket_name => 'j.lab-images',
    :access_key_id => ENV['S3_ACCESS_KEY'],
    :secret_access_key => ENV['S3_ACCESS_SECRET']
  )

app.define_macro(ActiveRecord::Base, :image_accessor)
