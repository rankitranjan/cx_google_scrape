class KeywordsController < ApplicationController
  before_action :set_keyword, only: [:show, :destroy, :refresh]
  before_action :authenticate_user!

  def index
    @keywords = current_user.keywords.includes(:search_result).order(created_at: :desc).page(params[:page] || 1).per(12)
  end

  def new
    @keyword = Keyword.new
  end

  def create
    file = keyword_params[:file]
    csv_content = file.read
    keywords = CsvParser.parse(csv_content)
    processed_keywords = KeywordProcessor.process(keywords)

    processed_keywords.each do |keyword|
      current_user.keywords.find_or_create_by(name: keyword)
    end

    redirect_to keywords_url, notice: 'Keywords processed successfully.'
  rescue => e
    @keyword = Keyword.new
    @keyword.errors.add(:base, e)
    render :new
  end

  def show
  end

  def destroy
    @keyword.destroy
    respond_to do |format|
      format.html { redirect_to keywords_url, notice: 'Keyword was successfully destroyed.' }
    end
  end

  def sample_csv
    sample_data = "Keywords\nCool Jackets online\nCool shoes\nIphone online"
    send_data sample_data, filename: "sample_keywords.csv", type: "text/csv"
  end

  def refresh
    @keyword.refresh
    respond_to do |format|
      format.html { redirect_to keywords_url, notice: 'Successfully triggerd for refresh.' }
    end
  end

  private

  def set_keyword
    @keyword = Keyword.find(params[:id] || params[:keyword_id])
  end

  def keyword_params
    params.require(:keyword).permit(:file)
  end
end
