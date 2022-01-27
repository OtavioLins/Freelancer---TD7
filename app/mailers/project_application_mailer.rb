class ProjectApplicationMailer < ApplicationMailer
  def notify_new_application
    @application = params[:project_application]
    @professional = @application.professional.profile.social_name
    @owner = @application.project.user.email
    mail(to: @owner,
         subject: "Nova aplicação para seu projeto")
  end
end
