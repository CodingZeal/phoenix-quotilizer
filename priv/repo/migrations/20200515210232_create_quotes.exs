defmodule Quotilizer.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :text, :string
      add :author_id, references(:authors)

      timestamps()
    end

  end
end
