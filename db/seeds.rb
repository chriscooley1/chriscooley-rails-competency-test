password = "password123"

reader = User.find_or_initialize_by(email: "reader@example.com")
reader.update!(password: password, password_confirmation: password, role: :user)

editor = User.find_or_initialize_by(email: "editor@example.com")
editor.update!(password: password, password_confirmation: password, role: :editor)

admin = User.find_or_initialize_by(email: "admin@example.com")
admin.update!(password: password, password_confirmation: password, role: :admin)

stories = [
  [ "The Layout Saved the Point", "Ultimate Frisbee",
    "The disc was already past the cone when the layout started. It stuck, and the next throw was a simple dump." ],
  [ "Miles Before the Group Chat Wakes Up", "Running",
    "The loop around the park was done before the first message landed. The only goal was to be home while the street was still quiet." ],
  [ "Switchbacks and a Late Start", "Hiking",
    "They left the trailhead an hour after they meant to and still made the ridge for the view." ],
  [ "One More Run", "Video Games",
    "The run was supposed to be the last one before the controller went on the table. It was not." ]
]

stories.each do |title, category, content|
  article = Article.find_or_initialize_by(title: title)
  article.update!(category: category, content: content, user: editor)
end
