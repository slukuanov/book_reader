class Admin::ChaptersController < Admin::AdminController

  def get_chapter
    @chapter = Chapter.find_by_id(params[:id])

    render :json => { :title => @chapter.title,
                      :content => @chapter.content
    }
  end

  def save_chapter
    @chapter = Chapter.find(chapter_params[:id])
    if @chapter.update(chapter_params)
      render :json => { :title => @chapter.title,
                        :content => @chapter.content
      }
    else
      render :json => { status: 403 }
    end
  end

  def generate_new_chapter
    @chapter = Chapter.create(chapter_params)

    redirect_to edit_admin_book_path(@chapter.book, to_bottom: true), success: 'Update success'
  end

  def destroy_chapter
    @chapter = Chapter.find_by_id(params[:chapter][:id])
    chapter_title = @chapter.title
    @book = @chapter.book
    if @chapter.destroy
      render :json => { chapter_title: chapter_title,
                        last_chapter_id: @book.chapters.last.id
      }
    else
      render :json => { status: 403 }
    end
  end

  private
    def chapter_params
      params.require(:chapter).permit(:title, :content, :book_id, :id)
    end

    def new_chapter_params
      params.require(:chapter_new).permit(:title, :content, :book_id)
    end
end
