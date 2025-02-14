defmodule LiveFeedback.Selection do

  @behaviour Bodyguard.Policy

  import Ecto.Query, warn: false
  alias LiveFeedback.Repo

  alias LiveFeedback.Courses.CoursePage
  alias LiveFeedback.Questions.QuestionOccurance
  alias LiveFeedback.Questions.QuestionOptionsOccurance
  alias LiveFeedback.Questions.QuestionOptionsResponse
  alias LiveFeedback.Accounts.UserProfile


  def get_course_name(course_page_id) do
    from(course in CoursePage,
      where: course.id == ^course_page_id,
      select: course.title)
      |> Repo.one()
  end
  def get_question_from_queue(queue_id, question_num) do
    from(question in QuestionOccurance,
      where: question.queue_id == ^queue_id and question.display_order == ^question_num,
      preload: [:question_options_occurances]
    )
    |> Repo.one()
  end

  def add_response(attrs) do
      %QuestionOptionsResponse{}
      |> QuestionOptionsResponse.changeset(attrs)
      |> Repo.insert()
  end

  def get_profile_id(user_id, course_page_id) do
    from(profile in UserProfile,
      where: profile.user_id == ^user_id and profile.course_page_id == ^course_page_id
    )
    |> Repo.one()
  end

  def get_profile_responses(profile_id, question_id) do
    from(option in QuestionOptionsOccurance,
      join: response in assoc(option, :question_options_responses),
      where: option.question_occurance_id == ^question_id and response.user_profile_id == ^profile_id
    )
    |> Repo.all()
  end

end
