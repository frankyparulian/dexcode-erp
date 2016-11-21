# == Schema Information
#
# Table name: documents
#
#  id                :integer          not null, primary key
#  document          :string(255)      not null
#  documentable_id   :integer
#  documentable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_documents_on_documentable_id_and_documentable_type  (documentable_id,documentable_type)
#

# For storing documents
class Document < ActiveRecord::Base
  belongs_to :documentable, polymorphic: true

  mount_uploader :document, UnprocessedUploader

  validates :document, presence: true
  validates :documentable_id, presence: true
  validates :documentable_type, presence: true

  after_destroy :remove_document_folder

  def remove_document_folder
    directory = "#{Rails.root}/public/uploads/document/document/#{id}"
    FileUtils.rm_rf(directory)
  end
end
