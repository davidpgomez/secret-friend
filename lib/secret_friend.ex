defmodule SecretFriends do
  use Application

  @impl Application
  def start(_type, _args) do
    # create a list supervisor at application start
    children = [
      {SecretFriends.Boundary.SFListsSupervisor, :supervised}
    ]

    # Create a table using at startup (as a set -now allowing duplicates-)
    # and public (other processes can interact with it)
    :ets.new(:sflist_cache, [:named_table, :set, :public])

    # Create a supervisor with 1_for_1 option (if a children dies, restart only that)
    opts = [strategy: :one_for_one, name: SecretFriends.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
