defmodule SecretFriends.Boundary.SFListsSupervisor do
    use DynamicSupervisor
    alias SecretFriends.Worker.SFWorker
    @moduledoc """
    Create our own supervisor which will handle the workers. This supervisor
    will be unique (in a singleton sense).
    """

    def start_link(_args) do
        DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
    end

    def init(nil) do
        DynamicSupervisor.init(strategy: :one_for_one)
    end

    def create_sflist(name) do
        # as SFWorker does not have child_spec method, we have to manually
        # create the spec for the supervisor
        spec = %{id: SFWorker, start: {SFWorker, :start_link, [name]}}
        DynamicSupervisor.start_child(__MODULE__, spec)
    end

end
