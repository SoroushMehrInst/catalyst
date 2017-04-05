defmodule Catalyst.LicenseInfoView do
  use Catalyst.Web, :view

  @doc """
  Renders an error response of register operation
  """
  def render("register_error.json", %{err: err, msg: msg}) do
    %{is_activated: false, err: err, msg: msg}
  end

  @doc """
  Renders a success response of register operation
  """
  def render("register_success.json", %{register_info: register_info}) do
    %{is_activated: true, registration_id: register_info.id}
  end
end
