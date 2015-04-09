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

  private
    def chapter_params
      params.require(:chapter).permit(:title, :content, :book_id, :id)
    end
end
