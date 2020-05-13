defmodule Quotilizer.Repo do
  use Ecto.Repo,
    otp_app: :quotilizer,
    adapter: Ecto.Adapters.Postgres
end
