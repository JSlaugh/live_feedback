defmodule LiveFeedback.Participation do

  # FUNCTIONS GO ON THIS PAGE

  #@behaviour Bodyguard.Policy

  import Ecto.Query, warn: false

  alias LiveFeedback.Queues.Queue
  alias LiveFeedback.Repo
  alias LiveFeedback.Participation.ParticipationRequest

  def list_all_available_participation_dates(course_page_id) do
    query =
      from q in Queue,
        select: %{
          name: q.name,
          presented_date: q.presented_date,
        },
        where: q.course_page_id == ^course_page_id,
        order_by: [asc: q.presented_date]

    Repo.all(query)
  end

  def add_participation_request(attrs) do
    %ParticipationRequest{}
    |> ParticipationRequest.changeset(attrs)
    |> Repo.insert()
  end
end
