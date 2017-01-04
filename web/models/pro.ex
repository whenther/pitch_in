defmodule PitchIn.Pro do
  use PitchIn.Web, :model

  schema "pros" do
    belongs_to :user, PitchIn.User
    field :linkedin_url, :string
    field :profession, :string
    field :address_street, :string
    field :address_unit, :string
    field :address_city, :string
    field :address_state, :string
    field :address_zip, :string
    field :phone, :string
    field :experience_starts_at, Timex.Ecto.Date

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:linkedin_url, :profession, :address_street, :address_unit, :address_city, :address_state, :address_zip, :phone, :experience_starts_at])
    |> unique_constraint(:user_id)
  end
end