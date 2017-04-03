defmodule Catalyst.Repo.Migrations.CreateLicenseInfo do
  use Ecto.Migration

  def change do
    create table(:licensing) do
      add :active_code, :string
      add :valid_from, :datetime
      add :valid_until, :datetime
      add :max_users, :integer
      add :is_valid, :boolean, default: false, null: false

      timestamps()
    end

  end
end
