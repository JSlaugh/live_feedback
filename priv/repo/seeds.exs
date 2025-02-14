# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Repo.insert!(%LiveFeedback.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LiveFeedback.Repo
alias LiveFeedback.Questions.{Question, QuestionOption, QuestionOptionsResponse, Queue, QueueOccurrence, QuestionSet, QuestionOccurrence, QuestionOptionsOccurrence}
alias LiveFeedback.Courses.CoursePage
alias LiveFeedback.Accounts.User
alias LiveFeedback.Accounts.UserProfile
# alias LiveFeedback.Participation.{ParticipationRequest, ParticipationSummary}

now = DateTime.utc_now() |> DateTime.truncate(:second)

###########################################################################
################                     Users                 ################
###########################################################################

# Insert a User for Mason
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%CoursePage{
  title: "SWELL 108",
  description: "Bowling for Beginners",
  slug: "swell108",
  user_id: 1,
  inserted_at: now,
  updated_at: now,
},
  on_conflict: :nothing
)

Repo.insert!(%CoursePage{
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
Repo.insert!(%CoursePage{
  title: "ENG 150",
  description: "English Composition",
  slug: "eng150",
  user_id: 2,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%CoursePage{
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
Repo.insert!(%CoursePage{
  title: "HIST 210",
  description: "World History",
  slug: "hist210",
  user_id: 3,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%CoursePage{
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
Repo.insert!(%CoursePage{
  title: "CHEM 105",
  description: "General Chemistry",
  slug: "chem105",
  user_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%CoursePage{
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
Repo.insert!(%CoursePage{
  title: "ECON 220",
  description: "Microeconomics",
  slug: "econ220",
  user_id: 5,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%CoursePage{
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
################               Question Sets               ################
###########################################################################

Repo.insert!(%QuestionSet{
  course_page_id: 1,
  user_id: 1,
  name: "Attendance Daily Questions",
  description: "History Questions",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionSet{
  course_page_id: 3,
  user_id: 2,
  name: "Weekly Reading Report",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionSet{
  course_page_id: 5,
  user_id: 3,
  name: "Pre-Reading Questions",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionSet{
  course_page_id: 7,
  user_id: 4,
  name: "Attendance Daily Questions",
  description: "Bowling Questions",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionSet{
  course_page_id: 9,
  user_id: 5,
  name: "Daily Touchbase Questions",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################                  Questions                ################
###########################################################################

# User 1 Courses
Repo.insert!(%Question{
  question_set_id: 1,
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

Repo.insert!(%Question{
  question_set_id: 1,
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

Repo.insert!(%Question{
  question_set_id: nil,
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

Repo.insert!(%Question{
  question_set_id: nil,
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
Repo.insert!(%Question{
  question_set_id: 2,
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

Repo.insert!(%Question{
  question_set_id: 2,
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

Repo.insert!(%Question{
  question_set_id: nil,
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

Repo.insert!(%Question{
  question_set_id: nil,
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
Repo.insert!(%Question{
  question_set_id: 3,
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

Repo.insert!(%Question{
  question_set_id: 3,
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

Repo.insert!(%Question{
  question_set_id: nil,
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

Repo.insert!(%Question{
  question_set_id: nil,
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
Repo.insert!(%Question{
  question_set_id: 4,
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

Repo.insert!(%Question{
  question_set_id: 4,
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

Repo.insert!(%Question{
  question_set_id: nil,
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

Repo.insert!(%Question{
  question_set_id: nil,
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
Repo.insert!(%Question{
  question_set_id: 5,
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

Repo.insert!(%Question{
  question_set_id: 5,
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

Repo.insert!(%Question{
  question_set_id: nil,
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

Repo.insert!(%Question{
  question_set_id: nil,
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
Repo.insert!(%QuestionOption{
  question_id: 2,
  option_content: "Spare",
  option_order: "A",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 2,
  option_content: "Strike",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 2,
  option_content: "Gutter Ball",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 2,
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
Repo.insert!(%QuestionOption{
  question_id: 4,
  option_content: "x^2",
  option_order: "A",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 4,
  option_content: "2x^2",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 4,
  option_content: "x^3",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 4,
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
Repo.insert!(%QuestionOption{
  question_id: 6,
  option_content: "Simile",
  option_order: "A",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 6,
  option_content: "Metaphor",
  option_order: "B",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 6,
  option_content: "Adjective",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 6,
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
Repo.insert!(%QuestionOption{
  question_id: 8,
  option_content: "Liver",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 8,
  option_content: "Stomach",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 8,
  option_content: "Lung",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 8,
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
Repo.insert!(%QuestionOption{
  question_id: 10,
  option_content: "D-Day",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 10,
  option_content: "Cold War",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 10,
  option_content: "Cuban Missile Crisis",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 10,
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
Repo.insert!(%QuestionOption{
  question_id: 12,
  option_content: "Newton",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 12,
  option_content: "Pascal",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 12,
  option_content: "Joule",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 12,
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
Repo.insert!(%QuestionOption{
  question_id: 14,
  option_content: "Argon",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 14,
  option_content: "Oxygen",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 14,
  option_content: "Hydrogen",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 14,
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
Repo.insert!(%QuestionOption{
  question_id: 16,
  option_content: "Schizophrenia",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 16,
  option_content: "Dyslexia",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 16,
  option_content: "Asthma",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 16,
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
Repo.insert!(%QuestionOption{
  question_id: 18,
  option_content: "Supply and Demand",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 18,
  option_content: "Opportunity Cost",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 18,
  option_content: "Elasticity",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 18,
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
Repo.insert!(%QuestionOption{
  question_id: 20,
  option_content: "Pablo Picasso",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 20,
  option_content: "Vincent van Gogh",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 20,
  option_content: "Leonardo da Vinci",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOption{
  question_id: 20,
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
Repo.insert!(%UserProfile{
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

Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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

Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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

Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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

Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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

Repo.insert!(%UserProfile{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%User{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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
Repo.insert!(%UserProfile{
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

Repo.insert!(%Queue{
  course_page_id: 1,
  name: "Monday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%Queue{
  course_page_id: 3,
  name: "Monday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%Queue{
  course_page_id: 5,
  name: "Wednesday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%Queue{
  course_page_id: 7,
  name: "Thursday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%Queue{
  course_page_id: 9,
  name: "Friday Schedule",
  description: "",
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################         Question Queue Occurrences        ################
###########################################################################

presented_date = Date.from_iso8601!("2025-02-01")
presented_date_2 = Date.from_iso8601!("2025-02-03")

Repo.insert!(%QueueOccurrence{
  queue_id: 1,
  presented_date: presented_date
},
  on_conflict: :nothing
)

Repo.insert!(%QueueOccurrence{
  queue_id: 1,
  presented_date: presented_date_2
},
  on_conflict: :nothing
)

Repo.insert!(%QueueOccurrence{
  queue_id: 2,
  presented_date: presented_date
},
  on_conflict: :nothing
)

Repo.insert!(%QueueOccurrence{
  queue_id: 2,
  presented_date: presented_date_2
},
  on_conflict: :nothing
)

Repo.insert!(%QueueOccurrence{
  queue_id: 3,
  presented_date: presented_date
},
  on_conflict: :nothing
)

Repo.insert!(%QueueOccurrence{
  queue_id: 3,
  presented_date: presented_date_2
},
  on_conflict: :nothing
)

Repo.insert!(%QueueOccurrence{
  queue_id: 4,
  presented_date: presented_date
},
  on_conflict: :nothing
)

Repo.insert!(%QueueOccurrence{
  queue_id: 4,
  presented_date: presented_date_2
},
  on_conflict: :nothing
)

Repo.insert!(%QueueOccurrence{
  queue_id: 5,
  presented_date: presented_date
},
  on_conflict: :nothing
)

Repo.insert!(%QueueOccurrence{
  queue_id: 5,
  presented_date: presented_date_2
},
  on_conflict: :nothing
)

###########################################################################
################            Question Occurrences            ################
###########################################################################

# Create date var from string
{:ok, date_used} = Date.from_iso8601("2025-01-31")


Repo.insert!(%QuestionOccurrence{
  question_id: 1,
  queue_id: 1,
  is_required: false,
  url: nil,
  question_type: "QA",
  question_content: "What is a wombat?",
  set_display_order: 1,
  is_archived: false,
  display_order: 1,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 2,
  queue_id: 1,
  is_required: false,
  url: nil,
  question_type: "multiple_choice",
  question_content: "What of these is NOT a bowling term?",
  set_display_order: 2,
  is_archived: false,
  display_order: 2,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 4,
  queue_id: 2,
  is_required: false,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following is the integral of 2x?",
  set_display_order: 2,
  is_archived: false,
  display_order: 1,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 5,
  queue_id: 2,
  is_required: false,
  url: nil,
  question_type: "QA",
  question_content: "What is a thesis statement?",
  set_display_order: 1,
  is_archived: false,
  display_order: 2,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 6,
  queue_id: 2,
  is_required: false,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following is a literary device?",
  set_display_order: 2,
  is_archived: false,
  display_order: 3,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 9,
  queue_id: 3,
  is_required: false,
  url: nil,
  question_type: "QA",
  question_content: "Who was the first president of the United States?",
  set_display_order: 1,
  is_archived: false,
  display_order: 1,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 10,
  queue_id: 3,
  is_required: false,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following was a major even in World War II?",
  set_display_order: 2,
  is_archived: false,
  display_order: 2,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 13,
  queue_id: 4,
  is_required: false,
  url: nil,
  question_type: "QA",
  question_content: "What is the atomic number of hydrogen?",
  set_display_order: 1,
  is_archived: false,
  display_order: 1,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 14,
  queue_id: 4,
  is_required: false,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of these is a noble gas?",
  set_display_order: 2,
  is_archived: false,
  display_order: 2,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 19,
  queue_id: 5,
  is_required: false,
  url: nil,
  question_type: "QA",
  question_content: "What are the primary colors?",
  set_display_order: 1,
  is_archived: false,
  display_order: 1,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOccurrence{
  question_id: 20,
  queue_id: 5,
  is_required: false,
  url: nil,
  question_type: "multiple_choice",
  question_content: "Which of the following is a famous painter?",
  set_display_order: 2,
  is_archived: false,
  display_order: 2,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################        Question Options Occurrences        ################
###########################################################################

# Options for question 2
Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 2,
  option_content: "Spare",
  option_order: "A",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 2,
  option_content: "Strike",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 2,
  option_content: "Gutter Ball",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 2,
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
Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 4,
  option_content: "x^2",
  option_order: "A",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 4,
  option_content: "2x^2",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 4,
  option_content: "x^3",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 4,
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
Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 6,
  option_content: "Simile",
  option_order: "A",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 6,
  option_content: "Metaphor",
  option_order: "B",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 6,
  option_content: "Adjective",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 6,
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
Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 8,
  option_content: "Liver",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 8,
  option_content: "Stomach",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 8,
  option_content: "Lung",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 8,
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
Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 10,
  option_content: "D-Day",
  option_order: "A",
  url: nil,
  is_correct: true,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 10,
  option_content: "Cold War",
  option_order: "B",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 10,
  option_content: "Cuban Missile Crisis",
  option_order: "C",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

Repo.insert!(%QuestionOptionsOccurrence{
  question_occurrence_id: 10,
  option_content: "World War I",
  option_order: "D",
  url: nil,
  is_correct: false,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

###########################################################################
################         Test User Option Responses        ################
###########################################################################
# Insert QuestionOptionsResponse for user 6
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 11,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 7
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 12,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

## RESPONSE 8 IS MISSING ON PURPOSE ##

# Insert QuestionOptionsResponse for user 9
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 14,
  question_options_occurrence_id: 2,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 10
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 15,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 11
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 16,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 12
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 17,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 13
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 18,
  question_options_occurrence_id: 3,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 14
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 19,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 15
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 20,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 16
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 21,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 17
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 22,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 18
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 23,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

## RESPONSE 19 IS MISSING ON PURPOSE ##

# Insert QuestionOptionsResponse for user 20
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 25,
  question_options_occurrence_id: 1,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 21
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 26,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 22
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 27,
  question_options_occurrence_id: 1,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 23
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 28,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 24
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 29,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)

# Insert QuestionOptionsResponse for user 25
Repo.insert!(%QuestionOptionsResponse{
  user_profile_id: 30,
  question_options_occurrence_id: 4,
  inserted_at: now,
  updated_at: now
},
  on_conflict: :nothing
)
