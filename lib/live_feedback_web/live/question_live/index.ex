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
      "display_order" => Questions.get_max_display_order(socket.assigns.course_page_id) + 1
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
          Questions.add_option(option_attrs)
        end

        # Return the updated socket with the new question streamed
        {:noreply,
         socket
         |> assign(show_form: "none")
         |> put_flash(:info, "Question added successfully.")}  # Stream the newly added question

      {:error, changeset} ->
        # In case of error, return the socket with an error message
        {:noreply,
         socket
         |> put_flash(:error, "Failed to add question.")}
    end
  end

  def handle_info({:new_question, question}, socket) do
    # Check if the course page ID matches
    if question.course_page_id == socket.assigns.course_page.id do
      # Retrieve the sorted list of questions for this course page
      sorted_questions =
        Questions.get_questions_for_course_page_id(
          socket.assigns.course_page.id,
          socket.assigns.sort_by
        )

      # Stream the updated list of questions
      {:noreply, stream(socket, :questions, sorted_questions, reset: true)}
    else
      {:noreply, socket}
    end
  end


  @impl true
  def handle_event("edit_question", params, socket) do
    question = Questions.get_question!(Map.get(params, "question_id"))
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
    case Questions.update_question(question, attrs) do
      {:ok, question} ->
        existing_options = Questions.list_options_for_question(question.id)

        # Define the form options as a list of maps
        form_options = [
          %{option_content: option_A, is_correct: answer_A},
          %{option_content: option_B, is_correct: answer_B},
          %{option_content: option_C, is_correct: answer_C},
          %{option_content: option_D, is_correct: answer_D}
        ]

        for i <- 0..3 do
          # Get the options at index i, or default to nil values if not found
          existing_option = Enum.at(existing_options, i, %{option_content: nil, is_correct: nil})
          form_option = Enum.at(form_options, i, %{option_content: nil, is_correct: nil})

          # Extract option_content and is_correct into separate variables
          existing_option_content = Map.get(existing_option, :option_content)
          existing_is_correct = Map.get(existing_option, :is_correct)

          form_option_content = Map.get(form_option, :option_content)
          form_is_correct = Map.get(form_option, :is_correct)

          #add
          if (form_option_content != nil && existing_option_content == nil) do
            option_attrs = %{
              "option_order" => i + 1,
              "option_content" => form_option_content,
              "is_correct" => form_is_correct,
              "question_id" => question.id
            }
            Questions.add_option(option_attrs)
          end
          #update
          if form_option_content != nil and existing_option_content != nil do
            if form_option_content != existing_option_content or form_is_correct != existing_is_correct do
              option_attrs = %{
                "option_order" => i + 1,
                "option_content" => form_option_content,
                "is_correct" => form_is_correct,
                "question_id" => question.id
              }
              # Update the option in the question
              Questions.update_option(existing_option.id, option_attrs)
            end
          end
          #delete
          if (form_option_content == nil && existing_option_content != nil) do
            Questions.delete_option(existing_option.id)
          end

          IO.puts("Iteration #{i}:")
          IO.puts("Existing Option - Content: #{existing_option_content}, Is Correct: #{existing_is_correct}")
          IO.puts("Form Option - Content: #{form_option_content}, Is Correct: #{form_is_correct}")
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

  def handle_event("move_question", %{"id" => id, "direction" => direction}, socket) do
    case Questions.move_question(id, direction) do
      {:ok, {q1, q2}} ->
        {:noreply,
         load_questions(socket)}

      {:error, _} ->
        {:noreply, socket} # No-op if already at the top/bottom
    end
  end

end
