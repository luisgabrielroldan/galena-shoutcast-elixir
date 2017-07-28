defmodule GalenaServer.ServerView do
  use GalenaServer.Web, :view

  def render("index.json", %{servers: servers}) do
    %{servers: render_many(servers, GalenaServer.ServerView, "server.json")}
  end

  def render("show.json", %{server: server}) do
    %{server: render_one(server, GalenaServer.ServerView, "server.json")}
  end

  def render("server.json", %{server: server}) do
    %{id: server.id,
      name: server.name,
      portBase: server.portbase,
      password: server.name,
      adminPassword: server.name,
      maxusers: 0,
      public: true,
      isRunning: server.active,
      isPublic: false,
      state: nil}
  end
end