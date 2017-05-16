defmodule Catalyst.Application do
  use Catalyst.Web, :model

  schema "applications" do
    field :name, :string
    field :is_enabled, :boolean, default: false
    field :valid_until, :utc_datetime, null: true
    field :valid_from, :utc_datetime

    has_many :license_info, LicenseInfo

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :is_enabled, :valid_until, :valid_from])
    |> validate_required([:name, :is_enabled, :valid_from])
  end
end
