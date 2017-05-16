defmodule Catalyst.Repo.Migrations.CreateApplication do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :name, :string
      add :is_enabled, :boolean, default: false, null: false
      add :valid_until, :utc_datetime
      add :valid_from, :utc_datetime

      timestamps()
    end


    alter table(:licensing) do
      add :application_id, references(:applications)
    end
  end
end
