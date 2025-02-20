defmodule LiveFeedbackWeb.QuestionLive.Index do
  use LiveFeedbackWeb, :live_view

  alias LiveFeedback.Questions

  @impl true
  def mount(%{"queue" => queue_id}, _session, socket) do
    #if connected?(socket), do: Questions.subscribe(queue_id)
    queue = Questions.get_queue!(queue_id)
    course_page_id = queue.course_page_id
    {:ok,
     socket
     |> assign(:course_page_id, course_page_id)
     |> assign(:queue_id, queue_id)
     |> assign(:course_name, Questions.get_course_name(course_page_id))
     |> assign(:show_form, nil)
     |> assign(:question_type, "QA")
     |> assign(:show_add_form, false)
     |> assign(:confirm_delete, false)
     |> assign(:delete_id, nil)
     |> assign(:max_question_num, Questions.get_max_display_order(queue_id))
     |> stream(:questions, Questions.list_questions_for_queue(queue_id))
    }
  end

  def handle_event("see_stream", _params, socket) do
    # Inspect the stream data
    #IO.inspect(Map.get(socket.assigns.streams, :ac), label: "My Stream Data")

    {:noreply, socket}
  end

  #Add question
  @impl true
  def handle_event("add_question", params, socket) do
    IO.inspect(params)
    #extract Parameters
    content = Map.get(params, "question_content", "")
    type = Map.get(params, "question_type", "")
    is_required = case Map.get(params, "is_required", false) do
      "on" -> true
      _ -> false
    end
    #if option a/b account for t/f questions
    #only grab the param if it exist, if not set to "" so the option can be ignored
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

    #get correct answer. answer for radio buttons, correct_A-D for check box
    answer = Map.get(params, "answer", "")
    correct_A = Map.get(params, "correct_A", "") #change to select
    correct_B = Map.get(params, "correct_B", "")
    correct_C = Map.get(params, "correct_C", "")
    correct_D = Map.get(params, "correct_D", "")

    #look for both radio button/check box responses and set variable to be passed to the option in the DB
    answer_A = if answer == "A" || correct_A == "A", do: true, else: false
    answer_B = if answer == "B" || correct_B == "B", do: true, else: false
    answer_C = if answer == "C" || correct_C == "C", do: true, else: false
    answer_D = if answer == "D" || correct_D == "D", do: true, else: false

    # Prepare the attributes for the new question
    attrs = %{
      "queue_id" => socket.assigns.queue_id,
      "question_content" => content,
      "question_type" => type,
      "display_order" => Questions.get_max_display_order(socket.assigns.queue_id) + 1,
      "is_archived" => false,
      "is_required" => is_required
    }

    # Attempt to add the question
    case Questions.add_question(attrs) do
      {:ok, question} ->
        # Loop through each option, create the cast compatible object, and add the question
        for {option, correct, order} <- [
              {option_A, answer_A, "A"},
              {option_B, answer_B, "B"},
              {option_C, answer_C, "C"},
              {option_D, answer_D, "D"}
            ], option != "" do
          option_attrs = %{
            "option_order" => order,
            "option_content" => option,
            "is_correct" => correct,
            "question_occurrence_id" => question.id  # Associate with the newly added question
          }
          # Add the option to the question
          Questions.add_option(option_attrs)
        end
        #get the full question + options packaged together
        question = Questions.get_question!(question.id)

        {:noreply,
         socket
         |> assign(show_add_form: false) #close the form
         |> assign(:max_question_num, socket.assigns.max_question_num + 1) #update the max question number since new question was added
         |> stream(:questions, Questions.list_questions_for_queue(socket.assigns.queue_id), reset: false) #update the entire stream so that the previous question also update their arrows for movement
         |> put_flash(:info, "Question added successfully.")
         }

      {:error, changeset} ->
        # In case of error, return the socket with an error message
        {:noreply,
         socket
         |> put_flash(:error, "Failed to add question.")}
    end
  end

  #edit question
  @impl true
  def handle_event("edit_question", params, socket) do
    #get parameters
    question = Questions.get_question!(Map.get(params, "question_id"))
    content = Map.get(params, "question_content", "")
    type = Map.get(params, "question_type", "")
    is_required = case Map.get(params, "is_required", false) do
      "on" -> true
      _ -> false
    end


    option_A = if type == "true_false", do: "true", else: Map.get(params, "option_A", "")
    option_B = if type == "true_false", do: "false", else: Map.get(params, "option_B", "")

    option_C = if type == "true_false", do: "", else: Map.get(params, "option_C", "")
    option_D = if type == "true_false", do: "", else: Map.get(params, "option_D", "")

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
      "question_type" => type,
      "is_required" => is_required
    }

    # Attempt to update the question
    case Questions.update_question(question, attrs) do
      {:ok, question} ->
        if type in ["free_response", "QA"] do
          Questions.delete_all_options_for_question(question.id)
        else
          existing_options = Questions.list_options_for_question(question.id)

          # Define the form options as a list of maps
          form_options = [
            %{option_content: option_A, is_correct: answer_A},
            %{option_content: option_B, is_correct: answer_B},
            %{option_content: option_C, is_correct: answer_C},
            %{option_content: option_D, is_correct: answer_D}
          ]
          IO.inspect(form_options)
          for i <- 0..3 do
            option_letters = ["A", "B", "C", "D"]
            # Get the options at index i, or default to nil values if not found
            existing_option = Enum.at(existing_options, i, %{option_content: nil, is_correct: nil})
            form_option = Enum.at(form_options, i, %{option_content: nil, is_correct: nil})

            # Extract option_content and is_correct into separate variables
            existing_option_content = Map.get(existing_option, :option_content)
            existing_is_correct = Map.get(existing_option, :is_correct)

            form_option_content = Map.get(form_option, :option_content)
            form_is_correct = Map.get(form_option, :is_correct)
            IO.inspect(form_option)

            #add
            if (form_option_content != nil && existing_option_content == nil) do
              IO.inspect("add")
              option_attrs = %{
                "option_order" => Enum.at(option_letters, i),
                "option_content" => form_option_content,
                "is_correct" => form_is_correct,
                "question_occurrence_id" => question.id
              }
              Questions.add_option(option_attrs)
            end
            #update
            if form_option_content != nil and existing_option_content != nil do
              IO.inspect("edit")
              option_attrs = %{
                "option_content" => form_option_content,
                "is_correct" => form_is_correct
              }
              # Update the option in the question
              Questions.update_option(existing_option.id, option_attrs)
            end
            #delete
            if (form_option_content == "" && existing_option_content != nil) do
              IO.inspect("delete")
              Questions.delete_option(existing_option.id)
            end
          end
        end
        question = Questions.get_question!(question.id)
        {:noreply,
        socket
        |> assign(show_form: "none")
        |> put_flash(:info, "Question updated successfully.")
        |> stream_insert(:questions, question)
      }

      {:error, changeset} ->
        # In case of error, return the socket with an error message
        {:noreply,
        socket
        |> put_flash(:error, "Failed to update question.")}
    end
  end

  @impl true
  def handle_event("confirm_delete", %{"id" => id}, socket) do
    {:noreply,
    socket
    |> assign(:confirm_delete, true)
    |> assign(:delete_id, id)
  }
  end

  @impl true
  def handle_event("delete_question", %{"id" => id}, socket) do
    # Convert the ID to an integer
    id = String.to_integer(id)

    # Fetch the question from the database
    question = Questions.get_question!(id)

    case Questions.delete_question(question) do
      {:ok, deleted_question} ->
        {:noreply,
        socket
        |> assign(:max_question_num, Questions.get_max_display_order(socket.assigns.queue_id))
        |> assign(:confirm_delete, false)
        |> put_flash(:info, "Successfully deleted the question.")
        |> stream(:questions, Questions.list_questions_for_queue(socket.assigns.queue_id), reset: true)}
      {:error, _changeset} ->
        # If deletion fails, show an error flash
        {:noreply, put_flash(socket, :error, "Failed to delete the question.")}
    end
  end

  def handle_event("archive_question",%{"id" => id}, socket) do
    question = Questions.get_question!(id)
    attrs = %{
      "is_archived" => true
    }
    case Questions.update_question(question, attrs) do
      {:ok, question} ->
        {:noreply,
          socket
          |> assign(:confirm_delete, false)
          |> put_flash(:info, "Question archived successfully.")
          |> stream(:questions, Questions.list_questions_for_queue(socket.assigns.queue_id), reset: false)
        }
      {:error, changeset} ->
          {:noreply,
          socket
          |> put_flash(:error, "Failed to archive question.")}
    end
  end

  def handle_event("toggle_new_form", _params, socket) do
    {:noreply,
      socket
      |> assign(show_add_form: !socket.assigns.show_add_form)
      |> assign(:show_form, "none")
      |> assign(:question_type, "QA")
      |> stream(:questions, Questions.list_questions_for_queue(socket.assigns.queue_id), reset: false)}
  end

  def handle_event("typeChange", %{"question_type" => question_type}, socket) do
    {:noreply,
    socket
    |> assign(question_type: question_type)
    |> stream(:questions, Questions.list_questions_for_queue(socket.assigns.queue_id), reset: false)}
  end


  def handle_event("move_question", %{"id" => id, "direction" => direction}, socket) do
    case Questions.move_question(id, direction) do
      {:ok, {q1, q2}} ->
        {:noreply,
         socket
         |> stream(:questions, Questions.list_questions_for_queue(socket.assigns.queue_id), reset: true)}

      {:error, _} ->
        {:noreply, socket} # No-op if already at the top/bottom
    end
  end

  @impl true
  def handle_info({:toggle_form, question_id}, socket) do
    question = Questions.get_question!(question_id)
    #IO.inspect(socket.assigns.streams, label: "My Stream Data")
    {:noreply,
    socket
    |> assign(:show_form, (if question_id != socket.assigns.show_form, do: question_id, else: nil))
    |> assign(:show_add_form, false)
    |> assign(:question_type, question.question_type)
    |> stream(:questions, Questions.list_questions_for_queue(socket.assigns.queue_id), reset: false)}
  end


end
