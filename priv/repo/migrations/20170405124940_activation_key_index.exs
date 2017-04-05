defmodule Catalyst.Repo.Migrations.ActivationKeyIndex do
  use Ecto.Migration

  def change do
    alter table(:licensing) do
      modify :active_code, :string, size: 255
    end

    create index(:licensing, [:active_code], unique: true)
  end
end
