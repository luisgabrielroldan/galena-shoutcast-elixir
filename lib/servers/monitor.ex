defmodule Servers.Monitor do
    use GenServer

    @server_name :servers_monitor

    alias Servers.Server
    alias Servers.Director
    alias GalenaServer.Repo

    def check_servers() do
        GenServer.call(@server_name, {:check_servers})
    end

    def start_server(server_id) do
        GenServer.call(@server_name, {:start_server, server_id})
    end

    def stop_server(server_id) do
        GenServer.call(@server_name, {:stop_server, server_id})
    end

    def start_link do
        GenServer.start_link(__MODULE__, %{})
    end

    def init(state) do
        receive do after 1000 -> :ok end    
        Process.register(self(), @server_name)
        schedule_check()
        {:ok, state}
    end

    def handle_info(:check_servers, state) do
        check_all_servers_state()
        schedule_check()
        {:noreply, state}
    end

    def handle_info({_, {:data, _}}, state), do: {:noreply, state}

    defp schedule_check() do
        Process.send_after(self(), :check_servers, 1000)
    end

    def handle_call({:check_servers}, _from, state) do
        check_all_servers_state()
        {:reply, :ok, state}
    end

    def handle_call({:start_server, server_id}, _from, state) do
        server_id
        |> get_server_by_id
        |> set_server_activation(true, state)
    end

    def handle_call({:stop_server, server_id}, _from, state) do
        server_id
        |> get_server_by_id
        |> set_server_activation(false, state)
    end

    defp set_server_activation(server, active?, state) do
        case server do
            nil ->
                {:reply, {:error, reason: "Server not found!"}, state}
            _   -> 
                server
                |> set_server_active_flag(active?)
                |> check_server_state
                |> build_server_activation_result(state)
        end
    end

    defp build_server_activation_result(server, state) do
        {:reply, {:ok, server}, state}
    end
    
    defp check_all_servers_state() do
        Repo.all(Server)
        |> Enum.map(&check_server_state/1)
    end

    defp check_server_state(server) do        
        state = { server.active, Director.server_alive?(server.pid) }
        case state do
            { false, true } ->
                Director.kill_server(server.pid)
                save_server_pid(0, server)
            { true,  false } -> 
                Director.run_server(server)
                |> save_server_pid(server)
            _ -> false
        end
    end    

    defp save_server_pid(pid, server) do
        server
        |> Ecto.Changeset.change(pid: pid)
        |> Repo.update!
    end

    defp set_server_active_flag(server, value) do
        server
        |> Ecto.Changeset.change(active: value)
        |> Repo.update!
    end

    defp get_server_by_id(server_id) do
        Repo.get(Server, server_id)
    end

end