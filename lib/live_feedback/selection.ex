defmodule LiveFeedback.Selection do

  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias LiveFeedback.Questions.Question
  alias LiveFeedback.Repo

  alias LiveFeedback.Courses.CoursePage
  alias LiveFeedback.Questions.QuestionOccurrence
  alias LiveFeedback.Questions.QuestionOptionsOccurrence
  alias LiveFeedback.Questions.QuestionOptionsResponse
  alias LiveFeedback.Accounts.UserProfile


  def get_course_name(course_page_id) do
    from(course in CoursePage,
      where: course.id == ^course_page_id,
      select: course.title)
      |> Repo.one()
  end
  def get_question_from_queue(queue_id, question_num) do
    from(question in QuestionOccurrence,
      where: question.queue_id == ^queue_id and question.display_order == ^question_num,
      preload: [:question_options_occurrences]
    )
    |> Repo.one()
  end

  def get_profile_id(user_id, course_page_id) do
    from(profile in UserProfile,
      where: profile.user_id == ^user_id and profile.course_page_id == ^course_page_id
    )
    |> Repo.one()
  end

  def get_profile_responses(profile_id, question_id) do
    from(response in QuestionOptionsResponse,
    join: option in QuestionOptionsOccurrence,
    on: response.question_options_occurrence_id == option.id,
      where: option.question_occurrence_id == ^question_id and response.anonymous_id == ^profile_id
    )
    |> Repo.all()
  end

  #get all responses for a question
  def get_question_responses(question_id) do
    from(response in QuestionOptionsResponse,
    join: option in QuestionOptionsOccurrence,
    on: response.question_options_occurrence_id == option.id,
      where: option.question_occurrence_id == ^question_id)
    |> Repo.all()
  end

  def add_response(attrs) do
    %QuestionOptionsResponse{}
    |> QuestionOptionsResponse.changeset(attrs)
    |> Repo.insert()
  end

  #deletes specific response
  def delete_response_for_profile_for_question(profile_id, option_id) do
    from(response in QuestionOptionsResponse,
    where: response.anonymous_id == ^profile_id and response.question_options_occurrence_id == ^option_id)
    |> Repo.delete_all()
  end

  #not currently being used
  def delete_all_responses_for_profile_for_question(profile_id, question_id) do
    from(response in QuestionOptionsResponse,
    join: option in QuestionOptionsOccurrence,
    on: response.question_options_occurrence_id == option.id,
    where: response.anonymous_id == ^profile_id and
           option.question_occurrence_id == ^question_id)
  |> Repo.delete_all()
  end

  #updates specific response
  def update_response_for_profile_for_question(profile_id, question_id, attrs) do
    query =
      from(response in QuestionOptionsResponse,
        join: option in QuestionOptionsOccurrence,
        on: response.question_options_occurrence_id == option.id,
        where: response.anonymous_id == ^profile_id and
               option.question_occurrence_id == ^question_id
      )

    case Repo.one(query) do
      nil -> {:error, "Response not found"}
      response ->
        response
        |> QuestionOptionsResponse.changeset(attrs)
        |> Repo.update()
    end
  end
end
