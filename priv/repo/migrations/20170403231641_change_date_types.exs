defmodule Catalyst.Repo.Migrations.ChangeDateTypes do
  use Ecto.Migration

  def change do
    alter table(:licensing) do
      modify :valid_from, :utc_datetime
      modify :valid_until, :utc_datetime
    end

  end
end
