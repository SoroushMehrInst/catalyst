defmodule Catalyst.LicenseInfoControllerTest do
  use Catalyst.ConnCase

  alias Catalyst.LicenseInfo
  @valid_attrs %{active_code: "some content", id: 42, is_valid: true, max_users: 42, valid_from: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, valid_until: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, license_info_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    license_info = Repo.insert! %LicenseInfo{}
    conn = get conn, license_info_path(conn, :show, license_info)
    assert json_response(conn, 200)["data"] == %{"id" => license_info.id,
      "id" => license_info.id,
      "active_code" => license_info.active_code,
      "valid_from" => license_info.valid_from,
      "valid_until" => license_info.valid_until,
      "max_users" => license_info.max_users,
      "is_valid" => license_info.is_valid}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, license_info_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, license_info_path(conn, :create), license_info: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(LicenseInfo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, license_info_path(conn, :create), license_info: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    license_info = Repo.insert! %LicenseInfo{}
    conn = put conn, license_info_path(conn, :update, license_info), license_info: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(LicenseInfo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    license_info = Repo.insert! %LicenseInfo{}
    conn = put conn, license_info_path(conn, :update, license_info), license_info: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    license_info = Repo.insert! %LicenseInfo{}
    conn = delete conn, license_info_path(conn, :delete, license_info)
    assert response(conn, 204)
    refute Repo.get(LicenseInfo, license_info.id)
  end
end
