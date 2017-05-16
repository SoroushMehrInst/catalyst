defmodule Catalyst.LicenseInfoControllerTest do
  use Catalyst.ConnCase

  alias Catalyst.LicenseInfo
  @valid_attrs %{active_code: "some content", id: 42, is_valid: true, max_users: 42, valid_from: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, valid_until: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
end
