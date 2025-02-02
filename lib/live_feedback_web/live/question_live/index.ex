defmodule LiveFeedbackWeb.QuestionLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Questions

  @impl true
  def mount(%{"course_page_id" => course_page_id}, _session, socket) do
    questions = Questions.list_questions_for_course(course_page_id)

    {:ok,
     socket
     |> assign(:course_page_id, course_page_id)
     |> assign(:course_name, Questions.get_course_name(course_page_id))
     |> assign(:show_form, "none")
     |> assign(:question_type, "QA")
     |> stream(:questions, questions)
    }

  end

  @impl true
  def handle_event("add_question", params, socket) do
    IO.inspect(params, label: "Received params")
    content = Map.get(params, "question_content", "")
    type = Map.get(params, "question_type", "")

    option_A =
      if type == "true_false" do
        "true"
      else
        Map.get(params, "option_A", "")
      end
    option_B =
      if type == "true_false" do
        "false"
      else
        Map.get(params, "option_B", "")
      end
    option_C = Map.get(params, "option_C", "")
    option_D = Map.get(params, "option_D", "")

    answer = Map.get(params, "answer", "")
    correct_A = Map.get(params, "correct_A", "") #change to select
    correct_B = Map.get(params, "correct_B", "")
    correct_C = Map.get(params, "correct_C", "")
    correct_D = Map.get(params, "correct_D", "")

    answer_A = if answer == "A" || correct_A == "A", do: true, else: false
    answer_B = if answer == "B" || correct_B == "B", do: true, else: false
    answer_C = if answer == "C" || correct_C == "C", do: true, else: false
    answer_D = if answer == "D" || correct_D == "D", do: true, else: false

    # Prepare the attributes for the new question
    attrs = %{
      "course_page_id" => socket.assigns.course_page_id,
      "question_content" => content,
      "question_type" => type,
      "display_order" => Questions.get_max_display_order(socket.assigns.course_page_id)
    }

    # Attempt to add the question
    case Questions.add_question(attrs) do
      {:ok, question} ->
        # Loop through each option and call add_option_to_question/1 if not empty
        for {option, correct, order} <- [
              {option_A, answer_A, 1},
              {option_B, answer_B, 2},
              {option_C, answer_C, 3},
              {option_D, answer_D, 4}
            ], option != "" do
          option_attrs = %{
            "option_order" => order,
            "option_content" => option,
            "is_correct" => correct,
            "question_id" => question.id  # Associate with the newly added question
          }
          # Add the option to the question
          Questions.add_option_to_question(option_attrs)
        end

        # Return the updated socket with the new question streamed
        {:noreply,
         socket
         |> assign(show_form: "none")
         |> put_flash(:info, "Question added successfully.")
         |> stream_insert(:questions, question)}  # Stream the newly added question

      {:error, changeset} ->
        # In case of error, return the socket with an error message
        {:noreply,
         socket
         |> put_flash(:error, "Failed to add question.")}
    end
  end

  @impl true
  def handle_event("delete_question", %{"id" => id}, socket) do
    # Convert the ID to an integer
    id = String.to_integer(id)

    # Fetch the question from the database
    question = Questions.get_question!(id)

    case Questions.delete_question(question) do
      {:ok, _deleted_question} ->
        # Pass the whole question struct to the stream_delete
        {:noreply, stream(socket, :questions, Questions.list_questions_for_course(socket.assigns.course_page_id), reset: true)}

      {:error, _changeset} ->
        # If deletion fails, show an error flash
        {:noreply, put_flash(socket, :error, "Failed to delete the question.")}
    end
  end

  def handle_event("toggle_form", %{"form" => form}, socket) do
    {:noreply,
      socket
      |> assign(show_form: form)
      |> stream(:questions, Questions.list_questions_for_course(socket.assigns.course_page_id), reset: true)}
  end

  def handle_event("typeChange", %{"question_type" => question_type}, socket) do
    {:noreply,
    socket
    |> assign(question_type: question_type)
    |> stream(:questions, Questions.list_questions_for_course(socket.assigns.course_page_id), reset: true)}
  end
end
