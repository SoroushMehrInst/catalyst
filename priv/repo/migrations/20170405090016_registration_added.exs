defmodule Catalyst.Repo.Migrations.RegistrationAdded do
  use Ecto.Migration

  def change do
    create table(:registrations) do
      add :device_id, :string, size: 255
      add :registration_date, :utc_datetime
      add :is_valid, :boolean, default: true, null: false
      add :license_id, references(:licensing)

      timestamps()
    end
  end
end
