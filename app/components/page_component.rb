class PageComponent < ApplicationComponent
  with_content_areas :header, :body

  def initialize(subject: nil, tabs: false, sidebar: false, sidebar_partial: nil)
    @subject = subject
    @tabs = tabs
    @sidebar = sidebar
    @sidebar_partial = sidebar_partial
  end

  def subject_view_directory
    return "" unless subject
    subject.class.name.underscore.pluralize
  end

  private

  attr_reader :subject, :sidebar, :tabs, :sidebar_partial
end
