class ProjectApplicationSerializer < ActiveModel::Serializer
  attributes :id, :situation, :professional

  def professional
    ActiveModelSerializers::SerializableResource.new(object.professional, serializer: ProjectApplicationProfessionalSerializer)
  end
end
