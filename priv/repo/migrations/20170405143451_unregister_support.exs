defmodule Catalyst.Repo.Migrations.UnregisterSupport do
  use Ecto.Migration

  def change do
    alter table(:registrations) do
      add :is_unregistered, :boolean, default: false, null: false
      add :unregister_date, :utc_datetime, null: true
      add :registration_id, :uuid, null: false
    end

    create index(:registrations, [:is_unregistered], unique: false)
  end
end
