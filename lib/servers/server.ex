defmodule Servers.Server do
    use Ecto.Schema
    import Ecto.Changeset

    schema "servers" do
        field :name, :string
        field :portbase, :integer
        field :password, :string
        field :admin_password, :string
        field :maxuser, :integer
        field :active, :boolean
        field :pid, :integer
    end

    def build(params) do
        changeset(%Servers.Server{}, params)
    end

    def changeset(server, params \\ %{}) do
        server
        |> cast(params, [:name, :portbase, :password, :admin_password, :active])
        |> validate_required([:name, :portbase, :password, :admin_password])
        |> validate_inclusion(:portbase, 8000..35000)
        |> validate_even_portbase
        |> unique_constraint(:portbase)
    end

    defp validate_even_portbase(changeset) do
        portbase = get_field(changeset, :portbase)        
        case rem(portbase, 2) do
            1 -> add_error(changeset, :portbase, "Port base should be even.")
            0 -> changeset
        end
    end

end