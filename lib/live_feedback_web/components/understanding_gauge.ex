defmodule LiveFeedbackWeb.GaugeChartComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="relative mx-auto max-w-md">
      <div class="bg-gray-50 rounded-lg shadow-md p-4 mb-4">
        <div class="h-64 w-64 mx-auto">
          <canvas id={"pieChart-#{@id}"}
                  phx-hook="PieChart"
                  phx-update="ignore"
                  data-chart-data={Jason.encode!(%{
                    labels: ["I'm Lost", "Getting it", "Got it!"],
                    datasets: [
                      %{
                        data: @chart_data,
                        backgroundColor: [
                          "rgba(239, 68, 68, 0.8)",   # Tailwind red-500
                          "rgba(245, 158, 11, 0.8)",  # Tailwind yellow-500
                          "rgba(34, 197, 94, 0.8)"    # Tailwind green-500
                        ],
                        borderColor: [
                          "rgba(239, 68, 68, 1)",     # Tailwind red-500
                          "rgba(245, 158, 11, 1)",    # Tailwind yellow-500
                          "rgba(34, 197, 94, 1)"      # Tailwind green-500
                        ],
                        borderWidth: 1
                      }
                    ]
                  })}>
          </canvas>
        </div>
        <div class="mt-4 flex justify-center">
          <button phx-click="clear_chart" phx-target={@myself} class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-md transition-colors flex items-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
            Clear Chart Data
          </button>
        </div>
      </div>
      <script>
        const chartSetup = (function() {
          document.addEventListener("DOMContentLoaded", function() {
            const chartHook = {
              chartInstance: null,

              mounted() {
                const ctx = this.el.getContext('2d');
                const chartData = JSON.parse(this.el.dataset.chartData);

                this.chartInstance = new Chart(ctx, {
                  type: 'pie',
                  data: chartData,
                  options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: {
                      duration: 800,
                      easing: 'easeOutQuart'
                    },
                    plugins: {
                      legend: {
                        position: 'right',
                        align: 'center',
                        labels: {
                          boxWidth: 15,
                          padding: 10,
                          font: {
                            size: 12
                          }
                        }
                      }
                    }
                  }
                });
              },

              updated() {
                try {
                  const newChartData = JSON.parse(this.el.dataset.chartData);

                  // Update data while maintaining animation
                  if (this.chartInstance) {
                    this.chartInstance.data.datasets[0].data = newChartData.datasets[0].data;
                    this.chartInstance.update();
                  }
                } catch (error) {
                  console.error("Error updating chart:", error);
                }
              },

              destroyed() {
                if (this.chartInstance) {
                  this.chartInstance.destroy();
                }
              }
            };

            // Register the hook if its not already registered
            if (window.Hooks && !window.Hooks.PieChart) {
              window.Hooks.PieChart = chartHook;
            }
          });
        })();
      </script>
    </div>
    """
  end

  def handle_event("clear_chart", _params, socket) do
    topic = "#{socket.assigns.queue_id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:clear_chart})
    send(self(), {:clear_chart_data})
    {:noreply, socket}
  end
end

defmodule LiveFeedbackWeb.GaugeFormComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <form phx-change="gauge_understanding" phx-target={@myself} class="max-w-md mx-auto my-4 p-4 bg-gray-50 rounded-lg shadow-md">
      <h2 class="text-xl font-bold text-center mb-4 text-gray-800">Understanding Gauge</h2>

      <div class="flex flex-col space-y-3">
        <div class="w-full">
          <label class={[
            "flex items-center p-3 rounded-md cursor-pointer transition-all duration-300 ease-in-out",
            @user_understanding == "got_it" && "bg-green-50 border-2 border-green-500",
            @user_understanding != "got_it" && "border-l-4 border-green-500 hover:bg-gray-100"
          ]}>
            <input type="radio" name="understanding_gauge" value="got_it"
                  class="h-5 w-5 mr-3 text-green-500 cursor-pointer"
                  checked={@user_understanding == "got_it"} />
            <span class="font-medium">Got It! 😄</span>
          </label>
        </div>
        <div class="w-full">
          <label class={[
            "flex items-center p-3 rounded-md cursor-pointer transition-all duration-300 ease-in-out",
            @user_understanding == "getting_it" && "bg-yellow-50 border-2 border-yellow-500",
            @user_understanding != "getting_it" && "border-l-4 border-yellow-500 hover:bg-gray-100"
          ]}>
            <input type="radio" name="understanding_gauge" value="getting_it"
                  class="h-5 w-5 mr-3 text-yellow-500 cursor-pointer"
                  checked={@user_understanding == "getting_it"} />
            <span class="font-medium">Getting It 🤔</span>
          </label>
        </div>
        <div class="w-full">
          <label class={[
            "flex items-center p-3 rounded-md cursor-pointer transition-all duration-300 ease-in-out",
            @user_understanding == "lost" && "bg-red-50 border-2 border-red-500",
            @user_understanding != "lost" && "border-l-4 border-red-500 hover:bg-gray-100"
          ]}>
            <input type="radio" name="understanding_gauge" value="lost"
                  class="h-5 w-5 mr-3 text-red-500 cursor-pointer"
                  checked={@user_understanding == "lost"} />
            <span class="font-medium">Im Lost 😕</span>
          </label>
        </div>
      </div>
    </form>
    """
  end

  def handle_event("gauge_understanding", %{"understanding_gauge" => choice}, socket) do
    IO.inspect(choice, label: "User's understanding choice")
    got_it =
      cond do
        socket.assigns.user_understanding == "got_it" and choice != "got_it" -> -1
        socket.assigns.user_understanding != "got_it" and choice == "got_it" -> 1
        true -> 0
      end

    getting_it =
      cond do
        socket.assigns.user_understanding == "getting_it" and choice != "getting_it" -> -1
        socket.assigns.user_understanding != "getting_it" and choice == "getting_it" -> 1
        true -> 0
      end

    lost =
      cond do
        socket.assigns.user_understanding == "lost" and choice != "lost" -> -1
        socket.assigns.user_understanding != "lost" and choice == "lost" -> 1
        true -> 0
      end

    gauge = [lost, getting_it, got_it]

    topic = "Host:#{socket.assigns.course_page.id}"
    Phoenix.PubSub.broadcast(LiveFeedback.PubSub, topic, {:update_gauge, gauge})
    send(self(), {:update_user_understanding, choice})
    {:noreply, socket}
  end
end
