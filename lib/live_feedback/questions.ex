defmodule LiveFeedback.Questions do

  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Courses.CoursePage
  alias LiveFeedback.Questions.QuestionOccurrence
  alias LiveFeedback.Questions.QuestionOptionsOccurrence
  alias LiveFeedback.Questions.Queue


  def subscribe(queue_id) do
    topic = "questions:#{queue_id}"
    Phoenix.PubSub.subscribe(LiveFeedback.PubSub, topic)
  end

  #gets all question for that queue so it can be displayed on the page
  def list_questions_for_queue(queue_id) do
    from(question in QuestionOccurrence,
      where: question.queue_id == ^queue_id,
      order_by: [asc: question.display_order],
      preload: [:question_options_occurrences]
    )
    |> Repo.all()
  end

  #get all options for a question
  def list_options_for_question(question_occurrence_id) do
    Repo.all(from o in QuestionOptionsOccurrence, where: o.question_occurrence_id == ^question_occurrence_id)
  end

  #get specific question
  def get_question!(id) do
    Repo.get!(QuestionOccurrence, id)
    |> Repo.preload(:question_options_occurrences) # Preload the associated question options
  end

  #get specific option
  def get_question_option!(id), do: Repo.get!(QuestionOptionsOccurrence, id)

  #get queue
  def get_queue!(id), do: Repo.get!(Queue, id)

  #get course name so it can be displayed
  def get_course_name(course_page_id) do
    from(course in CoursePage,
      where: course.id == ^course_page_id,
      select: course.title)
      |> Repo.one()
  end

  #get max display order to determine last question
  #used for reordering arrows and when adding new question
  def get_max_display_order(queue_id) do
    query = from question in QuestionOccurrence,
            where: question.queue_id == ^queue_id,
            select: max(question.display_order)

    case Repo.one(query) do
      nil -> 0 # If first question, return 0
      max_display_order -> max_display_order  # Return the maximum display_order
    end
  end


  def add_question(attrs \\ %{}) do
    %QuestionOccurrence{}
    |> QuestionOccurrence.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, question} ->
        {:ok, question}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_question(%QuestionOccurrence{} = question, attrs) do
    IO.inspect(attrs)
    question
    |> QuestionOccurrence.changeset(attrs)
    |> Repo.update()
  end

  #reorders questions to maintain sequential display_order before deleting question
  def delete_question(%QuestionOccurrence{} = question) do
    Repo.transaction(fn ->
      # Update display_order of questions with a greater order
      #moves them down by 1 to maintain sequential display order after deleting the question
      if question.display_order < get_max_display_order(question.queue_id) do
        from(q in QuestionOccurrence,
          where: q.queue_id == ^question.queue_id and q.display_order > ^question.display_order,
          update: [set: [display_order: q.display_order - 1]]
        )
        |> Repo.update_all([])
      end

      # Delete the question
      case Repo.delete(question) do
        {:ok, question} ->
          {:ok, question}
        #rolls back changes if the question doesn't delete
        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end


  def add_option(attrs) do
    %QuestionOptionsOccurrence{}
    |> QuestionOptionsOccurrence.changeset(attrs)
    |> Repo.insert()
  end

  def update_option(option_id, attrs) do
    option = get_question_option!(option_id)
    IO.inspect(option, label: "option to be updated")
    option
    |> QuestionOptionsOccurrence.changeset(attrs)
    |> Repo.update()
  end

  def delete_option(option_id) do
    option = get_question_option!(option_id)
    Repo.delete(option)
  end

  def delete_all_options_for_question(question_occurrence_id) do
    from(o in QuestionOptionsOccurrence, where: o.question_occurrence_id == ^question_occurrence_id)
    |> Repo.delete_all()
  end


  def move_question(question_occurrence_id, direction) when direction in ["up", "down"] do
    Repo.transaction(fn ->
      # Get the question to move
      question = Repo.get!(QuestionOccurrence, question_occurrence_id)

      # Determine the target display order and find the adjacent question
      {offset, comparison} =
        case direction do
          "up" -> {-1, question.display_order - 1}
          "down" -> {1, question.display_order + 1}
        end

      adjacent_question =
        Repo.one(
          from q in QuestionOccurrence,
          where: q.queue_id == ^question.queue_id and q.display_order == ^comparison,
          limit: 1
        )

      # If there's no adjacent question, do nothing
      if adjacent_question do
        # Swap their display_order values
        Repo.update!(Ecto.Changeset.change(question, display_order: question.display_order + offset))
        Repo.update!(Ecto.Changeset.change(adjacent_question, display_order: adjacent_question.display_order - offset))

        # Broadcast update
        topic = "questions:#{question.queue_id}"
        Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:swapped_questions, question, adjacent_question})

        {:ok, {question, adjacent_question}}
      else
        {:error, if(direction == "up", do: :already_at_top, else: :already_at_bottom)}
      end
    end)
  end

end
