defmodule Catalyst.LicenseInfoTest do
  use Catalyst.ModelCase

  alias Catalyst.LicenseInfo

  @valid_attrs %{active_code: "some content", id: 42, is_valid: true, max_users: 42, valid_from: DateTime.utc_now, valid_until: DateTime.utc_now}
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
