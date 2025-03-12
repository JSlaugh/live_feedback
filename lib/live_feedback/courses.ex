defmodule LiveFeedback.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias LiveFeedback.Accounts.UserProfile
  alias LiveFeedback.Repo

  alias LiveFeedback.Courses.CoursePage

  @behaviour Bodyguard.Policy

  # Delete course_pages permissions
  def authorize(:delete_course_page, %{is_admin: true} = _user, _course_page), do: :ok

  # Can delete course_pages if you are the user that created the course_page
  def authorize(:delete_course_page, %{id: user_id} = _user, %{user_id: user_id} = _course_page),
    do: :ok

  def authorize(:delete_course_page, _user, _course_page), do: :error

  # Change course_pages permissions
  def authorize(:change_course_page, %{is_admin: true} = _user, _course_page), do: :ok

  # Can change course_pages if you are the user that created the course_page
  def authorize(:change_course_page, %{id: user_id} = _user, %{user_id: user_id} = _course_page),
    do: :ok

  def authorize(:change_course_page, _user, _course_page), do: :error

  @doc """
  Returns the list of course_pages.

  ## Examples

      iex> list_course_pages()
      [%CoursePage{}, ...]

  """
  def list_course_pages do
    Repo.all(CoursePage)
  end

  @doc """
  Gets a single course_page.

  Raises `Ecto.NoResultsError` if the Course page does not exist.

  ## Examples

      iex> get_course_page!(123)
      %CoursePage{}

      iex> get_course_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course_page!(id), do: Repo.get!(CoursePage, id)

  @doc """
  Creates a course_page.

  ## Examples

      iex> create_course_page(%{field: value})
      {:ok, %CoursePage{}}

      iex> create_course_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course_page(attrs \\ %{}) do
    %CoursePage{}
    |> CoursePage.changeset(attrs)
    |> Repo.insert()
  end

  def join_class(attrs \\ %{}) do
    # Check if a UserProfile already exists for the user and course
    case Repo.get_by(UserProfile,
           user_id: attrs["user_id"],
           course_page_id: attrs["course_page_id"]
         ) do
      nil ->
        # No existing profile, so insert a new one
        %UserProfile{}
        |> UserProfile.changeset(attrs)
        |> Repo.insert()

      %UserProfile{role: "owner"} ->
        # If the user is an owner, return an error
        {:error, "You are the owner of this course and cannot join as a participant."}

      %UserProfile{is_active: true} ->
        # If the user is already active, return an error
        {:error, "You are already an active participant in this course."}

      user_profile ->
        # Profile exists, so update it
        user_profile
        |> UserProfile.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Updates a course_page.

  ## Examples

      iex> update_course_page(course_page, %{field: new_value})
      {:ok, %CoursePage{}}

      iex> update_course_page(course_page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_course_page(%CoursePage{} = course_page, attrs) do
    course_page
    |> CoursePage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a course_page.

  ## Examples

      iex> delete_course_page(course_page)
      {:ok, %CoursePage{}}

      iex> delete_course_page(course_page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course_page(%CoursePage{} = course_page) do
    Repo.delete(course_page)
  end

  def leave_course_page(course_page_id, user_id) do
    profile =
      Repo.one(
        from profile in UserProfile,
          where: profile.user_id == ^user_id and profile.course_page_id == ^course_page_id
      )

    if profile.is_active do
      profile
      |> UserProfile.changeset(%{"is_active" => false})
      |> Repo.update()
    else
      {:error, "Profile not found"}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course_page changes.

  ## Examples

      iex> change_course_page(course_page)
      %Ecto.Changeset{data: %CoursePage{}}

  """
  def change_course_page(%CoursePage{} = course_page, attrs \\ %{}) do
    CoursePage.changeset(course_page, attrs)
  end

  def get_course_page_by_slug!(slug) do
    Repo.get_by(CoursePage, slug: slug)
  end

  def get_course_page_by_slug(slug) do
    case Repo.get_by(CoursePage, slug: slug) do
      nil -> {:error, :not_found}
      course -> {:ok, course}
    end
  end

  def list_course_pages_by_user(user_id, role) do
    Repo.all(
      from cp in CoursePage,
        join: profile in UserProfile,
        on: profile.course_page_id == cp.id,
        where: profile.user_id == ^user_id and profile.role == ^role and profile.is_active == true,
        preload: [user_profile: profile],
        select: %{cp | user_profile: profile}
    )
  end

  def get_profile_for_course(user_id, course_page_id) do
    Repo.one(
      from profile in UserProfile,
        where: profile.user_id == ^user_id and profile.course_page_id == ^course_page_id
    )
  end

  def toggle_favorite(user_id, course_page_id) do
    # First, find the profile
    query = from(profile in UserProfile,
      where: profile.user_id == ^user_id and profile.course_page_id == ^course_page_id)

    # Get the profile
    case Repo.one(query) do
      nil ->
        {:error, :not_found}
      profile ->
        # Toggle the is_course_page_favorite field to its opposite value
        profile
        |> Ecto.Changeset.change(is_course_page_favorite: not profile.is_course_page_favorite)
        |> Repo.update()
    end
  end
end
