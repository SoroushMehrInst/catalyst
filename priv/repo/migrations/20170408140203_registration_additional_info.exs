defmodule Catalyst.Repo.Migrations.RegistrationAdditionalInfo do
  use Ecto.Migration

  def change do
    create table(:registration_additional_info) do
      add :field_name, :string, size: 100
      add :field_value, :string, size: 255
      add :registrations_id, references(:registrations)
    end

    create index(:registration_additional_info, [:field_name], unique: false)
  end
end
