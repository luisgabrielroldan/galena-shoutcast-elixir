defmodule Servers.Director do

    @sc_serv "./bin/sc_serv"
    @config_folder "./var/config"

    def kill_server(server_pid) do
        case server_alive?(server_pid) do
            true ->
                System.cmd("kill", [ Integer.to_string(server_pid) ])
        end
    end

    def run_server(server) do
        config_path = @config_folder <> "/#{server.id}.conf"         
        Servers.ConfigAdapter.create_config_file(config_path, server)
        info = exec_server(config_path)

        case info do
            nil -> 0
            _ -> info[:os_pid]
        end        
    end

    def server_alive?(server_pid) do
        case server_pid do
            0 -> false
            _ -> server_ps_alive?(server_pid)
        end             
    end

    defp exec_server(config_path) do
        Port.open({:spawn_executable, @sc_serv}, [:binary, args: [ config_path ]])
        |> Port.info
    end    

    defp server_ps_alive?(server_pid) do
        server_pid
        |> Integer.to_string
        |> get_ps_result
        |> handle_ps_result  
    end

    defp get_ps_result(pid) do
        System.cmd "ps", ["-fp", pid]
    end

    defp handle_ps_result({_, 1}), do: false

    defp handle_ps_result({output, 0}) do
        String.contains? output, "sc_serv"
    end

end