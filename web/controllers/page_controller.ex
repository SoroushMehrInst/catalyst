defmodule Catalyst.PageController do
  use Catalyst.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
