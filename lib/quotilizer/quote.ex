defmodule Quotilizer.Quote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Quotilizer.Repo
  alias Quotilizer.Quote

  schema "quotes" do
    belongs_to :author, Quotilizer.Author
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(%Quote{} = quote, attrs) do
    quote
    |> cast(attrs, [:text, :author_id])
    |> validate_required([:text])
  end

  def create_quote(quoteJson) do
    %Quote{}
    |>changeset(format_quote(quoteJson))
    |>Repo.insert
    |>broadcast(:quote_created)
  end

  defp format_quote(%{ "Quote" => text, "Author" => author_name }) do
    {:ok, %{ id: id } } = Quotilizer.Author.find_or_create_author_by_name(author_name)
    %{ text: text, author_id: id }
  end

  defp broadcast({:error, error}, _event) do
    IO.inspect(error)
  end

  defp broadcast({:ok, quote}, event) do
    Phoenix.PubSub.broadcast(Quotilizer.PubSub, "quotes", { event, quote })
  end
end
