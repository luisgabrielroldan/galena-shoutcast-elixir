defmodule GalenaServer.PageController do
  use GalenaServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
