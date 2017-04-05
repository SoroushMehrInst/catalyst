defmodule Catalyst.LicenseInfoController do
  @moduledoc """
  This module is controller of license registration with REST API
  """

  use Catalyst.Web, :controller

  alias Catalyst.LicenseInfo
  alias Catalyst.Registration

  @doc """
  Registers a device with an activation code and returns registration status
  """
  def register(conn, %{"device_id" => device_id, "active_code" => active_code}) do
    case find_license(active_code) do
      {:error, _cause} ->
        conn
        |> put_status(:not_found)
        |> render("register_error.json", err: "NOT_FOUND", msg: "Your activation code is invalid. Please check and try again!")
      {:ok, license} ->
        case try_register(license, device_id) do
          {:error, _cause} ->
            conn
            |> put_status(:not_found)
            |> render("register_error.json", err: "UNABLE_TO_ACTIVATE", msg: "You are not able to activate with this code on this device!")
          {:ok, register_info} ->
            conn
            |> put_status(:not_found)
            |> render("register_success.json", register_info: register_info)
        end
    end
  end

  defp find_license(active_code) do
    licence_info_query = from d in LicenseInfo,
                          where: d.active_code == ^active_code,
                          select: d

    case Repo.one(licence_info_query) do
      nil ->
        {:error, :not_found}
      license_info ->
        {:ok, license_info}
    end
  end

  defp try_register(license, device_id) do
    current_actives = Repo.one(
      from r in Registration,
      join: l in LicenseInfo,
      where: l.id == ^license.id,
      select: count("r.id"))

    case is_previously_registered(license, device_id) do
      {:ok, register_info} ->
        {:ok, register_info}
      _ ->
        cond do
          license.max_users <= current_actives -> # New registration not possible due to max_users reach
            {:error, :max_users_reached}
          true -> #Register New User
            changeset = Registration.changeset(%Registration{device_id: device_id, license_id: license.id, registration_date: DateTime.utc_now})
            case Repo.insert(changeset) do
              {:ok, register_info} ->
                {:ok, register_info}
              {:error, _changeset} ->
                {:error, :changeset_error}
            end
        end
    end
  end

  defp is_previously_registered(license, device_id) do
    device_activated = Repo.one(
      from r in Registration,
      join: l in LicenseInfo,
      where: l.id == ^license.id and r.device_id == ^device_id,
      select: r)

    case device_activated do
      %{device_id: ^device_id} ->
        {:ok, device_activated}
      _ ->
        :not_activated_before
    end
  end
end
