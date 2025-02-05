defmodule LiveFeedback.Questions do

  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Courses.CoursePage
  alias LiveFeedback.Questions.Question
  alias LiveFeedback.Questions.QuestionOptions

  def list_questions_for_course(course_page_id) do
    from(question in Question,
      where: question.course_page_id == ^course_page_id,
      order_by: [asc: question.display_order],
      preload: [:question_options]  # Preload the associated question options
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

  def update_question(id, attrs) do
    id
    |> Repo.get(Question)
    |> Question.changeset(attrs)
    |> Repo.update()
  end


  def add_option_to_question(attrs) do
    %QuestionOptions{}
    |> QuestionOptions.changeset(attrs)
    |> Repo.insert()
  end

  # Update or add an option to the question
  def update_or_add_option_to_question(attrs) do
    case Repo.get_by(QuestionOptions, option_order: attrs["option_order"], question_id: attrs["question_id"]) do
      nil -> add_option_to_question(attrs) # Add if it doesn't exist
      option -> update_option(option, attrs) # Update if it exists
    end
  end

  # Update an option
  def update_option(option, attrs) do
    option
    |> QuestionOptions.changeset(attrs)
    |> Repo.update()
  end

  # Delete an option for a question if it's no longer present
  def delete_option_for_question(question_id, order) do
    option = Repo.get_by(QuestionOptions, question_id: question_id, option_order: order)
    if option, do: Repo.delete(option)
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
