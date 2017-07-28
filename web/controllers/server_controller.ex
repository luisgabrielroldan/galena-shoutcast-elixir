defmodule GalenaServer.ServerController do
  use GalenaServer.Web, :controller

  alias Servers.Server

  def index(conn, _params) do
    servers = Repo.all(Server)
    render(conn, "index.json", servers: servers)
  end

  def show(conn, %{"id" => id}) do
    server = Repo.get!(Server, id)
    render(conn, "show.json", server: server)
  end

  def start(conn, %{"id" => id}) do
    {:ok, server} = Servers.Monitor.start_server(id)
    render(conn, "show.json", server: server)
  end

  def stop(conn, %{"id" => id}) do
    {:ok, server} = Servers.Monitor.stop_server(id)
    render(conn, "show.json", server: server)
  end

end
