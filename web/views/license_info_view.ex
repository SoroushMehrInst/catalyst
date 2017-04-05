defmodule Catalyst.LicenseInfoView do
  use Catalyst.Web, :view

  def render("error.json", %{err: err, msg: msg}) do
    %{is_activated: false, err: err, msg: msg}
  end

  def render("success.json", %{register_info: register_info}) do
    %{is_activated: true, registration_id: register_info.id}
  end
end
