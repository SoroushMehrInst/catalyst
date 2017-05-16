defmodule Catalyst.ApplicationTest do
  use Catalyst.ModelCase

  alias Catalyst.Application

  @valid_attrs %{is_enabled: true, friendly_name: "some content", name: "app1", valid_from: DateTime.utc_now, valid_until: DateTime.utc_now}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Application.changeset(%Application{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Application.changeset(%Application{}, @invalid_attrs)
    refute changeset.valid?
  end
end
