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
     |> assign(:show_form, false)
     |> assign(:question_type, "QA")
     |> stream(:questions, questions)
    }
  end

  @impl true
  def handle_event("add_question", %{"question_content" => content, "question_type" => type, "option_a" => option_a, "option_b" => option_b, "option_c" => option_c, "option_d" => option_d, "correct_a" => correct_a, "correct_b" => correct_b, "correct_c" => correct_c, "correct_d" => correct_d}, socket) do
    options = %{
      "option_a" => {option_a || "", correct_a == "true"},
      "option_b" => {option_b || "", correct_b == "true"},
      "option_c" => {option_c || "", correct_c == "true"},
      "option_d" => {option_d || "", correct_d == "true"}
    }

    attrs = %{
      "course_page_id" => socket.assigns.course_page_id,
      "question_content" => content,
      "question_type" => type,
      "options" => options,
      "display_order" => Questions.get_max_display_order(socket.assigns.course_page_id)
    }

    case Questions.add_question(attrs) do
      {:ok, question} ->
        # Add the new question to the stream
        {:noreply,
         socket
         |> assign(show_form: !socket.assigns.show_form)
         |> put_flash(:info, "Question added successfully.")
         |> stream_insert(:questions, question)}  # Stream the newly added question

      {:error, changeset} ->
        {:noreply,
        socket
        |> put_flash(:error, "Failed to add question.")
      }
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


  @impl true
  def handle_event("toggle_form", _params, socket) do
    {:noreply,
     socket
     |> assign(show_form: !socket.assigns.show_form)
     |> assign(:question_type, "QA")}
  end

  def handle_event("typeChange", %{"question_type" => question_type}, socket) do
    {:noreply, assign(socket, question_type: question_type)}
  end
end
