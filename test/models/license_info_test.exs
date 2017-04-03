defmodule Catalyst.LicenseInfoTest do
  use Catalyst.ModelCase

  alias Catalyst.LicenseInfo

  @valid_attrs %{active_code: "some content", id: 42, is_valid: true, max_users: 42, valid_from: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, valid_until: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LicenseInfo.changeset(%LicenseInfo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LicenseInfo.changeset(%LicenseInfo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
