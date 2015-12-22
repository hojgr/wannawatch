defmodule Wannawatch.User do
  use Wannawatch.Web, :model

  schema "users" do
    field :username, :string
    field :password, :string
    field :email, :string

    timestamps
  end

  @required_fields ~w(username password email)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:username, min: 2, max: 64)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    
  end
end
