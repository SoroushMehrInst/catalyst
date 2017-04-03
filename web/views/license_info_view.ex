defmodule Catalyst.LicenseInfoView do
  use Catalyst.Web, :view

  def render("index.json", %{licensing: licensing}) do
    %{data: render_many(licensing, Catalyst.LicenseInfoView, "license_info.json")}
  end

  def render("show.json", %{license_info: license_info}) do
    %{data: render_one(license_info, Catalyst.LicenseInfoView, "license_info.json")}
  end

  def render("license_info.json", %{license_info: license_info}) do
    %{id: license_info.id,
      id: license_info.id,
      active_code: license_info.active_code,
      valid_from: license_info.valid_from,
      valid_until: license_info.valid_until,
      max_users: license_info.max_users,
      is_valid: license_info.is_valid}
  end
end
