defmodule Servers.ConfigAdapter do
    def create_config_file(path, server) do

        file_header(server)
        
        |> add_setting(server.portbase, "portbase")
        |> add_setting(server.password, "password")
        |> add_setting(server.admin_password, "adminpassword")
        |> add_setting(server.maxuser, "maxuser")
        |> add_setting(0, "screenlog")
        |> add_setting("", "logfile")
        |> add_setting("", "w3clog")

        |> write_config(path)

    end

    defp file_header(server) do
        "# Shoutcast server config (ID=#{server.id})\n\n"
    end

    defp write_config(content, path), do: File.write!(path, content)

    defp add_setting(content, value, prop), do: content <> build_line(value, prop)

    defp build_line(value, prop) when is_binary(value), do: "#{prop}=#{value}\n"

    defp build_line(value, prop) when is_integer(value) do
        value
        |> Integer.to_string
        |> build_line(prop)
    end

    defp build_line(value, prop) do
        value
        |> Kernel.inspect
        |> build_line(prop)
    end

end