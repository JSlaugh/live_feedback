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
     |> assign(:show_form, nil)
     |> assign(:question_type, "QA")
     |> stream(:questions, questions)
    }

  end

  defp load_questions(socket) do
    questions = Questions.list_questions_for_course(socket.assigns.course_page_id)
    stream(socket, :questions, questions, reset: false)
  end

  @impl true
  def handle_event("add_question", params, socket) do
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
         |> stream(:questions, Questions.list_questions_for_course(socket.assigns.course_page_id))}  # Stream the newly added question

      {:error, changeset} ->
        # In case of error, return the socket with an error message
        {:noreply,
         socket
         |> put_flash(:error, "Failed to add question.")}
    end
  end

  @impl true
def handle_event("edit_question", params, socket) do
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
  correct_A = Map.get(params, "correct_A", "")
  correct_B = Map.get(params, "correct_B", "")
  correct_C = Map.get(params, "correct_C", "")
  correct_D = Map.get(params, "correct_D", "")

  answer_A = if answer == "A" || correct_A == "A", do: true, else: false
  answer_B = if answer == "B" || correct_B == "B", do: true, else: false
  answer_C = if answer == "C" || correct_C == "C", do: true, else: false
  answer_D = if answer == "D" || correct_D == "D", do: true, else: false

  # Prepare the attributes for the updated question
  attrs = %{
    "question_content" => content,
    "question_type" => type
  }

  # Attempt to update the question
  case Questions.update_question(socket.assigns.question.id, attrs) do
    {:ok, question} ->
      # Loop through each option, add/update or delete if necessary
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
          "question_id" => question.id
        }

        # Update or add the option
        case Questions.update_or_add_option_to_question(option_attrs) do
          {:ok, _option} -> :ok
          {:error, _changeset} -> :ok
        end
      end

      # Delete any options that are no longer provided (if there are fewer options than before)
      current_option_orders = [1, 2, 3, 4]
      existing_option_orders = Enum.map(question.options, & &1.option_order)

      options_to_delete = Enum.filter(current_option_orders, fn order ->
        not Enum.member?(existing_option_orders, order)
      end)

      for order <- options_to_delete do
        Questions.delete_option_for_question(question.id, order)
      end

      # Return the updated socket with the edited question streamed
      {:noreply,
       socket
       |> assign(show_form: "none")
       |> put_flash(:info, "Question updated successfully.")
       |> stream(:questions, Questions.list_questions_for_course(socket.assigns.course_page_id))}  # Stream the updated question

    {:error, changeset} ->
      # In case of error, return the socket with an error message
      {:noreply,
       socket
       |> put_flash(:error, "Failed to update question.")}
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
        {:noreply, load_questions(socket)}

      {:error, _changeset} ->
        # If deletion fails, show an error flash
        {:noreply, put_flash(socket, :error, "Failed to delete the question.")}
    end
  end

  def handle_event("toggle_form", %{"form" => form}, socket) do
    new_show_form =
      if form== "add" && socket.assigns.show_form == "add" do
        "none"  # Close the form if it's already open
      else
        form  # Open the form if it's closed
      end

    question_type =
      case Integer.parse(form) do
        {form_id, ""} ->
          question = Questions.get_question!(form_id)
          question.question_type  # Get the question type from the fetched question

        _ ->
          "QA"  # Default to "QA" if parsing fails
      end

      IO.inspect(new_show_form, label: "New show_form value")
    {:noreply,
     socket
     |> assign(show_form: new_show_form)
     |> assign(question_type: question_type)
     |> load_questions()}
  end


  def handle_event("typeChange", %{"question_type" => question_type}, socket) do
    {:noreply,
    socket
    |> assign(question_type: question_type)
    |> load_questions()}
  end
end
