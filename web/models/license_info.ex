defmodule Catalyst.LicenseInfo do
  use Catalyst.Web, :model

  schema "licensing" do
    field :active_code, :string
    field :valid_from, :utc_datetime
    field :valid_until, :utc_datetime
    field :max_users, :integer
    field :is_valid, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :active_code, :valid_from, :valid_until, :max_users, :is_valid])
    |> validate_required([:id, :active_code, :valid_from, :valid_until, :max_users, :is_valid])
  end
end
