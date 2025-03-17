# QA Component Integration Guide

**Note: To view this file like a md file right-click on this file and select "Open Preview"**

This is a description of the different parts that you will need to have integrated into the parent Liveview page in order for the QA component to work. 

### LiveView Component Example

This is what the component should look like inside or your heex

```heex
      <.live_component
        module={LiveFeedbackWeb.QaComponent}
        id="example-activity"
        page_admin={@page_admin}
        course_page={@course_page}
        sort_by={@sort_by}
        streams={@streams}
        anonymous_id={@anonymous_id}
        live_action={@live_action}
        message={@message}
        page_title={@page_title}
        parent_pid={self()}
      />
```

Many of these different attributes will throw and error if not passed (some will not) but you need to be sure to add the "parent_pid={self()}" attribute otherwise none of the functionallity will work. 

Some of these different attributes are generated or created in a way that is specific to that page for references please look at another page where this component is used to see how they did it and if you want to do it the same way. 

### Copy and Paste Required handle_info Functions

```elixir
  # Handle Info for Sorting Messages -----------------------------------------------
  @impl true
  def handle_info({:sorted_messages, sort_by_atom, sorted_messages}, socket) do
    {:noreply,
    socket
    |> assign(:sort_by, sort_by_atom)  # Update the sort_by atom in the socket
    |> stream(:messages, sorted_messages, reset: true)}  # Stream the sorted messages
  end

  # Handle Info for Deleteing all Messages ------------------------------------------
  def handle_info({:deleted_all_messages, course_page_id}, socket) do
    {:noreply, stream(socket, :messages, [], reset: true)}
  end

  # Handle Info for Deleting a Message From Focus Mode ------------------------------
  def handle_info({:deleted_message_modal, message}, socket) do
    {:noreply, socket
    |> assign(:live_action, :index)
    |> stream_delete(:messages, message)}
  end

  def handle_info({:deleted_message, message}, socket) do # This is needed for the pubsub in messages.ex
   {:noreply, socket}
  end

  # Handle Info for Focusing on a Message -------------------------------------------
  def handle_info({:selected_message_focus, message}, socket) do
    {:noreply,
    socket
    |> assign(:live_action, :focus)
    |> assign(:message, message)}
  end

  # Handle Info for Liking a message -----------------------------------------------
  def handle_info({:selected_message_liked, update_message}, socket) do
    {:noreply, stream_insert(socket, :messages, update_message)}
  end

  def handle_info({:updated_message, updated_message}, socket) do # This is needed for the pubsub in messages.ex
    {:noreply, socket}
  end

  # Handle Info for Editing a Message From the Message Component -------------------
  def handle_info({:selected_message_edit, message}, socket) do
    {:noreply, assign(socket, live_action: :edit, message: message)}
  end

  # Handle Info for Deleting a Message From the Message Component ------------------
  def handle_info({:selected_message_delete, message}, socket) do
    {:noreply, stream_delete(socket, :messages, message)}
  end
```
All of these functions should be set up to just be copy/paste into the index.ex file of your LiveView page. 

### Error handling with handle_info

If you are running into issues with a message being sent either through Pubsub, handle_event, or handle_info and there not being the proper handle_info to receive it just add this function and it will tell you the name of the message being sent that is not being handled properly. 

```elixir
  # Handle Info for testing purposes only ------------------------------------------
  def handle_info(msg, socket) do
    IO.inspect(msg, label: "Unhandled message")
    {:noreply, socket}
  end
```