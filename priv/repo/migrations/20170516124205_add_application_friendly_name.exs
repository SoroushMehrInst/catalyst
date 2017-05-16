defmodule Catalyst.Repo.Migrations.AddApplicationFriendlyName do
  use Ecto.Migration

  def change do
    alter table(:applications) do
      add :friendly_name, :string, size: 100
    end
  end
end
