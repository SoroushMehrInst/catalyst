defmodule Catalyst.Repo.Migrations.MaxUnregister do
  use Ecto.Migration

  def change do
    alter table(:licensing) do
      add :max_unregister, :integer, default: 0, null: false
    end
  end
end
