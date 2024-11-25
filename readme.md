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

## Add comments

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

xxx