defmodule Catalyst.RegistrationAdditionalInfo do
  use Catalyst.Web, :model

  schema "registration_additional_info" do
    field :field_name, :string
    field :field_value, :string

    belongs_to :registrations, Registration

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:field_name, :field_value])
    |> validate_required([:field_name, :field_value])
  end
end
