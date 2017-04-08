defmodule Catalyst.Registration do
  use Catalyst.Web, :model

  schema "registrations" do
    field :device_id, :string
    field :registration_date, :utc_datetime
    field :is_valid, :boolean, default: true

    field :is_unregistered, :boolean, default: false
    field :unregister_date, :utc_datetime

    field :registration_id, Ecto.UUID

    belongs_to :license, LicenseInfo

    has_many :registration_additional_info, Catalyst.RegistrationAdditionalInfo

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:device_id, :registration_date, :is_valid, :is_unregistered, :unregister_date])
    |> validate_required([:device_id, :registration_date])
  end
end
