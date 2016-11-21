file = YAML.load_file("#{Rails.root}/config/google_authentication.yml")
GOOGLE_CONFIG = file[Rails.env].with_indifferent_access
