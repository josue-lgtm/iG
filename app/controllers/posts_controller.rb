class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]  # Asegurar que el usuario sea dueño

    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)
    
        if @post.save
          redirect_to @post, notice: 'Publicación creada exitosamente.'
        else
          render :new
        end
    end

    def show
        @posts = Post.all
    end

    def edit
        # El post ya está cargado por el before_action
    end 

    def update
        if @post.update(post_params)
            redirect_to @post, notice: 'Publicación actualizada exitosamente.'
        else
            render :edit
        end
    end

    def destroy
        @post.destroy
        redirect_to posts_path, notice: 'Publicación eliminada exitosamente.'
    end

    private

    def set_post
        @post = Post.find(params[:id])
    end

    def authorize_user!
        # Verifica que el usuario autenticado sea el propietario del post
        if @post.user != current_user
            redirect_to posts_path, alert: 'No tienes permiso para realizar esta acción.'
        end
    end

    def post_params
        params.require(:post).permit(:description, images: [])
    end
end
