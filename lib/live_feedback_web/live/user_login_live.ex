defmodule LiveFeedbackWeb.UserLoginLive do
  use LiveFeedbackWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm lg:max-w-lg">
      <.header class="text-center">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-logo_red hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />
        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Reset your password?
          </.link>
        </:actions>

        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>

      <.modal
        :if={@live_action == :reset_password_prompt}
        id="reset-password-modal"
        show
        on_cancel={JS.push("close_modal")}
      >
        <div class="">
          <h2 class="text-lg font-bold">Reset Your Password</h2>

          <p class="mt-2">
            We've updated our password encryption system. As a result, all users must reset their passwords to continue accessing their accounts. If you haven't reset your password since <span class="font-bold">March 17th</span>, please do so now to keep using your account.
          </p>

          <div class="mt-4 flex justify-end">
            <.link
              navigate={~p"/users/reset_password"}
              class="px-4 py-2 text-white bg-logo_red rounded"
            >
              Reset Password
            </.link>
          </div>
        </div>
      </.modal>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, live_action: :reset_password_prompt),
     temporary_assigns: [form: form]}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, live_action: nil)}
  end
end
