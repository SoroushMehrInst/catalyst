defmodule Catalyst.Registration do
  use Catalyst.Web, :model

  schema "registrations" do
    field :device_id, :string
    field :registration_date, :utc_datetime
    field :is_valid, :boolean, default: true

    belongs_to :license, LicenseInfo

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:device_id, :registration_date, :is_valid])
    |> validate_required([:device_id, :registration_date])
  end
end
