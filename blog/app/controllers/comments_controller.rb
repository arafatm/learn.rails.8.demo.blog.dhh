class CommentsController < ApplicationController
  before_action :set_post # see prvate method below

  def create
    @post.comments.create! params.expect(comment: [ :content ])
    redirect_to @post
  end

  private
  # Comment is a child of Post, so we need to find the parent Post
  def set_post
    @post = Post.find(params[:post_id])
  end
end
