defmodule Catalyst.ExAdmin.Applications do
  use ExAdmin.Register

  register_page "Applications" do
    menu priority: 2, label: "Applications"

    content do
      div ".blank_slate_container#dashboard_default_message" do
        span ".blank_slate" do
          span "Welcome to ExAdmin. This is the default dashboard page."
          small "To add dashboard sections, checkout 'web/admin/dashboards.ex'"
        end
      end
    end
  end
end
