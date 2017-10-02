defmodule Catalyst.LicenseInfoController do
  @moduledoc """
  This module is controller of license registration with REST API
  """

  use Catalyst.Web, :controller

  alias Catalyst.LicenseInfo
  alias Catalyst.Registration
  alias Catalyst.RegistrationAdditionalInfo

  require Logger

  ###
  # API actions
  ###

  @doc """
  Registers a device with an activation code and returns registration status
  """
  def register(conn, %{"device_id" => device_id, "active_code" => active_code_raw, "additional_info" => additional_info, "app_id" => app_id}) do
    active_code = normalize_active_code(active_code_raw)

    Logger.info "Active Code: #{active_code}"

    case find_license(active_code, app_id) do
      {:error, _cause} ->
        conn
        |> put_status(:not_found)
        |> render("register_error.json", err: "NOT_FOUND", msg: "Your activation code is invalid. Please check and try again!")
      {:ok, license} ->
        case try_register(license, device_id) do
          {:error, _cause} ->
            conn
            |> put_status(:not_found)
            |> render("register_error.json", err: "UNABLE_TO_REGISTER", msg: "You are not able to activate with this code on this device!")
          {:ok, register_info} ->
            submit_additional_info(register_info, additional_info) # currently results are ignored
            conn
            |> put_status(:ok)
            |> render("register_success.json", register_info: register_info)
        end
    end
  end

  @doc """
  Register wrapper for requests without ``app_id``
  """
  def register(conn, %{"device_id" => device_id, "active_code" => active_code, "additional_info" => additional_info}) do
    case get_default_app() do
      nil ->
        conn
        |> put_status(500)
        |> render("register_error.json", err: "CONFIG_ERROR", msg: "Current application configuration is incorrect!")
      app ->
        register(conn, %{"device_id" => device_id, "active_code" => active_code, "additional_info" => additional_info, "app_id" => app.id})
    end
  end

  @doc """
  Cancels a registeration requested by the user if possible
  """
  def unregister(conn, %{"device_id" => device_id, "active_code" => active_code, "registration_id" => registration_id, "app_id" => app_id}) do
    case find_license(active_code, app_id) do
      {:error, _cause} ->
        conn
        |> put_status(:not_found)
        |> render("unregister_error.json", err: "NOT_FOUND", msg: "Your activation code is invalid. Please check and try again!")
      {:ok, license} ->
        case try_unregister(license, device_id, registration_id) do
          {:error, :max_inactive_reached} ->
            conn
            |> put_status(:forbidden)
            |> render("unregister_error.json", err: "UNABLE_TO_UNREGISTER", msg: "You are not able to deactivate this code on this device!")
          {:ok, register_info} ->
            conn
            |> put_status(:ok)
            |> render("unregister_success.json", register_info: register_info)
          _ ->
            conn
            |> put_status(500)
            |> render("unregister_error.json", err: "UNKNOWN_ERROR", msg: "An Unknown error occured in deactivation procedure!")
        end
    end
  end

  @doc """
  Unregister wrapper for requests without ``app_id``
  """
  def unregister(conn, %{"device_id" => device_id, "active_code" => active_code, "registration_id" => registration_id}) do
    case get_default_app() do
      nil ->
        conn
        |> put_status(500)
        |> render("register_error.json", err: "CONFIG_ERROR", msg: "Current application configuration is incorrect!")
      app ->
        unregister(conn, %{"device_id" => device_id, "active_code" => active_code, "registration_id" => registration_id, "app_id" => app.id})
    end
  end

  ###
  # Helpers
  ###

  defp find_license(active_code, app_id) do
    licence_info_query = from d in LicenseInfo,
                          where: d.active_code == ^active_code and d.application_id == ^app_id,
                          select: d

    case Repo.one(licence_info_query) do
      nil ->
        {:error, :not_found}
      license_info ->
        {:ok, license_info}
    end
  end

  defp try_register(license, device_id) do
    case is_previously_registered(license, device_id) do
      {:ok, register_info} ->
        {:ok, register_info}
      _ ->
        current_actives = Repo.one(
          from r in Registration,
          where: r.license_id == ^license.id,
          select: count("*"))

        alias Catalyst.RegistrationAdditionalInfo

        cond do
          license.max_users <= current_actives -> # New registration not possible due to max_users reach
            {:error, :max_users_reached}
          true -> # Register New User
            case Repo.insert(%Registration{
                device_id: device_id,
                license_id: license.id,
                registration_date: DateTime.utc_now,
                registration_id: Ecto.UUID.generate}) do
              {:ok, register_info} ->
                {:ok, register_info}
              {:error, changeset} ->
                {:error, :changeset_error}
            end
        end
    end
  end

  defp submit_additional_info(register_info, additional_info) do
    db_add_info = get_add_info(register_info.id, additional_info)
    count = Enum.count(db_add_info)

    case Repo.insert_all(RegistrationAdditionalInfo, db_add_info) do
      {^count, _} ->
        :ok
      _ ->
        :error
    end
  end

  defp get_add_info(register_id, additional_info) when is_list(additional_info) do
    do_get_add_info(register_id, additional_info, [])
  end

  defp do_get_add_info(register_id, [map_info | tail], acc) do
    [key | _] = Map.keys map_info

    do_get_add_info(register_id,
      tail,
      [%{field_name: key, field_value: map_info[key], registrations_id: register_id} | acc])
  end

  defp do_get_add_info(_register_id, [], acc), do: acc

  defp try_unregister(license, device_id, registration_id) do
    current_inactives = Repo.one(
      from r in Registration,
      join: l in LicenseInfo,
      where: l.id == ^license.id and r.is_unregistered == true,
      select: count("r.id"))

      cond do
        license.max_unregister <= current_inactives -> # Unregistration not possible due to max_users reach
          {:error, :max_inactive_reached}
        true -> # Register New User
          registration = Repo.one(
            from r in Registration,
            where: r.registration_id == ^registration_id,
            select: r)

          changeset = Registration.changeset(registration, %{is_unregistered: true, unregister_date: DateTime.utc_now})

          require IEx
          IEx.pry

          case Repo.update(changeset) do
            {:ok, register_info} ->
              {:ok, register_info}
            {:error, _changeset} ->
              {:error, :changeset_error}
          end
      end
  end

  defp is_previously_registered(license, device_id) do
    device_activated = Repo.one(
      from r in Registration,
      join: l in LicenseInfo,
      where: l.id == ^license.id and r.device_id == ^device_id and r.is_unregistered == false,
      select: r)

    case device_activated do
      %{device_id: ^device_id} ->
        {:ok, device_activated}
      _ ->
        :not_activated_before
    end
  end

  defp get_default_app(), do:
    Repo.one(from d in Catalyst.Application, order_by: [d.id], select: d)

  defp normalize_active_code(active_code_raw) do
    active_code_raw
    |> String.trim
    |> Numero.normalize
    |> Numero.remove_non_digits
  end
end
