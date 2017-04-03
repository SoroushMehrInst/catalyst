defmodule Catalyst.LicenseInfoController do
  use Catalyst.Web, :controller

  alias Catalyst.LicenseInfo

  def index(conn, _params) do
    licensing = Repo.all(LicenseInfo)
    render(conn, "index.json", licensing: licensing)
  end

  def create(conn, %{"license_info" => license_info_params}) do
    changeset = LicenseInfo.changeset(%LicenseInfo{}, license_info_params)

    case Repo.insert(changeset) do
      {:ok, license_info} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", license_info_path(conn, :show, license_info))
        |> render("show.json", license_info: license_info)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Catalyst.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    license_info = Repo.get!(LicenseInfo, id)
    render(conn, "show.json", license_info: license_info)
  end

  def update(conn, %{"id" => id, "license_info" => license_info_params}) do
    license_info = Repo.get!(LicenseInfo, id)
    changeset = LicenseInfo.changeset(license_info, license_info_params)

    case Repo.update(changeset) do
      {:ok, license_info} ->
        render(conn, "show.json", license_info: license_info)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Catalyst.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    license_info = Repo.get!(LicenseInfo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(license_info)

    send_resp(conn, :no_content, "")
  end
end
