defmodule SecretFriends do
  use Application

  @impl Application
  def start(_type, _args) do
    # create SFWorksers at application start
    children = [
      {SecretFriends.Worker.SFWorker, :supervised}
    ]

    # Create a supervisor with 1_for_1 option (if a children dies, restart only that)
    opts = [strategy: :one_for_one, name: SecretFriends.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
