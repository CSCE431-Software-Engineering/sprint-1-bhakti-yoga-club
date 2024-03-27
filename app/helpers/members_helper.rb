module MembersHelper

  def sort_direction_icon(column)
    if params[:sort_column] == column && params[:sort_direction] == "asc"
      content_tag(:span, "▲", class: "asc-sort")
    elsif params[:sort_column] == column && params[:sort_direction] == "desc"
      content_tag(:span, "▼", class: "desc-sort")
    end
  end

  def sortable(column_title, column)
    should_change_column = (params[:sort_column] == column)
    direction = params[:sort_direction]
    if should_change_column
      direction = (params[:sort_direction] == "asc") ? false : true
    end
    link_to column_title, { sort_column: column, sort_direction: direction ? "asc" : "desc" }
  end

  def sortable_columns
    ["full_name", "email", "date_joined", "date_left", "is_on_mailing_list", "is_active_paid_member", "is_admin"]
  end
  
end
