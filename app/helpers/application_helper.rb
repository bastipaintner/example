module ApplicationHelper
  # Gibt den vollen Titel einer Seite zurück (Individuell zu jeder Seite)
  def page_title page_title = ""
    base_title = "SubwayTube"
    page_title.blank? ? base_title : page_title + " | " + base_title
  end
end
