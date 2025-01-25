defmodule LiveFeedback.Questions do

  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Messages.Message
  alias LiveFeedback.Messages.LikedBy
  alias LiveFeedback.Courses.CoursePage
  alias LiveFeedback.Questions.Question

  def list_questions_for_course(course_page_id) do
    from(question in Question,
      where: question.course_page_id == ^course_page_id,
      order_by: [asc: question.display_order]
    )
    |> Repo.all()
  end

  def get_question!(id), do: Repo.get!(Question, id)

  def get_course_name(course_page_id) do
    from(course in CoursePage,
      where: course.id == ^course_page_id,
      select: course.title)
      |> Repo.one()
  end

  def get_max_display_order(course_page_id) do
    query = from question in Question,
            where: question.course_page_id == ^course_page_id,
            select: max(question.display_order)

    case Repo.one(query) do
      nil -> 1 # If no questions exist, return 0
      max_display_order -> max_display_order  # Return the maximum display_order
    end
  end

  def add_question(attrs) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  def delete_question(%Question{} = question) do
    # Delete the question from the database
    Repo.delete(question)
    |> case do
      {:ok, question} ->
        # Broadcast the deletion event for questions
        topic = "questions:#{question.course_page_id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:deleted_question, question})
        {:ok, question}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
