defmodule Quotilizer.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias Quotilizer.Repo
  alias Quotilizer.Author

  schema "authors" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def find_or_create_author_by_name(name) do
    %Author{}
    |>changeset(%{ name: name })
    |>Repo.insert_or_update
    # |>Repo.insert!(on_conflict: [set: [name: name]], conflict_target: :name)
  end
end
