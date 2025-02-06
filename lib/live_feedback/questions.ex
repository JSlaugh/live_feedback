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

  def list_options_for_question(question_id) do
    Repo.all(from o in QuestionOptions, where: o.question_id == ^question_id)
  end

  def get_question!(id), do: Repo.get!(Question, id)
  def get_question_option!(id), do: Repo.get!(QuestionOptions, id)

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

  def add_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, question} ->
        topic = "questions:#{question.course_page_id}"
        # Broadcast the new question to interested subscribers
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:new_question, question})
        {:ok, question}

      {:error, changeset} ->
        {:error, changeset}
    end
  end


  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  def delete_question(%Question{} = question) do
    Repo.transaction(fn ->
      # Update display_order of questions with a greater order
      from(q in Question,
        where: q.course_page_id == ^question.course_page_id and q.display_order > ^question.display_order,
        update: [set: [display_order: q.display_order - 1]]
      )
      |> Repo.update_all([])

      # Delete the question
      case Repo.delete(question) do
        {:ok, question} ->
          topic = "questions:#{question.course_page_id}"
          Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:deleted_question, question})
          {:ok, question}

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end


  def add_option(attrs) do
    %QuestionOptions{}
    |> QuestionOptions.changeset(attrs)
    |> Repo.insert()
  end

  def update_option(option_id, attrs) do
    option = get_question_option!(option_id)
    IO.inspect(option, label: "option to be updated")
    option
    |> QuestionOptions.changeset(attrs)
    |> Repo.update()
  end

  def delete_option(option_id) do
    option = get_question_option!(option_id)
    IO.inspect(option, label: "option to be deleted")
    Repo.delete(option)
  end

  def move_question(question_id, direction) when direction in ["up", "down"] do
    Repo.transaction(fn ->
      # Get the question to move
      question = Repo.get!(Question, question_id)

      # Determine the target display order and find the adjacent question
      {offset, comparison} =
        case direction do
          "up" -> {-1, question.display_order - 1}
          "down" -> {1, question.display_order + 1}
        end

      adjacent_question =
        Repo.one(
          from q in Question,
          where: q.course_page_id == ^question.course_page_id and q.display_order == ^comparison,
          limit: 1
        )

      # If there's no adjacent question, do nothing
      if adjacent_question do
        # Swap their display_order values
        Repo.update!(Ecto.Changeset.change(question, display_order: question.display_order + offset))
        Repo.update!(Ecto.Changeset.change(adjacent_question, display_order: adjacent_question.display_order - offset))

        # Broadcast update
        topic = "questions:#{question.course_page_id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:swapped_questions, question, adjacent_question})

        {:ok, {question, adjacent_question}}
      else
        {:error, if(direction == "up", do: :already_at_top, else: :already_at_bottom)}
      end
    end)
  end

end
