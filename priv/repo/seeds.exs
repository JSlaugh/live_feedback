# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LiveFeedback.Repo.insert!(%LiveFeedback.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LiveFeedback.Repo
alias LiveFeedback.Questions.{QuestionTemplate, QuestionOptionsTemplate, QuestionOptionsResponse, Queue, QuestionSet, QuestionOccurance}
alias LiveFeedback.Courses.CoursePage
alias LiveFeedback.Accounts.User
alias LiveFeedback.Accounts.UserProfile
# alias LiveFeedback.Participation.{ParticipationRequest, ParticipationSummary}

now = DateTime.utc_now() |> DateTime.truncate(:second)

###########################################################################
################                     Users                 ################
###########################################################################

# Insert a User for Mason
_user_mason = Repo.insert!(%User{
  email: "mdperry5th@gmail.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "admin",
  is_admin: true
},
  on_conflict: :nothing
)

# Insert a User for Maddy
_user_maddy = Repo.insert!(%User{
  email: "madisonhoyt19@gmail.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "admin",
  is_admin: true
},
  on_conflict: :nothing
)

# Insert a User for Joe
_user_joe = Repo.insert!(%User{
  email: "j@slaugh.net",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "admin",
  is_admin: true
},
  on_conflict: :nothing
)

# Insert a User for Mark
_user_mark = Repo.insert!(%User{
  email: "markbriggs321@gmail.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "admin",
  is_admin: true
},
  on_conflict: :nothing
)

# Insert a User for Henry
_user_henry = Repo.insert!(%User{
  email: "henrydmatsen@gmail.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "admin",
  is_admin: true
},
  on_conflict: :nothing
)

###########################################################################
################                Course Pages               ################
###########################################################################

# Insert Course Pages for Mason
_course_mason = Repo.insert!(%CoursePage{
  title: "SWELL 108",
  description: "Bowling for Beginners",
  slug: "swell108",
  user_id: 1,
  inserted_at: now,
  updated_at: now,
},
  on_conflict: :nothing
)

_course_user1_2 = Repo.insert!(%CoursePage{
  title: "MATH 201",
  description: "Calculus I",
  slug: "math201",
  user_id: 1,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert Course Pages for Maddy
_course_user2_1 = Repo.insert!(%CoursePage{
  title: "ENG 150",
  description: "English Composition",
  slug: "eng150",
  user_id: 2,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_course_user2_2 = Repo.insert!(%CoursePage{
  title: "BIO 202",
  description: "Human Anatomy",
  slug: "bio202",
  user_id: 2,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert Course Pages for Joe
_course_user3_1 = Repo.insert!(%CoursePage{
  title: "HIST 210",
  description: "World History",
  slug: "hist210",
  user_id: 3,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_course_user3_2 = Repo.insert!(%CoursePage{
  title: "PHYS 101",
  description: "Physics Fundamentals",
  slug: "phys101",
  user_id: 3,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert Course Pages for Mark
_course_user4_1 = Repo.insert!(%CoursePage{
  title: "CHEM 105",
  description: "General Chemistry",
  slug: "chem105",
  user_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_course_user4_2 = Repo.insert!(%CoursePage{
  title: "PSYC 200",
  description: "Introduction to Psychology",
  slug: "psyc200",
  user_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert Course Pages for Henry
_course_user5_1 = Repo.insert!(%CoursePage{
  title: "ECON 220",
  description: "Microeconomics",
  slug: "econ220",
  user_id: 5,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_course_user5_2 = Repo.insert!(%CoursePage{
  title: "ART 130",
  description: "Introduction to Painting",
  slug: "art130",
  user_id: 5,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################                  Questions                ################
###########################################################################

# User 1 Courses
_question_course1_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 1,
  url: nil,
  question_type: "QA",
  question_content: "What is a wombat?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course1_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 1,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of these is NOT a bowling term?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course2_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 2,
  url: nil,
  question_type: "QA",
  question_content: "What is the derivative of x^2?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course2_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 2,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following is the integral of 2x?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# User 2 Courses
_question_course3_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 3,
  url: nil,
  question_type: "QA",
  question_content: "What is a thesis statement?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course3_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 3,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following is a literary device?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course4_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 4,
  url: nil,
  question_type: "QA",
  question_content: "What is the function of the liver?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course4_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 4,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following is an organ in the human body?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# User 3 Courses
_question_course5_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 5,
  url: nil,
  question_type: "QA",
  question_content: "Who was the first president of the United States?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course5_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 5,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following was a major event in World War II?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course6_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 6,
  url: nil,
  question_type: "QA",
  question_content: "What is Newton’s First Law?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course6_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 6,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of these is a unit of force?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# User 4 Courses
_question_course7_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 7,
  url: nil,
  question_type: "QA",
  question_content: "What is the atomic number of hydrogen?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course7_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 7,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of these is a noble gas?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course8_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 8,
  url: nil,
  question_type: "QA",
  question_content: "What does a psychologist study?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course8_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 8,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following is a psychological disorder?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# User 5 Courses
_question_course9_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 9,
  url: nil,
  question_type: "QA",
  question_content: "What is supply and demand?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course9_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 9,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of these is a principle of microeconomics?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course10_qa = Repo.insert!(%QuestionTemplate{
  course_page_id: 10,
  url: nil,
  question_type: "QA",
  question_content: "What are the primary colors?",
  display_order: 1,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course10_mc = Repo.insert!(%QuestionTemplate{
  course_page_id: 10,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following is a famous painter?",
  display_order: 2,
  is_archived: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################               Question Options            ################
###########################################################################

# Options for question 2
_question_course2_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 2,
  option_content: "Spare",
  option_order: "A",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course2_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 2,
  option_content: "Strike",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course2_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 2,
  option_content: "Gutter Ball",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course2_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 2,
  option_content: "Slip",
  option_order: "D",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Options for question 4
_question_course4_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 4,
  option_content: "x^2",
  option_order: "A",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course4_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 4,
  option_content: "2x^2",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course4_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 4,
  option_content: "x^3",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course4_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 4,
  option_content: "x^2 + C",
  option_order: "D",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Options for question 6
_question_course6_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 6,
  option_content: "Simile",
  option_order: "A",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course6_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 6,
  option_content: "Metaphor",
  option_order: "B",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course6_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 6,
  option_content: "Adjective",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course6_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 6,
  option_content: "Alliteration",
  option_order: "D",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Options for question 8
_question_course8_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 8,
  option_content: "Liver",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course8_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 8,
  option_content: "Stomach",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course8_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 8,
  option_content: "Lung",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course8_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 8,
  option_content: "Brain",
  option_order: "D",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Options for question 10
_question_course10_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 10,
  option_content: "D-Day",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course10_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 10,
  option_content: "Cold War",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course10_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 10,
  option_content: "Cuban Missile Crisis",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course10_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 10,
  option_content: "World War I",
  option_order: "D",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Options for question 12
_question_course12_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 12,
  option_content: "Newton",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course12_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 12,
  option_content: "Pascal",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course12_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 12,
  option_content: "Joule",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course12_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 12,
  option_content: "Ampere",
  option_order: "D",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Options for question 14
_question_course14_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 14,
  option_content: "Argon",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course14_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 14,
  option_content: "Oxygen",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course14_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 14,
  option_content: "Hydrogen",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course14_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 14,
  option_content: "Nitrogen",
  option_order: "D",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Options for question 16
_question_course16_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 16,
  option_content: "Schizophrenia",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course16_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 16,
  option_content: "Dyslexia",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course16_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 16,
  option_content: "Asthma",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course16_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 16,
  option_content: "Diabetes",
  option_order: "D",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Options for question 18
_question_course18_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 18,
  option_content: "Supply and Demand",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course18_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 18,
  option_content: "Opportunity Cost",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course18_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 18,
  option_content: "Elasticity",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course18_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 18,
  option_content: "Free Market",
  option_order: "D",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Options for question 20
_question_course20_mc_options_a = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 20,
  option_content: "Pablo Picasso",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course20_mc_options_b = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 20,
  option_content: "Vincent van Gogh",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course20_mc_options_c = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 20,
  option_content: "Leonardo da Vinci",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_question_course20_mc_options_d = Repo.insert!(%QuestionOptionsTemplate{
  question_template_id: 20,
  option_content: "Claude Monet",
  option_order: "D",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################               User Profiles               ################
###########################################################################

# Mason Profiles
_user1_user_profile1 = Repo.insert!(%UserProfile{
  user_id: 1,
  course_page_id: 1,
  role: nil,
  display_name: "Mace",
  custom_registration_id: "mperry",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_user1_user_profile2 = Repo.insert!(%UserProfile{
  user_id: 1,
  course_page_id: 2,
  role: nil,
  display_name: "Professor Perry",
  custom_registration_id: "perry101",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Maddy Profiles
_user2_user_profile1 = Repo.insert!(%UserProfile{
  user_id: 2,
  course_page_id: 3,
  role: nil,
  display_name: "Maddy H.",
  custom_registration_id: "maddy_h2",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_user2_user_profile2 = Repo.insert!(%UserProfile{
  user_id: 2,
  course_page_id: 4,
  role: nil,
  display_name: "M. Hoyt",
  custom_registration_id: "maddy_math",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Joe Profiles
_user3_user_profile1 = Repo.insert!(%UserProfile{
  user_id: 3,
  course_page_id: 5,
  role: nil,
  display_name: "Joe the Historian",
  custom_registration_id: "hist_joe",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_user3_user_profile2 = Repo.insert!(%UserProfile{
  user_id: 3,
  course_page_id: 6,
  role: nil,
  display_name: "Newton’s Apprentice",
  custom_registration_id: "joeNewton",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Mark Profiles
_user4_user_profile1 = Repo.insert!(%UserProfile{
  user_id: 4,
  course_page_id: 7,
  role: nil,
  display_name: "Dr. Chem",
  custom_registration_id: "098765221",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_user4_user_profile2 = Repo.insert!(%UserProfile{
  user_id: 4,
  course_page_id: 8,
  role: nil,
  display_name: "Mr. Beep Beep",
  custom_registration_id: "mbusbriggs",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Henry Profiles
_user5_user_profile1 = Repo.insert!(%UserProfile{
  user_id: 5,
  course_page_id: 9,
  role: nil,
  display_name: "Enry Mateez",
  custom_registration_id: "henryLuvzEcon",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_user5_user_profile2 = Repo.insert!(%UserProfile{
  user_id: 5,
  course_page_id: 10,
  role: nil,
  display_name: "PicassoFan99",
  custom_registration_id: "hmat",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################                 Test Users                ################
###########################################################################

# Insert a User for Alice Johnson
_user_alice = Repo.insert!(%User{
  email: "alice.johnson@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Bob Smith
_user_bob = Repo.insert!(%User{
  email: "bob.smith@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Charlie Davis
_user_charlie = Repo.insert!(%User{
  email: "charlie.davis@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Danielle White
_user_danielle = Repo.insert!(%User{
  email: "danielle.white@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Ethan Brown
_user_ethan = Repo.insert!(%User{
  email: "ethan.brown@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Fiona Miller
_user_fiona = Repo.insert!(%User{
  email: "fiona.miller@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for George Wilson
_user_george = Repo.insert!(%User{
  email: "george.wilson@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Hannah Moore
_user_hannah = Repo.insert!(%User{
  email: "hannah.moore@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Isaac Taylor
_user_isaac = Repo.insert!(%User{
  email: "isaac.taylor@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Julia Anderson
_user_julia = Repo.insert!(%User{
  email: "julia.anderson@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Kevin Thomas
_user_kevin = Repo.insert!(%User{
  email: "kevin.thomas@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Laura Martinez
_user_laura = Repo.insert!(%User{
  email: "laura.martinez@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Michael Hernandez
_user_michael = Repo.insert!(%User{
  email: "michael.hernandez@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Natalie Robinson
_user_natalie = Repo.insert!(%User{
  email: "natalie.robinson@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Oliver Clark
_user_oliver = Repo.insert!(%User{
  email: "oliver.clark@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Patricia Lewis
_user_patricia = Repo.insert!(%User{
  email: "patricia.lewis@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Quentin Walker
_user_quentin = Repo.insert!(%User{
  email: "quentin.walker@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Rachel Hall
_user_rachel = Repo.insert!(%User{
  email: "rachel.hall@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Samuel Young
_user_samuel = Repo.insert!(%User{
  email: "samuel.young@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

# Insert a User for Tiffany Allen
_user_tiffany = Repo.insert!(%User{
  email: "tiffany.allen@email.com",
  hashed_password: "$pbkdf2-sha512$160000$1Bxu.eKhmx9oHWmIYoiDFw$tA1/Kwk8PsehMpRNFvnRZP9HZbm.jYcZ6bMiABCpDB35x4/ijXBW9O/0U3gvsKb949VocMwA8Nfv0ll5TtFL1g",
  confirmed_at: nil,
  inserted_at: now,
  updated_at: now,
  role: "student",
  is_admin: false
},
  on_conflict: :nothing
)

###########################################################################
################             Test User Profiles            ################
###########################################################################
# Insert UserProfile for user 6
_user6_user_profile = Repo.insert!(%UserProfile{
  user_id: 6,
  course_page_id: 2,
  role: nil,
  display_name: "BowlingChamp",
  custom_registration_id: "bc6",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 7
_user7_user_profile = Repo.insert!(%UserProfile{
  user_id: 7,
  course_page_id: 2,
  role: nil,
  display_name: "MathWhiz07",
  custom_registration_id: "mw07",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 8
_user8_user_profile = Repo.insert!(%UserProfile{
  user_id: 8,
  course_page_id: 2,
  role: nil,
  display_name: "LitLover88",
  custom_registration_id: "ll88",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 9
_user9_user_profile = Repo.insert!(%UserProfile{
  user_id: 9,
  course_page_id: 2,
  role: nil,
  display_name: "BioNerd42",
  custom_registration_id: "bn42",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 10
_user10_user_profile = Repo.insert!(%UserProfile{
  user_id: 10,
  course_page_id: 2,
  role: nil,
  display_name: "HistoryBuff99",
  custom_registration_id: "hb99",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 11
_user11_user_profile = Repo.insert!(%UserProfile{
  user_id: 11,
  course_page_id: 2,
  role: nil,
  display_name: "PhysicsGeek11",
  custom_registration_id: "pg11",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 12
_user12_user_profile = Repo.insert!(%UserProfile{
  user_id: 12,
  course_page_id: 2,
  role: nil,
  display_name: "GasMaster",
  custom_registration_id: "gm12",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 13
_user13_user_profile = Repo.insert!(%UserProfile{
  user_id: 13,
  course_page_id: 2,
  role: nil,
  display_name: "PsycheMajor",
  custom_registration_id: "pm13",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 14
_user14_user_profile = Repo.insert!(%UserProfile{
  user_id: 14,
  course_page_id: 2,
  role: nil,
  display_name: "EconGuru",
  custom_registration_id: "eg14",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 15
_user15_user_profile = Repo.insert!(%UserProfile{
  user_id: 15,
  course_page_id: 2,
  role: nil,
  display_name: "ArtisticSoul",
  custom_registration_id: "as15",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 16
_user16_user_profile = Repo.insert!(%UserProfile{
  user_id: 16,
  course_page_id: 2,
  role: nil,
  display_name: "TechWizard16",
  custom_registration_id: "tw16",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 17
_user17_user_profile = Repo.insert!(%UserProfile{
  user_id: 17,
  course_page_id: 2,
  role: nil,
  display_name: "SciFiFanatic",
  custom_registration_id: "sf17",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 18
_user18_user_profile = Repo.insert!(%UserProfile{
  user_id: 18,
  course_page_id: 2,
  role: nil,
  display_name: "CodeCracker",
  custom_registration_id: "cc18",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 19
_user19_user_profile = Repo.insert!(%UserProfile{
  user_id: 19,
  course_page_id: 2,
  role: nil,
  display_name: "ChessMaster",
  custom_registration_id: "cm19",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 20
_user20_user_profile = Repo.insert!(%UserProfile{
  user_id: 20,
  course_page_id: 2,
  role: nil,
  display_name: "MovieBuff20",
  custom_registration_id: "mb20",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 21
_user21_user_profile = Repo.insert!(%UserProfile{
  user_id: 21,
  course_page_id: 2,
  role: nil,
  display_name: "SportsAnalyst",
  custom_registration_id: "sa21",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 22
_user22_user_profile = Repo.insert!(%UserProfile{
  user_id: 22,
  course_page_id: 2,
  role: nil,
  display_name: "MusicGenius",
  custom_registration_id: "mg22",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 23
_user23_user_profile = Repo.insert!(%UserProfile{
  user_id: 23,
  course_page_id: 2,
  role: nil,
  display_name: "AstroExplorer",
  custom_registration_id: "ae23",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 24
_user24_user_profile = Repo.insert!(%UserProfile{
  user_id: 24,
  course_page_id: 2,
  role: nil,
  display_name: "Linguist24",
  custom_registration_id: "lg24",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert UserProfile for user 25
_user25_user_profile = Repo.insert!(%UserProfile{
  user_id: 25,
  course_page_id: 2,
  role: nil,
  display_name: "GamerPro",
  custom_registration_id: "gp25",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################               Question Queues             ################
###########################################################################

_queue1 = Repo.insert!(%Queue{
  course_page_id: 1,
  name: "Monday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_queue2 = Repo.insert!(%Queue{
  course_page_id: 3,
  name: "Monday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_queue3 = Repo.insert!(%Queue{
  course_page_id: 5,
  name: "Wednesday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_queue4 = Repo.insert!(%Queue{
  course_page_id: 7,
  name: "Thursday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_queue5 = Repo.insert!(%Queue{
  course_page_id: 9,
  name: "Friday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################            Question Occurances            ################
###########################################################################

# Create date var from string
{:ok, date_used} = Date.from_iso8601("2025-01-31")


_QuestionOccurance1 = Repo.insert!(%QuestionOccurance{
  question_template_id: 1,
  queue_id: 1,
  queue_display_order: 1,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance2 = Repo.insert!(%QuestionOccurance{
  question_template_id: 2,
  queue_id: 1,
  queue_display_order: 2,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance2a = Repo.insert!(%QuestionOccurance{
  question_template_id: 4,
  queue_id: 2,
  queue_display_order: 1,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance3 = Repo.insert!(%QuestionOccurance{
  question_template_id: 5,
  queue_id: 2,
  queue_display_order: 1,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance4 = Repo.insert!(%QuestionOccurance{
  question_template_id: 6,
  queue_id: 2,
  queue_display_order: 2,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance5 = Repo.insert!(%QuestionOccurance{
  question_template_id: 9,
  queue_id: 3,
  queue_display_order: 1,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance6 = Repo.insert!(%QuestionOccurance{
  question_template_id: 10,
  queue_id: 3,
  queue_display_order: 2,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance7 = Repo.insert!(%QuestionOccurance{
  question_template_id: 13,
  queue_id: 4,
  queue_display_order: 1,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance8 = Repo.insert!(%QuestionOccurance{
  question_template_id: 14,
  queue_id: 4,
  queue_display_order: 2,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance9 = Repo.insert!(%QuestionOccurance{
  question_template_id: 19,
  queue_id: 5,
  queue_display_order: 1,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionOccurance10 = Repo.insert!(%QuestionOccurance{
  question_template_id: 20,
  queue_id: 5,
  queue_display_order: 2,
  date_used: date_used,
  is_required: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################         Test User Option Responses        ################
###########################################################################
# Insert QuestionOptionsResponse for user 6
_user6_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 11,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 7
_user7_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 12,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

## RESPONSE 8 IS MISSING ON PURPOSE ##

# Insert QuestionOptionsResponse for user 9
_user9_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 14,
  question_occurance_id: 3,
  option_response: "B",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 10
_user10_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 15,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 11
_user11_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 16,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 12
_user12_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 17,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 13
_user13_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 18,
  question_occurance_id: 3,
  option_response: "C",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 14
_user14_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 19,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 15
_user15_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 20,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 16
_user16_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 21,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 17
_user17_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 22,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 18
_user18_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 23,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

## RESPONSE 19 IS MISSING ON PURPOSE ##

# Insert QuestionOptionsResponse for user 20
_user20_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 25,
  question_occurance_id: 3,
  option_response: "A",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 21
_user21_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 26,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 22
_user22_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 27,
  question_occurance_id: 3,
  option_response: "A",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 23
_user23_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 28,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 24
_user24_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 29,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 25
_user25_option_response = Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 30,
  question_occurance_id: 3,
  option_response: "D",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################               Question Sets               ################
###########################################################################

_QuestionSet1 = Repo.insert!(%QuestionSet{
  name: "Attendance Daily Questions",
  description: "History Questions",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionSet2 = Repo.insert!(%QuestionSet{
  name: "Weekly Reading Report",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionSet3 = Repo.insert!(%QuestionSet{
  name: "Pre-Reading Questions",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionSet4 = Repo.insert!(%QuestionSet{
  name: "Attendance Daily Questions",
  description: "Bowling Questions",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

_QuestionSet5 = Repo.insert!(%QuestionSet{
  name: "Daily Touchbase Questions",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)
