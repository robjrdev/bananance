class ApplicationRecord < ActiveRecord::Base
  include FormatHelper
  primary_abstract_class
end
