---
source: https://www.youtube.com/watch?v=X_Hw9P1iZfQ
title: Rails 8 The Demo 
---

## rails new

🚢 [8dfb67b](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/8dfb67b)
```bash
rails new blog
```

🚢 [2c638f7](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/2c638f7)
```bash
bundle exec rails generate scaffold post title:string body:text
```

🚢 [adb017b](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/adb017b)
```bash
bundle exec rails db:migrate 
```

`app/controllers/posts_controller.rb`
- 7 actions: index, show, new, edit, create, index, destroy
- 2 flavors: html, json

`app/models/post.rb`
- Uses _intrespection_ of `schema.rb`

`app/views/posts/` 
- has erb files for all rest actions

🚢 [909c482](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/909c482)
Start puma web server
```bash
bundle exec rails s -b 0.0.0.0 
```

- [posts](localhost:3000/posts) returns html
- [posts.json](localhost:3000/posts.json) returns json 

## simple.css

🚢 [67a4a63](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/67a4a63)
Add simple.css
```diff
diff --git a/blog/app/views/layouts/application.html.erb
+    <%= stylesheet_link_tag "https://cdn.simplecss.org/simple.css" %>
```

## debugging

🚢 [387ee99](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/387ee99)
Raising an exception provides the stacktrace and a _builtin console_
```diff
diff --git a/blog/app/controllers/posts_controller.rb
   def index
     @posts = Post.all
+    raise "some exception"
```
Can interact with the console e.g. `@posts`
- can also in the cli `rails console`

## action_storage

🚢 [1efd5c1](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/1efd5c1)
Provides a _wysiwyg_ and `action_storage` to support attachments and files
```bash
# Ubuntu: apt install libvips-dev
bundle exec rails action_text:install
```

🚢 [cf33fc3](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/cf33fc3)
Install required gems
```bash
,buinstall
```

🚢 [dd7eae8](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/dd7eae8)
Don't forget to db:migrate
```bash
bundle exec rails db:migrate 
```

🚢 [fb99a7e](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/fb99a7e)
Restart server
```bash
* bundle exec rails s -b 0.0.0.0 
```

🚢 [bd6a509](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/bd6a509)
Remove raised exception from earlier

🚢 [835f08b](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/835f08b)
Enable rich text for post.body
```diff
diff --git a/blog/app/models/post.rb
@@ -1,2 +1,3 @@
 class Post < ApplicationRecord
+  has_rich_text :body
 end

diff --git a/blog/app/views/posts/_form.html.erb
@@ -2,7 +2,6 @@
   <div>
     <%= form.label :body, style: "display: block" %>
-    <%= form.textarea :body %>
+    <%= form.rich_textarea :body %>
   </div>
```

## importmap

- `config/importmap.rb` includes npm dependencies 
- By default includes
  - [hotwired/turbo-rails](https://github.com/hotwired/turbo-rails) to write SPA-ish without JS
  - [Stimulus JS](https://stimulus.hotwired.dev/) 

🚢 [5a8bf51](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/5a8bf51)
Example to include an npm package
```bash
`bin/importmap pin local-time` 
```

```diff
diff --git a/blog/config/importmap.rb
+pin "local-time" # @3.0.2

diff --git a/blog/vendor/javascript/local-time.js
new file mode 100644
@@ -0,0 +1,4 @@
+// local-time@3.0.2 downloaded from https://ga.jspm.io/npm:local-time@3.0.2/app/assets/javascripts/local-time.es2017-esm.js
```

🚢 [350a719](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/350a719)
Example of using npm package. Even though time is stored UTC, we're using local-time package to display local time
```diff
diff --git a/blog/app/javascript/application.js
+import LocalTime from "local-time"
+LocalTime.start()

diff --git a/blog/app/views/posts/_post.html.erb
+  <p>
+    <strong>Updated at:</strong>
+    <%= time_tag post.updated_at, "data-local": "time", "data-format": "%B %e, %Y %l:%M%P" %>
+  </div>
```

In browser dev-tools, go to `network->js` to view the js files being pulled from npm

## Add comments as `resource`

🚢 [5e06c5f](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/5e06c5f)
```bash
bundle exec rails generate resource comment post:references content:text
```
- `resource` generator is more lightweight than `scaffold`
- generates model, migration, empty controller actions

🚢 [3ddffc3](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/3ddffc3)
```bash
bundle exec rails db:migrate
```
```
  == 20241123224036 CreateComments: migrating ===================================
  -- create_table(:comments)
     -> 0.0021s
  == 20241123224036 CreateComments: migrated (0.0022s) ==========================
```

🚢 [d92338f](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/d92338f)
Post comments and form to add a comment
```diff
diff --git a/blog/app/controllers/comments_controller.rb
@@ -1,2 +1,14 @@
 class CommentsController < ApplicationController
+  before_action :set_post # see prvate method below
+
+  def create
+    @post.comments.create! params.expect(comment: [ :content ])
+    redirect_to @post
+  end
+
+  private
+  # Comment is a child of Post, so we need to find the parent Post
+  def set_post
+    @post = Post.find(params[:post_id])
+  end
 end

diff --git a/blog/app/models/post.rb
@@ -1,3 +1,4 @@
 class Post < ApplicationRecord
   has_rich_text :body
+  has_many :comments
 end

diff --git a/blog/app/views/comments/_comment.html.erb
new file mode 100644
@@ -0,0 +1,5 @@
+<%# %>
+<div id="<%= dom_id(comment)%>" > <%# provide id so it can be referenced in dom %>
+  <%= comment.content %> -
+  <%= time_tag comment.updated_at, "data-local": "time-ago" %><%# using local-time we importmap'd earlier %>
+</div>
 No newline at end of file

diff --git a/blog/app/views/comments/_comments.html.erb
new file mode 100644
@@ -0,0 +1,7 @@
+<%# referenced in posts.show to show all comments to a post %>
+<h2>Comments</h2>
+<div id="comments">
+  <%= render post.comments %>
+</div>
+<%# form to add a new comment %>
+<%= render "comments/new", post: post %>
 No newline at end of file

diff --git a/blog/app/views/comments/_new.html.erb
new file mode 100644
@@ -0,0 +1,5 @@
+<%= form_with model: [ post, Comment.new ] do |form| %>
+  Your comment:<br>
+  <%= form.text_area :content, size: "20x5" %><br>
+  <%= form.submit %>
+<% end %>
 No newline at end of file

diff --git a/blog/app/views/posts/show.html.erb
@@ -1,10 +1,8 @@
 <p style="color: green"><%= notice %></p>
-
 <%= render @post %>
-
 <div>
   <%= link_to "Edit this post", edit_post_path(@post) %> |
   <%= link_to "Back to posts", posts_path %>
-
   <%= button_to "Destroy this post", @post, method: :delete %>
 </div>
+<%= render "comments/comments", post: @post %>

diff --git a/blog/config/routes.rb
@@ -1,6 +1,7 @@
 Rails.application.routes.draw do
-  resources :comments
-  resources :posts
+  resources :posts do
+    resources :comments # Nested resource
+  end
   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
 
   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
```

## Websockets w/ action_cable

🚢 [7083e67](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/7083e67)
`turbo_stream_from @post` to live update comments
```diff
diff --git a/blog/app/models/comment.rb
@@ -1,3 +1,4 @@
 class Comment < ApplicationRecord
   belongs_to :post
+  broadcasts_to :post
 end

diff --git a/blog/app/views/posts/show.html.erb
@@ -1,3 +1,4 @@
+<%= turbo_stream_from @post %>
 <p style="color: green"><%= notice %></p>
 <%= render @post %>
 <div>
```

## Production

Rails uses `kamal` 
- see `deploy.yml` for configuration
- secrets can be pulled from 1password, GITHUB_TOKEN or env in `kamal.secrets`
- kamal uses docker volume for active_storage, but we can use others e.g. s3

Basic flow is...
- `git commit`
- `kamal deploy`

🚢 [cb4b4d4](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/cb4b4d4)
set root route
```diff
diff --git a/blog/config/routes.rb
@@ -13,5 +13,5 @@ Rails.application.routes.draw do
   # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
 
   # Defines the root path route ("/")
-  # root "posts#index"
+  root "posts#index"
 end
```

## Authentication

rails auth gives you tracking sessions, pwd resets, but _not signup flow_

🚢 [c3e23fd](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/c3e23fd)

```bash
bundle exec rails generate authentication
```
```
        invoke  erb
        create    app/views/passwords/new.html.erb
        create    app/views/passwords/edit.html.erb
        create    app/views/sessions/new.html.erb
        create  app/models/session.rb
        create  app/models/user.rb
        create  app/models/current.rb
        create  app/controllers/sessions_controller.rb
        create  app/controllers/concerns/authentication.rb
        create  app/controllers/passwords_controller.rb
        create  app/channels/application_cable/connection.rb
        create  app/mailers/passwords_mailer.rb
        create  app/views/passwords_mailer/reset.html.erb
        create  app/views/passwords_mailer/reset.text.erb
        create  test/mailers/previews/passwords_mailer_preview.rb
        insert  app/controllers/application_controller.rb
         route  resources :passwords, param: :token
         route  resource :session
          gsub  Gemfile
        bundle  install --quiet
  WARN: Unresolved or ambiguous specs during Gem::Specification.reset:
        stringio (>= 0)
        Available/installed versions of this gem:
        - 3.1.2
        - 3.1.1
  WARN: Clearing out unresolved specs. Try 'gem cleanup <gem>'
  Please report a bug if this causes problems.
      generate  migration CreateUsers email_address:string!:uniq password_digest:string! --force
         rails  generate migration CreateUsers email_address:string!:uniq password_digest:string! --force 
        invoke  active_record
        create    db/migrate/20241126170314_create_users.rb
      generate  migration CreateSessions user:references ip_address:string user_agent:string --force
         rails  generate migration CreateSessions user:references ip_address:string user_agent:string --force 
        invoke  active_record
        create    db/migrate/20241126170315_create_sessions.rb
        invoke  test_unit
        create    test/fixtures/users.yml
        create    test/models/user_test.rb
```

🚢 [14c7204](https://github.com/arafatm/learn.rails.8.demo.blog.dhh/commit/14c7204)
```bash
bundle exec rails db:migrate
```
```
  == 20241126170314 CreateUsers: migrating ======================================
  -- create_table(:users)
     -> 0.0028s
  -- add_index(:users, :email_address, {:unique=>true})
     -> 0.0009s
  == 20241126170314 CreateUsers: migrated (0.0037s) =============================
  
  == 20241126170315 CreateSessions: migrating ===================================
  -- create_table(:sessions)
     -> 0.0028s
  == 20241126170315 CreateSessions: migrated (0.0029s) ==========================
```

xxx