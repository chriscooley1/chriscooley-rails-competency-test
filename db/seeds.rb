password = "password123"

reader = User.find_or_initialize_by(email: "reader@example.com")
reader.update!(password: password, password_confirmation: password, role: :user)

editor = User.find_or_initialize_by(email: "editor@example.com")
editor.update!(password: password, password_confirmation: password, role: :editor)

admin = User.find_or_initialize_by(email: "admin@example.com")
admin.update!(password: password, password_confirmation: password, role: :admin)

Article.where.not(category: Article::CATEGORIES).delete_all
Article.where(title: "The Disc in the Trunk").delete_all

stories = [
  [ "The Layout Saved the Point", "Ultimate Frisbee", 2, editor,
    "The disc was already past the cone when the layout started. It stuck, the sideline yelled, and the next throw was a simple dump because nobody wanted to follow that with a turnover." ],
  [ "Zone in a Crosswind", "Ultimate Frisbee", 5, editor,
    "The cup kept drifting toward the downwind sideline, which is how a zone dies. They switched back to person after four points and spent the rest of the game laughing about the one throw that went to nobody." ],
  [ "Hat Tournament, One Field", "Ultimate Frisbee", 8, editor,
    "Seven teams, one good field, and a bracket drawn on the back of a signup sheet. The final started late because the semifinal went to universe point and nobody was willing to call it." ],
  [ "The Throw Was Perfect", "Ultimate Frisbee", 240, editor,
    "The pass sat right where the cutter wanted it. A defender went up over him, skied the catch, and their handler hucked the next one into the end zone for the score." ],
  [ "Miles Before the Group Chat Wakes Up", "Running", 6, editor,
    "The loop around the park was done before the first message landed. Easy pace, no watch glance on the hills, and the only goal was to be home while the street was still quiet." ],
  [ "The Hill Nobody Puts on Strava", "Running", 20, editor,
    "The hill is one block, and four repeats up it will empty your legs. Strava would show a tiny distance and a slow pace, so the hard part never looks like anything worth posting." ],
  [ "Finished the 10K Smiling", "Running", 30, editor,
    "The plan was to finish smiling, not to chase a time. Mile five hurt, the same pace kept going, and the finish line still came with a smile." ],
  [ "Switchbacks and a Late Start", "Hiking", 4, editor,
    "They left the trailhead an hour after they meant to and still made the ridge for the view. The walk down took longer than the climb, so they reached the car later than they had planned." ],
  [ "Wind at the Summit, Lunch Below It", "Hiking", 18, editor,
    "The top was too loud for a sandwich. They dropped back to the last trees, ate there, and they counted the summit anyway." ],
  [ "The Turnaround That Was the Right Call", "Hiking", 28, editor,
    "Clouds sat on the pass and the map said two more miles. The view they wanted was already at the creek, so the extra miles were unnecessary." ],
  [ "One More Run", "Video Games", 9, editor,
    "The run was supposed to be the last one before the controller went on the table. It was not. The next one was shorter, which is the lie that makes a night like that." ],
  [ "Co-op Ran Past Midnight", "Video Games", 26, editor,
    "The session started as one mission. It ended with a boss neither of them had read about, and a promise to stop that they both knew was for the next night." ],
  [ "The Save File From Two Years Ago", "Video Games", 48, editor,
    "The character was standing exactly where the last session ended. Inventory still wrong, quest still half done, and it felt like opening a notebook from another season." ]
]

stories.each do |title, category, hours_old, author, content|
  published_at = hours_old.hours.ago
  article = Article.find_or_initialize_by(title: title)
  article.update!(
    category: category,
    content: content,
    user: author,
    created_at: published_at,
    updated_at: published_at
  )
end
