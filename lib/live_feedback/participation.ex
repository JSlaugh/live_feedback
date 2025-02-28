defmodule LiveFeedback.Participation do

  # FUNCTIONS GO ON THIS PAGE

  #@behaviour Bodyguard.Policy

  import Ecto.Query, warn: false

  alias LiveFeedback.Questions.{Queue, QueueOccurrence}
  alias LiveFeedback.Repo
  alias LiveFeedback.Participation.ParticipationRequest

  def list_all_available_participation_dates(course_page_id) do
    query =
      from qo in QueueOccurrence,
      join: qoo in Queue, on: qo.queue_id == qoo.id,
        distinct: qo.presented_date,
        where: qoo.course_page_id == ^course_page_id,
        order_by: [asc: qo.presented_date]

    Repo.all(query)
  end

  def add_participation_request(attrs) do
    %ParticipationRequest{}
    |> ParticipationRequest.changeset(attrs)
    |> Repo.insert()
  end
end
