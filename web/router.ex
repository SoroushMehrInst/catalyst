defmodule Catalyst.Router do
  use Catalyst.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Catalyst do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Catalyst do
    pipe_through :api

    post "/licensing/register", LicenseInfoController, :register
    post "/licensing/unregister", LicenseInfoController, :unregister
  end
end
