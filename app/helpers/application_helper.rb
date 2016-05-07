################################################################################
# general helper for the application                                           #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/helpers/application_helper.rb                                      #
################################################################################
module ApplicationHelper
  def page_title page_title = ""
    base_title = "SubwayTube"
    page_title.blank? ? base_title : page_title + " | " + base_title
  end
end
